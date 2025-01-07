%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2014, haowan123
%%% @doc 修罗战场	血色争霸
%%% 201904012 update by mty
%%%          整理代码，并修改为联服模式。
%%%          若存在主服，所有数据由主服管理，否则如同单服模式。
%%% @end
%%% Created : 2017-07-27 14:30
%%%-------------------------------------------------------------------
-ifndef(ashura_hrl).
-define(ashura_hrl, 1).

-include("global.hrl").

%%%-------------------------------------------------------------------
%% ets:活动信息KV表
-define(AshuraTable, ashuraTable).	%% {Key::term(), Value::term()}
-define(AshuraInfo_Time,	0).		%% #ashuraInfo{} 用于活动时间状态
-define(AshuraInfo_Winners,	1).		%% [#ashuraWinner{}, ...] 用于winner list
-define(AshuraInfo_Remain,	2).		%% remain 不晓得这是个啥

%%%-------------------------------------------------------------------
%% 数据库 ashura_data.id 对应值定义
-define(AshuraDataID_BEGIN,			1).
-define(AshuraDataID_ListRank,		1).	%% 排行榜
-define(AshuraDataID_ListWinner,	2).	%% 胜利者
-define(AshuraDataID_ListPlayer,	3).	%% 角色信息
-define(AshuraDataID_END,			3).

%%%-------------------------------------------------------------------
%% 活动状态
-define(AshuraState_BEGIN,	0).
-define(AshuraState_Idle,	0).	%% 空闲
-define(AshuraState_Ready,	1).	%% 准备
-define(AshuraState_Battle,	2).	%% 战斗
-define(AshuraState_END,	2).
-record(ashuraInfo, {
	order = 0,
	isGm = ?FALSE,
	state = ?AshuraState_BEGIN,
	readyTime = 0,
	battleTime = 0,
	closeTime = 0,
	world_level = 0	%% 主服世界等级
}).

%%%-------------------------------------------------------------------
%% ets:玩家信息（积分）
-define(ETS_AshuraPlayerInfo, ets_AshuraPlayerInfo).
-record(ashuraScore, {
	playerID = 0,
	life = {0,0,0},	%% 对应三个地图级别的剩余可重生次数
	totalScore = 0,
	totalKillNum = 0,
	totalKillNum1 = 0, %%第一层地图单场累杀
	totalLiveTime = 0,
	killNum = 0,
	playerName = "",
	guildID = 0,
	rune_tower_layer = 0,
	battleValue = 0,
	guildName = [],
	serverName = [],
	head = 0,
	frame = 0,
	career = 0,
	level = 0,
	nationality_id = 0
}).
-define(DefaultLive, {3, 3, 999}).	%% 默认的生命值

%%%-------------------------------------------------------------------
%% ets:排行榜信息
-define(ETS_AshuraRankInfo, ets_AshuraRankInfo). %%排行榜信息
-record(ashuraRank, {
	rank = 0,
	playerID = 0,
	totalScore = 0,
	totalKillNum = 0,
	totalLiveTime = 0,
	playerName = "",
	guildID = 0,
	battleValue = 0,
	guildName = [],
	serverName = [],
	head = 0,
	frame = 0,
	career = 0,
	level = 0,
	nationality_id = 0
	}).

%%%-------------------------------------------------------------------
%% 角色数据:活动数据
-record(ashuraData, {
	totalNum = 0,
	winNum = 0,
	totalScore = 0,
	totalKillNum = 0,
	killNum = 0,
	finishList = [],
	isCluster = false
}).

%%%-------------------------------------------------------------------
%% 成就类型
-define(AshuraAchieve_BEGIN,		1).
-define(AshuraAchieve_TotalNum,		1).
-define(AshuraAchieve_TotalScore,	2).
-define(AshuraAchieve_WinNum,		3).
-define(AshuraAchieve_TotalKillNum,	4).
-define(AshuraAchieve_KillNum,		5).
-define(AshuraAchieve_END,			5).

%%%-------------------------------------------------------------------
%% 获取角色数据顺序
-define(GPN_BEGIN,	0).
-define(GPN_Map,	0).	%% 从地图获取
-define(GPN_DB,		1).	%% 从数据库获取
-define(GPN_Cluster,2).	%% 从联服缓存获取
-define(GPN_END,	2).

-endif.	%% ashura_hrl