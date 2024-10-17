using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text.Json;

namespace Remnant_Afterglow
{
    public class JsonModelConverter
    {
        //所有基类和子类,用于序列化和反序列化
        private static Dictionary<string, Type> _modelTypes = new Dictionary<string, Type>();
        private static JsonSerializerOptions _jsonSerializerOptions = new JsonSerializerOptions
        {
        };

        public JsonModelConverter()
        {
            _modelTypes = ClassMap.GetAllClass();
        }

        //增加特殊序列化类
        public static void Add(Type type)
        {
            _modelTypes[type.Name] = type;
        }


        //序列化对象  对象要求有空的构造函数
        public string Serialize(IJsonModelWrapper source, Type modelType)
        {
            _modelTypes[modelType.FullName] = modelType;
            source.ModelFullName = modelType.FullName;
            var json = JsonSerializer.Serialize(source, source.GetType());
            return json;
        }

        //反序列化对象 注意是需要通过_modelTypes来查询对应类型的
        public T Deserialize<T>(string json) where T : class, IJsonModelWrapper, new()
        {
            var result = JsonSerializer.Deserialize(json, typeof(T)) as T;
            var modelName = result.ModelFullName;
            var objectProperties = typeof(T).GetProperties(BindingFlags.Public |
            BindingFlags.Instance).Where(p => p.PropertyType == typeof(object));
            foreach (var property in objectProperties)
            {
                var model = property.GetValue(result);
                if (model is JsonElement)
                {
                    var modelJsonElement = (JsonElement)model;
                    var modelJson = modelJsonElement.GetRawText();
                    var restoredModel = JsonSerializer.Deserialize
                    (modelJson, _modelTypes[modelName]);
                    property.SetValue(result, restoredModel);
                }
            }
            return result as T;
        }

        //序列化对象列表
        public string SerializeList<T>(List<T> sourceList) where T : IJsonModelWrapper
        {
            var jsonList = new List<string>();
            foreach (var item in sourceList)
            {
                _modelTypes[item.GetType().FullName] = item.GetType();
                item.ModelFullName = item.GetType().FullName;
                var json = JsonSerializer.Serialize(item, item.GetType());
                jsonList.Add(json);
            }
            return JsonSerializer.Serialize(jsonList);
        }

        //反序列化对象列表
        public List<T> DeserializeList<T>(string json) where T : class, IJsonModelWrapper, new()
        {
            var jsonList = JsonSerializer.Deserialize<List<string>>(json);
            var resultList = new List<T>();
            foreach (var jsonItem in jsonList)
            {
                var item = JsonSerializer.Deserialize(jsonItem, typeof(T)) as T;
                var modelName = item.ModelFullName;
                var objectProperties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance).Where(p => p.PropertyType == typeof(object));
                foreach (var property in objectProperties)
                {
                    var model = property.GetValue(item);
                    if (model is JsonElement)
                    {
                        var modelJsonElement = (JsonElement)model;
                        var modelJson = modelJsonElement.GetRawText();
                        var restoredModel = JsonSerializer.Deserialize(modelJson, _modelTypes[modelName]);
                        property.SetValue(item, restoredModel);
                    }
                }
                resultList.Add(item);
            }
            return resultList;
        }
    }
}
