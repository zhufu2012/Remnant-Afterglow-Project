using Godot;
using Remnant_Afterglow;
using System.Collections.Generic;
namespace Project_Core_Test
{
    public partial class Units : CharacterBody2D
    {
        [Export] public NavigationAgent2D agent;
        //兵种id
        public int Enemy_Id = 0;
        //兵种名称
        public string Enemy_Name;
        //兵种描述1
        public string Enemy_Describe1;
        //兵种描述2
        public string Enemy_Describe2;
        //血量
        public int Blood = 100;

        //速度
        public float Speed = 50;

        //上一个可导航点
        public Vector2 LastPoint;

        public Units() { }

        public void IniData(int id)
        {
            Dictionary<string, object> dict = ConfigLoadSystem.GetCfgIndex("cfg_Enemy", id);
            Enemy_Id = (int)dict["Enemy_Id"];
            Enemy_Name = (string)dict["Enemy_Name"];
            Enemy_Describe1 = (string)dict["Enemy_Describe1"];
            Enemy_Describe2 = (string)dict["Enemy_Describe2"];
            Blood = (int)dict["Blood"];
            Scale = (Vector2)dict["Scale"];
            Speed = (int)dict["Speed"];
        }



        //目标
        public Node2D build_node;//
        public Timer timer;

        public override void _Ready()
        {
            build_node = GetParent().GetParent().GetNode<Node2D>("BuildTest/Build");
            timer = GetNode<Timer>("Navigate/Timer");
            agent = GetNode<NavigationAgent2D>("Navigate/NavigationAgent2D");

            timer.Timeout += TimeOut;
            base._Ready();
        }


        public override void _PhysicsProcess(double delta)
        {

            Vector2 now_pos = ToLocal(agent.GetNextPathPosition()).Normalized();
            Velocity = Speed * now_pos;
            MoveAndSlide();
        }

        public void TimeOut()
        {
            //先判断目标是否在可导航位置，在可导航位置就更新，不在可导航位置就还是使用之前的导航位置
            agent.TargetPosition = build_node.Position;
        }

    }

}