using GameLog;
using Godot;
using SteeringBehaviors;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 场上实体管理器-
    /// BaseUnit = 1,//单位   1
    /// </summary>
    public partial class ObjectManager
    {
        /// <summary>
        /// 唯一id,对应单位
        /// </summary>
        public Dictionary<string, UnitBase> unitDict = new Dictionary<string, UnitBase>();
        public PackedScene unit_0_Scene = GD.Load<PackedScene>("res://src/core/characters/units/land/LandUnit.tscn");

        public PackedScene unit_3_Scene = GD.Load<PackedScene>("res://src/core/characters/units/air/AirUnit.tscn");
        public PackedScene unit_4_Scene = GD.Load<PackedScene>("res://src/core/characters/units/hull_land/HullLandUnit.tscn");
        public PackedScene unit_5_Scene = GD.Load<PackedScene>("res://src/core/characters/units/hull_air/HullAirUnit.tscn");
        /// <summary>
        /// 创建一个单位
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">对应地图位置</param>
        /// <param name="Pos">刷新点id</param>
        /// <returns></returns>
        public UnitBase CreateMapUnit(int ObjectId, Vector2I MapPos, Vector2I targetPos)
        {
            UnitLogic unitLogic = ConfigCache.GetUnitLogic(ObjectId);
            UnitBase unitBase = null;
            switch (unitLogic.UnitAIType)
            {
                case (int)UnitAIType.LandUnit://陆地单位
                    unitBase = unit_0_Scene.Instantiate<LandUnit>();
                    unitBase.Position = MapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
                    unitBase.InitData(ObjectId, 1);
                    unitBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
                    unitDict[unitBase.Logotype] = unitBase;
                    MapCopy.Instance.UnitNode.AddChild(unitBase);
                    unitBase.SetMovementTarget(targetPos);
                    unitBase.AnimatedSprite.GlobalRotation = unitBase.flow.GetDirection(MapPos).Angle() + Mathf.Pi / 2;
                    SpatialGrid.UpdateGrid(unitBase.steering);//维护空间网格
                    return unitBase;
                case (int)UnitAIType.AirUnit://空中单位
                    unitBase = unit_3_Scene.Instantiate<AirUnit>();
                    unitBase.Position = MapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
                    unitBase.InitData(ObjectId, 1);
                    unitBase.ZIndex = 10;//祝福注释-这里地图层要改,先用着
                    unitDict[unitBase.Logotype] = unitBase;
                    MapCopy.Instance.UnitNode.AddChild(unitBase);
                    unitBase.SetMovementTarget(targetPos);
                    return unitBase;
                case (int)UnitAIType.HullLandUnit://机甲形 陆地单位
                    unitBase = unit_4_Scene.Instantiate<HullLandUnit>();
                    unitBase.Position = MapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
                    unitBase.InitData(ObjectId, 1);
                    unitBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
                    unitDict[unitBase.Logotype] = unitBase;
                    MapCopy.Instance.UnitNode.AddChild(unitBase);
                    unitBase.SetMovementTarget(targetPos);
                    unitBase.AnimatedSprite.GlobalRotation = unitBase.flow.GetDirection(MapPos).Angle() + Mathf.Pi / 2;
                    SpatialGrid.UpdateGrid(unitBase.steering);//维护空间网格
                    return unitBase;
                case (int)UnitAIType.HullAirUnit://机甲形 空中单位
                    unitBase = unit_5_Scene.Instantiate<HullAirUnit>();
                    unitBase.Position = MapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
                    unitBase.InitData(ObjectId, 1);
                    unitBase.ZIndex = 10;//祝福注释-这里地图层要改,先用着
                    unitDict[unitBase.Logotype] = unitBase;
                    MapCopy.Instance.UnitNode.AddChild(unitBase);
                    unitBase.SetMovementTarget(targetPos);
                    return unitBase;
                default:
                    Log.Error($"单位object_id:{ObjectId},其单位类型{unitLogic.UnitAIType} 未处理！");
                    return unitBase;
            }
        }


        /// <summary>
        /// 单位死亡
        /// </summary>
        /// <param name="Logotype"></param>
        public void RemoveUnit(string Logotype)
        {
            if (unitDict.TryGetValue(Logotype, out var unit))
            {
                SpatialGrid.RemoveFromGrid(unit.steering);
                unitDict.Remove(Logotype);
            }
        }


    }
}