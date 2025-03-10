
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 实体动画 处理
    /// </summary>
    public partial class BaseObject : CharacterBody2D, IPoolItem
    {

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
        /// 设置节点整体颜色
        /// </summary>
        public void SetNodeColor(Color color)
        {
            Modulate = color;
        }

    }
}
