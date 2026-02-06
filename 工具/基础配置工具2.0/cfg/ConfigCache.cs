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
            LoadViewBase();
            LoadUpdateLog();
            LoadAttainmentPage();
            LoadAttainmentBase();
            LoadArchival();
            LoadArchivalItem();
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
            LoadAnimaUnit();
            LoadAnimaBuild();
            LoadAnimaTower();
            LoadAnimaWeapon();
            LoadAnimaWorker();
            LoadAnimaExplode();
            LoadAnimaUnit2();
            LoadAnimaBuild2();
            LoadAnimaTower2();
            LoadAnimaWorker2();
            LoadAnimaWeapon2();
            LoadAnimaExplode2();
            LoadSequenceMapBase();
            LoadSpeciallyEffect();
            LoadObjectEffectImage();
            LoadGenerateFixedMap();
            LoadMapFixedSet();
            LoadMapFixedMaterial();
            LoadMapPassType();
            LoadMapEdge();
            LoadMapWallShadow();
            LoadMapMassif();
            LoadMapImageLayer();
            LoadMapMaterial();
            LoadGenerateBottomMap();
            LoadMapExtraDraw();
            LoadGenerateBigStruct();
            LoadMapDecorate();
            LoadBigMapBase();
            LoadBigMapMaterial();
            LoadBigMapBigCell();
            LoadBigMapCellLogic();
            LoadBigMapEvent();
            LoadCopyBrush();
            LoadBrushPoint();
            LoadWaveBase();
            LoadUnitGroupData();
            LoadUnitGroupType();
            LoadChapterBase();
            LoadChapterCopyBase();
            LoadCopyBuildLimit();
            LoadChapterCopyUI();
            LoadBackgroundMusic();
            LoadUISoundSfx();
            LoadSoundSfx();
            LoadBulletData();
            LoadBulletLogic();
            LoadLaserBulletLogic();
            LoadExplodeData();
            LoadExplodeHarm();
            LoadUnitData();
            LoadUnitLogic();
            LoadBaseObjectShow();
            LoadObjectBottomBar();
            LoadObjectSideBar();
            LoadBaseObjectData();
            LoadBuildData();
            LoadWorkerData();
            LoadWeaponData();
            LoadWeaponData2();
            LoadWreckAge();
            LoadBuffTag();
            LoadBuffData();
            LoadAttrEvent();
            LoadGlobalAttrEvent();
            LoadGlobalAttributeBase();
            LoadGlobalAttrTem();
            LoadGlobalAttrData();
            LoadGlobalAttrMod();
            LoadAttributeBase();
            LoadAttrCalculate();
            LoadAttrDependency();
            LoadAttributeTemplate();
            LoadAttributeData();
            LoadAttrModifier();
            LoadMapBuildLable();
            LoadMapBuildItem();
            LoadBuildRule();
            LoadCampBase();
            LoadGameDiffBase();
            LoadBagData();
            LoadItemData();
            LoadMoneyBase();
            LoadErrorBase();
        }



        #region Ui界面配置
        /// <summary>
        /// 界面基础配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ViewBase> ViewBase_Cache = [];
        /// <summary>
        /// 提前加载所有界面基础配置配置缓存
        /// </summary>
        public static void LoadViewBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ViewBase))
            {
                ViewBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ViewBase>(ViewBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的界面基础配置数据
        /// </summary>
        public static bool HasViewBase(int cfgId)
        {
            return ViewBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的界面基础配置数据
        /// </summary>
        public static bool HasViewBase(string cfgId)
        {
            return ViewBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 主界面更新日志
        /// <summary>
        /// 更新日志配置缓存
        /// </summary>
        private static readonly Dictionary<string, UpdateLog> UpdateLog_Cache = [];
        /// <summary>
        /// 提前加载所有更新日志配置缓存
        /// </summary>
        public static void LoadUpdateLog()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_UpdateLog))
            {
                UpdateLog data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<UpdateLog>(UpdateLog_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的更新日志数据
        /// </summary>
        public static bool HasUpdateLog(int cfgId)
        {
            return UpdateLog_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的更新日志数据
        /// </summary>
        public static bool HasUpdateLog(string cfgId)
        {
            return UpdateLog_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 数据库界面及成就相关配置
        /// <summary>
        /// 数据库成就分页配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttainmentPage> AttainmentPage_Cache = [];
        /// <summary>
        /// 提前加载所有数据库成就分页配置缓存
        /// </summary>
        public static void LoadAttainmentPage()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttainmentPage))
            {
                AttainmentPage data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AttainmentPage>(AttainmentPage_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的数据库成就分页数据
        /// </summary>
        public static bool HasAttainmentPage(int cfgId)
        {
            return AttainmentPage_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的数据库成就分页数据
        /// </summary>
        public static bool HasAttainmentPage(string cfgId)
        {
            return AttainmentPage_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 数据库成就相关配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttainmentBase> AttainmentBase_Cache = [];
        /// <summary>
        /// 提前加载所有数据库成就相关配置配置缓存
        /// </summary>
        public static void LoadAttainmentBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttainmentBase))
            {
                AttainmentBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AttainmentBase>(AttainmentBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的数据库成就相关配置数据
        /// </summary>
        public static bool HasAttainmentBase(int cfgId)
        {
            return AttainmentBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的数据库成就相关配置数据
        /// </summary>
        public static bool HasAttainmentBase(string cfgId)
        {
            return AttainmentBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 档案库主界面
        /// <summary>
        /// 档案库主界面配置缓存
        /// </summary>
        private static readonly Dictionary<string, Archival> Archival_Cache = [];
        /// <summary>
        /// 提前加载所有档案库主界面配置缓存
        /// </summary>
        public static void LoadArchival()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_Archival))
            {
                Archival data = new(val.Value);
                data.InitData2();
                Archival_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的档案库主界面基础配置缓存
        /// </summary>
        public static Archival GetArchival(string cfgId)
        {
            if (!Archival_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new Archival(cfgId);
                    data.InitData2();
                    Archival_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("档案库主界面.xlsx表中的 cfg_Archival配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static Archival GetArchival(int cfgId)
        {
            if (!Archival_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new Archival(cfgId);
                    data.InitData2();
                    Archival_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("档案库主界面.xlsx表中的 cfg_Archival配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有档案库主界面数据
        /// </summary>
        public static List<Archival> GetAllArchival()
        {
            return new List<Archival>(Archival_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的档案库主界面数据
        /// </summary>
        public static bool HasArchival(int cfgId)
        {
            return Archival_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的档案库主界面数据
        /// </summary>
        public static bool HasArchival(string cfgId)
        {
            return Archival_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 档案库子项配置缓存
        /// </summary>
        private static readonly Dictionary<string, ArchivalItem> ArchivalItem_Cache = [];
        /// <summary>
        /// 提前加载所有档案库子项配置缓存
        /// </summary>
        public static void LoadArchivalItem()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ArchivalItem))
            {
                ArchivalItem data = new(val.Value);
                data.InitData2();
                ArchivalItem_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的档案库子项基础配置缓存
        /// </summary>
        public static ArchivalItem GetArchivalItem(string cfgId)
        {
            if (!ArchivalItem_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new ArchivalItem(cfgId);
                    data.InitData2();
                    ArchivalItem_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("档案库主界面.xlsx表中的 cfg_ArchivalItem配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ArchivalItem GetArchivalItem(int cfgId)
        {
            if (!ArchivalItem_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ArchivalItem(cfgId);
                    data.InitData2();
                    ArchivalItem_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("档案库主界面.xlsx表中的 cfg_ArchivalItem配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有档案库子项数据
        /// </summary>
        public static List<ArchivalItem> GetAllArchivalItem()
        {
            return new List<ArchivalItem>(ArchivalItem_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的档案库子项数据
        /// </summary>
        public static bool HasArchivalItem(int cfgId)
        {
            return ArchivalItem_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的档案库子项数据
        /// </summary>
        public static bool HasArchivalItem(string cfgId)
        {
            return ArchivalItem_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 科技树解锁界面相关配置
        /// <summary>
        /// 科技范围配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceRange> ScienceRange_Cache = [];
        /// <summary>
        /// 提前加载所有科技范围配置配置缓存
        /// </summary>
        public static void LoadScienceRange()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceRange))
            {
                ScienceRange data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ScienceRange>(ScienceRange_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技范围配置数据
        /// </summary>
        public static bool HasScienceRange(int cfgId)
        {
            return ScienceRange_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技范围配置数据
        /// </summary>
        public static bool HasScienceRange(string cfgId)
        {
            return ScienceRange_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 科技基础显示配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceBase> ScienceBase_Cache = [];
        /// <summary>
        /// 提前加载所有科技基础显示配置配置缓存
        /// </summary>
        public static void LoadScienceBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceBase))
            {
                ScienceBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ScienceBase>(ScienceBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技基础显示配置数据
        /// </summary>
        public static bool HasScienceBase(int cfgId)
        {
            return ScienceBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技基础显示配置数据
        /// </summary>
        public static bool HasScienceBase(string cfgId)
        {
            return ScienceBase_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 科技激活相关数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceData> ScienceData_Cache = [];
        /// <summary>
        /// 提前加载所有科技激活相关数据配置缓存
        /// </summary>
        public static void LoadScienceData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceData))
            {
                ScienceData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ScienceData>(ScienceData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技激活相关数据数据
        /// </summary>
        public static bool HasScienceData(int cfgId)
        {
            return ScienceData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技激活相关数据数据
        /// </summary>
        public static bool HasScienceData(string cfgId)
        {
            return ScienceData_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 配置界面相关
        /// <summary>
        /// 道具配置界面数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ItemDeployData> ItemDeployData_Cache = [];
        /// <summary>
        /// 提前加载所有道具配置界面数据配置缓存
        /// </summary>
        public static void LoadItemDeployData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ItemDeployData))
            {
                ItemDeployData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ItemDeployData>(ItemDeployData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的道具配置界面数据数据
        /// </summary>
        public static bool HasItemDeployData(int cfgId)
        {
            return ItemDeployData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的道具配置界面数据数据
        /// </summary>
        public static bool HasItemDeployData(string cfgId)
        {
            return ItemDeployData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 核心插件配置数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CorePlugDeployData> CorePlugDeployData_Cache = [];
        /// <summary>
        /// 提前加载所有核心插件配置数据配置缓存
        /// </summary>
        public static void LoadCorePlugDeployData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_CorePlugDeployData))
            {
                CorePlugDeployData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<CorePlugDeployData>(CorePlugDeployData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的核心插件配置数据数据
        /// </summary>
        public static bool HasCorePlugDeployData(int cfgId)
        {
            return CorePlugDeployData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的核心插件配置数据数据
        /// </summary>
        public static bool HasCorePlugDeployData(string cfgId)
        {
            return CorePlugDeployData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 科技配置数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ScienceDeployData> ScienceDeployData_Cache = [];
        /// <summary>
        /// 提前加载所有科技配置数据配置缓存
        /// </summary>
        public static void LoadScienceDeployData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ScienceDeployData))
            {
                ScienceDeployData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ScienceDeployData>(ScienceDeployData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技配置数据数据
        /// </summary>
        public static bool HasScienceDeployData(int cfgId)
        {
            return ScienceDeployData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的科技配置数据数据
        /// </summary>
        public static bool HasScienceDeployData(string cfgId)
        {
            return ScienceDeployData_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 配置特殊功能表
        /// <summary>
        /// 配置覆盖关系表配置缓存
        /// </summary>
        private static readonly Dictionary<string, ConfigCover> ConfigCover_Cache = [];
        /// <summary>
        /// 提前加载所有配置覆盖关系表配置缓存
        /// </summary>
        public static void LoadConfigCover()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ConfigCover))
            {
                ConfigCover data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ConfigCover>(ConfigCover_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的配置覆盖关系表数据
        /// </summary>
        public static bool HasConfigCover(int cfgId)
        {
            return ConfigCover_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的配置覆盖关系表数据
        /// </summary>
        public static bool HasConfigCover(string cfgId)
        {
            return ConfigCover_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 配置调用关系表配置缓存
        /// </summary>
        private static readonly Dictionary<string, ConfigCall> ConfigCall_Cache = [];
        /// <summary>
        /// 提前加载所有配置调用关系表配置缓存
        /// </summary>
        public static void LoadConfigCall()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ConfigCall))
            {
                ConfigCall data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ConfigCall>(ConfigCall_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的配置调用关系表数据
        /// </summary>
        public static bool HasConfigCall(int cfgId)
        {
            return ConfigCall_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的配置调用关系表数据
        /// </summary>
        public static bool HasConfigCall(string cfgId)
        {
            return ConfigCall_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 默认配置表
        /// <summary>
        /// 全局配置Int数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigInt> GlobalConfigInt_Cache = [];
        /// <summary>
        /// 提前加载所有全局配置Int数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigInt()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigInt))
            {
                GlobalConfigInt data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GlobalConfigInt>(GlobalConfigInt_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局配置Int数据数据
        /// </summary>
        public static bool HasGlobalConfigInt(int cfgId)
        {
            return GlobalConfigInt_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局配置Int数据数据
        /// </summary>
        public static bool HasGlobalConfigInt(string cfgId)
        {
            return GlobalConfigInt_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// Png散图配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigPng> GlobalConfigPng_Cache = [];
        /// <summary>
        /// 提前加载所有Png散图配置缓存
        /// </summary>
        public static void LoadGlobalConfigPng()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigPng))
            {
                GlobalConfigPng data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GlobalConfigPng>(GlobalConfigPng_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的Png散图数据
        /// </summary>
        public static bool HasGlobalConfigPng(int cfgId)
        {
            return GlobalConfigPng_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的Png散图数据
        /// </summary>
        public static bool HasGlobalConfigPng(string cfgId)
        {
            return GlobalConfigPng_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// Str数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigStr> GlobalConfigStr_Cache = [];
        /// <summary>
        /// 提前加载所有Str数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigStr()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigStr))
            {
                GlobalConfigStr data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GlobalConfigStr>(GlobalConfigStr_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的Str数据数据
        /// </summary>
        public static bool HasGlobalConfigStr(int cfgId)
        {
            return GlobalConfigStr_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的Str数据数据
        /// </summary>
        public static bool HasGlobalConfigStr(string cfgId)
        {
            return GlobalConfigStr_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// float数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigFloat> GlobalConfigFloat_Cache = [];
        /// <summary>
        /// 提前加载所有float数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigFloat()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigFloat))
            {
                GlobalConfigFloat data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GlobalConfigFloat>(GlobalConfigFloat_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的float数据数据
        /// </summary>
        public static bool HasGlobalConfigFloat(int cfgId)
        {
            return GlobalConfigFloat_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的float数据数据
        /// </summary>
        public static bool HasGlobalConfigFloat(string cfgId)
        {
            return GlobalConfigFloat_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// List数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalConfigList> GlobalConfigList_Cache = [];
        /// <summary>
        /// 提前加载所有List数据配置缓存
        /// </summary>
        public static void LoadGlobalConfigList()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalConfigList))
            {
                GlobalConfigList data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GlobalConfigList>(GlobalConfigList_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的List数据数据
        /// </summary>
        public static bool HasGlobalConfigList(int cfgId)
        {
            return GlobalConfigList_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的List数据数据
        /// </summary>
        public static bool HasGlobalConfigList(string cfgId)
        {
            return GlobalConfigList_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 函数模板
        /// <summary>
        /// 函数模板配置缓存
        /// </summary>
        private static readonly Dictionary<string, FunctionTemplate> FunctionTemplate_Cache = [];
        /// <summary>
        /// 提前加载所有函数模板配置缓存
        /// </summary>
        public static void LoadFunctionTemplate()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_FunctionTemplate))
            {
                FunctionTemplate data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<FunctionTemplate>(FunctionTemplate_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的函数模板数据
        /// </summary>
        public static bool HasFunctionTemplate(int cfgId)
        {
            return FunctionTemplate_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的函数模板数据
        /// </summary>
        public static bool HasFunctionTemplate(string cfgId)
        {
            return FunctionTemplate_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 噪声
        #endregion

        #region 相机
        /// <summary>
        /// 相机基本数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CameraBase> CameraBase_Cache = [];
        /// <summary>
        /// 提前加载所有相机基本数据配置缓存
        /// </summary>
        public static void LoadCameraBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_CameraBase))
            {
                CameraBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<CameraBase>(CameraBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的相机基本数据数据
        /// </summary>
        public static bool HasCameraBase(int cfgId)
        {
            return CameraBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的相机基本数据数据
        /// </summary>
        public static bool HasCameraBase(string cfgId)
        {
            return CameraBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 帧动画
        /// <summary>
        /// 单位帧动画配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaUnit> AnimaUnit_Cache = [];
        /// <summary>
        /// 提前加载所有单位帧动画配置配置缓存
        /// </summary>
        public static void LoadAnimaUnit()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaUnit))
            {
                AnimaUnit data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AnimaUnit>(AnimaUnit_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位帧动画配置数据
        /// </summary>
        public static bool HasAnimaUnit(int cfgId)
        {
            return AnimaUnit_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位帧动画配置数据
        /// </summary>
        public static bool HasAnimaUnit(string cfgId)
        {
            return AnimaUnit_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 建筑动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaBuild> AnimaBuild_Cache = [];
        /// <summary>
        /// 提前加载所有建筑动画配置缓存
        /// </summary>
        public static void LoadAnimaBuild()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaBuild))
            {
                AnimaBuild data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AnimaBuild>(AnimaBuild_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的建筑动画数据
        /// </summary>
        public static bool HasAnimaBuild(int cfgId)
        {
            return AnimaBuild_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的建筑动画数据
        /// </summary>
        public static bool HasAnimaBuild(string cfgId)
        {
            return AnimaBuild_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 炮塔动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaTower> AnimaTower_Cache = [];
        /// <summary>
        /// 提前加载所有炮塔动画配置缓存
        /// </summary>
        public static void LoadAnimaTower()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaTower))
            {
                AnimaTower data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AnimaTower>(AnimaTower_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的炮塔动画数据
        /// </summary>
        public static bool HasAnimaTower(int cfgId)
        {
            return AnimaTower_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的炮塔动画数据
        /// </summary>
        public static bool HasAnimaTower(string cfgId)
        {
            return AnimaTower_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 武器动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaWeapon> AnimaWeapon_Cache = [];
        /// <summary>
        /// 提前加载所有武器动画配置缓存
        /// </summary>
        public static void LoadAnimaWeapon()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaWeapon))
            {
                AnimaWeapon data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AnimaWeapon>(AnimaWeapon_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器动画数据
        /// </summary>
        public static bool HasAnimaWeapon(int cfgId)
        {
            return AnimaWeapon_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器动画数据
        /// </summary>
        public static bool HasAnimaWeapon(string cfgId)
        {
            return AnimaWeapon_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 无人机动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaWorker> AnimaWorker_Cache = [];
        /// <summary>
        /// 提前加载所有无人机动画配置缓存
        /// </summary>
        public static void LoadAnimaWorker()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaWorker))
            {
                AnimaWorker data = new(val.Value);
                data.InitData2();
                AnimaWorker_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的无人机动画基础配置缓存
        /// </summary>
        public static AnimaWorker GetAnimaWorker(string cfgId)
        {
            if (!AnimaWorker_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaWorker(cfgId);
                    data.InitData2();
                    AnimaWorker_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaWorker配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaWorker GetAnimaWorker(int cfgId)
        {
            if (!AnimaWorker_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaWorker(cfgId);
                    data.InitData2();
                    AnimaWorker_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画.xlsx表中的 cfg_AnimaWorker配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有无人机动画数据
        /// </summary>
        public static List<AnimaWorker> GetAllAnimaWorker()
        {
            return new List<AnimaWorker>(AnimaWorker_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的无人机动画数据
        /// </summary>
        public static bool HasAnimaWorker(int cfgId)
        {
            return AnimaWorker_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的无人机动画数据
        /// </summary>
        public static bool HasAnimaWorker(string cfgId)
        {
            return AnimaWorker_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 爆炸动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaExplode> AnimaExplode_Cache = [];
        /// <summary>
        /// 提前加载所有爆炸动画配置缓存
        /// </summary>
        public static void LoadAnimaExplode()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaExplode))
            {
                AnimaExplode data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<AnimaExplode>(AnimaExplode_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸动画数据
        /// </summary>
        public static bool HasAnimaExplode(int cfgId)
        {
            return AnimaExplode_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸动画数据
        /// </summary>
        public static bool HasAnimaExplode(string cfgId)
        {
            return AnimaExplode_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 帧动画2
        /// <summary>
        /// 单位帧动画配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaUnit2> AnimaUnit2_Cache = [];
        /// <summary>
        /// 提前加载所有单位帧动画配置配置缓存
        /// </summary>
        public static void LoadAnimaUnit2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaUnit2))
            {
                AnimaUnit2 data = new(val.Value);
                data.InitData2();
                AnimaUnit2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的单位帧动画配置基础配置缓存
        /// </summary>
        public static AnimaUnit2 GetAnimaUnit2(string cfgId)
        {
            if (!AnimaUnit2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaUnit2(cfgId);
                    data.InitData2();
                    AnimaUnit2_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaUnit2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaUnit2 GetAnimaUnit2(int cfgId)
        {
            if (!AnimaUnit2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaUnit2(cfgId);
                    data.InitData2();
                    AnimaUnit2_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaUnit2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位帧动画配置数据
        /// </summary>
        public static List<AnimaUnit2> GetAllAnimaUnit2()
        {
            return new List<AnimaUnit2>(AnimaUnit2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位帧动画配置数据
        /// </summary>
        public static bool HasAnimaUnit2(int cfgId)
        {
            return AnimaUnit2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位帧动画配置数据
        /// </summary>
        public static bool HasAnimaUnit2(string cfgId)
        {
            return AnimaUnit2_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 建筑动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaBuild2> AnimaBuild2_Cache = [];
        /// <summary>
        /// 提前加载所有建筑动画配置缓存
        /// </summary>
        public static void LoadAnimaBuild2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaBuild2))
            {
                AnimaBuild2 data = new(val.Value);
                data.InitData2();
                AnimaBuild2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建筑动画基础配置缓存
        /// </summary>
        public static AnimaBuild2 GetAnimaBuild2(string cfgId)
        {
            if (!AnimaBuild2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaBuild2(cfgId);
                    data.InitData2();
                    AnimaBuild2_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaBuild2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaBuild2 GetAnimaBuild2(int cfgId)
        {
            if (!AnimaBuild2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaBuild2(cfgId);
                    data.InitData2();
                    AnimaBuild2_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaBuild2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建筑动画数据
        /// </summary>
        public static List<AnimaBuild2> GetAllAnimaBuild2()
        {
            return new List<AnimaBuild2>(AnimaBuild2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的建筑动画数据
        /// </summary>
        public static bool HasAnimaBuild2(int cfgId)
        {
            return AnimaBuild2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的建筑动画数据
        /// </summary>
        public static bool HasAnimaBuild2(string cfgId)
        {
            return AnimaBuild2_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 炮塔动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaTower2> AnimaTower2_Cache = [];
        /// <summary>
        /// 提前加载所有炮塔动画配置缓存
        /// </summary>
        public static void LoadAnimaTower2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaTower2))
            {
                AnimaTower2 data = new(val.Value);
                data.InitData2();
                AnimaTower2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的炮塔动画基础配置缓存
        /// </summary>
        public static AnimaTower2 GetAnimaTower2(string cfgId)
        {
            if (!AnimaTower2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaTower2(cfgId);
                    data.InitData2();
                    AnimaTower2_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaTower2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaTower2 GetAnimaTower2(int cfgId)
        {
            if (!AnimaTower2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaTower2(cfgId);
                    data.InitData2();
                    AnimaTower2_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaTower2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有炮塔动画数据
        /// </summary>
        public static List<AnimaTower2> GetAllAnimaTower2()
        {
            return new List<AnimaTower2>(AnimaTower2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的炮塔动画数据
        /// </summary>
        public static bool HasAnimaTower2(int cfgId)
        {
            return AnimaTower2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的炮塔动画数据
        /// </summary>
        public static bool HasAnimaTower2(string cfgId)
        {
            return AnimaTower2_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 无人机动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaWorker2> AnimaWorker2_Cache = [];
        /// <summary>
        /// 提前加载所有无人机动画配置缓存
        /// </summary>
        public static void LoadAnimaWorker2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaWorker2))
            {
                AnimaWorker2 data = new(val.Value);
                data.InitData2();
                AnimaWorker2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的无人机动画基础配置缓存
        /// </summary>
        public static AnimaWorker2 GetAnimaWorker2(string cfgId)
        {
            if (!AnimaWorker2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaWorker2(cfgId);
                    data.InitData2();
                    AnimaWorker2_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaWorker2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaWorker2 GetAnimaWorker2(int cfgId)
        {
            if (!AnimaWorker2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaWorker2(cfgId);
                    data.InitData2();
                    AnimaWorker2_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaWorker2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有无人机动画数据
        /// </summary>
        public static List<AnimaWorker2> GetAllAnimaWorker2()
        {
            return new List<AnimaWorker2>(AnimaWorker2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的无人机动画数据
        /// </summary>
        public static bool HasAnimaWorker2(int cfgId)
        {
            return AnimaWorker2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的无人机动画数据
        /// </summary>
        public static bool HasAnimaWorker2(string cfgId)
        {
            return AnimaWorker2_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 武器动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaWeapon2> AnimaWeapon2_Cache = [];
        /// <summary>
        /// 提前加载所有武器动画配置缓存
        /// </summary>
        public static void LoadAnimaWeapon2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaWeapon2))
            {
                AnimaWeapon2 data = new(val.Value);
                data.InitData2();
                AnimaWeapon2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的武器动画基础配置缓存
        /// </summary>
        public static AnimaWeapon2 GetAnimaWeapon2(string cfgId)
        {
            if (!AnimaWeapon2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaWeapon2(cfgId);
                    data.InitData2();
                    AnimaWeapon2_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaWeapon2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaWeapon2 GetAnimaWeapon2(int cfgId)
        {
            if (!AnimaWeapon2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaWeapon2(cfgId);
                    data.InitData2();
                    AnimaWeapon2_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaWeapon2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有武器动画数据
        /// </summary>
        public static List<AnimaWeapon2> GetAllAnimaWeapon2()
        {
            return new List<AnimaWeapon2>(AnimaWeapon2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器动画数据
        /// </summary>
        public static bool HasAnimaWeapon2(int cfgId)
        {
            return AnimaWeapon2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器动画数据
        /// </summary>
        public static bool HasAnimaWeapon2(string cfgId)
        {
            return AnimaWeapon2_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 爆炸动画配置缓存
        /// </summary>
        private static readonly Dictionary<string, AnimaExplode2> AnimaExplode2_Cache = [];
        /// <summary>
        /// 提前加载所有爆炸动画配置缓存
        /// </summary>
        public static void LoadAnimaExplode2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AnimaExplode2))
            {
                AnimaExplode2 data = new(val.Value);
                data.InitData2();
                AnimaExplode2_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的爆炸动画基础配置缓存
        /// </summary>
        public static AnimaExplode2 GetAnimaExplode2(string cfgId)
        {
            if (!AnimaExplode2_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new AnimaExplode2(cfgId);
                    data.InitData2();
                    AnimaExplode2_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaExplode2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static AnimaExplode2 GetAnimaExplode2(int cfgId)
        {
            if (!AnimaExplode2_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new AnimaExplode2(cfgId);
                    data.InitData2();
                    AnimaExplode2_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("帧动画2.xlsx表中的 cfg_AnimaExplode2配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有爆炸动画数据
        /// </summary>
        public static List<AnimaExplode2> GetAllAnimaExplode2()
        {
            return new List<AnimaExplode2>(AnimaExplode2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸动画数据
        /// </summary>
        public static bool HasAnimaExplode2(int cfgId)
        {
            return AnimaExplode2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸动画数据
        /// </summary>
        public static bool HasAnimaExplode2(string cfgId)
        {
            return AnimaExplode2_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 序列图
        /// <summary>
        /// 序列图配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, SequenceMapBase> SequenceMapBase_Cache = [];
        /// <summary>
        /// 提前加载所有序列图配置配置缓存
        /// </summary>
        public static void LoadSequenceMapBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_SequenceMapBase))
            {
                SequenceMapBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<SequenceMapBase>(SequenceMapBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的序列图配置数据
        /// </summary>
        public static bool HasSequenceMapBase(int cfgId)
        {
            return SequenceMapBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的序列图配置数据
        /// </summary>
        public static bool HasSequenceMapBase(string cfgId)
        {
            return SequenceMapBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 特效
        /// <summary>
        /// 特效配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, SpeciallyEffect> SpeciallyEffect_Cache = [];
        /// <summary>
        /// 提前加载所有特效配置配置缓存
        /// </summary>
        public static void LoadSpeciallyEffect()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_SpeciallyEffect))
            {
                SpeciallyEffect data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<SpeciallyEffect>(SpeciallyEffect_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的特效配置数据
        /// </summary>
        public static bool HasSpeciallyEffect(int cfgId)
        {
            return SpeciallyEffect_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的特效配置数据
        /// </summary>
        public static bool HasSpeciallyEffect(string cfgId)
        {
            return SpeciallyEffect_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 程序动画
        /// <summary>
        /// 实体效果图片配置缓存
        /// </summary>
        private static readonly Dictionary<string, ObjectEffectImage> ObjectEffectImage_Cache = [];
        /// <summary>
        /// 提前加载所有实体效果图片配置缓存
        /// </summary>
        public static void LoadObjectEffectImage()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ObjectEffectImage))
            {
                ObjectEffectImage data = new(val.Value);
                data.InitData2();
                ObjectEffectImage_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体效果图片基础配置缓存
        /// </summary>
        public static ObjectEffectImage GetObjectEffectImage(string cfgId)
        {
            if (!ObjectEffectImage_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new ObjectEffectImage(cfgId);
                    data.InitData2();
                    ObjectEffectImage_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("程序动画.xlsx表中的 cfg_ObjectEffectImage配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static ObjectEffectImage GetObjectEffectImage(int cfgId)
        {
            if (!ObjectEffectImage_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new ObjectEffectImage(cfgId);
                    data.InitData2();
                    ObjectEffectImage_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("程序动画.xlsx表中的 cfg_ObjectEffectImage配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体效果图片数据
        /// </summary>
        public static List<ObjectEffectImage> GetAllObjectEffectImage()
        {
            return new List<ObjectEffectImage>(ObjectEffectImage_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体效果图片数据
        /// </summary>
        public static bool HasObjectEffectImage(int cfgId)
        {
            return ObjectEffectImage_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体效果图片数据
        /// </summary>
        public static bool HasObjectEffectImage(string cfgId)
        {
            return ObjectEffectImage_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 固定地图配置
        /// <summary>
        /// 固定地图配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, GenerateFixedMap> GenerateFixedMap_Cache = [];
        /// <summary>
        /// 提前加载所有固定地图配置配置缓存
        /// </summary>
        public static void LoadGenerateFixedMap()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GenerateFixedMap))
            {
                GenerateFixedMap data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_GenerateFixedMap配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_GenerateFixedMap配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有固定地图配置数据
        /// </summary>
        public static List<GenerateFixedMap> GetAllGenerateFixedMap()
        {
            return new List<GenerateFixedMap>(GenerateFixedMap_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的固定地图配置数据
        /// </summary>
        public static bool HasGenerateFixedMap(int cfgId)
        {
            return GenerateFixedMap_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的固定地图配置数据
        /// </summary>
        public static bool HasGenerateFixedMap(string cfgId)
        {
            return GenerateFixedMap_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 固定地图图集 配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapFixedSet> MapFixedSet_Cache = [];
        /// <summary>
        /// 提前加载所有固定地图图集 配置缓存
        /// </summary>
        public static void LoadMapFixedSet()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapFixedSet))
            {
                MapFixedSet data = new(val.Value);
                data.InitData2();
                MapFixedSet_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的固定地图图集 基础配置缓存
        /// </summary>
        public static MapFixedSet GetMapFixedSet(string cfgId)
        {
            if (!MapFixedSet_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapFixedSet(cfgId);
                    data.InitData2();
                    MapFixedSet_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapFixedSet配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapFixedSet GetMapFixedSet(int cfgId)
        {
            if (!MapFixedSet_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapFixedSet(cfgId);
                    data.InitData2();
                    MapFixedSet_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapFixedSet配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有固定地图图集 数据
        /// </summary>
        public static List<MapFixedSet> GetAllMapFixedSet()
        {
            return new List<MapFixedSet>(MapFixedSet_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的固定地图图集 数据
        /// </summary>
        public static bool HasMapFixedSet(int cfgId)
        {
            return MapFixedSet_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的固定地图图集 数据
        /// </summary>
        public static bool HasMapFixedSet(string cfgId)
        {
            return MapFixedSet_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 固定地图用材料配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapFixedMaterial> MapFixedMaterial_Cache = [];
        /// <summary>
        /// 提前加载所有固定地图用材料配置缓存
        /// </summary>
        public static void LoadMapFixedMaterial()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapFixedMaterial))
            {
                MapFixedMaterial data = new(val.Value);
                data.InitData2();
                MapFixedMaterial_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的固定地图用材料基础配置缓存
        /// </summary>
        public static MapFixedMaterial GetMapFixedMaterial(string cfgId)
        {
            if (!MapFixedMaterial_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapFixedMaterial(cfgId);
                    data.InitData2();
                    MapFixedMaterial_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapFixedMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapFixedMaterial GetMapFixedMaterial(int cfgId)
        {
            if (!MapFixedMaterial_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapFixedMaterial(cfgId);
                    data.InitData2();
                    MapFixedMaterial_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapFixedMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有固定地图用材料数据
        /// </summary>
        public static List<MapFixedMaterial> GetAllMapFixedMaterial()
        {
            return new List<MapFixedMaterial>(MapFixedMaterial_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的固定地图用材料数据
        /// </summary>
        public static bool HasMapFixedMaterial(int cfgId)
        {
            return MapFixedMaterial_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的固定地图用材料数据
        /// </summary>
        public static bool HasMapFixedMaterial(string cfgId)
        {
            return MapFixedMaterial_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 地图可通过类型配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapPassType> MapPassType_Cache = [];
        /// <summary>
        /// 提前加载所有地图可通过类型配置缓存
        /// </summary>
        public static void LoadMapPassType()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapPassType))
            {
                MapPassType data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapPassType配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapPassType配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图可通过类型数据
        /// </summary>
        public static List<MapPassType> GetAllMapPassType()
        {
            return new List<MapPassType>(MapPassType_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图可通过类型数据
        /// </summary>
        public static bool HasMapPassType(int cfgId)
        {
            return MapPassType_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图可通过类型数据
        /// </summary>
        public static bool HasMapPassType(string cfgId)
        {
            return MapPassType_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 地图边缘连接配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapEdge> MapEdge_Cache = [];
        /// <summary>
        /// 提前加载所有地图边缘连接配置配置缓存
        /// </summary>
        public static void LoadMapEdge()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapEdge))
            {
                MapEdge data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapEdge配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapEdge配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图边缘连接配置数据
        /// </summary>
        public static List<MapEdge> GetAllMapEdge()
        {
            return new List<MapEdge>(MapEdge_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图边缘连接配置数据
        /// </summary>
        public static bool HasMapEdge(int cfgId)
        {
            return MapEdge_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图边缘连接配置数据
        /// </summary>
        public static bool HasMapEdge(string cfgId)
        {
            return MapEdge_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 地图墙壁阴影配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapWallShadow> MapWallShadow_Cache = [];
        /// <summary>
        /// 提前加载所有地图墙壁阴影配置配置缓存
        /// </summary>
        public static void LoadMapWallShadow()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapWallShadow))
            {
                MapWallShadow data = new(val.Value);
                data.InitData2();
                MapWallShadow_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图墙壁阴影配置基础配置缓存
        /// </summary>
        public static MapWallShadow GetMapWallShadow(string cfgId)
        {
            if (!MapWallShadow_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapWallShadow(cfgId);
                    data.InitData2();
                    MapWallShadow_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapWallShadow配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapWallShadow GetMapWallShadow(int cfgId)
        {
            if (!MapWallShadow_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapWallShadow(cfgId);
                    data.InitData2();
                    MapWallShadow_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("固定地图配置.xlsx表中的 cfg_MapWallShadow配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图墙壁阴影配置数据
        /// </summary>
        public static List<MapWallShadow> GetAllMapWallShadow()
        {
            return new List<MapWallShadow>(MapWallShadow_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图墙壁阴影配置数据
        /// </summary>
        public static bool HasMapWallShadow(int cfgId)
        {
            return MapWallShadow_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图墙壁阴影配置数据
        /// </summary>
        public static bool HasMapWallShadow(string cfgId)
        {
            return MapWallShadow_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 图块相关
        /// <summary>
        /// 地图资源图集配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapMassif> MapMassif_Cache = [];
        /// <summary>
        /// 提前加载所有地图资源图集配置缓存
        /// </summary>
        public static void LoadMapMassif()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapMassif))
            {
                MapMassif data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<MapMassif>(MapMassif_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图资源图集数据
        /// </summary>
        public static bool HasMapMassif(int cfgId)
        {
            return MapMassif_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图资源图集数据
        /// </summary>
        public static bool HasMapMassif(string cfgId)
        {
            return MapMassif_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 图层相关
        /// <summary>
        /// 图像层配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapImageLayer> MapImageLayer_Cache = [];
        /// <summary>
        /// 提前加载所有图像层配置配置缓存
        /// </summary>
        public static void LoadMapImageLayer()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapImageLayer))
            {
                MapImageLayer data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<MapImageLayer>(MapImageLayer_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的图像层配置数据
        /// </summary>
        public static bool HasMapImageLayer(int cfgId)
        {
            return MapImageLayer_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的图像层配置数据
        /// </summary>
        public static bool HasMapImageLayer(string cfgId)
        {
            return MapImageLayer_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 地图生成
        /// <summary>
        /// 随机生成地图用材料配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapMaterial> MapMaterial_Cache = [];
        /// <summary>
        /// 提前加载所有随机生成地图用材料配置缓存
        /// </summary>
        public static void LoadMapMaterial()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapMaterial))
            {
                MapMaterial data = new(val.Value);
                data.InitData2();
                MapMaterial_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的随机生成地图用材料基础配置缓存
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
                catch (Exception)
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
                catch (Exception)
                {
                    Log.PrintConfigError("地图生成.xlsx表中的 cfg_MapMaterial配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有随机生成地图用材料数据
        /// </summary>
        public static List<MapMaterial> GetAllMapMaterial()
        {
            return new List<MapMaterial>(MapMaterial_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的随机生成地图用材料数据
        /// </summary>
        public static bool HasMapMaterial(int cfgId)
        {
            return MapMaterial_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的随机生成地图用材料数据
        /// </summary>
        public static bool HasMapMaterial(string cfgId)
        {
            return MapMaterial_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 随机生成地图方式配置缓存
        /// </summary>
        private static readonly Dictionary<string, GenerateBottomMap> GenerateBottomMap_Cache = [];
        /// <summary>
        /// 提前加载所有随机生成地图方式配置缓存
        /// </summary>
        public static void LoadGenerateBottomMap()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GenerateBottomMap))
            {
                GenerateBottomMap data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GenerateBottomMap>(GenerateBottomMap_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的随机生成地图方式数据
        /// </summary>
        public static bool HasGenerateBottomMap(int cfgId)
        {
            return GenerateBottomMap_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的随机生成地图方式数据
        /// </summary>
        public static bool HasGenerateBottomMap(string cfgId)
        {
            return GenerateBottomMap_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 地图额外绘制表配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapExtraDraw> MapExtraDraw_Cache = [];
        /// <summary>
        /// 提前加载所有地图额外绘制表配置缓存
        /// </summary>
        public static void LoadMapExtraDraw()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapExtraDraw))
            {
                MapExtraDraw data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<MapExtraDraw>(MapExtraDraw_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图额外绘制表数据
        /// </summary>
        public static bool HasMapExtraDraw(int cfgId)
        {
            return MapExtraDraw_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图额外绘制表数据
        /// </summary>
        public static bool HasMapExtraDraw(string cfgId)
        {
            return MapExtraDraw_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 地图大型结构配置缓存
        /// </summary>
        private static readonly Dictionary<string, GenerateBigStruct> GenerateBigStruct_Cache = [];
        /// <summary>
        /// 提前加载所有地图大型结构配置缓存
        /// </summary>
        public static void LoadGenerateBigStruct()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GenerateBigStruct))
            {
                GenerateBigStruct data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GenerateBigStruct>(GenerateBigStruct_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图大型结构数据
        /// </summary>
        public static bool HasGenerateBigStruct(int cfgId)
        {
            return GenerateBigStruct_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图大型结构数据
        /// </summary>
        public static bool HasGenerateBigStruct(string cfgId)
        {
            return GenerateBigStruct_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 地图装饰物配置
        /// <summary>
        /// 地图装饰物配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapDecorate> MapDecorate_Cache = [];
        /// <summary>
        /// 提前加载所有地图装饰物配置配置缓存
        /// </summary>
        public static void LoadMapDecorate()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapDecorate))
            {
                MapDecorate data = new(val.Value);
                data.InitData2();
                MapDecorate_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的地图装饰物配置基础配置缓存
        /// </summary>
        public static MapDecorate GetMapDecorate(string cfgId)
        {
            if (!MapDecorate_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapDecorate(cfgId);
                    data.InitData2();
                    MapDecorate_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("地图装饰物配置.xlsx表中的 cfg_MapDecorate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapDecorate GetMapDecorate(int cfgId)
        {
            if (!MapDecorate_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapDecorate(cfgId);
                    data.InitData2();
                    MapDecorate_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("地图装饰物配置.xlsx表中的 cfg_MapDecorate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有地图装饰物配置数据
        /// </summary>
        public static List<MapDecorate> GetAllMapDecorate()
        {
            return new List<MapDecorate>(MapDecorate_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图装饰物配置数据
        /// </summary>
        public static bool HasMapDecorate(int cfgId)
        {
            return MapDecorate_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的地图装饰物配置数据
        /// </summary>
        public static bool HasMapDecorate(string cfgId)
        {
            return MapDecorate_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 大地图生成
        /// <summary>
        /// 生成大地图配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapBase> BigMapBase_Cache = [];
        /// <summary>
        /// 提前加载所有生成大地图配置缓存
        /// </summary>
        public static void LoadBigMapBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapBase))
            {
                BigMapBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BigMapBase>(BigMapBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的生成大地图数据
        /// </summary>
        public static bool HasBigMapBase(int cfgId)
        {
            return BigMapBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的生成大地图数据
        /// </summary>
        public static bool HasBigMapBase(string cfgId)
        {
            return BigMapBase_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 大地图节点配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapMaterial> BigMapMaterial_Cache = [];
        /// <summary>
        /// 提前加载所有大地图节点配置缓存
        /// </summary>
        public static void LoadBigMapMaterial()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapMaterial))
            {
                BigMapMaterial data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BigMapMaterial>(BigMapMaterial_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的大地图节点数据
        /// </summary>
        public static bool HasBigMapMaterial(int cfgId)
        {
            return BigMapMaterial_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的大地图节点数据
        /// </summary>
        public static bool HasBigMapMaterial(string cfgId)
        {
            return BigMapMaterial_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 大地图大结构配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapBigCell> BigMapBigCell_Cache = [];
        /// <summary>
        /// 提前加载所有大地图大结构配置缓存
        /// </summary>
        public static void LoadBigMapBigCell()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapBigCell))
            {
                BigMapBigCell data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BigMapBigCell>(BigMapBigCell_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的大地图大结构数据
        /// </summary>
        public static bool HasBigMapBigCell(int cfgId)
        {
            return BigMapBigCell_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的大地图大结构数据
        /// </summary>
        public static bool HasBigMapBigCell(string cfgId)
        {
            return BigMapBigCell_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 节点绘制逻辑配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapCellLogic> BigMapCellLogic_Cache = [];
        /// <summary>
        /// 提前加载所有节点绘制逻辑配置缓存
        /// </summary>
        public static void LoadBigMapCellLogic()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapCellLogic))
            {
                BigMapCellLogic data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BigMapCellLogic>(BigMapCellLogic_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的节点绘制逻辑数据
        /// </summary>
        public static bool HasBigMapCellLogic(int cfgId)
        {
            return BigMapCellLogic_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的节点绘制逻辑数据
        /// </summary>
        public static bool HasBigMapCellLogic(string cfgId)
        {
            return BigMapCellLogic_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 大地图节点事件配置缓存
        /// </summary>
        private static readonly Dictionary<string, BigMapEvent> BigMapEvent_Cache = [];
        /// <summary>
        /// 提前加载所有大地图节点事件配置缓存
        /// </summary>
        public static void LoadBigMapEvent()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BigMapEvent))
            {
                BigMapEvent data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BigMapEvent>(BigMapEvent_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的大地图节点事件数据
        /// </summary>
        public static bool HasBigMapEvent(int cfgId)
        {
            return BigMapEvent_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的大地图节点事件数据
        /// </summary>
        public static bool HasBigMapEvent(string cfgId)
        {
            return BigMapEvent_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 刷怪配置
        /// <summary>
        /// 战役关卡刷怪数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CopyBrush> CopyBrush_Cache = [];
        /// <summary>
        /// 提前加载所有战役关卡刷怪数据配置缓存
        /// </summary>
        public static void LoadCopyBrush()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_CopyBrush))
            {
                CopyBrush data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_CopyBrush配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_CopyBrush配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有战役关卡刷怪数据数据
        /// </summary>
        public static List<CopyBrush> GetAllCopyBrush()
        {
            return new List<CopyBrush>(CopyBrush_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的战役关卡刷怪数据数据
        /// </summary>
        public static bool HasCopyBrush(int cfgId)
        {
            return CopyBrush_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的战役关卡刷怪数据数据
        /// </summary>
        public static bool HasCopyBrush(string cfgId)
        {
            return CopyBrush_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 刷怪点数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BrushPoint> BrushPoint_Cache = [];
        /// <summary>
        /// 提前加载所有刷怪点数据配置缓存
        /// </summary>
        public static void LoadBrushPoint()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BrushPoint))
            {
                BrushPoint data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_BrushPoint配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_BrushPoint配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有刷怪点数据数据
        /// </summary>
        public static List<BrushPoint> GetAllBrushPoint()
        {
            return new List<BrushPoint>(BrushPoint_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的刷怪点数据数据
        /// </summary>
        public static bool HasBrushPoint(int cfgId)
        {
            return BrushPoint_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的刷怪点数据数据
        /// </summary>
        public static bool HasBrushPoint(string cfgId)
        {
            return BrushPoint_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 波数配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, WaveBase> WaveBase_Cache = [];
        /// <summary>
        /// 提前加载所有波数配置配置缓存
        /// </summary>
        public static void LoadWaveBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_WaveBase))
            {
                WaveBase data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_WaveBase配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_WaveBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有波数配置数据
        /// </summary>
        public static List<WaveBase> GetAllWaveBase()
        {
            return new List<WaveBase>(WaveBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的波数配置数据
        /// </summary>
        public static bool HasWaveBase(int cfgId)
        {
            return WaveBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的波数配置数据
        /// </summary>
        public static bool HasWaveBase(string cfgId)
        {
            return WaveBase_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 单位组配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitGroupData> UnitGroupData_Cache = [];
        /// <summary>
        /// 提前加载所有单位组配置配置缓存
        /// </summary>
        public static void LoadUnitGroupData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitGroupData))
            {
                UnitGroupData data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_UnitGroupData配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_UnitGroupData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位组配置数据
        /// </summary>
        public static List<UnitGroupData> GetAllUnitGroupData()
        {
            return new List<UnitGroupData>(UnitGroupData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位组配置数据
        /// </summary>
        public static bool HasUnitGroupData(int cfgId)
        {
            return UnitGroupData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位组配置数据
        /// </summary>
        public static bool HasUnitGroupData(string cfgId)
        {
            return UnitGroupData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 单位组类型配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitGroupType> UnitGroupType_Cache = [];
        /// <summary>
        /// 提前加载所有单位组类型配置缓存
        /// </summary>
        public static void LoadUnitGroupType()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitGroupType))
            {
                UnitGroupType data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_UnitGroupType配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("刷怪配置.xlsx表中的 cfg_UnitGroupType配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有单位组类型数据
        /// </summary>
        public static List<UnitGroupType> GetAllUnitGroupType()
        {
            return new List<UnitGroupType>(UnitGroupType_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位组类型数据
        /// </summary>
        public static bool HasUnitGroupType(int cfgId)
        {
            return UnitGroupType_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位组类型数据
        /// </summary>
        public static bool HasUnitGroupType(string cfgId)
        {
            return UnitGroupType_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 战役副本相关
        /// <summary>
        /// 战役基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ChapterBase> ChapterBase_Cache = [];
        /// <summary>
        /// 提前加载所有战役基础数据配置缓存
        /// </summary>
        public static void LoadChapterBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ChapterBase))
            {
                ChapterBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ChapterBase>(ChapterBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的战役基础数据数据
        /// </summary>
        public static bool HasChapterBase(int cfgId)
        {
            return ChapterBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的战役基础数据数据
        /// </summary>
        public static bool HasChapterBase(string cfgId)
        {
            return ChapterBase_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 战役关卡基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ChapterCopyBase> ChapterCopyBase_Cache = [];
        /// <summary>
        /// 提前加载所有战役关卡基础数据配置缓存
        /// </summary>
        public static void LoadChapterCopyBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ChapterCopyBase))
            {
                ChapterCopyBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ChapterCopyBase>(ChapterCopyBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的战役关卡基础数据数据
        /// </summary>
        public static bool HasChapterCopyBase(int cfgId)
        {
            return ChapterCopyBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的战役关卡基础数据数据
        /// </summary>
        public static bool HasChapterCopyBase(string cfgId)
        {
            return ChapterCopyBase_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 关卡建造限制配置缓存
        /// </summary>
        private static readonly Dictionary<string, CopyBuildLimit> CopyBuildLimit_Cache = [];
        /// <summary>
        /// 提前加载所有关卡建造限制配置缓存
        /// </summary>
        public static void LoadCopyBuildLimit()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_CopyBuildLimit))
            {
                CopyBuildLimit data = new(val.Value);
                data.InitData2();
                CopyBuildLimit_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的关卡建造限制基础配置缓存
        /// </summary>
        public static CopyBuildLimit GetCopyBuildLimit(string cfgId)
        {
            if (!CopyBuildLimit_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new CopyBuildLimit(cfgId);
                    data.InitData2();
                    CopyBuildLimit_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_CopyBuildLimit配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static CopyBuildLimit GetCopyBuildLimit(int cfgId)
        {
            if (!CopyBuildLimit_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new CopyBuildLimit(cfgId);
                    data.InitData2();
                    CopyBuildLimit_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_CopyBuildLimit配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有关卡建造限制数据
        /// </summary>
        public static List<CopyBuildLimit> GetAllCopyBuildLimit()
        {
            return new List<CopyBuildLimit>(CopyBuildLimit_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的关卡建造限制数据
        /// </summary>
        public static bool HasCopyBuildLimit(int cfgId)
        {
            return CopyBuildLimit_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的关卡建造限制数据
        /// </summary>
        public static bool HasCopyBuildLimit(string cfgId)
        {
            return CopyBuildLimit_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 章节关卡描述数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ChapterCopyUI> ChapterCopyUI_Cache = [];
        /// <summary>
        /// 提前加载所有章节关卡描述数据配置缓存
        /// </summary>
        public static void LoadChapterCopyUI()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ChapterCopyUI))
            {
                ChapterCopyUI data = new(val.Value);
                data.InitData2();
                ChapterCopyUI_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的章节关卡描述数据基础配置缓存
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
                catch (Exception)
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
                catch (Exception)
                {
                    Log.PrintConfigError("战役副本相关.xlsx表中的 cfg_ChapterCopyUI配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有章节关卡描述数据数据
        /// </summary>
        public static List<ChapterCopyUI> GetAllChapterCopyUI()
        {
            return new List<ChapterCopyUI>(ChapterCopyUI_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的章节关卡描述数据数据
        /// </summary>
        public static bool HasChapterCopyUI(int cfgId)
        {
            return ChapterCopyUI_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的章节关卡描述数据数据
        /// </summary>
        public static bool HasChapterCopyUI(string cfgId)
        {
            return ChapterCopyUI_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 音乐配置
        /// <summary>
        /// 背景音乐配置缓存
        /// </summary>
        private static readonly Dictionary<string, BackgroundMusic> BackgroundMusic_Cache = [];
        /// <summary>
        /// 提前加载所有背景音乐配置缓存
        /// </summary>
        public static void LoadBackgroundMusic()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BackgroundMusic))
            {
                BackgroundMusic data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BackgroundMusic>(BackgroundMusic_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的背景音乐数据
        /// </summary>
        public static bool HasBackgroundMusic(int cfgId)
        {
            return BackgroundMusic_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的背景音乐数据
        /// </summary>
        public static bool HasBackgroundMusic(string cfgId)
        {
            return BackgroundMusic_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 音效配置
        /// <summary>
        /// UI音效配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, UISoundSfx> UISoundSfx_Cache = [];
        /// <summary>
        /// 提前加载所有UI音效配置配置缓存
        /// </summary>
        public static void LoadUISoundSfx()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_UISoundSfx))
            {
                UISoundSfx data = new(val.Value);
                data.InitData2();
                UISoundSfx_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的UI音效配置基础配置缓存
        /// </summary>
        public static UISoundSfx GetUISoundSfx(string cfgId)
        {
            if (!UISoundSfx_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new UISoundSfx(cfgId);
                    data.InitData2();
                    UISoundSfx_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("音效配置.xlsx表中的 cfg_UISoundSfx配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static UISoundSfx GetUISoundSfx(int cfgId)
        {
            if (!UISoundSfx_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new UISoundSfx(cfgId);
                    data.InitData2();
                    UISoundSfx_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("音效配置.xlsx表中的 cfg_UISoundSfx配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有UI音效配置数据
        /// </summary>
        public static List<UISoundSfx> GetAllUISoundSfx()
        {
            return new List<UISoundSfx>(UISoundSfx_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的UI音效配置数据
        /// </summary>
        public static bool HasUISoundSfx(int cfgId)
        {
            return UISoundSfx_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的UI音效配置数据
        /// </summary>
        public static bool HasUISoundSfx(string cfgId)
        {
            return UISoundSfx_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 音效配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, SoundSfx> SoundSfx_Cache = [];
        /// <summary>
        /// 提前加载所有音效配置配置缓存
        /// </summary>
        public static void LoadSoundSfx()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_SoundSfx))
            {
                SoundSfx data = new(val.Value);
                data.InitData2();
                SoundSfx_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的音效配置基础配置缓存
        /// </summary>
        public static SoundSfx GetSoundSfx(string cfgId)
        {
            if (!SoundSfx_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new SoundSfx(cfgId);
                    data.InitData2();
                    SoundSfx_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("音效配置.xlsx表中的 cfg_SoundSfx配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static SoundSfx GetSoundSfx(int cfgId)
        {
            if (!SoundSfx_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new SoundSfx(cfgId);
                    data.InitData2();
                    SoundSfx_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("音效配置.xlsx表中的 cfg_SoundSfx配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有音效配置数据
        /// </summary>
        public static List<SoundSfx> GetAllSoundSfx()
        {
            return new List<SoundSfx>(SoundSfx_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的音效配置数据
        /// </summary>
        public static bool HasSoundSfx(int cfgId)
        {
            return SoundSfx_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的音效配置数据
        /// </summary>
        public static bool HasSoundSfx(string cfgId)
        {
            return SoundSfx_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 子弹配置
        /// <summary>
        /// 子弹基础数据表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletData> BulletData_Cache = [];
        /// <summary>
        /// 提前加载所有子弹基础数据表配置缓存
        /// </summary>
        public static void LoadBulletData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletData))
            {
                BulletData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BulletData>(BulletData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的子弹基础数据表数据
        /// </summary>
        public static bool HasBulletData(int cfgId)
        {
            return BulletData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的子弹基础数据表数据
        /// </summary>
        public static bool HasBulletData(string cfgId)
        {
            return BulletData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 实体子弹逻辑表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BulletLogic> BulletLogic_Cache = [];
        /// <summary>
        /// 提前加载所有实体子弹逻辑表配置缓存
        /// </summary>
        public static void LoadBulletLogic()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BulletLogic))
            {
                BulletLogic data = new(val.Value);
                data.InitData2();
                BulletLogic_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体子弹逻辑表基础配置缓存
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
                catch (Exception)
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
                catch (Exception)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_BulletLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体子弹逻辑表数据
        /// </summary>
        public static List<BulletLogic> GetAllBulletLogic()
        {
            return new List<BulletLogic>(BulletLogic_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体子弹逻辑表数据
        /// </summary>
        public static bool HasBulletLogic(int cfgId)
        {
            return BulletLogic_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体子弹逻辑表数据
        /// </summary>
        public static bool HasBulletLogic(string cfgId)
        {
            return BulletLogic_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 激光子弹逻辑表配置缓存
        /// </summary>
        private static readonly Dictionary<string, LaserBulletLogic> LaserBulletLogic_Cache = [];
        /// <summary>
        /// 提前加载所有激光子弹逻辑表配置缓存
        /// </summary>
        public static void LoadLaserBulletLogic()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_LaserBulletLogic))
            {
                LaserBulletLogic data = new(val.Value);
                data.InitData2();
                LaserBulletLogic_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的激光子弹逻辑表基础配置缓存
        /// </summary>
        public static LaserBulletLogic GetLaserBulletLogic(string cfgId)
        {
            if (!LaserBulletLogic_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new LaserBulletLogic(cfgId);
                    data.InitData2();
                    LaserBulletLogic_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_LaserBulletLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static LaserBulletLogic GetLaserBulletLogic(int cfgId)
        {
            if (!LaserBulletLogic_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new LaserBulletLogic(cfgId);
                    data.InitData2();
                    LaserBulletLogic_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("子弹配置.xlsx表中的 cfg_LaserBulletLogic配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有激光子弹逻辑表数据
        /// </summary>
        public static List<LaserBulletLogic> GetAllLaserBulletLogic()
        {
            return new List<LaserBulletLogic>(LaserBulletLogic_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的激光子弹逻辑表数据
        /// </summary>
        public static bool HasLaserBulletLogic(int cfgId)
        {
            return LaserBulletLogic_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的激光子弹逻辑表数据
        /// </summary>
        public static bool HasLaserBulletLogic(string cfgId)
        {
            return LaserBulletLogic_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 爆炸配置
        /// <summary>
        /// 爆炸基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ExplodeData> ExplodeData_Cache = [];
        /// <summary>
        /// 提前加载所有爆炸基础数据配置缓存
        /// </summary>
        public static void LoadExplodeData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ExplodeData))
            {
                ExplodeData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ExplodeData>(ExplodeData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸基础数据数据
        /// </summary>
        public static bool HasExplodeData(int cfgId)
        {
            return ExplodeData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸基础数据数据
        /// </summary>
        public static bool HasExplodeData(string cfgId)
        {
            return ExplodeData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 爆炸伤害数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, ExplodeHarm> ExplodeHarm_Cache = [];
        /// <summary>
        /// 提前加载所有爆炸伤害数据配置缓存
        /// </summary>
        public static void LoadExplodeHarm()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ExplodeHarm))
            {
                ExplodeHarm data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ExplodeHarm>(ExplodeHarm_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸伤害数据数据
        /// </summary>
        public static bool HasExplodeHarm(int cfgId)
        {
            return ExplodeHarm_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的爆炸伤害数据数据
        /// </summary>
        public static bool HasExplodeHarm(string cfgId)
        {
            return ExplodeHarm_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 单位配置
        /// <summary>
        /// 单位基础表配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitData> UnitData_Cache = [];
        /// <summary>
        /// 提前加载所有单位基础表配置缓存
        /// </summary>
        public static void LoadUnitData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitData))
            {
                UnitData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<UnitData>(UnitData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位基础表数据
        /// </summary>
        public static bool HasUnitData(int cfgId)
        {
            return UnitData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位基础表数据
        /// </summary>
        public static bool HasUnitData(string cfgId)
        {
            return UnitData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 单位逻辑表配置缓存
        /// </summary>
        private static readonly Dictionary<string, UnitLogic> UnitLogic_Cache = [];
        /// <summary>
        /// 提前加载所有单位逻辑表配置缓存
        /// </summary>
        public static void LoadUnitLogic()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_UnitLogic))
            {
                UnitLogic data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<UnitLogic>(UnitLogic_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位逻辑表数据
        /// </summary>
        public static bool HasUnitLogic(int cfgId)
        {
            return UnitLogic_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的单位逻辑表数据
        /// </summary>
        public static bool HasUnitLogic(string cfgId)
        {
            return UnitLogic_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 实体显示相关配置
        /// <summary>
        /// 实体显示方式表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BaseObjectShow> BaseObjectShow_Cache = [];
        /// <summary>
        /// 提前加载所有实体显示方式表配置缓存
        /// </summary>
        public static void LoadBaseObjectShow()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BaseObjectShow))
            {
                BaseObjectShow data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BaseObjectShow>(BaseObjectShow_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体显示方式表数据
        /// </summary>
        public static bool HasBaseObjectShow(int cfgId)
        {
            return BaseObjectShow_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体显示方式表数据
        /// </summary>
        public static bool HasBaseObjectShow(string cfgId)
        {
            return BaseObjectShow_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 底部栏配置缓存
        /// </summary>
        private static readonly Dictionary<string, ObjectBottomBar> ObjectBottomBar_Cache = [];
        /// <summary>
        /// 提前加载所有底部栏配置缓存
        /// </summary>
        public static void LoadObjectBottomBar()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ObjectBottomBar))
            {
                ObjectBottomBar data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ObjectBottomBar>(ObjectBottomBar_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的底部栏数据
        /// </summary>
        public static bool HasObjectBottomBar(int cfgId)
        {
            return ObjectBottomBar_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的底部栏数据
        /// </summary>
        public static bool HasObjectBottomBar(string cfgId)
        {
            return ObjectBottomBar_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 侧边栏配置缓存
        /// </summary>
        private static readonly Dictionary<string, ObjectSideBar> ObjectSideBar_Cache = [];
        /// <summary>
        /// 提前加载所有侧边栏配置缓存
        /// </summary>
        public static void LoadObjectSideBar()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ObjectSideBar))
            {
                ObjectSideBar data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ObjectSideBar>(ObjectSideBar_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的侧边栏数据
        /// </summary>
        public static bool HasObjectSideBar(int cfgId)
        {
            return ObjectSideBar_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的侧边栏数据
        /// </summary>
        public static bool HasObjectSideBar(string cfgId)
        {
            return ObjectSideBar_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 实体相关配置
        /// <summary>
        /// 实体表配置缓存
        /// </summary>
        private static readonly Dictionary<string, BaseObjectData> BaseObjectData_Cache = [];
        /// <summary>
        /// 提前加载所有实体表配置缓存
        /// </summary>
        public static void LoadBaseObjectData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BaseObjectData))
            {
                BaseObjectData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BaseObjectData>(BaseObjectData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体表数据
        /// </summary>
        public static bool HasBaseObjectData(int cfgId)
        {
            return BaseObjectData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体表数据
        /// </summary>
        public static bool HasBaseObjectData(string cfgId)
        {
            return BaseObjectData_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 建筑配置
        /// <summary>
        /// 建筑及炮塔数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuildData> BuildData_Cache = [];
        /// <summary>
        /// 提前加载所有建筑及炮塔数据配置缓存
        /// </summary>
        public static void LoadBuildData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuildData))
            {
                BuildData data = new(val.Value);
                data.InitData2();
                BuildData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建筑及炮塔数据基础配置缓存
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
                catch (Exception)
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
                catch (Exception)
                {
                    Log.PrintConfigError("建筑配置.xlsx表中的 cfg_BuildData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建筑及炮塔数据数据
        /// </summary>
        public static List<BuildData> GetAllBuildData()
        {
            return new List<BuildData>(BuildData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的建筑及炮塔数据数据
        /// </summary>
        public static bool HasBuildData(int cfgId)
        {
            return BuildData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的建筑及炮塔数据数据
        /// </summary>
        public static bool HasBuildData(string cfgId)
        {
            return BuildData_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 无人机配置
        /// <summary>
        /// 无人机基础表配置缓存
        /// </summary>
        private static readonly Dictionary<string, WorkerData> WorkerData_Cache = [];
        /// <summary>
        /// 提前加载所有无人机基础表配置缓存
        /// </summary>
        public static void LoadWorkerData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_WorkerData))
            {
                WorkerData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<WorkerData>(WorkerData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的无人机基础表数据
        /// </summary>
        public static bool HasWorkerData(int cfgId)
        {
            return WorkerData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的无人机基础表数据
        /// </summary>
        public static bool HasWorkerData(string cfgId)
        {
            return WorkerData_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 武器配置
        /// <summary>
        /// 武器数据1配置缓存
        /// </summary>
        private static readonly Dictionary<string, WeaponData> WeaponData_Cache = [];
        /// <summary>
        /// 提前加载所有武器数据1配置缓存
        /// </summary>
        public static void LoadWeaponData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_WeaponData))
            {
                WeaponData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<WeaponData>(WeaponData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器数据1数据
        /// </summary>
        public static bool HasWeaponData(int cfgId)
        {
            return WeaponData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器数据1数据
        /// </summary>
        public static bool HasWeaponData(string cfgId)
        {
            return WeaponData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 武器数据2配置缓存
        /// </summary>
        private static readonly Dictionary<string, WeaponData2> WeaponData2_Cache = [];
        /// <summary>
        /// 提前加载所有武器数据2配置缓存
        /// </summary>
        public static void LoadWeaponData2()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_WeaponData2))
            {
                WeaponData2 data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<WeaponData2>(WeaponData2_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器数据2数据
        /// </summary>
        public static bool HasWeaponData2(int cfgId)
        {
            return WeaponData2_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的武器数据2数据
        /// </summary>
        public static bool HasWeaponData2(string cfgId)
        {
            return WeaponData2_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 残骸配置
        /// <summary>
        /// 残骸配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, WreckAge> WreckAge_Cache = [];
        /// <summary>
        /// 提前加载所有残骸配置配置缓存
        /// </summary>
        public static void LoadWreckAge()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_WreckAge))
            {
                WreckAge data = new(val.Value);
                data.InitData2();
                WreckAge_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的残骸配置基础配置缓存
        /// </summary>
        public static WreckAge GetWreckAge(string cfgId)
        {
            if (!WreckAge_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new WreckAge(cfgId);
                    data.InitData2();
                    WreckAge_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("残骸配置.xlsx表中的 cfg_WreckAge配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static WreckAge GetWreckAge(int cfgId)
        {
            if (!WreckAge_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new WreckAge(cfgId);
                    data.InitData2();
                    WreckAge_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("残骸配置.xlsx表中的 cfg_WreckAge配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有残骸配置数据
        /// </summary>
        public static List<WreckAge> GetAllWreckAge()
        {
            return new List<WreckAge>(WreckAge_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的残骸配置数据
        /// </summary>
        public static bool HasWreckAge(int cfgId)
        {
            return WreckAge_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的残骸配置数据
        /// </summary>
        public static bool HasWreckAge(string cfgId)
        {
            return WreckAge_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region buff配置
        /// <summary>
        /// buff标签数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuffTag> BuffTag_Cache = [];
        /// <summary>
        /// 提前加载所有buff标签数据配置缓存
        /// </summary>
        public static void LoadBuffTag()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuffTag))
            {
                BuffTag data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BuffTag>(BuffTag_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的buff标签数据数据
        /// </summary>
        public static bool HasBuffTag(int cfgId)
        {
            return BuffTag_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的buff标签数据数据
        /// </summary>
        public static bool HasBuffTag(string cfgId)
        {
            return BuffTag_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// buff基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuffData> BuffData_Cache = [];
        /// <summary>
        /// 提前加载所有buff基础数据配置缓存
        /// </summary>
        public static void LoadBuffData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuffData))
            {
                BuffData data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BuffData>(BuffData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的buff基础数据数据
        /// </summary>
        public static bool HasBuffData(int cfgId)
        {
            return BuffData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的buff基础数据数据
        /// </summary>
        public static bool HasBuffData(string cfgId)
        {
            return BuffData_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 事件配置
        /// <summary>
        /// 实体事件配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrEvent> AttrEvent_Cache = [];
        /// <summary>
        /// 提前加载所有实体事件配置缓存
        /// </summary>
        public static void LoadAttrEvent()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrEvent))
            {
                AttrEvent data = new(val.Value);
                data.InitData2();
                AttrEvent_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的实体事件基础配置缓存
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
                catch (Exception)
                {
                    Log.PrintConfigError("事件配置.xlsx表中的 cfg_AttrEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("事件配置.xlsx表中的 cfg_AttrEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体事件数据
        /// </summary>
        public static List<AttrEvent> GetAllAttrEvent()
        {
            return new List<AttrEvent>(AttrEvent_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体事件数据
        /// </summary>
        public static bool HasAttrEvent(int cfgId)
        {
            return AttrEvent_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体事件数据
        /// </summary>
        public static bool HasAttrEvent(string cfgId)
        {
            return AttrEvent_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 全局事件配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalAttrEvent> GlobalAttrEvent_Cache = [];
        /// <summary>
        /// 提前加载所有全局事件配置缓存
        /// </summary>
        public static void LoadGlobalAttrEvent()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalAttrEvent))
            {
                GlobalAttrEvent data = new(val.Value);
                data.InitData2();
                GlobalAttrEvent_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的全局事件基础配置缓存
        /// </summary>
        public static GlobalAttrEvent GetGlobalAttrEvent(string cfgId)
        {
            if (!GlobalAttrEvent_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrEvent(cfgId);
                    data.InitData2();
                    GlobalAttrEvent_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("事件配置.xlsx表中的 cfg_GlobalAttrEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalAttrEvent GetGlobalAttrEvent(int cfgId)
        {
            if (!GlobalAttrEvent_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrEvent(cfgId);
                    data.InitData2();
                    GlobalAttrEvent_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("事件配置.xlsx表中的 cfg_GlobalAttrEvent配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有全局事件数据
        /// </summary>
        public static List<GlobalAttrEvent> GetAllGlobalAttrEvent()
        {
            return new List<GlobalAttrEvent>(GlobalAttrEvent_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局事件数据
        /// </summary>
        public static bool HasGlobalAttrEvent(int cfgId)
        {
            return GlobalAttrEvent_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局事件数据
        /// </summary>
        public static bool HasGlobalAttrEvent(string cfgId)
        {
            return GlobalAttrEvent_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 全局属性基础表
        /// <summary>
        /// 全局属性表配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalAttributeBase> GlobalAttributeBase_Cache = [];
        /// <summary>
        /// 提前加载所有全局属性表配置缓存
        /// </summary>
        public static void LoadGlobalAttributeBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalAttributeBase))
            {
                GlobalAttributeBase data = new(val.Value);
                data.InitData2();
                GlobalAttributeBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的全局属性表基础配置缓存
        /// </summary>
        public static GlobalAttributeBase GetGlobalAttributeBase(string cfgId)
        {
            if (!GlobalAttributeBase_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttributeBase(cfgId);
                    data.InitData2();
                    GlobalAttributeBase_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性基础表.xlsx表中的 cfg_GlobalAttributeBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalAttributeBase GetGlobalAttributeBase(int cfgId)
        {
            if (!GlobalAttributeBase_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttributeBase(cfgId);
                    data.InitData2();
                    GlobalAttributeBase_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性基础表.xlsx表中的 cfg_GlobalAttributeBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有全局属性表数据
        /// </summary>
        public static List<GlobalAttributeBase> GetAllGlobalAttributeBase()
        {
            return new List<GlobalAttributeBase>(GlobalAttributeBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局属性表数据
        /// </summary>
        public static bool HasGlobalAttributeBase(int cfgId)
        {
            return GlobalAttributeBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局属性表数据
        /// </summary>
        public static bool HasGlobalAttributeBase(string cfgId)
        {
            return GlobalAttributeBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 全局属性配置
        /// <summary>
        /// 属性模板表配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalAttrTem> GlobalAttrTem_Cache = [];
        /// <summary>
        /// 提前加载所有属性模板表配置缓存
        /// </summary>
        public static void LoadGlobalAttrTem()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalAttrTem))
            {
                GlobalAttrTem data = new(val.Value);
                data.InitData2();
                GlobalAttrTem_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的属性模板表基础配置缓存
        /// </summary>
        public static GlobalAttrTem GetGlobalAttrTem(string cfgId)
        {
            if (!GlobalAttrTem_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrTem(cfgId);
                    data.InitData2();
                    GlobalAttrTem_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性配置.xlsx表中的 cfg_GlobalAttrTem配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalAttrTem GetGlobalAttrTem(int cfgId)
        {
            if (!GlobalAttrTem_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrTem(cfgId);
                    data.InitData2();
                    GlobalAttrTem_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性配置.xlsx表中的 cfg_GlobalAttrTem配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性模板表数据
        /// </summary>
        public static List<GlobalAttrTem> GetAllGlobalAttrTem()
        {
            return new List<GlobalAttrTem>(GlobalAttrTem_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性模板表数据
        /// </summary>
        public static bool HasGlobalAttrTem(int cfgId)
        {
            return GlobalAttrTem_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性模板表数据
        /// </summary>
        public static bool HasGlobalAttrTem(string cfgId)
        {
            return GlobalAttrTem_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 全局属性表配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalAttrData> GlobalAttrData_Cache = [];
        /// <summary>
        /// 提前加载所有全局属性表配置缓存
        /// </summary>
        public static void LoadGlobalAttrData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalAttrData))
            {
                GlobalAttrData data = new(val.Value);
                data.InitData2();
                GlobalAttrData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的全局属性表基础配置缓存
        /// </summary>
        public static GlobalAttrData GetGlobalAttrData(string cfgId)
        {
            if (!GlobalAttrData_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrData(cfgId);
                    data.InitData2();
                    GlobalAttrData_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性配置.xlsx表中的 cfg_GlobalAttrData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalAttrData GetGlobalAttrData(int cfgId)
        {
            if (!GlobalAttrData_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrData(cfgId);
                    data.InitData2();
                    GlobalAttrData_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性配置.xlsx表中的 cfg_GlobalAttrData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有全局属性表数据
        /// </summary>
        public static List<GlobalAttrData> GetAllGlobalAttrData()
        {
            return new List<GlobalAttrData>(GlobalAttrData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局属性表数据
        /// </summary>
        public static bool HasGlobalAttrData(int cfgId)
        {
            return GlobalAttrData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局属性表数据
        /// </summary>
        public static bool HasGlobalAttrData(string cfgId)
        {
            return GlobalAttrData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 全局修饰器配置缓存
        /// </summary>
        private static readonly Dictionary<string, GlobalAttrMod> GlobalAttrMod_Cache = [];
        /// <summary>
        /// 提前加载所有全局修饰器配置缓存
        /// </summary>
        public static void LoadGlobalAttrMod()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GlobalAttrMod))
            {
                GlobalAttrMod data = new(val.Value);
                data.InitData2();
                GlobalAttrMod_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的全局修饰器基础配置缓存
        /// </summary>
        public static GlobalAttrMod GetGlobalAttrMod(string cfgId)
        {
            if (!GlobalAttrMod_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrMod(cfgId);
                    data.InitData2();
                    GlobalAttrMod_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性配置.xlsx表中的 cfg_GlobalAttrMod配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static GlobalAttrMod GetGlobalAttrMod(int cfgId)
        {
            if (!GlobalAttrMod_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new GlobalAttrMod(cfgId);
                    data.InitData2();
                    GlobalAttrMod_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("全局属性配置.xlsx表中的 cfg_GlobalAttrMod配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有全局修饰器数据
        /// </summary>
        public static List<GlobalAttrMod> GetAllGlobalAttrMod()
        {
            return new List<GlobalAttrMod>(GlobalAttrMod_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局修饰器数据
        /// </summary>
        public static bool HasGlobalAttrMod(int cfgId)
        {
            return GlobalAttrMod_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的全局修饰器数据
        /// </summary>
        public static bool HasGlobalAttrMod(string cfgId)
        {
            return GlobalAttrMod_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 实体属性基础表
        /// <summary>
        /// 属性表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttributeBase> AttributeBase_Cache = [];
        /// <summary>
        /// 提前加载所有属性表配置缓存
        /// </summary>
        public static void LoadAttributeBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttributeBase))
            {
                AttributeBase data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性基础表.xlsx表中的 cfg_AttributeBase配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性基础表.xlsx表中的 cfg_AttributeBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性表数据
        /// </summary>
        public static List<AttributeBase> GetAllAttributeBase()
        {
            return new List<AttributeBase>(AttributeBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性表数据
        /// </summary>
        public static bool HasAttributeBase(int cfgId)
        {
            return AttributeBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性表数据
        /// </summary>
        public static bool HasAttributeBase(string cfgId)
        {
            return AttributeBase_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 属性计算表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrCalculate> AttrCalculate_Cache = [];
        /// <summary>
        /// 提前加载所有属性计算表配置缓存
        /// </summary>
        public static void LoadAttrCalculate()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrCalculate))
            {
                AttrCalculate data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性基础表.xlsx表中的 cfg_AttrCalculate配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性基础表.xlsx表中的 cfg_AttrCalculate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性计算表数据
        /// </summary>
        public static List<AttrCalculate> GetAllAttrCalculate()
        {
            return new List<AttrCalculate>(AttrCalculate_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性计算表数据
        /// </summary>
        public static bool HasAttrCalculate(int cfgId)
        {
            return AttrCalculate_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性计算表数据
        /// </summary>
        public static bool HasAttrCalculate(string cfgId)
        {
            return AttrCalculate_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 属性依赖表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrDependency> AttrDependency_Cache = [];
        /// <summary>
        /// 提前加载所有属性依赖表配置缓存
        /// </summary>
        public static void LoadAttrDependency()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrDependency))
            {
                AttrDependency data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性基础表.xlsx表中的 cfg_AttrDependency配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性基础表.xlsx表中的 cfg_AttrDependency配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性依赖表数据
        /// </summary>
        public static List<AttrDependency> GetAllAttrDependency()
        {
            return new List<AttrDependency>(AttrDependency_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性依赖表数据
        /// </summary>
        public static bool HasAttrDependency(int cfgId)
        {
            return AttrDependency_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性依赖表数据
        /// </summary>
        public static bool HasAttrDependency(string cfgId)
        {
            return AttrDependency_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 实体属性配置
        /// <summary>
        /// 属性模板表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttributeTemplate> AttributeTemplate_Cache = [];
        /// <summary>
        /// 提前加载所有属性模板表配置缓存
        /// </summary>
        public static void LoadAttributeTemplate()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttributeTemplate))
            {
                AttributeTemplate data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性配置.xlsx表中的 cfg_AttributeTemplate配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性配置.xlsx表中的 cfg_AttributeTemplate配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性模板表数据
        /// </summary>
        public static List<AttributeTemplate> GetAllAttributeTemplate()
        {
            return new List<AttributeTemplate>(AttributeTemplate_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性模板表数据
        /// </summary>
        public static bool HasAttributeTemplate(int cfgId)
        {
            return AttributeTemplate_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性模板表数据
        /// </summary>
        public static bool HasAttributeTemplate(string cfgId)
        {
            return AttributeTemplate_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 实体属性表配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttributeData> AttributeData_Cache = [];
        /// <summary>
        /// 提前加载所有实体属性表配置缓存
        /// </summary>
        public static void LoadAttributeData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttributeData))
            {
                AttributeData data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性配置.xlsx表中的 cfg_AttributeData配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性配置.xlsx表中的 cfg_AttributeData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有实体属性表数据
        /// </summary>
        public static List<AttributeData> GetAllAttributeData()
        {
            return new List<AttributeData>(AttributeData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体属性表数据
        /// </summary>
        public static bool HasAttributeData(int cfgId)
        {
            return AttributeData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的实体属性表数据
        /// </summary>
        public static bool HasAttributeData(string cfgId)
        {
            return AttributeData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 属性修饰器配置缓存
        /// </summary>
        private static readonly Dictionary<string, AttrModifier> AttrModifier_Cache = [];
        /// <summary>
        /// 提前加载所有属性修饰器配置缓存
        /// </summary>
        public static void LoadAttrModifier()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_AttrModifier))
            {
                AttrModifier data = new(val.Value);
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性配置.xlsx表中的 cfg_AttrModifier配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("实体属性配置.xlsx表中的 cfg_AttrModifier配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有属性修饰器数据
        /// </summary>
        public static List<AttrModifier> GetAllAttrModifier()
        {
            return new List<AttrModifier>(AttrModifier_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性修饰器数据
        /// </summary>
        public static bool HasAttrModifier(int cfgId)
        {
            return AttrModifier_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的属性修饰器数据
        /// </summary>
        public static bool HasAttrModifier(string cfgId)
        {
            return AttrModifier_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 建造列表相关配置
        /// <summary>
        /// 建造列表标签配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapBuildLable> MapBuildLable_Cache = [];
        /// <summary>
        /// 提前加载所有建造列表标签配置缓存
        /// </summary>
        public static void LoadMapBuildLable()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapBuildLable))
            {
                MapBuildLable data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<MapBuildLable>(MapBuildLable_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的建造列表标签数据
        /// </summary>
        public static bool HasMapBuildLable(int cfgId)
        {
            return MapBuildLable_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的建造列表标签数据
        /// </summary>
        public static bool HasMapBuildLable(string cfgId)
        {
            return MapBuildLable_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 建造项数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, MapBuildItem> MapBuildItem_Cache = [];
        /// <summary>
        /// 提前加载所有建造项数据配置缓存
        /// </summary>
        public static void LoadMapBuildItem()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MapBuildItem))
            {
                MapBuildItem data = new(val.Value);
                data.InitData2();
                MapBuildItem_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的建造项数据基础配置缓存
        /// </summary>
        public static MapBuildItem GetMapBuildItem(string cfgId)
        {
            if (!MapBuildItem_Cache.TryGetValue(cfgId, out var data))
            {
                try
                {
                    data = new MapBuildItem(cfgId);
                    data.InitData2();
                    MapBuildItem_Cache.Add(cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_MapBuildItem配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        public static MapBuildItem GetMapBuildItem(int cfgId)
        {
            if (!MapBuildItem_Cache.TryGetValue("" + cfgId, out var data))
            {
                try
                {
                    data = new MapBuildItem(cfgId);
                    data.InitData2();
                    MapBuildItem_Cache.Add("" + cfgId, data);
                }
                catch (Exception)
                {
                    Log.PrintConfigError("建造列表相关配置.xlsx表中的 cfg_MapBuildItem配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有建造项数据数据
        /// </summary>
        public static List<MapBuildItem> GetAllMapBuildItem()
        {
            return new List<MapBuildItem>(MapBuildItem_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的建造项数据数据
        /// </summary>
        public static bool HasMapBuildItem(int cfgId)
        {
            return MapBuildItem_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的建造项数据数据
        /// </summary>
        public static bool HasMapBuildItem(string cfgId)
        {
            return MapBuildItem_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 建造规则配置缓存
        /// </summary>
        private static readonly Dictionary<string, BuildRule> BuildRule_Cache = [];
        /// <summary>
        /// 提前加载所有建造规则配置缓存
        /// </summary>
        public static void LoadBuildRule()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BuildRule))
            {
                BuildRule data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<BuildRule>(BuildRule_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的建造规则数据
        /// </summary>
        public static bool HasBuildRule(int cfgId)
        {
            return BuildRule_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的建造规则数据
        /// </summary>
        public static bool HasBuildRule(string cfgId)
        {
            return BuildRule_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 阵营相关
        /// <summary>
        /// 阵营基础数据配置缓存
        /// </summary>
        private static readonly Dictionary<string, CampBase> CampBase_Cache = [];
        /// <summary>
        /// 提前加载所有阵营基础数据配置缓存
        /// </summary>
        public static void LoadCampBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_CampBase))
            {
                CampBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<CampBase>(CampBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的阵营基础数据数据
        /// </summary>
        public static bool HasCampBase(int cfgId)
        {
            return CampBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的阵营基础数据数据
        /// </summary>
        public static bool HasCampBase(string cfgId)
        {
            return CampBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 难度相关
        /// <summary>
        /// 游戏难度相关配置缓存
        /// </summary>
        private static readonly Dictionary<string, GameDiffBase> GameDiffBase_Cache = [];
        /// <summary>
        /// 提前加载所有游戏难度相关配置缓存
        /// </summary>
        public static void LoadGameDiffBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_GameDiffBase))
            {
                GameDiffBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<GameDiffBase>(GameDiffBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的游戏难度相关数据
        /// </summary>
        public static bool HasGameDiffBase(int cfgId)
        {
            return GameDiffBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的游戏难度相关数据
        /// </summary>
        public static bool HasGameDiffBase(string cfgId)
        {
            return GameDiffBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 背包 道具 及货币相关配置
        /// <summary>
        /// 背包配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, BagData> BagData_Cache = [];
        /// <summary>
        /// 提前加载所有背包配置配置缓存
        /// </summary>
        public static void LoadBagData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_BagData))
            {
                BagData data = new(val.Value);
                data.InitData2();
                BagData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的背包配置基础配置缓存
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
                catch (Exception)
                {
                    Log.PrintConfigError("背包 道具 及货币相关配置.xlsx表中的 cfg_bagData配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("背包 道具 及货币相关配置.xlsx表中的 cfg_bagData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有背包配置数据
        /// </summary>
        public static List<BagData> GetAllBagData()
        {
            return new List<BagData>(BagData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的背包配置数据
        /// </summary>
        public static bool HasBagData(int cfgId)
        {
            return BagData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的背包配置数据
        /// </summary>
        public static bool HasBagData(string cfgId)
        {
            return BagData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 道具配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, ItemData> ItemData_Cache = [];
        /// <summary>
        /// 提前加载所有道具配置配置缓存
        /// </summary>
        public static void LoadItemData()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ItemData))
            {
                ItemData data = new(val.Value);
                data.InitData2();
                ItemData_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的道具配置基础配置缓存
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
                catch (Exception)
                {
                    Log.PrintConfigError("背包 道具 及货币相关配置.xlsx表中的 cfg_itemData配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("背包 道具 及货币相关配置.xlsx表中的 cfg_itemData配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有道具配置数据
        /// </summary>
        public static List<ItemData> GetAllItemData()
        {
            return new List<ItemData>(ItemData_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的道具配置数据
        /// </summary>
        public static bool HasItemData(int cfgId)
        {
            return ItemData_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的道具配置数据
        /// </summary>
        public static bool HasItemData(string cfgId)
        {
            return ItemData_Cache.ContainsKey(cfgId);
        }
        /// <summary>
        /// 货币配置配置缓存
        /// </summary>
        private static readonly Dictionary<string, MoneyBase> MoneyBase_Cache = [];
        /// <summary>
        /// 提前加载所有货币配置配置缓存
        /// </summary>
        public static void LoadMoneyBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_MoneyBase))
            {
                MoneyBase data = new(val.Value);
                data.InitData2();
                MoneyBase_Cache.Add(val.Key, data);
            }
        }
        /// <summary>
        /// 加载或获取已缓存的货币配置基础配置缓存
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
                catch (Exception)
                {
                    Log.PrintConfigError("背包 道具 及货币相关配置.xlsx表中的 cfg_MoneyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
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
                catch (Exception)
                {
                    Log.PrintConfigError("背包 道具 及货币相关配置.xlsx表中的 cfg_MoneyBase配置表中，不存在主键为<" + cfgId + ">的数据！");
                }
            }
            return data;
        }
        /// <summary>
        /// 获取加载的所有货币配置数据
        /// </summary>
        public static List<MoneyBase> GetAllMoneyBase()
        {
            return new List<MoneyBase>(MoneyBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的货币配置数据
        /// </summary>
        public static bool HasMoneyBase(int cfgId)
        {
            return MoneyBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的货币配置数据
        /// </summary>
        public static bool HasMoneyBase(string cfgId)
        {
            return MoneyBase_Cache.ContainsKey(cfgId);
        }
        #endregion

        #region 错误码
        /// <summary>
        /// 错误码配置缓存
        /// </summary>
        private static readonly Dictionary<string, ErrorBase> ErrorBase_Cache = [];
        /// <summary>
        /// 提前加载所有错误码配置缓存
        /// </summary>
        public static void LoadErrorBase()
        {
            foreach (var val in ConfigLoadSystem.GetCfg(ConfigConstant.Config_ErrorBase))
            {
                ErrorBase data = new(val.Value);
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
                catch (Exception)
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
                catch (Exception)
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
            return new List<ErrorBase>(ErrorBase_Cache.Values);
        }
        /// <summary>
        /// 检查是否存在指定ID的错误码数据
        /// </summary>
        public static bool HasErrorBase(int cfgId)
        {
            return ErrorBase_Cache.ContainsKey("" + cfgId);
        }
        /// <summary>
        /// 检查是否存在指定ID的错误码数据
        /// </summary>
        public static bool HasErrorBase(string cfgId)
        {
            return ErrorBase_Cache.ContainsKey(cfgId);
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
            Archival_Cache.Clear();
            ArchivalItem_Cache.Clear();
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
            AnimaUnit_Cache.Clear();
            AnimaBuild_Cache.Clear();
            AnimaTower_Cache.Clear();
            AnimaWeapon_Cache.Clear();
            AnimaWorker_Cache.Clear();
            AnimaExplode_Cache.Clear();
            AnimaUnit2_Cache.Clear();
            AnimaBuild2_Cache.Clear();
            AnimaTower2_Cache.Clear();
            AnimaWorker2_Cache.Clear();
            AnimaWeapon2_Cache.Clear();
            AnimaExplode2_Cache.Clear();
            SequenceMapBase_Cache.Clear();
            SpeciallyEffect_Cache.Clear();
            ObjectEffectImage_Cache.Clear();
            GenerateFixedMap_Cache.Clear();
            MapFixedSet_Cache.Clear();
            MapFixedMaterial_Cache.Clear();
            MapPassType_Cache.Clear();
            MapEdge_Cache.Clear();
            MapWallShadow_Cache.Clear();
            MapMassif_Cache.Clear();
            MapImageLayer_Cache.Clear();
            MapMaterial_Cache.Clear();
            GenerateBottomMap_Cache.Clear();
            MapExtraDraw_Cache.Clear();
            GenerateBigStruct_Cache.Clear();
            MapDecorate_Cache.Clear();
            BigMapBase_Cache.Clear();
            BigMapMaterial_Cache.Clear();
            BigMapBigCell_Cache.Clear();
            BigMapCellLogic_Cache.Clear();
            BigMapEvent_Cache.Clear();
            CopyBrush_Cache.Clear();
            BrushPoint_Cache.Clear();
            WaveBase_Cache.Clear();
            UnitGroupData_Cache.Clear();
            UnitGroupType_Cache.Clear();
            ChapterBase_Cache.Clear();
            ChapterCopyBase_Cache.Clear();
            CopyBuildLimit_Cache.Clear();
            ChapterCopyUI_Cache.Clear();
            BackgroundMusic_Cache.Clear();
            UISoundSfx_Cache.Clear();
            SoundSfx_Cache.Clear();
            BulletData_Cache.Clear();
            BulletLogic_Cache.Clear();
            LaserBulletLogic_Cache.Clear();
            ExplodeData_Cache.Clear();
            ExplodeHarm_Cache.Clear();
            UnitData_Cache.Clear();
            UnitLogic_Cache.Clear();
            BaseObjectShow_Cache.Clear();
            ObjectBottomBar_Cache.Clear();
            ObjectSideBar_Cache.Clear();
            BaseObjectData_Cache.Clear();
            BuildData_Cache.Clear();
            WorkerData_Cache.Clear();
            WeaponData_Cache.Clear();
            WeaponData2_Cache.Clear();
            WreckAge_Cache.Clear();
            BuffTag_Cache.Clear();
            BuffData_Cache.Clear();
            AttrEvent_Cache.Clear();
            GlobalAttrEvent_Cache.Clear();
            GlobalAttributeBase_Cache.Clear();
            GlobalAttrTem_Cache.Clear();
            GlobalAttrData_Cache.Clear();
            GlobalAttrMod_Cache.Clear();
            AttributeBase_Cache.Clear();
            AttrCalculate_Cache.Clear();
            AttrDependency_Cache.Clear();
            AttributeTemplate_Cache.Clear();
            AttributeData_Cache.Clear();
            AttrModifier_Cache.Clear();
            MapBuildLable_Cache.Clear();
            MapBuildItem_Cache.Clear();
            BuildRule_Cache.Clear();
            CampBase_Cache.Clear();
            GameDiffBase_Cache.Clear();
            BagData_Cache.Clear();
            ItemData_Cache.Clear();
            MoneyBase_Cache.Clear();
            ErrorBase_Cache.Clear();
        }

    }
}