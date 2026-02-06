using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 ExplodeData 用于 爆炸基础数据,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class ExplodeData
    {
        #region 参数及初始化
        /// <summary>
        /// 爆炸id
        /// </summary>
        public int ExplodeId { get; set; }
        /// <summary>
        /// 动画类型列表
        ///cfg_AnimaExplode_爆炸动画id列表
        /// </summary>
        public List<int> AnimaTypeList { get; set; }
        /// <summary>
        /// 爆炸音效id
        ///不写表示无音效
        /// </summary>
        public string SoundId { get; set; }
        /// <summary>
        /// 碰撞器所在层数
        ///(1-32)
        ///具体请按照
        ///cfg_MapPhysicsLayer_物理层配置id填写
        ///
        /// </summary>
        public int CollisionLayer { get; set; }
        /// <summary>
        /// 碰撞器检测哪些层的碰撞器
        ///具体请按照
        ///cfg_MapPhysicsLayer_物理层配置id填写
        ///仅检查碰撞器与这些层的碰撞
        /// </summary>
        public List<int> MaskLayerList { get; set; }
        /// <summary>
        /// 碰撞器挂载位置
        ///（X,Y）
        ///（0，0）表示单位中心
        /// </summary>
        public Vector2 CollidePos { get; set; }
        /// <summary>
        /// 碰撞器形状
        ///1 2D胶囊形状
        ///2 2D矩形
        ///3 2D圆形
        ///4 2D线段形状 
        ///5 2D多线段形状.描述多边形
        /// </summary>
        public int ShapeType { get; set; }
        /// <summary>
        /// 碰撞体形状参数列表
        ///当碰撞器形状为
        ///1 2D胶囊形状 （高度,半径）
        ///2 2D矩形，一个(X,Y)表示矩形的长宽
        ///3 2D圆形，(半径r)
        ///4 2D线段形状,两个点，第一起点，第二终点
        ///5 2D多线段形状.描述多边形
        ///描述一个多边形的所有顶点
        /// </summary>
        public List<List<float>> ShapePointList { get; set; }
        /// <summary>
        /// 碰撞器旋转角度
        ///单位为度数
        ///rotation_degrees
        /// </summary>
        public float CollideRotate { get; set; }
        /// <summary>
        /// 额外边距，
        ///如果该实体与另一个实体至少有这么近
        ///就会认为它们正在碰撞
        /// </summary>
        public float SafeMargin  { get; set; }

        public ExplodeData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ExplodeData, id);//public const string Config_ExplodeData = "cfg_ExplodeData"; 
			ExplodeId = (int)dict["ExplodeId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			SoundId = (string)dict["SoundId"];
			CollisionLayer = (int)dict["CollisionLayer"];
			MaskLayerList = (List<int>)dict["MaskLayerList"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<List<float>>)dict["ShapePointList"];
			CollideRotate = (float)dict["CollideRotate"];
			SafeMargin  = (float)dict["SafeMargin "];
			InitData();
        }

        
        public ExplodeData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_ExplodeData, cfg_id);//public const string Config_ExplodeData = "cfg_ExplodeData"; 
			ExplodeId = (int)dict["ExplodeId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			SoundId = (string)dict["SoundId"];
			CollisionLayer = (int)dict["CollisionLayer"];
			MaskLayerList = (List<int>)dict["MaskLayerList"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<List<float>>)dict["ShapePointList"];
			CollideRotate = (float)dict["CollideRotate"];
			SafeMargin  = (float)dict["SafeMargin "];
			InitData();
        }

        public ExplodeData(Dictionary<string, object> dict)
        {
			ExplodeId = (int)dict["ExplodeId"];
			AnimaTypeList = (List<int>)dict["AnimaTypeList"];
			SoundId = (string)dict["SoundId"];
			CollisionLayer = (int)dict["CollisionLayer"];
			MaskLayerList = (List<int>)dict["MaskLayerList"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<List<float>>)dict["ShapePointList"];
			CollideRotate = (float)dict["CollideRotate"];
			SafeMargin  = (float)dict["SafeMargin "];
			InitData();
        }
        #endregion
    }
}
