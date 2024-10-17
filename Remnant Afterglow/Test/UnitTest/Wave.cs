using Remnant_Afterglow;
using System.Collections.Generic;

namespace Project_Core_Test
{
    ///波数 所有属性
	public class Wave
    {
        //波数
        public int wave_id;

        //波数名称
        public string Wave_Name;

        //波数描述
        public string Wave_Describe;

        //波数刷怪数据
        public Dictionary<int, int> Wave_Data = new Dictionary<int, int>();
        //波数刷新类型
        public int Wave_Type;
        //
        public int Wave_Time;
        public int Wave_After_Time;

        //===================================波数内数据====================================//
        public double SpaceFrameNumber = 0;//间隔帧数
        public bool is_flush_acc = false;//是否已刷新完
        //过去已刷新的怪物数量
        public Dictionary<int, int> HistoryWaveData = new Dictionary<int, int>();
        //===================================波数内数据====================================//
        public Wave(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex("cfg_Wave", id);
            wave_id = (int)dict["Wave_Id"];
            Wave_Name = (string)dict["Wave_Name"];
            Wave_Describe = (string)dict["Wave_Describe"];
            List<List<int>> list = (List<List<int>>)dict["Wave_Data"];
            for (int i = 0; i < list.Count; i++)
            {
                List<int> ememy = list[i];//这里是怪物类型和数量
                if (Wave_Data.ContainsKey(ememy[0]))
                {
                    Wave_Data[ememy[0]] = ememy[1] + Wave_Data[ememy[0]];
                }
                else
                {
                    Wave_Data[ememy[0]] = ememy[1];
                }
            }
            Wave_Type = (int)dict["Wave_Type"];
            Wave_Time = (int)dict["Wave_Time"];
            Wave_After_Time = (int)dict["Wave_After_Time"];
        }



    }
}