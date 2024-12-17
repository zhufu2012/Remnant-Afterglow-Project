using Newtonsoft.Json;
namespace Remnant_Afterglow;

/// <summary>
/// 存储系统的扩展方法。
/// <para>Uses the <remarks>Newtonsoft.Json</remarks> library and add function wrappers for serializing and deserializing Godot data types.</para>
/// </summary>
public static class SaveExtension
{
    public static readonly JsonSerializerSettings Settings = CreateSettings();

    internal static JsonSerializerSettings CreateSettings()
    {
        var settings = new JsonSerializerSettings
        {
            Formatting = Formatting.Indented,
            Culture = System.Globalization.CultureInfo.InvariantCulture,
        };

        settings.Converters.Add(new AttributeConverter());

        // Core converters
        settings.Converters.Add(new NodeSaveConverter());
        settings.Converters.Add(new TreeSaveConverter());

        // Godot converters
        settings.Converters.Add(new Vector2Converter());
        settings.Converters.Add(new Vector2IConverter());
        settings.Converters.Add(new Vector3Converter());
        settings.Converters.Add(new Vector3IConverter());
        settings.Converters.Add(new Vector4Converter());
        settings.Converters.Add(new Vector4IConverter());
        settings.Converters.Add(new QuaternionConverter());
        settings.Converters.Add(new Rect2Converter());
        settings.Converters.Add(new Rect2IConverter());
        settings.Converters.Add(new BasisConverter());
        settings.Converters.Add(new Transform2DConverter());
        settings.Converters.Add(new Transform3DConverter());
        settings.Converters.Add(new ProjectionConverter());
        settings.Converters.Add(new PlaneConverter());
        settings.Converters.Add(new AabbConverter());
        settings.Converters.Add(new RidConverter());
        settings.Converters.Add(new ColorConverter());
        settings.Converters.Add(new NodePathConverter());
        settings.Converters.Add(new StringNameConverter());
        settings.Converters.Add(new CallableConverter());
        settings.Converters.Add(new SignalConverter());
        settings.Converters.Add(new SceneTreeConverter());
        settings.Converters.Add(new GodotObjectConverter());

        return settings;
    }

    /// <summary>
    /// Serializes an object to a JSON string
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static string SerializeObject(object? value)
    {
        return JsonConvert.SerializeObject(value, Settings);
    }

    /// <summary>
    /// 将对象序列化为JSON字符串
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="value"></param>
    /// <returns></returns>
    public static string SerializeObject<T>(T? value)
    {
        return JsonConvert.SerializeObject(value, Settings);
    }

    /// <summary>
    /// 从JSON字符串反序列化对象
    /// </summary>
    /// <param name="value"></param>
    /// <returns></returns>
    public static object? DeserializeObject(string value)
    {
        return JsonConvert.DeserializeObject(value, Settings);
    }

    /// <summary>
    /// 从JSON字符串反序列化一个对象
    /// </summary>
    /// <typeparam name="T"></typeparam>
    /// <param name="json">A JSON string</param>
    /// <returns>A deserialized object</returns>
    public static T? DeserializeObject<T>(string json)
    {
        return JsonConvert.DeserializeObject<T>(json, Settings);
    }
}