using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 建造项按钮，点击打开或关闭建造子项列表
    /// </summary>
    public partial class BuildLableButton : Button
    {
        public MapBuildLable data;
        /// <summary>
        /// 是否选中该项,选中需要发光
        /// </summary>
        public bool IsSelect = false;


        public void InitData(MapBuildLable data)
        {
            this.data = data;
            FocusEntered += OnFocusEntered;

        }

        /// <summary>
        /// 检查建造子项是否显示
        /// </summary>
        /// <returns></returns>
        public bool CheckBuildItemShow()
        {
            return true;
        }

        /// <summary>
        /// 获取焦点时，显示另一个建造界面
        /// </summary>
        public void OnFocusEntered()
        {
            IsSelect = true;
        }

    }
}
