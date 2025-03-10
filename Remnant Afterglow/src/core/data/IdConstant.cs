namespace Remnant_Afterglow
{

    //id类型，生成使用 IdGenerator.Generate(IdConstant.ID_TYPE_DATABASE_MAX)
    public static class IdConstant
    {
        /// <summary>
        /// id生成器的间隔保存时间-帧
        /// </summary>
        public const int SaveIdGeneration = 60;


        #region 仅存储 1-40的， 41-63的id类型 仅存内存，游戏重启就没了
        /// <summary>
        /// 单位唯一id 实体
        /// </summary>
        public const int ID_TYPE_UNIT = 1;

        /// <summary>
        /// 炮塔唯一id 实体
        /// </summary>
        public const int ID_TYPE_TOWER = 2;

        /// <summary>
        /// 建筑唯一id 实体
        /// </summary>
        public const int ID_TYPE_BUILD = 3;

        /// <summary>
        /// 无人机唯一id 实体
        /// </summary>
        public const int ID_TYPE_WORKER = 4;

        /// <summary>
        /// 道具唯一id
        /// </summary>
        public const int ID_TYPE_ITEM = 30;
        /// <summary>
        /// 最大的存储数据库的id 类型
        /// </summary>
        public const int ID_TYPE_DATABASE_MAX = 40;
        #endregion


        /////////////不存储，仅保存内存，游戏重启就重新计算（可以用于防止mod顺序等修改）///////////////
        /// <summary>
        /// Buff类型的唯一id
        /// </summary>
        public const int ID_TYPE_BUFF = 41;

        /// <summary>
        /// 随机生成地图中使用的区域类型
        /// </summary>
        public const int ID_TYPE_REGION = 60;

        public const int ID_TYPE_MAX = 63;
    }
}