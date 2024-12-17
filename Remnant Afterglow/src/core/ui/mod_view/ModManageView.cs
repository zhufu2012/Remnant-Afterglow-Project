using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// mod管理器界面
    /// </summary>
    public partial class ModManageView : Control
    {
        #region 界面ui
        public Panel panel_1;
        public Panel panel_2;

        /// <summary>
        /// 返回按钮,点击返回主菜单
        /// </summary>
        public Button ReturnButton = new Button();
        /// <summary>
        /// 返回按钮,点击返回主菜单
        /// </summary>
        public Button ReturnButton2 = new Button();
        /// <summary>
        /// 点击刷新模组界面-（用于将刚激活的模组，移动到上面来）
        /// </summary>
        public Button FlushButton = new Button();
        /// <summary>
        /// 所有模组的框,当前加载的不在
        /// </summary>
        public VBoxContainer AllModCon = new VBoxContainer();
        /// <summary>
        /// 当前加载的模组框
        /// </summary>
        public VBoxContainer LoadModCon = new VBoxContainer();

        /// <summary>
        /// mod图片
        /// </summary>
        public HBoxContainer hBoxContainer = new HBoxContainer();


        /// <summary>
        /// mod的介绍
        /// </summary>
        public RichTextLabel mod_text;
        public Label mod_name;
        /// <summary>
        /// mod介绍富文本
        /// </summary>
        public RichTextLabel RichText;

        /// <summary>
        /// 单个mod项
        /// </summary>
        public List<SingleMod> singleMods = new List<SingleMod>();
        /// <summary>
        /// mod组 下拉框
        /// </summary>
        public OptionButton modGroupOption;
        /// <summary>
        /// 加载模组列表
        /// </summary>
        public Button loadModGroup;
        /// <summary>
        /// 保存模组列表
        /// </summary>
        public Button saveModGroup;
        /// <summary>
        /// 保存模组列表2
        /// </summary>
        public Button saveModGroup2;
        /// <summary>
        /// mod组名称
        /// </summary>
        public LineEdit lineEdit;
        public VBoxContainer SaveModCon = new VBoxContainer();
        #endregion




        /// <summary>
        /// 当前正在显示的mod信息
        /// </summary>
        public ModAllInfo NowShowModInfo;




        public List<ModGroup> modGroupList = new List<ModGroup>();



        public override void _Ready()
        {
            InitData();
            InitView();
        }

        /// <summary>
        /// 初始化界面数据
        /// </summary>
        public void InitData()
        {
        }

        /// <summary>
        /// 初始化界面数据
        /// </summary>
        public void InitView()
        {
            panel_1 = GetNode<Panel>("Panel");
            panel_2 = GetNode<Panel>("Panel2");
            ReturnButton = GetNode<Button>("Panel/ReturnView");
            ReturnButton2 = GetNode<Button>("Panel2/ReturnView");
            ReturnButton.ButtonDown += ReturnView;
            ReturnButton2.ButtonDown += ReturnView2;
            AllModCon = GetNode<VBoxContainer>("Panel/Panel/ScrollContainer/AllModCon");
            LoadModCon = GetNode<VBoxContainer>("Panel/Panel2/ScrollContainer/LoadModCon");
            SaveModCon = GetNode<VBoxContainer>("Panel2/Panel/ScrollContainer/VBoxContainer");
            mod_text = GetNode<RichTextLabel>("Panel/ModDataPanel/RichTextLabel");
            mod_name = GetNode<Label>("Panel/ModDataPanel/Label");
            hBoxContainer = GetNode<HBoxContainer>("Panel/ModDataPanel/ScrollContainer/HBoxContainer");
            modGroupOption = GetNode<OptionButton>("Panel/OptionButton");
            loadModGroup = GetNode<Button>("Panel/LoadModGroup");
            saveModGroup = GetNode<Button>("Panel/SaveModGroup");
            saveModGroup.ButtonDown += ShowSaveModGroupView;
            lineEdit = GetNode<LineEdit>("Panel2/LineEdit");
            saveModGroup2 = GetNode<Button>("Panel2/SaveModGroup");
            saveModGroup2.ButtonDown += SaveModGroup2;
            foreach (var item in ModLoadSystem.all_mod_list)
            {
                ModAllInfo modInfo = item.Value;
                if (!ModLoadSystem.load_mod_list.ContainsValue(modInfo))//在需要加载的mod列表中没有
                {
                    SingleMod singleMod = (SingleMod)GD.Load<PackedScene>("res://src/core/ui/mod_view/SingleMod.tscn").Instantiate();
                    singleMod.InitData(modInfo, false);
                    singleMod.ButtonDown += () =>
                        {
                            ShowModData(singleMod.modallInfo);//显示mod信息
                        };
                    AllModCon.AddChild(singleMod);
                    singleMods.Add(singleMod);
                }
                else
                {
                    SingleMod singleMod = (SingleMod)GD.Load<PackedScene>("res://src/core/ui/mod_view/SingleMod.tscn").Instantiate();
                    singleMod.InitData(modInfo, true);
                    singleMod.ButtonDown += () =>
                        {
                            ShowModData(singleMod.modallInfo);//显示mod信息
                        };
                    LoadModCon.AddChild(singleMod);
                    singleMods.Add(singleMod);
                }
            }
            FiushModGroup();
        }


        public override void _PhysicsProcess(double delta)
        {
            for (int i = 0; i < singleMods.Count; i++)//这里只是修改模组位置，不进行真正的加载
            {
                SingleMod singleMod = singleMods[i];
                if (singleMod.IsSelect && AllModCon.IsAncestorOf(singleMod))//被选中并且在全模组界面
                {
                    AllModCon.RemoveChild(singleMod);
                    LoadModCon.AddChild(singleMod);//添加到加载模组
                }
                if (!singleMod.IsSelect && LoadModCon.IsAncestorOf(singleMod))//不被选中并且在加载模组界面
                {
                    LoadModCon.RemoveChild(singleMod);
                    AllModCon.AddChild(singleMod);//移除模组
                }
            }
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event.IsActionPressed(KeyConstant.Input_Key_ESC))
            {
                ReturnView();
            }
        }

        /// <summary>
        /// 显示mod信息
        /// </summary>
        public void ShowModData(ModAllInfo modallInfo)
        {
            NowShowModInfo = modallInfo;
            mod_name.Text = modallInfo.modInfo.Name;
            mod_text.Text = modallInfo.modInfo.Description;
            Common.ClearChildren(hBoxContainer);//清除子节点
            foreach (string img_path in modallInfo.modInfo.ImgList)
            {
                Button img_button = new Button();
                img_button.Icon = GD.Load<Texture2D>(modallInfo.mod_path + img_path);
                hBoxContainer.AddChild(img_button);
            }
        }

        /// <summary>
        /// 显示mod组保存界面的函数
        /// </summary>
        public void ShowSaveModGroupView()
        {
            Common.ClearChildren(SaveModCon);
            panel_1.Visible = false;//隐藏界面1
            panel_2.Visible = true;//显示界面2
            for (int i = 0; i < singleMods.Count; i++)
            {
                if (LoadModCon.IsAncestorOf(singleMods[i]))//在加载模组界面
                {
                    SingleMod singleMod = (SingleMod)GD.Load<PackedScene>("res://src/core/ui/mod_view/SingleMod.tscn").Instantiate();
                    singleMod.InitData(singleMods[i].modallInfo, false);
                    SaveModCon.AddChild(singleMod);
                }
            }
        }


        /// <summary>
        /// 保存mod组数据
        /// </summary>
        public void SaveModGroup2()
        {
            string modGroupName = lineEdit.Text;
            List<ModAllInfo> temp_mod_all = new List<ModAllInfo>();
            for (int i = 0; i < singleMods.Count; i++)
            {
                if (LoadModCon.IsAncestorOf(singleMods[i]))//在加载模组界面
                {
                    temp_mod_all.Add(singleMods[i].modallInfo);
                }
            }
            ModGroup modGroup = new ModGroup(lineEdit.Text, temp_mod_all);
            ModGroup oldModGroup = ModGroup.FindModGroup(modGroupName, modGroupList);//老mod组
            if (oldModGroup == null)//不存在相同名称的mod组
            {

                modGroupList.Add(modGroup);
                ModGroup.SaveModGroupList(modGroupList);//将该分组保存到mod组数据中
            }
            else//存在相同名称的mod组-覆盖
            {
                modGroupList.Remove(oldModGroup);
                modGroupList.Add(modGroup);
                ModGroup.SaveModGroupList(modGroupList);//将该分组保存到mod组数据中
            }
            lineEdit.Text = "";
            Common.ClearChildren(SaveModCon);
            FiushModGroup();//刷新mod组下拉框
            ReturnView2();
        }

        /// <summary>
        /// 加载mod组数据
        /// </summary>
        public void LoadModGroup()
        {
            string modGroupName = modGroupOption.GetItemText(modGroupOption.Selected);
            ModGroup modGroup = ModGroup.FindModGroup(modGroupName, modGroupList);//选中mod组
            Common.ClearChildren(LoadModCon);//清除加载框中数据
            List<ModAllInfo> CanLoadModList = modGroup.GetCanModAllInfoList();//可以加载的mod列表

            for (int i = 0; i < singleMods.Count; i++)
            {
                SingleMod singleMod = singleMods[i];


                if (AllModCon.IsAncestorOf(singleMod))//在全模组界面
                {
                    AllModCon.RemoveChild(singleMod);
                    LoadModCon.AddChild(singleMod);
                }
                if (LoadModCon.IsAncestorOf(singleMod))//在加载模组界面
                {
                    LoadModCon.RemoveChild(singleMod);
                    AllModCon.AddChild(singleMod);//移除模组
                }
            }



        }

        /// <summary>
        /// 返回上一个界面
        /// </summary>
        public void ReturnView()
        {
            SceneManager.ChangeSceneBackward(this);
        }

        /// <summary>
        /// 隐藏界面2,显示界面1
        /// </summary>
        public void ReturnView2()
        {
            panel_1.Visible = true;
            panel_2.Visible = false;
        }


        /// <summary>
        /// 刷新mod组下拉框
        /// </summary>
        public void FiushModGroup()
        {
            modGroupOption.Clear();
            modGroupList = ModGroup.GetModGroupList();
            foreach (ModGroup modGroup in modGroupList)
            {
                modGroupOption.AddItem(modGroup.group_name);
            }
        }

    }
}