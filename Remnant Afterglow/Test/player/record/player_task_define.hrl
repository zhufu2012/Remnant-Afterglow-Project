%%%-------------------------------------------------------------------
%%% @author tang
%%% @copyright (C) 2018, Double Game
%%% @doc application
%%% @end
%%% Created : 2018-09-11
%%%-------------------------------------------------------------------

%% 任务类型
-define(Task_Type_Main, 0).              %% 0主线
-define(Task_Type_Daily, 1).             %% 1日常	% todo 废弃
-define(Task_Type_Branch, 2).            %% 2支线
-define(Task_Type_Guild, 3).             %% 3仙盟	% todo 废弃
-define(Task_Type_Holiday, 4).           %% 4节日	% todo 未使用
-define(Task_Type_Activity, 5).          %% 5活动	% todo 未使用
-define(Task_Type_Bounty, 6).            %% 6赏金
-define(Task_Type_GuildTask, 7).         %% 7战盟周环
-define(Task_Type_Reincarnate, 8).         %% 8 转生任务
-define(Task_Type_Role, 9).              %% 9 角色任务
-define(Task_Type_DestinyGuard, 10).              %% 10 天命守护任务

%% 主线目标类型
-define(Task_Goal_Dialog, 0).        %% 0为对话
-define(Task_Goal_Monster, 1).        %% 1为杀怪
-define(Task_Goal_Dungeon, 2).        %% 2为移动+副本(到指定地点进入副本)
-define(Task_Goal_Item, 3).            %% 3为打怪收集
-define(Task_Goal_Discovery, 4).        %% 4为探索
-define(Task_Goal_Level, 5).            %% 5为主角等级
-define(Task_Goal_Scene, 6).            %% 6为播放剧情动画
-define(Task_Goal_Guide, 7).            %% 7为引导任务
-define(Task_Goal_Transmit, 8).        %% 8为传送任务
-define(Task_Goal_DialogDungeon, 9).    %% 9为对话+副本(与NPC对话进入副本)
-define(Task_Goal_DialogGuide, 10).     %% 10为自动弹奖励的引导任务
-define(Task_Goal_DialogDiscovery, 11). %% 11为对话＋探索
-define(Task_Goal_CompleteDungeon, 12).    %% 12为副本(直接进入副本)(前端可更新进度)
-define(Task_Goal_OpenWindow, 13).      %% 13为打开界面(前端更新进度)
-define(Task_Goal_ClientDungeonSuccess, 15).      %% 15 通关该关卡所需要通关的副本
-define(Task_Goal_ClientDungeonSuccessEx, 16).      %% 16 通关该关卡所需要通关的副本(和15相同，但是客户端有特殊处理，需要区分)
-define(Task_Goal_SubItem, 74).         %% 74提交物品
-define(Task_Goal_FateStar, 75).        %% 75点亮命星
-define(Task_Goal_DragonSpirit, 76).    %% 76点亮龙魂
-define(Task_Goal_Element, 77).         %% 77点亮元素
-define(Task_Goal_DragonCristal, 78).   %% 78点亮龙魂水晶
-define(Task_Goal_DemonSource, 79).     %% 79点亮魔源
-define(Task_Goal_MagicFire, 80).       %% 80点亮神火

