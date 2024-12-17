using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Godot.Community.ManagedAttributes
{
    /// <summary>
    /// 属性接口
    /// </summary>
    public interface IManagedAttribute
    {
        delegate void AttributeUpdatedHandler(IManagedAttribute attribute);
        event AttributeUpdatedHandler AttributeUpdated;

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
