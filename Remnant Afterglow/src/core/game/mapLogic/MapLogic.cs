using GameLog;
using Godot;
using SteeringBehaviors;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地图内逻辑
    /// </summary>
    public partial class MapLogic : Node2D
    {
        /// <summary>
        /// 当前关卡模式
        /// </summary>
        public MapGameModel mapGameModel;

        /// <summary>
        /// 游戏模式系统
        /// </summary>
        public GameModel gameModel;

        /// <summary>
        /// 章节数据
        /// </summary>
        public ChapterBase chapter;
        /// <summary>
        /// 战役关卡数据
        /// </summary>
        public ChapterCopyBase chapterCopy;
        /// <summary>
        /// 单例模式
        /// </summary>
        public static MapLogic Instance;
        /// <summary>
        /// 初始化 关卡逻辑
        /// </summary>
        /// <param name="mapGameModel"></param>
        public MapLogic(MapGameModel mapGameModel, int ChapterId, int CopyId)
        {
            Instance = this;
            this.mapGameModel = mapGameModel;
            chapter = ConfigCache.GetChapterBase(ChapterId);
            chapterCopy = ConfigCache.GetChapterCopyBase(ChapterId + "_" + CopyId);
            switch (mapGameModel)//根据模式的不同，初始化不同数据
            {
                case MapGameModel.WaveBrush://波数刷怪
                    gameModel = new BrushSystem(chapter, chapterCopy);
                    gameModel.Name = "BrushSystem";
                    break;
            }
            CreateBagData();//准备作战地图 的背包资源数据
            AddChild(gameModel);
            InitAttribute();
        }

        #region 关卡逻辑开始
        /// <summary>
        /// 关卡逻辑开始
        /// 1.准备地图内 资源
        /// 2.设置波数开启倒计时
        /// 3.寻找合适的位置创建核心 - (是随机生成的地图才处理)
        /// </summary>
        public virtual void LogicStart()
        {
            MapOpView.Instance.SetCurrencyView();//设置货币数量

            switch (mapGameModel)
            {
                case MapGameModel.WaveBrush://波数刷怪
                    gameModel.StartModel();
                    break;
            }
        }

        /// <summary>
        /// 准备背包数据
        /// </summary>
        public void CreateBagData()
        {
            List<MoneyBase> moneyBaseList = ConfigCache.GetAllMoneyBase();//货币初始化
            BagSystem.Instance.MapCurrencyClear();
            foreach (MoneyBase moneyBase in moneyBaseList)
            {
                BagSystem.Instance.CreateMapCurrency(moneyBase);
            }
        }
        #endregion


        int index = 0;
        /// <summary>
        /// 地图逻辑-每帧更新
        /// </summary>
        /// <param name="delta"></param>
        public virtual void MapLogicUpdate(double delta)
        {
            if (gameModel.IsCopyEnd())
            {
                Log.Print("关卡结束了");
                SceneManager.PutParam("chapter_id", chapter.ChapterId);
                gameModel.EndModel();//关卡具体逻辑 结束
                SpatialGrid.Clear();
            }
            else
            {
                gameModel.PostUpdate(delta);//执行模式的PostUpdate逻辑-修改为每秒执行一次

            }
            if (index >= GameConstant.GameFrame)//每秒执行一次
            {
                index = 0;
            }

            if (index % SpatialGrid.UpdateCacheTime == 0)
                SpatialGrid.UpdateCache();
            index++;
        }

        /// <summary>
        /// 每波开始时
        /// </summary>
        public virtual void WaveStart()
        {

        }

        /// <summary>
        /// 检查游戏状态,每帧检查一次，
        /// </summary>
        public virtual void checkGameState()
        {
        }

        /// <summary>
        /// 重置重生周期
        /// </summary>
        public virtual void RegenerationCycle()
        {
        }
    }
}
