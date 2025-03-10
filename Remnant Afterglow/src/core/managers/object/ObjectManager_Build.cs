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
        public BuildBase CreateMapBuild(int ObjectId, Vector2I MapPos)
        {
            BuildBase buildBase = GD.Load<PackedScene>("res://src/core/characters/builds/BuildBase.tscn").Instantiate<BuildBase>();
            buildBase.InitData(ObjectId);
            //检查对应位置是否可以创建建筑
            buildBase.mapPos = MapPos;
            buildBase.Position = MapCopy.Instance.fixedTileMap.GetBuildPos(buildBase.buildData.BuildingSize, MapPos);
            buildBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            buildDict[buildBase.Logotype] = buildBase;
            MapCopy.Instance.BuildNode.AddChild(buildBase);
            CreateObject(buildBase, buildBase.buildData);
            FlowFieldSystem.Instance.CreateBaseObject(buildBase, buildBase.buildData, false);
            buildBase.MobKilled += (BaseObject killObject, BaseObject casterObject, BulletNode bulletNode) =>
KilledAfter(killObject, casterObject, bulletNode);
            return buildBase;
        }

    }
}