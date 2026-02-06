using Remnant_Afterglow;
using System.Collections.Generic;
using Godot;

namespace SteeringBehaviors
{
    /// <summary>
    /// 对象 - 行为模式整合类
    /// </summary>
    public class Steering
    {
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
        /// 分离半径平方
        /// </summary>
        public float SeparationRadiuSq = 225;

        public Steering(BaseObject baseObject, int Rad, int Mass)
        {
            this.baseObject = baseObject;
            Logotype = baseObject.Logotype;
            // 为不同单位类型添加随机偏移
            SeparationRadius = Rad;
            SeparationRadiuSq = Rad * Rad;
            this.Mass = Mass;
        }

        //int index = 0;
        /// <summary>
        /// 行为模式力-更新
        /// </summary>
        public void Update()
        {
            steer_force = SpatialGrid.GetSeparation(Logotype, Mass, baseObject.Position, SeparationRadius);
        }

    }
}
