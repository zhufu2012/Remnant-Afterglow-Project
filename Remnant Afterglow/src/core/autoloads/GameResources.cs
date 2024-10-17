
using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 游戏设置参数
    /// </summary>
    [Serializable]
    public class SaveGameParam
    {
        public string language = "zh_cn";
        public int language_index = 2;
    }

    //这是游戏运行所需资源，基本上都是需要保存的数据
    public partial class GameResources : Node
    {
        //游戏设置参数
        public static SaveGameParam gameParam;


        public override void _Ready()
        {
            gameParam = SaveLoadSystem.GetParam<SaveGameParam>();
            if (gameParam == null)
            {
                Log.Print("无基础配置！");
                gameParam = new SaveGameParam();
                SaveLoadSystem.SaveParam<SaveGameParam>(gameParam);
            }
        }


    }
}