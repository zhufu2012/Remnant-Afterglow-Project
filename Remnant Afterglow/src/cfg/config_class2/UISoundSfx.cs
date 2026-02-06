using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 UISoundSfx 用于 音效配置,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class UISoundSfx
    {
        public AudioStream audio_stream;

        /// <summary>
        /// 创建配置时，初始化数据-构造函数中运行
        /// </summary>
        public void InitData()
        {
        }

        /// <summary>
        /// 创建缓存时，初始化数据-构造函数后运行
        /// </summary>        
        public void InitData2()
        {
            if (SoundPath != "")
                audio_stream = ResourceLoader.Load<AudioStream>(PathConstant.GetPathUser(PathConstant.SOUND_PATH_USER)+SoundPath);
        }
    }
}
