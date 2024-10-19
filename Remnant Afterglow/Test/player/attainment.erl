%%%-------------------------------------------------------------------
%%% @author wangqing
%%% @copyright (C) 2018, Double Game
%%% @doc	任务成就
%%% @end
%%% Created : 2018-09-19 15:00
%%%-------------------------------------------------------------------
-module(attainment).
-include("cfg_item.hrl").
-include("cfg_attainmentsNew.hrl").
-include("netmsgRecords.hrl").
-include("variable.hrl").
-include("globalDict.hrl").
-include("attainment.hrl").
-include("record.hrl").
-include("itemDefine.hrl").
-include("error.hrl").
-include("logDefine.hrl").
-include("logger.hrl").
-include("db_table.hrl").
-include("reason.hrl").
-include("prophecy.hrl").
-include("skill.hrl").
-include("item.hrl").
-include("player_private_list.hrl").
-include("currency.hrl").
-include("gameMap.hrl").
-include("log_times_define.hrl").
%%%====================================================================
%%% API functions
%%%
%%%
%%%====================================================================
-export([
	on_load/0,
	on_function_open/0,
	on_player_online/0,
	on_daily_reset/0,
	check_attainment/1,
	check_attainment/2,
	check_attainment/3,
	add_attain_progress/2,
	add_attain_progress/3,
%%	save_off_event/2,
	add_attainment/1
]).
-export([get_type_map/0]).
%%-export([add_map_star/2, add_map_times/1]).
-export([
	on_get_award/1,
	on_get_attain_complete/0,
	on_get_attain_progress/0
]).
-export([
	show_att_point/0,
	gm_add_progress/6,
	gm_add_att/1,
	gm_all_att/0
]).
-export([fix_data_20221208/0]).

show_att_point() ->
	?metrics(begin
				 AttPoint = variable_player:get_value(?FixedVariant_Index_68_AttPoint),
				 ?LOG_INFO("Player:~p AttPoint:~p~n", [player:getPlayerID(), AttPoint]) end).

%% 加载
on_load() ->
	?metrics(begin
				 load_from_db() end).

%% 玩家上线
on_player_online() ->
	?metrics(begin
				 send_all_info() end).

%% 功能开放
on_function_open() ->
%%	?LOG_INFO("attainment on_function_open~n"),

	?metrics(begin
				 send_all_info() end).

