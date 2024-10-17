
using GameLog;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 地面装饰层
    /// </summary>
    public class MapAdornData
    {
        public int GenerateLayerMapId;
        /// <summary>
        /// 绘制层数
        /// </summary>
        public int Layer;
        /// <summary>
        /// 生成噪声种子类型id
        /// </summary>
        public MapSeedType Seed;
        /// <summary>
        /// 生成地图用材料id列表(材料id,生成密度)
        /// </summary>
        public List<KeyValuePair<int, MapMaterial>> MaterialList = new List<KeyValuePair<int, MapMaterial>>();
        /// <summary>
        /// 地图大型结构id列表
        /// </summary>
        public List<MapBigStructData> BigStructList = new List<MapBigStructData>();
        public MapAdornData(int id)
        {
            GenerateLayerMapId = id;
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_GenerateAdornMap, id);
            Layer = (int)dict["Layer"];
            Seed = new MapSeedType((int)dict["SeedTypeId"]);
            List<List<int>> list = (List<List<int>>)dict["MaterialIdList"];
            for (int i = 0; i < list.Count; i++)
            {
                //Log.Print(list[i][0]);
                //Log.Print(list[i][1]);
                //Log.Print(new KeyValuePair<int, MapMaterial>(list[i][1], new MapMaterial(list[i][0])));
                MaterialList.Add(new KeyValuePair<int, MapMaterial>(list[i][1], new MapMaterial(list[i][0])));
            }
            List<int> list2 = (List<int>)dict["BigStructIdList"];
            for (int i = 0; i < list2.Count; i++)
                BigStructList.Add(new MapBigStructData(list2[i]));
        }

    }


    /// <summary>
    /// 地图装饰
    /// </summary>
    public class MapAdorn
    {
        //  GenerateLayerMapId		Layer	SeedTypeId	Density	MaterialIdList	BigStructIdList
        //  INT		INT	INT	INT	<INT>	<INT>



        public MapAdorn(int id)
        {


        }

    }
}