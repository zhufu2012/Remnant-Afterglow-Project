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
        /// 属性条位置及大小
        ///（X轴，Y轴）
        ///这是第一个属性条的位置
        ///之后的属性条是Y轴*属性条体积系数
        /// </summary>
        public Vector2 AttributeBarPos { get; set; }
        /// <summary>
        /// 属性条体积系数，
        ///用于属性条大小的计算
        /// </summary>
        public float Volume { get; set; }
        /// <summary>
        /// 碰撞器挂载位置
        ///（X,Y）
        ///（0，0）表示单位中心
        /// </summary>
        public Vector2 CollidePos { get; set; }
        /// <summary>
        /// 碰撞器形状(正方形碰撞体只跟子弹有关)
        ///1 2D矩形
        ///2 2D圆形
        /// </summary>
        public int ShapeType { get; set; }
        /// <summary>
        /// 碰撞体形状参数列表
        ///当碰撞器形状为
        ///1 2D矩形，一个(X,Y)表示矩形的长宽
        ///2 2D圆形，(半径r)
        /// </summary>
        public List<int> ShapePointList { get; set; }

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
			AttributeBarPos = (Vector2)dict["AttributeBarPos"];
			Volume = (float)dict["Volume"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<int>)dict["ShapePointList"];
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
			AttributeBarPos = (Vector2)dict["AttributeBarPos"];
			Volume = (float)dict["Volume"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<int>)dict["ShapePointList"];
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
			AttributeBarPos = (Vector2)dict["AttributeBarPos"];
			Volume = (float)dict["Volume"];
			CollidePos = (Vector2)dict["CollidePos"];
			ShapeType = (int)dict["ShapeType"];
			ShapePointList = (List<int>)dict["ShapePointList"];
			InitData();
        }
        #endregion
    }
}
