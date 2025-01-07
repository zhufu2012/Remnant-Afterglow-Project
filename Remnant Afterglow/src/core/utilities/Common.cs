using GameLog;
using Godot;
using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 常用函数
    /// </summary>
    public class Common
    {

        /// <summary>
        /// 通用函数，用于清除指定节点的所有子节点
        /// </summary>
        /// <param name="parent"></param>
        public static void ClearChildren(Node parent)
        {
            foreach (Node child in parent.GetChildren())
            {
                if (child != parent)
                {
                    child.QueueFree();
                }
            }
        }


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

        /// <summary>
        /// 时间戳
        /// </summary>
        /// <returns></returns>
        public static long GetS()
        {
            return (long)Time.GetUnixTimeFromSystem();
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
        /// <param name="texture">图片</param>
        /// <param name="size">拆分的横轴和纵轴</param>
        /// <returns></returns>
        public static Dictionary<Vector2I, Texture2D> SplitTexture(Texture2D texture, Vector2I Size)
        {
            Image image = texture.GetImage();
            var subTextures = new Dictionary<Vector2I, Texture2D>();

            var originalSize = texture.GetSize();
            Vector2I size = new Vector2I((int)(originalSize.X / Size.X), (int)(originalSize.Y / Size.Y));

            for (int y = 0; y < Size.X; y++)
            {
                for (int x = 0; x < Size.Y; x++)
                {
                    Rect2I rect = new Rect2I(new Vector2I(x * size.X, y * size.Y), size);
                    Image image1 = image.GetRegion(rect);
                    subTextures[new Vector2I(x + 1, y + 1)] = (Texture2D)ImageTexture.CreateFromImage(image1);
                }
            }
            return subTextures;
        }

        /// <summary>
        /// 将一个大图片，按照指定大小，拆分为多个小图片，返回图片字典
        /// </summary>
        /// <param name="texture">图片</param>
        /// <param name="ImageSize">图片指定大小</param>
        /// <returns></returns>
        public static Dictionary<Vector2I, Texture2D> SplitTexture2(Texture2D texture, Vector2I ImageSize)
        {
            Image image = texture.GetImage();
            var subTextures = new Dictionary<Vector2I, Texture2D>();
            // 获取原始图片的尺寸
            Vector2I originalSize = texture.GetSize();
            // 计算在水平和垂直方向上可拆分的小图片数量
            Vector2I size = new Vector2I((int)(originalSize.X / ImageSize.X), (int)(originalSize.Y / ImageSize.Y));

            for (int y = 0; y < size.Y; y++)
            {
                for (int x = 0; x < size.X; x++)
                {
                    // 计算当前小图片对应的矩形区域
                    Rect2I rect = new Rect2I(new Vector2I(x * ImageSize.X, y * ImageSize.Y), ImageSize);
                    Image image1 = image.GetRegion(rect);
                    subTextures[new Vector2I(x + 1, y + 1)] = (Texture2D)ImageTexture.CreateFromImage(image1);
                }
            }
            return subTextures;
        }

        /// <summary>
        /// 计算掩模
        /// </summary>
        /// <param name="maskList"></param>
        /// <returns></returns>
        public static uint CalculateMaskSum(List<int> maskList)
        {
            float sum = 0;
            foreach (int position in maskList)
            {
                if (position >= 1 && position <= 32)
                {
                    // 使用位移操作来计算2的(position - 1)次方
                    sum += Mathf.Pow(2, position - 1);
                }
            }
            return (uint)sum;
        }
    }
}