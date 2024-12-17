
using BulletMLLib.SharedProject;
using GameLog;
using Godot;
using System;
using System.Collections.Generic;
using static Godot.DisplayServer;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 游戏设置参数
    /// </summary>
    [Serializable]
    public class SaveGameParam
    {
        /// <summary>
        /// 选择的语言
        /// </summary>
        public string language = "zh_cn";
        /// <summary>
        /// 选择的语言的index
        /// </summary>
        public int language_index = 2;
        /// <summary>
        /// 游戏音乐音量 0-100
        /// </summary>
        public float MusicVolume = 50;
        /// <summary>
        /// 效果音量 0-100
        /// </summary>
        public float SFXVolume = 50;
        /// <summary>
        /// 游戏运行时的窗口模式：窗口模式、无边框全屏或全屏独占
        /// WINDOW_MODE_WINDOWED = 0  窗口模式，即 Window 不占据整个屏幕（除非设置为屏幕的大小）。
        /// WINDOW_MODE_MAXIMIZED = 2 最大化窗口模式，即 Window 会占据整个屏幕区域，任务栏除外，并且会显示边框。通常发生在按下最大化按钮时。
        /// WINDOW_MODE_FULLSCREEN = 3 具有完整多窗口支持的全屏模式。 全屏窗口覆盖屏幕的整个显示区域，且没有任何装饰。显示的视频模式没有更改。
        /// </summary>
        public WindowMode WindowMode = WindowMode.Windowed;
        /// <summary>
        /// 窗口大小
        /// </summary>
        public Vector2I   WindowSize;
    }

    /// <summary>
    /// 这是游戏运行所需资源，基本上都是需要保存的数据
    /// </summary>
    public partial class GameResources : Node
    {
        /// <summary>
        /// 游戏设置参数
        /// </summary>
        public static SaveGameParam gameParam;


        public override void _Ready()
        {
            Utils.InitRandom();//随机数初始化
            GameManager.GameDifficulty = () => 1.0f;// 设置游戏难度（暂时固定为1.0）


            gameParam = SaveLoadSystem.GetParam<SaveGameParam>();
            if (gameParam == null)
            {
                Log.Error("文件夹data下不存在config.json！重新生成config.json！");
                gameParam = new SaveGameParam();
                SaveLoadSystem.SaveParam<SaveGameParam>(gameParam);
            }
        }




    }
}