%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 世界变量、玩家变量
%%% @end
%%% Created : 2018-05-25 15:40
%%%-------------------------------------------------------------------
-ifndef(variable_hrl).
-define(variable_hrl, true).

%% TODO 玩家变量注意事项：一个功能超过两个玩家变量，请单独建表存储！

%%----------------------------------------------------------------------------------------------------------------------
%% TODO 世界变量
-define(VARIABLE_WORLD_ServerState, 1). %% 0-未开服、1-已开服
-define(WorldVariant_Index_2_WorldBossState, 2).     %%世界BOSS开关
-define(WorldVariant_Index_3_ServerStartTime, 3).   %% 服务器开服时间
-define(WorldVariant_GMlevel, 4).    %% gmlevel = 1,           %%ServerGM等级,正式等级为1,测试为0
-define(VARIABLE_WORLD_ClusterStage, 5).      %% 联服阶段：0-未开启、1-单服、2-2联、4-4联、8-8联
-define(VARIABLE_WORLD_ClusterOpenTime2, 6).  %% 2联开始时间
-define(VARIABLE_WORLD_ClusterOpenTime4, 7).  %% 4联开始时间
-define(VARIABLE_WORLD_ClusterOpenTime8, 8).  %% 8联开始时间
-define(VARIABLE_WORLD_ClusterOpenTime, 9).   %% 联服本次开始时间
-define(VARIABLE_WORLD_ClusterCloseTime, 10). %% 联服本次结束时间
-define(VARIABLE_WORLD_ClusterWorldLevel, 11).    %% 主服世界等级(边境入侵的主服)
-define(VARIABLE_WORLD_ArenaWorldLevel, 12). %% 上期竞技场结算世界等级
-define(WorldVariant_3v3Season, 13).                %% 3v3 当前服务器已经打了多少次  (赛季)  用于联服重置后计算玩家该掉多少段
-define(VARIABLE_WORLD_ClusterDisable, 14).  %% 联服功能关闭标记（0-可用、1-不可用）
-define(WorldVariant_Index_15_MaxMainChapter, 15).    %% 服务器主线最大章节
-define(WorldVariant_Index_16_WorldLevel, 16).    %% 世界等级
-define(VARIABLE_WORLD_AccountBusyCount, 17). %% 关闭推荐账号数量
-define(VARIABLE_WORLD_AccountTotalCount, 18). %% 新进限制账号数量
-define(VARIABLE_WORLD_LoginBusyCount, 19). %% 登录排队-登录忙碌状态人数
-define(VARIABLE_WORLD_LoginTotalCount, 20). %% 登录排队-总人数
-define(VARIABLE_WORLD_SealLevel, 21).      %% 封印ID
-define(VARIABLE_WORLD_SealState, 22).      %% 封印状态
-define(VARIABLE_WORLD_ClusterEnable, 23).  %% 联服功能开启标记（0-不可用、1-可用）
-define(VARIABLE_WORLD_SkipResetTime5, 29). %% 跳过5点重置时间（秒）
-define(VARIABLE_WORLD_LastResetTime5, 30). %% 上次5点重置时间（秒）
-define(VARIABLE_WORLD_LastResetTime1, 31). %% 上次0点重置时间（秒）
-define(VARIABLE_WORLD_LastResetTime2, 32). %% 上次22点重置时间（秒）
-define(Variable_World_FundsBuyCounter, 33).    %% 基金购买人数计数器
-define(VARIABLE_WORLD_ResVersion, 34). %% 资源版本号（前端使用）
-define(VARIABLE_WORLD_LastResetTime3, 35). %% 上次21点重置时间（秒）
-define(VARIABLE_WORLD_LastResetTime4, 36). %% 上次23:30重置时间（秒）
-define(VARIABLE_WORLD_LotteryEnable, 40).  %% 紫钻抽奖功能开启标记（0-不可用、1-可用）
-define(VARIABLE_WORLD_EntityLotteryEnable, 41).  %% 实物抽奖功能开启标记（0-不可用、1-可用）
-define(VARIABLE_WORLD_SkinLotteryEnable, 42).  %% 皮肤抽奖功能开启标记（0-不可用、1-可用）
-define(WorldVariant_AcceleratorCheckInfo, 50). %% 加速器检查方式
-define(WorldVariant_YanMoLevel, 51). %% 炎魔试炼炎魔的等级
-define(VARIABLE_WORLD_chat_37wan, 52). %% 37wan聊天屏蔽字开关
-define(WorldVariant_Carnival2, 53). %% 嘉年华开启时候的开服天数
-define(WorldVariant_ManorRound, 54). %% 当前是领地战的X场
-define(VARIABLE_WORLD_google_fcm, 55). %% 谷歌推送关闭
-define(WorldVariant_BorderTopSettle, 56).  %% 边境发奖状态
-define(VARIABLE_WORLD_Border_Rank, 57).    %% 边境入侵服务器排名
-define(WorldVariant_HolyWarCurseClearTime, 58).    %% 圣战遗迹诅咒值清除时间点
-define(WorldVariant_MergeServerFlag, 59).    %% 合服标记，用于合服后进行一些处理
-define(WorldVariant_BorderMaxSeason, 61).          %% 边境当前最高赛季
-define(WorldVariant_XunBaoLucky, 62).                %% 寻宝全服幸运值
-define(WorldVariant_King1v1SeasonTime, 63).        %% 1v1赛季时间(赛季开始时间)
-define(WorldVariant_King1v1MatchFlag, 64).         %% 1v1匹配标记
-define(WorldVariant_ExpeditionInfo, 66).         %% 远征公告发布记录 1为30分钟公告已经发布， 2为20分钟公告已经发布 3为今天10分钟公告已经发布
-define(WorldVariant_ExpeditionTodayJoinNum, 67).         %% 远征活跃度
-define(Variable_World_FundsBuyCounterFake, 68).    %% 基金购买增加的假人数

-define(Variable_World_King1v1_BpTimesFix, 69).        %% 王者1v1BP次数倍率 todo 废弃
-define(Variable_World_King1v1_BpScoreFix, 70).        %% 王者1v1BP积分倍率 todo 废弃

-define(Variable_World_FreeBuyTime, 71).    %%零元购老服重开时间,新服开服时间
-define(Variable_World_ServerSealDoingKey, 72).    %% 等级封印进行中的key
-define(Variable_World_ServerSealLastFinishKey, 73).    %% 等级封印最近完成的key
-define(Variable_World_COMaxWorldLevel, 74).           %% 跨服开启时联服最高世界等级
-define(Variable_World_GuildWarMergeTime, 75).      %% 联服公会战合服时间标记

-define(WorldVariant_Max, 80).        %% TODO 最大世界变量

