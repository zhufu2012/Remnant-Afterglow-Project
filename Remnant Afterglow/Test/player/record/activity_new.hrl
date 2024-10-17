%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 19. 一月 2020 20:38
%%%-------------------------------------------------------------------
-author("suw").

-define(TableActivity, db_activity).
-define(TableActivityPlayer, db_activity_player).
-define(ETS_ActivityNewCache, ets_activityNewCache).
-define(ETS_PlayerActivityNewCache, ets_playerActivityNewCache). %% 玩家个人版活动，ets里只有非过期数据

-record(activity_new, {
	player_id = 0,          %% 玩家个人版活动有效
	id = 0,                 %% 活动入口ID  TODO 全服公用活动的索引
	key = {0, 0},           %% {玩家id，活动入口ID} TODO 玩家个人版活动的索引
	ref_id = 0,             %% 引用ID
	type = 0,               %% 活动类型
	pid = 0,                %% 进程ID
	parent_pid = 0,         %% 父进程ID
	group_id = 0,           %% 组ID
	group_index = 0,        %% 分组顺序
	team_type = 0,          %% 活动分组
	show_start = 0,         %% 图标开始显示时间
	show_end = 0,           %% 图标结束显示时间
	start_time = 0,         %% 开始时间
	end_time = 0,           %% 结束时间
	world_lv = 0,           %% 活动加载时的世界等级 todo 注意如果活动结束后要给玩家补发奖励，需要在玩家参与活动时给玩家记录上世界等级，在补发奖励时用于获取活动ID
	related_ac = 0         %% 关联活动ID
}).

%% 达成条件 默认为值相加
-define(SalesActivity_Level, 1).        %% 等级
-define(SalesActivity_Recharge_Total, 2).   %% 累积充值
-define(SalesActivity_SpentGold, 3).    %% 消耗元宝
-define(SalesActivity_Recharge_single, 4).  %% 单次充值
-define(SalesActivity_JoinTimes_Arena, 5).  %% 参与次数 竞技场
-define(SalesActivity_JoinTimes_YanMo, 9).  %% 参与次数 炎魔试炼
-define(SalesActivity_JoinTimes_Excellence, 13).    %% 参与次数  精英副本
-define(SalesActivity_VipLevel, 14).        %%  VIP等级
-define(SalesActivity_LoginRecharge, 18).       %% 连续充值
-define(SalesActivity_loginDays, 19).           %% 连续登陆
-define(SalesActivity_NormalMain, 20).          %% 参与次数 剧情副本 主线副本
-define(SalesActivity_Battlefield, 21).         %% 参与次数 三界战场
-define(SalesActivity_WildBoss, 22).            %% 参与次数 诛仙
-define(SalesActivity_RankWheel, 23).          %% 排行榜转盘抽奖次数
-define(SalesActivity_Manor, 24).               %% 参与次数 领地战
-define(SalesActivity_CampFire, 25).            %% 参与次数 晚宴次数
-define(SalesActivity_CampTreat, 26).           %% 参与次数 请客次数
-define(SalesActivity_CampPacket, 27).          %% 参与次数 开红包次数
-define(SalesActivity_GoldMount, 28).           %% 元宝抽坐骑
-define(SalesActivity_FieldBoss, 29).           %% 野外Boss次数
-define(SalesActivity_FieldTime, 30).           %% 野外挂机小时数
-define(SalesActivity_DungeonGuild, 31).        %% 参与次数 仙盟副本次数
-define(SalesActivity_ActiveValue, 32).         %% 日常活跃度
-define(SalesActivity_OnlineTime, 33).          %% 在线时长
-define(SalesActivity_UseItem, 34).             %% 使用物品次数
-define(SalesActivity_Melee, 35).               %% 麒麟洞参与次数
-define(SalesActivity_convoyTimes, 36).         %% 运镖次数
-define(SalesActivity_ThunderFort, 37).         %% 雷霆要塞次数
-define(SalesActivity_DrawHLWingsTimes, 38).    %% 高级神翼元宝抽卡次数
-define(SalesActivity_DrawLegendWinsTimes, 39). %% 传说神翼元宝抽卡次数
-define(SalesActivity_ShareServerFightRing, 40).%% 跨服比武参与次数
-define(SalesActivity_ThreeHeaven1, 41).        %% 41为天宫试炼次数
-define(SalesActivity_ThreeHeaven2, 42).        %% 42为天宫试炼开丹炉个数
-define(SalesActivity_DungeonHoly, 43).            %% 43为圣物副本参加次数
-define(SalesActivity_CoupleFight, 44).            %% 44仙侣2V2次数
-define(SalesActivity_ActiveExtend, 45).        %% 45为挑战副本次数
-define(SalesActivity_RechargeGold, 46).        %% 非绑元宝
-define(SalesActivity_Lottery, 47).             %% 庆典抽奖次数
-define(SalesActivity_LotteryEx, 48).           %% 资源盛典抽奖
-define(SalesActivity_ActiveScore, 49).         %% 活动积分
-define(SalesActivity_KillDemons, 50).          %% 击杀天魔数量
-define(SalesActivity_Roulette3, 52).           %% 聚宝盆抽奖次数
-define(SalesActivity_Roulette4, 53).           %% 迷宫抽奖次数
-define(SalesActivity_DartsNum, 54).            %% 飞镖次数
-define(SalesActivity_DemonsNum, 55).           %% 参与恶魔入侵次数
-define(SalesActivity_PantheonNum, 56).         %% 神魔战场次数
-define(SalesActivity_Couple, 57).                %% 情侣试炼次数
-define(SalesActivity_WorldBoss, 58).           %% 世界boss
-define(SalesActivity_DungeonWing, 61).         %% 翅膀副本参加次数
-define(SalesActivity_BountyTask, 62).          %% 赏金任务完成次数
-define(SalesActivity_GuildTask, 63).           %% 战盟任务完成次数
-define(SalesActivity_DungeonPet, 64).          %% 宠物副本参加次数
-define(SalesActivity_DungeonMount, 65).        %% 坐骑副本参加次数
-define(SalesActivity_DungeonDragonConsum, 66). %% 龙王宝库参加次数

