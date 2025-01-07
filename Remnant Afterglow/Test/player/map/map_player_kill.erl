%%%-------------------------------------------------------------------
%%% @author wangdaobin
%%% @copyright (C) 2018, Double Game
%%% @doc  通用PVP规则(一个玩法,多张地图,各不相关适用)
%%% @end
%%% Created : 2018/10/8
%%%-------------------------------------------------------------------
-module(map_player_kill).

-include("netmsgRecords.hrl").
-include("global.hrl").
-include("guild.hrl").
-include("record.hrl").
-include("logger.hrl").
-include("gameMap.hrl").
-include("demons.hrl").

%% API
-export([new/0, on_tick/1,
	on_kill_player/3, on_player_dead/1,
	send_special_dead_notice/3, new_first_kill_false/0,
	on_player_leave_map/2
]).


%% 击杀信息
-record(kill_info, {
	player_id = 0,            %% 玩家ID
	kill_num = 0,             %% 连杀数
	total_kill_num = 0,        %% 累杀数
	kill_time = 0             %% 最后杀人时间
}).
-record(player_kill, {kill_list = [], is_first_kill = ?TRUE, reset_days = 0}).
-define(MapAIList, [
	?MapAI_DemonCM, ?MapAI_Demon, ?MapAI_DemonCx, ?MapAI_DemonCluster,
	?MapAI_ThunderFort, ?MapAI_ThunderFortCluster, ?MapAI_Battlefield, ?MapAI_Pantheon, ?MapAI_PantheonCluster, ?MapAI_Melee,
	?MapAI_BlzForest, ?MapAI_HolyWar, ?MapAI_HolyRuins
]).

%%%====================================================================
%%% API functions
%%%====================================================================
%% 创建一个 player_kill
new() ->
	#player_kill{}.

new_first_kill_false() ->
	#player_kill{is_first_kill = ?FALSE}.

%% 心跳, 更新player_kill
on_tick(TimeSeconds) ->
%%	check_reset(TimeSeconds), %% 先检查一下是否需要重置, 需要择重置
	PlayerKill = mapdb:getMapPlayerKillinfo(),
	#player_kill{kill_list = KillList} = PlayerKill,
	ExpireTime = TimeSeconds - df:getGlobalSetupValue(battlefield_KeepKillTime, 120),
	Fun = fun
			  (KillInfo = #kill_info{kill_time = KillTime, kill_num = KillNum}) ->
				  if
					  KillTime < ExpireTime andalso KillNum =/= 0 -> %% 连斩过期
						  KillInfo#kill_info{kill_num = 0};
					  true ->
						  KillInfo
				  end
		  end,
	NewKillList = lists:map(Fun, KillList),
	NewPlayerKill = PlayerKill#player_kill{kill_list = NewKillList},
	mapdb:setMapPlayerKillinfo(NewPlayerKill).

%% 响应杀人
on_kill_player(PlayerID, DeadPlayerID, MapAI) ->
	PlayerKill = mapdb:getMapPlayerKillinfo(),
	#player_kill{is_first_kill = IsFirstKill} = PlayerKill,
	KillInfo = get_kill_info(PlayerKill, PlayerID),
	DeadInfo = get_kill_info(PlayerKill, DeadPlayerID),

	NewKillInfo = KillInfo#kill_info{
		kill_num = KillInfo#kill_info.kill_num + 1,
		total_kill_num = KillInfo#kill_info.total_kill_num + 1,
		kill_time = time:time()
	},
	NewPlayerKill = update_kill_info(PlayerKill, NewKillInfo),
	send_kill_num(NewKillInfo),
	send_total_kill_num(NewKillInfo),


	send_kill_notice(NewKillInfo, DeadPlayerID, IsFirstKill),
	send_Total_kill_notice(NewKillInfo),
	send_dead_notice(DeadInfo, PlayerID),
	send_special_dead_notice(MapAI, DeadPlayerID, PlayerID),


	FinalPlayerKill = NewPlayerKill#player_kill{is_first_kill = ?FALSE},
	mapdb:setMapPlayerKillinfo(FinalPlayerKill).

%% 死亡事件
on_player_dead(PlayerID) ->
	PlayerKill = mapdb:getMapPlayerKillinfo(),
	KillInfo = get_kill_info(PlayerKill, PlayerID),
	NewPlayerKill = case KillInfo#kill_info.kill_num > 0 of
						?TRUE ->
							NewKillInfo = KillInfo#kill_info{kill_num = 0},
							update_kill_info(PlayerKill, NewKillInfo);
						_ ->
							PlayerKill
					end,
	mapdb:setMapPlayerKillinfo(NewPlayerKill).


