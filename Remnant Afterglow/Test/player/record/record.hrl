%%%------------------------------------------------
%%% File    : record.erl
%%% Author  : gogo
%%% Created : 2014.11.4
%%% Description: record
%%% 记录结构定义
%%%------------------------------------------------
-include("global.hrl").
-include("battlefield.hrl").
-include("melee.hrl").
-include("ashura.hrl").
-ifndef(record_hrl).
-define(record_hrl, 1).

%%标记为 服务器类型 2个互斥
-define(ShareServer, true).
-define(GameServer, false).

-define(INT16, 16 / signed - little - integer).
-define(INT8, 8 / signed - little - integer).
-define(INT, 32 / signed - little - integer).
-define(INT64, 64 / signed - little - integer).
-define(UINT, 32 / unsigned - little - integer).
-define(ETSRC, {read_concurrency, true}).       %%并发读写
-define(ETSWC, {write_concurrency, true}).      %%并发读写

%% 开放的职业
-define(OpenCareerList, [1004, 1005, 1006, 1007]).
%% 最大可创建角色数
-define(MaxRoleNum, 3).

-define(IF(EXPRESSION, Value1, Value2),
	case EXPRESSION of
		true -> Value1;
		false -> Value2
	end).

-define(MainTick_INTERVAL, 1000).  %%系统心跳包1000ms
-define(MapTick_INTERVAL, 250).  %%地图进程心跳包500ms->250ms
-define(FreeSocket_MaxTickCount, 1100).         %%空连接最大TICK数   3*60*5
-define(AccountOffLine_MaxTickCount, 900).      %%帐号下线检测最大TICK数  3*60*5
-define(PlayerOnLine_MaxTickCount, 600).       %%在线角色检测最大TICK数  1*60*5
-define(Team_MaxTickCount, 1400).               %%队伍检测最大TICK数         5*60*5
-define(Reset_MaxTickCount, 600).               %%重置检测最大TICK数   2*60*5
-define(Main_ResetTime, 60).                 %% 系统重置时间   4 * 3600=14400, 改为0:01重置
-define(MapTimeOut_INTERVAL, 60).  %%地图超时检测60s
-define(MapDestroy_INTERVAL, 5000).  %%地图超时到销毁的间隔时间5s
-define(Player_AutoSave_INTERVAL, 10).  %%玩家角色数据自动保存频率，单位为分
-define(MonthTick_Seconds, 2592000).    %% 一个月 秒数  60 * 60 * 24 * 30
-define(WeekTick_Seconds, 604800).    %% 一周 秒数  60 * 60 * 24 * 7
-define(DayTick_Seconds, 86400).    %% 一天 秒数  60 * 60 * 24
-define(UserLoginTick_INTERVAL, 50).  %%登录队列心跳 50ms 每秒20个登录
-define(Distance_Player_NPC, 15).   %% 玩家和NPC验证距离

%%需要初始化成功的模块
-define(InitModule_Main, 1).
-define(InitModule_MapMgr, 2).
-define(InitModule_Chat, 3).
-define(InitModule_VoiceChat, 4).
%-define(InitModule_Team, 5).
%% -define(InitModule_Mail, 6).
%%-define(InitModule_AuctionHouse, 6).
-define(InitModule_Shop, 6).
-define(InitModule_Guild, 7).
%-define(InitModule_FastTeamSup, 9).
%%-define(InitModule_HomeManagerSup, 10).
-define(InitModule_ArenaSup, 11).
-define(InitModule_LoginServer, 12).
-define(InitModule_NetServerSup, 13).
-define(InitModule_Top, 14).
-define(InitModule_Announce, 15).
-define(InitModule_WorldBoss, 16).
-define(InitModule_FightRingSup, 17).
-define(InitModule_BossWorldSup, 18).
-define(InitModule_ManorWarSup, 19).
-define(InitModule_Plunder, 20).
-define(InitModule_Battlefield, 21).
-define(InitModule_RoomMgrSup, 22).
-define(InitModule_Friends, 23).
-define(InitModule_Carnival, 24).
-define(InitModule_SalesActivity, 25).
-define(InitModule_WildAutoSup, 26).
-define(InitModule_rouletteMgr, 27).
-define(InitModule_topActivity, 28).
-define(InitModule_Melee, 29).
-define(InitModule_Convoy, 30).
-define(InitModule_Ashura, 32).
-define(InitModule_CroFightRingLocalSup, 33).
-define(InitModule_Darts, 34).
-define(InitModule_Wedding, 35).
-define(InitModule_intimacy, 36).
-define(InitModule_danmakuMgr, 37).
-define(InitModule_WeddingTop, 38).
-define(InitModule_Flower, 39).
-define(InitModule_MailNew, 40).
-define(InitModule_DailyTop, 41).

-define(InitModule_CHECK_LIST, [
	?InitModule_Chat,
	?InitModule_VoiceChat,
	?InitModule_Shop,
	?InitModule_Guild,
	?InitModule_ArenaSup,
	?InitModule_LoginServer,
	?InitModule_NetServerSup,
	?InitModule_Top,
	?InitModule_Announce,
	?InitModule_WorldBoss,
	?InitModule_BossWorldSup,
	?InitModule_Battlefield,
	?InitModule_Friends,
	?InitModule_SalesActivity,
	?InitModule_topActivity,
	?InitModule_Melee,
	?InitModule_Convoy,
	?InitModule_Ashura,
	?InitModule_Wedding,
	?InitModule_intimacy,
	?InitModule_danmakuMgr,
	?InitModule_WeddingTop,
	?InitModule_Flower,
	?InitModule_MailNew,
	?InitModule_DailyTop
]).

