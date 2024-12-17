using System.Linq;                      // 导入Linq命名空间，用于集合查询
using System.Collections.Generic;       // 导入集合框架命名空间
using Newtonsoft.Json;                  // 导入JSON.NET命名空间，用于序列化和反序列化
using Godot.Community.ControlBinding.Collections; // 导入Godot社区Control Binding集合命名空间
using Godot.Community.ControlBinding;   // 导入Godot社区Control Binding命名空间
using Godot.Community.ControlBinding.EventArgs;
using GameLog;

namespace Godot.Community.ManagedAttributes
{ // 定义命名空间

    // ManagedAttributeContainer类，实现IObservableList接口，用于管理一组ManagedAttribute实例
    //一个实体拥有一个这样的属性组
    public class ManagedAttributeContainer : IObservableList
    {

        /// <summary>
        /// 定义委托，用于处理属性更新事件
        /// </summary>
        /// <param name="attribute"></param>
        public delegate void AttributeUpdatedHandler(IManagedAttribute attribute);

        /// <summary>
        /// 定义事件，当属性更新时触发
        /// </summary>
        public event AttributeUpdatedHandler AttributeUpdated;

        /// <summary>
        /// 定义事件，当列表发生变化时触发
        /// </summary>
        public event ObservableListChangedEventHandler ObservableListChanged;

        /// <summary>
        /// 用于存储属性实例的字典<属性id,属性>
        /// </summary>
        public Dictionary<string, IManagedAttribute> Attributes { get; set; } = new Dictionary<string, IManagedAttribute>();

        /// <summary>
        /// 索引器，根据名称查找并返回属性实例
        /// </summary>
        /// <param name="name">属性名称</param>
        /// <returns></returns>
        public IManagedAttribute this[string name]
        {
            get
            {
                if (Attributes.TryGetValue(name, out var attribute))
                {
                    return attribute;
                }
                return null;
            }
        }


        /// <summary>
        /// 添加方法，用于向容器中添加一个属性实例
        /// </summary>
        /// <param name="attr"></param>
        /// <returns></returns>
        public bool Add(IManagedAttribute attr)
        {
            if (Attributes.ContainsKey(attr.GetName()))
            {
                return false; // 如果存在，则不允许添加
            }
            Attributes[attr.GetName()] = attr;
            OnObservableListChanged(new ObservableListChangedEventArgs()
            {
                ChangedEntries = new List<object> { attr }, // 收集变更条目
                ChangeType = ObservableListChangeType.Add, // 变更类型为添加
                Index = int.Parse(attr.GetName()) // 字典没有索引概念，这里设置为属性id
            });
            return true; // 返回成功添加的信号
        }

        /// <summary>
        ///  移除方法，根据属性实例移除元素
        /// </summary>
        /// <param name="attr"></param>
        /// <returns></returns>
        public bool Remove(IManagedAttribute attr)
        {
            string key = attr.GetName();
            if (Attributes.Remove(key))
            {
                OnObservableListChanged(new ObservableListChangedEventArgs()
                {
                    ChangedEntries = new List<object> { attr }, // 收集变更条目
                    ChangeType = ObservableListChangeType.Remove, // 变更类型为移除
                    Index = int.Parse(attr.GetName()) // 字典没有索引概念，这里设置为属性id
                });
                return true;
            }
            return false;
        }


        /// <summary>
        /// 移除方法，根据属性名称移除元素
        /// </summary>
        /// <param name="attrName"></param>
        /// <returns></returns>
        public bool Remove(string attrName)
        {
            if (Attributes.Remove(attrName))
            {
                OnObservableListChanged(new ObservableListChangedEventArgs()
                {
                    ChangedEntries = new List<object> { attrName }, // 收集变更条目
                    ChangeType = ObservableListChangeType.Remove, // 变更类型为移除
                    Index = int.Parse(attrName) // 字典没有索引概念，这里设置为属性id
                });
                return true;
            }
            return false;
        }



        /// <summary>
        /// 移除指定属性id的方法
        /// </summary>
        /// <param name="index"></param>
        public void RemoveAt(int index)
        {
            string attrName = "" + index;
            if (Attributes.Remove(attrName))
            {
                OnObservableListChanged(new ObservableListChangedEventArgs()
                {
                    ChangedEntries = new List<object> { attrName }, // 收集变更条目
                    ChangeType = ObservableListChangeType.Remove, // 变更类型为移除
                    Index = int.Parse(attrName) //字典没有索引概念，这里设置为属性id
                });
            }
        }


