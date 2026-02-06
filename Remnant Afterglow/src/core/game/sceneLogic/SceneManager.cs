using Godot;
using System.Collections.Generic;
using System.Linq;
using GameLog;
using System.Threading.Tasks;
using System.Threading;

namespace Remnant_Afterglow
{
    //场景过渡类型
    public enum SceneTransitionType
    {
        None = 0,//没有过度
        BattleMap = 1, //大地图->作战地图
        MainChange = 2  //主界面->到其他界面
    }


    /// <summary>
    /// 管理场景数据，以及跨场景数据
    /// </summary>
    public static partial class SceneManager
    {
        public static Dictionary<string, string> NameScene = new Dictionary<string, string>
        {
            { "ResourceLoadView","res://src/core/ui/ResourceLoadView.tscn"},//资源加载界面

			{ "MainView","res://src/core/ui/MainView.tscn" },//游戏主界面

			{ "SaveLoadView","res://src/core/ui/view/archive_view/SaveLoadView.tscn" },//存档管理界面
            { "ArchivalView","res://src/core/ui/view/database_view/scene/ArchivalView.tscn" },//档案界面
			{ "ModManageView","res://src/core/ui/mod_view/ModManageView.tscn" },//mod管理界面
			{ "SettingView","res://src/core/ui/set_menu/SettingView.tscn" },//设置界面
			{ "CreateArchiveView","res://src/core/ui/view/archive_view/CreateArchiveView.tscn" },//创建存档界面


			{ "BigMapCopy","res://src/core/game/bigMapLogic/BigMapCopy.tscn" },//大地图界面
			{ "关卡选择界面","res://src/core/game/bigMapLogic/关卡选择界面.tscn" },//关卡选择界面
			{ "关卡准备界面","res://src/core/game/bigMapLogic/关卡准备界面.tscn" },//关卡准备界面
			{ "MapCopy","res://src/core/game/mapLogic/MapCopy.tscn" },// 作战界面
			{ "结算界面","res://src/core/game/mapLogic/结算界面.tscn" },//作战地图-结算界面




			{ "EditMapCreateView","res://src/edit/EditMapCreateView.tscn" },//地图创建和管理页面
			{ "EditMapView","res://src/edit/edit_map/EditMapView.tscn" },//地图编辑器界面
			{ "EditBigMapView","res://src/edit/edit_bigmap/EditBigMapView.tscn" }//大地图编辑器界面
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
        private static CanvasLayer transitionNode;


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
            DataDict[str] = var;
        }

        /// <summary>
        /// 获取单个参数
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static Variant? GetParam(string str)
        {
            if (DataDict.ContainsKey(str))
                return DataDict[str];
            else
            {
                Log.Error("场景参数获取时报错，无Key键:" + str);
                return null;
            }
        }

        /// <summary>
        /// 跨场景数据清理
        /// </summary>
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
        public static void ChangeScenePath(string newScenePath, SceneTransitionType type, Node callingNode)
        {
            ChangeSceneForward(NameScene[newScenePath], type, callingNode);
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
            switch (transitionType)
            {
                case SceneTransitionType.None:
                    callingNode.GetTree().ChangeSceneToFile(newScenePath);
                    break;
                case SceneTransitionType.BattleMap://大地图->作战地图
                    transitionNode = (CanvasLayer)GD.Load<PackedScene>("res://assets/作战界面素材/场景切换.tscn").Instantiate();
                    transitionNode.Name = "transitionNode";
                    AnimationPlayer animation = transitionNode.GetNode<AnimationPlayer>("AnimationPlayer");
                    callingNode.GetTree().Root.AddChild(transitionNode);
                    animation.AnimationFinished += (StringName anim_name) =>
                    {
                        if (anim_name.Equals("关闭动画"))//关闭动画结束
                        {
                            callingNode.GetTree().ChangeSceneToFile(newScenePath);
                            animation.ProcessMode = Node.ProcessModeEnum.Always;
                            animation.Play("开启动画");
                            animation.GetTree().Paused = true;//暂停
                        }
                        if (anim_name.Equals("开启动画"))//开始动画结束
                        {
                            MapCopy.Instance.GetTree().Paused = false;//不再暂停
                                                                      //transitionNode.QueueFree();
                            MapCopy.Instance.mapLogic.LogicStart();//地图逻辑-关卡逻辑开始
                            MapCopy.Instance.gameCamera.SetOp(true);//设置相机为可操作
                        }
                    };
                    break;
                case SceneTransitionType.MainChange:
                    transitionNode = (CanvasLayer)GD.Load<PackedScene>("res://assets/作战界面素材/界面场景切换.tscn").Instantiate();
                    transitionNode.Name = "transitionNode";
                    AnimationPlayer animation2 = transitionNode.GetNode<AnimationPlayer>("AnimationPlayer");
                    callingNode.GetTree().Root.AddChild(transitionNode);
                    animation2.AnimationFinished += (StringName anim_name) =>
                    {
                        if (anim_name.Equals("关闭动画"))//关闭动画结束
                        {
                            callingNode.GetTree().ChangeSceneToFile(newScenePath);
                            animation2.ProcessMode = Node.ProcessModeEnum.Always;
                            animation2.Play("开启动画");
                            animation2.GetTree().Paused = true;//暂停
                        }
                        if (anim_name.Equals("开启动画"))//开始动画结束
                        {
                            animation2.GetTree().Paused = false;//不再暂停
                        }
                    };
                    break;
                default:
                    callingNode.GetTree().ChangeSceneToFile(newScenePath);
                    break;
            }
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
                //transitionNode = CreateTransitionNode(transitionType, callingNode.GetTree());
                // 加载前一个场景
                callingNode.GetTree().ChangeSceneToFile(previousScenePath);
            }
        }
    }
}