%%功能开启，对应的功能ID
-define(OpenAction_EquipLevel, 1).          %% 装备强化
-define(OpenAction_Plunder, 5).             %% 掠夺（夺宝）副本
-define(OpenAction_Arena, 6).               %% 竞技场
-define(OpenAction_TeamCopyMap, 9).         %% 组队副本
-define(OpenAction_Home, 11).               %% 家园
-define(OpenAction_EquipSynthetic, 12).     %% 装备合成
-define(OpenAction_SecretCopyMap, 16).      %% 妖魔来袭
-define(OpenAction_FightRing, 17).          %% 比武擂台
-define(OpenAction_DNTG, 20).               %% 大闹天宫
-define(OpenAction_EquipNumber, 21).        %% 装备洗练
-define(OpenAction_YanMo, 23).          %% 炎魔试炼
-define(OpenAction_ActiveCopyMap_Equip, 24).      %% 活动副本-强化石
-define(OpenAction_XCTS, 26).               %% 仙船探索
-define(OpenAction_DoublePactice, 27).      %% 双修
-define(OpenAction_FWT, 28).                %% 风晚亭
-define(OpenAction_Mine, 29).               %% 矿脉
-define(OpenAction_ChangeCareer, 30).       %% 变身
-define(OpenAction_DailyTask, 31).            %% 日常
-define(OpenAction_GuildCopyMap, 32).       %% 仙盟副本
-define(OpenAction_ExcellenceCopyMap, 43).  %% 精英副本
-define(OpenAction_PlayerSkill, 44).        %% 主角技能
-define(OpenAction_Poncho, 45).             %% 披风
-define(OpenAction_Title, 46).                %% 称号
-define(OpenAction_EquipQuality, 47).       %% 装备精炼
-define(OpenAction_Pet, 48).               %% 魔宠
-define(OpenAction_HeroChara, 49).          %% 英雄升品
-define(OpenAction_HeroStar, 50).           %% 英雄升星
-define(OpenAction_HeroCulture, 51).        %% 英雄培养
-define(OpenAction_Fashion, 54).            %% 时装
-define(OpenAction_TopChart, 57).            %% 排行榜
-define(OpenAction_FateLevel, 60).            %% 大圣之路
-define(OpenAction_GemsStone, 61).            %% 圣印
-define(OpenAction_WildBoss, 65).            %% 诛仙
-define(OpenAction_SevenGift, 66).            %% 七天奖
%%-define(OpenAction_ManorWar, 69).%%领地战
-define(OpenAction_Shop, 70).                %% 商城
-define(OpenAction_Assist, 72).             %% 副将
-define(OpenAction_NextDayAward, 73).       %% 次日奖励
-define(OpenAction_ActiveCopyMap_HeroExp, 74).      %% 活动副本-包子
-define(OpenAction_ActiveCopyMap_Money, 75).      %% 活动副本-铜币
-define(OpenAction_Battlefield, 78).      %% 三界战场
-define(OpenAction_Mount, 82).            %% 坐骑
-define(OpenAction_Carnival, 83).            %% 嘉年华
-define(OpenAction_QQVip_Level, 84).%%QQ会员 冲级功能
-define(OpenAction_Activities, 86).      %% 精彩活动
-define(OpenAction_RouletteA, 87).      %% 转盘
-define(OpenAction_EquipAddChara, 90).             %% 装备觉醒
-define(OpenAction_daily_buy, 91).             %% 每日礼包
-define(OpenAction_DayPayAward, 92).             %% 充值OpenAction_CoupleFight
-define(OpenAction_recharge_total, 94).             %% 累计充值/天天乐/每日首充
-define(OpenAction_Melee, 95).             %% 麒麟洞
-define(OpenAction_HeroAwaken, 96).             %% 英雄觉醒
-define(OpenAction_HeroAwakenPotential, 97).             %% 英雄炼魂
-define(OpenAction_Convoy, 98).     %% 运镖
-define(OpenAction_DungeonLove, 100).             %% 七夕副本
-define(OpenAction_ThunderFort, 101).             %% 雷霆要塞
-define(OpenAction_Wing, 103).                %% 翅膀
-define(OpenAction_3v3, 105).                %% 3v3
-define(OpenAction_ThreeHeave, 111).            %% 三重天
-define(OpenAction_MountAwaken, 113).             %% 坐骑觉醒
-define(OpenAction_DungeonFabao, 114).%%法宝副本
-define(OpenAction_WorldLevel, 116).             %% 世界等级
%%-define(OpenAction_GemRefine, 117).             %% 圣印精炼
-define(OpenAction_Wedding, 118).         %% 仙侣奇缘
-define(OpenAction_Ring, 119).              %% 婚戒
-define(OpenAction_ActiveExtend, 120).      %% 秘境试炼
-define(OpenAction_FWing, 121).            %% 飞翼
-define(OpenAction_CoupleFight, 122).%%跨服仙侣2v2
-define(OpenAction_WildAutoBoss, 123).      %% 四海刷怪
-define(OpenAction_Trade, 124).      %% 交易行
-define(OpenAction_Demon, 125).      %% 恶魔入侵
-define(OpenAction_DemonCx, 126).      %% 恶魔巢穴
-define(OpenAction_EqInt, 127).         %% 装备强化
-define(OpenAction_Synthetic, 131).     %% 装备合成
-define(OpenAction_PersonalBoss, 132).      %% 个人恶魔
-define(OpenAction_DemonsLair, 133).      %% 恶魔禁地
-define(OpenAction_EqSuit, 134).      %% 装备套装
-define(OpenAction_Rune, 137).      %% 符文
-define(OpenAction_RuneTower, 138).      %% 符文塔
-define(OpenAction_Team, 139).      %% 组队
-define(OpenAction_EqAdd, 140).        %% 装备追加
-define(OpenAction_EqCast, 141).      %% 装备洗练
-define(OpenAction_GemOn, 142).            %% 宝石镶嵌
-define(OpenAction_GemRefine, 143).        %% 宝石精炼
-define(OpenAction_GDMain, 144).        %% 龙神
-define(OpenAction_GDElf, 146).            %% 精灵龙神
-define(OpenAction_GDAddStar, 147).        %% 龙神升星
-define(OpenAction_GD_Statue, 148).        %% 龙神雕像
-define(OpenAction_Astro, 149).            %% 神灵
-define(OpenAction_DungeonPet, 150).    %% 宠物副本
-define(OpenAction_DungeonWing, 151).    %% 翅膀副本
-define(OpenAction_DungeonMount, 152).    %% 坐骑副本
-define(OpenAction_DJBK, 153).    %% 地精宝库
-define(OpenAction_Guard, 154).    %% 守护
-define(OpenAction_GDCons, 155).    %% 龙神秘典
-define(OpenAction_HolyOpen, 157).      %% 圣物
-define(OpenAction_HolyRefine, 158).      %% 圣物精炼
-define(OpenAction_Hang, 159).      %% 挂机
-define(OpenAction_Pantheon, 160).      %% 神魔战场
-define(OpenAction_Moling, 161).        %% 魔灵
-define(OpenAction_Yiling, 162).        %% 翼灵
-define(OpenAction_Shouling, 163).        %% 兽灵
-define(OpenAction_FreeEnergy, 164).    %% 龙城盛宴
-define(OpenAction_TeamExp, 165).        %% 恶魔广场
-define(OpenAction_guild, 166).             %% 仙盟
-define(OpenAction_Science, 167).     %% 战盟科技
-define(OpenAction_GuildTask, 168).     %% 战盟任务
-define(OpenAction_GuildFete, 171).     %% 战盟祭祀
-define(OpenAction_Card, 172).          %% 图鉴
-define(OpenAction_EqFade, 176).        %% 装备炼金
-define(OpenAction_PlayerTitle, 177).      %% 头衔
-define(OpenAction_BountyTask, 178).      %% 赏金任务
-define(OpenAction_Friends, 179).       %% 好友
-define(OpenAction_PreDeposits, 180).   %% 矮人宝藏
-define(OpenAction_DepositsEx, 181).   %% 精灵宝库  d3 组队装备副本
-define(OpenAction_WorldBoss, 183).   %% 世界boss
-define(OpenAction_MapDragon, 184).     %% 龙神秘典副本
-define(OpenAction_BoneYard, 185).     %% 百鬼夜行, 埋骨之地
-define(OpenAction_GuildGuard, 186).     %% 守卫战盟
-define(OpenAction_GuildCraft, 189).     %% 战盟争霸
-define(OpenAction_DungeonRelic, 190).     %% 圣物副本
-define(OpenAction_DungeonDragon, 191).     %% 龙神副本
-define(OpenAction_Soul, 192).            %% 神魂
-define(OpenAction_Prophecy7, 194).     %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_CoupleTrial, 195).     %% 情侣试炼
-define(OpenAction_ExtLevel, 196).        %% 巅峰等级
-define(OpenAction_Attainment, 197).     %% 成就
-define(OpenAction_Prophecy3, 198).     %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_Prophecy4, 199).     %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_Prophecy5, 200).     %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_Prophecy6, 201).     %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_Skill, 202).            %% 技能
-define(OpenAction_Genius, 203).        %% 天赋
-define(OpenAction_SkillBind, 205).        %% 技能装配
-define(OpenAction_Fight_1v1, 206).      %% 王者1V1
-define(OpenAction_Dress, 207).      %% 装扮
-define(OpenAction_MountSublimate, 210).  %% 坐骑炼魂
-define(OpenAction_MountEq, 211).     %% 坐骑装备
-define(OpenAction_WingFeather, 212).  %% 翅膀羽化
-define(OpenAction_WingSublimate, 213).  %% 翅膀炼魂
-define(OpenAction_WingEq, 214).     %% 翅膀装备
-define(OpenAction_PetAwaken, 215).  %% 宠物觉醒
-define(OpenAction_PetSublimate, 216).  %% 宠物炼魂
-define(OpenAction_PetEq, 217).       %% 宠物装备（包括合成）
-define(OpenAction_AwakenRoad, 218).  %% 觉醒之路(原龙神图鉴)
-define(OpenAction_GuardUp, 220).        %% 守护升阶
-define(OpenAction_ChatBubble, 221).    %% 聊天气泡
-define(OpenAction_HornBubble, 222).    %% 喇叭气泡
-define(OpenAction_XunBao_0, 226).      %% 0寻宝总控
-define(OpenAction_XunBao_1, 227).      %% 1装备寻宝
-define(OpenAction_XunBao_2, 228).      %% 2龙印寻宝（符文寻宝）
-define(OpenAction_XORoom, 230).      %% XO房间
-define(OpenAction_RetrieveRes, 231).   %% 资源找回
-define(OpenAction_LoginGift, 233).        %% 登录奖
-define(OpenAction_RingCast, 234).        %% 婚戒淬炼
-define(OpenAction_FreeBuy, 235).        %% 0元购
-define(OpenAction_Funds, 236).            %% 基金
-define(OpenAction_FundsGrowth, 237).    %% 成长基金
-define(OpenAction_FundsExtreme, 238).    %% 巅峰基金
-define(OpenAction_FundsLegend, 239).    %% 传奇基金
-define(OpenAction_FundsAll, 240).        %% 全民奖励
-define(OpenAction_MonthFinancing, 241).    %% 月理财
-define(OpenAction_WeekFinancing, 242).        %% 周理财
-define(OpenAction_TimeLimitGift, 243).        %% 限时折扣
-define(OpenAction_recharge_life_card, 244).             %% 终身卡
-define(OpenAction_XunBao_5, 246).      %% 5魔宠寻宝
-define(OpenAction_XunBao_4, 247).      %% 4神翼寻宝
-define(OpenAction_DungeonMain, 253).   %% 主线副本
-define(OpenAction_CPMonthCard, 255).   %% 情侣月卡
-define(OpenAction_recharge_subscribe, 256).             %% 订阅
-define(OpenAction_recharge_first, 257).             %% 首充
-define(OpenAction_recharge_DungeonDemon, 259).             %% 龙神结界
-define(OpenAction_recharge_first2, 260).             %% 新服累充
-define(OpenAction_Ornament, 261).                    %% 海神套装(配饰)
-define(OpenAction_recharge_first3, 262).             %% 续充
-define(OpenAction_FlyShoes, 264).                    %% 小飞鞋
-define(OpenAction_Prophecy2, 265).                %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_OrnamentCast, 269).                %% 海神祝福
-define(OpenAction_DungeonOrnament, 270).                %% 配饰副本
-define(OpenAction_GuildCamp, 271).                %% 战盟营地
-define(OpenAction_GDSynt, 272).                %% 龙神装合成
-define(OpenAction_Horcrux, 273).                   %% 魂器
-define(OpenAction_PantheonCluster, 274).      %% 神魔战场
-define(OpenAction_GodMountEqSynt, 275).                %%骑装神装和神装石合成
-define(OpenAction_GDMountEqSynt, 276).                %%骑装龙神装合成
-define(OpenAction_GodPetEqSynt, 277).                %%宠装神装和神装石合成
-define(OpenAction_GDPetEqSynt, 278).                %%宠装龙神装合成
-define(OpenAction_GodWingEqSynt, 279).                %%翼装神装和神装石合成
-define(OpenAction_GDWingEqSynt, 280).                %%翼装龙神装合成
-define(OpenAction_GodEqSynt, 281).                %% 神灵装神装和神装石合成
-define(OpenAction_GDEqSynt, 282).                %% 神灵装龙神装备合成
-define(OpenAction_ManorWar, 283).                   %% 领地战-龙城争霸
-define(OpenAction_GodSeaEqSynt, 285).                %% 海神套装：神装、海神神装石合成
-define(OpenAction_GDeaEqSynt, 286).                %% 海神套装：龙神装合成
-define(OpenAction_XunBao_6, 287).      %% 6巅峰寻宝
-define(OpenAction_RuneCore, 289).                  %% 核心龙印
-define(OpenAction_RuneCoreSynt, 290).              %% 核心龙印合成
-define(OpenAction_RuneAddStar, 291).               %% 龙印升星
-define(OpenAction_DemonCluster, 293). %% 恶魔深渊
-define(OpenAction_SoulAddStar, 295).               %% 神魂升星
-define(OpenAction_Weapon, 296).                    %% 神兵
-define(OpenAction_WeaponAddLv, 297).               %% 神兵升阶
-define(OpenAction_WeaponAddStar, 298).             %% 神兵升星
-define(OpenAction_WeaponSoul, 299).                %% 兵魂
-define(OpenAction_WeaponSynt, 300).                %% 神兵合成
-define(OpenAction_WeaponReopen, 301).              %% 神兵解封
-define(OpenAction_GodOrnament, 302).               %% 神饰
-define(OpenAction_MountSynt, 303).                 %% 坐骑合成
-define(OpenAction_PetSynt, 304).                   %% 宠物合成
-define(OpenAction_WingSynt, 305).                  %% 翅膀合成
-define(OpenAction_HolySynt, 306).                  %% 圣物合成
-define(OpenAction_GdSynt, 307).                    %% 龙神合成
-define(OpenAction_HolyShield, 308).                %% 圣盾
-define(OpenAction_HolyShieldStage, 309).                %% 圣盾升阶
-define(OpenAction_HolyShieldSkill, 310).                %% 圣盾技能
-define(OpenAction_GameHelper, 311).                %% 小助手
-define(OpenAction_AbyssFight, 312).                %% 深海角斗
-define(OpenAction_FundsDemon, 313).                %% 神魔基金
-define(OpenAction_FundsGodDragon, 314).            %% 龙神基金
-define(OpenAction_quick_hang, 319).      %% 快速讨伐
-define(OpenAction_dragon_city_updown, 320).      %% 风暴龙城点赞
-define(OpenAction_BlizzardForest, 322).      %% 寒风森林
-define(OpenAction_show_box1_synt, 323).         %% 外显宝箱-骑宠翼
-define(OpenAction_show_box2_synt, 324).         %% 外显宝箱-圣物
-define(OpenAction_Constellation, 325).              %% 星座
-define(OpenAction_Constellation_star_soul_eq1, 326).    %% 星座龙装合成
-define(OpenAction_Constellation_star_soul_eq2, 327).    %% 星座神装合成
-define(OpenAction_RuneAddStage, 328).               %% 龙印升阶
-define(OpenAction_SoulAddStage, 329).               %% 神魂升阶
-define(OpenAction_border_war, 330).             %% 边境入侵
-define(OpenAction_border_coll, 332).             %% 边境采集
-define(OpenAction_DemonsBorder, 333).              %% 边境夺宝
%%-define(OpenAction_Constellation_star_soul_eq3, 335).    %% 星座龙神装合成
-define(OpenAction_GUIDANCE, 335).    %% 小助手
-define(OpenAction_ShenHuaLevel, 336).        %% 神话等级
-define(OpenAction_Ancient_Holy_Eq, 337). %% 古神圣装
-define(OpenAction_change_career, 338).             %% 职业切换
-define(OpenAction_Ancient_Holy_Eq_Synthetic, 339).     %% 古神圣装合成
-define(OpenAction_Ancient_Holy_Eq_Awaken, 341). %% 古神圣装觉醒
-define(OpenAction_RuneSynthetic1, 342).               %% 龙印-紫色三属性合成
-define(OpenAction_RuneSynthetic2, 343).               %% 龙印-橙色三属性合成
-define(OpenAction_RuneSynthetic3, 344).               %% 龙印-红色三属性合成
-define(OpenAction_RuneStageSynthetic1, 345).               %% 龙印-紫色三属性合成
-define(OpenAction_RuneStageSynthetic2, 346).               %% 龙印-紫色三属性合成
-define(OpenAction_RuneStageSynthetic3, 347).               %% 龙印-紫色三属性合成
-define(OpenAction_SoulSynthetic1, 348).               %% 神魂-紫色三属性合成
-define(OpenAction_SoulSynthetic2, 349).               %% 神魂-橙色三属性合成
-define(OpenAction_SoulSynthetic3, 350).               %% 神魂-红色三属性合成
-define(OpenAction_SoulStageSynthetic1, 351).               %% 神魂-紫色三属性合成
-define(OpenAction_SoulStageSynthetic2, 352).               %% 神魂-紫色三属性合成
-define(OpenAction_SoulStageSynthetic3, 353).               %% 神魂-紫色三属性合成
-define(OpenAction_GodFight, 356).                      %% 主神争夺
-define(OpenAction_DungeonGod, 357).                    %% 神力战场
-define(OpenAction_Divine_God, 358).                     %% 神位
-define(OpenAction_BonfireBoss, 359).                    %% 篝火Boss
-define(OpenAction_Divine_Talent, 360).                  %% 神力天赋
-define(OpenAction_HolyRuins, 361).                     %% 星空圣墟
-define(OpenAction_Holy_Wing, 362).                      %% 圣翼
-define(OpenAction_EqEleAdd, 366).                      %% 装备元素强化
-define(OpenAction_Bloodline, 367).                     %% 血脉
-define(OpenAction_Constellation_Awaken, 371).  %% 星魂觉醒
-define(OpenAction_Constellation_Bless, 372).   %% 幸运祝福
-define(OpenAction_MountEleAwaken, 373).        %% 坐骑元素觉醒
-define(OpenAction_WingEleAwaken, 374).         %% 翅膀元素觉醒
-define(OpenAction_Constellation_BlessPro, 375).%% 星魂祝福
-define(OpenAction_PetGradeUp, 376).            %% 魔宠晋升
-define(OpenAction_ShengJia, 377).                %% 圣甲
-define(OpenAction_ShengJia_gem, 378).            %% 圣甲镶嵌
-define(OpenAction_Shengwen, 379).                        %% 圣纹
-define(OpenAction_dragon_city, 380).             %% 风暴龙城
-define(OpenAction_XunBao_7, 381).                %% 7圣纹寻宝
-define(OpenAction_ElementTrial, 382).              %% 元素试炼
-define(OpenAction_Shengwen_ShengwenDragonSynt, 383).    %% 圣纹龙装合成
-define(OpenAction_Shengwen_ShengwenGodSynt, 384).        %% 圣纹神装合成
-define(OpenAction_Shengwen_ShengwenAddStage, 385).        %% 圣纹升阶
-define(OpenAction_DarkFlame, 386).        %% 暗炎魔装
-define(OpenAction_DarkFlame_Synthetic, 387).        %% 暗炎魔装合成
-define(OpenAction_DemonReward, 389).           %% 恶魔悬赏令
-define(OpenAction_E_Download, 403).                %% E好礼
-define(OpenAction_MobilePhoneBind, 404).           %% 手机绑定
-define(OpenAction_Nationality, 493).               %%  国籍
-define(OpenAction_DirectBuyFund, 502).           %% 直购基金总开关，每个基金的单独开关读配置
-define(OpenAction_GodBless, 504).                 %% 神佑
-define(OpenAction_DragonSeal, 505).               %% 龙神封印
-define(OpenAction_DomainFight, 506).              %% 领地战
-define(OpenAction_Merchant_Ship, 511).         %% 商船
-define(OpenAction_Skill2, 531).            %% 技能突破
-define(OpenAction_Skill3, 532).            %% 技能觉醒
-define(OpenAction_GD_Weapon, 533).          %% 龙神武器
-define(OpenAction_GD_Eq, 534).          %% 龙神圣装
-define(OpenAction_GD_Eq_synt, 535).          %% 龙神圣装合成
-define(OpenAction_GD_Statue_synt, 536).          %% 龙神雕像合成
-define(OpenAction_Dragon_Badge, 537).                     %% 个人荣耀龙徽
-define(OpenAction_Recharge_Packs, 538).         %% 直购礼包
-define(OpenAction_DungeonPetNew, 539).         %% 新魔宠副本(技能挑战)

