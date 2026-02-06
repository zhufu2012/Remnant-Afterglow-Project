using GameLog;
using Godot;
using System.Collections.Generic;
namespace Project_Core_Test
{
	public partial class TowerTest : CharacterBody2D
	{
		//攻击范围-半径
		[Export] public float attack_range = 150;

		//显示攻击范围-半径
		[Export] public float show_attack_range = 150;

		//显示-可见程度
		[Export] public float show_vis = 255;
		//显示-可见程度
		[Export] public Color show_clolr = new Color();

		/// <summary>
		/// 转到速度
		/// </summary>
		[Export] float rot_speed = 5.0f;


		//进入攻击范围的可攻击目标
		public List<Node2D> targets = new List<Node2D>();

		/// <summary>
		/// 单位计时器列表
		/// 1，单位炮火冷却计时器
		/// </summary>
		public Timer[] timers = new Timer[1];

		//攻击范围
		public Area2D area;
		public Sprite2D sprite;

		//塔id
		public int tower_id = 0;

		public TowerTest()
		{ }

		public TowerTest(int tower_id)
		{

		}

		public override void _Ready()
		{
			area = GetNode<Area2D>("AttackRange");
			sprite = GetNode<Sprite2D>("Draw/射击塔");
			area.AreaEntered += OnAreaEntered;
			area.AreaExited += OnAreaExited;
			timers[0] = GetNode<Timer>("TimerList/Timer1");//冷却计时器



			base._Ready();
		}


		/// <summary>
		/// 检查进入的物体
		/// </summary>
		/// <param name="enter_area"></param>
		public void OnAreaEntered(Area2D enter_area)
		{
			if (!targets.Contains(enter_area))
			{
				targets.Add(enter_area);
			}
		}

		/// <summary>
		/// 检查出去的物体
		/// </summary>
		/// <param name="enter_area"></param>
		public void OnAreaExited(Area2D enter_area)
		{
			if (targets.Contains(enter_area))
			{
				targets.Remove(enter_area);
			}
		}



		public override void _PhysicsProcess(double delta)
		{
			QueueRedraw();

			if (targets.Count > 0)
			{
				Vector2 target_pos = targets[0].GlobalPosition;//获取第1个单位的全局位置
				Vector2 direction = target_pos - sprite.GlobalPosition;

				//var targetRotation = direction.Angle();
				float target_rot = direction.Angle();
				//sprite.GlobalPosition.DirectionTo(target_pos).Angle();
				sprite.Rotation = (float)Mathf.LerpAngle(sprite.Rotation, target_rot, rot_speed * delta);
				//Log.Print(target_rot);
			}
		}
	}
}
