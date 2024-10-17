using Godot;
using System.Collections.Generic;
namespace Project_Core_Test
{
    public partial class Test : Node2D
    {
        public Label label;
        public Node2D node2d;
        [Export]
        public int Num = 100;

        public List<Node2D> lists = new List<Node2D>();

        public override void _Ready()
        {
            label = GetNode<Label>("Label");
            node2d = GetNode<Node2D>("node");
            for (int i = 0; i < Num; i++)
            {
                Node2D node2 = GD.Load<PackedScene>("res://Test/Test/unit.tscn").Instantiate<Node2D>();
                node2d.AddChild(node2);
                lists.Add(node2);
            }
        }

        public override void _PhysicsProcess(double delta)
        {
            label.Text = "" + Engine.GetFramesPerSecond();
            base._PhysicsProcess(delta);
        }



    }
}