%% TODO 功能开关
-define(WorldVariant_Switch_Signin, 81).  %% 签到奖励活动
-define(WorldVariant_Switch_Login, 82).   %% 登陆奖励活动
-define(WorldVariant_Switch_LevelGift, 84).   %% 等级礼包活动
%%-define(WorldVariant_Switch_HappyCard, 85).   %% 开心翻牌
-define(WorldVariant_Switch_MonthCard, 86).   %% 月卡系统
-define(WorldVariant_Switch_ActiveCode, 87).    %% 使用激活码功能
-define(WorldVariant_Switch_Rechage, 88).   %% 首冲
-define(WorldVariant_Switch_VipGift, 89).   %% vip礼包
-define(WorldVariant_Switch_ActionHint, 90). %% GM命令小图标(仅有充值)
-define(WorldVariant_Switch_GmOrder, 91).   %% GM命令图标
-define(WorldVariant_Switch_SalesActivity, 92).  %% 后台活动
-define(WorldVariant_Switch_Top, 94).       %% 排行榜
-define(WorldVariant_Switch_MobilePhoneBind, 95). %% 手机绑定
-define(WorldVariant_Switch_ShopGift, 96). %% 商城-礼包分页
-define(WorldVariant_Switch_ShopXF, 97). %% 商城-仙坊分页
-define(WorldVariant_Switch_NextDayAward, 98).  %% 次日奖励
-define(WorldVariant_Switch_ChatVoice, 99). %% 语音翻译
-define(WorldVariant_Switch_ManorWar_One, 101).  %% 领地战一等级领地
-define(WorldVariant_Switch_ManorWar_Two, 102).  %% 领地战二等级领地
-define(WorldVariant_Switch_ManorWar_Three, 103).  %% 领地战三等级领地
-define(WorldVariant_Switch_QQVIP, 104).  %% QQ送会员
-define(WorldVariant_Switch_QQVIP_SP, 105).  %% QQ会员特权
%%-define(WorldVariant_Switch_ManorWar, 106). %% 领地图标
-define(WorldVariant_Switch_Roulette, 107). %% 转盘图标
-define(WorldVariant_Switch_Carnival, 108). %% 嘉年华图标
-define(WorldVariant_Switch_recharge_total, 109). %% 累计充值/天天乐/每日首充
-define(WorldVariant_Switch_daily_buy, 110). %% 每日礼包
-define(WorldVariant_Switch_DungeonLove, 111). %% 七夕副本
-define(WorldVariant_Switch_TimeLimitGift, 112). %% 限时折扣
-define(WorldVariant_Switch_ConnectShareServer, 113). %% 连接跨服
-define(WorldVariant_Switch_share, 114).    %% 分享
-define(WorldVariant_Switch_FuncVPlus, 115).    %% V+礼包
-define(WorldVariant_Switch_3v3, 116). %% 跨服比武
-define(WorldVariant_Switch_Melee, 117). %% 麒麟洞
-define(WorldVariant_Switch_ThunderFort, 118). %% 雷霆要塞
-define(WorldVariant_Switch_Darts, 119).    %% 飞镖活动图标
-define(WorldVariant_Switch_ThreeHeaven, 120). %%三重天
-define(WorldVariant_Switch_WorldLevel, 121). %% 世界等级
-define(WorldVariant_Switch_WildAutoBoss, 122). %% 四海刷怪
-define(WorldVariant_Switch_CoupleFight, 123). %%2v2
-define(WorldVariant_Switch_Trade, 124). %% 交易行
-define(WorldVariant_Switch_FreeEnergy, 127).   %% 龙城盛宴
-define(WorldVariant_Switch_Card, 128).   %% 图鉴
-define(WorldVariant_Switch_VIP, 130).   %% vip
-define(WorldVariant_Switch_Honor, 132).    %% 头衔
-define(WorldVariant_Switch_Trade_password, 133).    %% 密码交易总控
-define(WorldVariant_Switch_Trade_remote_password, 134).    %% 密码交易跨服
-define(WorldVariant_Switch_Trade_goods_request, 135).    %% 求购总控
-define(WorldVariant_Switch_Trade_remote_goods_request, 136).    %% 求购跨服
-define(WorldVariant_Switch_BountyTask, 137).    %% 赏金任务
-define(WorldVariant_Switch_DungeonPreDeposits, 138).   %% 矮人宝藏
-define(WorldVariant_Switch_DungeonDepositsEx, 139).   %% 精灵宝藏  d3 组队装备
-define(WorldVariant_Switch_WorldBoss, 141).   %% 世界BOSS
-define(WorldVariant_Switch_DungeonGDCons, 142).   %% 龙神秘典副本
-define(WorldVariant_Switch_BoneYard, 143).   %% 恶魔猎场
-define(WorldVariant_Switch_GuildGuard, 144).   %% 守卫战盟
-define(WorldVariant_Switch_GuildTask, 145).    %% 战盟任务
-define(WorldVariant_Switch_GuildAuction, 146).   %% 守卫拍卖
-define(WorldVariant_Switch_GuildCraft, 147).   %% 战盟争霸
-define(WorldVariant_Switch_Attainment, 148).   %% 成就
-define(WorldVariant_Switch_Prophecy3, 149).   %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_Prophecy4, 150).   %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_Prophecy5, 151).   %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_Prophecy6, 152).   %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_Prophecy7, 153).   %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_cluster, 154).   %% 世界服开关
-define(WorldVariant_Switch_flower, 155).   %% 送花
-define(WorldVariant_Switch_Fight_1v1, 156).   %% 王者1V1
-define(WorldVariant_Switch_Head, 157).   %% 头像
-define(WorldVariant_Switch_Frame, 158).   %% 头像框
-define(WorldVariant_Switch_Convoy, 159).   %% 护送龙晶
%%-define(WorldVariant_Switch_DungeonArti, 160).  %% 个人恶魔 todo ?激活码
-define(WorldVariant_Switch_AwakenRoad, 161).   %% 觉醒之路(原龙神图鉴)
-define(WorldVariant_Switch_ChatBubble, 162).    %% 聊天气泡
-define(WorldVariant_Switch_HornBubble, 163).    %% 喇叭气泡
-define(WorldVariant_Switch_BlessGift, 164).    %% 天神祈福
-define(WorldVariant_Switch_XunBao_0, 165). %% 0寻宝总控
-define(WorldVariant_Switch_XunBao_1, 166). %% 1装备寻宝
-define(WorldVariant_Switch_XunBao_2, 167). %% 2龙印寻宝
-define(WorldVariant_Switch_XORoom, 169). %% XO房间
-define(WorldVariant_Switch_Retrieve, 170). %% 资源找回
-define(WorldVariant_Switch_LoginGift, 172).    %% 登录奖
-define(WorldVariant_Switch_FreeBuy, 173).        %% 0元购
-define(WorldVariant_Switch_recharge_first, 174).   %% 首充
-define(WorldVariant_Switch_MonthFinancing, 175).    %% 月理财
-define(WorldVariant_Switch_WeekFinancing, 176).    %% 周理财
-define(WorldVariant_Switch_Funds, 177).        %% 基金
-define(WorldVariant_Switch_FundsGrowth, 178).    %% 成长基金
-define(WorldVariant_Switch_FundsExtreme, 179).    %% 巅峰基金
-define(WorldVariant_Switch_FundsLegend, 180).    %% 传奇基金
-define(WorldVariant_Switch_FundsAll, 181).        %% 全民奖励
-define(WorldVariant_Switch_Arena, 182).        %% 竞技场
-define(WorldVariant_Switch_Guild, 183).        %% 战盟
-define(WorldVariant_Switch_YanMo, 184).        %% 炎魔试炼
-define(WorldVariant_Switch_DailyTask, 185).    %% 日常
-define(WorldVariant_Switch_ExcellenceCopyMap, 186).    %% 精英副本
-define(WorldVariant_Switch_Title, 187).        %% 称号
-define(WorldVariant_Switch_Pet, 188).            %% 宠物
-define(WorldVariant_Switch_DungeonMain, 189).  %% 主线副本
-define(WorldVariant_Switch_BattleField, 191).  %% 永恒战场
-define(WorldVariant_Switch_Mount, 192).        %% 坐骑
-define(WorldVariant_Switch_Wing, 195).            %% 翅膀
-define(WorldVariant_Switch_MountAwaken, 196).    %% 坐骑觉醒
-define(WorldVariant_Switch_FWing, 197).        %% 飞翼
-define(WorldVariant_Switch_Demon, 200).        %% 恶魔入侵
-define(WorldVariant_Switch_DemonCx, 201).        %% 恶魔巢穴
-define(WorldVariant_Switch_EqInt, 202).     %% 装备强化
-define(WorldVariant_Switch_Synthetic, 203).  %% 合成
-define(WorldVariant_Switch_PersonalBossNew, 204).   %% 个人boss
-define(WorldVariant_Switch_DemonsLair, 205).   %% 恶魔禁地
-define(WorldVariant_Switch_EqSuit, 206).        %% 装备套装
-define(WorldVariant_Switch_Rune, 208).   %% 龙印
-define(WorldVariant_Switch_RuneTower, 209).   %% 龙神塔
-define(WorldVariant_Switch_Team, 210).   %% 组队
-define(WorldVariant_Switch_EqAdd, 211).    %% 装备追加
-define(WorldVariant_Switch_EqCast, 212).    %% 装备洗练
-define(WorldVariant_Switch_GemOn, 213).    %% 宝石镶嵌
-define(WorldVariant_Switch_GemRefine, 214).    %% 宝石精炼
-define(WorldVariant_Switch_GDMain, 215).    %% 龙神
-define(WorldVariant_Switch_GDElf, 216).    %% 精灵龙神
-define(WorldVariant_Switch_GDAddStar, 217).    %% 龙神升星
-define(WorldVariant_Switch_GD_Statue, 218).    %% 龙神雕像
-define(WorldVariant_Switch_Astro, 219).    %% 神灵
-define(WorldVariant_Switch_DungeonPet, 220). %% 宠物副本
-define(WorldVariant_Switch_DungeonWing, 221). %% 翅膀副本
-define(WorldVariant_Switch_DungeonMount, 222). %% 坐骑副本
-define(WorldVariant_Switch_DungeonGoblin, 223). %% 地精宝库
-define(WorldVariant_Switch_Guard, 224). %% 守护
-define(WorldVariant_Switch_GDCons, 225). %% 龙神秘典
-define(WorldVariant_Switch_Holy, 227).            %% 圣物
-define(WorldVariant_Switch_HolyRefine, 228).    %% 圣物精炼
-define(WorldVariant_Switch_hang, 229).    %% 挂机
-define(WorldVariant_Switch_Pantheon, 230).    %% 神魔战场
-define(WorldVariant_Switch_Moling, 231).    %% 魔灵
-define(WorldVariant_Switch_Yiling, 232).    %% 翼灵
-define(WorldVariant_Switch_Shouling, 233).    %% 兽灵
-define(WorldVariant_Switch_TeamExp, 234).    %% 恶魔广场
-define(WorldVariant_Switch_EqFade, 241).      %% 装备炼金
-define(WorldVariant_Switch_Wedding, 244).    %% 结婚
-define(WorldVariant_Switch_Friends, 245).    %% 好友
-define(WorldVariant_Switch_DungeonRelic, 246).    %% 圣物副本
-define(WorldVariant_Switch_DungeonDragon, 247).    %% 龙神副本
-define(WorldVariant_Switch_Soul, 248).                %% 神魂
-define(WorldVariant_Switch_CoupleTrial, 250).     %% 情侣试炼
-define(WorldVariant_Switch_ExtLevel, 251).        %% 巅峰等级
-define(WorldVariant_Switch_Skill, 252).         %% 技能
-define(WorldVariant_Switch_Genius, 253).        %% 天赋
-define(WorldVariant_Switch_SkillBind, 255).     %% 技能装配
-define(WorldVariant_Switch_MountSublimate, 257).     %% 坐骑炼魂
-define(WorldVariant_Switch_MountEq, 258).         %% 坐骑装备
-define(WorldVariant_Switch_WingFeather, 259).     %% 翅膀羽化
-define(WorldVariant_Switch_WingSublimate, 260). %% 翅膀炼魂
-define(WorldVariant_Switch_WingEq, 261).        %% 翅膀装备
-define(WorldVariant_Switch_PetAwaken, 262).        %% 宠物觉醒
-define(WorldVariant_Switch_PetSublimate, 263).        %% 宠物炼魂
-define(WorldVariant_Switch_PetEq, 264).        %% 宠物装备（包括合成）
-define(WorldVariant_Switch_GuardUp, 266).        %% 守护升阶
-define(WorldVariant_Switch_recharge_life_card, 268).   %% 终身卡
-define(WorldVariant_Switch_XunBao_5, 270). %% 5魔宠寻宝
-define(WorldVariant_Switch_XunBao_4, 271). %% 4神翼寻宝
-define(WorldVariant_Switch_CPMonthCard, 277). %% 情侣月卡
-define(WorldVariant_Switch_recharge_subscribe, 278). %% 订阅.
-define(WorldVariant_Switch_FlyShoes, 279).        %% 小飞鞋
-define(WorldVariant_Switch_recharge_DungeonDemon, 281). %% 龙神结界.
-define(WorldVariant_Switch_recharge_first2, 282).   %% 新服累充
-define(WorldVariant_Switch_Ornament, 283).     %% 海神套装(配饰)
-define(WorldVariant_Switch_SevenGift, 284).    %% 七天奖
-define(WorldVariant_Switch_recharge_first3, 285).   %% 续充
-define(WorldVariant_Switch_Prophecy2, 287).            %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_Actor, 290).            %% 演员
-define(WorldVariant_Switch_OrnamentCast, 293). %% 海神祝福
-define(WorldVariant_Switch_DungeonOrnament, 294).            %% 配饰副本
-define(WorldVariant_Switch_GuildCamp, 295).            %% 战盟驻地
-define(WorldVariant_Switch_GDSynt, 296).                %% 龙神装合成
-define(WorldVariant_Switch_Horcrux, 297).          %% 魂器
-define(WorldVariant_Switch_PantheonCluster, 298).    %% 神魔战场
-define(WorldVariant_Switch_GodMountEqSynt, 299).                %%骑装神装和神装石合成
-define(WorldVariant_Switch_GDMountEqSynt, 300).                %%骑装龙神装合成
-define(WorldVariant_Switch_GodPetEqSynt, 301).                %%宠装神装和神装石合成
-define(WorldVariant_Switch_GDPetEqSynt, 302).                %%宠装龙神装合成
-define(WorldVariant_Switch_GodWingEqSynt, 303).                %%翼装神装和神装石合成
-define(WorldVariant_Switch_GDWingEqSynt, 304).                %%翼装龙神装合成
-define(WorldVariant_Switch_GodEqSynt, 305).                %% 神灵装神装和神装石合成
-define(WorldVariant_Switch_GDEqSynt, 306).                %% 神灵装龙神装合成
-define(WorldVariant_Switch_ManorWar, 307).          %% 领地战-龙城争霸
-define(WorldVariant_Switch_GodSeaEqSynt, 309).                %% 海神套装：神装、海神神装石合成
-define(WorldVariant_Switch_GDSeaEqSynt, 310).                %% 海神套装：龙神装合成
-define(WorldVariant_Switch_XunBao_6, 311). %% 6巅峰寻宝
-define(WorldVariant_Switch_RuneCore, 313).         %% 核心龙印
-define(WorldVariant_Switch_RuneCoreSynt, 314).      %% 核心龙印合成
-define(WorldVariant_Switch_RuneAddStar, 315).      %% 龙印升星
-define(WorldVariant_Switch_Carnival2, 316).      %% 第二轮嘉年华
-define(WorldVariant_Switch_DemonCluster, 317).   %% 恶魔深渊
-define(WorldVariant_Switch_SoulAddStar, 319).   %% 神魂升星
-define(WorldVariant_Switch_Weapon, 320).           %% 神兵
-define(WorldVariant_Switch_WeaponAddLv, 321).      %% 神兵升阶
-define(WorldVariant_Switch_WeaponAddStar, 322).    %% 神兵升星
-define(WorldVariant_Switch_WeaponSoul, 323).       %% 兵魂
-define(WorldVariant_Switch_WeaponSynt, 324).       %% 神兵合成
-define(WorldVariant_Switch_WeaponReopen, 325).     %% 神兵解封
-define(WorldVariant_Switch_GodOrnament, 326).      %% 神饰
-define(WorldVariant_Switch_MountSynt, 327).        %% 坐骑合成
-define(WorldVariant_Switch_PetSynt, 328).          %% 宠物合成
-define(WorldVariant_Switch_WingSynt, 329).         %% 翅膀合成
-define(WorldVariant_Switch_HolySynt, 330).         %% 圣物合成
-define(WorldVariant_Switch_GdSynt, 331).           %% 龙神合成
-define(WorldVariant_Switch_HolyShield, 332).        %% 圣盾
-define(WorldVariant_Switch_HolyShieldStage, 333).        %% 圣盾升阶
-define(WorldVariant_Switch_HolyShieldSkill, 334).        %% 圣盾技
-define(WorldVariant_Switch_GameHelper, 335).            %% 小助手
-define(WorldVariant_Switch_FundsDemon, 337).           %% 神魔基金
-define(WorldVariant_Switch_DirectBuyFund, 338).        %% 直购基金总开关，每个基金的单独开关读配置
-define(WorldVariant_Switch_Prophecy, 339).        %% 预言之书 总控
-define(WorldVariant_Switch_quick_hang, 342).   %% 快速讨伐
-define(WorldVariant_Switch_dragon_city_updown, 343).   %% 风暴龙城点赞
-define(WorldVariant_Switch_BlizzardForest, 345).          %% 寒风森林
-define(WorldVariant_Switch_show_box1_synt, 346). %% 外显宝箱-骑宠翼
-define(WorldVariant_Switch_show_box2_synt, 347). %% 外显宝箱-圣物
-define(WorldVariant_Switch_GD_Weapon, 349).          %% 龙神武器
-define(WorldVariant_Switch_GD_Eq, 350).          %% 龙神圣装
-define(WorldVariant_Switch_GreenBless, 351).    %% 蓝钻祈福
-define(WorldVariant_Switch_MerchantShip, 352).        %% 商船
-define(WorldVariant_Switch_GD_Eq_synt, 353).          %% 龙神圣装合成
-define(WorldVariant_Switch_GD_Statue_synt, 354).          %% 龙神雕像合成
-define(WorldVariant_Switch_DungeonPetNew, 355).        %% 新魔宠副本(技能挑战)
-define(WorldVariant_Switch_DG_Weapon_synt, 359).       %% 龙神武器合成
-define(WorldVariant_Switch_Dh_Season, 360).       %% 恶魔狩猎季
-define(WorldVariant_Switch_God_Bless, 367).                %% 神佑
-define(WorldVariant_Switch_DragonSeal, 368).               %% 龙神封印
-define(WorldVariant_Switch_Pill, 369).               %% 磕丹
-define(WorldVariant_Switch_ClientDungeonBless, 370).    %% 循环关祝福
-define(WorldVariant_Switch_New_Card_Recast, 371).         %% 卡片重铸
-define(WorldVariant_Switch_EqPolarity, 374).         %% 装备倾向相关
-define(WorldVariant_Switch_dragon_city, 380).          %% 风暴龙城
-define(WorldVariant_Switch_DomainFight, 381).              %% 领地战
-define(WorldVariant_Online_Reward, 382).              %% 在线时长奖励
-define(WorldVariant_Switch_PetHatch2, 383).              %% 宠物孵蛋2期
-define(WorldVariant_Switch_WeekActive, 384).              %% 周活跃
-define(WorldVariant_Switch_CareerTower_Super, 385).        %% 超级塔
-define(WorldVariant_Switch_E_Download, 403).       %% E好礼
-define(WorldVariant_Switch_Skill2, 416).         %% 技能突破
-define(WorldVariant_Switch_Skill3, 417).         %% 技能觉醒
-define(WorldVariant_Switch_New_Card, 419).         %% 卡片（新图鉴）
-define(WorldVariant_Switch_TreasureChest, 421).         %% 战盟宝库
-define(WorldVariant_Switch_Prophecy1, 422).         %% 预言之书枚举之一（根据配置读取）
-define(WorldVariant_Switch_PetHatch, 423).     %% 宠物孵化
-define(WorldVariant_Switch_EqCollect, 462).        %% 装备收藏
-define(WorldVariant_Switch_EqReborn, 463).        %% 装备收藏再生
-define(WorldVariant_Switch_ServerSeal, 464).        %% 等级封印
-define(WorldVariant_Switch_PetCity, 465).        %% 英雄国度
-define(WorldVariant_Switch_PetBlessEqCast, 466).        %% 英雄装备祝福

