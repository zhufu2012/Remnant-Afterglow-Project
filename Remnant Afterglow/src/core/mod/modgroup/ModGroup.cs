

using System.Collections.Generic;

namespace Remnant_Afterglow
{
    /// <summary>
    /// mod组
    /// mod组 是mod管理界面中用于记录  模组加载及顺序的类
    /// 
    /// </summary>
    public class ModGroup
    {
        /// <summary>
        /// 组名称
        /// </summary>
        public string group_name = "";

        /// <summary>
        /// mod数量
        /// </summary>
        public int mod_num = 0;

        /// <summary>
        /// 保存时间
        /// </summary>
        public long mod_time = 0;


        public List<ModAllInfo> modAllInfoList;
        public ModGroup()
        {

        }

        public ModGroup(string group_name, List<ModAllInfo> modAllInfos)
        {
            mod_num = modAllInfos.Count;
            modAllInfoList = modAllInfos;
            this.group_name = group_name;
        }

        /// <summary>
        /// 检查该mod组的mod是否还可以使用
        /// </summary>
        /// <returns></returns>
        public bool CheckModGroup()
        {
            List<ModAllInfo> all_mod_list = new List<ModAllInfo>();
            foreach (var k in ModLoadSystem.all_mod_list)
            {
                all_mod_list.Add(k.Value);
            }
            bool IsExist = true;
            for (int i = 0; i < modAllInfoList.Count; i++)//查询mod组中所有mod在 当前所有mod中存在
            {
                ModAllInfo modGroupAllInfo = modAllInfoList[i];
                if (all_mod_list.Find((ModAllInfo allInfo) => { return ModAllInfoEquals(allInfo, modGroupAllInfo); }) == null)//没查到
                    IsExist = false;
            }
            return IsExist;
        }

        /// <summary>
        /// 获取还可以使用的mod列表，并且该列表按照顺序排
        /// </summary>
        /// <returns></returns>
        public List<ModAllInfo> GetCanModAllInfoList()
        {
            List<ModAllInfo> all_mod_list = new List<ModAllInfo>();
            foreach (var k in ModLoadSystem.all_mod_list)
            {
                all_mod_list.Add(k.Value);
            }
            List<ModAllInfo> NewModAllInfoList = new List<ModAllInfo>();
            for (int i = 0; i < modAllInfoList.Count; i++)//查询mod组中所有mod在 当前所有mod中存在
            {
                ModAllInfo modGroupAllInfo = modAllInfoList[i];
                if (all_mod_list.Find((ModAllInfo allInfo) => { return ModAllInfoEquals(allInfo, modGroupAllInfo); }) != null)//没查到
                    NewModAllInfoList.Add(modGroupAllInfo);

            }
            return NewModAllInfoList;
        }



        /// <summary>
        /// 检查该mod是否在mod组中是否存在
        /// </summary>
        /// <returns></returns>
        public bool IsExist(ModAllInfo modAllInfo)
        {
            return modAllInfoList.Find((ModAllInfo allInfo) =>
                {
                    return ModAllInfoEquals(allInfo, modAllInfo);
                    //文件夹同名并且mod名称同名才行
                }) == null;
        }



        /// <summary>
        /// 获取mod组总数据
        /// </summary>
        /// <returns></returns>
        public static List<ModGroup> GetModGroupList()
        {
            List<ModGroup> data = FileUtils.ReadObjectSmartParam<List<ModGroup>>(PathConstant.GetPathUser(PathConstant.MOD_LOAD_PAHT_GROUP));
            return data;
        }

        /// <summary>
        /// 保存到mod组数据
        /// </summary>
        /// <param name="data"></param>
        public static void SaveModGroupList(List<ModGroup> data)
        {
            FileUtils.WriteObjectSmartParam(PathConstant.GetPathUser(PathConstant.MOD_LOAD_PAHT_GROUP), data);
        }

        /// <summary>
        /// 查询相同mod组名称的mod组，没有返回null
        /// </summary>
        /// <returns></returns>
        public static ModGroup? FindModGroup(string group_name, List<ModGroup> groupList)
        {
            return groupList.Find((ModGroup modGroup) => { return modGroup.group_name == group_name; });
        }


        /// <summary>
        /// 检测是否相同  文件夹同名并且mod名称同名才行-祝福注释-mod组
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public bool ModAllInfoEquals(ModAllInfo mod1, ModAllInfo mod2)
        {
            return mod1.file_name == mod2.file_name && mod1.modInfo.Name == mod2.modInfo.Name;
        }

        /// <summary>
        /// 检测是否相同
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public override bool Equals(object obj)
        {


            return base.Equals(obj);
        }

    }
}
