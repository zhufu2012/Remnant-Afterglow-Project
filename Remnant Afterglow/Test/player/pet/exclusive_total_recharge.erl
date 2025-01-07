%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2023, DoubleGame
%%% @doc
%%%		专属累充
%%% @end
%%% Created : 31. 5月 2023 19:18
%%%-------------------------------------------------------------------
-module(exclusive_total_recharge).
-author("suw").

%% API
-export([list_2_exclusive_total_recharge/1, exclusive_total_recharge_2_list/1]).
-export([on_player_online/0, on_reset/0, on_func_open/0, on_recharge/1, on_get_award/1]).

-include("global.hrl").
-include("variable.hrl").
-include("reason.hrl").
-include("error.hrl").
-include("record.hrl").
-include("cfg_exclusiveRecharge1.hrl").
-include("cfg_exclusiveRecharge2.hrl").
-include("netmsgRecords.hrl").

-define(TableExclusiveTotalRecharge, db_exclusive_total_recharge).
-record(exclusive_total_recharge, {
	player_id = 0, %% 玩家Id
	recharge_num = 0, %% 专属充值额度
	reset_time = 0, %% 重置时间
	rule1 = 0, %% 开服天数分段
	rule2 = 0, %% 个人等级分段
	index_list = [] %% 已获得奖励档位
}).
%%%===================================================================
%%% API
%%%===================================================================
on_player_online() ->
	case is_func_open() of
		?TRUE -> sync_info();
		?FALSE -> ok
	end.

on_reset() ->
	case is_func_open() of
		?TRUE ->
			NowTime = time:time(),
			case get_data() of
				#exclusive_total_recharge{reset_time = ResetTime} = Data when NowTime >= ResetTime ->
					check_mail(Data),
					update_data(init_data()),
					sync_info();
				_ -> ok
			end;
		?FALSE -> ok
	end.

on_func_open() ->
	case is_func_open() of
		?TRUE ->
			Data = init_data(),
			update_data(Data),
			sync_info();
		?FALSE -> ok
	end.

