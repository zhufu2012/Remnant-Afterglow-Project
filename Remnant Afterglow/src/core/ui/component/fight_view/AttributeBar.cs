using GameLog;
using Godot;
using Godot.Community.ManagedAttributes;
namespace Remnant_Afterglow
{
	/// <summary>
	/// 属性条
	/// </summary>
	public partial class AttributeBar : TextureProgressBar
	{
		/// <summary>
		/// 属性id,默认使用 结构值
		/// </summary>
		public int AttributeId = 1;
		public string ArrtibuteName = "1";
		/// <summary>
		/// 属性
		/// </summary>
		FloatManagedAttribute _attribute;

		public void InitData(int AttributeId, FloatManagedAttribute attribute)
		{
			this.AttributeId = AttributeId;
			ArrtibuteName = AttributeId.ToString();
			this._attribute = attribute;
			_attribute.AttributeUpdated += Attribute_AttributeUpdated;
			UpdateValue();
			
		}

		private void Attribute_AttributeUpdated(IManagedAttribute attribute)
		{
			UpdateValue();
		}

		/// <summary>
		/// 更新进度条的值
		/// </summary>
		private void UpdateValue()
		{
			float rawValue = _attribute.GetRaw<float>(AttributeValueType.Value);
			float rawMax = _attribute.GetRaw<float>(AttributeValueType.Max);
			Value = (rawMax > 0) ? (rawValue / rawMax) * MaxValue : 0;
		}
    }
}
