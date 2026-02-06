using Godot;
namespace Project_Core_Test
{
	public partial class MyNode2d : Node2D
	{
		private Texture2D _texture;

		public override void _Ready()
		{
			// 创建一个画布项目，该节点的子节点。
			Rid ciRid = RenderingServer.CanvasItemCreate();
			// 将此节点设为父节点。
			RenderingServer.CanvasItemSetParent(ciRid, GetCanvasItem());
			// 在上面画一个纹理。
			// 记住，保留这个参考。
			_texture = ResourceLoader.Load<Texture2D>("res://data/config/images/ID_3B8EAE66BAEA4426B59F0AEE51C3CFD4.png");
			// 添加它，居中
			RenderingServer.CanvasItemAddTextureRect(ciRid, new Rect2(-_texture.GetSize() / 2, _texture.GetSize()), _texture.GetRid());
			// 添加旋转45度并平移的项目。
			Transform2D xform = Transform2D.Identity.Rotated(Mathf.DegToRad(45)).Translated(new Vector2(20, 30));
			RenderingServer.CanvasItemSetTransform(ciRid, xform);
		}
	}
}
