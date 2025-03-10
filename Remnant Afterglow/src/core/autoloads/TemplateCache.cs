using GameLog;
using Godot;
using Microsoft.CodeAnalysis;
using Microsoft.CodeAnalysis.CSharp;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text.RegularExpressions;
namespace Remnant_Afterglow
{

	/// <summary>
	/// 函数模板-缓存
	/// </summary>
	public partial class TemplateCache : Node
	{
		/// <summary>
		/// 模板缓存-<配置id,函数模板>
		/// </summary>
		private static readonly ConcurrentDictionary<string, ConcurrentDictionary<string, Delegate>> CompiledDelegates = new ConcurrentDictionary<string, ConcurrentDictionary<string, Delegate>>();

		private static Assembly CurrentDomain_AssemblyResolve(object sender, ResolveEventArgs args)
		{
			string assemblyName = new AssemblyName(args.Name).Name;
			string dllPath = Path.Combine("dll/", assemblyName + ".dll");
			if (File.Exists(dllPath))
			{
				byte[] assemblyData;
				using (FileStream fs = File.OpenRead(dllPath))
				{
					assemblyData = new byte[fs.Length];
					fs.Read(assemblyData, 0, assemblyData.Length);
				}
				return Assembly.Load(assemblyData);
			}
			return null;
		}

		/// <summary>
		/// 初始化所有函数模板
		/// </summary>
		public TemplateCache()
		{
			AppDomain.CurrentDomain.AssemblyResolve += CurrentDomain_AssemblyResolve;
			List<FunctionTemplate> list = FunctionTemplate.GetAllFunctionTemplate();
			for (int i = 0; i < list.Count; i++)
			{
				CompileTable(list[i]);
			}
			//Log.Print(ReconstructDelegate("Func<float,float,float,float,float,float,float,float,float>"));
			//Log.Print(ReconstructDelegate("Func<List<float>,List<float>>"));
		}

		/// <summary>
		/// 编译整个表数据
		/// </summary>
		/// <param name="table_name"></param>
		/// <param name="table_dict"></param>
		/// <param name="type_str"></param>
		/// <exception cref="Exception"></exception>
		public static void CompileTable(FunctionTemplate temp)
		{
			string table_name = temp.TableName;
			Dictionary<string, Dictionary<string, object>> table_dict = ConfigLoadSystem.GetCfg(table_name);
			Type type_str = ReconstructDelegate(temp.VariableType);

			string deficode = TemplateCode(temp, table_name, table_dict);
			// 使用Roslyn动态编译代码
			var syntaxTree = CSharpSyntaxTree.ParseText(deficode);
			var references = new[]
			{
				// 引用mscorlib.dll和System.Core.dll，以及其他可能需要的DLL
				MetadataReference.CreateFromFile(typeof(object).Assembly.Location),
				MetadataReference.CreateFromFile(typeof(Enumerable).Assembly.Location),
				// 如果你的代码依赖其他类型，记得在这里添加相应的引用
			};
			var compilation = CSharpCompilation.Create(
				"DynamicAssembly",
				options: new CSharpCompilationOptions(OutputKind.DynamicallyLinkedLibrary),
				syntaxTrees: new[] { syntaxTree },
				references: references);

			using (var ms = new MemoryStream())
			{
				var emitResult = compilation.Emit(ms);

				if (!emitResult.Success)
				{
					// 编译失败，输出错误信息
					foreach (var diagnostic in emitResult.Diagnostics.Where(d => d.IsWarningAsError || d.Severity == DiagnosticSeverity.Error))
					{
						Log.Error($"编译错误: {diagnostic}");
					}
					throw new Exception("编译失败");
				}
				// 加载编译后的程序集
				ms.Seek(0, SeekOrigin.Begin);
				var assembly = Assembly.Load(ms.ToArray());
				// 获取编译后的类型和方法
				var type = assembly.GetType("DynamicCode." + temp.TemplateId); // 根据实际情况修改类型名称
				ConcurrentDictionary<string, Delegate> compiledDelegate = new ConcurrentDictionary<string, Delegate>();
				foreach (var val in table_dict)
				{
					Dictionary<string, object> dict = val.Value;
					string cfg_id = "" + (int)dict[temp.TableKey];
					var method = type.GetMethod("Evaluate" + "_" + cfg_id); // 根据实际情况修改方法名称
					compiledDelegate[cfg_id] = Delegate.CreateDelegate(type_str, method);
					CompiledDelegates.TryAdd(table_name, compiledDelegate);
				}
			}
			return;
		}


