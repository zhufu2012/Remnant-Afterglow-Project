//模组信息
using GameLog;
using System;

namespace Remnant_Afterglow
{

    //所有mod数据，不只包含作者的mod.info文件
    public class ModAllInfo
    {
        /// <summary>
        /// mod本身数据
        /// </summary>
        public ModInfo modInfo;
        /// <summary>
        /// mod文件夹
        /// </summary>
        public string file_name;

        #region 延申数据
        /// <summary>
        /// mod列表
        /// </summary>
        public string mod_path;


        #endregion




        public ModAllInfo(ModInfo modInfo, string file_name)
        {
            this.modInfo = modInfo;
            this.file_name = file_name;
            string img1 = PathConstant.GetPathUser(PathConstant.MOD_LOAD_PATH_USER);
            mod_path = img1 + file_name+"/";
        }
    }
}