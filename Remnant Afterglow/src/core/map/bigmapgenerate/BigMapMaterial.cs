using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class BigMapMaterial
    {
        #region 参数及初始化
        /// <summary>
        /// 地图节点id
        /// </summary>
        public int NodeId { get; set; }
        /// <summary>
        /// 地图节点类型
        ///暂不使用
        /// </summary>
        public int NodeType { get; set; }
        /// <summary>
        /// 节点所用图集id
        ///地块表的cfg_MapImageSet_地图图像集id
        /// </summary>
        public int ImageSetId { get; set; }
        /// <summary>
        /// 所在图集序号
        /// </summary>
        public int ImageSetIndex { get; set; }
        /// <summary>
        /// 是否可选中
        /// </summary>
        public bool IsSelect { get; set; }
        /// <summary>
        /// 是否可点击
        /// </summary>
        public bool IsClick { get; set; }
        /// <summary>
        /// 地图节点 点击事件列表
        ///
        /// </summary>
        public List<int> NodeClickEventList { get; set; }
        /// <summary>
        /// 地图节点 进入事件列表
        ///
        /// </summary>
        public List<BigMapEvent> NodeEnterEventList { get; set; }

        public BigMapMaterial(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapCell, id);
            NodeId = (int)dict["NodeId"];
            NodeType = (int)dict["NodeType"];
            ImageSetId = (int)dict["ImageSetId"];
            ImageSetIndex = (int)dict["ImageSetIndex"];
            IsSelect = (bool)dict["IsSelect"];
            IsClick = (bool)dict["IsClick"];
            NodeClickEventList = (List<int>)dict["NodeClickEventList"];
            List<int> list = (List<int>)dict["NodeEnterEventList"];
            NodeEnterEventList = new List<BigMapEvent>();
            for (int i = 0; i < list.Count; i++)
            {
                NodeEnterEventList.Add(new BigMapEvent(list[i]));
            }
        }
        #endregion

        /// <summary>
        /// 根据坐标数据，直接获取对应的节点
        /// </summary>
        /// <param name="pos"></param>
        /// <returns></returns>
        public Hex GetHex(Vector3I pos)
        {
            return new Hex(pos, NodeId, ImageSetId, ImageSetIndex);
        }

        public Hex GetHex()
        {
            return new Hex(NodeId, ImageSetId, ImageSetIndex);
        }

        public Hex GetHex(int q, int r, int s)
        {
            return new Hex(q, r, s, NodeId, ImageSetId, ImageSetIndex);
        }

        public Hex GetHex(int x, int y)
        {
            return new Hex(OffsetToCube(x, y), NodeId, ImageSetId, ImageSetIndex);
        }

        public static Vector3I OffsetToCube(int X, int Y)
        {
            int r = Y - (X + (X & 1)) / 2;
            int s = -X - r;
            return new Vector3I(X, r, s);
        }


    }
}
