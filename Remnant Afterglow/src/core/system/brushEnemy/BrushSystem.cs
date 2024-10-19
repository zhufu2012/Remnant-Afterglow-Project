
using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //地图刷怪功能
    public class BrushSystem
    {
        //关卡刷怪配置
        public CopyBrush cfgData;

        //当前地图时间 单位秒
        public double nowTime = 0;
        //当前地图帧数 单位帧
        public double frameNumber = 0;

        //当前波数，0表示未开始刷新
        public int NowWave = 0;

        //刷新点列表
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

        //当前波数刷完了
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

        public BrushSystem(int ChapterId, int CopyId)
        {
            Log.PrintList(SaveLoadSystem.NowSaveData.ScienceIdList);
            this.ChapterId = ChapterId;
            this.CopyId = CopyId;
            cfgData = new CopyBrush(ChapterId, CopyId);
            CreateInitData();//创建时初始化数据
        }
        ///创建时初始化数据
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
                FirstWaveTime = BrushSpaceList[1];
            foreach (int brushId in cfgData.BrushIdList)//初始化刷新点形状数据
            {
                BrushPoint brushCfg = GetBrushPoint(brushId);//刷新点配置
                List<Vector2I> vector_list = new List<Vector2I>();
                List<Vector2I> vector_list2 = new List<Vector2I>();
                Vector2I brush_pos = new Vector2I(brushCfg.BrushPos.X * MapConstant.TileCellSize, brushCfg.BrushPos.Y * MapConstant.TileCellSize);//刷新点实际位置;
                foreach (Vector2I vec in brushCfg.Polygon)
                {
                    Vector2I temp_vec = new Vector2I(vec.X * MapConstant.TileCellSize, vec.Y * MapConstant.TileCellSize) + brush_pos;
                    Vector2I temp_vec2 = new Vector2I(vec.X, vec.Y) + brushCfg.BrushPos;
                    vector_list.Add(temp_vec);
                    vector_list2.Add(temp_vec2);
                }
                BrushPosDict[brushId] = brush_pos;
                PolygonDict[brushId] = vector_list;
                vector_list2.Add(vector_list2[0]);
                PolygonDict2[brushId] = vector_list2;
            }

        }


        /// <summary>
        /// 初始化绘制地图刷新点
        /// </summary>
        public Node2D GetBrushPoint()
        {
            List<int> brushIdList = cfgData.BrushIdList;
            Node2D node = new Node2D();
            foreach (int brushId in brushIdList)
            {
                BrushPoint brushCfg = GetBrushPoint(brushId);//刷新点配置
                Line2D line = new Line2D();
                line.AddToGroup(MapGroup.GroupName_1);
                line.ZIndex = MapLayer.FloorLayer3;
                List<Vector2I> vector_list = PolygonDict[brushId];
                Vector2I BrushPos = BrushPosDict[brushId];
                switch (brushCfg.ShapeSelect)
                {
                    case 0://全图刷新
                        break;
                    case 1://表示在一个点刷新，读取Polygon第一个坐标
                        line.AddPoint(vector_list[0]);//祝福注释
                        break;
                    case 2://表示多边形刷新
                        line.Closed = true;//如果为 true 并且折线有超过2个点，则最后一个点和第一个点将通过线段连接
                        foreach (Vector2 vec in vector_list)
                        {
                            line.AddPoint(vec);
                        }
                        break;
                    case 3://表示圆形刷新//其他地方绘制
                        break;
                    default:
                        break;
                }
                line.Visible = brushCfg.BrushShowType;//是否显示刷新点
                node.AddChild(line);
            }
            return node;
        }
        /// <summary>
        /// 每帧刷新
        /// </summary>
        /// <param name="delta"></param>
        public void Update(double delta)
        {

            //时间及帧数计数
            nowTime += delta;
            frameNumber += 1;
        }

        ///////////////////////////////////////////////////////////////函数////////////////////////////////////////////////////////////////////////
        //返回对应的刷新点配置数据
        public BrushPoint GetBrushPoint(int BrushId)
        {
            return brushPointDict[BrushId];
        }

        //检查刷怪
        public Dictionary<int, Dictionary<KeyValuePair<int, int>, int>> CheckRefreshEnemies(double delta)
        {
            //刷怪列表，<刷新点id,<<怪物id,阵营>,数量>>
            Dictionary<int, Dictionary<KeyValuePair<int, int>, int>> dict = new Dictionary<int, Dictionary<KeyValuePair<int, int>, int>>();
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
        public Dictionary<int, Dictionary<KeyValuePair<int, int>, int>> RefreshEnemies(double delta)
        {
            //<刷新点id,<<怪物id,阵营id>,数量>>
            Dictionary<int, Dictionary<KeyValuePair<int, int>, int>> dict = new Dictionary<int, Dictionary<KeyValuePair<int, int>, int>>();
            if (NowWave > 0 && NowWave <= cfgData.AllWave && is_all_end == false)//波数大于0并且 当前波数小于等于配置总波数
            {
                flush_time += delta;
                if (is_after_time)//是否在刷新间隔中,是刷新间隔就继续增加
                {
                    if (flush_time >= BrushSpaceList[NowWave])//刷新间隔时长达到
                        is_after_time = false;
                    else
                        return dict;
                }
                if (is_after_time == false)//不在刷新间隔就直接刷新怪物，并且进入刷新间隔
                {
                    foreach (int BrushId in cfgData.BrushIdList)//遍历刷新点
                    {
                        if (!brushDataDict[BrushId].CheckAllWaveFlush())//该刷新点所有波数未刷新完
                        {
                            dict[BrushId] = brushDataDict[BrushId].CalcWaveUnit(NowWave, nowTime, frameNumber);
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