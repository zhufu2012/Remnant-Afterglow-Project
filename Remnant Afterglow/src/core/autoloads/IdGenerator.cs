using GameLog;
using Godot;
using System;
using System.Collections.Generic;
using System.Text.Encodings.Web;
using System.Text.Json;
using System.Text.Json.Serialization;
using System.Text.Unicode;
using System.Threading;
namespace Remnant_Afterglow
{
    public class IdData
    {
        [JsonInclude]
        public Dictionary<int, long> dict = new Dictionary<int, long>();

        public IdData(Dictionary<int, long> dict)
        {
            this.dict = dict;
        }
    }


    //id生成器-最多64种id的类型，每个id最大生成 2199023255551（2的41次方-1个）
    //2万亿，假设每秒这个id类型 生成1000个id，也能生成69年，足够了
    //最大需保存id类型是40，大于40的id类型不需要保存，随意使用，具体ID_TYPE_DATABASE_MAX
    public partial class IdGenerator : Node
    {

        double SaveIntervalTime = 0;//保存间隔-距离上一次保存的时间
        private static double SaveInterval = 0;//保存间隔 单位秒

        /// <summary>
        /// 是否可使用
        /// </summary>
        private static bool is_use = true;

        /// <summary>
        /// 这次保存间隔时间中是否有修改
        /// </summary>
        private static bool is_modify = false;

        /// <summary>
        /// 文件名
        /// </summary>
        private static string id_file_path = "res://data/IdData.json";
        /// <summary>
        /// 键值对
        /// </summary>
        private static Dictionary<int, long> dict = new Dictionary<int, long>();

        private static object dictLock = new object();

        static JsonSerializerOptions jsonSerializerOptions = new JsonSerializerOptions()
        {
            WriteIndented = true,
            IncludeFields = true,
            ReferenceHandler = ReferenceHandler.IgnoreCycles,
            Encoder = JavaScriptEncoder.Create(UnicodeRanges.BasicLatin, UnicodeRanges.CjkUnifiedIdeographs, UnicodeRanges.CjkSymbolsandPunctuation)
        };

        static IdGenerator()
        {
            SaveInterval = IdConstant.SaveIdGeneration;
            FileAccess Id_file = FileAccess.Open(id_file_path, FileAccess.ModeFlags.Read);
            //动画数据读取
            IdData iddata = JsonSerializer.Deserialize<IdData>(Id_file.GetAsText(), jsonSerializerOptions);
            dict = iddata.dict;
            Id_file.Close();
        }

        /// <summary>
        /// 物理帧
        /// </summary>
        /// <param name="delta"></param>
        public override void _PhysicsProcess(double delta)
        {
            SaveIntervalTime += delta;
            while (SaveIntervalTime >= SaveInterval)
            {
                SaveSchedule();
                SaveIntervalTime -= SaveInterval;
            }
        }

        //离开场景树
        public override void _ExitTree()
        {
            SaveSchedule();
            is_use = false;
        }

        /// <summary>
        /// 保存数据，其实就是各id类已使用id的最大值
        /// </summary>
        public void SaveSchedule()
        {
            if (is_modify)//间隔时间内是否有修改
            {
                Dictionary<int, long> dict_updata = new Dictionary<int, long>();
                for (int i = 1; i < IdConstant.ID_TYPE_DATABASE_MAX; i++)
                {
                    long new_value;
                    if (dict.TryGetValue(i, out new_value))//能查到，
                    {
                        dict_updata[i] = new_value;
                    }
                }
                if (dict_updata.Count > 0)
                {
                    SaveData(dict_updata);
                }
                is_modify = false;
            }
        }

        /// <summary>
        /// 获取id的最大值，对应id加1
        /// </summary>
        /// <param name="type"></param>
        /// <param name="define"></param>
        /// <returns></returns>
        public static long get_id_max(int type, long define)
        {
            long id = 0;
            lock (dictLock)
            {
                if (dict.ContainsKey(type))
                {
                    id = dict[type];
                    dict[type] = Interlocked.Increment(ref id);
                }
                else
                {
                    dict[type] = define;
                    id = define;
                }
            }
            return id;
        }


        /// <summary>
        /// 生成对应类型的唯一id,返回的是string类型的数据
        /// </summary>
        /// <param name="type">id类型</param>
        public static string Generate(int type)
        {
            if (is_use)
            {
                long id_max = get_id_max(type, 1);
                is_modify = true;
                return "" + makeObjectID(type, id_max);
            }
            else
            {
                throw new Exception("IdGenerator is no user");
            }
        }

        /// <summary>
        /// 获取id的类型
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static int GetType(string id)
        {
            long idLong = Convert.ToInt64(id);
            // 提取类型信息，右移41位后获取低6位
            return (int)((idLong >> 41) & 63);
        }

        /// <summary>
        /// 构造id
        /// </summary>
        /// <param name="type"></param>
        /// <param name="IdMax"></param>
        /// <returns></returns>
        private static long makeObjectID(int type, long IdMax)
        {
            // 类型信息放在高6位 (41-46位)，ID最大值放在低21位 (0-20位)
            return ((long)(type & 63) << 41) | (IdMax & 0x1FFFFFFFFFF);
        }

        /// <summary>
        /// 保存id使用数据
        /// </summary>
        /// <param name="dict_updata"></param>
        public void SaveData(Dictionary<int, long> dict_updata)
        {
            try
            {
                string data = JsonSerializer.Serialize(new IdData(dict_updata), jsonSerializerOptions);
                using var file = FileAccess.Open(id_file_path, FileAccess.ModeFlags.Write);
                file.StoreString(data);
                file.Close();
            }
            catch (Exception e)
            {
                Log.Error("保存id使用数据时出错！", e.StackTrace);
            }
        }
    }
}