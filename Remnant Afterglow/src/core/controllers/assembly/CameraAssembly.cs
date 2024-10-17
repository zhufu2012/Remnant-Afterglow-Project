using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 相机组件
    /// </summary>
    public partial class CameraAssembly : CanvasLayer
    {
        public Dictionary<int, CameraAssemblyBase> cfgDict;
        //标签
        public Dictionary<int, Label> labels = new Dictionary<int, Label>();

        public Dictionary<int, Control> controls = new Dictionary<int, Control>();

        /// <summary>
        /// 组件噪声的额外数据
        /// </summary>
        public FastNoiseLite noise = new FastNoiseLite();
        public Vector2 Size = new Vector2(200, 200);
        /// <summary>
        /// 组件id列表
        /// </summary>
        public List<int> AssemblyidList;
        /// <summary>
        /// 根据组件id生成对应组件
        /// </summary>
        /// <param name="AssemblyidList"></param>
        public CameraAssembly(List<int> AssemblyidList)
        {
            this.AssemblyidList = AssemblyidList;
        }

        public override void _Ready()
        {
            InitView();
        }

        public void InitView()
        {
            cfgDict = new Dictionary<int, CameraAssemblyBase>();
            foreach (int id in AssemblyidList)
            {
                cfgDict[id] = new CameraAssemblyBase(id);
                switch (cfgDict[id].Type1)
                {
                    case 0://显示帧数
                        Label label = new Label();
                        label.Text = "" + Common.GetGameFrameNum();
                        label.Size = cfgDict[id].Size;
                        label.Position = cfgDict[id].Pos;
                        labels[id] = label;
                        label.Visible = cfgDict[id].IsDefineShow;
                        AddChild(label);
                        break;
                    case 1://噪声编辑器
                        Control control = (Control)GD.Load<PackedScene>("res://addons/fastnoiselite-configurator/fastnoiselite-configurator.tscn").Instantiate();
                        controls[id] = control;
                        controls[id].Visible = cfgDict[id].IsDefineShow;
                        AddChild(control);
                        break;
                    case 2://图片组 ParamPosLIst是后面图片的坐标
                        break;
                    case 3://常规按钮 需要处理具体类型
                        SetButton(id, cfgDict[id]);
                        break;
                    case 51:
                        ItemList itemList = new ItemList();
                        itemList.AddItem(cfgDict[id].ParamStr1);
                        itemList.Position = cfgDict[id].Pos;
                        itemList.Visible = cfgDict[id].IsDefineShow;
                        itemList.Size = cfgDict[id].Size;
                        controls[id] = itemList;
                        AddChild(itemList);
                        break;
                    default:
                        break;
                }
            }

        }

        public override void _PhysicsProcess(double delta)
        {
            foreach (var label in labels)
            {
                int id = label.Key;
                switch (cfgDict[id].Type1)
                {
                    case 0://显示帧数
                        label.Value.Text = "" + Common.GetGameFrameNum();
                        break;
                    default:
                        break;
                }
            }
            foreach (var control in controls)
            {
                int id = control.Key;
                switch (cfgDict[id].Type1)
                {
                    case 1://噪声编辑器
                        var data = new ConfigFile();
                        Error err = data.Load(PathConstant.GetPathUser(PathConstant.NOISE_SETTING_PATH_USER));
                        if (err != Error.Ok)
                        {
                            Log.Print("出现错误,错误码：" + err);
                            return;
                        }
                        noise = new FastNoiseLite();
                        foreach (String key in data.GetSectionKeys("Setting"))
                        {
                            // Fetch the data for each section.
                            var Value = data.GetValue("Setting", key);
                            noise.Set(key, Value);
                        }
                        Size.X = (float)data.GetValue("Param", "SizeX");
                        Size.Y = (float)data.GetValue("Param", "SizeY");
                        break;
                    default:
                        break;
                }
            }
        }

        /// <summary>
        /// 设置具体类型的参数
        /// </summary>
        /// <param name="control"></param>
        /// <param name="Type2"></param>
        /// <param name="Param"></param>
        /// <returns></returns>
        public void SetButton(int id, CameraAssemblyBase cfg)
        {
            Button button = new Button();
            button.Text = cfgDict[id].ParamStr1;
            button.Position = cfgDict[id].Pos;
            button.Visible = cfgDict[id].IsDefineShow;
            button.Size = cfgDict[id].Size;
            switch (cfg.Type2)
            {
                case 1:
                    DeployView deployView = new DeployView(cfg.Param1);
                    deployView.Visible = false;
                    AddChild(deployView);
                    button.ButtonDown += () =>
                    {
                        Log.Print("默认配置界面");
                        if (deployView.Visible)
                            deployView.Visible = false;
                        else
                            deployView.Visible = true;
                    };
                    break;
                case 2:
                    ScienceTreeView scienceTreeView = new ScienceTreeView(cfg.Param1);
                    scienceTreeView.Visible = false;
                    AddChild(scienceTreeView);
                    button.ButtonDown += () =>
                    {
                        Log.Print("科技树界面");
                        if (scienceTreeView.Visible)
                            scienceTreeView.Visible = false;
                        else
                            scienceTreeView.Visible = true;
                    };
                    break;
                case 3:
                    DatabaseView databaseView = new DatabaseView(cfg.Param1);
                    databaseView.Visible = false;
                    AddChild(databaseView);
                    button.ButtonDown += () =>
                    {
                        Log.Print("数据库界面");
                        if (databaseView.Visible)
                            databaseView.Visible = false;
                        else
                            databaseView.Visible = true;
                    };
                    break;
                default:
                    break;
            }
            controls[id] = button;
            AddChild(button, false, InternalMode.Front);
        }




    }
}
