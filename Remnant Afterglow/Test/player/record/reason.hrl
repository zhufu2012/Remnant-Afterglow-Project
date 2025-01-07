%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 原因码
%%% @end
%%% Created : 2018-05-08 16:00
%%%-------------------------------------------------------------------
-ifndef(reason_hrl).
-define(reason_hrl, true).

%% TODO 用于追踪货币、道具等资源的变化原因。不同类型资源、不同变化类型可以使用同一个原因码
%% TODO 命名规则：-define(REASON_功能名_原因名, 原因码).	原因码 = 功能序号 * 100 + 原因序号(1-99)

%% 0 通用
-define(REASON_GetExp_Monster, 1).    %% 打怪获得经验
-define(REASON_GetExp_Pantheon, 2).    %% 战神殿获得经验
-define(REASON_GetExp_Fight1v1, 4).    %% 1v1获得经验
-define(REASON_GetExp_UseItem, 5).    %% 使用道具
-define(REASON_Fix_Data, 6).    %% 数据修复

%% 1 gm
-define(REASON_gm, 101). %% gm命令（例子）
-define(Reason_UseItem, 102).    %% 使用物品
-define(Reason_CBT_Rebate, 103).    %% CBT充值返利
-define(Reason_CBT_Join, 104).    %% CBT参与奖
-define(Reason_Ad_Code_Exchange, 105).    %% 广告码兑换

%% 2 物品背包
-define(REASON_item_bag_capacity, 201). %% 背包容量扩充
-define(REASON_item_bag_split, 202). %% 背包堆叠拆分
-define(REASON_item_bag_merge, 203). %% 背包整理
-define(REASON_item_bag_transfer, 204). %% 背包物品转移
-define(REASON_item_bag_sell, 205). %% 背包物品出售
-define(REASON_item_use_get, 206). %% 使用物品获得
-define(REASON_item_use_cost, 207). %% 使用物品消耗
-define(REASON_item_xunbao_get, 208). %% 寻宝仓库
-define(REASON_item_bag_full_mail, 209). %% 背包满邮件
-define(REASON_quick_synthetic, 210). %% 快捷合成
-define(REASON_item_expedition_explore, 211). %% 远征仓库

%% 3 聚魂/符文/符文塔/万神殿
-define(REASON_soul_fade, 301). %% 灵魂分解
-define(REASON_soul_separate_delete, 302). %% 灵魂拆解
-define(REASON_soul_separate_add, 303). %% 灵魂拆解获得
-define(REASON_soul_addlevel, 304). %% 灵魂强化
-define(REASON_soul_addstar, 305). %% 灵魂升星
-define(REASON_soul_addstage, 306). %% 灵魂升阶
-define(REASON_rune_fade, 311). %% 龙印分解
-define(REASON_rune_separate_delete, 312). %% 灵魂拆解
-define(REASON_rune_separate_add, 313). %% 灵魂拆解获得
-define(REASON_rune_addlevel, 314). %% 灵魂强化
-define(REASON_astro_assist_extend, 315). %% 万神殿助战位扩展
-define(REASON_astro_aequip_addlv, 316). %% 万神殿装备强化消耗
-define(REASON_soul_synt_ret, 317). %% 灵魂合成返回强化材料
-define(REASON_rune_addstar, 318). %% 龙印升星
-define(REASON_astro_aequip_DisGet, 319). %% 拆解获得道具
-define(REASON_rune_addstage, 320). %% 龙印升阶
-define(REASON_rune_tower_mop_up, 321). %% 扫荡
-define(REASON_astro_synthetic, 322). %% 黄金契约装备合成继承经验达到上限，返还经验道具

%% 4 合成
-define(REASON_Synthetic, 401).     %% 合成
-define(REASON_DisassembleCost, 402).     %% 拆消耗
-define(REASON_DisassembleGet, 403).     %% 拆获得

%% 挂机
-define(REASON_hang, 501).  %% 挂机
-define(Reason_Hang_AutoUse, 502).  %% 自动使用
-define(Reason_Quick_Hang, 503).  %% 快速讨伐

%% 6 装备
-define(REASON_Eq_add_level, 601).     %% 装备强化
-define(REASON_Eq_fade, 602).     %% 装备炼金
-define(REASON_Eq_cast, 603).     %% 装备洗练
-define(REASON_Eq_cast_extend, 604).     %% 装备洗练位扩展
-define(REASON_Eq_gem_refine, 605).     %% 宝石精炼
-define(REASON_Eq_suit_make_d, 606).     %% 装备打造扣除
-define(REASON_Eq_suit_make_a, 607).     %% 装备打造获得
-define(REASON_Eq_GemDismantleCost, 608).     %% 宝石拆解消耗
-define(REASON_Eq_GemDismantleAdd, 609).     %% 宝石拆解获得
-define(REASON_Eq_add_add, 610).     %% 装备追加
-define(REASON_Eq_Ele_Intensity, 611).      %% 装备元素强化
-define(REASON_Eq_Ele_Break, 612).      %% 装备元素突破
-define(REASON_Eq_Ele_Add, 613).      %% 装备元素追加
-define(REASON_Eq_FadePrivilege, 614).      %% 炼金特权
-define(REASON_Eq_Card, 615).      %% 卡片
-define(REASON_Eq_Off, 616).      %% 装备卸下
-define(REASON_Eq_Card_Combine, 617).      %% 卡片升级
-define(REASON_Eq_Card_Recast, 618).      %% 卡片重铸
-define(REASON_Eq_ChangePolarity, 619).      %% 更换极性
-define(REASON_Eq_Forge, 620).      %% 装备打造
-define(REASON_Eq_EquipOn, 621).      %% 装备穿戴

%% 7 宠物/坐骑/翅膀/法宝
-define(REASON_pet_add_star, 701).    %% 宠物升*
-define(REASON_pet_add_lv, 702).    %% 宠物升级
-define(REASON_pet_break, 703).    %% 宠物突破
-define(REASON_pet_awaken, 704).    %% 宠物觉醒
-define(REASON_pet_awaken_p, 705).    %% 宠物炼魂
-define(REASON_pet_soul_add_lv, 706).    %% 魔灵升级
-define(REASON_pet_soul_pill, 707).    %% 魔灵嗑丹
-define(REASON_pet_soul_eqaddlv, 708).    %% 魔灵装备强化
-define(REASON_pet_add_repeat, 709).    %% 宠物重复获取拆分成碎片
-define(REASON_wing_add_repeat, 710).    %% 翅膀重复获取拆分成碎片
-define(REASON_ml_eq_break, 711).    %% 突破
-define(REASON_yl_eq_break, 712).    %% 突破
-define(REASON_sl_eq_break, 713).    %% 突破
-define(REASON_Moling_open_skillbox, 714).    %% 魔灵开启技能格子
-define(REASON_pet_add_item, 715). %% 宠物道具返还
-define(REASON_pet_rein, 716).  %% 宠物转生
-define(REASON_pet_grade, 717).  %% 宠物晋升

-define(REASON_wing_rein, 719).  %% 翅膀转生
-define(REASON_wing_add_star, 720).    %% 翅膀升*
-define(REASON_wing_add_lv, 721).    %% 翅膀升级
-define(REASON_wing_break, 722).    %% 翅膀突破
-define(REASON_wing_feather, 723).    %% 翅膀羽化
-define(REASON_wing_sublimate, 724).    %% 宠物炼魂
-define(REASON_Yiling_soul_pill, 725).    %% 翼灵嗑丹
-define(REASON_Yiling_add_lv, 726).    %% 翼灵升级
-define(REASON_Yiling_eqaddlv, 727).    %% 翼灵装备强化
-define(REASON_FWing_addlv, 728).    %% 飞翼升级
-define(REASON_Yiling_SkillTOpen, 729).    %% 飞翼触发技能开启
-define(REASON_Yiling_SkillTMake, 730).   %% 飞翼触发技能打造
-define(REASON_Yiling_open_skillbox, 731).    %% 翼灵开启技能格子
-define(REASON_mount_add_star, 732).  %% 坐骑升*
-define(REASON_mount_add_lv, 733).  %% 坐骑升级
-define(REASON_mount_break, 734).  %% 坐骑突破
-define(REASON_mount_awaken, 735).  %% 坐骑觉醒
-define(REASON_mount_sublimate, 736).  %% 坐骑炼魂
-define(REASON_Shouling_soul_pill, 737).  %% 兽灵嗑丹
-define(REASON_Shouling_add_lv, 738).  %% 兽灵升级
-define(REASON_Shouling_eqaddlv, 739).  %% 兽灵装备升级
-define(REASON_Shouling_SkillTOpen, 740).  %% 兽灵触发技能槽开启
-define(REASON_Shouling_SkillTMake, 741).  %% 兽灵触发技能打造
-define(REASON_Shouling_open_skillbox, 742).    %% 兽灵开启技能格子
-define(REASON_mount_add_repeat, 743).  %% 坐骑重复获取拆分成碎片
-define(REASON_mount_add_item, 744). %% 坐骑道具返还
-define(REASON_mount_rein, 745).  %% 坐骑转生
-define(REASON_pet_ultimate_lv_up, 746).  %% 魔宠必杀技升级
-define(REASON_wing_open_fly, 747). %% 开启飞翼
-define(REASON_mount_eq_BreakDown, 748). %% 坐骑装备分解
-define(REASON_mount_eq_star_lv, 749). %% 坐骑装备升星
-define(REASON_wing_add_item, 750). %% 翅膀道具返还
-define(REASON_wing_ele_awaken, 751).    %% 翅膀元素觉醒
-define(REASON_mount_ele_awaken, 752).    %% 坐骑元素觉醒
-define(REASON_Yiling_Break, 753).    %% 翼灵突破
-define(REASON_Shouling_Break, 754).    %% 兽灵突破
-define(REASON_Shouling_Lv, 755).    %% 兽灵等级奖励
-define(REASON_Yiling_Lv, 756).    %% 翼灵等级奖励
-define(REASON_Shouling_pos_unlock, 757).  %% 兽灵装备位解锁消耗

