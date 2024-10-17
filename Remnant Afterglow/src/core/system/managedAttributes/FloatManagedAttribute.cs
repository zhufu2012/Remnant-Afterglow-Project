using System;                       // 引入System命名空间，用于基本类型和异常
using Newtonsoft.Json;              // 引入Newtonsoft.Json命名空间，用于JSON序列化和反序列化

namespace Godot.Community.ManagedAttributes
{ // 定义命名空间

    // FloatManagedAttribute类，继承自ManagedAttribute基类，用于管理浮点数类型的属性
    public class FloatManagedAttribute : ManagedAttribute<float>
    {

        /// <summary>
        /// JSON属性，用于序列化和反序列化
        /// </summary>
        [JsonProperty]
        public float CurrentValue
        { // 当前值属性
            get => currentValue; // 获取当前值
            set => SetValue(ref currentValue, value); // 设置当前值，通过SetValue方法进行
        }

        /// <summary>
        /// 私有字段，用于存储实际的当前值
        /// </summary>
        private float currentValue;

        /// <summary>
        /// 最大值属性，用于限制属性的最大值
        /// </summary>
        [JsonProperty]
        public float MaxValue
        {
            get => maxValue; // 获取最大值
            set => SetValue(ref maxValue, value); // 设置最大值，通过SetValue方法进行
        }

        /// <summary>
        /// 私有字段，用于存储实际的最大值
        /// </summary>
        private float maxValue;

        /// <summary>
        /// 最小值属性，用于限制属性的最小值
        /// </summary>
        [JsonProperty]
        public float MinValue
        {
            get => minValue; // 获取最小值
            set => SetValue(ref minValue, value); // 设置最小值，通过SetValue方法进行
        }

        /// <summary>
        /// 私有字段，用于存储实际的最小值
        /// </summary>
        private float minValue;

        /// <summary>
        /// 再生值属性，用于计算每帧的再生量
        /// </summary>
        [JsonProperty]
        public float RegenValue
        {
            get => regenValue; // 获取再生值
            set => SetValue(ref regenValue, value); // 设置再生值，通过SetValue方法进行
        }

        /// <summary>
        /// 私有字段，用于存储实际的再生值
        /// </summary>
        private float regenValue;

        /// <summary>
        /// 默认构造函数，初始化当前值为0，最小值为float.MinValue，最大值为float.MaxValue
        /// </summary>
        /// <param name="name"></param>
        public FloatManagedAttribute(string name)
        {
            Name = name;
            CurrentValue = 0; // 初始化当前值为0
            MinValue = float.MinValue; // 设置最小值为浮点数的最小值
            MaxValue = float.MaxValue; // 设置最大值为浮点数的最大值
        }

        /// <summary>
        /// 构造函数，初始化当前值，最小值为float.MinValue，最大值为float.MaxValue
        /// </summary>
        /// <param name="name">属性名称</param>
        /// <param name="val">属性当前值</param>
        public FloatManagedAttribute(int attr_id, float val)
        {
            Name = "" + attr_id;
            CurrentValue = val; // 设置当前值
            MinValue = float.MinValue; // 设置最小值为浮点数的最小值
            MaxValue = float.MaxValue; // 设置最大值为浮点数的最大值
        }

        /// <summary>
        /// 构造函数，初始化当前值，最小值和最大值
        /// </summary>
        /// <param name="name">属性名称</param>
        /// <param name="val">属性当前值</param>
        /// <param name="min">最小值</param>
        /// <param name="max">最大值</param>
        public FloatManagedAttribute(int attr_id, float val, float min, float max)
        {
            Name = "" + attr_id;
            CurrentValue = val; // 设置当前值
            MinValue = min; // 设置最小值
            MaxValue = max; // 设置最大值
        }


        /// <summary>
        /// 构造函数，初始化当前值，最小值和最大值
        /// </summary>
        /// <param name="name">属性名称</param>
        /// <param name="val">属性当前值</param>
        /// <param name="min">最小值</param>
        /// <param name="max">最大值</param>
        /// <param name="Regen">再生值</param>
        public FloatManagedAttribute(int attr_id, float val, float min, float max, float Regen)
        {
            Name = "" + attr_id;
            CurrentValue = val; // 设置当前值
            MinValue = min; // 设置最小值
            MaxValue = max; // 设置最大值
            RegenValue = Regen;//设置再生值
        }

