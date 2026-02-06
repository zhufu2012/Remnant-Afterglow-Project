using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 大地图的TileMap
	/// </summary>
	public partial class BigTileMap : TileMap
	{
		/// <summary>
		/// 地图图集配置
		/// </summary>
		public LoadTileSetConfig loadTileSetConfig;
		public BigMapGenerate bigMapGenerate;
		public Dictionary<int, Hex[,]> layer_dict = new Dictionary<int, Hex[,]>();


		/// <summary>
		/// 是否显示设置下的各按钮
		/// </summary>
		public bool is_show_setview = false;

		/// <summary>
		/// 章节id
		/// </summary>
		public int ChapterId;
		public ChapterBase chapterBase;
		/// <summary>
		/// 地图大小
		/// </summary>
		public Vector2 Size;
		public BigTileMap(int ChapterId, ChapterBase chapterBase, Vector2 Size)
		{
			this.ChapterId = ChapterId;
			this.chapterBase = chapterBase;
			this.Size = Size;
		}


		public override void _Ready()
		{
			InitView();
			InitMap();//初始化地图
		}

		public void InitView()
		{
			loadTileSetConfig = new LoadTileSetConfig(2);
			TileSet = loadTileSetConfig.GetTileSet();
			bigMapGenerate = new BigMapGenerate(1);//祝福注释-暂时

		}


		/// <summary>
		/// 测试用地图-待地图编辑器写好后修改,祝福注释-大地图绘制的逻辑还没完成
		/// </summary>
		public void InitMap()
		{
			layer_dict = bigMapGenerate.GenerateMap(Size);
			foreach (var Layer in layer_dict)
			{
				Hex[,] map = Layer.Value;//每层
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
						Vector2I pos = new Vector2I(i, j);
						if (BigMapCopy.Instance.copyBaseDict.ContainsKey(pos))//是关卡
						{
							ChapterCopyBase chapter = BigMapCopy.Instance.copyBaseDict[pos];
							BigMapMaterial bigcellMaterial = new BigMapMaterial(chapter.NodeId);
							SetCell(Layer.Key, pos, bigcellMaterial.ImageSetId, LoadTileSetConfig.GetImageIndex_TO_Vector2(bigcellMaterial.ImageSetId, bigcellMaterial.ImageSetIndex));
							AddBigCell(map[i, j], pos, true);
						}
						else
						{
							SetCell(Layer.Key, pos, map[i, j].MapImageId, LoadTileSetConfig.GetImageIndex_TO_Vector2(map[i, j].MapImageId, map[i, j].MapImageIndex));
							AddBigCell(map[i, j], pos, false);
						}
					}
				}
			}
		}

		public override void _UnhandledInput(InputEvent @event)
		{
			if (@event is InputEventMouse mouseEvent)// 检查是否是鼠标事件
			{
				// 检查是否是鼠标左键按下
				if (mouseEvent is InputEventMouseButton mb && mb.ButtonIndex == MouseButton.Left && mb.Pressed)
				{
					Vector2I pos = GetLocalMousePos();//当前选择的位置
					if (BigMapCopy.IsCopy(pos))//当前的位置是否为关卡
					{
						if (WindowManager.Instance._currentWindow == null)
						{
							ChapterCopyBase chapter = BigMapCopy.Instance.copyBaseDict[pos];
							// 关卡选择管理器
							WindowManager.Instance.OpenWindow<CopySelectPanel>(new Dictionary<string, object>
							{
								{ "copy_id", chapter.CopyId },
								{ "chapterCopyBase", chapter }
							});
							MapOpManager.Instance.SetOp();
						}
					}
				}
			}


		}


		/// <summary>
		/// 添加额外节点-祝福注释-大地图这个可以不加
		/// </summary>
		/// <param name="hex"></param>
		/// <param name="pos"></param>
		public void AddBigCell(Hex hex, Vector2I pos, bool IsCopy)
		{
			if (IsCopy)
			{
				ChapterCopyBase chapter = BigMapCopy.Instance.copyBaseDict[pos];
				BigCell bigCell = new BigCell(chapter.NodeId, pos, chapter);
				bigCell.InitData();
				bigCell.Position = MapToLocal(pos);
				BigMapCopy.Instance.BigCellList.AddChild(bigCell);
			}
			else
			{
				BigCell bigCell = new BigCell(hex.index, pos);
				bigCell.InitData();
				bigCell.Position = MapToLocal(pos);
				BigMapCopy.Instance.BigCellList.AddChild(bigCell);
			}
		}

		/// <summary>
		/// 获取鼠标位置在地图中的位置
		/// </summary>
		/// <param name="pos"></param>
		/// <returns></returns>
		public Vector2I GetLocalMousePos()
		{
			return LocalToMap(GetGlobalMousePosition());
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

		/// <summary>
		/// 坐标相加
		/// </summary>
		/// <param name="b"></param>
		/// <returns></returns>
		public Hex Add(Hex b)
		{
			return new Hex(q + b.q, r + b.r, s + b.s, b.index, b.MapImageId, b.MapImageIndex);
		}

		/// <summary>
		/// 相减
		/// </summary>
		/// <param name="b"></param>
		/// <returns></returns>
		public Hex Subtract(Hex b)
		{
			return new Hex(q - b.q, r - b.r, s - b.s, b.index, b.MapImageId, b.MapImageIndex);
		}

		/// <summary>
		/// 缩放，整数
		/// </summary>
		/// <param name="k"></param>
		/// <returns></returns>
		public Hex Scale(int k)
		{
			return new Hex(q * k, r * k, s * k, index, MapImageId, MapImageIndex);
		}

		/// <summary>
		/// 左旋转
		/// </summary>
		/// <returns></returns>
		public Hex RotateLeft()
		{
			return new Hex(-s, -q, -r, index, MapImageId, MapImageIndex);
		}
		/// <summary>
		/// 右旋运算
		/// </summary>
		/// <returns></returns>
		public Hex RotateRight()
		{
			return new Hex(-r, -s, -q, index, MapImageId, MapImageIndex);
		}

		static public List<Hex> directions = new List<Hex> { new Hex(1, 0, -1,0,0,0), new Hex(1, -1, 0,0,0,0), new Hex(0, -1, 1,0,0,0),
		new Hex(-1, 0, 1,0,0,0), new Hex(-1, 1, 0,0,0,0), new Hex(0, 1, -1,0,0,0) };
		/// <summary>
		/// 方向向量
		/// </summary>
		/// <param name="direction"></param>
		/// <returns></returns>
		static public Hex Direction(int direction)
		{
			return Hex.directions[direction];
		}
		/// <summary>
		/// 邻居查询
		/// </summary>
		/// <param name="direction"></param>
		/// <returns></returns>
		public Hex Neighbor(int direction)
		{
			return Add(Hex.Direction(direction));
		}

		static public List<Hex> diagonals = new List<Hex> { new Hex(2, -1, -1,0,0,0), new Hex(1, -2, 1,0,0,0), new Hex(-1, -1, 2,0,0,0),
		new Hex(-2, 1, 1,0,0,0), new Hex(-1, 2, -1,0,0,0), new Hex(1, 1, -2,0,0,0) };
		/// <summary>
		/// 对角邻居查询
		/// </summary>
		/// <param name="direction"></param>
		/// <returns></returns>
		public Hex DiagonalNeighbor(int direction)
		{
			return Add(Hex.diagonals[direction]);
		}

		/// <summary>
		/// 长度计算
		/// </summary>
		/// <returns></returns>
		public int Length()
		{
			return (int)((Math.Abs(q) + Math.Abs(r) + Math.Abs(s)) / 2);
		}

		/// <summary>
		/// 距离计算
		/// </summary>
		/// <param name="b"></param>
		/// <returns></returns>
		public int Distance(Hex b)
		{
			return Subtract(b).Length();
		}

		/// <summary>
		/// 转换为偏移坐标系
		/// </summary>
		/// <param name="hex"></param>
		/// <returns></returns>
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