%% 每日重置
on_daily_reset() ->
	?metrics(begin
				 ProgressMap = get_progress_map(),
				 UpdateList = maps:fold(
					 fun
						 (_, #attain_progress{today_progress = 0}, List) ->
							 List;
						 (_, Progress, List) ->
							 [Progress#attain_progress{today_progress = 0} | List]
					 end, [], ProgressMap),
				 update_progress_list(UpdateList, ProgressMap)
			 end).

%% 取成就所有数据发送给客户端
on_get_attain_complete() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 MsgList = maps:fold(
						 fun(_, Complete, List) ->
							 #attain_complete{id = ID, is_get = IsGet} = Complete,
							 case cfg_attainmentsNew:getRow(ID) of
								 {} -> List;
								 #attainmentsNewCfg{page = Page} ->
									 case Page =:= 0 of
										 ?TRUE -> List;
										 ?FALSE -> [#pk_attainmentReachInfo{id = ID, isGet = IsGet} | List]
									 end
							 end
						 end, [], get_complete_map()),
					 player:send(#pk_GS2U_sendAttainmentReachList{reachList = MsgList})
				 catch
					 ErrCode ->
						 ?LOG_ERROR("attainment on_get_attain_complete err:~p~n", [ErrCode]),
						 player:send(#pk_GS2U_sendAttainmentReachList{reachList = []})
				 end end).

%% 获取当前进度
on_get_attain_progress() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 KeyList = cfg_attainmentsNew:getKeyList(),
					 ProgressMap = get_progress_map(),
					 MsgList = lists:foldl(
						 fun(ID, List) ->
							 % 只筛选未达成的成就
							 case check_condition(ProgressMap, ID) of
								 ?TRUE -> List;
								 ?FALSE ->
									 case get_progress(ID, ProgressMap) of
										 0 -> List;
										 Progress ->
											 [#pk_attainmentProgress{id = ID, progress = Progress} | List]
									 end
							 end
						 end, [], KeyList),
					 player:send(#pk_GS2U_sendAttainmentProgress{progressList = MsgList})
				 catch
					 Why ->
						 ?LOG_ERROR("attainment on_get_attain_progress err:~p~n", [Why]),
						 player:send(#pk_GS2U_sendAttainmentProgress{progressList = []})
				 end end).

%% 领奖
on_get_award(AttainIDList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 OldPoint = variable_player:get_value(?FixedVariant_Index_68_AttPoint),
					 NewPoint = lists:foldl(fun get_award/2, OldPoint, AttainIDList),
					 case NewPoint =/= OldPoint of
						 ?TRUE ->
							 variable_player:set_value(?FixedVariant_Index_68_AttPoint, NewPoint),
							 check_attainment(?Attainments_Type_AttPoint);
						 ?FALSE -> ok
					 end,
					 %% 通知领奖成功
					 on_get_attain_progress(),
					 on_get_attain_complete(),
					 player:send(#pk_GS2U_getAttainmentRewardRet{err_code = 0})
				 catch
					 ErrCode ->
						 ?LOG_ERROR("attainment on_get_award err:~p~n", [ErrCode]),
						 player:send(#pk_GS2U_getAttainmentRewardRet{err_code = ErrCode})
				 end end).

%% 外部调用 添加某类型成就进度
%% Param:{} 接受0~5个参数,缺省参数{1,0,0,0,0}
add_attain_progress(Type, Param) when is_tuple(Param), tuple_size(Param) >= 0, tuple_size(Param) =< 5 ->
	?metrics(begin
				 do_add_attain_progress(Type, Param) end).
add_attain_progress(PlayerPid, Type, Param) when is_pid(PlayerPid), is_tuple(Param), tuple_size(Param) >= 0, tuple_size(Param) =< 5 ->
	?metrics(begin
				 m_send:send_pid_msg(PlayerPid, {attainment_addprogress, Type, Param}) end);
add_attain_progress(PlayerID, Type, Param) when is_tuple(Param), tuple_size(Param) >= 0, tuple_size(Param) =< 5 ->
	?metrics(begin
				 case main:isOnline(PlayerID) of
					 ?TRUE ->
						 main:sendMsgToPlayerProcess(PlayerID, {attainment_addprogress, Type, Param});
					 _ ->
						 save_off_event(PlayerID, {attainment_addprogress, Type, Param})
				 end end).

%% 外部调用 检查指定类型
%% %% Param:{} 接受0~5个参数,缺省参数{0,0,0,0,0}
check_attainment(TypeOrList) ->
	?metrics(begin
				 check_attainment(TypeOrList, {0, 0, 0, 0, 0}) end).
check_attainment(TypeOrList, Param) when is_tuple(Param), tuple_size(Param) >= 0, tuple_size(Param) =< 5 ->
	?metrics(begin
				 do_check_attainment(TypeOrList, Param) end);
check_attainment(PlayerID, TypeOrList) ->
	?metrics(begin
				 check_attainment(PlayerID, TypeOrList, {0, 0, 0, 0, 0}) end).
check_attainment(PlayerID, TypeOrList, Param) when is_tuple(Param), tuple_size(Param) >= 0, tuple_size(Param) =< 5 ->
	?metrics(begin
				 case main:isOnline(PlayerID) of
					 ?TRUE ->
						 main:sendMsgToPlayerProcess(PlayerID, {attainment_check, TypeOrList, Param});
					 _ ->
						 save_off_event(PlayerID, {attainment_check, TypeOrList, Param})
				 end end);
check_attainment(_, _, _) ->
	ok.

gm_add_progress(Type, P1, P2, P3, P4, P5) ->
	add_attain_progress(Type, {P1, P2, P3, P4, P5}).

gm_add_att(ID) ->
	case cfg_attainmentsNew:getRow(ID) of
		#attainmentsNewCfg{} -> add_attainment(ID);
		_ -> ?LOG_ERROR("gm_add_att [ID:~p] not exist.~n", [ID])
	end.

gm_all_att() ->
	[add_attainment(ID) || ID <- cfg_attainmentsNew:getKeyList()].


%%数据更新
fix_data_20221208() ->
	add_attain_progress(?Attainments_Type_GoldGetCount, {currency:get_value(?CURRENCY_Money)}),
	add_attain_progress(?Attainments_Type_BlueDiamondCount, {currency:get_value(?CURRENCY_GoldBind)}),
	add_attain_progress(?Attainments_Type_GreenDiamondCount, {currency:get_value(?CURRENCY_Gold)}),
	add_attain_progress(?Attainments_Type_GreenAndBlueReincarnation, {currency:get_gold(player:getPlayerID())}),
	do_check_attainment().
%%%===================================================================
%%% Internal functions
%%%===================================================================

put_type_map(Map) ->
	persistent_term:put({?MODULE, type_map}, Map).
get_type_map() ->
	case persistent_term:get({?MODULE, type_map}, ?UNDEFINED) of
		?UNDEFINED ->
			TypeMap = lists:foldl(
				fun(Id, Map) ->
					#attainmentsNewCfg{param = [{Type, _, _, _, _, _}]} = cfg_attainmentsNew:getRow(Id),
					List = maps:get(Type, Map, []),
					maps:put(Type, [Id | List], Map)
				end, #{}, cfg_attainmentsNew:getKeyList()),
			put_type_map(TypeMap),
			TypeMap;
		Map -> Map
	end.
%%
get_id_list(Type) ->
	maps:get(Type, get_type_map(), []).

%% 进程字典 完成的成就
set_complete_map(Map) ->
	put(attain_complete, Map).
get_complete_map() ->
	case get(attain_complete) of
		?UNDEFINED -> #{};
		Map when is_map(Map) -> Map;
		List ->
			%% 数据升级
			Map = maps:from_list([{Complete#attain_complete.id, Complete} || Complete <- List]),
			set_complete_map(Map),
			Map
	end.
%%
update_complete(Complete, Map) ->
	table_player:insert(db_attain_complete, attcomp_2_dbattcomp(Complete)),
	set_complete_map(maps:put(Complete#attain_complete.id, Complete, Map)).
%% 返回 Complete | false
find_complete(Id, Map) ->
	case maps:find(Id, Map) of
		{ok, Complete} -> Complete;
		error -> ?FALSE
	end.

%% 进程字典 进行中的成就
set_progress_map(Map) ->
	put(attain_progress, Map).
get_progress_map() ->
	case get(attain_progress) of
		?UNDEFINED -> #{};
		Map when is_map(Map) -> Map;
		List ->
			%% 数据升级
			Map = maps:from_list([{Progress#attain_progress.id, Progress} || Progress <- List]),
			set_progress_map(Map),
			Map
	end.
%%
update_progress_list(ProgressList, Map) ->
	table_player_async:insert(db_attain_progress, [attprog_2_dbattprog(Progress) || Progress <- ProgressList]),
	Map2 = maps:from_list([{Progress#attain_progress.id, Progress} || Progress <- ProgressList]),
	set_progress_map(maps:merge(Map, Map2)).
%% 返回 Progress | false
find_progress(Id, Map) ->
	case maps:find(Id, Map) of
		{ok, Progress} -> Progress;
		error -> ?FALSE
	end.

%% 从数据库加载成就信息
load_from_db() ->
	PlayerID = player:getPlayerID(),

	CompleteList = table_player:lookup(db_attain_complete, PlayerID),
	set_complete_map(maps:from_list([{ID, #attain_complete{id = ID, is_get = IsGet}} ||
		#db_attain_complete{id = ID, is_get = IsGet} <- CompleteList])),

	ProgressList = table_player:lookup(db_attain_progress, PlayerID),
	set_progress_map(maps:from_list([{ID, #attain_progress{id = ID, progress = Progress, today_progress = TodayProgress}} ||
		#db_attain_progress{id = ID, progress = Progress, today_progress = TodayProgress} <- ProgressList])),

%%	?LOG_INFO("attanment load...~ncomplete:~p~nprogress:~p~n", [AttainCompleteList, AttainProgressList]),
	ok.

%% 发送数据
send_all_info() ->
%%	?LOG_INFO("send_all_info~n"),
	do_check_attainment(),
	case is_func_open() of
		?TRUE ->
			on_get_attain_progress(),
			on_get_attain_complete();
		?FALSE ->
			ok
	end.

%% 领取某个成就奖励，返回 NewPoint
get_award(ID, OldPoint) ->
	try
		CompleteMap = get_complete_map(),
		AttainInfo = case find_complete(ID, CompleteMap) of
						 ?FALSE -> throw(?ErrorCode_Attainment_NotReach);
						 AttInfo -> AttInfo
					 end,
		case AttainInfo#attain_complete.is_get =:= 1 of
			?TRUE ->
				throw(?ErrorCode_Attainment_HasGetReward);
			?FALSE ->
				ok
		end,
		AttCfg = cfg_attainmentsNew:getRow(ID),
		case AttCfg of
			{} -> throw(?ErrorCode_Attainment_EmptyCfg);
			_ -> ok
		end,

		PlayerID = player:getPlayerID(),
		Career = player:getCareer(),
		#attainmentsNewCfg{award = Award, title = TitleID} = AttCfg,
		case Award =/= [] of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Attainment_EmptyAward)
		end,

		{ItemList, _, CurrencyList, _} = drop:drop([], Award, PlayerID, Career, player:getLevel()),

		%% 添加称号
		[player_title:on_add_title(TitleID) || TitleID =/= 0],

		%% 记录
		NewInfo = AttainInfo#attain_complete{is_get = 1},
		update_complete(NewInfo, CompleteMap),

		player:add_rewards(ItemList, CurrencyList, ?Reason_Attainment_Award),
		player_item:show_get_item_dialog(ItemList, CurrencyList, [], 0, 5),

		%% 添加成就点
		NewPoint = OldPoint + AttCfg#attainmentsNewCfg.attaVal,
		log_attain_award(ID, OldPoint, NewPoint, time:time()),
		NewPoint
	catch
		_ ->
			OldPoint
	end.


%% 全部检查
do_check_attainment() ->
	try
		CompleteMap = get_complete_map(),
		KeyList = cfg_attainmentsNew:getKeyList(),
		CheckList = lists:foldl(
			fun(AttainID, List) ->
				case find_complete(AttainID, CompleteMap) of
					?FALSE -> [AttainID | List];
					_ -> List
				end
			end, [], KeyList),
%%		?LOG_INFO("do_check_attainment0 CheckList:~p~n", [CheckList]),
		ProgressMap = get_progress_map(),
		[check_new_att(ProgressMap, ID) || ID <- CheckList]
	catch
		Why ->
			?LOG_ERROR("do_check_attainment failed, why:~p~n", [Why])
	end.
%% 检查指定类型
do_check_attainment(TypeList, Param) when is_list(TypeList) ->
	[do_check_attainment(Type, Param) || Type <- TypeList];
do_check_attainment(Type, Param) when is_integer(Type) ->
%%	?LOG_INFO("do_check_attainment type:~p~n", [Type]),

	try
		CompleteMap = get_complete_map(),
		CheckList = lists:foldl(
			fun(AttainID, List) ->
				case cfg_attainmentsNew:getRow(AttainID) of
					{} -> List;
					#attainmentsNewCfg{param = P} ->
						[{AttainType, _, _, _, _, _} | _] = P,
						case AttainType =:= Type of
							?TRUE ->
								case find_complete(AttainID, CompleteMap) of
									?FALSE -> [AttainID | List];
									_ -> List
								end;
							?FALSE -> List
						end
				end
			end, [], get_id_list(Type)),
%%		?LOG_INFO("do_check_attainment2 CheckList:~p~n", [CheckList]),
		ProgressMap = get_progress_map(),
		[check_new_att(ProgressMap, ID, Param) || ID <- CheckList]
	catch
		Why ->
			?LOG_ERROR("do_check_attainment faild, why:~p~n", [Why])
	end;
do_check_attainment(_, _) -> ok.

%% 隐形成就自动领取奖励 返回true
check_invisible(ID) ->
	case cfg_attainmentsNew:getRow(ID) of
		{} -> ?FALSE;
		#attainmentsNewCfg{page = Page, award = Award, title = TitleID, attaVal = AttVal} ->
			case Page of
				{0, 0} ->
%%					?LOG_INFO("check_invisible ID:~p~n", [ID]),
					%% 添加道具
					[{CareerCfg, _, B, Time, Multi}, {_, _, Ba, _, MultiA}] = Award,
					Career = role_data:get_leader_career(),

					currency:add(Ba, MultiA, ?Reason_Attainment_Award),
					%% 职业限定
					case CareerCfg =:= 0 of
						?TRUE ->
							bag_player:add([{B, Multi, Time, 0}], ?Reason_Attainment_Award),
							player_item:show_get_item_dialog([{B, Multi, Time, 0, 1}], [{Ba, MultiA, 1}], [], 0);
						?FALSE ->
							case CareerCfg =:= Career of
								?TRUE ->
									bag_player:add([{B, Multi, Time, 0}], ?Reason_Attainment_Award),
									player_item:show_get_item_dialog([{B, Multi, Time, 0, 1}], [{Ba, MultiA, 1}], [], 0);
								?FALSE ->
									player_item:show_get_item_dialog([], [{Ba, MultiA, 1}], [], 0)
							end
					end,

					%% 添加称号
					case TitleID =/= 0 of
						?TRUE -> player_title:on_add_title(TitleID);
						?FALSE -> ok
					end,

					OldPoint = variable_player:get_value(?FixedVariant_Index_68_AttPoint),
					NewPoint = OldPoint + AttVal,
					variable_player:set_value(?FixedVariant_Index_68_AttPoint, NewPoint),

					log_attain_award(ID, OldPoint, NewPoint, time:time()),
					?TRUE;
				_ ->
					?FALSE
			end
	end.

do_add_attain_progress(Type, {}) ->
	do_add_attain_progress(Type, {1, 0, 0, 0, 0});
do_add_attain_progress(Type, {Param1}) ->
	do_add_attain_progress(Type, {Param1, 0, 0, 0, 0});
do_add_attain_progress(Type, {Param1, Param2}) ->
	do_add_attain_progress(Type, {Param1, Param2, 0, 0, 0});
do_add_attain_progress(Type, {Param1, Param2, Param3}) ->
	do_add_attain_progress(Type, {Param1, Param2, Param3, 0, 0});
do_add_attain_progress(Type, {Param1, Param2, Param3, Param4}) ->
	do_add_attain_progress(Type, {Param1, Param2, Param3, Param4, 0});
do_add_attain_progress(Type, {Param1, Param2, Param3, Param4, Param5} = Param) ->
	ProgressMap = get_progress_map(),
	ChangeList = lists:foldl(
		fun(AttID, List) ->
			case check_att_id_type(AttID, Type, Param1, Param2, Param3, Param4, Param5, ProgressMap) of
				{?TRUE, Val} ->
					case find_progress(AttID, ProgressMap) of
						?FALSE ->
							[#attain_progress{id = AttID, progress = Val, today_progress = Val} | List];
						#attain_progress{progress = P, today_progress = TP} = AP ->
							case lists:member(Type, ?AttainmentsReplaceValue) of
								?FALSE ->
									[AP#attain_progress{progress = P + Val, today_progress = TP + Val} | List];
								?TRUE ->
									[AP#attain_progress{progress = Val, today_progress = Val} | List]
							end
					end;
				{?FALSE, _} -> List
			end
		end, [], get_id_list(Type)),
	update_progress_list(ChangeList, ProgressMap),
	do_check_attainment(Type, Param),
	ok;
do_add_attain_progress(_, _) ->
	ok.

%% 检查成就达成
check_new_att(ProgressMap, ID) ->
	check_new_att(ProgressMap, ID, {0, 0, 0, 0, 0}).
check_new_att(ProgressMap, ID, Param) ->
%%	?LOG_INFO("check_new_att ID:~p~n", [ID]),

	try

		CfgAtt = cfg_attainmentsNew:getRow(ID),
		case CfgAtt of
			{} -> throw(ok);
			_ -> ok
		end,
		case check_condition(ProgressMap, ID, Param) of
			?TRUE ->
				add_attainment(ID);
			?FALSE -> ok
		end
	catch
		_ -> ok
	end.

%% 新达成一个任务成就
add_attainment(ID) ->
%%	?LOG_INFO("add_attainment [id:~p] [attcompletelist:~p]~n", [ID, get_attain_complete()]),

	?metrics(begin
				 try
					 CompleteMap = get_complete_map(),
					 case find_complete(ID, CompleteMap) of
						 ?FALSE ->
							 IsGet = case check_invisible(ID) of
										 ?TRUE -> 1;
										 ?FALSE -> 0
									 end,
							 NewAtt = #attain_complete{id = ID, is_get = IsGet},
							 update_complete(NewAtt, CompleteMap),

							 log_attain_complete(ID),
							 case guide:is_open_action(?OpenAction_Attainment) of
								 ?TRUE -> [send_new_attainment(ID) || IsGet =:= 0];
								 ?FALSE -> ok
							 end,
							 ok;
						 _ ->
							 ?LOG_ERROR("add_attainment duplicate, id:~p~n", [ID])
					 end
				 catch
					 Why ->
						 ?LOG_ERROR("add_attainment failed, why:~p~n", [Why])
				 end end).

%% 通知客户端有新完成的成就任务
send_new_attainment(ID) ->
%%	?LOG_INFO("send_new_attainment ID:~p~n", [ID]),
	player:send(#pk_GS2U_sendReachAttainment{id = ID}).

attcomp_2_dbattcomp(AttComp) ->
	PlayerID = player:getPlayerID(),
	#attain_complete{
		id = ID,
		is_get = IsGet} = AttComp,
	#db_attain_complete{
		player_id = PlayerID,
		id = ID,
		is_get = IsGet}.

attprog_2_dbattprog(AttProg) ->
	PlayerID = player:getPlayerID(),
	#attain_progress{
		id = ID,
		progress = Progress,
		today_progress = TodayProgress} = AttProg,
	#db_attain_progress{
		player_id = PlayerID,
		id = ID,
		progress = Progress,
		today_progress = TodayProgress}.

%% 检查是否符合类型 是否可以添加/更改进度
%% 返回{false, 0}或者{true, val}
check_att_id_type(AttID, Type, Param1, Param2, Param3, _Param4, _Param5, ProgressMap) ->
	try
		AttCfg = cfg_attainmentsNew:getRow(AttID),
		case AttCfg =/= {} of
			?TRUE -> ok;
			?FALSE -> throw(?FALSE)
		end,
		[{T, P1, P2, P3, _P4, _P5} | _] = AttCfg#attainmentsNewCfg.param,
		case Type =:= T of
			?TRUE -> ok;
			?FALSE -> throw(?FALSE)
		end,

		case Type of
			?Attainments_Type_RuneIntLv ->
				{Param2 < P2 andalso P2 =< Param3, Param1};
			?Attainments_Type_RuneSyn ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_RuneUp ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_SoulIntLv ->
				{Param2 < P2 andalso P2 =< Param3, Param1};
			?Attainments_Type_SoulSyn ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_SoulUp ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_DungeonStoryChapter ->%%167
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonPetCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonMountCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonWingCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonGDCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonHolyCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonGDConsCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonPreDepositsCount ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonDepositsCount ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_ArenaWinCount ->
				{?TRUE, Param1};
			?Attainments_Type_DungeonExcellenceChapter ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_DungeonDragonConsum ->
				{Param2 =:= P2 andalso Param3 >= P3, Param1};
			?Attainments_Type_XORoomRightCount ->%%185
				{?TRUE, Param1};
			?Attainments_Type_WalkDemonTower ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_WalkDemonBossCount ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldKill ->
				{?TRUE, Param1};
			?Attainments_Type_Arena1v1WinCount ->
				{?TRUE, Param1};
			?Attainments_Type_MeleeKill ->
				{?TRUE, Param1};
			?Attainments_Type_AshuraKill ->
				{?TRUE, Param1};

			?Attainments_Type_ConvoyCount ->
				{?TRUE, Param1};
			?Attainments_Type_RobCount ->
				{?TRUE, Param1};

			?Attainments_Type_GuildTaskCount ->
				{?TRUE, Param1};
			?Attainments_Type_GuildRedPacketCount ->
				{?TRUE, Param1};
			?Attainments_Type_PVPKill ->
				{?TRUE, Param1};
			?Attainments_Type_PVPKillRed ->
				{?TRUE, Param1};
			?Attainments_Type_PVPKilled ->
				{?TRUE, Param1};
			?Attainments_Type_GoldGetCount ->%%198
				{?TRUE, Param1};
			?Attainments_Type_SignCount ->
				{?TRUE, Param1};
			?Attainments_Type_BagExtCell ->
				{?TRUE, Param1};
			?Attainments_Type_BountyTaskCount ->
				{?TRUE, Param1};
			?Attainments_Type_DemonSquare ->
				{?TRUE, Param1};
			?Attainments_Type_DungeonYanmoCount ->
				{?TRUE, Param1};
			?Attainments_Type_DemonsInvasionBoss ->
				{?TRUE, Param1};
			?Attainments_Type_PersonalBoss ->
				{?TRUE, Param1};
			?Attainments_Type_DemonsLairBoss ->
				{?TRUE, Param1};
			?Attainments_Type_CursePlaceBoss ->
				{?TRUE, Param1};
			?Attainments_Type_ShenmoBoss ->
				{?TRUE, Param1};
			?Attainments_Type_ShenmoClusterBoss ->
				{?TRUE, Param1};
			?Attainments_Type_WorldBossKill ->
				{?TRUE, Param1};
			?Attainments_Type_WorldBossJoin ->
				{?TRUE, Param1};
			?Attainments_Type_DailyTaskActivity ->
				{get_today_progress(AttID, ProgressMap) =:= 0 andalso Param2 >= P2, Param1};
			?Attainments_Type_DemonsInvClusterBoss ->
				{?TRUE, Param1};
			?Attainments_Type_HolyRuinsBoss ->%%232
				{?TRUE, Param1};

			?Attainments_Type_BlueDiamondCount ->%%302
				{?TRUE, Param1};
			?Attainments_Type_GreenDiamondCount ->%%303
				{?TRUE, Param1};
			?Attainments_Type_GreenAndBlueReincarnation ->%%304
				{?TRUE, Param1};
			?Attainments_Type_OnlineMinute ->%%306
				{?TRUE, Param1};
			?Attainments_Type_ActivationSkillLv ->%%310
				{Param2 =:= P2, Param1};
			?Attainments_Type_SkillReset ->%%311
				{?TRUE, Param1};
			?Attainments_Type_ModifyNameCount ->%%313
				{?TRUE, Param1};
			?Attainments_Type_ModifySexCount ->%%314
				{?TRUE, Param1};
			?Attainments_Type_Dyeing ->%%316
				{?TRUE, Param1};
			?Attainments_Type_MakeUp ->%%317
				{?TRUE, Param1};
			?Attainments_Type_MarketBuyItem ->%%325
				{?TRUE, Param1};
			?Attainments_Type_StarryFeastCount ->%%326
				{?TRUE, Param1};
			?Attainments_Type_TransactionBuyItem ->%%327
				{?TRUE, Param1};
			?Attainments_Type_BuyPassCheckCount ->%%330
				{?TRUE, Param1};
			?Attainments_Type_BuyMonthlyCard ->%%331
				{?TRUE, Param1};
			?Attainments_Type_BuyMonthly ->%%334
				{Param2 =:= P2, Param1};
			?Attainments_Type_SynthesisCardCount ->%%365
				{?TRUE, Param1};
			?Attainments_Type_RecastCardCount ->%%366
				{?TRUE, Param1};
			?Attainments_Type_DivineOrnamentStar ->%%368
				{?TRUE, Param1};
			?Attainments_Type_DivineOrnamentLv ->%%369
				{?TRUE, Param1};
			?Attainments_Type_BlessEqLvCount1 ->%%370
				{?TRUE, Param1};
			?Attainments_Type_BlessEqLvCount2 ->%%371
				{?TRUE, Param1};
			?Attainments_Type_Titan ->%%378
				{?TRUE, Param1};
			?Attainments_Type_TitanStar ->%%380
				{?TRUE, Param1};
			?Attainments_Type_GoldMysteryKillCount ->%%391
				{?TRUE, Param1};
			?Attainments_Type_GoldMysteryCommonChestCount ->%%392
				{?TRUE, Param1};
			?Attainments_Type_GoldMysteryHighChestCount ->%%393
				{?TRUE, Param1};
			?Attainments_Type_GoldMysteryCount ->%%394
				{?TRUE, Param1};
			?Attainments_Type_DarkCount ->%%395
				{?TRUE, Param1};
			?Attainments_Type_AssistKillCount ->%%396
				{?TRUE, Param1};
			?Attainments_Type_AssistKillCountEd ->%%397
				{?TRUE, Param1};
			?Attainments_Type_WingCopyCount ->%%399
				{P2 =:= Param2, Param1};
			?Attainments_Type_SkillChallengeStar3Count ->%%400
				{P2 =:= Param2 andalso Param3 >= P3, Param1};
			?Attainments_Type_BraveManCount ->%%401
				{?TRUE, Param1};
			?Attainments_Type_EqTreasureHuntCount ->%%404
				{?TRUE, Param1};
			?Attainments_Type_CardTreasureHuntCount ->%%405
				{?TRUE, Param1};
			?Attainments_Type_MeleeCount ->%%406
				{?TRUE, Param1};
			?Attainments_Type_AshuraCount ->%%407
				{?TRUE, Param1};
			?Attainments_Type_GuildHegemonyCount ->%%408
				{?TRUE, Param1};
			?Attainments_Type_BonfireCount ->%%409
				{?TRUE, Param1};
			?Attainments_Type_BossBonfireCount ->%%410
				{?TRUE, Param1};
			?Attainments_Type_XoRoomCount ->%%411
				{?TRUE, Param1};
			?Attainments_Type_GuildHegemonyKill ->%%412
				{?TRUE, Param1};
			?Attainments_Type_AshuraLiveCount ->%%413
				{?TRUE, Param1};
			?Attainments_Type_AshuraLv1Count ->%%414
				{?TRUE, Param1};
			?Attainments_Type_MeleeLv1Count ->%%415
				{?TRUE, Param1};
			?Attainments_Type_GuardWorldLv1Count ->%%416
				{?TRUE, Param1};
			?Attainments_Type_XORoomStakeCount ->%%417
				{?TRUE, Param1};
			?Attainments_Type_BountyTaskStarCount ->%%418
				{P2 =:= Param2, Param1};
			?Attainments_Type_ExpeditionCountCity0 ->%%419
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity1 ->%%420
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity2 ->%%421
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity3 ->%%422
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity4 ->%%423
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity5 ->%%424
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity6 ->%%425
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity7 ->%%426
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_ExpeditionCountCity8 ->%%427
				{border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2, Param1};
			?Attainments_Type_FastCrusadeCount ->%%429
				{?TRUE, Param1};
			?Attainments_Type_MoppingUpCount ->%%430
				{?TRUE, Param1};
			?Attainments_Type_GuildShipCount ->%%431
				{?TRUE, Param1};
			?Attainments_Type_RedGuildShipCount ->%%432
				{?TRUE, Param1};
			?Attainments_Type_VolleyGuildShipCount ->%%433
				{?TRUE, Param1};
			?Attainments_Type_TakeGuildShipCount ->%%434
				{?TRUE, Param1};
			?Attainments_Type_ArenaRankCount ->%%435
				{Param1 >= P1 andalso Param1 =< P2, 1};
			?Attainments_Type_Fight1V1WinCount ->%%436
				{king_1v1_player:get_player_season_id() =:= P2, Param1};
			?Attainments_Type_KillPlayer ->%%440
				{?TRUE, Param1};
			?Attainments_Type_PVPKillCount ->%%441
				{?TRUE, Param1};
			?Attainments_Type_GeneralDonationCount ->%%447
				{?TRUE, Param1};
			?Attainments_Type_HighDonationCount ->%%448
				{?TRUE, Param1};
			?Attainments_Type_GuildWishesCount ->%%449
				{?TRUE, Param1};
			?Attainments_Type_ReceiveGiftsCount ->%%450
				{?TRUE, Param1};
			?Attainments_Type_GiveEnduranceCount1 ->%%451
				{?TRUE, Param1};
			?Attainments_Type_GiveEnduranceCount2 ->%%452
				{?TRUE, Param1};
			?Attainments_Type_ReceivedEnduranceCount1 ->%%453
				{?TRUE, Param1};
			?Attainments_Type_ReceivedEnduranceCount2 ->%%454
				{?TRUE, Param1};
			?Attainments_Type_ChestDiamondsCount ->%%455
				{?TRUE, Param1};
			?Attainments_Type_AuctionCount ->%%456
				{?TRUE, Param1};
			?Attainments_Type_PantheonBp1Buy ->
				{?TRUE, Param1};
			?Attainments_Type_PantheonBp2Buy ->
				{?TRUE, Param1};
			?Attainments_Type_King1v1Bp1Buy ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_King1v1Bp2Buy ->
				{Param2 =:= P2, Param1};
			?Attainments_Type_BattleFieldJoin ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldPlayerKill ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldBossKill ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldCollectDiamond ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldCollectGold ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldCollectSilver ->
				{?TRUE, Param1};
			?Attainments_Type_BattleFieldCollectCopper ->
				{?TRUE, Param1};
			?Attainments_Type_BoneYardJoin ->
				{Param1 =:= P1, 1};
			?Attainments_Type_BoneYardMonsterKill ->
				{?TRUE, Param1};
			?Attainments_Type_BoneYardEliteBossKill ->
				{?TRUE, Param1};
			?Attainments_Type_BoneYardCallBossKill ->
				{?TRUE, Param1};
			?Attainments_Type_FaZhenRune_One_Attr ->
				Num = fazhen:get_fazhenrune_num_attr_num(Param1, P1, 1, 0),
				{?TRUE, Num};
			?Attainments_Type_FaZhenRune_Two_Attr ->
				Num = fazhen:get_fazhenrune_num_attr_num(Param1, P1, 2, 1),
				{?TRUE, Num};
			?Attainments_Type_FaZhenRune_Three_Attr ->
				Num = fazhen:get_fazhenrune_num_attr_num(Param1, P1, 3, 1),
				{?TRUE, Num};
			?Attainments_Type_RuneXunBao_Count ->%%486
				{?TRUE, Param1};
			?Attainments_Type_ReinBp1Buy ->%%487
				{?TRUE, Param1};
			?Attainments_Type_ReinBp2Buy ->%%488
				{?TRUE, Param1};
			?Attainments_Type_AbyssBpBuy1 ->%%489
				{?TRUE, Param1};
			?Attainments_Type_AbyssBpBuy2 ->%%490
				{?TRUE, Param1};
			?Attainments_Type_PetCityBpBuy1 ->%%491
				{?TRUE, Param1};
			?Attainments_Type_PetCityBpBuy2 ->%%492
				{?TRUE, Param1};
			?Attainments_Type_SoulStoneXunBao_Count ->%%493
				{?TRUE, Param1};
			?Attainments_Type_SealProve_Lv ->%%496
				{?TRUE, Param1};
			?Attainments_Type_EliteDungeonBpBuy1 ->%%497
				{?TRUE, Param1};
			?Attainments_Type_EliteDungeonBpBuy2 ->%%498
				{?TRUE, Param1};
			?Attainments_Type_EliteDungeonBpBuy3 ->%%499
				{?TRUE, Param1};
			?Attainments_Type_EliteDungeonBpBuy4 ->%%500
				{?TRUE, Param1};
			?Attainments_Type_GuildWarFlagCount ->%%501
				{?TRUE, Param1};
			?Attainments_Type_GuildWarPlayerKillCount ->%%502
				{?TRUE, Param1};
			?Attainments_Type_GuildWarBossKillCount ->%%503
				{?TRUE, Param1};
			?Attainments_Type_GuildWarPersonalScoreCount ->%%504
				{?TRUE, Param1};
			?Attainments_Type_GuildWarScoreRank ->%%505
				{Param2 =< P2, Param1};
			?Attainments_Type_GuildWarJoinCount ->%%506
				{get_today_progress(AttID, ProgressMap) == 0, Param1};
			?Attainments_Type_GuildWarWinCount ->%%507
				{?TRUE, Param1};
			?Attainments_Type_GuildWarQuarterCount ->%%508
				{get_today_progress(AttID, ProgressMap) == 0, Param1};
			?Attainments_Type_GuildWarSemiCount ->%%509
				{get_today_progress(AttID, ProgressMap) == 0, Param1};
			?Attainments_Type_GuildWarRank2Count ->%%510
				{?TRUE, Param1};
			?Attainments_Type_GuildWarRank1Count ->%%511
				{?TRUE, Param1};
			?Attainments_Type_LavaRankTimes ->
				{Param2 =< P2, Param1};
			?Attainments_Type_LavaDungeonPassTimes ->
				{Param2 >= P2 andalso Param3 == P3, Param1};
			?Attainments_Type_WeddingTimes ->
				{Param2 >= P2, Param1};
			?Attainments_Type_WeddingCardTimes ->
				{?TRUE, Param1};
			?Attainments_Type_HolyShieldBp ->
				{Param2 == P2 andalso Param3 == P3, Param1};
			?Attainments_Type_BlzJoinTimes ->
				{?TRUE, Param1};
			?Attainments_Type_BlzBigBossKill ->
				{?TRUE, Param1};
			?Attainments_Type_BlzBossKill ->
				{?TRUE, Param1};
			?Attainments_Type_ShengWenXunBao_Count ->%%531
				{?TRUE, Param1};
			?Attainments_Type_ShengJiaBpBuy ->%% 537
				{Param2 == P2 andalso Param3 == P3, Param1};
			?Attainments_Type_ManorWarJoin ->
				{get_today_progress(AttID, ProgressMap) == 0, Param1};
			?Attainments_Type_ManorWarRank ->
				{Param2 =< P2, Param1};
			?Attainments_Type_ElementContinentTotem ->
				{?TRUE, Param1};
			?Attainments_Type_TeamEqPassNum ->%%543
				{Param2 == P2, Param1};
			?Attainments_Type_TeamCouplePassNum ->
				{?TRUE, Param1};
			_ ->
				{?FALSE, 0}
		end
	catch
		_ -> {?FALSE, 0}
	end.

%% 检查成就是否完成
check_condition(ProgressMap, ID) ->
	check_condition(ProgressMap, ID, {0, 0, 0, 0, 0}).
%%
check_condition(ProgressMap, ID, {}) ->
	check_condition(ProgressMap, ID, {0, 0, 0, 0, 0});
check_condition(ProgressMap, ID, {Param1}) ->
	check_condition(ProgressMap, ID, {Param1, 0, 0, 0, 0});
check_condition(ProgressMap, ID, {Param1, Param2}) ->
	check_condition(ProgressMap, ID, {Param1, Param2, 0, 0, 0});
check_condition(ProgressMap, ID, {Param1, Param2, Param3}) ->
	check_condition(ProgressMap, ID, {Param1, Param2, Param3, 0, 0});
check_condition(ProgressMap, ID, {Param1, Param2, Param3, Param4}) ->
	check_condition(ProgressMap, ID, {Param1, Param2, Param3, Param4, 0});
check_condition(ProgressMap, ID, {Param1, Param2, _Param3, _Param4, _Param5} = _Param) ->
%%	?LOG_INFO("check_condition ID:~p~n", [ID]),

	try
		CurProgress = get_progress(ID, ProgressMap),

		AttCfg = cfg_attainmentsNew:getRow(ID),
		case AttCfg =/= {} of
			?TRUE -> ok;
			?FALSE -> throw(0)
		end,
		[{Type, P1, P2, P3, _P4, _P5} | _] = AttCfg#attainmentsNewCfg.param,

		case Type of
			?Attainments_Type_AttPoint ->%%101
				CurProgress >= P1;
			?Attainments_Type_Level ->
				CurProgress >= P1;
			?Attainments_Type_WingLv ->
				CurProgress >= P1;
			?Attainments_Type_WingStar ->
				CurProgress >= P1;
			?Attainments_Type_WingFeather ->
				CurProgress >= P1;
			?Attainments_Type_WingSublimate ->
				CurProgress >= P1;
			?Attainments_Type_YilingPill ->
				CurProgress >= P1;
			?Attainments_Type_YilingLv ->
				CurProgress >= P1;
			?Attainments_Type_FWingLv ->
				CurProgress >= P1;
			?Attainments_Type_WingCount ->
				CurProgress >= P1;
			?Attainments_Type_CareerLv ->
				CurProgress >= P1;
			?Attainments_Type_MountLv ->
				CurProgress >= P1;
			?Attainments_Type_MountStar ->
				CurProgress >= P1;
			?Attainments_Type_MountFeather ->
				CurProgress >= P1;
			?Attainments_Type_MountSublimate ->
				CurProgress >= P1;
			?Attainments_Type_MountPill ->
				CurProgress >= P1;
			?Attainments_Type_MountSoulLv ->
				CurProgress >= P1;
			?Attainments_Type_MountCount ->
				CurProgress >= P1;
			?Attainments_Type_PetLv ->
				CurProgress >= P1;
			?Attainments_Type_PetStar ->
				CurProgress >= P1;
			?Attainments_Type_PetFeather ->
				CurProgress >= P1;
			?Attainments_Type_PetSublimate ->
				CurProgress >= P1;
			?Attainments_Type_PetPill ->
				CurProgress >= P1;
			?Attainments_Type_PetSoulLv ->
				CurProgress >= P1;
			?Attainments_Type_PetCount ->
				CurProgress >= P1;
			?Attainments_Type_EqIntensify ->
				CurProgress >= P1;
			?Attainments_Type_EqAdd ->
				CurProgress >= P1;
			?Attainments_Type_EqRefine ->
				CurProgress >= P1;
			?Attainments_Type_EqGem ->
				CurProgress >= P1;
			?Attainments_Type_GemRefine ->
				CurProgress >= P1;
			?Attainments_Type_EqSuit ->
				CurProgress >= P1;
			?Attainments_Type_EqBase1 ->
				CurProgress > 0;
			?Attainments_Type_EqBase2 ->
				CurProgress > 0;
			?Attainments_Type_HolyLv ->
				CurProgress >= P1;
			?Attainments_Type_HolyStar ->
				CurProgress >= P1;
			?Attainments_Type_HolyRefine ->
				CurProgress >= P1;
			?Attainments_Type_HolyPill ->
				CurProgress >= P1;
			?Attainments_Type_HolyCount ->
				CurProgress >= P1;
			?Attainments_Type_HolySoulLv ->
				CurProgress >= P1;
			?Attainments_Type_GDMainCount ->
				CurProgress >= P1;
			?Attainments_Type_GDMainLv ->
				CurProgress >= P1;
			?Attainments_Type_GDMainStar ->
				CurProgress >= P1;
			?Attainments_Type_GDElfCount ->
				CurProgress >= P1;
			?Attainments_Type_GDElfLv ->
				CurProgress >= P1;
			?Attainments_Type_GDElfStar ->
				CurProgress >= P1;
			?Attainments_Type_GDWeaponCount ->
				CurProgress >= P1;
			?Attainments_Type_GDWeaponLv ->
				CurProgress >= P1;
			?Attainments_Type_GDConsCount ->
				CurProgress >= P1;
			?Attainments_Type_GDConsLv ->
				CurProgress >= P1;
			?Attainments_Type_RuneCount ->
				CurProgress >= P1;
			?Attainments_Type_RuneIntLv ->
				CurProgress >= P1;
			?Attainments_Type_RuneSyn ->
				CurProgress >= P1;
			?Attainments_Type_RuneUp ->
				?FALSE;
			?Attainments_Type_SoulCount ->
				CurProgress >= P1;
			?Attainments_Type_SoulIntLv ->
				CurProgress >= P1;
			?Attainments_Type_SoulSyn ->
				CurProgress >= P1;
			?Attainments_Type_SoulUp ->
				?FALSE;
			?Attainments_Type_Card1 ->
				CurProgress >= P1;
			?Attainments_Type_Card2 ->
				CurProgress >= P1;
			?Attainments_Type_Card3 ->
				CurProgress >= P1;
			?Attainments_Type_AstroEqCount ->
				CurProgress >= P1;
			?Attainments_Type_AstroEqInt ->
				CurProgress >= P1;
			?Attainments_Type_AstroCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonStoryChapter ->
				CurProgress >= P1;
			?Attainments_Type_PagodaLv ->
				CurProgress >= P1;
			?Attainments_Type_DungeonPetCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonMountCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonWingCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonGDCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonHolyCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonGDConsCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonPreDepositsCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonDepositsCount ->
				CurProgress >= P1;
			?Attainments_Type_ArenaWinCount ->
				CurProgress >= P1;
			?Attainments_Type_ArenaTop ->
				CurProgress =/= 0 andalso CurProgress =< P2;
			?Attainments_Type_DungeonExcellenceChapter ->
				CurProgress >= P1;
			?Attainments_Type_DungeonDragonConsum ->
				CurProgress >= P1;
			?Attainments_Type_WalkDemonTower ->
				CurProgress >= P1;
			?Attainments_Type_WalkDemonBossCount ->
				CurProgress >= P1;
			?Attainments_Type_WalkDemonClearStar ->
				?FALSE;
			?Attainments_Type_BattleFieldKill ->
				CurProgress >= P1;
			?Attainments_Type_XORoomRightCount -> %% 185
				CurProgress >= P1;
			?Attainments_Type_Arena1v1WinCount ->
				CurProgress >= P1;
			?Attainments_Type_MeleeKill ->
				CurProgress >= P1;
			?Attainments_Type_AshuraKill ->
				CurProgress >= P1;
			?Attainments_Type_AshuraTop ->
				CurProgress =/= 0 andalso CurProgress =< P2;
			?Attainments_Type_ConvoyCount ->
				CurProgress >= P1;
			?Attainments_Type_RobCount ->
				CurProgress >= P1;
			?Attainments_Type_GuildDefDamageTop ->
				Param2 =/= 0 andalso Param2 =< P2;
			?Attainments_Type_GuildTaskCount ->
				CurProgress >= P1;
			?Attainments_Type_GuildRedPacketCount ->
				CurProgress >= P1;
			?Attainments_Type_PVPKill ->
				CurProgress >= P1;
			?Attainments_Type_PVPKillRed ->
				CurProgress >= P1;
			?Attainments_Type_PVPKilled ->
				CurProgress >= P1;
			?Attainments_Type_GoldGetCount ->
				CurProgress >= P1;
			?Attainments_Type_SignCount ->
				CurProgress >= P1;
			?Attainments_Type_BagExtCell ->
				CurProgress >= P1;
			?Attainments_Type_StorageExtCell ->
				?FALSE;
			?Attainments_Type_MonsterKillCount ->
				CurProgress >= P1;
			?Attainments_Type_BountyTaskCount ->
				CurProgress >= P1;
			?Attainments_Type_LordRingEqCount ->
				CurProgress >= P1;
			?Attainments_Type_HonorLv ->
				CurProgress >= P1;
			?Attainments_Type_FriendsCount ->
				CurProgress >= P1;
			?Attainments_Type_DemonSquare ->
				CurProgress >= P1;
			?Attainments_Type_DungeonYanmoCount ->
				CurProgress >= P1;
			?Attainments_Type_DungeonYanmoTop ->
				Param2 =/= 0 andalso Param2 =< P2;
			?Attainments_Type_DemonsInvasionBoss ->
				CurProgress >= P1;
			?Attainments_Type_PersonalBoss ->
				CurProgress >= P1;
			?Attainments_Type_DemonsLairBoss ->
				CurProgress >= P1;
			?Attainments_Type_CursePlaceBoss ->
				CurProgress >= P1;
			?Attainments_Type_ShenmoBoss ->
				CurProgress >= P1;
			?Attainments_Type_ShenmoClusterBoss ->
				CurProgress >= P1;
			?Attainments_Type_WorldBossKill ->
				CurProgress >= P1;
			?Attainments_Type_WorldBossJoin ->
				CurProgress >= P1;
			?Attainments_Type_DailyTaskActivity ->
				CurProgress >= P1;
			?Attainments_Type_ProphecyCompleteID ->
				Param2 =:= P2;
			?Attainments_Type_AlchemyLv ->
				CurProgress >= P1;
			?Attainments_Type_PetEqCount ->
				CurProgress >= P1;
			?Attainments_Type_MountEqCount ->
				CurProgress >= P1;
			?Attainments_Type_WingEqCount ->
				CurProgress >= P1;
			?Attainments_Type_JoinGuild ->
				CurProgress > 0;
			?Attainments_Type_Fight1v1 ->
				Param1 >= P1;
			?Attainments_Type_Fight2v2 ->
				?FALSE;
			?Attainments_Type_Fight3v3 ->
				Param1 >= P1;
			?Attainments_Type_SkillLv ->
				CurProgress >= P1;
			?Attainments_Type_DemonsInvClusterBoss ->
				CurProgress >= P1;
			?Attainments_Type_GodLevel ->
				Param2 =/= 0 andalso Param2 =< P2;
			?Attainments_Type_HolyRuinsBoss ->
				CurProgress >= P1;
			?Attainments_Type_Reincarnation ->%%转生次数 301
				CurProgress >= P1;
			?Attainments_Type_BlueDiamondCount ->%%累计获得钻石数量 302
				CurProgress >= P1;
			?Attainments_Type_GreenDiamondCount ->%%累计获得绿钻数量 303
				CurProgress >= P1;
			?Attainments_Type_GreenAndBlueReincarnation ->%%累计获得钻石和绿钻数量 304
				CurProgress >= P1;
			?Attainments_Type_VipLv ->  %%VIP达到XX级 305
				CurProgress >= P1;
			?Attainments_Type_OnlineMinute ->  %%累计在线分钟 306
				CurProgress >= P1;
			?Attainments_Type_SkillBreachLv ->  %%XX个技能突破达到XX级 307
				CurProgress >= P1;
			?Attainments_Type_SkillawakenLvCount ->  %%XX个技能觉醒达到XX级 308
				CurProgress >= P1;
			?Attainments_Type_ActivationSkill ->  %%激活奥义*XXX技能 309
				CurProgress =:= P1;
			?Attainments_Type_ActivationSkillLv ->  %%XX个技能觉醒达到XX级 310
				CurProgress >= P1;
			?Attainments_Type_SkillReset ->  %%XX个技能觉醒达到XX级 311
				CurProgress >= P1;
			?Attainments_Type_GodGifts ->  %%激活XX品质的神的馈赠XX个 312
				CurProgress >= P1;
			?Attainments_Type_ModifyNameCount ->%%修改角色名字XX次 313
				CurProgress >= P1;
			?Attainments_Type_ModifySexCount ->%%修改性别XX次 314
				CurProgress >= P1;
			?Attainments_Type_Fashion ->%%激活一套XXX时装 315
				dress_up:is_active_topic(P1) orelse dress_up:is_active_topic(P2) orelse dress_up:is_active_topic(P3) orelse dress_up:is_active_topic(_P4);
			?Attainments_Type_Dyeing ->%%对主角进行XX次染色 316
				CurProgress >= P1;
			?Attainments_Type_MakeUp ->%%对主角进行XX次化妆 317
				CurProgress >= P1;
			?Attainments_Type_HeadCount ->%%激活XX个头像 318
				CurProgress >= P1;
			?Attainments_Type_HeadStarCount ->%%XX个头像升星到X星 319
				CurProgress >= P1;
			?Attainments_Type_HeadBoxCount ->%%激活XX个头像框 320
				CurProgress >= P1;
			?Attainments_Type_HeadBoxStarCount ->%%XX个头像框升星到X星 321
				CurProgress >= P1;
			?Attainments_Type_ChatBubbleCount ->%%激活XX个聊天气泡 322
				CurProgress >= P1;
			?Attainments_Type_ChatBubbleStarCount ->%%XX个聊天气泡升星到X星 323
				CurProgress >= P1;
			?Attainments_Type_UnlockDevour ->%%解锁吞噬特权 324
				Param1 =:= 1;
			?Attainments_Type_MarketBuyItem ->%%神秘集市中购买道具XXX次 325
				CurProgress >= P1;
			?Attainments_Type_StarryFeastCount ->%%参加XX次星空盛宴 326
				CurProgress >= P1;
			?Attainments_Type_TransactionBuyItem ->%%交易行中购买道具XX次 327
				CurProgress >= P1;
			?Attainments_Type_BuyWarToken ->%%在X赛季中，购买征战令牌 328
				CurProgress =:= P1;
			?Attainments_Type_BuyCertificateHonor ->%%在X赛季中，购买荣誉证书 329
				CurProgress =:= P1;
			?Attainments_Type_BuyPassCheckCount ->%%购买日常通行证XX次 330
				CurProgress >= P1;
			?Attainments_Type_BuyMonthlyCard ->%%购买月卡特权次数 331
				CurProgress >= P1;
			?Attainments_Type_BuyLifetimeCard ->%%购买XX终身卡 332
				CurProgress =:= P1;
			?Attainments_Type_BuyFund ->%%购买XX基金 333
				CurProgress =:= P1;
			?Attainments_Type_BuyMonthly ->%%购买XX次月理财 334
				CurProgress >= P1;
			?Attainments_Type_BuyWarOrder ->%%购买XX次战令 335
				CurProgress =:= P2;
			?Attainments_Type_SSRHeroCount ->%%激活X个Y品质的英雄 336
				CurProgress >= P1;
			?Attainments_Type_SPHeroCount ->%%激活X个英雄 337
				CurProgress >= P1;
			?Attainments_Type_PetRingCount ->%%装配X件X品质的英雄戒指 338
				CurProgress >= P1;
			?Attainments_Type_PetBlessEQCount ->%%装配X件X品质的英雄装备 339
				CurProgress >= P1;
			?Attainments_Type_PetAssistCount ->%%X个英雄助战 340
				CurProgress >= P1;
			?Attainments_Type_PetResonanceCount ->%%X个英雄共鸣圣树 341
				CurProgress >= P1;

			?Attainments_Type_WingUpCount ->%%X个翅膀装备升级到XX级 342--这里有问题，没看出来
				CurProgress >= P1;
			?Attainments_Type_WingReinCount ->%%X翅膀转生 343
				CurProgress >= P1;
			?Attainments_Type_MountEqLvCount ->%%X个坐骑装备升级到XX级 344
				CurProgress >= P1;
			?Attainments_Type_MountReinCount ->%%X坐骑转生 345
				CurProgress >= P1;
			?Attainments_Type_SacredObjectAwakenCount ->%%X个圣物觉醒到X 346
				CurProgress >= P1;
			?Attainments_Type_SacredObjectGrade ->%%X个圣物升品到X 347
				CurProgress >= P1;
			?Attainments_Type_SacredObjectCount ->%%装配X个X品质圣印 348
				CurProgress >= P1;
			?Attainments_Type_SacredObjectLvCount ->%%装配X个X品质圣印升级到X级 349
				CurProgress >= P1;
			?Attainments_Type_MaxCombinationSkillsCount ->%%激活X个最高组合技能 350
				CurProgress >= P1;

			?Attainments_Type_GodStatueCount ->%%激活X个神像 351
				CurProgress >= P1;
			?Attainments_Type_GodStatueLvCount ->%%X个神像强化到X阶 352
				CurProgress >= P1;
			?Attainments_Type_GodStatueStarCount ->%%353
				CurProgress >= P1;
			?Attainments_Type_GodStatueWingQuCount ->%%354
				CurProgress >= P1;
			?Attainments_Type_GodStatueGodEqCount ->%%355
				CurProgress >= P1;
			?Attainments_Type_GuardCount ->%%356
				CurProgress >= P1;
			?Attainments_Type_GuardLvCount ->%%357
				CurProgress >= P1;
			?Attainments_Type_GuardQuCount ->%%358
				CurProgress >= P1;
			?Attainments_Type_GemstoneCount ->%%359
				CurProgress >= P1;
			?Attainments_Type_CoreGemstoneCount ->%%360
				CurProgress >= P1;
			?Attainments_Type_HighGemstoneCount ->%%361
				CurProgress >= P1;
			?Attainments_Type_WearEqLvQuStarCount1 ->%%362
				CurProgress >= P1;
			?Attainments_Type_WearEqLvQuStarCount2 ->%%363
				CurProgress >= P1;
			?Attainments_Type_EquipQuCardCount ->%%364
				CurProgress >= P1;
			?Attainments_Type_SynthesisCardCount ->%%365
				CurProgress >= P1;
			?Attainments_Type_RecastCardCount ->%%366
				CurProgress >= P1;
			?Attainments_Type_DivineOrnamentCount ->%%367
				CurProgress >= P1;
			?Attainments_Type_DivineOrnamentStar ->%%368
				CurProgress >= P1 andalso P2 >= Param2;
			?Attainments_Type_DivineOrnamentLv ->%%369
				CurProgress >= P1 andalso P2 >= Param2;
			?Attainments_Type_BlessEqLvCount1 ->%%370
				eq:check_bless_eq_polarity(1, P2) >= P1;
			?Attainments_Type_BlessEqLvCount2 ->%%371
				eq:check_bless_eq_polarity(2, P2) >= P1;
			?Attainments_Type_RingStarCount ->%%372
				CurProgress >= P1;
			?Attainments_Type_CollectionLvQuStarCount1 ->%%373
				CurProgress >= P1;
			?Attainments_Type_CollectionLvQuStarCount2 ->%%374
				CurProgress >= P1;
			?Attainments_Type_EqRegenerateLvCount1 ->%%375
				CurProgress >= P1;
			?Attainments_Type_EqRegenerateLvCount2 ->%%376
				CurProgress >= P1;
			?Attainments_Type_EqRegenerateLvCount3 ->%%377
				CurProgress >= P1;
			?Attainments_Type_Titan ->%%378
				constellation:is_active_season_constellation(P1);
			?Attainments_Type_EquipQuTitanEqCount ->%%379
				CurProgress >= P1;
			?Attainments_Type_TitanStar ->%%380
				Param1 =:= P2 andalso constellation:get_season_constellation_star(P2) >= P1;
			?Attainments_Type_GodStoneLvCount ->%%381
				CurProgress >= P1;
			?Attainments_Type_DivineTroopCount ->%%382
				CurProgress >= P1;
			?Attainments_Type_DivineTroopsCount ->%%383
				CurProgress >= P1;
			?Attainments_Type_DivineTroopLv ->%%384
				CurProgress >= P1;
			?Attainments_Type_DivineTroopStar ->%%385
				CurProgress >= P1;
			?Attainments_Type_QiLingLv ->%%386
				CurProgress >= P1;
			?Attainments_Type_QuGoldContract ->%%387
				CurProgress >= P1;
			?Attainments_Type_GoldContractLv ->%%388
				CurProgress >= P1;
			?Attainments_Type_GoldContractQu ->%%389
				CurProgress >= P1;
			?Attainments_Type_AssistWarCount ->%%390
				CurProgress >= P1;
			?Attainments_Type_GoldMysteryKillCount ->%%391
				CurProgress >= P1;
			?Attainments_Type_GoldMysteryCommonChestCount ->%%392
				CurProgress >= P1;
			?Attainments_Type_GoldMysteryHighChestCount ->%%393
				CurProgress >= P1;
			?Attainments_Type_GoldMysteryCount ->%%394
				CurProgress >= P1;
			?Attainments_Type_DarkCount ->%%395
				CurProgress >= P1;
			?Attainments_Type_AssistKillCount ->%%396
				CurProgress >= P1;
			?Attainments_Type_AssistKillCountEd ->%%397
				CurProgress >= P1;
			?Attainments_Type_PetPagodaCount ->%%398
				CurProgress >= P1;
			?Attainments_Type_WingCopyCount ->%%399
				CurProgress >= P1;
			?Attainments_Type_SkillChallengeStar3Count ->%%400
				CurProgress >= P1;
			?Attainments_Type_BraveManCount ->%%401
				CurProgress >= P1;
			?Attainments_PetCallCount ->%%402
				CurProgress >= P1;
			?Attainments_Type_PetDestinyCallCount ->%%403
				CurProgress >= P1;
			?Attainments_Type_EqTreasureHuntCount ->%%404
				CurProgress >= P1;
			?Attainments_Type_CardTreasureHuntCount ->%%405
				CurProgress >= P1;
			?Attainments_Type_MeleeCount ->%%406
				CurProgress >= P1;
			?Attainments_Type_AshuraCount ->%%407
				CurProgress >= P1;
			?Attainments_Type_GuildHegemonyCount ->%%408
				CurProgress >= P1;
			?Attainments_Type_BonfireCount ->%%409
				CurProgress >= P1;
			?Attainments_Type_BossBonfireCount ->%%410
				CurProgress >= P1;
			?Attainments_Type_XoRoomCount ->%%411
				CurProgress >= P1;
			?Attainments_Type_GuildHegemonyKill ->%%412
				CurProgress >= P1;
			?Attainments_Type_AshuraLiveCount ->%%413
				CurProgress >= P1;
			?Attainments_Type_AshuraLv1Count ->%%414
				CurProgress >= P1;
			?Attainments_Type_MeleeLv1Count ->%%415
				CurProgress >= P1;
			?Attainments_Type_GuardWorldLv1Count ->%%416
				CurProgress >= P1;
			?Attainments_Type_XORoomStakeCount ->%%417
				CurProgress >= P1;
			?Attainments_Type_BountyTaskStarCount ->%%418
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity0 ->%%419
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity1 ->%%420
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity2 ->%%421
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity3 ->%%422
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity4 ->%%423
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity5 ->%%424
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity6 ->%%425
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity7 ->%%426
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity8 ->%%427
				CurProgress >= P1;
			?Attainments_Type_ExpeditionCountCity9 ->%%在X赛季中，爵位达到XX 428
				border_war_player_bp:on_get_player_season(player:getPlayerID()) =:= P2 andalso Param1 >= P1;
			?Attainments_Type_FastCrusadeCount ->%%429
				CurProgress >= P1;
			?Attainments_Type_MoppingUpCount ->%%430
				CurProgress >= P1;
			?Attainments_Type_GuildShipCount ->%%431
				CurProgress >= P1;
			?Attainments_Type_RedGuildShipCount ->%%432
				CurProgress >= P1;
			?Attainments_Type_VolleyGuildShipCount ->%%433
				CurProgress >= P1;
			?Attainments_Type_TakeGuildShipCount ->%%434
				CurProgress >= P1;
			?Attainments_Type_ArenaRankCount ->%%竞技场排名 435
				CurProgress =:= 1;
			?Attainments_Type_Fight1V1WinCount ->%%436
				CurProgress >= P1;
			?Attainments_Type_Fight1V1Lv ->%%437
				king_1v1_player:get_player_season_id() =:= P2 andalso CurProgress >= P1;
			?Attainments_Type_Fight1V1Finals ->% 438
				king_1v1_player:get_player_season_id() =:= P2 andalso Param1 =:= 1;
			?Attainments_Type_Fight1V1Rank ->%% 439
				king_1v1_player:get_player_season_id() =:= P3 andalso Param1 >= P1 andalso Param1 =< P2;
			?Attainments_Type_KillPlayer ->%%440
				CurProgress >= P1;
			?Attainments_Type_PVPKillCount ->%%441
				CurProgress >= P1;
			?Attainments_Type_1v1TrophyCount ->%%激活X个1v1奖杯 442
				CurProgress >= P1;
			?Attainments_Type_1v1TrophyQu ->%%任意1v1奖杯提升到X品质 443
				CurProgress >= P1;
			?Attainments_Type_1v1TrophyLv ->%%任意1v1奖杯升级到X级 444
				CurProgress >= P1;
			?Attainments_Type_1v1TrophyQuCount ->%%X个1v1奖杯提升到X品质 445
				CurProgress >= P1;
			?Attainments_Type_1v1TrophyLvCount ->%%X个1v1奖杯升级到X级 446
				CurProgress >= P1;
			?Attainments_Type_GeneralDonationCount ->%%447
				CurProgress >= P1;
			?Attainments_Type_HighDonationCount ->%%448
				CurProgress >= P1;
			?Attainments_Type_GuildWishesCount ->%%449
				CurProgress >= P1;
			?Attainments_Type_ReceiveGiftsCount ->%%450
				CurProgress >= P1;
			?Attainments_Type_GiveEnduranceCount1 ->%%451
				CurProgress >= P1;
			?Attainments_Type_GiveEnduranceCount2 ->%%452
				CurProgress >= P1;
			?Attainments_Type_ReceivedEnduranceCount1 ->%%453
				CurProgress >= P1;
			?Attainments_Type_ReceivedEnduranceCount2 ->%%454
				CurProgress >= P1;
			?Attainments_Type_ChestDiamondsCount ->%%455
				CurProgress >= P1;
			?Attainments_Type_AuctionCount ->%%456
				CurProgress >= P1;
			?Attainments_Type_GainRing ->%%获得XX魔戒(1麻痹戒指，2治疗戒指，3复活戒指，4护身戒指) 457
				lord_ring:has_ring(P1, 0);
			?Attainments_Type_RingStar ->%%XX魔戒升星到X星 458
				lord_ring:has_ring(P2, P1);
			?Attainments_Type_WingAllCount ->%%翅膀总数量459
				CurProgress >= P1;
			?Attainments_Type_MountAllCount ->%%坐骑总数量 460
				CurProgress >= P1;
			?Attainments_Type_PantheonBp1Buy ->%%461
				CurProgress >= P1;
			?Attainments_Type_PantheonBp2Buy ->%%462
				CurProgress >= P1;
			?Attainments_Type_King1v1Bp1Buy ->%%463
				CurProgress >= P1;
			?Attainments_Type_King1v1Bp2Buy ->%%464
				CurProgress >= P1;
			?Attainments_Type_BattleFieldJoin ->%%465
				CurProgress >= P1;
			?Attainments_Type_BattleFieldPlayerKill ->%%466
				CurProgress >= P1;
			?Attainments_Type_BattleFieldBossKill ->%%467
				CurProgress >= P1;
			?Attainments_Type_BattleFieldCollectDiamond ->%%468
				CurProgress >= P1;
			?Attainments_Type_BattleFieldCollectGold ->%%469
				CurProgress >= P1;
			?Attainments_Type_BattleFieldCollectSilver ->%%470
				CurProgress >= P1;
			?Attainments_Type_BattleFieldCollectCopper ->%%471
				CurProgress >= P1;
			?Attainments_Type_BoneYardJoin -> %% 472
				CurProgress >= 1;
			?Attainments_Type_BoneYardMonsterKill -> %% 473
				CurProgress >= P1;
			?Attainments_Type_BoneYardEliteBossKill ->%% 474
				CurProgress >= P1;
			?Attainments_Type_BoneYardCallBossKill ->%% 475
				CurProgress >= P1;
			?Attainments_Type_Relic_Illusion_Qu ->%%476
				CurProgress >= P1;
			?Attainments_Type_Relic_Illusion_Star ->%%477
				CurProgress >= P1;
			?Attainments_Type_Relic_Illusion_ReinCount ->%%478
				CurProgress >= P1;
			?Attainments_Type_FaZhen_Char_Num ->%%479
				CurProgress >= P1;
			?Attainments_Type_FaZhenRune_One_Attr ->%%480
				CurProgress >= P1;
			?Attainments_Type_FaZhenRune_Two_Attr ->%%481
				CurProgress >= P1;
			?Attainments_Type_FaZhenRune_Three_Attr ->%%482
				CurProgress >= P1;
			?Attainments_Type_FaZhenRune_Attr ->%%483
				CurProgress >= P1;
			?Attainments_Type_FaZhenRune_Star_Num ->%%484
				CurProgress >= P1;
			?Attainments_Type_FaZhen_Star_Num ->%%485
				CurProgress >= P1;
			?Attainments_Type_RuneXunBao_Count ->%%486
				CurProgress >= P1;
			?Attainments_Type_ReinBp1Buy ->%%487
				CurProgress >= P1;
			?Attainments_Type_ReinBp2Buy ->%%488
				CurProgress >= P1;
			?Attainments_Type_AbyssBpBuy1 ->%%489
				CurProgress >= P1;
			?Attainments_Type_AbyssBpBuy2 ->%%490
				CurProgress >= P1;
			?Attainments_Type_PetCityBpBuy1 ->%%491
				CurProgress >= P1;
			?Attainments_Type_PetCityBpBuy2 ->%%492
				CurProgress >= P1;
			?Attainments_Type_SoulStoneXunBao_Count ->%%493
				CurProgress >= P1;
			?Attainments_Type_PetEq_SoulStone_Lv_Num ->%%494
				CurProgress >= P1;
			?Attainments_Type_ShouLingEq_Star_Num ->%%495
				CurProgress >= P1;
			?Attainments_Type_SealProve_Lv ->%%496
				CurProgress >= P1;
			?Attainments_Type_EliteDungeonBpBuy1 ->%%497
				CurProgress >= P1;
			?Attainments_Type_EliteDungeonBpBuy2 ->%%498
				CurProgress >= P1;
			?Attainments_Type_EliteDungeonBpBuy3 ->%%499
				CurProgress >= P1;
			?Attainments_Type_EliteDungeonBpBuy4 ->%%500
				CurProgress >= P1;
			?Attainments_Type_GuildWarFlagCount ->%%501
				CurProgress >= P1;
			?Attainments_Type_GuildWarPlayerKillCount ->%%502
				CurProgress >= P1;
			?Attainments_Type_GuildWarBossKillCount ->%%503
				CurProgress >= P1;
			?Attainments_Type_GuildWarPersonalScoreCount ->%%504
				CurProgress >= P1;
			?Attainments_Type_GuildWarScoreRank ->%%505
				Param2 =/= 0 andalso Param2 =< P2;
			?Attainments_Type_GuildWarJoinCount ->%%506
				CurProgress >= P1;
			?Attainments_Type_GuildWarWinCount ->%%507
				CurProgress >= P1;
			?Attainments_Type_GuildWarQuarterCount ->%%508
				CurProgress >= P1;
			?Attainments_Type_GuildWarSemiCount ->%%509
				CurProgress >= P1;
			?Attainments_Type_GuildWarRank2Count ->%%510
				CurProgress >= P1;
			?Attainments_Type_GuildWarRank1Count ->%%511
				CurProgress >= P1;
			?Attainments_Type_LavaRankTimes ->
				CurProgress >= P1;
			?Attainments_Type_LavaDungeonPassTimes ->
				CurProgress >= P1;
			?Attainments_Type_SacredEqCount ->%%514
				CurProgress >= P1;
			?Attainments_Type_WeddingTimes ->%%515
				CurProgress >= P1;
			?Attainments_Type_WeddingCardTimes ->%%516
				CurProgress >= P1;
			?Attainments_Type_HolyShieldStage ->
				CurProgress >= P1;
			?Attainments_Type_HolyShieldBp ->
				CurProgress >= P1;
			?Attainments_Type_HolyShieldLevel ->
				CurProgress >= P1;
			?Attainments_Type_HolyShieldSkill ->
				CurProgress >= P1;
			?Attainments_Type_BlzJoinTimes ->
				CurProgress >= P1;
			?Attainments_Type_BlzLayer ->
				CurProgress >= P1;
			?Attainments_Type_BlzBigBossKill ->
				CurProgress >= P1;
			?Attainments_Type_BlzBossKill ->
				CurProgress >= P1;
			?Attainments_Type_ManorWarJoin ->
				CurProgress >= P1;
			?Attainments_Type_ManorWarRank ->
				CurProgress >= P1;
			?Attainments_Type_PetIllusionRefineNum ->
				CurProgress >= P1;
			?Attainments_Type_AltarHeroCount ->
				CurProgress >= P1;
			?Attainments_Type_AltarStoneLvTotal ->
				CurProgress >= P1;
			?Attainments_Type_ShengWenXunBao_Count ->%%531
				CurProgress >= P1;
			?Attainments_Type_ShengWen_EqStageCount ->%%532
				CurProgress >= P1;
			?Attainments_Type_ShengWen_EqQuCount ->%%533
				CurProgress >= P1;
			?Attainments_Type_ShengWenAllLv ->%%534
				CurProgress >= P1;
			?Attainments_Type_ShengWenAllPoint ->%%535
				CurProgress >= P1;
			?Attainments_Type_ElementContinentTotem ->
				CurProgress >= P1;
			?Attainments_Type_ShengJiaBpBuy ->%%537
				CurProgress >= P1;
			?Attainments_Type_ShengJiaActive ->%%538
				CurProgress >= P1;
			?Attainments_Type_ShengJiaEqGem ->%%539
				CurProgress >= P1;
			?Attainments_Type_ShengJiaEqGem2 ->%%540
				CurProgress >= P1;
			?Attainments_Type_ShengJiaSkillAllLv ->%%541
				CurProgress >= P1;
			?Attainments_Type_ShengJiaActiveSkill ->%%542
				CurProgress >= P2;
			?Attainments_Type_TeamEqPassNum ->    %% 543
				CurProgress >= P1;
			?Attainments_Type_TeamCouplePassNum ->  %% 544
				CurProgress >= P1;
			?Attainments_Type_ActiveRingNum ->    %% 545
				CurProgress >= P1;
			?Attainments_Type_ActiveRingAllLv ->        %%546
				CurProgress >= P1;
			?Attainments_Type_ActiveRingStar ->        %%547
				CurProgress >= P1;
			?Attainments_Type_UnknownCount ->%% 548
				CurProgress >= P1;
			?Attainments_Type_GDWeaponStar -> %%551
				CurProgress >= P1;
			_ ->
%%				?LOG_ERROR("check condition config error id[~p] type[~p]~n", [ID, Type]),
				?FALSE
		end
	catch
		_ -> ?FALSE
	end.

%% 获取某个成就进度
get_progress(ID, ProgressMap) ->
	try
		AttainProgress = case find_progress(ID, ProgressMap) of
							 ?FALSE -> #attain_progress{};
							 P -> P
						 end,

		AttCfg = cfg_attainmentsNew:getRow(ID),
		case AttCfg =/= {} of
			?TRUE -> ok;
			?FALSE -> throw(0)
		end,
		[{Type, Param1, Param2, Param3, Param4, _Param5} | _] = AttCfg#attainmentsNewCfg.param,

		case Type of
			?Attainments_Type_AttPoint ->    %% 成就点 101
				variable_player:get_value(?FixedVariant_Index_68_AttPoint);
			?Attainments_Type_Level ->    %% 等级 102
				player:getLevel();
			?Attainments_Type_WingLv ->    %% 翅膀等级 103
				wing:get_wing_count_lv(Param2);
			?Attainments_Type_WingStar ->    %% 翅膀星级 104
				wing:get_wing_count_star(Param2);
			?Attainments_Type_YilingLv ->    %% 翼灵等级 108
				wing:get_yiling_lv();
			?Attainments_Type_WingCount ->    %% 翅膀数量 110
				wing:get_wing_count_quality(Param2);
			?Attainments_Type_CareerLv ->    %% 转职等级 111
				change_role:get_career_lv();
			?Attainments_Type_MountStar ->    %% 坐骑星级 113
				mount:get_param_for_attainment(?Attainments_Type_MountStar, Param2);
			?Attainments_Type_MountSoulLv ->    %% 兽灵等级 117
				mount:get_param_for_attainment(?Attainments_Type_MountSoulLv, Param2);
			?Attainments_Type_MountCount ->    %% 坐骑数量 118
				mount:get_param_for_attainment(?Attainments_Type_MountCount, Param2);
			?Attainments_Type_PetLv ->    %% 宠物等级[数量,宠物的等级] 119
				pet_new:get_count_lv(Param2);
			?Attainments_Type_PetStar ->    %% 宠物星级[数量,宠物的星级] 120
				pet_new:get_count_star(Param2);
			?Attainments_Type_EqIntensify ->    %% 装备强化 126
				eq:get_param_for_attainment2(Param2);
			?Attainments_Type_EqAdd ->    %% 装备追加 127
				eq:get_param_for_attainment(?Attainments_Type_EqAdd, Param2);
			?Attainments_Type_EqSuit ->    %% 装备套装 131
				eq:get_param_for_attainment(?Attainments_Type_EqSuit, {Param2, Param3, Param4});
			?Attainments_Type_HolyLv ->    %% 圣物等级 134
				relic:get_count_level(Param2);
			?Attainments_Type_HolyCount ->    %% 圣物数量[数量] 138
				relic:get_count();
			?Attainments_Type_GDWeaponCount ->    %% 天神武器数量 146
				g_dragon_weapon:get_weapon_all_num();
			?Attainments_Type_DungeonStoryChapter ->    %% 剧情本章节  X星通关XX主线副本 167
				mainline_copy_map:get_count_pass(Param2, Param3, AttainProgress#attain_progress.progress);
			?Attainments_Type_DungeonMountCount ->    %% 通关坐骑副本次数 170
				dungeon_mount:get_dungeon_pass(?MapAI_DungeonMount, Param2, Param3, AttainProgress#attain_progress.progress);
			?Attainments_Type_ArenaWinCount ->    %% 竞技场胜利次数 177
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DungeonExcellenceChapter ->    %% 精英本章节 精英副本三星通过XX章XX关 179
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DungeonDragonConsum ->    %% 通关龙王宝库 3星通关XX法老宝库副本 180
				dungeon_mount:get_dungeon_pass(?MapAI_ActiveExtend, Param2, Param3, AttainProgress#attain_progress.progress);
			?Attainments_Type_XORoomRightCount ->    %% 斯芬克斯房间答题全正确XX次 185
				AttainProgress#attain_progress.progress;
			?Attainments_Type_MeleeKill ->    %%牛怪迷宫中累计击杀XX玩家   187
				AttainProgress#attain_progress.progress;
			?Attainments_Type_AshuraKill ->    %% 雷霆要塞中累计击杀XX玩家 188
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GoldGetCount ->    %% 累计获得金币数量 198
				AttainProgress#attain_progress.progress;
			?Attainments_Type_SignCount ->    %% 签到次数 199
				AttainProgress#attain_progress.progress;
			?Attainments_Type_BagExtCell ->    %% 额外开启的背包格子数量 200
				bag:get_extend(?BAG_PLAYER);
			?Attainments_Type_BountyTaskCount ->    %% 完成XX次赏金任务 203
				AttainProgress#attain_progress.progress;
			?Attainments_Type_LordRingEqCount ->    % 当前穿戴魔戒数 204
				length(role_data:get_role_element(role_data:get_leader_id(), #role.lord_ring));
			?Attainments_Type_HonorLv ->    %%头衔[头衔等级(等级对应的名称) 205
				player_honor:get_honor_lv();
			?Attainments_Type_FriendsCount ->%% 好友[数量,亲密度] 206
				friends:get_friends_count_intimacy(Param2);
			?Attainments_Type_DemonSquare ->%% 勇者试炼[完成次数] 207
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DungeonYanmoCount ->%%参加守卫世界树X次 209
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DemonsInvasionBoss ->%%死亡地狱击杀boss数， 新手场最多记录6只 211
				AttainProgress#attain_progress.progress;
			?Attainments_Type_PersonalBoss ->%%个人BOss击杀数 212
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DemonsLairBoss ->%%死亡森林击杀Boss数 213
				AttainProgress#attain_progress.progress;
			?Attainments_Type_CursePlaceBoss ->%%诅咒禁地击杀X只boss 214
				AttainProgress#attain_progress.progress;
			?Attainments_Type_WorldBossKill ->%%世界boss击杀X只boss 217
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DailyTaskActivity ->    %% 累计数天日常活跃度达到某值 219
				AttainProgress#attain_progress.progress;
			?Attainments_Type_ProphecyCompleteID ->  %%完成神谕X 220
				prophecy:get_skill_list(player:getPlayerProperty(#player.leader_role_id));
			?Attainments_Type_AlchemyLv ->%%吞噬到达XX级 221
				variable_player:get_value(?VARIABLE_PLAYER_EqSmeltLv);
			?Attainments_Type_MountEqCount ->%%装配X个X品质的坐骑装备 223
				mount_eq:get_count_eq_chara(Param2);
			?Attainments_Type_WingEqCount ->%%装配X个X品质的翅膀装备 224
				wing:get_count_eq_chara(Param2);
			?Attainments_Type_SkillLv ->%%技能等级[数量,等级] 229
				RoleId = role_data:get_leader_id(),
				skill_player:get_count_skill_lv(RoleId, Param2);
			?Attainments_Type_Reincarnation -> player:getPlayerProperty(#player.rein_lv);
			?Attainments_Type_BlueDiamondCount ->%%累计获得钻石数量 302
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GreenDiamondCount ->%%累计获得绿钻数量 303
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GreenAndBlueReincarnation ->%%累计获得钻石和绿钻数量 304
				AttainProgress#attain_progress.progress;
			?Attainments_Type_VipLv ->%%VIP达到XX级 305
				player:getPlayerProperty(#player.vip);
			?Attainments_Type_OnlineMinute ->%%累计在线分钟 306
				AttainProgress#attain_progress.progress;
			?Attainments_Type_SkillBreachLv ->%%XX个技能突破达到XX级 307
				RoleId = role_data:get_leader_id(),
				SkillIndex = cfg_skillEquip:getKeyList(),
				length([1 || #playerSkillInfo{index = Index} <- role_data:get_role_element(RoleId, #role.skillList),
					skill_up:get_state_level(RoleId, Index, 1) >= Param2, lists:member(Index, SkillIndex)]);
			?Attainments_Type_SkillawakenLvCount ->%%XX个技能觉醒达到XX级 308
				RoleId = role_data:get_leader_id(),
				SkillIndex = cfg_skillEquip:getKeyList(),
				length([1 || #playerSkillInfo{index = Index} <- role_data:get_role_element(RoleId, #role.skillList),
					skill_up:get_state_level(RoleId, Index, 2) >= Param2, lists:member(Index, SkillIndex)]);
			?Attainments_Type_ActivationSkill ->
				skill_up:get_active_skill(Param1);
			?Attainments_Type_ActivationSkillLv ->%%奥义XXX技能升级到XX级
				RoleId = role_data:get_leader_id(),
				skill_up:get_skill_level2(RoleId, Param2);
			?Attainments_Type_SkillReset ->%%重置技能X次 311
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GodGifts ->%%激活XX品质的神的馈赠XX个 312
				pill:get_pill_count(Param2);
			?Attainments_Type_ModifyNameCount ->%%修改角色名字XX次 313
				AttainProgress#attain_progress.progress;
			?Attainments_Type_ModifySexCount ->%%修改性别XX次 314
				AttainProgress#attain_progress.progress;
			?Attainments_Type_Dyeing ->%%对主角进行XX次染色 316
				AttainProgress#attain_progress.progress;
			?Attainments_Type_MakeUp ->%%对主角进行XX次化妆 317
				AttainProgress#attain_progress.progress;
			?Attainments_Type_HeadCount ->%%激活XX个头像 318
				dress_up_head:get_dress_up_count(0);
			?Attainments_Type_HeadStarCount ->%%XX个头像升星到X星 319
				dress_up_head:get_dress_up_count(0, Param2);
			?Attainments_Type_HeadBoxCount ->%%激活XX个头像框 320
				dress_up_head:get_dress_up_count(1);
			?Attainments_Type_HeadBoxStarCount ->%%XX个头像框升星到X星 321
				dress_up_head:get_dress_up_count(1, Param2);
			?Attainments_Type_ChatBubbleCount ->%%激活XX个聊天气泡 322
				dress_up_head:get_dress_up_count(2);
			?Attainments_Type_ChatBubbleStarCount ->%%XX个聊天气泡升星到X星 323
				dress_up_head:get_dress_up_count(2, Param2);
			?Attainments_Type_UnlockDevour ->%%解锁吞噬特权 324
				case player_private_list:get_value(?Private_List_FadePrivilege) of
					[] -> 0;
					[{_, _} | _] -> 1
				end;
			?Attainments_Type_MarketBuyItem ->%%神秘集市中购买道具XXX次 325
				AttainProgress#attain_progress.progress;
			?Attainments_Type_StarryFeastCount ->%%参加XX次星空盛宴 326
				AttainProgress#attain_progress.progress;
			?Attainments_Type_TransactionBuyItem ->%%交易行中购买道具XX次 327
				AttainProgress#attain_progress.progress;
			?Attainments_Type_BuyWarToken ->%%在X赛季中，购买征战令牌 328
				border_war_player_bp:get_active(2);
			?Attainments_Type_BuyCertificateHonor ->%%在X赛季中，购买荣誉证书 329
				border_war_player_bp:get_active(1);

			?Attainments_Type_BuyPassCheckCount ->%%购买日常通行证XX次 330
				week_active:get_count_week(AttainProgress#attain_progress.progress);
			?Attainments_Type_BuyMonthlyCard ->%%购买月卡特权次数 331
				recharge_subscribe:get_count_subscribe(1, AttainProgress#attain_progress.progress);
			?Attainments_Type_BuyLifetimeCard ->%%终身卡 332
				case recharge_life_card:is_buy(Param1) of
					?TRUE -> Param1;
					?FALSE -> 0
				end;
			?Attainments_Type_BuyFund ->%%购买XX基金 333  db_funds_buy
				case player_funds:is_funds_buy(Param1) of
					?TRUE -> Param1;
					?FALSE -> 0
				end;
			?Attainments_Type_BuyMonthly ->%%购买XX次月理财 334
				player_financing:get_count_month_financing(Param2, AttainProgress#attain_progress.progress);
			?Attainments_Type_BuyWarOrder ->%%购买XX战令 335
				awaken_road:get_active_bp(Param2);
			?Attainments_Type_SSRHeroCount ->%%激活X个Y品质的英雄 336
				pet_new:get_count_grade(Param2);
			?Attainments_Type_SPHeroCount ->%%激活X个英雄 337
				pet_new:get_count();
			?Attainments_Type_PetRingCount ->%%装配X件X品质的英雄戒指 338
				pet_eq_and_star:get_count_eq_chara(Param2);
			?Attainments_Type_PetBlessEQCount ->%%装配X件X品质的英雄装备 339
				pet_bless_eq:get_count_eq_chara(Param2);
			?Attainments_Type_PetAssistCount ->%%X个英雄助战 340
				length(pet_pos:get_assist_list());
			?Attainments_Type_PetResonanceCount ->%%X个英雄共鸣圣树 341
				pet_shengshu:get_count_shenshu();
			?Attainments_Type_WingUpCount ->%%X个翅膀装备升级到XX级 342
				wing:get_count_eq_lv(Param2);
			?Attainments_Type_WingReinCount ->%%X翅膀转生 343
				wing:get_rein_list();
			?Attainments_Type_MountEqLvCount ->%%X个坐骑装备升级到XX级 344
				mount_eq:get_count_eq_int(Param2);
			?Attainments_Type_MountReinCount ->%%X坐骑转生 345
				mount:get_rein_list();
			?Attainments_Type_SacredObjectAwakenCount ->%%X个圣物觉醒到X 346
				relic:get_count_awaken_lv(Param2);
			?Attainments_Type_SacredObjectGrade ->%%X个圣物升品到X（SSR/SP/UR） 347
				relic:get_count_grade_lv(Param2 - 2);
			?Attainments_Type_SacredObjectCount ->%%装配X个X品质圣印 348
				relic:get_count_grade_eq(Param2);
			?Attainments_Type_SacredObjectLvCount ->%%装配X个X品质圣印升级到X级 349
				relic:get_count_grade_eq2(Param2, Param3);
			?Attainments_Type_MaxCombinationSkillsCount ->%%激活X个最高组合技能 350
				relic:get_count_skill();

			?Attainments_Type_GodStatueCount -> %%激活X个神像 351
				g_dragon:get_gd_main_count();
			?Attainments_Type_GodStatueLvCount -> %%X个神像强化到X阶 352
				g_dragon:get_count_gd_stair(Param2);
			?Attainments_Type_GodStatueStarCount -> %%X个神像升星到X星 353
				g_dragon:get_gd_main_count_star(Param2);
			?Attainments_Type_GodStatueWingQuCount ->  %%装配X个X品质的神像翅膀 354
				g_dragon_statue:get_statue_order_num(Param2);
			?Attainments_Type_GodStatueGodEqCount ->  %%穿戴X件天神装备 355
				g_dragon_eq:get_eq_num() + g_dragon_weapon:get_weapon_num();
			?Attainments_Type_GuardCount -> %%激活X个守护 356
				guard:get_guards_count();
			?Attainments_Type_GuardLvCount -> %%X个守护进行X次进阶 357
				guard:get_guards_order_num_attainment(Param2);
			?Attainments_Type_GuardQuCount -> %%X个守护进行X次觉醒 358
				guard:get_guards_awake_num_attainment(Param2);
			?Attainments_Type_GemstoneCount -> %%镶嵌X个X级的X宝石（普通、红、绿、黄）359
				eq:get_gem_lv_type_num(Param2, Param3, Param4, 1);
			?Attainments_Type_HighGemstoneCount ->%%镶嵌X个X级的X曜石（普通、红、绿、黄）361
				eq:get_gem_lv_type_num(Param2, Param3, Param4, 2);
			?Attainments_Type_WearEqLvQuStarCount1 -> %%穿戴X件X阶X品质X星及以上的装备（分装备和饰品）362
				eq:get_eq_wear_num_type(Param2, 0, Param3, Param4, ?SUIT_EQUIP);
			?Attainments_Type_WearEqLvQuStarCount2 -> %%穿戴X件X阶X品质X星及以上的饰品（分装备和饰品）363
				eq:get_eq_wear_num_type(Param2, 0, Param3, Param4, ?SUIT_ORNAMENT);
			?Attainments_Type_EquipQuCardCount ->%%装配XX张XX品质及以上的卡片 364
				eq:get_char_card_num(Param2);
			?Attainments_Type_SynthesisCardCount -> %%进行X次合成卡片 365
				AttainProgress#attain_progress.progress;
			?Attainments_Type_RecastCardCount -> %%进行X次重铸卡片 366
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DivineOrnamentCount ->  %%激活X个X阶的神饰 367
				god_ornament:get_active_order_num(Param2);
			?Attainments_Type_DivineOrnamentStar -> %%任意X阶的神饰卓越激活X次 368
				god_ornament:get_any_order_star_num(Param1);
			?Attainments_Type_DivineOrnamentLv -> %%任意X阶的神饰卓越晋升X次 369
				god_ornament:get_any_order_quality_num(Param1);
			?Attainments_Type_BlessEqLvCount1 -> %%获得X件X阶祝福装备（攻击和防御装备）370
				eq:check_bless_eq_polarity(1, Param2);
			?Attainments_Type_BlessEqLvCount2 -> %%获得X件X阶祝福饰品（饰品）371
				eq:check_bless_eq_polarity(2, Param2);
			?Attainments_Type_RingStarCount -> %% XX魔戒升星到X星 372
				lord_ring:get_equip_lord_ring_star_num(Param2);
			?Attainments_Type_CollectionLvQuStarCount1 -> %%收藏X件X阶 X品质X星及以上的装备（分装备和饰品）373
				eq_collect:get_char_star_type_num(Param2, Param3, Param4, ?SUIT_EQUIP);
			?Attainments_Type_CollectionLvQuStarCount2 -> %%收藏X件X阶 X品质X星及以上的装备（分装备和饰品）374
				eq_collect:get_char_star_type_num(Param2, Param3, Param4, ?SUIT_ORNAMENT);
			?Attainments_Type_EqRegenerateLvCount1 -> %%X件X阶装备（分攻击/防御/饰品）再生等级达到X级以上 375
				eq_collect:get_reborn_order_type_num(Param2, Param3, ?Eq_Atk);
			?Attainments_Type_EqRegenerateLvCount2 -> %%X件X阶装备（分攻击/防御/饰品）再生等级达到X级以上 376
				eq_collect:get_reborn_order_type_num(Param2, Param3, ?Eq_Def);
			?Attainments_Type_EqRegenerateLvCount3 -> %%X件X阶装备（分攻击/防御/饰品）再生等级达到X级以上 377
				eq_collect:get_reborn_order_type_num(Param2, Param3, ?Eq_Orn);
			?Attainments_Type_Titan -> %%激活第X赛季的泰坦 378
				common:bool_to_int(constellation:is_active_season_constellation(Param1));
			?Attainments_Type_EquipQuTitanEqCount ->%%装配X个X赛季X品质以上的泰坦装备 379
				constellation:get_season_quality_eq_num(Param3, Param2);
			?Attainments_Type_TitanStar -> %%将X赛季的泰坦升星到X星 380
				common:bool_to_int(constellation:get_season_constellation_star(Param2) >= Param1);
			?Attainments_Type_GodStoneLvCount ->  %%将X赛季的X个神石升级到X级 381
				constellation:get_season_gem_lv_num(Param2, Param3);
			?Attainments_Type_DivineTroopCount -> %%激活X件神兵 382
				weapon:get_active_count();
			?Attainments_Type_DivineTroopsCount -> %%激活X套神兵 383
				{SuitNum, _, _} = weapon:get_weapon_suit_num(),
				SuitNum;
			?Attainments_Type_DivineTroopLv -> %%将任意神兵升阶到X阶 384
				weapon:get_weapon_level_max();
			?Attainments_Type_DivineTroopStar -> %%将任意神兵升星到X星 385
				weapon:get_weapon_main_star_max();
			?Attainments_Type_QiLingLv -> %%器灵升级到X级 386
				weapon:get_soul_lv2();
			?Attainments_Type_QuGoldContract ->%%同时助战X个XX品质的黄金契约 387
				astrolabe:get_astrolabe_quality_num(Param2);
			?Attainments_Type_GoldContractLv -> %%任意黄金契约装备强化到X级 388
				astrolabe:get_max_aequip_intlv();
			?Attainments_Type_GoldContractQu -> %%装配X个XX品质的黄金契约装备 389
				astrolabe:get_count_eqaequip_quality(Param2);
			?Attainments_Type_AssistWarCount -> %%开启X个助阵位 390
				astrolabe:get_all_astro_num_max();
			?Attainments_Type_GoldMysteryKillCount -> %%黄金秘境击杀X只boss 391
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GoldMysteryCommonChestCount -> %%黄金秘境中采集普通宝箱XX次 392
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GoldMysteryHighChestCount -> %%黄金秘境中采集高级宝箱XX次 393
				AttainProgress#attain_progress.progress;
			?Attainments_Type_GoldMysteryCount -> %%黄金秘境中采集XX次 394
				AttainProgress#attain_progress.progress;
			?Attainments_Type_DarkCount -> %%黑暗深渊击杀X只boss 395
				AttainProgress#attain_progress.progress;
			?Attainments_Type_AssistKillCount ->  %%协助玩家XX次 396
				AttainProgress#attain_progress.progress;
			?Attainments_Type_AssistKillCountEd -> %%被协助XX次 397
				AttainProgress#attain_progress.progress;
			?Attainments_Type_PetPagodaCount -> %%英雄塔通关X层 398
				career_tower:get_main_layer();
			?Attainments_Type_WingCopyCount -> %%通关XX次翅膀副本 399
				dungeons_wing_player:get_wing_count(Param2, AttainProgress#attain_progress.progress);
			?Attainments_Type_SkillChallengeStar3Count -> %%3星通关XX技能挑战副本 400
				dungeon_mount:get_dungeon_pass(?MapAI_DungeonPet, Param2, Param3, AttainProgress#attain_progress.progress);
			?Attainments_Type_BraveManCount -> %%击杀XX只勇者试炼中的小怪 401
				AttainProgress#attain_progress.progress;
			?Attainments_PetCallCount -> %%累计XX次英雄召唤 402
				pet_draw:get_normal_draw_time();
			?Attainments_Type_PetDestinyCallCount -> %%累计XX次命运召唤 403
				pet_draw:get_senior_draw_time();
			?Attainments_Type_EqTreasureHuntCount -> %%累计装备寻宝XX次 404
				AttainProgress#attain_progress.progress;
			?Attainments_Type_CardTreasureHuntCount -> %%累计卡片寻宝XX次 405
				AttainProgress#attain_progress.progress;
			?Attainments_Type_ArenaRankCount ->%%竞技场排名 435
				min(AttainProgress#attain_progress.progress, 1);
			?Attainments_Type_1v1TrophyCount ->%%激活X个1v1奖杯 442
				cup:get_cup_num();
			?Attainments_Type_1v1TrophyQu ->%%任意1v1奖杯提升到X品质 443
				cup:get_max_char();
			?Attainments_Type_1v1TrophyLv ->%%任意1v1奖杯升级到X级 444
				cup:get_max_lv();
			?Attainments_Type_1v1TrophyQuCount ->%%X个1v1奖杯提升到X品质 445
				cup:get_char_num(Param2);
			?Attainments_Type_1v1TrophyLvCount ->%%X个1v1奖杯升级到X级 446
				cup:get_lv_num(Param2);
			?Attainments_Type_WingAllCount ->%%翅膀总数量 459
				wing:get_wing_count();
			?Attainments_Type_MountAllCount ->%%坐骑总数量 460
				mount:get_count();
			?Attainments_Type_Relic_Illusion_Qu ->%%激活X个Y品质的幻化圣物 476
				relic_illusion:get_relic_illusion_char_num(Param2);
			?Attainments_Type_Relic_Illusion_Star ->%%X个幻化圣物升星到X星 477
				relic_illusion:get_relic_illusion_star_num(Param2);
			?Attainments_Type_Relic_Illusion_ReinCount ->%%X个幻化圣物转生 478
				relic_illusion:get_relic_illusion_star_rein();
			?Attainments_Type_FaZhen_Char_Num ->%%获得X个Y品质及以上法阵 479
				fazhen:get_fazhen_char_num(Param2);
			?Attainments_Type_FaZhenRune_Attr ->%%获得X个Y品质及以上不同的符文晋升 483
				fazhen:get_fazhenrune_attr_num(Param2);
			?Attainments_Type_FaZhenRune_Star_Num ->%%X个符文同时升至Y星 484
				fazhen:get_fazhenrune_star_num(Param2);
			?Attainments_Type_FaZhen_Star_Num ->%%X个法阵同时升至Y星 485
				fazhen:get_fazhen_star_num(Param2);
			?Attainments_Type_RuneXunBao_Count -> %%累计符文寻宝X次 486
				AttainProgress#attain_progress.progress;
			?Attainments_Type_PetEq_SoulStone_Lv_Num -> %%镶嵌X个Y级魂石 494
				pet_bless_eq:get_soul_lv(Param2);
			?Attainments_Type_ShouLingEq_Star_Num -> %%穿戴X件Y星的坐骑装备 495
				mount_eq:get_count_eq_star(Param2);
			?Attainments_Type_SacredEqCount -> %% 穿戴多少件A阶B品质C星级的英雄圣装 514
				pet_sacred_eq:get_char_star_type_num(Param2, Param3, Param4);
			?Attainments_Type_HolyShieldStage ->
				holy_shield:get_stage();
			?Attainments_Type_HolyShieldLevel ->
				holy_shield:get_level();
			?Attainments_Type_HolyShieldSkill ->
				holy_shield:get_skill_num(Param2, Param3);
			?Attainments_Type_PetIllusionRefineNum ->
				pet_illusion:get_illsuion_refine_num(Param2);
			?Attainments_Type_AltarHeroCount ->
				length(pet_pos:get_aid_uid_list());
			?Attainments_Type_AltarStoneLvTotal ->
				pet_pos:get_altar_stone_total_lv();
			?Attainments_Type_BlzLayer ->
				times_log:get_times(?Log_Type_BlzMaxLayer);
			?Attainments_Type_ShengWen_EqStageCount ->
				shengwen:get_stage_count(Param2);
			?Attainments_Type_ShengWen_EqQuCount ->
				shengwen:get_quality_count(Param2);
			?Attainments_Type_ShengWenAllLv ->
				shengwen:get_sum_lv();
			?Attainments_Type_ShengWenAllPoint ->
				shengwen:get_sum_point();
			?Attainments_Type_ShengJiaActive ->
				shengjia:get_is_active(Param1);
			?Attainments_Type_ShengJiaEqGem ->
				shengjia:get_gem_lv_type_num(Param2, Param3, 1);
			?Attainments_Type_ShengJiaEqGem2 ->
				shengjia:get_gem_lv_type_num(Param2, Param3, 2);
			?Attainments_Type_ShengJiaSkillAllLv ->
				shengjia:get_skill_all_lv();
			?Attainments_Type_ShengJiaActiveSkill ->
				shengjia:get_skill_lv(Param1);
			?Attainments_Type_ActiveRingNum ->
				player_ring:get_count_ring();
			?Attainments_Type_ActiveRingAllLv ->
				player_ring:get_count_ring_alllv();
			?Attainments_Type_ActiveRingStar ->
				player_ring:get_count_ring_star(Param2);
			?Attainments_Type_UnknownCount ->
				pet_draw:get_unknown_draw_time();
			?Attainments_Type_GDWeaponStar ->
				g_dragon_weapon:get_weapon_star_num(Param2);
			_ -> AttainProgress#attain_progress.progress
		end
	catch
		_ -> 0
	end.

%% 离线事件
save_off_event(PlayerID, Msg) ->
	player_offevent:save_offline_event(PlayerID, ?Offevent_Type_Attainments, Msg).

%% 获取当前完成的进度
get_today_progress(AttID, ProgressMap) ->
	case find_progress(AttID, ProgressMap) of
		?FALSE -> 0;
		#attain_progress{today_progress = P} -> P
	end.

%% 功能是否开放
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Attainment) =:= 1 andalso guide:is_open_action(?OpenAction_Attainment).

log_attain_complete(AttID) ->
	L = [player:getPlayerID(), AttID, time:time()],
	table_log:insert_row(log_attain_complete, L).

log_attain_award(AttID, OldPt, NewPt, Time) ->
	L = [player:getPlayerID(), AttID, OldPt, NewPt, Time],
	table_log:insert_row(log_attain_award, L).

