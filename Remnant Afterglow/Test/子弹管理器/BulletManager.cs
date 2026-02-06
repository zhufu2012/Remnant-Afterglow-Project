using GameLog;
using Godot;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow.Project_Core_Test
{
	/// <summary>
	/// 子弹管理器
	/// </summary>
	public partial class BulletManager : Node2D
	{
		// 子弹物理属性
		private struct Bullet
		{
			public Rid BodyRid;
			public Transform2D Transform;
			public Vector2 Velocity; // 新增速度存储
		}

		// 物理层定义（按项目实际需求调整）
		private const int BulletLayer = 1;   // 二进制 0001
		private const int TargetLayer = 0;    // 二进制 0010

		private Rid _canvasItem;
		private Texture2D _texture;
		private Dictionary<Rid, Bullet> _bulletDict = new Dictionary<Rid, Bullet>();
		private HashSet<Rid> _bulletsToRemove = new HashSet<Rid>();
		[Export] public int BulletCount = 7000; // 可根据需要调整数量
		[Export] public int BulletVelocity = 50;    //子弹速度

		public Area2D area2D = new Area2D();
		public override void _Ready()
		{
			_canvasItem = RenderingServer.CanvasItemCreate();
			RenderingServer.CanvasItemSetParent(_canvasItem, GetCanvasItem());
			_texture = ResourceLoader.Load<Texture2D>("res://data/config/images/ID_3B8EAE66BAEA4426B59F0AEE51C3CFD4.png");

			area2D = GetNode<Area2D>("Area2D");
			area2D.BodyShapeEntered += Area2D_BodyShapeEntered;


			// 实际创建物理体
			for (int i = 0; i < BulletCount; i++)
			{
				Vector2 position = new Vector2(
	(float)GD.RandRange(0, GetViewportRect().Size.X),
	(float)GD.RandRange(0, GetViewportRect().Size.Y));
				Vector2 velocity = (area2D.Position- position).Normalized()*BulletVelocity;
				CreateBullet(position,  velocity); //创建子弹
			}
		}

		private void Area2D_BodyShapeEntered(Rid bodyRid, Node2D body, long bodyShapeIndex, long localShapeIndex)
		{
			_bulletsToRemove.Add(bodyRid);
		}

		private void CreateBullet(Vector2 position, Vector2 velocity)
		{
			Rid body = PhysicsServer2D.BodyCreate();

			// 关键物理参数设置
			PhysicsServer2D.BodySetMode(body, PhysicsServer2D.BodyMode.Rigid);
			PhysicsServer2D.BodySetParam(body, PhysicsServer2D.BodyParameter.GravityScale, 0f);
			PhysicsServer2D.BodySetParam(body, PhysicsServer2D.BodyParameter.LinearDamp, 0f);

			// 设置碰撞层（关键修改）
			PhysicsServer2D.BodySetCollisionLayer(body, BulletLayer);
			PhysicsServer2D.BodySetCollisionMask(body, TargetLayer); // 只检测目标层

			Rid shape = PhysicsServer2D.RectangleShapeCreate();
			PhysicsServer2D.ShapeSetData(shape, _texture.GetSize() / 2);
			PhysicsServer2D.BodyAddShape(body, shape);

			var transform = new Transform2D(0, position);
			PhysicsServer2D.BodySetSpace(body, GetWorld2D().Space);
			PhysicsServer2D.BodySetState(body, PhysicsServer2D.BodyState.Transform, transform);
			PhysicsServer2D.BodySetState(body, PhysicsServer2D.BodyState.LinearVelocity, velocity);

			// 传递正确的索引
			PhysicsServer2D.BodySetForceIntegrationCallback(
				body,
				new Callable(this, MethodName._OnBodyMoved),
				body);

			_bulletDict[body] = new Bullet
			{
				BodyRid = body,
				Transform = transform,
				Velocity = velocity // 存储初始速度
			};

		}

		private void _OnBodyMoved(PhysicsDirectBodyState2D state, Rid body)
		{
			if (_bulletDict.TryGetValue(body, out Bullet bullet))
			{
				// 强制保持速度
				state.LinearVelocity = bullet.Velocity;
				bullet.Transform = state.Transform;
				_bulletDict[body] = bullet;
			}
		}

		public override void _Process(double delta)
		{
			// 销毁标记的子弹
			foreach (Rid rid in _bulletsToRemove)
			{
				if (_bulletDict.TryGetValue(rid, out Bullet bullet))
				{
					PhysicsServer2D.FreeRid(bullet.BodyRid);
					_bulletDict.Remove(rid);
				}
			}
			_bulletsToRemove.Clear();
			// 清空画布并重新绘制所有子弹
			RenderingServer.CanvasItemClear(_canvasItem);

			foreach (var bullet in _bulletDict.Values)
			{
				RenderingServer.CanvasItemAddTextureRect(
					_canvasItem,
					new Rect2(
						bullet.Transform.Origin - _texture.GetSize() / 2, // 中心对齐
						_texture.GetSize()),
					_texture.GetRid());
			}
		}

		public override void _ExitTree()
		{
			// 清理资源
			foreach (var bullet in _bulletDict.Values)
				PhysicsServer2D.FreeRid(bullet.BodyRid);
			RenderingServer.FreeRid(_canvasItem);
		}
	}
}
