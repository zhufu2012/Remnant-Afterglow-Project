using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 场景管理器
    /// </summary>
    public static partial class SceneManager
    {
        static readonly List<string> scenePaths = new List<string>();
        static Dictionary<string, object> sceneData = new Dictionary<string, object>();

        /// <summary>
        /// 使用 GetTree().ChangeSceneToFile()来改变场景，但是保存当前场景的路径以供后退按钮使用
        /// </summary>
        /// <param name="newScenePath">要更改到的新场景</param>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        /// <param name="transition">过渡效果</param>
        /// <param name="data">要传递给新场景的数据</param>
        public static async void ChangeSceneForward(string newScenePath, Node callingNode, PackedScene transition = null, Dictionary<string, object> data = null)
        {
            // 保存当前场景路径
            scenePaths.Add(callingNode.GetTree().CurrentScene.SceneFilePath);

            // 传递数据
            if (data != null)
            {
                sceneData[newScenePath] = data;
            }

            // 播放过渡效果
            if (transition != null)
            {
                await callingNode.GetTree().ChangeSceneAsync("res://transition.tscn", new Dictionary()
                {
                    {"transition", transition},
                    {"next_scene", newScenePath}
                });
            }
            else
            {
                callingNode.GetTree().ChangeSceneToFile(newScenePath);
            }
        }

        /// <summary>
        /// 将场景改变为之前的样子
        /// </summary>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static async void ChangeSceneBackward(Node callingNode)
        {
            if (scenePaths.Count > 1)
            {
                string lastScenePath = scenePaths[scenePaths.Count - 2];
                scenePaths.RemoveAt(scenePaths.Count - 1);

                // 播放过渡效果
                PackedScene transition = null;
                if (sceneData.TryGetValue(lastScenePath, out var data) && data is PackedScene)
                {
                    transition = (PackedScene)data;
                }

                if (transition != null)
                {
                    await callingNode.GetTree().ChangeSceneAsync("res://transition.tscn", new Dictionary()
                    {
                        {"transition", transition},
                        {"next_scene", scenePaths.Last()}
                    });
                }
                else
                {
                    callingNode.GetTree().ChangeSceneToFile(scenePaths.Last());
                }
            }
        }

        /// <summary>
        /// 获取场景数据
        /// </summary>
        /// <param name="scenePath">场景路径</param>
        /// <returns>场景数据</returns>
        public static object GetSceneData(string scenePath)
        {
            if (sceneData.TryGetValue(scenePath, out var data))
            {
                return data;
            }
            return null;
        }
    }
}