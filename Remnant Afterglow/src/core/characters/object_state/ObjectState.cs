using Godot;

namespace Remnant_Afterglow{
    /// <summary>
    /// 实体状态
    ///1 默认枚举-静止时状态
    ///2 移动枚举-移动时状态
    ///3 静止攻击状态
    ///4 装填状态
    ///5 工作状态
    ///6 移动攻击状态
    ///10 死亡状态
    /// </summary>
    public enum ObjectState{
        UnderBuild = 0,     //建造中
        Default = 1,        //默认
        Move = 2,           //移动
        Attack = 3,         //攻击
        Fill = 4,           //装填
        Worker = 5,         //工作
        Move_Attack = 6,    //移动攻击
        Die = 10            //死亡
    }

    /// <summary>
    /// 预制动画名称
    ///1 默认动画
    ///2 移动动画
    ///3 攻击动画
    ///4 装填动画
    ///5 工作动画
    ///6 子弹命中-特殊的，无枚举
    ///7 子弹消失-特殊的，无枚举
    ///10 死亡动画-死亡时播放动画
    /// </summary>
    public static class ObjectStateNames
    {
        /// <summary>
        /// 默认动画-播放动画时没有对应动画就播放这个
        /// </summary>
        public static readonly StringName UnderBuild = "0";
        /// <summary>
        /// 默认动画-播放动画时没有对应动画就播放这个
        /// </summary>
        public static readonly StringName Default = "1";
        /// <summary>
        /// 移动动画
        /// </summary>
        public static readonly StringName Move = "2";
        /// <summary>
        /// 攻击动画
        /// </summary>
        public static readonly StringName Attack = "3";

        /// <summary>
        /// 装填动画
        /// </summary>
        public static readonly StringName Fill = "4";

        /// <summary>
        /// 工作动画
        /// </summary>
        public static readonly StringName Worker = "5";
        /// <summary>
        /// 移动攻击动画
        /// </summary>
        public static readonly StringName Move_Attack = "6";
        /// <summary>
        /// 死亡动画，死亡时播放，播放完之后就死
        /// </summary>
        public static readonly StringName Die = "10";

        /// <summary>
        /// 将状态转换为动画名称
        /// </summary>
        /// <param name="state"></param>
        /// <returns></returns>
        public static string GetNames(ObjectState state)
        {
            switch(state)
            {
                case ObjectState.UnderBuild:        //默认
                    return UnderBuild;
                case ObjectState.Default:        //默认
                    return Default;
                case ObjectState.Move:           //移动
                    return Move;
                case ObjectState.Attack:         //攻击
                    return Attack;
                case ObjectState.Fill:           //装填
                    return Fill;
                case ObjectState.Worker:         //工作
                    return Worker;
                case ObjectState.Move_Attack:    //移动攻击
                    return Move_Attack;
                case ObjectState.Die:            //死亡
                    return Die;
                default:
                    return Default;
            }

        }

    }
}