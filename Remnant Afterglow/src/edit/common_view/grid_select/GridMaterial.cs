using Godot;
using Remnant_Afterglow;
using System;

namespace Remnant_Afterglow_EditMap
{
	/// <summary>
	/// 格子材料按钮
	/// </summary>
	public partial class GridMaterial : Button
	{
		//地图类型
		public int mapType;
		//地图材料
		public MapFixedMaterial material;

		public void InitData(MapFixedMaterial material,int mapType)
		{
			this.material = material;
			this.mapType = mapType;
		}

		public override void _Ready()
		{
			Flat = true;
			FocusEntered += OnFocusEntered;
		}

		//获得焦点时，
		public void OnFocusEntered()
		{
			//设置 材料格子的各项参数

		}
	}
}
