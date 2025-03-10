using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 建造格子-全地图哪些地块可建造，可以建造且没有占据就行
    /// </summary>
    public class BuildCell
    {
        /// <summary>
        /// 是否可以建造
        /// </summary>
        public bool IsBuild = false;
        /// <summary>
        /// 是否被占据
        /// </summary>
        public bool IsOccupy = false;
        /// <summary>
        /// 当前格子是哪个格子的建筑占据的
        /// </summary>
        public Vector2I BuildPos = new Vector2I(-1, -1);
        /// <summary>
        /// 对应格子的建筑项数据-只有占据的格子才有
        /// </summary>
        public BuildData buildData = null;
        /// <summary>
        /// 建筑类型
        ///0 建筑
        ///1 炮塔
        /// </summary>
        public int BuildType = 0;
        public BuildCell()
        {

        }
        public BuildCell(bool IsBuild)
        {
            this.IsBuild = IsBuild;
        }

        public override string ToString()
        {
            return "" + IsBuild + "   " + IsOccupy;
        }
    }
    /// <summary>
    /// 场上实体管理器-
    /// BaseUnit = 1,//单位   1
    /// BaseTower = 2,//炮塔  2
    /// BaseBuild = 3,//建筑  3
    /// BaseWeapon = 4,//武器  4
    /// WorkerBase = 5,//无人机  5
    /// </summary>
    public partial class ObjectManager
    {

        /// <summary>
        /// 实体管理器单例
        /// </summary>
        public static ObjectManager Instance { get; set; }
        /// <summary>
        /// 地图宽度
        /// </summary>
        public int Width;
        /// <summary>
        /// 地图高度
        /// </summary>
        public int Height;

        public static BuildCell[,] buildCells;
        /// <summary>
        /// 地板层 地图-如果地板层有修改，这里也要修改-祝福注释
        /// </summary>
        public Cell[,] layerData;

        /// <summary>
        /// 实体管理器
        /// </summary>
        public ObjectManager(int Width, int Height, Cell[,] layer)
        {
            Instance = this;
            this.Width = Width;
            this.Height = Height;
            layerData = layer;
            buildCells = new BuildCell[Width, Height];
            for (int i = 0; i < Width; i++)
            {
                for (int j = 0; j < Height; j++)
                {
                    if (layerData[i, j].index != 0)
                    {
                        MapPassType mapPassType = FlowFieldSystem.Instance.passDict[layerData[i, j].index];
                        buildCells[i, j] = new BuildCell(mapPassType.IsBuild);//设置地块的是否可建造
                    }
                    else
                    {
                        buildCells[i, j] = new BuildCell(false);//设置地块的是否可建造
                    }
                }
            }
        }

        /// <summary>
        /// 是否可建造
        /// </summary>
        /// <param name="buildData"></param>
        /// <param name="mapPos"></param>
        /// <returns></returns>
        public bool CanCreateBuild(BuildData buildData, Vector2I mapPos)
        {
            int size = buildData.BuildingSize; // 建筑占地
            int p = size / 2; // 默认奇数
            bool isEven = size % 2 == 0; // 是否为偶数
            for (int i = mapPos.X - p; i <= mapPos.X + p + (isEven ? -1 : 0); i++)
            {
                for (int j = mapPos.Y - p; j <= mapPos.Y + p + (isEven ? -1 : 0); j++)
                {
                    if (i < 0 || i >= Width || j < 0 || j >= Height)
                        return false;
                    BuildCell cell = buildCells[i, j];
                    if (cell.IsBuild && !cell.IsOccupy)

                        continue;
                    // 如果单元格不符合条件，直接返回 false
                    return false;
                }
            }
            
            Vector2 vectPos = mapPos * MapConstant.TileCellSizeVector2I;
            float CreateDistanceSq = Mathf.Pow((MapConstant.CreateDistanceSq + size / 2) * MapConstant.TileCellSize, 2f);
            foreach (var entry in unitDict)
            {
                var globalPos = entry.Value.GlobalPosition;
                var deltaX = globalPos.X - vectPos.X;
                var deltaY = globalPos.Y - vectPos.Y;
                if (deltaX * deltaX + deltaY * deltaY < CreateDistanceSq)
                {
                    return false;
                }
            }
            // 所有单元格都符合条件，返回 true
            return true;
        }



        /// <summary>
        /// 创建一个实体，维护建造列表
        /// </summary>
        public void CreateObject(BaseObject baseObject, BuildData buildData)
        {
            Vector2I mapPos = baseObject.mapPos; // 当前地图位置
            int size = buildData.BuildingSize; // 建筑占地
            int p = size / 2; // 默认奇数
            bool isEven = size % 2 == 0; // 是否为偶数
            switch (IdGenerator.GetType(baseObject.Logotype))
            {
                case IdConstant.ID_TYPE_TOWER: // 炮塔
                case IdConstant.ID_TYPE_BUILD: // 建筑
                    for (int i = mapPos.X - p; i <= mapPos.X + p + (isEven ? -1 : 0); i++)
                    {
                        for (int j = mapPos.Y - p; j <= mapPos.Y + p + (isEven ? -1 : 0); j++)
                        {
                            buildCells[i, j].IsOccupy = true;
                            buildCells[i, j].buildData = buildData;
                            buildCells[i, j].BuildPos = mapPos;
                        }
                    }
                    break;
                default:
                    Log.Error($"获取实体的类型报错！LogoType: {baseObject.Logotype},{IdGenerator.GetType(baseObject.Logotype)}");
                    break;
            }
        }

        /// <summary>
        /// 实体死亡或者移除，维护建造列表
        /// </summary>
        /// <param name="baseObject"></param>
        /// <param name="buildData"></param>
        public void ReMoveObject(BaseObject baseObject, BuildData buildData)
        {
            Vector2I mapPos = baseObject.mapPos; // 当前地图位置
            int size = buildData.BuildingSize; // 建筑占地
            int p = size / 2; // 默认奇数
            bool isEven = size % 2 == 0; // 是否为偶数
            switch (IdGenerator.GetType(baseObject.Logotype))
            {
                case IdConstant.ID_TYPE_TOWER: // 炮塔
                case IdConstant.ID_TYPE_BUILD: // 建筑
                    for (int i = mapPos.X - p; i <= mapPos.X + p + (isEven ? -1 : 0); i++)
                    {
                        for (int j = mapPos.Y - p; j <= mapPos.Y + p + (isEven ? -1 : 0); j++)
                        {
                            buildCells[i, j].IsOccupy = false;
                            buildCells[i, j].buildData = null;
                            buildCells[i, j].BuildPos = new Vector2I(-1, -1);
                        }
                    }
                    break;
                default:
                    Log.Error($"获取实体的类型报错！LogoType: {baseObject.Logotype},{IdGenerator.GetType(baseObject.Logotype)}");
                    break;
            }
        }

        /// <summary>
        /// 死亡后处理
        /// </summary>
        /// <param name="killObject"></param>
        /// <param name="casterObject"></param>
        /// <param name="bulletNode"></param>
        public static void KilledAfter(BaseObject killObject, BaseObject casterObject, BulletNode bulletNode)
        {
            Log.Print("死亡！"+killObject.Logotype+"    "+casterObject.Logotype);
            //killObject.QueueFree();//此时才清空
        }

        /// <summary>
        /// 受伤后处理
        /// </summary>
        /// <param name="killObject"></param>
        /// <param name="casterObject"></param>
        /// <param name="bulletNode"></param>
        public static void HarmedAfter(BaseObject killObject, BaseObject casterObject, BulletNode bulletNode)
        {
            Log.Print("死亡！！！！！！！！！！");
            //killObject.QueueFree();//此时才清空
        }


        /// <summary>
        /// 特殊更新逻辑
        /// </summary>
        /// <param name="delta"></param>
        public void Update(double delta)
        {
        }


        /// <summary>
        /// 获取实体的类型
        /// </summary>
        /// <param name="Logotype">唯一id</param>
        /// <returns></returns>
        public static BaseObjectType GetObjectType(string Logotype)
        {
            switch (IdGenerator.GetType(Logotype))
            {
                case IdConstant.ID_TYPE_UNIT://单位
                    return BaseObjectType.BaseUnit;
                case IdConstant.ID_TYPE_TOWER://炮塔
                    return BaseObjectType.BaseTower;
                case IdConstant.ID_TYPE_BUILD://建筑
                    return BaseObjectType.BaseBuild;
                case IdConstant.ID_TYPE_WORKER://无人机
                    return BaseObjectType.BaseWorker;
                default:
                    Log.Error(" 获取实体的类型报错！LogoType:", Logotype);
                    return BaseObjectType.BaseUnit;
            }
        }

    }
}