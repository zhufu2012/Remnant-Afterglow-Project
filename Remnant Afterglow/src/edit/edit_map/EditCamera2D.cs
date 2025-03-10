using GameLog;
using Godot;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 编辑器相机
    /// </summary>
    public partial class EditCamera2D : Camera2D
    {
        //按键-按键盘
        [Export] private bool is_key = true;

        //滚轮-通过鼠标滚轮放大/缩小
        [Export] private bool is_wheel = true;
        //最小缩小限制
        [Export] private float zoom_min_limit = 0.1f;

        //最大限制
        [Export] private float zoom_max_limit = 4f;

        //初始缩放值
        public Vector2 camera_zoom;
        [Export] public Vector2 camera_zoom_speed = new Vector2(0.02f, 0.02f);


        //相机速度（像素/秒）。
        [Export] private int camera_speed = 800;
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

        public override void _Ready()
        {
            camera_zoom = Zoom;
            base._Ready();
        }

        public override void _PhysicsProcess(double delta)
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
           
            //更新相机的位置。
            Position += camera_movement;
            //将相机移动设置为零，更新旧的鼠标位置。
            camera_movement = new Vector2(0, 0);
            _prev_mouse_pos = GetLocalMousePosition();
            base._Process(delta);
        }
        

        public override void _UnhandledInput(InputEvent @event)
        {
            base._UnhandledInput(@event);
            if (@event.IsAction(EditConstant.Input_Key_CtrlBrush1,true))
            {
                EditMapView.Instance.toolContainer.SubBrushSize(1);
                return;
            }
            if (@event.IsAction(EditConstant.Input_Key_CtrlBrush2,true))
            {
                EditMapView.Instance.toolContainer.AddBrushSize(1);
                return;
            }
            if (@event is InputEventMouseButton mouseButton)
            {
                var mouse = GetViewport().GetMousePosition();
                if (is_wheel&&mouse.X < 1420)
                {
                    if (mouseButton.ButtonIndex == MouseButton.WheelDown &&
                        camera_zoom.X - camera_zoom_speed.X > zoom_min_limit &&
                        camera_zoom.Y - camera_zoom_speed.Y > zoom_min_limit)
                    {
                        camera_zoom -= camera_zoom_speed;
                        //SetZoom(camera_zoom);//祝福注释
                        
                    }
                    if (mouseButton.ButtonIndex == MouseButton.WheelUp &&
                        camera_zoom.X + camera_zoom_speed.X < zoom_max_limit &&
                        camera_zoom.Y + camera_zoom_speed.Y < zoom_max_limit)
                    {
                        camera_zoom += camera_zoom_speed;
                        //SetZoom(camera_zoom);
                    }
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

