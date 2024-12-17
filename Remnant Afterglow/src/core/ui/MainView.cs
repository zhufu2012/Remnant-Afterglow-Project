using GameLog;
using Godot;

namespace Remnant_Afterglow
{
    public partial class MainView : Control
    {
        public Button but_continue_game;//继续游戏
        public Button but_start_game;   //开始游戏
        public Button but_multi_player; //多人游戏
        public Button but_model;    //模组
        public Button but_setting;  //设置
        public Button but_quit; //退出
        public Button but_achievement;  //成就
        public Button but_thank;    //致谢
        public Button but_language; //语言

        public Label updatelog;


        public Sprite2D title_gear1;
        public Sprite2D title_gear2;
        public Sprite2D title_gear3;

        ///齿轮速度
        [Export]
        public float TurnSpeed = 1;

        public override void _Ready()
        {
            but_continue_game = GetNode<Button>("view/but_continue_game");
            but_start_game = GetNode<Button>("view/but_start_game");
            but_multi_player = GetNode<Button>("view/but_multi_player");
            but_model = GetNode<Button>("view/but_model");
            but_setting = GetNode<Button>("view/but_setting");
            but_quit = GetNode<Button>("view/but_quit");
            but_achievement = GetNode<Button>("view/but_achievement");
            but_thank = GetNode<Button>("view/but_thank");
            but_language = GetNode<Button>("view/but_language");
            updatelog = GetNode<Label>("Panel/ScrollContainer/updatelog");

            title_gear1 = GetNode<Sprite2D>("title/title_gear/title_gear1");
            title_gear2 = GetNode<Sprite2D>("title/title_gear/title_gear2");
            title_gear3 = GetNode<Sprite2D>("title/title_gear/title_gear3");

            but_continue_game.ButtonDown += ContinueGame;
            but_start_game.ButtonDown += StartGame;
            but_multi_player.ButtonDown += MultiPlayer;
            but_model.ButtonDown += Model;
            but_setting.ButtonDown += SetUp;
            but_quit.ButtonDown += Quit;
            but_achievement.ButtonDown += Achievement;
            but_thank.ButtonDown += Thank;
            but_language.ButtonDown += Language;
        }

        public override void _Process(double delta)
        {
            //齿轮运动
            title_gear1.RotationDegrees += TurnSpeed;
            title_gear2.RotationDegrees += TurnSpeed;
            title_gear3.RotationDegrees += TurnSpeed;
            base._Process(delta);
        }



        /// <summary>
        /// 继续游戏
        /// </summary>
        public void ContinueGame()
        {
            Log.Print("继续游戏");
            // GetTree().ChangeSceneToFile("res://src/core/map/BigMapView.tscn");
            SceneManager.ChangeSceneName("BigMapCopy", this);
        }

        /// <summary>
        /// 开始游戏-跳转到存档管理界面
        /// </summary>
        public void StartGame()
        {
            Log.Print("开始游戏");
            SceneManager.ChangeSceneName("SaveLoadView", this);
            //GetTree().ChangeSceneToFile("res://src/core/ui/view/archive_view/SaveLoadView.tscn");
        }

        /// <summary>
        /// 多人游戏
        /// </summary>
        public void MultiPlayer()
        {
            Log.Print("多人游戏");
        }

        /// <summary>
        /// 模组管理器
        /// </summary>
        public void Model()
        {
            SceneManager.ChangeSceneName("ModManageView", this);
        }

        /// <summary>
        /// 设置
        /// </summary>
        public void SetUp()
        {
            SceneManager.ChangeSceneName("SettingView", this);
        }

        /// <summary>
        /// 退出游戏
        /// </summary>
        public void Quit()
        {
            Log.Print("退出游戏");
            GetTree().Quit();
        }

        /// <summary>
        /// 成就
        /// </summary>
        public void Achievement()
        {
            Log.Print("成就");
        }

        /// <summary>
        /// 致谢
        /// </summary>
        public void Thank()
        {
            Log.Print("致谢");
        }

        /// <summary>
        /// 语言
        /// </summary>
        public void Language()
        {
            Log.Print("语言");
        }

    }
}