-define(WorldVariant_Switch_PetSacredEq, 468).        %% 英雄圣装
-define(WorldVariant_Switch_LavaFight, 469).            %% 熔岩角斗场
-define(WorldVariant_Switch_PetSacredEqBp, 470).        %% 英雄圣装BP
-define(WorldVariant_Switch_Nationality, 493).      %% 国籍 区域
-define(WorldVariant_Switch_FundsGodDragon, 498).       %% 龙神基金

-define(WorldVariant_Switch_GiftPackageBuy11, 502).     %% 直购礼包1
-define(WorldVariant_Switch_GiftPackageBuy12, 503).     %% 直购礼包2
-define(WorldVariant_Switch_GiftPackageBuy13, 504).     %% 直购礼包3
-define(WorldVariant_Switch_GiftPackageBuy14, 505).     %% 直购礼包4
-define(WorldVariant_Switch_GiftPackageBuy15, 506).     %% 直购礼包5
-define(WorldVariant_Switch_GiftPackageBuy16, 507).     %% 直购礼包6
-define(WorldVariant_Switch_GameFcm_Time_Limit, 508).     %% 防沉迷累计在线时间登录限制
-define(WorldVariant_Switch_GameFcm_Time_fix_Limit, 509). %% 防沉迷指定时间登录限制
-define(WorldVariant_Switch_GameFcm_Recharge, 510).     %% 防沉迷充值限制
-define(WorldVariant_Switch_GameFcm_Time, 511).         %% 防沉迷每日累计时间提醒
-define(WorldVariant_Switch_GameFcm_Time_fix, 512).     %% 防沉迷每日固定时间提醒
-define(WorldVariant_Switch_GameFcm_Time_kickout, 513).          %% 防沉迷每日累计时间强制离线
-define(WorldVariant_Switch_GameFcm_Limit_kickout, 514).         %% 防沉迷每日指定时间强制离线
-define(WorldVariant_Switch_Constellation, 516).        %% 星座
-define(WorldVariant_Switch_Constellation_Star_Soul_Eq1, 517).  %% 合成 星魂龙装
-define(WorldVariant_Switch_Constellation_Star_Soul_Eq2, 518).  %% 合成 星魂神装
-define(WorldVariant_Switch_RuneAddStage, 519).       %% 龙印升阶
-define(WorldVariant_Switch_SoulAddStage, 520).       %% 神魂升阶
-define(WorldVariant_Switch_border_war, 521).          %% 边境入侵
-define(WorldVariant_Switch_Constellation_Star_Soul_Eq3, 526).  %% 合成 星魂龙神装
-define(WorldVariant_Switch_ShenHuaLevel, 527).        %% 神话等级
-define(WorldVariant_Switch_Ancient_Holy_Eq, 528). %% 古神圣装
-define(WorldVariant_Switch_change_career, 529).          %% 职业切换
-define(WorldVariant_Switch_Ancient_Holy_Eq_Synthetic, 530).          %% 古神圣装合成
-define(WorldVariant_Switch_Ancient_Holy_Eq_Awaken, 532). %% 古神圣装觉醒
-define(WorldVariant_Switch_GodFight, 535).           %% 主神争夺
-define(WorldVariant_Switch_DungeonGod, 536).           %% 神力战场
-define(WorldVariant_Switch_DivineGod, 537).           %% 神位
-define(WorldVariant_Switch_BonfireBoss, 538).           %% 篝火BOSS
-define(WorldVariant_Switch_DivineTalent, 539).           %% 神力天赋
-define(WorldVariant_Switch_HolyWing, 541).                 %% 圣翼
-define(WorldVariant_Switch_EqEleAdd, 545).                 %% 装备元素强化
-define(WorldVariant_Switch_Bloodline, 546).                %% 血脉
-define(WorldVariant_Switch_Constellation_Awaken, 550).     %% 星魂觉醒
-define(WorldVariant_Switch_Constellation_Bless, 551).      %% 幸运祝福
-define(WorldVariant_Switch_MountEleAwaken, 552).       %% 坐骑元素觉醒
-define(WorldVariant_Switch_WingEleAwaken, 553).        %% 翅膀元素觉醒
-define(WorldVariant_Switch_Constellation_BlessPro, 554).   %% 星魂祝福
-define(WorldVariant_Switch_PetGradeUp, 555).       %% 宠物升品
-define(WorldVariant_Switch_ShengJia, 556).   %% 圣甲
-define(WorldVariant_Switch_ShengJia_gem, 557).   %% 圣甲镶嵌

