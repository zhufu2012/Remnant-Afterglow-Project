using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    //存档创建页面
    public partial class CreateArchiveView : Control
    {
        public Button but_return_pre_view;//返回之前的界面
        public Button but_create_archive;//确定创建存档
        public LineEdit SaveLoadName;//存档名称
        public OptionButton opt_but_select_camp;//阵营选择
        public OptionButton opt_but_select_battle;//战役选择 -就是章节
        public OptionButton opt_but_select_diff;//难度选择

        /// <summary>
        /// 阵营列表
        /// </summary>
        public List<CampBase> camp_list = new List<CampBase>();
        /// <summary>
        /// 游戏难度列表
        /// </summary>
        public List<GameDiffBase> game_diff_list = new List<GameDiffBase>();
        /// <summary>
        /// 副本列表
        /// </summary>
        public List<ChapterBase> chapter_list = new List<ChapterBase>();

        public override void _Ready()
        {
            LoadData();
            LoadView();
        }
        /// <summary>
        /// 加载数据-阵营，战役，难度选择等数据
        /// </summary>
        public void LoadData()
        {
            List<CampBase> camplist_temp = ConfigCache.GetAllCampBase();
            List<GameDiffBase> gameDifflist_temp = ConfigCache.GetAllGameDiffBase();
            foreach (CampBase camp in camplist_temp)
            {
                if (camp.IsUser)
                    camp_list.Add(camp);
            }
            foreach (GameDiffBase game_diff in gameDifflist_temp)
            {
                if (game_diff.IsUser)
                    game_diff_list.Add(game_diff);
            }
            chapter_list = ConfigCache.GetAllChapterBase();
        }

        /// <summary>
        /// 加载UI
        /// </summary>
        public void LoadView()
        {
            but_return_pre_view = GetNode<Button>("Panel/Button");
            but_create_archive = GetNode<Button>("Panel/Button2");
            SaveLoadName = GetNode<LineEdit>("Panel/LineEdit");
            opt_but_select_camp = GetNode<OptionButton>("Panel/OptionButton");
            opt_but_select_battle = GetNode<OptionButton>("Panel/OptionButton2");
            opt_but_select_diff = GetNode<OptionButton>("Panel/OptionButton3");

            but_return_pre_view.ButtonDown += ReturnPreView;
            but_create_archive.ButtonDown += CreateArchive;
            foreach (CampBase camp in camp_list)
            {
                opt_but_select_camp.AddIconItem(camp.CampPng, camp.CampName, camp.CampId);
            }
            foreach (ChapterBase chapter in chapter_list)
            {
                opt_but_select_battle.AddIconItem(chapter.ChapterImage, chapter.ChapterName, chapter.ChapterId);

            }
            foreach (GameDiffBase game_diff in game_diff_list)
            {
                opt_but_select_diff.AddIconItem(game_diff.DiffPng, game_diff.DiffName, game_diff.DiffId);
            }
            if (camp_list.Count >= 1)
                opt_but_select_camp.Select(camp_list[0].CampId - 1);
            if (chapter_list.Count >= 1)
                opt_but_select_battle.Select(chapter_list[0].ChapterId - 1);
            if (game_diff_list.Count >= 1)
                opt_but_select_diff.Select(game_diff_list[0].DiffId - 1);
        }

        /// <summary>
        /// 返回之前的界面
        /// </summary>
        public void ReturnPreView()
        {
            Log.Print("返回上一个界面");
            GetTree().ChangeSceneToFile("res://scenes/ui/view/archive_view/SaveLoadView.tscn");
        }
        /// <summary>
        /// 创建存档
        /// </summary>
        public void CreateArchive()
        {
            Log.Print("创建存档");
            string saveload_name = SaveLoadName.Text;
            int select_camp = opt_but_select_camp.GetSelectedId();
            int select_battle = opt_but_select_battle.GetSelectedId();
            int select_diff = opt_but_select_diff.GetSelectedId();
            if (select_camp != -1 && select_battle != -1 && select_diff != -1)
            {
                GameError error = SaveLoadSystem.CreateSaveData(SaveLoadName.Text, select_camp, select_battle, select_diff);//创建存档
                if (error.error == 0)
                {
                    BigMapDraw bigMapDraw = (BigMapDraw)GD.Load<PackedScene>("res://scenes/map/BigMapView.tscn").Instantiate();
                    GlobalData.PutParam("chapter_id", select_battle);
                    GetTree().ChangeSceneToPacked(Common.GetPackedScene(bigMapDraw));
                }
                else
                {

                }

            }
            else
            {
                Log.Print("选择完才能创建存档");
            }

        }
    }
}