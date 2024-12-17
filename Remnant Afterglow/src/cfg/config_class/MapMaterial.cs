using System.Collections.Generic;
using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类 MapMaterial 用于 生成地图用材料,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class MapMaterial
    {
        #region 参数及初始化
        /// <summary>        
        /// 地图生成用材料id
        /// </summary>
        public int MaterialId { get; set; }
        /// <summary>        
        /// 地图生成用材料名称
        /// </summary>
        public string MaterialName { get; set; }
        /// <summary>        
        /// 可通过类型-注意仅地板层1的该材料有效果
        ///cfg_MapPassType_地图可通过类型的id
        /// </summary>
        public int PassTypeId { get; set; }
        /// <summary>        
        /// 生成概率
        ///这个概率是先满足地图生成密度之后
        ///计算的
        ///暂未使用
        /// </summary>
        public float Probability { get; set; }
        /// <summary>        
        /// 材料所用图集id
        ///地块表的cfg_MapImageSet_地图图像集id
        /// </summary>
        public int ImageSetId { get; set; }
        /// <summary>        
        /// 所在图集序号
        /// </summary>
        public int ImageSetIndex { get; set; }
        /// <summary>        
        /// 物理碰撞多边形坐标列表
        ///（PhysicsLayerId,X1,Y1,X2,Y2....）
        ///PhysicsLayerId是cfg_MapPhysicsLayer_物理层配置的主键，之后每个X,Y的组合，都是图块内部碰撞多边形的顶点坐标，
        ///X(0-20) Y（0-20）
        ///相同层的坐标总数小于3的无效（相同层坐标作为一个碰撞多边形）
        ///一层可以有多个碰撞多边形！！！
        ///（PhysicsLayerId1,X1,Y1,X2,Y2....）|（PhysicsLayerId2,X1,Y1,X2,Y2....）|（PhysicsLayerId3,X1,Y1,X2,Y2....）
        /// </summary>
        public List<List<int>> CollisionPolygon { get; set; }
        /// <summary>        
        /// 是否需要图块边缘处理
        ///即通过周围图块条件来确认自身图块
        ///该逻辑在地图生成基本完成后运行，可以用于对墙壁
        ///河流，海岸等区域的边缘进行合理的过渡
        ///具体图请看地块表中cfg_MapEdge_地图边缘连接配置
        /// </summary>
        public bool IsEdge { get; set; }
        /// <summary>        
        /// 小地图所示颜色
        /// </summary>
        public Color PreviewColor { get; set; }
        /// <summary>        
        /// 生成系数（暂未使用）
        /// </summary>
        public float Parame { get; set; }

        public MapMaterial(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapMaterial, id);//public const string Config_MapMaterial = "cfg_MapMaterial"; 
			MaterialId = (int)dict["MaterialId"];
			MaterialName = (string)dict["MaterialName"];
			PassTypeId = (int)dict["PassTypeId"];
			Probability = (float)dict["Probability"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			CollisionPolygon = (List<List<int>>)dict["CollisionPolygon"];
			IsEdge = (bool)dict["IsEdge"];
			PreviewColor = (Color)dict["PreviewColor"];
			Parame = (float)dict["Parame"];
			InitData();
        }

        
        public MapMaterial(string cfg_id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_MapMaterial, cfg_id);//public const string Config_MapMaterial = "cfg_MapMaterial"; 
			MaterialId = (int)dict["MaterialId"];
			MaterialName = (string)dict["MaterialName"];
			PassTypeId = (int)dict["PassTypeId"];
			Probability = (float)dict["Probability"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			CollisionPolygon = (List<List<int>>)dict["CollisionPolygon"];
			IsEdge = (bool)dict["IsEdge"];
			PreviewColor = (Color)dict["PreviewColor"];
			Parame = (float)dict["Parame"];
			InitData();
        }

        public MapMaterial(Dictionary<string, object> dict)
        {
			MaterialId = (int)dict["MaterialId"];
			MaterialName = (string)dict["MaterialName"];
			PassTypeId = (int)dict["PassTypeId"];
			Probability = (float)dict["Probability"];
			ImageSetId = (int)dict["ImageSetId"];
			ImageSetIndex = (int)dict["ImageSetIndex"];
			CollisionPolygon = (List<List<int>>)dict["CollisionPolygon"];
			IsEdge = (bool)dict["IsEdge"];
			PreviewColor = (Color)dict["PreviewColor"];
			Parame = (float)dict["Parame"];
			InitData();
        }
        #endregion
    }
}
