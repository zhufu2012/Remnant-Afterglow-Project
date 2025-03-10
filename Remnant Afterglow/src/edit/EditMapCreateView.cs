using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;
using System.IO;
namespace Remnant_Afterglow_EditMap
{
	public partial class EditMapCreateView : Control
	{
		/// <summary>
		/// 返还上一个界面
		/// </summary>
		public Button ReturnButton;
		#region 作战地图


		public Button CreateMapBut;
		public Button EditMapBut;

		public ItemList mapItemList;

		public LineEdit editName;
		public LineEdit editWidth;
		public LineEdit editHeight;


		/// <summary>
		/// 初始化界面数据
		/// </summary>
		public void InitViewMap()
		{
			ReturnButton = GetNode<Button>("Panel/ReturnButton");
			ReturnButton.ButtonDown += ReturnView;
			CreateMapBut = GetNode<Button>("Panel/CreateMapBut");
			CreateMapBut.ButtonDown += CreateMap;
			EditMapBut = GetNode<Button>("Panel/EditMapBut");
			EditMapBut.ButtonDown += EditMap;

			editName = GetNode<LineEdit>("Panel/EditMapName");
			editWidth = GetNode<LineEdit>("Panel/EditMapWidth");
			editHeight = GetNode<LineEdit>("Panel/EditMapHeight");
			mapItemList = GetNode<ItemList>("Panel/MapItemList");
			mapItemList.ItemSelected += MapItemList_ItemSelected;
		}

		private void MapItemList_ItemSelected(long index)
		{
			if (mapItemList.IsAnythingSelected())//有选中
			{
				EditMapBut.Disabled = false;
			}
			else
			{
				EditMapBut.Disabled = true;
			}
		}


		public void InitDataMap()
		{
			string mapPath = PathConstant.GetPathUser(EditConstant.Map_Path);//作战地图文件夹路径
			if (!Directory.Exists(mapPath))//没有对应存档文件夹
			{
				Directory.CreateDirectory(mapPath);//创建存档文件夹
			}
			List<string> mapListPath = FolderUtils.GetFilesInFolder(mapPath, false, "*" + PathConstant.GetPathUser(EditConstant.Map_FileSuffix));
			foreach (string file in mapListPath)
			{
				string fileName = FileUtils.GetFileName(file);
				mapItemList.AddItem(fileName);
			}
		}

		/// <summary>
		/// 创建地图
		/// </summary>
		public void CreateMap()
		{
			string mapName = editName.Text;
			if (mapName.Length > 0)
			{
				//地图横轴
				int mapWidth = int.Parse(editWidth.Text);
				//地图纵轴
				int mapHeight = int.Parse(editHeight.Text);
				MapDrawData mapDrawData = new MapDrawData(mapName, mapWidth, mapHeight);
				mapDrawData.SaveData(PathConstant.GetPathUser(EditConstant.Map_Path), mapName +PathConstant.GetPathUser(EditConstant.Map_FileSuffix));
				mapDrawData.Decompression();
				int index = mapItemList.AddItem(mapName+PathConstant.GetPathUser(EditConstant.Map_FileSuffix));
				//设置地图路径
				mapItemList.SetItemMetadata(index, mapName + PathConstant.GetPathUser(EditConstant.Map_FileSuffix));
				editName.Text = "";
				editWidth.Text = "";
				editHeight.Text = "";
			}
			else
			{



			}
		}


		/// <summary>
		/// 进入地图编辑器-编辑地图
		/// </summary>
		public void EditMap()
		{
			if (mapItemList.IsAnythingSelected())//有选中项
			{
				var selectedItems = mapItemList.GetSelectedItems();//选择的项
				string mapName = mapItemList.GetItemText(selectedItems[0]);
				EnterMapEdit(mapName);
			}
		}

		/// <summary>
		/// 进入地图
		/// </summary>
		/// <param name="mapName"></param>
		public void EnterMapEdit(string mapName)
		{
			SceneManager.PutParam("MapType", EditConstant.MapType);//地图类型
			SceneManager.PutParam("MapDataPath", PathConstant.GetPathUser(EditConstant.Map_Path));//地图数据路径
			SceneManager.PutParam("MapName", mapName);//地图名称
			SceneManager.ChangeSceneName("EditMapView", this);//跳转地图编辑器界面
		}
		#endregion

		#region 模板地图


