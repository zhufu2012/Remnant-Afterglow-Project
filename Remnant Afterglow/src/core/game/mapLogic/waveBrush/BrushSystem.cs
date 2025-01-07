
using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //刷新状态
    public enum BrushState
    {
        BeforeBrush,    //开始刷新前
        StartBrushWave, //第一波开始刷新
        StartBrushing,  //第一波刷新完后的间隔
        BrushWave,      //非第一波的其他波数刷新
        Brushing       //非第一波的其他波数刷新后间隔
    }

    //波数刷怪 模式
    //-祝福注释-似乎还有问题需要完善
    public partial class WaveBrushSystem : GameModel
    {
        /// <summary>
        /// 关卡刷怪配置
        /// </summary>
        public CopyBrush cfgData;

        /// <summary>
        /// 副本刷新状态
        /// </summary>
        public BrushState brushState;

        /// <summary>
        /// 当前地图时间 单位秒
        /// </summary>
        public double nowTime = 0;
        /// <summary>
        /// 当前地图帧数 单位帧
        /// </summary>
        public double frameNumber = 0;

        /// <summary>
        /// 当前波数，0表示未开始刷新
        /// </summary>
        public int NowWave = 0;

        /// <summary>
        /// 刷新点列表
        /// </summary>
        public Dictionary<int, BrushPoint> brushPointDict = new Dictionary<int, BrushPoint>();

        /// <summary>
        /// 刷新点波数刷新数据<刷新点id,波数数据列表>
        /// </summary>
        public Dictionary<int, CopyBrushData> brushDataDict = new Dictionary<int, CopyBrushData>();

        /// <summary>
        /// 第一次刷怪
        /// </summary>
        public int FirstWaveTime = 0;
        /// <summary>
        /// 刷新间隔列表 <波数x,第x波刷新前间隔秒数>
        /// </summary>
        public Dictionary<int, int> BrushSpaceList = new Dictionary<int, int>();

        /// <summary>
        /// 各刷新点实际位置-真实位置
        /// </summary>
        public Dictionary<int, Vector2I> BrushPosDict = new Dictionary<int, Vector2I>();
        /// <summary>
        /// 各刷新点形状数据-真实位置
        /// </summary>
        public Dictionary<int, List<Vector2I>> PolygonDict = new Dictionary<int, List<Vector2I>>();
        /// <summary>
        /// 各刷新点形状数据-点位置
        /// </summary>
        public Dictionary<int, List<Vector2I>> PolygonDict2 = new Dictionary<int, List<Vector2I>>();

        /// <summary>
        /// 是否开始刷新刷怪
        /// </summary>
        public bool is_start_brush = false;
        /// <summary>
        /// 是否在刷怪间隔中
        /// </summary>
        public bool is_after_time = false;

        /// <summary>
        /// 当前波数刷完了
        /// </summary>
        public bool is_now_end = false;
        /// <summary>
        /// 是否全部已经刷怪完了
        /// </summary>
        public bool is_all_end = false;

        /// <summary>
        /// 刷新间隔
        /// </summary>
        public double flush_time = 0;

        /// <summary>
        /// 章节id
        /// </summary>
        public int ChapterId;
        /// <summary>
        /// 关卡id
        /// </summary>
        public int CopyId;
        /// <summary>
        /// 副本节点
        /// </summary>
        public MapCopy mainCopy;

        public WaveBrushSystem(Node2D LineShowNode, int ChapterId, int CopyId) : base(LineShowNode)
        {
            this.ChapterId = ChapterId;
            this.CopyId = CopyId;
            cfgData = new CopyBrush(ChapterId, CopyId);
            CreateInitData();//创建时初始化数据
        }


        /// <summary>
        /// 创建时初始化数据
        /// </summary>
        public void CreateInitData()
        {
            List<int> BrushIdList = cfgData.BrushIdList;
            for (int i = 0; i < BrushIdList.Count; i++)
            {
                brushPointDict[BrushIdList[i]] = new BrushPoint(BrushIdList[i]);
                brushDataDict[BrushIdList[i]] = new CopyBrushData(BrushIdList[i]);
            }
            List<List<int>> space_list = cfgData.BrushSpaceList;//波数,间隔
            for (int i = 0; i < space_list.Count; i++)
            {
                BrushSpaceList[space_list[i][0]] = space_list[i][1];
            }
            for (int i = 1; i <= cfgData.AllWave; i++)
            {
                if (!BrushSpaceList.ContainsKey(i))
                {
                    BrushSpaceList[i] = cfgData.BrushSpace;
                }
            }
            if (BrushSpaceList.Count > 0)
                FirstWaveTime = BrushSpaceList[1];//初始化第一波刷新前 间隔时间
        }


        /// <summary>
        /// 初始化绘制地图刷新点
        /// </summary>
        public override void InitData()
        {
            List<int> brushIdList = cfgData.BrushIdList;
            foreach (int brushId in brushIdList)
            {
                BrushPoint brushCfg = GetBrushPoint(brushId);//刷新点配置
                switch (brushCfg.ShapeType)
                {
                    case 1://矩形刷新 (Widht,Height)
                        Line2D line = new Line2D();
                        line.AddToGroup(MapGroup.LineGroupName_1);
                        line.ZIndex = 3;//祝福注释-这里要看看
                        List<Vector2I> vector_list = PolygonDict[brushId];
                        line.Closed = true;//如果为 true 并且折线有超过2个点，则最后一个点和第一个点将通过线段连接
                        foreach (Vector2 vec in vector_list)
                        {
                            line.AddPoint(vec);
                        }
                        line.Visible = brushCfg.BrushShowType;//是否显示刷新点边界
                        ShowNode.AddChild(line);
                        break;
                    case 2://表示圆形刷新
                        break;
                    default:
                        break;
                }
            }
        }
        /// <summary>
        /// 每帧刷新
        /// </summary>
        /// <param name="delta"></param>
        public override void PostUpdate(double delta)
        {
            nowTime += delta;//时间计数
            frameNumber += 1;//帧数计数
            //刷怪列表，<刷新点,<<怪物id,阵营>,数量>>
            Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>> dict = CheckRefreshEnemies(delta);//
            foreach (var info in dict)//<刷新点,<<怪物id,阵营>,数量>>
            {
                BrushPoint pointData = info.Key;//刷新点配置
                foreach (var unit_info in info.Value)//<<怪物id,阵营>,数量>
                {
                    for (int i = 0; i < unit_info.Value; i++)//
                    {
                        //创建一个单位
                        ObjectManager.Instance.CreateMapUnit(unit_info.Key.Key, new Vector2I(9, 9));
                    }
                }
            }
        }


        ///////////////////////////////////////////////////////////////函数/////////////////////////////////////////////////
        /// <summary>
        /// 返回对应的刷新点配置数据
        /// </summary>
        /// <param name="BrushId"></param>
        /// <returns></returns>
        public BrushPoint GetBrushPoint(int BrushId)
        {
            return brushPointDict[BrushId];
        }

        //检查刷怪
        public Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>> CheckRefreshEnemies(double delta)
        {
            //刷怪列表，<刷新点id,<<怪物id,阵营>,数量>>
            Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>> dict = new Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>>();
            if (is_start_brush)//已经开始刷怪
            {
                dict = RefreshEnemies(delta);
            }
            else
            {
                if (nowTime >= FirstWaveTime)//开始刷怪
                {
                    is_start_brush = true;
                    NowWave = 1;
                    dict = RefreshEnemies(delta);
                }
            }
            return dict;
        }

        /// <summary>
        /// 刷新怪物
        /// </summary>
        /// <param name="delta"></param>
        /// <returns><刷新点id,<<怪物id,阵营id>,数量>></returns>
        public Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>> RefreshEnemies(double delta)
        {
            //<刷新点id,<<怪物id,阵营id>,数量>>
            Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>> dict = new Dictionary<BrushPoint, Dictionary<KeyValuePair<int, int>, int>>();
            if (NowWave > 0 && NowWave <= cfgData.AllWave && is_all_end == false)//波数大于0并且 当前波数小于等于配置总波数
            {
                flush_time += delta;//刷新间隔增加
                if (flush_time >= BrushSpaceList[NowWave])//刷新间隔时长达到
                {
                    is_after_time = false;
                }
                else
                {
                    is_after_time = true;
                }
                if (is_after_time == false)//不在刷新间隔就直接刷新怪物，并且进入刷新间隔
                {
                    foreach (int BrushId in cfgData.BrushIdList)//遍历刷新点
                    {
                        BrushPoint pointData = ConfigCache.GetBrushPoint(BrushId);
                        if (!brushDataDict[BrushId].CheckAllWaveFlush())//该刷新点所有波数未刷新完
                        {
                            dict[pointData] = brushDataDict[BrushId].CalcWaveUnit(NowWave, nowTime, frameNumber);
                        }
                        else
                        {
                            brushDataDict[BrushId].is_flush_acc = true;
                        }
                    }
                    if (CheckAllBrushFlush(NowWave))//当前波数都刷新完了，进入新的一波
                    {
                        is_after_time = true;
                        flush_time = 0;
                        NowWave += 1;
                    }
                }
                else
                {
                    return dict;
                }
            }
            else
            {

            }
            return dict;
        }

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        //检查所有刷新点该波是否都刷新完了
        public bool CheckAllBrushFlush(int waveId)
        {
            bool is_end = true;
            foreach (int BrushId in cfgData.BrushIdList)//遍历刷新点
            {
                if (!brushDataDict[BrushId].is_flush_acc)
                {
                    is_end = false;
                    break;
                }
            }
            return is_end;
        }

        //检查所有刷新点是否都刷新完了
        public bool CheckAllBrushFlush2(int waveId)
        {
            bool is_end = true;
            foreach (int BrushId in cfgData.BrushIdList)//遍历刷新点
            {
                if (!brushDataDict[BrushId].is_flush_acc)
                    is_end = false;
                break;
            }
            return is_end;
        }




    }
}