-define(REASON_Card_Add_Repeat, 780).  %% 卡片重复获得拆成碎片
-define(REASON_Card_Add_Star, 781).  %% 卡片升星
-define(REASON_Card_Add_Quality, 782).  %% 卡片升品

%% 8 副本
-define(Reason_Dungeon_BuyFightCount, 801). %% 购买副本挑战次数
-define(Reason_Dungeon_MergeFightCount, 802).   %% 合并副本挑战次数
-define(Reason_Dungeon_ClearEnterMapTime, 803). %% 清除进副本CD
-define(Reason_Dungeon_Assistant, 804). %% 副本助战
-define(Reason_Dungeon_Dragon, 805).    %% 龙神秘典副本
-define(Reason_Dungeon_Deposits, 806).    %% 精灵宝库
-define(Reason_Dungeon_PreDeposits, 807).    %% 矮人宝藏
-define(Reason_Dungeon_Couple, 808).    %% 情侣试炼
-define(Reason_Arena, 809). %% 竞技场
-define(Reason_RuneTowerDailyReward, 810). %% 符文塔每日奖励
-define(Reason_Pantheon_collection, 811).   %% 战神殿采集物奖励
-define(REASON_inspire_buy, 812). %% 鼓舞购买
-define(Reason_dungeon_demon_cd, 813).  %% 清除龙神结界CD
-define(REASON_revive_buy, 814). %% 复活购买
-define(Reason_Dungeon_Ornament, 815). %% 配饰副本
-define(Reason_Dungeon_CallBoss, 816). %% 配饰副本召唤Boss
-define(Reason_Dungeon_CallBossRet, 817). %% 配饰副本召唤Boss失败返回
-define(Reason_Dungeon_SweepCallBoss, 818). %% 配饰副本扫荡召唤Boss
-define(Reason_DemonHunterPlayerRank, 819). %% 猎魔个人排名奖励
-define(Reason_DemonHunterGuildRank, 820). %% 猎魔战盟排名奖励
-define(Reason_TeamExp_Compensate, 821).    %% 勇者试炼掉线补偿
-define(Reason_AF_SeasonAward, 822). %% 深渊角斗赛季结算奖励
-define(Reason_AF_OpenBoxRet, 823). %% 深渊角斗开宝箱返回
-define(Reason_AF_OpenBoxAward, 824). %% 深渊角斗开宝箱获得道具
-define(Reason_Dungeon_BuyCoupleCount, 825). %% 购买情侣副本挑战次数
-define(Reason_Dungeon_God, 827).           %% 神力战场副本
-define(Reason_Demon_Buy_Fatigue, 828).     %% 打宝疲劳购买
-define(Reason_Demon_Join_Award, 829).     %% 冒泡奖励
-define(Reason_Demon_SuperBoss_Kill, 830).     %% 超级BOSS击杀奖励
-define(Reason_Demon_SuperBoss_Member, 831).     %% 超级BOSS成员奖励
-define(Reason_Dungeon_Mainline, 832).    %% 主线副本通关奖励
-define(Reason_Dungeon_MainlineChapterStar, 833).    %% 主线副本章节星级奖励
-define(Reason_Dungeon_MainlineReset, 834).    %% 主线副本关卡次数重置
-define(Reason_Dungeon_MainlineMopUp, 835).    %% 主线副本扫荡奖励
-define(Reason_Dungeon_MainlineSecKill, 836).    %% 主线副本三星通关
-define(Reason_AF_OpenBoxCost, 837). %% 深渊角斗开宝箱消耗

%% 9 守护
-define(Reason_Guard_Active, 901).  %% 激活守护
-define(Reason_Guard_LevelUp, 902). %% 守护进阶
-define(Reason_Guard_Awaken, 903). %% 守护觉醒

%% 10 龙神
-define(Reason_GD_ActiveArti, 1001).  %% 激活神器
-define(Reason_GD_Active, 1002).  %% 激活天神
-define(Reason_GD_AddLv, 1003).  %% 天神升级
-define(Reason_GD_EqAwaken1, 1004).  %% 龙神武器觉醒
-define(Reason_GD_EqAwaken2, 1005).  %% 龙神秘典觉醒
-define(Reason_GD_EqSplitDec, 1006).  %% 龙神秘典分解扣除
-define(Reason_GD_EqSplitAdd, 1007).  %% 龙神秘典分解获得
-define(Reason_Skill_LevelUp, 1008).  %% 技能升级消耗
-define(Reason_GD_Duplicate, 1009).  %% 龙神礼包重复获得分解
-define(Reason_GD_EqDuplicate, 1010).  %% 龙神武器礼包重复获得分解
-define(Reason_GD_Rein, 1011).  %% 天神转生消耗
-define(Reason_GD_Break, 1012).  %% 天神突破消耗
-define(Reason_Skill_Reset, 1013).  %% 技能重置
-define(Reason_GD_EQ_add_repeat, 1014).%% 神像圣装 重复获取拆分成碎片
-define(Reason_GD_EQ_star, 1015).%% 神像圣装 升星消耗
-define(Reason_GD_Wing_Up, 1016).  %% 神像翅膀升级
%% 11 福利
-define(Reason_Signin_DayPro, 1101).    %% 签到进度奖励
-define(Reason_FreeItem, 1102).         %% 龙城盛宴
-define(Reason_BountyTaskLottery, 1103).         %% 赏金任务抽奖
-define(Reason_BlessGift, 1104).    %% 祈福
-define(Reason_OnlineTimeReward, 1105).    %% 在线时长奖励
-define(Reason_MondayReward, 1106).         %% 周一奖励
-define(Reason_MondayRewardMail, 1107).     %% 周一奖励邮件补发

%% 12 战盟
-define(Reason_Guild_Create, 1201).     %% 建立战盟
-define(Reason_Guild_FeteGod, 1202).    %% 战盟祭祀
-define(Reason_Guild_Donate, 1203).     %% 战盟捐献
-define(Reason_Guild_Exchange, 1204).   %% 战盟仓库兑换
-define(Reason_Guild_DonateFail, 1205). %% 捐献失败返回
-define(Reason_Guild_getEnvelope, 1206).    %% 领取战盟红包
-define(Reason_Guild_sendEnvelope, 1207).   %% 战盟发红包
-define(Reason_Guild_DailyItem, 1208).      %% 战盟工资
-define(Reason_Guild_UpLevelScience, 1209). %% 升级战盟科技
-define(Reason_Guild_Wish, 1210).        %% 战盟许愿
-define(Reason_Guild_InviteClearCd, 1211).        %% 战盟邀请清除别人的cd
-define(Reason_Guild_InviteClearCdRet, 1212).        %% 战盟邀请清除别人的cd失败返还
-define(Reason_Guild_Impeach, 1213).        %% 战盟弹劾
-define(Reason_Guild_ImpeachGet, 1214).        %% 战盟弹劾返回
-define(Reason_GCamp_Drink, 1215).        %% 战盟喝酒消耗
-define(Reason_GCamp_DrinkRet, 1216).        %% 战盟喝酒返回
-define(Reason_GCamp_StageAward, 1217).        %% 战盟喝酒阶段奖励领取
-define(Reason_GuildGather, 1218).        %% 战盟召集
-define(Reason_Treasure_Chest, 1219).        %% 战盟宝箱分配
-define(Reason_PrestigeSalary, 1220).        %% 战盟声望工资
-define(Reason_Guild_Active_Less, 1221).        %% 公会活跃不足
-define(Reason_Guild_Assign_Award, 1222).        %% 分配奖励
-define(Reason_Guild_LinkUrl_Award, 1223).        %% 公会Link群网址首次填写奖励

%% 13 任务/炎魔/世界Boss/战盟争霸/XO房间/战盟拍卖/领地战
-define(Reason_Task_B_QuickFinishCost, 1300).      %% 快速完成消耗
-define(Reason_Task_B_OneKeyFinishCost, 1301).      %% 快速完成消耗
-define(Reason_YanMo_KillAward, 1302).      %% 守护世界树击杀奖励
-define(Reason_YanMo_HurtAward, 1303).      %% 炎魔伤害阶段奖励
-define(Reason_BoneYardCallBoss, 1304).      %% 埋骨之地召唤Boss消耗
-define(Reason_YanMo_FinishAward, 1305).      %% 守护世界树结算奖励
-define(Reason_WB_HurtAward, 1306).      %% 世界boss伤害奖励
-define(Reason_GC_Award, 1307).      %% 战盟争霸结算奖励
-define(Reason_GC_LeaderAward, 1308).      %% 战盟争霸盟主奖励
-define(Reason_Xo_RankAward, 1309).      %% 答题房间排名奖励
-define(Reason_Xo_BetCost, 1310).      %% 答题房间竞猜消耗
-define(Reason_Xo_BetRet, 1311).      %% 答题房间竞猜返回
-define(Reason_Xo_BetAward, 1312).      %% 答题房间竞猜奖励
-define(Reason_GA_BidCost, 1313).      %% 战盟拍卖出价的消耗
-define(Reason_GA_BidRet, 1314).      %% 战盟拍卖出价返回
-define(Reason_GA_BidBuy, 1315).      %% 战盟拍卖买到
-define(Reason_GA_BidProfit, 1316).      %% 战盟拍卖分红
-define(Reason_WorldLevel_DailyReword, 1317).      %% 世界等级每日邮件
-define(Reason_Xo_Answer, 1318).      %% 答题房间答题奖励
-define(Reason_BC_HurtAward, 1319).      %% 血色争霸阶段奖励
-define(Reason_GG_HurtAward, 1320).      %% 守卫战盟阶段奖励
-define(Reason_GC_HurtAward, 1321).      %% 战盟争霸阶段奖励
-define(Reason_BF_HurtAward, 1322).      %% 永恒战场阶段奖励
-define(Reason_BF_ScoreRank, 1323).      %% 永恒战场积分排行奖励
-define(Reason_GA_GmAddVipExp, 1324).      %% GM后台加的vip经验
-define(Reason_Manor_Bid, 1325).      %% 领地战宣战
-define(Reason_Manor_BidRet, 1326).      %% 领地战宣战返回
-define(Reason_Manor_Settle, 1327).      %% 领地战结算奖励
-define(Reason_Manor_Inspire, 1328).      %% 领地战鼓舞
-define(Reason_Manor_InspireRet, 1329).      %% 领地战鼓舞返回
-define(Reason_Manor_StageAward, 1330).      %% 领地战阶段奖励
-define(Reason_3v3_AchieveGet, 1331).      %% 3v3成就领取
-define(Reason_3v3_WeekRank, 1332).      %% 3v3排行奖励

