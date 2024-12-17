
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 错误码
%%% @end
%%% Created : 2018-05-08 15:40
%%%-------------------------------------------------------------------
-ifndef(error_hrl).
-define(error_hrl, true).

%% TODO 功能之间函数调用，使用错误码标示错误
%% TODO 命名规则：-define(ERROR_功能名_错误名, 错误码).	错误码 = 功能序号 * 100 + 错误序号(1-99)

-define(ERROR_OK, 0).        %% 成功
-define(ERROR_CHECK_THROW(Error), ((Error =/= ?ERROR_OK) andalso throw(Error))).
-define(CHECK_THROW(Expr, Err), (((Expr) == true) orelse throw(Err))). %% 表达式为false抛出异常
-define(ASSERT_THROW(Expr, Err), ?CHECK_THROW(Expr, Err)).
-define(CHECK_CFG(Cfg), ((Cfg =/= {}) orelse throw(?ERROR_Cfg))).
-define(THROW(Err), (case Err of {error, _} -> throw(Err); _ -> throw({error, Err}) end)).

-define(ERROR_Cfg, 1).      %% 配置错误
-define(ERROR_Param, 2).    %% 参数错误
-define(ERROR_FunctionClose, 3).    %% 功能未开启
-define(ERROR_UNKNOWN, 4).    %% 未知错误
-define(ERROR_GoldFree, 5).  %% 操作未完成
-define(ERROR_Forbidden_Transfer, 6). %% 未知不可传送状态
-define(ERROR_Map_Trans_Forbidden, 7).  %% 地图不可传送
-define(ERROR_Fail, 8).    %% 失败
-define(ERROR_Type, 9).    %% 类型错误
-define(ERROR_BuyType, 10).    %% 购买方式错误
-define(ERROR_NoRole, 11).    %% 角色不存在
-define(ERROR_Translation_Timeout, 12).  %% 翻译超时，请稍后重试
-define(ERROR_Cross_Player, 13).    %% 不能查看其他服玩家
-define(ERROR_DownloadResource, 14).    %% 资源下载未完成
-define(ERROR_MAX, 15). %% 已达上限
-define(ERROR_Timeout, 16).  %% 请求超时，请稍后重试

%% 地图管理
-define(ERROR_map_cfg, 91). %% 地图配置错误
-define(ERROR_map_lookup, 92). %% 地图不存在
-define(ERROR_map_timeout, 93). %% 地图操作超时
-define(ERROR_map_not_allowed, 94). %% 地图不允许进入
-define(ERROR_map_owner_match, 95). %% 地图所有者不匹配
-define(ERROR_map_players_limit, 96). %% 地图进入人数达到上限

%% 1 物品背包
-define(ERROR_item_bag_param, 101). %% 背包操作参数错误
-define(ERROR_item_bag_capacity, 102). %% 背包容量不足
-define(ERROR_item_bag_find_item, 103). %% 背包物品不存在
-define(ERROR_item_bag_expire_time, 104). %% 物品已经过期
-define(ERROR_item_bag_amount, 105). %% 物品数量不足
-define(ERROR_item_bag_max_capacity, 106). %% 背包容量超过最大值
-define(Error_Item_HasNoFatigue, 107).  %% 没有疲劳度
-define(Error_Item_wrong_useType, 108). %% 使用错误类型的道具
-define(Error_Item_Map_Can_Not_Use, 109).   %% 该地图不能使用该物品
-define(Error_Item_Boss_Alive, 110).   %% Boss存活
-define(Error_Item_Use_only_1, 111).    %% 单次只能使用一个
-define(ERROR_item_bag_capacity_2, 112). %%	仓库容量不足
-define(ERROR_item_bag_capacity_3, 113). %% 聚魂背包容量不足
-define(ERROR_item_bag_capacity_5, 114). %% 龙印背包容量不足
-define(ERROR_item_bag_capacity_7, 115). %% 神格背包容量不足
-define(ERROR_item_bag_capacity_11, 116). %% D3英雄装备背包容量不足(原D2魔灵装备背包容量不足)
-define(ERROR_item_bag_capacity_13, 117). %% 翼灵装备背包容量不足
-define(ERROR_item_bag_capacity_15, 118). %% 兽灵装备背包容量不足
-define(ERROR_item_bag_capacity_16, 119). %% 图鉴装备背包容量不足
-define(ErrorCode_ItemUse_MaxLimit, 120).    %% 物品使用次数上限
-define(Error_Item_CannotExtend, 121).    %% 该背包不能扩展
-define(ERROR_item_bag_sell, 122). %% 物品不可出售
-define(ERROR_item_bag_delete, 123). %% 物品不可删除
-define(ERROR_item_bag_cd, 124).    %% 物品使用cd
-define(ERROR_item_bag_SelectNum, 125).    %% 选择数量不对
-define(ERROR_item_bag_capacity_38, 126).    %% 圣纹背包容量不足
-define(ERROR_quick_synthetic_need_item, 127).    %% 快捷合成消耗物品不足
-define(ERROR_item_bag_vip, 128).       %% vip等级不足
-define(ERROR_quick_synthetic_no_target_item, 129).       %% 未找到目标物品
-define(ERROR_item_no_use_when_seal_close, 130).       %% 封印副本尚未开启，无法使用
-define(ERROR_item_bag_capacity_fazhen, 131). %% 法阵背包不足
-define(ERROR_item_bag_capacity_fazhen_rune, 132). %% 符文背包不足
-define(ERROR_item_bag_capacity_replace, 133). %% 背包容量不足，无法进行替换
-define(ERROR_item_bag_capacity_pet_eq, 134). %% 宠物装备背包容量不足

-define(ERROR_item_bag_capacity_50, 135).        %%50 装备寻宝仓库容量不足 1
-define(ERROR_item_bag_capacity_51, 136).        %%51 龙印寻宝仓库容量不足 2
-define(ERROR_item_bag_capacity_52, 137).        %%52 坐骑寻宝仓库容量不足 3
-define(ERROR_item_bag_capacity_53, 138).        %%53 神翼寻宝仓库容量不足 4
-define(ERROR_item_bag_capacity_54, 139).        %%54 魔宠寻宝仓库容量不足 5
-define(ERROR_item_bag_capacity_55, 140).        %%55 巅峰寻宝仓库容量不足 6
-define(ERROR_item_bag_capacity_57, 141).        %%57 圣纹寻宝背包容量不足 7
-define(ERROR_item_bag_capacity_61, 142).        %%61 神兵寻宝仓库容量不足 8
-define(ERROR_item_bag_capacity_62, 143).        %%62 神魂寻宝仓库容量不足 9
-define(ERROR_item_bag_capacity_68, 144).        %%68 宝石寻宝仓库容量不足 10
-define(ERROR_item_bag_capacity_69, 145).        %%69 卡片寻宝仓库容量不足 11
-define(ERROR_item_bag_capacity_83, 146).        %%83 黄金寻宝仓库容量不足 12
-define(ERROR_item_bag_capacity_86, 147).        %%86 坐骑装备寻宝仓库容量不足 13

-define(ERROR_item_bag_capacity_17, 148).        %%17 图鉴背包容量不足
-define(ERROR_item_bag_capacity_19, 149).        %%19 材料背包容量不足
-define(ERROR_item_bag_capacity_20, 150).        %%20 碎片背包容量不足
-define(ERROR_item_bag_capacity_21, 151).        %%20 消耗品背包容量不足
-define(ERROR_item_bag_capacity_22, 152).        %%20 英雄圣装背包容量不足
-define(ERROR_item_bag_capacity_29, 153).        %%29 泰坦装备背包容量不足
-define(ERROR_item_bag_capacity_31, 154).        %%31 古神圣装背包容量不足
-define(ERROR_item_bag_capacity_34, 155).        %%34 圣翼符文背包容量不足
-define(ERROR_item_bag_capacity_36, 156).        %%36 血脉背包容量不足
-define(ERROR_item_bag_capacity_37, 157).        %%37 宝石背包容量不足
-define(ERROR_item_bag_capacity_40, 158).        %%40 暗炎魔装背包容量不足
-define(ERROR_item_bag_capacity_66, 159).        %%66 技能书背包容量不足
-define(ERROR_item_bag_capacity_67, 160).        %%67 卡片背包容量不足
-define(ERROR_item_bag_capacity_75, 161).        %%75 符文精华背包容量不足
-define(ERROR_item_bag_capacity_76, 162).        %%76 星座星石背包容量不足
-define(ERROR_item_bag_capacity_78, 163).        %%78 远征探险储存背包容量不足
-define(ERROR_item_bag_capacity_79, 164).        %%78 边境图鉴背包容量不足
-define(ERROR_item_bag_capacity_82, 165).        %%82 家园背包容量不足
-define(ERROR_item_bag_capacity_84, 166).        %%84 英雄魂石背包容量不足
-define(ERROR_item_bag_capacity_88, 167).        %%86 泰坦装备寻宝仓库容量不足 14
-define(ERROR_item_bag_select_NoCondition, 168). %% 不满足条件，无法领取
%% 2 副本
-define(ERROR_dungeons_param, 201). %% 副本操作参数错误
-define(ERROR_dungeons_state, 202). %% 副本状态错误
-define(ERROR_dungeons_inspire, 203). %% 副本鼓舞次数已满
-define(ERROR_dungeons_dead_time, 204). %% 死亡时间不满足
-define(ERROR_dungeons_MonsterExist, 205). %% 必须杀完当前波次怪物才能刷新下一波怪物
-define(ERROR_dungeons_End, 206). %% 没有下一波怪物了，不能刷新下一波
-define(ERROR_dungeons_Enter, 207). %% 进入地图失败
-define(ERROR_dungeons_Revive_Type, 208). %% 复活方式错误
-define(ERROR_dungeons_Dead_State, 209). %% 死亡状态错误
-define(ERROR_dungeons_Role_Remain, 210). %% 角色未全部死亡
-define(ERROR_dungeons_NoMopInfo, 211). %% 没有扫荡记录

%% 3 恶魔
-define(Error_NoSuch_Map, 301).         %% 没有指定的地图
-define(Error_Demon_Not_Dead, 302).     %% Boss还没死亡

%% 4 挂机
-define(Error_Has_Started, 401).        %% 已经开始挂机了
-define(Error_No_HangCfg, 402).         %% 没有挂机配置
-define(Error_wrong_type, 403).         %% 错误的类型
-define(Error_Quick_Hang_Times, 404).      %% 可用次数不足
-define(Error_Quick_Hang_NoReward, 405).      %% 暂无可领取奖励
-define(Error_Quick_Hang_TimeNotEnough, 406).      %% 快速讨伐次数未达领取要求

%%组队系统 5
-define(ErrorCode_Team_AreadyHave, 501).      %%已有队伍
-define(ErrorCode_Team_NotExist, 502).        %%队伍不存在
-define(ErrorCode_Team_NotOnline, 503).       %%对方不在线
-define(ErrorCode_Team_NotLeader, 504).       %%您不是队长
-define(ErrorCode_Team_NoRequest, 505).       %%没有可处理的请求
-define(ErrorCode_Team_Full, 506).    %%队伍已满
-define(ErrorCode_Team_ObjetAreadyHave, 507).    %%对方已有队伍
-define(ErrorCode_Team_MapNotTeam, 508).      %%地图不可组队
-define(ErrorCode_Team_NotInTeam, 509).       %%没有加入队伍
-define(ErrorCode_Team_AreadyBeLeader, 510).  %%已是队长
-define(ErrorCode_Team_LeaderNotOnline, 511).  %%队长不在线
-define(ErrorCode_Team_LeaveTeam, 512).       %%对方已离开队伍
-define(ErrorCode_Team_ErrorTeam, 513).       %%错误的队伍
-define(ErrorCode_Team_NoMatchTeam, 514).       %%没有可加入的队伍
-define(ErrorCode_Team_LevelNotMatch, 515).       %%等级不足
-define(ErrorCode_Team_SameOneRequest, 516).       %%已有他人申请
-define(ErrorCode_Team_RequestSend, 517).       %%申请已发出
-define(ErrorCode_Team_SomeOnePrepare, 518).    %% 有人没有准备好
-define(ErrorCode_Team_SomeOneEnter, 519).      %% 有人没在主城
-define(ErrorCode_Team_NotSetMap, 520).     %% 还没有设置地图
-define(ErrorCode_Team_FightCount, 521).    %% 进入挑战次数不足
-define(ErrorCode_Team_CoupleMember, 522).  %% 只有2人才能进
-define(ErrorCode_Team_CoupleSex, 523).     %% 队伍必须为一男一女
-define(ErrorCode_Team_NoMember, 524).      %% 战盟没有该玩家
-define(ErrorCode_Team_InviteCD, 525).      %% 对方处于邀请冷却中
-define(ErrorCode_Team_HasMirror, 526).     %% 对方已在队伍中
-define(ErrorCode_Team_HasMember, 527).     %% 无法邀请队伍成员进行助战
-define(ErrorCode_Team_MirrorForbid, 528).  %% 该副本不允许使用战盟助战
-define(ErrorCode_Team_OutMaxTeamNum, 529). %% 超出地图组队人数
-define(ErrorCode_Team_OutMaxMember, 530).  %% 队伍人数过多
-define(ErrorCode_Team_NotSuchOp, 531).     %% 没有这种操作
-define(ErrorCode_Team_In_Help, 532).     %% 协助状态不可组队
-define(ErrorCode_Team_FatigueNotMatch, 533).       %% 活力值不足
-define(ErrorCode_Team_InMatch, 534).       %% 已经处于匹配中
-define(ErrorCode_Team_SelfMapNotTeam, 535).       %% 您在副本或特殊不可申请组队的地图中，请退出后再尝试
-define(ErrorCode_Team_TargetMapNotTeam, 536).       %% 对方在副本或特殊不可申请组队的地图中，无法加入
-define(ErrorCode_Team_HasThisTeam, 537).       %% 已在队伍中
-define(ErrorCode_Team_NotRecConvene, 538).       %% 您正在副本地图中，无法收到队长召集
-define(ErrorCode_Team_CantKickOutSelf, 539).       %% 不能踢出自己
-define(ErrorCode_Team_CantDamage1, 540).       %% 队长没有剩余次数，无法对BOSS造成伤害！
-define(ErrorCode_Team_CantDamage2, 541).       %% 没有剩余次数，无法对BOSS造成伤害！
-define(ErrorCode_Team_CantDamage3, 542).       %% 队长疲劳度已达上限，攻击BOSS不会造成伤害！
-define(ErrorCode_Team_CantDamage4, 543).       %% 疲劳度已达上限，攻击BOSS不会造成伤害！
-define(ErrorCode_Team_CantDamage5, 544).       %% 队长耐力值不足，无法对BOSS造成伤害！
-define(ErrorCode_Team_CantDamage6, 545).       %% 耐力值不足，无法对BOSS造成伤害！
-define(ErrorCode_Team_HasOp, 546).            %% 已在操作中
-define(ErrorCode_Team_HasAgree, 547).        %% 已经同意过了
-define(ErrorCode_Team_TargetFuncClose, 548).        %% 对方未开启该副本

%% 聚魂
-define(ErrorCode_Soul_NoInstance, 601).           %% 灵魂不存在
-define(ErrorCode_Soul_ExistSameAttr, 602).           %% 已经装备的相同属性的灵魂
-define(ErrorCode_Soul_NoPosition, 603).           %% 错误的装备位置
-define(ErrorCode_Soul_PosNoSoul, 604).           %% 当前位置没有装配灵魂
-define(ErrorCode_Soul_LvMax, 605).           %% 已经强化到最大等级了
-define(ErrorCode_Soul_CfgErr, 606).           %% 配置错误
-define(ErrorCode_Soul_StarMax, 607).           %% 以达到最大星级
-define(ErrorCode_Soul_StageMax, 608).           %% 以达到最大阶级

%% 符文 符文塔 神祗
-define(ErrorCode_Rune_NoInstance, 701).           %% 符文不存在
-define(ErrorCode_Rune_ExistSameAttr, 702).           %% 已经装备的相同属性的符文
-define(ErrorCode_Rune_NoPosition, 703).           %% 错误的装备位置
-define(ErrorCode_Rune_PosNoRune, 704).           %% 当前位置没有装配符文
-define(ErrorCode_Rune_LvNotFeed, 705).           %% 等级不满足
-define(ErrorCode_Rune_CfgErr, 706).           %% 配置错误
-define(ErrorCode_Rune_MaxLevel, 707).           %% 强化到最大等级
-define(ErrorCode_RuneTower_CannotIn, 708).           %% 当前关卡不能挑战
-define(ErrorCode_Rune_MaxStar, 709).           %% 以达到最大星级
-define(ErrorCode_Rune_NoFreePos, 710).         %% 槽位或同类型槽位已镶满，需先卸下一个
-define(ErrorCode_Astro_NoMoney, 750).   %% 万神殿装备强化元宝不够
-define(ErrorCode_Astro_CannotDouble, 751).   %% 万神殿装备已经强化过 不能加倍
-define(ErrorCode_Astro_CannotExtend, 752).   %% 万神殿助战位已经达到最大
-define(ErrorCode_Astro_NoAEquip, 753).   %% 万神殿装备不存在
-define(ErrorCode_Astro_CannotEquip, 754).   %% 万神殿装备不能
-define(ErrorCode_Astro_CannotEquip_C, 755).   %% 万神殿装备品质不对
-define(ErrorCode_Astro_CannotEquip_P, 756).   %% 万神殿装备位置不对
-define(ErrorCode_Astro_NoAssistPos, 757).   %% 助战位置不足
-define(ErrorCode_Astro_CannotAssist, 758).   %% 不满足助战条件
-define(ErrorCode_Astro_NoAEquipEquip, 759).   %% 当前没有穿戴装备
-define(ErrorCode_Astro_NotAssist, 760).   %% 当前万神殿没有上阵
-define(ErrorCode_Astro_AssistRepeat, 761).   %% 当前万神殿已经上阵
-define(ErrorCode_Astro_AddLvNoM, 762).   %% 强化没有可消耗的材料
-define(ErrorCode_Astro_NoEqForOneKeyOn, 763).   %% 不能一键装配
-define(ErrorCode_Astro_CanNotDis, 764).   %% 不能拆解
-define(ErrorCode_Rune_MaxStage, 765).           %% 以达到最大阶级
-define(ErrorCode_Astro_VipLv, 766).           %% VIP等级不足
-define(ErrorCode_Astro_ConsumItem, 767).           %% 消耗道具不足
-define(ErrorCode_Rune_NoBless, 768).           %% 该祝福不存在
-define(ErrorCode_Rune_HadBlessNoChoose, 769).           %% 已生成祝福尚未选择
-define(ErrorCode_Rune_BlessNoCreate, 770).           %% 暂无生成祝福的次数
-define(ErrorCode_Rune_CantMopUp, 771).           %% 超过最大扫荡层数
-define(ErrorCode_Astro_CannotEquip_Equipped, 772). %%该契约装备已装配
%% 竞技场
-define(ErrorCode_Arena_MaxBuyTimes, 801).  %% 超出最大可购买次数
-define(ErrorCode_Arena_GoldEnough, 802).  %% 元宝不足
-define(ErrorCode_Arena_NoAward, 803).  %% 没有结算奖励
-define(ErrorCode_Arena_ChangeTimes, 804).  %% 挑战次数不足
-define(ErrorCode_Arena_CannotMopUp, 805).  %% 暂不能扫荡
-define(ErrorCode_Arena_WrongTarget, 806).  %% 错误的目标
-define(ErrorCode_Arena_HighLevelTarget, 807).  %% 不能扫荡排名高的玩家

%% 合成系统
-define(ErrorCode_Synthetic_NoConfig, 901).         %% 没有合成配置
-define(ErrorCode_Synthetic_ConditionEnough, 902).  %% 合成额外条件不足
-define(ErrorCode_Synthetic_BlessingItem, 903).     %% 祝福道具不足
-define(ErrorCode_Synthetic_NeedItem, 904).         %% 消耗道具不足
-define(ErrorCode_Synthetic_NeedCoin, 905).         %% 消耗货币不足
-define(ErrorCode_Synthetic_BagEnough, 906).        %% 背包格子数不足
-define(ErrorCode_Dis_NotNeedDealBind, 907).        %% 道具是非绑的不需要解绑
-define(ErrorCode_Dis_AlreadyInt, 908).             %% 道具已强化过
-define(ErrorCode_Dis_NotExist, 909).               %% 道具不存在
-define(ErrorCode_Synthetic_NoNeedConfig, 910).        %% 没有消耗配置
-define(ErrorCode_Synthetic_GodEq_CantConsume, 911).%% 神装不能消耗
-define(ErrorCode_Synthetic_NeedBackItem, 912).     %% 需要挽回石

%% 装备
-define(ErrorCode_Eq_NotExist, 1001).        %% 装备不存在
-define(ErrorCode_Eq_MaxLevel, 1002).        %% 装备强化达到最大等级
-define(ErrorCode_Eq_MaxAddLevel, 1003).        %% 装备追加达到最大等级
-define(ErrorCode_Eq_NotEquip, 1004).        %% 装备没有被穿戴
-define(ErrorCode_Eq_CastNoLockIndex, 1005).        %% 装备洗练锁定索引不存在
-define(ErrorCode_Eq_CastLockAll, 1006).        %% 装备洗练索引全部锁了
-define(ErrorCode_Eq_CastExtendFail_Lv, 1007).        %% 装备洗练位扩展失败等级不够
-define(ErrorCode_Eq_CastExtendFail_Cost, 1008).        %% 装备洗练位扩展失败消耗不够
-define(ErrorCode_Eq_CastExtendFail_Vip, 1009).        %% 装备洗练位扩展失败Vip不够
-define(ErrorCode_Eq_GemHoleNotActive, 1010).        %% 装备宝石孔未开启
-define(ErrorCode_Eq_CannotEq, 1011).        %% 不能穿戴
-define(ErrorCode_Eq_FreeCastNoTimes, 1012).        %% 免费洗练次数不足
-define(ErrorCode_Eq_SuitLevelMax, 1013).        %% 套装已经打造到最大等级
-define(ErrorCode_Eq_CharacterNotEnough, 1014).        %% 装备品质不够
-define(ErrorCode_Eq_FadeNoEq, 1015).        %% 炼金没有可以消耗的装备
-define(ErrorCode_Eq_CantIntensify, 1016).      %% 不可强化
-define(ErrorCode_Eq_MaxEleLevel, 1017).        %% 装备元素强化达到最大等级
-define(ErrorCode_Eq_EleLevel, 1018).           %% 装备元素强化等级不足
-define(ErrorCode_Eq_MaxEleBreak, 1019).        %% 装备元素突破达到最大等级
-define(ErrorCode_Eq_EleBreak, 1020).           %% 装备元素突破等级不足
-define(ErrorCode_Eq_MaxEleAddLevel, 1021).     %% 装备元素追加达到最大等级
-define(ErrorCode_Eq_MasterNoAdd, 1022).        %% 未达到点亮要求
-define(ErrorCode_Eq_GemTypeErr, 1023).            %% 宝石类型不匹配
-define(ErrorCode_Eq_FadePriviegeConditionNotMet, 1024).            %% 特权激活条件不满足
-define(ErrorCode_Eq_FadePriviegeAlreadyActive, 1025).            %% 特权已激活
-define(ErrorCode_Eq_TooManyIntactNum, 1026).            %% 祝福石使用过量
-define(ErrorCode_Eq_WrongIntactNum, 1027).            %% 祝福石使用数量错误
-define(ErrorCode_Eq_WrongSuitType, 1028).            %% 套装打造类型错误
-define(ErrorCode_Eq_WrongSuitEqQuality, 1029).            %% 套装打造所需品质不足
-define(ErrorCode_Eq_WrongSuitEqStar, 1030).            %% 套装打造所需星级不足
-define(ErrorCode_Eq_WrongSuitEqOrder, 1031).            %% 套装打造所需阶数不足
-define(ErrorCode_Eq_WrongSuitLv, 1032).            %% 套装前置打造未完成
-define(ErrorCode_Eq_WrongSuitNoLv, 1033).            %% 套装尚未打造
-define(ErrorCode_Eq_CantEquipThisHole, 1034).            %% 不能装备在该孔位
-define(ErrorCode_Eq_CantEquipSameTypeCard, 1035).            %% 不能装备相同类型的卡片
-define(ErrorCode_Eq_CardNotOnEquip, 1036).            %% 未装配该卡片
-define(ErrorCode_Eq_NoGemCanOff, 1037).            %% 没有可一键卸下的宝石
-define(ErrorCode_Eq_WrongCardType, 1038).            %% 不同类型卡片不能重铸
-define(ErrorCode_Eq_AlreadyPolarity, 1039).            %% 已为该极性
-define(ErrorCode_Eq_CantChangePolarity, 1040).            %% 不可更换极性
-define(ErrorCode_Eq_MustEquipOrCollect, 1041).            %% 必须穿戴或者收藏
-define(ErrorCode_Eq_ForgeCostNumNotEnough, 1042).            %% 打造消耗数量不足
-define(ErrorCode_Eq_WrongCostEq, 1043).            %% 不可消耗该装备
-define(ErrorCode_Eq_AlreadyEquipOrCollect, 1044).            %% 不可被穿戴或者收藏
-define(ErrorCode_Eq_CantForge, 1045).            %% 不可打造
-define(ErrorCode_Eq_ForgeMaterialNotEnough, 1046).            %% 打造材料不足
-define(ErrorCode_Eq_ForgeCostNumOutRange, 1047).            %% 打造消耗数量过多
-define(ErrorCode_Eq_MustSelectPolarityInAdvance, 1048).            %% 必须先幻化之后才能装备

%% 宠物/坐骑/翅膀/法宝
-define(ErrorCode_Wing_Is_Fly, 1100). %% 飞翼不能重复开启
-define(ErrorCode_YL_LvMax, 1101). %% 翼灵达到等级上限
-define(ErrorCode_SL_LvMax, 1102). %% 兽灵达到等级上限
-define(ErrorCode_L_Award, 1103). %% 没有可领取的奖励
-define(ErrorCode_Pet_PetLvNotMeet, 1109).        %% 炼魂需要的宠物等级不够
-define(ErrorCode_Pet_StarMax, 1110).        %% 该宠物已经达到最大星级
-define(ErrorCode_Pet_LvMax, 1111).        %% 该宠物已经达到最大等级
-define(ErrorCode_Pet_CannotAwaken, 1112).        %% 该宠物不能觉醒
-define(ErrorCode_Pet_FetterCannotActive, 1113).        %% 该宠物羁绊不能激活
-define(ErrorCode_ML_PillMax, 1114).        %% 魔灵嗑丹达到最大值
-define(ErrorCode_Pet_NoSkill, 1115).        %% 此宠物没有该技能
-define(ErrorCode_ML_NoSkillPos, 1116).        %% 魔灵该技能槽未激活
-define(ErrorCode_ML_NoEqPos, 1117).        %% 魔灵该装备槽未激活
-define(ErrorCode_ML_EqCannotAddLv, 1118).        %% 魔灵该装备未装备不能强化
-define(ErrorCode_ML_EqNotEquip, 1119).        %% 未装备
-define(ErrorCode_Pet_addLv_NoCost, 1120).        %% 没有消耗道具
-define(ErrorCode_ML_lvNotMeet, 1121).        %% 魔灵等级不够
-define(ErrorCode_Pet_CannotSublimate, 1122).        %% 该宠物不能炼魂
-define(ErrorCode_Pet_No, 1123).        %% 没有该宠物
-define(ErrorCode_Wing_No, 1124).        %% 没有该翅膀
-define(ErrorCode_Mount_No, 1125).        %% 没有该坐骑
-define(ErrorCode_ML_EqLvMax, 1126).        %% 魔灵装备强化到了最大等级
-define(ErrorCode_YL_EqLvMax, 1127).        %% 翼灵装备强化到了最大等级
-define(ErrorCode_SL_EqLvMax, 1128).        %% 兽灵装备强化到了最大等级
-define(ErrorCode_SL_NoSkillEq, 1129).        %% 没有装备该技能
-define(ErrorCode_ML_VipLvNotEnough, 1130).    %% vip等级不足
-define(ErrorCode_ML_BoxAlreadyOpen, 1131).    %% 技能格已开启
-define(ErrorCode_ML_BoxNotExist, 1132).    %% 技能格不存在
-define(ErrorCode_ML_CannotOpenBox, 1133).    %% 不能开启此技能格
-define(ErrorCode_Wing_CannotSublimate, 1134).        %% 该翅膀不能炼魂
-define(ErrorCode_Wing_FetterCannotActive, 1135).        %% 该翅膀羁绊不能激活
-define(ErrorCode_Wing_PillMax, 1136).        %% 翼灵嗑丹达到最大值
-define(ErrorCode_Wing_NoSkillPos, 1137).        %% 翼灵该技能槽未激活
-define(ErrorCode_Wing_NoEqPos, 1138).        %% 翼灵该装备槽未激活
-define(ErrorCode_YL_lvNotMeet, 1139).        %% 翼灵等级不够
-define(ErrorCode_YL_EqCannotAddLv, 1140).        %% 翼灵该装备未装备不能强化
-define(ErrorCode_Wing_WingLvNotMeet, 1141).        %% 炼魂需要的翅膀等级不够
-define(ErrorCode_FWing_ExpNotEnough, 1142).        %% 飞翼经验不足
-define(ErrorCode_YL_SkillTISOpen, 1143).        %% 触发技能的格子已经开启
-define(ErrorCode_YL_SkillTCannotMK, 1144).        %% 触发技能不能打造
-define(ErrorCode_YL_VipLvNotEnough, 1145).    %% vip等级不足
-define(ErrorCode_YL_BoxAlreadyOpen, 1146).    %% 技能格已开启
-define(ErrorCode_YL_BoxNotExist, 1147).    %% 技能格不存在
-define(ErrorCode_YL_CannotOpenBox, 1148).    %% 不能开启此技能格
-define(ErrorCode_Mount_MountLvNotMeet, 1149).        %% 炼魂需要的坐骑等级不够
-define(ErrorCode_Mount_FetterCannotActive, 1150).        %% 坐骑羁绊不能激活
-define(ErrorCode_Mount_PillMax, 1151).        %% 嗑丹达到最大值
-define(ErrorCode_Mount_NoSkillPos, 1152).        %% 兽灵该技能槽未激活
-define(ErrorCode_Mount_NoEqPos, 1153).        %% 兽灵该装备槽未激活
-define(ErrorCode_SL_lvNotMeet, 1154).        %% 兽灵等级不够
-define(ErrorCode_SL_EqCannotAddLv, 1155).        %% 兽灵该装备未装备不能强化
-define(ErrorCode_SL_SkillTISOpen, 1156).        %% 兽灵触发技能的格子已经开启
-define(ErrorCode_SL_SkillTCannotMK, 1157).        %% 兽灵触发技能不能打造
-define(ErrorCode_Wing_NoSkill, 1158).        %% 此翅膀没有该技能
-define(ErrorCode_SL_VipLvNotEnough, 1159).    %% vip等级不足
-define(ErrorCode_SL_BoxAlreadyOpen, 1160).    %% 技能格已开启
-define(ErrorCode_SL_BoxNotExist, 1161).    %% 技能格不存在
-define(ErrorCode_SL_CannotOpenBox, 1162).    %% 不能开启此技能格
-define(ErrorCode_YL_CannotBreak, 1163).        %% 翼灵不能突破
-define(ErrorCode_SL_CannotBreak, 1164).        %% 兽灵不能突破
-define(ErrorCode_ML_CannotBreak, 1165).        %% 魔灵不能突破
-define(ErrorCode_Pet_CannotBreak, 1166).        %% 宠物不能突破
-define(ErrorCode_Wing_CannotBreak, 1167).        %% 翅膀不能突破
-define(ErrorCode_Mount_CannotBreak, 1168).        %% 坐骑不能突破
-define(ErrorCode_Card_No, 1169).        %% 卡片未激活
-define(ErrorCode_Card_Quality_Max, 1170).        %% 卡片升品到了最大
-define(ErrorCode_Card_FetterCannotActive, 1171).        %% 该卡片羁绊不能激活
-define(ErrorCode_Wing_StarMax, 1172).        %% 该翅膀已经达到最大星级
-define(ErrorCode_Wing_addLv_NoCost, 1173).        %% 没有消耗道具
-define(ErrorCode_Wing_LvMax, 1174).        %% 该翅膀已经达到最大等级
-define(ErrorCode_Wing_CannotFeather, 1175).        %% 该翅膀不能羽化
-define(ErrorCode_Mount_StarMax, 1176).        %% 坐骑已经达到最大星级
-define(ErrorCode_Mount_addLv_NoCost, 1177).        %% 坐骑升级没有消耗道具
-define(ErrorCode_Mount_LvMax, 1178).        %% 坐骑已经达到最大等级
-define(ErrorCode_Mount_CannotAwaken, 1179).        %% 坐骑不能觉醒
-define(ErrorCode_Pet_BreakLingLvLimit, 1180).         %% 宠物突破魔灵等级不够
-define(ErrorCode_Mount_BreakLingLvLimit, 1181).       %% 坐骑突破兽灵等级不够
-define(ErrorCode_Wing_BreakLingLvLimit, 1182).        %% 翅膀突破翼灵等级不够
-define(ErrorCode_Holy_BreakLingLvLimit, 1183).        %% 圣物突破圣灵等级不够
-define(ErrorCode_Mount_Rein, 1184).        %% 坐骑已经转生
-define(ErrorCode_Pet_Rein, 1185).        %% 宠物已经转生
-define(ErrorCode_Wing_Rein, 1186).        %% 翅膀已经转生
-define(ErrorCode_Holy_Rein, 1187).        %% 圣物已经转生
-define(ErrorCode_Consume_Rein, 1188).        %% 转生消耗不足
-define(ErrorCode_Condition_Rein, 1189).        %% 转生条件不足
-define(ErrorCode_Wing_EleActiveCondition, 1190).   %% 未满足条件
-define(ErrorCode_Wing_EleActiveConsume, 1191).     %% 消耗不足
-define(ErrorCode_Wing_EleDuplicateActive, 1192).   %% 重复觉醒元素
-define(ErrorCode_Pet_Cant_GradeUp, 1193).   %% 宠物不可晋升
-define(ErrorCode_Pet_GradeMax, 1194).   %% 宠物晋升达到最大等级
-define(ErrorCode_Pet_Out_Yet, 1195).                %% 该魔宠已经上阵
-define(ErrorCode_Pet_Out_Condition_No, 1196).        %% 魔宠上阵条件未满足
-define(ErrorCode_Pet_Out_No, 1197).                 %% 该位置尚未上阵宠物
-define(ErrorCode_Pet_Out_CantDown, 1198).        %% 该宠物不能下阵
-define(ErrorCode_Pet_Equip_Cant, 1199).            %% 该宠物不能出战


