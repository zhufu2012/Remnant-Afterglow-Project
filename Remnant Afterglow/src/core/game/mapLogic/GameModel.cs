using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图游戏模式-各类模式都继承于此
    /// </summary>
    public partial class GameModel 
    {

        public Node2D ShowNode;
        public GameModel(Node2D ShowNode) { 
            this.ShowNode = ShowNode;
        }

        /// <summary>
        /// 模式的每帧刷新逻辑
        /// </summary>
        public virtual void PostUpdate(double delta)
        {
        }

        /// <summary>
        /// 开始模式的逻辑
        /// </summary>
        public virtual void StartModel()
        {
            InitData();//初始化数据
        }

        /// <summary>
        /// 结束模式的逻辑
        /// </summary>
        public virtual void EndModel()
        {
        }

        /// <summary>
        /// 初始化数据
        /// </summary>
        public virtual void InitData()
        {
        }
    }
}