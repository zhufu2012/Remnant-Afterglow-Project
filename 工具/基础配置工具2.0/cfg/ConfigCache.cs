using System.Collections.Generic;
namespace Remnant_Afterglow
{    
    /// <summary>
    /// 自动生成的配置缓存代码，请不要手动修改
    /// </summary>
    public static partial class ConfigCache
    {
        /// <summary>
        /// 提前加载所有界面基础配置配置缓存
        /// </summary>
        public static void LoadOtherCache()
        {
            LoadViewBase();
            LoadUpdateLog();
            LoadAttainmentPage();
            LoadAttainmentBase();
            LoadScienceRange();
            LoadScienceBase();
            LoadScienceData();
            LoadItemDeployData();
            LoadCorePlugDeployData();
            LoadScienceDeployData();
            LoadConfigCover();
            LoadConfigCall();
            LoadGlobalConfigInt();
            LoadGlobalConfigStr();
            LoadGlobalConfigFloat();
            LoadGlobalConfigList();
            LoadGlobalConfigPng();
            LoadFunctionTemplate();
            LoadCameraBase();
            LoadCameraAssemblyBase();
            LoadAnimaUnit();
            LoadAnimaTower();
            LoadAnimaBuild();
            LoadAnimaWeapon();
            LoadAnimaBullet();
            LoadSequenceMapBase();
            LoadSpeciallyEffect();
            LoadGenerateBottomMap();
            LoadMapMaterial();
            LoadMapExtraDraw();
            LoadGenerateBigStruct();
            LoadMapWall();
            LoadMapPassType();
            LoadMassif();
            LoadBigMapBase();
            LoadBigMapBigCell();
            LoadBigMapCellLogic();
            LoadBigMapEvent();
            LoadChapterBase();
            LoadChapterCopyBase();
            LoadCopyBrush();
            LoadBrushPoint();
            LoadWaveBase();
            LoadChapterCopyUI();
            LoadUnitData();
            LoadBulletData();
            LoadBaseObjectShow();
            LoadObjectBottomBar();
            LoadObjectSideBar();
            LoadAttributeBase();
            LoadAttributeTemplate();
            LoadAttributeData();
            LoadAttrCalculate();
            LoadAttrDependency();
            LoadBuildData();
            LoadBuildRule();
            LoadWeaponData();
            LoadWeaponBase();
            LoadTowerData();
            LoadMapBuildLable();
            LoadMapBuildList();
            LoadBuff();
            LoadCampBase();
            LoadGameDiffBase();
            LoadBagData();
            LoadMoneyBase();
            LoadItemData();
            LoadErrorBase();
        }


