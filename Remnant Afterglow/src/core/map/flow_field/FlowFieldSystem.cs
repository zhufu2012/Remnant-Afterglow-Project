using GameLog;
using Godot;
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 流场导航系统
    /// </summary>
    public class FlowFieldSystem
    {
        /// <summary>
        /// 单例模式，用于全局访问FlowFieldSystem实例
        /// </summary>
        public static FlowFieldSystem Instance { get; set; }

        /// <summary>
        /// 用于显示的流场
        /// </summary>
        public FlowField ShowFlowField { get; set; }

        /// <summary>
        /// 地图横向长度
        /// </summary>
        public int Width;
        /// <summary>
        /// 地图纵向长度
        /// </summary>
        public int Height;
        /// <summary>
        /// 地板层 地图-如果地板层有修改，这里也要修改-祝福注释
        /// </summary>
        public Cell[,] layer;
        /// <summary>
        /// 可通行类型配置字典 <材料id,可通行配置>
        /// </summary>
        Dictionary<int, MapPassType> passDict = new Dictionary<int, MapPassType>();
        /// <summary>
        /// 位置流场字典  <目标位置,流场> 实体群体移动时使用， 地图变化时需要更新流场-祝福注释
        /// </summary>
        public Dictionary<Vector2I, FlowField> posFlowDict = new Dictionary<Vector2I, FlowField>();
        /// <summary>
        /// 实体流场字典  <实体唯一id,流场> 追踪实体时使用，
        /// 1.检查实体移动时需要更新流场，-祝福注释
        /// 2.地图变化时需要更新流场-祝福注释
        /// </summary>
        public Dictionary<string, FlowField> objectFlowDict = new Dictionary<string, FlowField>();

        public FlowFieldSystem(int Width, int Height, Cell[,] layer)
        {
            Instance = this;
            this.Width = Width;
            this.Height = Height;
            this.layer = layer;
            foreach (MapMaterial info in ConfigCache.GetAllMapMaterial())//初始化通行类型 字典
            {
                passDict[info.MaterialId] = ConfigCache.GetMapPassType(info.PassTypeId);
            }
        }

        /// <summary>
        /// 新增一个位置流场 地图格子位置
        /// </summary>
        /// <param name="targetPos"></param>
        public void AddPosFlowField(Vector2I targetPos)
        {
            if (!posFlowDict.ContainsKey(targetPos))//如果没有，才创建
            {
                FlowField flow = new FlowField(targetPos);
                flow.SetTarget();//设置目标节点
                flow.Generate();//生成流场
                posFlowDict[targetPos] = flow;
            }
        }

        /// <summary>
        /// 移除不再使用的流场
        /// </summary>
        /// <param name="targetPos"></param>
        public void RemovePosFlowField(Vector2I targetPos)
        {
            posFlowDict.Remove(targetPos);
        }


        /// <summary>
        /// 新增一个实体流场
        /// </summary>
        /// <param name="targetObject"></param>
        public void AddObjectFlowField(BaseObject targetObject)
        {
            if (!objectFlowDict.ContainsKey(targetObject.Logotype))//如果没有，才创建
            {
                FlowField flow = new FlowField(targetObject);
                flow.SetTarget();//设置目标节点
                flow.Generate();//生成流场
                objectFlowDict[targetObject.Logotype] = flow;
            }
        }

        /// <summary>
        /// 移除不在使用的实体流场
        /// </summary>
        /// <param name="targetObject"></param>
        public void RemoveObjectFlowField(BaseObject targetObject)
        {
            objectFlowDict.Remove(targetObject.Logotype);
        }
       

        /// <summary>
        /// 获取追击实体的方向矢量
        /// </summary>
        /// <param name="mapPos">所在地图位置</param>
        /// <param name="targetId">追击者ID</param>
        /// <returns>方向矢量</returns>
        public Vector2? GetObjectDirection(Vector2I mapPos, string targetId)
        {
            // 尝试获取目标流场数据
            if (objectFlowDict.TryGetValue(targetId, out var flowField))
            {
                if (mapPos.X >= 0 && mapPos.X < flowField.Width && mapPos.Y >= 0 && mapPos.Y < flowField.Height)
                {
                    return flowField.nodeData[mapPos.X, mapPos.Y].direction;
                }
            }
            return null;
        }



    }
}