-define(Task_Goal_WingLv, 103).                        %% 翅膀升级			103	将{0}个翅膀强化到{1}级
-define(Task_Goal_WingSublimate, 106).                %% 翅膀炼魂			106	将{0}个翅膀炼魂到{1}级
-define(Task_Goal_YilingLv, 108).                    %% 翅膀翼灵			108	翼灵升到{0}级
-define(Task_Goal_WingCount, 110).                    %% 翅膀激活			110	激活{0}个{1}品质翅膀
-define(Task_Goal_MountLv, 112).                    %% 坐骑升级			112	将{0}个坐骑强化到{1}级
-define(Task_Goal_MountSublimate, 115).                %% 坐骑炼魂			115	将{0}个坐骑炼魂到{1}级
-define(Task_Goal_ShoulingLv, 117).                    %% 坐骑兽灵			117	兽灵升到{0}级
-define(Task_Goal_MountCount, 118).                    %% 坐骑激活			118	激活{0}个坐骑
-define(Task_Goal_PetLv, 119).                        %% 魔宠升级			119	将{0}个宠物强化到{1}级
-define(Task_Goal_PetSublimate, 122).                %% 魔宠炼魂			122	将{0}个宠物炼魂到{1}级
-define(Task_Goal_MolingLv, 124).                    %% 魔宠魔灵			124	魔灵升到{0}级
-define(Task_Goal_PetCount, 125).                    %% 魔宠激活			125	图鉴激活{0}个宠物
-define(Task_Goal_EqIntensify, 126).                %% 装备强化			126	将{0}件装备强化到{1}级
-define(Task_Goal_EqAdd, 127).                        %% 装备追加			127	将{0}件装备追加到{1}级
-define(Task_Goal_EqRefine, 128).                    %% 装备洗炼			128	一件装备洗练出{0}条以上{1}品质属性
-define(Task_Goal_EqGem, 129).                        %% 装备镶嵌			129	镶嵌{0}个{1}级宝石
-define(Task_Goal_GemRefine, 130).                    %% 装备精炼			130	将{0}个部位的宝石精炼到{1}级
-define(Task_Goal_EqSuit, 131).                        %% 装备套装			131	打造{0}件{1}阶{2}类型的{3}套装
-define(Task_Goal_EqWear, 132).                        %% 装备穿戴			132	首次穿戴{1}的{2}星装备
-define(Task_Goal_HolyLv, 134).                        %% 圣物升级			134	将{0}个圣物强化到{1}级
-define(Task_Goal_HolyCount, 138).                    %% 圣物激活			138	激活{0}个圣物
-define(Task_Goal_ShenglingLv, 139).                %% 圣物圣灵			139	将{0}个圣灵强化到{1}级
-define(Task_Goal_GDMainCount, 140).                %% 龙神唤醒			140	激活{0}个龙神
-define(Task_Goal_GDMainLv, 141).                    %% 龙神升阶			141	将{0}个龙神强化到{1}阶
-define(Task_Goal_GDElfCount, 143).                    %% 精灵龙神激活		143	激活{0}个精灵龙神
-define(Task_Goal_GDElfLv, 144).                    %% 精灵龙神升阶		144	将{0}个精灵龙神强化到{1}阶
-define(Task_Goal_GDWeaponCount, 146).                %% 龙神武器激活		146	激活{0}个龙神武器
-define(Task_Goal_GDConsCount, 148).                %% 龙神秘典激活		148	激活{0}个龙神秘典
-define(Task_Goal_GDConsLv, 149).                    %% 龙神秘典觉醒		149	将{0}个龙神秘典觉醒到{1}级
-define(Task_Goal_RuneCount, 150).                    %% 龙印装配	 		150	镶嵌{0}个{1}级龙印
-define(Task_Goal_RuneIntLv, 151).                    %% 龙印升级	 		151	将{0}个龙印强化到{1}级
-define(Task_Goal_SoulIntLv, 155).                    %% 聚魂升级	 		155	将{0}个聚魂强化到{1}级
%%-define(Task_Goal_SoulSyn, 156).					%% 聚魂升级	 		156	成功合成{0}的聚魂 -------------
-define(Task_Goal_CardActive, 158).                    %% 镶嵌卡片	 		158	镶嵌X张卡片
-define(Task_Goal_AstroEqInt, 165).                    %% 神祇装备强化		165	将神祇装备强化到{0}级
-define(Task_Goal_AstroCount, 166).                    %% 激活神祇	 		166	已激活{0}个神祇
-define(Task_Goal_PagodaLv, 168).                    %% 龙神塔层数		 	168	龙神塔通关层数达到{0}层
-define(Task_Goal_DungeonPetCount, 169).            %% 通关宠物副本		169	{0}次{2}星通关{1}副本
-define(Task_Goal_DungeonMountCount, 170).          %% 通关坐骑副本		170	{0}次{2}星通关{1}副本
-define(Task_Goal_DungeonWingCount, 171).           %% 通关翅膀副本		171	{0}次通关{1}副本(OB+4)
-define(Task_Goal_DungeonGDCount, 172).             %% 通关龙神材料本		172	{0}次{2}星通关{1}副本
-define(Task_Goal_DungeonHolyCount, 173).           %% 圣物副本	 		173	{0}次{2}星通关{1}副本
-define(Task_Goal_DungeonGDConsCount, 174).         %% 通关龙神秘典副本	174	{0}次{2}星通关{1}副本
-define(Task_Goal_DungeonPreDepositsCount, 175).    %% 通关矮人宝藏		175	{0}次{2}星通关{1}副本
-define(Task_Goal_DungeonDepositsCount, 176).        %% 通关精灵宝库		176	{0}次通关{1}副本
-define(Task_Goal_ArenaWinCount, 177).                %% 竞技场胜利			177	在竞技场中胜利{0}次
-define(Task_Goal_DungeonDragonConsum, 180).        %% 通关龙王宝库		180	{0}次{2}星通关{1}副本
-define(Task_Goal_WalkDemonTower, 181).                %% 埋骨之地建塔		181	在埋骨之地中建造{0}座{1}塔
-define(Task_Goal_GuildTaskCount, 193).                %% 战盟周环任务		193	累计完成{0}次战盟任务
-define(Task_Goal_BountyTaskCount, 203).            %% 赏金任务	 		203	完成{0}个赏金任务
-define(Task_Goal_HonorLv, 205).                    %% 头衔等级			205	达到{0}头衔
-define(Task_Goal_FriendsCount, 206).                %% 好友数	 		206	拥有亲密度等级≥{1}的好友{0}个
-define(Task_Goal_DemonSquare, 207).                %% 恶魔广场完成次数	207	完成恶魔广场{0}次
-define(Task_Goal_DemonsInvasionBoss, 211).            %% 恶魔入侵	 		211	恶魔入侵击杀BOSS{0}个
-define(Task_Goal_PersonalBoss, 212).                %% 个人恶魔	 		212	个人恶魔完成{0}次
-define(Task_Goal_CursePlaceBoss, 214).                %% 恶魔禁地	 		214	恶魔禁地击杀BOSS{0}个
-define(Task_Goal_ShenmoBoss, 215).                    %% 神魔战场	 		215	战神殿击杀BOSS{0}个
-define(Task_Goal_ShenmoLinkedBoss, 216).            %% 神魔战场（联服）	216	战神殿（联服）击杀BOSS{0}个	todo 还没做
-define(Task_Goal_DailyTaskActivity, 219).            %% 日常				219	日常活跃度超过{0}
-define(Task_Goal_AlchemyLv, 221).                    %% 炼金				221	炼金{0}级
-define(Task_Goal_PetEqCount, 222).                    %% 魔宠装备	 		222	装备{0}件{1}品质魔宠装备
-define(Task_Goal_MountEqCount, 223).                %% 坐骑装备	 		223	装备{0}件{1}品质坐骑装备
-define(Task_Goal_WingEqCount, 224).                %% 翅膀装备	 		224	装备{0}件{1}品质翅膀装备
-define(Task_Goal_JoinGuild, 225).                    %% 加入战盟	 		225	加入战盟
-define(Task_Goal_SkillLv, 229).                    %% 技能				229 {0}个技能达到{1}级
-define(Task_Goal_PatchDLAward, 230).               %% 分包下载          230 领取分包下载奖励
-define(Task_Goal_QuickHangAward, 231).             %% 快速挂机          231 领取{0}次快速挂机奖励
-define(Task_Goal_ReadMail, 232).             %% 阅读信件          232
-define(Task_Goal_MiniGame, 233).             %% 小游戏          233

