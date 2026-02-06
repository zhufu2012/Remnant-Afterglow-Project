using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 装饰-作为地图的装饰物存在，可以选择特殊功能，比如可点击显示文字等
    /// </summary>
    struct Decorate
    {
        /// <summary>
        /// 装饰id
        /// </summary>
        public int id;
        /// <summary>
        /// 位置
        /// </summary>
        public Vector2 pos;
    }

    /// <summary>
    /// 装饰管理器
    /// </summary>
    public partial class DecorateManager : Node
    {

    }
}