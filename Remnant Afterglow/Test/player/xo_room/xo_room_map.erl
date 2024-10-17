%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%       XO房间 地图进程(斯芬克斯房间)  TODO 复活点
%%% @end
%%% Created : 14. 十二月 2018 14:56
%%%-------------------------------------------------------------------
-module(xo_room_map).
-author("cbfan").
-include("xo_room.hrl").
-include("netmsgRecords.hrl").
-include("db_table.hrl").
-include("id_generator.hrl").

-include("reason.hrl").
-include("gameMap.hrl").
%% API
-export([on_player_enter/1, on_player_exit/1, get_answer_start_time/0, handle_msg/1]).

%% 玩家进入地图后  将信息发送到活动进程
on_player_enter(PlayerID) ->
	#mapPlayer{name = Name, guildName = GuildName, serverID = ServerId, enter_server_name = ServerName, sex = Sex, nationality_id = NationalityId} = mapdb:getMapPlayer(PlayerID),
	xo_room:send_2_master({player_enter, {PlayerID, mapdb:getPlayerPID(PlayerID), self(), Name, GuildName, ServerId, ServerName, Sex, NationalityId}}),
	ok.
%% 玩家进入地图后  将信息发送到活动进程
on_player_exit(PlayerId) ->
	xo_room:send_2_master({player_exit, PlayerId}).
%% 答题失败讲玩家传送到看台
get_answer_start_time() ->
	[{Start, _End, _IsGm, _CurOrder} | _] = ets:lookup_element(?MainEts, ?MainEtsKey_XoRoom, #mainEtsInfo.value),
	Start + cfg_globalSetup:xORoom_PreTime().

handle_msg({answer_fail_move, PlayerId, {X, Y}}) ->
	case mapdb:getMapPlayer(PlayerId) of
		#mapPlayer{} ->
			objectMove:updateObjectPos(PlayerId, X, Y, ?FALSE),
			Msg = #pk_GS2U_FlyMoveTo{id = map_role:get_leader_id(PlayerId), posX = X, posY = Y},
			mapView:broadcastByView(Msg, 0, 0);
		_ ->
			skip
	end;
handle_msg({answer_fail_addbuff, PlayerId, BuffId}) ->
	case mapdb:getMapPlayer(PlayerId) of
		#mapPlayer{} ->
			buff_map:add_buffer(PlayerId, PlayerId, BuffId, 0);
		_ ->
			skip
	end;


handle_msg(Msg) ->
	?LOG_ERROR("unhandle msg :~p", [Msg]),
	ok.