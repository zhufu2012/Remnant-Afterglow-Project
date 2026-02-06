
using Godot;

namespace LaserBullet
{
	/// <summary>
	/// 激光基类，继承自 RayCast2D，提供激光的基本功能实现
	/// </summary>
	public partial class BaseLaser : RayCast2D
	{
		// 可配置参数
		/// <summary>
		/// 激光投射速度（单位：像素/秒）
		/// </summary>
		[Export] public float CastSpeed = 7000f;

		/// <summary>
		/// 激光最大长度（单位：像素）
		/// </summary>
		[Export] public float MaxLength = 1400f;

		/// <summary>
		/// 激光生长动画时间（单位：秒）
		/// </summary>
		[Export] public float GrowthTime = 0.1f;

		// 组件引用
		/// <summary>
		/// 激光线的填充视觉效果
		/// </summary>
		protected Line2D Fill;

		/// <summary>
		/// 动画补间控制器
		/// </summary>
		protected Tween Tween;

		/// <summary>
		/// 激光发射时的粒子效果
		/// </summary>
		protected GpuParticles2D CastingParticles;

		/// <summary>
		/// 激光碰撞时的粒子效果
		/// </summary>
		protected GpuParticles2D CollisionParticles;

		/// <summary>
		/// 激光束的粒子效果
		/// </summary>
		protected GpuParticles2D BeamParticles;

		/// <summary>
		/// 激光是否正在投射状态的私有字段
		/// </summary>
		private bool _isCasting;

		/// <summary>
		/// 激光的默认宽度
		/// </summary>
		private float _defaultLaserWidth = 2.0f;

		/// <summary>
		/// 激光是否正在投射状态的公共属性
		/// 当状态改变时会触发 OnCastingStateChanged 回调
		/// </summary>
		public bool IsCasting
		{
			get => _isCasting;
			set
			{
				// 如果状态未改变则直接返回
				if (_isCasting == value) return;
				_isCasting = value;
				// 调用状态改变处理方法
				OnCastingStateChanged(value);
			}
		}

		/// <summary>
		/// 节点准备就绪时调用
		/// </summary>
		public override void _Ready()
		{
			base._Ready();
			// 初始化组件引用
			InitializeComponents();
			// 设置默认状态
			SetupDefaults();
		}

		/// <summary>
		/// 初始化子节点组件引用
		/// </summary>
		protected virtual void InitializeComponents()
		{
			Fill = GetNode<Line2D>("FillLine2D");
			CastingParticles = GetNode<GpuParticles2D>("CastingParticles2D");
			CollisionParticles = GetNode<GpuParticles2D>("CollisionParticles2D");
			BeamParticles = GetNode<GpuParticles2D>("BeamParticles2D");

			// 保存默认宽度
			_defaultLaserWidth = Fill.Width;
			GD.Print($"Default laser width: {_defaultLaserWidth}");
		}

		/// <summary>
		/// 设置默认状态
		/// </summary>
		protected virtual void SetupDefaults()
		{
			// 默认不处理物理过程
			SetPhysicsProcess(false);
			// 初始化填充线的终点位置
			Fill.SetPointPosition(1, Vector2.Zero);
			// 确保初始宽度为0
			Fill.Width = 0;
		}

		/// <summary>
		/// 物理过程处理函数，每帧调用
		/// </summary>
		/// <param name="delta">帧时间间隔</param>
		public override void _PhysicsProcess(double delta)
		{
			base._PhysicsProcess(delta);
			// 更新激光位置
			UpdateLaserPosition((float)delta);
			// 投射激光束
			CastBeam();
		}

		/// <summary>
		/// 更新激光投射位置
		/// </summary>
		/// <param name="delta">帧时间间隔</param>
		protected virtual void UpdateLaserPosition(float delta)
		{
			// 按速度和时间更新目标位置，并限制最大长度
			TargetPosition = (TargetPosition + Vector2.Right * CastSpeed * delta).LimitLength(MaxLength);
		}

		/// <summary>
		/// 激光投射状态改变时的处理方法
		/// </summary>
		/// <param name="isCasting">新的投射状态</param>
		protected virtual void OnCastingStateChanged(bool isCasting)
		{
			GD.Print($"Laser casting state changed to: {isCasting}");
			if (isCasting)
			{
				// 激活激光
				ActivateLaser();
			}
			else
			{
				// 停用激光
				DeactivateLaser();
			}
			// 根据状态设置是否处理物理过程
			SetPhysicsProcess(isCasting);
			// 更新粒子效果发射状态
			UpdateParticlesEmission(isCasting);
		}

		/// <summary>
		/// 激活激光
		/// </summary>
		protected virtual void ActivateLaser()
		{
			GD.Print("Activating laser");

			// 重置目标位置
			TargetPosition = Vector2.Zero;
			// 重置填充线终点
			Fill.SetPointPosition(1, TargetPosition);

			// 执行出现动画
			Appear();
		}

		/// <summary>
		/// 停用激光
		/// </summary>
		protected virtual void DeactivateLaser()
		{
			GD.Print("Deactivating laser");

			// 停止碰撞粒子效果
			CollisionParticles.Emitting = false;

			// 执行消失动画
			Disappear();
		}

