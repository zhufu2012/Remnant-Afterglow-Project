using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 防御塔动画
    /// </summary>
    public partial class TowerBase
    {
        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        [Export]
        public AnimatedSprite2D AnimatedSprite = new AnimatedSprite2D();


        /// <summary>
        /// 播放动画,并且设置动画的位置，确保动画的中心在实体上
        /// </summary>
        /// <param name="AnimaName">1 默认动画...</param>
        public void PlayAnima(string AnimaName)
        {
            if (AnimatedSprite.SpriteFrames.HasAnimation(AnimaName))
                AnimatedSprite.Play(AnimaName);
            else
                AnimatedSprite.Play(ObjectStateNames.Default);
        }

        /// <summary>
        /// 防御塔动画-底座
        /// </summary>
        /// <param name="CfgData"></param>
        /// <returns></returns>
        public void InitAnima()
        {
            AnimatedSprite.TextureFilter = TextureFilterEnum.Nearest;
            // 从预生成的资源中加载 SpriteFrames
            string spriteFramesPath = $"res://assets/animate/tower_{buildData.ObjectId}.tres";
            if (ResourceLoader.Exists(spriteFramesPath))
            {
                SpriteFrames spriteFrames = ResourceLoader.Load<SpriteFrames>(spriteFramesPath);
                AnimatedSprite.SpriteFrames = spriteFrames;
                if (spriteFrames.HasAnimation("1"))
                {
                    AnimatedSprite.Animation = "1";
                    AnimatedSprite.Autoplay = "1";
                }
            }
        }

    }
}