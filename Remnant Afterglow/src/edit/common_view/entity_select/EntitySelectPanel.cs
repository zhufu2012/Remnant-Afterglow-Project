using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;
namespace Remnant_Afterglow_EditMap
{
	/// <summary>
	/// 实体选择编辑器
	/// </summary>
	public partial class EntitySelectPanel : Control
	{
		public TabContainer tabContainer;

		public List<int> typeList = new List<int>() { 2, 3 };
		public List<string> typeNameList = new List<string>() { "炮塔", "建筑" };
		public Dictionary<int, BaseObjectData> baseObjectDictionary;
		/// <summary>
		/// 图集字典  图集id,单图集控件
		/// </summary>
		public Dictionary<int, EntitySelectCon> entityConDict = new Dictionary<int, EntitySelectCon>();
		public override void _Ready()
		{
			tabContainer = GetNode<TabContainer>("TabContainer");
			for (int i = 0; i < typeList.Count; i++)
			{
				EntitySelectCon entitySelectCon = (EntitySelectCon)GD.Load<PackedScene>("res://src/edit/common_view/entity_select/EntitySelectCon.tscn").Instantiate();
				entitySelectCon.InitData(typeList[i], typeNameList[i]);
				tabContainer.AddChild(entitySelectCon);
				entityConDict[typeList[i]] = entitySelectCon;
			}

		}


		public override void _PhysicsProcess(double delta)
		{
		}

		/// <summary>
		/// 返回当前选择的材料
		/// </summary>
		/// <returns></returns>
		public BuildData GetSelectBuildData()
		{
			EntitySelectCon con = (EntitySelectCon)tabContainer.GetCurrentTabControl();
			int objectId = con.GetSelectId();
			return ConfigCache.GetBuildData(objectId);
		}

	}
}
