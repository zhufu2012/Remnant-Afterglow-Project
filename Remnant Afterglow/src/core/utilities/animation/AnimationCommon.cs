using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 动画相关-通用代码
    /// </summary>
    public class AnimationCommon
    {




        public static float FindSecondItemIfFirstIsOne(List<List<float>> lists, int index)
        {
            foreach (var innerList in lists)
            {
                // 第一个元素是否为1
                if (innerList[0] == index)
                {
                    return innerList[1];
                }
            }
            // 如果没有找到符合条件的列表，则返回null
            return 1;
        }








    }
}