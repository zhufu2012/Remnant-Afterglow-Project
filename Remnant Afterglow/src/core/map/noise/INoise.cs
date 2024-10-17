using Godot;

namespace Remnant_Afterglow
{
    //噪声生成器接口,可以通过实现这个接口，来优化地形生成
    public interface INoise
    {
        /// <summary>
        /// 噪声
        /// </summary>
        FastNoiseLite noise { get; set; }

        /// <summary>
        /// 对应位置的噪声数据
        /// </summary>		
        float getNoiseValue(int x, int y);
    }
}