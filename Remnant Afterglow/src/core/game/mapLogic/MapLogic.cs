using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 游戏阶段类-用于管理游戏阶段
    /// -所有新游戏模式都需要继承该 游戏阶段类
    /// </summary>
    public class MapGameStage
    {
        /// <summary>
        /// 所有阶段列表
        /// </summary>
        public List<int> AllStateList;
        /// <summary>
        /// 游戏当前阶段
        /// </summary>
        public int NowGameState;

        /// <summary>
        /// 结束阶段
        /// </summary>
        public int EndGameState;
        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="AllStateList"></param>
        /// <param name="NowGameState"></param>
        public MapGameStage(List<int> AllStateList, int NowGameState)
        {
            this.NowGameState = NowGameState;
            this.AllStateList = AllStateList;
        }
        /// <summary>
        /// 获取当前游戏阶段
        /// </summary>
        /// <returns></returns>
        public int GetNowGameState()
        {
            return NowGameState;
        }
        /// <summary>
        /// 每帧更新阶段数据
        /// </summary>
        public void StageUpdate()
        {


        }
    }

    /// <summary>
    /// 关卡模式
    /// </summary>
    public enum MapGameModel
    {
        WaveBrush = 0, //波数刷新模式
    }
    /// <summary>
    /// 地图内逻辑
    /// </summary>
    public partial class MapLogic : Node
    {
        /// <summary>
        /// 出生点放置节点
        /// </summary>
        public Node2D LineShowNode = new Node2D();
        /// <summary>
        /// 当前游戏状态
        /// </summary>
        public MapGameStage stage;
        /// <summary>
        /// 当前关卡模式
        /// </summary>
        public MapGameModel mapGameModel;

        /// <summary>
        /// 游戏模式系统
        /// </summary>
        public GameModel gameModel;

        /// <summary>
        /// 初始化 关卡逻辑
        /// </summary>
        /// <param name="mapGameModel"></param>
        public MapLogic(MapGameModel mapGameModel, int ChapterId, int CopyId)
        {
            this.mapGameModel = mapGameModel;
            switch (mapGameModel)//根据模式的不同，初始化不同数据
            {
                case MapGameModel.WaveBrush://波数刷怪
                    gameModel = new WaveBrushSystem(LineShowNode, ChapterId, CopyId);
                    break;
            }
        }


        /// <summary>
        /// 关卡逻辑开始
        /// 1.准备地图内 资源
        /// 2.设置波数开启倒计时
        /// 3.寻找合适的位置创建核心 - (是随机生成的地图才处理)
        /// </summary>
        public virtual void LogicStart()
        {
            switch (mapGameModel)
            {
                case MapGameModel.WaveBrush://波数刷怪
                    gameModel.StartModel();
                    break;
            }
            AddChild(LineShowNode);
        }

        /// <summary>
        /// 关卡逻辑结束
        /// 1.提示获得什么道具等，或者解锁什么功能，解锁什么成就，解锁什么科技
        /// 2.返回主菜单
        /// </summary>
        public virtual void LogicEnd()
        {

            gameModel.EndModel();//关卡具体逻辑 结束
        }


        /// <summary>
        /// 地图逻辑-每帧更新
        /// </summary>
        /// <param name="delta"></param>
        public virtual void MapLogicUpdate(double delta)
        {
            gameModel.PostUpdate(delta);//执行模式的PostUpdate逻辑
        }

        //每波开始时
        public virtual void WaveStart()
        {
        }

        //检查游戏状态,每帧检查一次，
        public virtual void checkGameState()
        {
        }




    }
}