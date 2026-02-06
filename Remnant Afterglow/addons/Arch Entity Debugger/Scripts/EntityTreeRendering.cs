namespace RoadTurtleGames.ArchEntityDebugger;

using Godot;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Reflection;

public static class EntityTreeRendering
{
    static Dictionary<Type, Type> genericTypedRenderers = new();
    static Dictionary<Type, IEntityTreeRenderer> customRenderers = new();

    static EntityTreeRendering()
    {
        // 添加对List<T>的默认处理
        genericTypedRenderers[typeof(List<>)] = typeof(ListEntityTreeRenderer<>);

        foreach (Type type in Assembly.GetExecutingAssembly().GetTypes())
        {
            if (typeof(IEntityTreeRenderer).IsAssignableFrom(type) && !type.IsAbstract && !type.IsInterface)
            {
                Type renderedType = null;

                EntityRendererAttribute attr = (EntityRendererAttribute)Attribute.GetCustomAttribute(type, typeof(EntityRendererAttribute));
                if (attr != null)
                {
                    renderedType = attr.RenderedType;
                }

                if (renderedType != null)
                {
                    if (type.IsGenericTypeDefinition)
                    {
                        genericTypedRenderers[renderedType] = type;
                        GD.Print($"Loaded generic type {type.Name}");
                    }
                    else
                    {
                        IEntityTreeRenderer instance = Activator.CreateInstance(type) as IEntityTreeRenderer;
                        customRenderers[renderedType] = instance;
                        GD.Print($"Loaded type {type.Name}");
                    }
                }
            }
        }
    }

    public static void Render(TreeItem parentItem, object component, int childIndex, string fieldName = "", bool highlighted = false, int depth = 0)
    {
        if (depth > 3)
            return;

        bool isNew = parentItem.CreateOrGetChild(childIndex, out TreeItem componentItem);
        if (!string.IsNullOrEmpty(fieldName))
            componentItem.SetText(0, fieldName);

        if (highlighted)
        {
            componentItem.SetCustomBgColor(0, new Color(1, 1, 1, 0.1f));
        }

        if (component == null)
        {
            componentItem.SetText(0, $"{fieldName}: NULL");
            componentItem.SetCustomColor(0, Colors.Red);
            return;
        }

        Type componentType = component.GetType();

        if (componentType.IsPrimitive || componentType == typeof(string))
        {
            componentItem.SetText(0, $"{fieldName}: {component}");
            return;
        }

        if (componentType.IsEnum)
        {
            componentItem.SetText(0, $"{fieldName}: {component}");
            return;
        }
        // 检查是否是IEnumerable类型（如List、Array等）
        if (typeof(IEnumerable).IsAssignableFrom(componentType) && componentType != typeof(string))
        {
            if (customRenderers.TryGetValue(componentType, out IEntityTreeRenderer customRenderer2))
            {
                customRenderer2.Render(isNew, componentItem, component, fieldName);
                return;
            }

            if (componentType.IsGenericType)
            {
                Type genericTypeDefinition = componentType.GetGenericTypeDefinition();
                if (genericTypedRenderers.TryGetValue(genericTypeDefinition, out Type rendererType))
                {
                    Type[] genericArgs = componentType.GetGenericArguments();
                    Type constructedRendererType = rendererType.MakeGenericType(genericArgs);
                    customRenderer2 = (IEntityTreeRenderer)Activator.CreateInstance(constructedRendererType);
                    customRenderer2.Render(isNew, componentItem, component, fieldName);

                    // Cache the instance in customRenderers for reuse
                    customRenderers[componentType] = customRenderer2;
                    return;
                }
            }

            // 默认处理IEnumerable类型
            RenderEnumerable(componentItem, (IEnumerable)component, fieldName, depth);
            return;
        }

        if (customRenderers.TryGetValue(componentType, out IEntityTreeRenderer customRenderer))
        {
            customRenderer.Render(isNew, componentItem, component, fieldName);

            return;
        }

        if (componentType.IsGenericType)
        {
            Type genericTypeDefinition = componentType.GetGenericTypeDefinition();
            if (genericTypedRenderers.TryGetValue(genericTypeDefinition, out Type rendererType))
            {
                customRenderer = (IEntityTreeRenderer)Activator.CreateInstance(rendererType.MakeGenericType(componentType.GetGenericArguments()));
                customRenderer.Render(isNew, componentItem, component, fieldName);

                // Cache the instance in customRenderers for reuse
                customRenderers[componentType] = customRenderer;

                return;
            }
        }

        FieldInfo[] fields = componentType.GetFields(BindingFlags.Public | BindingFlags.NonPublic | BindingFlags.Instance);
        int fieldIndex = -1;
        foreach (FieldInfo field in fields)
        {
            fieldIndex++;

            object fieldValue;
            try
            {
                fieldValue = field.GetValue(component);
                Render(componentItem, fieldValue, fieldIndex, field.Name, false, depth + 1);
            }
            catch (Exception e)
            {
                componentItem.CreateOrGetChild(fieldIndex, out TreeItem child);
                child.SetText(0, $"{field.Name} | {field.FieldType}: ERROR");
                child.SetTooltipText(0, e.Message);
                child.SetCustomColor(0, Colors.Red);
                return;
            }
        }
    }

    private static void RenderEnumerable(TreeItem parentItem, IEnumerable enumerable, string fieldName, int depth)
    {
        int index = 0;
        foreach (object item in enumerable)
        {
            Render(parentItem, item, index, $"[{index}]", false, depth + 1);
            index++;
        }

        if (index == 0)
        {
            parentItem.CreateOrGetChild(0, out TreeItem emptyItem);
            emptyItem.SetText(0, "Empty collection");
        }
    }
}

/// <summary>
/// 添加一个通用的List渲染器
/// </summary>
/// <typeparam name="T"></typeparam>
[EntityRenderer(typeof(List<>))]
public class ListEntityTreeRenderer<T> : IEntityTreeRenderer
{
    public void Render(bool isNew, TreeItem item, object value, string fieldName)
    {
        List<T> list = (List<T>)value;
        item.SetText(0, $"{fieldName} (List<{typeof(T).Name}>, Count: {list.Count})");

        if (isNew)
        {
            int index = 0;
            foreach (T element in list)
            {
                EntityTreeRendering.Render(item, element, index, $"[{index}]", false, 1);
                index++;
            }

            if (index == 0)
            {
                item.CreateOrGetChild(0, out TreeItem emptyItem);
                emptyItem.SetText(0, "Empty list");
            }
        }
    }
}