-define(SalesActivity_Attend_PreDeposits, 69).      %% 参与矮人宝藏/精灵宝藏次数（结算）
-define(SalesActivity_DungeonGDCons, 70).       %% 龙神秘典参加次数
-define(SalesActivity_RuneTower, 71).           %% 龙神塔参与次数
-define(SalesActivity_Attend_DemonsVip, 72).      %% 参与恶魔巢穴次数（击杀boss并且获得掉落归属权的次数）
-define(SalesActivity_Attend_PersonalBoss, 73).      %% 参与个人BOSS次数（结算）
-define(SalesActivity_Attend_DemonsLimit, 74).      %% 参与诅咒之地次数（进入地图次数）
-define(SalesActivity_Attend_Pantheon, 75).      %% 参与神魔战场次数（消耗疲劳） TODO
-define(SalesActivity_Attend_GuildGuard, 76).      %% 参与守卫战盟次数（结算）
-define(SalesActivity_Attend_1v1, 77).             %% 参与王者1V1次数（结算）
-define(SalesActivity_FlowerGift, 78).          %% 献花次数
-define(SalesActivity_BattleValue, 79).      %% 战斗力达到指定值
-define(SalesActivity_FriendNum, 80).      %% 添加好友个数
-define(SalesActivity_Intimacy1, 81).      %% 任意一个好友亲密度达到1级
-define(SalesActivity_Intimacy2, 82).      %% 任意一个好友亲密度达到2级
-define(SalesActivity_Intimacy3, 83).      %% 任意一个好友亲密度达到3级
-define(SalesActivity_EngageTimes, 84).      %% 订婚次数
-define(SalesActivity_BuyCoupleMouthCardTimes, 85).      %% 为对方购买情侣月卡次数
-define(SalesActivity_RingLvUp1, 86).      %% 婚戒系统：提升纯爱无暇（情侣试炼激活）到20级｜信物id  101
-define(SalesActivity_LoveTask1, 87).      %% 许愿池边许心愿（约会中的一步）
-define(SalesActivity_LoveTask2, 88).      %% 玫瑰园中结誓言（约会中的一步）
-define(SalesActivity_LoveTask3, 89).      %% 爱神岛上永相随（约会中的一步）
-define(SalesActivity_RingLvUp2, 90).      %% 婚戒系统：提升一生一世（结婚激活）到50级｜信物id 104
-define(SalesActivity_WeddingHigh, 91).      %% 举办高级婚礼（和豪华婚礼区别）
-define(SalesActivity_RingLvUp3, 92).      %% 婚戒系统：提升清水出芙蓉（豪华婚礼2激活）到50级｜信物id 111
-define(SalesActivity_Guild_CreateGuild, 93).    %% 创建战盟
-define(SalesActivity_Guild_SuperElder1, 94).    %% 任命执法者
-define(SalesActivity_Guild_ViceChairman2, 95).    %% 任命副盟主
-define(SalesActivity_Guild_MemberCount30, 96).    %% 战盟人数30
-define(SalesActivity_Guild_GuildLv2, 97).        %% 战盟等级2
-define(SalesActivity_Guild_GuildLv3, 98).        %% 战盟等级3

-define(SalesActivity_GuildCraft1, 106).        %% 领地战S第一战盟的盟主
-define(SalesActivity_GuildCraft2, 107).        %% 领地战S第一战盟的执法者和副盟主
-define(SalesActivity_GuildCraft3, 108).        %% 领地战S第一战盟的成员
-define(SalesActivity_GuildCraft4, 109).        %% 参与领地战
-define(SalesActivity_Attend_XunBaoEquip, 110). %% 装备寻宝次数
-define(SalesActivity_Attend_XunBaoRune, 111).  %% 龙印寻宝次数
-define(SalesActivity_Attend_XunBaoMount, 112). %% 坐骑寻宝次数
-define(SalesActivity_Attend_XunBaoPet, 113).   %% 魔宠寻宝次数
-define(SalesActivity_Attend_XunBaoWing, 114).   %% 翅膀寻宝次数
-define(SalesActivity_FriendsImc2, 115).        %% 好感度达到2的好友数量
-define(SalesActivity_FriendsImc3, 116).        %% 好感度达到3的好友数量
-define(SalesActivity_FriendsImc4, 117).        %% 好感度达到4的好友数量
-define(SalesActivity_GuildCraft5, 118).   %% 参与战盟争霸S级联赛的其它战盟盟主
-define(SalesActivity_DemonCrusade, 119).   %% 恶魔讨伐令
-define(SalesActivity_Attend_XoRoom, 121).      %% XO房间次数（结算）
-define(SalesActivity_FireWorks, 122).      %% 烟花次数
-define(SalesActivity_DemonsNumType2, 123).      %% 恶魔深渊计数（恶魔深渊中消耗疲劳数）
-define(SalesActivity_DungeonOrnament, 124).    %% 深渊之海次数
-define(SalesActivity_XunBaoExt, 125).          %% 巅峰寻宝次数
-define(SalesActivity_DungeonGDragon, 126).     %% 龙神副本参加次数
-define(SalesActivity_Roulette7, 127).          %% 探宝矩阵抽奖次数（矩阵抽奖）
-define(SalesActivity_ResPoint, 128).           %% 累计获得资源点
-define(SalesActivity_PantheonCluster, 129).    %% 神魔幻域boss击杀次数
-define(SalesActivity_NewFireWorks, 130).       %% 新烟花盛典次数
-define(SalesActivity_Roulette8, 136).          %% 云购抽奖次数
-define(SalesActivity_Dungeons, 137).          %% 参与恶魔广场次数
-define(SalesActivity_CampFire1, 138).          %% 参与战盟篝火次数
-define(SalesActivity_Recharge_NewTotal, 139).   %% 累积充值(与枚举2独立计数)
-define(SalesActivity_NewSpentGold, 140).    %% 消耗元宝(与枚举3独立计数)

-define(SalesActivity_McShipGrade, 155).           %% 参与商船护送次数
-define(SalesActivity_McShipPlunder, 156).         %% 商船掠夺次数
-define(SalesActivity_Goblin, 157).                %% 参与地精宝库次数
-define(SalesActivity_PantheonBigGather, 158).     %% 神魔战场小采集次数
-define(SalesActivity_PantheonSmallGather, 159).   %% 神魔战场大采集次数
-define(SalesActivity_Vitality, 160).              %% 日常活跃度，参数1为活跃度值
-define(SalesActivity_MidFeteGod, 161).            %% 战盟祭祀（高级）次数
-define(SalesActivity_ExpBless, 162).              %% 经验祈福次数
-define(SalesActivity_GuildBoss, 163).             %% 战盟BOSS次数
-define(SalesActivity_RedMcShipGrade, 164).        %% 护送红色品质商船次数
-define(SalesActivity_QuickHang_170, 170).          %% 快速讨伐次数
-define(SalesActivity_NewBountyTask_171, 171).          %% SSS赏金任务次数
-define(SalesActivity_LowFeteGod_172, 172).          %% 公会普通捐献次数
-define(SalesActivity_GivePiece_173, 173).          %% 捐献卡片次数
-define(SalesActivity_LowerDrink_174, 174).          %% 公会篝火普通喝酒次数
-define(SalesActivity_SeniorDrink_175, 175).          %% 公会篝火龙火辣酒次数
-define(SalesActivity_HelpCount_176, 176).          %% 协助次数
-define(SalesActivity_MaterialDungeonEnter_177, 177).          %% 材料副本参与次数
-define(SalesActivity_GetGold_178, 178).          %% 累计获得钻石数
-define(SalesActivity_AllFeteGod_179, 179).          %% 公会捐献次数（普通+高级）
-define(SalesActivity_GetPiece_180, 180).          %% 收到卡片分享次数
-define(SalesActivity_SkillTotalLv_181, 181).          %% 技能总等级（三角色之和）
-define(SalesActivity_EquipIntensifyTotalLv_182, 182).          %% 装备强化总等级（三角色所有装备强化等级之和）
-define(SalesActivity_BountyTaskCompleteSS_183, 183).          %% SS赏金任务完成次数
-define(SalesActivity_CardEquipNumOrange_184, 184).          %% 已装配橙色卡片数量（三角色装配橙卡数量之和）
-define(SalesActivity_ArenaRank_185, 185).          %% 竞技场名次
-define(SalesActivity_PersonalBoss_186, 186).          %% 个人Boss
-define(SalesActivity_GemTotalLv_187, 187).          %% 宝石镶嵌总等级（三角色所有宝石）
-define(SalesActivity_SkillBreakLvTotal_188, 188).          %% 技能的总突破等级（三角色所有宝石）
-define(SalesActivity_SkillAwakenLvTotal_189, 189).          %% 技能的总觉醒等级（三角色所有宝石）

-define(SalesActivity_GuildCraft6, 199).        %% 领地战S联赛的其他公会的的成员
-define(SalesActivity_GuildCraft7, 200).        %% 领地战S联赛的其他公会的执法者和副会长