-define(Task_Goal_EqRequire, 1003).                    %% 装备要求			1003 人物全身{0}件{1}或者{2}阶{3}品质{4}星以上装备任务完成
-define(Task_Goal_BossSlayer, 1004).                %% 击杀boss			1004 击杀打宝玩法的{0}只{1}级以上boss (包括:恶魔入侵boss,个人恶魔boss,恶魔禁地boss,战神殿boss)
-define(Task_Goal_SoulEq, 1005).                    %% 聚魂装配			1005 装配{0}个聚魂
-define(Task_Goal_MopUp, 1006).                        %% 扫荡副本			1006 扫荡{0}次mapai为{1}order第一个字段为{2}的副本
-define(Task_Goal_BattleValue, 1007).                %% 战力突破			1007 将战力提升到{0}
-define(Task_Goal_HangExp, 1008).                    %% 挂机经验			1008 领取{0}次挂机经验
-define(Task_Goal_FriendsFlower, 1009).                %% 好友送花			1009 给好友赠送{0}次花
-define(Task_Goal_MCShip_Plunder, 1012).            %% 商船掠夺次数	    1012 商船拦截{0}次品质{1}及以上
-define(Task_Goal_Arti_Boss_id, 1013).                %% 个人boss	        1013 击杀对应{1}副本id {0} 次数
-define(Task_Goal_Level_seal, 1014).                %% 主角等级突破	        1014 突破封印{0} 等级达到{1}级
-define(Task_Goal_Client_Task1, 1017).                %% 转职 仪式	        1017  （前端推进任务）
-define(Task_Goal_Client_Task2, 1018).                %% 前端对话-移动-开UI-播剧情-结束	        1018  （前端推进任务）
-define(Task_Goal_Client_Task3, 1019).                %% 前端 对话+采集+小游戏	前端推进任务）

