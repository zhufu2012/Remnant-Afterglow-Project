using System.Collections.Generic;
using System.Diagnostics;
using BulletMLLib.SharedProject;
using Godot;

namespace Remnant_Afterglow
{
    /// <summary>
    /// BulletManager - 表示一个子弹管理器，例如生成子弹的敌人角色。
    /// </summary>
    public class BulletManager : IBulletManager
    {
        /// <summary>
        /// 时间速度常量，用于控制子弹的时间流逝速度。
        /// </summary>
        private const float timeSpeed = 1.0f;

        /// <summary>
        /// 缩放比例常量，用于控制子弹的大小。
        /// </summary>
        private const float scale = 1.0f;

        /// <summary>
        /// 存储所有活动子弹的列表。
        /// </summary>
        private readonly List<BulletBase> bulletList = new();

        /// <summary>
        /// 存储顶级子弹的列表，这些子弹不受其他子弹的影响。
        /// </summary>
        private readonly List<BulletBase> topBulletList = new();

        /// <summary>
        /// 存储所有子弹模式的字典,<子弹id,子弹模式>
        /// </summary>
        private readonly Dictionary<string, BulletPattern> PatternDict = new();



        /// <summary>
        /// 构造函数，初始化BulletManager实例。
        /// </summary>
        /// <param name="playerPosition">获取玩家位置的委托。</param>
        public BulletManager()
        {
            List<BulletData> bulletDatas = ConfigCache.GetAllBulletData();
            string rootPath = PathConstant.GetPathUser(PathConstant.BULLET_LOGIC_PATH_USER);
            foreach (BulletData item in bulletDatas)//初始化所有子弹模式
            {
                string path = rootPath + item.Logic;//子弹模式路径
                BulletPattern pattern = new BulletPattern();
                pattern.ParseXML(path);
                PatternDict[item.BulletLabel] = pattern;
            }
        }

        /// <summary>
        /// 更新所有子弹的状态。
        /// </summary>
        /// <param name="delta">上次调用以来的时间差（秒）。</param>
        public void Update(double delta)
        {
            for (var i = 0; i < bulletList.Count; i++)
            {
                bulletList[i].Update(); // 更新每个普通子弹
            }

            for (var i = 0; i < topBulletList.Count; i++)
            {
                topBulletList[i].Update(); // 更新每个顶级子弹
            }
        }

        /// <summary>
        /// 在每次更新后调用的方法，用于处理额外的逻辑。
        /// </summary>
        public void PostUpdate()
        {
            // TODO: 使用Godot游戏循环
            foreach (var t in bulletList)
            {
                t.PostUpdate(); // 处理每个普通子弹的PostUpdate逻辑
            }

            foreach (var t in topBulletList)
            {
                t.PostUpdate(); // 处理每个顶级子弹的PostUpdate逻辑
            }
            FreeMovers(); // 释放不再使用的子弹
        }
        /// <summary>
        /// 释放不再使用的子弹。
        /// </summary>
        private void FreeMovers()
        {
            for (var i = 0; i < bulletList.Count; i++)
            {

                if (bulletList[i].Used)
                    continue; // 跳过仍在使用的子弹
                bulletList[i].BulletNode.QueueFree();//下一帧清除
                bulletList.RemoveAt(i); // 移除不再使用的子弹
                i--; // 因为移除了一个元素，所以索引减一
            }

            // 清理顶级子弹
            for (var i = 0; i < topBulletList.Count; i++)
            {
                if (!topBulletList[i].TasksFinished())
                    continue; // 跳过任务未完成的顶级子弹
                topBulletList[i].BulletNode.QueueFree();//下一帧清除
                topBulletList.RemoveAt(i); // 移除任务已完成的顶级子弹
                i--; // 因为移除了一个元素，所以索引减一
            }
        }

        /// <summary>
        /// 获取玩家的位置。
        /// </summary>
        /// <param name="targettedBullet">目标子弹，通常用于计算相对于玩家的位置。</param>
        /// <returns>玩家的位置。</returns>
        public Vector2 PlayerPosition(IBullet targettedBullet)
        {
            return new Vector2(0, 0); // 返回玩家的位置-祝福注释
        }


        /// <summary>
        /// 创建一个新的顶级子弹，常用函数
        /// </summary>
        /// <param name="BulletLabel">子弹标签名</param>
        /// <param name="Pos">子弹创建位置</param>
        /// <param name="Direction">子弹发射方向，弧度</param>
        /// <param name="targetObject">攻击对象</param>
        /// <returns>新创建的顶级子弹。</returns>
        public BulletBase CreateTopBullet(string BulletLabel, Vector2 Pos, float Direction, BaseObject targetObject)
        {
            BulletBase topLevelBullet = (BulletBase)CreateTopBullet(BulletLabel, targetObject);
            topLevelBullet.Position = Pos;
            topLevelBullet.Direction = Direction;
            return topLevelBullet;
        }

        /// <summary>
        /// 移除指定的子弹。
        /// </summary>
        /// <param name="deadBullet">要移除的子弹。</param>
        public void RemoveBullet(IBullet deadBullet)
        {
            if (deadBullet is BulletBase bullet)
            {
                bullet.Used = false; // 将子弹标记为未使用
            }
        }

        /// <summary>
        /// 创建一个新的普通子弹。
        /// </summary>
        /// <returns>新创建的子弹。</returns>
        public IBullet CreateBullet(string BulletLabel, BaseObject targetObject)
        {
            var bullet = new BulletBase(this, BulletLabel, targetObject) // 创建一个新的Mover实例
            {
                TimeSpeed = timeSpeed, // 设置时间速度
                Scale = scale // 设置缩放比例
            };

            // 初始化子弹，存储在列表中，并返回
            bullet.Init();
            bulletList.Add(bullet);
            return bullet;
        }


        /// <summary>
        /// 创建一个新的顶级子弹。
        /// </summary>
        /// <returns>新创建的顶级子弹。</returns>
        public IBullet CreateTopBullet(string BulletLabel, BaseObject targetObject)
        {
            var bullet = new BulletBase(this, BulletLabel, targetObject) // 创建一个新的Mover实例
            {
                TimeSpeed = timeSpeed, // 设置时间速度
                Scale = scale // 设置缩放比例
            };

            // 初始化子弹，存储在列表中，并返回
            bullet.Init();
            bullet.InitTopNode(PatternDict[BulletLabel].RootNode, targetObject);//设置子弹模式

            topBulletList.Add(bullet);
            return bullet;
        }


        /// <summary>
        /// 获取当前等级。
        /// </summary>
        /// <returns>当前等级。</returns>
        public double Tier()
        {
            return 0.0; // 默认返回0.0，可以根据需要修改
        }


        /// <summary>
        /// 清除所有子弹。
        /// </summary>
        public void Clear()
        {
            bulletList.Clear(); // 清除所有普通子弹
            topBulletList.Clear(); // 清除所有顶级子弹
        }
    }
}