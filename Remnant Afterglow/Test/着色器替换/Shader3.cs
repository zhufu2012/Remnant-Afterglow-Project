using Godot;
namespace Project_Core_Test
{

	public partial class Shader3 : Node2D
	{
		Texture2D texture = GD.Load<Texture2D>("res://data/config/images/ID_2FE39F3032FD4E1F863874F8B4F60749.png");
		public override void _Ready()
		{

			for (int i = 0; i < 10; i++)
			{
				for (int j = 0; j < 10; j++)
				{
					Sprite2D sprite = new Sprite2D();
					sprite.Texture = texture;
					sprite.Scale = new Vector2(0.333f, 3f);
					sprite.Position = new Vector2(1 + i * 10, 1 + j * 10);
					Shader material = ResourceLoader.Load<Shader>("res://Test/着色器替换/Shader.gdshader");
					ShaderMaterial shaderMaterial = new ShaderMaterial();
					shaderMaterial.SetShaderParameter("x", 12.0);
					shaderMaterial.SetShaderParameter("y", 1.0);
					shaderMaterial.Shader = material;
					sprite.Material = shaderMaterial;
					AddChild(sprite);
				}
			}
		}







	}
}