-define(WorldVariant_Switch_Shengwen, 558).                %% 圣纹
-define(WorldVariant_Switch_XunBao_7, 559).                %% 7圣纹寻宝
-define(WorldVariant_Switch_ElementTrial, 560).         %% 元素试炼
-define(WorldVariant_Switch_ShengwenDragonSynt, 561).    %% 圣纹龙装合成
-define(WorldVariant_Switch_ShengwenGodSynt, 562).        %% 圣纹神装合成
-define(WorldVariant_Switch_ShengwenAddStage, 563).        %% 圣纹升阶
-define(WorldVariant_Switch_DarkFlame, 564).            %% 暗炎魔装
-define(WorldVariant_Switch_DarkFlame_Synthetic, 565).            %% 暗炎魔装合成
-define(WorldVariant_Switch_DemonReward, 567).          %% 恶魔悬赏令
-define(WorldVariant_Switch_XunBao_8, 568).                %% 8 神兵寻宝
-define(WorldVariant_Switch_XunBao_9, 569).                %% 9 神纹寻宝

-define(WorldVariant_Switch_DressUp, 584).                %% 时装
-define(WorldVariant_Switch_elite_dungeon, 586).        %% 精英副本
-define(WorldVariant_Switch_PetBlessEq, 589).        %%英雄装备

-define(WorldVariant_Switch_NewBountyTask, 591).        %% 新赏金任务
-define(WorldVariant_Switch_King1v1, 593).              %% 新王者1v1
-define(WorldVariant_Switch_King1v1_Cup, 595).              %% 王者1v1奖杯
-define(WorldVariant_Switch_XunBao_13, 596).              %% 13 宝石寻宝
-define(WorldVariant_Switch_XunBao_14, 597).              %% 14 卡片寻宝

-define(WorldVariant_Dragon_Badge, 600).              %% 个人荣耀龙徽
-define(WorldVariant_Mainline_Seal, 601).              %% 主线封印
-define(WorldVariant_Mainline_Seal_Hunter, 602).       %% 主线封印-猎魔大赛
-define(WorldVariant_Switch_Recharge_Packs, 603).       %% 直购礼包
-define(WorldVariant_Switch_Seckill_Gift, 604).         %% 每日秒杀礼包
-define(WorldVariant_Switch_NewDailyRecharge, 619).        %% 新每日累充
-define(WorldVariant_Switch_AwakenRoadBp_1, 620).        %% 觉醒之路战令1
-define(WorldVariant_Switch_AwakenRoadBp_2, 621).        %% 觉醒之路战令2
-define(WorldVariant_Switch_AwakenRoadBp_3, 622).        %% 觉醒之路战令3

-define(WorldVariant_Switch_LevelSeal, 642).               %% 等级封印
-define(WorldVariant_Switch_LevelSealDungeon, 643).        %% 封印副本
-define(WorldVariant_Switch_TimeLimitGiftPlus, 644).        %% 限时特惠
-define(WorldVariant_Switch_DungeonsBless, 646).        %% 天神祝福
-define(WorldVariant_Switch_RechargeRedEnvelope, 647).        %% 首充红包
-define(WorldVariant_Switch_FeedBack, 648).        %% 问题反馈
-define(WorldVariant_Switch_Recharge_Packs_Novice, 650).       %% 直购礼包-新手礼包
-define(WorldVariant_Switch_Recharge_Packs_Daily, 651).        %% 直购礼包-日礼包
-define(WorldVariant_Switch_Recharge_Packs_Weekly, 652).       %% 直购礼包-周礼包
-define(WorldVariant_Switch_Recharge_Packs_Monthly, 653).      %% 直购礼包-月礼包
-define(WorldVariant_Switch_Recharge_Packs_Treasure, 654).     %% 直购礼包-寻宝礼包
-define(WorldVariant_Switch_ServerSeal_Contest, 655).     %% 封印比拼
-define(WorldVariant_Switch_DailyShare, 656).     %% 每日分享
-define(WorldVariant_Switch_Bloodline2001, 658).     %% 幽冥血脉 2001
-define(WorldVariant_Switch_Bloodline2002, 659).     %% 丰饶血脉 2002
-define(WorldVariant_Switch_Bloodline2003, 660).     %% 自然血脉 2003
-define(WorldVariant_Switch_Bloodline2004, 661).     %% 狩月血脉 2004
-define(WorldVariant_Switch_Fazhen, 662).        %%法阵符文
-define(WorldVariant_Switch_CareerTower_Main, 696).     %% 宠物塔
-define(WorldVariant_Switch_CareerTower_1004, 665).     %% 职业塔 战士塔
-define(WorldVariant_Switch_CareerTower_1005, 666).     %% 职业塔 法师塔
-define(WorldVariant_Switch_CareerTower_1006, 667).     %% 职业塔 弓手塔
-define(WorldVariant_Switch_CareerTower_1007, 668).     %% 职业塔 圣职塔
-define(WorldVariant_Switch_ExpeditionFight, 672).   %% 普通城战
-define(WorldVariant_Switch_ExpeditionImperialFight, 673).   %% 皇城战
-define(WorldVariant_Switch_EXPEDITION_HUNT, 674).   %% 远征猎魔
-define(WorldVariant_Switch_EXPEDITION_FORCE, 675).   %% 远征强征
-define(WorldVariant_Switch_Constellation_Gem, 676).  %% 星石镶嵌、星石技能
-define(WorldVariant_Switch_ExpeditionDemonCome, 677).    %% 远征-巨魔降临
-define(WorldVariant_Switch_ExpeditionExplore, 678).    %% 远征探险
-define(WorldVariant_Switch_Expedition_card, 679).    %% 远征图鉴
-define(WorldVariant_Switch_Destiny_Guard, 680).    %% 天命守护
-define(WorldVariant_Switch_EXPEDITION_NOBILITY, 682).    %% 远征爵位
-define(WorldVariant_Switch_GuildInsZones, 683).    %% 公会副本
-define(WorldVariant_Switch_MysteryShop, 684).    %% 神秘商店
-define(WorldVariant_Switch_PetAtlas, 685).     %% 宠物图鉴
-define(WorldVariant_Switch_PetNormalDraw, 690).     %% 宠物普通抽奖
-define(WorldVariant_Switch_PetSeniorDraw, 691).     %% 宠物高级抽奖
-define(WorldVariant_Switch_PetSubstitutionLow, 692).     %% 宠物低星置换
-define(WorldVariant_Switch_PetSubstitutionHigh, 693).     %% 宠物高星置换
-define(WorldVariant_Switch_PetLink, 694).     %% 宠物链接
-define(WorldVariant_Switch_PetAppendage, 695).     %% 宠物附灵
-define(WorldVariant_Switch_Recharge_Packs_Reincarnate, 700).     %% 直购礼包-转生礼包
-define(WorldVariant_Switch_PetShengShu, 701).     %% 英雄圣树
-define(WorldVariant_Switch_RechargeFirstType, 711).     %% 首充类型 = 0 累充 = 1 直购
-define(WorldVariant_Switch_DemonHunter, 717).     %% 深渊猎魔
-define(WorldVariant_Switch_Relic_illusion, 718).     %% 圣物幻化
-define(WorldVariant_Switch_XunBao_15, 719).        %% 15 黄金寻宝
-define(WorldVariant_Switch_Recharge_Packs_Expedition, 720).     %% 直购礼包-远征礼包
-define(WorldVariant_Switch_RechargeFirstTotalType, 721).     %%  首充类型 = 0 按711类型判断 =1 4档位累充版首充
-define(WorldVariant_Switch_Recharge_Packs_King1v1, 722).     %% 直购礼包-1v1礼包
-define(WorldVariant_Switch_King1v1_Cup_Star, 723).     %% 1v1 奖杯升星
-define(WorldVariant_Switch_King1v1_DG_Star, 726).        %% 神像 圣装升星
-define(WorldVariant_Switch_PantheonBp, 727).            %% 黄金bp
-define(WorldVariant_Switch_ReturnOld, 730).        %% 回归-老服
-define(WorldVariant_Switch_ReturnNew, 731).        %% 回归-新服
-define(WorldVariant_Switch_ReinBp, 744).            %% 转生bp
-define(WorldVariant_Switch_SyBp, 745).            %% 深渊猎魔BP
-define(WorldVariant_Switch_PetCityBp, 746).    %% 家园BP
-define(WorldVariant_Switch_PetBlessEqSoulStone, 747).    %% 英雄魂石
-define(WorldVariant_Switch_XunBao_16, 749).        %% 16 坐骑装备寻宝
-define(WorldVariant_Switch_PurpleDiamondShop, 766). %% 紫钻商店
-define(WorldVariant_Switch_Lottery, 767).
-define(WorldVariant_Switch_Ad_Code_Exchange, 768).        %% 广告码兑换
-define(WorldVariant_Switch_ExclusiveTotalRecharge, 770).        %% 专属累充
-define(WorldVariant_Switch_GuildWar, 748).        %% 联服公会战

