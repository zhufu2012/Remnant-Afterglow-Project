

using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 数据库界面
    /// </summary>
    public partial class DatabaseView : ViewObject
    {
        public DatabaseView(int cfgId) : base(cfgId)
        {
        }

        public override void _Ready()
        {
            AddChild(panel);
        }


    }
}
