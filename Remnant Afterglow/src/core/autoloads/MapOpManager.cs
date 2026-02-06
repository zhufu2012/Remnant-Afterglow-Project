using Godot;
using Godot.Collections;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 操作界面-类型
    /// </summary>
    public enum OpViewType
    {
        /// <summary>
        /// 无操作界面
        /// </summary>
        None = 0,
        /// <summary>
        /// 大地图操作界面
        /// </summary>
        BigMap_OpView = 1,
        /// <summary>
        /// 作战地图操作界面
        /// </summary>
        Map_OpView = 2,
    }




    /// <summary>
    /// 关卡内玩家操作管理器
    /// </summary>
    public partial class MapOpManager : CanvasLayer
    {
        #region 界面初始化
        public OpViewType opViewType = OpViewType.None;
        /// <summary>
        /// 单例
        /// </summary>
        public static MapOpManager Instance;
        /// <summary>
        /// 操作界面
        /// </summary>
        public Control opView;

        public PackedScene bigMapScene = GD.Load<PackedScene>("res://src/core/controllers/operation/bigmapop/BigMapOpView.tscn");
        public PackedScene mapScene = GD.Load<PackedScene>("res://src/core/controllers/operation/mapop/MapOpView.tscn");

        public MapOpManager()
        {
            Instance = this;
            opViewType = OpViewType.None;//默认为无操作界面
        }
        /// <summary>
        /// 设置界面
        /// </summary>
        /// <param name="opViewType"></param>
        public void SetOpView(OpViewType opViewType)
        {
            this.opViewType = opViewType;
            InitView();
        }

        public override void _Ready()
        {
            InitView();
        }
        /// <summary>
        /// 初始化界面
        /// </summary>
        public void InitView()
        {
            Array<Node> array = GetChildren();
            foreach (Node node in array)
            {
                node.QueueFree();
            }
            switch (opViewType)
            {
                case OpViewType.None://无操作界面
                    break;
                case OpViewType.BigMap_OpView://大地图
                    opView = (BigMapOpView)bigMapScene.Instantiate();
                    AddChild(opView);
                    break;
                case OpViewType.Map_OpView:
                    opView = (MapOpView)mapScene.Instantiate();
                    AddChild(opView);
                    break;
                default:
                    break;
            }
        }

        /// <summary>
        /// 操作界面
        /// </summary>
        public void SetOp()
        {
            switch (opViewType)
            {
                case OpViewType.None://无操作界面
                    break;
                case OpViewType.BigMap_OpView://大地图
                    BigMapOpView view = (BigMapOpView)opView;
                    view.StartActive();
                    break;
                case OpViewType.Map_OpView:
                    MapOpView view2 = (MapOpView)opView;
                    break;
                default:
                    break;

            }

        }

        #endregion


    }
}