-define(WorldVariant_Switch_GuideNotice, 750).        %% 功能预告

-define(WorldVariant_Switch_DungeonSkillCombat, 769).   %% 战技试炼
-define(WorldVariant_Switch_WeddingCard, 774).          %% 结婚理财

-define(WorldVariant_Switch_SpecialRecharge, 771).   %%特惠储值
-define(WorldVariant_Switch_PetCultivationTransfer, 778).    %% 英雄养成转移
-define(WorldVariant_shop_cart, 779).   %% 商城购物车
-define(WorldVariant_TopBroadcast, 780).   %% 播报
-define(WorldVariant_Switch_PetIllusion, 781).   %% 英雄幻化
-define(WorldVariant_OnlineAnnounce, 782).   %% 上线公告
-define(WorldVariant_MainStatue, 783).      %% 主城雕像
-define(WorldVariant_Switch_UrCard, 787).     %% UR卡片
-define(WorldVariant_Switch_ExpeditionAwardControl, 788).     %% 远征城池历史奖励，领取控制
-define(WorldVariant_Switch_HolyShieldBp, 784).     %% 圣盾bp
-define(WorldVariant_Switch_FundsGodKing, 789).     %% 神王基金
-define(WorldVariant_Switch_FundsGodGrand, 790).     %% 神皇基金
-define(WorldVariant_Switch_FundsShangGu, 791).        %%上古基金
-define(WorldVariant_Switch_FundsYuanGu, 792).        %%远古基金
-define(WorldVariant_Switch_FundsTaiGu, 793).        %%太古基金
-define(WorldVariant_Switch_FundsBuXiu, 794).        %%不朽基金
-define(WorldVariant_Switch_ShengJiaBp, 795).   %% 圣甲Bp
-define(WorldVariant_Switch_PlayerRing, 800).   %% 信物
-define(WorldVariant_Switch_PetUnknownDraw, 807).     %% 宠物未知抽奖
-define(WorldVariant_Switch_XunBao_17, 809).        %% 17	泰坦寻宝
-define(WorldVariant_Switch_EntityLottery, 811).
-define(WorldVariant_Switch_PraisesPop, 812).  %%好评弹窗
-define(WorldVariant_Switch_MondayReward, 817).  %% 周一奖励
-define(WorldVariant_Switch_GD_Weapon_Star, 818).   %% 神像武器-升星
-define(WorldVariant_Switch_FwingLevel, 819).   %% 飞翼升级
-define(WorldVariant_Switch_SkinLottery, 820).
-define(WorldVariant_Switch_ClusterWorldLevel, 821). %% 联服世界等级

-define(WorldVariant_Switch_AwakenRoadBp_4, 835).        %% 觉醒之路战令4 永恒战令
-define(WorldVariant_Switch_XunBao_3, 836).        %%  3 坐骑装备寻宝
%% 服务器使用的私有世界变量 不需要同步客户端
-define(SERVER_PRIVATE, [
	?WorldVariant_AcceleratorCheckInfo,
	?WorldVariant_YanMoLevel
]).


