namespace RoadTurtleGames.ArchEntityDebugger;

using Arch.Core.Utils;
using System.Collections.Generic;
using System.Linq;

/// <summary>
/// 用于 ComponentType 数组的自定义比较器。
/// 在字典中使用数组作为键时是必需的。
/// </summary>
public class ComponentTypeArrayComparer : IEqualityComparer<ComponentType[]>
{
    public bool Equals(ComponentType[] x, ComponentType[] y)
    {
        return Enumerable.SequenceEqual(x, y);
    }

    public int GetHashCode(ComponentType[] obj)
    {
        int hash = 19;
        foreach (ComponentType comp in obj)
        {
            hash = hash * 31 + comp.GetHashCode();
        }
        return hash;
    }
}
