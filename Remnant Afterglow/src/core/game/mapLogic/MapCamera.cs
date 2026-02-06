using Godot;
namespace Remnant_Afterglow
{
	public partial class MapCamera : Camera2D
	{

		/// <summary>
		/// 相机默认配置
		/// </summary>
		public CameraBase cfgData;

		/// <summary>
		/// 当前是否可以操作
		/// </summary>
		public bool IsOp = false;
		/// <summary>
		/// 设置是否可操作
		/// </summary>
		/// <param name="op"></param>
		public void SetOp(bool op)
		{
			IsOp = op;
		}

		/// <summary>
		/// 按键-按键盘
		/// </summary>
		[Export] private bool is_key = true;

		/// <summary>
		/// 边缘-通过将鼠标移动到窗口边缘
		/// </summary>
		[Export] private bool is_edge = false;

		/// <summary>
		/// 滚轮-通过鼠标滚轮放大/缩小
		/// </summary>
		[Export] private bool is_wheel = true;
		/// <summary>
		/// 最小缩小限制
		/// </summary>
		[Export] private float zoom_min_limit = 0.5f;

		/// <summary>
		/// 最小限制
		/// </summary>
		[Export] private float zoom_max_limit = 2f;
		/// <summary>
		/// 新增拖拽相关变量
		/// </summary>
		[Export] private bool is_dragging = false;

		[Export] public Vector2 camera_zoom_speed = new Vector2(0.1f, 0.1f);


		//相机速度（像素/秒）。
		[Export] private int camera_speed = 450;
		//值，表示鼠标必须离窗口边缘（以像素为单位）有多近，移动视图。
		[Export] private int camera_margin = 50;

		/// <summary>
		/// 初始缩放值
		/// </summary>
		public Vector2 camera_zoom;

		/// <summary>
		/// 摄影机移动的矢量/秒。
		/// </summary>
		public Vector2 camera_movement = new Vector2(0, 0);
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

		
		private Label frame_number_label;

		/// <summary>
		/// 拖动起始相机位置（场景坐标）
		/// </summary>
		private Vector2 drag_start_camera_pos; 
		/// <summary>
		/// 拖动起始鼠标位置（场景坐标）
		/// </summary>
		private Vector2 drag_start_mouse_pos;  
		public override void _Ready()
		{
			camera_zoom = Zoom;
			frame_number_label = GetNode<Label>("CanvasLayer/frame_number_label");
		}

		public void InitData(int id)
		{
			cfgData = new CameraBase(id);
		}

		public override void _PhysicsProcess(double delta)
		{
			if(IsOp)
			{
				frame_number_label.Text = "" + Engine.GetFramesPerSecond();
				PhysicsProcess(delta);
			}
		}


		public override void _UnhandledInput(InputEvent @event)
		{
			if (IsOp)
			{
				UnhandledInput(@event);
			}
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
				camera_movement = Vector2.Zero;
				_prev_mouse_pos = GetLocalMousePosition();
		}

		/// <summary>
		/// 鼠标中建是否按下
		/// </summary>
		private bool _isMiddlePressed = false;
		public override void _Input(InputEvent @event)
		{
			if (@event is InputEventMouseButton mouseButton)
			{
				if(mouseButton.ButtonIndex == MouseButton.Middle)
				{
					_isMiddlePressed = true;
				}
			}

			if(_isMiddlePressed)
			{
				if (@event is InputEventMouseMotion events)
				{
					Position -= events.Relative;
				}
			}

		}


		public void UnhandledInput(InputEvent @event)
		{
			if (@event is InputEventMouseButton mouseButton)
			{

				if (is_wheel)
				{
					if (mouseButton.ButtonIndex == MouseButton.WheelDown &&
						camera_zoom.X - camera_zoom_speed.X >= zoom_min_limit &&
						camera_zoom.Y - camera_zoom_speed.Y >= zoom_min_limit)
					{
						camera_zoom -= camera_zoom_speed;
					}

					if (mouseButton.ButtonIndex == MouseButton.WheelUp &&
						camera_zoom.X + camera_zoom_speed.X <= zoom_max_limit &&
						camera_zoom.Y + camera_zoom_speed.Y <= zoom_max_limit)
					{
						camera_zoom += camera_zoom_speed;
						//SetZoom(camera_zoom);

					}
					Zoom = camera_zoom;
				}
				if(mouseButton.ButtonIndex == MouseButton.Middle)//中键点击
					_isMiddlePressed = mouseButton.Pressed;
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
		}
	}
}
