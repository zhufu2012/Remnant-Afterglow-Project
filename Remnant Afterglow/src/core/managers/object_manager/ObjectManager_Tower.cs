using GameLog;
using Godot;
using SteeringBehaviors;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 场上实体管理器-
    /// BaseTower = 2,//炮塔  2
    /// </summary>
    public partial class ObjectManager
    {
        /// <summary>
        /// 唯一id,对应单位
        /// </summary>
        public Dictionary<string, TowerBase> towerDict = new Dictionary<string, TowerBase>();

        public static PackedScene towerScene = GD.Load<PackedScene>("res://src/core/characters/towers/TowerBase.tscn");

        /// <summary>
        /// 创建一个炮塔
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">地图格位置</param>
        /// <returns></returns>
        public TowerBase CreateMapTower(int ObjectId, Vector2I MapPos)
        {
            TowerBase towerBase = towerScene.Instantiate<TowerBase>();
            towerBase.Camp = PlayerCamp;//设置所在阵营
            towerBase.InitData(ObjectId, 1);
            towerBase.mapPos = MapPos;
            towerBase.Position = MapCopy.Instance.fixedTileMap.GetBuildPos(towerBase.buildData.BuildingSize, MapPos);
            towerBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            towerDict[towerBase.Logotype] = towerBase;
            MapCopy.Instance.TowerNode.AddChild(towerBase);
            CreateObject(towerBase, towerBase.buildData);
            FlowFieldSystem.Instance.CreateBaseObject(towerBase.Logotype, towerBase.mapPos, towerBase.buildData, false);
            return towerBase;
        }

        /// <summary>
        /// 创建一个炮塔，在地图生成时使用的，
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">地图格位置</param>
        /// <returns></returns>
        public TowerBase CreateMapTower(int ObjectId, int Camp, Vector2I MapPos)
        {
            TowerBase towerBase = towerScene.Instantiate<TowerBase>();
            towerBase.Camp = Camp;//设置所在阵营
            towerBase.InitData(ObjectId, 0);
            towerBase.mapPos = MapPos;
            towerBase.Position = MapCopy.Instance.fixedTileMap.GetBuildPos(towerBase.buildData.BuildingSize, MapPos);
            towerBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            towerDict[towerBase.Logotype] = towerBase;
            MapCopy.Instance.TowerNode.AddChild(towerBase);
            CreateObject(towerBase, towerBase.buildData);
            FlowFieldSystem.Instance.CreateBaseObject(towerBase.Logotype, towerBase.mapPos, towerBase.buildData, false);
            return towerBase;
        }

        public void RemoveTower(string Logotype, Vector2I mapPos, BuildData buildData)
        {
            if (towerDict.TryGetValue(Logotype, out var tower))
            {
                towerDict.Remove(Logotype);
                ObjectManager.Instance.ReMoveObject(Logotype, mapPos, buildData);
                FlowFieldSystem.Instance.CreateBaseObject(Logotype, mapPos, buildData, true);
            }
        }
    }
}