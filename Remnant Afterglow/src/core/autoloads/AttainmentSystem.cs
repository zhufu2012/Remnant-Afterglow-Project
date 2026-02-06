using Godot;
using System.Collections.Generic;

//成就系统
namespace Remnant_Afterglow
{
    //完成后的成就
    public class AttainmentComplete
    {
        //成就id
        public int AttainmentId;
        public AttainmentBase cfgData;

    }

    //成就进度数据
    public class AttainmentProgress
    {
        //成就id
        public int AttainmentId;
        //参数列表
        public List<int> ParamList;
        ///进度
        public int progress;
    }

    //成就系统
    public partial class AttainmentSystem : Node
    {
        //成就完成字典
        public Dictionary<int, AttainmentComplete> CompleteDict = new Dictionary<int, AttainmentComplete>();
        //成就进度字典
        public Dictionary<int, AttainmentProgress> ProgressDict = new Dictionary<int, AttainmentProgress>();

        //成就类型列表 字典<成就类型，成就列表>
        public Dictionary<int, List<int>> TypeAttainmentDict = new Dictionary<int, List<int>>();

    }
}

