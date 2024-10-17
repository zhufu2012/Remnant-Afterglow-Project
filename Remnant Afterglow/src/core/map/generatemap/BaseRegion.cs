using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class BaseRegion
    {
        /// <summary>
        /// 唯一房间id，类型 IdConstant.ID_REGION_TYPE
        /// </summary>
        public string data_id;

        /// <summary>
        /// 相连的区域
        /// </summary>
        public List<string> connectedRooms = new List<string>();
        /// <summary>
        /// 是否连接主房间
        /// </summary>
        public bool isAccessibleFromMainRoom = false;
        /// <summary>
        /// 是否是主房间
        /// </summary>
        public bool isMainRoom = false;

        /// <summary>
        /// 标记相对于主房间的连接性
        /// </summary>
        public void MarkAccessibleFromMainRoom(List<BaseRegion> AllRoomList)
        {
            if (!isAccessibleFromMainRoom)
            {
                isAccessibleFromMainRoom = true;
                foreach (string id in connectedRooms)
                {
                    BaseRegion connectedRoom = AllRoomList.Find(c => c.data_id == id);
                    connectedRoom.MarkAccessibleFromMainRoom(AllRoomList);
                }
            }
        }
        /// <summary>
        /// 连接房间
        /// </summary>
        /// <param name="roomB"></param>
        public void ConnectRooms(BaseRegion roomB, List<BaseRegion> AllRoomList)
        {
            //传递连接标记
            if (isAccessibleFromMainRoom)
            {
                roomB.MarkAccessibleFromMainRoom(AllRoomList);
            }
            else if (roomB.isAccessibleFromMainRoom)
            {
                MarkAccessibleFromMainRoom(AllRoomList);
            }
            //传递连接行为
            connectedRooms.Add(roomB.data_id);
            roomB.connectedRooms.Add(data_id);
        }

        /// <summary>
        /// 是否连接另一个房间
        /// </summary>
        /// <param name="room"></param>
        /// <returns></returns>
        public bool IsConnected(BaseRegion room)
        {
            if (connectedRooms.Contains(room.data_id))
                return true;
            else
                return false;
        }
    }
}
