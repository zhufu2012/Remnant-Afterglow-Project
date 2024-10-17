using GameLog;
using Godot.Community.ManagedAttributes;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 AttributeData 用于 实体属性表,可在这里拓展，拓展前记得在工具的config表中增加需要拓展的类名称
    /// </summary>
    public partial class AttributeData
    {
        public FloatManagedAttribute attribute;
        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>
        public void InitData()
        {
            attribute = new FloatManagedAttribute(AttributeId, StartValue, Min, Max, Regen);
          
        }

        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>
        public void InitData2()
        {

        }

    }
}