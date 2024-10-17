using Godot;

// 定义一个Sound类来处理音频播放
public class Sound
{
    // 是否循环播放
    private bool looping = false;

    // 音频播放器
    public AudioStreamPlayer player;

    // 声音标签，用于分类声音
    public readonly SoundTags tag;

    // 主音量线性值，默认1.0f表示无变化
    public float MasterLinearVolume { get; private set; } = 1.0f;
    // 自身音量线性值，默认1.0f表示无变化
    public float SelfLinearVolume   { get; private set; } = 1.0f;
    // 标签音量线性值，默认1.0f表示无变化
    public float TagLinearVolume    { get; private set; } = 1.0f;
    // 最终计算出的线性音量
    public float LinearVolume       { get; private set; } = 1.0f;

    // 检查当前声音是否属于指定的标签
    public bool Is(SoundTags tag) => this.tag == tag;

    // 构造函数，初始化播放器和标签
    public Sound(Resource stream, int polyphony, SoundTags tag)
    {
        // 创建一个新的AudioStreamPlayer实例并设置流和最大复音数
        player = new AudioStreamPlayer()
        {
            Stream = (AudioStream)stream,
            MaxPolyphony = polyphony,
        };

        // 设置声音标签
        this.tag = tag;
    }

    // 切换循环播放状态
    public void ToggleLooping()
    {
        // 反转looping的状态
        looping = !looping;
        if (looping)
        {
            // 如果开启循环，则在播放结束时重新开始播放
            player.Finished += () => player.Play();
        }
        else
        {
            // 如果关闭循环，则移除播放结束时重新开始播放的事件
            player.Finished -= () => player.Play();
        }
    }

    // 切换播放/停止状态
    public void Toggle()
    {
        if (player.Playing)
        {
            // 如果正在播放，则停止
            player.Stop();
        }
        else
        {
            // 如果已停止，则开始播放
            player.Play();
        }
    }

    // 从指定位置开始播放
    public void Play(float fromPosition)
    {
        player.Play(fromPosition);
    }

    // 停止播放
    public void Stop()
    {
        player.Stop();
    }

    // 重新计算最终的音量，并更新播放器的音量
    private void RecomputeVolume()
    {
        // 计算最终音量为自身、标签和主音量的乘积
        LinearVolume = SelfLinearVolume * TagLinearVolume * MasterLinearVolume;
        // 将线性音量转换为分贝单位，并设置给播放器
        player.VolumeDb = Mathf.LinearToDb(LinearVolume);
    }

    // 设置主音量的线性值，并重新计算最终音量
    public void SetMasterLinearVolume(float newMasterLinearVolume)
    {
        MasterLinearVolume = newMasterLinearVolume;
        RecomputeVolume();
    }

    // 设置自身音量的线性值，并重新计算最终音量
    public void SetSelfLinearVolume(float newSelfLinearVolume)
    {
        SelfLinearVolume = newSelfLinearVolume;
        RecomputeVolume();
    }

    // 设置标签音量的线性值，并重新计算最终音量
    public void SetTagLinearVolume(float newTagLinearVolume)
    {
        TagLinearVolume = newTagLinearVolume;
        RecomputeVolume();
    }
}