using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位动画
    /// </summary>
    public partial class WorkerBase
    {
        /// <summary>
        /// 播放动画,并且设置动画的位置，确保动画的中心在实体上
        /// </summary>
        /// <param name="AnimaName">1 默认动画...</param>
        public void PlayAnima(string AnimaName)
        {
            if(AnimatedSprite.SpriteFrames.HasAnimation(AnimaName))
                AnimatedSprite.Play(AnimaName);
            else
                AnimatedSprite.Play(AnimatorNames.Default);
        }
        /// <summary>
        /// 单位动画
        /// </summary>
        /// <param name="CfgData"></param>
        /// <returns></returns>
        public AnimatedSprite2D GetWorkerFrame(WorkerData CfgData)
        {
            AnimatedSprite2D AnimatedSprite = new AnimatedSprite2D();
            SpriteFrames spriteFrames = new SpriteFrames();
            List<int> AnimaTypeList = CfgData.AnimaTypeList;
            string LoopName = "1";
            string AutoName = "1";
            foreach (int AnimaType in AnimaTypeList)
            {
                AnimaWorker animaWorker = ConfigCache.GetAnimaWorker(CfgData.ObjectId + "_" + AnimaType);
                Image image = animaWorker.Picture.GetImage();
                string AnimaName = "" + AnimaType;
                spriteFrames.AddAnimation(AnimaName);
                int Index = 1;
                for (int i = 1; i <= animaWorker.Size.X; i++)
                {
                    for (int j = 1; j <= animaWorker.Size.Y; j++)
                    {
                        if (Index <= animaWorker.MaxIndex)
                        {
                            Rect2I rect2 = new Rect2I(new Vector2I((i - 1) * animaWorker.LengWidth.X, (j - 1) * animaWorker.LengWidth.Y), animaWorker.LengWidth);
                            Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
                            spriteFrames.AddFrame(AnimaName, texture2D, animaWorker.DurationMs / 1000);
                        }
                        else
                        {
                            break;
                        }
                        Index++;
                    }
                }
                if (animaWorker.IsLoop)
                    LoopName = AnimaName;
                if (animaWorker.IsAutoplay)
                    AutoName = AnimaName;
            }
            if (AnimaTypeList.Count > 0)
            {
                spriteFrames.SetAnimationLoop(LoopName, true);
                spriteFrames.RemoveAnimation("default");
                AnimatedSprite.SpriteFrames = spriteFrames;
                AnimatedSprite.Animation = LoopName;
                AnimatedSprite.Autoplay = AutoName;
            }
            return AnimatedSprite;
        }
    }
}