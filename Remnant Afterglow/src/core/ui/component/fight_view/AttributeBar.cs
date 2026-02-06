using Godot;
using ManagedAttributes;
namespace Remnant_Afterglow
{
	/// <summary>
	/// 属性条 结构值-护盾值
	/// </summary>
	public partial class AttributeBar : TextureProgressBar
	{
		/// <summary>
		/// 结构值属性
		/// </summary>
		AttrData _hp_attr;

		/// <summary>
		/// 护盾值属性
		/// </summary>
		AttrData _shield_attr;

		/// <summary>
		/// 护盾属性条
		/// </summary>
		[Export] TextureProgressBar shield_bar;

		public void InitData(AttrData hp, AttrData shield)
		{
			_hp_attr = hp;
			_shield_attr = shield;
			_hp_attr.AttributeUpdated += Hp_AttributeUpdated;
			_shield_attr.AttributeUpdated += Shield_AttributeUpdated;
			UpdateHpValue();
			UpdateShieldValue();
		}

		private void Hp_AttributeUpdated(IAttrData attribute)
		{
			UpdateHpValue();
		}
		private void Shield_AttributeUpdated(IAttrData attribute)
		{
			UpdateShieldValue();
		}

		/// <summary>
		/// 更新进度条的值,并设置是否显示
		/// </summary>
		private void UpdateHpValue()
		{
			float rawValue = _hp_attr.GetFloat(AttrDataType.Value);
			float rawMax = _hp_attr.GetFloat(AttrDataType.Max);
			Value = (rawMax > 0) ? (rawValue / rawMax) * MaxValue : 0;
		}

		/// <summary>
		/// 更新进度条的值,并设置是否显示
		/// </summary>
		private void UpdateShieldValue()
		{
			float rawValue = _shield_attr.GetFloat(AttrDataType.Value);
			float rawMax = _shield_attr.GetFloat(AttrDataType.Max);
			shield_bar.Value = (rawMax > 0) ? (rawValue / rawMax) * MaxValue : 0;
			Visible = rawMax > rawValue;
		}
	}
}
