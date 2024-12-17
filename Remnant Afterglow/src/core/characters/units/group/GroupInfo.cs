using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位组
    /// </summary>
    public partial class GroupInfo
    {
        //单位组类型配置
        public UnitGroupType groupType;
        //单位组数据配置
        public UnitGroupData groupData;
        //单位列表-用于遍历
        public List<UnitBase> unitList;
        //单位字典,用于快速查找<唯一id,单位>
        public Dictionary<string, UnitBase> UnitDict = new Dictionary<string, UnitBase>();

        public int groupSize; // 组的大小
        //头领单位
        public UnitBase LeaderUnit;
        //// 移动方向
        public Vector2 direction;
        //// 组的中心点
        public Vector2 middle;
        // 构造函数
        public GroupInfo()
        {
        }
    }
}