%% 14 圣物
-define(REASON_holy_add_star, 1401).    %% 圣物升*
-define(REASON_holy_add_lv, 1402).    %% 圣物升级
-define(REASON_holy_break, 1403).    %% 圣物突破
-define(REASON_holy_awaken, 1404).    %% 圣物精炼
-define(REASON_holy_soul_add_lv, 1406).    %% 圣灵升级
-define(REASON_holy_soul_pill, 1407).    %% 圣灵嗑丹
-define(REASON_holy_add_repeat, 1408).    %% 圣物重复获取拆分成碎片
-define(REASON_holy_open_skillbox, 1409).    %% 圣灵开启技能格子
-define(REASON_holy_add_item, 1410). %% 圣物道具返还
-define(REASON_holy_rein, 1411). %% 圣物转生

%% 15 日常
-define(REASON_Daily_Award, 1501).    %% 日常
-define(REASON_Daily_SignUp, 1502).    %% 日常报名奖励
-define(REASON_Daily_SignUp_Guaranteed, 1503).    %% 日常报名低保奖励
-define(REASON_WeekActive_Pay, 1504).    %% 周活跃度通行证
-define(REASON_Daily_Award_mail, 1505).    %% 每日活跃的免费及付费奖励部分 邮件补领


%% 16 新版交易行
-define(REASON_trade_remove_goods, 1601). %% 下架
-define(REASON_trade_buy_goods, 1602). %% 购买
-define(REASON_trade_back, 1603). %% 退还
-define(REASON_trade_add_goods, 1604). %% 上架

%% 17 次日登录奖励
-define(Reason_NextDayAward, 1701).        %%次日奖励

%% 18 头衔
-define(Reason_honor_add_lv, 1801).        %%头衔提升

%% 19 信物
-define(Reason_ring_add_lv, 1901).        %%信物提升
-define(Reason_ring_cast, 1902).        %%信物淬取
-define(Reason_ring_add_star, 1903).        %%信物升星
-define(Reason_ring_add_item, 1904). 	%% 信物道具返还-邮件返还碎片
-define(Reason_ring_add_break, 1905). 	%% 信物突破
-define(Reason_ring_rein_lv, 1906).        %%信物转生
%% 20 装扮
-define(REASON_head_add_star, 2001).    %% 头像升*
-define(REASON_head_album_add_lv, 2002).    %% 相册&相框升级
-define(REASON_head_frame_add_star, 2003).    %% 头像框升*
-define(Reason_ChatBubble_AddStar, 2004).    %% 聊天气泡升星
-define(Reason_HornBubble_AddStar, 2005).    %% 喇叭气泡升星
-define(Reason_ChatPaopao_AddLv, 2006).        %% 聊天泡泡升级
-define(Reason_HornPaopao_AddLv, 2007).        %% 喇叭泡泡升级

% 21 任务
-define(Reason_Task_QuickFinish, 2101).        % 快速完成
-define(Reason_Task_Award, 2102).            % 领取奖励
-define(Reason_Task_PutItem, 2103).            % 提交任务物品
-define(Reason_Task_Multiple, 2104).        % 任务加倍
-define(Reason_Task_FlyShoes, 2105).        % 小飞鞋
-define(Reason_Task_Guild_Refresh, 2106).        % 战盟任务刷新

%% 22 结婚
-define(Reason_Wedding_Engagement, 2201).   %% 提亲
-define(Reason_wedding_Cruise_Exp, 2202).   %% 游行经验
-define(Reason_wedding_Marry_Exp, 2203).    %% 拜堂经验
-define(Reason_wedding_DingQinRet, 2204).    %% 定亲失败返还

%% 23 百鬼夜行/守卫仙盟
-define(Reason_GG_JiaGuUsed, 2300).    %% 神柱加固消耗
-define(Reason_GG_JiaGuGet, 2301).    %% 神柱加固获得
-define(Reason_BY_CallBossRet, 2302).    %% 召唤Boss返回消耗
-define(Reason_GG_KillBossGet, 2303).    %% Boss击杀奖励
-define(Reason_GG_Finish, 2304).    %% 结算
-define(Reason_BY_KillExp, 2305).    %% 百鬼夜行击杀经验
-define(Reason_GG_KillExp, 2306).    %% 守卫战盟击杀经验
-define(Reason_BY_MopUp, 2307).    %% 百鬼夜行扫荡
-define(Reason_GC_Daily, 2308).    %% 战盟争霸每日领奖
-define(Reason_Bonfire_Tick, 2309).    %% 战盟篝火心跳奖励

% 24 转职
-define(Reason_ChangeRole_Fate, 2401).    % 点亮命星
-define(Reason_ChangeRole_DragonSpirit, 2402).    % 点亮龙魂
-define(Reason_ChangeRole_Element, 2403).    % 点亮元素
-define(Reason_ChangeRole_DragonCristal, 2404).    % 点亮龙魂
-define(Reason_ChangeRole_DemonSource, 2405).    % 点亮魔源
-define(Reason_ChangeRole_MagicFire, 2406).     %% 点亮神火
-define(Reason_ChangeCareer, 2407).    % 职业转换

%% 25 预言之书
-define(Reason_Book_Task_Award, 2501).    %% 奖励领取

%% 26 测试图鉴
-define(Reason_Get_Card, 2601). %% 获取图鉴卡牌
-define(Reason_Card_Up_Star, 2602). %% 图鉴升星
-define(Reason_Card_Up_Quality, 2603). %% 图鉴升品
-define(Reason_Card_Refine, 2604). %% 图鉴炼金

%% 27 护送龙蛋
-define(Reason_Convoy_VehicleMiss, 2701).   %% 镖车消失
-define(Reason_Convoy_VehicleJunk, 2702).   %% 抢劫镖车
-define(Reason_Convoy_Commit, 2703).   %% 交镖

%% 28 成就
-define(Reason_Attainment_Award, 2802).            % 领取成就奖励

%% 29 天赋
-define(Reason_Genius_Reset, 2901).            % 重置天赋

%% 30 王者1V1
-define(REASON_fight_buy_times, 3001). %% 购买次数
-define(REASON_fight_grade_award, 3002). %% 段位奖励
-define(REASON_fight_rank_award, 3003). %% 排名奖励
-define(REASON_fight_task_award, 3004). %% 任务奖励

%% 使用物品
-define(Reason_UseItem_EmojiGroupExist, 3101).    %% 表情包重复激活
-define(Reason_UseItem_TitleDuplicate, 3102).    %% 称号重复激活

%% 商店
-define(Reason_Shop_Buy, 3201).            %% 商店 购买物品
-define(Reason_Shop_Refresh, 3202).        %% 商店 刷新
-define(Reason_Shop_Exchange, 3203).       %% 商店 兑换(绿钻)

%% 33 红名
-define(Reason_Red_Name_Kill_Player, 3301). %% 红名击杀奖励

%% 副本扫荡
-define(Reason_Dungeon_Sweep_Drop_Award, 3401). %% 副本扫荡掉落奖励

%% 功能开启邮件
-define(Reason_Function_Open_Mail, 3501). %% 功能开启邮件
-define(Reason_Function_PreReward, 3502). %% 功能预告奖励
-define(Reason_Function_OpenReward, 3503).    %% 功能开启奖励
-define(Reason_Function_GuideNotice, 3504).    %% 功能预告每日奖励

%% 36 活动
-define(Reason_Active_Exchange, 3601).        % 兑换
-define(Reason_Active_RechargeAct, 3602).    % 充值活动
-define(Reason_Active_Lottery, 3603).        % 抽奖
-define(Reason_Active_Buy, 3604).            % 购买
-define(Reason_Active_Rebate, 3605).        % 天天乐
-define(Reason_Active_weeklyCard, 3606).    %% 特权周卡
-define(Reason_Active_LuckyGuy, 3607).      %% 云购锦鲤
-define(Reason_Active_TicketBuy, 3608).      %% 购买运营活动门票
-define(Reason_LoginCompensation, 3609).      %% 登录补偿
-define(Reason_CloudStageAward, 3610).      %% 云购阶段奖励自己阶段
-define(Reason_DemonSea_BuyTimes, 3611).      %% 恶魔之海购买次数
-define(Reason_DemonSea_TransCost, 3612).      %% 恶魔之海传送消耗
-define(Reason_DemonSea_TransCostRet, 3613).      %% 恶魔之海传送消耗返回
-define(Reason_FireworksAward, 3614).       %% 烟花盛典个人奖励
-define(Reason_FireworksAwardMail, 3615).       %% 烟花盛典个人奖励补发