        /// <summary>
        /// 将对象转换为浮点数的方法
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        /// <exception cref="InvalidCastException"></exception>
        public float ObjectToFloat(object obj)
        {
            // 尝试将对象转换为不同的数字类型
            if (obj is int intObj)
            {
                return (float)intObj; // 转换为整数
            }
            if (obj is Int32 int32Obj)
            {
                return (float)int32Obj; // 转换为32位整数
            }
            if (obj is float floatObj)
            {
                return floatObj; // 直接返回浮点数
            }
            if (obj is string stringObj)
            { // 尝试从字符串解析浮点数
                if (float.TryParse(stringObj, out float retValue))
                {
                    return retValue; // 成功解析，返回浮点数
                }
            }
            throw new InvalidCastException($"Invalid type. Expected float, got {obj.GetType().Name}"); // 抛出异常，如果无法转换
        }

        /// <summary>
        /// Set方法，用于设置属性的值
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        public override void Set(object val, AttributeValueType valType = AttributeValueType.Value)
        {
            var numVal = ObjectToFloat(val); // 将传入的对象转换为浮点数
            float retValue = valType switch
            { // 根据属性类型设置值
                AttributeValueType.Min => SetMinValue(numVal,true),
                AttributeValueType.Value => SetValue(numVal,true),
                AttributeValueType.Max => SetMaxValue(numVal,true),
                AttributeValueType.Regen => SetRegenValue(numVal),
                _ => throw new ArgumentOutOfRangeException(nameof(valType), valType, null),
            };
        }

        /// <summary>
        /// 设置值，但不触发改变值事件
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        public override void SetKeyValue(object val, AttributeValueType valType = AttributeValueType.Value)
        {
            var numVal = ObjectToFloat(val); // 将传入的对象转换为浮点数
            float retValue = valType switch
            { // 根据属性类型设置值
                AttributeValueType.Min => SetMinValue(numVal, false),
                AttributeValueType.Value => SetValue(numVal, false),
                AttributeValueType.Max => SetMaxValue(numVal, false),
                AttributeValueType.Regen => SetRegenValue(numVal),
                _ => throw new ArgumentOutOfRangeException(nameof(valType), valType, null),
            };
        }

        /// <summary>
        /// Get方法，用于获取属性的值，考虑修饰器的影响
        /// </summary>
        /// <param name="valType">值类型</param>
        /// <returns></returns>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        protected override float Get(AttributeValueType valType = AttributeValueType.Value)
        {
            float retValue = valType switch
            { // 根据属性类型获取值
                AttributeValueType.Min => Calculate(AttributeValueType.Min),
                AttributeValueType.Value => Calculate(AttributeValueType.Value),
                AttributeValueType.Max => Calculate(AttributeValueType.Max),
                AttributeValueType.Regen => Calculate(AttributeValueType.Regen),
                _ => throw new ArgumentOutOfRangeException(nameof(valType), valType, null),
            };
            return retValue;
        }

        /// <summary>
        /// 计算属性值的方法，考虑修饰器的影响
        /// </summary>
        /// <param name="valType">值类型</param>
        /// <returns></returns>
        private float Calculate(AttributeValueType valType = AttributeValueType.Value)
        {
            var result = GetRaw(valType); // 获取原始值
            foreach (var m in modifiers)
            { // 遍历所有修饰器
                if (m.ModifierValues.ContainsKey(valType) && m.ModifierValues[valType] is ManagedAttributeModifierValue mamv)
                { // 如果修饰器包含此属性类型
                    result += mamv.Add; // 应用加成
                    result = mamv.Multiplier * result; // 应用乘法
                }
            }
            return result;
        }

        /// <summary>
        /// GetRaw方法，用于获取属性的原始值，不考虑修饰器的影响
        /// </summary>
        /// <param name="valType">值类型</param>
        /// <returns></returns>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        protected override float GetRaw(AttributeValueType valType = AttributeValueType.Value)
        {
            float retValue = valType switch
            { // 根据属性类型获取原始值
                AttributeValueType.Min => MinValue,
                AttributeValueType.Value => CurrentValue,
                AttributeValueType.Max => MaxValue,
                AttributeValueType.Regen => RegenValue,
                _ => throw new ArgumentOutOfRangeException(nameof(valType), valType, null),
            };
            return retValue;
        }

        /// <summary>
        /// Add方法，用于增加属性的值
        /// </summary>
        /// <param name="val">值</param>
        /// <param name="valType">值类型</param>
        /// <exception cref="ArgumentOutOfRangeException"></exception>
        public override void Add(object val, AttributeValueType valType = AttributeValueType.Value)
        {
            var numVal = ObjectToFloat(val); // 将传入的对象转换为浮点数
            float retValue = valType switch
            { // 根据属性类型增加值
                AttributeValueType.Min => SetMinValue(MinValue + numVal,true),
                AttributeValueType.Value => SetValue(CurrentValue + numVal,true),
                AttributeValueType.Max => SetMaxValue(MaxValue + numVal,true),
                AttributeValueType.Regen => SetRegenValue(RegenValue + numVal),
                _ => throw new ArgumentOutOfRangeException(nameof(valType), valType, null),
            };
        }

