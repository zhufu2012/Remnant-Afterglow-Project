using System.Collections.Generic;
using BulletMLLib.SharedProject.Nodes;
using BulletMLLib.SharedProject.Tasks;
using Remnant_Afterglow;

namespace BulletMLLib.SharedProject
{
    /// <summary>
    /// 如果你希望某个对象具有子弹的特性，可以继承这个接口。
    /// 对于封装了子弹的对象非常有用。
    /// </summary>
    public interface IBullet
    {
        /// <summary>
        /// 一个任务列表，用于定义这颗子弹的行为。
        /// </summary>
        List<BulletMLTask> Tasks { get; }

        /// <summary>
        /// 获取或设置这颗子弹的X位置。
        /// 以像素为单位，从左上角测量。
        /// </summary>
        float X { get; set; }

        /// <summary>
        /// 获取或设置这颗子弹的Y位置。
        /// 以像素为单位，从左上角测量。
        /// </summary>
        float Y { get; set; }

        /// <summary>
        /// 获取或设置这颗子弹的速度。
        /// 以每帧的像素数为单位。
        /// </summary>
        float Speed { get; set; }

        /// <summary>
        /// 获取或设置这颗子弹的方向。
        /// 以弧度为单位。
        /// </summary>
        float Direction { get; set; }

        /// <summary>
        /// 当前子弹已经飞行的距离
        /// </summary>
        float CurrFlyDistance { get; set; }
        /// <summary>
        /// 子弹id
        /// </summary>
        string BulletLabel { get; set; }

        /// <summary>
        /// 使用顶级节点初始化这颗子弹。
        /// </summary>
        /// <param name="rootNode">顶级节点，用于定义这颗子弹的行为。</param>
        void InitTopNode(BulletMLNode rootNode, BaseObject targetObject, BaseObject createObject);

        /// <summary>
        /// 这颗子弹是从另一颗子弹发射出来的，从发射它的节点初始化。
        /// </summary>
        /// <param name="subNode">定义这颗子弹的子节点。</param>
        /// <param name="baseObject">定义这颗子弹的子节点。</param>
        /// <param name="baseObject2">定义这颗子弹的子节点。</param>
        void InitNode(BulletMLNode subNode, BaseObject targetObject, BaseObject createObject);
    }
}