using Godot.Community.ManagedAttributes;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class AttributeData
    {
        public FloatManagedAttribute GetAttr()
        {
            return new FloatManagedAttribute(AttributeId, StartValue, Min, Max, Regen);
        }

        public override string ToString()
        {
            return $"AttributeData [ObjectId={ObjectId}, AttributeId={AttributeId}, StartValue={StartValue}, Max={Max}, Min={Min}, Regen={Regen}, RegenFps={RegenFps}, AttrEventIdList={AttrEventIdList.Count} entries]";
        }
    }
}