on_recharge(Num) ->
	case is_func_open() of
		?TRUE ->
			#exclusive_total_recharge{recharge_num = OldNUm} = Data = get_data(),
			update_data(Data#exclusive_total_recharge{recharge_num = OldNUm + Num}),
			player:send(#pk_GS2U_exclusive_total_recharge_update{recharge_num = OldNUm + Num});
		?FALSE -> ok
	end.

on_get_award(Index) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#exclusive_total_recharge{recharge_num = RechargeNum, rule1 = Rule1, rule2 = Rule2, index_list = IndexList} = Data = get_data(),
		Cfg = cfg_exclusiveRecharge2:getRow(Index, Rule1, Rule2),
		?CHECK_CFG(Cfg),
		#exclusiveRecharge2Cfg{recharge = NeedRecharge, itemNew = AwardList} = Cfg,
		?CHECK_THROW(RechargeNum >= NeedRecharge, ?ERROR_recharge_exclusive_total_condition),
		?CHECK_THROW(not lists:member(Index, IndexList), ?ERROR_recharge_exclusive_total_HasAward),
		MyCareer = player:getCareer(),
		ItemList = [{CfgID, Num, Bind} || {Career, 1, CfgID, Num, Bind, _Quality, _Star} <- AwardList, Career =:= 0 orelse Career =:= MyCareer],
		CurrencyList = [{CfgID, Num} || {Career, 2, CfgID, Num, _Bind, _Quality, _Star} <- AwardList, Career =:= 0 orelse Career =:= MyCareer],
		EqList = eq:create_eq([{CfgID, Bind, Quality, Star} || {Career, 3, CfgID, _Num, Bind, Quality, Star} <- AwardList, Career =:= 0 orelse Career =:= MyCareer]),
		update_data(Data#exclusive_total_recharge{index_list = [Index | IndexList]}),
		player_item:reward(ItemList, EqList, CurrencyList, ?REASON_recharge_ExclusiveTotalRecharge),
		player_item:show_get_item_dialog(ItemList, CurrencyList, EqList, 0, 7),
		player:send(#pk_GS2U_exclusive_total_recharge_award_ret{index = Index, err_code = ?ERROR_OK}),
		ok
	catch
		Err -> player:send(#pk_GS2U_exclusive_total_recharge_award_ret{index = Index, err_code = Err})
	end.

list_2_exclusive_total_recharge(List) ->
	Record = list_to_tuple([exclusive_total_recharge | List]),
	Record#exclusive_total_recharge{
		index_list = gamedbProc:dbstring_to_term(Record#exclusive_total_recharge.index_list)
	}.
exclusive_total_recharge_2_list(Record) ->
	tl(tuple_to_list(Record#exclusive_total_recharge{
		index_list = gamedbProc:term_to_dbstring(Record#exclusive_total_recharge.index_list)
	})).
%%%===================================================================
%%% Internal functions
%%%===================================================================
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_ExclusiveTotalRecharge) =:= 1 andalso guide:is_open_action(?OpenAction_ExclusiveTotalRecharge).

update_data(Data) ->
	table_player:insert(?TableExclusiveTotalRecharge, Data).

get_data() ->
	case table_player:lookup(?TableExclusiveTotalRecharge, player:getPlayerID()) of
		[] -> init_data();
		[R] -> R
	end.

init_data() ->
	Cfg = cfg_exclusiveRecharge1:first_row(),
	#exclusive_total_recharge{
		player_id = player:getPlayerID(),
		recharge_num = 0,
		reset_time = get_next_reset_time(Cfg),
		rule1 = get_rule1(Cfg),
		rule2 = get_rule2(Cfg),
		index_list = []
	}.

get_next_reset_time(#exclusiveRecharge1Cfg{day = Day}) ->
	StartTime = main:getServerStartTime(),
	NowTime = time:time(),
	DayDiff = time:daytime_offset_days(StartTime, NowTime),
	case DayDiff > 0 of
		?TRUE -> time:daytime_add(StartTime, (DayDiff div Day * Day + Day) * ?SECONDS_PER_DAY);
		?FALSE -> time:daytime_add(StartTime, Day * ?SECONDS_PER_DAY)
	end.

get_rule1(#exclusiveRecharge1Cfg{rule1 = Rule1}) ->
	StartDay = main:getServerStartDays(),
	{_, Index} = common:getValueByInterval(StartDay, Rule1, {1, 1}),
	Index.

get_rule2(#exclusiveRecharge1Cfg{rule2 = Rule2}) ->
	Lv = player:getLevel(),
	{_, Index} = common:getValueByInterval(Lv, Rule2, {1, 1}),
	Index.

check_mail(#exclusive_total_recharge{recharge_num = RechargeNum, index_list = IndexList, rule1 = Rule1, rule2 = Rule2}) ->
	#exclusiveRecharge2Cfg{maxID = MaxIndex} = cfg_exclusiveRecharge2:getRow(1, Rule1, Rule2),
	case lists:seq(1, MaxIndex) -- IndexList of
		[] -> ok;
		AwardIndexL ->
			F = fun(Index, Acc) ->
				case cfg_exclusiveRecharge2:getRow(Index, Rule1, Rule2) of
					#exclusiveRecharge2Cfg{recharge = NeedRecharge, itemNew = ItemNew} when RechargeNum >= NeedRecharge ->
						ItemNew ++ Acc;
					_ -> Acc
				end
				end,
			AwardList = lists:foldl(F, [], AwardIndexL),
			case AwardList =/= [] of
				?TRUE ->
					MyCareer = player:getCareer(),
					ItemList = [#itemInfo{itemID = CfgID, num = Num, isBind = Bind} || {Career, 1, CfgID, Num, Bind, _Quality, _Star} <- AwardList, Career =:= 0 orelse Career =:= MyCareer],
					CurrencyList = [#coinInfo{type = CfgID, num = Num} || {Career, 2, CfgID, Num, _Bind, _Quality, _Star} <- AwardList, Career =:= 0 orelse Career =:= MyCareer],
					EqList = eq:create_eq([{CfgID, Bind, Quality, Star} || {Career, 3, CfgID, _Num, Bind, Quality, Star} <- AwardList, Career =:= 0 orelse Career =:= MyCareer]),
					Language = player:get_language(),
					mail:send_mail(#mailInfo{
						player_id = player:getPlayerID(),
						title = language:get_server_string("ExcluRecharge_Mail_Title1", Language),
						describe = language:get_server_string("ExcluRecharge_Mail_Desc1", Language),
						coinList = CurrencyList,
						itemList = ItemList,
						itemInstance = EqList,
						attachmentReason = ?REASON_recharge_ExclusiveTotalRecharge
					});
				?FALSE -> ok
			end
	end.

sync_info() ->
	#exclusive_total_recharge{recharge_num = RechargeNum, reset_time = ResetTime, rule1 = Rule1, rule2 = Rule2, index_list = IndexList} = get_data(),
	Msg = #pk_GS2U_exclusive_total_recharge_sync{
		recharge_num = RechargeNum,
		reset_time = ResetTime,
		rule1 = Rule1,
		rule2 = Rule2,
		index_list = IndexList
	},
	player:send(Msg).