        /// <summary>
        /// 合并另一个ManagedAttributeContainer的内容到当前容器
        /// 拥有合并属性模板
        /// </summary>
        /// <param name="other">要合并的ManagedAttributeContainer实例</param>
        /// <param name="overwriteExisting">是否覆盖已存在的同名属性，默认为false</param>
        public void Merge(ManagedAttributeContainer other, bool overwriteExisting = false)
        {
            if (other == null)
            {
                Log.Error("错误！存在空的属性模板不能为空!");
            }
            else
            {
                foreach (var kvp in other.Attributes)
                {
                    string key = kvp.Key;
                    IManagedAttribute attr = kvp.Value;

                    if (Attributes.ContainsKey(key))
                    {
                        if (overwriteExisting)
                        {
                            // 如果允许覆盖，则移除现有属性
                            Attributes.Remove(key);
                            // 添加新属性
                            Attributes[key] = attr;
                            OnObservableListChanged(new ObservableListChangedEventArgs()
                            {
                                ChangedEntries = new List<object> { attr },
                                ChangeType = ObservableListChangeType.Replace,//替换
                                Index = int.Parse(key) //字典没有索引概念，这里设置为属性id
                            });
                        }
                        else
                        {
                            Log.Error("错误！该标签不允许属性覆盖");
                        }
                    }
                    else
                    {
                        // 如果不存在同名属性，则直接添加
                        Attributes[key] = attr;
                        OnObservableListChanged(new ObservableListChangedEventArgs()
                        {
                            ChangedEntries = new List<object> { attr },
                            ChangeType = ObservableListChangeType.Add,
                            Index = int.Parse(key) // 字典没有索引概念，这里设置为属性id
                        });
                    }
                }
            }
        }

        /// <summary>
        /// 内部事件处理器，当属性更新时调用
        /// </summary>
        /// <param name="attribute"></param>
        private void OnAttributeUpdated(IManagedAttribute attribute)
        {

            AttributeUpdated?.Invoke(attribute); // 调用AttributeUpdated事件，传入更新的属性实例
        }

        /// <summary>
        /// 更新方法，遍历所有属性并更新
        /// </summary>
        /// <param name="tick"></param>

        public void Update(ulong tick)
        {
            foreach (var attr in Attributes.Values)
            {
                attr.Update(tick); // 更新每个属性的内部状态
            }
        }

        /// <summary>
        /// 序列化方法，将属性列表转换为JSON字符串
        /// </summary>
        /// <returns></returns>
        public string Serialize()
        {


            return JsonConvert.SerializeObject(Attributes, Formatting.Indented, new JsonSerializerSettings()
            {
                TypeNameHandling = TypeNameHandling.Objects // 设置序列化选项，保留类型信息
            });
        }

        /// <summary>
        /// 反序列化方法，将JSON字符串转换回属性列表
        /// </summary>
        /// <param name="jsonString"></param>
        public void Deserialize(string jsonString)
        {
            Attributes = JsonConvert.DeserializeObject<Dictionary<string, IManagedAttribute>>(jsonString, new JsonSerializerSettings()
            {
                TypeNameHandling = TypeNameHandling.Objects // 设置反序列化选项，恢复类型信息
            });
        }

        /// <summary>
        /// 转换方法，返回属性实例的列表视图
        /// </summary>
        /// <returns></returns>
        public List<IManagedAttribute> ToList()
        {
            return Attributes.Values.ToList(); // 使用Values获取IManagedAttribute列表
        }

        /// <summary>
        /// 获取方法，返回列表的底层对象视图
        /// </summary>
        /// <returns></returns>
        public IList<object> GetBackingList()
        {
            return Attributes.Values.Cast<object>().ToList(); // 使用Cast转换为object列表
        }

        /// <summary>
        /// 内部事件处理器，当列表发生变化时调用
        /// </summary>
        /// <param name="eventArgs"></param>
        public void OnObservableListChanged(ObservableListChangedEventArgs eventArgs)
        {
            ObservableListChanged?.Invoke(eventArgs); // 调用ObservableListChanged事件，传入变更事件参数
        }


        public override string ToString()
        {
            string str = "";
            foreach (var attr in Attributes.Values)
            {
                str += "<<Value:" + attr.GetRaw<float>(AttributeValueType.Value) + "\n" +
                "Min:" + attr.GetRaw<float>(AttributeValueType.Min) + "\n" +
                "Max:" + attr.GetRaw<float>(AttributeValueType.Max) + "\n" +
                "Regen:" + attr.GetRaw<float>(AttributeValueType.Regen) + ">>\n";

            }
            return str;
        }
    }
}