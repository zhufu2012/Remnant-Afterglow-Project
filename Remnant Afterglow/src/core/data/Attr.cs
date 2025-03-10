

using System.Collections.Generic;

namespace Remnant_Afterglow
{
    public static class Attr
    {
        #region 伤害计算优先级
        /// <summary>
        /// 伤害计算优先级
        /// </summary>
        public static Dictionary<int,int> PriorityDict = new Dictionary<int, int>() {
            {1,1 },//结构值
            {2,2},//装甲血量
            {3,3},//护盾

            //抗性
            {10,10},
            {11,10},
            {12,10},
            {13,10},

        };



        #endregion






        #region 基础相关
        /// <summary>
        /// 属性id 1  实体 结构值
        /// </summary>
        public const string Attr_001 = "1";
        /// <summary>
        /// 属性id 2  实体 装甲值
        /// </summary>
        public const string Attr_002 = "2";
        /// <summary>
        /// 属性id 3  实体 护盾
        /// </summary>
        public const string Attr_003 = "3";
        /// <summary>
        /// 属性id 6  实体 装甲血量比例
        /// </summary>
        public const string Attr_006 = "6";
        /// <summary>
        /// 属性id 7  实体 护盾结晶
        /// </summary>
        public const string Attr_007 = "7";
        /// <summary>
        /// 属性id 8  实体 护盾过载恢复
        /// </summary>
        public const string Attr_008 = "8";

        /// <summary>
        /// 属性id 8  实体 护盾抗性
        /// </summary>
        public const string Attr_010 = "10";
        /// <summary>
        /// 属性id 8  实体 装甲抗性
        /// </summary>
        public const string Attr_011 = "11";
        /// <summary>
        /// 属性id 8  实体 结构抗性
        /// </summary>
        public const string Attr_012 = "12";
        /// <summary>
        /// 属性id 8  实体 穿透抗性
        /// </summary>
        public const string Attr_013 = "13";
        #endregion

        #region 速度相关
        /// <summary>
        /// 属性id 40  实体 移动速度
        /// </summary>
        public const string Attr_40 = "40";
        /// <summary>
        /// 属性id 41  实体 移动加速度
        /// </summary>
        public const string Attr_41 = "41";
        /// <summary>
        /// 属性id 42  实体 旋转速度
        /// </summary>
        public const string Attr_42 = "42";

        /// <summary>
        /// 属性id 51  实体 炮塔旋转速度
        /// </summary>
        public const string Attr_51 = "51";
        /// <summary>
        /// 属性id 52  实体 炮塔旋转加速度
        /// </summary>
        public const string Attr_52 = "52";
        #endregion

        #region 建造相关
        /// <summary>
        /// 属性id 101  实体 建造时间
        /// </summary>
        public const string Attr_101 = "101";
        /// <summary>
        /// 属性id 102  实体 重建时间
        /// </summary>
        public const string Attr_102 = "102";
        /// <summary>
        /// 属性id 103  实体 升级时间
        /// </summary>
        public const string Attr_103 = "103";
        /// <summary>
        /// 属性id 104  实体 存活时间
        /// </summary>
        public const string Attr_104 = "104";
        #endregion

        #region 采集相关
        /// <summary>
        /// 属性id 201  实体 资源数量
        /// </summary>
        public const string Attr_201 = "201";

        /// <summary>
        /// 属性id 202  实体 资源开采效率
        /// </summary>
        public const string Attr_202 = "202";

        /// <summary>
        /// 属性id 203  实体 资源拆解效率
        /// </summary>
        public const string Attr_203 = "203";

        /// <summary>
        /// 属性id 204  实体 拆解范围
        /// </summary>
        public const string Attr_204 = "204";
        #endregion

        #region 攻击属性相关
        /// <summary>
        /// 属性id 301  实体 基础伤害
        /// </summary>
        public const string Attr_301 = "301";

        /// <summary>
        /// 属性id 302  实体 护盾伤害
        /// </summary>
        public const string Attr_302 = "302";

        /// <summary>
        /// 属性id 303  实体 装甲伤害
        /// </summary>
        public const string Attr_303 = "303";

        /// <summary>
        /// 属性id 304  实体 攻击速度
        /// </summary>
        public const string Attr_304 = "304";

        /// <summary>
        /// 属性id 305  实体 预热时间
        /// </summary>
        public const string Attr_305 = "305";

        /// <summary>
        /// 属性id 306  实体 预热攻速上限
        /// </summary>
        public const string Attr_306 = "306";

        /// <summary>
        /// 属性id 307  实体 弹药量
        /// </summary>
        public const string Attr_307 = "307";

        /// <summary>
        /// 属性id 308  实体 持续供弹
        /// </summary>
        public const string Attr_308 = "308";

        /// <summary>
        /// 属性id 309  实体 换弹时间
        /// </summary>
        public const string Attr_309 = "309";

        /// <summary>
        /// 属性id 310  实体 充能时间
        /// </summary>
        public const string Attr_310 = "310";

        /// <summary>
        /// 属性id 311  实体 最远射程
        /// </summary>
        public const string Attr_311 = "311";

        /// <summary>
        /// 属性id 312  实体 可攻击角度
        /// </summary>
        public const string Attr_312 = "312";

        /// <summary>
        /// 属性id 313  实体 开火间隔乘数
        /// </summary>
        public const string Attr_313 = "313";

        /// <summary>
        /// 属性id 314  实体 开火伤害乘数
        /// </summary>
        public const string Attr_314 = "314";
        #endregion

        #region 防御与陷阱属性相关
        /// <summary>
        /// 属性id 401  实体 生产单位建造时间
        /// </summary>
        public const string Attr_401 = "401";

        /// <summary>
        /// 属性id 402  实体 生产单位上限
        /// </summary>
        public const string Attr_402 = "402";

        /// <summary>
        /// 属性id 403  实体 陷阱攻击耐久
        /// </summary>
        public const string Attr_403 = "403";
        #endregion

        #region 后勤相关
        /// <summary>
        /// 属性id 501  实体 工作范围
        /// </summary>
        public const string Attr_501 = "501";

        /// <summary>
        /// 属性id 502  实体 结构修复
        /// </summary>
        public const string Attr_502 = "502";

        /// <summary>
        /// 属性id 503  实体 护盾修复
        /// </summary>
        public const string Attr_503 = "503";

        /// <summary>
        /// 属性id 504  实体 装甲修复
        /// </summary>
        public const string Attr_504 = "504";

        /// <summary>
        /// 属性id 505  实体 伤害提升
        /// </summary>
        public const string Attr_505 = "505";

        /// <summary>
        /// 属性id 506  实体 攻速提升
        /// </summary>
        public const string Attr_506 = "506";

        /// <summary>
        /// 属性id 507  实体 重建提升
        /// </summary>
        public const string Attr_507 = "507";
        #endregion


        #region 攻击效果相关
        /// <summary>
        /// 属性id 601  实体 燃烧耐性
        /// </summary>
        public const string Attr_601 = "601";

        /// <summary>
        /// 属性id 602  实体 燃烧值
        /// </summary>
        public const string Attr_602 = "602";

        /// <summary>
        /// 属性id 603  实体 冰冻耐性
        /// </summary>
        public const string Attr_603 = "603";

        /// <summary>
        /// 属性id 604  实体 冰冻值
        /// </summary>
        public const string Attr_604 = "604";
        #endregion

    }
}