-define(SalesActivity_WingAddLv, 201).          %% 翅膀升级次数
-define(SalesActivity_WingAddStar, 202).        %% 翅膀升星次数
-define(SalesActivity_WingAwake, 203).          %% 翅膀觉醒次数
-define(SalesActivity_WingSublimate, 204).      %% 翅膀炼魂次数
-define(SalesActivity_YLPill, 205).             %% 翼灵磕丹次数
-define(SalesActivity_YLAddLv, 206).            %% 翼灵升级次数
-define(SalesActivity_FWingAddLv, 207).         %% 飞翼升级次数
-define(SalesActivity_MountAddLv, 208).         %% 坐骑升级次数
-define(SalesActivity_MountAddStar, 209).       %% 坐骑升星次数
-define(SalesActivity_MountAwake, 210).         %% 坐骑觉醒次数
-define(SalesActivity_MountSublimate, 211).     %% 坐骑炼魂次数
-define(SalesActivity_SLPill, 212).             %% 兽灵磕丹次数
-define(SalesActivity_SLAddLv, 213).            %% 兽灵升级次数
-define(SalesActivity_PetAddLv, 214).           %% 宠物升级次数
-define(SalesActivity_PetAddStar, 215).         %% 宠物升星次数
-define(SalesActivity_PetAwake, 216).           %% 宠物觉醒次数
-define(SalesActivity_PetSublimate, 217).       %% 宠物炼魂次数
-define(SalesActivity_MLPill, 218).             %% 魔灵磕丹次数
-define(SalesActivity_MLAddLv, 219).            %% 魔灵升级次数
-define(SalesActivity_EqInt, 220).              %% 装备强化次数
-define(SalesActivity_EqAdd, 221).              %% 装备追加次数
-define(SalesActivity_EqCast, 222).             %% 装备洗练次数
-define(SalesActivity_EqFade, 223).             %% 装备炼金次数

-define(SalesActivity_Attend_XunBaoCard, 251). %% 卡片寻宝次数
-define(SalesActivity_Attend_XunBaoGem, 252). %% 宝石寻宝次数

%% TODO 寻宝遗留
-define(SalesActivity_Attend_XunBaoExtreme, 253). %% 至尊寻宝次数
-define(SalesActivity_Attend_XunBaoShengWen, 254). %% 圣纹寻宝次数
-define(SalesActivity_Attend_XunBaoGodWing, 255). %% 神翼寻宝次数
-define(SalesActivity_Attend_XunBaoHolyEq, 256). %% 圣装寻宝次数
-define(SalesActivity_Attend_XunBaoAllHoly, 257). %% 神兵类寻宝次数(神兵，巅峰，至尊，圣装)
-define(SalesActivity_Attend_XunBaoAllRune, 258). %% 龙印类寻宝次数(龙印，神魂，圣纹)
-define(SalesActivity_Attend_XunBaoAllLook, 259). %% 外显类寻宝次数(坐骑，翅膀，魔宠，神翼)

-define(SalesActivity_Attend_XunBao, 260). %% 寻宝次数
-define(SalesActivity_GuildEnvelopGold, 261). %% 累计领取公会红包获得的钻石数
-define(SalesActivity_LuckyWheel, 262). %% 幸运转盘抽奖次数
-define(SalesActivity_Roulette, 263). %% 参与次数 转盘
-define(SalesActivity_DragonTreasure, 264). %% 天神秘宝抽奖次数
-define(SalesActivity_RuneXunBao, 265). %% 符文寻宝次数
-define(SalesActivity_CareerTowerMain, 266). %% 职业塔主塔层数
-define(SalesActivity_CareerTower1004, 267). %% 职业塔战士塔层数
-define(SalesActivity_CareerTower1005, 268). %% 职业塔法师塔层数
-define(SalesActivity_CareerTower1006, 269). %% 职业塔弓手塔层数
-define(SalesActivity_CareerTower1007, 270). %% 职业塔第四职业层数
-define(SalesActivity_CareerTowerAllLayer, 271). %% 职业塔所有层数总进度
-define(SalesActivity_LifelongPetSSR, 272). %% 终生获得SRR宠物次数
-define(SalesActivity_PetSSR, 273). %% 获得SRR宠物次数
-define(SalesActivity_PetDrawn, 274). %% 宠物抽奖次数
-define(SalesActivity_ExpeditionDominionBoss, 275). %% 攻城略地参与击败领地BOSS
-define(SalesActivity_ExpeditionFortressBoss, 276). %% 攻城略地参与击败要塞BOSS
-define(SalesActivity_ExpeditionStrongholdBoss, 277). %% 攻城略地参与击败堡垒BOSS
-define(SalesActivity_ExpeditionKillPlayer, 278). %% 攻城略地参与击败玩家
-define(SalesActivity_ExpeditionKillBoss, 279). %% 攻城略地参与击败BOSS
-define(SalesActivity_ExpeditionDemonKillBoss, 280). %% 英雄战纪参与击败BOSS
-define(SalesActivity_ExpeditionDemonKillPlayer, 281). %% 英雄战纪参与击败玩家
-define(SalesActivity_ExpeditionHuntTimes, 282). %% 远征猎魔次数
-define(SalesActivity_ExpeditionNobility, 283). %% 远征爵位达到
-define(SalesActivity_EqWear333, 284). %% 穿戴3阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear342, 285). %% 穿戴3阶红色2星{0}部位的装备
-define(SalesActivity_EqWear343, 286). %% 穿戴3阶红色3星{0}部位的装备
-define(SalesActivity_EqWear433, 287). %% 穿戴4阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear442, 288). %% 穿戴4阶红色2星{0}部位的装备
-define(SalesActivity_EqWear443, 289). %% 穿戴4阶红色3星{0}部位的装备
-define(SalesActivity_EqWear533, 290). %% 穿戴5阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear542, 291). %% 穿戴5阶红色2星{0}部位的装备
-define(SalesActivity_EqWear543, 292). %% 穿戴5阶红色3星{0}部位的装备
-define(SalesActivity_EqWear633, 293). %% 穿戴6阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear642, 294). %% 穿戴6阶红色2星{0}部位的装备
-define(SalesActivity_EqWear643, 295). %% 穿戴6阶红色3星{0}部位的装备
-define(SalesActivity_EqWear733, 296). %% 穿戴7阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear742, 297). %% 穿戴7阶红色2星{0}部位的装备
-define(SalesActivity_EqWear743, 298). %% 穿戴7阶红色3星{0}部位的装备
-define(SalesActivity_EqWear833, 299). %% 穿戴8阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear842, 300). %% 穿戴8阶红色2星{0}部位的装备
-define(SalesActivity_EqWear843, 301). %% 穿戴8阶红色3星{0}部位的装备
-define(SalesActivity_EqWear933, 302). %% 穿戴9阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear942, 303). %% 穿戴9阶红色2星{0}部位的装备
-define(SalesActivity_EqWear943, 304). %% 穿戴9阶红色3星{0}部位的装备
-define(SalesActivity_EqWear1033, 305). %% 穿戴10阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear1042, 306). %% 穿戴10阶红色2星{0}部位的装备
-define(SalesActivity_EqWear1043, 307). %% 穿戴10阶红色3星{0}部位的装备
-define(SalesActivity_EqWear1133, 308). %% 穿戴11阶橙色3星{0}部位的装备
-define(SalesActivity_EqWear1142, 309). %% 穿戴11阶红色2星{0}部位的装备
-define(SalesActivity_EqWear1143, 310). %% 穿戴11阶红色3星{0}部位的装备