        /// <summary>
        /// Clamp方法，用于限制属性值在最小值和最大值之间
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        protected float Clamp(float val)
        {
            if (val > MaxValue)
            {
                val = MaxValue; // 如果大于最大值，设置为最大值
            }
            if (val < MinValue)
            {
                val = MinValue; // 如果小于最小值，设置为最小值
            }
            return val; // 返回当前值（实际上应返回受限后的值）
        }

        /// <summary>
        /// SetMinValue方法，用于设置最小值并检查是否需要调整当前值
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        protected float SetMinValue(float val, bool IsRunChanged)
        {
            var raiseChanged = MinValue != val; // 检查最小值是否改变
            MinValue = val; // 设置新的最小值
            if (CurrentValue < MinValue)
            {
                CurrentValue = MinValue; // 如果当前值小于最小值，设置当前值为最小值
                raiseChanged = true; // 标记为已改变
            }
            if (MaxValue < MinValue)
            {
                MaxValue = MinValue; // 如果最大值小于最小值，设置最大值为最小值
                raiseChanged = true; // 标记为已改变
            }
            if (raiseChanged && IsRunChanged)
            {
                RaiseHasChanged(); // 如果任何值改变，触发变更事件
            }
            return MinValue; // 返回新的最小值
        }

        /// <summary>
        /// SetValue方法，用于设置当前值并检查是否需要调整
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        protected float SetValue(float val, bool IsRunChanged)
        {
            var originalValue = CurrentValue; // 保存原始值
            CurrentValue = Clamp(val); // 设置新的当前值，通过Clamp方法限制范围
            if (originalValue != CurrentValue && IsRunChanged)
            {
                RaiseHasChanged(); // 如果值改变，触发变更事件
            }
            return CurrentValue; // 返回新的当前值
        }

        /// <summary>
        /// SetMaxValue方法，用于设置最大值并检查是否需要调整当前值
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        protected float SetMaxValue(float val, bool IsRunChanged)
        {
            var raiseChanged = MaxValue != val; // 检查最大值是否改变
            MaxValue = val; // 设置新的最大值
            if (CurrentValue > MaxValue)
            {
                CurrentValue = MaxValue; // 如果当前值大于最大值，设置当前值为最大值
                raiseChanged = true; // 标记为已改变
            }
            if (MinValue > MaxValue)
            {
                MinValue = MaxValue; // 如果最小值大于最大值，设置最小值为最大值
                raiseChanged = true; // 标记为已改变
            }
            if (raiseChanged && IsRunChanged)
            {
                RaiseHasChanged(); // 如果任何值改变，触发变更事件
            }
            return MaxValue; // 返回新的最大值
        }

        /// <summary>
        /// SetRegenValue方法，用于设置再生值
        /// </summary>
        /// <param name="val"></param>
        /// <returns></returns>
        protected float SetRegenValue(float val)
        {
            RegenValue = val; // 设置新的再生值
            return RegenValue; // 返回新的再生值
        }

        /// <summary>
        /// Update方法，用于每帧更新属性，如再生
        /// </summary>
        /// <param name="tick">时间戳或计数</param>
        public override void Update(ulong tick)
        {
            base.Update(tick); // 调用基类的更新方法
            // 再生逻辑
            var originalVal = CurrentValue; // 保存原始的当前值
            CurrentValue = Clamp(CurrentValue + RegenValue); // 应用再生值，并限制范围
            if (originalVal != CurrentValue)
            {
                RaiseHasChanged(); // 如果值改变，触发变更事件
            }
        }

        /// <summary>
        /// OnModifierAdded方法，用于当添加修饰器时的逻辑
        /// </summary>
        /// <param name="mod"></param>
        protected override void OnModifierAdded(ManagedAttributeModifier mod)
        {
            if (mod.ModifierValues.ContainsKey(AttributeValueType.Max) && CurrentValue > Get(AttributeValueType.Max))
            {
                CurrentValue = Get(AttributeValueType.Max); // 如果当前值大于最大值，设置当前值为最大值
            }
            if (mod.ModifierValues.ContainsKey(AttributeValueType.Max) && CurrentValue < Get(AttributeValueType.Min))
            {
                CurrentValue = Get(AttributeValueType.Min); // 如果当前值小于最小值，设置当前值为最小值
            }
        }
    }
}