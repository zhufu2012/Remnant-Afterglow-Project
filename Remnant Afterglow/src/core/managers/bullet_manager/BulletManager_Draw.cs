

using BulletMLLib.SharedProject;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 子弹管理器-绘制
    /// </summary>
    public partial class BulletManager : Node2D, IBulletManager
    {
        private Rid _canvasItem;
        public override void _Ready()
        {
            Name = "BulletManager";
            _canvasItem = RenderingServer.CanvasItemCreate();
            RenderingServer.CanvasItemSetZIndex(_canvasItem, ViewConstant.Bullet_ZIndex);
            RenderingServer.CanvasItemSetParent(_canvasItem, GetCanvasItem());

        }

        /// <summary>
        /// 全部实体子弹绘制
        /// </summary>
        public void EntityDraw()
        {
            // 清空画布并重新绘制所有子弹
            RenderingServer.CanvasItemClear(_canvasItem);

            foreach (var info in bulletDict)
            {
                if (_centerbulletCache.ContainsKey(info.Value.BulletId))//中心对称子弹
                {
                    RenderingServer.CanvasItemAddTextureRect(
                    _canvasItem,
                    new Rect2(
                        info.Value.GetPosition() - _textureSizeCache[info.Value.BulletId] / 2,
                        _textureSizeCache[info.Value.BulletId]),
                     _textureCache[info.Value.BulletId]);
                }
                else//非中心对称子弹
                {
                    // 使用独立的 CanvasItem 来绘制每个非中心对称子弹
                    if (bulletCanvasItemDict.ContainsKey(info.Key))
                    {
                        Rid canvasItem = bulletCanvasItemDict[info.Key];
                        RenderingServer.CanvasItemClear(canvasItem);

                        // 创建变换矩阵，包括位置和旋转
                        Transform2D transform = new Transform2D(info.Value.Direction, Vector2.Zero);
                        transform.Origin = info.Value.GetPosition();

                        // 应用变换并绘制纹理
                        RenderingServer.CanvasItemSetTransform(canvasItem, transform);
                        RenderingServer.CanvasItemAddTextureRect(
                            canvasItem,
                            new Rect2(
                                -_textureSizeCache[info.Value.BulletId] / 2,
                                _textureSizeCache[info.Value.BulletId]),
                            _textureCache[info.Value.BulletId]
                        );
                    }
                }
            }
        }



    }
}
