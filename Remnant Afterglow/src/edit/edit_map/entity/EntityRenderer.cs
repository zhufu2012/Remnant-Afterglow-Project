using Godot;
using Remnant_Afterglow;
using System;
using System.Collections.Generic;

namespace Remnant_Afterglow_EditMap
{
    /// <summary>
    /// 实体渲染器，用于处理建筑、炮塔等实体的渲染逻辑
    /// </summary>
    public class EntityRenderer
    {
        /// <summary>
        /// 渲染建筑或炮塔主体
        /// </summary>
        /// <param name="sprite">要渲染的精灵</param>
        /// <param name="buildData">建筑数据</param>
        /// <param name="position">位置</param>
        public static void RenderEntity(Sprite2D sprite, BuildData buildData, Vector2 position)
        {
            if (buildData.Type == 0) // 建筑
            {
                RenderBuilding(sprite, buildData, position);
            }
            else // 炮塔
            {
                RenderTower(sprite, buildData, position);
            }
        }

        /// <summary>
        /// 渲染建筑
        /// </summary>
        private static void RenderBuilding(Sprite2D sprite, BuildData buildData, Vector2 position)
        {
            AnimaBuild animaUnit = ConfigCache.GetAnimaBuild(buildData.ObjectId + "_" + 1);
            if (animaUnit != null)
            {
                sprite.Texture = animaUnit.Picture;
                sprite.Hframes = animaUnit.Size.X;
                sprite.Vframes = animaUnit.Size.Y;
                sprite.Frame = 0;
                sprite.Position = position;
            }
        }

        /// <summary>
        /// 渲染炮塔
        /// </summary>
        private static void RenderTower(Sprite2D sprite, BuildData buildData, Vector2 position)
        {
            AnimaTower animaUnit = ConfigCache.GetAnimaTower(buildData.ObjectId + "_" + 1);
            if (animaUnit != null)
            {
                sprite.Texture = animaUnit.Picture;
                sprite.Hframes = animaUnit.Size.X;
                sprite.Vframes = animaUnit.Size.Y;
                sprite.Frame = 0;
                sprite.Position = position;
            }
        }

        /// <summary>
        /// 渲染武器
        /// </summary>
        /// <param name="parentSprite">父级精灵</param>
        /// <param name="weaponList">武器列表</param>
        /// <returns>武器精灵列表</returns>
        public static List<Sprite2D> RenderWeapons(Sprite2D parentSprite, List<List<int>> weaponList)
        {
            List<Sprite2D> weapons = new List<Sprite2D>();

            if (weaponList != null && weaponList.Count > 0)
            {
                foreach (var weaponData in weaponList)
                {
                    int weaponId = weaponData[0];
                    int x = weaponData[1];
                    int y = weaponData[2];

                    AnimaWeapon animaWeapon = ConfigCache.GetAnimaWeapon(weaponId + "_" + 1);
                    if (animaWeapon != null)
                    {
                        Sprite2D weaponShow = new Sprite2D();
                        weaponShow.Texture = animaWeapon.Picture;
                        weaponShow.Hframes = animaWeapon.Size.X;
                        weaponShow.Vframes = animaWeapon.Size.Y;
                        weaponShow.Frame = 0;
                        weaponShow.Position = new Vector2(x, y);
                        parentSprite.AddChild(weaponShow);
                        weapons.Add(weaponShow);
                    }
                }
            }

            return weapons;
        }

        /// <summary>
        /// 设置实体颜色
        /// </summary>
        /// <param name="sprite">主体精灵</param>
        /// <param name="weapons">武器精灵列表</param>
        /// <param name="color">颜色</param>
        public static void SetEntityColor(Sprite2D sprite, List<Sprite2D> weapons, Color color)
        {
            sprite.Modulate = color;

            if (weapons != null)
            {
                foreach (var weapon in weapons)
                {
                    weapon.Modulate = color;
                }
            }
        }
    }
}