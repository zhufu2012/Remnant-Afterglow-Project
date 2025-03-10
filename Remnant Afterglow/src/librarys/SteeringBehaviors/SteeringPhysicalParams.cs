namespace SteeringBehaviors
{
    // 定义了转向行为中使用的物理参数。
    public class SteeringPhysicalParams
    {
        // 质量，可以为 null 表示未设置。
        public float? Mass { get; set; }

        // 最大速度，可以为 null 表示未设置。
        public float? MaxVelocity { get; set; }

        // 最大力度，可以为 null 表示未设置。
        public float? MaxForce { get; set; }

        // 提供默认物理参数的静态方法。
        // 默认情况下，实体的质量为 10f，最大速度为 3.9f，最大力度为 3.8f。
        public static SteeringPhysicalParams Defaults()
        {
            return new SteeringPhysicalParams
            {
                Mass = 10f,           // 默认质量
                MaxForce = 3.8f,      // 默认最大力
                MaxVelocity = 3.9f    // 默认最大速度
            };
        }
    }
}