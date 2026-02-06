using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;
namespace Remnant_Afterglow_EditMap
{
	/// <summary>
	/// 实体选择器-单个界面
	/// </summary>
	public partial class EntitySelectCon : Control
	{
		/// <summary>
		/// 实体类型id
		/// </summary>
		public int type = 1;
		public string typeName = "";
		public GridContainer gridContainer;

		public int select_obj_id;
		public void InitData(int type, string typeName)
		{
			this.type = type;
			this.typeName = typeName;
			Name = typeName;
		}
		
		public override void _Ready()
		{
			gridContainer = GetNode<GridContainer>("ScrollContainer/VBoxContainer/GridContainer");
			gridContainer.Columns = 10;
			gridContainer.AddThemeConstantOverride("h_separation", 10); // 水平间距
			gridContainer.AddThemeConstantOverride("v_separation", 10); // 垂直间距
			List<Dictionary<string, object>> QueryList = ConfigLoadSystem.QueryCfgAllLine(ConfigConstant.Config_BaseObjectData,
				new Dictionary<string, object> { { "ObjectType", type }
			  });
			foreach (var info in QueryList)
			{
				int obj_id = (int)info["ObjectId"];//实体id
				int obj_type = (int)info["ObjectType"];//实体类型
				EntityItem item = (EntityItem)GD.Load<PackedScene>("res://src/edit/common_view/entity_select/EntityItem.tscn").Instantiate();
				BuildData buildData = ConfigCache.GetBuildData(obj_id);
				if (buildData != null)
				{
					switch (obj_type)
					{
						case (int)BaseObjectType.BaseTower://炮塔
							AnimaTower animaTower = ConfigCache.GetAnimaTower(obj_id + "_" + 1);
							if (animaTower != null)
							{
								Image image = animaTower.Picture.GetImage();
								Rect2I rect2 = new Rect2I(new Vector2I(0, 0), animaTower.LengWidth);
								item.Icon = ImageTexture.CreateFromImage(image.GetRegion(rect2));
								if (buildData.WeaponList.Count > 0)//有武器
								{
									for (int i = 0; i < buildData.WeaponList.Count; i++)
									{
										int weaponId = buildData.WeaponList[i][0];
										AnimaWeapon animaWeapon = ConfigCache.GetAnimaWeapon(weaponId + "_" + 1);
										if (animaWeapon != null)
										{
											TextureRect weaponShow = new TextureRect();
											weaponShow.MouseFilter = MouseFilterEnum.Pass;
											Vector2I size = animaWeapon.LengWidth;
											Rect2I weapomRect = new Rect2I(new Vector2I(0, 0), animaWeapon.LengWidth);
											weaponShow.Texture = ImageTexture.CreateFromImage(animaWeapon.Picture.GetImage().GetRegion(weapomRect));
											weaponShow.ZIndex = 1;
											weaponShow.Position = new Vector2(60 - (size.X / 2), 60 - (size.Y / 2));
											item.AddChild(weaponShow);
										}

									}
								}
							}
							else
							{
								continue;
							}
							break;
						case (int)BaseObjectType.BaseBuild://建筑
							AnimaBuild animaBuild = ConfigCache.GetAnimaBuild(obj_id + "_" + 1);
							if (animaBuild != null)
							{
								Image image = animaBuild.Picture.GetImage();
								Rect2I rect2 = new Rect2I(new Vector2I(0, 0), animaBuild.LengWidth);
								item.Icon = ImageTexture.CreateFromImage(image.GetRegion(rect2));
							}
							else
							{
								continue;
							}
							break;
						default:
							continue;
					}
					item.InitData(obj_id, obj_type);
					item.ButtonDown += () =>
					{
						select_obj_id = obj_id;
						EditTileMap.SetType(MouseButtonType.Entity);//设置实体
						EditMapView.Instance.tileMap.UpdataObject();//更新材料格子数据
					};
					gridContainer.AddChild(item);
				}
			}
		}

		/// <summary>
		/// 当前选择实体id
		/// </summary>
		/// <returns></returns>
		public int GetSelectId()
		{
			return select_obj_id;
		}
	}
}
