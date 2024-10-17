
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 对象池，用于获取和回收常用对象，避免每次都创建一个新的
    /// 管理的对象，必须实现 IPoolItem，并且要求存在有唯一标识，唯一标识可以使用id生成器的id
    /// 也可以用资源路径来，或者某种方式
    /// </summary>
    public static class ObjectPool
    {
        ///对象池,键是 对象类型+_+cfg_id
        private static Dictionary<string, Stack<IPoolItem>> _pool = new Dictionary<string, Stack<IPoolItem>>();
        //当前在使用的对象，<唯一id,对象>  通过唯一id,可以知道玩家是什么类型的对象
        private static Dictionary<string, Object> IdPool = new Dictionary<string, Object>();
        /// <summary>
        /// 回收一个对象
        /// </summary>
        public static void Reclaim(IPoolItem poolItem)
        {
            if (poolItem.IsRecycled)
            {
                return;
            }
            var logotype = poolItem.Logotype;
            if (!_pool.TryGetValue(logotype, out var poolItems))
            {
                poolItems = new Stack<IPoolItem>();
                _pool.Add(logotype, poolItems);
            }

            poolItems.Push(poolItem);
            poolItem.IsRecycled = true;
            poolItem.OnReclaim();
        }

        /// <summary>
        /// 根据标识从池中取出一个实例，如果没有该标识类型的实例，则返回null
        /// </summary>
        public static IPoolItem GetItem(string logotype)
        {
            if (_pool.TryGetValue(logotype, out var poolItems))
            {
                if (poolItems.Count > 0)
                {
                    var poolItem = poolItems.Pop();
                    poolItem.IsRecycled = false;
                    poolItem.OnLeavePool();
                    return poolItem;
                }
            }

            return null;
        }

        /// <summary>
        /// 根据标识从池中取出一个实例，如果没有该标识类型的实例，则返回null
        /// </summary>
        public static T GetItem<T>(string logotype) where T : IPoolItem
        {
            return (T)GetItem(logotype);
        }

        /// <summary>
        /// 销毁所有池中的物体
        /// </summary>
        public static void DisposeAllItem()
        {
            foreach (var keyValuePair in _pool)
            {
                var poolItems = keyValuePair.Value;
                while (poolItems.Count > 0)
                {
                    var item = poolItems.Pop();
                    item.Destroy();
                }
            }
            _pool.Clear();
        }
    }
}