-define(OpenAction_EqCollect, 551).                     %% 装备收藏
-define(OpenAction_EqReborn, 552).                     %% 装备收藏再生

-define(OpenAction_ExpeditionFight, 571).            %% 普通城战
-define(OpenAction_ExpeditionImperialFight, 572).   %% 皇城战
-define(OpenAction_EXPEDITION_HUNT, 573).    %% 远征猎魔
-define(OpenAction_EXPEDITION_FORCE, 574).    %% 远征强征
-define(OpenAction_Constellation_Gem, 575).    %% 星石镶嵌、星石技能
-define(OpenAction_ExpeditionDemonCome, 578).   %% 远征-巨魔降临
-define(OpenAction_ExpeditionExplore, 579).     %% 远征探险
-define(OpenAction_Expedition_Card, 580).     %% 远征图鉴
-define(OpenAction_Expedition_NOBILITY, 713).   %% 远征爵位

-define(OpenAction_MainlineSeal, 604).                 %% 主线封印
-define(OpenAction_MainlineSeal_Hunter, 605).          %% 主线封印-猎魔大赛
-define(OpenAction_SecKill_Gift, 606).                 %% 秒杀礼包

-define(OpenAction_XunBao_8, 616).                %% 8 神兵寻宝
-define(OpenAction_XunBao_9, 617).                %% 9 神魂寻宝

-define(OpenAction_GD_Weapon_synt, 621).                %% 龙神武器合成
-define(OpenAction_Online_Reward, 622).                     %% 在线时长奖励
-define(OpenAction_DressUp, 638).                     %% 时装
-define(OpenAction_Dh_Season, 640).                     %% 恶魔狩猎季
-define(OpenAction_elite_dungeon, 641).                    %% 精英副本
-define(OpenAction_Pill, 642).                     %% 磕丹
-define(OpenAction_ClientDungeonBless, 645).            %% 循环关祝福系统
-define(OpenAction_SecondRole, 646).            %% 第二职业
-define(OpenAction_ThirdRole, 647).            %% 第三职业
-define(OpenAction_NewBountyTask, 648).                     %% 新赏金任务
-define(OpenAction_NewCard, 650).                     %% 卡片（新图鉴）
-define(OpenAction_TreasureChest, 652).                     %% 战盟宝库
-define(OpenAction_NewCardRecast, 654).                     %% 卡片重铸
-define(OpenAction_Prophecy, 655).                     %% 预言之书 总控
-define(OpenAction_Prophecy1, 656).     %% 预言之书枚举之一（根据配置读取）
-define(OpenAction_King1v1, 659).               %% 新王者1v1
-define(OpenAction_King1v1_Cup, 661).               %% 王者1v1奖杯
-define(OpenAction_NewDailyRecharge, 662).        %% 新每日累充
-define(OpenAction_AwakenRoadBp_1, 663).        %% 觉醒之路战令1
-define(OpenAction_AwakenRoadBp_2, 664).        %% 觉醒之路战令2
-define(OpenAction_AwakenRoadBp_3, 665).        %% 觉醒之路战令3
-define(OpenAction_XunBao_13, 666).        %% 13 宝石寻宝
-define(OpenAction_XunBao_14, 667).        %% 14 卡片寻宝
-define(OpenAction_LevelSeal, 669).               %% 等级封印
-define(OpenAction_LevelSealDungeon, 670).        %% 封印副本

-define(OpenAction_DragonWeapon1, 671).        %% 天神1武器
-define(OpenAction_DragonWeapon2, 672).        %% 天神2武器
-define(OpenAction_DragonWeapon3, 673).        %% 天神3武器
-define(OpenAction_DragonWeapon4, 674).        %% 天神4武器
-define(OpenAction_DragonWeapon5, 675).        %% 天神5武器
-define(OpenAction_DragonWeapon6, 676).        %% 天神6武器
-define(OpenAction_DragonWeapon7, 677).        %% 天神7武器

-define(OpenAction_MonthFinancing_Great, 681).        %% 至尊月理财
-define(OpenAction_recharge_life_card_Great, 682).    %% 至尊终身卡
-define(OpenAction_Server_Seal, 683).    %% 等级封印
-define(OpenAction_DungeonsBless, 684).    %% 天神祝福
-define(OpenAction_RechargeRedEnvelope, 687).    %% 首充红包
-define(OpenAction_FeedBack, 688).    %% 问题反馈
-define(OpenAction_Recharge_Packs_Novice, 689).       %% 直购礼包-新手礼包
-define(OpenAction_Recharge_Packs_Daily, 690).        %% 直购礼包-日礼包
-define(OpenAction_Recharge_Packs_Weekly, 691).       %% 直购礼包-周礼包
-define(OpenAction_Recharge_Packs_Monthly, 692).      %% 直购礼包-月礼包
-define(OpenAction_Recharge_Packs_Treasure, 693).     %% 直购礼包-寻宝礼包
-define(OpenAction_Server_Seal_Contest, 694).    %% 封印比拼
-define(OpenAction_DailyShare, 695).    %% 每日分享
-define(OpenAction_EqPolarity, 696).    %% 装备倾向相关
-define(OpenAction_Bloodline2001, 697).     %% 幽冥血脉 2001
-define(OpenAction_Bloodline2002, 698).     %% 丰饶血脉 2002
-define(OpenAction_Bloodline2003, 699).     %% 自然血脉 2003
-define(OpenAction_Bloodline2004, 700).     %% 狩月血脉 2004
-define(OpenAction_Fazhen, 701).    %% 法阵符文
-define(OpenAction_CareerTower_Main, 728).     %% 宠物塔
-define(OpenAction_CareerTower_1004, 704).     %% 职业塔 战士塔
-define(OpenAction_CareerTower_1005, 705).     %% 职业塔 法师塔
-define(OpenAction_CareerTower_1006, 706).     %% 职业塔 弓手塔
-define(OpenAction_CareerTower_1007, 707).     %% 职业塔 圣职塔
-define(OpenAction_TimeLimitGiftPlus, 708).    %% 限时特惠
-define(OpenAction_DestinyGuard, 711).    %% 天命守护

-define(OpenAction_GreenBless, 714).    %% 蓝钻祈福
-define(OpenAction_GuildInsZones, 715).    %% 公会副本
-define(OpenAction_MysteryShop, 716).    %% 神秘商店
-define(OpenAction_PetAtlas, 717).               %% 魔宠图鉴
-define(OpenAction_PetNormalDraw, 722). %% 宠物普通抽奖
-define(OpenAction_PetSeniorDraw, 723). %% 宠物高级抽奖
-define(OpenAction_PetSubstitutionLow, 724).               %% 宠物低星置换
-define(OpenAction_PetSubstitutionHigh, 725).               %% 宠物高星置换
-define(OpenAction_PetLink, 726).               %% 宠物链接
-define(OpenAction_PetAppendage, 727).               %% 宠物附灵
-define(OpenAction_PetHatch, 729).               %% 宠物孵化
-define(OpenAction_PetHatch2, 732).               %% 宠物孵化2期
-define(OpenAction_Recharge_Packs_Reincarnate, 733).               %% 直购礼包-转生礼包
-define(OpenAction_WeekActive, 734). %% 周活跃通行证
-define(OpenAction_PetShengShu, 735).  %% 英雄圣树
-define(OpenAction_PetBlessEq, 736).  %% 英雄装备
-define(OpenAction_PetCity, 738).  %% 英雄国度
-define(OpenAction_PetBlessEqCast, 739).  %% 英雄装备祝福
-define(OpenAction_CareerTower_Super, 742).  %% 超级塔
-define(OpenAction_DemonHunter, 743).  %% 深渊猎魔
-define(OpenAction_RelicIllusion, 744).  %% 圣物幻化
-define(OpenAction_XunBao_15, 745).        %% 15 黄金寻宝
-define(OpenAction_Recharge_Packs_Expedition, 746).  %% 直购礼包-远征礼包
-define(OpenAction_Recharge_Packs_King1v1, 747).  %% 直购礼包-1v1礼包
-define(OpenAction_King1v1_Cup_Star, 748).        %%1v1 奖杯升星
-define(OpenAction_GD_Eq_Star, 751).            %%神像 圣装升星
-define(OpenAction_PantheonBp, 752).            %% 黄金bp
-define(OpenAction_ReturnOld, 756).            %% 回归-老服
-define(OpenAction_ReinBp, 758).            %% 转生bp
-define(OpenAction_SyBp, 759).            %% 深渊猎魔BP
-define(OpenAction_PetCityBp, 760).    %% 家园BP
-define(OpenAction_PetBlessEqSoulStone, 761).    %% 英雄魂石
-define(OpenAction_GuildWar, 762).        %% 联服公会战

-define(OpenAction_XunBao_16, 763).    %%16 魂石寻宝
-define(OpenAction_PurpleDiamondShop, 772). %% 紫钻商店
-define(OpenAction_Lottery, 773).
-define(OpenAction_Ad_Code_Exchange, 774).    %% 广告码兑换
-define(OpenAction_ExclusiveTotalRecharge, 779).    %% 专属累充
-define(OpenAction_SpecialRecharge, 780).    %% 特惠储值

-define(OpenAction_GuideNotice, 766).        %% 功能预告

-define(OpenAction_DungeonSkillCombat, 775).    %% 战技试炼

-define(OpenAction_PetSacredEq, 776).  %% 英雄圣装
-define(OpenAction_LavaFight, 777).             %% 熔岩角斗场
-define(OpenAction_PetSacredEqBp, 778).  %% 英雄圣装评分BP
-define(OpenActon_wedding, 782).    %% 结婚
-define(OpenAction_WeddingCard, 784).           %% 结婚理财
-define(OpenAction_PetCultivationTransfer, 787).    %% 英雄养成转移

-define(OpenAction_TopBroadcast, 789). %% 播报
-define(OpenAction_PetIllusion, 790). %% 英雄幻化
-define(OpenAction_OnlineAnnounce, 791). %% 上线公告
-define(OpenAction_MainStatue, 792).        %% 主城雕像
-define(OpenAction_URCard, 796).      %% UR卡片
-define(OpenAction_HolyShieldBp, 793).      %% 圣盾bp
-define(OpenAction_DragonWeapon8, 797).        %% 天神8武器-时间之神

-define(OpenAction_FundsGodKing, 798).            %% 神王基金
-define(OpenAction_FundsGodGrand, 799).            %% 神皇基金
-define(OpenAction_FundsShangGu, 805).            %% 上古基金
-define(OpenAction_FundsYuanGu, 806).            %% 远古基金
-define(OpenAction_FundsTaiGu, 807).            %% 太古基金
-define(OpenAction_FundsBuXiu, 808).            %% 不朽基金

-define(OpenAction_shop_cart, 788). %% 商场购物车

-define(OpenAction_ShengJiaBp, 809).       %% 圣甲Bp
-define(OpenAction_PlayerRing, 815).       %% 信物
-define(OpenAction_PetUnknownDraw, 821).    %% 宠物未知抽奖
-define(OpenAction_Pet_Wash, 824).            %%英雄洗髓
-define(OpenAction_Pet_Star, 825).            %%英雄升星
-define(OpenAction_XunBao_17, 823).    %%17 泰坦寻宝
-define(OpenAction_EntityLottery, 826).
-define(OpenAction_DragonWeapon9, 830).  %% 天神9武器-睡神
-define(OpenAction_MondayReward, 849).  %% 周一奖励
-define(OpenAction_GD_Weapon_Star, 850).  %% 龙神武器升星
-define(OpenAction_FwingLevel, 851).  %% 飞翼升级
-define(OpenAction_SkinLottery, 852).

-define(OpenAction_DragonWeapon10, 855).  %% 天神10武器-死神
-define(OpenAction_ClusterWorldLevel, 856).     %% 联服世界等级
-define(OpenAction_DragonWeapon11, 860).  %% 天神11武器-新死神-阿努比斯

-define(OpenAction_AwakenRoadBp_4, 872).        %% 觉醒之路战令4-至尊战令 永恒战令
-define(OpenAction_XunBao_3, 873).    %% 3 坐骑装备寻宝
-define(SocketTimeOut, 1800). %%Socket超时时限

-define(CallTimeOut, 300000). %%CALL等待时长

-define(ETS_GlobalAccount, ets_globalAccount). %%帐号信息表
-record(globalAccount, {
	account = "",            %%帐号名字
	accountID = 0,            %帐号id;
	identity = 0,           %%随机码，需要和登录的进行验证
	platID = 0,             %%渠道编号
	state = 0,              %状态，0：没登录，1：已登录，2：下线
	playerID = 0,           %进入游戏的角色id,
%%	playerPID = 0,          %角色进程PID
	netPID = 0,             %网络进程PID
	time = 0,                %% 更新时间
	enter_server_id = 0,        %% 入口服务器Id，合服后保持原入口
	platID2 = 0,                %渠道子编号
	openID = "",             %%渠道帐号
	isTestAccount = false
}).
-define(GlobalAccount_State_Init, 0).           % 初始化
-define(GlobalAccount_State_OnLine, 1).         % 帐号上线
-define(GlobalAccount_State_OffLine, 2).        % 帐号下线
-define(Account_OffLine_TimeOut, 600).       % 离线最大时长,超过后，清除帐号信息，角色必须走登录服 600秒 10*60


