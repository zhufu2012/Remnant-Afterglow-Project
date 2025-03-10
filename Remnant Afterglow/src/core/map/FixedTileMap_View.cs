
using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class FixedTileMap : TileMap
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
        /// 初始化界面
        /// </summary>
        public void InitView()
        { }

        /// <summary>
        /// 每帧运行界面
        /// </summary>
        /// <param name="delta"></param>
        public void UpdateView(double delta)
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


        public override void _UnhandledInput(InputEvent @event)
        {
            if (buildData == null)
            {
                //Log.Print("缺少建造数据");
                return;
            }
            // 检查是否为鼠标按钮事件并且按钮被按下
            if (@event is InputEventMouseButton mouseButton)
            {
                if (mouseButton.Pressed)
                {
                    if (mouseButton.ButtonIndex == MouseButton.Left)
                    {
                        // 获取地图位置
                        Vector2I mapPos = GetBuildPos();
                        // 检查是否可以在此位置建造
                        if (ObjectManager.Instance.CanCreateBuild(buildData, mapPos))
                        {
                            if (BagSystem.Instance.RemoveBuildPrice(buildData, true))//建造资源足够
                            {
                                
                                switch (buildData.Type)
                                {
                                    case 0:
                                        ObjectManager.Instance.CreateMapBuild(buildData.ObjectId, mapPos);
                                        break;
                                    case 1:
                                        ObjectManager.Instance.CreateMapTower(buildData.ObjectId, mapPos);
                                        break;
                                    default: break;
                                }
                                MapOpView.Instance.SetCurrencyView();//根据货币数据，更新显示的资源量和增加的量
                            }
                            else
                            {
                                Log.Print("无法建造：建造资源不足！");
                            }
                        }
                        else
                        {
                            Log.Print("无法建造：区域重叠！");
                        }

                    }
                    if (mouseButton.ButtonIndex == MouseButton.Right)//右键，取消建造
                    {
                        MapOpView.Instance.buildOpList.subBuildList.SetHighLight(-1);
                    }
                }

            }
        }

        public override void _Draw()
        {
        }


        #region 建造预览
        /// <summary>
        /// 建筑-炮塔底座
        /// </summary>
        public Sprite2D buildShow;
        /// <summary>
        /// 边框线
        /// </summary>
        public Line2D line2D;
        /// <summary>
        /// 占地区域
        /// </summary>
        public Area2D area2D;
        /// <summary>
        /// 形状
        /// </summary>
        public CollisionShape2D shape2D;
        /// <summary>
        /// 炮塔列表
        /// </summary>
        public List<Sprite2D> weaponList = new List<Sprite2D>();
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
        /// 选择的建造项
        /// </summary>
        /// <param name="item"></param>
        public void SelectItem(MapBuildItem item)
        {
            if (item != null)
            {
                buildData = item.GetBuildData();
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
            Vector2 NewPos = GetMouseOffsetPos();
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
            if (buildData != null)
            {
                IsCanBuild = BagSystem.Instance.RemoveBuildPrice(buildData, false) && 
                    ObjectManager.Instance.CanCreateBuild(buildData, GetBuildPos());
                SetShowColor(IsCanBuild);
            }
        }


        public void AddBuildPreview()
        {
            Vector2 offsetPos = GetMouseOffsetPos();
            if (buildData.Type == 0)//建筑
            {
                AnimaBuild animaUnit = ConfigCache.GetAnimaBuild(buildData.ObjectId + "_" + 1);
                buildShow.Texture = animaUnit.Picture;
                buildShow.Hframes = animaUnit.Size.X;
                buildShow.Vframes = animaUnit.Size.Y;
                buildShow.Frame = 0;
                buildShow.Modulate = BuildShowColor;
                buildShow.Position = offsetPos;
                for (int i = 0; i < weaponList.Count; i++)
                {
                    weaponList[i].Free();
                }
                weaponList.Clear();
                buildShow.Visible = true;
            }
            else//炮塔
            {
                AnimaTower animaUnit = ConfigCache.GetAnimaTower(buildData.ObjectId + "_" + 1);
                buildShow.Texture = animaUnit.Picture;
                buildShow.Hframes = animaUnit.Size.X;
                buildShow.Vframes = animaUnit.Size.Y;
                buildShow.Frame = 0;
                buildShow.Modulate = BuildShowColor;
                buildShow.Position = offsetPos;
                for (int i = 0; i < weaponList.Count; i++)
                {
                    weaponList[i].Free();
                }
                weaponList.Clear();
                if (buildData.WeaponList.Count > 0)//有武器
                {
                    for (int i = 0; i < buildData.WeaponList.Count; i++)
                    {
                        int weaponId = buildData.WeaponList[i][0];
                        int x = buildData.WeaponList[i][1];
                        int y = buildData.WeaponList[i][2];
                        AnimaWeapon animaWeapon = ConfigCache.GetAnimaWeapon(weaponId + "_" + 1);
                        if (animaWeapon != null)
                        {
                            Sprite2D weaponShow = new Sprite2D();
                            weaponShow.Texture = animaWeapon.Picture;
                            weaponShow.Hframes = animaWeapon.Size.X;
                            weaponShow.Vframes = animaWeapon.Size.Y;
                            weaponShow.Frame = 0;
                            weaponShow.Modulate = BuildShowColor;
                            weaponShow.Position = new Vector2(x, y);
                            weaponList.Add(weaponShow);
                            buildShow.AddChild(weaponShow);
                        }

                    }
                }
                buildShow.Visible = true;
            }
            IsAddBuildShow = true;
            float size = (float)buildData.BuildingSize / 2;
            Vector2 p1 = new Vector2(-size, -size) * MapConstant.TileCellSize + new Vector2(LineWidth / 2, LineWidth / 2);
            Vector2 p2 = new Vector2(size, -size) * MapConstant.TileCellSize + new Vector2(-LineWidth / 2, LineWidth / 2);
            Vector2 p3 = new Vector2(size, size) * MapConstant.TileCellSize + new Vector2(-LineWidth / 2, -LineWidth / 2);
            Vector2 p4 = new Vector2(-size, size) * MapConstant.TileCellSize + new Vector2(LineWidth / 2, -LineWidth / 2);
            ///添加边框线
            line2D.Points =
            [
                p1,p2,p3,p4
            ];
            line2D.Width = LineWidth;
            line2D.DefaultColor = LineColor;
            RectangleShape2D rectangle = new RectangleShape2D();
            rectangle.Size = new Vector2(buildData.BuildingSize, buildData.BuildingSize) * (MapConstant.TileCellSize - 1);
            shape2D.Shape = rectangle;
        }

        public void SetShowColor(bool IsBuild)
        {
            if (IsBuild)//可建造
            {
                for (int i = 0; i < weaponList.Count; i++)
                {
                    weaponList[i].Modulate = BuildShowColor;
                }
                buildShow.Modulate = BuildShowColor;
                line2D.DefaultColor = LineColor;
            }
            else
            {
                for (int i = 0; i < weaponList.Count; i++)
                {
                    weaponList[i].Modulate = NoBuildShowColor;
                }
                buildShow.Modulate = NoBuildShowColor;
                line2D.DefaultColor = NoBuildLineColor;
            }
        }

        /// <summary>
        /// 获取图片的偏移位置
        /// </summary>
        /// <returns></returns>
        public Vector2 GetMouseOffsetPos()
        {
            if (IsEvenNumber)//偶数
            {
                Vector2 mousePos = GetLocalMousePosition() - new Vector2(20, 20);
                Vector2 mapPos = LocalToMap(mousePos) + new Vector2(1f, 1f);//建筑的地图位置
                Vector2 OffPos = mapPos;//图片偏移位置
                return OffPos * MapConstant.TileCellSize;
            }
            else//奇数
            {
                Vector2 mousePos = GetLocalMousePosition();
                Vector2 mapPos = LocalToMap(mousePos);//建筑的地图位置
                Vector2 OffPos = mapPos + new Vector2(0.5f, 0.5f);//图片偏移位置
                return OffPos * MapConstant.TileCellSize;
            }
        }


        /// <summary>
        /// 获取当前建筑预览的当前地图位置
        /// </summary>
        /// <returns></returns>
        public Vector2I GetBuildPos()
        {
            if (IsEvenNumber)//偶数
            {
                Vector2 mousePos = GetLocalMousePosition() - new Vector2(20, 20);
                Vector2I mapPos = LocalToMap(mousePos) + new Vector2I(1, 1);//建筑的地图位置
                return mapPos;
            }
            else//奇数
            {
                Vector2 mousePos = GetLocalMousePosition();
                Vector2I mapPos = LocalToMap(mousePos);//建筑的地图位置
                return mapPos;
            }
        }



        /// <summary>
        /// 获取某地图位置的建筑的真实 地图位置
        /// </summary>
        /// <returns></returns>
        public Vector2 GetBuildPos(int size, Vector2 pos)
        {
            if (size % 2 == 0)//偶数
            {
                Vector2 mousePos = pos - new Vector2(20, 20);
                Vector2 mapPos = LocalToMap(mousePos) + new Vector2(1f, 1f);//建筑的地图位置
                return mapPos;
            }
            else//奇数
            {
                Vector2 mousePos = pos;
                Vector2 mapPos = LocalToMap(mousePos);//建筑的地图位置
                return mapPos;
            }
        }


        /// <summary>
        /// 根据地图格子，和建筑数据，计算真实的建筑位置
        /// </summary>
        /// <returns></returns>
        public Vector2 GetBuildPos(int size, Vector2I mapPos)
        {
            if (size % 2 == 0)//偶数
            {
                return mapPos * MapConstant.TileCellSize;
            }
            else//奇数
            {
                return mapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
            }
        }

        #endregion
    }
}
