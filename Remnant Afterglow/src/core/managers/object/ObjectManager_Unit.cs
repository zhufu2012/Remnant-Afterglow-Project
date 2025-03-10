using Godot;
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


        /// <summary>
        /// 创建一个单位
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">对应地图位置</param>
        /// <returns></returns>
        public UnitBase CreateMapUnit(int ObjectId, Vector2I MapPos)
        {
            Vector2 Pos = MapPos * MapConstant.TileCellSize + MapConstant.TileCellSizeVector2I / 2;
            return CreateUnit(ObjectId, Pos);
        }

        /// <summary>
        /// 创建一个单位
        /// </summary>
        /// <param name="ObjectId">实体id</param>
        /// <param name="Pos">创建位置</param>
        /// <returns></returns>
        public UnitBase CreateUnit(int ObjectId, Vector2 Pos)
        {
            UnitBase unitBase = (UnitBase)GD.Load<PackedScene>("res://src/core/characters/units/UnitBase.tscn").Instantiate();
            unitBase.Position = Pos;
            unitBase.InitData(ObjectId);
            unitBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            unitDict[unitBase.Logotype] = unitBase;
            MapCopy.Instance.UnitNode.AddChild(unitBase);

            Vector2I Target = new Vector2I(28, 36);
            unitBase.SetMovementTarget(Target);//祝福注释-测试用-要去掉
            unitBase.MobKilled += (BaseObject killObject, BaseObject casterObject, BulletNode bulletNode) =>
KilledAfter(killObject, casterObject,bulletNode);
            return unitBase;
        }



    }
}