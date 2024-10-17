using System.Reflection;
using System.Text.Json;

namespace SceneCore_Space
{
    internal class Compatibility_Json
    {
        //解决这撒比玩意与godot当前的不兼容，卸载程序集 System.Text.Json
        [System.Runtime.CompilerServices.ModuleInitializer]
        public static void Initialize()
        {
            System.Runtime.Loader.AssemblyLoadContext.GetLoadContext(System.Reflection.Assembly.GetExecutingAssembly()).Unloading += alc =>
            {
                var assembly = typeof(JsonSerializerOptions).Assembly;
                var updateHandlerType = assembly.GetType("System.Text.Json.JsonSerializerOptionsUpdateHandler");
                var clearCacheMethod = updateHandlerType?.GetMethod("ClearCache", BindingFlags.Static | BindingFlags.Public);
                clearCacheMethod?.Invoke(null, new object?[] { null });

            };
        }
    }
}
