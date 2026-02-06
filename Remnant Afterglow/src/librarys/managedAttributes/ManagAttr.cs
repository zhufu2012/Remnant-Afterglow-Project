using System;
using System.Linq;
using System.Collections.Generic;
using Godot.Community.ControlBinding;
using GameLog;

namespace ManagedAttributes;



public abstract class ManagAttr<T> : ObservableObject, IAttrData
{
	public event IAttrData.AttributeUpdatedHandler AttributeUpdated;

	protected List<ManagAttrModifier> modifiers = new();
	/// <summary>
	/// 优先级
	/// </summary>
	public int Priority { get; set; } = 0;
	public bool Used { get; set; } = true;

	/// <summary>
	/// 自身属性库的引用
	/// </summary>
	public ManagAttrCon container { get; set; }
	/// <summary>
	/// 自身全局属性库的引用
	/// </summary>
	public GloManagAttrCon glo_container { get; set; }
	/// <summary>
	/// 修改值，会触发改变值事件
	/// </summary>
	/// <param name="val"></param>
	/// <param name="valType"></param>
	public abstract void Set(object val, AttrDataType valType = AttrDataType.Value);
	/// <summary>
	/// 设置值，但不触发改变值事件
	/// </summary>
	/// <param name="val"></param>
	/// <param name="valType"></param>
	public abstract void SetKeyValue(object val, AttrDataType valType = AttrDataType.Value);
	public abstract void Add(object val, AttrDataType valType = AttrDataType.Value);
	protected abstract T Get(AttrDataType valType = AttrDataType.Value);
	protected abstract T GetRaw(AttrDataType valType = AttrDataType.Value);
	/// <summary>
	/// 属性id
	/// </summary>
	public int Id { get; init; } = 0;

	public int GetId()
	{
		return Id;
	}

	public R GetAttr<R>()
	{
		return (R)(object)this;
	}

	public virtual void Update(ulong tick)
	{
		RemoveExpiredModifiers(tick);
	}

	public void AddModifier(ManagAttrModifier mod)
	{
		modifiers.Add(mod);
		//TODO: Event?
		OnModifierAdded(mod);
	}

	public void RemoveModifier(ManagAttrModifier mod)
	{
		modifiers.Remove(mod);
		//TODO: event?
		OnModifierRemoved(mod);
	}

	protected virtual void OnModifierAdded(ManagAttrModifier mod)
	{

	}

	protected virtual void OnModifierRemoved(ManagAttrModifier mod)
	{

	}

	/// <summary>
	/// 移除所有已过期的修饰符
	/// </summary>
	/// <param name="tick"></param>
	protected void RemoveExpiredModifiers(ulong tick)
	{
		var toRemove = new List<ManagAttrModifier>();
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

	public virtual object GetObj(AttrDataType valType = AttrDataType.Value)
	{
		return Get(valType);
	}

	public virtual R Get<R>(AttrDataType valType = AttrDataType.Value)
	{
		return (R)(object)Get(valType);
	}

	public virtual R GetRaw<R>(AttrDataType valType = AttrDataType.Value)
	{
		return (R)(object)GetRaw(valType);
	}

	public virtual void SetFloat(float val, AttrDataType valType = AttrDataType.Value)
	{
		SetFloat(val, valType);
	}

	public virtual float GetFloat(AttrDataType valType = AttrDataType.Value)
	{
		return GetFloat(valType);
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
