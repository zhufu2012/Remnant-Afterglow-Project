
using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{

    /// <summary>
    /// 常规游戏模式-波数刷怪模式
    /// </summary>
    public partial class BrushSystem : GameModel
    {
        #region
        /// <summary>
        /// 章节数据
        /// </summary>
        public ChapterBase chapter;
        /// <summary>
        /// 关卡数据
        /// </summary>
        public ChapterCopyBase chapterCopy;
        #endregion

        #region 刷怪点
        /// <summary>
        /// 当前波数
        /// </summary>
        public int NowWave = 0;


        /// <summary>
        /// 是否显示刷怪点的边缘
        /// </summary>
        public bool IsBrushShowType = true;

        /// <summary>
        /// 当前地图时间 单位秒
        /// </summary>
        public double NowTime = 0;
        /// <summary>
        /// 刷怪点 放置的 父节点
        /// </summary>
        public Node2D LineShowNode = new Node2D();
        /// <summary>
        /// 关卡刷怪数据
        /// </summary>
        public CopyBrush copyBrush;
        /// <summary>
        /// 关卡 各刷怪点数据字典 <刷怪点id，刷怪点数据>
        /// </summary>
        public Dictionary<int, BrushPoint> BrushDict = new Dictionary<int, BrushPoint>();

        /// <summary>
        /// 关卡 各刷怪点类字典 <刷怪点id，刷怪点类数据>
        /// </summary>
        public Dictionary<int, CopyBrushData> BrushDataDict = new Dictionary<int, CopyBrushData>();
        /// <summary>
        /// 各刷怪点开始位置<刷怪点id,区域>
        /// </summary>
        public Dictionary<int, Rect2I> BrushPosDict = new Dictionary<int, Rect2I>();

        /// <summary>
        /// <刷怪点，本波要刷的怪>
        /// </summary>
        Dictionary<int, List<int>> NowWaveBrushDict = new Dictionary<int, List<int>>();

        /// <summary>
        /// 波次间隔时间<波次，间隔时间>，不包含没有的数据，没有的用BrushSpace
        /// </summary>
        Dictionary<int, int> BrushSpaceTimeDict = new Dictionary<int, int>();
        #endregion

        #region 其他节点

        public BrushSettleView SettlePopup;

        #endregion
        /// <summary>
        /// 刷怪状态，逻辑开始是准备阶段
        /// </summary>
        public BrushState brushState = BrushState.Prepare;



        public BrushSystem(ChapterBase chapter, ChapterCopyBase chapterCopy)
        {
            this.chapterCopy = chapterCopy;
            this.chapter = chapter;
            copyBrush = ConfigCache.GetCopyBrush(chapter.ChapterId + "_" + chapterCopy.CopyId);
            Log.Print("关卡开始，关卡id:" + chapterCopy.CopyId);
            foreach (int i in copyBrush.BrushIdList)
            {
                BrushPoint point = ConfigCache.GetBrushPoint(i);
                BrushDict[i] = point;
                List<Vector2I> posList = point.BrushPosList;
                BrushPosDict[i] = new Rect2I(posList[0], posList[1]);
                BrushDataDict[i] = new CopyBrushData(i, point, posList[0], posList[1]);
            }

            foreach (var info in copyBrush.BrushSpaceList)
            {
                BrushSpaceTimeDict[info[0]] = info[1];
            }
            SettlePopup = (BrushSettleView)GD.Load<PackedScene>("res://src/core/game/mapLogic/结算界面.tscn").Instantiate();
            SettlePopup.Hide();
            AddChild(SettlePopup);
        }
        /// <summary>
        /// 初始化数据
        /// </summary>
        public override void InitData()
        {
            base.InitData();
        }

        /// <summary>
        /// 开始准备刷怪
        /// </summary>
        public override void StartModel()
        {
            base.StartModel();
            MapOpView.Instance.SetAllWave(copyBrush.AllWave);//设置总波数
            Log.Print("开始状态");
            AddLineShow();
        }


        /// <summary>
        /// 是否关卡结束
        /// </summary>
        /// <returns></returns>
        public override bool IsCopyEnd()
        {
            //是否已刷新完所有波次敌人 并且 所有单位都死亡
            return brushState == BrushState.EndBrush && ObjectManager.Instance.unitDict.Count == 0;
        }

        /// <summary>
        /// 刷怪点区域显示
        /// </summary>
        public void AddLineShow()
        {
            LineShowNode.Name = "LineShowNode";
            AddChild(LineShowNode);
            foreach (var point in BrushPosDict)
            {
                Line2D line = new Line2D();
                line.AddToGroup(MapGroup.LineGroupName_1);
                line.ZIndex = ViewConstant.BrushSystem_Line_ZIndex;//祝福注释-暂时
                Vector2 p1 = point.Value.Position * MapConstant.TileCellSize;
                Vector2 p2 = point.Value.End * MapConstant.TileCellSize;
                line.AddPoint(p1);
                line.AddPoint(new Vector2(p2.X, p1.Y));
                line.AddPoint(p2);
                line.AddPoint(new Vector2(p1.X, p2.Y));
                line.Closed = true;
                line.Visible = IsBrushShowType;
                LineShowNode.AddChild(line);
            }
        }

        /// <summary>
        /// 当前波数是否数据已经处理了
        /// </summary>
        public bool IsNowWave = false;
        /// <summary>
        /// 下一个波数开始刷怪的时间
        /// </summary>
        public double NextTime = 0;
        /// <summary>
        /// 每个刷怪点的下次刷新时间
        /// </summary>
        private Dictionary<int, double> brushNextFlushTime = new Dictionary<int, double>();
        /// <summary>
        /// 每个刷怪点中每个单位组的下次刷新时间
        /// </summary>
        private Dictionary<int, Dictionary<int, double>> brushGroupNextFlushTime = new Dictionary<int, Dictionary<int, double>>();

        public override void PostUpdate(double delta)
        {
            base.PostUpdate(delta);
            if (!IsStart)//没开启逻辑就不运行之后的
                return;
            NowTime += delta;//时间计数
            MapOpView.Instance.SetNowWave(NowWave);//设置当前波数--这里没必要每帧都执行，可以修改为每秒执行一次
            BrushWaveLogic();
        }

        public void BrushWaveLogic()
        {
            switch (brushState)
            {
                case BrushState.Prepare://准备阶段
                    if (NowTime >= copyBrush.PrepareTime)//当前地图时间 大于 准备时间了
                    {
                        brushState = BrushState.BrushWave;//开始刷怪
                        Log.Print("开始刷怪!" + NowWave + "  " + NowTime);
                        IsNowWave = false;
                        NowWave = 1;//波数修改为1
                    }
                    break;
                case BrushState.BrushWave://开始刷怪
                    if (IsNowWave)
                    {
                        // 移除对WaveFlushTime的依赖，直接调用BrushWave
                        BrushWave();
                        Log.Print("刷怪:" + NowWave + "  " + NowTime);
                    }
                    else
                    {
                        StartWaveData();//处理数据并刷新波次怪物
                        Log.Print("刷怪:" + NowWave + "  " + NowTime);
                    }
                    break;
                case BrushState.Brushing://刷怪完成后到下一波的间隔
                    if (NowTime >= NextTime)//当前时间大于等于的下一波的开启时间
                    {
                        NowWave += 1;
                        IsNowWave = false;
                        brushState = BrushState.BrushWave;//开始刷怪
                    }
                    break;
                case BrushState.EndBrush://结束刷怪
                    break;
                default: break;
            }
        }




        /// <summary>
        /// 处理该波数据
        /// </summary>
        /// <param name="wave">要刷的波</param>
        public void StartWaveData()
        {
            NowWaveBrushDict.Clear();//清理之前波数记录的数据
            foreach (var data in BrushDataDict)
            {
                List<List<int>> list = data.Value.GetWaveBrushList(NowWave);
                List<int> allUnitList = new List<int>();
                foreach (List<int> info in list)
                {
                    int GroupId = info[0];//单位组id
                    int Count = info[1];//刷新次数
                    UnitGroupData unitGroup = ConfigCache.GetUnitGroupData(GroupId);
                    List<int> unitList = GenerateUnits(unitGroup.UnitList, unitGroup.CountInterval, Count);
                    allUnitList.AddRange(unitList);
                }
                NowWaveBrushDict[data.Key] = allUnitList;

                // 初始化每个刷怪点中单位组的刷新时间记录
                brushGroupNextFlushTime[data.Key] = new Dictionary<int, double>();
                List<List<int>> waveUnitGroups = data.Value.GetWaveBrushList(NowWave);
                foreach (List<int> groupInfo in waveUnitGroups)
                {
                    int groupId = groupInfo[0];
                    UnitGroupData unitGroup = ConfigCache.GetUnitGroupData(groupId);
                    brushGroupNextFlushTime[data.Key][groupId] = NowTime; // 初始刷新时间为当前时间
                }
            }
            IsNowWave = true;//设置为已处理数据
            BrushWave();
        }


        /// <summary>
        /// 刷新当前波-修改为每个刷怪点都刷一只怪,而不是一次性刷完
        /// </summary>
        public void BrushWave()
        {
            // WaveFlushTime = NowTime + FlushSpace;//刷新时 ，上一波时间修改 - 删除这行
            bool IsAllFlush = true;//当前波是否全部刷新完成

            // 遍历所有刷怪点
            foreach (var brush in NowWaveBrushDict)
            {
                int BrushId = brush.Key;//刷怪点id
                List<int> allUnitList = brush.Value;//这一波要刷新的所有单位

                // 获取当前刷怪点的波次数据
                List<List<int>> waveUnitGroups = BrushDataDict[BrushId].GetWaveBrushList(NowWave);

                // 检查是否到了该刷怪点中某个单位组的刷新时间
                bool unitSpawned = false;
                foreach (List<int> groupInfo in waveUnitGroups)
                {
                    int groupId = groupInfo[0];
                    UnitGroupData unitGroup = ConfigCache.GetUnitGroupData(groupId);

                    // 确保该单位组在字典中存在
                    if (!brushGroupNextFlushTime[BrushId].ContainsKey(groupId))
                    {
                        brushGroupNextFlushTime[BrushId][groupId] = NowTime;
                    }

                    // 检查是否到了该单位组的刷新时间
                    // 将帧数转换为秒数进行比较
                    double intervalInSeconds = unitGroup.Interval / 60.0; // 假设60帧每秒
                    if (NowTime >= brushGroupNextFlushTime[BrushId][groupId] && allUnitList.Count > 0)
                    {
                        CopyBrushData data = BrushDataDict[BrushId];

                        // 从该刷怪点的单位列表中取出第一个单位
                        int UnitId = allUnitList[0];

                        // 从data.points中随机选择一个位置
                        Random random = new Random();
                        int randomIndex = random.Next(0, data.points.Count);
                        Vector2I spawnPosition = data.points[randomIndex];

                        // 创建单位
                        ObjectManager.Instance.CreateMapUnit(UnitId, spawnPosition, data.cfgData.TargetPos);

                        // 移除已刷的单位
                        allUnitList.RemoveAt(0);

                        // 设置该单位组下一次刷新时间（根据单位组配置决定间隔）
                        brushGroupNextFlushTime[BrushId][groupId] = NowTime + intervalInSeconds;

                        // 一次只刷一个单位
                        unitSpawned = true;
                        break;
                    }
                }

                // 如果还有单位未刷出，则当前波次未完成
                if (allUnitList.Count > 0)
                {
                    IsAllFlush = false;
                }
            }

            if (IsAllFlush)//当前波 全部刷新完成
            {
                if (NowWave <= copyBrush.AllWave - 1)//非结束波次
                {
                    brushState = BrushState.Brushing;//刷怪完成后到下一波的间隔
                    // WaveFlushTime = 0; // 删除这行
                    brushNextFlushTime.Clear(); // 清空刷新时间记录
                    brushGroupNextFlushTime.Clear(); // 清空单位组刷新时间记录
                    if (BrushSpaceTimeDict.ContainsKey(NowWave))//设置下一波开始时间
                        NextTime = NowTime + BrushSpaceTimeDict[NowWave];
                    else
                        NextTime = NowTime + copyBrush.BrushSpace;
                }
                else
                {
                    brushState = BrushState.EndBrush;//波次结束
                    Log.Print("波次结束了，全部刷完了," + NowWave + "  " + NowTime);
                }
            }
        }



        /// <summary>
        /// 关卡具体逻辑 结束
        /// </summary>
        public override void EndModel()
        {
            base.EndModel();
            SettlePopup.Show();
        }

        /// <summary>
        /// 根据给定概率生成单位ID列表
        /// </summary>
        /// <param name="probabilityList"> 概率列表</param>
        /// <param name="CountInterval"> 生成数量范围</param>
        /// <param name="count"> 组生成数量</param>
        /// <returns></returns>
        public List<int> GenerateUnits(List<List<int>> probabilityList, List<int> CountInterval, int count)
        {
            // 处理CountInterval，确定实际生成数量
            int actualCount = count;
            if (CountInterval != null && CountInterval.Count >= 2)
            {
                int minCount = CountInterval[0];
                int maxCount = CountInterval[1];

                // 确保最小值不大于最大值，且都为正数
                if (minCount <= maxCount && minCount > 0)
                {
                    // 如果只有一个值可选，则使用固定值；否则在范围内随机选择
                    if (minCount == maxCount)
                    {
                        actualCount = count * minCount;
                    }
                    else
                    {
                        Random rangeRand = new Random();
                        int randomMultiplier = rangeRand.Next(minCount, maxCount + 1);
                        actualCount = count * randomMultiplier;
                    }
                }
            }
            List<Tuple<int, int>> cumulative = new List<Tuple<int, int>>();
            int sum = 0;
            foreach (var item in probabilityList)
            {
                if (item.Count < 2)
                    continue; // 跳过无效项
                int unitId = item[0];
                int weight = item[1];
                if (weight <= 0)
                    continue; // 忽略非正概率项
                sum += weight;
                cumulative.Add(Tuple.Create(sum, unitId));
            }
            if (sum <= 0 || actualCount <= 0)
                return new List<int>();
            Random rand = new Random();
            List<int> result = new List<int>();
            for (int i = 0; i < actualCount; i++)
            {
                double randomValue = rand.NextDouble() * sum;
                foreach (var tuple in cumulative)
                {
                    if (randomValue <= tuple.Item1)
                    {
                        result.Add(tuple.Item2);
                        break;
                    }
                }
            }
            return result;
        }
    }
}