%% 副本
-define(ErrorCode_Dungeon_NoDungeon, 1201).  %% 没有副本数据
-define(ErrorCode_Dungeon_NotBuyTimes, 1202).  %% 不能购买次数的类型
-define(ErrorCode_Dungeon_OutOfMaxBuyTimes, 1203).  %% 超出最大购买次数
-define(ErrorCode_Dungeon_CoinEnough, 1204).  %% 货币不足
-define(ErrorCode_Dungeon_NoConsConfig, 1205).  %% 没有消耗配置
-define(ErrorCode_Dungeon_HasNoCD, 1206).  %% 没有在CD时间内
-define(ErrorCode_Dungeon_NoMerge, 1207).   %% 该副本不能合并
-define(ErrorCode_Dungeon_MergeLevel, 1208).    %% 合并等级不足
-define(ErrorCode_Dungeon_Single, 1209).    %% 单身不能购买
-define(ErrorCode_Dungeon_OtherOffline, 1210).  %% 对方已下线
-define(ErrorCode_Dungeon_ShowWithoutPick, 1211).   %% 能看不能捡
-define(ErrorCode_Dungeon_MaxOwnTimes, 1212).   %% 超过最大拥有次数
-define(ErrorCode_Dungeon_MaxFatigue, 1213).   %% 达到最大疲劳度
-define(ErrorCode_Dungeon_MaxOwnTimes_Couple, 1214).   %% 情侣中已经有人达到最大次数
-define(ErrorCode_3v3_AchieveNotSatisfied, 1215).   %% 3v3成就未达成
-define(ErrorCode_3v3_NoRoom, 1216).                    %% 没有房间无法改变房间设置
-define(ErrorCode_3v3_NotMaster, 1217).            %% 不是房主无法改变房间设置
-define(ErrorCode_Dungeon_TargetOutOfMaxBuyTimes, 1218).    %% 对方超出最大购买次数
-define(ErrorCode_3v3_JoinRoom_HaveRoom, 1219).            %% 已有房间无法加入房间
-define(ErrorCode_3v3_JoinRoom_NoRoom, 1220).            %% 没有该房间无法加入房间
-define(ErrorCode_3v3_HaveRoom, 1221).            %% 已有房间无法创建房间
-define(ErrorCode_3v3_KickPlayer_Self, 1222).            %% 无法踢出自己
-define(ErrorCode_3v3_KickPlayer_NoRoom, 1223).            %% 没有房间了，无法踢人
-define(ErrorCode_3v3_KickPlayer_NotMaster, 1224).            %% 不是房主，无法踢人
-define(ErrorCode_3v3_JoinRoom_OutOfMax, 1225).            %% 人数已满无法加入房间
-define(ErrorCode_3v3_OpenRoom_NoRoom, 1226).            %% 没有房间无法获取房间信息
-define(ErrorCode_3v3_JoinRoom_Fighting, 1227).            %% 对方正在战斗中，无法加入房间

-define(ErrorCode_AF_CanNotSet1, 1228).             %% 不是房主无法设置房间
-define(ErrorCode_AF_CanNotSet2, 1229).             %% 没有房间无法设置房间
-define(ErrorCode_AF_NoRoom, 1230).                 %% 没有房间
-define(ErrorCode_AF_NotInRoom, 1231).              %% 没有在房间
-define(ErrorCode_AF_InviteExistRoom, 1232).        %% 邀请的玩家已经有房间了
-define(ErrorCode_AF_OwnerOpSelf, 1233).            %% 不能操作自己
-define(ErrorCode_AF_NoFreeBoxTime, 1234).          %% 免费开宝箱次数已经用完
-define(ErrorCode_AF_AlreadyOpenBox, 1235).         %% 本次已经开了宝箱了
-define(ErrorCode_AF_CollectOwnerDeny, 1236).       %% 采集物不属于自己
-define(ErrorCode_AF_InTeam, 1237).                 %% 请先退出队伍
-define(ErrorCode_AF_LevelLimit, 1238).             %% 等级不符
-define(ErrorCode_AF_BattleValueLimit, 1239).       %% 战力不符
-define(ErrorCode_AF_MaxMembers, 1240).             %% 房间已满员
-define(ErrorCode_AF_HaveRoom, 1241).               %% 已有房间
-define(ErrorCode_AF_MapDeny, 1242).                %% 该地图无法进行该操作
-define(ErrorCode_AF_AccessDeny, 1243).             %% 没有权限进行该操作
-define(ErrorCode_AF_NotInAc, 1244).                %% 活动未开放
-define(ErrorCode_AF_TargetNotInRoom, 1245).        %% 对象不在房间
-define(ErrorCode_AF_NoTarget, 1246).               %% 目标不存在
-define(ErrorCode_AF_TargetLevelLimit, 1247).       %% 目标等级不符
-define(ErrorCode_AF_TargetBattleValueLimit, 1248). %% 目标战力不符
-define(ErrorCode_AF_MemberMaxLimit, 1249).         %% 有成员参与次数限制

%% 守护
-define(ErrorCode_Guard_Active, 1301).      %% 已经激活
-define(ErrorCode_Guard_BaseConfig, 1302).  %% 没有守护配置
-define(ErrorCode_Guard_CostConfig, 1303).  %% 没有守护消耗配置
-define(ErrorCode_Guard_NoActive, 1304).    %% 不能激活
-define(ErrorCode_Guard_NoLevelUp, 1305).   %% 不能进阶
-define(ErrorCode_Guard_NoRenew, 1306).     %% 不能续期
-define(ErrorCode_Guard_NoGuard, 1307).     %% 没有该守护
-define(ErrorCode_Guard_HadEquip, 1308).    %% 已经装备
-define(ErrorCode_Guard_HasNoActiveItem, 1309). %% 没有激活道具
-define(ErrorCode_Guard_NoAwaken, 1310).    %% 不能觉醒
-define(ErrorCode_Guard_BeyondMaxLevel, 1311).    %% 超过羁绊最大等级
-define(ErrorCode_Guard_AlreadyActive, 1312).    %% 已经激活该羁绊等级
-define(ErrorCode_Guard_GuardNumNotEnough, 1313).    %% 符合条件守护数不足
-define(ErrorCode_Guard_NeedActiveLastLevelFetter, 1314).    %% 需要激活上一等级羁绊
-define(ErrorCode_Guard_TimeLimitGuardCantAwaken, 1315).    %% 限时守护不能觉醒

%% 龙神相关
-define(ErrorCode_GD_ArtiAlreadyActive, 1401).    %% 此神器已经激活
-define(ErrorCode_GD_AlreadyActive, 1402).    %% 已经激活
-define(ErrorCode_GD_AddLv_NoCost, 1403).        %% 没有消耗道具
-define(ErrorCode_GD_StarMax, 1404).        %% 升星到最大了
-define(ErrorCode_GD_NotExist, 1405).        %% 龙神不存在(未激活)
-define(ErrorCode_GD_NoMainGD, 1406).        %% 主战龙神才能出战
-define(ErrorCode_GD_GDSkillEqErr, 1407).        %% 装配掠阵技能错误(主战or掠阵弄错了)
-define(ErrorCode_GD_BelongNotActive, 1408).        %% 武器所属的龙神没有被激活
-define(ErrorCode_GD_AwakenLvMax, 1409).        %% 武器觉醒达到最大等级
-define(ErrorCode_GD_LvMax, 1410).        %% 升级到最大了
-define(ErrorCode_GD_Rein, 1411).        %% 已经转生
-define(ErrorCode_GD_MaxLvOfBreakLv, 1412).        %% 已达到当前突破等级上限
-define(ErrorCode_GD_LvNotEnoughToBreak, 1413).        %% 未达到突破所需等级

-define(Error_GD_Eq_MaxStar, 1414).            %%神像圣装 已达到最大星级
-define(ErrorCode_GD_NotEq, 1415).            %%神像圣装 对应圣装未激活
-define(ErrorCode_GD_WingNoQuality, 1416).            %%神像翅膀所需最低要求未满足
-define(ErrorCode_GD_WingEquip, 1417).            %%神像翅膀已装配，不可消耗
-define(ErrorCode_GD_WingLvMax, 1418).            %%神像翅膀已升级到最高等级
-define(ErrorCode_GD_WingNoLv, 1419).            %%该神像的翅膀不可升级
-define(ErrorCode_GD_WeaponNotEquip, 1420).            %%圣像武器未穿戴
-define(ErrorCode_GD_WeaponEquip, 1421).            %%圣像武器已穿戴
-define(ErrorCode_GD_WeaponStarMax, 1422).            %%圣像武器已达到最大星级
-define(ErrorCode_GD_WeaponStarNot, 1423).            %%消耗材料需要零星
-define(ErrorCode_GD_WeaponStarCostEnough, 1424).            %%消耗材料不足
%% 福利
-define(ErrorCode_LevelGift_MaxNum, 1501).  %% 奖励被领完了
-define(ErrorCode_Signin_SignIn, 1502).     %% 不能签到
-define(ErrorCode_Signin_Config, 1503).     %% 没有签到奖励配置
-define(ErrorCode_Signin_ProAward, 1504).   %% 已经领取进度奖励
-define(ErrorCode_Signin_OnlyNext, 1505).   %% 奖励依次领取
-define(ErrorCode_Signin_DayPro, 1506).     %% 领奖天数未到
-define(ErrorCode_Bless_NoConfig, 1507).    %% 没有祈福配置
-define(ErrorCode_Bless_NoFree, 1508).      %% 不能免费祈福
-define(ErrorCode_Bless_MaxFree, 1509).     %% 超出最大免费祈福次数
-define(ErrorCode_Bless_FreeCD, 1510).      %% 免费祈福CD中
-define(ErrorCode_Bless_MaxBless, 1511).    %% 超出今日最大祈福次数
-define(ErrorCode_LevelGift_VipNotEnough, 1512).    %% VIP等级不足

%% 战盟
-define(ErrorCode_Guild_CostEnough, 1601).  %% 消耗不足
-define(ErrorCode_Guild_NoGuild, 1602). %% 没有战盟
-define(ErrorCode_Guild_MaxLevel, 1603).    %% 已经达到最大等级
-define(ErrorCode_Guild_MoneyEnough, 1604). %% 战盟资金不足
-define(ErrorCode_Guild_RankEnough, 1605).  %% 权限不足
-define(ErrorCode_Guild_WrongScience, 1606).    %% 错误的科技
-define(ErrorCode_Guild_ScienceMaxLevel, 1607). %% 已经升到最大等级
-define(ErrorCode_Guild_NotItem, 1608). %% 捐献的不是装备
-define(ErrorCode_Guild_Integral, 1609).    %% 捐献积分不足
-define(ErrorCode_Guild_DepotEmpty, 1610).  %% 仓库空
-define(ErrorCode_Guild_Exchanged, 1611).  %% 已经被兑换
-define(ErrorCode_Guild_ExchangedMax, 1612).  %% 今日兑换已达上限
-define(ErrorCode_Guild_NotExist, 1613).    %% 装备不存在
-define(ErrorCode_Guild_CanNotDonate, 1614).    %% 该装备不能捐献
-define(ErrorCode_Guild_DepotFull, 1615).   %% 仓库满了
-define(ErrorCode_Guild_EnvelopeNotExist, 1616).    %% 没有该红包或已经过期
-define(ErrorCode_Guild_GetEnvelope, 1617). %% 已经领取过该红包了
-define(ErrorCode_Guild_MaxDayGold, 1618).  %% 超出今日最大领取元宝数量
-define(ErrorCode_Guild_VipEnough, 1619).   %% VIP等级不足
-define(ErrorCode_Guild_MaxSendNum, 1620).  %% 超出今日最大发红包个数
-define(ErrorCode_Guild_MaxEnvelopeNum, 1621).  %% 超出红包个数上限
-define(ErrorCode_Guild_WrongMoney, 1622).  %% 输入的金额不正确
-define(ErrorCode_Guild_MaxPlayerGold, 1623).   %% 超出每人每天最大上限
-define(ErrorCode_Guild_science_level, 1624).   %% 玩家等级不足
-define(ErrorCode_Guild_InActivity, 1625).  %% 活动期间不能解散、退出战盟
-define(ErrorCode_Guild_HasEquip, 1626).    %% 不能捐献已经装备的道具
-define(ErrorCode_Guild_LobbyLevel, 1627).    %% 战盟大厅等级不足
-define(ErrorCode_Guild_SysEnvelope, 1628). %% 今日已经领取过每日红包了
-define(ErrorCode_Guild_InviteErrState, 1629). %% 对方的清除cd已经没有了
-define(ErrorCode_Guild_ImpeachFail, 1630). %% 弹劾失败
-define(ErrorCode_Guild_Dissolve, 1631). %% 龙神骑士前三战盟无法被解散
-define(ErrorCode_Guild_NoEnvelopeGet, 1632). %% 没有红包可领
-define(ErrorCode_Guild_ChestNum, 1633). %% 宝箱数量不足
-define(ErrorCode_Guild_PrestigeSalary, 1634). %% 已领取声望工资
-define(ErrorCode_Guild_No_Chariot_Build, 1635). %% 没有可建造的战车
-define(ErrorCode_Guild_No_Chariot_Full, 1636). %% 战车位已满
-define(ErrorCode_Guild_No_Chariot, 1637). %% 战车不存在
-define(ErrorCode_Guild_Science_Lock, 1638). %% 战车科技未解锁
-define(ErrorCode_Guild_NoAssignAward, 1639). %% 没有可分配奖励
-define(ErrorCode_Guild_HasAssignAward, 1640). %% 该成员已被分配过奖励

%% vip
-define(ErrorCode_Vip_NoVip, 1700).  %% 不是vip
-define(ErrorCode_Vip_ExpGeted, 1701).  %% vip每日免费经验已领取
-define(ErrorCode_Vip_LvNotEnough, 1702).  %% vip等级不够
-define(ErrorCode_YanMo_CannotEnterMap, 1703).  %% 炎魔试炼未开启
-define(ErrorCode_BoneYard_SoulNotEnough, 1704).  %% 斗魂不够
-define(ErrorCode_BoneYard_TowerExist, 1705).  %% 已经创建了一个炮台
-define(ErrorCode_BoneYard_TowerNotExist, 1706).  %% 炮台不存在
-define(ErrorCode_BoneYard_TowerMaxLevel, 1707).  %% 炮台不能升级了
-define(ErrorCode_BoneYard_BossCalled, 1708).  %% Boss已经召唤
-define(ErrorCode_BoneYard_BossCalledErr, 1709).  %% Boss召唤错误
-define(ErrorCode_YanMo_HurtAwardAlreadyGet, 1710).  %% 炎魔试炼阶段奖励已经领取
-define(ErrorCode_YanMo_HurtAwardNotEnough, 1711).  %% 阶段奖励伤害不够
-define(ErrorCode_YanMo_HurtAwardNotEnoughScore, 1712).  %% 阶段奖励积分不够
-define(ErrorCode_HurtAwardCannotGet, 1713).  %% 阶段奖励不能领取
-define(ErrorCode_FireBossNotExit, 1714).  %% Boss不存在
-define(ErrorCode_FireBossGuildRankLimit, 1715).  %% 副盟主、执法者、盟主才能发起集火
-define(ErrorCode_VipNotOpenAgo, 1716).  %% VIP等级至少1级才可续期
-define(ErrorCode_VipExpMaxDaily, 1717).  %% 今日获得VIP经验值已达上限
-define(ErrorCode_VipDrawMax, 1718).  %% 抽奖送vip次数达到上线
-define(ErrorCode_VipPacksNotExist, 1719).  %% 不存在该vip礼包
-define(ErrorCode_VipPacksBuyWay, 1720).  %% 该vip礼包购买方式不正确
-define(ErrorCode_VipPacksNumLimit, 1721).  %% 该vip礼包购买次数达上限
-define(ErrorCode_VipFreeGiftHasGet, 1722).  %% 该vip免费礼包已领取
-define(ErrorCode_VipUpGiftHasGet, 1723).  %% 该vip额外礼包已领取


%% task
-define(ErrorCode_Task_NoLotteryTimes, 1801).  %% 没有抽奖次数(赏金任务)
-define(ErrorCode_Task_ProgressNotExist, 1802).    %% 不存在任务列表中
-define(ErrorCode_Task_TaskCannotComplete, 1803).    %% 该任务不能提交
-define(ErrorCode_Task_Progress, 1804).            %% 任务进度未满
-define(ErrorCode_Task_Condition, 1805).        %% 条件未满足(战盟任务需要加入战盟)
-define(ErrorCode_Task_FuncNotOpen, 1806).        %% 功能未开放
-define(ErrorCode_Task_ItemCfg, 1807).            %% 任务物品配置错误
-define(ErrorCode_Task_ItemAttr, 1808).            %% 任务物品不合要求
-define(ErrorCode_Task_ItemNotExist, 1809).        %% 物品不存在
-define(ErrorCode_Task_ParamErr, 1810).            %% 参数错误
-define(ErrorCode_Task_UnFinish, 1811).            %% 任务未完成

%% 圣物
-define(ErrorCode_Holy_StarMax, 1901).        %% 该圣物已经达到最大星级
-define(ErrorCode_Holy_LvMax, 1902).        %% 该圣物已经达到最大等级
-define(ErrorCode_HL_PillMax, 1903).        %% 圣灵嗑丹达到最大值
-define(ErrorCode_HL_NoSkill, 1904).        %% 此圣灵没有该技能
-define(ErrorCode_HL_NoSkillPos, 1905).        %% 圣灵该技能槽未激活
-define(ErrorCode_Holy_addLv_NoCost, 1906).        %% 圣物升级没有消耗道具
-define(ErrorCode_Holy_SL_lvNotMeet, 1907).        %% 圣灵等级不够
-define(ErrorCode_Holy_No, 1908).        %% 没有该圣物
-define(ErrorCode_Holy_CannotBreak, 1909).        %% 圣物不能突破
-define(ErrorCode_Holy_CannotAwaken, 1910).        %% 圣物不能精炼
-define(ErrorCode_HL_No, 1911).        %% 没有该圣灵
-define(ErrorCode_HL_addLv_NoCost, 1912).        %% 圣灵升级没有消耗道具
-define(ErrorCode_HL_LvMax, 1913).        %% 该圣灵已经达到最大等级
-define(ErrorCode_Holy_NoSkill, 1914).        %% 此圣物没有该技能
-define(ErrorCode_HL_LvNotEnough, 1915).    %% 圣灵等级不足
-define(ErrorCode_HL_VipLvNotEnough, 1916).    %% vip等级不足
-define(ErrorCode_HL_BoxAlreadyOpen, 1917).    %% 技能格已开启
-define(ErrorCode_HL_BoxNotExist, 1918).    %% 技能格不存在
-define(ErrorCode_HL_CannotOpenBox, 1919).    %% 不能开启此技能格

%% 日常
-define(ErrorCode_Daily_NotExist, 2001).            %% 任务不存在
-define(ErrorCode_Daily_ProgressErr, 2002).            %% 进度错误
-define(ErrorCode_Daily_CfgErr, 2003).                %% 配置不存在
-define(ErrorCode_Daily_TimeLimit, 2004).            %% 当前不在活动时间范围
-define(ErrorCode_FuncFree_Count, 2005).            %% 次数限制
-define(ErrorCode_Daily_AlreadyFinish, 2006).            %% 已经完成过
-define(ErrorCode_Daily_NotRecharge, 2007).            %% 尚未充值
-define(ErrorCode_Daily_NotCompleteAny, 2008).      %% 没有任务可以完成
-define(ErrorCode_Daily_LvLimit, 2009).             %% vip或玩家等级不足
-define(ErrorCode_Daily_SignUpNo, 2010).             %% 无法报名
-define(ErrorCode_Daily_SignUpTimeOver, 2011).       %% 报名时间已过
-define(ErrorCode_Daily_HasSignUp, 2012).       %% 已经报名过了


%% 21 新版交易行
-define(ERROR_trade_find_goods, 2101). %% 找不到商品
-define(ERROR_trade_player_id, 2102). %% 商品不是自己的
-define(ERROR_trade_amount, 2103). %% 商品数量不足
-define(ERROR_trade_remote, 2104). %% 商品服务器连接失败
-define(ERROR_trade_player_currency, 2105). %% 收益不足
-define(ERROR_trade_password_vip, 2106). %% 使用密码的Vip等级不足
-define(ERROR_trade_add_seat, 2107). %% 上架位置已满
-define(ERROR_trade_add_item, 2108). %% 物品不可上架
-define(ERROR_trade_add_amount, 2109). %% 上架物品数量错误
-define(ERROR_trade_add_equipment, 2110). %% 装备不可上架
-define(ERROR_trade_add_price, 2111). %% 上架物品价格错误
-define(ERROR_trade_item_cfg, 2112). %% 找不到物品配置
-define(ERROR_trade_password, 2113). %% 购买密码错误
-define(ERROR_trade_open, 2114). %% 功能未开启
-define(ERROR_trade_player_currency_remaining, 2115). %% 当日提取已达上限
-define(ERROR_trade_noCoin, 2116). %% 活动获得货币不可交易

%% 次日登录奖励
-define(ErrorCode_NextDayAward_NoAward, 2201).         %% 没有奖励
-define(ErrorCode_NextDayAward_HasGet, 2202).          %% 已经领取奖励
-define(ErrorCode_NextDayAward_NoCfg, 2203).           %% 没有配置数据
-define(ErrorCode_NextDayAward_NotTime, 2204).         %% 没到领奖时间

%% 称号
-define(ErrorCode_Title_NotHaveTitle, 2301).    %% 没有该称号
-define(ErrorCode_Title_AlreadyEquip, 2302).    %% 已装备该称号
-define(ErrorCode_Title_NotEquip, 2303).        %% 没有装备该称号
-define(ErrorCode_Title_NoCfg, 2304).            %% 没有称号配置
-define(ErrorCode_Title_Duplicate, 2305).        %% 重复获取称号
-define(ErrorCode_Title_NotOpenAction, 2306).    %% 未开放功能
-define(ErrorCode_Title_TimeLimit, 2307).        %% 称号已过期

%% 头衔
-define(ErrorCode_PlayTitle_No, 2401).         %% 没有头衔
-define(ErrorCode_PlayTitle_Battle, 2402).          %% 提升头衔战斗力不足
-define(ErrorCode_PlayTitle_MaxLv, 2403).           %% 头衔满级

%% 25 排行榜
-define(ErrorCode_Has_worship, 2501).       %% 已经赞美该玩家

%%信物
-define(ErrorCode_Ring_addLv_NoCost, 2601).         %% 没有消耗道具

%% 27 百鬼夜行/守卫仙盟/战盟争霸/答题房间/战盟拍卖/战盟拍卖
-define(ErrorCode_GG_AlreadyCallBoss, 2700).         %% 已经召唤了Boss
-define(ErrorCode_GG_GuildRankLimit, 2701).         %% Boss召唤权限不够
-define(ErrorCode_GG_JiaGuNoIndex, 2702).         %% 加固没有找到索引
-define(ErrorCode_GG_JiaGuMax, 2703).         %% 加固达到上限
-define(ErrorCode_GG_AcEnd, 2704).         %% 活动已经结束
-define(ErrorCode_GG_CanJoinOnlyOnce, 2705).         %% 已经参加过活动了
-define(ErrorCode_BoneYard_AlreadyStart, 2706).         %% 已经开始刷怪了
-define(ErrorCode_GG_AlreadySettle, 2707).         %% 准备结算中不能召唤Boss
-define(ErrorCode_GC_AlreadyCollect, 2708).         %% 已经占领了这个旗子
-define(ErrorCode_GC_AlreadyGetDailyAward, 2709).         %% 已经领取了每日奖励
-define(ErrorCode_GC_NoOverlord, 2710).         %% 不是霸主
-define(ErrorCode_XO_PlayerNotInAc, 2711).         %% 玩家没有参加活动
-define(ErrorCode_XO_NotInThisArea, 2712).         %% 玩家没有进过区域怎么退出
-define(ErrorCode_XO_JoinedBet, 2713).         %% 玩家已经参加竞猜了
-define(ErrorCode_XO_CannotBet, 2714).         %% 准备阶段才可以竞猜
-define(ErrorCode_XO_BetNotInMap, 2715).         %% 进入活动地图才可以竞猜
-define(ErrorCode_XO_BetNotInAcTime, 2716).         %% 活动准备期间才可以竞猜
-define(ErrorCode_GA_NoItem, 2717).         %% 没有此拍卖品
-define(ErrorCode_GA_Bought, 2718).         %% 被一口价买了
-define(ErrorCode_GA_BidRepeat, 2719).         %% 已经出价了
-define(ErrorCode_GA_Fresh, 2720).         %% 已经有人竞拍了请刷新在试
-define(ErrorCode_GA_Over, 2721).         %% 已经结束
-define(ErrorCode_GA_CannotBuy, 2722).         %% 战盟里面没有东西
-define(ErrorCode_GA_NoQualification, 2723).         %% 没有参加活动不能参加竞拍
-define(ErrorCode_GC_AcIsPrepared, 2724).         %% 还在准备阶段不能采旗帜
-define(ErrorCode_GA_EnterOnlyPrepared, 2725).         %% 准备阶段才可以进入地图
-define(ErrorCode_GA_CantAuction, 2726).             %% 该物品不能竞拍
-define(ErrorCode_GA_LimitBuy, 2727).                %% 购买上限
-define(ErrorCode_OR_NotInMap, 2728).                %% 配饰副本-当前地图不能召唤
-define(ErrorCode_OR_WaveLast, 2729).                %% 刷新最后一波怪物后，无法召唤
-define(ErrorCode_OR_CalledBoss, 2730).                %% 已经召唤了Boss
-define(ErrorCode_OR_CannotCallBoss, 2731).                %% 已经召唤了Boss
-define(ErrorCode_GG_NoMemberJoin, 2732).               %% 准备时间内无战盟成员进入，不能参与
-define(ErrorCode_GG_AcNotStart, 2733).                 %% 活动还没开始
-define(ErrorCode_Times_Limit, 2734).                 %% 已达到每日参加上限
-define(ErrorCode_GA_Authority, 2735).                %% 没有分配权限
-define(ErrorCode_GA_AuthorityNo, 2736).                %% 无法分配该物品
-define(ErrorCode_GA_NotStart, 2737).                 %% 拍卖未开始

%% 28 装扮
-define(ErrorCode_head_StarMax, 2801).        %% 该头像已经达到最大星级
-define(ErrorCode_head_xc_LvMax, 2802).        %% 该相册已经达到最大等级
-define(ErrorCode_head_xc_No, 2803).        %% 没有激活相册、相框
-define(ErrorCode_head_xc_addLv_NoCost, 2804).        %% 相册&相框升级没有消耗道具
-define(ErrorCode_head_No, 2805).        %% 头像未激活
-define(ErrorCode_head_frame_StarMax, 2806).        %% 该头像已经达到最大星级
-define(ErrorCode_head_frame_No, 2807).        %% 头像未激活
-define(ErrorCode_ChatBubble_StarMax, 2808).        %% 聊天气泡已达最大星级
-define(ErrorCode_HornBubble_StarMax, 2809).        %% 喇叭气泡已达最大星级
-define(ErrorCode_ChatPaopao_ErrItem, 2810).        %% 该物品不可用于聊天泡泡升级
-define(ErrorCode_HornPaopao_ErrItem, 2811).        %% 该物品不可用于喇叭泡泡升级
-define(ErrorCode_ChatPaopao_NoItem, 2812).            %% 无消耗物品
-define(ErrorCode_HornPaopao_NoItem, 2813).            %% 无消耗物品
-define(ErrorCode_ChatBubble_NotExist, 2814).        %% 聊天气泡不存在
-define(ErrorCode_ChatBubble_NotActive, 2815).        %% 聊天气泡未激活
-define(ErrorCode_HornBubble_NotExist, 2816).        %% 喇叭气泡不存在
-define(ErrorCode_HornBubble_NotActive, 2817).        %% 喇叭气泡未激活

%% 29 战盟任务
-define(ErrorCode_GuildTask_AlreadyAccept, 2901).        %% 已经接过任务
-define(ErrorCode_GuildTask_AlreadyGet, 2902).            %% 已领取过奖励
-define(ErrorCode_GuildTask_YBNotEnough, 2903).            %% 元宝不足
-define(ErrorCode_GuildTask_TaskInfoErr, 2904).            %% 任务信息错误
-define(ErrorCode_GuildTask_NoGuild, 2905).                %% 未加入战盟
-define(ErrorCode_GuildTask_NoAward, 2906).                %% 现在还不可以领取

%% 30 任务