-define(Reason_Active_change_package, 3619).      %% 换包奖励
-define(Reason_Active_type_200, 3620).      %% 版本预告奖励
-define(Reason_Active_open_server_gift, 3621).      %% 开服礼包
-define(Reason_Active_recharge_wheel_one, 3622).      %% 幸运转盘
-define(Reason_Active_recharge_wheel_two, 3623).      %% 鸿运转盘
-define(Reason_Active_Limit_Direct_Buy, 3624).      %% 限时直购
-define(Reason_BlzForest_Exchange, 3625).      %% 寒风森林 交换
-define(Reason_Change_Active_Exchange, 3626).      %% 兑换活动 交换
-define(Reason_Privilege_Weekly_Card, 3627).      %% 特权周卡
-define(Reason_Active_Lucky_Cat, 3628).      %% 招财猫
-define(Reason_CloudBuy_Compensate, 3629).      %% 云购奖励补发

%% 37 三界战场
-define(Reason_BattleField_Task, 3701).        % 三界战场任务奖励

%% 38 弹幕
-define(Reason_Danmaku_Gift, 3801).            % 弹幕礼物

%% 39 登录奖
-define(Reason_LoginGift_Get, 3901).        %% 登录奖领奖
-define(Reason_LoginGift_Compensation, 3902).        %% 登录奖领奖数据修复补偿

%% 40 资源找回
-define(Reason_RetrieveRes, 4001).      %% 资源找回

%% 41 0元购
-define(Reason_FreeBuy_Buy, 4101).            %% 0元购 购买
-define(Reason_FreeBuy_Gift, 4102).            %% 0元购 奖励
-define(Reason_FreeBuy_Gift_mail, 4103).       %% 0元购活动返利未领取 邮件补领
%% 42、嘉年华
-define(Reason_Carnival, 4201).     %% 嘉年华
-define(Reason_Carnival_BaseReward, 4202).     %% 嘉年华基础奖励
-define(Reason_Carnival_RankReward, 4203).     %% 嘉年华排名奖励
-define(Reason_Carnival_BuyGoods, 4204).     %% 嘉年华商品购买

%% 43 基金
-define(Reason_Funds_Buy, 4301).        % 基金 购买
-define(Reason_Funds_Award, 4302).        % 基金 领奖
-define(Reason_Funds_AllAward, 4303).    % 全民奖励领取
-define(Reason_Financing_MonthBuy, 4304).    % 月理财购买
-define(Reason_Financing_MonthAward, 4305).    % 月理财领奖
-define(Reason_Financing_WeekAward, 4306).    % 周理财领奖
-define(Reason_Financing_WeekBuy, 4307).    % 周理财开通
-define(REASON_Financing_WeekBuy_DailyFreeGift, 4308).      %% 月理财 每日免费礼包
-define(REASON_Funds_DailyFreeGift, 4309).      %%基金 每日免费礼包

%% 44 寻宝
-define(REASON_xun_bao_draw, 4401). %% 寻宝
-define(REASON_xun_bao_period, 4402). %% 寻宝热点
-define(REASON_xun_bao_time_item, 4403). %% 多次寻宝
-define(REASON_xun_bao_receive_draw, 4404). %% 泰坦寻宝-领取达成奖励
-define(REASON_xun_bao_taitan_draw, 4405). %% 泰坦寻宝-新赛季时，邮件发送未领取的奖励
-define(REASON_xun_bao_taitan_synthe, 4406). %% 泰坦寻宝-跨赛季合并新赛季寻宝令
-define(REASON_xun_bao_taitan_reset, 4407). %% 泰坦寻宝-跨赛季 泰坦寻宝积分重置
%% 45 组队
-define(Reason_Team_inviteMirror, 4501).    %% 邀请助战镜像
-define(Reason_Team_inviteAward, 4502).     %% 被邀请助战奖励

%% 46 充值
-define(REASON_recharge_total_daily_finish, 4601). %% 每日累充领奖
-define(REASON_recharge_total_period_finish, 4602). %% 周期累充领奖
-define(REASON_recharge_first_finish, 4603). %% 首充领奖
-define(REASON_recharge_buy_free_finish, 4604). %% 一元秒杀免费领奖
-define(REASON_recharge_buy_recharge_finish, 4605). %% 一元秒杀充值领奖
-define(REASON_recharge_life_card_open_finish, 4606). %% 终身卡开通领奖
-define(REASON_recharge_life_card_daily_finish, 4607). %% 终身卡每日领奖
-define(REASON_recharge_life_card_open, 4608). %% 终身卡晚购补偿
-define(REASON_recharge_gold, 4609). %% 充值
-define(REASON_recharge_extra_gold, 4610). %% 充值赠送
-define(REASON_gm_recharge_gold, 4611). %% GM充值
-define(REASON_gm_recharge_extra_gold, 4612). %% GM充值赠送
-define(REASON_recharge_first2_finish, 4613). %% 新服累充领奖
-define(REASON_recharge_first3_finish, 4614). %% 续充领奖
-define(REASON_recharge_test_rebate, 4615). %% 充值测试返利
-define(REASON_recharge_gift_package_award, 4616). %% 直购礼包领奖
-define(REASON_recharge_fund_active_award, 4617). %% 直购基金激活领奖
-define(REASON_recharge_game_helper_buy, 4618). %% 小助手购买
-define(REASON_recharge_first_Mail, 4619).      %% 首充奖励补发
-define(REASON_recharge_gift_packs_buy, 4620).      %% 直购礼包购买
-define(REASON_recharge_daily_buy, 4621).      %% 每日礼包领奖
-define(REASON_recharge_seckill_buy, 4622).      %% 每日秒杀领奖
-define(REASON_recharge_Subscribe_Open, 4623).      %% 月订阅
-define(REASON_recharge_first_buy, 4624). %% 首充购买
-define(REASON_recharge_Daily_Total, 4625). %% 新每日累充
-define(REASON_recharge_life_card_daily_free_gift, 4626). %% 终身卡每日免费礼包
-define(REASON_recharge_Subscribe_daily_free_gift, 4627).      %% 月订阅每日免费礼包
-define(REASON_recharge_life_card_daily_finish_mail, 4628). %% 终身卡每日未领奖 邮件补领
-define(REASON_recharge_Subscribe_daily_free_gift_mail, 4629). %% 月卡每日未领奖 邮件补领
-define(REASON_recharge_ExclusiveTotalRecharge, 4630). %% 专属累充领奖
-define(REASON_recharge_fund_daily_award, 4631).  %% 直购基金每日领奖
-define(REASON_recharge_fund_daily_award_mail, 4632).  %% 直购基金每日未领发送邮件
-define(REASON_recharge_game_helper_award, 4633). %% 小助手每日领奖

%% 47 限时特惠
-define(Reason_TimeLimit_BuyGift, 4701).    %% 购买礼包

%% 48 情侣月卡
-define(Reason_CPMonthCard_Buy, 4801).        %% 购买情侣月卡
-define(Reason_CPMonthCard_Award, 4802).    %% 领取情侣月卡奖励

%% 49 vip引导
-define(Reason_VipGuide_LvAward, 4901).        %% vip引导等级奖励
-define(Reason_VipGuide_LoginAward, 4902).    %% vip引导登录奖励
-define(Reason_Vip_PlayerLvAward, 4903).    %% 玩家达到一定等级赠送vip等级
-define(Reason_Vip_PlayerDrawAward, 4904).    %% 玩家抽奖送vip
-define(Reason_Vip_Packs_Buy, 490).    %% Vip礼包购买
-define(Reason_Vip_AdditionalRewards, 491).    %% VIP达成额外奖励
-define(Reason_Vip_FreeGift, 492).    %% VIP每日免费礼包

%% 50、运营活动
-define(Reason_SalesActivity_GetAward, 5001).   %% 领取奖励
-define(Reason_SalesActivity_GetTempBag, 5002).    %% 领取转盘临时背包奖励
-define(Reason_SalesActivity_ExchangeAward, 5003). %% 转盘兑换物品
-define(Reason_SalesActivity_WheelRankAward, 5004). %% 转盘排行奖励
-define(Reason_SalesActivity_Question_Award, 5005). %% 问卷调查奖励
-define(Reason_SalesActivity_PromotionPresentGift, 5006). %% 荣耀献礼
-define(Reason_SalesActivity_PromotionTreasure, 5007). %% 无尽宝库
-define(Reason_SalesActivity_GloryCarnival, 5008). %% 觉醒狂欢
-define(Reason_SalesActivity_TimeLimitGift, 5009). %% 限时特惠弹窗版
-define(Reason_SalesActivity_BossFirstKill, 5010). %% boss首杀
-define(Reason_SalesActivity_DragonTreasure, 5011). %% 龙神秘宝
-define(Reason_SalesActivity_WheelDraw, 5012). %% 转盘抽奖
-define(Reason_SalesActivity_DonateRoulette, 5013). %% 捐赠活动
-define(Reason_SalesActivity_Arbitrary_Charge, 5014). %% 任意充
-define(Reason_SalesActivity_BLZForestChangeAward, 5015). %% 寒风森林兑换物品
-define(Reason_SalesActivity_WheelDrawItemBuy, 5016). %% 转盘购买抽奖道具
-define(Reason_SalesActivity_DragonTreasureDrawItemBuy, 5017). %% 龙神秘宝购买抽奖道具
-define(Reason_SalesActivity_DragonTempleAward, 5018).   %% 龙神殿领取奖励
-define(Reason_SalesActivity_ChangeActiveChangeAward, 5019). %% 兑换活动兑换物品
-define(Reason_SalesActivity_Continuous_Recharge_ExAward, 5020).   %% 连充豪礼领取奖励
-define(Reason_SalesActivity_WantedReward, 5021).   %% 悬赏活动领取奖励
-define(Reason_SalesActivity_VersionNoticeAward, 5022).   %% 版本预告领取奖励
-define(Reason_SalesActivity_ConsumeTop, 5023).   %% 消费排行结算奖励
-define(Reason_SalesActivity_DestinyWheel, 5024).   %% 天命转盘奖励
-define(Reason_SelectGoods_Reward, 5025).        %%自选直购奖励发放
-define(Reason_SelectGoods_Coin, 5026).            %%自选货币购买 货币扣除
-define(Reason_SelectGoods_Coin_Reward, 5027).    %%自选货币购买 奖励发放

