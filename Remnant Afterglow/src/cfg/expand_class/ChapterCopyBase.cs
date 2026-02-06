using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 关卡数据
    /// </summary>
    public partial class ChapterCopyBase
    {
        public ChapterCopyBase(int ChapterId, int CopyId)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ChapterCopyBase, ChapterId, CopyId);
            this.ChapterId = (int)dict["ChapterId"];
            this.CopyId = (int)dict["CopyId"];
            CopyUiId = (int)dict["CopyUiId"];
            CameraId = (int)dict["CameraId"];
            MapName = (string)dict["MapName"];
            Pos = (Vector2I)dict["Pos"];
            NodeId = (int)dict["NodeId"];
            CopyIdList = (List<int>)dict["CopyIdList"];
        }
    }
}
