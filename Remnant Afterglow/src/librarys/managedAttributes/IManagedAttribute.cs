
namespace Godot.Community.ManagedAttributes
{
    /// <summary>
    /// 属性接口
    /// </summary>
    public interface IManagedAttribute
    {
        delegate void AttributeUpdatedHandler(IManagedAttribute attribute);
        event AttributeUpdatedHandler AttributeUpdated;

        /// <summary>
        /// 伤害优先级，大于0的部分，才属于血量类型的，
        /// </summary>
        public int Priority { get; set; }

        /// <summary>
        /// 是否更新该属性,默认为true
        /// </summary>
        public bool Used{ get; set; }
        /// <summary>
        /// 自身属性库的引用
        /// </summary>
        public ManagedAttributeContainer container { get; set; }
        public object GetObj(AttributeValueType valType = AttributeValueType.Value);
        public T Get<T>(AttributeValueType valType = AttributeValueType.Value);
        public T GetRaw<T>(AttributeValueType valType = AttributeValueType.Value);
        /// <summary>
        /// 修改值，会触发改变值事件
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        public void Set(object val, AttributeValueType valType = AttributeValueType.Value);

        /// <summary>
        /// 设置值，但不触发改变值事件
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        public abstract void SetKeyValue(object val, AttributeValueType valType = AttributeValueType.Value);
        public void Add(object val, AttributeValueType valType = AttributeValueType.Value);
        public void AddModifier(ManagedAttributeModifier mod);
        public void RemoveModifier(ManagedAttributeModifier mod);
        public void Update(ulong tick);
        public string GetName();


        /// <summary>
        /// 是否为模板属性
        /// </summary>
        public bool IsTemplateAttr { get; set; }
        /// <summary>
        /// 模板实体id,仅模板属性使用
        /// </summary>
        public int TemplateObjectId { get; set; }
    }
}
