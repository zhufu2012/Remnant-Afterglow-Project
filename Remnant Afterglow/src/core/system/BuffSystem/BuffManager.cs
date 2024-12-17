
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// Buff管理器
    /// </summary>
    public class BuffManager
    {
        /// <summary>
        /// 实体管理器单例
        /// </summary>
        public static BuffManager Instance { get; set; }

        public Dictionary<int, BuffBase> buffDict = new Dictionary<int, BuffBase>();
        public BuffManager()
        {
            Instance = this;
        }

        public IBuff GetBuff(int buffId)
        {
            if (buffDict.ContainsKey(buffId))
            {
                return (IBuff)buffDict[buffId].Clone();
            }
            throw new System.Exception("使用非法的Buff id：" + buffId + "");
        }
    }
}
