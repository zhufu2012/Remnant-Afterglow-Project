using Godot;
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



        /// <summary>
        /// 创建一个炮塔
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">地图格位置</param>
        /// <returns></returns>
        public TowerBase CreateMapTower(int ObjectId, Vector2I MapPos)
        {
            TowerBase towerBase = GD.Load<PackedScene>("res://src/core/characters/towers/TowerBase.tscn").Instantiate<TowerBase>();
            towerBase.InitData(ObjectId);
            towerBase.mapPos = MapPos;
            towerBase.Position = MapCopy.Instance.fixedTileMap.GetBuildPos(towerBase.buildData.BuildingSize, MapPos);
            towerBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            towerDict[towerBase.Logotype] = towerBase;
            MapCopy.Instance.TowerNode.AddChild(towerBase);
            CreateObject(towerBase, towerBase.buildData);
            FlowFieldSystem.Instance.CreateBaseObject(towerBase, towerBase.buildData, false);
            towerBase.MobKilled += (BaseObject killObject, BaseObject casterObject, BulletNode bulletNode) =>
KilledAfter(killObject, casterObject, bulletNode);
            return towerBase;
        }
    }
}