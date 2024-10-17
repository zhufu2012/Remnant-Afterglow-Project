
using System;
using System.Collections.Generic;
namespace Remnant_Afterglow
{
///泛型参数列表
///一种配置类型，在配置中使用
public class ParamList<T>
{
    public int Key { get; private set; }
    public List<T> Values { get; private set; }

    public ParamList(int key, List<T> values)
    {
        Key = key;
        Values = values ?? throw new ArgumentNullException(nameof(values));
    }

}
}