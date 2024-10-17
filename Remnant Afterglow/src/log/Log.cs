using Godot;
using System;
using System.Collections.Generic;

namespace GameLog
{
    public class Log
    {


        public static void PrintList<T>(List<T> list)
        {
            for (int i = 0; i < list.Count; i++)
            {
                GD.Print(list[i].ToString());
            }
        }

        //输出数据
        public static void Print(params object[] What)
        {
            GD.Print(What);
        }

        public static void PrintDict<T>(Dictionary<int, T> dict)
        {
            foreach (var key in dict)
            {
                GD.Print(key.Key + "    " + key.Value);
            }
        }
        public static void PrintDict<T>(Dictionary<T, object> dict)
        {
            foreach (var key in dict)
            {
                GD.Print(key.Key + "    " + key.Value);
            }
        }

        public static void Print(Dictionary<Object, Object> dict)
        {
            foreach (KeyValuePair<Object, Object> kvp in dict)
            {
                GD.Print($"Key:{kvp.Key}   Value:{kvp.Value}");
            }
        }

        //输出数据-红色提示
        public static void Error(params object[] What)
        {
            //GD.PrintErr(What);
            GD.Print(What);
        }
    }
}
