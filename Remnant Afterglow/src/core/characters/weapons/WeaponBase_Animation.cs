using Godot;
using System.Collections.Generic;
using System.Diagnostics;

namespace Remnant_Afterglow
{
    /// <summary>
    /// 单位动画-用补间动画做
    /// </summary>
    public partial class WeaponBase : Area2D, IWeapon
    {
        /// <summary>
        /// 当前物体显示的精灵图像, 节点名称必须叫 "AnimatedSprite2D", 类型为 AnimatedSprite2D
        /// </summary>
        [Export]
        public AnimatedSprite2D AnimatedSprite { get; set; }

        public ShaderMaterial shaderMaterial;

        public Tween HitFlashTween;

        //动画队列最大长度
        private const int MAX_QUEUE_SIZE = 3;
        /// <summary>
        /// 动画优先级权重映射
        /// </summary>
        private Dictionary<string, int> _animationPriorities = new Dictionary<string, int>()
        {
            { ObjectStateNames.Attack, 10 },  // 攻击动画优先级最高
            { ObjectStateNames.Fill, 8 },     // 装填动画次之
            { ObjectStateNames.Move, 5 },     // 移动动画
            { ObjectStateNames.Default, 3 }   // 默认动画优先级最低
        };
        /// <summary>
        /// 动画队列，用于按顺序播放动画
        /// </summary>
        private Queue<string> _animationQueue = new Queue<string>();

        /// <summary>
        /// 标记当前是否正在播放动画
        /// </summary>
        private bool _isPlayingAnimation = false;

        /// <summary>
        /// 播放动画,并且设置动画的位置，确保动画的中心在实体上
        /// 如果当前有动画正在播放，则将新动画加入队列
        /// </summary>
        /// <param name="AnimaName">动画名称</param>
        public void PlayAnima(string AnimaName)
        {
            // 检查AnimatedSprite是否有效
            if (AnimatedSprite == null || AnimatedSprite.SpriteFrames == null)
            {
                GD.PrintErr($"WeaponBase: AnimatedSprite or SpriteFrames is null when trying to play animation: {AnimaName}");
                return;
            }

            // 检查动画是否存在
            if (!AnimatedSprite.SpriteFrames.HasAnimation(AnimaName))
            {
                return;
            }

            // 如果当前正在播放动画，将新动画加入队列
            if (_isPlayingAnimation)
            {
                // 优化队列管理：根据优先级决定是否替换队列中的动画
                ManageAnimationQueue(AnimaName);
                return;
            }
            else
            {
                // 直接播放动画
                AnimatedSprite.Play(AnimaName);
                _isPlayingAnimation = true;
            }
        }

        /// <summary>
        /// 智能管理动画队列，根据优先级决定如何添加新动画
        /// </summary>
        /// <param name="newAnimationName">新动画名称</param>
        private void ManageAnimationQueue(string newAnimationName)
        {
            // 如果队列未满，直接添加
            if (_animationQueue.Count < MAX_QUEUE_SIZE)
            {
                _animationQueue.Enqueue(newAnimationName);
                return;
            }
            else
            {
                _animationQueue.Dequeue();
                _animationQueue.Enqueue(newAnimationName);
            }
        }

        /// <summary>
        /// 立即播放动画，清空队列并直接播放指定动画
        /// </summary>
        /// <param name="AnimaName">动画名称</param>
        public void PlayAnimaImmediate(string AnimaName)
        {
            // 检查AnimatedSprite是否有效
            if (AnimatedSprite == null || AnimatedSprite.SpriteFrames == null)
            {
                GD.PrintErr($"WeaponBase: AnimatedSprite or SpriteFrames is null when trying to play animation immediately: {AnimaName}");
                return;
            }

            // 清空动画队列
            _animationQueue.Clear();
            _isPlayingAnimation = false; // 重置播放状态

            if (AnimatedSprite.SpriteFrames.HasAnimation(AnimaName))
            {
                AnimatedSprite.Play(AnimaName);
                _isPlayingAnimation = true;
            }
            else
            {
                // 尝试播放默认动画
                if (AnimatedSprite.SpriteFrames.HasAnimation(ObjectStateNames.Default))
                {
                    AnimatedSprite.Play(ObjectStateNames.Default);
                    _isPlayingAnimation = true;
                }
                else
                {
                    GD.PrintErr($"WeaponBase: Neither requested animation '{AnimaName}' nor default animation exists");
                }
            }
        }

