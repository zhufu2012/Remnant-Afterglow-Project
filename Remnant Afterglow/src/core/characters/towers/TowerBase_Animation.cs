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
        /// 防御塔动画-底座
        /// </summary>
        /// <param name="CfgData"></param>
        /// <returns></returns>
        public AnimatedSprite2D GetTowerFrame(TowerData CfgData)
        {
            AnimatedSprite2D AnimatedSprite = new AnimatedSprite2D();
            SpriteFrames spriteFrames = new SpriteFrames();
            List<int> AnimaTypeList = CfgData.AnimaTypeList;
            string LoopName = "1";
            string AutoName = "1";
            foreach (int AnimaType in AnimaTypeList)
            {
                AnimaTower animaUnit = ConfigCache.GetAnimaTower(CfgData.ObjectId + "_" + AnimaType);
                Image image = animaUnit.Picture.GetImage();
                string AnimaName = "" + AnimaType;
                spriteFrames.AddAnimation(AnimaName);
                int Index = 1;
                for (int i = 1; i <= animaUnit.Size.X; i++)
                {
                    for (int j = 1; j <= animaUnit.Size.Y; j++)
                    {
                        if (Index <= animaUnit.MaxIndex)
                        {
                            Rect2I rect2 = new Rect2I(new Vector2I((i - 1) * animaUnit.LengWidth.X, (j - 1) * animaUnit.LengWidth.Y), animaUnit.LengWidth);
                            Texture2D texture2D = ImageTexture.CreateFromImage(image.GetRegion(rect2));
                            spriteFrames.AddFrame(AnimaName, texture2D, animaUnit.DurationMs / 1000);
                        }
                        else
                        {
                            break;
                        }
                        Index++;
                    }
                }
                if (animaUnit.IsLoop)
                    LoopName = AnimaName;
                if (animaUnit.IsAutoplay)
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


        /// <summary>
        /// 初始化远程武器数据
        /// </summary>
        /// <returns></returns>
        public void InitWeaponData()
        {
            foreach (List<int> var in CfgData.WeaponList)
            {
                int CampId = Camp;
                if (var[1] != 0)
                    CampId = var[1];
                Weapon weapon = new Weapon(var[0], CampId);
                WeaponList.Add(weapon);
            }
        }











    }
}