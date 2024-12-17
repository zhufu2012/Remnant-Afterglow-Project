
using Godot.Community.ManagedAttributes;

namespace Remnant_Afterglow
{
    public partial class MoneyBase
    {

        /// <summary>
        /// 返回货币资源
        /// </summary>
        /// <returns></returns>
        public FloatManagedAttribute GetAttribute()
        {
            FloatManagedAttribute attribute = new FloatManagedAttribute(MoneyId, NowValue, Min, Max, Regen);
            return attribute;
        }




    }
}
