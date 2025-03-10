
using Godot;

namespace SteeringBehaviors
{
    public partial class PathComponent : ISteeringTarget
    {
        public Vector2 Position
        {
            get => Path.GetTargetNode()?.Target ?? Vector2.Zero;
            set => Path.AddNode(value);
        }

        public bool IsActual => Path.NodeCount > 0;

        public Path Path { get; set; }

        public PathComponent(Path path)
        {
            Path = path;
        }

        //public void Update()
        //{
       // //    if (Input.RightMouseButtonPressed)
        //        Path.AddNode(Input.MousePosition);
       // }
    }
}