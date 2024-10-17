using GameLog;
using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;

public class MapGeneratorNoise : INoise
{


    /// <summary>
    /// 噪声
    /// </summary>
    public FastNoiseLite noise { get; set; }
    /// <summary>
    /// 噪声图大小x
    /// </summary>
    public int x;
    /// <summary>
    /// 噪声图大小y
    /// </summary>
    public int y;

    public MapGeneratorNoise(int id, int Seed)
    {
        Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex(ConfigConstant.Config_Noise, id);
        noise = new FastNoiseLite();
        noise.Seed = Seed;
        noise.NoiseType = (FastNoiseLite.NoiseTypeEnum)(int)dict["NoiseType"];
        noise.Frequency = (float)dict["Frequency"];
        noise.DomainWarpEnabled = (bool)dict["Enabled"];
        noise.DomainWarpAmplitude = (float)dict["Amplitude"];
        noise.DomainWarpFractalGain = (float)dict["WarpFractalGain"];
        noise.DomainWarpFractalType = (FastNoiseLite.DomainWarpFractalTypeEnum)(int)dict["WarpFractalType"];
        noise.DomainWarpFrequency = (float)dict["WarpFrequency"];
        noise.DomainWarpFractalOctaves = (int)dict["WarpFractalOctaves"];
        noise.DomainWarpType = (FastNoiseLite.DomainWarpTypeEnum)(int)dict["WarpType"];
        noise.FractalType = (FastNoiseLite.FractalTypeEnum)(int)dict["FractalType"];
        noise.FractalGain = (float)dict["FractalGain"];
        noise.FractalLacunarity = (float)dict["FractalLacunarity"];
        noise.FractalOctaves = (int)dict["FractalOctaves"];
        noise.FractalPingPongStrength = (float)dict["FractalPingPongStrength"];
        noise.FractalWeightedStrength = (float)dict["FractalWeightedStrength"];
        noise.CellularDistanceFunction = (FastNoiseLite.CellularDistanceFunctionEnum)(int)dict["DistanceFunction"];
        noise.CellularJitter = (float)dict["CellularJitter"];
        noise.CellularReturnType = (FastNoiseLite.CellularReturnTypeEnum)(int)dict["CellularReturnType"];
        x = (int)dict["NoiseX"];
        y = (int)dict["NoiseY"];
    }

    public float getNoiseValue(int x, int y)
    {
        return noise.GetNoise2D(x, y);
    }
}