using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BaseObjectData 用于 实体表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BaseObjectData
    {
        #region 参数及初始化
        /// <summary>        
        /// 实体id
        ///实体唯一id,不能为负数或0
        /// </summary>
        public int ObjectId { get; set; }
        /// <summary>        
        /// 实体类型
        ///1 单位
        ///2 炮塔
        ///3 建筑
        ///4 无人机
        ///
        /// </summary>
        public int ObjectType { get; set; }
        /// <summary>        
        /// 所属阵营id
        ///cfg_Troops_阵营id
        /// </summary>
        public int CampId { get; set; }
        /// <summary>        
        /// 属性模板id列表
        ///属性是cfg_AttributeTemplate_属性模板表与cfg_AttributeData_实体属性表覆盖的结果
        /// </summary>
        public List<int> TempLateList { get; set; }
        /// <summary>        
        /// 默认Buff标签Id列表
        ///buff标签用于管理实体可以添加哪些Buff,
        ///禁止添加哪些Buff
        ///注意！默认在实体上的tag没法移除
        ///具体请看：
        ///buff配置.xlsx-cfg_BuffTag_buff标签数据
        ///可通过属性事件修改
        /// </summary>
        public HashSet<int> BuffTagIdList { get; set; }
        /// <summary>        
        /// 默认Buff Id列表
        ///buff用于实体可以影响许多属性和效果,一种buff只能存在一个
        ///具体请看：
        ///buff配置.xlsx-cfg_BuffData_buff基础数据
        ///可通过属性事件修改
        /// </summary>
        public HashSet<int> BuffIdList { get; set; }
        /// <summary>        
        /// 是否可以移动
        ///
        /// </summary>
        public bool IsMove { get; set; }
        /// <summary>        
        /// 是否有碰撞器
        ///即是否可碰撞
        /// </summary>
        public bool IsCollide { get; set; }
        /// <summary>        
        /// 需要显示的属性条
        ///
        ///cfg_AttributeBase_属性表id
        /// </summary>
        public List<int> AttributeBarList { get; set; }
        /// <summary>        
        /// 体积系数，
        ///用于属性条大小的计算
        /// </summary>
        public float Volume { get; set; }
        /// <summary>        
        /// 碰撞器所在层数（可多写）
        ///(1-32)
        ///具体请按照
        ///cfg_MapPhysicsLayer_物理层配置id填写
        ///
        /// </summary>
        public List<int> CollisionLayerList { get; set; }
        /// <summary>        
        /// 碰撞器检测哪些层的碰撞器（可多写）
        ///具体请按照
        ///cfg_MapPhysicsLayer_物理层配置id填写
        ///
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
        /// </summary>
        public int ShapeType { get; set; }
        /// <summary>        
        /// 碰撞体形状参数列表
        ///当碰撞器形状为
        ///1 2D胶囊形状 （高度,半径）
        ///2 2D矩形，一个(X,Y)表示矩形的长宽
        ///3 2D圆形，(半径r)
        /// </summary>
        public List<int> ShapePointList { get; set; }
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
        public float SafeMargin { get; set; }

        public BaseObjectData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BaseObjectData, id);//public const string Config_BaseObjectData = "cfg_BaseObjectData"; 
			ObjectId = (int)dict["ObjectId"];
			ObjectType = (int)dict["ObjectType"];
			CampId = (int)dict["CampId"];
			TempLateList = (List<int>)dict["TempLateList"];
			BuffTagIdList = (HashSet<int>)dict["BuffTagIdList"];
			BuffIdList = (HashSet<int>)dict["BuffIdList"];
			IsMove = (bool)dict["IsMove"];
			IsCollide = (bool)dict["IsCollide"];
			AttributeBarList = (List<int>)dict["AttributeBarList"];
			Volume = (float)dict["Volume"];
			CollisionLayerList = (List<int>)dict["CollisionLayerList"];
			MaskLayerList = (List<int>)dict["MaskLayerList"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<int>)dict["ShapePointList"];
			CollideRotate = (float)dict["CollideRotate"];
			SafeMargin = (float)dict["SafeMargin"];
			InitData();
        }

        
        public BaseObjectData(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BaseObjectData, cfg_id);//public const string Config_BaseObjectData = "cfg_BaseObjectData"; 
			ObjectId = (int)dict["ObjectId"];
			ObjectType = (int)dict["ObjectType"];
			CampId = (int)dict["CampId"];
			TempLateList = (List<int>)dict["TempLateList"];
			BuffTagIdList = (HashSet<int>)dict["BuffTagIdList"];
			BuffIdList = (HashSet<int>)dict["BuffIdList"];
			IsMove = (bool)dict["IsMove"];
			IsCollide = (bool)dict["IsCollide"];
			AttributeBarList = (List<int>)dict["AttributeBarList"];
			Volume = (float)dict["Volume"];
			CollisionLayerList = (List<int>)dict["CollisionLayerList"];
			MaskLayerList = (List<int>)dict["MaskLayerList"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<int>)dict["ShapePointList"];
			CollideRotate = (float)dict["CollideRotate"];
			SafeMargin = (float)dict["SafeMargin"];
			InitData();
        }

        public BaseObjectData(Dictionary<string, object> dict)
        {
			ObjectId = (int)dict["ObjectId"];
			ObjectType = (int)dict["ObjectType"];
			CampId = (int)dict["CampId"];
			TempLateList = (List<int>)dict["TempLateList"];
			BuffTagIdList = (HashSet<int>)dict["BuffTagIdList"];
			BuffIdList = (HashSet<int>)dict["BuffIdList"];
			IsMove = (bool)dict["IsMove"];
			IsCollide = (bool)dict["IsCollide"];
			AttributeBarList = (List<int>)dict["AttributeBarList"];
			Volume = (float)dict["Volume"];
			CollisionLayerList = (List<int>)dict["CollisionLayerList"];
			MaskLayerList = (List<int>)dict["MaskLayerList"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<int>)dict["ShapePointList"];
			CollideRotate = (float)dict["CollideRotate"];
			SafeMargin = (float)dict["SafeMargin"];
			InitData();
        }
        #endregion
    }
}