%% TODO 玩家动态变量第一段：每日重置
-define(VARIABLE_PLAYER_RESET_LifeCard, 3). %% 终身卡今日领取标记
-define(VARIABLE_PLAYER_RESET_LifeCard_Bit1, 1). %% 普通终身卡今日领取标记
-define(VARIABLE_PLAYER_RESET_LifeCard_Bit2, 2). %% 至尊终身卡今日领取标记
-define(Variant_Index_4_isSignin, 4).    %% 是否签到
-define(VARIABLE_PLAYER_RESET_TradeCurrency, 5). %% 交易行每日已提取元宝数量
-define(VARIABLE_PLAYER_RESET_GoldFree, 6). %% 每日已使用福利钻石数量
-define(VARIABLE_PLAYER_RESET_GoldRevive, 7). %% 钻石复活次数
-define(VARIABLE_PLAYER_RESET_ClientReward, 8).  %% 客户端领奖
-define(VARIABLE_PLAYER_RESET_ClientReward_Bit1, 1). %% FB分享领奖＆VK分享领奖
-define(Variant_Index_9_GuildDepot_ExchangeTimes, 9).   %% 战盟仓库兑换次数
-define(Variant_Index_10_GuildSysEnvelope, 10). %% 领取战盟每日红包
-define(Variant_Index_11_CarnivalMail, 11). %% 嘉年华邮件
-define(Variant_Index_12_CloudBuyGet, 12). %% 云购领取状态 <<自己领取进度:16, 全服领取进度:16>>
-define(VARIABLE_PLAYER_RESET_ChatFreeNum, 13). %% 每日已使用免费聊天次数
-define(VARIABLE_PLAYER_RESET_ChatTranslate, 14). %% 每日已使用聊天翻译次数
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN, 15).          %% 龙城雕像点赞
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT1, 1).      %% 2106008 赞
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT2, 2).      %% 2106008 踩
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT3, 3).      %% 2106009 赞
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT4, 4).      %% 2106009 踩
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT5, 5).      %% 2106010 赞
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT6, 6).      %% 2106010 踩
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT7, 7).      %% 2106011 赞
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT8, 8).      %% 2106011 踩
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT9, 9).      %% 2106012 赞
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_BIT10, 10).    %% 2106012 踩
-define(VARIABLE_PLAYER_RESET_DRAGON_CITY_UPDOWN_MANOR_TIME, 16).          %% 龙城雕像点赞领地时间
-define(Variant_Index_14_AF_FreeBoxTime, 17).  %% 深海角斗今日已经使用免费开宝箱次数
-define(Variant_Index_18_WorldBossBuffID1Num, 18).  %% 炎魔试炼复活buff
-define(Variant_Index_19_EnergyOverFlow, 19).  %% 溢出的死亡森林体力（找回使用）
-define(Variant_Index_20_StrengthOverFlow, 20).  %% 溢出的主线体力 （找回使用）
-define(Variant_Index_21_SuperBossAwardTimes, 21).  %%  死亡森林超级boss奖励
-define(Variant_Index_22_FreeEnergy, 22).
-define(Variant_Index_22_FreeEnergy1, 1).  %% 免费体力次数（中午）12:00-14:00
-define(Variant_Index_22_FreeEnergy2, 2).  %% 免费体力次数（下午）18:00-20:00
-define(Variant_Index_22_FreeEnergy3, 3).  %% 免费体力次数（晚上）21:00-23:00
-define(Variant_Index_23_VipCardExp, 23).  %% 今日使用vip卡获得的vip经验
-define(Variant_Index_24_GMAsk, 24).  %% GM留言次数
-define(Variant_Index_25_ReinHelpTime, 25).        %% 转生今天帮助压制次数
-define(Variant_Index_26, 26).                    %%每日充值
-define(Variant_Index_26_Bit3, 3).                 %%玩家是当日否领取小助手每日奖励
-define(Variant_Index_26_Bit12, 12).    %% 玩家每日是否进入跨服比武
-define(Variant_Index_26_Bit18, 18).    %% 低于世界等级的每日奖励是否发放
-define(Variant_Index_26_Bit20, 20).    %% 龙神骑士每日奖励
-define(Variant_Index_26_Bit21, 21).    %% 版本预告每日奖励
-define(Variant_Index_26_Bit22, 22).    %% 领地战预告邮件
-define(Variant_Index_26_Bit23, 23).    %% 终生卡每日奖励
-define(Variant_Index_26_Bit24, 24).    %% 月理财每日奖励
-define(Variant_Index_26_Bit25, 25).    %% 基金每日奖励
-define(Variant_Index_26_Bit26, 26).    %% 月卡每日奖励
-define(Variant_Index_26_Bit27, 27).    %% 月卡宠物抽卡免费1次是否使用
-define(Variant_Index_28_DragonBadge_Exp, 28).  %% 今日已购买龙徽经验
-define(Variant_Index_29_TradingMarketTake, 29).  %% 今日已提取的钻石
-define(Variant_Index_30_TradingMarketGoldShelveTimes, 30).  %% 今日已上架粉钻份数
-define(Variant_Index_31_OnlineTime, 31).  %% 今日在线时长(5点起算)
-define(Variant_Index_32_DemonsBorderEnterTimes, 32).   %% 边境反击参与次数
-define(Variable_Player_FiveBountyNotice, 33).        %% 五星赏金 每日公告最大次数
-define(Variant_Index_34_WorshipTimes, 34). %% 膜拜次数 todo 废弃
-define(Variant_Index_35_GuidHelpScore, 35). %% 协助每日积分上限 <<今日获得积分:16, 协助者奖励次数:8, 求助者奖励次数:8>>
-define(Variant_Index_36_GiveStamina, 36).      %% 每日赠送耐力次数
-define(Variant_Index_36_GiveStamina_GiveGoldStamina, 1). %% 是否高级赠送 1：已经赠送
-define(Variant_Index_36_GiveStamina_ReciveGoldStamina, 2). %% 是否领取高级赠送 1：已经领取
-define(Variant_Index_37_GuildGuardEnterWave, 37).      %% 守卫战盟进入时是第几波怪
-define(Variant_Index_38_XORoomEnterWave, 38).          %% XO房间进入时是第几道题
-define(Variant_Index_37_GuildCampTime, 39).      %% 战盟篝火进入时开始多久了(秒)
-define(Variant_Index_40_1v1Times, 40).    %% 1v1已打的次数（找回用）
-define(Variant_Index_43_ReciveEnergyTimes, 43). %% 领取耐力次数
-define(Variant_Index_44_GuildWishTimes, 44).   %% 发布心愿的次数
-define(Variant_Index_45_GuildWishGiveCount, 45). %% 赠送人数
-define(Variant_Index_46_WorldBossEnterTime, 46). %%进入世界BOSS的时间戳，用于复活时间计算
-define(Variant_Index_47_LoveValue, 47). %%今日获得的爱心值
-define(Variant_Index_48_QuickHangAwardTimes, 48).  %% 快速讨伐次数
-define(Variant_Index_49_FreeEnergy, 49).  %% 当日获得的回复体力总值
-define(Variant_Index_50_IsOpenNext, 50).  %%本次战斗是否开启了下一关（eg:活动副本战斗后是否开启了下一关）0未开启；1开启了下一关
-define(Variant_Index_51_TodayIsQuitGuild, 51). %% 当天是否退出仙盟
-define(Variant_Index_52_ArenaDayFightTime, 52).    %% 竞技场玩家每次参与次数
-define(Variable_player_reset_DungeonGodEnterTime, 53).     %% 神力战场进入次数
-define(Variant_Index_56_RechargeNum, 56).  %% 充值次数
-define(Variant_Index_57_RechargePrice, 57).  %% 充值金额
-define(Variant_Index_58_RechargeAmount, 58).  %% 充值数额(0点重置)
-define(Variant_Index_59_RechargeAmount, 59).  %% 充值数额(5点重置)
-define(Variant_Index_60_ExclusiveRechargeAmount, 60).  %% 第三方充值数额(0点重置)
-define(Variant_Index_62_ConvoyTimes, 62).  %% 运镖次数
-define(Variant_Index_63_DemonSeaTimes, 63). %% 今天进入恶魔之海的次数  0
-define(Variant_Index_64_DemonSeaCanEnterTime, 64). %% 可以进入的时间  为0或者小于此时间可以进入
-define(Variant_Index_68_DemonCMBuyTimes, 68).   %% 剑台除魔购买次数
-define(Variant_Index_69_DemonCMBuyTimesVip, 69).   %% 剑台除魔VIP已经购买次数
-define(VARIABLE_PLAYER_RESET_1v1RecoverTimes, 70). %% 1v1每日恢复的次数
-define(VARIABLE_PLAYER_RESET_1v1DailyBuyTimes, 71). %% 1v1每日购买的次数
-define(VARIABLE_PLAYER_RESET_EqFreeCastTime, 74). %% 玩家装备免费洗练每日已经使用的次数
-define(VARIABLE_PLAYER_RESET_FeteType1, 75).   %% 战盟祭祀1
-define(VARIABLE_PLAYER_RESET_FeteType2, 76).   %% 战盟祭祀2
-define(VARIABLE_PLAYER_RESET_FeteType3, 77).   %% 战盟祭祀3
-define(VPR_BountyTaskStep, 78).   %% 赏金任务环数
-define(VPR_BountyTaskLottery, 79).   %% 赏金任务抽奖次数
-define(VPR_BountyTaskLotteryMask, 80).   %% 赏金任务抽奖抽到的索引的掩码
-define(Variable_Player_EnvelopeGoldNum, 81).   %% 仙盟红包元宝数量
-define(Variable_Player_EnvelopeSendNum, 82).   %% 仙盟发红包数量
-define(Variable_Player_GuildDailyItem, 83).    %% 战盟工资
-define(Variable_Player_Assistant, 84).     %% 副本助战次数
-define(Variant_Index_85_BlzForestTimes, 85). %% 今天进入寒风森林的次数  0
-define(Variant_Index_86_BlzForestCanEnterTime, 86). %% 可以进入的时间  为0或者小于此时间可以进入
-define(Variable_Player_EnvelopeVipCard, 87).   %% 红包获得的VIP卡数量
-define(Variable_Player_shop_red_point, 89).        %% 上线VIP商店红点推送
-define(Variable_Player_SWDYBoss_red_envelope, 90).        %% 死亡地狱发红包数（原恶魔入侵）
-define(Variable_Player_BorderConveneTimes, 91).    %% 当天边境召集次数
-define(Variable_Player_BorderConveneLastTime, 92). %% 当天边境最后召集时间
-define(Variable_player_JTCM_Times, 93).    %% 进入剑台除魔次数
-define(VPR_AcceleratorTimes, 94). %% 使用加速的次数
-define(Variable_Player_convoyRefreshTimes, 95).    %% 护送魔晶免费刷新次数
-define(Variable_Player_reset_announce, 96).    %% 战盟祭祀广播标记
-define(Variable_Player_reset_announce_1, 1).    %% 战盟祭祀广播1标记
-define(Variable_Player_reset_announce_2, 2).    %% 战盟祭祀广播2标记
-define(Variable_Player_reset_announce_3, 3).    %% 战盟祭祀广播3标记
-define(Variable_Player_reset_dailyHangTime, 97).    %% 每日离线挂机时间
-define(Variable_Player_reset_BuyCoupleTimes, 98).  %% 购买情侣试炼的挑战次数 todo 废弃
-define(Variable_player_reset_Enter, 99).   %% 玩家是否参与某个活动
-define(Variable_player_reset_Enter_Bit1, 1).   %% 血色争霸
-define(Variable_player_reset_Enter_Bit2, 2).   %% 魔龙洞窟
-define(Variable_player_reset_Enter_Bit3, 3).   %% 炎魔试炼
-define(Variable_player_reset_Enter_Bit4, 4).   %% 守卫战盟
-define(Variable_player_reset_Enter_Bit5, 5).   %% 战盟争霸
-define(Variable_player_reset_Enter_Bit6, 6).   %% XO房间
-define(Variable_player_reset_Enter_Bit7, 7).   %% 巅峰3V3
-define(Variable_player_reset_Enter_Bit8, 8).   %% 战盟篝火
-define(Variable_player_reset_Enter_Bit9, 9).   %% 领地战
-define(Variable_player_reset_Enter_Bit10, 10). %% 篝火boss
-define(Variable_player_reset_Enter_Bit11, 11). %% 参与联动超级boss
-define(Variable_Player_reset_OtherBuyCoupleTimes, 100).    %% 对象购买情侣试炼的挑战次数 todo 废弃
-define(VARIABLE_PLAYER_RESET_MAX, 100). %% TODO 第一段最大100

%% TODO 玩家动态变量第二段：每日重置
-define(VARIABLE_PLAYER_RESET_MIN, 1000). %% TODO 第二段最小1000

%% TODO 玩家重置变量：5点重置的放在这个列表里面，否则默认0点重置
-define(PLAYER_RESET_LIST_5, [
	?VARIABLE_PLAYER_RESET_FeteType1,
	?VARIABLE_PLAYER_RESET_FeteType2,
	?VARIABLE_PLAYER_RESET_FeteType3,
	?Variant_Index_44_GuildWishTimes,
	?Variant_Index_45_GuildWishGiveCount,
	?Variant_Index_48_QuickHangAwardTimes,
	?Variable_Player_GuildDailyItem,
	?Variant_Index_38_XORoomEnterWave,
	?Variant_Index_34_WorshipTimes,
	?Variant_Index_35_GuidHelpScore,
	?Variant_Index_37_GuildGuardEnterWave,
	?Variant_Index_37_GuildCampTime,
	?Variable_Player_reset_BuyCoupleTimes,
	?Variable_player_reset_Enter,
	?Variable_Player_reset_OtherBuyCoupleTimes,
	?Variable_player_JTCM_Times,
	?Variant_Index_68_DemonCMBuyTimes,
	?Variant_Index_19_EnergyOverFlow,
	?Variant_Index_20_StrengthOverFlow,
	?Variant_Index_22_FreeEnergy,
	?Variant_Index_59_RechargeAmount,
	?Variant_Index_10_GuildSysEnvelope,
	?Variable_Player_EnvelopeGoldNum,
	?Variant_Index_23_VipCardExp,
	?Variant_Index_29_TradingMarketTake,
	?Variant_Index_31_OnlineTime,
	?Variant_Index_36_GiveStamina,
	?Variant_Index_40_1v1Times,
	?Variant_Index_43_ReciveEnergyTimes,
	?Variant_Index_52_ArenaDayFightTime
]).


