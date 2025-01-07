
using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 建造系统-可建造列表-祝福注释-近期必须完成的功能
    /// </summary>
    public partial class ObjectBuildSystem : Control
    {
        /// <summary>
        ///  科技子列表宽度
        /// </summary>
        [Export]
        public int Width = 236;
        /// <summary>
        /// 科技子列表间间隔
        /// </summary>
        [Export]
        public int Space = 1;
        /// <summary>
        /// 高度
        /// </summary>
        [Export]
        public int Height = 78;
        /// <summary>
        /// 建筑标签数
        /// </summary>
        [Export]
        public int BuildCount = 5;


        /// <summary>
        /// 父节点-建造节点-所有在建的都加在这里
        /// </summary>
        public Node2D buildRootNode;
        /// <summary>
        /// 保存所有在建的实体的列表
        /// </summary>
        public List<ObjectBuild> objectBuildList = new List<ObjectBuild>();

        public TextureRect Map_BuildList_1;
        public TextureRect Map_BuildList_2;

        public Panel panel;
        public ScrollContainer scrollContainer;
        public HBoxContainer hBoxContainer;

        /// <summary>
        /// 建造系统-大标签
        /// </summary>
        public List<BuildLableButton> buttonList = new List<BuildLableButton>();

        /// <summary>
        /// 建造子项列表，焦点选中哪个建造项，就显示哪个建造项的建筑
        /// </summary>
        public BuildItemList buildItemList;

        public ObjectBuildSystem()
        {

        }

        public void IniData(Node2D rootNode)
        {
            buildRootNode = rootNode;
            //BuildCount = ConfigCache.GetAllMapBuildLable().Count;//建筑列表项数

        }

        public override void _Ready()
        {
            panel = GetNode<Panel>("Panel");
            panel.Size = new Vector2(78 * 2 + BuildCount * Width + (BuildCount - 1) * Space + 7, Height);
            panel.SetAnchorsPreset(Control.LayoutPreset.Center, true);


            Map_BuildList_1 = GetNode<TextureRect>("Panel/Map_BuildList_1");
            Map_BuildList_2 = GetNode<TextureRect>("Panel/Map_BuildList_2");
            Map_BuildList_1.Texture = ConfigCache.GetGlobal_Png("Map_BuildList_1");
            Map_BuildList_2.Texture = ConfigCache.GetGlobal_Png("Map_BuildList_2");

            hBoxContainer = GetNode<HBoxContainer>("Panel/ScrollContainer/HBoxContainer");
            foreach (MapBuildLable info in ConfigCache.GetAllMapBuildLable())
            {
                BuildLableButton mapBuildLableButton = (BuildLableButton)GD.Load<PackedScene>("res://src/core/game/mapLogic/operation/objectBuildSystem/BuildLableButton.tscn").Instantiate();
                mapBuildLableButton.InitData(info);
                hBoxContainer.AddChild(mapBuildLableButton);
            }
            scrollContainer = GetNode<ScrollContainer>("Panel/ScrollContainer");
            scrollContainer.Size = new Vector2(BuildCount * Width + (BuildCount - 1) * Space + 12, Height);
            scrollContainer.Position = new Vector2(75.5f, 0);
            // 在所有布局设置完成后强制更新整个场景树的布局


            buildItemList = (BuildItemList)GD.Load<PackedScene>("res://src/core/game/mapLogic/operation/objectBuildSystem/BuildItemList.tscn").Instantiate();
            buildItemList.InitData(ConfigCache.GetMapBuildLable("1"));
            AddChild(buildItemList);

        }



    }
}
