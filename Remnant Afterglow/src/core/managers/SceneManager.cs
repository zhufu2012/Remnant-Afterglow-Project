using Godot;
using System.Collections.Generic;
using System;
using System.Linq;

namespace Remnant_Afterglow
{
    //场景过渡类型
    public enum SceneTransitionType
    {
        None = 0,
        ZoomOut = 1,
        SwipeRight = 2,
        FallDown = 3
    }


    /// <summary>
    /// 管理场景数据，以及跨场景数据
    /// </summary>
    public static partial class SceneManager
    {
        public static Dictionary<string, string> NameScene = new Dictionary<string, string>
        {
            { "MainView","res://src/core/ui/MainView.tscn" },//游戏主界面
            { "MapCopy","res://src/core/game/mapLogic/MapCopy.tscn" },// 关卡内界面
            { "BigMapCopy","res://src/core/game/bigMapLogic/BigMapCopy.tscn" },//大地图界面
            { "SaveLoadView","res://src/core/ui/view/archive_view/SaveLoadView.tscn" },//存档管理界面
            { "ModManageView","res://src/core/ui/mod_view/ModManageView.tscn" },//mod管理界面
            { "SettingView","res://src/core/ui/set_menu/SettingView.tscn" },//设置界面
            { "CreateArchiveView","res://src/core/ui/view/archive_view/CreateArchiveView.tscn" }//创建存档界面
        };


        /// <summary>
        /// 当前场景
        /// </summary>
        public static string NowScene = "res://src/core/ui/MainView.tscn";
        /// <summary>
        /// 主场景 - 没有可返回的就返回主场景
        /// </summary>
        public static string MainScene = "res://src/core/ui/MainView.tscn";
        private static readonly List<string> scenePaths = new List<string>();
        /// <summary>
        /// 过渡节点
        /// </summary>
        private static Node transitionNode;


        /// <summary>
        /// 保存跨场景数据
        /// </summary>
        public static Dictionary<string, Variant> DataDict = new Dictionary<string, Variant>();

        public static void SetParams(Dictionary<string, Variant> parameters)
        {
            DataDict = parameters;
        }

        public static Dictionary<string, Variant> GetParams()
        {
            return DataDict;
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
        //跨场景数据清理
        public static void DataClear()
        {
            DataDict.Clear();
        }

        /// <summary>
        /// 使用 GetTree().ChangeSceneToFile()来改变场景，但是保存当前场景的路径以供后退按钮使用
        /// </summary>
        /// <param name="newScenePath">要更改到的新场景</param>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeSceneName(string SceneName, Node callingNode)
        {
            ChangeSceneForward(NameScene[SceneName], SceneTransitionType.None, callingNode);
        }
        /// <summary>
        /// 使用 GetTree().ChangeSceneToFile()来改变场景，但是保存当前场景的路径以供后退按钮使用
        /// </summary>
        /// <param name="newScenePath">要更改到的新场景</param>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeScenePath(string newScenePath, Node callingNode)
        {
            ChangeSceneForward(newScenePath, SceneTransitionType.None, callingNode);
        }

        /// <summary>
        /// 使用 GetTree().ChangeSceneToFile()来改变场景，但是保存当前场景的路径以供后退按钮使用
        /// </summary>
        /// <param name="newScenePath">要更改到的新场景</param>
        /// <param name="transitionType">过渡效果类型</param>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeSceneForward(string newScenePath, SceneTransitionType transitionType, Node callingNode)
        {
            string scene_path = callingNode.GetTree().CurrentScene.SceneFilePath;
            scenePaths.Add(scene_path);
            NowScene = scene_path;
            // 创建过渡节点
            transitionNode = CreateTransitionNode(transitionType, callingNode.GetTree());
            // 加载新场景
            callingNode.GetTree().ChangeSceneToFile(newScenePath);
        }

        /// <summary>
        /// 将场景改变为之前的样子
        /// </summary>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeSceneBackward(Node callingNode)
        {
            ChangeSceneBackward(SceneTransitionType.None, callingNode);
        }
        /// <summary>
        /// 将场景改变为之前的样子
        /// </summary>
        /// <param name="transitionType">过渡效果类型</param>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeSceneBackward(SceneTransitionType transitionType, Node callingNode)
        {
            if (scenePaths.Count == 0) // 没有可返回的场景，就返回主界面
            {
                callingNode.GetTree().ChangeSceneToFile(MainScene);
                NowScene = MainScene;
            }
            else
            {
                string previousScenePath = scenePaths.Last<string>();
                scenePaths.RemoveAt(scenePaths.Count - 1);
                NowScene = previousScenePath;
                // 创建过渡节点
                transitionNode = CreateTransitionNode(transitionType, callingNode.GetTree());
                // 加载前一个场景
                callingNode.GetTree().ChangeSceneToFile(previousScenePath);
            }
        }

        private static Node CreateTransitionNode(SceneTransitionType transitionType, SceneTree sceneTree)
        {
            // 创建并配置过渡节点
            // 这里需要根据实际的过渡效果来实现节点的创建和配置
            // 以下代码仅为示例，具体实现可能需要根据过渡效果的类型来调整
            Node transitionNode = new Node2D();
            // 根据 transitionType 设置过渡效果
            // ...
            sceneTree.Root.AddChild(transitionNode);
            return transitionNode;
        }
    }
}