%% 31 转职
-define(ErrorCode_CareerTask_TypeErr, 3101).        %% 任务类型错误
-define(ErrorCode_CareerTask_ProgressErr, 3102).    %% 任务进度错误
-define(ErrorCode_CareerTask_NotAccept, 3103).        %% 还没接转职任务
-define(ErrorCode_CareerTask_AllTaskComplete, 3104).%% 所有任务均已完成
-define(ErrorCode_CareerTask_CfgErr, 3105).            %% 配置错误
-define(ErrorCode_CareerTask_TaskCondition, 3106).    %% 未满足条件
-define(ErrorCode_CareerTask_PreCondition, 3107).    %% 前置条件未满足
-define(ErrorCode_CareerTask_ParamErr, 3108).        %% 参数错误
-define(ErrorCode_CareerTask_ItemNotEnough, 3109).    %% 物品不足
-define(ErrorCode_CareerTask_AlreadyAccept, 3110).    %% 已接取转职任务
-define(ErrorCode_CareerTask_TaskPre, 3111).        %% 转职前置未达成
-define(ErrorCode_CareerTask_NotAllComplete, 3112).    %% 尚未完成所有转职任务
-define(ErrorCode_CareerTask_LevelLimit, 3113).    %% 等级不足
-define(ErrorCode_CareerTask_TaskLimit, 3114).    %% 未接取对应任务
-define(ErrorCode_CareerTask_NoTitle, 3115).    %% 暂无可获得称号

%% 32 预言之书
-define(ErrorCode_Book_No, 3201).        %% 此类不存在
-define(ErrorCode_Book_activate, 3202).            %% 任务完成数不够
-define(ErrorCode_Book_ItemNotExist, 3203).        %% 物品不存在
-define(ErrorCode_Book_Task_No, 3204).        %% 此任务不存在
-define(ErrorCode_Book_Task_Over, 3205).        %% 已领奖，不能重复领取
-define(ErrorCode_Book_Task_Not_Reach, 3206).        %% 未达成条件
-define(ErrorCode_Book_NotOpen, 3207).            %% 未开放

%% 等级
-define(ErrorCode_LevelUp_ExpCfg, 3301).        %% cfg_expDistribution配置错误


%% 34 技能
-define(ErrorCode_Skill_NotLearn, 3400).        %% 该技能还未学习
-define(ErrorCode_Skill_NotLevelUp, 3401).        %% 该技能不能升级
-define(ErrorCode_Skill_AlreadyEquip, 3402).        %% 该技能已经装配
-define(ErrorCode_Skill_CannotEquip, 3403).        %% 该技能不能装配
-define(ErrorCode_Skill_CannotOneKeyLevelUp, 3404).      %% 不能一键升级
-define(ErrorCode_Genius_CareerLevelNotEnough, 3405).    %% 转职等级不够
-define(ErrorCode_Genius_LevelNotEnough, 3406).             %% 等级不够
-define(ErrorCode_Genius_TypeCountNotEnough, 3407).         %% 累计点数不够
-define(ErrorCode_Genius_PreCountNotEnough, 3408).         %% 前置点数不够
-define(ErrorCode_Genius_CfgErr, 3409).                     %% 未找到配置
-define(ErrorCode_Genius_LvMax, 3410).                     %% 已达到最大等级
-define(ErrorCode_Genius_PointNotEnough, 3411).             %% 天赋点不足
-define(ErrorCode_Genius_YBNotEnough, 3412).             %% 元宝不足
-define(ErrorCode_Skill_No, 3413).             %% 技能不存在
-define(ErrorCode_Skill_No_This_Buff, 3414).             %% 技能不能触发此buff
-define(ErrorCode_Skill_NotAlive, 3415).             %% 需要在存活的状态使用技能
-define(ErrorCode_Skill_NotExist, 3416).             %% 此技能不存在或者没学习
-define(ErrorCode_Skill_CD1, 3417).             %% 技能使用间隔中
-define(ErrorCode_Skill_CD2, 3418).             %% 技能使用组CD中
-define(ErrorCode_Skill_CD3, 3419).             %% 技能使用CD中
-define(ErrorCode_Skill_NoEnoughCost, 3420).             %% 技能使用消耗不足
-define(ErrorCode_Skill_ObjectDead, 3421).             %% 对象已经死亡
-define(ErrorCode_Skill_TypeRepeat, 3422).             %% 已经装配了此类型的技能
-define(ErrorCode_Skill_NumMax, 3423).             %% 普攻上面只能绑定四个技能
-define(ErrorCode_Skill_Science, 3424).             %% 沉默
-define(ErrorCode_Genius_ShoulingLvNotEnough, 3425).    %% 兽灵等级不足
-define(ErrorCode_Genius_MolingLvNotEnough, 3426).        %% 魔灵等级不足
-define(ErrorCode_Genius_YilingLvNotEnough, 3427).        %% 翼灵等级不足
-define(ErrorCode_Genius_ShenglingLvNotEnough, 3428).    %% 圣灵等级不足
-define(ErrorCode_Genius_NoOpenType, 3429).                %% 生效类型不存在
-define(ErrorCode_Genius_NotUsePt, 3430).                %% 未使用天赋点,无需重置
-define(ErrorCode_Genius_GemsNotEnough, 3431).           %% 宝石镶嵌数量未达到
-define(ErrorCode_Skill_NotBind, 3432).                 %% 未装配技能
-define(ErrorCode_Skill_MaxLv, 3433).                   %% 等级已达最大
-define(ErrorCode_Skill_Lv, 3434).                      %% 等级错误
-define(ErrorCode_Skill_Pre, 3435).                     %% 条件不足

%% 35 成就称号
-define(ErrorCode_Attainment_NotReach, 3501). %% 没有达成该成就
-define(ErrorCode_Attainment_HasGetReward, 3502). %% 已经领取该奖励
-define(ErrorCode_Attainment_EmptyCfg, 3503). %% 没有该成就配置
-define(ErrorCode_Attainment_EmptyAward, 3504).    %% 该成就没有奖励

%% 36 王者1V1
-define(ERROR_fight_match_state, 3601). %% 匹配状态错误，请重新登录
-define(ERROR_fight_task_cfg, 3602). %% 找不到任务配置
-define(ERROR_fight_award, 3603). %% 重复领奖
-define(ERROR_fight_times, 3604). %% 没有次数
-define(ERROR_fight_open, 3605). %% 功能未开启
-define(ERROR_fight_activity, 3606). %% 活动未开启
-define(ERROR_fight_remote, 3607). %% 远程服务器连接失败
-define(ERROR_fight_buy_times, 3608). %% 拥有次数已达上限，不可购买！

%% 37 商城
-define(ErrorCode_Shop_Unknowns, 3701).            %% 未知错误
-define(ErrorCode_Shop_Params, 3702).            %% 参数错误
-define(ErrorCode_Shop_PlayerLv, 3703).        %% 购买所需等级不满足
-define(ErrorCode_Shop_VipLv, 3704).            %% 购买所需VIP等级不满足
-define(ErrorCode_Shop_ArenaTop, 3705).        %% 购买所需历史最大竞技场排名不满足
-define(ErrorCode_Shop_RuneTower, 3706).        %% 购买所需大闹天宫最高星数不满足
-define(ErrorCode_Shop_GuildLv, 3707).        %% 购买所需帮会等级不满足
-define(ErrorCode_Shop_1v1Rank, 3708).        %% 购买所需历史1v1排名不满足
-define(ErrorCode_Shop_CareerLv, 3709).        %% 购买所需转职等级不满足
-define(ErrorCode_Shop_HonorLv, 3710).        %% 购买所需头衔等级不满足
-define(ErrorCode_Shop_YilingLv, 3711).        %% 购买所需翼灵等级不满足
-define(ErrorCode_Shop_ShoulingLv, 3712).        %% 购买所需兽灵等级不满足
-define(ErrorCode_Shop_MolingLv, 3713).        %% 购买所需魔灵等级不满足
-define(ErrorCode_Shop_GDragon, 3714).        %% 购买所需龙神尚未激活
-define(ErrorCode_Shop_OpenAction, 3715).        %% 购买所需功能尚未激活
-define(ErrorCode_Shop_WorldLevel, 3716).        %% 购买所需世界等级未达到
-define(ErrorCode_Shop_MountActive, 3717).        %% 购买所需坐骑未激活
-define(ErrorCode_Shop_PetActive, 3718).        %% 购买所需宠物未激活
-define(ErrorCode_Shop_WingActive, 3719).        %% 购买所需翅膀未激活
-define(ErrorCode_Shop_HolyActive, 3720).        %% 购买所需圣物未激活
-define(ErrorCode_Shop_BattleFieldJoin, 3721).   %% 还未参加过永恒战场
-define(ErrorCode_Shop_GuildGuardJoin, 3722).   %% 还未参加过守卫战盟
-define(ErrorCode_Shop_ArenaJoin, 3723).        %% 还未参加过竞技场
-define(ErrorCode_Shop_1v1Join, 3724).        %% 还未参加过1v1
-define(ErrorCode_Shop_MeleeJoin, 3725).        %% 还未参加过魔龙洞窟
-define(ErrorCode_Shop_AshuraJoin, 3726).    %% 还未参加过血色争霸
-define(ErrorCode_Shop_WorldBossJoin, 3727).    %% 还未参加过世界boss
-define(ErrorCode_Shop_YanmoJoin, 3728).        %% 还未参加过炎魔试炼
-define(ErrorCode_Shop_DungeonCoupleJoin, 3729).%% 还未参加过情侣试炼
-define(ErrorCode_Shop_WeaponNotActive, 3730).  %% 还未激活指定神兵
-define(ErrorCode_Shop_WeaponSoulLv, 3731).     %% 兵魂等级不足
-define(ErrorCode_Shop_Career, 3732).           %% 当前职业无法购买
-define(ErrorCode_Shop_BorderSeason, 3733).     %% 边境赛季不符合
-define(ErrorCode_Shop_MilitaryRank, 3734).     %% 军衔不足
-define(ErrorCode_Shop_RuleNum, 3735).          %% 圣纹法则总值不符合
-define(ErrorCode_Shop_RingStar, 3736).           %% 信物星级不符合要求
-define(ErrorCode_Shop_ExpeditionNobility, 3737).%% 远征爵位不符合要求
-define(ErrorCode_Shop_BuyLimit, 3760).        %% 购买次数不足
-define(ErrorCode_Shop_RefreshLimit, 3761).    %% 刷新次数不足
-define(ErrorCode_Shop_PageNotExist, 3762).    %% 商店分页不存在
-define(ErrorCode_Shop_PageNotOpen, 3763).    %% 商店分页未开放
-define(ErrorCode_Shop_NoCurLvShop, 3764).    %% 没有玩家等级对应的商店
-define(ErrorCode_Shop_NotExist, 3765).        %% 商店不存在
-define(ErrorCode_Shop_AlreadyReset, 3766).    %% 商店已经重置，请重新打开
-define(ErrorCode_Shop_GoodNotExist, 3767).    %% 商品不存在
-define(ErrorCode_Shop_No_Condition, 3768).    %% 购买条件不满
-define(ErrorCode_Shop_RingNoActive, 3769).    %% 所需信物未激活
-define(ErrorCode_Shop_TaitanEqNoQuality, 3770).    %% 未穿戴足够数量的对应品质泰坦装备
%% 38 聊天
-define(ErrorCode_Chat_LvOrVipLimit, 3800).    %% 25级或VIP2可在世界频道发言

%% 39 改名
-define(ErrorCode_Change_Name_Unvalid, 3901). %% 新名字不合法
-define(ErrorCode_Change_Name_Forbidden, 3902). %% 名字里有敏感字符
-define(ErrorCode_Change_Name_Exist, 3903). %% 重名
-define(ErrorCode_Change_Name_Consume_Limit, 3904). %% 消耗不足

%% 40 玩家简要数据
-define(ERROR_player_summary_player_limit, 4001). %% 角色数量超过限制
-define(ERROR_player_summary_name_used, 4002). %% 角色名字已被使用
-define(ERROR_player_summary_account_player, 4003). %% 角色不属于该账号
-define(ERROR_player_summary_player, 4004). %% 角色不存在

%% 41 战盟争霸  领地战
-define(ErrorCode_GC_CannotJoin, 4100).        %% 没有参赛资格
-define(ErrorCode_GC_WaitMapCreate, 4101).        %% 当前阶段已经打完了
-define(ErrorCode_GC_JoinGuildTimeLimit, 4102).        %% 加入战盟时间不足24小时
-define(ErrorCode_GCamp_NotInMap, 4103).        %% 你不在战盟驻地内
-define(ErrorCode_GCamp_DrinkTimesLimit, 4104).        %% 喝酒次数达到最大
-define(ErrorCode_GCamp_StageAwardErr, 4105).        %% 领取失败
-define(ErrorCode_GCamp_StageAwardGot, 4106).        %% 阶段奖励已经领取
-define(ErrorCode_GCamp_OutActiveTime, 4107).       %% 不在活动期间
-define(ErrorCode_Manor_AlreadyStart, 4108).        %% 活动已经开启, GM设置失败
-define(ErrorCode_Manor_NoManor, 4109).        %% 没有该领地
-define(ErrorCode_Manor_BidErrState, 4110).        %% 当前阶段不能宣战
-define(ErrorCode_Manor_BidErrAuto, 4111).        %% 已经自动宣战
-define(ErrorCode_Manor_BidExist, 4112).        %% 已经宣战
-define(ErrorCode_Manor_BidExistManor, 4113).        %% 有领地的不能宣战
-define(ErrorCode_Manor_BidAddErr, 4114).        %% 不满足竞标最低价
-define(ErrorCode_Manor_BidNeedRefresh, 4115).        %% 其他人已经在竞拍了
-define(ErrorCode_Manor_DailyAwardErr, 4116).        %% 不能领取每日奖励
-define(ErrorCode_Manor_DailyAwardGot, 4117).        %% 已经领取了每日奖励


%% 42 运营活动
-define(ErrorCode_SalesActive_hasNoReward, 4201).     %% 没有奖励可以领取
-define(ErrorCode_SalesActive_RechargeEnough, 4202).  %% 充值金额不足
-define(ErrorCode_Lucky_OutActiveTime, 4203).       %% 不在活动期间
-define(ErrorCode_Lucky_OutMaxDrawTimes, 4204).     %% 超出最大购买次数
-define(ErrorCode_Lucky_OutMaxDayDrawTimes, 4205).     %% 超出今日最大购买次数
-define(ErrorCode_Lucky_ActiveEnd, 4206).   %% 活动已经结束
-define(ErrorCode_Lucky_NotEnoughTimes, 4207).  %% 次数不足
-define(ErrorCode_AcAlreadyBuyTicket, 4208).  %% 已经买了门票
-define(ErrorCode_AcNoTicket, 4209).  %% 没有门票
-define(ErrorCode_CloudErrStage, 4210).  %% 当前阶段不能领取
-define(ErrorCode_CloudStageGot, 4211).  %% 当前阶段已经领取
-define(ErrorCode_CloudStageErrTimes, 4212).  %% 购买次数不足不能领取
-define(ErrorCode_Exchange_ItemNotEnough, 4213).    %% 物品数量不足
-define(ErrorCode_DemonSea_CannotBuy, 4214).    %% 有次数不能购买
-define(ErrorCode_DemonSea_MaxLayer, 4215).    %% 已经达到最大层
-define(ErrorCode_Firework_CfgErr, 4216).           %% 烟花盛典配置错误
-define(ErrorCode_Firework_DuplicateAward, 4217).   %% 烟花盛典重复领取
-define(ErrorCode_Firework_BadIndex, 4218).         %% 烟花盛典错误序号
-define(ErrorCode_Firework_NotEnough, 4219).         %% 烟花盛典次数不足
-define(ErrorCode_BlzForest_CannotBuy, 4220).    %% 有次数不能购买
-define(ErrorCode_SalesActive_No_Type_Ac, 4221).  %% 没有此类型活动
-define(ErrorCode_SalesActive_Type_Not_Match, 4222).  %% 活动类型不匹配
-define(ErrorCode_SalesActive_No_Exist, 4223).  %% 不存在该活动
-define(ErrorCode_SalesActive_No_Exchange, 4224).  %% 该活动不支持兑换
-define(ErrorCode_SalesActive_Question_No_Finish, 4225).  %% 问题未回答完成
-define(ErrorCode_SalesActive_PromotionPresentGift_HadBuy, 4226).  %% 该献礼已经购买
-define(ErrorCode_SalesActive_PromotionPresentGift_TypeWrong, 4227).  %% 献礼购买类型错误
-define(ErrorCode_SalesActive_PromotionTreasure_NotOpen, 4228).  %% 该任务尚未开启
-define(ErrorCode_SalesActive_PromotionTreasure_TypeWrong, 4229).  %% 类型错误
-define(ErrorCode_SalesActive_PromotionTreasure_WrongStore, 4230).  %% 该宝库暂无法开启
-define(ErrorCode_SalesActive_PromotionTreasure_WrongPos, 4231).  %% 该位置已经开启
-define(ErrorCode_SalesActive_PromotionTreasure_NoAward, 4232).  %% 该宝库已全部开启
-define(ErrorCode_SalesActive_PromotionTreasure_NoMoney, 4233).  %% 宝藏开启消耗不足
-define(ErrorCode_SalesActive_GloryCarnival_WrongType, 4234).  %% 狂欢类型错误
-define(ErrorCode_SalesActive_GloryCarnival_HadGet, 4235).  %% 已领取该积分奖励
-define(ErrorCode_SalesActive_GloryCarnival_LackScore, 4236).  %% 积分不足
-define(ErrorCode_SalesActive_TimeLimitGift_NotOpen, 4237).  %% 未开放购买
-define(ErrorCode_SalesActive_TimeLimitGift_BuyWay, 4238).  %% 购买方式错误
-define(ErrorCode_SalesActive_TimeLimitGift_BuyMax, 4239).  %% 达到购买上限
-define(ErrorCode_SalesActive_LevelSealTypeWrong, 4240).  %% 等级封印商店购买类型错误
-define(ErrorCode_SalesActive_ExchangeTimesLimit, 4241).    %% 达到交换次数上限
-define(ErrorCode_SalesActive_AlreadyFollow, 4242).    %% 已经关注
-define(ErrorCode_SalesActive_ContinuousRechargeExtra, 4243).    %% 已领取过该奖励
-define(ErrorCode_SalesActive_OutBuyTime, 4244).    %% 不在购买时间
-define(ErrorCode_SalesActive_NoIntegral, 4245).    %% 积分不足
-define(ErrorCode_SalesActive_NoTimes, 4246).    %% 超过最大次数

%% 43 登录奖
-define(ErrorCode_LoginGift_Cfg, 4301).                %% 配置不存在
-define(ErrorCode_LoginGift_Limit, 4302).            %% 条件未达到
-define(ErrorCode_LoginGift_AlreadyGet, 4303).        %% 已领取

%% 44 资源找回
-define(RetrieveRes_NotFind, 4401).             %% 没有可找回资源
-define(RetrieveRes_NotEnough, 4402).           %% 可找回次数不足
-define(RetrieveRes_CostNotEnough, 4403).       %% 找回消耗不足
-define(RetrieveRes_HasNoGuild, 4404).          %% 没有战盟
-define(RetrieveRes_WrongRecoveryType, 4405).          %% 错误找回类型

%% 45 0元购
-define(ErrorCode_FreeBuy_BuyTimeLimit, 4501).        %% 超过购买时间
-define(ErrorCode_FreeBuy_GiftTimeLimit, 4502).        %% 未到领取时间
-define(ErrorCode_FreeBuy_NoCfg, 4503).                %% 没有该商品
-define(ErrorCode_FreeBuy_BuyDuplicate, 4504).        %% 重复购买
-define(ErrorCode_FreeBuy_GiftDuplicate, 4505).        %% 重复领奖
-define(ErrorCode_FreeBuy_GiftNotBuy, 4506).        %% 尚未购买
-define(ErrorCode_FreeBuy_VipNotEnough, 4507).        %% VIP等级不足

%% 46 基金
-define(ErrorCode_Funds_FundsNotExist, 4601).        %% 该基金不存在
-define(ErrorCode_Funds_DuplicateBuy, 4602).        %% 重复购买
-define(ErrorCode_Funds_FundsLimit, 4603).            %% 未达到购买条件
-define(ErrorCode_Funds_AwardNotExist, 4604).        %% 该奖励不存在
-define(ErrorCode_Funds_DuplicateAward, 4605).        %% 重复领奖
-define(ErrorCode_Funds_AllAwardNotExist, 4606).    %% 该全民奖不存在
-define(ErrorCode_Funds_NotBuyAny, 4607).            %% 还没有买任何一种基金
-define(ErrorCode_Funds_ServerBuyCount, 4608).        %% 全服购买人数未达到
-define(ErrorCode_Funds_DuplicateAllAward, 4609).    %% 重复领奖(全民奖励)
-define(ErrorCode_Financing_NoSuchType, 4610).        %% 没有该理财类型
-define(ErrorCode_Financing_AwardNotExist, 4611).    %% 该理财奖励不存在
-define(ErrorCode_Financing_DuplicateAward, 4612).    %% 理财重复领奖
-define(ErrorCode_Financing_NotBuy, 4613).            %% 还没有买理财
-define(ErrorCode_Financing_AwardTime, 4614).        %% 未到领奖时间
-define(ErrorCode_Financing_DuplicateBuy, 4615).    %% 重复购买理财
-define(ErrorCode_Funds_NotBuy, 4616).              %% 还未购买该基金
-define(ErrorCode_Funds_Buy_Type, 4617).              %% 该基金不支持货币购买
-define(ErrorCode_Funds_LvLimit, 4618).                %% 基金领取等级限制

%% 47 寻宝
-define(ERROR_xun_bao_open, 4701). %% 功能未开启
-define(ERROR_xun_bao_draw_free, 4702). %% 未到免费寻宝时间
-define(ERROR_xun_bao_period_finish, 4703).  %% 重复领奖
-define(ERROR_xun_bao_period_finish_index, 4704).  %% 错误的序号
-define(ERROR_xun_bao_period_finish_num, 4705).  %% 次数不满足
-define(ERROR_xun_bao_draw_level, 4706).  %% 装备寻宝等级超过限制
-define(ERROR_xun_bao_time_item_cfg, 4707).  %% 多次寻宝配置错误
-define(ERROR_xun_bao_today_times_limit, 4708).  %% 今日寻宝次数到达上限
-define(ERROR_xun_bao_taitan_NoDraw, 4709).    %%没有可领取的奖励
-define(ERROR_xun_bao_taitan_Draw_finish, 4710).%%已领取该达成奖励
-define(ERROR_xun_bao_taitan_NoSeason, 4711).%% 非当前赛季，无法领取
-define(ERROR_xun_bao_taitan_NotSynthe, 4712).    %%当前赛季寻宝令不能二合一
%% 48 充值
-define(ERROR_recharge_total_open, 4801). %% 功能未开启
-define(ERROR_recharge_total_finish, 4802). %% 重复领奖
-define(ERROR_recharge_total_finish_index, 4803).  %% 错误的序号
-define(ERROR_recharge_total_finish_recharge, 4804).  %% 条件不满足
-define(ERROR_recharge_first_open, 4805). %% 功能未开启
-define(ERROR_recharge_first_finish, 4806). %% 重复领奖
-define(ERROR_recharge_first_finish_recharge, 4807).  %% 条件不满足
-define(ERROR_recharge_buy_open, 4808). %% 功能未开启
-define(ERROR_recharge_buy_finish, 4809). %% 重复领奖
-define(ERROR_recharge_buy_finish_recharge, 4810).  %% 条件不满足
-define(ERROR_recharge_life_card_open, 4811). %% 功能未开启
-define(ERROR_recharge_life_card_card, 4812). %% 重复开通
-define(ERROR_recharge_life_card_finish, 4813). %% 重复领奖
-define(ERROR_recharge_order_open, 4814). %% 功能未开启
-define(ERROR_recharge_order_error, 4815). %% 发货异常
-define(ERROR_recharge_subscribe, 4816). %% 重复订阅
-define(ERROR_recharge_subscribe_open, 4817). %% 功能未开启
-define(ERROR_recharge_first2_open, 4818). %% 功能未开启
-define(ERROR_recharge_first2_finish, 4819). %% 重复领奖
-define(ERROR_recharge_first2_finish_recharge, 4820).  %% 条件不满足
-define(ERROR_recharge_first3_open, 4821). %% 功能未开启
-define(ERROR_recharge_first3_finish, 4822). %% 重复领奖
-define(ERROR_recharge_first3_finish_recharge, 4823).  %% 条件不满足
-define(ERROR_recharge_first3_close, 4824). %% 功能已关闭
-define(ERROR_recharge_gift_package_buy_cfg_err, 4825). %% 未找到配置
-define(ERROR_recharge_gift_package_buy_finish, 4826). %% 已达到最大购买次数
-define(ERROR_recharge_price, 4827). %% 兑换比例异常
-define(ERROR_recharge_gift1, 4828). %% 赠送比例异常1
-define(ERROR_recharge_gift2, 4829). %% 赠送比例异常2
-define(ERROR_recharge_gift3, 4830). %% 赠送比例异常3
-define(ERROR_recharge_platform, 4831). %% 不支持第三方充值
-define(ERROR_recharge_gift_package_buy_forbid, 4832). %% 礼包不可购买
-define(ERROR_recharge_fund_not_open, 4833).      %% 直购基金未开启
-define(ERROR_recharge_fund_cfg_err, 4834).       %% 未找到直购基金配置
-define(ERROR_recharge_fund_has_buy, 4835).       %% 基金已购买
-define(ERROR_recharge_fund_has_expired, 4836).   %% 基金已到期
-define(ERROR_recharge_fund_has_award, 4837).     %% 当日奖励已领取过
-define(ERROR_recharge_fund_not_buy, 4838).       %% 基金未购买
-define(ERROR_recharge_fund_award_null, 4839).    %% 没有可领取奖励
-define(ERROR_recharge_game_helper_has_buy, 4840). %% 重复激活小助手
-define(ERROR_recharge_game_helper_not_open, 4841). %% 功能未开启
-define(ERROR_recharge_gift_packs_condition, 4842).    %% 购买条件不满足
-define(ERROR_recharge_gift_packs_buy_way, 4843).    %% 购买方式错误
-define(ERROR_recharge_gift_packs_buy_time, 4844).    %% 超出最大购买次数
-define(ERROR_recharge_gift_packs_buy_close, 4845).    %% 已关闭购买
-define(ERROR_recharge_gift_packs_buy_not_open, 4846).    %% 未开放购买
-define(ERROR_recharge_exclusive_total_condition, 4847).    %% 领取条件不满足
-define(ERROR_recharge_exclusive_total_HasAward, 4848).    %% 已经领取过该奖励

%% 49 限时特惠
-define(ErrorCode_TimeLimit_NotExist, 4901).    %% 礼包不存在
-define(ErrorCode_TimeLimit_Expire, 4902).      %% 礼包已过期
-define(ErrorCode_TimeLimit_Bought, 4903).      %% 礼包已购买

%% 50 情侣月卡
-define(ErrorCode_CPMonthCard_CPFuncOpen, 5001).        %% 对方功能未开放
-define(ErrorCode_CPMonthCard_CPNotOnline, 5002).        %% 对方不在线
-define(ErrorCode_CPMonthCard_CPNotExpire, 5003).        %% 对方月卡还没过期
-define(ErrorCode_CPMonthCard_NotExpire, 5004).            %% 自己月卡还没过期
-define(ErrorCode_CPMonthCard_Expire, 5005).            %% 月卡已过期
-define(ErrorCode_CPMonthCard_DuplicateAward, 5006).    %% 重复领奖
-define(ErrorCode_CPMonthCard_NoCP, 5007).                %% 没有情侣
-define(ErrorCode_CPMonthCard_NoReq, 5008).                %% 没有赠送请求

%% 51 七天奖
-define(ErrorCode_SevenGift_DuplicateBuy, 5101).        %% 重复购买
-define(ErrorCode_SevenGift_GroupErr, 5102).            %% 活动组错误
-define(ErrorCode_SevenGift_GroupNotExist, 5103).        %% 活动组不存在
-define(ErrorCode_SevenGift_TimeLimit, 5104).            %% 时间限制
-define(ErrorCode_SevenGift_NotComplete, 5105).            %% 尚未完成任务
-define(ErrorCode_SevenGift_DuplicateAward, 5106).        %% 重复领取奖励
-define(ErrorCode_SevenGift_NoAward, 5107).                %% 不存在该奖励
-define(ErrorCode_SevenGift_PtNotEnough, 5108).            %% 积分不足
-define(ErrorCode_SevenGift_VipNotEnough, 5109).            %% VIP等级不足

%% 52 联服
-define(ERROR_cluster_open, 5201). %% 世界服未开启
-define(ERROR_cluster_gameplay, 5202). %% 找不到玩法
-define(ERROR_cluster_server_id, 5203). %% 找不到服务器
-define(ERROR_cluster_server_disconnected, 5204). %% 服务器连接断开
-define(ERROR_cluster_server_restructure, 5205). %% 位面正在重组，请稍后再试

%% 53 世界服阶段
-define(ERROR_cluster_stage_player_award_cfg, 5301). %% 屠魔令奖励配置错误
-define(ERROR_cluster_stage_player_award_finished, 5302). %% 屠魔令奖励条件不满足
-define(ERROR_cluster_stage_player_award_index, 5303). %% 屠魔令奖励重复领奖

%% 54 配饰
-define(ErrorCode_Ornament_NotExist, 5401).             %% 配饰不存在
-define(ErrorCode_Ornament_WearCondition, 5402).        %% 穿戴条件不满足
-define(ErrorCode_Ornament_NotWear, 5403).              %% 没有穿戴配饰
-define(ErrorCode_Ornament_IntLvLimit, 5404).           %% 已达到强化上限
-define(ErrorCode_Ornament_CantBreak, 5405).            %% 不可升阶
-define(ErrorCode_Ornament_LvNotEnough, 5406).          %% 强化等级不足
-define(ErrorCode_Ornament_CastInfoExist, 5407).        %% 有未处理的祝福信息
-define(ErrorCode_Ornament_CastInfoNotExist, 5408).     %% 没有未处理的祝福信息
-define(ErrorCode_Ornament_CharaNotEnough, 5409).       %% 品质不足
-define(ErrorCode_Ornament_OrderNotEnough, 5410).       %% 阶数不足
-define(ErrorCode_Ornament_NoDec, 5411).                %% 没有消耗品
-define(ErrorCode_Ornament_OneKeyOpNoWear, 5412).       %% 一键穿戴没有成功

%% 55 魂器
-define(ErrorCode_Horcrux_HxUnLock, 5501).              %% 魂器未解锁
-define(ErrorCode_Horcrux_LvMax, 5502).                 %% 已达到最大等级
-define(ErrorCode_Horcrux_NoDec, 5503).                 %% 没有消耗品
-define(ErrorCode_Horcrux_SkillBoxOpened, 5504).        %% 技能格已开放
-define(ErrorCode_Horcrux_HsLvNotEnough, 5505).         %% 器灵等级不足
-define(ErrorCode_Horcrux_VipLvNotEnough, 5506).        %% vip等级不足
-define(ErrorCode_Horcrux_SkillBoxNotExist, 5507).      %% 技能格不存在
-define(ErrorCode_Horcrux_HsPillMax, 5508).             %% 磕丹上限
-define(ErrorCode_Horcrux_SkillBoxNotOpen, 5509).       %% 技能格未开放
-define(ErrorCode_Horcrux_NoSkill, 5510).               %% 未获得该技能
-define(ErrorCode_Horcrux_NotPutOnSkill, 5511).         %% 未镶嵌该技能
-define(ErrorCode_Horcrux_SkillTypeRepeat, 5512).       %% 技能类型重复
-define(ErrorCode_Horcrux_SkillRepeat, 5513).           %% 已镶嵌该技能