%%%% 移除玩家
%%on_remove_player(PlayerID) ->
%%	PlayerKill = mapdb:getMapPlayerKillinfo(),
%%	#player_kill{kill_list = KillList} = PlayerKill,
%%	NewKillList = lists:keydelete(PlayerID, #kill_info.player_id, KillList),
%%	NewPlayerKill = PlayerKill#player_kill{kill_list = NewKillList},
%%	mapdb:setMapPlayerKillinfo(NewPlayerKill).

%% 玩家离开地图，清除玩家信息
on_player_leave_map(PlayerID, MapAI) ->
	case lists:member(MapAI, ?MapAIList) of
		?TRUE ->
			PlayerKill = mapdb:getMapPlayerKillinfo(),
			#player_kill{kill_list = KillList} = PlayerKill,
			NewKillList = lists:keydelete(PlayerID, #kill_info.player_id, KillList),
			NewPlayerKill = PlayerKill#player_kill{kill_list = NewKillList},
			mapdb:setMapPlayerKillinfo(NewPlayerKill);
		_ -> ok
	end.


%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 检查重置
%%check_reset(TimeSeconds) ->
%%	{Days, _} = calendar:seconds_to_daystime(TimeSeconds),
%%	PlayerKill = mapdb:getMapPlayerKillinfo(),
%%	#player_kill{kill_list = KillList, reset_days = ResetDays} = PlayerKill,
%%	if
%%		Days =/= ResetDays -> %% 跨天, 重置
%%			NewKillList = [KillInfo#kill_info{total_kill_num = 0} || KillInfo <- KillList],
%%			NewPlayerKill = PlayerKill#player_kill{kill_list = NewKillList, is_first_kill = ?TRUE, reset_days = Days},
%%			mapdb:setMapPlayerKillinfo(NewPlayerKill);
%%		true ->
%%			ok
%%	end.

%% 获取击杀信息
get_kill_info(#player_kill{kill_list = KillList}, PlayerID) ->
	case lists:keyfind(PlayerID, #kill_info.player_id, KillList) of
		?FALSE ->
			#kill_info{player_id = PlayerID};
		KillInfo ->
			KillInfo
	end.


%% 更新击杀信息
update_kill_info(PlayerKill = #player_kill{kill_list = KillList}, NewKillInfo) ->
	NewKillList = lists:keystore(NewKillInfo#kill_info.player_id, #kill_info.player_id, KillList, NewKillInfo),
	PlayerKill#player_kill{kill_list = NewKillList}.


%% 给客户端发送击杀消息
send_kill_num(#kill_info{player_id = PlayerId, kill_num = KillNum}) ->
	m_send:sendMsgToClient(PlayerId, #pk_GS2U_BattlefieldKeepKill{num = KillNum}).
send_total_kill_num(#kill_info{player_id = PlayerId, total_kill_num = KillNum}) ->
	m_send:sendMsgToClient(PlayerId, #pk_GS2U_MapKillNum{killNum = KillNum}).


%% 连续击杀公告
send_kill_notice(#kill_info{player_id = PlayerId, kill_num = KillNum}, DeadPlayerID, ?FALSE) ->
	if
		KillNum > 0 andalso (KillNum rem 10) =:= 0 ->%% 10杀后每次+10人
			KillPlayerName = mapdb:getObjectName(PlayerId),
			DeadPlayerName = mapdb:getObjectName(DeadPlayerID),
			PlayerIdList = mapdb:getMapPlayerIDList(),
			MapDataID = mapSup:getMapDataID(),
			marquee:sendNoticeBroadcastInMap(PlayerIdList, 0, battlefield_KeepKillDesc9,
				fun(Language) ->
					NewKillPlayerName = mapdb:updateObjectName(KillPlayerName, Language),
					NewDeadPlayerName = mapdb:updateObjectName(DeadPlayerName, Language),
					language:format(language:get_server_string("battlefield_KeepKillDesc9", Language),
						[NewKillPlayerName, language:get_map_name(MapDataID, Language), NewDeadPlayerName, KillNum])
				end);
		true -> ok
	end;
send_kill_notice(#kill_info{player_id = PlayerId}, DeadPlayerID, _) -> %% 首杀公告
	KillPlayerName = mapdb:getObjectName(PlayerId),
	DeadPlayerName = mapdb:getObjectName(DeadPlayerID),
	PlayerIdList = mapdb:getMapPlayerIDList(),
	MapDataID = mapSup:getMapDataID(),
	marquee:sendNoticeBroadcastInMap(PlayerIdList, 0, battlefield_KeepKillDesc1,
		fun(Language) ->
			NewKillPlayerName = mapdb:updateObjectName(KillPlayerName, Language),
			NewDeadPlayerName = mapdb:updateObjectName(DeadPlayerName, Language),
			language:format(language:get_server_string("battlefield_KeepKillDesc1", Language),
				[NewKillPlayerName, language:get_map_name(MapDataID, Language), NewDeadPlayerName])
		end).


%% 总击杀公告
send_Total_kill_notice(#kill_info{player_id = PlayerId, total_kill_num = TotalKillNum}) ->
	if
		TotalKillNum >= 100 andalso (TotalKillNum rem 20) =:= 0 -> %% 从100人开始公告，之后每20人公告一次
			PlayerName = mapdb:getObjectName(PlayerId),
			PlayerIdList = mapdb:getMapPlayerIDList(),
			MapDataID = mapSup:getMapDataID(),
			marquee:sendNoticeBroadcastInMap(PlayerIdList, 0, battleField_TotalKill2,
				fun(Language) ->
					NewPlayerName = mapdb:updateObjectName(PlayerName, Language),
					language:format(language:get_server_string("BattleField_TotalKill2", Language),
						[NewPlayerName, language:get_map_name(MapDataID, Language), TotalKillNum])
				end);
		true ->
			ok
	end.

%% 终结连杀公告
send_dead_notice(#kill_info{player_id = DeadPlayerId, kill_num = KillNum}, PlayerID) ->
	if
		KillNum >= 10 -> %% 终结10杀及以上
			KillPlayerName = mapdb:getObjectName(PlayerID),
			DeadPlayerName = mapdb:getObjectName(DeadPlayerId),
			PlayerIdList = mapdb:getMapPlayerIDList(),
			MapDataID = mapSup:getMapDataID(),
			marquee:sendNoticeBroadcastInMap(PlayerIdList, 0, battlefield_ShutDownDesc7,
				fun(Language) ->
					NewKillPlayerName = mapdb:updateObjectName(KillPlayerName, Language),
					NewDeadPlayerName = mapdb:updateObjectName(DeadPlayerName, Language),
					language:format(language:get_server_string("battlefield_ShutDownDesc7", Language),
						[NewKillPlayerName, language:get_map_name(MapDataID, Language), NewDeadPlayerName])
				end);
		true ->
			ok
	end.

%% 特殊死亡公告
send_special_dead_notice(_MapAI, DeadPlayerID, KillPlayerID) ->
	MapPlayer = mapdb:getMapPlayer(DeadPlayerID),
	case MapPlayer of
		#mapPlayer{guildRank = GuildRank} ->
			case GuildRank of
				?GuildRank_Chairman ->
					GuildName = MapPlayer#mapPlayer.guildName,
					KillPlayerName = mapdb:getObjectName(KillPlayerID),
					DeadPlayerName = mapdb:getObjectName(DeadPlayerID),
					PlayerIDList = mapdb:getMapPlayerIDList(),
					marquee:sendNoticeBroadcastInMap(PlayerIDList, 0, battleField_KillMaster1,
						fun(Language) ->
							NewKillPlayerName = mapdb:updateObjectName(KillPlayerName, Language),
							NewDeadPlayerName = mapdb:updateObjectName(DeadPlayerName, Language),
							language:format(language:get_server_string("BattleField_KillMaster1", Language), [NewKillPlayerName, GuildName, NewDeadPlayerName])
						end);
				?GuildRank_SuperElder ->
					GuildName = MapPlayer#mapPlayer.guildName,
					KillPlayerName = mapdb:getObjectName(KillPlayerID),
					DeadPlayerName = mapdb:getObjectName(DeadPlayerID),
					PlayerIDList = mapdb:getMapPlayerIDList(),
					marquee:sendNoticeBroadcastInMap(PlayerIDList, 0, battleField_KillMaster2,
						fun(Language) ->
							NewKillPlayerName = mapdb:updateObjectName(KillPlayerName, Language),
							NewDeadPlayerName = mapdb:updateObjectName(DeadPlayerName, Language),
							language:format(language:get_server_string("BattleField_KillMaster2", Language), [NewKillPlayerName, GuildName, NewDeadPlayerName])
						end);
				?GuildRank_ViceChairman ->
					GuildName = MapPlayer#mapPlayer.guildName,
					KillPlayerName = mapdb:getObjectName(KillPlayerID),
					DeadPlayerName = mapdb:getObjectName(DeadPlayerID),
					PlayerIDList = mapdb:getMapPlayerIDList(),
					marquee:sendNoticeBroadcastInMap(PlayerIDList, 0, battleField_KillMaster3,
						fun(Language) ->
							NewKillPlayerName = mapdb:updateObjectName(KillPlayerName, Language),
							NewDeadPlayerName = mapdb:updateObjectName(DeadPlayerName, Language),
							language:format(language:get_server_string("BattleField_KillMaster3", Language), [NewKillPlayerName, GuildName, NewDeadPlayerName])
						end);
				_ -> ok
			end;
		_ -> skip
	end.
