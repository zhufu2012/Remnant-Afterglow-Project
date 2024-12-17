using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 BigMapMaterial 用于 大地图节点,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BigMapMaterial
    {
        /// <summary>
        /// 地图节点 进入事件列表
        ///
        /// </summary>
        public List<BigMapEvent> EnterEventList = new List<BigMapEvent>();
        /// <summary>
        /// 创建配置时，初始化数据-构造函数中运行
        /// </summary>
        public void InitData()
        {
            EnterEventList = new List<BigMapEvent>();
            for (int i = 0; i < NodeEnterEventList.Count; i++)
            {
                EnterEventList.Add(new BigMapEvent(NodeEnterEventList[i]));
            }
        }

        /// <summary>
        /// 创建缓存时，初始化数据-构造函数后运行
        /// </summary>        
        public void InitData2()
        {
        }

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