        #region Ui界面配置
        /// <summary>
        /// 界面基础配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ViewBase> ViewBase_Cache = new Dictionary<string, ViewBase>();
        /// <summary>
        /// 提前加载所有界面基础配置配置缓存
        /// </summary>
        public static void LoadViewBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ViewBase);
            foreach (var val in cfg_dict)
            {
                ViewBase data = new ViewBase(val.Value);
                data.InitData2();
                ViewBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的界面基础配置基础配置缓存
        /// </summary>
        public static ViewBase GetViewBase(string cfgId)
        {
            if (!ViewBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ViewBase(cfgId);
                data.InitData2();
                ViewBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ViewBase GetViewBase(int cfgId)
        {
            if (!ViewBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ViewBase(cfgId);
                data.InitData2();
                ViewBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有界面基础配置数据
        /// </summary>
        public static List<ViewBase> GetAllViewBase()
        {
            List<ViewBase> list = new List<ViewBase>();
            foreach (var val in ViewBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 主界面更新日志
        /// <summary>
        /// 更新日志配置缓存
        /// </summary>
        private static readonly Dictionary<string, UpdateLog> UpdateLog_Cache = new Dictionary<string, UpdateLog>();
        /// <summary>
        /// 提前加载所有更新日志配置缓存
        /// </summary>
        public static void LoadUpdateLog()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_UpdateLog);
            foreach (var val in cfg_dict)
            {
                UpdateLog data = new UpdateLog(val.Value);
                data.InitData2();
                UpdateLog_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的更新日志基础配置缓存
        /// </summary>
        public static UpdateLog GetUpdateLog(string cfgId)
        {
            if (!UpdateLog_Cache.TryGetValue(cfgId, out var data))
            {
                data = new UpdateLog(cfgId);
                data.InitData2();
                UpdateLog_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static UpdateLog GetUpdateLog(int cfgId)
        {
            if (!UpdateLog_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new UpdateLog(cfgId);
                data.InitData2();
                UpdateLog_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有更新日志数据
        /// </summary>
        public static List<UpdateLog> GetAllUpdateLog()
        {
            List<UpdateLog> list = new List<UpdateLog>();
            foreach (var val in UpdateLog_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 数据库界面及成就相关配置
        /// <summary>
        /// 数据库成就分页配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttainmentPage> AttainmentPage_Cache = new Dictionary<string, AttainmentPage>();
        /// <summary>
        /// 提前加载所有数据库成就分页配置缓存
        /// </summary>
        public static void LoadAttainmentPage()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttainmentPage);
            foreach (var val in cfg_dict)
            {
                AttainmentPage data = new AttainmentPage(val.Value);
                data.InitData2();
                AttainmentPage_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的数据库成就分页基础配置缓存
        /// </summary>
        public static AttainmentPage GetAttainmentPage(string cfgId)
        {
            if (!AttainmentPage_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttainmentPage(cfgId);
                data.InitData2();
                AttainmentPage_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttainmentPage GetAttainmentPage(int cfgId)
        {
            if (!AttainmentPage_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttainmentPage(cfgId);
                data.InitData2();
                AttainmentPage_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有数据库成就分页数据
        /// </summary>
        public static List<AttainmentPage> GetAllAttainmentPage()
        {
            List<AttainmentPage> list = new List<AttainmentPage>();
            foreach (var val in AttainmentPage_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 数据库成就相关配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttainmentBase> AttainmentBase_Cache = new Dictionary<string, AttainmentBase>();
        /// <summary>
        /// 提前加载所有数据库成就相关配置配置缓存
        /// </summary>
        public static void LoadAttainmentBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttainmentBase);
            foreach (var val in cfg_dict)
            {
                AttainmentBase data = new AttainmentBase(val.Value);
                data.InitData2();
                AttainmentBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的数据库成就相关配置基础配置缓存
        /// </summary>
        public static AttainmentBase GetAttainmentBase(string cfgId)
        {
            if (!AttainmentBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttainmentBase(cfgId);
                data.InitData2();
                AttainmentBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttainmentBase GetAttainmentBase(int cfgId)
        {
            if (!AttainmentBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttainmentBase(cfgId);
                data.InitData2();
                AttainmentBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有数据库成就相关配置数据
        /// </summary>
        public static List<AttainmentBase> GetAllAttainmentBase()
        {
            List<AttainmentBase> list = new List<AttainmentBase>();
            foreach (var val in AttainmentBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 科技树解锁界面相关配置
        /// <summary>
        /// 科技范围配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceRange> ScienceRange_Cache = new Dictionary<string, ScienceRange>();
        /// <summary>
        /// 提前加载所有科技范围配置配置缓存
        /// </summary>
        public static void LoadScienceRange()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceRange);
            foreach (var val in cfg_dict)
            {
                ScienceRange data = new ScienceRange(val.Value);
                data.InitData2();
                ScienceRange_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的科技范围配置基础配置缓存
        /// </summary>
        public static ScienceRange GetScienceRange(string cfgId)
        {
            if (!ScienceRange_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ScienceRange(cfgId);
                data.InitData2();
                ScienceRange_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ScienceRange GetScienceRange(int cfgId)
        {
            if (!ScienceRange_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ScienceRange(cfgId);
                data.InitData2();
                ScienceRange_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有科技范围配置数据
        /// </summary>
        public static List<ScienceRange> GetAllScienceRange()
        {
            List<ScienceRange> list = new List<ScienceRange>();
            foreach (var val in ScienceRange_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 科技基础显示配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceBase> ScienceBase_Cache = new Dictionary<string, ScienceBase>();
        /// <summary>
        /// 提前加载所有科技基础显示配置配置缓存
        /// </summary>
        public static void LoadScienceBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceBase);
            foreach (var val in cfg_dict)
            {
                ScienceBase data = new ScienceBase(val.Value);
                data.InitData2();
                ScienceBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的科技基础显示配置基础配置缓存
        /// </summary>
        public static ScienceBase GetScienceBase(string cfgId)
        {
            if (!ScienceBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ScienceBase(cfgId);
                data.InitData2();
                ScienceBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ScienceBase GetScienceBase(int cfgId)
        {
            if (!ScienceBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ScienceBase(cfgId);
                data.InitData2();
                ScienceBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有科技基础显示配置数据
        /// </summary>
        public static List<ScienceBase> GetAllScienceBase()
        {
            List<ScienceBase> list = new List<ScienceBase>();
            foreach (var val in ScienceBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 科技激活相关数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceData> ScienceData_Cache = new Dictionary<string, ScienceData>();
        /// <summary>
        /// 提前加载所有科技激活相关数据配置缓存
        /// </summary>
        public static void LoadScienceData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceData);
            foreach (var val in cfg_dict)
            {
                ScienceData data = new ScienceData(val.Value);
                data.InitData2();
                ScienceData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的科技激活相关数据基础配置缓存
        /// </summary>
        public static ScienceData GetScienceData(string cfgId)
        {
            if (!ScienceData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ScienceData(cfgId);
                data.InitData2();
                ScienceData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ScienceData GetScienceData(int cfgId)
        {
            if (!ScienceData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ScienceData(cfgId);
                data.InitData2();
                ScienceData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有科技激活相关数据数据
        /// </summary>
        public static List<ScienceData> GetAllScienceData()
        {
            List<ScienceData> list = new List<ScienceData>();
            foreach (var val in ScienceData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 配置界面相关
        /// <summary>
        /// 道具配置界面数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ItemDeployData> ItemDeployData_Cache = new Dictionary<string, ItemDeployData>();
        /// <summary>
        /// 提前加载所有道具配置界面数据配置缓存
        /// </summary>
        public static void LoadItemDeployData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ItemDeployData);
            foreach (var val in cfg_dict)
            {
                ItemDeployData data = new ItemDeployData(val.Value);
                data.InitData2();
                ItemDeployData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的道具配置界面数据基础配置缓存
        /// </summary>
        public static ItemDeployData GetItemDeployData(string cfgId)
        {
            if (!ItemDeployData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ItemDeployData(cfgId);
                data.InitData2();
                ItemDeployData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ItemDeployData GetItemDeployData(int cfgId)
        {
            if (!ItemDeployData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ItemDeployData(cfgId);
                data.InitData2();
                ItemDeployData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有道具配置界面数据数据
        /// </summary>
        public static List<ItemDeployData> GetAllItemDeployData()
        {
            List<ItemDeployData> list = new List<ItemDeployData>();
            foreach (var val in ItemDeployData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 核心插件配置数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CorePlugDeployData> CorePlugDeployData_Cache = new Dictionary<string, CorePlugDeployData>();
        /// <summary>
        /// 提前加载所有核心插件配置数据配置缓存
        /// </summary>
        public static void LoadCorePlugDeployData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_CorePlugDeployData);
            foreach (var val in cfg_dict)
            {
                CorePlugDeployData data = new CorePlugDeployData(val.Value);
                data.InitData2();
                CorePlugDeployData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的核心插件配置数据基础配置缓存
        /// </summary>
        public static CorePlugDeployData GetCorePlugDeployData(string cfgId)
        {
            if (!CorePlugDeployData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new CorePlugDeployData(cfgId);
                data.InitData2();
                CorePlugDeployData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static CorePlugDeployData GetCorePlugDeployData(int cfgId)
        {
            if (!CorePlugDeployData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new CorePlugDeployData(cfgId);
                data.InitData2();
                CorePlugDeployData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有核心插件配置数据数据
        /// </summary>
        public static List<CorePlugDeployData> GetAllCorePlugDeployData()
        {
            List<CorePlugDeployData> list = new List<CorePlugDeployData>();
            foreach (var val in CorePlugDeployData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 科技配置数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceDeployData> ScienceDeployData_Cache = new Dictionary<string, ScienceDeployData>();
        /// <summary>
        /// 提前加载所有科技配置数据配置缓存
        /// </summary>
        public static void LoadScienceDeployData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceDeployData);
            foreach (var val in cfg_dict)
            {
                ScienceDeployData data = new ScienceDeployData(val.Value);
                data.InitData2();
                ScienceDeployData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的科技配置数据基础配置缓存
        /// </summary>
        public static ScienceDeployData GetScienceDeployData(string cfgId)
        {
            if (!ScienceDeployData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ScienceDeployData(cfgId);
                data.InitData2();
                ScienceDeployData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ScienceDeployData GetScienceDeployData(int cfgId)
        {
            if (!ScienceDeployData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ScienceDeployData(cfgId);
                data.InitData2();
                ScienceDeployData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有科技配置数据数据
        /// </summary>
        public static List<ScienceDeployData> GetAllScienceDeployData()
        {
            List<ScienceDeployData> list = new List<ScienceDeployData>();
            foreach (var val in ScienceDeployData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 配置特殊功能表
        /// <summary>
        /// 配置覆盖关系表配置缓存
        /// </summary>
        private static readonly Dictionary<string, ConfigCover> ConfigCover_Cache = new Dictionary<string, ConfigCover>();
        /// <summary>
        /// 提前加载所有配置覆盖关系表配置缓存
        /// </summary>
        public static void LoadConfigCover()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ConfigCover);
            foreach (var val in cfg_dict)
            {
                ConfigCover data = new ConfigCover(val.Value);
                data.InitData2();
                ConfigCover_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的配置覆盖关系表基础配置缓存
        /// </summary>
        public static ConfigCover GetConfigCover(string cfgId)
        {
            if (!ConfigCover_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ConfigCover(cfgId);
                data.InitData2();
                ConfigCover_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ConfigCover GetConfigCover(int cfgId)
        {
            if (!ConfigCover_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ConfigCover(cfgId);
                data.InitData2();
                ConfigCover_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有配置覆盖关系表数据
        /// </summary>
        public static List<ConfigCover> GetAllConfigCover()
        {
            List<ConfigCover> list = new List<ConfigCover>();
            foreach (var val in ConfigCover_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 配置调用关系表配置缓存
        /// </summary>
        private static readonly Dictionary<string, ConfigCall> ConfigCall_Cache = new Dictionary<string, ConfigCall>();
        /// <summary>
        /// 提前加载所有配置调用关系表配置缓存
        /// </summary>
        public static void LoadConfigCall()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ConfigCall);
            foreach (var val in cfg_dict)
            {
                ConfigCall data = new ConfigCall(val.Value);
                data.InitData2();
                ConfigCall_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的配置调用关系表基础配置缓存
        /// </summary>
        public static ConfigCall GetConfigCall(string cfgId)
        {
            if (!ConfigCall_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ConfigCall(cfgId);
                data.InitData2();
                ConfigCall_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ConfigCall GetConfigCall(int cfgId)
        {
            if (!ConfigCall_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ConfigCall(cfgId);
                data.InitData2();
                ConfigCall_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有配置调用关系表数据
        /// </summary>
        public static List<ConfigCall> GetAllConfigCall()
        {
            List<ConfigCall> list = new List<ConfigCall>();
            foreach (var val in ConfigCall_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 默认配置表
        /// <summary>
        /// 全局配置Int数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigInt> GlobalConfigInt_Cache = new Dictionary<string, GlobalConfigInt>();
        /// <summary>
        /// 提前加载所有全局配置Int数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigInt()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigInt);
            foreach (var val in cfg_dict)
            {
                GlobalConfigInt data = new GlobalConfigInt(val.Value);
                data.InitData2();
                GlobalConfigInt_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的全局配置Int数据基础配置缓存
        /// </summary>
        public static GlobalConfigInt GetGlobalConfigInt(string cfgId)
        {
            if (!GlobalConfigInt_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GlobalConfigInt(cfgId);
                data.InitData2();
                GlobalConfigInt_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GlobalConfigInt GetGlobalConfigInt(int cfgId)
        {
            if (!GlobalConfigInt_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GlobalConfigInt(cfgId);
                data.InitData2();
                GlobalConfigInt_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有全局配置Int数据数据
        /// </summary>
        public static List<GlobalConfigInt> GetAllGlobalConfigInt()
        {
            List<GlobalConfigInt> list = new List<GlobalConfigInt>();
            foreach (var val in GlobalConfigInt_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// Str数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigStr> GlobalConfigStr_Cache = new Dictionary<string, GlobalConfigStr>();
        /// <summary>
        /// 提前加载所有Str数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigStr()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigStr);
            foreach (var val in cfg_dict)
            {
                GlobalConfigStr data = new GlobalConfigStr(val.Value);
                data.InitData2();
                GlobalConfigStr_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的Str数据基础配置缓存
        /// </summary>
        public static GlobalConfigStr GetGlobalConfigStr(string cfgId)
        {
            if (!GlobalConfigStr_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GlobalConfigStr(cfgId);
                data.InitData2();
                GlobalConfigStr_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GlobalConfigStr GetGlobalConfigStr(int cfgId)
        {
            if (!GlobalConfigStr_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GlobalConfigStr(cfgId);
                data.InitData2();
                GlobalConfigStr_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有Str数据数据
        /// </summary>
        public static List<GlobalConfigStr> GetAllGlobalConfigStr()
        {
            List<GlobalConfigStr> list = new List<GlobalConfigStr>();
            foreach (var val in GlobalConfigStr_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// float数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigFloat> GlobalConfigFloat_Cache = new Dictionary<string, GlobalConfigFloat>();
        /// <summary>
        /// 提前加载所有float数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigFloat()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigFloat);
            foreach (var val in cfg_dict)
            {
                GlobalConfigFloat data = new GlobalConfigFloat(val.Value);
                data.InitData2();
                GlobalConfigFloat_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的float数据基础配置缓存
        /// </summary>
        public static GlobalConfigFloat GetGlobalConfigFloat(string cfgId)
        {
            if (!GlobalConfigFloat_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GlobalConfigFloat(cfgId);
                data.InitData2();
                GlobalConfigFloat_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GlobalConfigFloat GetGlobalConfigFloat(int cfgId)
        {
            if (!GlobalConfigFloat_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GlobalConfigFloat(cfgId);
                data.InitData2();
                GlobalConfigFloat_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有float数据数据
        /// </summary>
        public static List<GlobalConfigFloat> GetAllGlobalConfigFloat()
        {
            List<GlobalConfigFloat> list = new List<GlobalConfigFloat>();
            foreach (var val in GlobalConfigFloat_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// List数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigList> GlobalConfigList_Cache = new Dictionary<string, GlobalConfigList>();
        /// <summary>
        /// 提前加载所有List数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigList()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigList);
            foreach (var val in cfg_dict)
            {
                GlobalConfigList data = new GlobalConfigList(val.Value);
                data.InitData2();
                GlobalConfigList_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的List数据基础配置缓存
        /// </summary>
        public static GlobalConfigList GetGlobalConfigList(string cfgId)
        {
            if (!GlobalConfigList_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GlobalConfigList(cfgId);
                data.InitData2();
                GlobalConfigList_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GlobalConfigList GetGlobalConfigList(int cfgId)
        {
            if (!GlobalConfigList_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GlobalConfigList(cfgId);
                data.InitData2();
                GlobalConfigList_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有List数据数据
        /// </summary>
        public static List<GlobalConfigList> GetAllGlobalConfigList()
        {
            List<GlobalConfigList> list = new List<GlobalConfigList>();
            foreach (var val in GlobalConfigList_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// Png数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigPng> GlobalConfigPng_Cache = new Dictionary<string, GlobalConfigPng>();
        /// <summary>
        /// 提前加载所有Png数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigPng()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigPng);
            foreach (var val in cfg_dict)
            {
                GlobalConfigPng data = new GlobalConfigPng(val.Value);
                data.InitData2();
                GlobalConfigPng_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的Png数据基础配置缓存
        /// </summary>
        public static GlobalConfigPng GetGlobalConfigPng(string cfgId)
        {
            if (!GlobalConfigPng_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GlobalConfigPng(cfgId);
                data.InitData2();
                GlobalConfigPng_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GlobalConfigPng GetGlobalConfigPng(int cfgId)
        {
            if (!GlobalConfigPng_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GlobalConfigPng(cfgId);
                data.InitData2();
                GlobalConfigPng_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有Png数据数据
        /// </summary>
        public static List<GlobalConfigPng> GetAllGlobalConfigPng()
        {
            List<GlobalConfigPng> list = new List<GlobalConfigPng>();
            foreach (var val in GlobalConfigPng_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 函数模板
        /// <summary>
        /// 函数模板配置缓存
        /// </summary>
        private static readonly Dictionary<string, FunctionTemplate> FunctionTemplate_Cache = new Dictionary<string, FunctionTemplate>();
        /// <summary>
        /// 提前加载所有函数模板配置缓存
        /// </summary>
        public static void LoadFunctionTemplate()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_FunctionTemplate);
            foreach (var val in cfg_dict)
            {
                FunctionTemplate data = new FunctionTemplate(val.Value);
                data.InitData2();
                FunctionTemplate_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的函数模板基础配置缓存
        /// </summary>
        public static FunctionTemplate GetFunctionTemplate(string cfgId)
        {
            if (!FunctionTemplate_Cache.TryGetValue(cfgId, out var data))
            {
                data = new FunctionTemplate(cfgId);
                data.InitData2();
                FunctionTemplate_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static FunctionTemplate GetFunctionTemplate(int cfgId)
        {
            if (!FunctionTemplate_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new FunctionTemplate(cfgId);
                data.InitData2();
                FunctionTemplate_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有函数模板数据
        /// </summary>
        public static List<FunctionTemplate> GetAllFunctionTemplate()
        {
            List<FunctionTemplate> list = new List<FunctionTemplate>();
            foreach (var val in FunctionTemplate_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 噪声
        #endregion
        #region 相机
        /// <summary>
        /// 相机基本数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CameraBase> CameraBase_Cache = new Dictionary<string, CameraBase>();
        /// <summary>
        /// 提前加载所有相机基本数据配置缓存
        /// </summary>
        public static void LoadCameraBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_CameraBase);
            foreach (var val in cfg_dict)
            {
                CameraBase data = new CameraBase(val.Value);
                data.InitData2();
                CameraBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的相机基本数据基础配置缓存
        /// </summary>
        public static CameraBase GetCameraBase(string cfgId)
        {
            if (!CameraBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new CameraBase(cfgId);
                data.InitData2();
                CameraBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static CameraBase GetCameraBase(int cfgId)
        {
            if (!CameraBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new CameraBase(cfgId);
                data.InitData2();
                CameraBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有相机基本数据数据
        /// </summary>
        public static List<CameraBase> GetAllCameraBase()
        {
            List<CameraBase> list = new List<CameraBase>();
            foreach (var val in CameraBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 相机组件表配置缓存
        /// </summary>
        private static readonly Dictionary<string, CameraAssemblyBase> CameraAssemblyBase_Cache = new Dictionary<string, CameraAssemblyBase>();
        /// <summary>
        /// 提前加载所有相机组件表配置缓存
        /// </summary>
        public static void LoadCameraAssemblyBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_CameraAssemblyBase);
            foreach (var val in cfg_dict)
            {
                CameraAssemblyBase data = new CameraAssemblyBase(val.Value);
                data.InitData2();
                CameraAssemblyBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的相机组件表基础配置缓存
        /// </summary>
        public static CameraAssemblyBase GetCameraAssemblyBase(string cfgId)
        {
            if (!CameraAssemblyBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new CameraAssemblyBase(cfgId);
                data.InitData2();
                CameraAssemblyBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static CameraAssemblyBase GetCameraAssemblyBase(int cfgId)
        {
            if (!CameraAssemblyBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new CameraAssemblyBase(cfgId);
                data.InitData2();
                CameraAssemblyBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有相机组件表数据
        /// </summary>
        public static List<CameraAssemblyBase> GetAllCameraAssemblyBase()
        {
            List<CameraAssemblyBase> list = new List<CameraAssemblyBase>();
            foreach (var val in CameraAssemblyBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 帧动画
        /// <summary>
        /// 单位帧动画配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaUnit> AnimaUnit_Cache = new Dictionary<string, AnimaUnit>();
        /// <summary>
        /// 提前加载所有单位帧动画配置配置缓存
        /// </summary>
        public static void LoadAnimaUnit()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaUnit);
            foreach (var val in cfg_dict)
            {
                AnimaUnit data = new AnimaUnit(val.Value);
                data.InitData2();
                AnimaUnit_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的单位帧动画配置基础配置缓存
        /// </summary>
        public static AnimaUnit GetAnimaUnit(string cfgId)
        {
            if (!AnimaUnit_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AnimaUnit(cfgId);
                data.InitData2();
                AnimaUnit_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AnimaUnit GetAnimaUnit(int cfgId)
        {
            if (!AnimaUnit_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AnimaUnit(cfgId);
                data.InitData2();
                AnimaUnit_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位帧动画配置数据
        /// </summary>
        public static List<AnimaUnit> GetAllAnimaUnit()
        {
            List<AnimaUnit> list = new List<AnimaUnit>();
            foreach (var val in AnimaUnit_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 炮塔动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaTower> AnimaTower_Cache = new Dictionary<string, AnimaTower>();
        /// <summary>
        /// 提前加载所有炮塔动画配置缓存
        /// </summary>
        public static void LoadAnimaTower()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaTower);
            foreach (var val in cfg_dict)
            {
                AnimaTower data = new AnimaTower(val.Value);
                data.InitData2();
                AnimaTower_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的炮塔动画基础配置缓存
        /// </summary>
        public static AnimaTower GetAnimaTower(string cfgId)
        {
            if (!AnimaTower_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AnimaTower(cfgId);
                data.InitData2();
                AnimaTower_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AnimaTower GetAnimaTower(int cfgId)
        {
            if (!AnimaTower_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AnimaTower(cfgId);
                data.InitData2();
                AnimaTower_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有炮塔动画数据
        /// </summary>
        public static List<AnimaTower> GetAllAnimaTower()
        {
            List<AnimaTower> list = new List<AnimaTower>();
            foreach (var val in AnimaTower_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 建筑动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaBuild> AnimaBuild_Cache = new Dictionary<string, AnimaBuild>();
        /// <summary>
        /// 提前加载所有建筑动画配置缓存
        /// </summary>
        public static void LoadAnimaBuild()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaBuild);
            foreach (var val in cfg_dict)
            {
                AnimaBuild data = new AnimaBuild(val.Value);
                data.InitData2();
                AnimaBuild_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建筑动画基础配置缓存
        /// </summary>
        public static AnimaBuild GetAnimaBuild(string cfgId)
        {
            if (!AnimaBuild_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AnimaBuild(cfgId);
                data.InitData2();
                AnimaBuild_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AnimaBuild GetAnimaBuild(int cfgId)
        {
            if (!AnimaBuild_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AnimaBuild(cfgId);
                data.InitData2();
                AnimaBuild_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建筑动画数据
        /// </summary>
        public static List<AnimaBuild> GetAllAnimaBuild()
        {
            List<AnimaBuild> list = new List<AnimaBuild>();
            foreach (var val in AnimaBuild_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 武器动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaWeapon> AnimaWeapon_Cache = new Dictionary<string, AnimaWeapon>();
        /// <summary>
        /// 提前加载所有武器动画配置缓存
        /// </summary>
        public static void LoadAnimaWeapon()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaWeapon);
            foreach (var val in cfg_dict)
            {
                AnimaWeapon data = new AnimaWeapon(val.Value);
                data.InitData2();
                AnimaWeapon_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的武器动画基础配置缓存
        /// </summary>
        public static AnimaWeapon GetAnimaWeapon(string cfgId)
        {
            if (!AnimaWeapon_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AnimaWeapon(cfgId);
                data.InitData2();
                AnimaWeapon_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AnimaWeapon GetAnimaWeapon(int cfgId)
        {
            if (!AnimaWeapon_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AnimaWeapon(cfgId);
                data.InitData2();
                AnimaWeapon_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有武器动画数据
        /// </summary>
        public static List<AnimaWeapon> GetAllAnimaWeapon()
        {
            List<AnimaWeapon> list = new List<AnimaWeapon>();
            foreach (var val in AnimaWeapon_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 子弹动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaBullet> AnimaBullet_Cache = new Dictionary<string, AnimaBullet>();
        /// <summary>
        /// 提前加载所有子弹动画配置缓存
        /// </summary>
        public static void LoadAnimaBullet()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaBullet);
            foreach (var val in cfg_dict)
            {
                AnimaBullet data = new AnimaBullet(val.Value);
                data.InitData2();
                AnimaBullet_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹动画基础配置缓存
        /// </summary>
        public static AnimaBullet GetAnimaBullet(string cfgId)
        {
            if (!AnimaBullet_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AnimaBullet(cfgId);
                data.InitData2();
                AnimaBullet_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AnimaBullet GetAnimaBullet(int cfgId)
        {
            if (!AnimaBullet_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AnimaBullet(cfgId);
                data.InitData2();
                AnimaBullet_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹动画数据
        /// </summary>
        public static List<AnimaBullet> GetAllAnimaBullet()
        {
            List<AnimaBullet> list = new List<AnimaBullet>();
            foreach (var val in AnimaBullet_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 序列图
        /// <summary>
        /// 序列图配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, SequenceMapBase> SequenceMapBase_Cache = new Dictionary<string, SequenceMapBase>();
        /// <summary>
        /// 提前加载所有序列图配置配置缓存
        /// </summary>
        public static void LoadSequenceMapBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_SequenceMapBase);
            foreach (var val in cfg_dict)
            {
                SequenceMapBase data = new SequenceMapBase(val.Value);
                data.InitData2();
                SequenceMapBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的序列图配置基础配置缓存
        /// </summary>
        public static SequenceMapBase GetSequenceMapBase(string cfgId)
        {
            if (!SequenceMapBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new SequenceMapBase(cfgId);
                data.InitData2();
                SequenceMapBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static SequenceMapBase GetSequenceMapBase(int cfgId)
        {
            if (!SequenceMapBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new SequenceMapBase(cfgId);
                data.InitData2();
                SequenceMapBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有序列图配置数据
        /// </summary>
        public static List<SequenceMapBase> GetAllSequenceMapBase()
        {
            List<SequenceMapBase> list = new List<SequenceMapBase>();
            foreach (var val in SequenceMapBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 特效
        /// <summary>
        /// 特效配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, SpeciallyEffect> SpeciallyEffect_Cache = new Dictionary<string, SpeciallyEffect>();
        /// <summary>
        /// 提前加载所有特效配置配置缓存
        /// </summary>
        public static void LoadSpeciallyEffect()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_SpeciallyEffect);
            foreach (var val in cfg_dict)
            {
                SpeciallyEffect data = new SpeciallyEffect(val.Value);
                data.InitData2();
                SpeciallyEffect_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的特效配置基础配置缓存
        /// </summary>
        public static SpeciallyEffect GetSpeciallyEffect(string cfgId)
        {
            if (!SpeciallyEffect_Cache.TryGetValue(cfgId, out var data))
            {
                data = new SpeciallyEffect(cfgId);
                data.InitData2();
                SpeciallyEffect_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static SpeciallyEffect GetSpeciallyEffect(int cfgId)
        {
            if (!SpeciallyEffect_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new SpeciallyEffect(cfgId);
                data.InitData2();
                SpeciallyEffect_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有特效配置数据
        /// </summary>
        public static List<SpeciallyEffect> GetAllSpeciallyEffect()
        {
            List<SpeciallyEffect> list = new List<SpeciallyEffect>();
            foreach (var val in SpeciallyEffect_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 地图生成
        /// <summary>
        /// 随机生成地图方式配置缓存
        /// </summary>
        private static readonly Dictionary<string, GenerateBottomMap> GenerateBottomMap_Cache = new Dictionary<string, GenerateBottomMap>();
        /// <summary>
        /// 提前加载所有随机生成地图方式配置缓存
        /// </summary>
        public static void LoadGenerateBottomMap()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GenerateBottomMap);
            foreach (var val in cfg_dict)
            {
                GenerateBottomMap data = new GenerateBottomMap(val.Value);
                data.InitData2();
                GenerateBottomMap_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的随机生成地图方式基础配置缓存
        /// </summary>
        public static GenerateBottomMap GetGenerateBottomMap(string cfgId)
        {
            if (!GenerateBottomMap_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GenerateBottomMap(cfgId);
                data.InitData2();
                GenerateBottomMap_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GenerateBottomMap GetGenerateBottomMap(int cfgId)
        {
            if (!GenerateBottomMap_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GenerateBottomMap(cfgId);
                data.InitData2();
                GenerateBottomMap_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有随机生成地图方式数据
        /// </summary>
        public static List<GenerateBottomMap> GetAllGenerateBottomMap()
        {
            List<GenerateBottomMap> list = new List<GenerateBottomMap>();
            foreach (var val in GenerateBottomMap_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 生成地图用材料配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapMaterial> MapMaterial_Cache = new Dictionary<string, MapMaterial>();
        /// <summary>
        /// 提前加载所有生成地图用材料配置缓存
        /// </summary>
        public static void LoadMapMaterial()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapMaterial);
            foreach (var val in cfg_dict)
            {
                MapMaterial data = new MapMaterial(val.Value);
                data.InitData2();
                MapMaterial_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的生成地图用材料基础配置缓存
        /// </summary>
        public static MapMaterial GetMapMaterial(string cfgId)
        {
            if (!MapMaterial_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MapMaterial(cfgId);
                data.InitData2();
                MapMaterial_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MapMaterial GetMapMaterial(int cfgId)
        {
            if (!MapMaterial_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MapMaterial(cfgId);
                data.InitData2();
                MapMaterial_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有生成地图用材料数据
        /// </summary>
        public static List<MapMaterial> GetAllMapMaterial()
        {
            List<MapMaterial> list = new List<MapMaterial>();
            foreach (var val in MapMaterial_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 地图额外绘制表配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapExtraDraw> MapExtraDraw_Cache = new Dictionary<string, MapExtraDraw>();
        /// <summary>
        /// 提前加载所有地图额外绘制表配置缓存
        /// </summary>
        public static void LoadMapExtraDraw()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapExtraDraw);
            foreach (var val in cfg_dict)
            {
                MapExtraDraw data = new MapExtraDraw(val.Value);
                data.InitData2();
                MapExtraDraw_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图额外绘制表基础配置缓存
        /// </summary>
        public static MapExtraDraw GetMapExtraDraw(string cfgId)
        {
            if (!MapExtraDraw_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MapExtraDraw(cfgId);
                data.InitData2();
                MapExtraDraw_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MapExtraDraw GetMapExtraDraw(int cfgId)
        {
            if (!MapExtraDraw_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MapExtraDraw(cfgId);
                data.InitData2();
                MapExtraDraw_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图额外绘制表数据
        /// </summary>
        public static List<MapExtraDraw> GetAllMapExtraDraw()
        {
            List<MapExtraDraw> list = new List<MapExtraDraw>();
            foreach (var val in MapExtraDraw_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 地图大型结构配置缓存
        /// </summary>
        private static readonly Dictionary<string, GenerateBigStruct> GenerateBigStruct_Cache = new Dictionary<string, GenerateBigStruct>();
        /// <summary>
        /// 提前加载所有地图大型结构配置缓存
        /// </summary>
        public static void LoadGenerateBigStruct()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GenerateBigStruct);
            foreach (var val in cfg_dict)
            {
                GenerateBigStruct data = new GenerateBigStruct(val.Value);
                data.InitData2();
                GenerateBigStruct_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图大型结构基础配置缓存
        /// </summary>
        public static GenerateBigStruct GetGenerateBigStruct(string cfgId)
        {
            if (!GenerateBigStruct_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GenerateBigStruct(cfgId);
                data.InitData2();
                GenerateBigStruct_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GenerateBigStruct GetGenerateBigStruct(int cfgId)
        {
            if (!GenerateBigStruct_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GenerateBigStruct(cfgId);
                data.InitData2();
                GenerateBigStruct_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图大型结构数据
        /// </summary>
        public static List<GenerateBigStruct> GetAllGenerateBigStruct()
        {
            List<GenerateBigStruct> list = new List<GenerateBigStruct>();
            foreach (var val in GenerateBigStruct_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 地图墙壁表配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapWall> MapWall_Cache = new Dictionary<string, MapWall>();
        /// <summary>
        /// 提前加载所有地图墙壁表配置缓存
        /// </summary>
        public static void LoadMapWall()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapWall);
            foreach (var val in cfg_dict)
            {
                MapWall data = new MapWall(val.Value);
                data.InitData2();
                MapWall_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图墙壁表基础配置缓存
        /// </summary>
        public static MapWall GetMapWall(string cfgId)
        {
            if (!MapWall_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MapWall(cfgId);
                data.InitData2();
                MapWall_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MapWall GetMapWall(int cfgId)
        {
            if (!MapWall_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MapWall(cfgId);
                data.InitData2();
                MapWall_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图墙壁表数据
        /// </summary>
        public static List<MapWall> GetAllMapWall()
        {
            List<MapWall> list = new List<MapWall>();
            foreach (var val in MapWall_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 地图可通过类型配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapPassType> MapPassType_Cache = new Dictionary<string, MapPassType>();
        /// <summary>
        /// 提前加载所有地图可通过类型配置缓存
        /// </summary>
        public static void LoadMapPassType()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapPassType);
            foreach (var val in cfg_dict)
            {
                MapPassType data = new MapPassType(val.Value);
                data.InitData2();
                MapPassType_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图可通过类型基础配置缓存
        /// </summary>
        public static MapPassType GetMapPassType(string cfgId)
        {
            if (!MapPassType_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MapPassType(cfgId);
                data.InitData2();
                MapPassType_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MapPassType GetMapPassType(int cfgId)
        {
            if (!MapPassType_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MapPassType(cfgId);
                data.InitData2();
                MapPassType_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图可通过类型数据
        /// </summary>
        public static List<MapPassType> GetAllMapPassType()
        {
            List<MapPassType> list = new List<MapPassType>();
            foreach (var val in MapPassType_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 地块
        /// <summary>
        /// 资源地块配置缓存
        /// </summary>
        private static readonly Dictionary<string, Massif> Massif_Cache = new Dictionary<string, Massif>();
        /// <summary>
        /// 提前加载所有资源地块配置缓存
        /// </summary>
        public static void LoadMassif()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_Massif);
            foreach (var val in cfg_dict)
            {
                Massif data = new Massif(val.Value);
                data.InitData2();
                Massif_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的资源地块基础配置缓存
        /// </summary>
        public static Massif GetMassif(string cfgId)
        {
            if (!Massif_Cache.TryGetValue(cfgId, out var data))
            {
                data = new Massif(cfgId);
                data.InitData2();
                Massif_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static Massif GetMassif(int cfgId)
        {
            if (!Massif_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new Massif(cfgId);
                data.InitData2();
                Massif_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有资源地块数据
        /// </summary>
        public static List<Massif> GetAllMassif()
        {
            List<Massif> list = new List<Massif>();
            foreach (var val in Massif_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 大地图生成
        /// <summary>
        /// 生成大地图配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapBase> BigMapBase_Cache = new Dictionary<string, BigMapBase>();
        /// <summary>
        /// 提前加载所有生成大地图配置缓存
        /// </summary>
        public static void LoadBigMapBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapBase);
            foreach (var val in cfg_dict)
            {
                BigMapBase data = new BigMapBase(val.Value);
                data.InitData2();
                BigMapBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的生成大地图基础配置缓存
        /// </summary>
        public static BigMapBase GetBigMapBase(string cfgId)
        {
            if (!BigMapBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BigMapBase(cfgId);
                data.InitData2();
                BigMapBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BigMapBase GetBigMapBase(int cfgId)
        {
            if (!BigMapBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BigMapBase(cfgId);
                data.InitData2();
                BigMapBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有生成大地图数据
        /// </summary>
        public static List<BigMapBase> GetAllBigMapBase()
        {
            List<BigMapBase> list = new List<BigMapBase>();
            foreach (var val in BigMapBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 大地图大结构配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapBigCell> BigMapBigCell_Cache = new Dictionary<string, BigMapBigCell>();
        /// <summary>
        /// 提前加载所有大地图大结构配置缓存
        /// </summary>
        public static void LoadBigMapBigCell()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapBigCell);
            foreach (var val in cfg_dict)
            {
                BigMapBigCell data = new BigMapBigCell(val.Value);
                data.InitData2();
                BigMapBigCell_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的大地图大结构基础配置缓存
        /// </summary>
        public static BigMapBigCell GetBigMapBigCell(string cfgId)
        {
            if (!BigMapBigCell_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BigMapBigCell(cfgId);
                data.InitData2();
                BigMapBigCell_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BigMapBigCell GetBigMapBigCell(int cfgId)
        {
            if (!BigMapBigCell_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BigMapBigCell(cfgId);
                data.InitData2();
                BigMapBigCell_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有大地图大结构数据
        /// </summary>
        public static List<BigMapBigCell> GetAllBigMapBigCell()
        {
            List<BigMapBigCell> list = new List<BigMapBigCell>();
            foreach (var val in BigMapBigCell_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 节点绘制逻辑配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapCellLogic> BigMapCellLogic_Cache = new Dictionary<string, BigMapCellLogic>();
        /// <summary>
        /// 提前加载所有节点绘制逻辑配置缓存
        /// </summary>
        public static void LoadBigMapCellLogic()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapCellLogic);
            foreach (var val in cfg_dict)
            {
                BigMapCellLogic data = new BigMapCellLogic(val.Value);
                data.InitData2();
                BigMapCellLogic_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的节点绘制逻辑基础配置缓存
        /// </summary>
        public static BigMapCellLogic GetBigMapCellLogic(string cfgId)
        {
            if (!BigMapCellLogic_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BigMapCellLogic(cfgId);
                data.InitData2();
                BigMapCellLogic_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BigMapCellLogic GetBigMapCellLogic(int cfgId)
        {
            if (!BigMapCellLogic_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BigMapCellLogic(cfgId);
                data.InitData2();
                BigMapCellLogic_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有节点绘制逻辑数据
        /// </summary>
        public static List<BigMapCellLogic> GetAllBigMapCellLogic()
        {
            List<BigMapCellLogic> list = new List<BigMapCellLogic>();
            foreach (var val in BigMapCellLogic_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 大地图节点事件配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapEvent> BigMapEvent_Cache = new Dictionary<string, BigMapEvent>();
        /// <summary>
        /// 提前加载所有大地图节点事件配置缓存
        /// </summary>
        public static void LoadBigMapEvent()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapEvent);
            foreach (var val in cfg_dict)
            {
                BigMapEvent data = new BigMapEvent(val.Value);
                data.InitData2();
                BigMapEvent_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的大地图节点事件基础配置缓存
        /// </summary>
        public static BigMapEvent GetBigMapEvent(string cfgId)
        {
            if (!BigMapEvent_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BigMapEvent(cfgId);
                data.InitData2();
                BigMapEvent_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BigMapEvent GetBigMapEvent(int cfgId)
        {
            if (!BigMapEvent_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BigMapEvent(cfgId);
                data.InitData2();
                BigMapEvent_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有大地图节点事件数据
        /// </summary>
        public static List<BigMapEvent> GetAllBigMapEvent()
        {
            List<BigMapEvent> list = new List<BigMapEvent>();
            foreach (var val in BigMapEvent_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 战役副本相关
        /// <summary>
        /// 战役基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ChapterBase> ChapterBase_Cache = new Dictionary<string, ChapterBase>();
        /// <summary>
        /// 提前加载所有战役基础数据配置缓存
        /// </summary>
        public static void LoadChapterBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ChapterBase);
            foreach (var val in cfg_dict)
            {
                ChapterBase data = new ChapterBase(val.Value);
                data.InitData2();
                ChapterBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的战役基础数据基础配置缓存
        /// </summary>
        public static ChapterBase GetChapterBase(string cfgId)
        {
            if (!ChapterBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ChapterBase(cfgId);
                data.InitData2();
                ChapterBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ChapterBase GetChapterBase(int cfgId)
        {
            if (!ChapterBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ChapterBase(cfgId);
                data.InitData2();
                ChapterBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有战役基础数据数据
        /// </summary>
        public static List<ChapterBase> GetAllChapterBase()
        {
            List<ChapterBase> list = new List<ChapterBase>();
            foreach (var val in ChapterBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 战役关卡基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ChapterCopyBase> ChapterCopyBase_Cache = new Dictionary<string, ChapterCopyBase>();
        /// <summary>
        /// 提前加载所有战役关卡基础数据配置缓存
        /// </summary>
        public static void LoadChapterCopyBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ChapterCopyBase);
            foreach (var val in cfg_dict)
            {
                ChapterCopyBase data = new ChapterCopyBase(val.Value);
                data.InitData2();
                ChapterCopyBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的战役关卡基础数据基础配置缓存
        /// </summary>
        public static ChapterCopyBase GetChapterCopyBase(string cfgId)
        {
            if (!ChapterCopyBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ChapterCopyBase(cfgId);
                data.InitData2();
                ChapterCopyBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ChapterCopyBase GetChapterCopyBase(int cfgId)
        {
            if (!ChapterCopyBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ChapterCopyBase(cfgId);
                data.InitData2();
                ChapterCopyBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有战役关卡基础数据数据
        /// </summary>
        public static List<ChapterCopyBase> GetAllChapterCopyBase()
        {
            List<ChapterCopyBase> list = new List<ChapterCopyBase>();
            foreach (var val in ChapterCopyBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 战役关卡刷怪数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CopyBrush> CopyBrush_Cache = new Dictionary<string, CopyBrush>();
        /// <summary>
        /// 提前加载所有战役关卡刷怪数据配置缓存
        /// </summary>
        public static void LoadCopyBrush()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_CopyBrush);
            foreach (var val in cfg_dict)
            {
                CopyBrush data = new CopyBrush(val.Value);
                data.InitData2();
                CopyBrush_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的战役关卡刷怪数据基础配置缓存
        /// </summary>
        public static CopyBrush GetCopyBrush(string cfgId)
        {
            if (!CopyBrush_Cache.TryGetValue(cfgId, out var data))
            {
                data = new CopyBrush(cfgId);
                data.InitData2();
                CopyBrush_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static CopyBrush GetCopyBrush(int cfgId)
        {
            if (!CopyBrush_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new CopyBrush(cfgId);
                data.InitData2();
                CopyBrush_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有战役关卡刷怪数据数据
        /// </summary>
        public static List<CopyBrush> GetAllCopyBrush()
        {
            List<CopyBrush> list = new List<CopyBrush>();
            foreach (var val in CopyBrush_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 刷怪点数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BrushPoint> BrushPoint_Cache = new Dictionary<string, BrushPoint>();
        /// <summary>
        /// 提前加载所有刷怪点数据配置缓存
        /// </summary>
        public static void LoadBrushPoint()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BrushPoint);
            foreach (var val in cfg_dict)
            {
                BrushPoint data = new BrushPoint(val.Value);
                data.InitData2();
                BrushPoint_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的刷怪点数据基础配置缓存
        /// </summary>
        public static BrushPoint GetBrushPoint(string cfgId)
        {
            if (!BrushPoint_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BrushPoint(cfgId);
                data.InitData2();
                BrushPoint_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BrushPoint GetBrushPoint(int cfgId)
        {
            if (!BrushPoint_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BrushPoint(cfgId);
                data.InitData2();
                BrushPoint_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有刷怪点数据数据
        /// </summary>
        public static List<BrushPoint> GetAllBrushPoint()
        {
            List<BrushPoint> list = new List<BrushPoint>();
            foreach (var val in BrushPoint_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 波数配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, WaveBase> WaveBase_Cache = new Dictionary<string, WaveBase>();
        /// <summary>
        /// 提前加载所有波数配置配置缓存
        /// </summary>
        public static void LoadWaveBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_WaveBase);
            foreach (var val in cfg_dict)
            {
                WaveBase data = new WaveBase(val.Value);
                data.InitData2();
                WaveBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的波数配置基础配置缓存
        /// </summary>
        public static WaveBase GetWaveBase(string cfgId)
        {
            if (!WaveBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new WaveBase(cfgId);
                data.InitData2();
                WaveBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static WaveBase GetWaveBase(int cfgId)
        {
            if (!WaveBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new WaveBase(cfgId);
                data.InitData2();
                WaveBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有波数配置数据
        /// </summary>
        public static List<WaveBase> GetAllWaveBase()
        {
            List<WaveBase> list = new List<WaveBase>();
            foreach (var val in WaveBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 章节关卡UI数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ChapterCopyUI> ChapterCopyUI_Cache = new Dictionary<string, ChapterCopyUI>();
        /// <summary>
        /// 提前加载所有章节关卡UI数据配置缓存
        /// </summary>
        public static void LoadChapterCopyUI()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ChapterCopyUI);
            foreach (var val in cfg_dict)
            {
                ChapterCopyUI data = new ChapterCopyUI(val.Value);
                data.InitData2();
                ChapterCopyUI_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的章节关卡UI数据基础配置缓存
        /// </summary>
        public static ChapterCopyUI GetChapterCopyUI(string cfgId)
        {
            if (!ChapterCopyUI_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ChapterCopyUI(cfgId);
                data.InitData2();
                ChapterCopyUI_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ChapterCopyUI GetChapterCopyUI(int cfgId)
        {
            if (!ChapterCopyUI_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ChapterCopyUI(cfgId);
                data.InitData2();
                ChapterCopyUI_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有章节关卡UI数据数据
        /// </summary>
        public static List<ChapterCopyUI> GetAllChapterCopyUI()
        {
            List<ChapterCopyUI> list = new List<ChapterCopyUI>();
            foreach (var val in ChapterCopyUI_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 单位配置
        /// <summary>
        /// 单位基础表配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitData> UnitData_Cache = new Dictionary<string, UnitData>();
        /// <summary>
        /// 提前加载所有单位基础表配置缓存
        /// </summary>
        public static void LoadUnitData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitData);
            foreach (var val in cfg_dict)
            {
                UnitData data = new UnitData(val.Value);
                data.InitData2();
                UnitData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的单位基础表基础配置缓存
        /// </summary>
        public static UnitData GetUnitData(string cfgId)
        {
            if (!UnitData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new UnitData(cfgId);
                data.InitData2();
                UnitData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static UnitData GetUnitData(int cfgId)
        {
            if (!UnitData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new UnitData(cfgId);
                data.InitData2();
                UnitData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位基础表数据
        /// </summary>
        public static List<UnitData> GetAllUnitData()
        {
            List<UnitData> list = new List<UnitData>();
            foreach (var val in UnitData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 子弹配置
        /// <summary>
        /// 子弹基础表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletData> BulletData_Cache = new Dictionary<string, BulletData>();
        /// <summary>
        /// 提前加载所有子弹基础表配置缓存
        /// </summary>
        public static void LoadBulletData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletData);
            foreach (var val in cfg_dict)
            {
                BulletData data = new BulletData(val.Value);
                data.InitData2();
                BulletData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹基础表基础配置缓存
        /// </summary>
        public static BulletData GetBulletData(string cfgId)
        {
            if (!BulletData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BulletData(cfgId);
                data.InitData2();
                BulletData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BulletData GetBulletData(int cfgId)
        {
            if (!BulletData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BulletData(cfgId);
                data.InitData2();
                BulletData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹基础表数据
        /// </summary>
        public static List<BulletData> GetAllBulletData()
        {
            List<BulletData> list = new List<BulletData>();
            foreach (var val in BulletData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 实体显示相关配置
        /// <summary>
        /// 实体显示方式表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BaseObjectShow> BaseObjectShow_Cache = new Dictionary<string, BaseObjectShow>();
        /// <summary>
        /// 提前加载所有实体显示方式表配置缓存
        /// </summary>
        public static void LoadBaseObjectShow()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BaseObjectShow);
            foreach (var val in cfg_dict)
            {
                BaseObjectShow data = new BaseObjectShow(val.Value);
                data.InitData2();
                BaseObjectShow_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体显示方式表基础配置缓存
        /// </summary>
        public static BaseObjectShow GetBaseObjectShow(string cfgId)
        {
            if (!BaseObjectShow_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BaseObjectShow(cfgId);
                data.InitData2();
                BaseObjectShow_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BaseObjectShow GetBaseObjectShow(int cfgId)
        {
            if (!BaseObjectShow_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BaseObjectShow(cfgId);
                data.InitData2();
                BaseObjectShow_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体显示方式表数据
        /// </summary>
        public static List<BaseObjectShow> GetAllBaseObjectShow()
        {
            List<BaseObjectShow> list = new List<BaseObjectShow>();
            foreach (var val in BaseObjectShow_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 底部栏配置缓存
        /// </summary>
        private static readonly Dictionary<string, ObjectBottomBar> ObjectBottomBar_Cache = new Dictionary<string, ObjectBottomBar>();
        /// <summary>
        /// 提前加载所有底部栏配置缓存
        /// </summary>
        public static void LoadObjectBottomBar()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ObjectBottomBar);
            foreach (var val in cfg_dict)
            {
                ObjectBottomBar data = new ObjectBottomBar(val.Value);
                data.InitData2();
                ObjectBottomBar_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的底部栏基础配置缓存
        /// </summary>
        public static ObjectBottomBar GetObjectBottomBar(string cfgId)
        {
            if (!ObjectBottomBar_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ObjectBottomBar(cfgId);
                data.InitData2();
                ObjectBottomBar_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ObjectBottomBar GetObjectBottomBar(int cfgId)
        {
            if (!ObjectBottomBar_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ObjectBottomBar(cfgId);
                data.InitData2();
                ObjectBottomBar_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有底部栏数据
        /// </summary>
        public static List<ObjectBottomBar> GetAllObjectBottomBar()
        {
            List<ObjectBottomBar> list = new List<ObjectBottomBar>();
            foreach (var val in ObjectBottomBar_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 侧边栏配置缓存
        /// </summary>
        private static readonly Dictionary<string, ObjectSideBar> ObjectSideBar_Cache = new Dictionary<string, ObjectSideBar>();
        /// <summary>
        /// 提前加载所有侧边栏配置缓存
        /// </summary>
        public static void LoadObjectSideBar()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ObjectSideBar);
            foreach (var val in cfg_dict)
            {
                ObjectSideBar data = new ObjectSideBar(val.Value);
                data.InitData2();
                ObjectSideBar_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的侧边栏基础配置缓存
        /// </summary>
        public static ObjectSideBar GetObjectSideBar(string cfgId)
        {
            if (!ObjectSideBar_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ObjectSideBar(cfgId);
                data.InitData2();
                ObjectSideBar_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ObjectSideBar GetObjectSideBar(int cfgId)
        {
            if (!ObjectSideBar_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ObjectSideBar(cfgId);
                data.InitData2();
                ObjectSideBar_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有侧边栏数据
        /// </summary>
        public static List<ObjectSideBar> GetAllObjectSideBar()
        {
            List<ObjectSideBar> list = new List<ObjectSideBar>();
            foreach (var val in ObjectSideBar_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 属性配置
        /// <summary>
        /// 属性表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttributeBase> AttributeBase_Cache = new Dictionary<string, AttributeBase>();
        /// <summary>
        /// 提前加载所有属性表配置缓存
        /// </summary>
        public static void LoadAttributeBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttributeBase);
            foreach (var val in cfg_dict)
            {
                AttributeBase data = new AttributeBase(val.Value);
                data.InitData2();
                AttributeBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性表基础配置缓存
        /// </summary>
        public static AttributeBase GetAttributeBase(string cfgId)
        {
            if (!AttributeBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttributeBase(cfgId);
                data.InitData2();
                AttributeBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttributeBase GetAttributeBase(int cfgId)
        {
            if (!AttributeBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttributeBase(cfgId);
                data.InitData2();
                AttributeBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性表数据
        /// </summary>
        public static List<AttributeBase> GetAllAttributeBase()
        {
            List<AttributeBase> list = new List<AttributeBase>();
            foreach (var val in AttributeBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 属性模板表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttributeTemplate> AttributeTemplate_Cache = new Dictionary<string, AttributeTemplate>();
        /// <summary>
        /// 提前加载所有属性模板表配置缓存
        /// </summary>
        public static void LoadAttributeTemplate()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttributeTemplate);
            foreach (var val in cfg_dict)
            {
                AttributeTemplate data = new AttributeTemplate(val.Value);
                data.InitData2();
                AttributeTemplate_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性模板表基础配置缓存
        /// </summary>
        public static AttributeTemplate GetAttributeTemplate(string cfgId)
        {
            if (!AttributeTemplate_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttributeTemplate(cfgId);
                data.InitData2();
                AttributeTemplate_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttributeTemplate GetAttributeTemplate(int cfgId)
        {
            if (!AttributeTemplate_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttributeTemplate(cfgId);
                data.InitData2();
                AttributeTemplate_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性模板表数据
        /// </summary>
        public static List<AttributeTemplate> GetAllAttributeTemplate()
        {
            List<AttributeTemplate> list = new List<AttributeTemplate>();
            foreach (var val in AttributeTemplate_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 实体属性表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttributeData> AttributeData_Cache = new Dictionary<string, AttributeData>();
        /// <summary>
        /// 提前加载所有实体属性表配置缓存
        /// </summary>
        public static void LoadAttributeData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttributeData);
            foreach (var val in cfg_dict)
            {
                AttributeData data = new AttributeData(val.Value);
                data.InitData2();
                AttributeData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体属性表基础配置缓存
        /// </summary>
        public static AttributeData GetAttributeData(string cfgId)
        {
            if (!AttributeData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttributeData(cfgId);
                data.InitData2();
                AttributeData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttributeData GetAttributeData(int cfgId)
        {
            if (!AttributeData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttributeData(cfgId);
                data.InitData2();
                AttributeData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体属性表数据
        /// </summary>
        public static List<AttributeData> GetAllAttributeData()
        {
            List<AttributeData> list = new List<AttributeData>();
            foreach (var val in AttributeData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 属性计算表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrCalculate> AttrCalculate_Cache = new Dictionary<string, AttrCalculate>();
        /// <summary>
        /// 提前加载所有属性计算表配置缓存
        /// </summary>
        public static void LoadAttrCalculate()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrCalculate);
            foreach (var val in cfg_dict)
            {
                AttrCalculate data = new AttrCalculate(val.Value);
                data.InitData2();
                AttrCalculate_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性计算表基础配置缓存
        /// </summary>
        public static AttrCalculate GetAttrCalculate(string cfgId)
        {
            if (!AttrCalculate_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttrCalculate(cfgId);
                data.InitData2();
                AttrCalculate_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttrCalculate GetAttrCalculate(int cfgId)
        {
            if (!AttrCalculate_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttrCalculate(cfgId);
                data.InitData2();
                AttrCalculate_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性计算表数据
        /// </summary>
        public static List<AttrCalculate> GetAllAttrCalculate()
        {
            List<AttrCalculate> list = new List<AttrCalculate>();
            foreach (var val in AttrCalculate_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 属性依赖表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrDependency> AttrDependency_Cache = new Dictionary<string, AttrDependency>();
        /// <summary>
        /// 提前加载所有属性依赖表配置缓存
        /// </summary>
        public static void LoadAttrDependency()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrDependency);
            foreach (var val in cfg_dict)
            {
                AttrDependency data = new AttrDependency(val.Value);
                data.InitData2();
                AttrDependency_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性依赖表基础配置缓存
        /// </summary>
        public static AttrDependency GetAttrDependency(string cfgId)
        {
            if (!AttrDependency_Cache.TryGetValue(cfgId, out var data))
            {
                data = new AttrDependency(cfgId);
                data.InitData2();
                AttrDependency_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static AttrDependency GetAttrDependency(int cfgId)
        {
            if (!AttrDependency_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new AttrDependency(cfgId);
                data.InitData2();
                AttrDependency_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性依赖表数据
        /// </summary>
        public static List<AttrDependency> GetAllAttrDependency()
        {
            List<AttrDependency> list = new List<AttrDependency>();
            foreach (var val in AttrDependency_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 建筑配置
        /// <summary>
        /// 建筑建筑数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuildData> BuildData_Cache = new Dictionary<string, BuildData>();
        /// <summary>
        /// 提前加载所有建筑建筑数据配置缓存
        /// </summary>
        public static void LoadBuildData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuildData);
            foreach (var val in cfg_dict)
            {
                BuildData data = new BuildData(val.Value);
                data.InitData2();
                BuildData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建筑建筑数据基础配置缓存
        /// </summary>
        public static BuildData GetBuildData(string cfgId)
        {
            if (!BuildData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BuildData(cfgId);
                data.InitData2();
                BuildData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BuildData GetBuildData(int cfgId)
        {
            if (!BuildData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BuildData(cfgId);
                data.InitData2();
                BuildData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建筑建筑数据数据
        /// </summary>
        public static List<BuildData> GetAllBuildData()
        {
            List<BuildData> list = new List<BuildData>();
            foreach (var val in BuildData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 建造规则配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuildRule> BuildRule_Cache = new Dictionary<string, BuildRule>();
        /// <summary>
        /// 提前加载所有建造规则配置缓存
        /// </summary>
        public static void LoadBuildRule()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuildRule);
            foreach (var val in cfg_dict)
            {
                BuildRule data = new BuildRule(val.Value);
                data.InitData2();
                BuildRule_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建造规则基础配置缓存
        /// </summary>
        public static BuildRule GetBuildRule(string cfgId)
        {
            if (!BuildRule_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BuildRule(cfgId);
                data.InitData2();
                BuildRule_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BuildRule GetBuildRule(int cfgId)
        {
            if (!BuildRule_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BuildRule(cfgId);
                data.InitData2();
                BuildRule_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建造规则数据
        /// </summary>
        public static List<BuildRule> GetAllBuildRule()
        {
            List<BuildRule> list = new List<BuildRule>();
            foreach (var val in BuildRule_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 武器配置
        /// <summary>
        /// 武器基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, WeaponData> WeaponData_Cache = new Dictionary<string, WeaponData>();
        /// <summary>
        /// 提前加载所有武器基础数据配置缓存
        /// </summary>
        public static void LoadWeaponData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_WeaponData);
            foreach (var val in cfg_dict)
            {
                WeaponData data = new WeaponData(val.Value);
                data.InitData2();
                WeaponData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的武器基础数据基础配置缓存
        /// </summary>
        public static WeaponData GetWeaponData(string cfgId)
        {
            if (!WeaponData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new WeaponData(cfgId);
                data.InitData2();
                WeaponData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static WeaponData GetWeaponData(int cfgId)
        {
            if (!WeaponData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new WeaponData(cfgId);
                data.InitData2();
                WeaponData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有武器基础数据数据
        /// </summary>
        public static List<WeaponData> GetAllWeaponData()
        {
            List<WeaponData> list = new List<WeaponData>();
            foreach (var val in WeaponData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 武器数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, WeaponBase> WeaponBase_Cache = new Dictionary<string, WeaponBase>();
        /// <summary>
        /// 提前加载所有武器数据配置缓存
        /// </summary>
        public static void LoadWeaponBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_WeaponBase);
            foreach (var val in cfg_dict)
            {
                WeaponBase data = new WeaponBase(val.Value);
                data.InitData2();
                WeaponBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的武器数据基础配置缓存
        /// </summary>
        public static WeaponBase GetWeaponBase(string cfgId)
        {
            if (!WeaponBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new WeaponBase(cfgId);
                data.InitData2();
                WeaponBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static WeaponBase GetWeaponBase(int cfgId)
        {
            if (!WeaponBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new WeaponBase(cfgId);
                data.InitData2();
                WeaponBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有武器数据数据
        /// </summary>
        public static List<WeaponBase> GetAllWeaponBase()
        {
            List<WeaponBase> list = new List<WeaponBase>();
            foreach (var val in WeaponBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 炮塔配置
        /// <summary>
        /// 炮塔基础表配置缓存
        /// </summary>
        private static readonly Dictionary<string, TowerData> TowerData_Cache = new Dictionary<string, TowerData>();
        /// <summary>
        /// 提前加载所有炮塔基础表配置缓存
        /// </summary>
        public static void LoadTowerData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_TowerData);
            foreach (var val in cfg_dict)
            {
                TowerData data = new TowerData(val.Value);
                data.InitData2();
                TowerData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的炮塔基础表基础配置缓存
        /// </summary>
        public static TowerData GetTowerData(string cfgId)
        {
            if (!TowerData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new TowerData(cfgId);
                data.InitData2();
                TowerData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static TowerData GetTowerData(int cfgId)
        {
            if (!TowerData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new TowerData(cfgId);
                data.InitData2();
                TowerData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有炮塔基础表数据
        /// </summary>
        public static List<TowerData> GetAllTowerData()
        {
            List<TowerData> list = new List<TowerData>();
            foreach (var val in TowerData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 建造列表相关配置
        /// <summary>
        /// 建造列表标签配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapBuildLable> MapBuildLable_Cache = new Dictionary<string, MapBuildLable>();
        /// <summary>
        /// 提前加载所有建造列表标签配置缓存
        /// </summary>
        public static void LoadMapBuildLable()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapBuildLable);
            foreach (var val in cfg_dict)
            {
                MapBuildLable data = new MapBuildLable(val.Value);
                data.InitData2();
                MapBuildLable_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建造列表标签基础配置缓存
        /// </summary>
        public static MapBuildLable GetMapBuildLable(string cfgId)
        {
            if (!MapBuildLable_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MapBuildLable(cfgId);
                data.InitData2();
                MapBuildLable_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MapBuildLable GetMapBuildLable(int cfgId)
        {
            if (!MapBuildLable_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MapBuildLable(cfgId);
                data.InitData2();
                MapBuildLable_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建造列表标签数据
        /// </summary>
        public static List<MapBuildLable> GetAllMapBuildLable()
        {
            List<MapBuildLable> list = new List<MapBuildLable>();
            foreach (var val in MapBuildLable_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 建造子列表配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapBuildList> MapBuildList_Cache = new Dictionary<string, MapBuildList>();
        /// <summary>
        /// 提前加载所有建造子列表配置缓存
        /// </summary>
        public static void LoadMapBuildList()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapBuildList);
            foreach (var val in cfg_dict)
            {
                MapBuildList data = new MapBuildList(val.Value);
                data.InitData2();
                MapBuildList_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建造子列表基础配置缓存
        /// </summary>
        public static MapBuildList GetMapBuildList(string cfgId)
        {
            if (!MapBuildList_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MapBuildList(cfgId);
                data.InitData2();
                MapBuildList_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MapBuildList GetMapBuildList(int cfgId)
        {
            if (!MapBuildList_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MapBuildList(cfgId);
                data.InitData2();
                MapBuildList_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建造子列表数据
        /// </summary>
        public static List<MapBuildList> GetAllMapBuildList()
        {
            List<MapBuildList> list = new List<MapBuildList>();
            foreach (var val in MapBuildList_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region buff
        /// <summary>
        /// buff基础配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, Buff> Buff_Cache = new Dictionary<string, Buff>();
        /// <summary>
        /// 提前加载所有buff基础配置配置缓存
        /// </summary>
        public static void LoadBuff()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_Buff);
            foreach (var val in cfg_dict)
            {
                Buff data = new Buff(val.Value);
                data.InitData2();
                Buff_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的buff基础配置基础配置缓存
        /// </summary>
        public static Buff GetBuff(string cfgId)
        {
            if (!Buff_Cache.TryGetValue(cfgId, out var data))
            {
                data = new Buff(cfgId);
                data.InitData2();
                Buff_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static Buff GetBuff(int cfgId)
        {
            if (!Buff_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new Buff(cfgId);
                data.InitData2();
                Buff_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有buff基础配置数据
        /// </summary>
        public static List<Buff> GetAllBuff()
        {
            List<Buff> list = new List<Buff>();
            foreach (var val in Buff_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 阵营相关
        /// <summary>
        /// 阵营基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CampBase> CampBase_Cache = new Dictionary<string, CampBase>();
        /// <summary>
        /// 提前加载所有阵营基础数据配置缓存
        /// </summary>
        public static void LoadCampBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_CampBase);
            foreach (var val in cfg_dict)
            {
                CampBase data = new CampBase(val.Value);
                data.InitData2();
                CampBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的阵营基础数据基础配置缓存
        /// </summary>
        public static CampBase GetCampBase(string cfgId)
        {
            if (!CampBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new CampBase(cfgId);
                data.InitData2();
                CampBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static CampBase GetCampBase(int cfgId)
        {
            if (!CampBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new CampBase(cfgId);
                data.InitData2();
                CampBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有阵营基础数据数据
        /// </summary>
        public static List<CampBase> GetAllCampBase()
        {
            List<CampBase> list = new List<CampBase>();
            foreach (var val in CampBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 难度相关
        /// <summary>
        /// 游戏难度相关配置缓存
        /// </summary>
        private static readonly Dictionary<string, GameDiffBase> GameDiffBase_Cache = new Dictionary<string, GameDiffBase>();
        /// <summary>
        /// 提前加载所有游戏难度相关配置缓存
        /// </summary>
        public static void LoadGameDiffBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GameDiffBase);
            foreach (var val in cfg_dict)
            {
                GameDiffBase data = new GameDiffBase(val.Value);
                data.InitData2();
                GameDiffBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的游戏难度相关基础配置缓存
        /// </summary>
        public static GameDiffBase GetGameDiffBase(string cfgId)
        {
            if (!GameDiffBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new GameDiffBase(cfgId);
                data.InitData2();
                GameDiffBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static GameDiffBase GetGameDiffBase(int cfgId)
        {
            if (!GameDiffBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new GameDiffBase(cfgId);
                data.InitData2();
                GameDiffBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有游戏难度相关数据
        /// </summary>
        public static List<GameDiffBase> GetAllGameDiffBase()
        {
            List<GameDiffBase> list = new List<GameDiffBase>();
            foreach (var val in GameDiffBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 背包相关
        /// <summary>
        /// 配置缓存
        /// </summary>
        private static readonly Dictionary<string, BagData> BagData_Cache = new Dictionary<string, BagData>();
        /// <summary>
        /// 提前加载所有配置缓存
        /// </summary>
        public static void LoadBagData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BagData);
            foreach (var val in cfg_dict)
            {
                BagData data = new BagData(val.Value);
                data.InitData2();
                BagData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的基础配置缓存
        /// </summary>
        public static BagData GetBagData(string cfgId)
        {
            if (!BagData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new BagData(cfgId);
                data.InitData2();
                BagData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static BagData GetBagData(int cfgId)
        {
            if (!BagData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new BagData(cfgId);
                data.InitData2();
                BagData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有数据
        /// </summary>
        public static List<BagData> GetAllBagData()
        {
            List<BagData> list = new List<BagData>();
            foreach (var val in BagData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 货币相关
        /// <summary>
        /// 货币界面显示配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MoneyBase> MoneyBase_Cache = new Dictionary<string, MoneyBase>();
        /// <summary>
        /// 提前加载所有货币界面显示配置配置缓存
        /// </summary>
        public static void LoadMoneyBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MoneyBase);
            foreach (var val in cfg_dict)
            {
                MoneyBase data = new MoneyBase(val.Value);
                data.InitData2();
                MoneyBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的货币界面显示配置基础配置缓存
        /// </summary>
        public static MoneyBase GetMoneyBase(string cfgId)
        {
            if (!MoneyBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new MoneyBase(cfgId);
                data.InitData2();
                MoneyBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static MoneyBase GetMoneyBase(int cfgId)
        {
            if (!MoneyBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new MoneyBase(cfgId);
                data.InitData2();
                MoneyBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有货币界面显示配置数据
        /// </summary>
        public static List<MoneyBase> GetAllMoneyBase()
        {
            List<MoneyBase> list = new List<MoneyBase>();
            foreach (var val in MoneyBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 道具相关
        /// <summary>
        /// 道具基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ItemData> ItemData_Cache = new Dictionary<string, ItemData>();
        /// <summary>
        /// 提前加载所有道具基础数据配置缓存
        /// </summary>
        public static void LoadItemData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ItemData);
            foreach (var val in cfg_dict)
            {
                ItemData data = new ItemData(val.Value);
                data.InitData2();
                ItemData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的道具基础数据基础配置缓存
        /// </summary>
        public static ItemData GetItemData(string cfgId)
        {
            if (!ItemData_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ItemData(cfgId);
                data.InitData2();
                ItemData_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ItemData GetItemData(int cfgId)
        {
            if (!ItemData_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ItemData(cfgId);
                data.InitData2();
                ItemData_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有道具基础数据数据
        /// </summary>
        public static List<ItemData> GetAllItemData()
        {
            List<ItemData> list = new List<ItemData>();
            foreach (var val in ItemData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 错误码
        /// <summary>
        /// 错误码配置缓存
        /// </summary>
        private static readonly Dictionary<string, ErrorBase> ErrorBase_Cache = new Dictionary<string, ErrorBase>();
        /// <summary>
        /// 提前加载所有错误码配置缓存
        /// </summary>
        public static void LoadErrorBase()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ErrorBase);
            foreach (var val in cfg_dict)
            {
                ErrorBase data = new ErrorBase(val.Value);
                data.InitData2();
                ErrorBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的错误码基础配置缓存
        /// </summary>
        public static ErrorBase GetErrorBase(string cfgId)
        {
            if (!ErrorBase_Cache.TryGetValue(cfgId, out var data))
            {
                data = new ErrorBase(cfgId);
                data.InitData2();
                ErrorBase_Cache.Add(cfgId, data);
            }
            return data;
        }
        public static ErrorBase GetErrorBase(int cfgId)
        {
            if (!ErrorBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                data = new ErrorBase(cfgId);
                data.InitData2();
                ErrorBase_Cache.Add("" + cfgId, data);
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有错误码数据
        /// </summary>
        public static List<ErrorBase> GetAllErrorBase()
        {
            List<ErrorBase> list = new List<ErrorBase>();
            foreach (var val in ErrorBase_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion


        /// <summary>
        /// 清理所有缓存数据
        /// </summary>
        public static void ClearAllCache()
        {
            ViewBase_Cache.Clear();
            UpdateLog_Cache.Clear();
            AttainmentPage_Cache.Clear();
            AttainmentBase_Cache.Clear();
            ScienceRange_Cache.Clear();
            ScienceBase_Cache.Clear();
            ScienceData_Cache.Clear();
            ItemDeployData_Cache.Clear();
            CorePlugDeployData_Cache.Clear();
            ScienceDeployData_Cache.Clear();
            ConfigCover_Cache.Clear();
            ConfigCall_Cache.Clear();
            GlobalConfigInt_Cache.Clear();
            GlobalConfigStr_Cache.Clear();
            GlobalConfigFloat_Cache.Clear();
            GlobalConfigList_Cache.Clear();
            GlobalConfigPng_Cache.Clear();
            FunctionTemplate_Cache.Clear();
            CameraBase_Cache.Clear();
            CameraAssemblyBase_Cache.Clear();
            AnimaUnit_Cache.Clear();
            AnimaTower_Cache.Clear();
            AnimaBuild_Cache.Clear();
            AnimaWeapon_Cache.Clear();
            AnimaBullet_Cache.Clear();
            SequenceMapBase_Cache.Clear();
            SpeciallyEffect_Cache.Clear();
            GenerateBottomMap_Cache.Clear();
            MapMaterial_Cache.Clear();
            MapExtraDraw_Cache.Clear();
            GenerateBigStruct_Cache.Clear();
            MapWall_Cache.Clear();
            MapPassType_Cache.Clear();
            Massif_Cache.Clear();
            BigMapBase_Cache.Clear();
            BigMapBigCell_Cache.Clear();
            BigMapCellLogic_Cache.Clear();
            BigMapEvent_Cache.Clear();
            ChapterBase_Cache.Clear();
            ChapterCopyBase_Cache.Clear();
            CopyBrush_Cache.Clear();
            BrushPoint_Cache.Clear();
            WaveBase_Cache.Clear();
            ChapterCopyUI_Cache.Clear();
            UnitData_Cache.Clear();
            BulletData_Cache.Clear();
            BaseObjectShow_Cache.Clear();
            ObjectBottomBar_Cache.Clear();
            ObjectSideBar_Cache.Clear();
            AttributeBase_Cache.Clear();
            AttributeTemplate_Cache.Clear();
            AttributeData_Cache.Clear();
            AttrCalculate_Cache.Clear();
            AttrDependency_Cache.Clear();
            BuildData_Cache.Clear();
            BuildRule_Cache.Clear();
            WeaponData_Cache.Clear();
            WeaponBase_Cache.Clear();
            TowerData_Cache.Clear();
            MapBuildLable_Cache.Clear();
            MapBuildList_Cache.Clear();
            Buff_Cache.Clear();
            CampBase_Cache.Clear();
            GameDiffBase_Cache.Clear();
            BagData_Cache.Clear();
            MoneyBase_Cache.Clear();
            ItemData_Cache.Clear();
            ErrorBase_Cache.Clear();
        }

    }
}