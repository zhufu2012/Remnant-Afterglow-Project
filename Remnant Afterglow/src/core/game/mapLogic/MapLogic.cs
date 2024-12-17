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
        //所有阶段列表
        public List<int> AllStateList;
        //游戏当前阶段
        public int NowGameState;

        //结束阶段
        public int EndGameState;
        //构造函数
        public MapGameStage(List<int> AllStateList,int NowGameState)
        {
            this.NowGameState = NowGameState;
            this.AllStateList = AllStateList;
        }
        //获取当前游戏阶段
        public int GetNowGameState()
        {
            return NowGameState;
        }
        //每帧更新阶段数据
        public void StageUpdate()
        {


        }
    }
    /// <summary>
    /// 关卡模式
    /// </summary>
    public enum MapGameModel
    {
        WaveBrush = 1, //波数刷新模式
    }
    /// <summary>
    /// 地图内逻辑
    /// </summary>
    public partial class MapLogic : Node
    {
        //当前游戏状态
        public MapGameStage stage;
        //当前关卡模式
        public MapGameModel mapGameModel;

        /// <summary>
        /// 怪物刷新系统
        /// </summary>
        public GameModel gameModel;

        //初始化 关卡逻辑
        public MapLogic(MapGameModel mapGameModel)
        {
            this.stage = stage;
            this.mapGameModel = mapGameModel;
            switch(mapGameModel)//根据模式的不同，初始化不同数据
            {
                case MapGameModel.WaveBrush://波数刷怪
                    gameModel = new WaveBrushSystem(ChapterId, CopyId);
                    break;
            }
        }

        //关卡逻辑开始
        //1.准备地图内 资源
        //2.设置波数开启倒计时
        //3.寻找合适的位置创建核心 - (是随机生成的地图才处理)
        public virtual void LogicStart()
        {
            switch(mapGameModel)
            {
                case MapGameModel.WaveBrush://波数刷怪
                    gameModel.StartModel();
                    break;
            }
        }

        //关卡逻辑结束
        //1.提示获得什么道具等，或者解锁什么功能，解锁什么成就，解锁什么科技
        //2.返回主菜单
        public virtual void LogicEnd()
        {

            gameModel.EndModel();//关卡具体逻辑 结束
        }


        //地图逻辑-每帧更新
        public virtual void MapLogicUpdate()
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