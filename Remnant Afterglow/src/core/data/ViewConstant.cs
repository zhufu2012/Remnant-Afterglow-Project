
using Godot;

namespace Remnant_Afterglow
{
    //页面显示相关配置
    public static class ViewConstant
    {

        #region 相机界面参数
        /// <summary>
        /// 相机界面中，常规按钮的大小
        /// </summary>
        public static Vector2 Camera_Button_Size = new Vector2(300, 75);
        #endregion


        #region ZIndex层
        /// <summary>
        /// 建筑图层 ZIndex
        /// </summary>
        public const int Build_ZIndex = 9;
        /// <summary>
        /// 炮台图层 ZIndex
        /// </summary>
        public const int Tower_ZIndex = 9;
        /// <summary>
        /// 无人机图层 ZIndex
        /// </summary>
        public const int Worker_ZIndex = 9;
        /// <summary>
        /// 单位图层 ZIndex
        /// </summary>
        public const int Unit_ZIndex = 9;

        /// <summary>
        /// 子弹图层 ZIndex
        /// </summary>
        public const int Bullet_ZIndex = 200;

        /// <summary>
        /// 武器图层 ZIndex
        /// </summary>
        public const int Weapon_ZIndex = 200;

        /// <summary>
        /// 流场显示组件 ZIndex
        /// </summary>
        public const int FlowShow_ZIndex = 100;

        /// <summary>
        /// 刷怪系统的 刷新点标记线 ZIndex
        /// </summary>
        public const int BrushSystem_Line_ZIndex = 50;

        /// <summary>
        /// 艺术数字 显示组件 ZIndex
        /// </summary>
        public const int ImageNum_ZIndex = 1000;
        #endregion


    }
}