%% 51 七天奖
-define(Reason_SevenGift_Buy, 5101).        %% 福利购买
-define(Reason_SevenGift_Award, 5102).        %% 领取奖励

%% 52 世界服阶段
-define(REASON_cluster_stage_player_award, 5201). %% 屠魔令玩家领奖
-define(REASON_cluster_stage_rank_award, 5202). %% 屠魔令排名奖励

%% 53 发货
-define(REASON_fahuo_uc_item, 5301).  %% uc发货
-define(REASON_fahuo_qq_item, 5302).  %% qq发货
-define(REASON_fahuo_oppo_item, 5303).%% oppo发货
-define(REASON_fahuo_efun_item, 5304).%% efun发货

%% 54 配饰
-define(Reason_Ornament_Int, 5401).         %% 强化消耗
-define(Reason_Ornament_Break, 5402).       %% 升阶消耗
-define(Reason_Ornament_Cast, 5403).        %% 祝福消耗
-define(Reason_Ornament_Fade, 5404).        %% 分解消耗
-define(Reason_Ornament_FadeDouble, 5405).  %% 分解双倍消耗

%% 55 聊天
-define(REASON_chat_cluster, 5501). %% 聊天

%% 56 魂器
-define(Reason_Horcrux_HxAddLv, 5601).        %% 魂器升级
-define(Reason_Horcrux_HsAddLv, 5602).        %% 器灵升级
-define(Reason_Horcrux_HsSkillBoxOpen, 5603). %% 器灵技能格开放
-define(Reason_Horcrux_HsPill, 5604).         %% 器灵磕丹

%% 57 满减促销活动
-define(Reason_Discount_Buy, 5701).         %% 购买

%% 58 拍卖行
-define(REASON_auction_bid_exceeded, 5801). %% 竞价被超
-define(REASON_auction_buy_succeed, 5802). %% 购买成功
-define(REASON_auction_back, 5803). %% 失败退还
-define(REASON_auction_bonus, 5804). %% 分红

%% 59 龙神777
-define(Reason_Card777_Draw, 5901).         %% 抽奖消耗
-define(Reason_Card777_Random, 5902).       %% 重置消耗
-define(Reason_Card777_SpAward, 5903).      %% 领取大奖
-define(Reason_Card777_SpAwardMail, 5904).  %% 大奖补发

%% 60 节日签到
-define(Reason_FSign_Sign, 6001).           %% 签到
-define(Reason_FSign_RepSign, 6002).        %% 补签
-define(Reason_FSign_Award, 6003).          %% 领奖
-define(Reason_FSign_1KeyRepSign, 6004).    %% 一键补签
-define(Reason_FSign_AwardMail, 6005).      %% 邮件补发

%% 61 累充兑换
-define(Reason_RechargeExchange_AwardMail, 6101).   %% 累充签到奖励邮件

%% 62 神兵
-define(Reason_Weapon_Active, 6201).        %% 神兵激活
-define(Reason_Weapon_Reopen, 6202).        %% 神兵解封
-define(Reason_Weapon_AddLv, 6203).         %% 神兵升阶
-define(Reason_Weapon_AddStar, 6204).       %% 神兵升星
-define(Reason_Weapon_SoulAddLv, 6205).     %% 兵魂升级
-define(Reason_Weapon_SoulPill, 6206).      %% 兵魂磕丹
-define(Reason_Weapon_OpenSkillBox, 6207).  %% 兵魂开启技能孔

%% 63 神秘商店
-define(Reason_MysteryShop_Buy, 6301).          %% 神秘商店购买商品
-define(Reason_MysteryShop_Refresh, 6302).       %% 神秘商店刷新商店

%% 64 节日工资
-define(Reason_FWage_AwardMail, 6401).      %% 邮件发奖

%% 65 圣盾
-define(Reason_Holy_Shield_Up_Level, 6501). %%  升级
-define(Reason_Holy_Shield_Up_Stage, 6502). %% 升阶
-define(Reason_Holy_Shield_Skill_Up_Level, 6503). %% 技能升级
-define(Reason_Holy_Shield_Decompose, 6504). %% 分解
-define(Reason_Holy_Shield_Level_Break, 6505). %%  突破

%% 67 风暴龙城
-define(REASON_dragon_city_updown, 6701). %% 龙城雕像点赞

%% 68 荣耀龙徽进阶
-define(REASON_Glory_Badge_Advance, 6801). %% 进阶消耗
-define(REASON_Glory_Badge_AddLv, 6802). %% 升级奖励
-define(REASON_Glory_Badge_DailyReward, 6803). %% 每日奖励
-define(REASON_Glory_Badge_BuyGoods, 6804). %% 兑换商品
-define(REASON_Glory_Badge_Email, 6805). %% 邮件补发奖励
-define(REASON_Glory_Badge_Exp, 6806). %% 扣除龙徽经验
-define(REASON_Glory_Badge_Supplement, 6807). %% 进阶补发奖励
-define(REASON_Glory_Badge_Buy_Exp, 6808). %% 购买龙徽经验

%% 69 星座
-define(Reason_Constellation_Up_Star, 6901). %% 星座升星
-define(Reason_Constellation_enhance_star_soul, 6902). %% 星魂强化
-define(Reason_Constellation_breakdown, 6903). %% 星魂装备分解
-define(Reason_Constellation_Unlock_Skill_Position, 6904). %% 技能位置解锁
-define(Reason_Constellation_Awaken, 6905). %% 星魂觉醒
-define(Reason_Constellation_Bless, 6906). %% 幸运祝福
-define(Reason_Constellation_BlessPro, 6907). %% 星魂祝福
-define(Reason_Constellation_Gem_AddLv, 6908). %% 星石升级
-define(Reason_Constellation_Gem_Skill_AddLv, 6909). %% 星石技能升级
-define(Reason_Constellation_Gem_Embed, 6910). %% 星石镶嵌
-define(Reason_Constellation_Gem_Skill_Reset, 6911). %% 星石技能重置

%% 70 边境入侵
-define(REASON_border_war_getWarCoin, 7001). %% 获取战功
-define(REASON_border_war_bp_personal, 7002). %% 王者证书BP领奖
-define(REASON_border_war_bp_server, 7003). %% 征战令牌BP领奖
-define(REASON_border_war_bp_buy_score, 7004). %% 购买征服点/荣誉点
-define(REASON_border_war_coll_award, 7005). %% 边境采集
-define(REASON_border_war_settle, 7006).        %% 结算
-define(REASON_border_war_server_score_daily, 7007).        %% 服务器每日排名奖励
-define(REASON_border_war_Convene, 7008).        %% 边境召集
-define(REASON_border_war_bp_personal_compensate, 7009). %% 王者证书BP领奖补领
-define(REASON_border_war_bp_server_compensate, 7010). %% 征战令牌BP领奖补领

%% 71 古神圣装
-define(REASON_Ancient_Holy_Eq_Enhance, 7101). %% 强化
-define(REASON_Ancient_Holy_Eq_Awaken, 7102).  %% 觉醒
-define(Reason_Ancient_Holy_Eq_Breakdown, 7103).  %% 觉醒

%% 72 圣战遗迹
-define(Reason_HolyWar_Boss, 7201).         %% boss掉落
-define(Reason_HolyWar_Box, 7202).          %% 宝箱掉落

%% 73 龙神骑士
-define(Reason_Dragon_Honor_Rank_Award, 7301).    %% 龙神骑士排名奖励
-define(Reason_Dragon_Honor_Daily_Award, 7302).    %% 龙神骑士每日奖励
-define(Reason_Dragon_Honor_Title_Change, 7303).    %% 龙神骑士称号改变
-define(Reason_Dragon_Honor_Final_Award, 7304).    %% 龙神骑士最终结算
-define(Reason_Dragon_Honor_Guild_Settle, 7305).    %% 龙神骑士每日战盟结算

%% 74 神位和神力天赋
-define(REASON_Divine_Talent_Reset_Return, 7401).           %% 重置返还
-define(REASON_Divine_Talent_Reset_Cost, 7402).             %% 重置消耗
-define(REASON_Divine_Talent_Change_Type_Return, 7403).     %% 神系转换返还
-define(REASON_Divine_Talent_Change_Type_Cost, 7404).     %% 神系转换返还
-define(REASON_Divine_Talent_Up_Star, 7405).                %% 神力天赋升星

%% 75 篝火Boss
-define(REASON_Bonfire_Boss_Coll, 7501).           %% 采集获得
-define(REASON_Bonfire_Boss_Person_Rank, 7502).    %% 盟内排行奖励

%% 76 神位争夺
-define(Reason_GodFight_Settle, 7601).                  %% 结算奖励

%% 77 圣翼
-define(Reason_Holy_Wing_Intensify, 7701).              %% 圣翼强化消耗
-define(Reason_Holy_Wing_Unlock, 7702).                 %% 圣翼等级解锁消耗
-define(Reason_Holy_Wing_Refine, 7703).                 %% 圣翼精炼消耗
-define(Reason_Holy_Wing_RuneLv, 7704).                 %% 符文升级消耗
-define(Reason_Holy_Wing_RuneChange, 7705).             %% 符文升级
-define(Reason_Holy_Wing_SkillLv, 7706).                %% 技能升级
-define(Reason_Holy_Wing_Skill_Pos_Unlock, 7707).       %% 技能槽解锁
-define(Reason_Holy_Wing_Choose_Type, 7708).            %% 转换消耗

