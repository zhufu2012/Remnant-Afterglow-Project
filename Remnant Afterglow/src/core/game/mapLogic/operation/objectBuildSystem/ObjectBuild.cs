using Godot;
namespace Remnant_Afterglow
{
    /// <summary>
    /// 建造显示-建造某个建筑或者炮塔时，显示这个图像-可以有场景
    /// </summary>
    public partial class ObjectBuild : Control
    {
        /// <summary>
        /// 当前建造的类型
        /// </summary>
        BaseObjectType objectType;
        /// <summary>
        /// 当时要建造的实体
        /// </summary>
        public BaseObject nowObject;
        /// <summary>
        /// 地图所在位置
        /// </summary>
        public Vector2I mapPos;
        /// <summary>
        /// 当前建造速度
        /// </summary>
        public float BuildSpeed = 1;
        /// <summary>
        /// 当前建造进度-与属性-建造时间相关
        /// </summary>
        public float NowProgress = 0;
        /// <summary>
        /// 最大建造进度=开始的建造时间相关
        /// </summary>
        public float MaxProgress = 0;
        /// <summary>
        /// 建造的图像
        /// </summary>
        public TextureRect objectTextureRect = new TextureRect();
        ///建造进度条
        public ProgressBar progressBar = new ProgressBar();

        /// <summary>
        /// 构造函数，实体建造
        /// </summary>
        /// <param name="nowObject"></param>
        public ObjectBuild(BaseObject nowObject, Vector2I mapPos)
        {
            objectType = nowObject.object_type;
            this.NowProgress = 0;
            this.nowObject = nowObject;
            MaxProgress = nowObject.GetAttrNow(Attr.Attr_101);//最大建造时间
            objectTextureRect.Texture = nowObject.AnimatedSprite.SpriteFrames.GetFrameTexture("1", 1);//获取默认动画第一帧-不一定对，看第一帧是不是有问题
            objectTextureRect.Modulate = new Color(1, 1, 1, 0.5f);//祝福注释-待修改
        }

        /// <summary>
        /// 初始化显示
        /// </summary>
        public void InitView()
        {
            AddChild(objectTextureRect);
        }


        /// <summary>
        /// 建造更新-每帧更新一次
        /// </summary>
        public void BuildUpdate()
        {
            if (NowProgress >= MaxProgress)
            {
                //这里是建造完成
            }
            else
            {
                NowProgress++;
                //同时显示进度条也更新
                UpdateShow(NowProgress);
            }
        }

        /// <summary>
        /// 更新进度条，和界面显示透明度
        /// </summary>
        /// <param name="NowProgress"></param>
        public void UpdateShow(float NowProgress)
        {
            objectTextureRect.Modulate = new Color(1, 1, 1, 0.5f + NowProgress / MaxProgress);
        }

    }
}