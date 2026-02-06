using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 BigMapBase 用于 生成大地图,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BigMapBase
    {
        #region 参数及初始化
        /// <summary>
        /// 大地图生成id
        /// </summary>
        public int BigMapId { get; set; }
        /// <summary>
        /// 大地图生成描述
        /// </summary>
        public string BigMapDescribe { get; set; }
        /// <summary>
        /// 大地图横轴
        /// </summary>
        public int Width { get; set; }
        /// <summary>
        /// 大地图纵轴
        /// </summary>
        public int Height { get; set; }
        /// <summary>
        /// 是否需要有
        ///边界墙壁
        /// </summary>
        public bool IsNeedWall { get; set; }
        /// <summary>
        /// 墙壁厚度
        /// </summary>
        public int WallThickness { get; set; }
        /// <summary>
        /// 默认材料id
        ///默认用这个节点填满地图
        /// </summary>
        public int DefaultNodeId { get; set; }
        /// <summary>
        /// 墙壁节点id
        /// </summary>
        public int WallMaterialId { get; set; }
        /// <summary>
        /// 是否使用
        ///噪声编辑器的数据
        ///True就是使用
        ///False就是使用后面的
        ///种子表数据
        /// </summary>
        public bool IsUseNoiseEdit { get; set; }
        /// <summary>
        /// 生成噪声种子类型id
        ///种子噪声相关表的
        ///cfg_SeedType_种子表
        /// </summary>
        public int SeedTypeId { get; set; }
        /// <summary>
        /// 生成密度是否反向判断
        ///true 表示小于这个数字就生成墙壁
        ///false 表示大于这个数字就生成
        /// </summary>
        public bool IsDensityContrary { get; set; }
        /// <summary>
        /// 生成密度
        ///百万分比，生成地图时任何非墙壁和大型结构的材料都需要生成一个1-100万的随机数，和这个数字比较，小于这个数字就生成
        ///
        /// </summary>
        public int Density { get; set; }
        /// <summary>
        /// 平滑墙壁规则列表，
        ///按照这些参数来进行光滑处理
        ///（参数1，参数2）|（参数1，参数2）
        ///别写大了，计算量上扛不住，
        ///参数1增加就是扩大检测范围
        ///参数2增加就是让每次平滑的力度增加（空地增加）
        ///每个（参数1，参数2）就是一次光滑处理
        ///参数1：检测多少范围内墙壁 1表示检测周围6个块
        ///参数2：检测周围图块（根据规则1）超过这个数量，
        ///本图块就是墙壁，没超过本图块就是空地，
        ///等于这个数量本图块就不处理
        /// </summary>
        public List<List<int>> WallParamList { get; set; }
        /// <summary>
        /// 固定生成节点列表(节点id,节点绘制层,
        ///节点位置X,节点位置Y,对应的点击事件id，对应的进入事件id)
        ///首先生成的固定节点列表
        ///位置可重复（可用于拓展特殊显示节点）
        /// </summary>
        public List<List<int>> FixedtCellList { get; set; }
        /// <summary>
        /// 随机生成节点列表
        ///(节点id,节点生成概率，节点生成逻辑id
        ///（cfg_BigMapLogic表id 0就是纯概率生成）)
        /// </summary>
        public List<List<int>> LogicIdList { get; set; }
        /// <summary>
        /// 大地图背景显示方式
        ///0 无背景
        ///1 背景图片
        ///2 背景着色器
        /// </summary>
        public int BackgroundType { get; set; }
        /// <summary>
        /// 大地图背景图
        /// </summary>
        public Texture2D BackgroundImage { get; set; }
        /// <summary>
        /// 大地图背景着色器
        ///路径
        /// </summary>
        public string BackgroundShader { get; set; }

        public BigMapBase(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapBase, id);//public const string Config_BigMapBase = "cfg_BigMapBase"; 
			BigMapId = (int)dict["BigMapId"];
			BigMapDescribe = (string)dict["BigMapDescribe"];
			Width = (int)dict["Width"];
			Height = (int)dict["Height"];
			IsNeedWall = (bool)dict["IsNeedWall"];
			WallThickness = (int)dict["WallThickness"];
			DefaultNodeId = (int)dict["DefaultNodeId"];
			WallMaterialId = (int)dict["WallMaterialId"];
			IsUseNoiseEdit = (bool)dict["IsUseNoiseEdit"];
			SeedTypeId = (int)dict["SeedTypeId"];
			IsDensityContrary = (bool)dict["IsDensityContrary"];
			Density = (int)dict["Density"];
			WallParamList = (List<List<int>>)dict["WallParamList"];
			FixedtCellList = (List<List<int>>)dict["FixedtCellList"];
			LogicIdList = (List<List<int>>)dict["LogicIdList"];
			BackgroundType = (int)dict["BackgroundType"];
			BackgroundImage = (Texture2D)dict["BackgroundImage"];
			BackgroundShader = (string)dict["BackgroundShader"];
			InitData();
        }

        
        public BigMapBase(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_BigMapBase, cfg_id);//public const string Config_BigMapBase = "cfg_BigMapBase"; 
			BigMapId = (int)dict["BigMapId"];
			BigMapDescribe = (string)dict["BigMapDescribe"];
			Width = (int)dict["Width"];
			Height = (int)dict["Height"];
			IsNeedWall = (bool)dict["IsNeedWall"];
			WallThickness = (int)dict["WallThickness"];
			DefaultNodeId = (int)dict["DefaultNodeId"];
			WallMaterialId = (int)dict["WallMaterialId"];
			IsUseNoiseEdit = (bool)dict["IsUseNoiseEdit"];
			SeedTypeId = (int)dict["SeedTypeId"];
			IsDensityContrary = (bool)dict["IsDensityContrary"];
			Density = (int)dict["Density"];
			WallParamList = (List<List<int>>)dict["WallParamList"];
			FixedtCellList = (List<List<int>>)dict["FixedtCellList"];
			LogicIdList = (List<List<int>>)dict["LogicIdList"];
			BackgroundType = (int)dict["BackgroundType"];
			BackgroundImage = (Texture2D)dict["BackgroundImage"];
			BackgroundShader = (string)dict["BackgroundShader"];
			InitData();
        }

        public BigMapBase(Dictionary<string, object> dict)
        {
			BigMapId = (int)dict["BigMapId"];
			BigMapDescribe = (string)dict["BigMapDescribe"];
			Width = (int)dict["Width"];
			Height = (int)dict["Height"];
			IsNeedWall = (bool)dict["IsNeedWall"];
			WallThickness = (int)dict["WallThickness"];
			DefaultNodeId = (int)dict["DefaultNodeId"];
			WallMaterialId = (int)dict["WallMaterialId"];
			IsUseNoiseEdit = (bool)dict["IsUseNoiseEdit"];
			SeedTypeId = (int)dict["SeedTypeId"];
			IsDensityContrary = (bool)dict["IsDensityContrary"];
			Density = (int)dict["Density"];
			WallParamList = (List<List<int>>)dict["WallParamList"];
			FixedtCellList = (List<List<int>>)dict["FixedtCellList"];
			LogicIdList = (List<List<int>>)dict["LogicIdList"];
			BackgroundType = (int)dict["BackgroundType"];
			BackgroundImage = (Texture2D)dict["BackgroundImage"];
			BackgroundShader = (string)dict["BackgroundShader"];
			InitData();
        }
        #endregion
    }
}
