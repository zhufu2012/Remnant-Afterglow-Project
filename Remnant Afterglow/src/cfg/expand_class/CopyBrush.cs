using System.Collections.Generic;
namespace Remnant_Afterglow
{
    public partial class CopyBrush
    {
        public CopyBrush(int ChapterId, int CopyId)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_CopyBrush, ChapterId, CopyId);//public const string Config_CopyBrush = "cfg_CopyBrush";
            ChapterId = (int)dict["ChapterId"];
            CopyId = (int)dict["CopyId"];
            CopyType = (int)dict["CopyType"];
            AllWave = (int)dict["AllWave"];
            BrushSpace = (int)dict["BrushSpace"];
            BrushSpaceList = (List<List<int>>)dict["BrushSpaceList"];
            BrushIdList = (List<int>)dict["BrushIdList"];
        }
    }
}
