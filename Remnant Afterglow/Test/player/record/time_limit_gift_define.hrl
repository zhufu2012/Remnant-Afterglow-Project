-ifndef(time_limit_gift_define_hrl).
-define(time_limit_gift_define_hrl, 1).

-define(TimeLimitType_Level, 1).            % 等级
-define(TimeLimitType_FuncOpen, 2).            % 功能开放
-define(TimeLimitType_ServerTime, 3).        % 开服天数
-define(TimeLimitType_TaskReceive, 4).        % 接取任务
-define(TimeLimitType_RuneHole, 5).            % 开启龙印孔
-define(TimeLimitType_GetMount, 6).            % 获得坐骑
-define(TimeLimitType_GetWing, 7).            % 获得翅膀
-define(TimeLimitType_GetPet, 8).            % 获得魔宠
-define(TimeLimitType_GetGD, 9).            % 获得龙神
-define(TimeLimitType_GetHoly, 10).            % 获得圣物
-define(TimeLimitType_GetRing, 11).            % 获得婚戒
-define(TimeLimitType_EqSynFailR2, 12).        % 未使用挽回石，装备合成到红2失败X次
-define(TimeLimitType_EqSynFailR3, 13).        % 未使用挽回石，装备合成到红3失败X次
-define(TimeLimitType_EqAdd, 14).            % X件装备追加等级达到Y级
-define(TimeLimitType_EqGem, 15).            % X个宝石等级达到Y级
-define(TimeLimitType_AllEqRefine, 16).        % 装备洗炼获得X个Y品质的属性时
-define(TimeLimitType_MountLv, 17).            % X个坐骑达到Y级
-define(TimeLimitType_WingLv, 18).            % X个翅膀达到Y级
-define(TimeLimitType_PetLv, 19).            % X个魔宠达到Y级
-define(TimeLimitType_GDStair, 20).            % X个龙神达到Y阶
-define(TimeLimitType_HolyLv, 21).            % X个圣物达到Y级
-define(TimeLimitType_RingLv, 22).            % X个婚戒达到Y级
-define(TimeLimitType_EqSuit, 23).            % 打造X件Y阶Z类型的W套装
-define(TimeLimitType_YLSkillTBoxOpen, 24).    % 解锁第X个翼灵打造技能孔
-define(TimeLimitType_SLSkillTBoxOpen, 25).    % 解锁第X个兽灵打造技能孔
-define(TimeLimitType_RuneCrystal, 26).        % 龙印结晶数量达到X个
-define(TimeLimitType_SoulCrystal, 27).        % 神魂结晶数量达到X个
-define(TimeLimitType_ItemShopBuy1, 28).    % 在绑钻商店和钻石商店中购买恶魔广场通行证X个
-define(TimeLimitType_ItemShopBuy2, 29).    % 在绑钻商店和钻石商店中购买个人BOSS挑战券X个
-define(TimeLimitType_ItemShopBuy3, 30).    % 在绑钻商店和钻石商店中购买扫荡卷轴X个
-define(TimeLimitType_ItemShopBuy4, 31).    % 在绑钻商店和钻石商店中购买5小时离线卡X个
-define(TimeLimitType_MountAwaken, 32).     % X个坐骑觉醒到Y级
-define(TimeLimitType_PetAwaken, 33).       % X个魔宠觉醒到Y级
-define(TimeLimitType_WingAwaken, 34).      % X个翅膀觉醒到Y级
-define(TimeLimitType_MountEqInt, 35).      % 装备了X个Y级的坐骑装备
-define(TimeLimitType_PetEqInt, 36).        % 装备了X个Y级的魔宠装备
-define(TimeLimitType_WingEqInt, 37).       % 装备了X个Y级的翅膀装备
-define(TimeLimitType_MountSublimate, 38).  % X个坐骑炼魂到Y级
-define(TimeLimitType_PetSublimate, 39).    % X个魔宠炼魂到Y级
-define(TimeLimitType_WingSublimate, 40).   % X个翅膀炼魂到Y级
-define(TimeLimitType_GetWeapon, 41).       % 获得神兵
-define(TimeLimitType_WeaponSoulLv, 42).    % 神兵器灵等级
-define(TimeLimitType_OrnamentEq1, 43).     % 穿戴X件Y品质及以上的海神装备
-define(TimeLimitType_OrnamentEq2, 44).     % 穿戴X件强化到Y级及以上的海神装备
-define(TimeLimitType_Bloodline, 45).       % 激活指定血脉
-define(TimeLimitType_TaskFinish, 46).        % 完成任务
-define(TimeLimitType_MainlineCopyMapPass, 47).        % 通关主线副本
-define(TimeLimitType_ChangeRole, 48).        % 完成转职
-define(TimeLimitType_Reincarnate, 49).        % 完成转生
-define(TimeLimitType_RoleCreate, 50).        % 激活第N职业
-define(TimeLimitType_EliteDungeonStar, 51).        % 精英副本X章达到X星
-define(TimeLimitType_DungeonActiveExtendPass, 52).        % 材料副本X 3星通关
-define(TimeLimitType_SetTime, 53).        % 指定时间
-define(TimeLimitType_ServerTimeDuring, 54).    % 开服第X天N时间点-第Y天23:59之间
-define(TimeLimitType_ContinuesRecharge, 55).        % 完成续充
-define(TimeLimitType_SeverIDRange, 56).        % 服务器区服段
-define(TimeLimitType_CareerTowerMain, 57).        % 英雄塔层数
-define(TimeLimitType_PetStar, 58).        % 获得X星英雄
-define(TimeLimitType_PetDrawnNormal, 59).        % 英雄召唤X次
-define(TimeLimitType_PetDrawnHigher, 60).        % 命运召唤X次
-define(TimeLimitType_PetStarNum, 61).        % 获得X个Y星英雄
-define(TimeLimitType_PetTypeRareNum, 62).        % 获得X个Y阵营Z品质英雄
-define(TimeLimitType_PetLevel, 63).        % 英雄达到X级
-define(TimeLimitType_PetWashAptitude, 64).        % 英雄洗练资质达到X
-define(TimeLimitType_PetEqWearNum, 65).        % 英雄装备数量达到X
-define(TimeLimitType_PetMasterLv, 66).        % 英雄大师达到X
-define(TimeLimitType_SynEq, 67).        % 合成X阶Y品质Z星装备
-define(TimeLimitType_WearEq, 68).        % 穿戴X阶Y品质Z星装备
-define(TimeLimitType_EqIntTotalLv, 69).        % 装备强化总等级X
-define(TimeLimitType_GemTotalLv, 70).        % 宝石强化总等级X
-define(TimeLimitType_GemXunBao, 71).        % 宝石寻宝X次
-define(TimeLimitType_SuperTower, 72).        % 黄金魔塔
-define(TimeLimitType_PantheonKillNum, 73).        % 累积击杀黄金boss次数
-define(TimeLimitType_PantheonXunBao, 74).        % 黄金寻宝X次
-define(TimeLimitType_BoneYardTimes, 75).        % 参与埋骨之地X次
-define(TimeLimitType_BattleField, 76).        % 参与波塞冬宝藏X次
-define(TimeLimitType_FuWenXunBao, 77).        % 符文寻宝X次
-define(TimeLimitType_SoulStoneXunBao, 78).        %% 魂石寻宝x次
-define(TimeLimitType_EquipPetEqNum, 79).        %% 穿戴X件幻彩英雄装备
-define(TimeLimitType_MountEqQualityNum, 80).        %% 穿戴X件Y品质及以上的坐骑装备
-define(TimeLimitType_MountEqStarNum, 81).        %% 穿戴X件Y星及以上的坐骑装备
-define(TimeLimitType_CardXunBao, 82).        %% 卡片寻宝x次
-define(TimeLimitType_DayPetDrawnNormal, 83).        %%每日英雄召唤次数
-define(TimeLimitType_DayPetDrawnHigher, 84).        %%每日命运召唤次数
-define(TimeLimitType_DayGemXunbao, 85).                %%每日装备寻宝次数
-define(TimeLimitType_DayCardXunBao, 86).        %%每日卡片寻宝次数
-define(TimeLimitType_DayPantheonXunBao, 87).        %%每日黄金寻宝次数
-define(TimeLimitType_DayFuWenXunBao, 88).            %%每日符文寻宝次数
-define(TimeLimitType_DaySoulStoneXunBao, 89).        %%每日魂石寻宝次数
-define(TimeLimitType_LevelSealOpen, 90).        %% 触发本服XX恶魔封印，参数1=ID【LevelSeal_1_等级封印】
-define(TimeLimitType_HasMarry, 91).        %% 结婚成功
-define(TimeLimitType_EquipBlessBreakCount, 92). %% 玩家穿戴X件N阶及以上 攻击/防御/饰品祝福装备-祝福注释-这里得问清楚，品质是否向下兼容 还有参数要求得有是哪种祝福装备
-define(TimeLimitType_PetIllusion, 93).        %% 激活幻化
-define(TimeLimitType_ClusterReset, 94).        %% 联服重组X天内，且等级小于等于联服世界等级Y级，且单服等级排行榜在Z名以前【含该名次】  每日重置检查
-define(TimeLimitType_RecentRechargeLT, 97). %% 充值小于XX绿钻触发，参数1=具体绿钻，参数2=统计天数，参数3/4=0



%%每日重置 限时特惠弹窗类型列表(0点重置),对应log_times_define 中的 LogTypeDailyResetList
-define(TimeLimitTypeDailyResetList, [?TimeLimitType_DayPetDrawnNormal, ?TimeLimitType_DayPetDrawnHigher, ?TimeLimitType_DayGemXunbao,
	?TimeLimitType_DayCardXunBao, ?TimeLimitType_DayPantheonXunBao, ?TimeLimitType_DayFuWenXunBao, ?TimeLimitType_DaySoulStoneXunBao,
	?TimeLimitType_ClusterReset]).






-endif.