        /// <summary>
        /// 播放完成
        /// </summary>
        private void OnAnimationFinished()
        {
            _isPlayingAnimation = false;

            // 检查AnimatedSprite是否有效
            if (AnimatedSprite == null)
            {
                GD.PrintErr("WeaponBase: AnimatedSprite is null in OnAnimationFinished");
                return;
            }

            // 注意：此处的状态转换逻辑已在WeaponBase_Attack.cs的Update_Attack方法中处理
            // 移除重复的状态转换逻辑，避免状态不一致

            // 检查队列中是否有下一个动画
            if (_animationQueue.Count > 0)
            {
                string nextAnimation = _animationQueue.Dequeue();
                PlayAnima(nextAnimation);
            }
        }


        /// <summary>
        /// 远程武器动画初始化
        /// </summary>
        /// <param name="CfgData">武器配置数据</param>
        public void InitAnima(WeaponData CfgData)
        {
            // 首先尝试从场景树获取AnimatedSprite2D节点
            if (AnimatedSprite == null)
            {
                AnimatedSprite = GetNodeOrNull<AnimatedSprite2D>("AnimatedSprite2D");
                if (AnimatedSprite == null)
                {
                    GD.PrintErr($"WeaponBase: Failed to find AnimatedSprite2D node for weapon {CfgData.WeaponId}");
                    return;
                }
            }

            AnimatedSprite.TextureFilter = TextureFilterEnum.Nearest;

            // 从预生成的资源中加载 SpriteFrames
            string spriteFramesPath = $"res://assets/animate/weapon_{CfgData.WeaponId}.tres";
            if (ResourceLoader.Exists(spriteFramesPath))
            {
                try
                {
                    SpriteFrames spriteFrames = ResourceLoader.Load<SpriteFrames>(spriteFramesPath);
                    if (spriteFrames != null)
                    {
                        AnimatedSprite.SpriteFrames = spriteFrames;
                        // 使用ObjectStateNames.Default而不是硬编码的"1"
                        if (spriteFrames.HasAnimation(ObjectStateNames.Default))
                        {
                            AnimatedSprite.Animation = ObjectStateNames.Default;
                            AnimatedSprite.Autoplay = ObjectStateNames.Default;
                        }
                        else
                        {
                            GD.Print($"WeaponBase: Default animation not found for weapon {CfgData.WeaponId}");
                        }
                    }
                    else
                    {
                        GD.PrintErr($"WeaponBase: Failed to load SpriteFrames for weapon {CfgData.WeaponId}");
                    }
                }
                catch (System.Exception e)
                {
                    GD.PrintErr($"WeaponBase: Exception loading SpriteFrames for weapon {CfgData.WeaponId}: {e.Message}");
                }
            }
            else
            {
                GD.Print($"WeaponBase: SpriteFrames file not found for weapon {CfgData.WeaponId} at {spriteFramesPath}");
            }

            // 安全地获取和类型转换材质
            if (AnimatedSprite.Material is ShaderMaterial material)
            {
                shaderMaterial = material;
            }
            else
            {
                GD.Print($"WeaponBase: AnimatedSprite.Material is not a ShaderMaterial for weapon {CfgData.WeaponId}");
                // 可以选择创建一个默认的ShaderMaterial
            }

            // 确保只连接一次信号
            //AnimatedSprite.AnimationFinished -= OnAnimationFinished;
            AnimatedSprite.AnimationFinished += OnAnimationFinished;
        }

