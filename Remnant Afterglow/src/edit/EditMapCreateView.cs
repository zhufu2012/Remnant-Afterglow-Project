using Godot;
using System;
namespace Remnant_Afterglow_EditMap
{
    public partial class EditMapCreateView : Control
    {
        //返还上一个界面
        public Button ReturnButton;
        public override void _Ready()
        {
            ReturnButton = GetNode<Button>("ReturnButton");
            ReturnButton.ButtonDown += ReturnView;
        }
        /// <summary>
        /// 返回上一个界面
        /// </summary>
        public void ReturnView()
        {
            SceneManager.ChangeSceneBackward(this);
        }

        //创建地图
        public void CreateMap(string mapName)
        {

        }

        //进入地图编辑器-编辑地图
        public void EditMap()
        {
            int mapType = 1;
            MapDrawData = new MapDrawData();
            string Path = "";
            SceneManager.PutParam("MapType", );//地图类型
            SceneManager.PutParam("MapData", MapDrawData);//地图数据
            SceneManager.PutParam("MapDataPath", Path);//地图数据路径
            SceneManager.ChangeSceneName("EditMapView", this);//跳转地图编辑器界面
        }
    }
}