%% 78 协助
-define(Reason_GuildHelp_Seeker_Finish, 7801).   %% 求助者的协助被完成
-define(Reason_GuildHelp_Success, 7802).   %% 协助者完成协助
-define(Reason_GuildHelp_Tks_box, 7803).   %% 使用心意宝箱

%% 79 星空圣墟
-define(Reason_HolyRuins_Boss, 7901).                   %% boss掉落
-define(Reason_HolyRuins_Collection, 7902).             %% 宝箱掉落

%% 80 血脉
-define(Reason_Blood_Active, 8001).                     %% 激活血脉
-define(Reason_Blood_AddLevel, 8002).                   %% 血脉升级
-define(Reason_Blood_SkillAddLevel, 8003).              %% 血脉技能升级

%% 81 龙神秘宝
-define(Reason_DragonTreasure_Draw, 8101).              %% 抽奖
-define(Reason_DragonTreasure_TimesReward, 8102).       %% 次数奖励
-define(Reason_DragonTreasure_TimesRewardMail, 8103).   %% 次数奖励补发

%% 82 圣甲
-define(Reason_Shengjia_AddLevel, 8201).              %% 圣甲天赋升级
-define(Reason_Shengjia_GemEquipOn, 8202).              %% 圣甲元素宝石装配
-define(Reason_Shengjia_GemEquipOff, 8203).              %% 圣甲元素宝石卸下
-define(Reason_Shengjia_OpenPos, 8204).              %% 圣甲点亮
-define(Reason_Shengjia_Active, 8205).              %% 圣甲点亮
%% 83 圣纹
-define(Reason_Shengwen_Intensify, 8301).              %% 圣纹强化
-define(Reason_Shengwen_Awaken, 8302).              %% 圣纹觉醒
-define(Reason_Shengwen_resolve, 8303).              %% 圣纹分解
-define(Reason_QuickSynthesize_ShengWen, 8304).   %% 圣纹-神王纹升阶
%% 84 元素试炼
-define(Reason_ElementTrial_Monster, 8401).         %% 怪物掉落
-define(Reason_ElementTrial_BuyCurse, 8402).        %% 购买诅咒值

%% 85 暗炎魔装
-define(Reason_Dark_Flame_Forge, 8501).         %% 魔锻消耗
-define(Reason_Dark_Flame_BreakDown, 8502).     %% 魔装分解

%% 86 恶魔悬赏令
-define(Reason_DemonReward_Buy, 8601).          %% 购买
-define(Reason_DemonReward_Award, 8602).        %% 领奖

%% 87 领地战
-define(Reason_Domain_Fight_Stage_Award, 8701).       %% 领地战阶段奖励
-define(Reason_Domain_Fight_Inspire, 8702).           %% 领地战鼓舞
-define(Reason_Domain_Fight_Person_Award, 8703).      %% 领地战个人奖励

%% 88 龙神封印
-define(Reason_DragonSeal_Dungeon, 8801).       %% 龙神封印副本
-define(Reason_DragonSeal_Award, 8802).         %% 龙神封印奖励
-define(Reason_DragonSeal_BuyTimes, 8803).      %% 龙神封印购买次数
-define(Reason_DragonSeal_CallBoss, 8804).      %% 龙神封印召唤boss
-define(Reason_DragonSeal_BuyTimesRet, 8805).   %% 购买次数返还

%% 89 个人龙徽
-define(Reason_Dragon_Badge_Advance, 8901).             %% 龙徽进阶
-define(Reason_Dragon_Badge_Supplement, 8902).          %% 进阶补发奖励
-define(Reason_Dragon_Badge_Lv_Award, 8903).            %% 等级奖励
-define(Reason_Dragon_Badge_DailyReward, 8904).         %% 每日奖励
-define(Reason_Dragon_Badge_Buy_Exp, 8905).             %% 经验购买

%% 90 神佑
-define(REASON_god_bless_prayer_exp, 9001). %% 经验祈祷

%% 91 主线封印
-define(Reason_Mainline_Seal_Rank, 9101).            %% 主线封印排名奖励
-define(Reason_Mainline_Seal_Personal, 9102).        %% 主线封印个人奖励

%% 92 商船
-define(REASON_Merchant_Ship_Refresh, 9201).  %% 商船刷新
-define(REASON_Merchant_Ship_Escort, 9202).   %% 商船护送
-define(REASON_Merchant_Ship_Plunder, 9203).   %% 商船掠夺
-define(REASON_Merchant_Ship_Retake, 9204).   %% 商船夺回
-define(REASON_Merchant_Ship_Help_Retake, 9205).   %% 商船协助夺回

%% 93 觉醒之路
-define(Reason_Awaken_Road_GetReward, 9301).            %% 觉醒之路领奖
-define(Reason_Awaken_Road_ActiveBP, 9302).            %% 觉醒之路 激活战令

%% 94 游戏助手
-define(Reason_Game_Guidance_StoryReward, 9401).            %% 故事书领奖
-define(Reason_Game_Guidance_AccompanyReward, 9402).            %% 外显图鉴

%% 95 龙神雕像
-define(Reason_DG_Statue_BreakDown, 9501).            %% 龙神雕像分解
-define(Reason_DG_Statue_Awaken, 9502).                %% 龙神雕像觉醒
-define(Reason_DG_Statue_Equip, 9503).                %% 龙神雕像穿戴
-define(Reason_DG_WeaponAddStar, 9504).                %% 神像武器升星
-define(Reason_DG_WeaponFade, 9505).                %% 神像武器分解

%% 96 魔宠副本
-define(Reason_DungeonPet_MopUp, 9601).         %% 扫荡
-define(Reason_DungeonPet_FirstDown, 9602).     %% 首杀

%% 97 快捷合成
-define(Reason_QuickSynthesize_Synthesize, 9701).   %% 合成

%% 98 秘境试炼
-define(Reason_Dungeon_BP_Award, 9801).   %% 领取奖励
-define(Reason_Dungeon_BP_Advance_Compensate, 9802).   %% 进阶补偿奖励
-define(Reason_Dungeon_BP_Reset_Compensate, 9803).   %% 重置补偿奖励
-define(Reason_Dungeon_BP_Advance, 9804).   %% 进阶

%% 99 恶魔狩猎季
-define(Reason_Dh_Season_Finish, 9901).   %% 阶段结束奖励邮件

%% 100 磕丹
-define(Reason_Pill, 10001).   %% 磕丹

%% 101 队伍转生
-define(Reason_Reincarnate_Stage, 10101).   %% 转生阶段结束奖励
-define(Reason_Reincarnate_Help, 10102).   %% 转生协助

%% 102 D3精英副本
-define(Reason_Elite_Dungeon, 10201).   %% 精英副本
-define(Reason_Elite_BpBuy, 10202).     %% 精英副本购买bp

%% 103 D3交易行
-define(Reason_Trading_Market_Sell, 10301). %% 出售物品
-define(Reason_Trading_Market_Buy, 10302). %% 购买物品
-define(Reason_Trading_Market_Buy_Fail, 10303). %% 购买物品失败
-define(Reason_Trading_Market_TradeGold_OnSell, 10304). %% 粉钻上架
-define(Reason_Trading_Market_TradeGold_OffSell, 10305). %% 粉钻下架
-define(Reason_Trading_Market_TradeGold_Buy, 10306). %% 粉钻购买
-define(Reason_Trading_Market_TradeGold_Buy_Fail, 10307). %% 粉钻购买失败
-define(Reason_Trading_Market_TradeGold_TakeIncome, 10308). %% 粉钻收益提取
-define(Reason_Trading_Market_TradeItem_OnSell, 10309). %% 物品上架
-define(Reason_Trading_Market_TradeItem_OffSell, 10310). %% 物品下架
-define(Reason_Trading_Market_TradeItem_TakeIncome, 10311). %% 物品收益提取
-define(Reason_Trading_Market_TradeItem_ServerBack, 10312). %% 系统强制回退


%% 104 主线祝福
-define(Reason_ClientDungeon_Unlock, 10401). %% 解锁孔位

%% 105 装备收藏
-define(Reason_EqCollect_EqReborn, 10501).    %% 装备再生
-define(Reason_EqCollect_EqCollect, 10502).    %% 装备收藏

%% 106 赏金任务
-define(Reason_BountyTask, 10601). %% 赏金任务
-define(Reason_BountyTaskSpecialActive, 10602). %% 赏金任务特权激活
-define(Reason_BountyTaskDispatch, 10603).        %% 赏金任务派遣
-define(Reason_BountyTaskInit, 10604).            %% 初始赠送

%% 107 竞技场
-define(Reason_ArenaProAward, 10701). %% 竞技场进步奖励
-define(Reason_ArenaFinally, 10702). %% 竞技场永久结算奖励

%% 108 神饰
-define(Reason_GodOrnament_Active, 10801). %% 神饰激活
-define(Reason_GodOrnament_ExcellenceActive, 10802). %% 神饰卓越激活
-define(Reason_GodOrnament_ExcellenceAdvance, 10803). %% 神饰卓越进阶
-define(Reason_GodOrnament_Advance, 10804). %% 神饰升阶

%% 109 龙神试炼
-define(Reason_Dragon_God_Trail_Rank, 10901).   %% 排名奖励
-define(Reason_Dragon_God_Trail_Cond, 10902).   %% 达成奖励