        /// <summary>
        /// 受击动画
        /// </summary>
        public void Flash()
        {
            // 检查shaderMaterial是否有效
            if (shaderMaterial == null)
            {
                GD.PrintErr("WeaponBase: shaderMaterial is null in Flash method");
                return;
            }

            // 安全地处理现有tween
            if (HitFlashTween != null && HitFlashTween.IsValid())
            {
                HitFlashTween.Kill();
                HitFlashTween = null;
            }
            try
            {
                // 设置受击效果参数
                shaderMaterial.SetShaderParameter("percent", 1.0);

                // 创建新的tween动画
                HitFlashTween = CreateTween();
                HitFlashTween.TweenProperty(shaderMaterial, "shader_parameter/percent", 0.0, 0.4);

                // 添加完成回调以清理
                HitFlashTween.Finished += () =>
                {
                    if (IsInstanceValid(HitFlashTween))
                    {
                        HitFlashTween = null;
                    }
                };
            }
            catch (System.Exception e)
            {
                GD.PrintErr($"WeaponBase: Exception in Flash method: {e.Message}");
            }
        }

        /// <summary>
        /// 清空动画队列
        /// </summary>
        public void ClearAnimationQueue()
        {
            _animationQueue.Clear();
        }

        /// <summary>
        /// 获取当前动画队列中的动画数量
        /// </summary>
        /// <returns>队列中的动画数量</returns>
        public int GetAnimationQueueCount()
        {
            return _animationQueue.Count;
        }

        /// <summary>
        /// 节点被移除时的清理工作
        /// </summary>
        public override void _ExitTree()
        {
            base._ExitTree();

            // 断开信号连接
            if (AnimatedSprite != null)
            {
                AnimatedSprite.AnimationFinished -= OnAnimationFinished;
            }

            // 清理tween资源
            if (HitFlashTween != null && HitFlashTween.IsValid())
            {
                HitFlashTween.Kill();
                HitFlashTween = null;
            }

            // 清空动画队列
            _animationQueue.Clear();
            _isPlayingAnimation = false;
        }

        /// <summary>
        /// 移除并返回队列中最旧的动画
        /// </summary>
        /// <returns>最旧的动画名称，如果队列为空则返回null</returns>
        public string RemoveOldestAnimation()
        {
            if (_animationQueue.Count > 0)
            {
                return _animationQueue.Dequeue();
            }
            return null;
        }

        /// <summary>
        /// 移除指定数量的最旧动画
        /// </summary>
        /// <param name="count">要移除的动画数量</param>
        public void RemoveOldestAnimations(int count)
        {
            for (int i = 0; i < count && _animationQueue.Count > 0; i++)
            {
                _animationQueue.Dequeue();
            }
        }

        /// <summary>
        /// 重置动画状态
        /// 用于武器状态发生剧烈变化时，确保动画状态一致性
        /// </summary>
        public void ResetAnimationState()
        {
            // 清空动画队列
            _animationQueue.Clear();

            // 重置播放状态
            _isPlayingAnimation = false;

            // 清理tween
            if (HitFlashTween != null && HitFlashTween.IsValid())
            {
                HitFlashTween.Kill();
                HitFlashTween = null;
            }

            // 尝试恢复到默认动画
            if (AnimatedSprite != null && AnimatedSprite.SpriteFrames != null &&
                AnimatedSprite.SpriteFrames.HasAnimation(ObjectStateNames.Default))
            {
                AnimatedSprite.Play(ObjectStateNames.Default);
                _isPlayingAnimation = true;
            }
        }

        /// <summary>
        /// 获取当前动画队列中的第一个动画名称（不移除）
        /// </summary>
        /// <returns>队列中第一个动画的名称，如果队列为空则返回null</returns>
        public string GetFirstAnimationInQueue()
        {
            if (_animationQueue.Count > 0)
            {
                return _animationQueue.Peek();
            }
            return null;
        }
    }
}