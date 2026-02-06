using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 建造预览
    /// </summary>
    public partial class EditTileMap : TileMap
    {
        /// <summary>
        /// 建造预览的颜色
        /// </summary>
        [Export] public Color BuildShowColor = new Color(1, 1, 1, 0.5f);
        /// <summary>
        /// 不可建造的预览颜色
        /// </summary>
        [Export] public Color NoBuildShowColor = new Color(1, 1, 1, 0.5f);
        /// <summary>
        /// 框的颜色
        /// </summary>
        [Export] public Color LineColor = new Color(0.118f, 1, 1, 1);
        /// <summary>
        /// 不可建造时的框的颜色
        /// </summary>
        [Export] public Color NoBuildLineColor = new Color(0.118f, 1, 1, 1);
        /// <summary>
        /// 线宽度
        /// </summary>
        [Export] public int LineWidth = 4;
        /// <summary>
        /// 建筑-炮塔底座
        /// </summary>
        public Sprite2D buildShow;
        /// <summary>
        /// 边框线
        /// </summary>
        public Line2D line2D;
        /// <summary>
        /// 炮塔列表
        /// </summary>
        public List<Sprite2D> weaponList = new List<Sprite2D>();

        /// <summary>
        /// 显示的建筑图片<唯一id,图片>
        /// </summary>
        public Dictionary<int, Sprite2D> showDict = new Dictionary<int, Sprite2D>();

        /// <summary>
        /// 是否有选择建造项
        /// </summary>
        bool IsSelectBuild = false;
        /// <summary>
        /// 是否已添加建造预览
        /// </summary>
        bool IsAddBuildShow = false;
        /// <summary>
        /// 当前选择的建造项
        /// </summary>
        public BuildData buildData;
        /// <summary>
        /// 当前是否可以建造
        /// </summary>
        public bool IsCanBuild = true;

        /// <summary>
        /// 上一个地图位置
        /// </summary>
        public Vector2 NextPos = new Vector2(-1000, -1000);

        /// <summary>
        /// 建筑占地是否为偶数
        /// </summary>
        public bool IsEvenNumber = true;

        /// <summary>
        /// 每帧运行界面
        /// </summary>
        /// <param name="delta"></param>
        public void UpdateView()
        {
            if (IsSelectBuild)//当前有选择建筑项
            {
                if (!IsAddBuildShow)//如果还没添加就添加
                    AddBuildPreview();
                else
                    SetBuildPreviewPos();
            }
            else
            {
                if (buildShow.Visible)
                    buildShow.Visible = false;
            }
        }



        /// <summary>
        /// 更新要绘制的实体
        /// </summary>
        public void UpdataObject()
        {
            if (MouseType == MouseButtonType.Entity)
            {
                buildData = EditMapView.Instance.entitySelectPanel.GetSelectBuildData();
                IsEvenNumber = buildData.BuildingSize % 2 == 0;
                if (buildData != null)
                {
                    IsSelectBuild = true;
                    IsAddBuildShow = false;
                }
            }
            else
            {
                IsSelectBuild = false;
                buildData = null;
                IsAddBuildShow = true;
            }
        }

        /// <summary>
        /// 修改建筑位置
        /// </summary>
        public void SetBuildPreviewPos()
        {
            Vector2 NewPos = EditMapView.Instance.tileMap.GetMouseOffsetPos(IsEvenNumber);
            if (NextPos != NewPos)
            {
                if (buildData.Type == 0)//建筑
                {
                    buildShow.Position = NewPos;
                }
                else
                {
                    buildShow.Position = NewPos;
                }
            }
            NextPos = NewPos;
        }

        /// <summary>
        /// 添加建筑预览
        /// </summary>
        public void AddBuildPreview()
        {
            Vector2 offsetPos = EditMapView.Instance.tileMap.GetMouseOffsetPos(IsEvenNumber);

            // 使用实体渲染器渲染主体
            EntityRenderer.RenderEntity(buildShow, buildData, offsetPos);
            buildShow.Modulate = BuildShowColor;

            // 清理旧武器
            for (int i = 0; i < weaponList.Count; i++)
            {
                weaponList[i].Free();
            }
            weaponList.Clear();

            // 如果是炮塔且有武器，渲染武器
            if (buildData.Type == 1 && buildData.WeaponList.Count > 0)
            {
                weaponList = EntityRenderer.RenderWeapons(buildShow, buildData.WeaponList);
                EntityRenderer.SetEntityColor(buildShow, weaponList, BuildShowColor);
            }

            buildShow.Visible = true;

            // 绘制边框线
            DrawBoundingBox();
            IsAddBuildShow = true;
        }

        /// <summary>
        /// 绘制边界框
        /// </summary>
        private void DrawBoundingBox()
        {
            float size = (float)buildData.BuildingSize / 2;
            Vector2 p1 = new Vector2(-size, -size) * MapConstant.TileCellSize + new Vector2(LineWidth / 2, LineWidth / 2);
            Vector2 p2 = new Vector2(size, -size) * MapConstant.TileCellSize + new Vector2(-LineWidth / 2, LineWidth / 2);
            Vector2 p3 = new Vector2(size, size) * MapConstant.TileCellSize + new Vector2(-LineWidth / 2, -LineWidth / 2);
            Vector2 p4 = new Vector2(-size, size) * MapConstant.TileCellSize + new Vector2(LineWidth / 2, -LineWidth / 2);

            line2D.Points = [p1, p2, p3, p4];
            line2D.Width = LineWidth;
            line2D.DefaultColor = LineColor;
        }

        /// <summary>
        /// 设置能否建造
        /// </summary>
        public void SetShowColor(bool canBuild)
        {
            Color color = canBuild ? BuildShowColor : NoBuildShowColor;
            Color lineColor = canBuild ? LineColor : NoBuildLineColor;

            EntityRenderer.SetEntityColor(buildShow, weaponList, color);
            line2D.DefaultColor = lineColor;
        }

        /// <summary>
        /// 添加建筑到地图
        /// </summary>
        public void AddBuild(BuildData buildData, Vector2 offsetPos, Vector2I mapPos)
        {
            entityManager.AddEntity(this, buildData, offsetPos, mapPos);
        }

    }
}