-define(SalesActivity_PetTower, 311). %% 通关英雄塔{}层
-define(SalesActivity_FirstStarPet, 312). %% 首次获得{}星数英雄
-define(SalesActivity_PetNormalDrawn, 313). %% 英雄召唤{}次
-define(SalesActivity_PetHigherDrawn, 314). %% 命运召唤{}次
-define(SalesActivity_TotalPetGetStar6, 315). %% 累计获得{}位6星及以上的英雄
-define(SalesActivity_TotalPetGetStar7, 316). %% 累计获得{}位7星及以上的英雄
-define(SalesActivity_TotalPetGetStar8, 317). %% 累计获得{}位8星及以上的英雄
-define(SalesActivity_TotalPetGetStar9, 318). %% 累计获得{}位9星及以上的英雄
-define(SalesActivity_TotalPetGetStar10, 319). %% 累计获得{}位10星及以上的英雄
-define(SalesActivity_TotalPetGetStar11, 320). %% 累计获得{}位11星及以上的英雄
-define(SalesActivity_TotalPetGetStar12, 321). %% 累计获得{}位12星及以上的英雄
-define(SalesActivity_PetGetStar6, 322). %% 获得{}位6星及以上的英雄
-define(SalesActivity_PetGetStar7, 323). %% 获得{}位7星及以上的英雄
-define(SalesActivity_PetGetStar8, 324). %% 获得{}位8星及以上的英雄
-define(SalesActivity_PetGetStar9, 325). %% 获得{}位9星及以上的英雄
-define(SalesActivity_PetGetStar10, 326). %% 获得{}位10星及以上的英雄
-define(SalesActivity_PetGetStar11, 327). %% 获得{}位11星及以上的英雄
-define(SalesActivity_PetGetStar12, 328). %% 获得{}位12星及以上的英雄
-define(SalesActivity_PetType2SSR, 329). %% 获得{}审判联盟SSR品质以上的英雄
-define(SalesActivity_PetType3SSR, 330). %% 获得{}银色黎明SSR品质以上的英雄
-define(SalesActivity_PetType1SSR, 331). %% 获得{}暗影议会SSR品质以上的英雄
-define(SalesActivity_FirstPetLv, 332). %% 首次将英雄培养到{}等级
-define(SalesActivity_PetLv, 333). %% 拥有一位{}等级的英雄
-define(SalesActivity_FirstPetWashAptitude, 334). %% 首次将英雄资质评分提升到{}
-define(SalesActivity_PetWashAptitude, 335). %% 拥有一位{}评分的英雄
-define(SalesActivity_PetEqNum, 336). %% 穿戴{}件英雄装备
-define(SalesActivity_PetMasterLv, 337). %% 召唤大师达到{}

-define(SalesActivity_FirstGemLv, 338). %% 首次镶嵌{}级的宝石
-define(SalesActivity_FirstCoreGemLv, 339). %% 首次镶嵌{}级的核心宝石
-define(SalesActivity_NormalSuit3, 340). %% 铸造{}件的3阶普通套装
-define(SalesActivity_NormalSuit4, 341). %% 铸造{}件的4阶普通套装
-define(SalesActivity_NormalSuit5, 342). %% 铸造{}件的5阶普通套装
-define(SalesActivity_NormalSuit6, 343). %% 铸造{}件的6阶普通套装
-define(SalesActivity_NormalSuit7, 344). %% 铸造{}件的7阶普通套装
-define(SalesActivity_NormalSuit8, 345). %% 铸造{}件的8阶普通套装
-define(SalesActivity_NormalSuit9, 346). %% 铸造{}件的9阶普通套装
-define(SalesActivity_NormalSuit10, 347). %% 铸造{}件的10阶普通套装
-define(SalesActivity_NormalSuit11, 348). %% 铸造{}件的11阶普通套装
-define(SalesActivity_PerfectSuit3, 349). %% 铸造{}件的3阶完美套装
-define(SalesActivity_PerfectSuit4, 350). %% 铸造{}件的4阶完美套装
-define(SalesActivity_PerfectSuit5, 351). %% 铸造{}件的5阶完美套装
-define(SalesActivity_PerfectSuit6, 352). %% 铸造{}件的6阶完美套装
-define(SalesActivity_PerfectSuit7, 353). %% 铸造{}件的7阶完美套装
-define(SalesActivity_PerfectSuit8, 354). %% 铸造{}件的8阶完美套装
-define(SalesActivity_PerfectSuit9, 355). %% 铸造{}件的9阶完美套装
-define(SalesActivity_PerfectSuit10, 356). %% 铸造{}件的10阶完美套装
-define(SalesActivity_PerfectSuit11, 357). %% 铸造{}件的11阶完美套装
-define(SalesActivity_ShopBuyTimes, 358). %% 在商场购买{}次道具
-define(SalesActivity_TradingMarketBuyTimes, 359). %% 在交易行购买{}次道具
-define(SalesActivity_TradingMarketOnShellTimes, 360). %% 在交易行上架{}次道具
-define(SalesActivity_MysteryShopFreshTimes, 361). %% 宝藏集市刷新{}次
-define(SalesActivity_MysteryShopBuyTimes, 362). %% 宝藏集市购买{}次
-define(SalesActivity_TotalPetGetStar5, 363). %% 累计获得{}位5星及以上的英雄
-define(SalesActivity_PetGetStar5, 364). %% 获得{}位5星及以上的英雄
-define(SalesActivity_MainlineCopymapTimes, 365). %% 完成主线副本次数
-define(SalesActivity_DungeonWingConsumeEnergy, 366). %% 翅膀副本消耗能量
-define(SalesActivity_PantheonKillNum, 367). %% 击杀黄金BOSS次数
-define(SalesActivity_Attend_XunBaoPantheon, 368). %% 黄金寻宝次数
-define(SalesActivity_BoneYardJoinTimes, 370). %% 参与埋骨之地次数
-define(SalesActivity_ExpeditionConquerBpBuy, 371).%%购买远征征战令牌：目标=1；参数=0
-define(SalesActivity_ExpeditionHonorBpBuy, 372).%%购买远征荣誉证书：目标=1；参数=0
-define(SalesActivity_TitanActive, 373). %%激活第{0}赛季泰坦：目标=1；参数=远征赛季ID
-define(SalesActivity_TitanStarUp, 374).%%将第{1}赛季泰坦升星到{0}星：目标=星数；参数=远征赛季ID
-define(SalesActivity_ExpeditionConquerWall, 375).%%远征中攻下城墙{0}次：目标=次数；参数=0
-define(SalesActivity_ExpeditionConquerDarkCity, 376).%%远征中攻下黑暗王城{0}次：目标=次数；参数=0
-define(SalesActivity_ExpeditionChallengePlayer, 377).%%远征中挑战玩家{0}次：目标=次数；参数=0
-define(SalesActivity_ExpeditionGetRelicBox, 378).%%远征中获得遗迹宝箱{0}个：目标=次数；参数=0
-define(SalesActivity_ExpeditionStrongConquer, 379).%%远征强征{0}次：目标=次数；参数=0
-define(SalesActivity_ExpeditionConsumeHuntPower, 380).%%远征中消耗{0}点远征猎魔体力：目标=猎魔体力；参数=0
-define(SalesActivity_ExpeditionHuntLevel, 381).%%远征猎魔等级达到{0}级：目标=等级；参数=0
-define(SalesActivity_ExpeditionHuntRank, 382).%%远征猎魔排名达到第{0}名：目标=排名；参数=0
-define(SalesActivity_ExpeditionGetHonor, 383).%%获得{0}点远征功勋：目标=远征功勋点数；参数=0
-define(SalesActivity_ExpeditionTeamScore, 384).%%远征战队积分达到{0}：目标=战队积分；参数=0
-define(SalesActivity_ExpeditionJoinBattle, 385).%%参与远征作战{0}次：目标=作战次数；参数=0
-define(SalesActivity_ExpeditionHeroRecord, 386).%%远征中英雄战纪攻占{0}次：目标=次数；参数=0
-define(SalesActivity_King1v1WinTimes, 387).%%王者1V1中胜利{0}次：目标=次数；参数=0
-define(SalesActivity_King1v1ReachRank, 388).%%王者1V1中达到{0}段位：目标=段位（配置数值，显示段位名称）；参数=0
-define(SalesActivity_King1v1ReachFinal, 389).%%王者1V1中进入决赛：目标=1；参数=0
-define(SalesActivity_CupActive, 390).%% 激活奖杯{0}：目标=1；参数=王者1V1奖杯ID
-define(SalesActivity_CupGradeUp, 391).%%{1}奖杯提升到{0}品质：目标=奖杯品质（RareType[LMatch1v1CupGradeUp_1_奖杯升品]），转换成名称显示；参数=王者1V1奖杯ID
-define(SalesActivity_CupLevelUp, 392).%%{1}奖杯升级到{0}级：目标=等级；参数=王者1V1奖杯ID
-define(SalesActivity_King1v1BattleBpBuy, 393).%%购买王者1V1对战战令：目标=1；参数=0
-define(SalesActivity_King1v1RankBpBuy, 394).%%购买王者1V1段位战令：目标=1；参数=0
-define(SalesActivity_XunBaoSoulStone, 395).    %%魂石寻宝多少次
-define(SalesActivity_SpecialSuperBossKill, 396).    %% 击杀特殊场次超级boss
-define(SalesActivity_LavaFightTimes, 397).     %% 熔岩角斗场完成次数
-define(SalesActivity_BlzJoinTimes, 398).  %% 寒风森林参与次数
-define(SalesActivity_XunBaoShenWen, 399).  %% 神纹寻宝{0}次
-define(SalesActivity_EleCCurseConsume, 400).  %% 元素大陆消耗怒气值{0}点
-define(SalesActivity_UnknownDraw, 401).  %% 未知召唤{0}次
-define(SalesActivity_AcDay1, 402).  %% 活动开启后第几日登录
-define(SalesActivity_AcDay2, 403).  %% 活动开启后第几日及之后登录
-define(SalesActivity_EliteCopyMapPass, 404). %%精英副本第X章Y星，总星数 章节id
-define(SalesActivity_Exclusive_Recharge_Total, 405).   %% 第三方累积充值
-define(SalesActivity_Exclusive_Recharge_single, 406).  %% 第三方单次充值
-define(SalesActivity_Exclusive_LoginRecharge, 407).    %% 第三方连续充值