%% 110 新王者1v1
-define(Reason_King1v1_BattleSettle, 11001).         %% 对战结算奖励
-define(Reason_King1v1_SeasonSettle, 11002).         %% 赛季结算奖励
-define(Reason_King1v1_TaskAward, 11003).            %% 任务奖励
-define(Reason_King1v1_BuyTimes, 11004).             %% 次数购买
-define(Reason_King1v1_Bet, 11005).                  %% 竞猜
-define(Reason_King1v1_MergeCompensate, 11006).      %% 合服补偿

%% 111 奖杯
-define(Reason_Cup_LevelUp, 11101).             %% 奖杯升级
-define(Reason_Cup_CharUp, 11102).             %% 奖杯升品
-define(REASON_Cup_Add_Repeat, 11103).  %% 奖杯重复获取拆分成碎片
-define(Reason_Cup_ActiveStamp, 11104).             %% 激活印记
-define(Reason_Cup_StarUp, 11105).                %%奖杯升星

%% 112 跨服拍卖
-define(Reason_ClusterAuction_Bid, 11201).               %% 竞拍
-define(Reason_ClusterAuction_Buy, 11202).               %% 一口价
-define(Reason_ClusterAuction_Back, 11203).              %% 返还
-define(Reason_ClusterAuction_Bonus, 11204).             %% 分红

%% 113 金流专用原因码
-define(Reason_Gold_Flow1, 11301).                %% 充值钻石
-define(Reason_Gold_Flow2, 11302).                %% 直购新手礼包
-define(Reason_Gold_Flow3, 11303).                %% 直购每日礼包
-define(Reason_Gold_Flow4, 11304).                %% 直购每周礼包
-define(Reason_Gold_Flow5, 11305).                %% 月理财
-define(Reason_Gold_Flow6, 11306).                %% 普通终身卡
-define(Reason_Gold_Flow7, 11307).                %% 至尊终身卡
-define(Reason_Gold_Flow8, 11308).                %% 直购成长基金
-define(Reason_Gold_Flow9, 11309).                %% 直购战令
-define(Reason_Gold_Flow10, 11310).               %% 直购限时特惠
-define(Reason_Gold_Flow11, 11311).               %% 直购荣耀献礼
-define(Reason_Gold_Flow12, 11312).               %% 其他直购
-define(Reason_Gold_Flow13, 11313).               %% 普通觉醒之路领取
-define(Reason_Gold_Flow14, 11314).               %% 免费新手礼包
-define(Reason_Gold_Flow15, 11315).               %% 免费每日礼包
-define(Reason_Gold_Flow16, 11316).               %% 免费每周礼包
-define(Reason_Gold_Flow17, 11317).               %% 返利券


%% 114 等级封印
-define(Reason_LevelSeal_Award, 11401).         %% 等级封印奖励
-define(Reason_LevelSeal_Dungeon, 11402).       %% 等级封印副本
-define(Reason_LevelSeal_Shop, 11403).       %% 等级封印商店

%% 115 圣物系统
-define(REASON_relic_active, 11501).             %% 圣物激活
-define(REASON_relic_up_level, 11502).           %% 圣物升级
-define(REASON_relic_up_grade_level, 11503).     %% 圣物升品
-define(REASON_relic_up_awaken_level, 11504).    %% 圣物觉醒
-define(REASON_relic_hs_up_level, 11505).        %% 圣印升级
-define(REASON_relic_illusion_active, 11506).    %% 幻化激活
-define(REASON_relic_illusion_up_star, 11507).   %% 幻化升星
-define(REASON_relic_album_up_level, 11508).     %% 相册升级
-define(REASON_relic_break, 11509).             %% 圣物突破
-define(REASON_relic_add_repeat, 11510).         %% 圣物重复激活
-define(REASON_relic_reset_awaken_level, 11511).         %% 圣物重置觉醒技能
-define(REASON_relic_illusion_rein, 11512).         %% 圣物幻化 转生
-define(REASON_relic_illusion_up_star_add_item, 11513). %% 圣物幻化 升星道具返还
%% 116 捐赠抽奖
-define(Reason_DonateRoulette_Donate, 11601).    %% 捐赠
-define(Reason_DonateRoulette_Reward, 11602).    %% 领奖
-define(Reason_DonateRoulette_Mail, 11603).      %% 奖励补发

%% 117 时装
-define(Reason_DressUp_FashionActive, 11701).    %% 时装激活
-define(Reason_DressUp_FashionAddStar, 11702).    %% 时装升星
-define(Reason_DressUp_FashionDyeing, 11703).      %% 时装染色
-define(Reason_DressUp_AppearanceChange, 11704).      %% 外观变更
-define(Reason_DressUp_FashionReturn, 11705).      %% 时装道具重复激活返还

%% 118 服务器等级封印
-define(Reason_ServerSealExp, 11801).    %% 经验溢出获得
-define(Reason_ServerSealHonorLv, 11802).    %% 封印之证等级提升
-define(Reason_ServerSealBreak, 11803).    %% 封印突破
-define(Reason_ServerSealContestAward, 11804).    %% 封印比拼结算
-define(Reason_ServerSealContestPersonalAward, 11805).    %% 封印比拼丰碑奖励

%% 119 悬赏活动
-define(Reason_Wanted, 11901).    %% 悬赏活动

%% 120 法阵符文
-define(Reason_Fazhen_BreakDown, 12001). %% 法阵分解
-define(Reason_FazhenRune_BreakDown, 12002). %% 符文分解
-define(Reason_Fazhen_Add_Star, 12003). %% 法阵升星
-define(Reason_FazhenRune_Add_Lv, 12004). %% 符文升级
-define(Reason_FazhenRune_Add_Star, 12005). %% 符文升星
-define(Reason_Fazhen_Off, 12006). %% 法阵卸下
-define(Reason_Fazhen_On, 12007). %% 法阵装备

%% 121 职业塔
-define(Reason_CareerTowerLayer, 12101).    %% 职业塔挑战
-define(Reason_CareerTowerReward, 12102).    %% 职业塔阶段挑战
-define(Reason_CareerTowerSettleReward, 12103).    %% 职业塔结算奖励
-define(Reason_CareerTowerFirstKill, 12104).    %% 职业塔首杀领奖
-define(Reason_CareerTowerSuperFirstKill, 12105).    %% 超级塔首杀领奖
-define(Reason_CareerTowerSuperFirstKillRegBag, 12106).    %% 超级塔首杀红包
-define(Reason_CareerTowerSuperFirstKillTitle, 12107).    %% 超级塔首杀称号

%% 122 远征猎魔
-define(Reason_HUNT_CHALLENGE, 12200).                %% 猎魔战斗结算
-define(Reason_HUNT_SWEEP, 12201).                %% 猎魔扫荡
-define(Reason_HUNT_BOSS, 12202).                %% 猎魔BOSS

%% 123 远征功勋
-define(Reason_TEAM_SCORE_REWARD, 12301).            %% 小队积分奖励
-define(Reason_NOBILITY_SALARY, 12302).            %% 爵位工资
-define(Reason_FORCE_EXPEDITION, 12303).            %% 强征

%% 124 远征
-define(Reason_EXPWDITION_BUY_ENERGY, 12401).                %% 远征购买体力
-define(Reason_EXPWDITION_GET_AWARD, 12402).                %% 远征领奖
-define(Reason_EXPWDITION_GATHER_AWARD, 12403).                %% 集结奖励
-define(Reason_EXPWDITION_EXPLORE, 12404).                %% 探险奖励
-define(Reason_EXPWDITION_CARD, 12405).                %% 远征图鉴
-define(Reason_EXPWDITION_PlayerFight, 12406).         %% 远征PK
-define(Reason_EXPWDITION_BossDead, 12407).         %% 远征击杀boss
-define(Reason_EXPWDITION_CitySettle, 12408).         %% 远征攻城略地结算
-define(Reason_EXPWDITION_NoteTask, 12409).         %% 远征令牌任务
-define(Reason_EXPWDITION_Hunt, 12410).         %% 远征猎魔

%% 125 蓝钻祈福
-define(Reason_GreenBless, 12501).         %% 绿钻祈福
-define(Reason_GreenBlessFree, 12502).         %% 每日占卜

%% 126 公会副本
-define(Reason_GuildInsZonesKillBoss, 12601).    %% 击杀进度关BOSS奖励
-define(Reason_GuildInsZonesDailyProgress, 12602).    %% 每日进度奖励
-define(Reason_GuildInsZonesWelfare, 12603).    %% 福利关通关奖励
-define(Reason_GuildInsZonesPassNode, 12604).    %% 通关奖励

