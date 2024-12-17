%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2014, haowan123
%%% @doc 麒麟洞大乱斗
%%% @end
%%% Created : 2017-07-27 14:30
%%%-------------------------------------------------------------------
-ifndef(melee_hrl).
-define(melee_hrl, 1).

-include("global.hrl").

-define(MeleeTable, meleeTable).

-define(MeleeGroupID_9, 9).               %% 阵营9
-define(MeleeGroupID_10, 10).             %% 阵营10
-define(MeleeGroupID_11, 11).             %% 阵营11

-define(MeleeState_Idle, 0).              %% 空闲
-define(MeleeState_Ready, 1).             %% 准备
-define(MeleeState_Battle, 2).            %% 战斗

-define(MeleePlayerState_Apply, 0).       %% 申请
-define(MeleePlayerState_Enter, 1).       %% 进入

-define(MeleeObjectType_1, 1).            %% 1刷buff球(这个类型只保留最后一波，刷新波的时候删掉上波）
-define(MeleeObjectType_2, 2).            %% 2刷宝箱
-define(MeleeObjectType_3, 3).            %% 3刷任意门
-define(MeleeObjectType_4, 4).            %% 4密室刷buff球(这个类型只保留最后一波，刷新波的时候删掉上波）
-define(MeleeObjectType_5, 5).            %% 5密室刷宝箱(这个类型只保留最后一波，刷新波的时候删掉上波）
-define(MeleeObjectType_6, 6).            %% 6刷怪
-define(MeleeObjectType_7, 7).            %% 7密室里刷出来的门（这个类型不公告）
-define(MeleeObjectTypeList, lists:seq(?MeleeObjectType_1, ?MeleeObjectType_7)).

-record(meleeInfo, {
	order = 0,
	isGm = ?FALSE,
	state = 0,
	readyTime = 0,
	battleTime = 0,
	closeTime = 0,
	createLineID = 0,
	switchTime = 0,
	specialSwitchLineID = 0,
	specialSwitchTime = 0,
	addLiveTimeTime = 0,
	addLiveScoreTime = 0,
	sendTopRankTime = 0,
	lineList = [],
	playerList = [],
	switchList = [],
	objectList = [],
	scoreList = [],
	rankList = [],
	firstPlayer = {},
	isBossDead = ?FALSE
}).

-record(meleeLine, {lineID = 0, playerCount = 0}).
-record(meleePlayer, {playerID = 0, lineID = 0, groupID = 0, battleValue = 0, applyTime = 0, state = 0}).
-record(meleeObject, {type = 0, specialRate = 0, refreshList = []}).
-record(meleeScore, {playerID = 0, totalScore = 0, totalKillNum = 0, killNum = 0, liveTime = 0, killNumTime = 0, quality = 0}).
-record(meleeRank, {
	rank = 0,
	playerID = 0,
	totalScore = 0,
	totalKillNum = 0,
	param = {}  %% {PlayerName, ServerName, GuildId, GuildName, BattleValue,NationalityId, ServerID}
}).

-endif.