%% 以下条件用值替换
-define(ValueReplace, [?SalesActivity_VipLevel, ?SalesActivity_Level, ?SalesActivity_BattleValue, ?SalesActivity_FriendNum,
	?SalesActivity_FriendsImc2, ?SalesActivity_FriendsImc3, ?SalesActivity_FriendsImc4,
	?SalesActivity_SkillTotalLv_181, ?SalesActivity_EquipIntensifyTotalLv_182, ?SalesActivity_CardEquipNumOrange_184,
	?SalesActivity_ArenaRank_185, ?SalesActivity_GemTotalLv_187, ?SalesActivity_SkillBreakLvTotal_188, ?SalesActivity_SkillAwakenLvTotal_189,
	?SalesActivity_CareerTowerMain, ?SalesActivity_CareerTower1004, ?SalesActivity_CareerTower1005, ?SalesActivity_CareerTower1006, ?SalesActivity_CareerTower1007,
	?SalesActivity_CareerTowerAllLayer, ?SalesActivity_LifelongPetSSR, ?SalesActivity_ExpeditionNobility, ?SalesActivity_PetWashAptitude,
	?SalesActivity_FirstStarPet, ?SalesActivity_FirstPetLv, ?SalesActivity_FirstPetWashAptitude, ?SalesActivity_FirstGemLv, ?SalesActivity_FirstCoreGemLv,
	?SalesActivity_TotalPetGetStar5, ?SalesActivity_TotalPetGetStar6, ?SalesActivity_TotalPetGetStar7, ?SalesActivity_TotalPetGetStar8,
	?SalesActivity_TotalPetGetStar9, ?SalesActivity_TotalPetGetStar10, ?SalesActivity_TotalPetGetStar11, ?SalesActivity_TotalPetGetStar12,
	?SalesActivity_PetLv, ?SalesActivity_PetTower, ?SalesActivity_PetMasterLv, ?SalesActivity_NormalSuit3, ?SalesActivity_NormalSuit4, ?SalesActivity_NormalSuit5,
	?SalesActivity_NormalSuit6, ?SalesActivity_NormalSuit7, ?SalesActivity_NormalSuit8, ?SalesActivity_NormalSuit9, ?SalesActivity_NormalSuit10, ?SalesActivity_NormalSuit11,
	?SalesActivity_PerfectSuit3, ?SalesActivity_PerfectSuit4, ?SalesActivity_PerfectSuit5, ?SalesActivity_PerfectSuit6, ?SalesActivity_PerfectSuit7,
	?SalesActivity_PerfectSuit8, ?SalesActivity_PerfectSuit9, ?SalesActivity_PerfectSuit10, ?SalesActivity_PerfectSuit11, ?SalesActivity_TitanStarUp,
	?SalesActivity_ExpeditionHuntLevel, ?SalesActivity_ExpeditionHuntRank, ?SalesActivity_ExpeditionTeamScore, ?SalesActivity_King1v1ReachRank,
	?SalesActivity_CupGradeUp, ?SalesActivity_CupLevelUp
]).


%% 以下条件为布尔类型（达成则值置1）
-define(ValueBool, [?SalesActivity_Guild_CreateGuild, ?SalesActivity_Guild_SuperElder1, ?SalesActivity_Guild_ViceChairman2, ?SalesActivity_Guild_MemberCount30,
	?SalesActivity_Guild_GuildLv2, ?SalesActivity_Guild_GuildLv3, ?SalesActivity_EqWear333, ?SalesActivity_EqWear342,
	?SalesActivity_EqWear343, ?SalesActivity_EqWear433, ?SalesActivity_EqWear442, ?SalesActivity_EqWear443, ?SalesActivity_EqWear533,
	?SalesActivity_EqWear542, ?SalesActivity_EqWear543, ?SalesActivity_EqWear633, ?SalesActivity_EqWear642, ?SalesActivity_EqWear643,
	?SalesActivity_EqWear733, ?SalesActivity_EqWear742, ?SalesActivity_EqWear743, ?SalesActivity_EqWear833, ?SalesActivity_EqWear842,
	?SalesActivity_EqWear843, ?SalesActivity_EqWear933, ?SalesActivity_EqWear942, ?SalesActivity_EqWear943, ?SalesActivity_EqWear1033,
	?SalesActivity_EqWear1042, ?SalesActivity_EqWear1043, ?SalesActivity_EqWear1133, ?SalesActivity_EqWear1142, ?SalesActivity_EqWear1143
]).