%% 56 满减促销
-define(ErrorCode_Discount_BuyLimit, 5601).             %% 购买次数不足
-define(ErrorCode_Discount_NoGoods, 5602).              %% 找不到促销商品
-define(ErrorCode_Discount_PlayerLv, 5603).             %% 玩家等级不足
-define(ErrorCode_Discount_VipLv, 5604).                %% vip等级不足
-define(ErrorCode_Discount_ArenaTop, 5605).             %% 历史最大竞技场排名不足
-define(ErrorCode_Discount_RuneTower, 5606).            %% 龙神塔层数不足
-define(ErrorCode_Discount_GuildLv, 5607).              %% 战盟等级不足
-define(ErrorCode_Discount_1v1Rank, 5608).              %% 段位不足
-define(ErrorCode_Discount_CareerLv, 5609).             %% 转职等级不足
-define(ErrorCode_Discount_HonorLv, 5610).              %% 头衔等级不足
-define(ErrorCode_Discount_YLLv, 5611).                 %% 翼灵等级不足
-define(ErrorCode_Discount_SLLv, 5612).                 %% 兽灵等级不足
-define(ErrorCode_Discount_MLLv, 5613).                 %% 魔灵等级不足
-define(ErrorCode_Discount_GdActive, 5614).             %% 对应龙神未激活
-define(ErrorCode_Discount_OpenFunc, 5615).             %% 对应功能未开启
-define(ErrorCode_Discount_WorldLv, 5616).              %% 世界等级不足
-define(ErrorCode_Discount_MountActive, 5617).          %% 对应坐骑未激活
-define(ErrorCode_Discount_PetActive, 5618).            %% 对应宠物未激活
-define(ErrorCode_Discount_WingActive, 5619).           %% 对应翅膀未激活
-define(ErrorCode_Discount_HolyActive, 5620).           %% 对应圣物未激活
-define(ErrorCode_Discount_BattleFieldJoin, 5621).      %% 永恒战场参与次数不足
-define(ErrorCode_Discount_GuildGuardJoin, 5622).       %% 守卫战盟参与次数不足
-define(ErrorCode_Discount_ArenaJoin, 5623).            %% 竞技场参与次数不足
-define(ErrorCode_Discount_1v1Join, 5624).              %% 1v1参与次数不足
-define(ErrorCode_Discount_MeleeJoin, 5625).            %% 魔龙洞窟参与次数不足
-define(ErrorCode_Discount_AshuraJoin, 5626).           %% 血色争霸参与次数不足
-define(ErrorCode_Discount_WorldBossJoin, 5627).        %% 世界boss参与次数不足
-define(ErrorCode_Discount_YanmoJoin, 5628).            %% 炎魔试炼参与次数不足
-define(ErrorCode_Discount_DungeonCpJoin, 5629).        %% 情侣试炼参与次数不足
-define(ErrorCode_Discount_BuyNothing, 5630).           %% 没有买任何东西
-define(ErrorCode_Discount_NoShop, 5631).               %% 不存在该商店

%% 57 拍卖行
-define(ERROR_auction_find_group, 5701). %% 找不到拍卖
-define(ERROR_auction_find_guild, 5702). %% 战盟未参与活动
-define(ERROR_auction_find_goods, 5703). %% 找不到商品
-define(ERROR_auction_group_state, 5704). %% 拍卖未开启
-define(ERROR_auction_bid_valid_guild, 5705). %% 不能竞价(公会原因)
-define(ERROR_auction_goods_sold, 5706). %% 商品已售出
-define(ERROR_auction_bid_num, 5707). %% 竞价次数错误
-define(ERROR_auction_item_amount, 5708). %% 物品数量错误
-define(ERROR_auction_limit_player, 5709). %% 限购商品不能购买
-define(ERROR_auction_bid_player, 5710). %% 重复竞价
-define(ERROR_auction_bid_valid_player, 5711). %% 不能竞价(个人原因)

%% 58 龙神777
-define(ErrorCode_Card777_NoCardExist, 5801).       %% 卡片不存在
-define(ErrorCode_Card777_CardSelected, 5802).      %% 已翻过该卡片
-define(ErrorCode_Card777_TimesNotEnough, 5803).    %% 次数不足
-define(ErrorCode_Card777_NoAward, 5804).           %% 未找到奖励
-define(ErrorCode_Card777_AwardDuplicate, 5805).    %% 重复领奖
-define(ErrorCode_Card777_AwardExist, 5806).        %% 还有奖励未领取
-define(ErrorCode_Card777_TimesMax, 5807).          %% 重置次数上限

%% 59 节日签到
-define(ErrorCode_FSign_Condition, 5901).           %% 条件不满足
-define(ErrorCode_FSign_NoSignId, 5902).            %% 签到活动不存在
-define(ErrorCode_FSign_RepSignNotSupport, 5903).   %% 不支持补签
-define(ErrorCode_FSign_DayErr1, 5904).             %% 错过天数不可签到
-define(ErrorCode_FSign_DayErr2, 5905).             %% 当天无需补签
-define(ErrorCode_FSign_SignDuplicate, 5906).       %% 重复签到
-define(ErrorCode_FSign_AwardDuplicate, 5907).      %% 重复领奖

%% 60 神兵
-define(ErrorCode_Weapon_Lock, 6001).               %% 神兵未解锁
-define(ErrorCode_Weapon_NotActive, 6002).          %% 神兵未激活
-define(ErrorCode_Weapon_CantMake, 6003).           %% 该神兵不可打造
-define(ErrorCode_Weapon_MakeMax, 6004).            %% 该神兵已打造完成
-define(ErrorCode_Weapon_DayLimit, 6005).           %% 次数已达到每日上限
-define(ErrorCode_Weapon_NoChara, 6006).            %% 不存在的打造品质
-define(ErrorCode_Weapon_RechargeLess, 6007).       %% 充值数量不够
-define(ErrorCode_Weapon_MakeLess, 6008).           %% 打造进度不足
-define(ErrorCode_Weapon_MaxReopen, 6009).          %% 已达到最大解封等级
-define(ErrorCode_Weapon_MaxLevel, 6010).           %% 已达到最大升阶等级
-define(ErrorCode_Weapon_MaxStar, 6011).            %% 已达到最大星级
-define(ErrorCode_Weapon_NeedStar, 6012).           %% 所需部位星级不足
-define(ErrorCode_Weapon_PillMax, 6013).            %% 已达到磕丹上限
-define(ErrorCode_Weapon_SkillBoxOpened, 6014).     %% 技能孔已开放
-define(ErrorCode_Weapon_SoulLvNotEnough, 6015).    %% 兵魂等级不足
-define(ErrorCode_Weapon_SkillBoxNotExist, 6016).   %% 技能孔不存在
-define(ErrorCode_Weapon_NoSkill, 6017).            %% 技能不存在
-define(ErrorCode_Weapon_SkillTypeRepeat, 6018).    %% 技能类型重复
-define(ErrorCode_Weapon_SkillRepeat, 6019).        %% 已镶嵌该技能
-define(ErrorCode_Weapon_NotPutOnSkill, 6020).      %% 未镶嵌该技能
-define(ErrorCode_Weapon_CantReopen, 6021).         %% 该神兵不可解封
-define(ErrorCode_Weapon_CantStar, 6022).           %% 该神兵不可升星
-define(ErrorCode_Weapon_MaxSoulLv, 6023).          %% 兵魂已达到最大等级
-define(ErrorCode_Weapon_DuplicateActive, 6024).    %% 重复激活
-define(ErrorCode_Weapon_AlreadyEquip, 6025).        %% 神兵重复装配
-define(ErrorCode_Weapon_FetterCantActive, 6026).    %% 羁绊无法激活
-define(ErrorCode_Weapon_FetterCfgNotCompare, 6027).%% 羁绊配置不匹配
-define(ErrorCode_Weapon_FetterNeedStar, 6028).        %% 羁绊激活条件不满足
-define(ErrorCode_Weapon_NotEquip, 6029).            %% 神兵未装配
-define(ErrorCode_Weapon_MaxFetter, 6030).            %% 神兵羁绊已满级

%% 61 神秘商店
-define(ErrorCode_Mystery_NoShop, 6101).            %% 商店不存在
-define(ErrorCode_Mystery_ShopInValid, 6102).       %% 商店已过期
-define(ErrorCode_Mystery_NoGoods, 6103).           %% 商品不存在
-define(ErrorCode_Mystery_BuyDuplicate, 6104).      %% 重复购买
-define(ErrorCode_Mystery_CostNotEnough, 6105).     %% 消耗不足
-define(ErrorCode_MysteryShop_RefreshMax, 6106).    %% 刷新上限
-define(ErrorCode_MysteryShop_BuyMax, 6107).        %% 购买上限

%% 62 节日工资
-define(Wage_ErrorCode_restCondi, 6201).        %% 重置次数不足
-define(Wage_ErrorCode_restFront, 6202).        %% 前置抽奖未完成
-define(Wage_ErrorCode_noDraw, 6203).           %% 不能抽取该卡
-define(ErrorCode_Wage_Closed, 6204).           %% 活动未开启或已关闭
-define(Wage_ErrorCode_noRest, 6205).           %% 不能重置该卡
-define(Wage_ErrorCode_noFirstDraw, 6206).      %% 请先完成抽奖再重置

%% 63 招财猫
-define(Cat_ErrorCode_noData, 6301).        %% 没有活动数据
-define(Cat_ErrorCode_noTimes, 6302).       %% 抽奖次数耗尽
-define(Cat_ErrorCode_noCfg, 6303).         %% 配置错误
-define(Cat_ErrorCode_noRecharge, 6304).    %% 充值不足
-define(Cat_ErrorCode_noCost, 6305).        %% 消费不足
-define(Cat_ErrorCode_noVip, 6306).         %% VIP等级不足
-define(Cat_ErrorCode_noConsume, 6307).     %% 消耗物品不足

%% 64 风暴龙城
-define(ERROR_dragon_city_not_open, 6401). %% 功能未开启
-define(ERROR_dragon_city_find_statue, 6402). %% 找不到雕像
-define(ERROR_dragon_city_has_updown, 6403). %% 已经赞/踩过了
-define(ERROR_dragon_city_not_enter, 6404). %% 边境未开放

%% 65 荣耀龙徽
-define(ERROR_Glory_Badge_Advance, 6501). %% 已经达到该阶
-define(ERROR_Glory_Badge_noData, 6502).        %% 没有活动数据
-define(ERROR_Glory_Badge_NoAdvance, 6503).      %% 没有该阶级
-define(ERROR_Glory_Badge_NoCost, 6504).      %% 消耗不足
-define(ERROR_Glory_Badge_NoLevel, 6505).      %% 等级不足
-define(ERROR_Glory_Badge_NoMaxLevel, 6506).      %% 超过最大等级
-define(ERROR_Glory_Badge_NoUpRank, 6507).      %% 不能领取奖励
-define(ERROR_Glory_Badge_NoGoods, 6508).      %% 商品不存在
-define(ERROR_Glory_Badge_NoCfg, 6509).      %% 配置错误
-define(ERROR_Glory_Badge_NoBuy, 6510).      %% 商品不可购买
-define(ERROR_Glory_Badge_OneLevel, 6511).      %% 至少购买一级
-define(ERROR_Glory_Badge_NoCondition, 6512).      %% 条件不满足
-define(ERROR_Glory_Badge_NoCoin, 6513).      %% 不能货币购买
-define(ERROR_Glory_Badge_Notimes, 6514).      %% 购买次数错误

%% 66 星座
-define(ErrorCode_Constellation_No_Active, 6601).                  %% 星座未激活
-define(ErrorCode_Constellation_Max_Star_Level, 6602).             %% 到达最大等级
-define(ErrorCode_Constellation_No_Equipment, 6603).               %% 未装备物品
-define(ErrorCode_Constellation_Enhance_Limit, 6604).              %% 到达强化上限
-define(ErrorCode_Constellation_Guard_Position_Lock, 6605).        %% 守护位置未解锁
-define(ErrorCode_Constellation_No_Guard, 6606).                   %% 守护未激活
-define(ErrorCode_Constellation_Skill_Position_Unlock, 6607).      %% 技能位置已解锁
-define(ErrorCode_Constellation_Skill_Position_Unlock_Limit, 6608).%% 解锁条件不满足
-define(ErrorCode_Constellation_Skill_Position_Lock, 6609).        %% 技能位置未解锁
-define(ErrorCode_Constellation_Skill_Lock, 6610).                 %% 技能未激活
-define(ErrorCode_Constellation_Equip_Condition_Limit, 6611).      %% 装配条件不满足
-define(ErrorCode_Constellation_Guard_Condition_Limit, 6612).      %% 守护条件不满足
-define(ErrorCode_Constellation_Awaken_LvLimit, 6613).             %% 等级上限
-define(ErrorCode_Constellation_Awaken_Condition, 6614).           %% 不满足条件
-define(ErrorCode_Constellation_Bless_LvLimit, 6615).              %% 等级上限
-define(ErrorCode_Constellation_BlessPro_LvLimit, 6616).           %% 等级上限
-define(ErrorCode_Constellation_Gem_Max_Level, 6617).              %% 星石达到最大等级
-define(ErrorCode_Constellation_No_Gem, 6618).                     %% 星石未镶嵌
-define(ErrorCode_Constellation_Gem_Condition_Limit, 6619).        %% 星石镶嵌类型不一致
-define(ErrorCode_Constellation_Gem_CostList_Bad, 6620).           %% 星石升级，客户端传入的消耗材料过多或不足
-define(ErrorCode_Constellation_Gem_Skill_Max_Level, 6621).        %% 星石技能达到最大等级
-define(ErrorCode_Constellation_Gem_Skill_CanNotReset, 6622).      %% 星石技能不能重置
-define(ErrorCode_Constellation_Gem_NoBetter, 6623).               %% 暂无更优的星石

%% 67 边境夺宝
-define(ErrorCode_DemonsBorder_ActiveClose, 6701).              %% 活动未开放
-define(ErrorCode_DemonsBorder_NoBoss, 6702).                   %% 没有这个boss
-define(ErrorCode_DemonsBorder_MaxTimes, 6703).                 %% 参与次数限制

%% 68 古神圣装
-define(ErrorCode_Ancient_Holy_Eq_Position_Locked, 6801). %% 穿戴位置未解锁
-define(ErrorCode_Ancient_Holy_Eq_Enhancement_Level_Limit, 6802). %% 到达最大强化等级
-define(ErrorCode_Ancient_Holy_Eq_Not_Eq, 6803). %% 该位置未穿戴装备
-define(ErrorCode_Ancient_Holy_Eq_Career_Limit, 6804). %% 非本职业圣装无法穿戴
-define(ErrorCode_Ancient_Holy_Eq_Level_Limit, 6805). %% 等级未达要求

%% 69 圣战遗迹
-define(ErrorCode_HW_NoMap, 6901).                              %% 地图不存在
-define(ErrorCode_HW_NoBoss, 6902).                             %% boss不存在
-define(ErrorCode_HW_Consume, 6903).                            %% 不满足进图条件

%% 70 神位和神力天赋
-define(ErrorCode_Divine_Talent_Change_Times, 7001).            %% 神系转化次数不足
-define(ErrorCode_Divine_Talent_Add_Point_lock, 7002).          %% 解锁条件未满足不能加点
-define(ErrorCode_Divine_Talent_Add_Point_No_Point, 7003).      %% 天赋点不足
-define(ErrorCode_Divine_Talent_Add_Point_Max, 7004).           %% 天赋已点满
-define(ErrorCode_Divine_Talent_No_God_Type, 7005).           %% 未加入神系
-define(ErrorCode_Divine_Talent_Up_Star_No_Main_Talent, 7006).  %% 非主天赋不可以升星
-define(ErrorCode_Divine_Talent_Up_Star_Max, 7007).             %% 已到最大星级
-define(ErrorCode_Divine_Talent_Up_Star_Max_Now, 7008).         %% 需提升上一神位的主天赋星级
-define(ErrorCode_Divine_Talent_Up_Star_Cost, 7009).            %% 升星材料不足
-define(ErrorCode_Divine_Talent_Up_Star_Condition, 7010).       %% 升星条件不满足
-define(ErrorCode_Divine_Talent_Change_Times_Main_Fight, 7011). %% 主神争夺活动时间内无法转换神系
-define(ErrorCode_Divine_Talent_Not_Add_Point, 7012).           %% 未加点无法进行重置

%% 71 神力战场/神位争夺
-define(ErrorCode_GF_NotEligible, 7101).                        %% 没有资格
-define(ErrorCode_GF_NotOpen, 7102).                            %% 活动未开启
-define(ErrorCode_GF_MapAiDeny, 7103).                          %% 当前地图不能执行该操作
-define(ErrorCode_GF_FightNotFind, 7104).                       %% 未找到该场战斗


%% 72 圣翼
-define(ErrorCode_Holy_Wing_Level_Unlock, 7201).                %% 圣翼等级未解锁
-define(ErrorCode_Holy_Wing_Max_Intensify_Level, 7202).         %% 已到最大强化等级
-define(ErrorCode_Holy_Wing_Intensify_Cost, 7203).              %% 强化材料不足
-define(ErrorCode_Holy_Wing_Level_Unlock_Condition, 7204).      %% 解锁条件不满足
-define(ErrorCode_Holy_Wing_Level_Unlock_Consume, 7205).        %% 解锁消耗不足
-define(ErrorCode_Holy_Wing_Max_Refine_Level, 7206).            %% 已到最大精炼等级
-define(ErrorCode_Holy_Wing_Awaken_Skill_Bind, 7207).           %% 觉醒技能已选择
-define(ErrorCode_Holy_Wing_Rune_Max_Quality, 7208).            %% 符文品质过高
-define(ErrorCode_Holy_Wing_Max_Skill_Level, 7209).             %% 已到最大等级
-define(ErrorCode_Holy_Wing_Skill_Pos_Unlock_Consume, 7210).    %% 扩展消耗不足
-define(ErrorCode_Holy_Wing_Skill_Equip_Consume, 7211).         %% 技能槽数量不足
-define(ErrorCode_Holy_Wing_Point_Cost, 7212).                  %% 加成点数不足
-define(ErrorCode_Holy_Wing_Rune_Lv_Cost, 7213).                %% 符文升级消耗不足
-define(ErrorCode_Holy_Wing_synthetic, 7214).                   %% 未选择圣翼类型无法合成
-define(ErrorCode_Holy_Wing_Equip_Remove, 7215).                %% 背包空余不足无法卸下圣翼
-define(ErrorCode_Holy_Wing_Type_Choose, 7216).                %% 该地图无法转换

%% 73 星空圣墟
-define(ErrorCode_HR_NoMap, 7301).                              %% 地图不存在
-define(ErrorCode_HR_NoBoss, 7302).                             %% boss不存在
-define(ErrorCode_HR_NoCollection, 7303).                       %% 采集物不存在
-define(ErrorCode_HR_AcClose, 7304).                            %% 活动未开放
-define(ErrorCode_HR_AcClosePre, 7305).                         %% 活动即将关闭
-define(ErrorCode_HR_EnterLv, 7306).                            %% 进入等级不足
-define(ErrorCode_HR_EnterHW, 7307).                            %% 未穿戴圣翼
-define(ErrorCode_HR_MaxCurse, 7308).                           %% 疲劳度已满

%% 74 血脉
-define(ErrorCode_Blood_NotExist, 7401).                        %% 血脉不存在
-define(ErrorCode_Blood_ActiveDeny, 7402).                      %% 不能通过此手段激活
-define(ErrorCode_Blood_ActiveCondition, 7403).                 %% 不满足激活条件
-define(ErrorCode_Blood_ActiveDuplicate, 7404).                 %% 重复激活
-define(ErrorCode_Blood_NotActive, 7405).                       %% 还未激活血脉
-define(ErrorCode_Blood_NoDec, 7406).                           %% 无消耗
-define(ErrorCode_Blood_SkillNotActive, 7407).                  %% 技能未激活
-define(ErrorCode_Blood_SkillLevelMax, 7408).                   %% 技能等级已达到最大

%% 75 龙神秘宝
-define(ErrorCode_DragonTreasure_Selected, 7501).               %% 已选择自选奖励
-define(ErrorCode_DragonTreasure_SelectNum, 7502).              %% 选择数量不正确
-define(ErrorCode_DragonTreasure_NotSelect, 7503).              %% 未选择自选奖励
-define(ErrorCode_DragonTreasure_DuplicateDraw, 7504).          %% 重复选择奖励
-define(ErrorCode_DragonTreasure_NullJackpot, 7505).            %% 奖池已空
-define(ErrorCode_DragonTreasure_ConsLess, 7506).               %% 消耗不足
-define(ErrorCode_DragonTreasure_DuplicateReward, 7507).        %% 重复领奖
-define(ErrorCode_DragonTreasure_NullReward, 7508).             %% 没有奖励可领

%% 76 元素试炼
-define(ErrorCode_ElementTrial_NoMap, 7601).                    %% 地图不存在
-define(ErrorCode_ElementTrial_DayBuyLimit, 7602).              %% 超出每日购买上限
-define(ErrorCode_ElementTrial_CurseLimit, 7603).               %% 超出可用上限
-define(ErrorCode_ElementTrial_NoCurse, 7604).                  %% 无可用诅咒值
-define(ErrorCode_ElementTrial_Rule, 7605).                     %% 法则不满足

%% 77 暗炎首领
-define(ErrorCode_DarkLord_NoMap, 7701).                        %% 地图不存在
-define(ErrorCode_DarkLord_Rule, 7702).                         %% 暗炎值不满足
-define(ErrorCode_DarkLord_NoTimes, 7703).                      %% 次数限制
-define(ErrorCode_DarkLord_NoBoss, 7704).                       %% boss不存在

%% 78 恶魔悬赏令
-define(ErrorCode_DemonReward_DuplicateGet, 7801).              %% 重复领取
-define(ErrorCode_DemonReward_DuplicateBuy, 7802).              %% 重复购买
-define(ErrorCode_DemonReward_ScoreNotEnough, 7803).            %% 积分不足
-define(ErrorCode_DemonReward_UnknownType, 7804).               %% 未知悬赏令
-define(ErrorCode_DemonReward_NoAwardId, 7805).                 %% 未找到奖励

%% 80 在线时长奖励
-define(ErrorCode_OnlineReward_BeyondMaxOrderTimes, 7901).                        %% 超过最大抽奖次数
-define(ErrorCode_OnlineReward_WrongIndex, 7902).                        %% 错误索引
-define(ErrorCode_OnlineReward_OrderTimesNotEnough, 7903).                        %% 抽取次数不足
-define(ErrorCode_MondayReward_NoItemGet, 7904).                %% 没有可领取的奖励

%% 81 龙神封印/等级封印
-define(ErrorCode_DragonSeal_NoAc, 8101).           %% 活动未开启或已结束
-define(ErrorCode_DragonSeal_LvLimit, 8102).        %% 等级限制
-define(ErrorCode_DragonSeal_CallNumLimit, 8103).   %% 召唤次数限制
-define(ErrorCode_DragonSeal_CallTimeLimit, 8104).  %% 召唤时间限制
-define(ErrorCode_DragonSeal_MapSettle, 8105).      %% 副本已结算
-define(ErrorCode_DragonSeal_DuplicateAward, 8106). %% 重复领奖
-define(ErrorCode_DragonSeal_LevelNotEnough, 8107). %% 等级不足
-define(ErrorCode_DragonSeal_AwardTime, 8108).      %% 还不能领奖
-define(ErrorCode_DragonSeal_BuyMaxTimes, 8109).    %% 购买次数上限
-define(ErrorCode_DragonSeal_TimesLimit, 8110).     %% 进入次数上限
-define(ErrorCode_LevelSeal_NoAc, 8111).            %% 活动未开启或已结束
-define(ErrorCode_LevelSeal_WrongType, 8112).       %% 类型错误
-define(ErrorCode_LevelSeal_LvLimit, 8113).         %% 等级限制
-define(ErrorCode_LevelSeal_WrongArea1, 8114).      %% 请先完成已开启的副本
-define(ErrorCode_LevelSeal_WrongArea2, 8115).      %% 该副本暂无法挑战
-define(ErrorCode_LevelSeal_NoEnergy, 8116).        %% 体力不足
-define(ErrorCode_LevelSeal_DuplicateAward, 8117). %% 重复领奖
-define(ErrorCode_LevelSeal_LevelNotEnough, 8118). %% 等级不足
-define(ErrorCode_LevelSeal_AwardTime, 8119).      %% 还不能领奖
-define(ErrorCode_LevelSeal_NoShop, 8120).        %% 商店暂未开启
-define(ErrorCode_LevelSeal_ShopBuyMax, 8121).      %% 该商品购买已达到上限
-define(ErrorCode_LevelSeal_WrongArea3, 8122).      %% 该副本已经完成挑战
-define(ErrorCode_LevelSeal_WrongResetMap, 8123).   %% BOSS尚未全部击败，不可重置地图

%% 82 快捷合成
-define(ErrorCode_QuickSynthesize_MaterialNotEnough, 8201).     %% 材料不足
-define(ErrorCode_QuickSynthesize_MaterialOver, 8202).          %% 材料过多
-define(ErrorCode_QuickSynthesize_CantSynthesize, 8203).        %% 不可升级

%% 83 磕丹
-define(ErrorCode_Pill_MinLvNotEnough, 8301).     %% 未达到最低等级
-define(ErrorCode_Pill_UseLimit, 8302).          %% 已达到当前等级使用上限
-define(ErrorCode_Pill_CantUseOneKey, 8303).          %% 未满足一键使用条件

%% 84 主线祝福
-define(ErrorCode_ClientDungeon_HadPos, 8401).     %% 该位置已经解锁
-define(ErrorCode_ClientDungeon_WrongBless, 8402).     %% 不能选择该祝福
-define(ErrorCode_ClientDungeon_NoPos, 8403).     %% 不存在该位置
-define(ErrorCode_ClientDungeon_NoBuy, 8404).     %% 该位置不可手动解锁
-define(ErrorCode_ClientDungeon_CantUnlock, 8405).     %% 不满足解锁条件
-define(ErrorCode_ClientDungeon_NoBlessInPool, 8406).     %% 祝福池中没有该祝福
-define(ErrorCode_ClientDungeon_NoBlessInPos, 8407).     %% 选中位置没有祝福可删除
-define(ErrorCode_ClientDungeon_HaveBlessInEq1, 8408).     %% 装备区有同类型祝福，无法放入祝福池子
-define(ErrorCode_ClientDungeon_HaveBlessInEq2, 8409).     %% 装备区有同类型祝福，无法放入其他位置
-define(ErrorCode_ClientDungeon_PoolClose, 8410).            %% 祝福池功能未开启

%% 85 装备收藏
-define(ErrorCode_EqCollect_EmptyUidList, 8501).              %% 未选择装备
-define(ErrorCode_EqCollect_UsedPos, 8502).              %% 该部位已被占用
-define(ErrorCode_EqCollect_CantEquipThisOrder, 8503).              %% 无法装备在此阶
-define(ErrorCode_EqCollect_NoUidEq, 8504).              %% 不存在该装备
-define(ErrorCode_EqCollect_MaxRebornLv, 8505).              %% 已达到最大再生等级
-define(ErrorCode_EqCollect_NoEquip, 8506).              %% 该部位未收藏装备
-define(ErrorCode_EqCollect_ConditionNotMet, 8507).              %% 收藏条件不满足
-define(ErrorCode_EqCollect_EquipCantCollect, 8508).              %% 该装备无法收藏
-define(ErrorCode_EqCollect_MustSelectPolarityInAdvance, 8509).              %% 必须先幻化之后才能收藏

%% 86 赏金任务
-define(ErrorCode_BountyTask_CantDispatch, 8601).              %% 该任务不可派遣
-define(ErrorCode_BountyTask_UnitNumWrong, 8602).              %% 派遣单位数错误
-define(ErrorCode_BountyTask_MaxDispatchTimes, 8603).              %% 派遣次数已到达上限
-define(ErrorCode_BountyTask_NotSpecial, 8604).              %% 未拥有特权无法派遣特权任务
-define(ErrorCode_BountyTask_UnitIsUsed, 8605).              %% 单位被占用
-define(ErrorCode_BountyTask_TaskNotExist, 8606).              %% 不存在此任务
-define(ErrorCode_BountyTask_TaskNotComplete, 8607).              %% 任务尚未完成
-define(ErrorCode_BountyTask_MaxSSSNum, 8608).              %% SSS任务数已到达上限
-define(ErrorCode_BountyTask_MaxFreeRefreshTimes, 8609).              %% 免费刷新次数到达上限
-define(ErrorCode_BountyTask_NotInDispatching, 8610).              %% 该任务未在派遣中
-define(ErrorCode_BountyTask_TaskAlreadyCompleted, 8611).              %% 任务已完成
-define(ErrorCode_BountyTask_MaxLockedTask, 8612).              %% 锁定任务达到上限
-define(ErrorCode_BountyTask_AlreadyTargetLock, 8613).              %% 已为目标锁定状态
-define(ErrorCode_BountyTask_UnitTypeWrong, 8614).       %% 派遣单位类型错误

%% 87 功能预告奖励
-define(ErrorCode_Guide_AlreadyHave, 8701).              %% 已经领取
-define(ErrorCode_Guide_CantGetPre, 8702).              %% 不满足预告奖励领取条件
-define(ErrorCode_Guide_CantGet, 8703).              %% 不满足功能开启奖励领取条件
-define(ErrorCode_Guide_WrongType, 8704).              %% 类型错误

%% 88 骑宠翼额外
-define(ErrorCode_SL_AlreadyTargetLock, 8801).              %% 已为目标锁定状态
-define(ErrorCode_SL_IndexUnlock, 8802).              %% 技能格尚未锁定
-define(ErrorCode_YL_AlreadyTargetLock, 8803).              %% 已为目标锁定状态
-define(ErrorCode_YL_IndexUnlock, 8804).              %% 技能格尚未锁定
-define(ErrorCode_Pet_MaxUltimateLv, 8805).              %% 已达到必杀技等级上限
-define(ErrorCode_mount_eq_NoEquip, 8806).              %% 未装配该坐骑装备
-define(ErrorCode_mount_eq_MaxStar, 8807).              %% 坐骑装备无法继续升星
-define(ErrorCode_mount_eq_CannotAddStar, 8808).                %% 未装备不能进行升星
-define(ErrorCode_mount_time_NoDevelop, 8809).          %%当前坐骑为限时激活，不可进行养成
-define(ErrorCode_mount_time_NoSkill, 8810).          %%当前坐骑为限时激活，技能及属性不生效，无法镶嵌
-define(ErrorCode_FWing_LevelMax, 8811).          %%该飞翼已达到最大等级，无法再提升
-define(ErrorCode_mount_eq_pos_unlock, 8812).          %%该坐骑装备位已解锁，无需再解锁
-define(ErrorCode_mount_Grade_Deficient, 8813).          %%未满足解锁条件，无法解锁该坐骑装备位
%% 每日累充 89
-define(ErrorCode_Daily_Total_Award_Null, 8901).  %% 没有可领取奖励
-define(ErrorCode_Daily_Total_Award_Has, 8902).  %% 已领取过该奖励
-define(ErrorCode_Daily_Total_Not_Exist, 8903).  %% 没有该达成项
-define(ErrorCode_Daily_Total_Condition, 8904).  %% 领取条件不满足

