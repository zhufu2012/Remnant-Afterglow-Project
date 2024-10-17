namespace Remnant_Afterglow
{
    /// <summary>
    /// 与存档界面UI配对的数据
    /// </summary>
    public class SaveFile
    {
        public string file_name;//存档名称
        public int camp_id;//阵营
        public int chapter_id;//战役id
        public int diff_id;//难度id
        //最后保存的时间
        public long Latest_Time;
        //最后保存时，游戏的版本
        public int version;


        public SaveFile()
        {
            Latest_Time = Common.GetS();
            file_name = "save01";
            camp_id = 1;
            chapter_id = 1;
            diff_id = 1;
            version = GameConstant.game_version;
        }
        public SaveFile(string file_name, long latest_Time, int camp_id, int chapter_id, int diff_id)
        {
            this.file_name = file_name;
            Latest_Time = latest_Time;
            this.camp_id = camp_id;
            this.chapter_id = chapter_id;
            this.diff_id = diff_id;
            version = GameConstant.game_version;
        }

        public override string ToString()
        {
            return $"file_name:{file_name},Latest_Time:{Latest_Time}";
        }
    }

}