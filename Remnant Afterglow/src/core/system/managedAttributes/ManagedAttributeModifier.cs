using System;                // 导入基本的系统命名空间
using System.Collections.Generic; // 导入集合框架命名空间
using Godot;                 // 导入Godot游戏引擎的命名空间

namespace Godot.Community.ManagedAttributes { // 定义命名空间

    // 定义ManagedAttributeModifier类，用于表示对ManagedAttribute的修饰
    public class ManagedAttributeModifier {

        /// <summary>
        /// 定义委托类型，用于处理修饰器过期事件
        /// </summary>
        /// <param name="modifier"></param>
        public delegate void AttributeModifierElapsedHandler(ManagedAttributeModifier modifier);

        /// <summary>
        /// 定义事件，当修饰器过期时触发
        /// </summary>
        public event AttributeModifierElapsedHandler AttributeModifierElapsed;

        /// <summary>
        /// 字典，存储不同类型属性的修饰值
        /// </summary>
        public Dictionary<AttributeValueType, ManagedAttributeModifierValue> ModifierValues { get; set; } = new();

        /// <summary>
        /// 当前修饰器应用的时间戳
        /// </summary>
        public ulong ApplyTick { get; set; }

        /// <summary>
        /// 修饰器过期的时间戳
        /// </summary>
        public ulong ExpiryTick { get; set; }

        /// <summary>
        /// 唯一标识符，用于唯一识别每个修饰器
        /// </summary>
        public Guid Id = new();

        /// <summary>
        /// 方法，当修饰器过期时调用
        /// </summary>
        public void OnModifierElapsed() {
            // 触发AttributeModifierElapsed事件，参数为当前修饰器实例
            AttributeModifierElapsed?.Invoke(this);
        }
    }

    /// <summary>
    /// 定义ManagedAttributeModifierValue类，用于存储修饰器的具体数值
    /// </summary>
    public class ManagedAttributeModifierValue {

        /// <summary>
        /// 属性Add，表示修饰器的加成数值
        /// </summary>
        public int Add { get; set; } = 0;

        /// <summary>
        /// 属性Multiplier，表示修饰器的乘法系数
        /// </summary>
        public float Multiplier { get; set; } = 1f;
    }
}