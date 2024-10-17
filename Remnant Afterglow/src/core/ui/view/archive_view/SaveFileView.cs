using GameLog;
using Godot;
using System;
namespace Remnant_Afterglow
{
    public partial class SaveFileView : Panel
    {
        public Label lab_SaveName;//SaveName  存档名称
        public Label lab_GameTime;//GameTime  最后保存时间
        public Sprite2D camp_sprite;//Sprite2D  阵营图标
        public Sprite2D battle_sprite;//Sprite2D  战役图标
        public Label lab_science_degree;//Button 科技完成度
        public Label lab_battle_degree;//Button2  战役完成度
        public Control control;

        private string saveName;//存档名称
        private string gameTime;//最后更新时间
        private Texture2D campTexture;
        private Texture2D battleTexture;
        private string scienceDegree;
        private string battleDegree;
        public SaveFile file;
        public bool isRange = false;

        public void SetData(SaveFile file)
        {
            this.file = file;
            this.saveName = file.file_name;
            this.gameTime = "" + file.Latest_Time;
            CampBase campBase = ConfigCache.GetCampBase(file.camp_id);
            ChapterBase chapterBase = ConfigCache.GetChapterBase(file.chapter_id);

            this.campTexture = campBase.CampPng;
            this.battleTexture = chapterBase.ChapterImage;
            this.scienceDegree = "";
            this.battleDegree = "";
        }

        public override void _Ready()
        {
            FocusMode = FocusModeEnum.Click;
            lab_SaveName = GetNode<Label>("saveName");
            lab_GameTime = GetNode<Label>("gameTime");
            camp_sprite = GetNode<Sprite2D>("camp_sprite");
            battle_sprite = GetNode<Sprite2D>("battle_sprite");
            lab_science_degree = GetNode<Label>("science_degree");
            lab_battle_degree = GetNode<Label>("battle_degree");
            control = GetNode<Control>("Control");
            if (lab_SaveName != null)
                lab_SaveName.Text = saveName ?? "";
            if (lab_GameTime != null)
                lab_GameTime.Text = gameTime ?? "";
            if (camp_sprite != null && campTexture != null)
                camp_sprite.Texture = campTexture;
            if (battle_sprite != null && battleTexture != null)
                battle_sprite.Texture = battleTexture;
            if (lab_science_degree != null)
                lab_science_degree.Text = scienceDegree ?? "";
            if (lab_battle_degree != null)
                lab_battle_degree.Text = battleDegree ?? "";
            MouseEntered += MouseEnteredN;
            MouseExited += MouseExitedN;
        }

        /// <summary>
        /// 鼠标进入区域
        /// </summary>
        public void MouseEnteredN()
        {
            isRange = true;
        }
        /// <summary>
        /// 鼠标离开区域
        /// </summary>
        public void MouseExitedN()
        {
            isRange = false;
        }

        public override void _Process(double delta)
        {
            control.Visible = HasFocus();
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (isRange)// 检查鼠标是否在节点上
            {
                if (@event is InputEventMouse mouseEvent)// 检查是否是鼠标事件
                {
                    if (mouseEvent is InputEventMouseButton mb && mb.ButtonIndex == MouseButton.Left && mb.Pressed)
                    {
                        //control.Visible = HasFocus();
                        GrabFocus();
                    }
                }
            }
        }
    }
}