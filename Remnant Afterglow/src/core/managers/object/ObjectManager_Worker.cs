using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 场上实体管理器-
    /// WorkerBase = 5,//无人机  5
    /// </summary>
    public partial class ObjectManager
    {
        /// <summary>
        /// 唯一id,对应建筑
        /// </summary>
        public Dictionary<string, WorkerBase> workerDict = new Dictionary<string, WorkerBase>();

        /// <summary>
        /// 创建一个建筑
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">创建位置</param>
        /// <returns></returns>
        public WorkerBase CreateWorker(int ObjectId, Vector2 Pos)
        {
            WorkerBase workerBase = new WorkerBase(ObjectId);
            //检查对应位置是否可以创建建筑

            workerBase.Position = Pos;
            workerBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            workerDict[workerBase.Logotype] = workerBase;
            MapCopy.Instance.WorkerNode.AddChild(workerBase);
            return workerBase;
        }

    }
}