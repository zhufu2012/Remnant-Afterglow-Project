using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
	/// <summary>
	/// 建造子项列表
	/// </summary>
	public partial class BuildItemList : Control
	{
		public MapBuildLable data;

		public ScrollContainer buildItemList;
		public HBoxContainer hBoxContainer;


		/// <summary>
		/// 所有建造子项
		/// </summary>
		public List<MapBuildItem> ItemList = new List<MapBuildItem>();


		/// <summary>
		/// 格子间衔接图
		/// </summary>
		public Texture2D Map_ItemView_Img_2;

		/// <summary>
		/// 建筑格子图
		/// </summary>
		public Texture2D Map_BuildListSubView_1;

		/// <summary>
		/// 无建筑格子图
		/// </summary>
		public Texture2D Map_BuildListSubView_2;

		/// <summary>
		/// 建筑子列表左支架
		/// </summary>
		public Texture2D Map_BuildList_3;
		/// <summary>
		/// 建筑子列表右支架
		/// </summary>
		public Texture2D Map_BuildList_4;

		public TextureRect ImgList1;
		public TextureRect ImgList2;

		/// <summary>
		/// 项数
		/// </summary>
		[Export]
		public int ItemNum = 0;
		public void InitData(MapBuildLable data)
		{
			this.data = data;
			if (data == null)
			{
				ItemNum = 0;
			}
			else
			{
				List<Dictionary<string, object>> list = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_MapBuildItem,
new Dictionary<string, object> { { "BuildLableId", data.BuildLableId } });
				foreach (Dictionary<string, object> dict in list)
				{
					ItemList.Add(new MapBuildItem(dict));
				}
				ItemNum = ItemList.Count;
			}


		}

		public override void _Ready()
		{
			InitView();
		}


		/// <summary>
		/// 初始化
		/// </summary>
		public void InitView()
		{
			hBoxContainer = GetNode<HBoxContainer>("BuildItemList/HBoxContainer");
			buildItemList = GetNode<ScrollContainer>("BuildItemList");
			ImgList1 = GetNode<TextureRect>("TextureRect");
			ImgList2 = GetNode<TextureRect>("TextureRect2");

			Map_ItemView_Img_2 = ConfigCache.GetGlobal_Png("Map_ItemView_Img_2");
			Map_BuildListSubView_1 = ConfigCache.GetGlobal_Png("Map_BuildListSubView_1");
			Map_BuildListSubView_2 = ConfigCache.GetGlobal_Png("Map_BuildListSubView_2");

			Map_BuildList_3 = ConfigCache.GetGlobal_Png("Map_BuildList_3");
			Map_BuildList_4 = ConfigCache.GetGlobal_Png("Map_BuildList_4");

			InitItemNum();
		}


		public void InitItemNum()
		{
			if (ItemNum == 0)
			{
				ImgList1.Texture = Map_BuildList_3;
				ImgList1.GlobalPosition = new Vector2(896, 905);
				ImgList2.Texture = Map_BuildList_4;
				ImgList2.GlobalPosition = new Vector2(1000, 905);
				TextureRect textureRect = new TextureRect();
				textureRect.Texture = Map_BuildListSubView_2;
				buildItemList.GlobalPosition = new Vector2(920, 900);
				hBoxContainer.AddChild(textureRect);
			}
			else
			{
				buildItemList.GlobalPosition = new Vector2(960 - ((ItemNum - 1) * 80 + 40), 900);
				buildItemList.Size = new Vector2(ItemNum * 80, 80);
				for (int i = 0; i < ItemList.Count; i++)
				{
					TextureRect textureRect = new TextureRect();
					textureRect.Texture = ItemList[i].LablePng;
					hBoxContainer.AddChild(textureRect);
				}
			}
		}

	}
}
