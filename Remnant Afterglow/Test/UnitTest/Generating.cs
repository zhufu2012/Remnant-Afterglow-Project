using Godot;
using Remnant_Afterglow;
namespace Project_Core_Test
{
	public partial class Generating : Node2D
	{
		//生成敌人数量
		[Export] public int num = 10;
		//每隔多少秒一个
		[Export] public int de = 3;

		private double _accumulatedTime1;//逻辑更新计时
		private double _accumulatedTime2;//绘制更新计时
		private double maxLogicTime;

		//当前生成数量
		public int now_num = 0;
		//当前时间
		public int now_time = 0;

		public Node2D node;
		public override void _Ready()
		{
			maxLogicTime = 1.0 / 60;
			node = GetParent().GetNode<Node2D>("UnitList");
		}

		public override void _PhysicsProcess(double delta)
		{

			_accumulatedTime2 += delta;
			while (_accumulatedTime2 >= maxLogicTime)
			{
				now_time += 1;
				if (now_time >= de)
				{
					if (now_num < num)
					{
						Gen();
					}
					now_time = 0;
				}
				base._PhysicsProcess(delta);
				_accumulatedTime2 -= maxLogicTime;
			}
			base._PhysicsProcess(delta);
		}

		//生成一个敌人
		public void Gen()
		{
			//GetParent()
			CharacterBody2D characterBody2D = GD.Load<PackedScene>("res://Test/UnitTest/Unit.tscn").Instantiate<CharacterBody2D>();

			characterBody2D.Position = Position;
			node.AddChild(characterBody2D);
			now_num += 1;
		}
	}

}
