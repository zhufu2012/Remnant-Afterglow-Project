using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //常用函数
    public class Common
    {
        public static PackedScene GetPackedScene(Node node)
        {
            PackedScene pack = new PackedScene();
            Error result = pack.Pack(node);
            if (result == Error.Ok)
            {
                return pack;
            }
            else
            {
                Log.Error("Error! 场景打包失败！");
                return pack;
            }
        }

        public static long GetS()
        {
            return (long)Time.GetUnixTimeFromSystem();//祝福注释-时间戳
        }


        /// <summary>
        /// 获取游戏帧数
        /// </summary>
        /// <returns></returns>
        public static double GetGameFrameNum()
        {
            return Engine.GetFramesPerSecond();
        }


        /// <summary>
        /// 将一个大图片，拆分为多个小图片，返回图片字典
        /// </summary>
        /// <param name="texture"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        public static Dictionary<Vector2I, Texture2D> SplitTexture(Texture2D texture, Vector2I Possize)
        {
            Image image = texture.GetImage();
            var subTextures = new Dictionary<Vector2I, Texture2D>();

            var originalSize = texture.GetSize();
            Vector2I size = new Vector2I((int)(originalSize.X / Possize.X), (int)(originalSize.Y / Possize.Y));

            for (int y = 0; y < Possize.X; y++)
            {
                for (int x = 0; x < Possize.Y; x++)
                {
                    Rect2I rect = new Rect2I(new Vector2I(x * size.X, y * size.Y), size);
                    Image image1 = image.GetRegion(rect);
                    subTextures[new Vector2I(x, y)] = (Texture2D)ImageTexture.CreateFromImage(image);
                }
            }
            return subTextures;
        }
    }
}