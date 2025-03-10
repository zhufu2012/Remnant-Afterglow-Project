﻿using GameLog;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public partial class GameCamera : Camera2D
    {
        /// <summary>
        /// 相机默认配置
        /// </summary>
        public CameraBase cfgData;
        /// <summary>
        /// 组件父节点
        /// </summary>
        //public CameraAssembly canvasLayer;


        /// <summary>
        /// 设置界面
        /// </summary>
        public CanvasLayer canvasLayer2 = new CanvasLayer();

        /// <summary>
        /// 返回相关按钮
        /// </summary>
        public Panel panel = new Panel();

        public Button ContinueBut = new Button();
        public Button button1 = new Button();
        public Button button2 = new Button();



        #region 相机相关数据
        //按键-按键盘
        [Export] private bool is_key = true;

        //边缘-通过将鼠标移动到窗口边缘
        [Export] private bool is_edge = false;
        /// <summary>
        /// 能否放大
        /// </summary>
        private bool IsZoomIn = false;
        /// <summary>
        /// 能否缩小
        /// </summary>
        private bool IsZoomOut = false;

        /// <summary>
        /// 最小缩小限制
        /// </summary>
        [Export] private float zoom_min_limit = 0.5f;

        /// <summary>
        /// 最大限制
        /// </summary>
        [Export] private float zoom_max_limit = 2f;
        /// <summary>
        /// 初始缩放值
        /// </summary>
        public Vector2 camera_zoom;


        /// <summary>
        /// 上一个鼠标位置用于计算鼠标移动的增量。
        /// </summary>
        public Vector2 _prev_mouse_pos;

        /// <summary>
        /// 鼠标右键过去或现在被按下
        /// </summary>
        public bool is_press = false;
        /// <summary>
        /// 按以下键移动相机：左、上、右、下。
        /// </summary>
        private bool[] key = new bool[4] { false, false, false, false };


        /// <summary>
        /// 相机速度（像素/秒）。
        /// </summary>
        private int camera_speed = 450;
        /// <summary>
        /// 相机边缘滚动速度（像素/秒）。
        /// </summary>
        private int edge_camera_speed = 450;
        /// <summary>
        /// 值，表示鼠标必须离窗口边缘（以像素为单位）有多近，移动视图。
        /// </summary>
        private int camera_margin = 50;
        /// <summary>
        /// 摄影机移动的矢量/秒。
        /// </summary>
        public Vector2 camera_movement = new Vector2(0, 0);

        [Export] public Vector2 camera_zoom_speed = new Vector2(0.1f, 0.1f);
        #endregion

        public GameCamera()
        {
            cfgData = new CameraBase(ConfigCache.GetGlobal_Int("MapDefineCameraId"));//地图默认相机id
        }
        public GameCamera(int id)
        {
            cfgData = new CameraBase(id);
        }

        public void InitData()
        {
            camera_speed = cfgData.MoveSpeed;//设置相机默认速度
            is_edge = cfgData.IsEdgeScroll;
            IsZoomIn = cfgData.IsZoomIn;
            IsZoomOut = cfgData.IsZoomOut;
            zoom_max_limit = cfgData.MaxZoom;
            zoom_min_limit = cfgData.MinZoom;
            camera_zoom = cfgData.StartZoom;
            camera_zoom_speed = cfgData.ZoomIncrement;
            is_key = cfgData.IsMove;
            Position = cfgData.StartPos;
            camera_margin = cfgData.EdgeScrollMargin;
            edge_camera_speed = cfgData.BaseEdgeScrollSpeed;
            Input.SetCustomMouseCursor(cfgData.CursorPoint);
            Input.SetCustomMouseCursor(cfgData.CursorGrab);
        }

        public void InitView()
        {
            //AddChild(canvasLayer);

            panel.SetAnchorsPreset(Control.LayoutPreset.FullRect);
            panel.Size = new Vector2(GameConstant.WindowSizeX, GameConstant.WindowSizeY);
            ContinueBut.Text = "继续";
            ContinueBut.Size = ViewConstant.Camera_Button_Size;
            ContinueBut.Position = new Vector2(30, 20);
            ContinueBut.ButtonDown += ContinueGame;
            button1.Text = "设置";
            button1.Size = ViewConstant.Camera_Button_Size;
            button1.Position = new Vector2(420, 125);
            button1.ButtonDown += Button1Game;
            button2.Text = "保存并退出到主界面";
            button2.Size = ViewConstant.Camera_Button_Size;
            button2.Position = new Vector2(420, 220);
            button2.ButtonDown += Button2Game;
            panel.AddChild(ContinueBut);
            panel.AddChild(button1);
            panel.AddChild(button2);
            canvasLayer2.AddChild(panel);
            canvasLayer2.Visible = false;
            AddChild(canvasLayer2);
        }

        public override void _Ready()
        {
            InitData();
            InitView();
            camera_zoom = Zoom;
        }

        public override void _PhysicsProcess(double delta)
        {
            PhysicsProcess(delta);
            base._PhysicsProcess(delta);
        }

        public override void _UnhandledInput(InputEvent @event)
        {
            if (@event is InputEventMouseButton mouseButton)
            {
                if (IsZoomOut && mouseButton.ButtonIndex == MouseButton.WheelDown &&
                    camera_zoom.X - camera_zoom_speed.X >= zoom_min_limit &&
                    camera_zoom.Y - camera_zoom_speed.Y >= zoom_min_limit)
                {
                    camera_zoom -= camera_zoom_speed;
                }
                if (IsZoomIn && mouseButton.ButtonIndex == MouseButton.WheelUp &&
                    camera_zoom.X + camera_zoom_speed.X <= zoom_max_limit &&
                    camera_zoom.Y + camera_zoom_speed.Y <= zoom_max_limit)
                {
                    camera_zoom += camera_zoom_speed;
                }
                if (IsZoomOut || IsZoomIn)
                    Zoom = camera_zoom;
            }
            if (@event.IsActionPressed(KeyConstant.Input_Key_A))
                key[0] = true;
            if (@event.IsActionPressed(KeyConstant.Input_Key_W))
                key[1] = true;
            if (@event.IsActionPressed(KeyConstant.Input_Key_D))
                key[2] = true;
            if (@event.IsActionPressed(KeyConstant.Input_Key_S))
                key[3] = true;
            if (@event.IsActionReleased(KeyConstant.Input_Key_A))
                key[0] = false;
            if (@event.IsActionReleased(KeyConstant.Input_Key_W))
                key[1] = false;
            if (@event.IsActionReleased(KeyConstant.Input_Key_D))
                key[2] = false;
            if (@event.IsActionReleased(KeyConstant.Input_Key_S))
                key[3] = false;
            if (@event.IsActionPressed(KeyConstant.Input_Key_ESC))
            {
               // if (canvasLayer.Visible)
                //{
               //     canvasLayer.Visible = false;
               //     canvasLayer2.Visible = true;
               // }
                //else
               // {
               //     canvasLayer.Visible = true;
               //     canvasLayer2.Visible = false;
               // }
            }
            base._UnhandledInput(@event);
        }


        #region 处理函数
        /// <summary>
        /// 继续
        /// </summary>
        public void ContinueGame()
        {
            Log.Print("继续");
        }

        /// <summary>
        /// 设置
        /// </summary>
        public void Button1Game()
        {
            Log.Print("设置");
        }


        /// <summary>
        /// 保存并退出到主界面
        /// </summary>
        public void Button2Game()
        {
            Log.Print("保存并退出到主界面");
        }




        /// <summary>
        /// 物理帧处理
        /// </summary>
        /// <param name="delta"></param>
        public void PhysicsProcess(double delta)
        {
            if (is_key)//按InputMap（ui_left/top/right/bottom）中定义的键移动相机。
            {
                if (key[0])
                    camera_movement.X -= (float)(camera_speed * delta);
                if (key[1])
                    camera_movement.Y -= (float)(camera_speed * delta);
                if (key[2])
                    camera_movement.X += (float)(camera_speed * delta);
                if (key[3])
                    camera_movement.Y += (float)(camera_speed * delta);
            }
            if (is_edge)//当相机位于边缘（由camera_margin定义）时，用鼠标移动相机。
            {

                Rect2 rec = GetViewport().GetVisibleRect();////注释//-这里类型
                Vector2 v = GetLocalMousePosition() + rec.Size / 2;

                if (rec.Size.X - v.X <= camera_margin)
                    camera_movement.X += (float)(edge_camera_speed * delta);
                if (v.X <= camera_margin)
                    camera_movement.X -= (float)(edge_camera_speed * delta);
                if (rec.Size.Y - v.Y <= camera_margin)
                    camera_movement.Y += (float)(edge_camera_speed * delta);
                if (v.Y <= camera_margin)
                    camera_movement.Y -= (float)(edge_camera_speed * delta);
            }
            //更新相机的位置。
            Position += camera_movement * Zoom;
            //将相机移动设置为零，更新旧的鼠标位置。
            camera_movement = new Vector2(0, 0);
            _prev_mouse_pos = GetLocalMousePosition();
        }

        #endregion
    }
}