-define(Task_Goal_FeteGod, 1020).                   %% 战盟祭祀         1020 战盟祭祀{0}次
-define(Task_Goal_DragonBless, 1022).               %% 龙神钻石祈福      1022 完成钻石龙神祈福
-define(Task_Goal_ActiveCard, 1025).                %% 图鉴             1025 激活X个图鉴

-define(Task_Goal_Reputation, 1032).                %% 声望             1032 声望获得达到X   target_num：声望值
-define(Task_Goal_HelpBoss, 1033).                  %% 协助             1033 成功协助他人击杀BOSS  target_num：击杀boss数量
-define(Task_Goal_helpMcShop, 1034).                %% 商船             1034 帮助战盟成员夺回被抢商船   target_num：次数
-define(Task_Goal_worldBoss, 1035).                 %% 世界BOSS         1035 世界BOSS中击杀X个BOSS   target_num：击杀boss数量

-define(Task_goal_MainLineStars, 1040).             %% 主线副本 主线副本星数
-define(Task_goal_AwakenLoadGetAward, 1041).        %% 觉醒之路 领奖指定奖励
-define(Task_goal_AwakenLoadLight, 1042).           %% 觉醒之路 点亮属性x
-define(Task_goal_PetActive, 1044).                 %% 魔宠  1044 激活指定魔宠   target_num：1  target_num1：魔宠id
-define(Task_goal_DG_EquipStatue, 1045).            %% 龙神雕像  1045 镶嵌龙神雕像   target_num：数量