		/// <summary>
		/// 更新粒子效果发射状态
		/// </summary>
		/// <param name="isActive">是否激活状态</param>
		protected virtual void UpdateParticlesEmission(bool isActive)
		{
			GD.Print($"Updating particles emission: {isActive}");

			// 设置激光束和发射粒子效果的状态
			BeamParticles.Emitting = isActive;
			CastingParticles.Emitting = isActive;
		}

		/// <summary>
		/// 投射激光束
		/// </summary>
		protected virtual void CastBeam()
		{
			// 获取当前投射点
			Vector2 castPoint = TargetPosition;
			// 强制更新射线检测
			ForceRaycastUpdate();

			// 检查是否发生碰撞
			bool isColliding = IsColliding();
			// 设置碰撞粒子效果发射状态
			CollisionParticles.Emitting = isColliding;

			if (isColliding)
			{
				// 如果发生碰撞，获取本地坐标系下的碰撞点
				castPoint = ToLocal(GetCollisionPoint());
				// 更新碰撞效果
				UpdateCollisionEffects(GetCollisionNormal(), castPoint);
			}

			// 更新激光视觉效果
			UpdateLaserVisuals(castPoint);
		}

		/// <summary>
		/// 更新碰撞效果
		/// </summary>
		/// <param name="collisionNormal">碰撞法线</param>
		/// <param name="collisionPoint">碰撞点</param>
		protected virtual void UpdateCollisionEffects(Vector2 collisionNormal, Vector2 collisionPoint)
		{
			// 设置碰撞粒子效果的旋转角度
			CollisionParticles.GlobalRotation = collisionNormal.Angle();
			// 设置碰撞粒子效果的位置
			CollisionParticles.Position = collisionPoint;
		}

		/// <summary>
		/// 更新激光视觉效果
		/// </summary>
		/// <param name="endPoint">激光终点</param>
		protected virtual void UpdateLaserVisuals(Vector2 endPoint)
		{
			// 更新填充线终点位置
			Fill.SetPointPosition(1, endPoint);
			// 设置激光束粒子效果位置（在中点）
			BeamParticles.Position = endPoint * 0.5f;
			// 更新粒子发射区域大小
			var material = (ParticleProcessMaterial)BeamParticles.ProcessMaterial;
			if (material != null)
			{
				material.EmissionBoxExtents = new Vector3(endPoint.Length() * 0.5f, 0, 0);
			}
		}

		/// <summary>
		/// 激光出现动画
		/// </summary>
		protected virtual void Appear()
		{
			GD.Print("Starting appear animation");

			// 清理之前的动画
			CleanupTween();

			// 确保当前宽度为0
			Fill.Width = 0;

			// 创建新的动画补间
			Tween = CreateTween();
			Tween.SetParallel(true); // 允许并行执行多个属性动画

			// 添加宽度属性动画（从0到默认宽度）
			Tween.TweenProperty(Fill, "width", _defaultLaserWidth, GrowthTime * 2);

			GD.Print($"Appear animation: 0 -> {_defaultLaserWidth}");
		}

		/// <summary>
		/// 激光消失动画
		/// </summary>
		protected virtual void Disappear()
		{
			GD.Print("Starting disappear animation");

			// 清理之前的动画
			CleanupTween();

			// 创建新的动画补间
			Tween = CreateTween();
			Tween.SetParallel(true); // 允许并行执行多个属性动画

			// 添加宽度属性动画（从当前宽度到0）
			Tween.TweenProperty(Fill, "width", 0, GrowthTime);

			// 添加完成回调
			Tween.Finished += OnDisappearComplete;

			GD.Print($"Disappear animation: {Fill.Width} -> 0");
		}

		/// <summary>
		/// 消失动画完成回调
		/// </summary>
		private void OnDisappearComplete()
		{
			GD.Print("Disappear animation completed");

			// 确保宽度为0
			Fill.Width = 0;

			// 重置填充线终点
			Fill.SetPointPosition(1, Vector2.Zero);

			// 重置目标位置
			TargetPosition = Vector2.Zero;

			// 重置光束粒子位置
			BeamParticles.Position = Vector2.Zero;

			// 重置粒子发射区域
			var material = (ParticleProcessMaterial)BeamParticles.ProcessMaterial;
			if (material != null)
			{
				material.EmissionBoxExtents = new Vector3(0, 0, 0);
			}

			GD.Print("Laser fully reset after disappear");
		}

		/// <summary>
		/// 清理动画补间
		/// </summary>
		protected void CleanupTween()
		{
			// 如果存在正在运行的补间则停止它
			if (Tween != null && Tween.IsValid())
			{
				Tween.Kill();
				Tween = null;
			}
		}

		public override void _UnhandledInput(InputEvent @event)
		{
			base._UnhandledInput(@event);

			// 调试输出，确认事件触发
			if (@event.IsActionPressed("cam_a"))
			{
				GD.Print("cam_a pressed - starting laser");
				StartFiring();
			}
			else if (@event.IsActionReleased("cam_a"))
			{
				GD.Print("cam_a released - stopping laser");
				StopFiring();
			}
		}

		/// <summary>
		/// 开始发射激光
		/// </summary>
		public void StartFiring()
		{
			GD.Print("StartFiring called, current IsCasting: " + IsCasting);
			IsCasting = true;
		}

		/// <summary>
		/// 停止发射激光
		/// </summary>
		public void StopFiring()
		{
			GD.Print("StopFiring called, current IsCasting: " + IsCasting);
			IsCasting = false;
		}
	}
}
