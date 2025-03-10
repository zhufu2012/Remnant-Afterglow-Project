
using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 资源数字处理
    /// </summary>
    public class ImgNumber
    {
        public static List<string> ImageStrList = new List<string> {
            "Resources_Number1",//0 万能齿轮资源数字
            "Resources_Number2",//1 怨灵水晶资源数字
            "Resources_Number3",//2 次元岛溶剂资源数字
            "Resources_Number4" //3 波次数字
        };
        /// <summary>
        /// 资源数字图片大小设置，
        /// </summary>
        public static List<Vector2> SizeList = new List<Vector2>();

        public static Dictionary<int, Texture2D> imgDict = new Dictionary<int, Texture2D>();

        /// <summary>
        /// 初始化资源图片数据
        /// </summary>
        public static void InitData()
        {
            int image_index = 0;
            foreach (var imgStr in ImageStrList)
            {
                Texture2D texture2D = ConfigCache.GetGlobal_Png(imgStr);
                Dictionary<Vector2I, Texture2D> keyValuePairs = Common.SplitTexture(texture2D, new Vector2I(10, 1));
                imgDict[image_index] = texture2D;
                Vector2 size = keyValuePairs[new Vector2I(1, 1)].GetSize();
                SizeList.Add(size);
                image_index++;
            }
        }
    }
}
