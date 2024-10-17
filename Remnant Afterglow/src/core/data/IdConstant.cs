namespace Remnant_Afterglow
{

    //id类型，生成使用 IdGenerator.Generate(IdConstant.ID_TYPE_DATABASE_MAX)
    public static class IdConstant
    {
        /// <summary>
        /// id生成器的间隔保存时间-帧
        /// </summary>
        public static int SaveIdGeneration = 60;


        #region 仅存储 1-40的， 41-63的id类型 仅存内存，游戏重启就没了
        /// <summary>
        /// 单位唯一id
        /// </summary>
        public static int ID_TYPE_UNIT = 1;

        /// <summary>
        /// 炮塔唯一id
        /// </summary>
        public static int ID_TYPE_TOWER = 2;

        /// <summary>
        /// 建筑唯一id
        /// </summary>
        public static int ID_TYPE_BUILD = 3;

        /// <summary>
        /// 子弹唯一id
        /// </summary>
        public static int ID_TYPE_BULLET = 4;



        /// <summary>
        /// 道具唯一id
        /// </summary>
        public static int ID_TYPE_ITEM = 30;
        /// <summary>
        /// 最大的存储数据库的id 类型
        /// </summary>
        public static int ID_TYPE_DATABASE_MAX = 40;
        #endregion


        //////////////////////////////////////////不存储，仅保存内存，游戏重启就重新计算（可以用于防止mod顺序等修改）///////////////////////////////////////////////


        //随机生成地图中使用的区域类型 
        public static int ID_TYPE_REGION = 60;


        public static int ID_TYPE_MAX = 63;
    }
}