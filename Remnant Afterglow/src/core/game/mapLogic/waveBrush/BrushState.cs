

namespace Remnant_Afterglow
{
    /// <summary>
    /// 刷怪状态
    /// </summary>
    public enum BrushState
    {
        /// <summary>
        /// 准备阶段
        /// </summary>
        Prepare,    
        /// <summary>
        /// 开始刷怪
        /// </summary>
        BrushWave, 
        /// <summary>
        /// 刷怪结束后间隔，如果是最后一波的刷怪，刷完就修改为EndBrush（结束刷怪）
        /// </summary>
        Brushing,  
        /// <summary>
        /// 结束刷怪，关卡结束也要判断这个参数为结束
        /// </summary>
        EndBrush,  
    }
}
