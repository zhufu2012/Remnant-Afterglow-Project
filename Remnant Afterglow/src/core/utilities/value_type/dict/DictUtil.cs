using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class DictUtil
    {

        /// <summary>
        /// Dictionary<int, int>两字典相加
        /// </summary>
        /// <param name="dict1">字典1</param>
        /// <param name="dict2">字典2</param>
        /// <returns></returns>
        public static Dictionary<int, int> AddDictionaries(Dictionary<int, int> dict1, Dictionary<int, int> dict2)
        {
            Dictionary<int, int> result = new Dictionary<int, int>();
            foreach (var kvp in dict1)
            {
                int key = kvp.Key;
                int value1 = kvp.Value;
                int value2 = dict2.ContainsKey(key) ? dict2[key] : 0;
                int sum = value1 + value2;
                result[key] = sum;
            }
            foreach (var kvp in dict2)
            {
                if (!result.ContainsKey(kvp.Key))
                {
                    result[kvp.Key] = kvp.Value;
                }
            }
            return result;
        }

        /// <summary>
        /// Dictionary<int, int> 两字典相减，小于等于 0 的数据保存
        /// </summary>
        public static Dictionary<int, int> SubDictionariesSave(Dictionary<int, int> dict1, Dictionary<int, int> dict2)
        {
            Dictionary<int, int> result = new Dictionary<int, int>();
            foreach (var kvp in dict1)
            {
                int key = kvp.Key;
                int value1 = kvp.Value;
                int value2 = dict2.ContainsKey(key) ? dict2[key] : 0;
                int diff = value1 - value2;
                if (diff <= 0)
                {
                    result[key] = diff;
                }
            }
            return result;
        }

        /// <summary>
        /// Dictionary<int, int> 两字典相减，小于等于 0 的数据不保存
        /// </summary>
        public static Dictionary<int, int> SubDictionariesNotSave(Dictionary<int, int> dict1, Dictionary<int, int> dict2)
        {
            Dictionary<int, int> result = new Dictionary<int, int>();
            foreach (var kvp in dict1)
            {
                int key = kvp.Key;
                int value1 = kvp.Value;
                int value2 = dict2.ContainsKey(key) ? dict2[key] : 0;
                int diff = value1 - value2;
                if (diff > 0)
                {
                    result[key] = diff;
                }
            }
            return result;
        }

        /// <summary>
        /// 将两个 List<T> 数据相加，第一个 List 中的元素作为键
        /// </summary>
        public static Dictionary<T1, T2> AddLists<T1, T2>(List<T1> keys, List<T2> values1, List<T2> values2)
        {
            if (keys.Count != values1.Count || keys.Count != values2.Count)
            {
                return null;
            }
            Dictionary<T1, T2> result = new Dictionary<T1, T2>();
            for (int i = 0; i < keys.Count; i++)
            {
                T1 key = keys[i];
                T2 value1 = values1[i];
                T2 value2 = values2[i];
                // 在这里可以根据具体需求进行元素相加或其他操作
                // 这里只是简单赋值
                result[key] = value1;
            }

            return result;
        }
    }

}