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
            Vector2 Pos = MapPos * MapConstant.TileCellSize - new Vector2I(MapConstant.TileCellSize / 2, MapConstant.TileCellSize / 2);
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
            UnitBase unitBase = new UnitBase(ObjectId);
            unitBase.Position = Pos;
            unitBase.ZIndex = 9;//祝福注释-这里地图层要改,先用着
            unitDict[unitBase.Logotype] = unitBase;
            MapCopy.Instance.UnitNode.AddChild(unitBase);

            Vector2I Target = new Vector2I(30, 38);
            unitBase.SetMovementTarget(Target);//祝福注释-测试用-要去掉
            Sprite2D ss = new Sprite2D();
            ss.Position = Target;
            ss.Texture = GD.Load<Texture2D>("res://Test/UnitTest/士兵装饰.png");
            MapCopy.Instance.AddChild(ss);
            return unitBase;
        }

        /// <summary>
        /// 单位死亡后处理
        /// </summary>
        /// <param name="casterObject"></param>
        private void UnitKilledAfter(BaseObject casterObject)
        {


            casterObject.QueueFree();
        }

    }
}