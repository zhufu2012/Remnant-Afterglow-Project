// GloAttrDataManager.cs - 全局属性管理器
using System.Collections.Generic;
using ManagedAttributes;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 全局属性管理器
    /// 管理独立于实体的全局属性，如关卡特殊效果、突袭敌人生成等
    /// </summary>
    public class GloAttrDataManager
    {
        /// <summary>
        /// 单例实例
        /// </summary>
        public static GloAttrDataManager Instance { get; private set; } = new GloAttrDataManager();

        /// <summary>
        /// 全局属性容器
        /// </summary>
        private ManagAttrCon gloAttrCon = new ManagAttrCon();

        /// <summary>
        /// 需要更新的全局属性列表
        /// </summary>
        private HashSet<IAttrData> actGloAttrSet = new HashSet<IAttrData>();

        public GloAttrDataManager()
        {
            Instance = this;
        }

        /// <summary>
        /// 添加全局属性
        /// </summary>
        /// <param name="attribute">全局属性</param>
        /// <param name="isActive">是否激活（需要每帧更新）</param>
        public void AddGlobalAttribute(IAttrData attribute, bool isActive = true)
        {
            gloAttrCon.Add(attribute);
            if (isActive)
            {
                actGloAttrSet.Add(attribute);
            }
        }

        /// <summary>
        /// 移除全局属性
        /// </summary>
        /// <param name="attributeId">全局属性ID</param>
        public void RemoveGlobalAttribute(int attributeId)
        {
            var attribute = gloAttrCon[attributeId];
            if (attribute != null)
            {
                actGloAttrSet.Remove(attribute);
                gloAttrCon.Remove(attributeId);
            }
        }

        /// <summary>
        /// 设置全局属性激活状态
        /// </summary>
        /// <param name="attributeId">属性ID</param>
        /// <param name="active">是否激活</param>
        public void SetGlobalAttributeActive(int attributeId, bool active)
        {
            var attribute = gloAttrCon[attributeId];
            if (attribute != null)
            {
                if (active)
                {
                    actGloAttrSet.Add(attribute);
                }
                else
                {
                    actGloAttrSet.Remove(attribute);
                }
            }
        }

        /// <summary>
        /// 获取全局属性
        /// </summary>
        /// <param name="attributeId">属性ID</param>
        /// <returns>全局属性</returns>
        public IAttrData GetGlobalAttribute(int attributeId)
        {
            return gloAttrCon[attributeId];
        }

        /// <summary>
        /// 每帧更新激活的全局属性
        /// </summary>
        /// <param name="tick">游戏刻度</param>
        public void Update(ulong tick)
        {
            foreach (var attribute in actGloAttrSet)
            {
                if (attribute.Used)
                {
                    attribute.Update(tick);
                }
            }
        }

        /// <summary>
        /// 清理所有全局属性
        /// </summary>
        public void Clear()
        {
            actGloAttrSet.Clear();
            gloAttrCon.Attributes.Clear();
        }
    }
}
