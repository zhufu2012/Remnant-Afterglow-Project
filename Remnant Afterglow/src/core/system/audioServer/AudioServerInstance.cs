using Godot;
using System;
using System.Collections.Frozen;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

// 标记为全局类，这样它就可以在任何地方被引用
[GlobalClass, Tool]
public partial class AudioServerInstance : Node
{
    // 一个不可变字典，用于存储已加载的声音
    private FrozenDictionary<Sounds, Sound> sounds;

    // 默认构造函数，全局类需要提供一个无参数的构造函数
    public AudioServerInstance() { }

    // 带参数的构造函数，允许初始化时传入一组要加载的声音
    public AudioServerInstance(IEnumerable<Sounds> sounds)
    {
        // 使用范围操作符将输入的声音集合转换为数组并赋值给soundsToLoad
        soundsToLoad = [.. sounds];
    }

    // 当节点准备好时调用的方法
    public override void _Ready()
    {
        // 将当前实例添加到名为"audio_server"的组中
        AddToGroup("audio_server");
        // 将声音播放器作为子节点添加
        AddPlayersAsChildren();
    }

    /// <summary>
    /// 停止所有声音的播放
    /// </summary>
    public void StopAllSounds()
    {
        // 遍历所有已加载的声音，并停止它们
        foreach (var sound in sounds.Values)
            sound.Stop();
    }

    /// <summary>
    /// 切换指定声音的播放状态（播放/停止）
    /// </summary>
    /// <param name="soundToToggle">要切换的声音</param>
    public void Toggle(Sounds soundToToggle)
    {
        if (!sounds.TryGetValue(soundToToggle, out Sound value))
        {
            // 如果声音未加载或不存在，则打印调试信息
            Debug.Print("Tried toggling, but sound '" + soundToToggle.ToString() + "' was not loaded or does not exist");
            return;
        }
        // 调用声音对象的Toggle方法来切换播放状态
        value.Toggle();
    }

    /// <summary>
    /// 切换指定声音的循环播放状态
    /// </summary>
    /// <param name="soundToToggleLooping">要切换循环状态的声音</param>
    public void ToggleLooping(Sounds soundToToggleLooping)
    {
        if (!sounds.TryGetValue(soundToToggleLooping, out Sound value))
        {
            // 如果声音未加载或不存在，则打印调试信息
            Debug.Print("Tried toggling, but sound '" + soundToToggleLooping.ToString() + "' was not loaded or does not exist");
            return;
        }
        // 调用声音对象的ToggleLooping方法来切换循环播放状态
        value.ToggleLooping();
    }

    /// <summary>
    /// 停止指定声音的播放
    /// </summary>
    /// <param name="soundToStop">要停止的声音</param>
    public void Stop(Sounds soundToStop)
    {
        if (!sounds.TryGetValue(soundToStop, out Sound value))
        {
            // 如果声音未加载或不存在，则打印调试信息
            Debug.Print("Tried stopping, but sound '" + soundToStop.ToString() + "' was not loaded or does not exist");
            return;
        }
        // 调用声音对象的Stop方法来停止播放
        value.Stop();
    }

    /// <summary>
    /// 通过名称获取声音枚举值，忽略大小写
    /// </summary>
    /// <param name="name">声音的名称</param>
    /// <returns>与名称对应的声音枚举值，如果找不到则返回-1（转换为Sounds类型）</returns>
    #pragma warning disable CA1822 // 禁用“将成员标记为静态”的警告
    public Sounds GetSoundByName(string name)
    #pragma warning restore CA1822
    {
        Sounds sound = (Sounds)(-1);
        try
        {
            // 使用Enum.Parse尝试从名称解析出声音枚举值，忽略大小写
            sound = (Sounds)Enum.Parse(typeof(Sounds), name, true);
        }
        catch
        {
            // 如果解析失败或找不到该声音，则打印调试信息
            Debug.Print("Tried getting sound '" + name + "', but no such sound could be found or Enum.Parse failed");
        }
        return sound;
    }

    /// <summary>
    /// 播放指定的声音
    /// </summary>
    /// <param name="soundToPlay">要播放的声音</param>
    /// <param name="fromPosition">可选参数，指定从哪个位置开始播放（以秒为单位）</param>
    public void Play(Sounds soundToPlay, float fromPosition = 0)
    {
        if (!sounds.TryGetValue(soundToPlay, out Sound value))
        {
            // 如果声音未加载或不存在，则打印调试信息
            Debug.Print("Tried playing, but sound '" + soundToPlay.ToString() + "' was not loaded or does not exist");
            return;
        }
        // 调用声音对象的Play方法来播放声音
        value.Play(fromPosition);
    }

    // 私有方法，用于将声音播放器作为子节点添加
    private void AddPlayersAsChildren()
    {
        // 获取去重后的声音列表，并排除_PickSound_这个占位符
        sounds = AudioServer.GetSoundList(soundsToLoad
                    .Distinct() // 移除重复项
                    .Where((s) => s != Sounds._PickSound_)); // 排除_PickSound_

        // 遍历所有声音，并将它们的播放器添加为当前节点的子节点
        foreach (var sound in sounds.Values)
                AddChild(sound.player);
    }

    /// <summary>
    /// 设置所有已加载声音的主音量
    /// </summary>
    /// <param name="volume">新的音量值</param>
    public void SetLinearVolumeMaster(float volume)
    {
        // 遍历所有已加载的声音，并设置它们的主音量
        foreach(var sound in sounds.Values)
            sound.SetMasterLinearVolume(volume);
        // 调用AudioServer的SetLinearVolumeMaster方法来设置主音量
        AudioServer.SetLinearVolumeMaster(volume);
    }

    /// <summary>
    /// 设置特定声音的个体音量
    /// </summary>
    /// <param name="volume">新的音量值</param>
    /// <param name="sound">要设置音量的声音</param>
    public void SetLinearVolume(float volume, Sounds sound)
    {
        if (!sounds.TryGetValue(sound, out Sound value))
        {
            // 如果声音未加载或不存在，则打印调试信息
            Debug.Print("Sound '" + sound.ToString() + "' was not loaded or does not exist, so its volume can't be set");
            return;
        }
        // 调用声音对象的SetSelfLinearVolume方法来设置个体音量
        value.SetSelfLinearVolume(volume);
        // 调用AudioServer的SetLinearVolume方法来设置音量
        AudioServer.SetLinearVolume(volume, sound);
    }

    /// <summary>
    /// 设置特定类别下所有声音的音量
    /// </summary>
    /// <param name="volume">新的音量值</param>
    /// <param name="tag">声音的类别标签</param>
    public void SetLinearVolumeTagged(float volume, SoundTags tag)
    {
        // 遍历所有已加载的声音，如果声音属于指定类别，则设置其类别音量
        foreach(var sound in sounds.Values)
            if(sound.Is(tag))
                sound.SetTagLinearVolume(volume);
        // 调用AudioServer的SetLinearVolumeTagged方法来设置类别音量
        AudioServer.SetLinearVolumeTagged(volume, tag);
    }
}