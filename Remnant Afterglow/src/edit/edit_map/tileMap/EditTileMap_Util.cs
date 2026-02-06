using Godot;
using Remnant_Afterglow;

namespace Remnant_Afterglow_EditMap
{
    public partial class EditTileMap : TileMap
    {

        /// <summary>
        /// 获取图片的偏移位置
        /// </summary>
        /// <returns></returns>
        public Vector2 GetMouseOffsetPos(bool IsNumber)
        {
            if (IsNumber)//偶数
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
        /// 获取当前鼠标位置所属真实地图格子位置（建筑）
        /// </summary>
        /// <returns></returns>
        public Vector2I GetBuildPos(bool IsNumber)
        {
            if (IsNumber)//偶数
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
        /// 获取格子的真实的位置
        /// </summary>
        /// <returns></returns>
        public Vector2 GetMapPos(bool IsNumber, Vector2I mapPos)
        {
            if (IsNumber)//偶数
            {
                return mapPos * MapConstant.TileCellSize;
            }
            else//奇数
            {
                return mapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
            }
        }
    }
}