%% 90 新王者1v1
-define(ErrorCode_King1v1_AcClose, 9001).               %% 活动未开启
-define(ErrorCode_King1v1_PlayerLimit, 9002).           %% 人数超限
-define(ErrorCode_King1v1_MatchFailed, 9003).           %% 匹配失败
-define(ErrorCode_King1v1_NotActive, 9004).             %% 尚未激活
-define(ErrorCode_King1v1_RoundErr, 9005).              %% 没有该对战信息
-define(ErrorCode_King1v1_DuplicateAward, 9006).        %% 重复领取
-define(ErrorCode_King1v1_MaxBuyTime, 9007).            %% 购买次数上限
-define(ErrorCode_King1v1_MaxFightTimes, 9008).         %% 参与次数上限
-define(ErrorCode_King1v1_NoTask, 9009).                %% 不存在该任务
-define(ErrorCode_King1v1_TaskCond, 9010).              %% 任务条件不满足
-define(ErrorCode_King1v1_Fighting, 9011).              %% 战斗中
-define(ErrorCode_King1v1_AwardFailed, 9012).           %% 领取失败
-define(ErrorCode_King1v1_DuplicateBet, 9013).          %% 重复竞猜
-define(ErrorCode_King1v1_MaxBetTimes, 9014).           %% 竞猜次数不足
-define(ErrorCode_King1v1_OutOfBetTime, 9015).          %% 不在竞猜时间
-define(ErrorCode_King1v1_InvalidFight, 9016).          %% 对战信息不存在
-define(ErrorCode_King1v1_PlayerNotEnough, 9017).       %% 玩家不足
-define(ErrorCode_King1v1_WaitResult, 9018).            %% 等待比赛结果
-define(ErrorCode_King1v1_NotBet, 9019).                %% 没有竞猜
-define(ErrorCode_King1v1_BetFailed, 9020).             %% 竞猜失败
-define(ErrorCode_King1v1_MatchSelf, 9021).             %% 不可挑战自己
-define(ErrorCode_King1v1_OutOfRank, 9022).             %% 对手排名过低
-define(ErrorCode_King1v1_NotActive1, 9023).            %% 另外一个未激活
-define(ErrorCode_King1v1_NotBuyBp, 9024).                %% 未购买对应战令
-define(ErrorCode_King1v1_DuplicateBuyBp, 9025).        %% 重复购买战令
-define(ErrorCode_King1v1_UnknownBp, 9026).                %% 购买未知战令
-define(ErrorCode_King1v1_NoTaskAward, 9027).            %% 没有可领取的奖励

%% 91 跨服拍卖行
-define(ErrorCode_ClusterAuction_Open, 9101).           %% 功能未开启
-define(ErrorCode_ClusterAuction_Lookup, 9102).         %% 未找到商品
-define(ErrorCode_ClusterAuction_Sold, 9103).           %% 商品已售出
-define(ErrorCode_ClusterAuction_BidSelf, 9104).        %% 重复竞价
-define(ErrorCode_ClusterAuction_Price, 9105).          %% 价格错误
-define(ErrorCode_ClusterAuction_State, 9106).          %% 状态错误
-define(ErrorCode_ClusterAuction_Permission, 9107).     %% 没有资格

%% 奖杯 92
-define(ErrorCode_Cup_NoCup, 9201).  %% 尚未激活该奖杯
-define(ErrorCode_Cup_UpNoCost, 9202).  %% 奖杯提升没有消耗道具
-define(ErrorCode_Cup_StampConditionNotMet, 9203).  %% 未满足印记激活条件
-define(ErrorCode_Cup_NotUsableStage, 9204).  %% 不可使用该段位奖杯

-define(ErrorCode_Cup_Max_Star, 9205).            %%已达到最大星级

%% 93 圣物系统
-define(ErrorCode_relic_career_lv_less, 9301). %% 转职等级不足
-define(ErrorCode_relic_no_active, 9302).   %% 圣物未激活
-define(ErrorCode_relic_max_level, 9303).   %% 已满级
-define(ErrorCode_relic_no_cost, 9304).     %% 消耗不足
-define(ErrorCode_relic_awaken_no_max, 9305).     %% 觉醒未满级
-define(ErrorCode_relic_inconsistent_quality, 9306).     %% 品质不符
-define(ErrorCode_relic_illusion_no_active, 9307).     %% 幻化未激活
-define(ErrorCode_relic_illusion_max_star, 9308).     %% 幻化已满星
-define(ErrorCode_relic_honor_condition, 9309).     %% 条件不满足
-define(ErrorCode_relic_honor_active, 9310).     %% 已点亮
-define(ErrorCode_relic_awaken_skill_chosen, 9311).     %% 该技能已被选取
-define(ErrorCode_relic_unlock_skill_pos, 9312).     %% 该装配格尚未解锁
-define(ErrorCode_relic_not_break_need_lv, 9313).     %% 未达到突破所需等级
-define(ErrorCode_relic_empty_cost, 9314).     %% 消耗为空
-define(ErrorCode_relic_material_Over, 9315).                %% 材料过多
-define(ErrorCode_relic_material_not_enough, 9316).                %% 材料不足
-define(ErrorCode_relic_RuneMaxLevel, 9317).                %% 圣印已升至最高等级

-define(ErrorCode_relic_illusion_no_condition_rein, 9318).     %% 幻化转生条件不满足
-define(ErrorCode_relic_illusion_complete_rein, 9319).            %%幻化已完成转生
-define(ErrorCode_relic_illusion_up_no_cost, 9320).            %%幻化升星消耗不足
-define(ErrorCode_relic_illusion_rein_no_cost, 9321).            %%幻化转生消耗不足
-define(ErrorCode_relic_illusion_eq_repeat, 9322).            %%圣物幻化 重复装备
-define(ErrorCode_relic_illusion_eq_remove, 9323).            %%圣物幻化 重复卸下
-define(ErrorCode_relic_illusion_eq_not_remove, 9324).            %%圣物幻化 要卸下的圣物不对
%% 94 捐赠抽奖
-define(ErrorCode_DonateRoulette_NoDonate, 9401).         %% 没有这个收集活动
-define(ErrorCode_DonateRoulette_NoCons, 9402).           %% 没有消耗
-define(ErrorCode_DonateRoulette_OutOfAcTime, 9403).      %% 不在活动时间
-define(ErrorCode_DonateRoulette_DuplicateReward, 9404).  %% 重复领奖
-define(ErrorCode_DonateRoulette_NoReward, 9405).         %% 没有这个奖励

%% 竞技场
-define(ERROR_arena_match, 9501). %% 错误的匹配
-define(ERROR_arena_server_down, 9502). %% 目标服失去连接
-define(ERROR_arena_enter_map, 9503). %% 地图进入失败
-define(ERROR_arena_day_max, 9504).     %% 每日挑战次数上限

%% 96 黄金Bp
-define(ErrorCode_PantheonBp_NoData, 9601).                %% 没有数据
-define(ErrorCode_PantheonBp_DuplicateBuy, 9602).        %% 重复购买
-define(ErrorCode_PantheonBp_BpInvalid, 9603).            %% 已过期
-define(ErrorCode_PantheonBp_NoAward, 9604).            %% 没有可领取的奖励

%% 97 回归
-define(ErrorCode_Return_NoServer, 9701).                %% 不存在该备选服务器
-define(ErrorCode_Return_AcClose, 9702).                %% 活动未开放
-define(ErrorCode_Return_NoTask, 9703).                    %% 不存在该奖励
-define(ErrorCode_Return_LevelNotReach, 9704).            %% 等级不足
-define(ErrorCode_Return_RechargeNotEnough, 9705).        %% 充值数量不足
-define(ErrorCode_Return_DuplicateAward, 9706).            %% 重复领奖
-define(ErrorCode_Return_NoTaskType, 9707).                %% 错误的奖励类型
-define(ErrorCode_Return_BindServer, 9708).                %% 已绑定服务器
-define(ErrorCode_Return_AcExpire, 9709).                %% 活动已过期

%% 98 转生bp
-define(ErrorCode_ReinBp_NotOpenOrClose, 9801).                %% 尚未开启或已关闭
-define(ErrorCode_ReinBp_NoAward, 9802).                    %% 没有奖励可领
-define(ErrorCode_ReinBp_LowLevel, 9803).                    %% 等级不足
-define(ErrorCode_ReinBp_DuplicateBuy, 9804).                %% 重复购买

%% 99 联服公会战
-define(ErrorCode_GuildWar_AcClose, 9901).                %% 活动关闭
-define(ErrorCode_GuildWar_StateDeny, 9902).            %% 不在活动状态
-define(ErrorCode_GuildWar_TimeDeny, 9903).                %% 不在活动时间
-define(ErrorCode_GuildWar_GuildDeny, 9904).            %% 所在公会没有权限
-define(ErrorCode_GuildWar_FightNotExist, 9905).        %% 不存在该场战斗
-define(ErrorCode_GuildWar_AlreadyDraw, 9906).            %% 已抽过签
-define(ErrorCode_GuildWar_NotBetTime, 9907).            %% 不在下注时间
-define(ErrorCode_GuildWar_AlreadyBet, 9908).            %% 已经下注
-define(ErrorCode_GuildWar_NotBetStage, 9909).            %% 不在下注阶段
-define(ErrorCode_GuildWar_GuildNotJoin, 9910).            %% 公会未参加该场比赛
-define(ErrorCode_GuildWar_FightCantBet, 9911).            %% 该场比赛不可竞猜
-define(ErrorCode_GuildWar_NotBetYet, 9912).            %% 尚未下注
-define(ErrorCode_GuildWar_GuildRankDeny, 9913).        %% 公会职位不足
-define(ErrorCode_GuildWar_InspireType, 9914).            %% 鼓舞类型错误
-define(ErrorCode_GuildWar_InspireLimit, 9915).            %% 鼓舞次数限制
-define(ErrorCode_GuildWar_FightNotStart, 9916).        %% 战斗未开始
-define(ErrorCode_GuildWar_FightEnd, 9917).                %% 战斗已结束
-define(ErrorCode_GuildWar_FightNotEnd, 9918).            %% 战斗未结束
-define(ErrorCode_GuildWar_AlreadyGet, 9919).            %% 已经领取过了
-define(ErrorCode_GuildWar_BetLose, 9920).                %% 竞猜输了
-define(ErrorCode_GuildWar_BetLimit, 9921).                %% 竞猜次数限制
-define(ErrorCode_GuildWar_ScoreNotEnough, 9922).        %% 积分不足
-define(ErrorCode_GuildWar_CantCollect, 9923).          %% 不可采集
-define(ErrorCode_GuildWar_NoGuild, 9924).              %% 未加入公会

%% 100 Lottery
-define(ERROR_lottery_state, 10001). %% 不能领取奖券
-define(ERROR_lottery_active, 10002). %% 日常活跃度不足
-define(ERROR_lottery_allocate, 10003). %% 奖券分配失败
-define(error_lottery_close, 10004). %% 活动已结束，无法领取奖券
%%
-define(ERROR_entity_lottery_state, 10011). %% 不能领取奖券
-define(ERROR_entity_lottery_active, 10012). %% 日常活跃度不足
-define(ERROR_entity_lottery_allocate, 10013). %% 奖券分配失败
-define(error_entity_lottery_close, 10014). %% 活动已结束，无法领取奖券
%%
-define(ERROR_skin_lottery_state, 10021). %% 不能领取奖券
-define(ERROR_skin_lottery_active, 10022). %% 日常活跃度不足
-define(ERROR_skin_lottery_allocate, 10023). %% 奖券分配失败
-define(error_skin_lottery_close, 10024). %% 活动已结束，无法领取奖券

%% 101 结婚理财
-define(ErrorCode_WeddingCard_DuplicateBuy, 10101).     %% 重复购买
-define(ErrorCode_WeddingCard_NotMarried, 10102).       %% 未结婚
-define(ErrorCode_WeddingCard_DuplicateAward, 10103).   %% 重复领奖
-define(ErrorCode_WeddingCard_NotBuy, 10104).           %% 未购买
-define(ErrorCode_WeddingCard_CpDivorce, 10105).        %% CP离婚限制
-define(ErrorCode_WeddingCard_StateErr, 10106).         %% 状态错误

%% 102 龙城争霸
-define(ErrorCode_ManorWar_NotBidState, 10201).         %% 不在竞拍状态
-define(ErrorCode_ManorWar_NoManorExist, 10202).        %% 未占领领地
-define(ErrorCode_ManorWar_ManorNotExist, 10203).       %% 领地不存在
-define(ErrorCode_ManorWar_BidMoneyLess, 10204).        %% 竞拍资金过少(只能加钱)
-define(ErrorCode_ManorWar_BidMoneyNotEnough, 10205).   %% 竞拍资金不足(出价太低)
-define(ErrorCode_ManorWar_AlreadyAutoBid, 10206).      %% 已自动宣战
-define(ErrorCode_ManorWar_BidExistManor, 10207).       %% 有领地不能宣战
-define(ErrorCode_ManorWar_BidNoPermission, 10208).     %% 没有宣战权限
-define(ErrorCode_ManorWar_ManorCantBid, 10209).        %% 不可对该领地宣战
-define(ErrorCode_ManorWar_BidChanged, 10210).          %% 竞标数据变化
-define(ErrorCode_ManorWar_AcClose, 20211).             %% 活动未开启
-define(ErrorCode_ManorWar_NotJoinAc, 20212).           %% 未参与活动
-define(ErrorCode_ManorWar_NotJoinLaAc, 20213).         %% 未参与上场活动
-define(ErrorCode_ManorWar_NotBattleState, 20214).      %% 不在对战状态
-define(ErrorCode_ManorWar_SameRebornId, 20215).        %% 复活点相同无需更改
-define(ErrorCode_ManorWar_ErrRebornId, 20216).         %% 不存在该复活点
-define(ErrorCode_ManorWar_CantChariot, 20217).         %% 当前地图不可使用战车
-define(ErrorCode_ManorWar_DuplicateAward, 20218).      %% 重复领奖
-define(ErrorCode_ManorWar_OutOfMap, 20219).            %% 不在地图内
-define(ErrorCode_ManorWar_InspireLimit, 20220).        %% 鼓舞次数限制
-define(ErrorCode_ManorWar_PillarNotExist, 20221).      %% 不存在该龙柱
-define(ErrorCode_ManorWar_ScoreNotEnough, 20222).      %% 积分不足
-define(ErrorCode_ManorWar_JoinTimeLimit, 20223).       %% 加入战盟不足24h
-define(ErrorCode_ManorWar_MapSettled, 20224).          %% 地图已结算
-define(ErrorCode_ManorWar_MapNotOpen, 20225).          %% 地图未开放
-define(ErrorCode_ManorWar_CreateTimeLimit, 20226).     %% 创建战盟不足24h

%% TODO =============================================================================
%% TODO 下面是老错误码，后面要清理掉的！D2正式版本要使用的请移到上面来，记得按功能编号！
%% TODO =============================================================================

%% 102、战斗相关
-define(ErrorCode_Battle_Unknown, 102001).  %% 未知错误

%%使用技能打断
-define(ErrorCode_BreakSkill_Unknown, 102003).    %% 102003:系统异常


%% 103、副本提示
%%GS2U_RequestEnterMapResult返回
-define(ServerError, 103001).%%异常
-define(MapDataError, 103002).%%地图数据异常

-define(InvalidMapCfg, 103004).%%Mapsetting配置不存在
-define(InvalidDungeonCfg, 103005).%%Dungeon配置不存在
-define(Dungeon_NotOpen, 103006).%%还未开启该关卡
-define(Dungeon_OutOfFightCount, 103007).%%超出关卡今日挑战次数
-define(EnergyNotEnough, 103008).%%进入体力不足
-define(PlayerLevelError, 103009).%%玩家等级不符合地图要求
-define(ItemNotEnough, 103010).%%进入副本所需物品不足
-define(AlreadyInThisMap, 103011).%%已经在该地图了
-define(VipNotEnough, 103012).%%VIP等级不足
-define(DungeonNotPass, 103013).%%指定关卡未通关
-define(WeekDayNotMatch, 103014).%%星期几（时间）不吻合，未开启
-define(GroupFightCountNotEnough, 103015).%%进入副本公用次数不足
-define(StaminaNotEnough, 103016).%%精力不足
-define(FightValueNotEnough, 103017).%%比武争斗值不足
-define(ResetGroupFightCount_OutOfMax, 103018).%%超过最大重置副本公用次数
-define(BuyDungeonCount_OutOfMaxTime, 103019).%%超过最大购买副本公用次数
-define(BuyDungeonCount_OutOfMoney, 103020).%%购买副本公用次数钱不够
-define(BuyDungeonCount_OutOfGold, 103021).%%购买副本公用次数元宝不够
-define(StateError_InTeam, 103022).%%不是队长的成员进行申请地图操作，退出组队，并返回提示信息
-define(MopUpValueNotEnough, 103023).%%副本扫荡点不足
-define(Dungeon_PreTaskNotCompleted, 103024).%%关卡的前置任务没有完成
-define(EnterDungeon_FuncNotOpen, 103025).%%该副本对应的功能未开启
-define(EnterMap_OutOfPlayerCount, 103026).%%地图已满员
-define(EnterMap_NoGuild, 103027).%%无仙盟无法进入
-define(DungeonPassed, 103028).%%已通关该副本
-define(EnterMap_MaxPlayerCountAndWait, 103029).%%地图人员已满，请等待

-define(WildBoss_Convene_NoGuild, 103031).  %% 没有仙盟
-define(WildBoss_Convene_NoMember, 103032). %% 没有成员
-define(WildBoss_Convene_NoPermission, 103033). %% 没有权限

-define(WildBoss_Convene_CDTime, 103035).   %% 召集CD中
-define(WildBoss_Packet_NoConfig, 103037).  %% 没有相关配置
-define(EnterDungeon_Seal, 103038).  %% 副本封印中
-define(EliteDungeonNotComplete, 103039).  %% 精英副本章节未完成
-define(FuWenScoreNotEnough, 103040).  %% 符文评分不足

-define(OpenChapterBox_ChapterNotOpen, 103201).%%该章节未开启
-define(OpenChapterBox_AlreadyAward, 103202).%%该宝箱已经领取
-define(OpenChapterBox_InvalidCfg, 103203).%%配置不正确
-define(OpenChapterBox_StarNotEnough, 103204).%%星数不足

-define(Dungeon_MainlineIsMaxStar, 103302).%%该关卡已三星通关
-define(Dungeon_MainlineNoBattleValue, 103303).%%战力不足所需要求的两倍，无法秒杀
-define(Dungeon_MainlineNoPass, 103304).%%该关卡未通关，无法秒杀
%% 105、阵容提示

%% 106、主角提示
-define(ErrorCode_Player_Unknown, 106001).               %% 未知错误
-define(ErrorCode_Player_Param, 106002).                 %% 参数错误
-define(ErrorCode_Player_Dead, 106011).                  %% 玩家已死亡
%% 122、副将系统
%% 126、公会系统
%%创建帮派返回
-define(Guild_CreateResult_HasGuild, 126001).%%已拥有公会
-define(Guild_CreateResult_NameOutOfLenght, 126002).%%名字超长
-define(GS2U_CreateGuildResult_Fail_Name_Multy, 126003).%%名字重名

-define(GS2U_CretaResult_NoName, 126104).    %% 请输入仙盟名字
-define(GS2U_CreateResult_MaxCount, 126107).    %% 仙盟个数已满
%%修改帮派公告返回
-define(Guild_ModifyAnnouncement_Toolong, 126005).%%字数过多
-define(Guild_ModifyAnnouncement_Forbidden, 126006).%%包含屏蔽字
-define(Guild_ModifyAnnouncement_NotMember, 126007).%%不是该帮派成员
-define(Guild_ModifyAnnouncement_NoPermission, 126008).%%没有修改权限
%%贡献帮贡返回
-define(Guild_Contribute_NotMember, 126009).%%不是该帮派成员
-define(Guild_Contribute_NoGuild, 126010).%%没有该帮派
%%调整成员职位返回
-define(Guild_ChangeRank_SamePlayer, 126011).%%同一个人
-define(Guild_ChangeRank_NoGuild, 126012).%%没有该帮派

-define(Guild_ChangeRank_NoSource, 126014).%%没有任命者
-define(Guild_ChangeRank_NoTarget, 126015).%%没有被任命者
-define(Guild_ChangeRank_NoPermission, 126016).%%任命者没有足够权限
-define(Guild_ChangeRank_OutOfRankCount, 126017).%%超出帮派该职位任命人数
%%踢成员返回
-define(Guild_KickOut_SamePlayer, 126018).%%同一人
-define(Guild_KickOut_NoGuild, 126019).%%没有该帮派
-define(Guild_KickOut_NoSource, 126020).%%没有踢人者
-define(Guild_KickOut_NoTarget, 126021).%%没有被踢的人
-define(Guild_KickOut_NoPermission, 126022).%%没有踢人的权限
%%成员主动退出帮派返回
-define(Guild_Quit_NoGuild, 126023).%%没有该帮派
-define(Guild_Quit_NoPlayer, 126024).%%没有该成员
-define(Guild_Quit_NoNewChairMan, 126025).%%盟主无法直接退出仙盟，需要转让盟主给其他人才能退出
%%申请入帮返回
-define(Guild_Join_AlreadyInGuild, 126026).%%已经是某帮派成员

-define(Guild_Join_NoGuild, 126028).%%没有该帮派

-define(Guild_Join_MaxApplicantCount, 126030).%%超出了申请列表长度
-define(Guild_Join_MaxMemberCount, 126031).        %%帮派成员已满
-define(Guild_Join_MaxApplicantGuild, 126103).     %% 最多只能同时申请3个仙盟
-define(Guild_Join_NotOpenAction, 126108).      %% 仙盟未开启
%%操作入帮的申请者返回
-define(Guild_OperateApplicant_HaveNoGuild, 126032).%%自己没有帮派
-define(Guild_OperateApplicant_NoGuild, 126033).%%没有该帮派
-define(Guild_OperateApplicant_NoMember, 126034).%%没有该成员
-define(Guild_OperateApplicant_NoApplicant, 126035).%%没有该申请人员

-define(Guild_OperateApplicant_IsOtherGuildMember, 126037).%%该玩家已经是别的帮派成员
-define(Guild_OperateApplicant_MaxMemberCount, 126038).%%帮派成员已满
-define(Guild_OperateApplicant_NoPermission, 126039).%%没有权限
%%修改帮派名称返回
-define(Guild_ChangeName_OutOfLength, 126040).%%新名称超过长度
-define(Guild_ChangeName_NoGuild, 126041).%%自己没有帮派
-define(Guild_ChangeName_SameName, 126042).%%新名称重名
-define(Guild_ChangeName_CD, 126043).%%改名CD中
-define(Guild_ChangeName_NotGuildMember, 126044).%%非帮派成员
-define(Guild_ChangeName_NoPermission, 126045).%%没有改名权限
%%解散帮派返回
-define(Guild_Dissolve_NoGuild, 126046).%%没有帮派
-define(Guild_Dissolve_NotGuildMember, 126047).%%不是帮派成员
-define(Guild_Dissolve_NoPermission, 126048).%%没有权限
%%邀请入帮返回
-define(Guild_Invite_SamePlayer, 126049).%%不能邀请自己
-define(Guild_Invite_NoGuild, 126050).%%没有帮派
-define(Guild_Invite_NotGuildMember, 126051).%%不是帮派成员
-define(Guild_Invite_NoPermission, 126052).%%没有权限
-define(Guild_Invite_MaxMember, 126053).%%已满员
-define(Guild_Invite_TargetHasGuild, 126054).%%被邀请者已有帮派
-define(Guild_Invite_NotOnLine, 126105).    %%对方不在线

-define(Guild_Invite_NoOpenGuild, 126109).  %% 对方没有开启仙盟功能
%%邀请回复返回
-define(Guild_ApplyInvite_NoGuild, 126055).%%没有帮派
-define(Guild_ApplyInvite_NotGuildMember, 126056).%%邀请人不是帮派成员
-define(Guild_ApplyInvite_NoPermission, 126057).%%邀请人没有权限
-define(Guild_ApplyInvite_MaxMember, 126058).%%帮派满员
-define(Guild_ApplyInvite_HasOtherGuild, 126059).%%已加入其他帮派
%% 封天祭祀
-define(Guild_FeteGod_noGuild, 126060).  %%没有帮派
-define(Guild_FeteGod_hasFeted, 126061). %% 已经祭祀过了
-define(Guild_FeteGod_wrongType, 126062).    %% 该配置跟玩家操作配置类型不符
-define(Guild_FeteGod_Not_finish, 126063).    %% 上一次祭祀还未完成


-define(Guild_FeteGod_noMember, 126066).     %% 帮派没有该成员
-define(Guild_FeteGod_noFeteValue, 126067).  %% 积分不足
-define(Guild_FeteGod_hasGetAward, 126068).  %% 已经领取奖励

%% 操作公会背包返回
-define(Guild_GuildBag_NoGuild, 126071). %% 没有帮派

-define(Guild_GuildBag_BagNoItem, 126073).   %% 公会背包没有该物品
-define(Guild_GuildBag_NoMember, 126074).    %% 公会没有该玩家

-define(Guild_GuildBag_NoPermission, 126076).%%没有权限


%% 公会任务
-define(Guild_Task_NoGuild, 126091).     %% 没有公会

-define(Guild_Task_NoMember, 126093).    %% 没有成员记录
-define(Guild_Task_NoTask, 126094).      %% 没有任务数据


%% 领取公会工资
-define(Guild_Salary_NoGuild, 126098).  %% 没有公会

-define(Guild_Salary_NoSalary, 126100). %% 没有工资或已经领取


-define(Guild_SetManor_NoGuild, 126110).    %% 没有加入仙盟


%% 仙盟心愿
-define(Guild_Wish_NoGuild, 126113).    %% 没有仙盟
-define(Guild_Wish_NoMember, 126114).    %% 没有成员记录
-define(Guild_Wish_HasWished, 126115).    %% 今日已经发布过心愿
-define(Guild_Wish_NoPieceCfg, 126116).     %% 没有该碎片的配置
-define(Guild_Wish_NoWishInfo, 126117).     %% 没有该玩家许愿数据
-define(Guild_Wish_OutGive, 126118).        %% 无效的赠送个数
-define(Guild_Wish_NotPiece, 126119).       %% 碎片不足
-define(Guild_Wish_OutGiveTimes, 126120).   %% 超出今日赠送人数
-define(Guild_Wish_OutSingleGiveTimes, 126121).  %% 超出对该玩家的赠送次数
-define(Guild_Wish_UnknowError, 126122).    %% 未知错误
-define(Guild_Wish_PieceFull, 126123).      %% 该玩家已捐满
-define(Guild_Wish_PieceNotSame, 126124).   %% 赠送的碎片不一致
-define(Guild_Wish_NoWishData, 126125).     %% 没有许愿数据
-define(Guild_Wish_MsgCD, 126126).          %% 推送CD中
-define(Guild_Wish_CanNotWish, 126127).     %% 不能许愿该碎片
-define(Guild_EnterCondition_NoGuild, 126128).  %% 没有仙盟
-define(Guild_EnterCondition_NoMember, 126129). %% 没有成员数据
-define(Guild_EnterCondition_NoPermission, 126130). %% 没有权限
-define(Guild_Normal_TodayOutGuild, 126131).    %% 您刚刚加入了新的仙盟，暂不能领取。
-define(Guild_Wish_OverLimitNum, 126132).       %% 许愿数量不符合

%%修改帮派Link群网址返回
-define(Guild_ModifyLinkUrl_Toolong, 126133).%%字数过多
-define(Guild_ModifyLinkUrl_Forbidden, 126134).%%包含屏蔽字
-define(Guild_ModifyLinkUrl_NotMember, 126135).%%不是该帮派成员
-define(Guild_ModifyLinkUrl_NoPermission, 126136).%%没有修改权限
-define(Guild_ModifyLinkUrl_PrefixErr, 126137).%%网址前缀错误

%%仙盟驻地
-define(Guild_Error_NoGuild, 126142).     %% 没有仙盟
-define(Guild_Error_NoMember, 126143).    %% 没有成员记录
-define(Guild_Error_NoTimes, 126145).    %% 请输入捐赠次数
-define(Guild_Error_BattleValue, 126148).       %% 战斗力不足
%%红包系统
-define(Red_Envelope_Out_Time, 126201).    %%红包已过期
-define(Red_Envelope_Not_Exist, 126202).    %%红包不存在
-define(Red_Envelope_Have_Take, 126203).    %%已领过
-define(Red_Envelope_Empty, 126204).    %%红包已领完
-define(Red_Envelope_CMD_Error, 126205).    %%红包口令错误
-define(Red_Envelope_Max_Count, 126206).    %%领取红包额度超过限制
-define(Red_Envelope_No_cfg, 126207).    %%配置错误
-define(Red_Envelope_No_gold, 126208).    %%元宝不足
-define(Red_Envelope_Not_inMap, 126209).    %%对方不在地图


%% 130、社交系统
-define(ErrorCode_Chat_Param, 130002).            %% 参数错误
-define(ErrorCode_Chat_NoTeam, 130003).           %% 找不到队伍
-define(ErrorCode_Chat_NoGuild, 130004).          %% 找不到仙盟
-define(ErrorCode_Chat_NoReceiver, 130005).       %% 找不到接收对象
-define(ErrorCode_Chat_ContentLength, 130006).    %% 内容长度错误
-define(ErrorCode_Chat_DenyChatTime, 130007).     %% 已经被禁言
-define(ErrorCode_Chat_InTargetBlack, 130008).    %% 在对方黑名单中
-define(ErrorCode_Friend_FriendsMax, 130009).       %% 好友数量已达到上限
-define(ErrorCode_Friend_NoInvitePlayer, 130010).    %% 没有查到玩家
-define(ErrorCode_Friend_TargetMaxFriend, 130011).  %% 对方好友数量已达到上限
-define(ErrorCode_Friend_TargetMaxFriend2, 130012).  %% 对方好友已满，对方将无法收到申请信息

-define(ErrorCode_Friends_InBlack, 130013).         %% 您在对方的黑名单中，不能赠送
-define(ErrorCode_Friends_HasGive, 130014).         %% 已经给该玩家赠送过体力了
-define(ErrorCode_Friends_WrongType, 130015).       %% 错误的赠送类型
-define(ErrorCode_Friends_ReceiveEnergy, 130016).         %% 已领取过该玩家赠送的体力

-define(ErrorCode_Friends_NoEnergy, 130017).        %% 没有可领的体力
-define(ErrorCode_Friends_HasGiveGoldEnergy, 130018).   %% 今日已经高级赠送过了
-define(ErrorCode_Friends_HasReciveGoldEnergy, 130019).   %% 今日已经领取过高级赠送
-define(ErrorCode_Friends_NotGiveGoldEnergy, 130020).   %% 对方还没有领取你的高级赠送
-define(ErrorCode_Friends_MaxReciveTimes, 130021).  %% 已经超出今日最大领取次数
-define(ErrorCode_Friends_HasFriend, 130022).  %% 已经是对方好友
-define(ErrorCode_Friends_MaxInvite, 130023).   %% 对方申请已达到上限


%% 131、竞技场
%%GS2U_RequestEnterMapResult返回
-define(CanEnterArena_TargetError, 131001).%%没有对方信息
-define(CanEnterArena_TargetRankNumberNone, 131002).%%对方暂时还没有排名（包括没上榜和刚打过榜单BOSS）
-define(CanEnterArena_Error, 131003).%%自己没有信息
-define(CanEnterArena_NoSameType, 131004).%%不是同一榜类型
-define(CanEnterArena_NoTargetMirro, 131005).%%没有对方镜像
-define(CanEnterArena_RankChange, 131006).%%排行榜发生变化