		public Button CreateTempMapBut;
		public Button EditTempMapBut;

		public ItemList tempMapItemList;

		public LineEdit tempEditName;
		public LineEdit tempEditWidth;
		public LineEdit tempEditHeight;


		/// <summary>
		/// 初始化界面数据
		/// </summary>
		public void InitViewTempMap()
		{
			CreateTempMapBut = GetNode<Button>("Panel2/CreateMapBut");
			CreateTempMapBut.ButtonDown += CreateTempMap;
			EditTempMapBut = GetNode<Button>("Panel2/EditMapBut");
			EditTempMapBut.ButtonDown += EditTempMap;

			tempEditName = GetNode<LineEdit>("Panel2/EditMapName");
			tempEditWidth = GetNode<LineEdit>("Panel2/EditMapWidth");
			tempEditHeight = GetNode<LineEdit>("Panel2/EditMapHeight");
			tempMapItemList = GetNode<ItemList>("Panel2/MapItemList");
			tempMapItemList.ItemSelected += TempMapItemList_ItemSelected;
		}

		private void TempMapItemList_ItemSelected(long index)
		{
			if (tempMapItemList.IsAnythingSelected())//有选中
			{
				EditTempMapBut.Disabled = false;
			}
			else
			{
				EditTempMapBut.Disabled = true;
			}
		}


		public void InitDataTempMap()
		{
			string mapPath = PathConstant.GetPathUser(EditConstant.TempMap_Path);//作战地图文件夹路径
			if (!Directory.Exists(mapPath))//没有对应存档文件夹
			{
				Directory.CreateDirectory(mapPath);//创建存档文件夹
			}
			List<string> mapListPath = FolderUtils.GetFilesInFolder(mapPath, false, "*" + PathConstant.GetPathUser(EditConstant.TempMap_FileSuffix));
			foreach (string file in mapListPath)
			{
				string fileName = FileUtils.GetFileName(file);
				tempMapItemList.AddItem(fileName);
			}
		}

		/// <summary>
		/// 创建地图
		/// </summary>
		public void CreateTempMap()
		{
			string mapName = tempEditName.Text;
			if (mapName.Length > 0)
			{
				//地图横轴
				int mapWidth = int.Parse(tempEditWidth.Text);
				//地图纵轴
				int mapHeight = int.Parse(tempEditHeight.Text);
				MapDrawData mapDrawData = new MapDrawData(mapName, mapWidth, mapHeight);
				mapDrawData.SaveData(PathConstant.GetPathUser(EditConstant.TempMap_Path), mapName + PathConstant.GetPathUser(EditConstant.TempMap_FileSuffix));
				mapDrawData.Decompression();
				int index = tempMapItemList.AddItem(mapName + PathConstant.GetPathUser(EditConstant.TempMap_FileSuffix));
				//设置地图路径
				tempMapItemList.SetItemMetadata(index, mapName + PathConstant.GetPathUser(EditConstant.TempMap_FileSuffix));
				tempEditName.Text = "";
				tempEditWidth.Text = "";
				tempEditHeight.Text = "";
			}
			else
			{



			}
		}


		/// <summary>
		/// 进入地图编辑器-编辑地图
		/// </summary>
		public void EditTempMap()
		{
			if (tempMapItemList.IsAnythingSelected())//有选中项
			{
				var selectedItems = tempMapItemList.GetSelectedItems();//选择的项
				string mapName = tempMapItemList.GetItemText(selectedItems[0]);
				EnterTempMapEdit(mapName);
			}
		}

		/// <summary>
		/// 进入地图模板
		/// </summary>
		/// <param name="mapName"></param>
		public void EnterTempMapEdit(string mapName)
		{
			SceneManager.PutParam("MapType", EditConstant.TempMapType);//地图类型
			SceneManager.PutParam("MapDataPath", PathConstant.GetPathUser(EditConstant.TempMap_Path));//地图数据路径
			SceneManager.PutParam("MapName", mapName);//地图名称
			SceneManager.ChangeSceneName("EditMapView", this);//跳转地图编辑器界面
		}
		#endregion


		#region 大地图


		public Button CreateBigMapBut;
		public Button EditBigMapBut;

		public ItemList bigMapItemList;

		public LineEdit bigEditName;
		public LineEdit bigEditWidth;
		public LineEdit bigEditHeight;