-define(Task_Goal_CommitCoin, 2001). %% 2001提交货币   target_num：数量  target_num1: 货币ID
-define(Task_Goal_SkillLv2, 2002). %% 2002指定数量技能升级到指定等级   target_num：技能数量  target_num1: 目标等级
-define(Task_Goal_GuardNum, 2003). %% 2003激活指定守护   target_num：守护数量 target_num1：守护ID
-define(Task_Goal_DragonJewelryNum, 2004). %% 2004穿戴龙饰   target_num：穿戴数量
-define(Task_Goal_ClientDungeonPass, 2005). %% 2005主线副本进度   target_num：完成目标主线副本id
-define(Task_Goal_MountDungeonCount, 2006). %% 2006坐骑副本完成XX次     target_num：完成次数
-define(Task_Goal_HelpCount, 2007). %% 2007协助次数到达XX次     target_num：完成次数
-define(Task_Goal_WingDungeonCount, 2008). %% 2008翅膀副本完成XX次     target_num：完成次数
-define(Task_Goal_CommitItem, 2009). %% 2009提交道具   target_num：数量  target_num1: 道具ID
-define(Task_Goal_DragonDungeonCount, 2010). %% 2010龙神副本完成XX次     target_num：完成次数
-define(Task_Goal_XoRoomCount, 2012). %% 2012XO大作战     target_num：完成次数"
-define(Task_Goal_BuySkillBook, 2013). %% 	购买指定技能书 target_num1  技能位 target_num2 角色顺序
-define(Task_Goal_ActiveSkill, 2014). %% 	激活指定技能 target_num1  技能位 target_num2 角色顺序
-define(Task_Goal_TeamExpGuide, 2016). %% 	完成勇者试炼引导副本 target_num1 副本id
-define(Task_Goal_RoleSecond, 2017). %% 	创建第二职业
-define(Task_Goal_ActiveDragonStatue, 2018). %% 	激活龙神雕像  target_num1 道具id
-define(Task_Goal_DispatchBounty, 2019). %% 	派遣赏金任务（派遣即完成）
-define(Task_Goal_EquipGodOrnament, 2020). %% 	穿戴神饰
-define(Task_Goal_RoleThird, 2021). %% 	创建第三职业
-define(Task_Goal_DungeonPet, 2022). %% 	通关魔宠试炼副本
-define(Task_Goal_MountActive, 2023).   %% 指定坐骑激活
-define(Task_Goal_WingActive, 2024).    %% 指定翅膀激活
-define(Task_Goal_DragonActive, 2026).  %% 指定龙神激活
-define(Task_Goal_DragonPartActive, 2027).  %% 指定龙晶激活
-define(Task_Goal_RoleActiveSkill, 2028).  %% 激活指定技能组 target_num：数量  target_num1/2/3/4: 技能位
-define(Task_Goal_DungeonPharaoh, 2029). %% 	通关法老宝库 target_num：完成次数
-define(Task_Goal_BuyGodOrnament, 2030). %% 	购买神饰
-define(Task_Goal_EliteDungeonOpen, 2031). %% 	领取精英副本解锁奖励
-define(Task_Goal_EliteDungeonChallenge, 2032). %% 	挑战精英副本
-define(Task_Goal_EliteDungeonStarNum, 2033). %% 	精英副本星数奖励
-define(Task_Goal_ProphecyNum, 2034). %% 	神谕完成奖励
-define(Task_Goal_RoleGuard, 2035). %% 	激活指定角色守护
-define(Task_Goal_BuyItem, 2036).        %% 	购买商城指定物品
-define(Task_Goal_GuideTask, 2037).        %% 	完成指定引导
-define(Task_Goal_GuildFeteHigh, 2038).        %% 	战盟高级捐献次数
-define(Task_Goal_GuildDrinkHigh, 2039).        %% 	战盟晚宴龙火辣酒次数
-define(Task_Goal_McShip, 2040).             %% 派遣商船 target_num1:商船品质（0白1蓝2紫3橙4红）
-define(Task_Goal_ArenaJoin, 2041).             %% 竞技场参与次数
-define(Task_Goal_RelicLevel, 2042).        %% 圣物升级 target_num1:等级
-define(Task_Goal_DailyTaskAward, 2043).     %%  领取指定日常任务奖励     target_num1:DailyActivityNew表ID
-define(Task_Goal_LoginAward, 2044).     %%  领取指定登录奖励     target_num1:LoginRewardNew表ID
-define(Task_Goal_Equip, 2045).             %%  穿戴装备 target_num1:装备部位 target_num2:装备品质 target_num3:星级 target_num4：角色顺序
-define(Task_Goal_Pill, 2046).             %%  磕丹 target_num1:磕丹ID
-define(Task_Goal_EnterEliteDungeon, 2047).     %%  进入精英副本 target_num1:精英副本ID
-define(Task_Goal_EqIntensifyAny, 2048).     %%  任意装备强化一次
-define(Task_Goal_GDMainLvTrue, 2049).     %%  %% 龙神升级	将{0}个龙神强化到{1}级
-define(Task_Goal_EnterDungeon, 2050).     %% 进入副本	  进入对应{1}副本id {0} 次数
-define(Task_Goal_TargetSkillLv, 2051).     %% 指定技能等级	  target_num1:技能位 target_num2:角色顺序 target_num3:目标等级
-define(Task_Goal_LevelSealDungeon, 2052).     %% 等级封印副本
-define(Task_Goal_LevelGift, 2053).     %% 玩家等级奖励
-define(Task_Goal_AccountBind, 2054).     %% 帐号绑定
-define(Task_Goal_TargetWorldBoss, 2055).     %% 击杀世界BOSS target_num1:BossID 0表示任意BOSS
-define(Task_Goal_MouthCardDailyGift, 2056).     %% 月卡每日赠礼
-define(Task_Goal_Roulette, 2057).     %% 寻宝 target_num1:寻宝ID
-define(Task_Goal_MountBreak, 2058).     %% 坐骑突破 target_num1:突破等级
-define(Task_Goal_MountStar, 2059).     %% 坐骑升星 target_num1:星数
-define(Task_Goal_MountAwaken, 2060).     %% 坐骑觉醒 target_num1:觉醒等级
-define(Task_Goal_BloodLv, 2061).     %% 血脉升级 target_num1:等级
-define(Task_Goal_ShopBuyItem, 2062).     %% 商店购买 target_num1:商店ID target_num2:序列 target_num3:位置为序列
-define(Task_Goal_EquipCard, 2063).     %% 镶嵌卡片 target_num1:等级 target_num2:品质 target_num3:部位
-define(Task_Goal_ChangeCareer, 2064).     %% 完成转职 target_num1:转职等级
-define(Task_Goal_MountSkillP, 2065).     %% 坐骑装配技能 target_num1:技能格子
-define(Task_Goal_RoleTask, 2066).     %% 角色任务接取 target_num1:任务ID
-define(Task_Goal_EquipGem, 2067).     %% 任一角色镶嵌宝石
-define(Task_Goal_CompleteDungeonNew, 2068).     %% 通关副本 target_num1:副本ID
-define(Task_Goal_BuyRelic, 2069).     %% 购买圣物
-define(Task_Goal_SevenGift, 2070).     %% 七日盛典领取奖励
-define(Task_Goal_CareerTowerMainLayer, 2071).     %% 职业主塔层数
-define(Task_Goal_CareerTowerMinorLayer, 2072).     %% XX副塔层数 target_num1:副塔编号
-define(Task_Goal_RuneXunBao, 2073).     %% 符文寻宝次数
-define(Task_Goal_RuneQualityNum, 2074).     %% 镶嵌符文数量 target_num1:品质
-define(Task_Goal_OperateGameHelper, 2075).     %% 运行小助手
-define(Task_Goal_AcceptTask, 2076).     %% 接取任务
-define(Task_Goal_CompleteTask, 2077).     %% 完成任务
-define(Task_Goal_EqIntensifyTotalLv, 2078).     %% 装备强化总等级
-define(Task_Goal_RoleChangeCareer, 2079).     %% 第X职业完成转职
-define(Task_Goal_PetStar, 2080).     %% 宠物星级 target_num1:星级
-define(Task_Goal_CareerTowerMaxMinorLayer, 2081). %% 职业副塔最高层数
-define(Task_Goal_MountAllLv, 2082). %% 坐骑升级总等级
-define(Task_Goal_EqNum, 2083). %% 角色装备数量(包括饰品) target_num1:阶数 target_num2:角色顺序 target_num3:品质，0白1蓝2紫3橙4红5粉6神,-1任意品质 target_num4:星数
-define(Task_Goal_RoleEqOrnamentNum, 2084). %% 角色饰品数量 target_num1:阶数 (角色ID) target_num3:品质，0白1蓝2紫3橙4红5粉6神,-1任意品质 target_num4:星数
-define(Task_Goal_RoleEqNum, 2085). %% 角色装备数量(包括饰品) target_num1:阶数 (角色ID) target_num3:品质，0白1蓝2紫3橙4红5粉6神,-1任意品质 target_num4:星数
-define(Task_Goal_PetReachStar, 2086). %% 将XX英雄进化到某星数 target_num1:英雄id
-define(Task_Goal_PetFightNum, 2087). %% 出战英雄数量
-define(Task_Goal_PetNormalDrawTime, 2089). %% 英雄普通抽奖次数
-define(Task_Goal_PetSeniorDrawTime, 2090). %% 英雄高级抽奖次数
-define(Task_Goal_PetStarCount, 2091). %% 英雄进化到指定星级的数量 target_num1:星级
-define(Task_Goal_ChangeCareerSkillNum, 2092). %% 将X个Y转职技能升级到Z级 target_num 数量 target_num1 等级 target_num2 转职数
-define(Task_Goal_MainLineCopyMapMopUpNum, 2093). %% 扫荡X次剧情本
-define(Task_Goal_ChooseDragonEgg, 2094). %% 选取龙蛋
-define(Task_Goal_DownloadResources, 2095). %% 资源下载完成
-define(Task_Goal_SkillUpTimes, 2096). %% 技能升级次数
-define(Task_Goal_PetFight, 2097). %% 上阵英雄XX target_num1:英雄id
-define(Task_Goal_PetActiveAndFightNum, 2098). %% 激活英雄XX且出战英雄数量达到N target_num1:英雄id target_num2:上阵数量
-define(Task_Goal_PetWashTime, 2099). %% 洗髓次数
-define(Task_Goal_Gold_Tower, 2100).    %%黄金魔塔层数
-define(Task_Goal_PetWashFull, 2101).    %%任意英雄完成 1 次四个资质洗髓达到满资质，	target_num:次数
-define(Task_Goal_PetBreakUp, 2102).    %%任意英雄完成 1 次洗髓突破，	target_num:次数
-define(Task_Goal_PetFightPosNum, 2103).    %%开启几号出战位，	target_num:出战位序号
-define(Task_Goal_PetFightPos, 2104).    %%在第几号出战位上上阵英雄，	target_num=1（表示上阵英雄）,	target_num1:出战位序号
-define(Task_Goal_PetAssistPosNum, 2105).    %%开启几号助战位，	target_num:助战位序号
-define(Task_Goal_PetAssistPos, 2106).    %%在第几号助战位上上阵英雄，	target_num=1（表示上阵英雄），	target_num1:助战位序号
-define(Task_Goal_BoneYardPass, 2107). %% 通关埋骨之地x次 target_num:次数 target_num1:关卡id
-define(Task_Goal_FaZhenActiveNum, 2108).    %%	激活X个法阵
-define(Task_Goal_FaZhenRuneNum, 2109).        %%	上阵X个符文
-define(Task_Goal_Pet_TenDrawNum, 2110).        %% 英雄抽奖普通十连抽,大于10抽，也算10抽
-define(Task_Goal_Collection_Eq, 2111).         %% 收藏X个部位X阶XX品质以上装备
-define(Task_Goal_LavaFightTimes, 2115).        %% 完成X次熔岩角斗场Y层
-define(Task_Goal_MarryClick, 2124).            %% 查看结婚功能
-define(Task_Goal_PetSacred_Eq, 2116).            %% 穿戴X个A阶B品质C星级及以上的英雄圣装
-define(Task_Goal_ElementContinentJoin, 2117).            %% 参与元素大陆 target_num:次数

