using Godot;
using System;

namespace Project_Core_Test
{

	public partial class BulletTestManager : Node2D
	{
		private MultiMeshInstance2D multiMeshInstance;
		private MultiMesh multiMesh;

		private struct Bullet
		{
			public Vector2 Position;
			public Vector2 Velocity;
			public bool Active;
		}

		private Bullet[] bullets;
		public int MaxBullets = 1000;

		public override void _Ready()
		{
			multiMeshInstance = GetNode<MultiMeshInstance2D>("MultiMeshInstance2D");

			// 创建MultiMesh并配置
			multiMesh = new MultiMesh();
			multiMeshInstance.Multimesh = multiMesh;

			// 创建自定义的ArrayMesh
			ArrayMesh arrayMesh = CreateQuadMesh();
			multiMesh.Mesh = arrayMesh;
			multiMesh.InstanceCount = MaxBullets;
			multiMesh.VisibleInstanceCount = MaxBullets;

			// 初始化子弹数组
			bullets = new Bullet[MaxBullets];


		}

		//发射子弹
		public void FreeBullet()
		{
			//ButtleTestManager bulletManager = GetNode<ButtleTestManager>("/root/BulletManager");
			SpawnBullet(new Vector2I(100,100), new Vector2(1, 1), 500);
		}

		private ArrayMesh CreateQuadMesh()
		{
			// 定义顶点、UV和索引
			Vector3[] vertices = new Vector3[]
			{
			new Vector3(-0.5f, -0.5f, 0), // 左下
			new Vector3(0.5f, -0.5f, 0),  // 右下
			new Vector3(0.5f, 0.5f, 0),   // 右上
			new Vector3(-0.5f, 0.5f, 0)   // 左上
			};

			Vector2[] uvs = new Vector2[]
			{
			new Vector2(0, 0),
			new Vector2(1, 0),
			new Vector2(1, 1),
			new Vector2(0, 1)
			};

			int[] indices = { 0, 1, 2, 0, 2, 3 };

			// 创建ArrayMesh
			ArrayMesh mesh = new ArrayMesh();
			var arrays = new Godot.Collections.Array();
			arrays.Resize((int)ArrayMesh.ArrayType.Max);
			arrays[(int)ArrayMesh.ArrayType.Vertex] = vertices;
			arrays[(int)ArrayMesh.ArrayType.TexUV] = uvs;
			arrays[(int)ArrayMesh.ArrayType.Index] = indices;

			mesh.AddSurfaceFromArrays(Mesh.PrimitiveType.Triangles, arrays);

			// 创建并应用材质
			ShaderMaterial material = new ShaderMaterial();
			material.Shader = new Shader();
			material.Shader.Code = @"
			shader_type canvas_item;
			uniform sampler2D texture_albedo;
			
			void fragment() {
				COLOR = texture(texture_albedo, UV);
			}
		";
			material.SetShaderParameter("texture_albedo", GD.Load<Texture2D>("res://data/config/images/ID_3B8EAE66BAEA4426B59F0AEE51C3CFD4.png"));
			mesh.SurfaceSetMaterial(0, material);

			return mesh;
		}

		public override void _Process(double delta)
		{
			float deltaTime = (float)delta;
			FreeBullet();


			for (int i = 0; i < MaxBullets; i++)
			{
				if (!bullets[i].Active) continue;

				// 更新位置
				bullets[i].Position += bullets[i].Velocity * deltaTime;

				// 计算旋转角度（根据速度方向）
				float rotation = bullets[i].Velocity.Angle();

				// 设置实例变换
				Transform2D transform = new Transform2D(rotation, bullets[i].Position);
				multiMesh.SetInstanceTransform2D(i, transform);

				// 边界检查示例
				if (bullets[i].Position.X < -100 || bullets[i].Position.X > GetViewportRect().Size.X + 100 ||
					bullets[i].Position.Y < -100 || bullets[i].Position.Y > GetViewportRect().Size.Y + 100)
				{
					bullets[i].Active = false;
				}
			}


		}

		public void SpawnBullet(Vector2 position, Vector2 direction, float speed)
		{
			for (int i = 0; i < MaxBullets; i++)
			{
				if (!bullets[i].Active)
				{
					bullets[i].Position = position;
					bullets[i].Velocity = direction.Normalized() * speed;
					bullets[i].Active = true;
					return;
				}
			}
		}
	}
}
