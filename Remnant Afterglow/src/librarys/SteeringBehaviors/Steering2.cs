using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;


namespace SteeringBehaviors
{
    // Steering类补充
    public class Steering2
    {
        // 新增字段
        // 修改LastCoveredCells为自动初始化
        public HashSet<Vector2I> LastCoveredCells { get; set; } = new HashSet<Vector2I>();

        // 析构时自动移除
        ~Steering2()
        {
            SpatialGrid2.FullRemoveFromGrid(this);
        }
        public Vector2 Size { get; set; } = new Vector2(10, 10); // 对象尺寸
        public BaseObject baseObject;
        /// <summary>
        /// 行为模式提供的力
        /// </summary>
        public Vector2 steer_force;
        /// <summary>
        /// 质量
        /// </summary>
        public int Mass = 1;
        /// <summary>
        /// 唯一id
        /// </summary>
        public string Logotype;
        /// <summary>
        /// 上一次网格位置
        /// </summary>
        public Vector2I LastGridCell { get; set; }
        /// <summary>
        /// 分离半径
        /// </summary>
        public float SeparationRadius = 15;
        /// <summary>
        /// 分离半径
        /// </summary>
        public float SeparationRadiuSq = 225;
        public Rect2 GetAABB() => new Rect2(
            baseObject.Position - Size / 2, // 假设Position是中心点
            Size
        );
        public Steering2(BaseObject baseObject, int Rad, int Mass)
        {
            this.baseObject = baseObject;
            // 为不同单位类型添加随机偏移
            this.Mass = Mass;
            Size = new Vector2(Rad, Rad);
        }


        public void Update()
        {
            SpatialGrid2.UpdateGrid(this);
            steer_force = SpatialGrid2.GetSeparation(this);
        }
    }
}
