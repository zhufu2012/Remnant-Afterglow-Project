using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class BigMapDraw : Node2D
    {
        private TileMap tilemap;
        public LoadTileSetConfig loadTileSetConfig;
        public BigMapGenerate bigMapGenerate;
        public Node2D BigCellList;
        /// <summary>
        /// 相机
        /// </summary>
        private GameCamera gameCamera;

        public Dictionary<int, Hex[,]> layer_dict = new Dictionary<int, Hex[,]>();

        /// <summary>
        /// 战役基础配置数据
        /// </summary>
        public ChapterBase chapterBase;
        /// <summary>
        /// 关卡基础配置列表  <坐标，关卡基础配置>
        /// </summary>
        public Dictionary<Vector2I, ChapterCopyBase> copyBaseDict = new Dictionary<Vector2I, ChapterCopyBase>();

        /// <summary>
        /// 章节id
        /// </summary>
        public int ChapterId;

        /// <summary>
        /// 是否显示设置下的各按钮
        /// </summary>
        public bool is_show_setview = false;
        /// <summary>
        /// 初始化数据
        /// </summary>
        public void InitData()
        {
            int ChapterId = (int)GlobalData.GetParam("chapter_id");
            GlobalData.Clear();
            chapterBase = ConfigCache.GetChapterBase("" + ChapterId);
            List<Dictionary<string, object>> list = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_ChapterCopyBase, new Dictionary<string, object> { { "ChapterId", ChapterId } });
            for (int i = 0; i < list.Count; i++)
            {
                ChapterCopyBase chapterCopy = ConfigCache.GetChapterCopyBase("" + ChapterId + "_" + (int)list[i]["CopyId"]);
                copyBaseDict[chapterCopy.Pos] = chapterCopy;
            }
            gameCamera = new GameCamera(chapterBase.CameraId);//游戏相机
            AddChild(gameCamera);
        }

        public override void _Ready()
        {
            InitData();
            InitView();
            InitMap();//初始化地图
        }

        public void InitView()
        {
            tilemap = GetNode<TileMap>("TileMap");
            BigCellList = GetNode<Node2D>("BigCellList");
            loadTileSetConfig = new LoadTileSetConfig(2);
            tilemap.TileSet = loadTileSetConfig.GetTileSet();
            bigMapGenerate = new BigMapGenerate(1);//祝福注释-暂时

        }

        public override void _Process(double delta)
        {
            QueueRedraw();
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed("mapview_drawmap"))
            {
                RemoveBigCell();
                InitMap();
            }
            base._UnhandledInput(@event);
        }

        /// <summary>
        /// 测试用地图-待地图编辑器写好后修改,祝福注释-大地图绘制的逻辑还没完成
        /// </summary>
        public void InitMap()
        {
            Log.Print("绘制地图");
            layer_dict = bigMapGenerate.GenerateMap(gameCamera.canvasLayer.noise, gameCamera.canvasLayer.Size);
            foreach (var Layer in layer_dict)
            {
                Hex[,] map = Layer.Value;//每层
                if (Layer.Key >= tilemap.GetLayersCount())
                {
                    for (int i = tilemap.GetLayersCount(); i <= Layer.Key; i++)
                    {
                        tilemap.AddLayer(i);
                    }
                }
                for (int i = 0; i < map.GetLength(0); i++)
                {
                    for (int j = 0; j < map.GetLength(1); j++)
                    {
                        Vector2I pos = new Vector2I(i, j);
                        if (copyBaseDict.ContainsKey(pos))//是关卡
                        {
                            ChapterCopyBase chapter = copyBaseDict[pos];
                            BigMapMaterial bigcellMaterial = new BigMapMaterial(chapter.NodeId);
                            tilemap.SetCell(Layer.Key, pos, bigcellMaterial.ImageSetId, LoadTileSetConfig.GetImageIndex_TO_Vector2(bigcellMaterial.ImageSetId, bigcellMaterial.ImageSetIndex));
                            AddBigCell(map[i, j], pos, true);
                        }
                        else
                        {
                            tilemap.SetCell(Layer.Key, pos, map[i, j].MapImageId, LoadTileSetConfig.GetImageIndex_TO_Vector2(map[i, j].MapImageId, map[i, j].MapImageIndex));
                            AddBigCell(map[i, j], pos, false);
                        }
                    }
                }
            }
        }

        /// <summary>
        /// 添加节点
        /// </summary>
        /// <param name="hex"></param>
        /// <param name="pos"></param>
        public void AddBigCell(Hex hex, Vector2I pos, bool IsCopy)
        {
            if (IsCopy)
            {
                ChapterCopyBase chapter = copyBaseDict[pos];
                BigCell bigCell = new BigCell(chapter.NodeId, pos, chapter);
                bigCell.Position = tilemap.MapToLocal(pos);
                bigCell.SetLable("cell_x:" + pos.X + ",cell_y:" + pos.Y);
                BigCellList.AddChild(bigCell);
            }
            else
            {
                BigCell bigCell = new BigCell(hex.index, pos);
                bigCell.Position = tilemap.MapToLocal(pos);
                bigCell.SetLable("cell_x:" + pos.X + ",cell_y:" + pos.Y);
                BigCellList.AddChild(bigCell);
            }
        }
        public void RemoveBigCell()
        {
            for (int i = BigCellList.GetChildCount() - 1; i >= 0; i--)
            {
                Node child = BigCellList.GetChild(i);
                BigCellList.RemoveChild(child);
                // 由于RemoveChild也会从场景树中移除子节点，所以不需要显式调用QueueFree()
                // child.QueueFree();
            }
        }
    }

    /// <summary>
    /// 立方体坐标
    /// </summary>
    public struct Hex
    {
        public int q;
        public int r;
        public int s;
        public int index;//材料序号
        public int MapImageId;//图像集序号，MapImageSet中CfgDataList的序号
        public int MapImageIndex;//图集内序号
        public Hex(int q, int r, int s, int index, int MapImageId, int MapImageIndex)
        {
            this.q = q;
            this.r = r;
            this.s = s;
            this.index = index;
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
            if (q + r + s != 0) throw new ArgumentException("位置错误！q:" + q + ",r:" + r + ",s:" + s);
        }

        public Hex(Vector3I pos, int index, int MapImageId, int MapImageIndex)
        {
            this.q = pos.X;
            this.r = pos.Y;
            this.s = pos.Z;
            this.index = index;
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
            if (q + r + s != 0) throw new ArgumentException("位置错误！q:" + q + ",r:" + r + ",s:" + s);
        }
        public Hex(Vector3I pos)
        {
            this.q = pos.X;
            this.r = pos.Y;
            this.s = pos.Z;
            this.index = 0;
            this.MapImageId = 0;
            this.MapImageIndex = 0;
            if (q + r + s != 0) throw new ArgumentException("位置错误！q:" + q + ",r:" + r + ",s:" + s);
        }
        public Hex(int index, int MapImageId, int MapImageIndex)
        {
            this.q = 0;
            this.r = 0;
            this.s = 0;
            this.index = index;
            this.MapImageId = MapImageId;
            this.MapImageIndex = MapImageIndex;
            if (q + r + s != 0) throw new ArgumentException("位置错误！q:" + q + ",r:" + r + ",s:" + s);
        }

        public static bool operator ==(Hex c1, Hex c2)
        {
            return c1.index == c2.index && c1.MapImageId == c2.MapImageId && c1.MapImageIndex == c2.MapImageIndex;
        }

        public static bool operator !=(Hex c1, Hex c2)
        {
            return !(c1 == c2);
        }

        public override bool Equals(object obj)
        {
            Hex other = (Hex)obj;
            return other.q == q && other.r == r && other.s == s && other.index == index && other.MapImageId == MapImageId && other.MapImageIndex == MapImageIndex;
        }

        //坐标相加
        public Hex Add(Hex b)
        {
            return new Hex(q + b.q, r + b.r, s + b.s, b.index, b.MapImageId, b.MapImageIndex);
        }

        //相减
        public Hex Subtract(Hex b)
        {
            return new Hex(q - b.q, r - b.r, s - b.s, b.index, b.MapImageId, b.MapImageIndex);
        }

        //缩放，整数
        public Hex Scale(int k)
        {
            return new Hex(q * k, r * k, s * k, index, MapImageId, MapImageIndex);
        }

        //左旋转
        public Hex RotateLeft()
        {
            return new Hex(-s, -q, -r, index, MapImageId, MapImageIndex);
        }
        //右旋运算
        public Hex RotateRight()
        {
            return new Hex(-r, -s, -q, index, MapImageId, MapImageIndex);
        }

        static public List<Hex> directions = new List<Hex> { new Hex(1, 0, -1,0,0,0), new Hex(1, -1, 0,0,0,0), new Hex(0, -1, 1,0,0,0),
        new Hex(-1, 0, 1,0,0,0), new Hex(-1, 1, 0,0,0,0), new Hex(0, 1, -1,0,0,0) };
        //方向向量
        static public Hex Direction(int direction)
        {
            return Hex.directions[direction];
        }
        //邻居查询
        public Hex Neighbor(int direction)
        {
            return Add(Hex.Direction(direction));
        }

        static public List<Hex> diagonals = new List<Hex> { new Hex(2, -1, -1,0,0,0), new Hex(1, -2, 1,0,0,0), new Hex(-1, -1, 2,0,0,0),
        new Hex(-2, 1, 1,0,0,0), new Hex(-1, 2, -1,0,0,0), new Hex(1, 1, -2,0,0,0) };
        //对角邻居查询
        public Hex DiagonalNeighbor(int direction)
        {
            return Add(Hex.diagonals[direction]);
        }

        //长度计算
        public int Length()
        {
            return (int)((Math.Abs(q) + Math.Abs(r) + Math.Abs(s)) / 2);
        }

        //距离计算
        public int Distance(Hex b)
        {
            return Subtract(b).Length();
        }

        //转换为偏移坐标系
        public Vector2I Offset(Hex hex)
        {
            return new Vector2I(q, r + (q + (q & 1)) / 2);
        }

        public override string ToString()
        {
            return $"q: {q}, r: {r}, s: {s}, index: {index}, MapImageId: {MapImageId}, MapImageIndex: {MapImageIndex}";
        }
    }

    /// <summary>
    /// 更精确的立方体坐标，用于计算
    /// </summary>
    struct FractionalHex
    {
        public FractionalHex(double q, double r, double s)
        {
            this.q = q;
            this.r = r;
            this.s = s;
            if (Math.Round(q + r + s) != 0) throw new ArgumentException("q + r + s must be 0");
        }
        public readonly double q;
        public readonly double r;
        public readonly double s;

        public Hex HexRound()
        {
            int qi = (int)(Math.Round(q));
            int ri = (int)(Math.Round(r));
            int si = (int)(Math.Round(s));
            double q_diff = Math.Abs(qi - q);
            double r_diff = Math.Abs(ri - r);
            double s_diff = Math.Abs(si - s);
            if (q_diff > r_diff && q_diff > s_diff)
            {
                qi = -ri - si;
            }
            else
                if (r_diff > s_diff)
            {
                ri = -qi - si;
            }
            else
            {
                si = -qi - ri;
            }
            return new Hex(qi, ri, si);
        }


        public FractionalHex HexLerp(FractionalHex b, double t)
        {
            return new FractionalHex(q * (1.0 - t) + b.q * t, r * (1.0 - t) + b.r * t, s * (1.0 - t) + b.s * t);
        }


        static public List<Hex> HexLinedraw(Hex a, Hex b)
        {
            int N = a.Distance(b);
            FractionalHex a_nudge = new FractionalHex(a.q + 1e-06, a.r + 1e-06, a.s - 2e-06);
            FractionalHex b_nudge = new FractionalHex(b.q + 1e-06, b.r + 1e-06, b.s - 2e-06);
            List<Hex> results = new List<Hex> { };
            double step = 1.0 / Math.Max(N, 1);
            for (int i = 0; i <= N; i++)
            {
                results.Add(a_nudge.HexLerp(b_nudge, step * i).HexRound());
            }
            return results;
        }
    }


}