%% 活动类型
-define(ACTIVITY_TYPE_Achievement, 1).           %% 达成类
-define(ACTIVITY_TYPE_DragonHonor, 2).           %% 公会骑士团
-define(ACTIVITY_TYPE_Questionnaire, 3).         %% 问卷调查
-define(ACTIVITY_TYPE_PromotionPresentGift, 4).  %% 荣耀献礼
-define(ACTIVITY_TYPE_TimeLimitGiftPlus, 5).     %% 限时特惠弹窗版
-define(ACTIVITY_TYPE_PromotionTreasure, 6).     %% 无尽宝库
-define(ACTIVITY_TYPE_GloryCarnival, 7).         %% 觉醒狂欢
-define(ACTIVITY_TYPE_BossFirstKill, 8).     %% BOSS首杀
-define(ACTIVITY_TYPE_Lucky_Wheel, 9).        %% 幸运转盘
-define(ACTIVITY_TYPE_Rank_Wheel, 10).         %% 排行榜转盘
-define(ACTIVITY_TYPE_Treasure_Wheel, 11).     %% 聚宝盆转盘
-define(ACTIVITY_TYPE_Maze_Wheel, 12).         %% 迷宫转盘
-define(ACTIVITY_TYPE_Matrix_Wheel, 13).       %% 矩阵寻宝
-define(ACTIVITY_TYPE_Donate_Roulette, 14).     %% 捐献抽奖
-define(ACTIVITY_TYPE_DragonTreasure, 16).     %% 龙神秘宝
-define(ACTIVITY_TYPE_DirectPurchase_Summary, 17).     %% 直购活动1 (汇总天数)
-define(ACTIVITY_TYPE_DirectPurchase_Segmented, 18).     %% 直购活动2 (独立天数)
-define(ACTIVITY_TYPE_Arbitrary_Charge, 19).     %% 任意充
-define(ACTIVITY_TYPE_Dragon_Temple, 20).     %% 龙神殿
-define(ACTIVITY_TYPE_Grand_Ceremony, 21).     %% 盛典
-define(ACTIVITY_TYPE_DragonBadge, 22).     %% 荣耀龙徽
-define(ACTIVITY_TYPE_Change_Active, 23).     %% 兑换活动
-define(ACTIVITY_TYPE_Continuous_Recharge, 24).     %% 连充豪礼
-define(ACTIVITY_TYPE_Weekly_Card, 25).     %% 周卡
-define(ACTIVITY_TYPE_Wanted, 26).     %% 悬赏
-define(ACTIVITY_TYPE_Lucky_Cat, 27).     %% 招财猫
-define(ACTIVITY_TYPE_Wheel_Luck_Diamond, 28).     %% 钻石幸运转盘
-define(ACTIVITY_TYPE_Wheel_Good_Fortune, 29).     %% 鸿运当头钻盘
-define(ACTIVITY_TYPE_Cloud_Buy_Lucky_Wheel, 30).     %% 云购
-define(ACTIVITY_TYPE_Consume_Top, 31).     %% 消费排行
-define(ACTIVITY_TYPE_Destiny_Wheel, 32).     %% 天命转盘
-define(ACTIVITY_TYPE_Select_Gift, 33).        %%自选直购
-define(ACTIVITY_TYPE_FirstRechargeReset, 34).        %% 首充重置
-define(ACTIVITY_TYPE_Cloud_Buy_Lucky_Wheel_New, 35).     %% 新云购

-define(ACTIVITY_TYPE_VersionNotice, 100).     %%版本预告

%% 自动加载的活动类型
-define(AutoLoadActivityType, [?ACTIVITY_TYPE_Achievement, ?ACTIVITY_TYPE_DragonHonor, ?ACTIVITY_TYPE_Questionnaire,
	?ACTIVITY_TYPE_PromotionPresentGift, ?ACTIVITY_TYPE_PromotionTreasure, ?ACTIVITY_TYPE_GloryCarnival, ?ACTIVITY_TYPE_TimeLimitGiftPlus,
	?ACTIVITY_TYPE_BossFirstKill, ?ACTIVITY_TYPE_DragonTreasure, ?ACTIVITY_TYPE_Donate_Roulette,
	?ACTIVITY_TYPE_DirectPurchase_Summary, ?ACTIVITY_TYPE_DirectPurchase_Segmented, ?ACTIVITY_TYPE_Arbitrary_Charge, ?ACTIVITY_TYPE_Dragon_Temple,
	?ACTIVITY_TYPE_Grand_Ceremony, ?ACTIVITY_TYPE_Change_Active, ?ACTIVITY_TYPE_DragonBadge, ?ACTIVITY_TYPE_Continuous_Recharge, ?ACTIVITY_TYPE_Weekly_Card,
	?ACTIVITY_TYPE_Lucky_Cat, ?ACTIVITY_TYPE_Wanted, ?ACTIVITY_TYPE_VersionNotice, ?ACTIVITY_TYPE_Wheel_Luck_Diamond, ?ACTIVITY_TYPE_Wheel_Good_Fortune,
	?ACTIVITY_TYPE_Consume_Top, ?ACTIVITY_TYPE_Destiny_Wheel, ?ACTIVITY_TYPE_Select_Gift, ?ACTIVITY_TYPE_FirstRechargeReset
] ++ ?WHEEL_CLASS).

%% 个人版活动自动加载的活动类型
-define(AutoLoadPlayerActivityType, [?ACTIVITY_TYPE_Achievement, ?ACTIVITY_TYPE_DirectPurchase_Summary, ?ACTIVITY_TYPE_DirectPurchase_Segmented,
	?ACTIVITY_TYPE_Arbitrary_Charge, ?ACTIVITY_TYPE_Change_Active, ?ACTIVITY_TYPE_Continuous_Recharge, ?ACTIVITY_TYPE_Weekly_Card,
	?ACTIVITY_TYPE_Wanted]).

%% 需要启动进程的活动的配置
-define(StartChildSpec, #{
	?ACTIVITY_TYPE_DragonHonor => #{serv_handler => dragon_honor_ser, opts => [tick]},
	?ACTIVITY_TYPE_BossFirstKill => #{serv_handler => boss_first_kill_ser, msg_handler => boss_first_kill_ser},
	?ACTIVITY_TYPE_Donate_Roulette => #{serv_handler => donate_roulette_server, msg_handler => donate_roulette_msg, opts => [tick, reset]},
	?ACTIVITY_TYPE_Consume_Top => #{serv_handler => consume_top_ser, msg_handler => consume_top_msg, opts => [reset]},
	?ACTIVITY_TYPE_Lucky_Wheel => #{serv_handler => lucky_wheel_ser, msg_handler => lucky_wheel_msg},
	?ACTIVITY_TYPE_Rank_Wheel => #{serv_handler => rank_wheel_ser, msg_handler => rank_wheel_msg},
	?ACTIVITY_TYPE_Treasure_Wheel => #{serv_handler => treasure_wheel_ser, msg_handler => treasure_wheel_msg, opts => [reset]},
	?ACTIVITY_TYPE_Maze_Wheel => #{serv_handler => maze_wheel_ser, msg_handler => maze_wheel_msg},
	?ACTIVITY_TYPE_Matrix_Wheel => #{serv_handler => matrix_wheel_ser, msg_handler => matrix_wheel_msg},
	?ACTIVITY_TYPE_Cloud_Buy_Lucky_Wheel => #{serv_handler => cloud_buy_wheel_ser, msg_handler => cloud_buy_wheel_msg, opts => [tick, reset]},
	?ACTIVITY_TYPE_Cloud_Buy_Lucky_Wheel_New => #{serv_handler => cloud_buy_wheel_new_ser, msg_handler => cloud_buy_wheel_new_msg, opts => [tick, reset]}
}).

%% 转盘类
-define(WHEEL_CLASS, [?ACTIVITY_TYPE_Lucky_Wheel, ?ACTIVITY_TYPE_Rank_Wheel, ?ACTIVITY_TYPE_Treasure_Wheel,
	?ACTIVITY_TYPE_Maze_Wheel, ?ACTIVITY_TYPE_Matrix_Wheel, ?ACTIVITY_TYPE_Cloud_Buy_Lucky_Wheel, ?ACTIVITY_TYPE_Cloud_Buy_Lucky_Wheel_New]).

