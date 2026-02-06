using Godot;
using SteeringBehaviors;
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

        public PackedScene buildScene = GD.Load<PackedScene>("res://src/core/characters/builds/BuildBase.tscn");
        /// <summary>
        /// 创建一个建筑
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">创建位置</param>
        /// <returns></returns>
        public BuildBase CreateMapBuild(int ObjectId, Vector2I MapPos)
        {
            BuildBase buildBase = buildScene.Instantiate<BuildBase>();
            buildBase.Camp = PlayerCamp;
            buildBase.InitData(ObjectId, 1);
            //检查对应位置是否可以创建建筑
            buildBase.mapPos = MapPos;
            buildBase.Position = MapCopy.Instance.fixedTileMap.GetBuildPos(buildBase.buildData.BuildingSize, MapPos);
            buildBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            buildDict[buildBase.Logotype] = buildBase;
            MapCopy.Instance.BuildNode.AddChild(buildBase);
            //SpatialGrid.UpdateGrid(buildBase.steering);//维护空间网格
            CreateObject(buildBase, buildBase.buildData);
            FlowFieldSystem.Instance.CreateBaseObject(buildBase.Logotype, buildBase.mapPos, buildBase.buildData, false);
            return buildBase;
        }

        /// <summary>
        /// 创建一个建筑,地图生成时使用的
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">创建位置</param>
        /// <returns></returns>
        public BuildBase CreateMapBuild(int ObjectId, int Camp, Vector2I MapPos)
        {
            BuildBase buildBase = buildScene.Instantiate<BuildBase>();
            buildBase.Camp = Camp;
            buildBase.InitData(ObjectId, 0);
            //检查对应位置是否可以创建建筑
            buildBase.mapPos = MapPos;
            buildBase.Position = MapCopy.Instance.fixedTileMap.GetBuildPos(buildBase.buildData.BuildingSize, MapPos);
            buildBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            buildDict[buildBase.Logotype] = buildBase;
            MapCopy.Instance.BuildNode.AddChild(buildBase);
            //SpatialGrid.UpdateGrid(buildBase.steering);//维护空间网格
            CreateObject(buildBase, buildBase.buildData);
            FlowFieldSystem.Instance.CreateBaseObject(buildBase.Logotype, buildBase.mapPos, buildBase.buildData, false);
            return buildBase;
        }
        public void RemoveBuild(string Logotype, Vector2I mapPos, BuildData buildData)
        {
            if (buildDict.TryGetValue(Logotype, out var build))
            {
                buildDict.Remove(Logotype);
                ObjectManager.Instance.ReMoveObject(Logotype, mapPos, buildData);
                FlowFieldSystem.Instance.CreateBaseObject(Logotype, mapPos, buildData, true);
            }
        }
    }
}