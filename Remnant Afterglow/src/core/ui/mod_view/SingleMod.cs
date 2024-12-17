using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单个mod项
    /// </summary>
    public partial class SingleMod : Button
    {
        public ModAllInfo modallInfo;

        /// <summary>
        /// 是否被选中
        /// </summary>
        public bool IsSelect = false;
        /// <summary>
        /// mod状态
        /// </summary>
        public ModState modState;

        public double CurrentTime = 0;

        public void InitData(ModAllInfo modallInfo, bool IsSelect)
        {
            this.modallInfo = modallInfo;
            this.IsSelect = IsSelect;
            CustomMinimumSize = new Vector2(0, 30);
        }

        public override void _Ready()
        {
            Text = modallInfo.modInfo.Name;
        }


        public override void _Input(InputEvent @event)
        {
            if (@event is InputEventMouseButton mouseButton)
            {
                Vector2 pos = mouseButton.GlobalPosition;
                //按键为左键 并且是双击
                if (mouseButton.ButtonIndex == MouseButton.Left && mouseButton.DoubleClick == true)
                {
                    if (GetGlobalRect().HasPoint(pos))
                    {
                        IsSelect = !IsSelect;
                    }
                }
            }
        }




    }

}