%% 宠物--new
-define(REASON_pet_wash, 12701).    %% 宠物洗髓
-define(REASON_pet_return, 12702).    %% 宠物回退
-define(REASON_pet_Substitute, 12703).    %% 宠物置换
-define(Reason_PetEqAndStar_EqSkillReset, 12704). %% 宠物装备技能重置
-define(Reason_PetCancelLink, 12705). %% 宠物取消链接
-define(Reason_PetCancelAppendage, 12706). %% 宠物取消附灵
-define(REASON_pet_draw, 12707).    %% 宠物抽奖
-define(REASON_pet_draw_switch_element, 12708).    %% 宠物抽奖切换限定元素
-define(REASON_pet_draw_score, 12709).    %% 宠物抽奖积分领奖
-define(REASON_pet_draw_normal_one, 12710).    %% 宠物普通抽奖单次
-define(REASON_pet_draw_high_one, 12711).    %% 宠物高级抽奖单次
-define(REASON_pet_draw_high_five, 12712).    %% 宠物高级抽奖五次
-define(REASON_pet_hatch2Active, 12713).    %% 二期孵蛋龙晶
-define(REASON_pet_draw_normal_ten, 12714).    %% 宠物普通抽奖十次
-define(REASON_PetShengShu_UnlockPos, 12715).    %% 宠物圣树解锁栏位
-define(REASON_PetShengShu_ResetCD, 12716).    %% 宠物圣树重置cd
-define(REASON_Pet_MainTask, 12717).    %% 主线任务删除假道具
-define(REASON_Pet_Shengshu_PosLv, 12718).    %% 圣树二期入驻位升级
-define(REASON_Pet_BlessEqCast, 12719).      %%宠物装备祝福消耗
-define(REASON_pet_city_research, 12720).    %% 英雄国度研究升级
-define(REASON_pet_city_call, 12721).    %% 英雄国度次元召唤
-define(REASON_pet_city_alter_coin, 12722).    %% 英雄国度星光祭坛领取家园币
-define(REASON_pet_city_make_equip, 12723).    %% 英雄国度装备打造
-define(REASON_pet_city_pray, 12724).    %% 英雄国度祈愿
-define(REASON_pet_city_build_lv, 12725).    %% 英雄国度升级建筑
-define(REASON_pet_city_build_lv_quick, 12726).    %% 英雄国度快速升级建筑
-define(REASON_pet_city_task, 12727).    %% 英雄国度完成任务
-define(REASON_Pet_Shengshu_PosLvBack, 12728).    %% 圣树二期入驻位升级回退
-define(REASON_Pet_Bless_soul_on, 12729).    %% 宠物装备 魂石装配
-define(REASON_Pet_Bless_soul_off, 12730).    %% 宠物装备 魂石卸下
-define(REASON_Pet_AtlasActiveReward, 12731).    %%英雄图鉴 激活奖励
-define(REASON_pet_draw_normal_fifty, 12732).    %% 宠物普通抽奖五十次
-define(REASON_pet_draw_high_twenty, 12733).    %% 宠物高级抽奖二十次
-define(REASON_pet_cultivation_transfer, 12734).    %% 英雄养成转移
-define(REASON_pet_city_quick_pray, 12735).      %%英雄国度，使用道具加速祈愿
-define(REASON_pet_pos_active, 12736). %% 出战位激活消耗
-define(REASON_pet_draw_unknown_one, 12737).    %% 未知抽奖单次
-define(REASON_pet_draw_unknown_ten, 12738).    %% 未知抽奖单次
-define(REASON_pet_draw_unknown_fifty, 12739).    %% 未知抽奖单次
-define(REASON_pet_SubstituteReturnItem, 12740).    %% 宠物置换 返还高级材料
-define(REASON_Pet_CultivationReplace, 12742).  %% 英雄 无损替换 返回养成材料

%% 翅膀副本
-define(Reason_DungeonsWing_Settle, 12801). %% 翅膀副本结算
-define(REASON_DungeonsWing_Shop, 12802). %% 翅膀副本商店
-define(REASON_DungeonsWing_MopUp, 12803). %% 翅膀副本扫荡

%% 129 黄金bp
-define(Reason_Pantheon_GetReward, 12901).        %% 领奖
-define(Reason_Pantheon_MailSend, 12902).        %% 邮件补发

%% 130 回归
-define(Reason_Return_GetAward, 13001).            %% 领奖
-define(Reason_Return_MailSend, 13002).            %% 邮件补发

%% 131 转生bp
-define(Reason_ReinBp_GetAward, 13101).            %% 领奖
-define(Reason_ReinBp_BuyScore, 13102).            %% 购买积分
-define(Reason_ReinBp_MailSend, 13103).            %% 邮件补发
-define(Reason_ReinBp_CfgUpd, 13104).              %% 配置修改邮件补发

%% 132 通用bp
-define(Reason_CommonBp_GetAward, 13201).        %% 通用bp领奖
-define(Reason_CommonBp_BuyScore, 13202).        %% 通用bp购买积分
-define(Reason_CommonBp_GetAwardMail, 13203).        %% 通用bp领奖补发

%% 133 联服公会战
-define(Reason_GuildWar_PersonRank, 13301).        %% 个人排名奖励
-define(Reason_GuildWar_BetUse, 13302).            %% 竞猜消耗
-define(Reason_GuildWar_BetGet, 13303).            %% 竞猜获得
-define(Reason_GuildWar_InspireCost, 13304).    %% 鼓舞消耗
-define(Reason_GuildWar_InspireBack, 13305).    %% 鼓舞失败返还
-define(Reason_GuildWar_StageAward, 13306).        %% 阶段奖励
-define(Reason_GuildWar_Compensate, 13307).        %% 补偿
-define(Reason_GuildWar_GuildRank, 13308).      %% 公会排名

%% 134 熔岩角斗场
-define(Reason_LavaFight_BoxAward, 13401).      %% 宝箱获得
-define(Reason_LavaFight_FirstWin, 13402).      %% 首次通关奖励
-define(Reason_LavaFight_Settle, 13403).        %% 结算奖励
-define(Reason_LavaFight_MopUp, 13404).         %% 扫荡消耗

%% 135 英雄圣装
-define(Reason_SacredEq_Int, 13501).         %% 强化消耗
-define(Reason_SacredEq_Break, 13502).       %% 升阶消耗
-define(Reason_SacredEq_Cast, 13503).        %% 祝福消耗
-define(Reason_SacredEq_Fade, 13504).        %% 分解消耗
-define(Reason_SacredEq_FadeDouble, 13505).  %% 分解双倍消耗
-define(Reason_SacredEq_Inherit, 13506).  %% 继承等级和阶数
-define(Reason_SacredEq_SyntheticError, 13507).  %% 未使用挽回道具，合成失败返回升阶升级道具

%% 136 结婚
-define(Reason_wedding_invite, 13601).  %% 结婚邀请
-define(Reason_wedding_booking, 13602).  %% 婚礼预定
-define(Reason_wedding_change_booking, 13603).  %% 修改预定
-define(Reason_wedding_booking_return, 13604).  %% 婚礼异常取消返还
-define(Reason_wedding_awards, 13605).  %% 婚礼完成奖励
-define(Reason_wedding_exp, 13606).     %% 婚礼宴席获得经验
-define(Reason_wedding_collect_awards, 13607).     %% 婚宴奖励
-define(Reason_wedding_send_gift, 13608).     %% 赠送贺礼
-define(Reason_wedding_gift, 13609).    %% 赠送贺礼奖励
-define(Reason_wedding_danmaku, 13610).    %% 发送弹幕消耗
-define(Reason_wedding_send_envelope, 13611).    %% 发送红包
-define(Reason_wedding_get_envelope, 13612).    %% 抢红包
-define(Reason_wedding_divorce, 13613).    %% 离婚
-define(Reason_wedding_divorce_ret, 13614).    %% 离婚返还
-define(Reason_wedding_envelope_award, 13615).    %% 发送红包奖励
-define(Reason_wedding_invitation_user, 13616).     %% 使用请柬增加邀请次数

%% 137 结婚基金
-define(Reason_WeddingCard_GetAward, 13701).        %% 领奖
-define(Reason_WeddingCard_MailSend, 13702).        %% 补发
-define(Reason_WeddingCard_DirectBuy, 13703).       %% 直购

%% 138 Lottery
-define(Reason_Lottery_Draw, 13801).        %% 开奖
-define(Reason_EntityLottery_Draw, 13811).        %% 开奖
-define(Reason_SkinLottery_Draw, 13812).        %% 开奖

%% 139 称号
-define(Reason_Title_expire, 13901).       %% 称号 过期
-define(Reason_Title_replace, 13902).       %% 称号被顶替

%% 140 排行榜
-define(Reason_Top_BroadcastAward, 14001).       %% 播报阅读奖励

%% 141 寒风森林
-define(Reason_BlzForest_TransCost, 14101).      %% 寒风森林传送消耗
-define(Reason_BlzForest_FlyNpcCost, 14102).      %% 寒风森林传送NPC消耗
-define(Reason_BlzForest_BossDrop, 14103).      %% 寒风森林Boss掉落

%% 142 英雄幻化
-define(Reason_Pet_Illusion_Activity, 14201).    %%英雄幻化 激活英雄幻化
-define(Reason_Pet_Illusion_Refine, 14202).    %%英雄幻化 精炼 消耗幻化道具升级
-define(Reason_Pet_Illusion_Collect, 14203).    %%英雄幻化 收藏室 消耗幻化道具升级

%% 143 龙城争霸
-define(Reason_ManorWar_BidCost, 14301).            %% 竞标消耗
-define(Reason_ManorWar_BidFailedRet, 14302).       %% 竞标操作失败返还
-define(Reason_ManorWar_BidLimitRet, 14303).        %% 竞标被其他战盟超过返还
-define(Reason_ManorWar_BidChangeRet, 14304).       %% 竞标被同公会改价返还
-define(Reason_ManorWar_PersonalAward, 14305).      %% 结算个人奖励
-define(Reason_ManorWar_RankAward, 14306).          %% 结算排名奖励
-define(Reason_ManorWar_DailyAward, 14307).         %% 每日领取奖励
-define(Reason_ManorWar_InspireCost, 14308).        %% 鼓舞消耗
-define(Reason_ManorWar_InspireFailedRet, 14309).   %% 鼓舞失败返还
-define(Reason_ManorWar_StageAward, 14310).         %% 阶段奖励
-define(Reason_ManorWar_ResetReturn, 14311).        %% 重置返还
-define(Reason_ManorWar_ResetCompensate, 14312).    %% 重置补偿


%% 145 情侣试炼
-define(Reason_CpTrial_SettleDungeon, 14501).       %% 副本结算奖励
-define(Reason_CpTrial_SettleRank, 14502).          %% 排行结算奖励

%% 146 装备副本排行
-define(Reason_TeamEq_SettleRank, 14601).           %% 排行结算

-endif.        %% -ifndef
