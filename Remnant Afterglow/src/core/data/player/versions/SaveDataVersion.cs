using GameLog;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 存档 的版本替换加载
    /// </summary>
    public partial class SaveData
    {
        ///版本数据检查，版本不同的话，需要设置版本数据
        public static string VersionConverter(string jsonText)
        {
            //Log.Print(jsonText);
            return jsonText;
        }
    }
}