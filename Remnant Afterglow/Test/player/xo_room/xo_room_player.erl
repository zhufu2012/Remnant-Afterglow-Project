%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%			 XO房间 玩家进程(斯芬克斯房间)
%%% @end
%%% Created : 14. 十二月 2018 14:56
%%%-------------------------------------------------------------------
-module(xo_room_player).
-author("cbfan").
-include("xo_room.hrl").
-include("netmsgRecords.hrl").
-include("variable.hrl").
-include("reason.hrl").
-include("cfg_functionFore.hrl").
-include("gameMap.hrl").
-include("cfg_xoRoomGuess.hrl").
-include("db_table.hrl").
-include("player_task_define.hrl").
-include("attainment.hrl").

%% API
-export([get_ac_info/0, enter_map/0, on_enter_area/1, on_exit_area/1, on_ask_answer/1, on_get_rank/0,
	on_get_bet_ui/0, on_bet/3, xo_bid_fail/1, sendMarquee/0]).

%% 请求活动信息 开始结束时间信息
get_ac_info() ->
	[{S, E, _IsGm, _CurOrder} | _] = ets:lookup_element(?MainEts, ?MainEtsKey_XoRoom, #mainEtsInfo.value),
	player:send(#pk_GS2U_RequestXOInfoRet{server_type = common:getTernaryValue(cluster:is_opened(), 2, 1), start_time = S, end_time = E}).

%% 请求排行榜，不在活动中显示上一场的结果

%% 进入地图
enter_map() ->
	try
		Now = time:time(),
		[{Start, End, _IsGm, CurOrder} | _] = ets:lookup_element(?MainEts, ?MainEtsKey_XoRoom, #mainEtsInfo.value),
		MapDataID = ?XoRoomDungeonID,
		case Now >= Start andalso Now =< End of
			?TRUE ->
				Info = db_common:get_player_time_limit_ac(player:getPlayerID(), ?OpenAction_XORoom),
				OrderList = Info#db_time_limit_ac.order_list,
				IsDec = case lists:keymember(CurOrder, 1, OrderList) of
							?TRUE -> ?FALSE;
							?FALSE ->
								case length(OrderList) < df:getFunctionForeLimitTime(?OpenAction_XORoom) of
									?TRUE -> ?TRUE;
									?FALSE -> throw(?ErrorCode_Times_Limit)
								end
						end,
				Result = playerMap:on_U2GS_RequestEnterMap(#requestEnterMapParam{
					cluster_gameplay = xo_room,
					requestID = MapDataID, params = #mapParams{mapAIType = ?MapAI_XORoom, dungeonID = MapDataID}}),
				case is_integer(Result) andalso IsDec of
					?TRUE->
						variable_player:set_value(?Variable_player_reset_Enter, ?Variable_player_reset_Enter_Bit6, 1),
						player_task:update_task(?Task_Goal_XoRoomCount, {1}),
						attainment:add_attain_progress(?Attainments_Type_XoRoomCount, {1}),
						db_common:update_time_limit_order(player:getPlayerID(), ?OpenAction_XORoom, CurOrder, End);
					?FALSE->
						throw(?ERROR_UNKNOWN)
				end;
			_ ->
				player:send(#pk_GS2U_RequestEnterMapResult{result = ?ERROR_fight_activity, mapDataID = MapDataID})
		end
	catch
		Err -> player:send(#pk_GS2U_RequestEnterMapResult{result = Err, mapDataID = ?XoRoomDungeonID})
	end.

%% 答题区进出区域 TODO 简单的检查看看玩家是否在玩法地图中
on_enter_area(Type) -> xo_room:send_2_master({enter_area, self(), player:getPlayerID(), Type}).
on_exit_area(Type) -> xo_room:send_2_master({exit_area, self(), player:getPlayerID(), Type}).

%% 看台区答题
on_ask_answer(Answer) -> xo_room:send_2_master({ask_answer, self(), player:getPlayerID(), Answer}).

on_get_rank() ->
	xo_room:send_2_master({get_rank, player:getPlayerID(), self(), player:getPlayerProperty(#player.sex), player:getPlayerProperty(#player.name)}).

on_get_bet_ui() -> xo_room:send_2_master({get_bet_ui, player:getPlayerID()}).

%% 下注
on_bet(Id, R, N) ->
	try
		%%	1. 判断是否在地图  2. 判断是否在准备时间内  3.判断下没下注  4.判断道具够不够
		case playerMap:getMapDataID() =:= ?XoRoomDungeonID of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_XO_BetNotInMap)
		end,

		Now = time:time(),
		[{Start, _End, _IsGm, _CurOrder} | _] = ets:lookup_element(?MainEts, ?MainEtsKey_XoRoom, #mainEtsInfo.value),
		case Now >= Start andalso Now =< (Start + cfg_globalSetup:xORoom_PreTime() - 1) of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_XO_BetNotInAcTime)
		end,
		Cfg = cfg_xoRoomGuess:getRow(Id),
		case is_record(Cfg, xoRoomGuessCfg) of ?TRUE -> skip; _ -> throw(?ERROR_Cfg) end,

		#xoRoomGuessCfg{option = Option, chip = Chip} = Cfg,
		CheckErr = check_cfg(Option, R),
		?ERROR_CHECK_THROW(CheckErr),

		Info = lists:keyfind(N, 2, Chip),
		case Info of ?FALSE -> throw(?ERROR_Cfg); _ -> skip end,
		{ItemId, ItemNum} = Info,
		CostErr = player:delete_cost([{ItemId, ItemNum}], [], ?Reason_Xo_BetCost),
		?ERROR_CHECK_THROW(CostErr),
		xo_room:send_2_master({on_bet, player:getPlayerID(), self(), {Id, R, N, ItemId, ItemNum}})
	catch
		ErrCode -> player:send(#pk_GS2U_XOBetRet{err_code = ErrCode, id = Id, num = N})
	end.

xo_bid_fail({ItemId, Num, ErrCode, BetId, BetNum}) ->
	bag_player:add([{ItemId, Num}], ?Reason_Xo_BetRet),
	player:send(#pk_GS2U_XOBetRet{err_code = ErrCode, id = BetId, num = BetNum}).

check_cfg([], 0) -> ?ERROR_OK;
check_cfg([], _) -> ?ERROR_Cfg;
check_cfg(L, Index) ->
	case lists:keymember(Index, 1, L) of
		?TRUE -> ?ERROR_OK;
		_ -> ?ERROR_Cfg
	end.
%%系统公告
sendMarquee() ->
	marquee:sendChannelNotice(0, 0, xOFJ_gonggao01,
		fun(Language) ->
			language:format(language:get_server_string("XOFJ_gonggao01", Language),
				[])
		end).