-define(CanEnterArena_CanNotBeSelf, 131008).%%不能对战自己
-define(CanEnterArena_WrongTime, 131009).%%该时间段不开放竞技场
-define(ArenaDirectWin_BattleValueNotEnough, 131010).%%战斗力不足以压制性胜利
%% 136、游戏活动
-define(MonthCard_ErrorCode_noConfig, 136025).  %% 没有找到配置数据
-define(Signin_ErrorCode_hasSignin, 136001).    %% 已经签到
-define(Funds_ErrorCode_getLevel, 136010).  %% 等级不足
-define(LevelGift_ErrorCode_noConfig, 136013).  %% 没有奖励配置数据
-define(LevelGift_ErrorCode_hasGet, 136014).    %% 已经领取等级礼包
-define(MonthCard_ErrorCode_noData, 136020).    %% 没有找到相应数据
-define(MonthCard_ErrorCode_hasGet, 136021).    %% 已经领取奖励
-define(MonthCard_ErrorCode_noCard, 136022).    %% 没有指定月卡数据
-define(MonthCard_ErrorCode_noUplvl, 136023).   %% 不能升级
-define(MonthCard_ErrorCode_hasCard, 136024).   %% 已经拥有升级后的卡片


%% 137、游戏登陆

-define(Login_LS_Result_Fail_UserNameOrPassword, 137001).            %%验证失败，用户名密码错误
-define(Login_LS_Result_Fail_OtherLogin, 137002).                %%验证失败，重复登录
-define(Login_LS_Result_Fail_Kickout, 137003).                %%被踢下线
-define(Login_LS_Result_Fail_Freeze, 137004).                %%该账户已经被冻结，禁止登录
-define(Login_LS_Result_Fail_Connect, 137005).                %%尚未连接登录服务器








-define(Login_LS_Result_Fail_Version, 137014).                %%版本过低

%%选服务器错误码
-define(Login_SelServer_StateErr, 137017). %%玩家状态错误


-define(Login_SelServer_SerMaintenance, 137020). %% 服务器维护

-define(Login_LS_Result_Fail_LimitCount, 137022).                %%超过连接上限


%% 138、创角选角


-define(CreatePlayer_Result_Fail_Full, 138001).%%满
-define(CreatePlayer_Result_Fail_Name_Unvalid, 138002).%%名字不合法
-define(CreatePlayer_Result_Fail_Name_Exist, 138003).%%重名
-define(CreatePlayer_Result_Fail_Name_Forbidden, 138004).%%名字里有敏感字符

-define(CreatePlayer_Result_Fail_Dont_Connected, 138006).    %%未发登录消息

-define(SelPlayer_Result_UserId_Fail, 138008).%%账号下无此角色
-define(SelPlayer_Result_Player_IsOnline, 138009).%%角色在线
-define(SelPlayer_Result_Fail_Dont_Connected, 138010).    %%未发登录消息
-define(CreatePlayerName_Result_WrongCareer, 138011).   %% 错误的职业
-define(CreatePlayer_Result_InvalidCfg, 138012).%%配置错误

%% 139、翻牌
%%翻牌错误返回GS2U_FlipCardResult
-define(FlipCardResult_GoldNotEnough, 139002).%%元宝不足
%% 140、邀请系统
-define(FrequentOP, 140002).%%操作过于频繁
%%142、世界BOSS
-define(WorldBoss_BuyBuff_MaxTime, 142001). %%最大购买数
-define(WorldBoss_BuyBuff_OutOfMoney, 142002).%%钱不够
-define(WorldBoss_BuyBuff_OutOfGold, 142003).%%元宝不够




-define(KickMe_Reason_OtherLogin, 143001).%%	账号重复登录被踢下线
-define(KickMe_Reason_GM, 143002).%%	被GM踢下线
-define(KickMe_Reason_Forbid, 143003).%%	账号被封禁，踢下线
-define(KickMe_Reason_Transfer, 143004).%%	账号转移，踢下线
-define(KickMe_Reason_ToFast, 143005).%%	加速，踢下线
-define(KickMe_Reason_InvalidDungeonSettle, 143006).%%	客户端副本结算异常，数据异常，踢下线
-define(KickMe_Reason_UpdateRec, 143007).%%	资源有更新，需要下线后，进行更新
-define(KickMe_Reason_Fcm, 143008).%%	防沉迷踢下线
-define(KickMe_Reason_ChangeCareer, 143009).%%	转职踢下线
-define(KickMe_Reason_ReturnBind, 143010).    %% 回归绑定踢下线

%% 新的错误码，不用分模块了
-define(ErrorCode_DownloadReward_144002, 144002).  %% 不能重复领取下载奖励
-define(ErrorCode_FreeEnergy_144003, 144003).  %% 蟠桃宴会还未开启
-define(ErrorCode_FreeEnergy_144004, 144004).  %% 蟠桃宴会已经结束
-define(ErrorCode_FreeEnergy_144005, 144005).  %% 不能重复参加蟠桃宴会
-define(ErrorCode_UseItem_144006, 144006).  %% 使用等级不足，无法使用
-define(ErrorCode_DecMoney_144007, 144007).  %% 铜币不足
-define(ErrorCode_DecGold_144008, 144008).  %% 元宝不足
-define(ErrorCode_DecGoldBind_144009, 144009).  %% 赠送元宝不足
-define(ErrorCode_DecSoulValue_144010, 144010).  %% 魂玉值不足
-define(ErrorCode_DecReputation_144011, 144011).  %% 声望值不足
-define(ErrorCode_DecHonor_144012, 144012).  %% 荣誉值不足
-define(ErrorCode_DecWarSpirit_144013, 144013).  %% 战魂值不足
-define(ErrorCode_DecEquipSoul_144014, 144014).  %% 铸魂值不足
-define(ErrorCode_DecGangCont_144015, 144015).  %% 帮会贡献值不足
-define(ErrorCode_DecArtiSoul_144016, 144016).  %% 法魂值不足
-define(ErrorCode_DecWarCoin_144017, 144017).  %% 战功不足
-define(ErrorCode_Bag_144019, 144019).  %% 背包剩余空间不足
-define(ErrorCode_Bag_144020, 144020).  %% 所需物品不足
-define(ErrorCode_144021, 144021).  %% 不能重复领取FB分享奖励
-define(ErrorCode_144022, 144022).  %% 不能重复领取Kakao分享奖励
-define(ErrorCode_144023, 144023).  %% 不能重复领取好评奖励
-define(ErrorCode_144024, 144024).  %% 不能重复领取账号绑定奖励
-define(ErrorCode_144025, 144025).  %% 荣耀积分不足
-define(ErrorCode_144026, 144026).  %% 不能重复领取VK分享奖励
-define(ErrorCode_ChangeCareer_TimeLimit, 144027).  %% 冷却时间结束后才能使用
-define(ErrorCode_ChangeCareer_CareerLimit, 144028).  %% 未开放该职业的转职
-define(ErrorCode_ChangeCareer_Close, 144029).  %% 职业转换功能未开启
-define(ErrorCode_ChangeCareer_Career, 144030).  %% 目标职业为当前职业，无需转换
-define(ErrorCode_ChangeCareer_MapLimit, 144031).  %% 无法在副本或跨服地图使用
-define(ErrorCode_Ancient_Holy_Eq_144032, 144032).  %% 圣装经验不足
-define(ErrorCode_Guild_Help_144033, 144033).  %% 协助积分不足
-define(ErrorCode_Shengwen_144034, 144034).    %% 圣纹积分不足
-define(ErrorCode_ShengwenExp_144035, 144035).  %% 圣纹经验不足
-define(ErrorCode_DarkFlame_144037, 144037).  %% 魔煅粉尘
-define(ErrorCode_Dragon_Badge_Score_144038, 144038).   %% 龙徽积分不足
-define(ErrorCode_Guild_Help_144039, 144039).   %% 今日声望已达上限，无法获得更多声望
-define(ErrorCode_DecWeaponScore_144040, 144040).   %% 神兵积分不足
-define(ErrorCode_DecShowScore_144041, 144041).     %% 外显积分不足
-define(ErrorCode_DecGuildContribute_144046, 144046).     %% 战盟贡献不足
-define(ErrorCode_DecWheelScore, 144050).     %% 抽奖积分不足
-define(ErrorCode_HONOR_NOT_ENOUGH, 144051).     %% 荣耀不足
-define(ErrorCode_DecServerSealPoint, 144052).     %% 封印之证不足
-define(ErrorCode_DecRoulettePoint_Gem, 144053).   %% 宝石寻宝积分不足
-define(ErrorCode_DecRoulettePoint_Card, 144054).   %% 卡片寻宝积分不足
-define(ErrorCode_DecRoulettePoint_Rune, 144055).   %% 符文寻宝积分不足
-define(ErrorCode_DecTradeGold, 144056).     %% 星币不足
-define(ErrorCode_DecPetDrawNormal, 144057).      %% 宠物抽奖普通积分不足
-define(ErrorCode_DecPetDrawSenior, 144058).      %% 宠物抽奖高级积分不足
-define(ErrorCode_DecGodEmblem, 144059).   %% 神徽不足
-define(ErrorCode_DecSymbiosisWater, 144060).   %% 共生泉水不足
-define(ErrorCode_DecPetCityCoin, 144061).   %% 英雄币不足
-define(ErrorCode_DecGoldXunBao, 144062).    %%黄金寻宝积分不足
-define(ErrorCode_DecBountyCoin, 144063).    %%赏金币不足
-define(ErrorCode_DecSoulStoneXunBao, 144065).    %%魂石寻宝积分不足
-define(ErrorCode_DecPurpleDiamond, 144066).    %% 紫钻不足

-define(ErrorCode_TaitanXunBao, 144070).    %% 泰坦寻宝积分不足
-define(ErrorCode_Chat_144076, 144076).  %% 发送聊天消息太频繁
-define(ErrorCode_Chat_144077, 144077).  %% 每天最多允许发送五次GM留言
-define(ErrorCode_Chat_144078, 144078).  %% 没有指定的语音数据
-define(ErrorCode_144101, 144101).  %% 不能重复领取E好礼奖励
-define(ErrorCode_144102, 144102).  %% 不能重复领取社区关注奖励
-define(ErrorCode_144103, 144103).  %% 错误的奖励类型
-define(Error_AtlasActiveRewardReceived, 144104).  %% 已领取过图鉴激活奖励
-define(ErrorCode_144105, 144105).  %% 不能重复领取官方社群分享奖励
-define(ErrorCode_144106, 144106).  %% 不能重复领取手机绑定奖励
-define(ErrorCode_ActiveCode_hsaExist, 144107).    %% 使用失败，您的验证码已被使用
-define(ErrorCode_ActiveCode_InvalidCode, 144108).  %% 无效的激活码
-define(ErrorCode_ActiveCode_ParamError, 144109).  %% 参数错误
-define(ErrorCode_ActiveCode_NoData, 144110).   %%没有相关数据
-define(ErrorCode_ActiveCode_CodeError, 144111).    %% 规则不正确
-define(ErrorCode_ActiveCode_NotFound, 144112).     %%激活码没找到
-define(ErrorCode_ActiveCode_PlatformLimit, 144113).    %% 使用者不属于激活码发布渠道
-define(ErrorCode_ActiveCode_GameLimit, 144114).    %% 使用者不属于激活码发布游戏
-define(ErrorCode_ActiveCode_TimeExpired, 144115).  %% 激活码过期
-define(ErrorCode_ActiveCode_HasUsed, 144116).  %% 你已经使用过同批次激活码
-define(ErrorCode_ActiveCode_NotUseTime, 144117).   %% 未到使用时间
-define(ErrorCode_ActiveCode_BatchCode, 144118).    %% 批次号错误
-define(ErrorCode_ActiveCode_BatchNotExist, 144119).    %% 批次不存在
-define(ErrorCode_DecStarSoul, 144120).  %% 星魂经验不足
-define(ErrorCode_Cfg_144121, 144121).        %%配置错误
-define(ErrorCode_144123, 144123).        %%vip每日免费经验已领取
-define(ErrorCode_144130, 144130).                %%vip等级未满足
-define(ErrorCode_CallError, 144192).        %% 服务器繁忙，请稍后重试
-define(ErrorCode_Collection_144193, 144193).  %% 找不到采集物
-define(ErrorCode_Collection_144194, 144194).  %% 采集物正在被其他玩家采集
-define(ErrorCode_Collection_144195, 144195).  %% 采集物距离不足
-define(ErrorCode_Collection_144196, 144196).  %% 找不到玩家
-define(ErrorCode_Collection_144197, 144197).  %% 本服或同盟服玩家不能采集
-define(ErrorCode_DecLoveValue_144198, 144198).  %% 爱心值不足
-define(ErrorCode_Battlefield_144199, 144199).  %% 排行榜不存在
-define(ErrorCode_Battlefield_144200, 144200).  %% RealmsBattlefieldCfg配置不存在
-define(ErrorCode_Battlefield_144201, 144201).  %% 奖励不能重复领取
-define(ErrorCode_Battlefield_144202, 144202).  %% 任务进度未满
-define(ErrorCode_Battlefield_144203, 144203).  %% 找不到仙盟
-define(ErrorCode_Battlefield_144204, 144204).  %% 您的竞技场排名不足，无法进入此战场！
-define(ErrorCode_Battlefield_144205, 144205).  %% 您已选择其他战场，活动期间无法进入此战场！
-define(ErrorCode_Battlefield_144206, 144206).  %% 复活时间未到
-define(ErrorCode_Battlefield_144207, 144207).  %% 活动时间未到
-define(ErrorCode_Battlefield_144208, 144208).  %% 当前场次人数已满，明天请尽早进入
-define(ErrorCode_Battlefield_144209, 144209).  %% 当前战场已结束
-define(ErrorCode_Collection_144210, 144210).  %% 采集时间不足
-define(ErrorCode_Battlefield_144211, 144211).  %% 没有可领取的奖励
-define(ErrorCode_144220, 144220).  %% 血玉值不足
-define(ErrorCode_BattleField_GuilMemener_Limit, 144226).  %% 三界战场同仙盟人数限制
-define(ErrorCode_144242, 144242).   %% 使用的Buff球不存在
-define(ErrorCode_144243, 144243).  %% Buff球不属于你
-define(ErrorCode_144244, 144244).  %% Buff球已被拾取
-define(ErrorCode_144245, 144245).  %% Buff球拾取距离不足
-define(ErrorCode_144246, 144246).  %% 非活动时间不能进入地图
-define(ErrorCode_144247, 144247).  %% 传送门已被使用
-define(ErrorCode_144248, 144248).  %% 传送门使用距离不足
-define(ErrorCode_144249, 144249).  %% Buff球已满
-define(ErrorCode_144250, 144250).  %% 威望值不足
-define(ErrorCode_144251, 144251).  %% 功能未开启
-define(ErrorCode_Wing_144273, 144273).  %% 次数不足
-define(ErrorCode_144275, 144275).    %% MountAwakenCfg配置错误
-define(ErrorCode_144283, 144283).  %% 仙侣精华不足
-define(ErrorCode_144280, 144284).    %% 活动尚未开始
-define(ErrorCode_144285, 144285).  %% 未找到仙侣试炼房间
-define(ErrorCode_144286, 144286).  %% 未找到仙侣
-define(ErrorCode_144289, 144289).  %% 目标职业未激活
-define(ErrorCode_144294, 144294).  %% 拜堂状态错误
-define(ErrorCode_144295, 144295).  %% 婚礼预约场次不存在
-define(ErrorCode_144296, 144296).  %% 婚礼预约场次已经被占用
-define(ErrorCode_144297, 144297).  %% 不是已婚状态
-define(ErrorCode_144298, 144298).  %% 已有婚礼
-define(ErrorCode_144299, 144299).  %% 场次不可预约
-define(ErrorCode_144300, 144300).  %% 婚礼不存在
-define(ErrorCode_144301, 144301).  %% 婚礼准备错误
-define(ErrorCode_144302, 144302).  %% 婚礼准备状态错误
-define(ErrorCode_144303, 144303).  %% 请帖不存在
-define(ErrorCode_144304, 144304).  %% 对方拒绝了请求
-define(ErrorCode_144305, 144305).  %% 拜堂开启后才能进入地图
-define(ErrorCode_144306, 144306).  %% 没有请帖不能进入拜堂地图
-define(ErrorCode_144307, 144307).  %% 不是高级婚礼
-define(ErrorCode_144308, 144308).  %% 不能给自己发请帖
-define(ErrorCode_144309, 144309).  %% 已经有对方的请柬了
-define(ErrorCode_144315, 144315).  %% 仙币不足
-define(ErrorCode_ThreeCoinNotEnough, 144323).  %% 三界币不足
-define(ErrorCode_144324, 144324).    %% 战斗正在进行，不可加入
-define(ErrorCode_144325, 144325).    %% 战斗已结束
-define(ErrorCode_144326, 144326).    %% 活动正在进行，不可加入
-define(ErrorCode_JoinTimeLimit, 144444).  %% 参与次数达到上限

%% 148 排行榜
-define(ErrorCode_Worship_NoPlayer, 148001).    %% 膜拜的玩家不在战斗力排行榜中
-define(ErrorCode_Worship_NoWorshipTimes, 148002).  %% 今日膜拜次数已经用完，请明日再来！

%% 150 后台活动
-define(ErrorCode_SalesActive_NoActive, 150001).    %% 活动没开启或者已经关闭
-define(ErrorCode_SalesActive_Condition, 150002).   %% 条件不满足
-define(ErrorCode_SalesActive_NoConditionData, 150003). %% 没有找到该奖励数据
-define(ErrorCode_SalesActive_NotReached, 150004).  %% 完成条件没有达成
-define(ErrorCode_SalesActive_OutDayGetTimes, 150005).  %% 今日次数已经达到上限
-define(ErrorCode_SalesActive_OutAllGetTimes, 150006).  %% 该活动次数已经达到上限
-define(ErrorCode_SalesActive_NoLimitShop, 150007).     %% 该活动暂不出售商品
-define(ErrorCode_SalesActive_NoItemData, 150008).      %% 没有该商品的相关数据
-define(ErrorCode_SalesActive_VipLevel, 150010).        %% VIP等级不足
-define(ErrorCode_SalesActive_JoinCondition, 150011).   %% 暂不满足该活动的参与条件
-define(ErrorCode_Bind_HasBindAccount, 150012).         %% 账户已绑定
-define(ErrorCode_Bind_HasBindTell, 150013).            %% 手机号码已绑定
-define(ErrorCode_Bind_WrongAccount, 150014).           %% 账户绑定的号码与输入不一致
-define(ErrorCode_Bind_NoSendData, 150015).             %% 未检测到发送信息
-define(ErrorCode_Bind_OutTime, 150016).                %% 短信信息过期,重新绑定
-define(ErrorCode_Bind_BindFiald, 150017).              %% 更新绑定失败
-define(ErrorCode_NexDayAward_HasGet, 150019).          %% 已经领取奖励
-define(ErrorCode_SalesActive_ChangeNull, 150022).      %% 没有可以兑换的物品
-define(ErrorCode_SalesActive_NoExChangeItem, 150023).  %% 找不到兑换的物品
-define(ErrorCode_roulette_NoConfig, 150025).           %% 没有该活动
-define(ErrorCode_roulette_EnoughCons, 150027).         %% 消耗物品不足
-define(ErrorCode_roulette_Dropping, 150028).           %% 上次抽奖尚未完成
-define(ErrorCode_roulette_HasChanged, 150029).         %% 已经兑换过该物品
-define(ErrorCode_roulette_NotHasItem, 105030).         %% 没有兑换的物品
-define(ErrorCode_roulette_EnoughIntegral, 105031).     %% 兑换积分不足
-define(ErrorCode_roulette_NotMatchType, 150032).       %% 不支持的奖励类型
-define(ErrorCode_roulette_HasNoItem, 150033).          %% 没有找到提取的物品
-define(ErrorCode_roulette_EnoughCount, 150034).        %% 提取物品数量不足
-define(ErrorCode_roulette_UnValidTime, 150035).        %% 活动未开始或已结束
-define(ErrorCode_roulette_FullBag, 150036).            %% 背包格子不足，请清理背包后提取
-define(ErrorCode_roulette_NoRouletteSup, 150037).      %% 没有活动处理进程
-define(ErrorCode_roulette_changeNotEnough, 150039).    %% 可兑换物品不足
-define(ErrorCode_SalesActivity_WorldIndex, 150040).    %% 世界等级索引不正确
-define(ErrorCode_SalesActive_OutServerDayGetTimes, 150041).  %% 今日全服次数已经达到上限
-define(ErrorCode_SalesActive_OutServerAllGetTimes, 150042).  %% 该活动全服次数已经达到上限
-define(ErrorCode_SalesActive_OutServerTimes, 150043).      %% 超出全服次数
-define(ErrorCode_SalesActive_HasBuy, 150044).          %% 已经购买该基金
-define(ErrorCode_SalesActive_NoSuchRecharge, 150045).  %% 充值金额不足
-define(ErrorCode_SalesActive_HasNotBuy, 150046).       %% 还没有购买该基金
-define(ErrorCode_SalesActive_HasGetAward, 150047).     %% 已经领取该奖励
-define(ErrorCode_SalesActive_HasNoIndex, 150048).      %% 没有该档次
-define(ErrorCode_SalesActive_GetAllReward, 150049).    %% 已领取所有奖励
-define(ErrorCode_SalesActive_CantOneKeyReward, 150050).%% 不可一键领取
-define(ErrorCode_SalesActive_NoAward, 150051).         %% 没有可领取的奖励
-define(ErrorCode_DragonHonor_HasAward, 150052).        %% 已领取过每日奖励
-define(ErrorCode_SalesActive_Times_Max, 150053).        %% 购买次数已达上限
-define(ErrorCode_Limit_Direct_Not_Open_Buy, 150054).   %% 未开放购买
-define(ErrorCode_Limit_Direct_Cant_Buy_Way, 150055).   %% 购买方式错误
-define(ErrorCode_Privilege_Weekly_Card, 150056).   %% 特权周卡未激活
-define(ErrorCode_SalesActive_HasReset, 150057).         %% 已经参与过重置

%%%% 151 领地战
%%-define(ErrorCode_ManorWar_Bid_NoGuild, 151001).        %%没有仙盟，无法竞标
%%-define(ErrorCode_ManorWar_Bid_NoPermission, 151003).        %%没有权限，无法竞标
%%-define(ErrorCode_ManorWar_Bid_NotGreaterThanMin, 151008).        %%必须超过最小的竞标资金
%%-define(ErrorCode_ManorWar_Enter_NotAcitveTime, 151021).        %%不是活动期间，无法进入
%%-define(ErrorCode_ManorWar_Enter_NoPermission, 151022).        %%没有资格进入
%%-define(ErrorCode_ManorWar_Change_TryAgain, 151025).        %%更换营地未成功，请重新操作
%%-define(ErrorCode_ManorWar_Cant_Transform, 151026).        %%当前地图无法开启战车
%%-define(ErrorCode_ManorWar_Chariots_Type_Err, 151027).        %%没有此类型战车
%%-define(ErrorCode_ManorWar_Has_Chariots, 151028).        %%已开启战车
%%-define(ErrorCode_ManorWar_Not_Chariots, 151029).        %%未开启战车
%%-define(ErrorCode_ManorWar_Enter_End, 151030).        %%已结束

%%153改名
-define(ErrorCode_Name_Not_Guild_ChairMan, 153001).%%非仙盟盟主

%%155仙盟组队
-define(ErrorCode_GuildTeam_No_Team, 155002).%%没有队伍
-define(ErrorCode_GuildTeam_Object_OffLine, 1550013).%%对方已下线

%%156
%%156 运镖
-define(ErrorCode_convoy_NoConfig, 156001).     %% 没有奖励配置
-define(ErrorCode_Convoy_Insured, 156003).      %% 镖车已投保
-define(ErrorCode_Convoy_RefreshInsured, 156004).      %% 镖车已投保,不能刷新
-define(ErrorCode_Convoy_MaxQuality, 156005).       %% 镖车已达到最大品质
-define(ErrorCode_Convoy_NoCostType, 156006).       %% 没找到消耗方式
-define(ErrorCode_Convoy_VipLevelEnough, 156007).   %% VIP等级不足
-define(ErrorCode_Convoy_CostEnough, 156008).       %% 刷新消耗不足
-define(ErrorCode_Convoy_PlayerLevel, 156011).      %% 玩家等级不足
-define(ErrorCode_Convoy_TooFar, 156012).           %% 距离太远
-define(ErrorCode_Convoy_NPC, 156013).              %% 没找到接任务对应NPC
-define(ErrorCode_Convoy_NoData, 156015).           %% 没有运镖数据
-define(ErrorCode_Convoy_MaxTimes, 156016).         %% 已经超过运镖次数上限
-define(ErrorCode_Convoy_WrongState, 156017).       %% 错误的状态
-define(ErrorCode_Convoy_WrongMapOrNPC, 156018).    %% 请前往指定的NPC位置
-define(ErrorCode_Convoy_NoVehicle, 156019).        %% 镖车已不在地图中
-define(ErrorCode_Convoy_OutRescueTime, 156020).    %% 超出救援时间
-define(ErrorCode_Convoy_VehicleWrongMap, 156021).  %% 镖车位置异常
-define(ErrorCode_Convoy_InTransState, 156023).     %% 已经在传送中
-define(ErrorCode_Convoy_NotVehicleArea, 156024).   %% 不在镖车旁边
-define(ErrorCode_Convoy_NotSameMap, 156025).       %% 不在镖车所在地图
-define(ErrorCode_Convoy_StartConvoy, 156026).      %% 已经开始运镖
-define(ErrorCode_Convoy_playerDead, 156028).       %% 您已死亡
-define(ErrorCode_Convoy_Forbidden_Transfer, 156029). %% 上车状态不可切换地图

%% 160051 飞镖
-define(ErrorCode_Darts_NoInvite, 160051).          %% 没有收到邀请函
-define(ErrorCode_Darts_AlreadyActive, 160052).     %% 已经激活该场次
-define(ErrorCode_Darts_NotActivation, 160054).     %% 没有激活该场次
-define(ErrorCode_Darts_NoPeltTimes, 160055).       %% 消耗不足
-define(ErrorCode_Darts_ConfigError, 160056).       %% 配置错误
-define(ErrorCode_Darts_WrongType, 160057).         %% 参与场次类型错误
-define(ErrorCode_Darts_NoRingConfig, 160058).      %% 没有环数配置
-define(ErrorCode_Darts_GetMaxPoint, 160059).       %% 已经领取全部积分
-define(ErrorCode_Darts_RestTime, 160060).          %% 休整时间中
-define(ErrorCode_Darts_ExchangeNotCfg, 160061).    %% 没有兑换物品配置
-define(ErrorCode_Darts_IntegralEnough, 160062).    %% 积分不足
-define(ErrorCode_Darts_SelfExchangeMax, 160063).   %% 可兑换物品不足
-define(ErrorCode_Darts_OutSelfTimes, 160064).      %% 个人限兑次数不足
-define(ErrorCode_Darts_OutServerTimes, 160065).    %% 全服限兑次数不足
-define(ErrorCode_Darts_Closed, 160066).            %% 活动未开启或已关闭
-define(ErrorCode_Darts_NotMatchType, 160067).      %% 奖励类型不匹配
-define(ErrorCode_Darts_MaxRing, 160068).           %% 已达到最大环数
%%161 跨服比武
-define(ErrorCode_CroFightRing_Timeout, 161001).%%没在活动时间内
-define(ErrorCode_CroFightRing_FuncNotOpen, 161002).%%功能未开启
-define(ErrorCode_CroFightRingAttainment_AlreadyAward, 161003).%%成就奖励已经领取
-define(ErrorCode_CroFightRingAttainment_NotSatisfied, 161004).%%成就还未达成
-define(ErrorCode_CroFightRing_NotFinishBattle, 161005).%%还有未结束的战斗
-define(ErrorCode_CroFightRing_BattleHasFinished, 161006).%%战斗已结束
-define(ErrorCode_CroFightRing_NotAllReady, 161007).%%有队员还未准备
-define(ErrorCode_CroFightRing_QuitPunish, 161008).%%自己还在逃跑惩罚中
-define(ErrorCode_CroFightRing_MemberQuitPunish, 161009).%%有队员还在逃跑惩罚中
-define(ErrorCode_CroFightRing_RetrieveLimit, 161010).%%超出最大回购次数
-define(ErrorCode_CroFightRing_RetrieveCountError, 161011).%%回购次数错误

%%163 公用通知服务
-define(ErrorCode_Notice_TimeOut, 163001).%%邀请已过期

%%164 结婚系统错误提示
-define(ErrorCode_Wedding_NotInUnmarried, 164001).%%非未婚状态
-define(ErrorCode_Wedding_TeammateNotInUnmarried, 164002).%%对方非未婚状态
-define(ErrorCode_Wedding_InEngageMent, 164003).%%你的上一个提亲还未结束
-define(ErrorCode_Wedding_TeammateInEngageMent, 164004).%%对方上一个提亲还未结束
-define(ErrorCode_Wedding_EngageMentGoodsNotEnough, 164005).%%材料不足
-define(ErrorCode_Wedding_EngageMentRefuse, 164006).%%对方拒绝了你的邀请
-define(ErrorCode_Wedding_EngageMentTimeOut, 164007).%%您的邀请超时，对方未回应
-define(ErrorCode_Wedding_EngageMentNone, 164008).%%邀请已过期
-define(ErrorCode_Wedding_SexNotMatch, 164009).%%性别不符合
-define(ErrorCode_Wedding_NotOnline, 164010).%%对方不在线
-define(ErrorCode_Wedding_OtherLevelLimit, 164011).%%对方等级不足
-define(ErrorCode_Wedding_WorldLevelLimit, 164012).%%世界等级不足
-define(ErrorCode_Wedding_OtherPowerLimit, 164013).%%对方战力不足
-define(ErrorCode_Wedding_IntimacyLimit, 164014).%%亲密度等级不足
-define(ErrorCode_WeddingDating_CannotDeleteFriend, 164015).%%请先处理对方的约会邀请
-define(ErrorCode_Wedding_LevelLimit, 164016).%%等级不足
-define(ErrorCode_Wedding_PowerLimit, 164017).%%战力不足
-define(ErrorCode_BanquetCollectionMaxPer, 164018).%%这桌宴席吃的有点多了，下一桌再吃吧
-define(ErrorCode_BanquetCollectionMax, 164019).%%这场婚礼吃的有点多了，留点给其他宾客吧
-define(ErrorCode_BanquetCollectionNotInState, 164020).%%不在开宴状态
-define(ErrorCode_BanquetCreateNotInState, 164021).%%只有新郎新娘才能操作
-define(ErrorCode_BanquetCreateNotInMap, 164022).%%必须在拜堂地图里面开宴
-define(ErrorCode_MarryDaysNotEnough, 164023).%%结婚天数不足
-define(ErrorCode_MarryCeremonyNotEnough, 164024).%%豪华婚礼参加次数不足
-define(ErrorCode_MarryCeremonyNotEnough2, 164025).%%婚礼仪式参加次数不足
%% 仙侣系统
-define(ErrorCode_NoCruiseData, 165001).    %% 没有迎亲车队数据
-define(ErrorCode_Unmarried, 165003).       %% 未结婚
-define(ErrorCode_MarriedStateError, 165004).       %% 婚姻状态有错
-define(ErrorCode_LeavenTimeUnlimit, 165005). %%离线时间不足
-define(ErrorCode_NotInDivorce, 165006). %%未在离婚状态
-define(ErrorCode_TimeOut, 165007). %%已过期
-define(ErrorCode_DatingNoTimes, 165009). %%约会次数不足
-define(ErrorCode_NotInEngaged, 165010). %%未在订婚状态
-define(ErrorCode_LoveTaskAlreadyFinish, 165011). %%已经完成了情定三生的这一步
-define(ErrorCode_LoveTaskWaitPartner, 165012). %%等待仙侣点击
-define(ErrorCode_DatingNotFinish1, 165013). %%你的约会状态不正确
-define(ErrorCode_DatingNotFinish2, 165014). %%对方的约会状态不正确
-define(ErrorCode_InDivorceState, 165016).   %%您有未处理的离婚
-define(ErrorCode_WeddingTask_NoCfg, 165017).   %% 没有成就配置
-define(ErrorCode_WeddingTask_HasGet, 165018).  %% 该成就已领奖
-define(ErrorCode_WeddingTask_NoEnough, 165019).    %% 成就未达成
-define(ErrorCode_ArmDatingNoTimes, 165020). %%对方约会次数不足
-define(ErrorCode_ArmNotInView, 165021). %%对方不在身边
-define(ErrorCode_NotAllow, 165022). %%当前不允许离婚
-define(ErrorCode_DatingUseFireworkMax, 165023). %%此烟花使用已经达到上限
-define(ErrorCode_ChangeSexNotAllow, 165024). %%当前不允许改变性别
-define(ErrorCode_HasBlessWedding, 165025). %% 已经祝福过了
-define(ErrorCode_hasNoCruise, 165026).     %% 没有游行队伍
-define(ErrorCode_MaxCollection, 165027).   %% 超出最大采集次数
-define(ErrorCode_Flower_NotConfig, 165028).    %% 没有送花配置
-define(ErrorCode_PantheonLowCollect, 165029).   %% 低级宝箱开启达上限
-define(ErrorCode_PantheonHighCollect, 165030).   %% 高级宝箱开启达上限


