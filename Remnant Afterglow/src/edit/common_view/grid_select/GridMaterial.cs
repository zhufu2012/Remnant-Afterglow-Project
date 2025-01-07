namespace Remnant_Afterglow_EditMap
{
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
	}
}