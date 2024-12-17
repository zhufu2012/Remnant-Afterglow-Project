using System;
using System.Linq;
using System.Collections.Generic;
using Godot.Community.ControlBinding;

namespace Godot.Community.ManagedAttributes;



public abstract class ManagedAttribute<T> : ObservableObject, IManagedAttribute
{
    public event IManagedAttribute.AttributeUpdatedHandler AttributeUpdated;

    protected List<ManagedAttributeModifier> modifiers = new();
    /// <summary>
    /// 修改值，会触发改变值事件
    /// </summary>
    /// <param name="val"></param>
    /// <param name="valType"></param>
    public abstract void Set(object val, AttributeValueType valType = AttributeValueType.Value);
    /// <summary>
    /// 设置值，但不触发改变值事件
    /// </summary>
    /// <param name="val"></param>
    /// <param name="valType"></param>
    public abstract void SetKeyValue(object val, AttributeValueType valType = AttributeValueType.Value);
    public abstract void Add(object val, AttributeValueType valType = AttributeValueType.Value);
    protected abstract T Get(AttributeValueType valType = AttributeValueType.Value);
    protected abstract T GetRaw(AttributeValueType valType = AttributeValueType.Value);
    public string Name { get; init; } = "";

    public string GetName()
    {
        return Name;
    }

    public R GetAttr<R>()
    {
        return (R)(object)this;
    }

    public virtual void Update(ulong tick)
    {
        RemoveExpiredModifiers(tick);
    }

    public void AddModifier(ManagedAttributeModifier mod)
    {
        modifiers.Add(mod);
        //TODO: Event?
        OnModifierAdded(mod);
    }

    public void RemoveModifier(ManagedAttributeModifier mod)
    {
        modifiers.Remove(mod);
        //TODO: event?
        OnModifierRemoved(mod);
    }

    protected virtual void OnModifierAdded(ManagedAttributeModifier mod)
    {

    }

    protected virtual void OnModifierRemoved(ManagedAttributeModifier mod)
    {

    }

    /// <summary>
    /// 移除所有已过期的修饰符
    /// </summary>
    /// <param name="tick"></param>
    protected void RemoveExpiredModifiers(ulong tick)
    {
        var toRemove = new List<ManagedAttributeModifier>();
        foreach (var m in modifiers)
        {
            if (m.ExpiryTick <= tick)
            {
                m.OnModifierElapsed();
                toRemove.Add(m);
            }
        }
        foreach (var m in toRemove)
        {
            modifiers.Remove(m);
        }

        if (toRemove.Any())
        {
            AttributeUpdated?.Invoke(this);
        }
    }


    public virtual bool CanHandleType(Type type)
    {
        return type == typeof(T);
    }

    /// <summary>
    /// 值改变
    /// </summary>
    protected void RaiseHasChanged()
    {
        AttributeUpdated?.Invoke(this);
    }

    public virtual object GetObj(AttributeValueType valType = AttributeValueType.Value)
    {
        return (object)Get(valType);
    }

    public virtual R Get<R>(AttributeValueType valType = AttributeValueType.Value)
    {
        return (R)(object)Get(valType);
    }

    public virtual R GetRaw<R>(AttributeValueType valType = AttributeValueType.Value)
    {
        return (R)(object)GetRaw(valType);
    }







    /// <summary>
    /// 是否为模板属性
    /// </summary>
    public bool IsTemplateAttr { get; set; } = false;
    /// <summary>
    /// 模板实体id,仅模板属性使用
    /// </summary>
    public int TemplateObjectId { get; set; }



}

