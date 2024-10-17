using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //界面切换等操作时，用于保存数据的类
    public partial class GlobalData : Node
    {
        public static Dictionary<string, Variant> dict = new Dictionary<string, Variant>();
        public static string path = "";
        public static void SetParams(Dictionary<string, Variant> parameters)
        {
            dict = parameters;
        }

        public static Dictionary<string, Variant> GetParams()
        {
            return dict;
        }
        public static void Clear()
        {
            dict.Clear();
        }

        /// <summary>
        /// 添加一个参数
        /// </summary>
        /// <param name="str"></param>
        /// <param name="var"></param>
        public static void PutParam(string str, Variant var)
        {
            dict[str] = var;
        }

        /// <summary>
        /// 获取单个参数
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static Variant? GetParam(string str)
        {
            if (dict.ContainsKey(str))
                return dict[str];
            else
                return null;
        }


    }
}
