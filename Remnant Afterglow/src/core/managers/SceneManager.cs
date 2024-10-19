using Godot;
using System.Collections.Generic;
using System.Linq;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 场景管理器
    /// </summary>
    public static partial class SceneManager
    {
        static readonly List<string> scenePaths = new List<string>();
        /// <summary>
        /// 使用 GetTree().ChangeSceneToFile()来改变场景，但是保存当前场景的路径以供后退按钮使用
        /// </summary>
        /// <param name="newScenePath">要更改到的新场景</param>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeSceneForward(string newScenePath, Node callingNode)
        {
            scenePaths.Add(callingNode.GetTree().CurrentScene.SceneFilePath);
            callingNode.GetTree().ChangeSceneToFile(newScenePath);
        }
        /// <summary>
        ///将场景改变为之前的样子
        /// </summary>
        /// <param name="callingNode">调用this的节点，通常是“this ”,但是树中的任何节点都可以</param>
        public static void ChangeSceneBackward(Node callingNode)
        {
            callingNode.GetTree().ChangeSceneToFile(scenePaths.Last());
            scenePaths.RemoveAt(scenePaths.Count - 1);
        }

    }
}
