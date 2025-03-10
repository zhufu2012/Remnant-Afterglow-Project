using Godot;
using System;

public partial class CharacterBody2D2 : Godot.CharacterBody2D
{
	public NavigationAgent2D navigation;
    public TileMap tileMap;
    public Timer timer;

    public override void _Ready()
    {
		navigation = GetNode<NavigationAgent2D>("NavigationAgent2D");
        navigation.VelocityComputed += Navigation_VelocityComputed;
        tileMap = GetTree().Root.GetNode<TileMap>("地图导航层创建测试/TileMap");
        timer = GetNode<Timer>("Timer");
        //navigation.SetNavigationMap(tileMap.GetLayerNavigationMap(0));
        timer.Timeout += Timer_Timeout;
    }

    private void Timer_Timeout()
    {
        var MousePos = GetGlobalMousePosition();

        navigation.TargetPosition = MousePos;
    }

    private void Navigation_VelocityComputed(Vector2 safeVelocity)
    {
        Velocity = safeVelocity;
    }

    public override void _PhysicsProcess(double delta)
	{
        Vector2 next_pos = navigation.GetNextPathPosition();
        var newVelocity = GlobalPosition.DirectionTo(next_pos) * 50;
        Velocity = newVelocity;

		MoveAndSlide();
	}


}
