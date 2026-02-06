using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;

namespace Remnant_Afterglow
{
    //是否可拓展，在这里添加
    public class ClassMap
    {
        /// <summary>
        /// 所有可拓展基类
        /// </summary>
        public static Dictionary<string, Type> BaseClass = new Dictionary<string, Type>();
        /// <summary>
        /// 所有基的子类
        /// </summary>
        public static Dictionary<Type, List<Type>> SubClass = new Dictionary<Type, List<Type>>();

        static ClassMap()
        {
            //这里需要对BaseClass添加数据
            AddBaseClass("UnitBase", typeof(UnitBase));


            foreach (KeyValuePair<string, Type> kvp in BaseClass)
            {
                Dictionary<string, Type> temp_dict = getclass(kvp.Key, kvp.Value);
                SubClass[kvp.Value] = temp_dict.Values.ToList();
            }
        }

        //添加可拓展基类
        public static void AddBaseClass(string base_name, Type type)
        {
            BaseClass[base_name] = type;
        }


        //返回所有可拓展基类
        public static Dictionary<string, Type> GetBaseClass()
        {
            return BaseClass;
        }

        //返回所有可拓展基类的子类
        public static Dictionary<Type, List<Type>> GetSubClass()
        {
            return SubClass;
        }


        //返回所有基类和子类，主要用于多态
        public static Dictionary<string, Type> GetAllClass()
        {
            Dictionary<string, Type> allClasses = new Dictionary<string, Type>(BaseClass);

            foreach (var kvp in SubClass)
            {
                foreach (var subType in kvp.Value)
                {
                    string subTypeName = subType.Name;
                    string discriminatorValue = kvp.Key.Name + "." + subTypeName;
                    allClasses[discriminatorValue] = subType;
                }
            }
            return allClasses;
        }

        //根据鉴别器名称和类型 通过反射机制获取所有该基类及继承基类的子类
        public static Dictionary<string, Type> getclass(string PropertyName, Type type)
        {
            Assembly assembly = Assembly.GetExecutingAssembly(); // 获取当前程序集的 Assembly 对象
            var derivedTypes = assembly.GetTypes().Where(t => t.IsSubclassOf(type));
            Dictionary<string, Type> temp_dict = new Dictionary<string, Type>();
            foreach (var types in derivedTypes)
            {
                string typeName = types.Name; // 获取派生类的名称
                string discriminatorValue = PropertyName + "_" + typeName; // 类别鉴别器值
                temp_dict[discriminatorValue] = types;
            }
            return temp_dict;
        }
    }

}