%%弹幕系统
-define(ErrorCode_danmaku_NoChannel, 166001).   %% 弹幕频道不存在
-define(ErrorCode_danmaku_NoConfig, 166002).    %% 没有配置数据
-define(ErrorCode_danmaku_SpentEnough, 166003). %% 消耗不足
-define(ErrorCode_danmaku_NotBarrageMap, 166004).   %% 当前地图不能发送弹幕
-define(ErrorCode_danmaku_OutWeddingTime, 166005).  %% 当前不在婚礼时间内
-define(ErrorCode_danmaku_OutTimesLimit, 166006).   %% 超出最大赠送次数
%% 信物系统
-define(ErrorCode_Ring_ErrorConfig, 166053). %% 配置错误
-define(ErrorCode_Ring_NoRing, 166054). %% 没有获得当前信物
-define(ErrorCode_Ring_MaxLevel, 166055). %% 信物已经达到最大等级
-define(ErrorCode_Ring_PropReplace, 166056). %% 洗练属性替换错误
-define(ErrorCode_Ring_MaxStar, 166057). %% 信物已经达到最大星级
-define(ErrorCode_Ring_MaxBreak, 166058). %% 信物已经达到最大突破等级
-define(ErrorCode_Ring_NoReinCondition, 166059). %% 未满足信物转生条件
-define(ErrorCode_Ring_MaxReinLv, 166060). %% 信物已经达到最大转生等级，无法继续转生
-define(ErrorCode_Ring_MaxStar2, 166061). %% 信物已经达到当前最大星级，请先进行转生
-define(ErrorCode_Ring_MaxLevel2, 166062). %% 信物已经达到最大等级，请先进行转生
-define(ErrorCode_Ring_IsActive, 166063). %% 信物已经激活
-define(ErrorCode_Ring_MaxLevel3, 166064). %% 信物已经达到当前最大等级，请先进行突破
-define(ErrorCode_Ring_NoLevel, 166065). %% 信物等级未达到要求等级，请先进行升级
-define(ErrorCode_Ring_NoStar, 166066). %% 信物等级未达到要求星级，请先进行升星
%%2v2  166100
-define(ErrorCode_CoupleFight_BuyNotOpen, 166104). %%今日无活动，无法购买
-define(ErrorCode_CoupleFight_BuyNoTimes, 166105). %%购买次数不足
%% 天魔Boss
-define(ErrorCode_Demons_NoDeMonConfig, 167001).    %% 没有天魔Boss配置
-define(ErrorCode_Demons_CannotEnter, 167002).      %% 进入条件不足
-define(ErrorCode_Demons_NoFindMonster, 167003).    %% 没有找到Boss配置
-define(ErrorCode_Demons_NoData, 167004).           %% 没有Boss数据
-define(ErrorCode_Demons_ForceTime, 167005).         %% 该时间段不能关注
-define(ErrorCode_Demons_HasFollowed, 167006).      %% 已经关注该Boss
-define(ErrorCode_Demons_NotFollowed, 167007).      %% 没有关注该Boss
-define(ErrorCode_Demons_NotConsume, 167008).       %% 该地图不用购买时长
-define(ErrorCode_Demons_MaxCurse, 167009).       %% 诅咒值已满
-define(ErrorCode_Demons_BuyNoTimes, 167010).        %%购买次数不足
-define(ErrorCode_Demons_CantMulti, 167011).        %% 多倍挑战开启条件不满足
-define(ErrorCode_Demons_CantChangeMulti, 167012).   %% 不能切换挑战倍数
-define(ErrorCode_Demons_CantBuyFatigue, 167013).   %% 不能购买
-define(ErrorCode_Demons_Fatigue_Overflow, 167014).   %% 超过最大可清除值
-define(ErrorCode_Demons_NoJoinAward, 167015).   %% 没有该奖励
-define(ErrorCode_Demons_NoTrueBoss, 167016).   %% 该boss无法使用收益卡获得奖励
-define(ErrorCode_Demons_HasAward, 167017).   %% 已领取该奖励
-define(ErrorCode_Demons_Award_Cond, 167018).   %% 领取条件不满足

%% 圣盾
-define(ErrorCode__Holy_Shield_Under_Item_Type, 168001). %% 道具类型错误
-define(ErrorCode_HOly_Shield_Max_Level, 168002). %% 已满级

%% 圣甲
-define(ErrorCode_Shengjia_MaxSkill_Level, 168101).                %% 圣甲天赋已满级
-define(ErrorCode_Shengjia_Stage_not_enough, 168102).        %% 圣甲阶级不足
-define(ErrorCode_Shengjia_gem_wrong_type, 168103).        %% 该宝石不能装配在该位置
-define(ErrorCode_Shengjia_gem_wrong_level, 168104).        %% 宝石等级过高
-define(ErrorCode_Shengjia_no_equip, 168105).        %% 不可镶嵌
-define(ErrorCode_Shengjia_skill_no_addlevel, 168106).        %% 前置条件未满足，该天赋不可升级
-define(ErrorCode_Shengjia_noactive, 168107).        %%圣甲未激活
-define(ErrorCode_Shengjia_gemposactive, 168108).        %%该镶嵌位已点亮
-define(ErrorCode_Shengjia_gem_is_equip, 168109).        %%圣甲宝石已镶嵌，不可再镶嵌
-define(ErrorCode_Shengjia_noOpen, 168110).        %%圣甲未开启
-define(ErrorCode_Shengjia_isactive, 168111).        %%圣甲已激活
-define(ErrorCode_Shengjia_noallposactive, 168112).        %%未点亮所有圣甲槽位
-define(ErrorCode_Shengjia_allposactive, 168113).        %%已点亮所有圣甲槽位
-define(ErrorCode_Shengjia_noconditionactive, 168114).        %%前置条件未满足，该圣甲不可激活
-define(ErrorCode_Shengjia_gem_no_equip, 168115).        %%该镶嵌位，没有镶嵌宝石
-define(ErrorCode_Shengjia_skill_no_active, 168116).        %% 前置条件未满足，该天赋不可激活
%%圣纹
-define(ErrorCode_Shengwen_Intensify_Max, 168201).        %% 已达最大强化等级
-define(ErrorCode_Shengwen_Awaken_Max, 168202).        %% 已达最大觉醒等级
-define(ErrorCode_Shengwen_Gongming_Max, 168203).        %% 已达最大共鸣等级
-define(ErrorCode_Shengwen_Num_Less, 168204).        %% 同类型圣纹装备数量不足
-define(ErrorCode_Shengwen_Wrong_Pos, 168205).        %% 圣纹位置错误

%% 小助手 169
-define(ErrorCode_Game_Helper_Not_Mouth, 169001). %% 非月卡用户
-define(ErrorCode_Game_Helper_Not_Mop_Up_Allow, 169002). %% 未达到扫荡条件
-define(ErrorCode_Game_Helper_No_Times, 169003).   %% 扫荡可用次数不足
-define(ErrorCode_Game_Helper_Not_Valid, 169004).  %% 小助手未生效
-define(ErrorCode_Game_Helper_Unknown_Type, 169005).  %% 未知扫荡类型
-define(ErrorCode_Game_Helper_Daily_Award, 169006).  %% 已领取过每日奖励
-define(ErrorCode_Game_Helper_Vip_Limit, 169007).  %% VIP等级不足

%% 边境入侵 170
-define(ErrorCode_Border_War_Cfg, 170001). %% 配置错误
-define(ErrorCode_Border_War_Zf_Point, 170002). %% 征服点不足
-define(ErrorCode_Border_War_Ry_Point, 170003). %% 荣誉点不足
-define(ErrorCode_Border_War_Has_Award, 170004). %% 已领取奖励
-define(ErrorCode_Border_War_Close, 170005). %% 功能未开启
-define(ErrorCode_Border_War_Has_Buy, 170006). %% 已经购买了
-define(ErrorCode_Border_War_NoData, 170007).  %% 没有Boss数据
-define(ErrorCode_Border_War_Not_Weak, 170008).  %% 对方非弱服
-define(ErrorCode_Border_War_Local_Has_Union, 170009).  %% 本服已有同盟
-define(ErrorCode_Border_War_Remote_Has_Union, 170010).  %% 对方服务器已有同盟
-define(ErrorCode_Border_War_Has_Invite, 170011).  %% 已发起过结盟邀请
-define(ErrorCode_Border_War_Not_Invite, 170012).  %% 未在邀请结盟列表中
-define(ErrorCode_Border_War_Not_Permission, 170013).  %% 军衔等级不足
-define(ErrorCode_Border_War_Not_Coll, 170014).  %% 无法采集本服或同盟服的魔晶
-define(ErrorCode_Border_War_Coll_Max, 170015).  %% 魔晶采集次数达到上限
-define(ErrorCode_Border_War_ConveneCD, 170016).    %% 召集cd
-define(ErrorCode_Border_War_Not_Same_Group, 170017).    %% 对方服务器不在同一分组

%% 协助 171
-define(ErrorCode_Guild_Help_Map, 171001). %% 不在此地图中
-define(ErrorCode_Guild_Help_Already_Help, 171002). %% 在协助状态不可重复求助或协助
-define(ErrorCode_Guild_Help_Map_Ai, 171003). %% 此类型地图不能协助
-define(ErrorCode_Guild_Help_Out_Range, 171004). %% 不在该boss周围
-define(ErrorCode_Guild_Help_No_Guild, 171005). %% 未加入战盟
-define(ErrorCode_Guild_Help_No_Exist, 171006). %% 协助信息不存在
-define(ErrorCode_Guild_Help_Not_Same_Guild, 171007). %% 非同战盟，无法协助
-define(ErrorCode_Guild_Help_Same_Player, 171008). %% 不能接取自己的协助请求
-define(ErrorCode_Guild_Help_Action_Not_Open, 171009). %% 功能未开启
-define(ErrorCode_Guild_Help_No_Msg, 171010). %% 消息不存在或已过期
-define(ErrorCode_Guild_Help_No_Req, 171011). %% 没有进行中的协助
-define(ErrorCode_Guild_Help_CD, 171012). %% 请求频繁
-define(ErrorCode_Guild_Help_Score_Max, 171013). %% 今日协助积分已上限
-define(ErrorCode_Guild_Help_Already_Help_Req, 171014). %% 在求助状态不可重复求助或协助
-define(ErrorCode_Guild_Help_No_Object, 171015). %% 目标不存在
-define(ErrorCode_Guild_Help_Max_Fatigue, 171016). %% 疲劳值已满
-define(ErrorCode_Guild_Help_In_Team, 171017). %% 组队状态不可协助
-define(ErrorCode_Guild_Help_Has_Seek_Help, 171018). %% 已发起过协助

%% 商船 172
-define(ErrorCode_MerchantShip_Max_Lv, 172001). %% 已达到最高品质
-define(ErrorCode_MerchantShip_Max_Escort, 172002). %% 商船运输次数已达上限
-define(ErrorCode_MerchantShip_Max_intercept, 172003). %% 商船拦截次数已达上限
-define(ErrorCode_MerchantShip_Has_Ship, 172004). %% 已有正在进行中的护送
-define(ErrorCode_MerchantShip_No_Ship, 172005). %% 没有正在进行中的护送
-define(ErrorCode_MerchantShip_Ship_Running, 172006). %% 商船还未完成护送
-define(ErrorCode_MerchantShip_Ship_Plunder_Max, 172007). %% 该商船已达到掠夺次数上限
-define(ErrorCode_MerchantShip_Ship_No_Mirror, 172008).%% 没有对方镜像
-define(ErrorCode_MerchantShip_Ship_Error_Target, 172009).%% 目标错误
-define(ErrorCode_MerchantShip_Ship_No_Foray_Msg, 172010).%% 没有袭击信息
-define(ErrorCode_MerchantShip_Ship_Retake_All, 172011).%% 已夺回全部奖励
-define(ErrorCode_MerchantShip_Ship_In_Plunder, 172012).%% 正在掠夺中
-define(ErrorCode_MerchantShip_Ship_No_Guild, 172013).%% 未加入战盟
-define(ErrorCode_MerchantShip_Ship_Protect, 172014).%% 商船受到保护，无法被掠夺
-define(ErrorCode_MerchantShip_Ship_Protect_Event, 172015).%% 神赐祝福，止此兵戈。雅典娜护佑了这艘船，无法被拦截
-define(ErrorCode_MerchantShip_Ship_Time, 172016).%% 商船开启时间未到
-define(ErrorCode_MerchantShip_Ship_Target_No_Guild, 172017).%% 对方未加入战盟

%% 领地战 173
-define(ErrorCode_DomainFight_Enter_Not_Permission, 173001). %% 没有进入资格
-define(ErrorCode_DomainFight_Not_Start, 173002). %% 活动未开始
-define(ErrorCode_DomainFight_No_Release_Award, 173003). %% 没有可发放的奖励
-define(ErrorCode_DomainFight_Release_Award_Permission, 173004). %% 没有发放奖励资格
-define(ErrorCode_DomainFight_Cant_Chariot, 173005). %% 当前地图无法使用战车
-define(ErrorCode_DomainFight_Cant_Use, 173006). %% 没有使用权限
-define(ErrorCode_DomainFight_Use_Times, 173007). %% 使用达到上限次数
-define(ErrorCode_DomainFight_Venue_Close, 173008). %% 本赛区战斗已结束

%% 个人龙徽 174
-define(ErrorCode_Dragon_Badge_Not_Open, 174001).  %% 未开放
-define(ErrorCode_Dragon_Badge_No_Award, 174002).  %% 没有可领取奖励
-define(ErrorCode_Dragon_Badge_Cant_DailyAward, 174003).  %% 不符合领取每日奖励条件
-define(ErrorCode_Dragon_Badge_Has_Award, 174004).  %% 已领取过该奖励
-define(ErrorCode_Dragon_Badge_Exp_Over_Buy, 174005).  %% 超出今日可购买经验

%%  觉醒之路 175
-define(ErrorCode_Awaken_Road_No_Pass, 175001).    %% 主线尚未通关
-define(ErrorCode_Awaken_Road_Had_Reward, 175002).    %% 该奖励已经领取过
-define(ErrorCode_Awaken_Road_Canot_Reward, 175003).    %% 无法领取
-define(ErrorCode_Awaken_Road_BPAlreadyActive, 175004).    %% 该战令已被激活
-define(ErrorCode_Awaken_Road_CantActiveByCurrency, 175005).    %% 不可用该方式激活

%%  游戏助手 176
-define(ErrorCode_Game_Guidance_AlreadyGetReward, 176001).  %% 已经领取该奖励
-define(ErrorCode_Game_Guidance_NotComplete, 176002).  %% 条件未达成

%% 秘境试炼 177
-define(ErrorCode_Dungeon_Bp_Award_Null, 177001).  %% 没有可领取奖励
-define(ErrorCode_Dungeon_Bp_Advance_Curr, 177002).  %% 不支持货币进阶
-define(ErrorCode_Dungeon_Bp_Condition, 177003).  %% 进阶条件不满足
-define(ErrorCode_Dungeon_Bp_Has_Advance, 177004).  %% 已经进阶过了

%% 转生 178
-define(ErrorCode_Reincarnate_Exist, 178001).  %% 已存在转生任务
-define(ErrorCode_Reincarnate_Finish, 178002).  %% 已完成转生
-define(ErrorCode_Reincarnate_Max, 178003).  %% 已达到最大转生等级
-define(ErrorCode_Reincarnate_Need_Level, 178004).  %% 转生所需等级不足
-define(ErrorCode_Reincarnate_Not_Exist, 178005).  %% 未在转生流程中
-define(ErrorCode_Reincarnate_Point, 178006).  %% 转生点不足
-define(ErrorCode_Reincarnate_Suppress, 178007).  %% 压制CD中
-define(ErrorCode_Reincarnate_Suppress_Times, 178008).  %% 压制次数达到上限
-define(ErrorCode_Reincarnate_Suppress_MaxPer, 178009).  %% 压制效果达到上限
-define(ErrorCode_Reincarnate_Suppress_TargetHelpTimes, 178010).  %% 对方被协助压制次数达到上限
-define(ErrorCode_Reincarnate_Suppress_TargetMaxPer, 178011).  %% 对方压制效果达到上限
-define(ErrorCode_Reincarnate_TargetOffline, 178012).  %% 对方已离线

%% D3精英副本 179
-define(ErrorCode_Elite_Dungeon_No_Get, 179001).        %% 该奖励不可领取
-define(ErrorCode_Elite_Dungeon_Already_Get, 179002).    %% 该奖励已经领取
-define(ErrorCode_Elite_Dungeon_Star_Not_Enough, 179003).    %% 领取奖励所需星数不足
-define(ErrorCode_Elite_Dungeon_No_Enter, 179004).    %% 不满足挑战boss的条件
-define(ErrorCode_Elite_Dungeon_Is_Star_max, 179005).    %% 该副本已达成三星，不可再次挑战
-define(ErrorCode_Elite_Dungeon_Id_Wrong, 179006).    %% 奖励序号错误，无法领取
-define(ErrorCode_Elite_Dungeon_Map_Wrong, 179007).    %% 地图错误，无法进入
-define(ErrorCode_Elite_Dungeon_Open_Wrong, 179008).    %% 该章节未解锁
-define(ErrorCode_Elite_Dungeon_No_Reward, 179009).     %% 没有可领取奖励
-define(ErrorCode_Elite_Dungeon_Consume_Err, 179010).   %% 消耗错误

%% D3交易行 180
-define(ErrorCode_Trading_Market_Item_Amount, 180001). %% 物品数量不足
-define(ErrorCode_Trading_Market_Price_Change, 180002). %% 价格发生变动
-define(ErrorCode_Trading_Market_Item_Cant_Sell, 180003). %% 该物品无法出售
-define(ErrorCode_Trading_Market_Item_Not_Exist, 180004). %% 该商品不存在
-define(ErrorCode_Trading_Market_Gold_Take_Empty, 180005). %% 没有可提取的钻石
-define(ErrorCode_Trading_Market_Gold_Sell_Full, 180006). %% 可出售份数达到上限
-define(ErrorCode_Trading_Market_Gold_No_Take, 180007). %% 未提取已售出物品收益
-define(ErrorCode_Trading_Market_Gold_Null_Take, 180008). %% 没有可提取物品收益
-define(ErrorCode_Trading_Market_On_Shelve_Protect, 180009). %% 上架保护期间
-define(ErrorCode_Trading_Market_Has_Off_Shelve, 180010). %% 物品已经下架
-define(ErrorCode_Trading_Market_Shelve_Max, 180011). %% 可上架数量已满
-define(ErrorCode_Trading_Market_Trade_Type, 180012). %% 非物品归属对象

%% D3神饰 181
-define(ErrorCode_God_Ornament_Has_Active, 181001). %% 神饰已经激活
-define(ErrorCode_God_Ornament_Advance_Condition, 181002). %% 不满足进阶条件
-define(ErrorCode_God_Ornament_Not_Active, 181003). %% 神饰未激活
-define(ErrorCode_God_Ornament_Cant_Ex_Advance, 181004). %% 卓越进阶条件不满足
-define(ErrorCode_God_Ornament_Max_Excellence_Active, 181005). %% 卓越激活已满
-define(ErrorCode_God_Ornament_Max_Excellence_Advance, 181006). %% 卓越进阶已满

%% D3资源找回 182
-define(ErrorCode_Retrieve_Num, 182001). %% 找回次数不足

%% D3时装 183
-define(ErrorCode_Dress_Up_FashionAlreadyActive, 183001). %% 已经激活
-define(ErrorCode_Dress_Up_FashionNoActive, 183002). %% 尚未激活
-define(ErrorCode_Dress_Up_FashionAlmostThisColor, 183003). %% 已为该颜色
-define(ErrorCode_Dress_Up_TopicNotEquip, 183004). %% 尚未穿戴该主题
-define(ErrorCode_Dress_Up_AppearanceAlready, 183005). %% 已为该外观
-define(ErrorCode_Dress_Up_WrongDyeingLayer, 183006). %% 不可在此染色
-define(ErrorCode_Dress_Up_NeedEternalFashion, 183007). %% 需要永久时装

%% 等级封印 184
-define(ErrorCode_ServerSeal_Contest_Award, 184001). %% 领取条件不满足
-define(ErrorCode_ServerSeal_Contest_Got, 184002). %% 已经领取过该奖励

%% 嘉年华 185
-define(ErrorCode_Carnival_Close, 185001). %% 嘉年华已结束
-define(ErrorCode_Carnival_No_Buy_Item, 185002). %% 商品不存在
-define(ErrorCode_Carnival_Buy_Condition, 185003). %% 商品购买条件不满足
-define(ErrorCode_Carnival_Buy_Way, 185004). %% 不支持改购买方式
-define(ErrorCode_Carnival_NoAward, 185005). %% 没有可领取的奖励

%% D3法阵符文 186
-define(ErrorCode_Fazhen_NotExist, 186001). %% 法阵不存在
-define(ErrorCode_FazhenRune_NotExist, 186002). %% 符文不存在
-define(ErrorCode_Fazhen_ReinLv_NotEnough, 186003). %% 转生等级不足，部位未开启
-define(ErrorCode_Fazhen_Pos_Err, 186004). %% 装备位置错误
-define(ErrorCode_No_Pos_Fazhen, 186005). %% 装备没有法阵
-define(ErrorCode_Fazhen_Is_Equip, 186006). %% 法阵正在装备中不能分解
-define(ErrorCode_Fazhen_Not_Equip, 186007). %% 法阵未装备，不能升星，不能镶嵌符文
-define(ErrorCode_Fazhen_MaxStar, 186008). %% 法阵已经达到最大星级
-define(ErrorCode_FazhenRune_Pos_NotExist, 186009). %% 符文装配法阵不存在
-define(ErrorCode_FazhenRune_Pos_Repeat, 186010). %% 符文重复装配
-define(ErrorCode_FazhenRune_MaxStar, 186011). %% 符文已经达到最大星级
-define(ErrorCode_FazhenRune_MaxLv, 186012). %% 符文已经达到最大等级
-define(ErrorCode_FazhenRune_Type, 186013). %% 符文装配的类型不匹配
-define(ErrorCode_FazhenRune_Over_Type, 186014). %% 符文装配的位置超出了配置长度界限
-define(ErrorCode_FazhenRune_Is_Equip, 186015). %% 符文已装配，不能分解
-define(ErrorCode_FazhenRune_Not_Equip, 186016). %% 符文为装备，不能升级升星
-define(ErrorCode_Fazhen_Eq_Repeat, 186017). %% 法阵重复装备
-define(ErrorCode_FazhenRune_AddLv_Consume_NotEnough, 186018). %% 符文升级消耗不足
-define(ErrorCode_FazhenRune_ToLv_Less_Lv, 186019). %% 符文升级目标等级小于当前等级
-define(ErrorCode_Fazhen_AddStar_Consume_NotEnough, 186020). %% 法阵升星消耗不足
-define(ErrorCode_FazhenRune_AddStar_Consume_NotEnough, 186021). %% 符文升星消耗不足
-define(ErrorCode_Fazhen_Breakdown_Type, 186022). %% 符文法阵分解类型错误
-define(ErrorCode_Fazhen_Not_In_Bag, 186023). %% 法阵不在背包中不能分解
-define(ErrorCode_FazhenRune_Not_In_Bag, 186024). %% 符文不在背包中不能分解
-define(ErrorCode_FazhenRune_Coin_UnEnough, 186025). %% 符文经验不足
-define(ErrorCode_Fazhen_EqPos_Repeat, 186026). %% 前端输入的法阵位置相同，重复装配
-define(ErrorCode_FazhenRune_Synthetic_Over_Equip, 186027). %% 合成的符文不能有超过一个装备在身上

-define(ErrorCode_Fazhen_Score_NotEnough, 186028). %% 符文评分不足，部位未开启
-define(ErrorCode_FaZhenPosIslock, 186029).    %%法阵位置已解锁 (位置解锁时)
-define(ErrorCode_FaZhenPosUnlock, 186030).    %%法阵位置未解锁 (法阵打造时)
-define(ErrorCode_RuneIslock, 186031).    %%符文已锁定，不可进行分解或拆解
%% 职业塔 187
-define(ErrorCode_Career_Tower_Dungeon_Map_Wrong, 187001).    %% 地图错误，无法进入
-define(ErrorCode_Career_Tower_Dungeon_No_Enter, 187002).    %% 不满足挑战boss的条件
-define(ErrorCode_Career_Tower_UnlockConditionNotMet, 187003).    %% 未满足解锁条件
-define(ErrorCode_Career_Tower_NotOpenTime, 187004).    %% 当前不在开放时间
-define(ErrorCode_Career_Tower_AlmostMaxLayer, 187005).    %% 已到最大层数
-define(ErrorCode_Career_Tower_CantMop, 187006).    %% 不可秒杀
-define(ErrorCode_Career_Tower_OnlyNextLayer, 187007).    %% 只可挑战下一层
-define(ErrorCode_Career_Tower_NoMopLayer, 187008).    %% 没有可以秒杀的层数
-define(ErrorCode_Career_Tower_AlreadyNowPet, 187009).    %% 已为当前出战英雄
-define(ErrorCode_Career_Tower_NoCanGetReward, 187010).    %% 没有可领取的奖励
-define(ErrorCode_Career_Tower_NoCareerRole, 187011).    %% 未拥有该职业角色
-define(ErrorCode_Career_Tower_Not_Minor_BattleValue, 187012).    %% 不是副塔，不能取角色战力
-define(ErrorCode_Career_Tower_NotKill, 187013).    %% 没有首通玩家
-define(ErrorCode_Career_Tower_RepeatFirstReward, 187014).    %% 重复领取首通奖励
-define(ErrorCode_Career_Tower_RewardEmpty, 187015).    %% 首通奖励为空


%% 猎魔
-define(ERROR_CONSTELL_SCORE_CONDITION, 188001). %% 星魂评分不满足条件
-define(ERROR_CONSTELL_PHY_NOT_ENOUGH, 188002). %% 体力不足
-define(ERROR_EXPEDITION_NO_BOSS, 188003). %% 该BOSS暂不可挑战
-define(ERROR_EXPEDITION_NOT_ENERGY_HUNT_LV, 188004). %% 猎魔等级不足
-define(ERROR_EXPEDITION_NO_TIME, 188005). %% 次数不足
-define(ERROR_EXPEDITION_HUNT_BOSS_HAD_AWARD, 188006). %% 已经领奖
-define(ERROR_EXPEDITION_HUNT_BOSS_NO_AWARD, 188007). %% 没有可领取奖励
-define(ERROR_EXPEDITION_CONDITION_NOT_MATCH, 188008). %% 条件不满足

%% 功勋
-define(ERROR_GIVE_MORE_THAN_HAVE, 189001). %% 奖励数量不足
-define(ERROR_REACH_MAX_NOBILITY, 189002). %% 已达到最大爵位
-define(ERROR_NOBILITY_NOT_ENOUGH, 189003). %% 功勋不足
-define(ERROR_NOT_IN_GET_TIME, 189004). %% 未到领取时间
-define(ERROR_YOU_ARE_NO_REWARD, 189005). %% 您没有被分配奖励
-define(ERROR_YOU_ALREADY_GOT, 189006). %% 您已经领取过
-define(ERROR_TEAM_NO_REWARD, 189007). %% 您的小队没有积分奖励
-define(ERROR_FORCE_TIME_LIMIT, 189008). %% 强征次数已用完

%% 远征战斗
-define(ERROR_SAME_CAMP, 190001). %% 不能对同阵营玩家发起挑战
-define(ERROR_IN_BATTLE, 190002). %% 对方处于战斗中


