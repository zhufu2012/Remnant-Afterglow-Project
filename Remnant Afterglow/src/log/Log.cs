using Godot;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Text;

namespace GameLog
{
    public static class Log
    {
        /// <summary>
        /// 日志级别枚举
        /// </summary>
        public enum LogLevel
        {
            Debug,
            Info,
            Warning,
            Error
        }

        /// <summary>
        /// 当前日志级别，低于此级别的日志不会被输出
        /// </summary>
        public static LogLevel CurrentLogLevel { get; set; } = LogLevel.Debug;

        /// <summary>
        /// 是否在输出日志时包含时间戳
        /// </summary>
        public static bool ShowTimestamp { get; set; } = true;

        /// <summary>
        /// 是否在输出日志时包含调用堆栈信息
        /// </summary>
        public static bool ShowStackTrace { get; set; } = false;

        /// <summary>
        /// 内部日志输出方法
        /// </summary>
        /// <param name="level">日志级别</param>
        /// <param name="objects">要输出的对象数组</param>
        private static void InternalPrint(LogLevel level, params object[] objects)
        {
            if (level < CurrentLogLevel)
                return;

            StringBuilder sb = new StringBuilder();

            // 添加时间戳
            if (ShowTimestamp)
            {
                sb.Append($"[{DateTime.Now:HH:mm:ss.fff}] ");
            }

            // 添加日志级别标识
            switch (level)
            {
                case LogLevel.Debug:
                    sb.Append("[DEBUG] ");
                    break;
                case LogLevel.Info:
                    sb.Append("[INFO] ");
                    break;
                case LogLevel.Warning:
                    sb.Append("[WARNING] ");
                    break;
                case LogLevel.Error:
                    sb.Append("[ERROR] ");
                    break;
            }

            // 添加日志内容
            foreach (var obj in objects)
            {
                sb.Append(obj?.ToString() ?? "null");
                sb.Append(" ");
            }

            // 输出日志
            switch (level)
            {
                case LogLevel.Warning:
                case LogLevel.Error:
                    GD.PrintErr(sb.ToString());
                    break;
                default:
                    GD.Print(sb.ToString());
                    break;
            }

            // 添加堆栈跟踪
            if (ShowStackTrace && level >= LogLevel.Warning)
            {
                StackTrace st = new StackTrace(true);
                GD.Print($"Stack trace: {st}");
            }
        }

        /// <summary>
        /// 输出调试信息
        /// </summary>
        /// <param name="what">要输出的内容</param>
        public static void Debug(params object[] what)
        {
            InternalPrint(LogLevel.Debug, what);
        }

        /// <summary>
        /// 输出普通信息
        /// </summary>
        /// <param name="what">要输出的内容</param>
        public static void Info(params object[] what)
        {
            InternalPrint(LogLevel.Info, what);
        }

        /// <summary>
        /// 输出警告信息
        /// </summary>
        /// <param name="what">要输出的内容</param>
        public static void Warning(params object[] what)
        {
            InternalPrint(LogLevel.Warning, what);
        }

        /// <summary>
        /// 输出错误信息
        /// </summary>
        /// <param name="what">要输出的内容</param>
        public static void Error(params object[] what)
        {
            InternalPrint(LogLevel.Error, what);
        }

        /// <summary>
        /// 原始的Print方法，保持向后兼容
        /// </summary>
        /// <param name="what">要输出的内容</param>
        public static void Print(params object[] what)
        {
            InternalPrint(LogLevel.Info, what);
        }

        /// <summary>
        /// 输出列表内容
        /// </summary>
        /// <typeparam name="T">列表元素类型</typeparam>
        /// <param name="list">要输出的列表</param>
        public static void PrintList<T>(List<T> list)
        {
            if (list == null)
            {
                Print("List is null");
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine($"List<{typeof(T).Name}> with {list.Count} elements:");
            for (int i = 0; i < list.Count; i++)
            {
                sb.AppendLine($"  [{i}] = {list[i]?.ToString() ?? "null"}");
            }
            Print(sb.ToString());
        }

        /// <summary>
        /// 输出数组内容
        /// </summary>
        /// <typeparam name="T">数组元素类型</typeparam>
        /// <param name="array">要输出的数组</param>
        public static void PrintArray<T>(T[] array)
        {
            if (array == null)
            {
                Print("Array is null");
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine($"Array<{typeof(T).Name}> with {array.Length} elements:");
            for (int i = 0; i < array.Length; i++)
            {
                sb.AppendLine($"  [{i}] = {array[i]?.ToString() ?? "null"}");
            }
            Print(sb.ToString());
        }

        /// <summary>
        /// 输出字典内容（键为int类型）
        /// </summary>
        /// <typeparam name="T">字典值类型</typeparam>
        /// <param name="dict">要输出的字典</param>
        public static void PrintDict<T>(Dictionary<int, T> dict)
        {
            if (dict == null)
            {
                Print("Dictionary is null");
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine($"Dictionary<int, {typeof(T).Name}> with {dict.Count} elements:");
            foreach (var kvp in dict)
            {
                sb.AppendLine($"  [{kvp.Key}] = {kvp.Value?.ToString() ?? "null"}");
            }
            Print(sb.ToString());
        }

        /// <summary>
        /// 输出字典内容（键为泛型）
        /// </summary>
        /// <typeparam name="T">字典键类型</typeparam>
        /// <param name="dict">要输出的字典</param>
        public static void PrintDict<T>(Dictionary<T, object> dict)
        {
            if (dict == null)
            {
                Print("Dictionary is null");
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine($"Dictionary<{typeof(T).Name}, object> with {dict.Count} elements:");
            foreach (var kvp in dict)
            {
                sb.AppendLine($"  [{kvp.Key?.ToString() ?? "null"}] = {kvp.Value?.ToString() ?? "null"}");
            }
            Print(sb.ToString());
        }

        /// <summary>
        /// 输出Object字典内容
        /// </summary>
        /// <param name="dict">要输出的字典</param>
        public static void Print(Dictionary<Object, Object> dict)
        {
            if (dict == null)
            {
                Print("Dictionary is null");
                return;
            }

            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Dictionary<Object, Object> with " + dict.Count + " elements:");
            foreach (KeyValuePair<Object, Object> kvp in dict)
            {
                sb.AppendLine($"  Key: {kvp.Key?.ToString() ?? "null"}   Value: {kvp.Value?.ToString() ?? "null"}");
            }
            Print(sb.ToString());
        }

        /// <summary>
        /// 输出配置错误信息
        /// </summary>
        /// <param name="what">要输出的内容</param>
        public static void PrintConfigError(params object[] what)
        {
            StringBuilder sb = new StringBuilder();
            sb.Append("[CONFIG ERROR] ");
            foreach (var obj in what)
            {
                sb.Append(obj?.ToString() ?? "null");
                sb.Append(" ");
            }
            GD.PrintErr(sb.ToString());
        }

        /// <summary>
        /// 条件性输出日志（仅在条件为true时输出）
        /// </summary>
        /// <param name="condition">条件</param>
        /// <param name="what">要输出的内容</param>
        public static void PrintIf(bool condition, params object[] what)
        {
            if (condition)
            {
                Print(what);
            }
        }
    }
}
