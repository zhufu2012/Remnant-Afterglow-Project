using ManagedAttributes;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
	/// <summary>
	/// 自动生成的配置类2 AttrModifier 用于 属性修饰器,拓展请在expand_class文件下使用partial拓展
	/// </summary>
	public partial class AttrModifier
	{

		/// <summary>
		/// 创建配置时，初始化数据-构造函数中运行
		/// </summary>
		public void InitData()
		{
		}

		/// <summary>
		/// 创建缓存时，初始化数据-构造函数后运行
		/// </summary>        
		public void InitData2()
		{
		}

		public Dictionary<AttrDataType, ManagedAttributeModifierValue> GetAttrModifierValueDict()
		{
			Dictionary<AttrDataType, ManagedAttributeModifierValue> ModifierValueList = new Dictionary<AttrDataType, ManagedAttributeModifierValue>();
			foreach (List<float> Param in ParamList)
			{
				ModifierValueList[(AttrDataType)((int)Param[0])] = new ManagedAttributeModifierValue { Add = Param[1], Multiplier = Param[2] };
			}
			return ModifierValueList;
		}


		/// <summary>
		/// 根据修饰器配置获取修饰器
		/// </summary>
		public ManagAttrModifier GetModifier(ulong ApplyTick)
		{
			if(ExpiryTick!=0)
			{
				ManagAttrModifier modifier =
					new ManagAttrModifier
					{
						ApplyTick = ApplyTick, // 假设当前帧
						ExpiryTick = ApplyTick + ExpiryTick, // 修饰器将在ExpiryTick帧后过期
						ModifierValues = GetAttrModifierValueDict()
					};
				return modifier;
			}
			else
			{
				ManagAttrModifier modifier =
					new ManagAttrModifier
					{
						ApplyTick = ApplyTick, // 假设当前帧
						ExpiryTick = ulong.MaxValue, // 默认无过期时间
						ModifierValues = GetAttrModifierValueDict()
					};
				return modifier;
			}
		}
	}
}
