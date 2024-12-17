using GameLog;
using Godot;
using System;
using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;

namespace Remnant_Afterglow
{
    public class ListCommon
    {
        /// <summary>
        /// 将一个List<int> 的每两个值转换为一个Vector2,前offset个数字不转换
        /// </summary>
        /// <param name="intList"></param>
        /// <param name="offset">这个位置之前的不转换</param>
        /// <returns></returns>
        /// <exception cref="ArgumentException"></exception>
        public static Vector2[] ConvertToVector2Array(List<int> intList, int offset)
        {
            if ((intList.Count - offset) % 2 != 0)
            {
                throw new ArgumentException("The list must contain an even number of elements.");
            }
            List<Vector2> vector2List = new List<Vector2>();
            for (int i = offset; i < intList.Count; i += 2)
            {
                vector2List.Add(new Vector2(intList[i], intList[i + 1]));
            }
            return vector2List.ToArray();
        }


        public static List<Vector2> ConvertToVector2List(List<int> intList, int offset)
        {
            if ((intList.Count - offset) % 2 != 0)
            {
                throw new ArgumentException("The list must contain an even number of elements.");
            }
            List<Vector2> vector2List = new List<Vector2>();
            for (int i = offset; i < intList.Count; i += 2)
            {
                vector2List.Add(new Vector2(intList[i], intList[i + 1]));
            }
            return vector2List;
        }
    }
}