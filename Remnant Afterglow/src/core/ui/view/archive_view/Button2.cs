using Godot;

public partial class HoverTextureButton : TextureButton
{
	private AnimationPlayer _animationPlayer;
	private bool _isHovered = false;

	public override void _Ready()
	{
		// 获取 AnimationPlayer 节点
		_animationPlayer = GetNode<AnimationPlayer>("AnimationPlayer");
		
		// 连接信号
		MouseEntered += OnMouseEntered;
		MouseExited += OnMouseExited;
		
		// 确保动画播放器连接了完成信号
		if (!_animationPlayer.IsConnected("animation_finished", new Callable(this, nameof(OnAnimationFinished))))
		{
			_animationPlayer.Connect("animation_finished", new Callable(this, nameof(OnAnimationFinished)));
		}
	}

	private void OnMouseEntered()
	{
		GD.Print("鼠标进入 - 开始正向播放");
		_isHovered = true;
		
		// 停止当前动画
		_animationPlayer.Stop();
		
		// 确保从第一帧开始
		_animationPlayer.Seek(0.0);
		
		// 正向播放动画
		_animationPlayer.Play("hover");
		_animationPlayer.SpeedScale = 1.0f;
	}

	private void OnMouseExited()
	{
		GD.Print("鼠标离开 - 准备倒放");
		_isHovered = false;
		
		// 如果动画正在播放，让它继续播放直到完成
		// 我们将在动画完成时检查是否需要倒放
		if (_animationPlayer.IsPlaying())
		{
			GD.Print("动画正在播放，等待完成后倒放");
		}
		else
		{
			GD.Print("动画未播放，立即开始倒放");
			StartReverseAnimation();
		}
	}

	private void StartReverseAnimation()
	{
		GD.Print("开始倒放动画");
		
		// 获取当前动画位置
		double currentTime = _animationPlayer.CurrentAnimationPosition;
		GD.Print("当前动画位置: ", currentTime);
		
		// 如果已经在第一帧，不需要倒放
		if (currentTime <= 0.01)
		{
			GD.Print("已在第一帧，无需倒放");
			return;
		}
		
		// 从当前位置倒放
		_animationPlayer.Play("hover");
		_animationPlayer.Seek(currentTime);
		_animationPlayer.SpeedScale = -1.0f;
	}

	private void OnAnimationFinished(StringName animName)
	{
		GD.Print("动画完成: ", animName, " - 速度比例: ", _animationPlayer.SpeedScale);
		
		if (animName == "hover")
		{
			// 如果动画完成且鼠标不在按钮上，开始倒放
			if (!_isHovered && _animationPlayer.SpeedScale > 0)
			{
				GD.Print("正向播放完成，开始倒放");
				StartReverseAnimation();
			}
			// 如果倒放完成，确保回到第一帧
			else if (_animationPlayer.SpeedScale < 0)
			{
				GD.Print("倒放完成，重置到第一帧");
				_animationPlayer.Seek(0.0);
			}
		}
	}
}
