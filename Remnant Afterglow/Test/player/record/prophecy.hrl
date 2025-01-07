%%%-------------------------------------------------------------------
%%% @author LFZ
%%% @copyright (C) 2021, DoubleGame
%%% @doc
%%% {{description}}
%%% @end
%%% Created : 07. 6月 2021 17:51
%%%-------------------------------------------------------------------
-author("LFZ").

-ifndef(prophecy_hrl).
-define(prophecy_hrl, true).

%%预言之书
-record(prophecy, {
	index = {0, 0},                    %% 索引 {角色ID，大类ID}
	role_id = 0,                    %% 角色ID
	book_id = 0,                    %% 大类ID
	book_progress = 0,                    %%任务进度
	book_complete = 0,                %%是否完成
	task_list = []                    %%任务列表
}).

%%预言之书任务
-record(prophecy_task, {
	task_id = 0,                    %% 任务ID
	task_progress = [],              %% 任务进度（仅用于同步前端 完成任务时实时检测）
	task_complete = 0                %% 是否完成
}).

-define(DB_PROPHECY, db_prophecy).


%% 对于boss检验的大类要求配置限定大类范围
-define(Prophecy1, 1).   %% 预言 大类1 时光预言
-define(Prophecy2, 2).   %% 预言 大类2 火焰预言
-define(Prophecy3, 3).   %% 预言 大类3 光明预言
-define(Prophecy4, 4).   %% 预言 大类4 黑暗预言
-define(Prophecy5, 5).   %% 预言 大类5 寒冰预言
-define(Prophecy6, 6).   %% 预言 大类6 天神预言
-define(Prophecy7, 7).   %% 预言 大类7 预言
-define(Prophecy8, 8).   %% 预言 大类8 预言

%% 当前boss大类
-define(ProphecyBossClass, ?Prophecy5).

-define(BookUnlockType_FirstRecharge, 1). %% 大类解锁条件类型1 首冲
-define(BookUnlockType_CompleteBook, 2). %% 大类解锁条件类型2 三角色均完成指定大类型
-define(BookUnlockType_ServerDay, 3). %% 大类解锁条件类型3 开服天数
-define(BookUnlockType_PlayerLevel, 4). %% 大类解锁条件类型4 玩家等级

-define(TaskType_Attr, 1). %% 任务类型1 属性
-define(TaskType_Equip, 2). %% 任务类型2 装备
-define(TaskType_EquipSuit, 3). %% 任务类型3 套装
-define(TaskType_Boss, 4). %% 任务类型4 击杀Boss

-define(TaskType_Other, 5). %% 任务类型5 杂项
-define(TaskType_Other_FirstRecharge, 1). %% 任务类型5 杂项 1 首充
-define(TaskType_Other_MouthCard, 2). %% 任务类型5 杂项 2 月卡
-define(TaskType_Other_VIP, 3). %% 任务类型5 杂项 3 VIP
-define(TaskType_Other_Fund, 4). %% 任务类型5 杂项 4 投资计划
-define(TaskType_Other_EquipGuard, 5). %% 任务类型5 杂项 5 佩戴守护
-define(TaskType_Other_ContinueRecharge, 6). %% 任务类型5 杂项 6 续充
-define(TaskType_Other_ForeverCard, 7). %% 任务类型5 杂项 7 终身卡
-define(TaskType_Other_MainTask, 8). %% 任务类型5 杂项 8 主线战令
-define(TaskType_Other_Drop, 9). %% 任务类型5 杂项 9 打宝战令
-define(TaskType_Other_Material, 10). %% 任务类型5 杂项 10 材料本战令
-define(TaskType_Other_DirectlyBuy, 11). %% 任务类型5 杂项 11 直购礼包
-define(TaskType_Other_BountyTaskSpecial, 12). %% 任务类型5 杂项 12 赏金特权
-define(TaskType_Other_FundsGrowth, 13). %% 任务类型5 杂项 13 成长基金
-define(TaskType_Other_VIPGift, 14). %% 任务类型5 杂项 14 VIP礼包
-define(TaskType_Other_FadeSpecial, 15). %% 任务类型5 杂项 15 吞噬特权
-define(TaskType_Other_AwakenRoadBp, 16). %% 任务类型5 杂项 16 觉醒之路战令
-define(TaskType_Other_MonthBuy, 17). %% 任务类型5 杂项 17 月理财

-define(TaskType_companion, 6). %% 任务类型6 养成伙伴
-define(TaskType_companion_Pet, 1). %% 任务类型6 养成伙伴 1 宠物
-define(TaskType_companion_Mount, 2). %% 任务类型6 养成伙伴 2 坐骑
-define(TaskType_companion_Wing, 3). %% 任务类型6 养成伙伴 3 翅膀
-define(TaskType_companion_Holy, 4). %% 任务类型6 养成伙伴 4 圣物
-define(TaskType_companion_MainDragonGod, 5). %% 任务类型6 养成伙伴 5 主战龙神
-define(TaskType_companion_ElfDragonGod, 6). %% 任务类型6 养成伙伴 6 精灵龙神
-define(TaskType_companion_DragonGodEquip, 7). %% 任务类型6 养成伙伴 7 龙神武器
-define(TaskType_companion_DragonGodBook, 8). %% 任务类型6 养成伙伴 8 龙神秘典

-define(TaskType_Skill, 7). %% 任务类型7 解锁技能

-define(TaskType_Play, 8). %% 任务类型8 玩法
-define(TaskType_Play_BountyTask, 1). %% 任务类型8 玩家 1 赏金任务
-define(TaskType_Play_ExpDungeon, 2). %% 任务类型8 玩家 2 勇者试炼
-define(TaskType_Play_QuickHang, 3). %% 任务类型8 玩家 3 快速讨伐
-define(TaskType_Play_WorldBoss, 4). %% 任务类型8 玩家 4 世界BOSS
-define(TaskType_Play_Demon, 5). %% 任务类型8 玩家 5 死亡地狱
-define(TaskType_Play_DeathForest, 6). %% 任务类型8 玩家 6 死亡森林
-define(TaskType_Play_Arena, 7). %% 任务类型8 玩家 7 竞技场
-define(TaskType_Play_MountDungeon, 8). %% 任务类型8 玩家 8 坐骑副本
-define(TaskType_Play_WingDungeon, 9). %% 任务类型8 玩家 9 翅膀副本
-define(TaskType_Play_HeroDungeon, 10). %% 任务类型8 玩家 10 英雄试炼扫荡
-define(TaskType_Play_MaterialDungeon, 11). %% 任务类型8 玩家 11 法老宝库
-define(TaskType_Play_DemonCM, 12). %% 任务类型8 玩家 12 诅咒禁地

-define(TaskType_Lv, 9). %% 任务类型9 等级达成

-endif. %% -ifndef
