using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 实体管理器，用于管理地图上的实体（建筑、炮塔等）
    /// </summary>
    public class EntityManager
    {
        private Dictionary<int, Sprite2D> showDict;
        private Dictionary<int, Vector2I> indexPosDict;
        /// <summary>
        /// 序号
        /// </summary>
        private int currentIndex;
        public EntityManager()
        {
            showDict = new Dictionary<int, Sprite2D>();
            indexPosDict = new Dictionary<int, Vector2I>();
            currentIndex = 0;
        }

        /// <summary>
        /// 添加实体到地图
        /// </summary>
        /// <param name="parent">父节点</param>
        /// <param name="buildData">实体数据</param>
        /// <param name="offsetPos">偏移位置</param>
        /// <param name="mapPos">地图位置</param>
        /// <returns>添加的精灵</returns>
        public Sprite2D AddEntity(Node parent, BuildData buildData, Vector2 offsetPos, Vector2I mapPos)
        {
            Sprite2D spShow = new Sprite2D();

            // 渲染实体主体
            EntityRenderer.RenderEntity(spShow, buildData, offsetPos);

            // 如果是炮塔且有武器，则渲染武器
            if (buildData.Type == 1 && buildData.WeaponList.Count > 0)
            {
                EntityRenderer.RenderWeapons(spShow, buildData.WeaponList);
            }

            parent.AddChild(spShow);
            showDict[currentIndex] = spShow;
            indexPosDict[currentIndex] = mapPos;
            currentIndex++;

            return spShow;
        }

        /// <summary>
        /// 移除实体
        /// </summary>
        /// <param name="index">实体索引</param>
        public void RemoveEntity(int index)
        {
            if (showDict.ContainsKey(index))
            {
                showDict[index].QueueFree();
                showDict.Remove(index);
                indexPosDict.Remove(index);
            }
        }

        /// <summary>
        /// 获取实体位置
        /// </summary>
        public Vector2I GetEntityPosition(int index)
        {
            return indexPosDict.ContainsKey(index) ? indexPosDict[index] : new Vector2I(-1, -1);
        }

        /// <summary>
        /// 查找指定位置的实体索引
        /// </summary>
        public int FindEntityIndex(Vector2I position)
        {
            foreach (var kvp in indexPosDict)
            {
                if (kvp.Value == position)
                {
                    return kvp.Key;
                }
            }
            return -1;
        }
    }
}