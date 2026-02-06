
namespace ManagedAttributes
{
    /// <summary>
    /// 属性接口
    /// </summary>
    public interface IAttrData
    {
        delegate void AttributeUpdatedHandler(IAttrData attribute);
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
        public ManagAttrCon container { get; set; }
        /// <summary>
        /// 自身全局属性库的引用
        /// </summary>
        public GloManagAttrCon glo_container { get; set; }
        public object GetObj(AttrDataType valType = AttrDataType.Value);
        public T Get<T>(AttrDataType valType = AttrDataType.Value);
        public T GetRaw<T>(AttrDataType valType = AttrDataType.Value);
        /// <summary>
        /// 修改值，会触发改变值事件
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        public void Set(object val, AttrDataType valType = AttrDataType.Value);

        /// <summary>
        /// 设置值，但不触发改变值事件
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        public abstract void SetKeyValue(object val, AttrDataType valType = AttrDataType.Value);
        public void Add(object val, AttrDataType valType = AttrDataType.Value);
        public void AddModifier(ManagAttrModifier mod);
        public void RemoveModifier(ManagAttrModifier mod);
        public void Update(ulong tick);
        public int GetId();

        /// <summary>
        /// 新增强类型方法-以避免装箱拆箱性能损耗
        /// </summary>
        /// <param name="val"></param>
        /// <param name="valType"></param>
        public void SetFloat(float val, AttrDataType valType = AttrDataType.Value);
        public float GetFloat(AttrDataType valType = AttrDataType.Value);


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
