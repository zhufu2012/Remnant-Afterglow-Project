
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体死亡遗留的 同一类 残骸
    /// </summary>
    struct Wreckage
    {
        /// <summary>
        /// 残骸id
        /// </summary>
        public int id;
        /// <summary>
        /// 超时时间
        /// </summary>
        public int out_time;
        /// <summary>
        /// 位置
        /// </summary>
        public Vector2 pos;
    }

    /// <summary>
    /// 残骸管理器
    /// </summary>
    public partial class WreckAgeManager : Node
    {
        public static WreckAgeManager Instance { get; set; }
        //残骸类型id
        private Dictionary<int, MultiMeshInstance2D> _multiMeshes = new();

        private List<Wreckage> _activeDebris = new();

        public WreckAgeManager()
        {
            Instance = this;
        }

        // 为每种残骸类型创建 MultiMeshInstance2D
        void CreateMultiMeshType(int wreckId, Texture2D texture)
        {
            var mmi = new MultiMeshInstance2D();
            mmi.Multimesh = new MultiMesh();
            mmi.Multimesh.TransformFormat = MultiMesh.TransformFormatEnum.Transform2D;
            mmi.Multimesh.InstanceCount = 0;
            // 配置材质
            var mat = new ShaderMaterial();
            //mat.Shader = preload("res://debris_shader.gdshader");
            //mat.SetShaderParam("albedo_texture", texture);
            mmi.Material = mat;

            _multiMeshes.Add(wreckId, mmi);
        }
    }
}