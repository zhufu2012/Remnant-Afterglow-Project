using BulletMLLib.SharedProject;
using Godot;
using System.Collections.Generic;

namespace Remnant_Afterglow
{

    /// <summary>
    /// 子弹请求结构
    /// </summary>
    public struct BulletRequest
    {
        /// <summary>
        /// 子弹id
        /// </summary>
        public int BulletId;
        /// <summary>
        /// 发射位置
        /// </summary>
        public Vector2 Position;
        /// <summary>
        /// 子弹方向
        /// </summary>
        public float Direction;
        /// <summary>
        /// 目标
        /// </summary>
        public BaseObject TargetObject;
        /// <summary>
        /// 创建者
        /// </summary>
        public BaseObject CreateObject;
    }
    /// <summary>
    /// 子弹管理器-性能优化
    /// </summary>
    public partial class BulletManager : Node2D, IBulletManager
    {

        #region 子弹性能优化相关
        /// <summary>
        /// 存储所有活动子弹的列表。
        /// </summary>
        public readonly Dictionary<Rid, EntityBullet> bulletDict = new Dictionary<Rid, EntityBullet>();

        /// <summary>
        /// 存储顶级子弹的列表，这些子弹不受其他子弹的影响,负责发射子弹
        /// </summary>
        public List<EntityBullet> topBulletList = new List<EntityBullet>(300);
        /// <summary>
        /// 子弹的图片
        /// </summary>
        public Dictionary<Rid, Sprite2D> bulletSpriteDict = new Dictionary<Rid, Sprite2D>();
        /// <summary>
        /// 非中心对称子弹的 CanvasItem 字典
        /// </summary>
        public Dictionary<Rid, Rid> bulletCanvasItemDict = new Dictionary<Rid, Rid>();

        /// <summary>
        /// 子弹请求队列
        /// </summary>
        private readonly Queue<BulletRequest> _bulletQueue = new();
        /// <summary>
        /// 队列处理状态标识
        /// </summary>
        private bool _isProcessingQueue = false;
        /// <summary>
        /// 目标帧率
        /// </summary>
        private int _autoAdjustThreshold = 50;
        private int _maxPerFarme = 24;
        /// <summary>
        /// 当前每帧生成
        /// </summary>
        private int _currentMaxPerFrame = 18;

        /// <summary>
        /// 将发射请求加入队列,
        /// </summary>
        /// <param name="request"></param>
        public void EnqueueBulletRequest(BulletRequest request)
        {
            _bulletQueue.Enqueue(request);
        }
        /// <summary>
        /// 处理子弹队列
        /// </summary>
        private void ProcessBulletQueue()
        {
            if (_isProcessingQueue) return;
            _isProcessingQueue = true;
            try
            {
                int processedCount = 0;
                while (_bulletQueue.Count > 0 && processedCount < _currentMaxPerFrame)
                {
                    var request = _bulletQueue.Dequeue();
                    CreateEntityBullet(
                        request.BulletId,
                        request.Position,
                        request.Direction,
                        request.TargetObject,
                        request.CreateObject
                    );
                    processedCount++;
                }
            }
            finally
            {
                _isProcessingQueue = false;
            }
        }

        /// <summary>
        /// 根据当前fps 调整生成速度
        /// </summary>
        private void AutoAdjustRate()
        {
            /**var currentFps = Engine.GetFramesPerSecond();//当前fps
            if (currentFps < _autoAdjustThreshold)
            {
                _currentMaxPerFrame = _maxPerFarme / 2;
            }
            else
            {
                _currentMaxPerFrame = _maxPerFarme;
            }**/
        }

        /// <summary>
        /// 需要立即生成时的应急方法
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        public IBullet CreateTopBulletEmergency(BulletRequest request)
        {
            return CreateEntityBullet(
                request.BulletId,
                request.Position,
                request.Direction,
                request.TargetObject,
                request.CreateObject
            );
        }

        #endregion


    }
}
