using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;
using System.Text;

namespace Project_Core_Test
{
    /// <summary>
    /// 刷新点所有属性
    /// </summary>
    public class BrushPoint
    {
        public long uid = 0;//祝福注释 实体uid  唯一

        //刷新点id 配置
        public int brush_id = 0;

        //刷新点位置
        public Vector2 Pos = new Vector2();
        //刷新类型名称
        public string Brush_Type_Name = "";
        //刷新类型描述
        public string Brush_Describe = "";
        //第一波出现前时间
        public float FirstWaveTime = 10;

        //每个波次的刷新配置
        public List<Wave> WaveList = new List<Wave>();

        //刷新点形状
        //刷新点使用选择，0，表示全图随机刷新  1，表示在一个点刷新 2，表示多边形刷新
        //读取Polygon所有坐标相连（至少一个点）3，表示圆形刷新
        public int Shape_Select = 0;

        //Shape_Select = 2使用 全局位置
        public List<Vector2> PolygonList = new List<Vector2>();

        //Shape_Select = 3 使用
        public float Radius = 0;

        //================================刷新点数据========================//
        //当前波数，0表示还未刷新
        public int now_wave_num = 0;

        //是否开始刷新了
        public bool is_start_fiush = false;

        //是否在刷新间隔中
        public bool is_after_time = false;

        public double flush_time = 0;//刷新间隔

        //是否已经刷新完了
        public bool is_end_fiush = false;

        //================================刷新点数据========================//


        public BrushPoint()
        {

        }

        public BrushPoint(int BrushId)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex("cfg_MapBrushPoint", BrushId);
            brush_id = (int)dict["Map_Brush_Id"];
            Pos = (Vector2)dict["BrushPos"];
            Brush_Type_Name = (string)dict["Brush_Type_Name"];
            Brush_Describe = (string)dict["Brush_Describe"];
            FirstWaveTime = (float)dict["FirstWaveTime"];
            List<int> wavelist = (List<int>)dict["WaveList"];
            Shape_Select = (int)dict["Shape_Select"];
            PolygonList = (List<Vector2>)dict["Polygon"];
            Radius = (float)dict["Radius"];
            foreach (int i in wavelist)
            {
                WaveList.Add(new Wave(i));
            }
        }



        /// <summary>
        /// 检查是否能刷怪
        /// </summary>
        /// <param name="NowTime">当前时间</param>
        public Dictionary<int, int> Check_RefreshEnemies(double NowTime, double delta)
        {
            Dictionary<int, int> dict = new Dictionary<int, int>();
            if (is_start_fiush)//已经开始刷怪
            {
                dict = RefreshEnemies(delta);
            }
            else
            {
                if (NowTime >= FirstWaveTime)
                {
                    is_start_fiush = true;
                    dict = RefreshEnemies(delta);
                }
            }
            return dict;
        }


        /// <summary>
        /// 刷怪
        /// </summary>
        /// <param name="delta"></param>
        /// <returns></returns>
        public Dictionary<int, int> RefreshEnemies(double delta)
        {
            Dictionary<int, int> dict = new Dictionary<int, int>();
            if (now_wave_num <= WaveList.Count - 1)//波数没刷玩
            {

                Wave wave = WaveList[now_wave_num];
                if (wave.is_flush_acc)//是否已经刷新完了
                    return dict;
                else//没刷新玩
                {
                    if (is_after_time)//是否在刷新间隔中,是刷新间隔就继续增加
                    {
                        flush_time += delta;
                        return dict;
                    }
                    if (is_after_time == false || flush_time >= wave.Wave_After_Time)
                    {
                        switch (wave.Wave_Type)
                        {
                            case 1://全部直接刷新
                                dict = DictUtil.AddDictionaries(dict, wave.Wave_Data);
                                wave.HistoryWaveData = wave.Wave_Data;
                                wave.is_flush_acc = true;
                                WaveList[now_wave_num] = wave;
                                now_wave_num += 1;
                                is_after_time = true;//进入刷新间隔
                                flush_time = 0;
                                return dict;
                            case 2:

                                WaveList[now_wave_num] = wave;
                                now_wave_num += 1;
                                is_after_time = false;
                                flush_time = 0;
                                return dict;
                            default:
                                flush_time = 0;
                                now_wave_num += 1;
                                return dict;
                        }
                    }
                    else
                        return dict;
                }

            }
            else
            {//表示刷新玩了
                is_end_fiush = true;
                return dict;
            }
        }




        /// <summary>
        /// 获取该刷新点要刷新的所有怪的类型和数量
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, int> GetEnemy()
        {
            Dictionary<int, int> dict = new Dictionary<int, int>();
            for (int i = 0; i < WaveList.Count; i++)
            {
                Dictionary<int, int> wave_enemy_list = WaveList[i].Wave_Data;
                foreach (var j in wave_enemy_list)
                {
                    if (dict.ContainsKey(j.Key))
                    {
                        dict.TryAdd(j.Key, j.Value);
                    }
                    else
                    {
                        dict[j.Key] = j.Value;
                    }
                }
            }
            return dict;
        }



        public override string ToString()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine($"UID: {uid}");
            sb.AppendLine($"Brush ID: {brush_id}");
            sb.AppendLine($"Position: {Pos}");
            sb.AppendLine($"Brush Type Name: {Brush_Type_Name}");
            sb.AppendLine($"Brush Describe: {Brush_Describe}");
            sb.AppendLine("Wave List:");
            foreach (Wave wave in WaveList)
            {
                sb.AppendLine(wave.ToString());
            }
            sb.AppendLine($"Shape Select: {Shape_Select}");
            if (Shape_Select == 2)
            {
                sb.AppendLine("Polygon List:");
                foreach (Vector2 point in PolygonList)
                {
                    sb.AppendLine(point.ToString());
                }
            }
            else if (Shape_Select == 3)
            {
                sb.AppendLine($"Radius: {Radius}");
            }

            return sb.ToString();
        }

    }
}
