using Godot;

namespace Project_Core_Test
{
    public partial class BuildTest : Node2D
    {
        // Called when the node enters the scene tree for the first time.
        public override void _Ready()
        {
        }

        public override void _PhysicsProcess(double delta)
        {
            Position = GetGlobalMousePosition();
            base._PhysicsProcess(delta);
        }

    }

}

