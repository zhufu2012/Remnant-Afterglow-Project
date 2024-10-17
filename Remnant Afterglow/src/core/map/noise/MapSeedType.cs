using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public class MapSeedType
    {
        //生成种子方式id
        public int SeedTypeId;
        //生成种子方式名称
        public string SeedTypeName;
        /// <summary>
        /// 0 纯随机 （纯随机）
        /// 1 随机种子使用噪声（纯随机，
        ///    但可以记录地形对应的种子，之后使用该来处理噪声也能得到相同的地形。
        ///    游戏中，随机地图就是使用这个模式
        ///    可以使用这个来不断随机地形，好的地形可以将种子记录下来）
        /// 2 固定的随机数种子（地形不会变）
        /// 3 使用固定种子来处理噪声（有固定种子，那么地形就不会变）
        public int Type;
        /// <summary>
        /// 种子
        /// </summary>
        public int Seed;
        /// <summary>
        /// 噪声id
        /// </summary>
        public int NoiseId;


        public Random randonSeed;


        public MapGeneratorNoise noise;



        public MapSeedType(int id)
        {
            SeedTypeId = id;
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_SeedType, id);
            SeedTypeName = (string)dict["SeedTypeName"];
            Type = (int)dict["SeedWay"];
            Seed = (int)dict["Seed"];
            NoiseId = (int)dict["NoiseId"];
            if (Type == 0)
                randonSeed = new Random();//纯随机
            else if (Type == 1)//随机噪声
            {
                randonSeed = new Random();
                noise = new MapGeneratorNoise(NoiseId, randonSeed.Next(1, 100000000));
            }
            else if (Type == 2)//固定随机数
                randonSeed = new Random(Seed);
            else if (Type == 3)//
                noise = new MapGeneratorNoise(NoiseId, Seed);
            else
            {
                Random ran = new Random();
                randonSeed = new Random(ran.Next());
            }
        }



        public float getNoiseValue(int min, int max)
        {
            if (Type == 0)
                return randonSeed.Next(0, 1000000);
            else if (Type == 1)
                return (noise.getNoiseValue(min, max) + 1) * 500000;
            else if (Type == 2)
                return randonSeed.Next(1, 1000000);
            else if (Type == 3)
                return (noise.getNoiseValue(min, max) + 1) * 500000;
            else
                return randonSeed.Next(0, 1000000);
        }
    }
}