-define(Task_Goal_ShengJiaLight, 2119).            %%点亮一次神甲 target_num1:次数
-define(Task_Goal_ShengJiaEqGemCount, 2120).            %%神甲中，镶嵌{0}个{1}级元素宝石  target_num:个数target_num1:等级
-define(Task_Goal_ShengWenCount, 2118).            %%穿戴 X件 Y阶Z品质及以上的神纹
-define(Task_Goal_TeamEqPass, 2121).        %%参与一次组队装备本
-define(Task_Goal_TeamCouplePass, 2122).    %%参与一次情侣本
-define(Task_Goal_ActiveRingNum, 2123).        %%解锁X个信物%% 转职任务红点枚举

-define(Task_Goal_PetUnknownDrawTime, 2125).            %%未知召唤10连抽 次数不足10连(没道具直接过)，抽奖也过
-define(Task_Goal_PetTypeCount, 2126).        %%	target_num为英雄上阵的数量；target_num1为对应的品质需求

%% 表示接取该任务后进行一次英雄升级  target_num固定为1 如果判断玩家身上没有经验书道具或者已解锁出战位的英雄都无法突破的情况就直接完成
%%有经验道具，满足使用条件，用了就算完成，不管升不升级
-define(Task_Goal_PetFinishTaskUpLv, 2127).
-define(Task_Goal_PetShengShuPos, 2128).%% 	圣树格子解锁 target_num1 就是入驻位id target_num为1

%% 转职任务红点枚举
-define(Task_red_point_1, 1).        %% 参与法老宝库
-define(Task_red_point_2, 2).        %% 击杀世界boss
-define(Task_red_point_3, 3).        %% 护送商船

%% 任务进度
-record(task_progress, {
	task_id = 0,        % 任务id
	update_flag = 0,    % 是否更新进度
	next_flag = 0,        % 是否在任务线内
	pre_flag = 0,        % 是否完成前置任务
	progress = 0        % 进度
}).


-define(ConditionTask_1, 1). %% 英雄召唤功能开启、且第一次以道具足够的形式满足十连抽
-define(ConditionTask_2, 2). %% 达到几转生
-define(ConditionTask_3, 3). %% 功能开启
