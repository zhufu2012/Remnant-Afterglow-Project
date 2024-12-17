using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class BigCell : Node2D
    {
        public int index;//材料序号
        public int MapImageId;//图像集序号，MapImageSet中CfgDataList的序号
        public int MapImageIndex;//图集内序号
        /// <summary>
        /// 位置
        /// </summary>
        public Vector2I pos;
        //区域
        public Area2D Area;
        public CollisionPolygon2D collisionPolygon2D;
        public Label label;

        public BigMapMaterial bigcellMaterial;
        /// <summary>
        /// 关卡基础配置
        /// </summary>
        public ChapterCopyBase chapterCopy;
        /// <summary>
        /// 是否有关卡配置
        /// </summary>
        public bool IsCopy = false;

        /// <summary>
        /// 鼠标是否在节点上
        /// </summary>
        public bool isRange = false;

        public BigCell(int index, Vector2I pos)
        {
            this.index = index;
            this.pos = pos;
            IsCopy = false;
            InitData();
        }
        public BigCell(int index, Vector2I pos, ChapterCopyBase chapterCopy)
        {
            this.index = index;
            this.pos = pos;
            this.chapterCopy = chapterCopy;
            IsCopy = true;//是关卡
            InitData();
        }

        public void InitData()
        {
            bigcellMaterial = new BigMapMaterial(index);
            Area = new Area2D();
            collisionPolygon2D = new CollisionPolygon2D();
            label = new Label();
            label.Text = "测试";
            collisionPolygon2D.Polygon = new Vector2[] {
    new Vector2(0, -MapConstant.BigCellSizeY/2),
    new Vector2(MapConstant.BigCellSizeX/2, -MapConstant.BigCellSizeY/4),
    new Vector2(MapConstant.BigCellSizeX/2, MapConstant.BigCellSizeY/4),
    new Vector2(0, MapConstant.BigCellSizeY/2),
    new Vector2(-MapConstant.BigCellSizeX/2, MapConstant.BigCellSizeY/4),
    new Vector2(-MapConstant.BigCellSizeX/2, -MapConstant.BigCellSizeY/4),
};
            AddChild(Area);
            AddChild(label);
            Area.AddChild(collisionPolygon2D);
            Area.MouseEntered += MouseEntered;
            Area.MouseExited += MouseExited;
        }
        public override void _Process(double delta)
        {

        }

        /// <summary>
        /// 鼠标进入区域
        /// </summary>
        public void MouseEntered()
        {
            Modulate = new Color(0.5f, 0.5f, 1);
            //Log.Print("鼠标进入区域");
            isRange = true;
        }
        /// <summary>
        /// 鼠标离开区域
        /// </summary>
        public void MouseExited()
        {
            Modulate = new Color(1, 1, 1);
            //Log.Print("鼠标离开区域");
            isRange = false;
        }


        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event is InputEventMouse mouseEvent)// 检查是否是鼠标事件
            {
                if (isRange)// 检查鼠标是否在节点上
                {
                    // 检查是否是鼠标左键按下
                    if (mouseEvent is InputEventMouseButton mb && mb.ButtonIndex == MouseButton.Left && mb.Pressed)
                    {

                        if (IsCopy)//是关卡
                        {
                            SceneManager.PutParam("ChapterId", chapterCopy.ChapterId);//章节
                            SceneManager.PutParam("CopyId", chapterCopy.CopyId);//关卡
                            SceneManager.ChangeSceneName("MapCopy", this);
                        }
                        else
                        {

                        }
                    }
                }
            }
        }

        public void SetLable(string str)
        {
            label.Text = str;
        }


    }
}
