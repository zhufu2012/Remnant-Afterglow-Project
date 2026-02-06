using Godot;

namespace Remnant_Afterglow_EditMap
{
	public partial class EntityItem : Button
	{
		/// <summary>
		/// 实体id
		/// </summary>
		public int obj_id;
		public int obj_type;
		public void InitData(int obj_id, int obj_type)
		{
			this.obj_id = obj_id;
			this.obj_type = obj_type;
		}

		public override void _Ready()
		{
			Flat = true;
		}



	}
}
