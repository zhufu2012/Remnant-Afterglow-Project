using System.Collections.Generic;
namespace Remnant_Afterglow;

/// <summary>
/// 存储一系列属性（使用 <see cref="string"/> 作为键，<see cref="object"/> 作为值）的集合。
/// </summary>
public class NodeSave
{
    public static readonly NodeSave Empty = new NodeSave();

    /// <summary>
    /// 属性的集合。
    /// </summary>
    public Dictionary<string, object?> Properties { get; init; }

    public NodeSave() => Properties = new();

    public NodeSave(IDictionary<string, object?> properties) => Properties = new Dictionary<string, object?>(properties);

    /// <summary>
    /// 获取具有指定 <paramref name="key"/> 的属性的值。
    /// </summary>
    /// <typeparam name="T">属性的类型。</typeparam>
    /// <param name="key">要获取的属性的键。</param>
    /// <returns>属性的值。</returns>
    public T? GetProperty<T>(string key)
    {
        string json = SaveExtension.SerializeObject(Properties[key]);
        return SaveExtension.DeserializeObject<T>(json);
    }

    /// <summary>
    /// 尝试获取具有指定 <paramref name="key"/> 的属性的值。
    /// </summary>
    /// <typeparam name="T">属性的类型。</typeparam>
    /// <param name="key">要获取的属性的键。</param>
    /// <param name="value">如果键存在，则是属性的值。</param>
    /// <returns>如果键存在则返回 <see langword="true"/>，否则返回 <see langword="false"/>.</returns>
    public bool TryGetProperty<T>(string key, out T? value)
    {
        if (Properties.ContainsKey(key))
        {
            value = GetProperty<T>(key);
            return true;
        }
        else
        {
            value = default;
            return false;
        }
    }

    /// <summary>
    /// 添加一个具有指定 <paramref name="key"/> 和 <paramref name="value"/> 的属性。
    /// </summary>
    /// <typeparam name="T">属性的类型。</typeparam>
    /// <param name="key">要添加的属性的键。</param>
    /// <param name="value">要添加的属性的值。</param>
    public void AddProperty<T>(string key, T value) => Properties.Add(key, value!);

    /// <summary>
    /// 尝试添加一个具有指定 <paramref name="key"/> 和 <paramref name="value"/> 的属性。
    /// </summary>
    /// <typeparam name="T">属性的类型。</typeparam>
    /// <param name="key">要添加的属性的键。</param>
    /// <param name="value">要添加的属性的值。</param>
    /// <returns>如果属性被添加则返回 <see langword="true"/>，否则返回 <see langword="false"/>.</returns>
    public bool TryAddProperty<T>(string key, T value) => Properties.TryAdd(key, value!);

    /// <summary>
    /// 添加或更新具有指定 <paramref name="key"/> 和 <paramref name="value"/> 的属性。
    /// </summary>
    /// <typeparam name="T">属性的类型。</typeparam>
    /// <param name="key">要添加或更新的属性的键。</param>
    /// <param name="value">要添加或更新的属性的值。</param>
    public void SetOrAddProperty<T>(string key, T value)
    {
        if (Properties.ContainsKey(key))
            Properties[key] = value;
        else
            Properties.Add(key, value);
    }

    /// <summary>
    /// 尝试添加或更新具有指定 <paramref name="key"/> 和 <paramref name="value"/> 的属性。
    /// </summary>
    /// <typeparam name="T">属性的类型。</typeparam>
    /// <param name="key">要添加或更新的属性的键。</param>
    /// <param name="value">要添加或更新的属性的值。</param>
    /// <returns>如果属性被添加或更新则返回 <see langword="true"/>，否则返回 <see langword="false"/>.</returns>
    public bool TrySetOrAddProperty<T>(string key, T value)
    {
        if (Properties.ContainsKey(key))
        {
            Properties[key] = value;
            return true;
        }
        else
            return Properties.TryAdd(key, value);
    }

    /// <summary>
    /// 移除具有指定 <paramref name="key"/> 的属性。
    /// </summary>
    /// <param name="key">要移除的属性的键。</param>
    /// <returns>如果属性被移除则返回 <see langword="true"/>，否则返回 <see langword="false"/>.</returns>
    public bool RemoveProperty(string key) => Properties.Remove(key);
}