%% 远征 191
-define(ERROR_EXPEDITION_NO_CAMP, 191001). %% 尚未加入阵营
-define(ERROR_EXPEDITION_NO_AREA, 191002). %% 城池错误
-define(ERROR_EXPEDITION_NO_PUBLISH, 191003). %% 无法发布该小队任务
-define(ERROR_EXPEDITION_NO_MODIFY, 191004). %% 无法修改小队任务
-define(ERROR_EXPEDITION_NO_RECEIVE, 191005). %% 无法接取小队任务
-define(ERROR_EXPEDITION_NO_TEAM_SCORE, 191006). %% 队伍积分不足
-define(ERROR_EXPEDITION_FULL_ENERGY, 191007). %% 能量已达上限
-define(ERROR_EXPEDITION_NO_BUY_ENERGY, 191008). %% 购买能量次数超过上限
-define(ERROR_EXPEDITION_NO_ENTER, 191009). %% 无法进入
-define(ERROR_EXPEDITION_NO_FIGHT, 191010). %% 无法挑战
-define(ERROR_EXPEDITION_SAME_CAMP, 191011). %% 同阵营无法发起挑战
-define(ERROR_EXPEDITION_HAD_FIGHT, 191012). %% 该玩家正处于挑战中
-define(ERROR_EXPEDITION_NO_IN_AREA, 191013). %% 不在城池中
-define(ERROR_EXPEDITION_NO_AWARD, 191014). %% 没有奖励可领取
-define(ERROR_EXPEDITION_HAD_AWARD, 191015). %% 奖励已经领取
-define(ERROR_EXPEDITION_HAD_CAMP, 191016). %% 已经加入阵营
-define(ERROR_EXPEDITION_NO_START, 191017). %% 活动尚未开启
-define(ERROR_EXPEDITION_NO_ENERGY, 191018). %% 未携带能量不可移动
-define(ERROR_EXPEDITION_HAD_ENERGY, 191019). %% 未在主城不可携带能量
-define(ERROR_EXPEDITION_WRONG_ROAD, 191020). %% 移动路线错误
-define(ERROR_EXPEDITION_HAD_MOVE, 191021).    %% 正在移动，无法修改移动目标
-define(ERROR_EXPEDITION_WRONG_ENERGY, 191022).    %% 携带能量数错误
-define(ERROR_EXPEDITION_NOT_ENOUGH_ENERGY, 191023).    %% 能量不足
-define(ERROR_EXPEDITION_FULL_GROUP, 191024).    %% 远征小队已满，无法加入
-define(ERROR_EXPEDITION_WRONG_TIME, 191025).    %% 未到争夺时间
-define(ERROR_EXPEDITION_WRONG_ENTER, 191026).    %% 不可重复进入
-define(ERROR_EXPEDITION_WRONG_PUBLISH1, 191027).    %% 职位不符合发布要求
-define(ERROR_EXPEDITION_WRONG_PUBLISH3, 191028).    %% 任务类型不符合发布要求
-define(ERROR_EXPEDITION_WRONG_PUBLISH4, 191029).    %% 任务城池不符合发布要求
-define(ERROR_EXPEDITION_WRONG_MODIFY1, 191030).    %% 新任务不可与旧任务相同
-define(ERROR_EXPEDITION_WRONG_MODIFY2, 191031).    %% 新任务类型不符合修改要求
-define(ERROR_EXPEDITION_WRONG_MODIFY4, 191032).    %% 新任务城池不符合修改要求
-define(ERROR_EXPEDITION_WRONG_MODIFY5, 191033).    %% 职位不符合修改要求
-define(ERROR_EXPEDITION_WRONG_DISTANCE, 191034).    %% 超出挑战范围
-define(ERROR_EXPEDITION_WRONG_GATHER1, 191035).    %% 职位不符合集结要求
-define(ERROR_EXPEDITION_WRONG_GATHER2, 191036).    %% 已有集结目标，不可再次集结
-define(ERROR_EXPEDITION_WRONG_GATHER3, 191037).    %% 集结功能CD中
-define(ERROR_EXPEDITION_WRONG_GATHER4, 191038).    %% 该城池不可集结
-define(ERROR_EXPEDITION_WRONG_GATHER5, 191039).    %% 未到集结时间
-define(ERROR_EXPEDITION_EXPLORE_WRONG1, 191040).    %% 该城池不可探索
-define(ERROR_EXPEDITION_EXPLORE_WRONG2, 191041).    %% 没有探险次数
-define(ERROR_EXPEDITION_EXPLORE_WRONG3, 191042).    %% 探险宝箱累计次数已满
-define(ERROR_EXPEDITION_EXPLORE_WRONG4, 191043).    %% 已有人占领，不可直接占领
-define(ERROR_EXPEDITION_EXPLORE_WRONG5, 191044).    %% 尚未占领该探险点
-define(ERROR_EXPEDITION_EXPLORE_WRONG6, 191045).    %% 尚未玩家占领，不可攻占
-define(ERROR_EXPEDITION_EXPLORE_WRONG7, 191046).    %% 已被你占领，不可重复攻占
-define(ERROR_EXPEDITION_EXPLORE_WRONG8, 191047).    %% 未到保护时间，不可攻占
-define(ERROR_EXPEDITION_EXPLORE_WRONG9, 191048).    %% 没有驱逐体力，无法攻占
-define(ERROR_EXPEDITION_EXPLORE_WRONG10, 191049).    %% 该城池处于争夺中，请稍后再试
-define(ERROR_EXPEDITION_MAP_WRONG, 191050).        %% 处于其他玩法中，无法进入
-define(ERROR_EXPEDITION_PROTECT_TIME, 191051).        %% 处于保护时间，无法挑战
-define(ERROR_EXPEDITION_FIGHT_FRIEND, 191052).        %% 盟友状态，无法挑战
-define(ERROR_EXPEDITION_AIRSHIP_SEND1, 191053).        %% 非本阵营飞艇，无法传送
-define(ERROR_EXPEDITION_AIRSHIP_SEND2, 191054).        %% 浮空岛坐标已丢失，无法传送
-define(ERROR_EXPEDITION_AIRSHIP_SEND3, 191055).        %% 传送人数已经达到上限，无法传送
-define(ERROR_EXPEDITION_AIRSHIP_SEND4, 191056).        %% 传送次数不足，无法传送
-define(ERROR_EXPEDITION_AIRSHIP_SEND5, 191057).        %% 当前城池不可乘坐飞艇
-define(ERROR_EXPEDITION_WRONG_PUBLISH5, 191058).    %% 不可发布突袭城池任务
-define(ERROR_EXPEDITION_WRONG_MODIFY6, 191059).    %% 不可修改突袭城池任务
-define(ERROR_EXPEDITION_WRONG_GATHER6, 191060).    %% 突袭城池不可集结
-define(ERROR_EXPEDITION_NO_SHIP, 191061).            %% 暂未定位到浮空岛位置，不可查看
-define(ERROR_EXPEDITION_NO_ENTER2, 191062).            %% 浮空岛已沦陷，不可进入
-define(ErrorCode_SYSTEM_ERROR, 191063).          %% 系统错误


%% 远征图鉴
-define(ERROR_expedition_card_had_active, 192001).   %% 该卡片已经激活
-define(ERROR_expedition_card_no_card, 192002).   %% 该类别暂无激活卡片，无法升阶
-define(ERROR_expedition_card_not_enough_card, 192003).   %% 激活卡片数量不足
-define(ERROR_expedition_card_fetter_max_level, 192004).   %% 已达到最大阶级
-define(ERROR_expedition_card_suit_max_level, 192005).   %% 已达到最大等级
-define(ERROR_expedition_card_not_enough_level, 192006).   %% 吞噬等级不足
-define(ERROR_expedition_card_swallow_max_level, 192007).   %% 已达到最大等级
-define(ERROR_expedition_card_swallow_wrong_type, 192008).   %% 吞噬卡片类别错误

%% 远征-巨魔降临 193
-define(ERROR_ExpeditionDemonCome_Wrong_Time, 193001). %% 活动未开始或已结束
-define(ERROR_ExpeditionDemonCome_Already_Killed, 193002). %% boss已经被击杀

%% 蓝钻祈福
-define(ErrorCode_GreenBless_NoAward, 194001). %% 没有可领取的奖励
-define(ErrorCode_GreenBless_NoFree, 194002). %% 今日免费占卜次数耗尽

%% 公会副本 195
-define(ErrorCode_GuildInsZones_NoPermission, 195001). %% 权限不足
-define(ErrorCode_GuildInsZones_Enter, 195002). %% 进入次数不足
-define(ErrorCode_GuildInsZones_Pass, 195003). %% 该关卡已通关
-define(ErrorCode_GuildInsZones_HasAward, 195004). %% 已领取该奖励
-define(ErrorCode_GuildInsZones_NoAward, 195005). %% 没有可领取的奖励
-define(ErrorCode_GuildInsZones_NotOpen, 195006). %% 该关卡未开启
-define(ErrorCode_GuildInsZones_Mark, 195007). %% 该关卡不能被标记
-define(ErrorCode_GuildInsZones_ItemUse, 195008). %% 可使用数量不足

%% 宠物上阵 196
-define(ErrorCode_PetPosIsExist, 196001). %% 已经激活位置
-define(ErrorCode_PetPosLock, 196002). %% 上阵位未解锁
-define(ErrorCode_PetPosNotExist, 196003). %% 未上阵宠物
-define(ErrorCode_PetPosOn, 196004). %% 宠物已经上阵在别的位置
-define(ErrorCode_PetAutoSkill, 196005). %% 自动激活参数错误
-define(ErrorCode_PetAutoSkillAlreadyOn, 196006). %% 已经自动释放
-define(ErrorCode_PetAutoSkillAlreadyOff, 196007). %% 已取消自动释放
-define(ErrorCode_PetMasterPos, 196008). %% 已经激活位置
-define(ErrorCode_PetMasterCondition, 196009). %% 激活大师条件不足
-define(ErrorCode_PetMasterConditionAtlas, 196010). %% 宠物对应品质图鉴数量不足
-define(ErrorCode_PetMasterConditionStar, 196011). %% 上阵宠物对应星级数量不足
-define(ErrorCode_PetNotExist, 196012). %% 宠物不存在
-define(ErrorCode_PetPosOn_Linked, 196013). %% 宠物链接的幻兽上阵中
-define(ErrorCode_PetPosOn_Linked2, 196014). %% 幻兽链接的宠物上阵中
-define(ErrorCode_PetPosActive_PlayerLv, 196015). %% 玩家等级不足
-define(ErrorCode_PetPosActive_Rein, 196016). %% 转职等级不足
-define(ErrorCode_PetPosActive_VIP, 196017). %% VIP等级不足
-define(ErrorCode_PetPosActive_PetTower, 196018). %% 宠物塔通关层数不足
-define(ErrorCode_PetPosRepeat, 196019). %% 上阵位置重复
-define(ErrorCode_PetPosDefExist, 196020). %% 防守位置已经有宠物
-define(ErrorCode_PetPosSpType, 196021). %% 特殊SP英雄不可出战
-define(ErrorCode_PetPosActive_PetRareNum, 196022). %% 所需英雄类型数量不足

%% 宠物基础(升级、洗髓、突破、回退)
-define(ErrorCode_Pet_TouchMaxLv, 197001). %% 已达最大等级
-define(ErrorCode_Pet_NOT_MATCH, 197002). %% 条件不满足
-define(ErrorCode_Pet_NOT_Orig, 197003). %% 目标已进行过养成
-define(ErrorCode_Pet_NoCultivation, 197004). %% 没有可转移的养成
-define(ErrorCode_Pet_OnShengShu, 197005). %% 目标已入驻圣树
-define(ErrorCode_Pet_SoulCultivation, 197006). %% 神灵宠物不可被继承
-define(ErrorCode_Pet_SoulCultivationReplace1, 197007). %% 神灵英雄无法被无损替换
-define(ErrorCode_Pet_SoulCultivationReplace2, 197008). %% 神灵英雄无法无损替换
-define(ErrorCode_Pet_CultivationReplaceLv, 197009). %% 无法将低等级养成属性替换到高等级英雄上
-define(ErrorCode_Pet_CultivationReplaceLvUpperLimit, 197010). %% 该英雄养成等级太高无法进行无损替换

-define(StateMatching, 140004).%%正在匹配中
-define(StateBeenInvited, 140005).%%已经接受邀请

%% 宠物装备、升星 198
-define(ErrorCode_PetEqAndStar_CostPetNo, 198001). %% 放入的消耗宠物不存在
-define(ErrorCode_PetEqAndStar_CostPetBadFightFlag, 198002). %% 放入的消耗宠物处于助战中或出战中
-define(ErrorCode_PetEqAndStar_CostPetBadCondition, 198003). %% 放入的消耗宠物不满足条件
-define(ErrorCode_PetEqAndStar_CostPetRepeat, 198004). %% 放入的宠物存在重复
-define(ErrorCode_PetEqAndStar_CostBad, 198005). %% 升星消耗不足
-define(ErrorCode_PetEqAndStar_CostPetEquip, 198006). %% 作为升星材料的宠物身上不能有装备
-define(ErrorCode_PetEqAndStar_CostPetLocked, 198007). %% 放入的消耗宠物处于锁定状态不能用于升星
-define(ErrorCode_PetEqAndStar_NoEq, 198008). %% 宠物装备不存在
-define(ErrorCode_PetEqAndStar_NoEqResetSKillList, 198009). %% 不存在待保存的技能
-define(ErrorCode_PetEqAndStar_CannotReset, 198010). %% 该宠物装备不能重置
-define(ErrorCode_PetEqAndStar_NoPos, 198011). %% 该孔位未开启
-define(ErrorCode_PetEqAndStar_NoPosEq, 198012). %% 该孔位未装配装备
-define(ErrorCode_PetEqAndStar_GetByEgg, 198013). %% 通过孵化获得的宠物不能用于升星
-define(ErrorCode_PetEqAndStar_CostPetSoul, 198014). %% 幻兽不能作为消耗宠物
-define(ErrorCode_PetEqAndStar_CostPetLinked, 198015). %% 被链接的宠物不能用于消耗
-define(ErrorCode_PetEqAndStar_CostPetBeenAppendage, 198016). %% 被附灵的宠物不能用于消耗
-define(ErrorCode_PetEqAndStar_CostPetStarCost, 198017). %% 该宠物不可用于升星消耗
-define(ErrorCode_PetEqAndStar_PosHaveLight, 198018). %% 已经点亮星位
-define(ErrorCode_PetEqAndStar_StarNoCondition, 198019).    %%未达到可晋升星级，无法晋升
-define(ErrorCode_PetEqAndStar_NeedPromotion, 198020).    %%已达到星级上限，请先进行英雄晋升
-define(ErrorCode_PetEqAndStar_NotPromotion, 198021).    %%该英雄无法晋升
-define(ErrorCode_PetEqAndStar_CostPetFightFlag, 198022). %% 放入的消耗宠物处于出战中
%% 幻兽
-define(ErrorCode_PetSoul_Linked, 199001). %% 宠物或幻兽链接中
-define(ErrorCode_PetSoul_Appendage, 199002). %% 宠物或幻兽附灵中
-define(ErrorCode_PetSoul_StarNotEnough, 199003). %% 链接宠物星级不足
-define(ErrorCode_PetSoul_Fight, 199004). %% 神灵出阵中无法附灵
-define(ErrorCode_PetSoul_CanNotAppendageSelf, 199005). %% 不能附灵自己
-define(ErrorCode_PetSoul_FightCantLink, 199006). %% 神灵出阵中无法链接
%% 宠物置换
-define(ErrorCode_PetSubstitute_StarAndGrade, 200001). %% 被用来置换的宠物星级和品质不满足
-define(ErrorCode_PetSubstitute_Culture, 200002). %% 宠物被培养过
-define(ErrorCode_PetSubstitute_Fight, 200003). %% 宠物出战或助战中
-define(ErrorCode_PetSubstitute_Eq, 200004). %% 宠物佩戴有装备
-define(ErrorCode_PetSubstitute_BreakLv, 200005). %% 宠物突破过
-define(ErrorCode_PetSubstitute_CostPet, 200006). %% 消耗宠物不满足条件
-define(ErrorCode_PetSubstitute_TargetPet, 200007). %% 目标宠物不在可置换列表里
-define(ErrorCode_PetSubstitute_PetNotSubstitute, 200008). %% 宠物不在可置换列表中
-define(ErrorCode_PetSubstitute_Self, 200009). %% 不可置换自己
-define(ErrorCode_PetSubstitute_NotExist, 200010). %% 宠物不存在
-define(ErrorCode_PetSubstitute_NotInit, 200011). %% 培养过的宠物不可消耗
-define(ErrorCode_PetSubstitute_PetCfg, 200012). %% 置换宠物配置错误
-define(ErrorCode_PetSubstitute_CostCfg, 200013). %% 置换消耗配置错误

%% 宠物抽奖 201
-define(ErrorCode_PetDrawCantFree, 201000). %% 不允许免费抽
-define(ErrorCode_PetDrawFreeTime, 201001). %% 未到宠物抽奖时间
-define(ErrorCode_PetDrawTime, 201002). %% 今日抽奖次数耗尽
-define(ErrorCode_PetDrawTimeMinus, 201003). %% 抽奖参数错误
-define(ErrorCode_PetDrawElementType, 201004). %% 宠物元素类型不对应
-define(ErrorCode_PetDrawWishRepeat, 201005). %% 宠物重复选择
-define(ErrorCode_PetDrawWishForbidden, 201006). %% 不允许开启心愿单
-define(ErrorCode_PetDrawWishTime, 201007). %% 次数不满足开启心愿单
-define(ErrorCode_PetDrawElementCantSwitch, 201008). %% 不可切换元素
-define(ErrorCode_PetDrawEmpty, 201009). %% 没有抽到任何东西
-define(ErrorCode_PetDrawCost, 201010). %% 抽奖消耗不足
-define(ErrorCode_PetDrawCostTime, 201011). %% 没有对应的抽奖次数配置
-define(ErrorCode_PetDrawNoAward, 201012). %% 没有奖励
-define(ErrorCode_PetDrawScoreReward, 201013). %% 不可积分领奖
-define(ErrorCode_PetDrawWishSSR, 201014). %% 心愿单必须为SSR
-define(ErrorCode_PetDrawWishRepeatType, 201015). %% 心愿单类型重复

%% 孵蛋流程 202
-define(ErrorCode_PetHatch_EggIsExist, 202000). %% 孵化的蛋已存在
-define(ErrorCode_PetHatch_EggIsNotExist, 202001). %% 孵化的蛋不已存在
-define(ErrorCode_PetHatch_HatchComplete, 202002). %% 孵化已完成
-define(ErrorCode_PetHatch_PetIsLooking, 202003). %% 宠物正在照看
-define(ErrorCode_PetHatch_PetCanNotAccelerate, 202004). %% 宠物不可加速
-define(ErrorCode_PetHatch_AcOn, 202005). %% 龙晶已经点亮过
-define(ErrorCode_PetHatch_ActiveVal, 202006). %% 活跃度不足
-define(ErrorCode_PetHatch_QTE, 202007). %% 没有对应QTE类型
-define(ErrorCode_PetHatch_ActiveRewardEmpty, 202008). %% 没有可领取的龙晶奖励
-define(ErrorCode_PetHatch_NotEnd, 202009). %% 孵化未完成

%% 翅膀副本 203
-define(ErrorCode_DungeonWing_Lv, 203001). %% 玩家等级不足
-define(ErrorCode_DungeonWing_WrongArea3, 203002). %% 该副本已经完成挑战
-define(ErrorCode_DungeonWing_Energy, 203003). %% 体力消耗不足
-define(ErrorCode_DungeonWing_NoShop, 203004). %% 商店暂未开启
-define(ErrorCode_DungeonWing_ShopBuyMax, 203005). %% 该商品购买已达到上限
-define(ErrorCode_SalesActive_DungeonWing_TypeWrong, 203006).  %% 翅膀副本商店购买类型错误
-define(ErrorCode_DungeonWing_WrongArea1, 203007). %% 请先完成已开启的副本
-define(ErrorCode_DungeonWing_WrongArea2, 203008). %% 该副本暂无法挑战
-define(ErrorCode_DungeonWing_WrongArea4, 203009). %% 上层关卡未通关
-define(ErrorCode_DungeonWing_WrongAreaCfg, 203010). %% 翅膀副本坐标配置规则长度
-define(ErrorCode_DungeonWing_NotComplete, 203011). %% 未通关副本
-define(ErrorCode_DungeonWing_WrongRoute, 203012).  %% 路线错误
-define(ErrorCode_DungeonWing_ExitMapFirst, 203013).    %% 请先退出地图

%% 宠物圣树 204
-define(ErrorCode_PetShengShu_UnlockDisorder, 204001). %% 未按顺序解锁栏位
-define(ErrorCode_PetShengShu_UnlockRepeat, 204002). %% 重复解锁栏位
-define(ErrorCode_PetShengShu_PetTower, 204003). %% 解锁栏位条件不满足，宠物塔层数不够
-define(ErrorCode_PetShengShu_VIP, 204004). %% 解锁栏位条件不满足，玩家vip等级不够
-define(ErrorCode_PetShengShu_LockedPos, 204005). %% 栏位未解锁
-define(ErrorCode_PetShengShu_NoCD, 204006). %% 栏位无cd，无需重置cd
-define(ErrorCode_PetShengShu_EnteredState, 204007). %% 栏位已入驻，无需重置cd
-define(ErrorCode_PetShengShu_InCD, 204008). %% 入驻栏位有cd，无法入驻
-define(ErrorCode_PetShengShu_OtherPetEntered, 204009). %% 其他宠物已经入驻该栏位
-define(ErrorCode_PetShengShu_GodPetEnter, 204010). %% 神灵宠物不可入驻
-define(ErrorCode_PetShengShu_GuardPetEnter, 204011). %% 圣树守卫不可入驻
-define(ErrorCode_PetShengShu_ForbidUpdate, 204012). %% 入驻圣树不可升级和洗髓
-define(ErrorCode_PetShengShu_PetEnteredOther, 204013). %% 宠物已入驻其他栏位
-define(ErrorCode_PetShengShu_GuardState, 204014). %% 圣树状态错误
-define(ErrorCode_PetShengShu_PosLvMax, 204015). %% 入驻位等级达到最大

%% 周活跃通行证 205
-define(ErrorCode_WeekActive_NotEnough, 205001). %% 活跃值不够
-define(ErrorCode_WeekActive_NoReward, 205002). %% 没有可领的奖励
-define(ErrorCode_WeekActive_NoRewardCfg, 205003). %% 没有可领的奖励配置
-define(ErrorCode_WeekActive_RepeatBuy, 205004). %% 重复购买通行证

%% 英雄装备 206
-define(ErrorCode_Bless_Eq_NotExist, 206001).             %% 英雄装备不存在
-define(ErrorCode_Bless_Eq_WearCondition, 206002).        %% 穿戴条件不满足%%暂时未使用
-define(ErrorCode_Bless_Eq_NotWear, 206003).              %% 没有穿戴装备
-define(ErrorCode_Bless_Eq_CastInfoExist, 206004).        %% 有未处理的祝福信息%%%%暂时未使用
-define(ErrorCode_Bless_Eq_CastInfoNotExist, 206005).     %% 没有未处理的祝福信息%%暂时未使用
-define(ErrorCode_Bless_Eq_StageNotUnLock, 206006).       %% 阶段未解锁
-define(ErrorCode_Bless_Eq_BattleNotUnLock, 206007).       %% 出战位未解锁
-define(ErrorCode_Bless_Eq_OneKeyOp0NoWear, 206008).       %% 一键穿戴没有成功
-define(ErrorCode_Bless_Eq_OneKeyOp1NoWear, 206009).       %% 一键卸下没有成功
-define(ErrorCode_Bless_Eq_BlessEq, 206010).       %% 该英雄装备已穿戴%%暂时未使用

%% 英雄国度 207
-define(ErrorCode_PetCity_BuildLvMax, 207001). %% 建筑已最大等级
-define(ErrorCode_PetCity_BuildLvCondition, 207002). %% 建筑升级条件不足
-define(ErrorCode_PetCity_BuildLvCost, 207003). %% 建筑升级消耗货币不足
-define(ErrorCode_PetCity_BuildLvNoNeedUp, 207004). %% 建筑不需要加速升级
-define(ErrorCode_PetCity_ResearchExist, 207005). %% 现在有正在进行的研究
-define(ErrorCode_PetCity_PetWorkingOtherBuild, 207006). %% 英雄正在别的建筑工作
-define(ErrorCode_PetCity_BuildIsNowLevelUp, 207007). %% 建筑正在升级
-define(ErrorCode_PetCity_ResearchCondition, 207008). %% 研究升级条件不满足
-define(ErrorCode_PetCity_OldCall, 207009). %% 已在召唤英雄
-define(ErrorCode_PetCity_CallTime, 207010). %% 召唤英雄还未结束
-define(ErrorCode_PetCity_CoinEmpty, 207011). %% 没有家园币可领取
-define(ErrorCode_PetCity_PetRepeat, 207012). %% 所选英雄已选中
-define(ErrorCode_PetCity_PetEquipNoMaking, 207013). %% 没有正在打造的装备
-define(ErrorCode_PetCity_PetEquipMaking, 207014). %% 英雄正在打造装备
-define(ErrorCode_PetCity_PetStarLow, 207015). %% 所选英雄星级太低
-define(ErrorCode_PetCity_PetEquipTime, 207016). %% 装备打造未结束
-define(ErrorCode_PetCity_RepeatPray, 207017). %% 不可重复祈愿
-define(ErrorCode_PetCity_NoPray, 207018). %% 没有对应位置的祈福信息
-define(ErrorCode_PetCity_PrayPos, 207019). %% 祈愿位置不足
-define(ErrorCode_PetCity_PrayTime, 207020). %% 祈愿未到领取时间
-define(ErrorCode_PetCity_CallPerCfg, 207021). %% 没有对应的建筑等级配置概率
-define(ErrorCode_PetCity_TaskType, 207022). %% 没有对应的任务类型配置
-define(ErrorCode_PetCity_TaskNotComplete, 207023). %% 任务未完成
-define(ErrorCode_PetCity_PrayNoReward, 207024). %% 没有可领取的祈愿奖励
-define(ErrorCode_PetCity_TaskIsComplete, 207025). %% 任务已完成
-define(ErrorCode_PetCity_ResearchMaxLv, 207026). %% 该研究已达到最大等级

-define(ErrorCode_PetCity_NoResearchExist, 207027). %% 没有正在进行的研究
-define(ErrorCode_PetCity_ResearchComplete, 207028). %% 研究未完成,无法领取

-define(ErrorCode_PetCity_PrayComplete, 207029).%% 祈愿已完成，无法加速
%%自选直购  209

-define(ErrorCode_SelectGoods_LvLimit, 20901).      %%等级不足
-define(ErrorCode_SelectGoods_Param, 20902).        %%礼包还有可选的道具
-define(ErrorCode_SelectGoods_Surpass_Max, 20903).  %%选择物品过多
-define(ErrorCode_SelectGoods_Repeat, 20904).       %%存在重复的道具组
-define(ErrorCode_SelectGoods_OneBuy, 20905).       %%该道具已购买，无法再选择
-define(ErrorCode_SelectGoods_NoGift, 20906).       %%不存在该礼包
-define(ErrorCode_SelectGoods_NoItem, 20907).       %%请选择道具
-define(ErrorCode_SelectGoods_NoBuy, 20908).        %%未达到购买条件
-define(ErrorCode_SelectGoods_NoTimes, 20909).      %%礼包购买次数不足

%% 通用功能BP
-define(ErrorCode_CommonBp_OPen, 21001).      %% 未开启
-define(ErrorCode_CommonBp_NoAward, 21002).      %% 没有可领取奖励
-define(ErrorCode_CommonBp_DuplicateBuy, 21003).  %% 重复购买
-define(ErrorCode_CommonBp_LowPlayerLv, 21004). %% 玩家等级不足
-define(ErrorCode_CommonBp_LowScoreLv, 21005).  %% 积分等级不足

%% 211 广告码兑换
-define(ErrorCode_AdCode_Exchange_Repeat, 21101).      %% 重复兑换
-define(ErrorCode_AdCode_Exchange_NoCode, 21102).      %% 无效的兑换码
-define(ErrorCode_AdCode_Exchange_Cd, 21103).        %% 使用CD时间未到

%% 212 英雄圣装
-define(ErrorCode_SacredEq_NotExist, 21201).             %% 圣装不存在
-define(ErrorCode_SacredEq_WearCondition, 21202).        %% 穿戴条件不满足
-define(ErrorCode_SacredEq_NotWear, 21203).              %% 没有穿戴圣装
-define(ErrorCode_SacredEq_IntLvLimit, 21204).           %% 已达到强化上限
-define(ErrorCode_SacredEq_CantBreak, 21205).            %% 不可升阶
-define(ErrorCode_SacredEq_LvNotEnough, 21206).          %% 强化等级不足
-define(ErrorCode_SacredEq_CastInfoExist, 21207).        %% 有未处理的祝福信息
-define(ErrorCode_SacredEq_CastInfoNotExist, 21208).     %% 没有未处理的祝福信息
-define(ErrorCode_SacredEq_CharaNotEnough, 21209).       %% 品质不足
-define(ErrorCode_SacredEq_OrderNotEnough, 21210).       %% 阶数不足
-define(ErrorCode_SacredEq_NoDec, 21211).                %% 没有消耗品
-define(ErrorCode_SacredEq_OneKeyOpNoWear, 21212).       %% 一键穿戴没有成功
-define(ErrorCode_SacredEq_NoWearSacredEq, 21213).       %% 没有穿戴对应圣装
-define(ErrorCode_SacredEq_MasterCondition, 21214).       %% 激活圣装大师条件不足
-define(ErrorCode_SacredEq_MasterCondition2, 21215).       %% 圣装大师属性已激活

%% 结婚
-define(Error_wedding_intimacy, 22001).     %% 亲密度不足
-define(Error_wedding_offline, 22002).     %% 对方不在线
-define(Error_wedding_married, 22003).     %% 已经结婚
-define(Error_wedding_invited, 22004).     %% 正在邀请
-define(Error_wedding_not_married, 22005).     %% 结婚后可以预约
-define(Error_wedding_out_time, 22006).     %% 不能预约过期的时间
-define(Error_wedding_out_date, 22007).     %% 不能预约太久的日期
-define(Error_wedding_booked, 22008).     %% 该场次已经被预定
-define(Error_wedding_lower, 22009).     %% 仅支持升级婚礼
-define(Error_wedding_too_late, 22010).     %% 该场次已停止预约
-define(Error_wedding_booking_missed, 22011).     %% 没有预定或已结束
-define(Error_wedding_can_not_change, 22012).     %% 你不能修改
-define(Error_wedding_day_limit, 22013).     %% 每日只能预约一场
-define(Error_wedding_no_booking, 22014).     %% 预约后可发送请柬
-define(Error_wedding_forbidden, 22015).     %% 仅两位新人可邀请
-define(Error_wedding_max_invite, 22016).     %% 没有多余的请柬
-define(Error_wedding_started, 22017).     %% 婚礼已经开始
-define(Error_wedding_self_not, 22018).     %% 不能给新人发送
-define(Error_wedding_un_booking, 22019).     %% 不存在的婚礼
-define(Error_wedding_no_req, 22020).     %% 不能向自己索要
-define(Error_wedding_has_req, 22021).     %% 已经索要过
-define(Error_wedding_overtime, 22022).     %% 婚礼未开始或已结束
-define(Error_wedding_no_invite, 22023).     %% 没有邀请函不能进入
-define(Error_wedding_max_collect, 22024).     %% 超出最大就餐次数
-define(Error_wedding_wedding_map, 22025).     %% 不在婚礼场景中
-define(Error_wedding_gift_id, 22026).     %% 不存在的贺礼
-define(Error_wedding_gift_time_limit, 22027).     %% 超出赠送次数
-define(Error_wedding_danmaku_color, 22028).     %% 不存在的颜色
-define(Error_wedding_envelope_id, 22029).     %% 不存在的红包
-define(Error_wedding_envelope, 22030).     %% 没有找到该红包
-define(Error_wedding_envelope_has_get, 22031).     %% 已经领取过该红包
-define(Error_wedding_envelope_none, 22032).     %% 红包已经被抢完了
-define(Error_wedding_has_divorce, 22033).     %% 未结婚或已离婚
-define(Error_wedding_envelope_out, 22034).     %% 超出发送红包最大次数
-define(Error_wedding_divorce_request, 22035).     %% 请等待对方确认
-define(Error_wedding_divorce_unhandle, 22036).     %% 有未处理的离婚请求
-define(Error_wedding_divorce_offline, 22037).     %% 离线时间不足7天
-define(Error_wedding_divorce_booking, 22038).     %% 还有未完成的婚礼
-define(Error_wedding_divorce_not_exist, 22039).     %% 没有待处理的离婚申请
-define(Error_wedding_divorce_other, 22040).     %% 请等待对方处理
-define(Error_wedding_confirm, 22041).     %% 仅新人可操作
-define(ERROR_wedding_map_main, 22042).     %% 在主城中可操作
-define(ERROR_wedding_has_end, 22043).     %% 已结束
-define(ERROR_wedding_guide_Open, 22044).   %% 对方未开启功能
-define(ERROR_wedding_Cost, 22045).         %% 消耗不足
-define(Error_wedding_invitation_type_user, 22046).     %% 预约后才可使用请柬增加邀请次数
-define(Error_wedding_invitation_forbidden, 22047).     %% 仅两位新人可使用请柬

%% 221 寒风森林
-define(Error_BlizzardForestNotOpen, 22101).     %% 活动未开启

%% 224 英雄幻化
-define(ERROR_PetIllusion_NoActive, 22401).    %%未激活该幻化
-define(ERROR_PetIllusion_NoAlwaysActive, 22402).    %%未永久激活该幻化，不可精炼
-define(ERROR_PetIllusion_MaxLv, 22403).    %%已精炼到满级，不可继续精炼
-define(ERROR_PetIllusion_Equip, 22404).    %%已穿戴该英雄幻化
-define(ERROR_PetIllusion_AlwaysEquip, 22405).    %%该英雄幻化已永久激活
-define(ERROR_PetIllusion_NoEquip, 22406).    %%未穿戴该英雄幻化
-define(ERROR_PetIllusion_CollectLvMax, 22407).    %%收藏室已经达到最大等级
-define(ERROR_PetIllusion_ReFineLvNoMax, 22408).    %%幻化的精炼未到达最大等级，不可使用收藏室

%% 226 组队装备副本
-define(ERROR_TeamEq_No_Enter, 22601).    %%非组队状态，无法进入恶魔宝藏

-endif.        %% -ifndef