		///把一个配置表的全部函数编译在一个类中
		public static string TemplateCode(FunctionTemplate temp, string table_name, Dictionary<string, Dictionary<string, object>> table_dict)
		{
			string class_name = temp.TemplateId;
			string default_code = @"using System;
	" + temp.CodePack +
	@"
namespace DynamicCode
{
	public class " + class_name +
	@"{
";
			foreach (var val in table_dict)
			{
				Dictionary<string, object> dict = val.Value;
				string code = (string)dict[temp.TableCode];
				string Return = (string)dict[temp.TableReturn];
				int id = (int)dict[temp.TableKey];
				string function_str = @"        public static " + temp.CodeReturn +
@"  Evaluate_" + id + "(" + temp.CodeVariable + @")
		{
			" + code + @"
			return " + Return + @";
		}
";
				default_code += function_str;
			}
			default_code += @"  }
}";
			return default_code;
		}

		public static Type ReconstructDelegate(string funcTypeStr)
		{
			// 替换字符串中的 "float" 为 "System.Single"
			// 替换字符串中的类型别名
			funcTypeStr = funcTypeStr.Replace("bool", "System.Boolean");
			funcTypeStr = funcTypeStr.Replace("char", "System.Char");
			funcTypeStr = funcTypeStr.Replace("sbyte", "System.SByte");
			funcTypeStr = funcTypeStr.Replace("byte", "System.Byte");
			funcTypeStr = funcTypeStr.Replace("short", "System.Int16");
			funcTypeStr = funcTypeStr.Replace("ushort", "System.UInt16");
			funcTypeStr = funcTypeStr.Replace("int", "System.Int32");
			funcTypeStr = funcTypeStr.Replace("uint", "System.UInt32");
			funcTypeStr = funcTypeStr.Replace("long", "System.Int64");
			funcTypeStr = funcTypeStr.Replace("ulong", "System.UInt64");
			funcTypeStr = funcTypeStr.Replace("float", "System.Single");
			funcTypeStr = funcTypeStr.Replace("double", "System.Double");
			funcTypeStr = funcTypeStr.Replace("decimal", "System.Decimal");
			funcTypeStr = funcTypeStr.Replace("string", "System.String");
			// 去掉开头的 "Func<" 和结尾的 ">"
			string innerTypes = funcTypeStr.Substring(5, funcTypeStr.Length - 6);
			// 获取所有类型参数
			string[] typeArgsStr = innerTypes.Split(',');
			// 创建类型参数列表
			List<Type> typeArgs = new List<Type>();
			foreach (string typeName in typeArgsStr)
			{
				Type type = GetTypeFromName(typeName.Trim()); // 使用自定义方法获取类型
				if (type == null)
					throw new ArgumentException($"Type '{typeName}' not found.");
				typeArgs.Add(type);
			}
			Type funcType;// 创建委托类型
			switch (typeArgs.Count)
			{
				case 1:
					funcType = typeof(Func<>).MakeGenericType(typeArgs.ToArray());
					break;
				case 2:
					funcType = typeof(Func<,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 3:
					funcType = typeof(Func<,,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 4:
					funcType = typeof(Func<,,,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 5:
					funcType = typeof(Func<,,,,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 6:
					funcType = typeof(Func<,,,,,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 7:
					funcType = typeof(Func<,,,,,,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 8:
					funcType = typeof(Func<,,,,,,,>).MakeGenericType(typeArgs.ToArray());
					break;
				case 9:
					funcType = typeof(Func<,,,,,,,,>).MakeGenericType(typeArgs.ToArray());
					break;
				default:
					throw new ArgumentException("Unsupported number of type arguments.");
			}
			return funcType;
		}

		private static Type GetTypeFromName(string typeName)
		{
			typeName = typeName.Replace("List", "System.Collections.Generic.List`1");
			typeName = typeName.Replace("<", "[");
			typeName = typeName.Replace(">", "]");
			Type nonGenericType = Type.GetType(typeName);
			if (nonGenericType != null)
				return nonGenericType;
			else
				throw new ArgumentException($"Type '{typeName}' not found.");

		}


		public static Delegate GetCompiledDelegate(string table_name, string cfg_id)
		{
			if (CompiledDelegates.TryGetValue(table_name, out ConcurrentDictionary<string, Delegate> compiledDelegate))
			{
				if (compiledDelegate.TryGetValue(cfg_id, out Delegate dele))
				{
					return dele;
				}
			}
			throw new Exception($"编译失败! cfg_id:{cfg_id}");
		}
	}
}
