using System.Collections.Generic;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 GenerateBottomMap 用于 随机生成地图方式,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class GenerateBottomMap
    {
        #region 参数及初始化
        /// <summary>
        /// 底层生成方式id
        /// </summary>
        public int GenerateMapId { get; set; }
        /// <summary>
        /// 生成方式名称
        /// </summary>
        public string GenerateMapName { get; set; }
        /// <summary>
        /// 生成地图
        ///的横轴长度
        /// </summary>
        public int Width { get; set; }
        /// <summary>
        /// 生成地图
        ///的纵轴长度
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
        ///默认用这个材料填满地图
        /// </summary>
        public int DefaultMaterialId { get; set; }
        /// <summary>
        /// 墙壁材料id
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
        ///
        ///（参数1，参数2）|（参数1，参数2）
        ///别写大了，计算量上扛不住，
        ///参数1增加就是扩大检测范围
        ///参数2增加就是让每次平滑的力度增加（空地增加）
        ///每个（参数1，参数2）就是一次光滑处理
        ///参数1：检测多少范围内墙壁 1表示检测周围8个块
        ///参数2：检测周围图块（根据规则1）超过这个数量，
        ///本图块就是墙壁，没超过本图块就是空地，等于这个数量本图块就不处理
        /// </summary>
        public List<List<int>> WallParamList { get; set; }
        /// <summary>
        /// 装饰层id列表
        ///cfg_GenerateAdornMap
        ///绘制完成该层后
        ///再绘制装饰层
        ///不写也没问题
        /// </summary>
        public List<int> AdornLayerIdList { get; set; }
        /// <summary>
        /// 地图额外绘制id列表
        ///cfg_MapExtraDraw
        ///用于对地图进行
        ///额外的绘制，比如
        ///绘制一条从左下到右上的通道
        /// </summary>
        public List<int> ExtraDrawIdList { get; set; }
        /// <summary>
        /// 地图大型结构id列表
        ///cfg_GenerateBigStruct
        /// </summary>
        public List<int> BigStructIdList { get; set; }
        /// <summary>
        /// 是否清除小尺寸墙壁
        /// </summary>
        public bool IsClearWall { get; set; }
        /// <summary>
        /// 是否清除小尺寸空地
        /// </summary>
        public bool IsClearDefine { get; set; }
        /// <summary>
        /// 墙壁区域最小尺寸
        ///小于这个尺寸的都清除
        ///
        /// </summary>
        public int MinWallMeasure { get; set; }
        /// <summary>
        /// 默认区域最小尺寸
        ///小于这个尺寸就清除
        ///
        /// </summary>
        public int MinDefineMeasure { get; set; }
        /// <summary>
        /// 是否绘制通道
        /// </summary>
        public bool IsDrawPass { get; set; }
        /// <summary>
        /// 连接通道材料id
        /// </summary>
        public int PassMaterialId { get; set; }
        /// <summary>
        /// 连接通道的宽度
        ///连接各区域的通道的宽度
        /// </summary>
        public int PassWidth { get; set; }

        public GenerateBottomMap(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateBottomMap, id);//public const string Config_GenerateBottomMap = "cfg_GenerateBottomMap"; 
			GenerateMapId = (int)dict["GenerateMapId"];
			GenerateMapName = (string)dict["GenerateMapName"];
			Width = (int)dict["Width"];
			Height = (int)dict["Height"];
			IsNeedWall = (bool)dict["IsNeedWall"];
			WallThickness = (int)dict["WallThickness"];
			DefaultMaterialId = (int)dict["DefaultMaterialId"];
			WallMaterialId = (int)dict["WallMaterialId"];
			IsUseNoiseEdit = (bool)dict["IsUseNoiseEdit"];
			SeedTypeId = (int)dict["SeedTypeId"];
			IsDensityContrary = (bool)dict["IsDensityContrary"];
			Density = (int)dict["Density"];
			WallParamList = (List<List<int>>)dict["WallParamList"];
			AdornLayerIdList = (List<int>)dict["AdornLayerIdList"];
			ExtraDrawIdList = (List<int>)dict["ExtraDrawIdList"];
			BigStructIdList = (List<int>)dict["BigStructIdList"];
			IsClearWall = (bool)dict["IsClearWall"];
			IsClearDefine = (bool)dict["IsClearDefine"];
			MinWallMeasure = (int)dict["MinWallMeasure"];
			MinDefineMeasure = (int)dict["MinDefineMeasure"];
			IsDrawPass = (bool)dict["IsDrawPass"];
			PassMaterialId = (int)dict["PassMaterialId"];
			PassWidth = (int)dict["PassWidth"];
			InitData();
        }

        
        public GenerateBottomMap(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateBottomMap, cfg_id);//public const string Config_GenerateBottomMap = "cfg_GenerateBottomMap"; 
			GenerateMapId = (int)dict["GenerateMapId"];
			GenerateMapName = (string)dict["GenerateMapName"];
			Width = (int)dict["Width"];
			Height = (int)dict["Height"];
			IsNeedWall = (bool)dict["IsNeedWall"];
			WallThickness = (int)dict["WallThickness"];
			DefaultMaterialId = (int)dict["DefaultMaterialId"];
			WallMaterialId = (int)dict["WallMaterialId"];
			IsUseNoiseEdit = (bool)dict["IsUseNoiseEdit"];
			SeedTypeId = (int)dict["SeedTypeId"];
			IsDensityContrary = (bool)dict["IsDensityContrary"];
			Density = (int)dict["Density"];
			WallParamList = (List<List<int>>)dict["WallParamList"];
			AdornLayerIdList = (List<int>)dict["AdornLayerIdList"];
			ExtraDrawIdList = (List<int>)dict["ExtraDrawIdList"];
			BigStructIdList = (List<int>)dict["BigStructIdList"];
			IsClearWall = (bool)dict["IsClearWall"];
			IsClearDefine = (bool)dict["IsClearDefine"];
			MinWallMeasure = (int)dict["MinWallMeasure"];
			MinDefineMeasure = (int)dict["MinDefineMeasure"];
			IsDrawPass = (bool)dict["IsDrawPass"];
			PassMaterialId = (int)dict["PassMaterialId"];
			PassWidth = (int)dict["PassWidth"];
			InitData();
        }

        public GenerateBottomMap(Dictionary<string, object> dict)
        {
			GenerateMapId = (int)dict["GenerateMapId"];
			GenerateMapName = (string)dict["GenerateMapName"];
			Width = (int)dict["Width"];
			Height = (int)dict["Height"];
			IsNeedWall = (bool)dict["IsNeedWall"];
			WallThickness = (int)dict["WallThickness"];
			DefaultMaterialId = (int)dict["DefaultMaterialId"];
			WallMaterialId = (int)dict["WallMaterialId"];
			IsUseNoiseEdit = (bool)dict["IsUseNoiseEdit"];
			SeedTypeId = (int)dict["SeedTypeId"];
			IsDensityContrary = (bool)dict["IsDensityContrary"];
			Density = (int)dict["Density"];
			WallParamList = (List<List<int>>)dict["WallParamList"];
			AdornLayerIdList = (List<int>)dict["AdornLayerIdList"];
			ExtraDrawIdList = (List<int>)dict["ExtraDrawIdList"];
			BigStructIdList = (List<int>)dict["BigStructIdList"];
			IsClearWall = (bool)dict["IsClearWall"];
			IsClearDefine = (bool)dict["IsClearDefine"];
			MinWallMeasure = (int)dict["MinWallMeasure"];
			MinDefineMeasure = (int)dict["MinDefineMeasure"];
			IsDrawPass = (bool)dict["IsDrawPass"];
			PassMaterialId = (int)dict["PassMaterialId"];
			PassWidth = (int)dict["PassWidth"];
			InitData();
        }
        #endregion
    }
}
