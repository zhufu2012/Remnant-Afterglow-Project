using System;
using System.Collections.Generic;
using GameLog;
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
            LoadBuffTag();
            LoadBuffData();
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
            LoadGlobalConfigPng();
            LoadGlobalConfigStr();
            LoadGlobalConfigFloat();
            LoadGlobalConfigList();
            LoadFunctionTemplate();
            LoadCameraBase();
            LoadCameraAssemblyBase();
            LoadAnimaUnit();
            LoadAnimaTower();
            LoadAnimaBuild();
            LoadAnimaWeapon();
            LoadAnimaBullet();
            LoadAnimaExplode();
            LoadSequenceMapBase();
            LoadSpeciallyEffect();
            LoadMapMassif();
            LoadMapImageLayer();
            LoadMapPhysicsLayer();
            LoadMapNavigate();
            LoadMapMaterial();
            LoadGenerateFixedMap();
            LoadGenerateBottomMap();
            LoadMapExtraDraw();
            LoadGenerateBigStruct();
            LoadMapPassType();
            LoadMapEdge();
            LoadBigMapMaterial();
            LoadBigMapBase();
            LoadBigMapBigCell();
            LoadBigMapCellLogic();
            LoadBigMapEvent();
            LoadUnitGroupType();
            LoadUnitGroupData();
            LoadChapterBase();
            LoadChapterCopyBase();
            LoadCopyBrush();
            LoadBrushPoint();
            LoadWaveBase();
            LoadChapterCopyUI();
            LoadBackgroundMusic();
            LoadSoundEffect();
            LoadBulletScript();
            LoadBulletAction();
            LoadBulletFire();
            LoadBulletScene();
            LoadBulletData();
            LoadBulletLogic();
            LoadBulletCollide();
            LoadExplodeData();
            LoadExplodeHarm();
            LoadUnitData();
            LoadUnitLogic();
            LoadAttrEvent();
            LoadBaseObjectShow();
            LoadObjectBottomBar();
            LoadObjectSideBar();
            LoadBaseObjectData();
            LoadBaseObjectWeapon();
            LoadBuildData();
            LoadWorkerData();
            LoadWeaponData();
            LoadWeaponData2();
            LoadTowerData();
            LoadAttributeBase();
            LoadAttrCalculate();
            LoadAttrDependency();
            LoadAttributeTemplate();
            LoadAttributeData();
            LoadAttrModifier();
            LoadMapBuildLable();
            LoadMapBuildList();
            LoadBuildRule();
            LoadCampBase();
            LoadGameDiffBase();
            LoadBagData();
            LoadMoneyBase();
            LoadItemData();
            LoadErrorBase();
        }


        #region buff配置
        /// <summary>
        /// buff标签数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuffTag> BuffTag_Cache = new Dictionary<string, BuffTag>();
        /// <summary>
        /// 提前加载所有buff标签数据配置缓存
        /// </summary>
        public static void LoadBuffTag()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuffTag);
            foreach (var val in cfg_dict)
            {
                BuffTag data = new BuffTag(val.Value);
                data.InitData2();
                BuffTag_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的buff标签数据基础配置缓存
        /// </summary>
        public static BuffTag GetBuffTag(string cfgId)
        {
            if (!BuffTag_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BuffTag(cfgId);
                    data.InitData2();
                    BuffTag_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("buff配置.xlsx表中的 cfg_BuffTag配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BuffTag GetBuffTag(int cfgId)
        {
            if (!BuffTag_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BuffTag(cfgId);
                    data.InitData2();
                    BuffTag_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("buff配置.xlsx表中的 cfg_BuffTag配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有buff标签数据数据
        /// </summary>
        public static List<BuffTag> GetAllBuffTag()
        {
            List<BuffTag> list = new List<BuffTag>();
            foreach (var val in BuffTag_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// buff基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuffData> BuffData_Cache = new Dictionary<string, BuffData>();
        /// <summary>
        /// 提前加载所有buff基础数据配置缓存
        /// </summary>
        public static void LoadBuffData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuffData);
            foreach (var val in cfg_dict)
            {
                BuffData data = new BuffData(val.Value);
                data.InitData2();
                BuffData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的buff基础数据基础配置缓存
        /// </summary>
        public static BuffData GetBuffData(string cfgId)
        {
            if (!BuffData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BuffData(cfgId);
                    data.InitData2();
                    BuffData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("buff配置.xlsx表中的 cfg_BuffData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BuffData GetBuffData(int cfgId)
        {
            if (!BuffData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BuffData(cfgId);
                    data.InitData2();
                    BuffData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("buff配置.xlsx表中的 cfg_BuffData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有buff基础数据数据
        /// </summary>
        public static List<BuffData> GetAllBuffData()
        {
            List<BuffData> list = new List<BuffData>();
            foreach (var val in BuffData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
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
                try
                {
                    data = new ViewBase(cfgId);
                    data.InitData2();
                    ViewBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("Ui界面配置.xlsx表中的 cfg_ViewBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ViewBase GetViewBase(int cfgId)
        {
            if (!ViewBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ViewBase(cfgId);
                    data.InitData2();
                    ViewBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("Ui界面配置.xlsx表中的 cfg_ViewBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new UpdateLog(cfgId);
                    data.InitData2();
                    UpdateLog_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("主界面更新日志.xlsx表中的 cfg_UpdateLog配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static UpdateLog GetUpdateLog(int cfgId)
        {
            if (!UpdateLog_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new UpdateLog(cfgId);
                    data.InitData2();
                    UpdateLog_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("主界面更新日志.xlsx表中的 cfg_UpdateLog配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AttainmentPage(cfgId);
                    data.InitData2();
                    AttainmentPage_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("数据库界面及成就相关配置.xlsx表中的 cfg_AttainmentPage配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttainmentPage GetAttainmentPage(int cfgId)
        {
            if (!AttainmentPage_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttainmentPage(cfgId);
                    data.InitData2();
                    AttainmentPage_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("数据库界面及成就相关配置.xlsx表中的 cfg_AttainmentPage配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AttainmentBase(cfgId);
                    data.InitData2();
                    AttainmentBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("数据库界面及成就相关配置.xlsx表中的 cfg_AttainmentBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttainmentBase GetAttainmentBase(int cfgId)
        {
            if (!AttainmentBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttainmentBase(cfgId);
                    data.InitData2();
                    AttainmentBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("数据库界面及成就相关配置.xlsx表中的 cfg_AttainmentBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ScienceRange(cfgId);
                    data.InitData2();
                    ScienceRange_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("科技树解锁界面相关配置.xlsx表中的 cfg_ScienceRange配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ScienceRange GetScienceRange(int cfgId)
        {
            if (!ScienceRange_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ScienceRange(cfgId);
                    data.InitData2();
                    ScienceRange_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("科技树解锁界面相关配置.xlsx表中的 cfg_ScienceRange配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ScienceBase(cfgId);
                    data.InitData2();
                    ScienceBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("科技树解锁界面相关配置.xlsx表中的 cfg_ScienceBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ScienceBase GetScienceBase(int cfgId)
        {
            if (!ScienceBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ScienceBase(cfgId);
                    data.InitData2();
                    ScienceBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("科技树解锁界面相关配置.xlsx表中的 cfg_ScienceBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ScienceData(cfgId);
                    data.InitData2();
                    ScienceData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("科技树解锁界面相关配置.xlsx表中的 cfg_ScienceData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ScienceData GetScienceData(int cfgId)
        {
            if (!ScienceData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ScienceData(cfgId);
                    data.InitData2();
                    ScienceData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("科技树解锁界面相关配置.xlsx表中的 cfg_ScienceData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ItemDeployData(cfgId);
                    data.InitData2();
                    ItemDeployData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置界面相关.xlsx表中的 cfg_ItemDeployData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ItemDeployData GetItemDeployData(int cfgId)
        {
            if (!ItemDeployData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ItemDeployData(cfgId);
                    data.InitData2();
                    ItemDeployData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置界面相关.xlsx表中的 cfg_ItemDeployData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new CorePlugDeployData(cfgId);
                    data.InitData2();
                    CorePlugDeployData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置界面相关.xlsx表中的 cfg_CorePlugDeployData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static CorePlugDeployData GetCorePlugDeployData(int cfgId)
        {
            if (!CorePlugDeployData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new CorePlugDeployData(cfgId);
                    data.InitData2();
                    CorePlugDeployData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置界面相关.xlsx表中的 cfg_CorePlugDeployData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ScienceDeployData(cfgId);
                    data.InitData2();
                    ScienceDeployData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置界面相关.xlsx表中的 cfg_ScienceDeployData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ScienceDeployData GetScienceDeployData(int cfgId)
        {
            if (!ScienceDeployData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ScienceDeployData(cfgId);
                    data.InitData2();
                    ScienceDeployData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置界面相关.xlsx表中的 cfg_ScienceDeployData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ConfigCover(cfgId);
                    data.InitData2();
                    ConfigCover_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置特殊功能表.xlsx表中的 cfg_ConfigCover配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ConfigCover GetConfigCover(int cfgId)
        {
            if (!ConfigCover_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ConfigCover(cfgId);
                    data.InitData2();
                    ConfigCover_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置特殊功能表.xlsx表中的 cfg_ConfigCover配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ConfigCall(cfgId);
                    data.InitData2();
                    ConfigCall_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置特殊功能表.xlsx表中的 cfg_ConfigCall配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ConfigCall GetConfigCall(int cfgId)
        {
            if (!ConfigCall_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ConfigCall(cfgId);
                    data.InitData2();
                    ConfigCall_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("配置特殊功能表.xlsx表中的 cfg_ConfigCall配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new GlobalConfigInt(cfgId);
                    data.InitData2();
                    GlobalConfigInt_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigInt配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalConfigInt GetGlobalConfigInt(int cfgId)
        {
            if (!GlobalConfigInt_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalConfigInt(cfgId);
                    data.InitData2();
                    GlobalConfigInt_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigInt配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        /// Png散图配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigPng> GlobalConfigPng_Cache = new Dictionary<string, GlobalConfigPng>();
        /// <summary>
        /// 提前加载所有Png散图配置缓存
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
        /// 加载或获取已缓存的Png散图基础配置缓存
        /// </summary>
        public static GlobalConfigPng GetGlobalConfigPng(string cfgId)
        {
            if (!GlobalConfigPng_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GlobalConfigPng(cfgId);
                    data.InitData2();
                    GlobalConfigPng_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigPng配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalConfigPng GetGlobalConfigPng(int cfgId)
        {
            if (!GlobalConfigPng_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalConfigPng(cfgId);
                    data.InitData2();
                    GlobalConfigPng_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigPng配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有Png散图数据
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
                try
                {
                    data = new GlobalConfigStr(cfgId);
                    data.InitData2();
                    GlobalConfigStr_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigStr配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalConfigStr GetGlobalConfigStr(int cfgId)
        {
            if (!GlobalConfigStr_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalConfigStr(cfgId);
                    data.InitData2();
                    GlobalConfigStr_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigStr配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new GlobalConfigFloat(cfgId);
                    data.InitData2();
                    GlobalConfigFloat_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigFloat配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalConfigFloat GetGlobalConfigFloat(int cfgId)
        {
            if (!GlobalConfigFloat_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalConfigFloat(cfgId);
                    data.InitData2();
                    GlobalConfigFloat_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigFloat配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new GlobalConfigList(cfgId);
                    data.InitData2();
                    GlobalConfigList_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigList配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalConfigList GetGlobalConfigList(int cfgId)
        {
            if (!GlobalConfigList_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalConfigList(cfgId);
                    data.InitData2();
                    GlobalConfigList_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("默认配置表.xlsx表中的 cfg_GlobalConfigList配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new FunctionTemplate(cfgId);
                    data.InitData2();
                    FunctionTemplate_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("函数模板.xlsx表中的 cfg_FunctionTemplate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static FunctionTemplate GetFunctionTemplate(int cfgId)
        {
            if (!FunctionTemplate_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new FunctionTemplate(cfgId);
                    data.InitData2();
                    FunctionTemplate_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("函数模板.xlsx表中的 cfg_FunctionTemplate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new CameraBase(cfgId);
                    data.InitData2();
                    CameraBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("相机.xlsx表中的 cfg_CameraBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static CameraBase GetCameraBase(int cfgId)
        {
            if (!CameraBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new CameraBase(cfgId);
                    data.InitData2();
                    CameraBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("相机.xlsx表中的 cfg_CameraBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new CameraAssemblyBase(cfgId);
                    data.InitData2();
                    CameraAssemblyBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("相机.xlsx表中的 cfg_CameraAssemblyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static CameraAssemblyBase GetCameraAssemblyBase(int cfgId)
        {
            if (!CameraAssemblyBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new CameraAssemblyBase(cfgId);
                    data.InitData2();
                    CameraAssemblyBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("相机.xlsx表中的 cfg_CameraAssemblyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AnimaUnit(cfgId);
                    data.InitData2();
                    AnimaUnit_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaUnit配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaUnit GetAnimaUnit(int cfgId)
        {
            if (!AnimaUnit_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaUnit(cfgId);
                    data.InitData2();
                    AnimaUnit_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaUnit配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AnimaTower(cfgId);
                    data.InitData2();
                    AnimaTower_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaTower配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaTower GetAnimaTower(int cfgId)
        {
            if (!AnimaTower_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaTower(cfgId);
                    data.InitData2();
                    AnimaTower_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaTower配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AnimaBuild(cfgId);
                    data.InitData2();
                    AnimaBuild_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaBuild配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaBuild GetAnimaBuild(int cfgId)
        {
            if (!AnimaBuild_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaBuild(cfgId);
                    data.InitData2();
                    AnimaBuild_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaBuild配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AnimaWeapon(cfgId);
                    data.InitData2();
                    AnimaWeapon_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaWeapon配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaWeapon GetAnimaWeapon(int cfgId)
        {
            if (!AnimaWeapon_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaWeapon(cfgId);
                    data.InitData2();
                    AnimaWeapon_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaWeapon配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AnimaBullet(cfgId);
                    data.InitData2();
                    AnimaBullet_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaBullet配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaBullet GetAnimaBullet(int cfgId)
        {
            if (!AnimaBullet_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaBullet(cfgId);
                    data.InitData2();
                    AnimaBullet_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaBullet配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        /// <summary>
        /// 爆炸动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaExplode> AnimaExplode_Cache = new Dictionary<string, AnimaExplode>();
        /// <summary>
        /// 提前加载所有爆炸动画配置缓存
        /// </summary>
        public static void LoadAnimaExplode()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaExplode);
            foreach (var val in cfg_dict)
            {
                AnimaExplode data = new AnimaExplode(val.Value);
                data.InitData2();
                AnimaExplode_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的爆炸动画基础配置缓存
        /// </summary>
        public static AnimaExplode GetAnimaExplode(string cfgId)
        {
            if (!AnimaExplode_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaExplode(cfgId);
                    data.InitData2();
                    AnimaExplode_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaExplode配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaExplode GetAnimaExplode(int cfgId)
        {
            if (!AnimaExplode_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaExplode(cfgId);
                    data.InitData2();
                    AnimaExplode_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaExplode配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有爆炸动画数据
        /// </summary>
        public static List<AnimaExplode> GetAllAnimaExplode()
        {
            List<AnimaExplode> list = new List<AnimaExplode>();
            foreach (var val in AnimaExplode_Cache)
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
                try
                {
                    data = new SequenceMapBase(cfgId);
                    data.InitData2();
                    SequenceMapBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("序列图.xlsx表中的 cfg_SequenceMapBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static SequenceMapBase GetSequenceMapBase(int cfgId)
        {
            if (!SequenceMapBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new SequenceMapBase(cfgId);
                    data.InitData2();
                    SequenceMapBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("序列图.xlsx表中的 cfg_SequenceMapBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new SpeciallyEffect(cfgId);
                    data.InitData2();
                    SpeciallyEffect_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("特效.xlsx表中的 cfg_SpeciallyEffect配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static SpeciallyEffect GetSpeciallyEffect(int cfgId)
        {
            if (!SpeciallyEffect_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new SpeciallyEffect(cfgId);
                    data.InitData2();
                    SpeciallyEffect_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("特效.xlsx表中的 cfg_SpeciallyEffect配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        #region 图块相关
        /// <summary>
        /// 地图资源图集配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapMassif> MapMassif_Cache = new Dictionary<string, MapMassif>();
        /// <summary>
        /// 提前加载所有地图资源图集配置缓存
        /// </summary>
        public static void LoadMapMassif()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapMassif);
            foreach (var val in cfg_dict)
            {
                MapMassif data = new MapMassif(val.Value);
                data.InitData2();
                MapMassif_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图资源图集基础配置缓存
        /// </summary>
        public static MapMassif GetMapMassif(string cfgId)
        {
            if (!MapMassif_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapMassif(cfgId);
                    data.InitData2();
                    MapMassif_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图块相关.xlsx表中的 cfg_MapMassif配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapMassif GetMapMassif(int cfgId)
        {
            if (!MapMassif_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapMassif(cfgId);
                    data.InitData2();
                    MapMassif_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图块相关.xlsx表中的 cfg_MapMassif配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图资源图集数据
        /// </summary>
        public static List<MapMassif> GetAllMapMassif()
        {
            List<MapMassif> list = new List<MapMassif>();
            foreach (var val in MapMassif_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 图层相关
        /// <summary>
        /// 图像层配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapImageLayer> MapImageLayer_Cache = new Dictionary<string, MapImageLayer>();
        /// <summary>
        /// 提前加载所有图像层配置配置缓存
        /// </summary>
        public static void LoadMapImageLayer()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapImageLayer);
            foreach (var val in cfg_dict)
            {
                MapImageLayer data = new MapImageLayer(val.Value);
                data.InitData2();
                MapImageLayer_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的图像层配置基础配置缓存
        /// </summary>
        public static MapImageLayer GetMapImageLayer(string cfgId)
        {
            if (!MapImageLayer_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapImageLayer(cfgId);
                    data.InitData2();
                    MapImageLayer_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图层相关.xlsx表中的 cfg_MapImageLayer配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapImageLayer GetMapImageLayer(int cfgId)
        {
            if (!MapImageLayer_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapImageLayer(cfgId);
                    data.InitData2();
                    MapImageLayer_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图层相关.xlsx表中的 cfg_MapImageLayer配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有图像层配置数据
        /// </summary>
        public static List<MapImageLayer> GetAllMapImageLayer()
        {
            List<MapImageLayer> list = new List<MapImageLayer>();
            foreach (var val in MapImageLayer_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 物理层配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapPhysicsLayer> MapPhysicsLayer_Cache = new Dictionary<string, MapPhysicsLayer>();
        /// <summary>
        /// 提前加载所有物理层配置配置缓存
        /// </summary>
        public static void LoadMapPhysicsLayer()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapPhysicsLayer);
            foreach (var val in cfg_dict)
            {
                MapPhysicsLayer data = new MapPhysicsLayer(val.Value);
                data.InitData2();
                MapPhysicsLayer_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的物理层配置基础配置缓存
        /// </summary>
        public static MapPhysicsLayer GetMapPhysicsLayer(string cfgId)
        {
            if (!MapPhysicsLayer_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapPhysicsLayer(cfgId);
                    data.InitData2();
                    MapPhysicsLayer_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图层相关.xlsx表中的 cfg_MapPhysicsLayer配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapPhysicsLayer GetMapPhysicsLayer(int cfgId)
        {
            if (!MapPhysicsLayer_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapPhysicsLayer(cfgId);
                    data.InitData2();
                    MapPhysicsLayer_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图层相关.xlsx表中的 cfg_MapPhysicsLayer配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有物理层配置数据
        /// </summary>
        public static List<MapPhysicsLayer> GetAllMapPhysicsLayer()
        {
            List<MapPhysicsLayer> list = new List<MapPhysicsLayer>();
            foreach (var val in MapPhysicsLayer_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 地图导航层配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapNavigate> MapNavigate_Cache = new Dictionary<string, MapNavigate>();
        /// <summary>
        /// 提前加载所有地图导航层配置缓存
        /// </summary>
        public static void LoadMapNavigate()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapNavigate);
            foreach (var val in cfg_dict)
            {
                MapNavigate data = new MapNavigate(val.Value);
                data.InitData2();
                MapNavigate_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图导航层基础配置缓存
        /// </summary>
        public static MapNavigate GetMapNavigate(string cfgId)
        {
            if (!MapNavigate_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapNavigate(cfgId);
                    data.InitData2();
                    MapNavigate_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图层相关.xlsx表中的 cfg_MapNavigate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapNavigate GetMapNavigate(int cfgId)
        {
            if (!MapNavigate_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapNavigate(cfgId);
                    data.InitData2();
                    MapNavigate_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("图层相关.xlsx表中的 cfg_MapNavigate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图导航层数据
        /// </summary>
        public static List<MapNavigate> GetAllMapNavigate()
        {
            List<MapNavigate> list = new List<MapNavigate>();
            foreach (var val in MapNavigate_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 地图生成
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
                try
                {
                    data = new MapMaterial(cfgId);
                    data.InitData2();
                    MapMaterial_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapMaterial GetMapMaterial(int cfgId)
        {
            if (!MapMaterial_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapMaterial(cfgId);
                    data.InitData2();
                    MapMaterial_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        /// 固定地图配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, GenerateFixedMap> GenerateFixedMap_Cache = new Dictionary<string, GenerateFixedMap>();
        /// <summary>
        /// 提前加载所有固定地图配置配置缓存
        /// </summary>
        public static void LoadGenerateFixedMap()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_GenerateFixedMap);
            foreach (var val in cfg_dict)
            {
                GenerateFixedMap data = new GenerateFixedMap(val.Value);
                data.InitData2();
                GenerateFixedMap_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的固定地图配置基础配置缓存
        /// </summary>
        public static GenerateFixedMap GetGenerateFixedMap(string cfgId)
        {
            if (!GenerateFixedMap_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GenerateFixedMap(cfgId);
                    data.InitData2();
                    GenerateFixedMap_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_GenerateFixedMap配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GenerateFixedMap GetGenerateFixedMap(int cfgId)
        {
            if (!GenerateFixedMap_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GenerateFixedMap(cfgId);
                    data.InitData2();
                    GenerateFixedMap_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_GenerateFixedMap配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有固定地图配置数据
        /// </summary>
        public static List<GenerateFixedMap> GetAllGenerateFixedMap()
        {
            List<GenerateFixedMap> list = new List<GenerateFixedMap>();
            foreach (var val in GenerateFixedMap_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
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
                try
                {
                    data = new GenerateBottomMap(cfgId);
                    data.InitData2();
                    GenerateBottomMap_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_GenerateBottomMap配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GenerateBottomMap GetGenerateBottomMap(int cfgId)
        {
            if (!GenerateBottomMap_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GenerateBottomMap(cfgId);
                    data.InitData2();
                    GenerateBottomMap_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_GenerateBottomMap配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new MapExtraDraw(cfgId);
                    data.InitData2();
                    MapExtraDraw_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapExtraDraw配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapExtraDraw GetMapExtraDraw(int cfgId)
        {
            if (!MapExtraDraw_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapExtraDraw(cfgId);
                    data.InitData2();
                    MapExtraDraw_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapExtraDraw配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new GenerateBigStruct(cfgId);
                    data.InitData2();
                    GenerateBigStruct_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_GenerateBigStruct配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GenerateBigStruct GetGenerateBigStruct(int cfgId)
        {
            if (!GenerateBigStruct_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GenerateBigStruct(cfgId);
                    data.InitData2();
                    GenerateBigStruct_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_GenerateBigStruct配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new MapPassType(cfgId);
                    data.InitData2();
                    MapPassType_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapPassType配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapPassType GetMapPassType(int cfgId)
        {
            if (!MapPassType_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapPassType(cfgId);
                    data.InitData2();
                    MapPassType_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapPassType配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        /// <summary>
        /// 地图边缘连接配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapEdge> MapEdge_Cache = new Dictionary<string, MapEdge>();
        /// <summary>
        /// 提前加载所有地图边缘连接配置配置缓存
        /// </summary>
        public static void LoadMapEdge()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapEdge);
            foreach (var val in cfg_dict)
            {
                MapEdge data = new MapEdge(val.Value);
                data.InitData2();
                MapEdge_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图边缘连接配置基础配置缓存
        /// </summary>
        public static MapEdge GetMapEdge(string cfgId)
        {
            if (!MapEdge_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapEdge(cfgId);
                    data.InitData2();
                    MapEdge_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapEdge配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapEdge GetMapEdge(int cfgId)
        {
            if (!MapEdge_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapEdge(cfgId);
                    data.InitData2();
                    MapEdge_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapEdge配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图边缘连接配置数据
        /// </summary>
        public static List<MapEdge> GetAllMapEdge()
        {
            List<MapEdge> list = new List<MapEdge>();
            foreach (var val in MapEdge_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 大地图生成
        /// <summary>
        /// 大地图节点配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapMaterial> BigMapMaterial_Cache = new Dictionary<string, BigMapMaterial>();
        /// <summary>
        /// 提前加载所有大地图节点配置缓存
        /// </summary>
        public static void LoadBigMapMaterial()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapMaterial);
            foreach (var val in cfg_dict)
            {
                BigMapMaterial data = new BigMapMaterial(val.Value);
                data.InitData2();
                BigMapMaterial_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的大地图节点基础配置缓存
        /// </summary>
        public static BigMapMaterial GetBigMapMaterial(string cfgId)
        {
            if (!BigMapMaterial_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BigMapMaterial(cfgId);
                    data.InitData2();
                    BigMapMaterial_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BigMapMaterial GetBigMapMaterial(int cfgId)
        {
            if (!BigMapMaterial_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BigMapMaterial(cfgId);
                    data.InitData2();
                    BigMapMaterial_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有大地图节点数据
        /// </summary>
        public static List<BigMapMaterial> GetAllBigMapMaterial()
        {
            List<BigMapMaterial> list = new List<BigMapMaterial>();
            foreach (var val in BigMapMaterial_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
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
                try
                {
                    data = new BigMapBase(cfgId);
                    data.InitData2();
                    BigMapBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BigMapBase GetBigMapBase(int cfgId)
        {
            if (!BigMapBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BigMapBase(cfgId);
                    data.InitData2();
                    BigMapBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new BigMapBigCell(cfgId);
                    data.InitData2();
                    BigMapBigCell_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapBigCell配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BigMapBigCell GetBigMapBigCell(int cfgId)
        {
            if (!BigMapBigCell_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BigMapBigCell(cfgId);
                    data.InitData2();
                    BigMapBigCell_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapBigCell配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new BigMapCellLogic(cfgId);
                    data.InitData2();
                    BigMapCellLogic_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapCellLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BigMapCellLogic GetBigMapCellLogic(int cfgId)
        {
            if (!BigMapCellLogic_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BigMapCellLogic(cfgId);
                    data.InitData2();
                    BigMapCellLogic_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapCellLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new BigMapEvent(cfgId);
                    data.InitData2();
                    BigMapEvent_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BigMapEvent GetBigMapEvent(int cfgId)
        {
            if (!BigMapEvent_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BigMapEvent(cfgId);
                    data.InitData2();
                    BigMapEvent_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("大地图生成.xlsx表中的 cfg_BigMapEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        #region 单位组配置
        /// <summary>
        /// 单位组类型配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitGroupType> UnitGroupType_Cache = new Dictionary<string, UnitGroupType>();
        /// <summary>
        /// 提前加载所有单位组类型配置缓存
        /// </summary>
        public static void LoadUnitGroupType()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitGroupType);
            foreach (var val in cfg_dict)
            {
                UnitGroupType data = new UnitGroupType(val.Value);
                data.InitData2();
                UnitGroupType_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的单位组类型基础配置缓存
        /// </summary>
        public static UnitGroupType GetUnitGroupType(string cfgId)
        {
            if (!UnitGroupType_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new UnitGroupType(cfgId);
                    data.InitData2();
                    UnitGroupType_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位组配置.xlsx表中的 cfg_UnitGroupType配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static UnitGroupType GetUnitGroupType(int cfgId)
        {
            if (!UnitGroupType_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new UnitGroupType(cfgId);
                    data.InitData2();
                    UnitGroupType_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位组配置.xlsx表中的 cfg_UnitGroupType配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位组类型数据
        /// </summary>
        public static List<UnitGroupType> GetAllUnitGroupType()
        {
            List<UnitGroupType> list = new List<UnitGroupType>();
            foreach (var val in UnitGroupType_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 单位组配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitGroupData> UnitGroupData_Cache = new Dictionary<string, UnitGroupData>();
        /// <summary>
        /// 提前加载所有单位组配置配置缓存
        /// </summary>
        public static void LoadUnitGroupData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitGroupData);
            foreach (var val in cfg_dict)
            {
                UnitGroupData data = new UnitGroupData(val.Value);
                data.InitData2();
                UnitGroupData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的单位组配置基础配置缓存
        /// </summary>
        public static UnitGroupData GetUnitGroupData(string cfgId)
        {
            if (!UnitGroupData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new UnitGroupData(cfgId);
                    data.InitData2();
                    UnitGroupData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位组配置.xlsx表中的 cfg_UnitGroupData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static UnitGroupData GetUnitGroupData(int cfgId)
        {
            if (!UnitGroupData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new UnitGroupData(cfgId);
                    data.InitData2();
                    UnitGroupData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位组配置.xlsx表中的 cfg_UnitGroupData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位组配置数据
        /// </summary>
        public static List<UnitGroupData> GetAllUnitGroupData()
        {
            List<UnitGroupData> list = new List<UnitGroupData>();
            foreach (var val in UnitGroupData_Cache)
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
                try
                {
                    data = new ChapterBase(cfgId);
                    data.InitData2();
                    ChapterBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ChapterBase GetChapterBase(int cfgId)
        {
            if (!ChapterBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ChapterBase(cfgId);
                    data.InitData2();
                    ChapterBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ChapterCopyBase(cfgId);
                    data.InitData2();
                    ChapterCopyBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterCopyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ChapterCopyBase GetChapterCopyBase(int cfgId)
        {
            if (!ChapterCopyBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ChapterCopyBase(cfgId);
                    data.InitData2();
                    ChapterCopyBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterCopyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new CopyBrush(cfgId);
                    data.InitData2();
                    CopyBrush_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_CopyBrush配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static CopyBrush GetCopyBrush(int cfgId)
        {
            if (!CopyBrush_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new CopyBrush(cfgId);
                    data.InitData2();
                    CopyBrush_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_CopyBrush配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new BrushPoint(cfgId);
                    data.InitData2();
                    BrushPoint_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_BrushPoint配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BrushPoint GetBrushPoint(int cfgId)
        {
            if (!BrushPoint_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BrushPoint(cfgId);
                    data.InitData2();
                    BrushPoint_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_BrushPoint配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new WaveBase(cfgId);
                    data.InitData2();
                    WaveBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_WaveBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static WaveBase GetWaveBase(int cfgId)
        {
            if (!WaveBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new WaveBase(cfgId);
                    data.InitData2();
                    WaveBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_WaveBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ChapterCopyUI(cfgId);
                    data.InitData2();
                    ChapterCopyUI_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterCopyUI配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ChapterCopyUI GetChapterCopyUI(int cfgId)
        {
            if (!ChapterCopyUI_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ChapterCopyUI(cfgId);
                    data.InitData2();
                    ChapterCopyUI_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterCopyUI配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        #region 音乐配置
        /// <summary>
        /// 背景音乐配置缓存
        /// </summary>
        private static readonly Dictionary<string, BackgroundMusic> BackgroundMusic_Cache = new Dictionary<string, BackgroundMusic>();
        /// <summary>
        /// 提前加载所有背景音乐配置缓存
        /// </summary>
        public static void LoadBackgroundMusic()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BackgroundMusic);
            foreach (var val in cfg_dict)
            {
                BackgroundMusic data = new BackgroundMusic(val.Value);
                data.InitData2();
                BackgroundMusic_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的背景音乐基础配置缓存
        /// </summary>
        public static BackgroundMusic GetBackgroundMusic(string cfgId)
        {
            if (!BackgroundMusic_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BackgroundMusic(cfgId);
                    data.InitData2();
                    BackgroundMusic_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("音乐配置.xlsx表中的 cfg_BackgroundMusic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BackgroundMusic GetBackgroundMusic(int cfgId)
        {
            if (!BackgroundMusic_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BackgroundMusic(cfgId);
                    data.InitData2();
                    BackgroundMusic_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("音乐配置.xlsx表中的 cfg_BackgroundMusic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有背景音乐数据
        /// </summary>
        public static List<BackgroundMusic> GetAllBackgroundMusic()
        {
            List<BackgroundMusic> list = new List<BackgroundMusic>();
            foreach (var val in BackgroundMusic_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 音效配置
        /// <summary>
        /// 音效配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, SoundEffect> SoundEffect_Cache = new Dictionary<string, SoundEffect>();
        /// <summary>
        /// 提前加载所有音效配置配置缓存
        /// </summary>
        public static void LoadSoundEffect()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_SoundEffect);
            foreach (var val in cfg_dict)
            {
                SoundEffect data = new SoundEffect(val.Value);
                data.InitData2();
                SoundEffect_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的音效配置基础配置缓存
        /// </summary>
        public static SoundEffect GetSoundEffect(string cfgId)
        {
            if (!SoundEffect_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new SoundEffect(cfgId);
                    data.InitData2();
                    SoundEffect_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("音效配置.xlsx表中的 cfg_SoundEffect配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static SoundEffect GetSoundEffect(int cfgId)
        {
            if (!SoundEffect_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new SoundEffect(cfgId);
                    data.InitData2();
                    SoundEffect_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("音效配置.xlsx表中的 cfg_SoundEffect配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有音效配置数据
        /// </summary>
        public static List<SoundEffect> GetAllSoundEffect()
        {
            List<SoundEffect> list = new List<SoundEffect>();
            foreach (var val in SoundEffect_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 子弹脚本配置
        /// <summary>
        /// 子弹脚本配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletScript> BulletScript_Cache = new Dictionary<string, BulletScript>();
        /// <summary>
        /// 提前加载所有子弹脚本配置配置缓存
        /// </summary>
        public static void LoadBulletScript()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletScript);
            foreach (var val in cfg_dict)
            {
                BulletScript data = new BulletScript(val.Value);
                data.InitData2();
                BulletScript_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹脚本配置基础配置缓存
        /// </summary>
        public static BulletScript GetBulletScript(string cfgId)
        {
            if (!BulletScript_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletScript(cfgId);
                    data.InitData2();
                    BulletScript_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹脚本配置.xlsx表中的 cfg_BulletScript配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletScript GetBulletScript(int cfgId)
        {
            if (!BulletScript_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletScript(cfgId);
                    data.InitData2();
                    BulletScript_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹脚本配置.xlsx表中的 cfg_BulletScript配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹脚本配置数据
        /// </summary>
        public static List<BulletScript> GetAllBulletScript()
        {
            List<BulletScript> list = new List<BulletScript>();
            foreach (var val in BulletScript_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 子弹脚本行为配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletAction> BulletAction_Cache = new Dictionary<string, BulletAction>();
        /// <summary>
        /// 提前加载所有子弹脚本行为配置缓存
        /// </summary>
        public static void LoadBulletAction()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletAction);
            foreach (var val in cfg_dict)
            {
                BulletAction data = new BulletAction(val.Value);
                data.InitData2();
                BulletAction_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹脚本行为基础配置缓存
        /// </summary>
        public static BulletAction GetBulletAction(string cfgId)
        {
            if (!BulletAction_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletAction(cfgId);
                    data.InitData2();
                    BulletAction_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹脚本配置.xlsx表中的 cfg_BulletAction配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletAction GetBulletAction(int cfgId)
        {
            if (!BulletAction_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletAction(cfgId);
                    data.InitData2();
                    BulletAction_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹脚本配置.xlsx表中的 cfg_BulletAction配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹脚本行为数据
        /// </summary>
        public static List<BulletAction> GetAllBulletAction()
        {
            List<BulletAction> list = new List<BulletAction>();
            foreach (var val in BulletAction_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 子弹脚本开火行为配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletFire> BulletFire_Cache = new Dictionary<string, BulletFire>();
        /// <summary>
        /// 提前加载所有子弹脚本开火行为配置缓存
        /// </summary>
        public static void LoadBulletFire()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletFire);
            foreach (var val in cfg_dict)
            {
                BulletFire data = new BulletFire(val.Value);
                data.InitData2();
                BulletFire_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹脚本开火行为基础配置缓存
        /// </summary>
        public static BulletFire GetBulletFire(string cfgId)
        {
            if (!BulletFire_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletFire(cfgId);
                    data.InitData2();
                    BulletFire_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹脚本配置.xlsx表中的 cfg_BulletFire配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletFire GetBulletFire(int cfgId)
        {
            if (!BulletFire_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletFire(cfgId);
                    data.InitData2();
                    BulletFire_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹脚本配置.xlsx表中的 cfg_BulletFire配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹脚本开火行为数据
        /// </summary>
        public static List<BulletFire> GetAllBulletFire()
        {
            List<BulletFire> list = new List<BulletFire>();
            foreach (var val in BulletFire_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 子弹配置
        /// <summary>
        /// 子弹场景数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletScene> BulletScene_Cache = new Dictionary<string, BulletScene>();
        /// <summary>
        /// 提前加载所有子弹场景数据配置缓存
        /// </summary>
        public static void LoadBulletScene()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletScene);
            foreach (var val in cfg_dict)
            {
                BulletScene data = new BulletScene(val.Value);
                data.InitData2();
                BulletScene_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹场景数据基础配置缓存
        /// </summary>
        public static BulletScene GetBulletScene(string cfgId)
        {
            if (!BulletScene_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletScene(cfgId);
                    data.InitData2();
                    BulletScene_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletScene配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletScene GetBulletScene(int cfgId)
        {
            if (!BulletScene_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletScene(cfgId);
                    data.InitData2();
                    BulletScene_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletScene配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹场景数据数据
        /// </summary>
        public static List<BulletScene> GetAllBulletScene()
        {
            List<BulletScene> list = new List<BulletScene>();
            foreach (var val in BulletScene_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 子弹基础数据表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletData> BulletData_Cache = new Dictionary<string, BulletData>();
        /// <summary>
        /// 提前加载所有子弹基础数据表配置缓存
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
        /// 加载或获取已缓存的子弹基础数据表基础配置缓存
        /// </summary>
        public static BulletData GetBulletData(string cfgId)
        {
            if (!BulletData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletData(cfgId);
                    data.InitData2();
                    BulletData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletData GetBulletData(int cfgId)
        {
            if (!BulletData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletData(cfgId);
                    data.InitData2();
                    BulletData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹基础数据表数据
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
        /// <summary>
        /// 子弹逻辑数据表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletLogic> BulletLogic_Cache = new Dictionary<string, BulletLogic>();
        /// <summary>
        /// 提前加载所有子弹逻辑数据表配置缓存
        /// </summary>
        public static void LoadBulletLogic()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletLogic);
            foreach (var val in cfg_dict)
            {
                BulletLogic data = new BulletLogic(val.Value);
                data.InitData2();
                BulletLogic_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹逻辑数据表基础配置缓存
        /// </summary>
        public static BulletLogic GetBulletLogic(string cfgId)
        {
            if (!BulletLogic_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletLogic(cfgId);
                    data.InitData2();
                    BulletLogic_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletLogic GetBulletLogic(int cfgId)
        {
            if (!BulletLogic_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletLogic(cfgId);
                    data.InitData2();
                    BulletLogic_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹逻辑数据表数据
        /// </summary>
        public static List<BulletLogic> GetAllBulletLogic()
        {
            List<BulletLogic> list = new List<BulletLogic>();
            foreach (var val in BulletLogic_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 子弹碰撞数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletCollide> BulletCollide_Cache = new Dictionary<string, BulletCollide>();
        /// <summary>
        /// 提前加载所有子弹碰撞数据配置缓存
        /// </summary>
        public static void LoadBulletCollide()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletCollide);
            foreach (var val in cfg_dict)
            {
                BulletCollide data = new BulletCollide(val.Value);
                data.InitData2();
                BulletCollide_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的子弹碰撞数据基础配置缓存
        /// </summary>
        public static BulletCollide GetBulletCollide(string cfgId)
        {
            if (!BulletCollide_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BulletCollide(cfgId);
                    data.InitData2();
                    BulletCollide_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletCollide配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BulletCollide GetBulletCollide(int cfgId)
        {
            if (!BulletCollide_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BulletCollide(cfgId);
                    data.InitData2();
                    BulletCollide_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletCollide配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有子弹碰撞数据数据
        /// </summary>
        public static List<BulletCollide> GetAllBulletCollide()
        {
            List<BulletCollide> list = new List<BulletCollide>();
            foreach (var val in BulletCollide_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 爆炸配置
        /// <summary>
        /// 爆炸基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ExplodeData> ExplodeData_Cache = new Dictionary<string, ExplodeData>();
        /// <summary>
        /// 提前加载所有爆炸基础数据配置缓存
        /// </summary>
        public static void LoadExplodeData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ExplodeData);
            foreach (var val in cfg_dict)
            {
                ExplodeData data = new ExplodeData(val.Value);
                data.InitData2();
                ExplodeData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的爆炸基础数据基础配置缓存
        /// </summary>
        public static ExplodeData GetExplodeData(string cfgId)
        {
            if (!ExplodeData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new ExplodeData(cfgId);
                    data.InitData2();
                    ExplodeData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("爆炸配置.xlsx表中的 cfg_ExplodeData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ExplodeData GetExplodeData(int cfgId)
        {
            if (!ExplodeData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ExplodeData(cfgId);
                    data.InitData2();
                    ExplodeData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("爆炸配置.xlsx表中的 cfg_ExplodeData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有爆炸基础数据数据
        /// </summary>
        public static List<ExplodeData> GetAllExplodeData()
        {
            List<ExplodeData> list = new List<ExplodeData>();
            foreach (var val in ExplodeData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 爆炸伤害数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ExplodeHarm> ExplodeHarm_Cache = new Dictionary<string, ExplodeHarm>();
        /// <summary>
        /// 提前加载所有爆炸伤害数据配置缓存
        /// </summary>
        public static void LoadExplodeHarm()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_ExplodeHarm);
            foreach (var val in cfg_dict)
            {
                ExplodeHarm data = new ExplodeHarm(val.Value);
                data.InitData2();
                ExplodeHarm_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的爆炸伤害数据基础配置缓存
        /// </summary>
        public static ExplodeHarm GetExplodeHarm(string cfgId)
        {
            if (!ExplodeHarm_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new ExplodeHarm(cfgId);
                    data.InitData2();
                    ExplodeHarm_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("爆炸配置.xlsx表中的 cfg_ExplodeHarm配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ExplodeHarm GetExplodeHarm(int cfgId)
        {
            if (!ExplodeHarm_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ExplodeHarm(cfgId);
                    data.InitData2();
                    ExplodeHarm_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("爆炸配置.xlsx表中的 cfg_ExplodeHarm配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有爆炸伤害数据数据
        /// </summary>
        public static List<ExplodeHarm> GetAllExplodeHarm()
        {
            List<ExplodeHarm> list = new List<ExplodeHarm>();
            foreach (var val in ExplodeHarm_Cache)
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
                try
                {
                    data = new UnitData(cfgId);
                    data.InitData2();
                    UnitData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位配置.xlsx表中的 cfg_UnitData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static UnitData GetUnitData(int cfgId)
        {
            if (!UnitData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new UnitData(cfgId);
                    data.InitData2();
                    UnitData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位配置.xlsx表中的 cfg_UnitData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        /// <summary>
        /// 单位逻辑表配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitLogic> UnitLogic_Cache = new Dictionary<string, UnitLogic>();
        /// <summary>
        /// 提前加载所有单位逻辑表配置缓存
        /// </summary>
        public static void LoadUnitLogic()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitLogic);
            foreach (var val in cfg_dict)
            {
                UnitLogic data = new UnitLogic(val.Value);
                data.InitData2();
                UnitLogic_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的单位逻辑表基础配置缓存
        /// </summary>
        public static UnitLogic GetUnitLogic(string cfgId)
        {
            if (!UnitLogic_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new UnitLogic(cfgId);
                    data.InitData2();
                    UnitLogic_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位配置.xlsx表中的 cfg_UnitLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static UnitLogic GetUnitLogic(int cfgId)
        {
            if (!UnitLogic_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new UnitLogic(cfgId);
                    data.InitData2();
                    UnitLogic_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("单位配置.xlsx表中的 cfg_UnitLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位逻辑表数据
        /// </summary>
        public static List<UnitLogic> GetAllUnitLogic()
        {
            List<UnitLogic> list = new List<UnitLogic>();
            foreach (var val in UnitLogic_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 实体事件配置
        /// <summary>
        /// 属性事件配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrEvent> AttrEvent_Cache = new Dictionary<string, AttrEvent>();
        /// <summary>
        /// 提前加载所有属性事件配置缓存
        /// </summary>
        public static void LoadAttrEvent()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrEvent);
            foreach (var val in cfg_dict)
            {
                AttrEvent data = new AttrEvent(val.Value);
                data.InitData2();
                AttrEvent_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性事件基础配置缓存
        /// </summary>
        public static AttrEvent GetAttrEvent(string cfgId)
        {
            if (!AttrEvent_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AttrEvent(cfgId);
                    data.InitData2();
                    AttrEvent_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体事件配置.xlsx表中的 cfg_AttrEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttrEvent GetAttrEvent(int cfgId)
        {
            if (!AttrEvent_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttrEvent(cfgId);
                    data.InitData2();
                    AttrEvent_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体事件配置.xlsx表中的 cfg_AttrEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性事件数据
        /// </summary>
        public static List<AttrEvent> GetAllAttrEvent()
        {
            List<AttrEvent> list = new List<AttrEvent>();
            foreach (var val in AttrEvent_Cache)
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
                try
                {
                    data = new BaseObjectShow(cfgId);
                    data.InitData2();
                    BaseObjectShow_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体显示相关配置.xlsx表中的 cfg_BaseObjectShow配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BaseObjectShow GetBaseObjectShow(int cfgId)
        {
            if (!BaseObjectShow_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BaseObjectShow(cfgId);
                    data.InitData2();
                    BaseObjectShow_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体显示相关配置.xlsx表中的 cfg_BaseObjectShow配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ObjectBottomBar(cfgId);
                    data.InitData2();
                    ObjectBottomBar_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体显示相关配置.xlsx表中的 cfg_ObjectBottomBar配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ObjectBottomBar GetObjectBottomBar(int cfgId)
        {
            if (!ObjectBottomBar_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ObjectBottomBar(cfgId);
                    data.InitData2();
                    ObjectBottomBar_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体显示相关配置.xlsx表中的 cfg_ObjectBottomBar配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ObjectSideBar(cfgId);
                    data.InitData2();
                    ObjectSideBar_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体显示相关配置.xlsx表中的 cfg_ObjectSideBar配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ObjectSideBar GetObjectSideBar(int cfgId)
        {
            if (!ObjectSideBar_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ObjectSideBar(cfgId);
                    data.InitData2();
                    ObjectSideBar_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体显示相关配置.xlsx表中的 cfg_ObjectSideBar配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        #region 实体相关配置
        /// <summary>
        /// 实体表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BaseObjectData> BaseObjectData_Cache = new Dictionary<string, BaseObjectData>();
        /// <summary>
        /// 提前加载所有实体表配置缓存
        /// </summary>
        public static void LoadBaseObjectData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BaseObjectData);
            foreach (var val in cfg_dict)
            {
                BaseObjectData data = new BaseObjectData(val.Value);
                data.InitData2();
                BaseObjectData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体表基础配置缓存
        /// </summary>
        public static BaseObjectData GetBaseObjectData(string cfgId)
        {
            if (!BaseObjectData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BaseObjectData(cfgId);
                    data.InitData2();
                    BaseObjectData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体相关配置.xlsx表中的 cfg_BaseObjectData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BaseObjectData GetBaseObjectData(int cfgId)
        {
            if (!BaseObjectData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BaseObjectData(cfgId);
                    data.InitData2();
                    BaseObjectData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体相关配置.xlsx表中的 cfg_BaseObjectData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体表数据
        /// </summary>
        public static List<BaseObjectData> GetAllBaseObjectData()
        {
            List<BaseObjectData> list = new List<BaseObjectData>();
            foreach (var val in BaseObjectData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        /// <summary>
        /// 实体武器表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BaseObjectWeapon> BaseObjectWeapon_Cache = new Dictionary<string, BaseObjectWeapon>();
        /// <summary>
        /// 提前加载所有实体武器表配置缓存
        /// </summary>
        public static void LoadBaseObjectWeapon()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_BaseObjectWeapon);
            foreach (var val in cfg_dict)
            {
                BaseObjectWeapon data = new BaseObjectWeapon(val.Value);
                data.InitData2();
                BaseObjectWeapon_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体武器表基础配置缓存
        /// </summary>
        public static BaseObjectWeapon GetBaseObjectWeapon(string cfgId)
        {
            if (!BaseObjectWeapon_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BaseObjectWeapon(cfgId);
                    data.InitData2();
                    BaseObjectWeapon_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体相关配置.xlsx表中的 cfg_BaseObjectWeapon配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BaseObjectWeapon GetBaseObjectWeapon(int cfgId)
        {
            if (!BaseObjectWeapon_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BaseObjectWeapon(cfgId);
                    data.InitData2();
                    BaseObjectWeapon_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("实体相关配置.xlsx表中的 cfg_BaseObjectWeapon配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体武器表数据
        /// </summary>
        public static List<BaseObjectWeapon> GetAllBaseObjectWeapon()
        {
            List<BaseObjectWeapon> list = new List<BaseObjectWeapon>();
            foreach (var val in BaseObjectWeapon_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 建筑配置
        /// <summary>
        /// 建筑数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuildData> BuildData_Cache = new Dictionary<string, BuildData>();
        /// <summary>
        /// 提前加载所有建筑数据配置缓存
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
        /// 加载或获取已缓存的建筑数据基础配置缓存
        /// </summary>
        public static BuildData GetBuildData(string cfgId)
        {
            if (!BuildData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new BuildData(cfgId);
                    data.InitData2();
                    BuildData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建筑配置.xlsx表中的 cfg_BuildData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BuildData GetBuildData(int cfgId)
        {
            if (!BuildData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BuildData(cfgId);
                    data.InitData2();
                    BuildData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建筑配置.xlsx表中的 cfg_BuildData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建筑数据数据
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
        #endregion
        #region 无人机配置
        /// <summary>
        /// 无人机基础表配置缓存
        /// </summary>
        private static readonly Dictionary<string, WorkerData> WorkerData_Cache = new Dictionary<string, WorkerData>();
        /// <summary>
        /// 提前加载所有无人机基础表配置缓存
        /// </summary>
        public static void LoadWorkerData()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_WorkerData);
            foreach (var val in cfg_dict)
            {
                WorkerData data = new WorkerData(val.Value);
                data.InitData2();
                WorkerData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的无人机基础表基础配置缓存
        /// </summary>
        public static WorkerData GetWorkerData(string cfgId)
        {
            if (!WorkerData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new WorkerData(cfgId);
                    data.InitData2();
                    WorkerData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("无人机配置.xlsx表中的 cfg_WorkerData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static WorkerData GetWorkerData(int cfgId)
        {
            if (!WorkerData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new WorkerData(cfgId);
                    data.InitData2();
                    WorkerData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("无人机配置.xlsx表中的 cfg_WorkerData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有无人机基础表数据
        /// </summary>
        public static List<WorkerData> GetAllWorkerData()
        {
            List<WorkerData> list = new List<WorkerData>();
            foreach (var val in WorkerData_Cache)
            {
                list.Add(val.Value);
            }
            return list;
        }
        #endregion
        #region 武器配置
        /// <summary>
        /// 武器数据1配置缓存
        /// </summary>
        private static readonly Dictionary<string, WeaponData> WeaponData_Cache = new Dictionary<string, WeaponData>();
        /// <summary>
        /// 提前加载所有武器数据1配置缓存
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
        /// 加载或获取已缓存的武器数据1基础配置缓存
        /// </summary>
        public static WeaponData GetWeaponData(string cfgId)
        {
            if (!WeaponData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new WeaponData(cfgId);
                    data.InitData2();
                    WeaponData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("武器配置.xlsx表中的 cfg_WeaponData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static WeaponData GetWeaponData(int cfgId)
        {
            if (!WeaponData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new WeaponData(cfgId);
                    data.InitData2();
                    WeaponData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("武器配置.xlsx表中的 cfg_WeaponData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有武器数据1数据
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
        /// 武器数据2配置缓存
        /// </summary>
        private static readonly Dictionary<string, WeaponData2> WeaponData2_Cache = new Dictionary<string, WeaponData2>();
        /// <summary>
        /// 提前加载所有武器数据2配置缓存
        /// </summary>
        public static void LoadWeaponData2()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_WeaponData2);
            foreach (var val in cfg_dict)
            {
                WeaponData2 data = new WeaponData2(val.Value);
                data.InitData2();
                WeaponData2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的武器数据2基础配置缓存
        /// </summary>
        public static WeaponData2 GetWeaponData2(string cfgId)
        {
            if (!WeaponData2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new WeaponData2(cfgId);
                    data.InitData2();
                    WeaponData2_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("武器配置.xlsx表中的 cfg_WeaponData2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static WeaponData2 GetWeaponData2(int cfgId)
        {
            if (!WeaponData2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new WeaponData2(cfgId);
                    data.InitData2();
                    WeaponData2_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("武器配置.xlsx表中的 cfg_WeaponData2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有武器数据2数据
        /// </summary>
        public static List<WeaponData2> GetAllWeaponData2()
        {
            List<WeaponData2> list = new List<WeaponData2>();
            foreach (var val in WeaponData2_Cache)
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
                try
                {
                    data = new TowerData(cfgId);
                    data.InitData2();
                    TowerData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("炮塔配置.xlsx表中的 cfg_TowerData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static TowerData GetTowerData(int cfgId)
        {
            if (!TowerData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new TowerData(cfgId);
                    data.InitData2();
                    TowerData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("炮塔配置.xlsx表中的 cfg_TowerData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        #region 属性基础表
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
                try
                {
                    data = new AttributeBase(cfgId);
                    data.InitData2();
                    AttributeBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性基础表.xlsx表中的 cfg_AttributeBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttributeBase GetAttributeBase(int cfgId)
        {
            if (!AttributeBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttributeBase(cfgId);
                    data.InitData2();
                    AttributeBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性基础表.xlsx表中的 cfg_AttributeBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AttrCalculate(cfgId);
                    data.InitData2();
                    AttrCalculate_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性基础表.xlsx表中的 cfg_AttrCalculate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttrCalculate GetAttrCalculate(int cfgId)
        {
            if (!AttrCalculate_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttrCalculate(cfgId);
                    data.InitData2();
                    AttrCalculate_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性基础表.xlsx表中的 cfg_AttrCalculate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AttrDependency(cfgId);
                    data.InitData2();
                    AttrDependency_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性基础表.xlsx表中的 cfg_AttrDependency配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttrDependency GetAttrDependency(int cfgId)
        {
            if (!AttrDependency_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttrDependency(cfgId);
                    data.InitData2();
                    AttrDependency_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性基础表.xlsx表中的 cfg_AttrDependency配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        #region 属性配置
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
                try
                {
                    data = new AttributeTemplate(cfgId);
                    data.InitData2();
                    AttributeTemplate_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性配置.xlsx表中的 cfg_AttributeTemplate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttributeTemplate GetAttributeTemplate(int cfgId)
        {
            if (!AttributeTemplate_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttributeTemplate(cfgId);
                    data.InitData2();
                    AttributeTemplate_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性配置.xlsx表中的 cfg_AttributeTemplate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new AttributeData(cfgId);
                    data.InitData2();
                    AttributeData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性配置.xlsx表中的 cfg_AttributeData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttributeData GetAttributeData(int cfgId)
        {
            if (!AttributeData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttributeData(cfgId);
                    data.InitData2();
                    AttributeData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性配置.xlsx表中的 cfg_AttributeData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
        /// 属性修饰器配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrModifier> AttrModifier_Cache = new Dictionary<string, AttrModifier>();
        /// <summary>
        /// 提前加载所有属性修饰器配置缓存
        /// </summary>
        public static void LoadAttrModifier()
        {
            Dictionary<string, Dictionary<string, object>> cfg_dict = ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrModifier);
            foreach (var val in cfg_dict)
            {
                AttrModifier data = new AttrModifier(val.Value);
                data.InitData2();
                AttrModifier_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性修饰器基础配置缓存
        /// </summary>
        public static AttrModifier GetAttrModifier(string cfgId)
        {
            if (!AttrModifier_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AttrModifier(cfgId);
                    data.InitData2();
                    AttrModifier_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性配置.xlsx表中的 cfg_AttrModifier配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AttrModifier GetAttrModifier(int cfgId)
        {
            if (!AttrModifier_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AttrModifier(cfgId);
                    data.InitData2();
                    AttrModifier_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("属性配置.xlsx表中的 cfg_AttrModifier配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性修饰器数据
        /// </summary>
        public static List<AttrModifier> GetAllAttrModifier()
        {
            List<AttrModifier> list = new List<AttrModifier>();
            foreach (var val in AttrModifier_Cache)
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
                try
                {
                    data = new MapBuildLable(cfgId);
                    data.InitData2();
                    MapBuildLable_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_MapBuildLable配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapBuildLable GetMapBuildLable(int cfgId)
        {
            if (!MapBuildLable_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapBuildLable(cfgId);
                    data.InitData2();
                    MapBuildLable_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_MapBuildLable配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new MapBuildList(cfgId);
                    data.InitData2();
                    MapBuildList_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_MapBuildList配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapBuildList GetMapBuildList(int cfgId)
        {
            if (!MapBuildList_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapBuildList(cfgId);
                    data.InitData2();
                    MapBuildList_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_MapBuildList配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new BuildRule(cfgId);
                    data.InitData2();
                    BuildRule_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_BuildRule配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BuildRule GetBuildRule(int cfgId)
        {
            if (!BuildRule_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BuildRule(cfgId);
                    data.InitData2();
                    BuildRule_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_BuildRule配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new CampBase(cfgId);
                    data.InitData2();
                    CampBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("阵营相关.xlsx表中的 cfg_CampBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static CampBase GetCampBase(int cfgId)
        {
            if (!CampBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new CampBase(cfgId);
                    data.InitData2();
                    CampBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("阵营相关.xlsx表中的 cfg_CampBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new GameDiffBase(cfgId);
                    data.InitData2();
                    GameDiffBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("难度相关.xlsx表中的 cfg_GameDiffBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GameDiffBase GetGameDiffBase(int cfgId)
        {
            if (!GameDiffBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GameDiffBase(cfgId);
                    data.InitData2();
                    GameDiffBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("难度相关.xlsx表中的 cfg_GameDiffBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new BagData(cfgId);
                    data.InitData2();
                    BagData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("背包相关.xlsx表中的 cfg_bagData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static BagData GetBagData(int cfgId)
        {
            if (!BagData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new BagData(cfgId);
                    data.InitData2();
                    BagData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("背包相关.xlsx表中的 cfg_bagData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new MoneyBase(cfgId);
                    data.InitData2();
                    MoneyBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("货币相关.xlsx表中的 cfg_MoneyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MoneyBase GetMoneyBase(int cfgId)
        {
            if (!MoneyBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MoneyBase(cfgId);
                    data.InitData2();
                    MoneyBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("货币相关.xlsx表中的 cfg_MoneyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ItemData(cfgId);
                    data.InitData2();
                    ItemData_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("道具相关.xlsx表中的 cfg_itemData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ItemData GetItemData(int cfgId)
        {
            if (!ItemData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ItemData(cfgId);
                    data.InitData2();
                    ItemData_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("道具相关.xlsx表中的 cfg_itemData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
                try
                {
                    data = new ErrorBase(cfgId);
                    data.InitData2();
                    ErrorBase_Cache.Add(cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("错误码.xlsx表中的 cfg_ErrorBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ErrorBase GetErrorBase(int cfgId)
        {
            if (!ErrorBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ErrorBase(cfgId);
                    data.InitData2();
                    ErrorBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception e)
                {
                    Log.PrintConfigError("错误码.xlsx表中的 cfg_ErrorBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
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
            BuffTag_Cache.Clear();
            BuffData_Cache.Clear();
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
            GlobalConfigPng_Cache.Clear();
            GlobalConfigStr_Cache.Clear();
            GlobalConfigFloat_Cache.Clear();
            GlobalConfigList_Cache.Clear();
            FunctionTemplate_Cache.Clear();
            CameraBase_Cache.Clear();
            CameraAssemblyBase_Cache.Clear();
            AnimaUnit_Cache.Clear();
            AnimaTower_Cache.Clear();
            AnimaBuild_Cache.Clear();
            AnimaWeapon_Cache.Clear();
            AnimaBullet_Cache.Clear();
            AnimaExplode_Cache.Clear();
            SequenceMapBase_Cache.Clear();
            SpeciallyEffect_Cache.Clear();
            MapMassif_Cache.Clear();
            MapImageLayer_Cache.Clear();
            MapPhysicsLayer_Cache.Clear();
            MapNavigate_Cache.Clear();
            MapMaterial_Cache.Clear();
            GenerateFixedMap_Cache.Clear();
            GenerateBottomMap_Cache.Clear();
            MapExtraDraw_Cache.Clear();
            GenerateBigStruct_Cache.Clear();
            MapPassType_Cache.Clear();
            MapEdge_Cache.Clear();
            BigMapMaterial_Cache.Clear();
            BigMapBase_Cache.Clear();
            BigMapBigCell_Cache.Clear();
            BigMapCellLogic_Cache.Clear();
            BigMapEvent_Cache.Clear();
            UnitGroupType_Cache.Clear();
            UnitGroupData_Cache.Clear();
            ChapterBase_Cache.Clear();
            ChapterCopyBase_Cache.Clear();
            CopyBrush_Cache.Clear();
            BrushPoint_Cache.Clear();
            WaveBase_Cache.Clear();
            ChapterCopyUI_Cache.Clear();
            BackgroundMusic_Cache.Clear();
            SoundEffect_Cache.Clear();
            BulletScript_Cache.Clear();
            BulletAction_Cache.Clear();
            BulletFire_Cache.Clear();
            BulletScene_Cache.Clear();
            BulletData_Cache.Clear();
            BulletLogic_Cache.Clear();
            BulletCollide_Cache.Clear();
            ExplodeData_Cache.Clear();
            ExplodeHarm_Cache.Clear();
            UnitData_Cache.Clear();
            UnitLogic_Cache.Clear();
            AttrEvent_Cache.Clear();
            BaseObjectShow_Cache.Clear();
            ObjectBottomBar_Cache.Clear();
            ObjectSideBar_Cache.Clear();
            BaseObjectData_Cache.Clear();
            BaseObjectWeapon_Cache.Clear();
            BuildData_Cache.Clear();
            WorkerData_Cache.Clear();
            WeaponData_Cache.Clear();
            WeaponData2_Cache.Clear();
            TowerData_Cache.Clear();
            AttributeBase_Cache.Clear();
            AttrCalculate_Cache.Clear();
            AttrDependency_Cache.Clear();
            AttributeTemplate_Cache.Clear();
            AttributeData_Cache.Clear();
            AttrModifier_Cache.Clear();
            MapBuildLable_Cache.Clear();
            MapBuildList_Cache.Clear();
            BuildRule_Cache.Clear();
            CampBase_Cache.Clear();
            GameDiffBase_Cache.Clear();
            BagData_Cache.Clear();
            MoneyBase_Cache.Clear();
            ItemData_Cache.Clear();
            ErrorBase_Cache.Clear();
        }

    }
}