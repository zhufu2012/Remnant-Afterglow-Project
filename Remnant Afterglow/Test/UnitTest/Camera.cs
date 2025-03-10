﻿using Godot;
namespace Project_Core_Test
{
    public partial class Camera : Camera2D
    {

        //按键-按键盘
        [Export] private bool is_key = true;

        //边缘-通过将鼠标移动到窗口边缘
        [Export] private bool is_edge = false;

        //滚轮-通过鼠标滚轮放大/缩小
        [Export] private bool is_wheel = true;
        //最小缩小限制
        [Export] private float zoom_min_limit = 2f;

        //最小限制
        [Export] private float zoom_max_limit = 0.5f;

        //初始缩放值
        public Vector2 camera_zoom;
        [Export] public Vector2 camera_zoom_speed = new Vector2(0.1f, 0.1f);


        //相机速度（像素/秒）。
        [Export] private int camera_speed = 450;
        //值，表示鼠标必须离窗口边缘（以像素为单位）有多近，移动视图。
        [Export] private int camera_margin = 50;

        //摄影机移动的矢量/秒。
        public Vector2 camera_movement = new Vector2(0, 0);
        //上一个鼠标位置用于计算鼠标移动的增量。
        public Vector2 _prev_mouse_pos;

        //鼠标右键过去或现在被按下
        public bool is_press = false;
        //按以下键移动相机：左、上、右、下。
        private bool[] key = new bool[4] { false, false, false, false };

        private Label frame_number_label;
        public override void _Ready()
        {
            frame_number_label = GetNode<Label>("Label");
            //祝福注释
            camera_zoom = Zoom;
        }

        public override void _PhysicsProcess(double delta)
        {
            frame_number_label.Text = "" + Engine.GetFramesPerSecond();

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

                Rect2 rec = GetViewport().GetVisibleRect();//祝福注释-这里类型
                Vector2 v = GetLocalMousePosition() + rec.Size / 2;

                if (rec.Size.X - v.X <= camera_margin)
                    camera_movement.X += (float)(camera_speed * delta);
                if (v.X <= camera_margin)
                    camera_movement.X -= (float)(camera_speed * delta);
                if (rec.Size.Y - v.Y <= camera_margin)
                    camera_movement.Y += (float)(camera_speed * delta);
                if (v.Y <= camera_margin)
                    camera_movement.Y -= (float)(camera_speed * delta);
            }

            //更新相机的位置。
            Position += camera_movement * Zoom;
            //将相机移动设置为零，更新旧的鼠标位置。
            camera_movement = new Vector2(0, 0);
            _prev_mouse_pos = GetLocalMousePosition();
            base._Process(delta);
        }


        public override void _UnhandledInput(InputEvent @event)
        {
            base._UnhandledInput(@event);
            if (@event is InputEventMouseButton mouseButton)
            {

                if (is_wheel)
                {
                    if (mouseButton.ButtonIndex == MouseButton.WheelDown &&
                        camera_zoom.X - camera_zoom_speed.X > zoom_min_limit &&
                        camera_zoom.Y - camera_zoom_speed.Y > zoom_min_limit)
                    {
                        camera_zoom -= camera_zoom_speed;

                        //SetZoom(camera_zoom);//祝福注释
                    }
                    Zoom = camera_zoom;
                    if (mouseButton.ButtonIndex == MouseButton.WheelUp &&
                        camera_zoom.X + camera_zoom_speed.X < zoom_max_limit &&
                        camera_zoom.Y + camera_zoom_speed.Y < zoom_max_limit)
                    {

                        camera_zoom += camera_zoom_speed;
                        //SetZoom(camera_zoom);

                    }
                    /*
                    if (mouseButton.ButtonIndex == MouseButton.WheelDown &&
                        camera_zoom.X - camera_zoom_speed.X < zoom_min_limit &&
                        camera_zoom.Y - camera_zoom_speed.Y < zoom_min_limit)
                    {

                        camera_zoom -= camera_zoom_speed;
                        //SetZoom(camera_zoom);

                    }*/

                    //zoom_max_limit

                    Zoom = camera_zoom;
                }
            }

            if (@event.IsActionPressed("cam_a"))
                key[0] = true;
            if (@event.IsActionPressed("cam_w"))
                key[1] = true;
            if (@event.IsActionPressed("cam_d"))
                key[2] = true;
            if (@event.IsActionPressed("cam_s"))
                key[3] = true;
            if (@event.IsActionReleased("cam_a"))
                key[0] = false;
            if (@event.IsActionReleased("cam_w"))
                key[1] = false;
            if (@event.IsActionReleased("cam_d"))
                key[2] = false;
            if (@event.IsActionReleased("cam_s"))
                key[3] = false;
        }
    }
}

