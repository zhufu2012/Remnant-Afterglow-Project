using Godot;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    public partial class FunctionTemplate
    {
        public static List<FunctionTemplate> GetAllFunctionTemplate()
        {
            Dictionary<string, Dictionary<string, object>> all_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_FunctionTemplate);
            List<FunctionTemplate> list = new List<FunctionTemplate>();
            foreach (var Val in all_dict)
            {
                list.Add(new FunctionTemplate((string)Val.Value["TemplateId"]));
            }
            return list;
        }
    }
}