%%----------------------------------------------------------------------------------------------------------------------
%% TODO 玩家静态变量：不会重置 相对于前端值加了100, 即后端118, 前端18
-define(FixedVariant_LoginCompensation, 112). %% 登录修复补偿
-define(FixedVariant_LoginCompensation_Bit0, 0). %% 用于初始化变量值
-define(FixedVariant_LoginCompensation_Bit1, 1). %% OB+0 数据升级
-define(FixedVariant_LoginCompensation_Bit2, 2). %% 20240319悬赏补偿
-define(FixedVariant_LoginCompensation_Bit3, 3). %% 20240411圣印改为可堆叠
-define(FixedVariant_LoginCompensation_Bit4, 4). %% 20240430转生bp配置修改补发
-define(FixedVariant_LoginCompensation_Bit5, 5). %% 20240501运营活动问题修复
-define(FixedVariant_LoginCompensation_Bit6, 6). %% 20240606OB+4商店问题数据升级
-define(FixedVariant_LoginCompensation_Bit7, 7). %% OB+6数据升级
-define(VARIABLE_PLAYER_recharge_first, 113). %% 首充第一档领取标记 bit0 是否购买 bit1~bitn 领奖标志
-define(VARIABLE_PLAYER_recharge_first_bit0, 0). %%bit0 是否购买
-define(VARIABLE_PLAYER_life_card, 114). %% 终身卡状态：0-未购买、1-已购买未领奖、2-已领奖 <<2类型:16,1类型:16>>
-define(FixedVariant_Index_15_EnergyRecoverTime, 115).  %% 体力恢复开始时间，0表示不恢复
-define(VARIABLE_PLAYER_Career_Select, 116).   %% 天命守护选择的职业
-define(VARIABLE_PLAYER_xun_bao_choice_level, 117). %% 装备寻宝手动提升等级标记
-define(FixedVariant_Index_18_ClientReward, 118).  %% 客户端领奖
-define(FixedVariant_Index_18_ClientReward_Bit1, 1). %% 下载资源包领奖
-define(FixedVariant_Index_18_ClientReward_Bit2, 2). %% FB分享领奖2 2022.1.6 改为每日重置 移到动态变量
-define(FixedVariant_Index_18_ClientReward_Bit3, 3). %% Kakao分享领奖
-define(FixedVariant_Index_18_ClientReward_Bit4, 4). %% 好评领奖
-define(FixedVariant_Index_18_ClientReward_Bit5, 5). %% 账号绑定领奖
-define(FixedVariant_Index_18_ClientReward_Bit6, 6). %%  E好礼领奖
-define(FixedVariant_Index_18_ClientReward_Bit7, 7). %%  社区关注领奖
-define(FixedVariant_Index_18_ClientReward_Bit8, 8). %%  官方社群领奖
-define(FixedVariant_Index_18_ClientReward_Bit9, 9). %%  手机绑定领奖
-define(FixedVariant_Index_19_FightValueRecoverTime, 119).  %% 比武争斗值恢复开始时间，0表示不恢复
-define(FixedVariant_Index_20_FightValue, 120).  %% 比武争斗值
-define(VARIABLE_PLAYER_subscribe, 121). %% 订阅过期时间，0表示未购买
-define(VARIABLE_PLAYER_recharge_first2, 122). %% 新服累充
-define(VARIABLE_PLAYER_recharge_first2_Bit1, 1). %% 新服累充第1天1档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit2, 2). %% 新服累充第1天2档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit3, 3). %% 新服累充第1天3档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit4, 4). %% 新服累充第2天1档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit5, 5). %% 新服累充第2天2档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit6, 6). %% 新服累充第2天3档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit7, 7). %% 新服累充第3天1档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit8, 8). %% 新服累充第3天2档奖励
-define(VARIABLE_PLAYER_recharge_first2_Bit9, 9). %% 新服累充第3天3档奖励
-define(VARIABLE_PLAYER_recharge_first3, 123). %% 续充状态：0-未开启、1-已领奖、其他-开启时间
-define(VARIABLE_PLAYER_HangSeconds, 124). %% 累积挂机收益时间
-define(FixedVariant_Index_25_UsedMopUpValue, 125).     %% 已使用的主线副本 扫荡点
-define(FixedVariant_Index_26_UsedMopUpValueRecoverTime, 126).  %% 已使用的主线副本 扫荡点恢复开始时间，0表示不恢复
-define(VARIABLE_PLAYER_fight_1v1_grade, 127). %% 王者1V1保留段位
-define(VARIABLE_PLAYER_fight_1v1_score, 128). %% 王者1V1保留积分
-define(FixedVariant_Index_29_LastJoinExpeditionTime, 129). %% 上一次参与远征时的远征开始时间
-define(FixedVariant_Index_30_BoughtMopUpValue, 130).     %% 购买的主线副本 扫荡点
-define(FixedVariant_Index_31_GuildFeteGod, 131).    %% 仙盟祭祀次数
-define(VARIABLE_PLAYER_subscribe_type, 132). %% 订阅类型 1：30天 2：90天
-define(VARIABLE_ATTAINMENT_DeathHillBossNum, 133).%%成就系统-211-记录死亡地狱新手场boss死亡次数
%%-define(FixedVariant_Index_34_KillMonster, 134).     %% 击杀怪物数量
-define(FixedVariant_Index_35_CopyMapWinTimes, 135). %% 挑战剧情副本胜利次数
-define(VARIABLE_PLAYER_arena_top_times, 136). %% 竞技场登顶次数
-define(VARIABLE_PLAYER_arena_max_rank, 137). %% 竞技场历史最大排名
-define(FixedVariant_Index_38_ResetTime, 138).   %% 签到奖励重置时间
-define(VARIABLE_PLAYER_arena_report_notice_time, 140). %% 竞技场战报通知时间
-define(FixedVariant_Index_41_ChangeNameTimes, 141). %% 修改玩家角色名次数
-define(VARIABLE_PLAYER_energy_notify_time, 142). %% 体力满后推送
-define(VARIABLE_PLAYER_fatigue_notify_time, 143). %% 世界BOSS活力值满后推送
-define(FixedVariant_Index_45_MainlineEnergyRecoverTime, 145). %% 主线副本体力恢复开始时间，0表示不恢复
-define(FixedVariant_Index_51_BindAccount, 151).     %% 绑定账号
-define(FixedVariant_MaxMainChapter, 152).     %% 通关主线最大章节
-define(FixedVariant_MainlineSeal_Mask, 153).    %% 玩家主线封印进度<<结束阶段:16,开启阶段:16>>
-define(FixedVariant_Index_55_InvalidDungeonSettleCount, 155).  %%记录玩家客户端副本异常结算次数
-define(FixedVariant_Index_56_ClearQuitGuildTimes, 156).    %% 清除退帮时间次数
-define(FixedVariant_Index_57_TaskFresh, 157).    %% 任务提前完成标记
-define(FixedVariant_Index_57_TaskFresh_Bit1, 1). %% 完成领取挂机收益
-define(FixedVariant_Index_64_SexNum, 164).  %% 修改性别次数
-define(FixedVariant_Index_65_ClearStartTime, 165).  %% 记录第一次退帮时间，每一周清除一次 56（清除退帮时间次数）
-define(FixedVariant_Index_68_AttPoint, 168).    %% 获得的成就点
-define(FixedVariant_Index_69_battleValueMax, 169).  %% 历史最高战力
-define(FixedVariant_Index_70_RechargeNum, 170).  %% 充值次数
-define(FixedVariant_Index_71_RechargePrice, 171).  %% 充值金额
-define(FixedVariant_Index_76_LastRechargeTime, 176).    %% 最后一次充值时间
-define(FixedVariant_Index_77_FirstRechargeTime, 177).    %% 购买首充的时间
-define(FixedVariant_Index_78_FirstRechargeType, 178).    %% 购买首充类型
-define(FixedVariant_Index_79_YesterdayVipLv, 179).    %% 昨日vip等级
-define(FixedVariant_Index_80_NormalLifeCardBuyTime, 180).    %% 普通终身卡购买时间
-define(FixedVariant_Index_81_VipFreeGift, 181).    %% vip免费礼包领取情况 bit n 表示vip等级n是否可领
-define(FixedVariant_Index_82_YesterdayVipLv, 182).    %% 昨日动态vip等级
-define(Variable_Player_3v3_MapLastTime, 186).                      %% 当前场次结束的时间
-define(Variable_Player_3v3_UnSettledMapId, 187).                   %% 3v3还没结算的地图id
-define(Variable_Player_3v3_UnFinishedGroupId, 188).                %% 3v3未结算的上一场阵营ID
-define(FixedVariant_3v3_EscapeTime, 189).            %% 3v3逃跑时的时间戳 + 惩罚时间
-define(FixedVariant_Index_90_7DaySeckill, 190).    %% 每日特惠7日打包购买结束时间

-define(FixedVariant_Index_92, 192).    %% 显示或隐藏标记
-define(FixedVariant_Index_92_Bit_1, 1).            %% HUD显示头衔
-define(FixedVariant_Index_92_Bit_2, 2).            %% 聊天隐藏VIP等级
-define(FixedVariant_Index_92_Bit_3, 3).            %% 不接收全局广播

-define(FixedVariant_3v3_RetrieveHistory, 193).        %% 跨服比武赛季找回数量
-define(FixedVariant_3v3_CountHistory, 194).            %% 3v3赛季总次数
-define(FixedVariant_3v3_CurrSeason, 195).                %% 3v3当前赛季

-define(FixedVariant_Index_96_CareerChangeTime, 196).   %% 职业转换卡上一次使用时间
-define(FixedVariant_Index_100_CeremonyMarryNum, 200).  %% 拜堂次数