%%Socket连接信息
-define(ETS_Account_Info, ets_Account_Info). %%账号信息
-record(account_Info, {account, playerid, token, pid, time}).

%%Socket连接信息
-define(ETS_InitSocket, ets_InitSocket). %%Socket表(等待通过验证)
-record(globalSocket, {
	socket, pid, time,
	state = 0,            %% 0-初始状态、1-排队状态、2-登录忙碌状态、3-登录空闲状态
	queue_time = 0        %% 排队时间
}).

%% 角色基本信息(只能在最后加字段，不能在中间加)
-record(player, {
	%% 基本信息
	player_id = 0,                              %% 2、唯一ID号
	name = [],                                  %% 3、人物昵称
	sex = 0,                                    %% 4、性别，0-男，1-女
	leader_role_id = 0,                         %% 5、领队角色Id
	level = 1,                                  %% 6、玩家等级
	exp = 0,                                    %% 7、经验值
	language = "",                              %% 8、语言
	energy = 0,                                 %% 9、体力值
	onlineTime = 0,                             %% 10、统计在线时长
	vip = 0,                                    %% 11、VIP等级
	battleValue = 0,                            %% 12、战斗力
	logintime = 0,                              %% 13、最近上线时间
	offlinetime = 0,                            %% 14、最后下线时间
	mapDataID1 = 0,                             %% 15、地图定义ID（当前地图：副本或野图）
	x1 = 0,                                     %% 16、坐标X
	y1 = 0,                                     %% 17、坐标Y
	recharge = 0,                               %% 18、累充元宝
	isOnline = 0,                               %% 19、是否在线
	createTime = 0,                             %% 20、创建时间
	gmLevel = 0,                                %% 21、GM等级
	guildID = 0,                                %% 22、帮派ID
	quitGuildTime = 0,                          %% 23、退出帮派时间（跳帮派的CD）
	skillList = [],                             %% 24、已学技能信息[#playerSkillInfo{}]
	bindSkillInfoList = [],                     %% 25、已装配技能信息[#bindPlayerSkillInfo{}]
	fashionCfgIDList = [],                      %% 26、可见时装配置ID列表
	attrList = [],                              %% 27、玩家属性信息
	downloadProgress = 0,                       %% 28、下载进度
	denyChatTime = 0,                           %% 29、禁言时间
	mapDataID2 = 0,                             %% 30、（上一地图：只存野图）
	x2 = 0,                                     %% 31、坐标X
	y2 = 0,                                     %% 32、坐标Y
	rechargeflag = 0,                           %% 33、玩家首冲标识
	denyState = 0,                              %% 34、封禁状态（0：正常 1：封禁）
	freeVipValue = 0,                           %% 35、赠送的VIP经验值 todo 标记玩家刚被合服，1-是 0-否 ，注意 使用完后会置0
	keepLoginDays = 1,                          %% 36、玩家连续登陆天数
	platId = 0,                                 %% 37、玩家平台号
	titleID = 0,                                %% 38、称号ID
	buff_fixes = [],                            %% 39、Buff修正信息 % todo 废弃
	platInfo = [],                              %% 40、玩家平台信息 [openid,ip,platform]
	lord_ring = [],                             %% 41、魔戒装配信息 {Pos, Uid, CfgId}
	weapon_id = 0,                              %% 42、神兵id
	weapon_vfx = 0,                             %% 43、神兵特效
	weapon_level = 0,                           %% 44、神兵解封等级
	weapon_star = 0,                            %% 45、神兵星级(主体)
	shield_id = 0,                              %% 46、圣盾外显id
	nationality_id = 0,                         %% 47、国籍id
	arenaPlayer = {},                           %% 48、竞技场个人数据#arenaPlayerInfo{} TODO 废弃
	groupFightCountList = [],                   %% 49、组挑战次数列表
	dungeonLocal = {},                          %% 50、单人副本信息
	actionHint = [],                            %% 51、功能提示信息
	fahuoList = [],                             %% 52、发货
	military_rank = 1,                          %% 53、军衔
	levelGift = [],                             %% 54、等级礼包
	dungeonChapterList = [],                    %% 55、通用副本章节信息
	dungeonSecretList = [],                     %% 56、妖魔莱西副本信息列表
	battlefield = #battlefieldData{},           %% 57、三界战场数据
	account = "",                               %% 58、账号
	salesRecharge = [],                         %% 59、保存销售活动充值数据
	salesLogin = [],                            %% 60、保存销售活动登陆数据
	exchange = [],                              %% 61、运营活动兑换活动[#playerExchange{}]
	topActivityList = [],                       %% 62、精彩活动排行榜玩家数据[#playerActivityInfo{}]
	fromserverid = 0,                           %% 63、入口服务器Id，合服后保持原入口
	ashuraData = {},                 %% 64、修罗战场数据（废弃）
	wingCfgID = 0,                              %% 65、佩戴神翼ID
	fwinglevel = 0,                             %% 66、飞翼等级
	artiCfgIDList = [],                         %% 67  穿戴的装备列表  [{eqcfgid, stage}]
	dailyTopList = [],                          %% 68、庆典排行榜玩家数据[#playerDailyTop{}]
	res_point = 0,                              %% 69、资源点
	worldEvent = [],                            %% 70、全服离线事件
	guard_id = 0,                               %% 71、守护ID
	deny_to_time = 0,                           %% 72、封号到这个时间
	ancient_holy_eq_id = 0,                     %% 73、古神圣装最低品质装备id
	ancient_holy_eq_enhance_level = 0,          %% 74、古神圣装最低强化等级
	head_id = 0,                                %% 75、头像id
	frame_id = 0,                               %% 76、头像框id
	age = 0,                                    %% 77、年龄
	rein_lv = 0,                                %% 78、转生等级
	recharge_price = 0,                         %% 79、充值金额（对应地区货币金额*100）
	return_pos_list = []                        %% 80、返回地图需要回到离开位置的地图[{MapDataID,X,Y}]
}).

%% 玩家子表，主要存储非常频繁更新的数据
%% 向#player同步时机(用于镜像数据访问)
%% 1.每次玩家tick时如果发生过变化 2.#player 触发保存时
-record(player_sub, {
	player_id = 0,                              %% 玩家id
	exp = 0,                                    %% 经验值
	battleValue = 0                             %% 战斗力
}).
-define(PlayerSubPos, [{#player.exp, #player_sub.exp}, {#player.battleValue, #player_sub.battleValue}]).

%% 角色
-record(role, {
	player_id = 0,                              %% 2.玩家Id
	role_id = 0,                                %% 3.角色Id
	career = 0,                                 %% 4.职业
	create_time = 0,                            %% 5.创建时间
	skillList = [],                             %% 6.已学技能信息[#playerSkillInfo{}]
	bindSkillInfoList = [],                     %% 7.已装配自动技能信息[#bindPlayerSkillInfo{}]
	eq_cfg_list = [],                           %% 8.穿戴装备列表
	attr_title_id = 0,                          %% 9.属性佩戴称号ID
	show_title_id = 0,                          %% 10.显示佩戴称号ID
	guard_id = 0,                               %% 11.装备的守护ID
	mount_id = 0,                               %% 12.装配的坐骑ID
	wing_id = 0,                                %% 13.装配的翅膀ID
	holy_id = 0,                                %% 14.装配的圣物ID
	dragon_id = 0,                              %% 15.装配的龙神ID
	battle_value = 0,                           %% 16.角色战斗力
	career_lv = 0,                              %% 17.角色转职等级
	buff_fixes = [],                            %% 18.buff修正信息
	lord_ring = [],                             %% 19.魔戒装配信息 [{Pos, Uid, CfgId}]
	bindSkillInfoListByHand = [],               %% 20.已装配手动技能信息[#bindPlayerSkillInfo{}]
	hair_color = 0,                             %% 21.发色索引
	skin_color = 0,                             %% 22.肤色索引
	height = 0,                                 %% 23.身高百分比
	fashion_id_list = [],                       %% 24.时装ID列表
	fashion_color = 0,                          %% 25.时装颜色 <<头部颜色:8, 衣服颜色1:8, 衣服颜色2:8, 预留:8>>
	tattoo = 0,                                 %% 26.纹身索引
	tattoo_color = 100,                         %% 27.纹身透明度
	is_show_helmet = 0,                         %% 28.是否不展示头盔 1-是 0-否
	weapon_list = [],                           %% 29.穿戴的神兵 [{神兵id,神兵特效,神兵解封等级,神兵阶数,神兵星级}]
	is_show_weapon = 1                          %% 30.是否展示神兵 1-是 0-否
}).

%% 玩家信息
-record(r_player_other, {
	player_id = 0
	, hunt_phy_value = 0 %% 猎魔体力值
	, hunt_recover_time = 0 %% 上次恢复时间
	, hunt_lv = 0 %% 猎魔等级
	, use_force_times = 0 %% 今日已使用的强征次数
	, challenge_time = 0        %% 今日挑战特殊BOSS次数
	, rank_pass_time = 0  %% 今日挑战特殊BOSS最短耗时
	, rank_pass_time_yesterday = 0    %% 昨天挑战特殊BOSS最短耗时
}).

%% 条件复活玩法定义
-define(Reborn_Index_Demons, 1).   %% 天魔Boss


-define(ETS_PlayerOnLine, ets_playerOnLine). %角色在线公共信息
%%角色在线公共信息表
-record(playerOnLine, {
	id = 0,                 %%角色ID
	pid = 0,                %%角色进程process id
	account = "",            %%帐号
	is_connected = ?TRUE,  %%是否有网络连接
	map_data_id = 0,        %%所在地图定义ID
	map_id = 0,             %%地图实例ID
	map_pid = 0,            %%地图进程ID
	line = 0,               %%地图线号
	sex = 0,
	level = 0,              %%等级
	guildID = 0,             %%帮派
	quitGuildTime = 0,        %% 退帮时间
	friendsCount = 0,        %% 好友数量
	battleValue = 0,            %%战斗力
	isRename = 0,                %%是否已改名
	friendsIDList = [],         %% 好友ID列表
	blackIDList = [],           %% 黑名单ID列表
	inviteIDList = [],          %% 邀请ID列表
	%%----玩家简要外观信息----
	name = "",                    %%名字
	leader_role_id = 0,                %% 领队角色Id
	career = 0,                 %% 职业
	vip = 0,                    %%VIP等级
	title = 0,                    %%称号ID
	head_id = 0,                %% 头像id
	frame_id = 0,                %% 头像框id
	funcList = [],              %% 功能开放列表
	enter_server_id = 0,        %% 入口服务器Id，合服后保持原入口
	military_rank = 0               %% 军衔
}).


-record(chat, {receiverID = 0, chatID = 0, chatInfo = {}}).
-record(gmAsk, {playerID = 0, id = 0, askContent = "", askTime = 0,
	answerGM1 = "", answerContent1 = "", answerTime1 = 0,
	answerGM2 = "", answerContent2 = "", answerTime2 = 0,
	answerGM3 = "", answerContent3 = "", answerTime3 = 0,
	state = 0, updateTime = 0}).


-define(ETS_MapRecCfg, ets_mapreccfg).    %%地图资源表
%%-define(ETS_MapCfg, ets_mapcfg).    %%地图信息表
%%-define(ETS_MapMonster, ets_monster).    %%怪物实例化
-define(ETS_MapNpc, ets_npc).             %%地图Npc


%% 平台发放物品
-record(platform_senditem, {id, levelMin, levelMax, itemList, coinList, exp, flag, timeBegin, timeEnd, title, content}).
-define(PLATFORM_SENDITEM_FLAG_INVALID, 0).
-define(PLATFORM_SENDITEM_FLAG_VALID, 1).


%% -----------------------开心翻牌错误反馈-----------------------

%%地图实例
-define(ETS_MapObject, ets_MapObject). %%地图实例表
-record(mapObject, {
	id = 0,               %%实例ID 构成map_data_id*10000+LineID
	map_data_id = 0,      %%地图id;
	line = 0,             %%线号,最大1000
	owner_id = 0,         %%所有者ID
	pid = 0,              %%地图进程ID
	players = [],         %%玩家列表{playerid,playerPID}
	time = 0,             %更新时间(地图创建时间)
	enterAble = 1,            %%地图是否能够进入（例如已结算的地图，不能进入）
	mapType = 0,               %%地图类型
	mapAI = 0,               %%地图子类型（副本类型）
	prePlayerIDlist = []    %%申请进入此地图的玩家ID列表
}).

-define(ETS_MapPlayerCluster, ets_mapPlayerCluster). %% 非本服地图玩家属性缓存
-record(mapPlayerCluster, {player_id, mapPlayer, time}).

-record(map_pet, {
	object_id = 0
	, pet_id = 0 %% 宠物配置ID
	, pet_star = 0 %% 宠物星级
	, pet_grade = 0 %% 宠物品级
	, pet_pos = 0 %% 宠物位置
	, pet_lv = 0
	, pet_sp_lv = 0 %% sp英雄战阶等级
	, been_link_pet_cfg_id = 0
	, been_link_pet_sp_lv = 0
	, illusion_id = 0
	, is_fight = 0 %% 是否参战
	, been_link_uid = 0
}).

%%玩家在地图上的属性
-record(mapPlayer, {
	id = 0,
	name = "",
	pid = 0,                                %%角色进程ID
	conn_pid = 0,                            %% 玩家连接进程PID
	%netpid = 0,                                %%角色网络进程ID
	level = 0,
	sex = 0,
	career = 0,                             %% 职业
	language = "",                          %% 语言
	showHud = ?FALSE,
	headID = 0,                            %% 头像ID
	frameID = 0,                            %% 头衔框
	group = 0,                              %% 阵营ID
	fashionCfgIDList = [],                  %% 可见时装配置ID列表
	equipCfgIDList = [],                    %% 可见装备配置ID列表
	eq_list = [],
	wingCfgID = 0,                          %% 佩戴神翼ID
	buff_fixes = [],                        %% Buff修正信息 % todo 废弃
	own_monsters = [],                      %% 拥有怪物列表
	initPosX = 0,                           %% 保存原主城位置信息，作为出生点
	initPosY = 0,                           %% 保存原主城位置信息，作为出生点
	titleID = 0,                            %% 称号ID
	guildID = 0,                            %% 帮派ID
	pkGroup = 0,                            %% PK阵营，战斗阵营
	collectionID = 0,                        %% 采集物ID
	mountDataID = 0,                        %% 展示坐骑配置ID，为0表示该位置没有坐骑
	mountStar = 0,                            %% 展示坐骑星数
	mountMaxSpeed = 0,                      %% 坐骑最大速度
	mountStatus = 0,                        %% 骑乘状态
	mountSpeed = 0,                        %% 骑乘前的速度
	battleStatus = 0,                    %% 战斗状态
	vip = 0,                                %% 生效VIP等级
	meleeQuality = 0,
	serverID = 0,
	enter_server_name = "",
	serverWorldLevel = 0,
	battleValue = 0,
	guildName = "",
	guildRank = 0,
	guild_bv = 0,
	sutraDataIDList = [],
	officeType = 0,
	office = 0,
	fwinglevel = 0,                        %% 飞翼等级
	honor_lv = 0,                            %%	头衔等级
	pet_infos = [],                            %% 出战宠物 [#map_pet{}]
	gd_id = 0,                                %% 主战的龙神id
	isMaxFatigue = ?FALSE,                %% 达到疲劳度上限
	drop_task_list = [],                    %% 掉落任务列表
	func_list = [],                        %% 开放功能列表
	hang_dungeon_id = 0,                    %% 挂机的副本ID（0表示未挂机）
	weapon_id = 0,                        %% 神兵id
	weapon_vfx = 0,                        %% 神兵特效
	weapon_level = 0,                    %% 神兵阶数
	weapon_star = 0,                        %% 神兵星级
	nationality_id = 0,                    %% 国籍id
	open_id = 0,                            %% 平台ID
	ip = "",                                %% 玩家IP
	platform = "",                        %% 渠道ID
	shield_id = 0,                        %% 圣盾外显id
	military_rank = 0,                    %% 军衔
	border_season = 1,                    %% 玩家边境入侵赛季
	ancient_holy_eq_id = 0,                %% 古神圣装最低品质装备
	ancient_holy_eq_enhance_level = 0,        %% 古神圣装最低强化等级
	helper_seeker = {},                    %% 协助-{求助者角色id,协助bossID}
	helper_list = [],                    %% 协助-协助者列表
	drop_sp_list = [],                    %% 特殊掉落组
	sj_level = 0,                        %% 圣甲等级
	element_attr = [],                    %% 元素属性
	dark_point = 0,                        %% 暗炎值
	leader_role_id = 0,                     %% 领队角色Id
	control_role_id = 0,                    %% 控制角色Id（客户端使用）
	mapRoleList = [],                       %% 地图角色列表
	task_item_list = [],                    %% 任务掉落限制数
	demon_param = {},                        %% 打宝挑战参数 {挑战倍数，疲劳，额外疲劳}
	rune_score = 0,                            %% 符文评分
	eq_drop_fix_list = [],                     %% 装备掉落填空转换记录
	eq_career_drop_fix_list = [],                %% 装备职业掉落转换记录
	mate_id = 0,                            %% 伴侣id
	mate_name = "",                         %% 伴侣名
	%% ================== 机器人专用 ==================
	robot_bornX = 0,
	robot_bornY = 0,
	robot_activateTime = 0,                %% 激活时间
	robot_recoverTime = 0,                    %% 复活时间
	robot_watchRadius = 0,                    %% 视野半径（当前点）
	robot_patrolRadius = 0,                %% 巡逻半径（出生点）
	robot_followRadius = 0                    %% 追击半径（出生点）
}).

%% 地图角色
-record(mapRole, {
	player_id = 0,                              %% 玩家Id
	role_id = 0,                                %% 角色Id
	career = 0,                                 %% 职业
	look_eq_list = [],                          %% 可见装备列表
	mount_id = 0,                               %% 坐骑id
	mount_star = 0,                             %% 坐骑星数
	wing_id = 0,                                %% 翅膀id
	guard_id = 0,                               %% 守护id
	holy_id_list = [],                          %% 圣物id列表
	battle_value = 0,                           %% 角色战斗力
	turn = 0,                                   %% 出战顺序
	enable = 0,                                 %% 是否可用 0-否 1-是
	create_time = 0,                            %% 角色创建时间
	buff_fixes = [],                            %% buff修正信息
	title_id = 0,                               %% 称号ID
	honor_lv = 0                                %% 头衔等级
	, atk_pos = 0                                %% 进攻站位
	, def_pos = 0,                                %% 防守站位
	fashion_id_list = [],                        %% 时装ID列表
	hair_color = 0,                            %% 发色索引
	skin_color = 0,                            %% 肤色索引
	height = 0,                                %% 身高百分比
	fashion_color = 0,                            %% 时装颜色 <<头部颜色:8, 衣服颜色1:8, 衣服颜色2:8, 预留:8>>
	tattoo = 0,                                    %% 纹身索引
	tattoo_color = 0,                            %% 纹身颜色
	is_show_helmet = 0,                           %% 是否不展示头盔 1-是 0-否
	is_fly = 0,                                    %% 飞翼是否激活 1-是 0-否
	weapon_list = [],                           %% 穿戴的神兵 [{神兵id,神兵特效,神兵解封等级,神兵阶数,神兵星级}]
	is_show_weapon = 1,                            %% 是否显示神兵 1-是 0-否
	eq_pos_info = []                           %% 装备位置信息 [{部位,阶数,品质}]
}).

%%npc实例
-record(mapNpc, {
	id = 0,                                 %%实例ID
	data_id = 0,                            %%定义ID
	res_id = 0,                            %%资源ID
	type = 0,                               %%类型
	npcType = 0,                            %% NPC类型（0：普通NPC 1：迎亲队伍NPC）
	rotw = 0,                               %旋转坐标W
	talk = 0,                               %%对话（暂不用）
	status = 1,                             %%状态0:关闭，1：显示
	callbackfun                             %%回调涵数
}).

%%monster实例
-record(mapMonster, {
	id = 0,                     %%怪物实例ID
	res_id = 0,                 %%资源ID
	data_id = 0,                %%怪物定义id
	owner_type = 0,             %%所属组
	owner_id = 0,               %%%所属ID
	attach_owner_id = 0,        %% 附着怪所属ID
	bornPosIndex = 0,                 %%出生的位点
	bornX = 0,                      %%出生坐标X
	bornY = 0,                       %%出生坐标Y
	activateTime = 0,                %% 激活时间
	rotw = 0,                    %旋转坐标W
	group = 1,                   %%阵营ID
	groupBorn = 1,                   %%原始阵营ID
	recoverTime = 0,             %%复活时间 0：不复活
	aiState = ?TRUE,                %% 怪物AI开关
	friendPlayerList = [],             %%友方玩家ID列表
	waypt = [],                  %%路点
	guildID = 0,                 %%所属仙盟ID
	stumpList = [],
	index = 1, %% 刷怪波数、刷怪序号
	level = 1, %% 等级
	battleValue = 1, %% 战斗力
	hpCount = 1, %% 血管数
	attribute = [], %% 战斗属性  TODO 废弃
	monster_exp = [], %% 经验参数
	drop_owners = [],
	skill_use = [],  %% 技能使用记录 {role_id,skill_id}
	skill_replace = 0, %% 技能是否被替换 1-是 0-否
	monster_type = 0   %% 同 #monsterBaseCfg.monsterType
}).

%% 采集物类型
-define(CollectionType_Pantheon, 2).    %% 战神殿采集物
-define(CollectionType_HolyRuins, 3).   %% 星空圣墟采集物
-define(CollectionType_HolyWar, 4).     %% 圣战遗迹采集物
-define(CollectionType_ElementTrial, 5).%% 元素试炼采集物
-define(CollectionType_GuildWar, 6).    %% 联服公会战采集物

%% 采集物实例
-record(mapCollection, {
	id = 0,                     %% 实例ID
	dataID = 0,                 %% 配置ID
	rotw = 0,                   %% 旋转坐标W
	state = 0,                  %% 状态：0-空闲、1-采集
	startPlayerID = 0,          %% 采集者ID，采集状态有效
	startPlayerName = "",       %% 采集者ID，采集状态有效
	startTime = 0,              %% 开始采集时间，采集状态有效
	survivalTime = 0,           %% 存活到的时间  为0表示不消失
	stopTime = 0,               %% 结束采集时间，采集状态有效
	creatorID = 0,
	type = 0,                   %% 采集物类型(0:无 1:婚礼采集物 2:战神殿采集物)
	isMulti = false,        %% 以下为多人采集相关
	collectTimes = 0,        %% 多人采集次数
	dec_interval = 0,          %% 扣血间隔
	dec_per = 0,            %% 扣血万分比(当前血量）
	param = 0,                 %% 参数(婚车掉落宝箱为婚礼巡游配置ID, 战神殿宝箱等级1：高级 2：低级）
	collectInfo = [],         %% 玩家id, 开始采集时间, 结束采集时间
	collectPidList = [],    %% 采集成功的玩家ID
	owner_id = 0              %% 可见玩家ID  深渊角斗场使用
}).


%% 传送门实例
-record(mapTeleporter, {
	id = 0,                     %% 实例ID
	dataID = 0,                 %% 配置ID
	rotw = 0,                   %% 旋转坐标W
	expireTime = 0              %% 过期时间
}).

%% Buff球实例
-record(mapBuffObject, {
	id = 0,                     %% 实例ID
	dataID = 0,                 %% 配置ID
	expireTime = 0,             %% 过期时间
	is_reborn = false,            %% 是否死亡不消失
	belong_id = 0                %% 归属id
}).

%% 镖车实例
-record(mapVehicle, {
	id = 0,                 %% 实例ID
	data_id = 0,            %% 配置ID
	bornX = 0,              %% 出生坐标X
	bornY = 0,              %% 出生坐标Y
	owner_id = 0,           %% 所属ID
	owner_name = "",        %% 所有者名字
	owner_type = 0,         %% 所属组
	group = 1,              %% 阵营ID
	guildID = 0,            %% 仙盟ID
	type = 0,               %% 类型 1：个人镖车 2：新娘婚车 3：婚礼牛车
	player_list = [],       %% 玩家ID列表
	limitTime = 0,          %% 消失时间
	attackedTime = 0,       %% 被攻击时间
	skillType = 1,           %% 技能类型（根据血量变化）
	serverID = 0
}).


-record(mapTomb, {
	bossID = 0,                 %% 怪物配置ID
	serverName = "",
	name = "",                   %% 击杀者名字
	deadTime = 0                %% 死亡时间
}).

%%MachineTrap实例
-record(mapMachineTrap, {
	id = 0,                     %%怪物实例ID
	res_id = 0,                 %%资源ID
	data_id = 0,                %%怪物定义id
	hp = 0,                     %%机关血量
	att_cd = 0,                 %%冷确CD
	stat = 0,                   %%机关状态 0：关闭，1：打开，2:死亡， 3：僵尸
	group = 1,                  %%阵营ID
	object_list = [],           %%对象ID列表,
	rotw = 0,                   %旋转坐标W
	guildID = 0,                %%所属仙盟ID
	tombInfo = #mapTomb{}      %%Boss墓碑信息
}).


%%玩家镜像在地图上的属性
-record(mapMirrorPlayer, {
	id = 0,
	name = "",                               %%镜像的角色名字
	owner_id = 0,                            %%被镜像角色ID
	owner_pid = 0,                             %% 拥有者PID
	level = 0,                               %%镜像角色等级
	sex = 0,                                 %%镜像角色性别
	career = 0,                              %%职业
	showHud = ?FALSE,
	titleID = 0,                             %% 称号ID
	guildID = 0,                             %% 帮派ID
	headID = 0,                             %% 头像ID
	group = 0,                               %% 阵营ID
	fashionCfgIDList = [],                   %% 可见时装配置ID列表
	eq_list = [],                             %% 可见装备配置ID列表
	wingCfgID = 0,                         %% 佩戴神翼ID        %% todo 废弃
	battleValue = 1,                         %% 战斗力
	pkGroup = 0,                             %% PK阵营，战斗阵营
	vip = 0,                                 %% VIP
	sutraDataIDList = [],
	call_player_id = 0,                      %% 召集玩家的ID
	guildName = "",
	guildRank = 0,
	pet_infos = [],                            %% 出战宠物 [#map_pet{}]
	weapon_id = 0,                         %% 装配的神兵id
	weapon_vfx = 0,                         %% 装配的神兵特效
	weapon_level = 0,                     %% 装配的神兵阶数
	weapon_star = 0,                         %% 装配的神兵星级
	nationality_id = 0,                     %% 国籍id
	shield_id = 0,                         %% 圣盾外显id
	ancient_holy_eq_id = 0,                 %% 古神圣装最低品质装备配置id
	ancient_holy_eq_enhance_level = 0,         %% 古神圣装最低强化等级
	leader_role_id = 0,                     %% 领队角色Id
	control_role_id = 0,                    %% 控制角色Id（客户端使用）
	mapRoleList = [],                       %% 地图角色列表
	frame_id = 0,                            %% 头像框id
	server_id = 0,                            %% 服务器id
	server_name = ""                            %% 服务器名
	, bind_skill_list = [],                        %% [{RoleID,BindList}]
	sj_level = 0                             %% 圣甲等级
}).

%%待进入地图信息
-record(requestEnterMap, {
	cluster_gameplay,
	id = 0,                         %%地图实实例ID
	map_data_id = 0,                %%地图数据ID
	map_pid = 0,                    %%地图进程ID
	line = 0,                        %%线号
	x = 0,                                                    %%X坐标
	y = 0,                                                    %%Y坐标
	params = {},                        %%附加信息
	needCost = false,
	groupid = 0,                        %%预先指定的阵营ID
	isDirectLoading = ?FALSE,        %%是否不用等所有人LOADING完毕
	isServerRequest = 0        %% 是否是后端发起的请求：0-前端发起、1-后端发起
}).

%%玩家进入地图的信息
-record(playerEnterMap, {
	cluster_gameplay,
	id = 0,                     %%地图实实例ID
	map_data_id = 0,            %%地图数据ID
	map_pid = 0,                %%地图进程ID
	map_ai = 0,                 %%地图type ai
	line = 0,                   %%线号
	time = 0                    %%进入时间
}).

%% 玩家切图需要继承的信息
%% TODO 目前针对切线怒气的继承 后期处理类似切线保留鼓舞buff等信息
-record(map_extend_data, {
	map_data_id = 0,            %% 地图数据ID
	map_ai = 0,                    %% 同类型地图切线
	rage = 0                    %% 线号
}).

%%对象坐标
-record(objectPos, {
	id = 0,                                 %%实例ID
	x = 0,                                  %%位置X
	y = 0,                                   %%位置Y
	type = 0,                                 %% 实例类型
	is_viewer = ?FALSE                       %% 是否观战
}).


%% -------------------------活动ID 定义------------------
-define(Activity_Signin, 1).    %%签到奖励
-define(Activity_Login, 2).     %%登陆奖励
-define(Activity_Funds, 3).     %%成长基金
-define(Activity_LevelGift, 4). %%等级礼包
-define(Activity_HappyCard, 5). %%开心翻牌
-define(Activity_MonthCard, 6). %%月卡系统
-define(Activity_ActiveCode, 7).%%激活码功能
-define(Activity_Recharge, 8).  %%首冲
-define(Activity_VipGift, 9).  %%vip礼包
-define(Activity_ActionHint, 10).   %%功能提示
-define(Activity_GMOrder, 11).  %% GM命令图标
-define(Activity_SalesActive, 12).  %% 后台活动
-define(Activity_SumRecharge, 13).  %% 累充奖励
-define(Activity_Top, 14).       %% 排行榜
-define(Activity_PhoneBind, 15). %% 手机绑定
-define(Activity_ShopGift, 16). %% 商城-礼包分页
-define(Activity_ShopXF, 17). %% 商城-仙坊分页
-define(Activity_NexDayAward, 18).  %% 次日奖励
-define(Activity_ChatVoice, 19).    %% 语音翻译 (客户端使用世界变量判断)
-define(Activity_DayRecharge, 20).  %% 每日充值
-define(Activity_QQVIP, 24).    %% QQ送会员
-define(Activity_QQVIP_SP, 25).    %% QQ会员特权
-define(Activity_ManorWar, 26). %% 领地图标
-define(Activity_Roulette, 27). %% 转盘
-define(Activity_Carnival, 28). %% 嘉年华
-define(Activity_DayPayAward, 29). %% 老版天天乐
-define(Activity_RebateItem, 30). %% 新版天天乐
-define(Activity_DungeonLove, 31).  %% 七夕副本
-define(Activity_TimeLimitGift, 32).  %% 限时折扣
-define(Activity_ConnectShareServer, 33).  %% 连接跨服
-define(Activity_Share, 34).    %% 分享
-define(Activity_VPlus, 35).    %% V+礼包
-define(Activity_CroFightRing, 36). %% 跨服比武
-define(Activity_Melee, 37). %% 麒麟洞
-define(Activity_Ashura, 38). %% 修罗战场
-define(Activity_Darts, 39).    %% 飞镖
-define(Activity_ThreeHeaven, 40).    %% 三重天
-define(Activity_WorldLevel, 41).    %% 世界等级
-define(Activity_CoupleFight, 43).    %% 2v2
-define(Activity_ConsignBank, 44).    %% 跨服寄售行开关
-define(Activity_Demons, 45).   %% 天魔入侵
-define(Activity_ShareDemons, 46).  %% 天魔远征
-define(Activity_FreeEnergy, 47).  %% 龙城盛宴
-define(Activity_PreDeposits, 58).  %% 矮人宝藏
-define(Activity_depositsEx, 59).  %% 精灵宝库
-define(Activity_GDragon, 62).  %% 龙神秘典副本
-define(Activity_Attainment, 68).  %% 成就
-define(Activity_ObsidianBook, 69).  %% 预言之书日曜
-define(Activity_GuardBook, 70).  %% 预言之书守护
-define(Activity_RuinBook, 71).  %% 预言之书毁灭
-define(Activity_SlayerBook, 72).  %% 预言之书屠魔
-define(Activity_DivineBook, 73).  %% 预言之书神力
-define(Activity_flower, 75).    %% 组队
-define(Activity_Convoy, 79).   %% 护送龙晶
-define(Activity_DungeonArti, 80). %% 个人恶魔
-define(Max_Activity_Num, 80).  %% 活动ID最大值
%% -------------------------活动ID 定义 end--------------

-define(ReadyLoginUserTableAtom, 'readyLoginUserTableAtom').

-define(ETS_MarqueeAnnounce, ets_MarqueeAnnounce).
-record(marquee, {
	announceID = 0,     %% 公告ID(自动生成)
	type = 2,           %% 类型(1:登陆公告 2:走马灯 默认为走马灯)
	announce = "",      %% 内容
	startTime = 0,      %% 播放时间(0:表示即时播放)
	endTime = 0,        %% 结束时间(仅登陆公告可用)
	playTimes = 1,       %% 播放次数
	interval = 0,        %% 间隔时间(秒)
	lastTime = 0        %% 上次播放时间
}).

-define(OpenFunc_TargetType_ReceiveTask, 1).    %% 接受任务
-define(OpenFunc_TargetType_CompleteTask, 2).   %% 完成任务
-define(OpenFunc_TargetType_PassDungeon, 4).    %% 通关关卡
-define(OpenFunc_TargetType_ServerDays, 5).    %% 开服天数
-define(OpenFunc_TargetType_Level, 7).            %% 等级
-define(OpenFunc_TargetType_ChangeRole, 13).    %% 转职等级
-define(OpenFunc_TargetType_LordRing, 14).    %% 获得魔戒
-define(OpenFunc_TargetType_VipLv, 15).        %% vip等级
-define(OpenFunc_TargetType_Mount, 16).            %% 获得坐骑
-define(OpenFunc_TargetType_Wing, 17).            %% 获得翅膀
-define(OpenFunc_TargetType_Pet, 18).            %% 获得宠物
-define(OpenFunc_TargetType_GDragon, 19).        %% 获得龙神
-define(OpenFunc_TargetType_GDWeapon, 20).        %% 获得龙神武器
-define(OpenFunc_TargetType_GDElf, 21).            %% 获得精灵龙神
-define(OpenFunc_TargetType_Holy, 22).            %% 获得圣物
-define(OpenFunc_TargetType_Guard, 23).            %% 获得守护
-define(OpenFunc_TargetType_WorldLv, 24).          %% 世界等级
-define(OpenFunc_TargetType_ClusterStage, 25).     %% 联服阶段
-define(OpenFunc_TargetType_Weapon, 26).            %% 激活神兵
-define(OpenFunc_TargetType_Ornament, 27).          %% 获得海神套装
-define(OpenFunc_TargetType_MountEq, 28).           %% 获得坐骑装备
-define(OpenFunc_TargetType_PetEq, 29).             %% 获得宠物装备
-define(OpenFunc_TargetType_WingEq, 30).            %% 获得翅膀装备
-define(OpenFunc_TargetType_AstEq, 31).             %% 获得神灵装备
-define(OpenFunc_TargetType_GdEq, 32).              %% 获得龙饰装备
-define(OpenFunc_TargetType_Ring, 33).              %% 激活信物
-define(OpenFunc_TargetType_God, 34).              %% 激活神灵
-define(OpenFunc_TargetType_WearEq, 35).            %% 穿戴主角装备
-define(OpenFunc_TargetType_WearGseaEq, 36).       %% 穿戴海神套装
-define(OpenFunc_TargetType_MountEq1, 37).           %% 坐骑装备
-define(OpenFunc_TargetType_PetEq1, 38).             %% 魔宠装备
-define(OpenFunc_TargetType_WingEq1, 39).            %% 翅膀装备
-define(OpenFunc_TargetType_Reincarnate, 40).        %% 转生等级
-define(OpenFunc_TargetType_ClientDungeon, 41).        %% 通过循环关卡
-define(OpenFunc_TargetType_EnterClientDungeon, 42).        %% 进入循环关卡
-define(OpenFunc_TargetType_AwakenRoadReward, 43).        %% 觉醒之路领奖
-define(OpenFunc_TargetType_LeveSealStage, 44).        %% 等级封印情况
-define(OpenFunc_TargetType_RechargeFirst, 45).        %% 首充
-define(OpenFunc_TargetType_Equip, 46).        %% 穿戴装备
-define(OpenFunc_TargetType_MountSoul, 47).        %% 坐骑灵等级
-define(OpenFunc_TargetType_WingSoul, 48).        %% 翅膀灵等级
-define(OpenFunc_TargetType_ClusterGroup, 49).        %% 联服组阶段
-define(OpenFunc_TargetType_GetSpPet, 50).        %% 获得任意xx个不同ID的xx品质的英雄，参数1=品质（例如：3为SSR，4为SP，5为UR...），参数2=数量
-define(OpenFunc_TargetType_BuyLifeCardTime, 51).        %% 终身卡购买之后，多少分钟，参数1=分钟
-define(OpenFunc_TargetType_CareerTowerMain, 52).        %% 英雄塔层数
-define(OpenFunc_TargetType_RuneScore, 53).            %% 符文评分
-define(OpenFunc_TargetType_PetLv, 54).            %% 英雄等级
-define(OpenFunc_TargetType_MonthCard, 55).        %% 购买月卡
-define(OpenFunc_TargetType_CardNum, 57).   %% 获得XX张XX品质的卡片，参数1 = 数量  参数2 = 品质
-define(OpenFunc_TargetType_GoldEqEquipNum, 56).   %% 穿戴x件y品质Z星级的黄金装备开启
-define(OpenFunc_TargetType_GDragon2, 58).   %% 激活xx神像开启 参数1 = 神像id
-define(OpenFunc_TargetType_PetIllusionNum, 59).   %% 获得一个英雄幻化道具

-define(OpenFunc_TargetType_ExpeditionSeason, 61).   %% 远征赛季达到第X赛季开启功能
-define(OpenFunc_TargetType_PetBlessEqNum, 62).        %% 装配多少件对应品质的幻彩装备 参数1 数量  参数2 品质    品质向下兼容

%%月卡类型
-define(MonthCard_Type_Free, 1).   %% 免费月卡类型
-define(MonthCard_Type_Gene, 2).   %% 普通月卡类型
-define(MonthCard_Type_Extr, 3).   %% 至尊月卡类型
-define(MonthCard_Type_Fore, 4).   %% 永久月卡类型


%%请求进入地图的请求参数
-record(requestEnterMapParam, {
	cluster_gameplay,
	mapUID = 0,%%直接请求进入某个地图ID
	mapPid = 0, %%如果有该值，则尝试进入改地图
	requestID = 0, %%地图配置id
	lineNum = 0,
	params = {},%%副本的DungeonID关卡ID默认放在第一个元素
	groupID = 0,
	mapOwnerID = 0,
	transmission_index = 0,%%传送阵id
	isDirectLoading = ?FALSE,
	isReconnect = ?FALSE,        %%是否是重连
	isForce = ?FALSE,
	isServerRequest = 0,        %% 是否是后端发起的请求：0-前端发起、1-后端发起
	reason_content = ""         %% 进入原因
}).

%%地图额外参数（整理，现有副本、野外地图）对个人而言
-record(mapParams, {
	mapAIType = 0,%%地图子类型
	dungeonID = 0,%%副本为关卡ID
	manorID = 0,%%领地地图时为领地ID
	teamEnterType = 0,%%组队副本默认进入方式0:任意
	playerID = 0,%%1V1比武表示自己
	targetID = 0,%%1V1比武表示对手；掠夺表示目标玩家ID；竞技场表示对手
	fight_id = 0,
	isGM = ?FALSE,%%是否是用GM进入地图
	guildID = 0,%%仙盟副本 仙盟ID
	activeEnterType = 1,%%活动副本默认进入方式1:使用次数和体力
	playerEnterTime = 0,%%玩家进入地图的时间戳，现在用于副本的单人时间计时结算
	vehicle_owner = 0,%% 镖车所属玩家ID
	playerCount = 0,    %% 挑战副本人数
	isDecCost = ?TRUE,%%外界可干预是否扣除，比如重复进入，则不再次扣除
	bride_id = 0,   %% 新娘ID
	loveTaskPos = {},
	activeExtendProgress = 0,
	mergeTimes = 1, %% 合并挑战次数
	assistant = ?FALSE, %% 是否助战
	isMaxDemonMap = ?FALSE,  %% 是否是天魔Boss限制的最大地图 todo del
	arena_target_bv = 0, %% 竞技场挑战对象的战斗力
	is_team_enter = 0,  %% 是否组队进入(1:是 2:不是）
	team_members = [],  %% 队员列表
	max_dungeon_id = 0,             %% 开启的最高关卡
	gc_param = {},
	game_type = 0,            %% 玩法模式
	offensive_defensive = [],   %% 攻防信息
	venue_type = 0,              %% 赛区
	is_reset_base_info = ?TRUE,    %% 重置副本基础信息(世界树是否重置鼓舞信息)
	retrieve_param = {},            %% {找回ID，挑战倍数}
	suppress_param = 0                %% 压制参数
	, left_hp
	, ext_param = 0, % 额外参数
	mod %% 指定模块
}).

-define(ObjectNotExist, objectNotExist).    %%对象不存在
%%-define(AppearIDMaxLenth, 2).    %%可视对象最大数量


-record(tlogClientHardInfo, {
	gameSvrId = "0",
	vGameAppid = "0",
	platID = 0,    %% 7 windowsEditor 8 IOS 11 Android
	vopenid = "0",
	clientVersion = "",
	systemSoftware = "",
	systemHardware = "",
	telecomOper = "",
	network = "",
	screenWidth = 0,
	screenHight = 0,
	density = 0.0,
	regChannel = 0,
	cpuHardware = "0",
	memory = 0,
	gLRender = "",
	gLVersion = "",
	deviceId = "",
	loginChannel = 0,
	loginConsumeTime = 0
}).

%%存储公用ETS数据
-define(MainEts, mainEts).
-record(mainEtsInfo, {
	key = 0,
	value = []
}).

-define(MainEtsKey_YanMo, 1).%%value存储活动开关的时间[{Start, End, IsGm}]
-define(MainEtsKey_GuildCamp, 3). %%	value存储活动开关的时间[{Start, End, IsGm}]
-define(MainEtsKey_GuildGuard, 4). %%	value存储活动开关的时间[{Start, End}]
-define(MainEtsKey_XoRoom, 5). %%	value存储活动开关的时间[{Start, End, IsGm}]

%%离线事件类型
-define(Offevent_Type_SevenGift, 1).  %% 七天奖离线事件
-define(Offevent_Type_Attainments, 2).  %% 任务成就离线事件
-define(Offevent_Type_dungeon_couple_buy, 3).     %% 情侣副本购买次数
-define(Offevent_Type_currency_deleted, 4).     %% 货币扣除事件
-define(Offevent_Type_arena_top_times, 5).     %% 竞技场登顶事件
-define(Offevent_Type_arena_max_rank, 6).     %% 竞技场最大排名变化
-define(Offevent_Type_GuildAward, 8).  %%仙盟副本 仙盟榜奖励
-define(Offevent_Type_GuildWorldAward, 9).  %%仙盟副本 世界榜奖励
-define(Offevent_Type_10, 10).  %%重置仙盟副本每周最高关卡伤害
-define(Offevent_Type_ManorWar, 11).  %%领地战 七天奖信息
-define(Offevent_Type_RouletteDraw, 12).    %% 转盘活动抽奖奖励
-define(Offevent_Type_WildAutoBossDead, 13).%%野外挂机BOSS死亡
-define(Offevent_Type_VehicleDisappear, 14).  %% 镖车消失
-define(Offevent_Type_ConvoyExp, 15). %% 运镖经验
-define(Offevent_Type_SalesActivityCondition, 16).  %% 运营活动
-define(Offevent_Type_AshuraAchieve, 17).  %% 修罗战场成就
-define(Offevent_Type_ClearCroFightRingFightCount, 18).  %% GM重置比武挑战次数
-define(Offevent_Type_19, 19).  %%跨服比武结果
-define(Offenent_Type_deleteEnemy, 28). %% 删除仇人
-define(Offevent_Type_doDemonRankAward, 29).    %% 天魔Boss排行榜奖励
-define(Offevent_Type_GuildDonate, 31).     %% 战盟捐献
-define(Offevent_Type_DailyTask, 32).  %% 日常活跃离线事件
-define(Offevent_Type_PlayerTitle, 33).  %% 称号离线事件
-define(Offevent_Type_LogTimes, 35).     %% 次数记录
-define(OffEvent_Type_GMTools, 37).     %% GM后台-玩家操作
-define(OffEvent_Type_luckyRoulette, 38).   %% 云购领取临时背包
-define(Offevent_Type_fight_1v1_grade_score, 40).     %% 王者1V1保留段位积分
-define(Offevent_Type_gm_delete_item, 41).     %% GM扣除道具
-define(Offevent_Type_efun_fahuo, 42).     %% efun发货
-define(Offevent_Type_gm_delete_currency, 43).     %% GM扣除货币
-define(Offevent_Type_gm_decrease_condition, 44).     %% GM减少活动进度
-define(Offevent_Type_gm_decrease_integral, 45).     %% GM减少转盘积分
-define(Offevent_Type_BorderSettleAward, 46).       %% 边境结算
-define(Offevent_Type_god_level, 47).       %% 神位写入
-define(Offevent_Type_Constellation_star_soul_level, 48). %% 星座星魂强化等级修改
-define(Offevent_Type_Client_Msg, 49).       %% 离线客户端消息
-define(Offevent_Type_Process_Msg, 50).       %% 离线玩家进程消息
-define(Offevent_Type_history_nobility, 51). %% 联服重置前的爵位
-define(Offevent_gm, 52). %% gm通用


%% TODO 修改
-record(awardInfo, {
	awardType = 0,%%logDefine.hrl的奖励类型
	dataID = 0,%%物品配置ID、神器实例ID
	amount = 0,%%数量统称
	bind = 1,%%绑定
	multiple = 1,%%奖励倍数
	reason = 0%%原因统称
}).


%%暂时不使用
%%玩家被封账号表
-record(account_banned, {
	account = "",
	times = 0,%%第几次被封
	time = 0 %%被封时间
}).

-record(matchSystemData, {
	serverID = 0,
	serverNode = 0,
	id = 0, %%发起者id
	max_score = 0, %%队员中的最高积分
	memberList = [], %%玩家列表 list of {PlayerID,Pid} 包含发起者
	time = 0 %%时间
}).

-record(coinInfo, {
	type = 0,           %% 货币类型()
	num = 0,            %% 数量
	multiple = 1,       %% 倍数(默认1倍)
	reason = 0          %% 来源
}).

%% 奖励物品数据
-record(itemInfo, {
	itemID = 0,
	num = 0,
	multiple = 1,        %% 倍数(默认1倍)
	isBind = 1,    %%  0 -非绑定   1-绑定
	expireInfo = {}  %% {X , Y} X-0 Y是绝对时间 X=1 Y是相对时间 单位秒
}).

%% 2018-01-09
-record(mailInfo, {
	player_id = 0,           %% 接收者ID
	mailID = 0,               %% 邮件ID
	senderID = 0,           %% 发送者ID
	senderName = "",       %% 发送者Name
	title = "",               %% 标题
	describe = "",           %% 描述
	state = 0,               %% 0-未读、1-已读 2-已经领取附件 3-已删除 4- 已经删除的世界邮件(需要暂时放在ets中)
	sendTime = 0,           %% 发送时间
	opTime = 0,               %% 操作时间
	multiple = 1,           %% 奖励倍数
	coinList = [],           %% 货币奖励列表  #coinInfo
	itemList = [],           %% 奖励的道具 #itemInfo
	exp = 0,                %% 经验
	attachmentReason = 0,  %% 奖励的原因
	isDirect = 0,          %% 0-添加到邮件列表  1-玩家直接领取   2-未知空间  发邮件的时候不能指定此参数 3-版本更新邮件空间
	itemInstance = [],      %% 装备实例[{Item, Eq}]，装备实例使用此条目  道具实例请拆分成itemInfo
	one_key_op = 1            %% 一键操作标志 0不可 1允许 默认可以一键领取
}).
-define(SystemMailRoleID, 66666).
%%0-未读、1-已读 2-已经领取附件 3-已删除 4- 已经删除的世界邮件(需要暂时放在ets中)
-define(MailState_UnRead, 0).   %% 未读
-define(MailState_Read, 1).     %% 读取
-define(MailState_Get, 2).      %% 领取
-define(MailState_Delete, 3).   %% 删除

-define(ETS_Special_Map_Buy_Times, special_map_buy_times).
-record(special_map_buy_times, {
	index = {0, 0},%%{playerid,type}
	playerid = 0,
	type = 0, %%1,3v3;2,2v2
	value = 0,
	last_time = 0
}).


-define(WorldEvent_Type_ResPoint, 1).    %% 重置玩家资源点

-define(WorldEventEts, worldEventEts).  %% 全服离线事件
-record(worldEvent, {
	id = 0,
	type = 0,       %% 类型
	time = 0,       %% 开始时间
	msg = {}        %% 内容
}).


%% 装备结构
-record(eq, {
	%% 生成后不会改变
	uid = 0,                     %% 道具ID
	item_data_id = 0,           %% 道具配置表ID
	bind = 1,                %% 绑定状态
	character = 0,              %% 品质  掉落时产生
	star = 0,                    %% 星级  掉落时产生
	score = 0,                  %% 装备评分
	rand_prop = [],             %% 根据品质和星级产生的随机属性  {I, V, C, PIndex} 属性ID 值 品质 积分索引
	beyond_prop = [],             %% 根据品质和星级产生的卓越属性 {I, V, C, PIndex}
	gd_prop = [],               %% 根据品质和星级产生的龙饰属性(基础属性) {I, V1, V2, C, PIndex}

	%% 宝石信息
	gem_hole_num = 0,         %% 装备可镶嵌宝石的孔位数掩码
	polarity = 0        %% 极性 幻默认为0 可以改变
}).

%% 装备位置结构
-record(eq_pos, {
	%% 生成后不会改变
	key = {role_id, pos},
	role_id = 0,                %% 角色id
	pos = 0,                    %% 部位
	eq_uid = 0,                     %% 装备ID

	%% 强化相关
	intensity_lv = 0,          %% 强化等级
	intensity_t_lv = 0,        %% 强化最大等级  传承使用

	%% 追加信息
	add_lv = 0,                    %% 追加
	add_t_lv = 0,                  %% 追加最大等级  传承使用

	%% 元素相关
	ele_intensity_atk_lv = 0,   %% 元素强化攻击等级
	ele_intensity_def_lv = 0,   %% 元素强化防御等级
	ele_intensity_atk_break_lv = 0, %% 元素强化攻击突破等级
	ele_intensity_def_break_lv = 0, %% 元素强化防御突破等级
	ele_add_atk_lv = 0,         %% 元素追加攻击等级
	ele_add_def_lv = 0,         %% 元素追加防御等级

	%% 宝石信息
	gem_info = [],              %% 宝石 {Position, Uid, CfgId}
	gem_refine_lv = 0,          %% 宝石精炼等级  对部位进行精炼，然后提高所有宝石的属性 % todo 废弃
	gem_refine_exp = 0,          %% 宝石精炼经验
	cast_prop = [],          %% 洗练属性 {P, I, V, C}
	gd_prop = [],               %% 龙饰属性(最终属性) {I, V1, V2, C, P}

	%% 套装打造
	suit_make_lv = [],       %% 套装打造等级列表 {打造类型,阶数}  打造类型： 1普通 2完美 3传说
	suit_make_cost = [],     %% 套装打造的消耗[{{打造类型，等级}，{道具消耗，货币消耗}}]

	%% 卡片
	card = [],        %% 卡片镶嵌信息 {Hole, CardCfgID}   Hole = 100 表示ur卡部位

	%% 符文法阵
	fazhen = 0            %% 法阵实例Id
}).

-record(pet, {
	pet_id = 0,                    %% 宠物id (配置表Id)
	pet_lv = 1,                    %% 等级
	pet_exp = 0,                %% 经验
	break_lv = 0,                %% 突破等级  和宠物等级相关
	star = 0,                    %% 星数
	grade = 0,                    %%品质（稀有度）
	awaken_lv = 0,                %% 觉醒等级
	awaken_potential = 0,       %% 炼魂等级  和觉醒等级相关
	is_rein = 0,               %% 是否转生 0否 1是
	ultimate_skill_lv = 1,            %% 必杀技等级
	fight_flag = 0,            %% 0否 1出战中 2助战中
	fight_pos = 0,            %% 出战/助战位置
	is_auto_skill = 0         %% 自动释放技能 0是/1否
}).

%% 宠物装备
-record(pet_eq, {
	uid = 0,            %% 宠物装备实例id
	cfg_id = 0,         %% 配置id
	reset_time = 0,     %% 已重置次数
	skill_list = [],    %% 装备的所有技能（为空表示没有技能）[{pos,skill_id,quality,order}] quality-order确定配置
	reset_skill_list = [] %% 待保存的重置技能（为空表示没有）[{pos,skill_id,quality,order}]
}).

%% 宠物圣树守卫
-record(pet_shared_guard, {
	uid_list = [], % 担任圣树守卫宠物uid列表
	uid = 0, % 被共享属性的宠物uid
	state = 0 % 状态 0-一期 1-二期
}).

%% 宠物圣树栏位
-record(pet_shared_pos, {
	pos = 0, % 入驻格子序号
	uid = 0, % 入驻宠物uid
	cd = 0, % 入驻冷却时间
	lv = 1, % 入住位等级
	unlock_time = 0 % 解锁时间
}).

-record(pet_new, {
	uid = 0                        %% 唯一ID
	, pet_cfg_id = 0             %% 宠物id (配置表Id)c
	, pet_lv = 1                %% 等级
	, pet_exp = 0                %% 经验
	, break_lv = 0                %% 突破等级  和宠物等级相关
	, star = 0                    %% 星数
	, grade = 0                    %% 品质（稀有度）
	, fight_flag = 0            %% 0否 1出战中 2助战中
	, fight_pos = 0                %% 出战/助战位置
	, is_auto_skill = 0        %% 自动释放技能 0是/1否
	, wash = []                    %% 洗髓属性列表 [{type, value}]
	, is_lock = 0                %% 是否锁定 1是 0否
	, wash_material = []            %% 洗髓消耗道具记录
	, wash_preview = []            %% 洗髓未保存属性[{type, value}]
	, link_uid = 0               %% 幻兽主动链接的宠物uid
	, been_link_uid = 0          %% 宠物 被链接的幻兽uid
	, appendage_uid = 0          %% 幻兽主动附灵的宠物uid
	, been_appendage_uid = 0     %% 宠物被附灵的幻兽uid
	, get_by_egg = 0             %% 是否通过孵化获得 1是 0否
	, hatch_id = 0               %% 照看孵化 0没有照看
	, shared_flag = 0            %% 是否入驻圣树 0 没有 1 入驻了
	, point = 0                  %% 入驻圣树前出战评分 0 未入驻圣树，前端显示需要...
	, star_pos = []              %% 星位 {Pos, Star}
	, sp_lv = 0                  %% sp英雄战阶，普通则为0
}).

-record(atlas, {
	atlas_id = 0, %% 图鉴id
	stars = 0, %%图鉴显示的星级，0代表玩家获得过该宠物，以后抽奖不显示New
	active_time = 0, %% 图鉴激活时间
	max_star = 0, %% 曾经获得过的最大星级
	is_reward = 0
}).

%% 魔灵
-record(moling, {
	player_id = 0,
	role_id = 0,
	lv = 1,
	exp = 0,
	skills = [],   %%
	eqs = [], %% [{部位  装备ID 强化等级, 突破}]
	pill1 = 0,      %% 嗑丹信息
	pill2 = 0,      %% 嗑丹信息
	pill3 = 0       %% 嗑丹信息
}).

%% 附加装备  魔/翼/兽灵装备
-record(eq_addition, {
	eq_uid = 0,
	cfg_id = 0,
	rand_prop = []
}).


%% 神翼属性，为r_itemDB子表
-record(wing, {
	wing_id = 0,           %% 道具配置表ID
	%% 基础属性
	level = 1,                  %% 等级
	exp = 0,                  %% 等级
	star = 0,                    %% 星数
	break_lv = 0,                    %% 星数
	feather_lv = 0,                %% 羽化等级(觉醒等级)
	sublimate_lv = 0,                %% 炼魂
	is_rein = 0,              %% 是否转生 0否 1是
	ele_awaken = 0,              %% 元素觉醒
	is_fly = 0,            %% 是否飞翼
	f_level = 0                %%飞翼等级
}).

%% 翼灵
-record(yiling, {
	lv = 1,                %%  等级
	exp = 0,            %%  经验
	break_lv = 0,        %% 突破等级
	skill_p = [],        %%  装配的技能 来自cfg_wingAwakenNew.skill [{Pos, MountId, 0}]
	skill_t_mask = 0,    %%  触发技能格子开启信息
	skill_t = [],        %%  打造的技能 来自cfg_wingStarNew.skill [{Pos, MountID, Index, IsLock}] 由MountID和Index决定技能
	eqs = [],            %%  穿戴的装备
	award_list = []
}).

%% 万神殿装备
-record(aequip, {
	uid = 0,        %%
	cfg_id = 0,
	intensity_lv = 0, %% 强化等级
	intensity_exp = 0,%% 强化经验 经验满了升级
	intensity_t_exp = 0,%% 强化获得的总经验(避免遍历配置表)
	rand_prop = []    %% 随机属性
}).

-define(BattlefieldPID, battlefield).
-define(MeleePID, meleePID).
-define(WorldBossPID, world_boss_pid).
-define(DemonHunterPid, demon_hunter).
-define(HolyWarPid, holy_war).
-define(GodFightPid, god_fight).
-define(DarkLordPid, dark_lord).
-define(ClusterDhSeason, dh_season).
-define(King1v1Pid, king_1v1).
-define(EXPEDITION_PID, expedition).
-define(BorderWar, border_war).
-define(GuildWarPid, guild_war).
-define(LavaFightPid, lava_fight).
-define(ManorWarPid, manor_war).
-define(CpTrialPid, couple_trial).
-define(TeamEqPid, team_eq).

%% 定义ETS表存篝火地图信息
-define(BonfireEts, bonfireEts).
-record(bonfire, {
	key = 0,
	state = 0,         %% 0-关闭 1-开启
	guild_ratio = 0,   %% 战盟加成
	treat_point = 0,   %% 请客积分
	guild_money = 0,   %% 获得的战盟资金
	player_list = []
}).

-define(BonfireKey, 1).

-record(bonfire_player, {
	player_id = 0,
	personal_ratio = 0,  %% 个人加成
	exp = 0,
	coin = 0,
	t1 = 0,
	t2 = 0,
	award_mask = 0,
	in_area = 0        %% 是否在圈内  0 不在  1 在
}).

%% 禁止传送类型
-define(Convoy_Forbidden, 1).  %% 镖车上车状态不可传送

%% 打宝类型
-define(DemonHolyWar, 9).
-define(DemonHolyRuins, 11).    %% 星空圣墟
-define(DemonDarkLord, 13).     %% 暗炎首领

%% 星座装备
-record(constellation_equipment, {uid, cfg_id, excellent_attr = [], excellent_attr1 = [], bind = 0}). %% 星座装备
%% 古神圣装
-record(ancient_holy_eq, {
	uid,                %% id
	cfg_id,             %% 配置id
	high_quality_attr,  %% 极品属性
	superior_attr       %% 卓越属性
}).

%% 特殊掉落记录
-define(Ets_DropSp, ets_drop_sp).

%% 圣翼随机属性
-record('holy_wing', {id, cfg_id, attr}).
-record(dark_flame_eq, {player_id, uid, cfg_id, best_attr, exc_attr}).

%% 血脉
-record(bloodline, {
	player_id = 0,      %% 玩家id
	blood_id = 0,       %% 血脉id
	level = 0,          %% 等级
	exp = 0,            %% 经验
	skills = []         %% 技能 [{order, level}|...]
}).

%% 恶魔悬赏令
-record(demons_reward, {
	player_id = 0,      %% 玩家id
	type = 0,           %% 类型
	score = 0,          %% 积分
	day_score = 0,      %% 每日积分
	is_token = 0,       %% 是否购买高级令牌
	rewards = []        %% 已领奖
}).

%% 圣纹信息
-record(shengwen, {
	player_id = 0,
	uid = 0,                %% 实例ID
	cfg_id = 0,             %% CfgID
	bind = 1,               %%绑定状态
	jipin_prop = [],        %% 极品属性  {I, V, C, PIndex} 属性ID 值 品质 积分索引
	zhuoyue_prop = []       %% 卓越属性  {I, V, C, PIndex} 属性ID 值 品质 积分索引
}).

-record(collect_pos, {
	index = {0, 0},     %% 索引：{order, pos}
	role_id = 0,        %% 角色ID
	order = 0,            %% 阶数
	pos = 0,            %% 部位
	uid = 0,            %% 装备uid
	reborn_lv = 0,            %% 再生等级
	reborn_fail_times = 0,  %% 再生失败次数
	reborn_prop = []    %% 再生属性列表（属性库ID）
}).

-define(ETS_GameFcm, ets_gameFcm).% 防沉迷
-record(game_fcm, {
	player_id = 0,
	account = "",
	online_time = 0,
	monthly_recharge = 0
}).

-record(week_active, {
	player_id = 0,
	active = 0,            %% 累计活跃值（功能未开启时每天累计，不重置）
	free_gift = [],    %% 免费已领取
	pay_gift = [],        %% 付费已领奖
	reset_time = 0,        %% 下次重置时间（记录0点时间，实际重置时间是5点）
	is_pay = 0,            %% 是否付费
	is_first_pay = 0,    %% 是否购买过首次通行证
	player_lv = 0        %5 起始等级
}).

%% 复活类型
-define(ReviveRole, 1).     %% 角色复活
-define(ReviveWhole, 2).    %% 全体复活

%% 玩家处于某种状态同步类型
-define(CertainStateStartIndex, 1). %% 类型开始
-define(CertainStateDragonHonor, 1). %% 是否龙神骑士团前N
-define(CertainStateDonateDoubleExp, 2). %% 捐赠双倍经验时间
-define(CertainStateDonateDoubleDrop, 3). %% 捐赠双倍掉落时间
-define(CertainStateEndIndex, 3). %% 类型结束

%% 特权订阅
-define(RechargeSubscribe1, 1).        %% 月卡特权赠送称号
-define(RechargeSubscribe4, 4).        %% 每日令牌获取上限
-define(RechargeSubscribe5, 5).        %% 卡片许愿获得
-define(RechargeSubscribe6, 6).        %% 工会宝箱钻石上限

%% 物品来源
-define(ShowDialogFrom_1, 1). %% 普通礼包
-define(ShowDialogFrom_2, 2). %% 选择礼包
-define(ShowDialogFrom_3, 3). %% 世界boss
-define(ShowDialogFrom_4, 4). %% 死亡地狱
-define(ShowDialogFrom_5, 5). %% 死亡森林
-define(ShowDialogFrom_6, 6). %% 特权BOSS
-define(ShowDialogFrom_7, 7). %% 明日领奖
-define(ShowDialogFrom_8, 8). %% 主线通关
-define(ShowDialogFrom_9, 9). %% 首充
-define(ShowDialogFrom_10, 10). %%  无尽宝藏
-define(ShowDialogFrom_11, 11). %%  觉醒之路
-define(ShowDialogFrom_12, 12). %%  运营活动 条件达成类
-define(ShowDialogFrom_13, 13). %%  限时特惠
-define(ShowDialogFrom_14, 14). %%  寻宝
-define(ShowDialogFrom_15, 15). %%  七日盛典
-define(ShowDialogFrom_16, 16). %%  等级礼包
-define(ShowDialogFrom_17, 17). %%  至尊终身卡
-define(ShowDialogFrom_18, 18). %%  商店
-define(ShowDialogFrom_19, 19). %%  直购礼包
-define(ShowDialogFrom_20, 20). %%  转盘兑换
-define(ShowDialogFrom_21, 21). %%  远征探险
-define(ShowDialogFrom_22, 22). %%  超级塔
-define(ShowDialogFrom_23, 23). %%  快捷合成
-define(ShowDialogFrom_24, 24). %%  圣装合成失败返还
%% 神装星级
-define(EqGodStar, 13).

-define(CareerValidList, [1004, 1005, 1006, 1007]).    %% 可创建职业

%% 装备类型
-define(SUIT_EQUIP, 1).  %% 装备套装
-define(SUIT_ORNAMENT, 2).  %% 首饰套装
-define(Eq_Atk, 1). %% 攻击
-define(Eq_Def, 2). %% 防御
-define(Eq_Orn, 3). %% 饰品

%%

-define(DropFromType1, 1). %% 死亡地狱
-define(DropFromType2, 2). %% 死亡森林
-define(DropFromType3, 3). %% 黑暗森林
-define(DropFromType4, 4). %% 世界boss
-define(DropFromType5, 5). %% 个人boss
-define(DropFromTypeRange, lists:seq(?DropFromType1, ?DropFromType5)).

-record(wedding, {key, role_id1, role_id2, m_time, divorce}).
-record(db_wedding, {role_id1, role_id2, m_time, divorce}). %% 这里没办法，只能分两个record。不然找不到key
%%索引  玩家ID1  玩家ID2   婚礼类型  预定信息(玩家预定的信息，用于回退消耗）  派发请柬的玩家  索要请柬的玩家  是否已经举办过婚礼  待推送请柬的玩家   使用请柬增加的邀请次数（两玩家共享）
-record(wedding_booking, {id, role_id1, role_id2, type, cost = [], invitation = [], req_list = [], is_end = 0, pre_send = [], add_invitation_num = 0}).
-record(wedding_ring, {player_id, key_list = []}).%%key_list 是 [{RindId,Key,Value},{101,1,0},{101,2,2},{102,1,0},{102,2,5}}]
-define(WEDDING_BOOKING_ETS, wedding_booking_ets).
-define(WEDDING_RING_ETS, wedding_ring_ets).
-define(WEDDING_MAP, 2900001).  %% 婚礼场景地图id

-endif. % -ifdef(record_hrl).