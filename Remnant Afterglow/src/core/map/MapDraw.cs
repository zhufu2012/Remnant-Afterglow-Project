using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class MapDraw : TileMap
    {
        /// <summary>
        /// 副本关卡数据
        /// </summary>
        private ChapterCopyBase copyData;
        /// <summary>
        /// 图块资源
        /// </summary>
        public LoadTileSetConfig loadTileSetConfig;
        /// <summary>
        /// 地图生成器
        /// </summary>
        public MapGenerate mapGenerate;
        /// <summary>
        /// 地图各层数据
        /// </summary>
        public Dictionary<int, Cell[,]> layer_dict = new Dictionary<int, Cell[,]>();
        /////////////////////地图内数据//////////////////////


        /// <summary>
        /// 地图总时间
        /// </summary>
        public double nowTime = 0;
        public int ChapterId;//副本id
        public int CopyId;//关卡id
        public FastNoiseLite noise;//随机种子
        public Vector2 Size;//
        public MapDraw(int ChapterId, int CopyId, FastNoiseLite noise, Vector2 Size)
        {
            copyData = new ChapterCopyBase(ChapterId, CopyId);
            this.ChapterId = ChapterId;
            this.CopyId = CopyId;
            this.noise = noise;
            this.Size = Size;
        }

        #region 初始化数据
        public override void _Ready()
        {
            InitMapCfg();
            InitMap();//初始化绘制地图
        }

        /// <summary>
        /// 地图绘制资源配置初始化
        /// </summary>
        public void InitMapCfg()
        {
            loadTileSetConfig = new LoadTileSetConfig(1);
            TileSet = loadTileSetConfig.GetTileSet();
            mapGenerate = new MapGenerate(copyData.CopyId);
        }
        /// <summary>
        /// 初始化绘制地图
        /// </summary>
        public void InitMap()
        {
            layer_dict = mapGenerate.GenerateMap(noise, Size);
            foreach (var Layer in layer_dict)
            {
                Cell[,] map = Layer.Value;//每层
                if (Layer.Key >= GetLayersCount())
                {
                    for (int i = GetLayersCount(); i <= Layer.Key; i++)
                    {
                        AddLayer(i);
                    }
                }
                for (int i = 0; i < map.GetLength(0); i++)
                {
                    for (int j = 0; j < map.GetLength(1); j++)
                    {
                        SetCell(Layer.Key, new Vector2I(i, j), map[i, j].MapImageId,
                             LoadTileSetConfig.GetImageIndex_TO_Vector2(map[i, j].MapImageId, map[i, j].MapImageIndex));
                    }
                }
            }
        }
        #endregion


        public override void _Process(double delta)
        {
            QueueRedraw();
        }

        /// <summary>
        /// 逻辑帧
        /// </summary>
        /// <param name="delta"></param>
        public override void _PhysicsProcess(double delta)
        {
            base._PhysicsProcess(delta);
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed("mapview_drawmap"))
            {
                InitMap();//重新绘制
            }
            base._UnhandledInput(@event);
        }

        ///创建一座防御塔
        public void AddTower()
        {
        }

        ///创建一座建筑
        public void AddBuild()
        {
        }

        //获取鼠标位置在地图中的位置
        public Vector2I GetLocalMousePos(Vector2I pos)
        {
            return LocalToMap(ToLocal(pos));
        }

        //获取地图中TileData
        public TileData GetLocalMousePos(int layer,Vector2I pos)
        {
            return GetCellTileData(layer, pos);
        }
    }
}