%% 玩家个人活动开启条件
-define(ActivityOpenType_Level, 1).                              %%	类型=1表示：等级达到，参数1=等级，参数2、3、4=0；
-define(ActivityOpenType_FuncOpen, 2).                           %%	类型=2表示：开启功能，参数1=功能开启ID，参数2、3、4=0；
-define(ActivityOpenType_Reincarnate, 3).                        %%	类型=3表示：完成转生，参数1=转生数，参数2、3、4=0；
-define(ActivityOpenType_MainlineCopyMapPass, 4).                %%	类型=4表示：通关主线关卡，参数1=关卡ID，参数2、3、4=0；
-define(ActivityOpenType_TaskReceive, 5).                        %%	类型=5表示：接取任务，参数1=任务ID，参数2、3、4=0；
-define(ActivityOpenType_TaskFinish, 6).                         %%	类型=6表示：完成任务，参数1=任务ID，参数2、3、4=0；
-define(ActivityOpenType_GetMount, 7).                           %%	类型=7表示：激活指定坐骑，参数1=坐骑id，参数2、3、4=0；
-define(ActivityOpenType_GetWing, 8).                            %%	类型=8表示：激活指定翅膀，参数1=翅膀id，参数2、3、4=0；
-define(ActivityOpenType_GetPet, 9).                             %%	类型=9表示：激活指定英雄，参数1=英雄id，参数2、3、4=0；
-define(ActivityOpenType_GetRelic, 10).                          %%	类型=10表示：激活指定圣物或幻化圣物，参数1=圣物或幻化圣物id，参数2、3、4=0；
-define(ActivityOpenType_CareerTowerMain, 11).                   %%	类型=11表示：英雄塔层数，参数1=层数，参数2、3、4=0；
-define(ActivityOpenType_SuperTower, 12).                        %%	类型=12表示：黄金魔塔层数，参数1=层数，参数2、3、4=0；
-define(ActivityOpenType_PetNormalDrawTime, 13).                 %%	类型=13表示：累计英雄召唤多少次，参数1=次数，参数2、3、4=0；
-define(ActivityOpenType_PetSeniorDrawTime, 14).                 %%	类型=14表示：累计命运召唤多少次，参数1=次数，参数2、3、4=0；
-define(ActivityOpenType_XunBaoDrawTime, 15).                    %%	类型=15表示：累计寻宝多少次，参数1=寻宝ID，参数2=次数，参数 3、4=0；
-define(ActivityOpenType_ExpeditionSeason, 16).                  %%	类型=16表示：开启第几个远征赛季，参数1=第几个赛季（1体验赛季，2第一个赛季，依次类推…），参数2、3、4=0；
-define(ActivityOpenType_King1V1Season, 17).                     %%	类型=17表示：开启第几个王者1V1赛季，参数1=第几个赛季，参数2、3、4=0；
-define(ActivityOpenType_EliteCopyMapPass, 18).                  %%	类型=18表示：精英副本第X章全3星通关，参数1=章节id，参数2=总星数、3、4=0；
-define(ActivityOpenType_MaterialCopyMapPass, 19).               %%	类型=19表示：材料副本三星通关（坐骑、翅膀），参数1=副本id，参数2、3、4=0；
-define(ActivityOpenType_SealOpen, 20).                          %% 类型=20表示：触发本服X恶魔封印，参数1=ID【LevelSeal_1_等级封印】，参数2、3、4=0；
-define(ActivityOpenType_EleCCurseConsume, 21).                  %%	类型=21表示：累计消耗怒气值{0}点，参数1=怒气值，参数2、3、4=0；
-define(ActivityOpenType_ClusterReset, 22).                  	 %%	类型=22表示：联服重组X天内，等级小于等于联服时间等级γ级，且单服等级排行榜在z名以前[含该名次]，参数1=天数，参数2=等级，参数3=名次，参数4=0

%% 达成类-玩家数据
-define(TableConditionPlayer, db_condition_player).
-record(condition_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	cond_reach_list = [],    %% 达成条件
	comp_list = []     %% 完成项目
}).

%% 公会骑士团
-define(TableDragonHonor, db_dragon_honor).
-record(dragon_honor_info, {
	id = 0,
	is_final = 0,  %% 最终结算 0 否 1是
	guild_rank = [], %%{rank,guildID}
	guild_member_rank = [],%% ,{guildID,[{rank,playerID}]}
	title_info = [], %% {PlayerID,TitleId}
	update_time = 0
}).

%% 荣耀献礼
-define(TablePromotionPresentGiftPlayer, db_promotion_present_gift_player).
-record(promotion_present_gift_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	buy_list = []    %% index
}).

%% 无尽宝库
-define(TablePromotionTreasurePlayer, db_promotion_treasure_player).
-record(promotion_treasure_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,        %% 活动入口ID
	is_get_big_award = [],    %% 是否获得大奖	宝藏ID
	open_award = [],            %% 已经开出的奖励 {{宝藏ID, pos}, 库id, 库index}
	cond_reach_list = [],    %% 达成条件
	comp_list = []     %% 完成项目 {{day,index},time}
}).

%% 觉醒狂欢
-define(TableGloryCarnivalPlayer, db_glory_carnival_player).
-record(glory_carnival_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	world_level = 0,    %% 世界等级
	score_list = [],    %% 狂欢积分 {type, score}
	award_list = [],        %% 已领取列表 {type, Index}
	cond_reach_list = [],    %% 达成条件
	comp_list = []        %% 完成项目{{o1, o2, o3}, num}
}).
%% 限时特惠弹窗版
-define(TableTimeLimitGiftPlus, db_time_limit_gift_plus).
-record(time_limit_gift_plus, {
	player_id = 0,       %% 玩家id
	id = 0,              %% 特惠id
	order = 0,           %% 特惠序号
	main_ac_id = 0,      %% 活动id
	open_time = 0,       %% 开启时间
	end_time = 0,        %% 结束时间 type=1时为结束时间戳 ，type=2时为剩余分钟数
	status = 0,          %% 状态
	buy_times = 0,       %% 购买次数
	push_param = 0       %% 弹窗参数 2-下一次弹出时间  其他-无意义
}).
%% BOSS首杀
-define(TableBossFirstKill, db_boss_first_kill).
-record(boss_first_kill, {
	main_ac_id = 0,
	map_data_id = 0,
	boss_data_id = 0,
	kill_player_id = 0
}).
%% BOSS首杀
-define(TableBossFirstKillPlayer, db_boss_first_kill_player).
-record(boss_first_kill_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,        %% 活动入口ID
	award_list = []        %% 已领取的奖励 {mapdataid,bossdataid}
}).

%% 龙神秘宝
-define(TableDragonTreasurePlayer, db_dragon_treasure_player).
-record(dragon_treasure_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,        %% 活动入口ID
	world_level = 0,        %% 世界等级
	select_ids = [],        %% 选择的奖励[idx, ...]
	draw_ids = [],          %% 抽到的奖励[{pos, idx}, ...]
	times_rewards = []      %% 领取的次数奖励[idx]
}).

%% 转盘通用
-define(TableWheel, db_wheel).
-record(wheel, {
	main_ac_id = 0,
	type = 0,
	data   %% 任意term，以blob存储
}).

%% 转盘通用-玩家
-define(TableWheelPlayer, db_wheel_player).
-record(wheel_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	change_integral = 0,%% 兑换积分
	lucky_integral = 0, %% 幸运积分
	draw_times = 0,     %% 抽奖次数
	change_list = [],   %% 已兑换列表
	temp_bag = [],      %% 临时仓库列表
	spec_list = [],     %% 特殊掉落的抽奖次数
	draw_record = []    %% 个人抽奖记录
}).

