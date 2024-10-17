using Godot;
using Godot.Collections;
using Remnant_Afterglow;

public partial class NavigationMap : Node
{
    public TileMap Map;

    public NavigationSystem NavigationSystem;


    public override void _Ready()
    {
        Map = GetNode<TileMap>("TileMap");
        //Log.Print(Map.GetUsedCells(0));
        Vector2I mapSize = Map.GetUsedRect().Size;
        //Log.Print(mapSize);//大小
        // 遍历每个格子

        Array<Vector2I> array = Map.GetUsedCells(0);

        for (int index = 0; index < array.Count; index++)
        {
            Vector2I cellType = Map.GetCellAtlasCoords(0, array[index]);  // 获取格子的类型
            Vector2 cellPosition = Map.MapToLocal(array[index]);  // 将格子坐标转换为世界坐标
            //GD.Print("格子位置: " + cellPosition + " 格子类型: " + cellType);
        }
        //NavigationSystem = new NavigationSystem();
    }


    public override void _Process(double delta)
    {

    }
}
