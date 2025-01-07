using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 场上实体管理器-
    /// BaseBuild = 3,//建筑  3
    /// </summary>
    public partial class ObjectManager
    {
        /// <summary>
        /// 唯一id,对应建筑
        /// </summary>
        public Dictionary<string, BuildBase> buildDict = new Dictionary<string, BuildBase>();

        /// <summary>
        /// 创建一个建筑
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">创建位置</param>
        /// <returns></returns>
        public BuildBase CreateBuild(int ObjectId, Vector2 Pos)
        {
            BuildBase buildBase = new BuildBase(ObjectId);
            //检查对应位置是否可以创建建筑

            buildBase.Position = Pos;
            buildBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            buildDict[buildBase.Logotype] = buildBase;
            buildBase.MobKilled +=(BaseObject killObject,BaseObject casterObject) => BuildKilledAfter(killObject,casterObject);
            MapCopy.Instance.BuildNode.AddChild(buildBase);
            return buildBase;
        }

        //建筑死亡后处理
        private void BuildKilledAfter(BaseObject killObject,BaseObject casterObject)
        {

            killObject.QueueFree();//此时才清空
        }
    }
}