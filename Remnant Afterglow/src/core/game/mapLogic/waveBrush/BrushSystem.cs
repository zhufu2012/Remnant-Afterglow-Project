
using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{

    /// <summary>
    /// 常规游戏模式
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
        /// <刷怪点，要刷的怪>
        /// </summary>
        Dictionary<int, List<int>> NowWaveBrushDict = new Dictionary<int, List<int>>();

        /// <summary>
        /// 波次间隔时间<波次，间隔时间>，不包含没有的数据，没有的用BrushSpace
        /// </summary>
        Dictionary<int, int> BrushSpaceTimeDict = new Dictionary<int, int>();
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
                line.ZIndex = 50;//祝福注释-暂时
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
        /// 这一波上次刷怪的时间（防止一波全部直接刷出来导致相互碰撞卡出地图）
        /// </summary>
        public double WaveFlushTime = 0;
        /// <summary>
        /// 刷新点刷新间隔
        /// </summary>
        public double FlushSpace = 2;

        public override void PostUpdate(double delta)
        {
            base.PostUpdate(delta);
            if (!IsStart)//没开启逻辑就不运行之后的
                return;
            if (IsEnd)
                return;
            NowTime += delta;//时间计数
            MapOpView.Instance.SetNowWave(NowWave);//设置当前波数
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
                        if ((WaveFlushTime == 0 || NowTime >= WaveFlushTime))
                        {
                            BrushWave();
                            Log.Print("刷怪1!" + NowWave + "  " + NowTime);
                        }
                    }
                    else
                    {
                        StartWaveData();//处理数据并刷新波次怪物
                        Log.Print("刷怪2!" + NowWave + "  " + NowTime);
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
                    Log.Print("波次结束了，全部刷完了," + NowWave + "  " + NowTime);
                    IsEnd = true;
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
            NowWaveBrushDict.Clear();//清理之前刷新的怪物
            foreach (var data in BrushDataDict)
            {
                List<List<int>> list = data.Value.GetWaveBrushList(NowWave);
                List<int> allUnitList = new List<int>();
                foreach (List<int> info in list)
                {
                    int GroupId = info[0];//单位组id
                    int Count = info[1];//刷新次数
                    UnitGroupData unitGroup = ConfigCache.GetUnitGroupData(GroupId);
                    List<int> unitList = GenerateUnits(unitGroup.UnitList, Count);
                    allUnitList.AddRange(unitList);
                }
                NowWaveBrushDict[data.Key] = allUnitList;
            }
            IsNowWave = true;//设置为已处理数据
            BrushWave();
        }
        /// <summary>
        /// 刷新当前波
        /// </summary>
        public void BrushWave()
        {
            WaveFlushTime = NowTime + FlushSpace;//刷新时 ，上一波时间修改
            bool IsAllFlush = true;//当前波是否全部刷新完成
            foreach (var brush in NowWaveBrushDict)
            {
                int BrushId = brush.Key;//刷怪点id
                List<int> allUnitList = brush.Value;//这一波要刷新的所有单位
                if (allUnitList.Count > 0)//还有需要刷新的单位
                {
                    CopyBrushData data = BrushDataDict[BrushId];
                    int count = Mathf.Min(allUnitList.Count, data.points.Count);//要刷新的量
                    List<Vector2I> points = data.points;//刷新坐标
                    for (int i = count - 1; i >= 0; i--)
                    {
                        int UnitId = allUnitList[i];
                        ObjectManager.Instance.CreateMapUnit(UnitId, points[i]);
                        allUnitList.RemoveAt(i); // 使用 RemoveAt 确保正确移除
                    }
                    if (allUnitList.Count > 0)//还有需要刷新的单位
                    { 
                        IsAllFlush = false;
                    }
                }
            }
            if (IsAllFlush)//当前波 全部刷新完成
            {
                if (NowWave <= copyBrush.AllWave - 1)//非结束波次
                {
                    brushState = BrushState.Brushing;//刷怪完成后到下一波的间隔
                    WaveFlushTime = 0;
                    if (BrushSpaceTimeDict.ContainsKey(NowWave))//设置下一波开始时间
                        NextTime = NowTime + BrushSpaceTimeDict[NowWave];
                    else
                        NextTime = NowTime + copyBrush.BrushSpace;
                }
                else
                {
                    brushState = BrushState.EndBrush;//波次结束
                }
            }
        }


        /// <summary>
        /// 结束
        /// </summary>
        public override void EndModel()
        {
            base.EndModel();
        }

        /// <summary>
        /// 根据给定概率生成单位ID列表
        /// </summary>
        /// <param name="probabilityList"></param>
        /// <param name="count"></param>
        /// <returns></returns>
        public List<int> GenerateUnits(List<List<int>> probabilityList, int count)
        {
            List<Tuple<int, int>> cumulative = new List<Tuple<int, int>>();
            int sum = 0;

            foreach (var item in probabilityList)
            {
                if (item.Count < 2)
                    continue; // 跳过无效项
                int x = item[0];
                int y = item[1];

                if (y <= 0)
                    continue; // 忽略非正概率项
                sum += y;
                cumulative.Add(Tuple.Create(sum, x));
            }
            if (sum <= 0 || count <= 0)
                return new List<int>();
            Random rand = new Random();
            List<int> result = new List<int>();
            for (int i = 0; i < count; i++)
            {
                double randomValue = rand.NextDouble() * sum;
                foreach (var tuple in cumulative)
                {
                    if (randomValue < tuple.Item1)
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