-define(FixedVariant_Index_110_King1v1JoinSeason, 210).  %% 王者1v1参与过的赛季 bit1~n分别代码1~n赛季
-define(Variable_Player_112_LastModifyNationalityTime, 212).               %% 最近一次修改区域时间
-define(FixedVariant_Index_119_RuneTowerID, 219). %% 当前已经通关的的龙神塔ID
-define(FixedVariant_Index_120_RuneTowerMax, 220). %% 龙神塔最高层数
-define(FixedVariant_Index_121_RuneTowerPreID, 221). %% 符文塔昨日领取的ID
-define(FixedVariant_Index_122_RunePosNum, 222). %% 符文开启的孔数
-define(FixedVariant_Index_123_AstroAssistNum, 223). %% 万神殿助战孔位数
-define(VARIABLE_PLAYER_EqSmeltLv, 224). %% 装备炼金等级
-define(VARIABLE_PLAYER_EqSmeltExp, 225). %% 装备炼金当前等级的经验， 通常和124一起使用
-define(VARIABLE_PLAYER_BagCapacity, 227). %% 背包容量
-define(VARIABLE_PLAYER_CurHangTime, 228). %% 玩家当前下线离线挂机时间
-define(VARIABLE_PLAYER_RuneTowerNum, 230).     %% 保存龙神塔已通关层数
-define(VARIABLE_PLAYER_PetId, 234). %% 出战的宠物ID
-define(VARIABLE_PLAYER_PetShowId, 244).        %% 出战宠物模型id
-define(Variable_Player_BountyVipExp, 254). %% 赏金任务累计的vip经验
-define(Variable_Player_BountyExpGotSN, 255). %% 赏金任务已经领取经验的条件序号
-define(VARIABLE_PLAYER_LastResetTime5, 256). %% 上次5点重置时间（秒）
-define(VARIABLE_PLAYER_LastResetTime, 257). %% 上次0点重置时间（秒）
-define(VARIABLE_PLAYER_GeniusPoint, 258).    %% 天赋点
-define(VARIABLE_PLAYER_GeniusResetTime, 259).    %% 天赋重置次数
-define(VARIABLE_PLAYER_ChatEmojiGroup, 260).    %% 激活的表情包
-define(Variable_Player_MaxTeamExp, 266).   %% 恶魔广场最大获得经验
-define(Variable_Player_ConvoyCurTimes, 267).   %% 当前品质刷新次数
-define(Variable_Player_LoginGiftDays, 268).    %% 登录奖 登录天数
-define(Variable_Player_FreeBuyGiftGetBit, 269).    %% 0元购奖励领取位
-define(Variable_Player_TeamIntimacyBuff, 270).     %% 好友亲密度buff
-define(Variable_Player_VipGuideTime, 272).            %% vip引导时间(第一次)
-define(Variable_Player_VipGuideAwardBit, 273).        %% vip引导领取情况
-define(Variable_Player_ProphecyGuardState, 274).        %% 预言之书守护任务状态
-define(Variable_Player_DemonAreaTime, 275).        %% 龙神结界进入CD
-define(Variable_Player_SevenGiftGroup, 276).        %% 七天奖组
-define(Variable_Player_SevenGiftPt, 277).            %% 七天奖积分
-define(Variable_Player_OrnamentMasterLv, 279). %% 配饰大师等级
-define(FixedVariant_Index_280_RuneCorePosNum, 280).    %% 核心龙印开放孔数
-define(Variable_Player_PraiseTimes, 281). %% 好评弹窗次数 <<社区关注次数:16, 好评弹窗次数:16>>
-define(Variable_Player_MaxTeamBaseExp, 282).       %% 恶魔广场最大获得基础经验
-define(Variable_Player_LoginDays, 283).    %% 累计登录天数
-define(Variable_Player_GameHelper_Subscribe, 285).     %% 小助手订阅过期时间，0表示未购买
-define(Variable_Player_Border_Score_Rank_Award, 286).     %% 边境入侵服务器排行每日奖励领取时间
-define(Variable_Player_BorderTitle, 287).          %% 边境称号
-define(Variable_Player_BorderRankValidSeason, 288).     %% 边境军衔生效赛季
-define(Variable_Player_Ancient_Holy_Eq_Display, 289). %% 古神圣装外显优先标记
-define(VARIABLE_PLAYER_GodGeniusPoint, 290).    %% 神级天赋点
-define(VARIABLE_PLAYER_Manor_Mail, 291).    %% 领取领地战邮件领取阶段
-define(VARIABLE_PLAYER_Dh_Mail, 292). %% 猎魔邮件领取阶段
-define(Variable_Player_QuickHangAwardTimes, 294).    %% 快速讨伐次数
-define(Variable_Player_Hang_Fix, 295).    %% 挂机修正数
-define(Variable_Player_BountyTask_GuideTask, 297).    %% 赏金任务 引导任务
-define(Variable_Player_YanMo_FirstEnter_Hp, 298).    %% 本次炎魔试炼首次进入时基础血量
-define(Variable_Player_YanMo_ExitTime, 299). %%离开守护世界树的时间戳，用于再次进入时间计算
-define(VARIABLE_PLAYER_client_dungeon_id, 301). %% 客户端副本Id
-define(VARIABLE_PLAYER_succeed_client_dungeon_id, 302). %% 已通关客户端副本Id
-define(VARIABLE_PLAYER_check_point1, 303). %% 埋点1（最多32）
-define(VARIABLE_PLAYER_check_point2, 304). %% 埋点2（预留）
-define(VARIABLE_PLAYER_check_point3, 305). %% 埋点3（预留）
-define(Variable_Player_EquipCupID, 306).     %% 装配的奖杯ID
-define(VARIABLE_PLAYER_VipGift, 307). %% Vip礼包购买记录
-define(VARIABLE_PLAYER_CacheBlessID, 308). %% 缓存祝福ID
-define(VARIABLE_PLAYER_MinorTowerBattleValue, 309). %% 副塔角色战力
-define(Variable_Player_ExpeditionNotes_NobilityID, 310). %% 远征手册历史最高爵位
-define(Variable_Player_Expedition_card_suit_lv, 311).     %% 远征图鉴套装等级
-define(Variable_Player_PetMaster, 313). %% 宠物大师等级
-define(Variable_Player_PetHatchEndTime, 314). %% 宠物孵化完成推送
-define(Variable_Player_DrawVip, 315). %% 25级抽vip奖次数
-define(Variable_Player_CostCoin, 316). %% 累计消耗钻石
-define(Variable_Player_recharge_first_server_day, 317). %% 首充的开服天数
-define(Variable_Player_recharge_total_server_day1, 318). %% 累充1档的开服天数
-define(Variable_Player_recharge_total_server_day2, 319). %% 累充2档的开服天数
-define(Variable_Player_recharge_total_server_day3, 320). %% 累充3档的开服天数
-define(Variable_Player_recharge_first_total_index1, 321). %% 4档位累充的首充档位1 bit0~bit15 达成开服天数 bit16 ~bit31 第n天的领取状态
-define(Variable_Player_recharge_first_total_index2, 322). %% 4档位累充的首充档位2 bit0~bit15 达成开服天数 bit16 ~bit31 第n天的领取状态
-define(Variable_Player_recharge_first_total_index3, 323). %% 4档位累充的首充档位3 bit0~bit15 达成开服天数 bit16 ~bit31 第n天的领取状态
-define(Variable_Player_recharge_first_total_index4, 324). %% 4档位累充的首充档位4 bit0~bit15 达成开服天数 bit16 ~bit31 第n天的领取状态

-define(Variable_Player_King_1v1_Bp1, 325).            %% 王者1v1直购战令到期时间（赛季结束时间）
-define(Variable_Player_King_1v1_Bp2, 326).            %% 王者1v1直购战令到期时间（赛季结束时间）
-define(Variable_Player_MaxFaZhenRuneScore, 327).        %%玩家符文历史最高评分
-define(Variable_Player_ReturnTriggerTime, 328).        %% 回归触发时间
-define(Variable_Player_EliteDungeonBp, 329).           %% 精英副本BP
-define(Variant_Player_VipUpGift, 330).           %% vip额外礼包领取情况

-define(Variable_Player_MaxSacredEqScore, 331).        %%英雄圣装历史最高评分
-define(Variable_Player_PetSacredEq_MasterLv, 332).        %%英雄圣装大师已点亮等级
-define(Variable_Player_FakeBattleValue, 333).        %% 虚假的战力值
-define(Variable_Player_MaxShengJiaScore, 334).        %%圣甲历史最高评价
-define(Variable_Player_WeddingCardBuyTimes, 335).      %% 结婚理财购买次数


-define(VARIABLE_PLAYER_MAX, 350).  %% TODO 最大值必须小于1000


-define(FixBigList,
	[
		?Variable_Player_BountyVipExp - 100,
		?Variable_Player_MaxTeamExp - 100,
		?Variable_Player_MaxTeamBaseExp - 100
	]).

-define(BigList,
	[
	]).

%% 以下为角色变量，一般情况下不使用，单个功能使用超过两个变量建议单独建表
%% 角色动态变量
-define(VARIABLE_ROLE_RESET_MAX, 100). %% TODO 预留100个
%% 角色静态变量 101开始
-define(VARIABLE_ROLE_BattleFactor1, 101). %% 角色总战力系数1
-define(VARIABLE_ROLE_BattleFactor2, 102). %% 角色总战力系数2
-define(VARIABLE_ROLE_AstrolabeNumMax, 103). %% 角色神灵助战数量上限

-define(VARIABLE_ROLE_MAX, 350).

-define(FixRoleBigList, []).

-define(RoleBigList, []).

-endif.        %% -ifndef
