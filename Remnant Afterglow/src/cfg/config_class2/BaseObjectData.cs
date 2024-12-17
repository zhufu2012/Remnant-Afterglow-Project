using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 自动生成的配置类2 BaseObjectData 用于 实体表,拓展请在expand_class文件下使用partial拓展
    /// </summary>
    public partial class BaseObjectData
    {
        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>
        public void InitData()
        {

        }

        /// <summary>
        /// 初始化数据-构造函数后运行
        /// </summary>        
        public void InitData2()
        {
        }


        public CollisionShape2D GetCollisionShape2D()
        {
            CollisionShape2D Collision = new CollisionShape2D();
            Collision.Disabled = IsCollide;//是否启用碰撞器
            switch (ShapeType)
            {
                case 1: //1 2D胶囊形状
                    CapsuleShape2D shape1 = new CapsuleShape2D();
                    Collision.Shape = shape1;

                    break;
                case 2: //2 2D矩形
                    RectangleShape2D shape2 = new RectangleShape2D();
                    Collision.Shape = shape2;
                    break;
                case 3: //3 2D圆形
                    CircleShape2D shape3 = new CircleShape2D();
                    Collision.Shape = shape3;
                    break;
                case 4: //4 2D线段形状
                    SegmentShape2D shape4 = new SegmentShape2D();
                    Collision.Shape = shape4;
                    break;
                case 5: //5 2D多线段形状.描述多边形
                    ConcavePolygonShape2D shape5 = new ConcavePolygonShape2D();
                    Collision.Shape = shape5;
                    break;
                default:
                    break;
            }
            Collision.Position = CollidePos;
            Collision.RotationDegrees = CollideRotate;
            return Collision;
        }

    }
}
