

using Godot;
using Godot.Collections;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class RoomPreview
    {
        public static List<int> ShowLayerList = new List<int>() {
        0,1,2,3

        };

        /// <summary>
        /// <para>Create Image</para>
        /// <para>创建图像</para>
        /// </summary>
        /// <param name="groundTileMapLayer"></param>
        /// <returns></returns>
        public static ImageTexture? CreateImage(TileMap? tileMapLayer, System.Collections.Generic.Dictionary<int, Cell[,]> layer_dict)
        {
            if (tileMapLayer == null)
            {
                return null;
            }
            //宽度为maxX-minX，高度为maxY-minY。
            var maxY = int.MinValue;
            var maxX = int.MinValue;
            var minY = int.MaxValue;
            var minX = int.MaxValue;
            for (int i = 0; i < ShowLayerList.Count; i++)
            {
                Array<Vector2I> tempArray = tileMapLayer.GetUsedCells(ShowLayerList[i]);//祝福注释-预览
                foreach (Vector2I vector2I in tempArray)
                {
                    if (vector2I.Y > maxY)
                        maxY = vector2I.Y;
                    if (vector2I.Y < minY)
                        minY = vector2I.Y;
                    if (vector2I.X > maxX)
                        maxX = vector2I.X;
                    if (vector2I.X < minX)
                        minX = vector2I.X;
                }
            }

            var height = maxY - minY;
            var width = maxX - minX;
            var offsetVector2 = Vector2I.Zero - new Vector2I(minX, minY);
            List<List<Color>> cellsArray = new List<List<Color>>();
            Color[][] colorArray = new Color[width + 1][];
            for (int i = 0; i < width; i++)
            {
                colorArray[i] = new Color[i];
                for (int j = 0; j < height; j++)
                {
                    colorArray[i][j] = Colors.Green;
                }
            }
            for (int i = 1; i < ShowLayerList.Count; i++)
            {
                int layerId = ShowLayerList[i];
                Array<Vector2I> tempArray = tileMapLayer.GetUsedCells(layerId);//祝福注释-预览
                foreach (Vector2I vect in tempArray)
                {
                    Cell cell = layer_dict[layerId][vect.X, vect.Y];
                    MapFixedMaterial material = ConfigCache.GetMapFixedMaterial(cell.index);
                    colorArray[vect.X][vect.Y] = material.PreviewColor;
                }
            }



            //Create an image.
            //创建image。
            var image = Image.Create(width + 1, height + 1, false, Image.Format.Rgba8);
            image.Fill(Colors.Green);
            //Fill in pixels
            //填充像素点
            for (int i = 0; i < cellsArray.Count; i++)
            {
                List<Color> vect = cellsArray[i];
                for (int j = 0; j < vect.Count; j++)
                {
                    image.SetPixel(i, j, cellsArray[i][j]);
                }
            }
            return ImageTexture.CreateFromImage(image);
        }
    }

}
