using GameLog;
using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
	public enum SubBuildListType
	{
		/// <summary>
		/// 没有选择，的默认情况
		/// </summary>
		NoSelect = 0,
		/// <summary>
		/// 选择1，采集
		/// </summary>
		Select1 = 1,
		/// <summary>
		/// 选择2，武器
		/// </summary>
		Select2 = 2,
		/// <summary>
		/// 选择3，防御
		/// </summary>
		Select3 = 3,
		/// <summary>
		/// 选择4，辅助
		/// </summary>
		Select4 = 4
	}
	/// <summary>
	/// 建筑列表
	/// </summary>
	public partial class SubBuildList : Node2D
	{
		AnimationPlayer animationPlayer;
		TextureButton button1;
		TextureButton button2;
		Node2D node2D;
		/// <summary>
		/// 高亮
		/// </summary>
		public TextureRect highLight;
		/// <summary>
		/// 每一页多少项
		/// </summary>
		[Export] public int ItemCount = 8;
		/// <summary>
		/// 建造项所在zindex
		/// </summary>
		[Export] public int PngZIndex = 1000;
		[Export] public int space = 4;
		[Export] public Vector2 DefineXY = new Vector2(0, 0);

		/// <summary>
		/// 章节id
		/// </summary>
		public int ChapterId;
		/// <summary>
		/// 关卡id
		/// </summary>
		public int CopyId;
		/// <summary>
		/// 当前选中项，-1为不选中
		/// </summary>
		public int SelectIndex;
		/// <summary>
		/// 当前选中的建筑项,没有选中的情况下是null
		/// </summary>
		public MapBuildItem SelectItem;

		/// <summary>
		/// 建造限制
		/// </summary>
		public CopyBuildLimit copyBuildLimit;
		/// <summary>
		/// 建造项字典<标签id,<每一页的建筑项>>
		/// </summary>
		public Dictionary<int, Dictionary<int, List<MapBuildItem>>> PageBuildDict = new Dictionary<int, Dictionary<int, List<MapBuildItem>>>();
		/// <summary>
		/// 动画是否在播放
		/// </summary>
		public bool IsAnima = false;
		/// <summary>
		/// 当前动画状态-false是关闭,true是开启
		/// </summary>
		public bool AnimaType = false;
		/// <summary>
		/// 默认为无选择状态
		/// </summary>
		public SubBuildListType type = SubBuildListType.NoSelect;

		/// <summary>
		/// 当前页数
		/// </summary>
		public int NowPage = 1;
		/// <summary>
		/// 最多 多少页
		/// </summary>
		public Dictionary<int, int> MaxPageDict = new Dictionary<int, int>();


		/// <summary>
		/// 建筑项图
		/// </summary>
		public List<TextureButton> textureList = new List<TextureButton>();
		/// <summary>
		/// 格子图
		/// </summary>
		public List<TextureButton> textureButtons = new List<TextureButton>();
		public override void _Ready()
		{
			animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
			animationPlayer.AnimationFinished += AnimationPlayer_AnimationFinished;
			button1 = GetNode<TextureButton>("Node2D/上一页");
			button1.ButtonDown += Button1_ButtonDown;
			button2 = GetNode<TextureButton>("Node2D/下一页");
			button2.ButtonDown += Button2_ButtonDown;
			node2D = GetNode<Node2D>("Node2D");
			highLight = GetNode<TextureRect>("Node2D/次级列表高亮");

			for (int i = 0; i < ItemCount; i++)
			{
				TextureButton textButton = GetNode<TextureButton>("Node2D/TextureButton" + i);
				int current = i; // 创建局部变量- 选择的项的index
				textButton.ButtonDown += () =>
				{
					SetHighLight(current);
				};
				textureButtons.Add(textButton);
			}
			InitData();
		}

		/// <summary>
		/// 初始化数据
		/// </summary>
		public void InitData()
		{
			ChapterId = MapCopy.Instance.copyData.ChapterId;//祝福注释-
			CopyId = MapCopy.Instance.copyData.CopyId;
			//ChapterId = 1;
			//CopyId = 1;
			copyBuildLimit = ConfigCache.GetCopyBuildLimit(ChapterId + "_" + CopyId);
			//<标签id,建筑项列表>
			Dictionary<int, List<MapBuildItem>> buildDict = new Dictionary<int, List<MapBuildItem>>();
			if (copyBuildLimit.IsChallenge)//是挑战关卡
			{
				foreach (int itemId in copyBuildLimit.LimitBuildItemIdList)
				{
					MapBuildItem item = ConfigCache.GetMapBuildItem(itemId);
					if (buildDict.ContainsKey(item.BuildLableId))
						buildDict[item.BuildLableId].Add(item);
					else
					{
						buildDict[item.BuildLableId] = [item];
					}
				}
			}
			else//不是挑战关卡
			{
				//当前解锁的科技id
				List<int> ScienceIdList = SaveLoadSystem.NowSaveData.ScienceIdList;
				List<MapBuildItem> buildItemList = ConfigCache.GetAllMapBuildItem()
					.FindAll((MapBuildItem item) => { return !item.IsNeedScience; });//所有不需要科技的建造项
				foreach (int ScienceId in ScienceIdList)
				{
					ScienceData scienceData = ConfigCache.GetScienceData(ScienceId);
					foreach (int id in scienceData.MapBuildIDList)
					{
						if (buildItemList.Find((MapBuildItem item) => { return item.BuildItemId == id; }) == null)
							buildItemList.Add(ConfigCache.GetMapBuildItem(id));
					}
				}
				foreach (MapBuildItem mapitem in buildItemList)
				{
					if (buildDict.ContainsKey(mapitem.BuildLableId))
						buildDict[mapitem.BuildLableId].Add(mapitem);
					else
					{
						buildDict[mapitem.BuildLableId] = [mapitem];
					}
				}
			}

			//这里进行数据分页
			foreach (var item in buildDict)
			{
				//<页数,建筑项>
				Dictionary<int, List<MapBuildItem>> keys = new Dictionary<int, List<MapBuildItem>>();
				List<MapBuildItem> mapBuilds = item.Value;
				int pagemax = mapBuilds.Count / ItemCount + 1;//多少页
				for (int i = 0; i < mapBuilds.Count; i++)
				{
					int page_index = i / ItemCount + 1;//第几页
					if (keys.ContainsKey(page_index))
					{
						keys[page_index].Add(mapBuilds[i]);
					}
					else
					{
						keys[page_index] = [mapBuilds[i]];
					}
				}
				MaxPageDict[item.Key] = pagemax;
				PageBuildDict[item.Key] = keys;
			}


		}

		/// <summary>
		/// 上一页
		/// </summary>
		private void Button1_ButtonDown()
		{
			if (NowPage > 1)
			{
				SetHighLight(-1);
				SetPageView(NowPage - 1);
			}
		}

		/// <summary>
		/// 下一页
		/// </summary>
		private void Button2_ButtonDown()
		{
			if (NowPage < MaxPageDict[(int)type])
			{
				SetHighLight(-1);
				SetPageView(NowPage + 1);
			}
		}

		/// <summary>
		/// 动画播放结束
		/// </summary>
		/// <param name="animName"></param>
		private void AnimationPlayer_AnimationFinished(StringName animName)
		{
			IsAnima = false;
			if (animName == "打开")
				AnimaType = true;
			else
				AnimaType = false;
		}

		/// <summary>
		/// 设置子列表是否开启
		/// </summary>
		/// <param name="IsStart">开启还是关闭</param>
		/// <param name="type">标签类型</param>
		public void SetView(bool IsStart, SubBuildListType label_type)
		{
			if (this.type != SubBuildListType.NoSelect)
			{
				if (AnimaType)//动画是开着的状态并且 旧状态和新状态不同
				{
					if (this.type != label_type)//直接切换图片
					{
						this.type = label_type;
						SetPageView(1);
						SetHighLight(-1);
					}
					else//是当前状态,就运行-关闭或开启动画
					{
						this.type = label_type;
						if (IsStart)
							animationPlayer.Play("打开");
						else
						{
							animationPlayer.Play("关闭");
							SetHighLight(-1);
						}
						IsAnima = true;
					}
				}
				else
				{
					this.type = label_type;
					SetPageView(1);
					animationPlayer.Play("打开");
					IsAnima = true;
				}
			}
			else//原本是默认选择的情况，需要加图然后，开启动画
			{
				this.type = label_type;
				SetPageView(1);
				if (IsStart)
					animationPlayer.Play("打开");
				else
				{
					animationPlayer.Play("关闭");
					SetHighLight(-1);
				}
				IsAnima = true;
			}
		}


		public override void _PhysicsProcess(double delta)
		{
		}

		/// <summary>
		/// 设置一页的数据，先清空再设置
		/// </summary>
		public void SetPageView(int nowPage)
		{
			NowPage = nowPage;//当前页设置为1
			for (int i = 0; i < textureList.Count; i++)
			{
				textureList[i].Free();
			}
			textureList.Clear();
			AddSprite();
		}


		/// <summary>
		/// 设置高亮，并且如果为-1就移除当前选择的建造项，并去掉高亮wa
		/// </summary>
		/// <param name="SelectIndex">当前选中项，-1为不选中</param>
		public void SetHighLight(int SelectIndex)
		{
			if (SelectIndex >= 0)
			{
				this.SelectIndex = SelectIndex;//当前选中
				List<MapBuildItem> itemList = PageBuildDict[(int)type][NowPage];
				if (itemList.Count > SelectIndex)
				{
					SelectItem = itemList[SelectIndex];
					highLight.Position = textureButtons[SelectIndex].Position;
					highLight.Visible = true;
					MapOpView.Instance.buildOpList.buildInfoView.SetView(SelectItem);
					MapCopy.Instance.fixedTileMap.SelectItem(SelectItem);
				}
			}
			else
			{
				this.SelectIndex = -1;
				SelectItem = null;
				highLight.Visible = false;
				MapOpView.Instance.buildOpList.buildInfoView.SetView(SelectItem);
				MapCopy.Instance.fixedTileMap.SelectItem(SelectItem);
			}
		}

		/// <summary>
		/// 格子图片添加
		/// </summary>
		public void AddSprite()
		{
			if (PageBuildDict.ContainsKey((int)type))
			{
				if (PageBuildDict[(int)type].ContainsKey(NowPage))
				{
					List<MapBuildItem> itemList = PageBuildDict[(int)type][NowPage];
					for (int i = 0; i < itemList.Count; i++)
					{
						TextureButton sprite2D = new TextureButton();
						sprite2D.MouseFilter = Control.MouseFilterEnum.Pass;
						sprite2D.TextureNormal = itemList[i].LablePng;
						sprite2D.Position = DefineXY;
						sprite2D.TextureFilter = TextureFilterEnum.Nearest;
						sprite2D.ZIndex = PngZIndex;
						sprite2D.Scale = new Vector2(1f, 1f);
						textureList.Add(sprite2D);
						textureButtons[i].AddChild(sprite2D);
					}
				}
			}
		}


	}
}