		/// <summary>
		/// 初始化界面数据
		/// </summary>
		public void InitViewBigMap()
		{
			CreateBigMapBut = GetNode<Button>("Panel3/CreateMapBut");
			CreateBigMapBut.ButtonDown += CreateBigMap;
			EditBigMapBut = GetNode<Button>("Panel3/EditMapBut");
			EditBigMapBut.ButtonDown += EditBigMap;

			bigEditName = GetNode<LineEdit>("Panel3/EditMapName");
			bigEditWidth = GetNode<LineEdit>("Panel3/EditMapWidth");
			bigEditHeight = GetNode<LineEdit>("Panel3/EditMapHeight");
			bigMapItemList = GetNode<ItemList>("Panel3/MapItemList");
			bigMapItemList.ItemSelected += BigMapItemList_ItemSelected;
		}


		private void BigMapItemList_ItemSelected(long index)
		{
			if (bigMapItemList.IsAnythingSelected())
			{
				EditBigMapBut.Disabled = false;
			}
			else
			{
				EditBigMapBut.Disabled = true;
			}
		}


		public void InitDataBigMap()
		{
			string bigMapPath = PathConstant.GetPathUser(EditConstant.BigMap_Path);//作战地图文件夹路径
			if (!Directory.Exists(bigMapPath))//没有对应存档文件夹
			{
				Directory.CreateDirectory(bigMapPath);//创建存档文件夹
			}
			List<string> bigMapListPath = FolderUtils.GetFilesInFolder(bigMapPath, false, "*" + PathConstant.GetPathUser(EditConstant.BigMap_FileSuffix));
			foreach (string file in bigMapListPath)
			{
			   string fileName= FileUtils.GetFileName(file);
			   bigMapItemList.AddItem(fileName);
			}
		}

		/// <summary>
		/// 创建地图
		/// </summary>
		public void CreateBigMap()
		{
			string mapName = bigEditName.Text;
			if (mapName.Length > 0)
			{
				//地图横轴
				int mapWidth = int.Parse(bigEditWidth.Text);
				//地图纵轴
				int mapHeight = int.Parse(bigEditHeight.Text);
				BigMapDrawData bigMapDrawData = new BigMapDrawData(mapName, mapWidth, mapHeight);
				bigMapDrawData.SaveData(PathConstant.GetPathUser(EditConstant.BigMap_Path), mapName);
				int index = bigMapItemList.AddItem(mapName);
				//设置地图路径
				bigMapItemList.SetItemMetadata(index, mapName + PathConstant.GetPathUser(EditConstant.BigMap_FileSuffix));
				bigEditName.Text = "";
				bigEditWidth.Text = "";
				bigEditHeight.Text = "";
			}
			else
			{
			}
		}

		/// <summary>
		/// 进入地图编辑器-编辑地图
		/// </summary>
		public void EditBigMap(string bigMapName)
		{
			//MapDrawData mapDrawData = new MapDrawData();
			if (bigMapItemList.IsAnythingSelected())//有选中项
			{
				var selectedItems = bigMapItemList.GetSelectedItems();//选择的项
				string mapName = bigMapItemList.GetItemText(selectedItems[0]);
				EnterMapEdit(mapName);
			}

		}

		/// <summary>
		/// 进入地图编辑器-编辑地图
		/// </summary>
		public void EditBigMap()
		{
			if (bigMapItemList.IsAnythingSelected())//有选中项
			{
				var selectedItems = bigMapItemList.GetSelectedItems();//选择的项
				string mapName = bigMapItemList.GetItemText(selectedItems[0]);
				EnterBigMapEdit(mapName);
			}
		}
		public void EnterBigMapEdit(string mapName)
		{
			SceneManager.PutParam("MapType", EditConstant.BigMapType);//地图类型
			SceneManager.PutParam("MapDataPath", PathConstant.GetPathUser(EditConstant.BigMap_Path));//地图数据路径
			SceneManager.PutParam("MapName", mapName);//地图数据路径
			SceneManager.ChangeSceneName("EditBigMapView", this);//跳转地图编辑器界面
		}
		#endregion

		public override void _Ready()
		{
			InitViewMap();
			InitViewTempMap();
			InitViewBigMap();

			InitDataMap();
			InitDataTempMap();
			InitDataBigMap();
		}

		/// <summary>
		/// 返回上一个界面
		/// </summary>
		public void ReturnView()
		{
			SceneManager.ChangeSceneBackward(this);
		}
	}
}