%% 捐赠抽奖
%% 捐赠抽奖表
-define(TableDonateRoulette, db_donate_roulette).
-record(donate_server, {
	main_ac_id = 0,            %% 活动入口ID
	donate_sum = 0,         %% 捐赠总量
	awards = [],            %% 奖励情况[{id, time}]
	last_awards = [],       %% 昨日奖励情况[{id, time}]
	reward_records = [],    %% 大奖记录
	change_list = []        %% 全服兑换列表 [{Index, Times}]
}).

%% 捐赠抽奖玩家表
-define(TableDonateRoulettePlayer, db_donate_roulette_player).
-record(donate_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,        %% 活动入口ID
	donate_sum = 0,         %% 捐赠总量
	change_score = 0,       %% 兑换积分
	awards = [],             %% 奖励情况[{type, id}] type:1个人 2全服
	change_list = []        %% 已兑换列表	[{Index, Times}]
}).

-define(TableDpSummaryPlayer, db_dp_summary_player).
-record(dp_summary_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,       %% 活动入口ID
	player_lv = 0,        %% 活动开启时玩家的等级
	open_list = []        %% 购买列表{id,daily_buy,total_buy}
}).

-define(TableDpSegmentedPlayer, db_dp_segmented_player).
-record(dp_segmented_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,       %% 活动入口ID
	day = 0,              %% 天数序号
	player_lv = 0,        %% 活动开启时玩家的等级
	open_list = []        %% 购买列表{id,daily_buy,total_buy}
}).

-define(TableArbitraryChargePlayer, db_arbitrary_charge_player).
-record(arbitrary_charge_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,       %% 活动入口ID
	award_list = []       %% 已领取的奖励id
}).

%% 龙神殿-玩家数据
-define(TableDragonTempleReach, db_dragon_temple_reach).
-record(dragon_temple_reach, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,       %% 活动入口ID
	world_lv = 0,         %% 世界等级
	cond_reach_list = [], %% 达成条件
	comp_list = []        %% 完成项目
}).

%% 盛典-玩家数据
-define(TableGrandCeremonyReach, db_grand_ceremony_reach).
-record(grand_ceremony_reach, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,       %% 活动入口ID
	cond_reach_list = [], %% 达成条件
	comp_list = []        %% 完成项目
}).

%% 兑换活动玩家表
-define(TableChangeActive, db_change_active_player).
-record(change_active_player, {
	player_id = 0,        %% 玩家ID
	main_ac_id = 0,        %% 活动入口ID
	change_list = [],        %% 已兑换列表 [{Index, Times}]
	today_change_list = [],   %% 今日已兑换列表 [{Index, Times}]
	follow_list = []       %% 关注列表
}).

%% 荣耀龙徽玩家表
-define(TableDragonBadgeActivityPlayer, db_dragon_badge_activity_player).
-record(db_dragon_badge_player, {
	player_id = 0,            %% 玩家id
	main_ac_id = 0,        %% 活动入口ID
	world_lv = 0,
	lv = 1,
	exp = 0,
	advance_flag = 0,        %% bit1 普通进阶 bit2 至尊进阶
	lv_award = [],
	daily_cond_reach_list = [],    %% 每日任务达成条件
	daily_comp_list = [],            %% 每日任务完成项目
	weekly_cond_reach_list = [],    %% 每周任务达成条件
	weekly_comp_list = [],            %% 每周任务完成项目
	goods_buy = [],        %% {goods_id,Times}
	is_daily_award = 0,
	next_reset_time = 0    %% 下一次周重置时间
}).

%% 连充豪礼-玩家数据
-define(TableContinuousRechargePlayer, db_continuous_recharge_player).
-record(continuous_recharge_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	world_lv = 0,            %% 活动世界等级
	cond_reach_list = [],    %% 达成条件
	comp_list = [],     %% 完成项目
	award_extra_list = [] %% 领取的额外奖励id
}).

%% 红点类型
-define(RedPointType1, 1). %% 登录一次性红点
-define(RedPointType2, 2). %% 领奖红点
-define(RedPointType3, 3). %% 仓库红点
-define(RedPointType4, 4). %% 兑换商店红点
-define(RedPointType5, 5). %% 关注红点
-define(RedPointType6, 6). %% 每日红点

%% 特权周卡
-define(TableACWeeklyCardPlayer, db_ac_weekly_card_player).
-record(ac_weekly_card_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	world_lv = 0,       %% 世界等级
	recharge_num = 0,   %% 充值钻石数
	is_active = 0,      %% 是否激活
	award_day = 0       %% 领取奖励天数
}).

%% 招财猫
-define(TableLuckyCatPlayer, db_lucky_cat_player).
-record(lucky_cat_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	drawn_times = 0,    %% 已抽次数
	reach_cond_list = []  %% 达成条件列表
}).

%% 悬赏
-define(TableWantedPlayer, db_wanted_player).
-record(wanted_player, {
	player_id = 0,      %% 玩家ID
	main_ac_id = 0,     %% 活动入口ID
	world_lv = 0,       %% 世界等级
	is_buy = 0,         %% 是否购买
	recharge_num = 0,   %% 充值钻石数
	cond_reach_list = [],    %% 达成条件
	comp_list = [],     %% 完成项目
	free_comp_list = []  %% 免费奖励
}).

%% 云购
-define(TableCloudBuyLucky, db_cloud_buy_lucky).
-record(cloud_buy_lucky, {
	id = 0, %% 活动入口ID
	cur_day = 0, %% 当前活动天数
	is_settle = 0, %% 是否结算
	winning_id = 0, %% 当天中奖者ID
	winning_num = 0, %% 当天中奖者幸运数字
	total_times = 0, %% 全服抽奖次数
	draw_list = [], %% 抽奖数据[{id, times, getMask}] getMask bit0~15全服领取进度 bit16~31 自己领取进度
	draw_log_list = [], %% 抽奖记录 [{player_id, draw_count, time, award}] award = {CoinList={ID,Num}, ItemList={ID,Num}, EquipList}
	winning_list = [], %% 幸运数字奖励记录 [{player_id, time, award}] award = {CoinList, ItemList, EquipList}
	rand_list = [], %% 幸运数字随机列表 [1000,1001,...]
	player_lucky_list = [] %% 玩家幸运数字 [{PlayerID, [1000,1001,...]}]
}).

%% 消费排行
-define(TableConsumeTop, db_consume_top).
-record(consume_top, {
	id = 0, %% 活动入口ID
	day = 0, %% 天
	is_settle = 0, %% 是否结算
	rank_list = [], %% 排行 [{player id,value,time,rank}]
	un_rank_list = [] %% 未进排行 [{player id,value}]
}).

%% 新云购
-define(TableNewCloudBuyLucky, db_cloud_buy_lucky_new).
-record(new_cloud_buy_lucky, {
	id = 0, %% 活动入口ID
	cur_day = 0, %% 当前活动天数
	is_settle = 0, %% 是否结算
	round_end_time = 0, %% 本轮结束时间
	winning_id = 0, %% 当天中奖者ID
	winning_num = 0, %% 当天中奖者幸运数字
	total_times = 0, %% 全服抽奖次数
	draw_list = [], %% 抽奖数据[{id, times, getMask}] getMask bit0~15全服领取进度 bit16~31 自己领取进度
	winning_list = [], %% 幸运数字奖励记录 [{player_id, time, award}] award = {CoinList, ItemList, EquipList}
	rand_list = [], %% 幸运数字随机列表 [1000,1001,...]
	player_lucky_list = [] %% 玩家幸运数字 [{PlayerID, [1000,1001,...]}]
}).