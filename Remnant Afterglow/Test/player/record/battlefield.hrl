%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2014, haowan123
%%% @doc 三界战场
%%% @end
%%% Created : 2015-04-01 10:30
%%%-------------------------------------------------------------------
-ifndef(battlefield_hrl).
-define(battlefield_hrl, 1).

-include("global.hrl").

-export_type([
	battlefieldStateType/0,
	battlefieldDeadType/0
]).

-define(BattlefieldState_Idle, 0).             %% 空闲
-define(BattlefieldState_Open, 1).             %% 开启
-define(BattlefieldState_Monster, 2).          %% 刷怪
-type battlefieldStateType() :: ?BattlefieldState_Idle .. ?BattlefieldState_Monster.

-define(BattlefieldDeadType_KillPlayer, 1).         %% 杀死玩家
-define(BattlefieldDeadType_Dead, 2).               %% 玩家被杀
-define(BattlefieldDeadType_KillCollection, 3).     %% 打开宝箱
-define(BattlefieldDeadType_KillBoss, 4).           %% 杀死BOSS
-type battlefieldDeadType() :: ?BattlefieldDeadType_KillPlayer .. ?BattlefieldDeadType_KillBoss.

%% PlayerRankType = DeadType * 2
%% GuildRankType = DeadType * 2 + 1
-define(BattlefieldRankType_PlayerKillPlayer, 2).         %% 玩家杀死玩家
-define(BattlefieldRankType_GuildKillPlayer, 3).          %% 仙盟杀死玩家
-define(BattlefieldRankType_PlayerDead, 4).               %% 玩家被杀
%%-define(BattlefieldRankType_GuildDead, 5).                %% 仙盟被杀
%%-define(BattlefieldRankType_PlayerKillCollection, 6).     %% 玩家打开宝箱
-define(BattlefieldRankType_GuildKillCollection, 7).      %% 仙盟打开宝箱
-define(BattlefieldRankType_PlayerKillBoss, 8).           %% 玩家杀死BOSS
-define(BattlefieldRankType_GuildKillBoss, 9).            %% 仙盟杀死BOSS

-record(battlefieldInfo, {order = 0, isGm = ?FALSE, state = 0, openTime = 0, monsterTime = 0, closeTime = 0, discount = 0, world_level = 0, settle_map = []}).
-record(battlefieldData, {mapTime = 0, mapDataID = 0, rebornTime = 0, deadList = [], taskProgressList = [], taskFinishList = [], isCluster = false, clusterNum = 0}).
-record(battlefieldRank, {id = 0, value = 0, playerID = 0, playerSex = 0, playerName = [], guildID = 0, guildName = [], leaderID = 0, leaderSex = 0, leaderName = [], serverName = [], playerBattleValue = 0, guildBattleValue = 0, nationality_id = 0}).


%% 地图内信息
%% 个人统计 战盟统计使用同一个结构体
-record(resultData, {
	id = 0,
	rune_score = 0,
	score = 0,      %% 个人积分   当Id表示PlayerId的时候生效
	killNum = 0,
	deadNum = 0,
	deadBossNum = 0,
	collectionNum = 0,
	collectionNum4 = 0,
	bossNum = 0,
	guildRewardNum = 0
}).
-record(resultBoss, {id = 0, monsterDataID = 0, playerID = 0, playerSex = 0, playerName = "", guildID = 0, guildName = "", itemList = [], currencyList = [], serverName = [], nationality_id = 0}).
-record(resultInfo, {isFinish = false, resultDataList = [], resultBossList = []}).

-record(assist, {playerAttackerID = {}, playerID = 0, time = 0}).


%%%-------------------------------------------------------------------
%% ets 战场信息和排行信息
%% {RankType, ListRank}
%% RankType :: non_neg_integer() 取值范围为?ListRankType里的元素值，额外值为0时表示为战场信息
%% ListRank :: [#battlefieldRank{}, ...] 当Key为0时，Value的结构为#battlefieldInfo{}，否则为list()
%% fixme RankType为0时表示战场信息，与排行信息放置在一起，没有规范命名，存在维护困难
-define(BattlefieldRankType_BattlefieldInfo, 0).    %% 特殊，表示战场信息 fixme 并没有向数据库中保存活动状态
-define(ListRankType, [
	?BattlefieldRankType_PlayerKillPlayer,
	?BattlefieldRankType_GuildKillPlayer,
	?BattlefieldRankType_PlayerDead,
	?BattlefieldRankType_GuildKillCollection,
	?BattlefieldRankType_PlayerKillBoss,
	?BattlefieldRankType_GuildKillBoss
]).
-define(BattlefieldRankTable, battlefieldTable).
-define(BattlefieldRankNum, 15).             %% 排行数量
-define(Discount, 10000).    %% fixme 原文硬编码中抄来的，似乎是计算奖励倍率相关的数值

%%%-------------------------------------------------------------------
%% ets Boss信息
%% {MapDataID, {MapTime, BossDeadList}}
%% MapDataID :: non_neg_integer()
%% MapTime :: non_neg_integer()
%% BossDeadList :: {MonsterDataID, PlayerID} | {MonsterDataID, PlayerID, PlayerName, ServerName}
%% MonsterDataID :: non_neg_integer()
%% PlayerID :: non_neg_integer()
%% PlayerName :: string()
%% ServerName :: string()
-define(BattlefieldBossTable, battlefieldBossTable).

-endif.