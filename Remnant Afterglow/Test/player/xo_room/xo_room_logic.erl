%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%          XO房间 逻辑模块(斯芬克斯房间)
%%% @end
%%% Created : 14. 十二月 2018 14:56
%%%-------------------------------------------------------------------
-module(xo_room_logic).
-author("cbfan").
-include("xo_room.hrl").
-include("cfg_functionFore.hrl").
-include("cfg_xoRoomQ.hrl").
-include("cfg_xoRoomA.hrl").
-include("cfg_xoRoomBase.hrl").
-include("netmsgRecords.hrl").
-include("cfg_expDistribution.hrl").
-include("cfg_xoRoomRank.hrl").
-include("cfg_xoRoomGuess.hrl").
-include("db_table.hrl").
-include("id_generator.hrl").
-include("attainment.hrl").
-include("reason.hrl").
-include("gameMap.hrl").
-include("seven_gift_define.hrl").
-include("activity_new.hrl").
-include("variable.hrl").

%% API
-export([on_init/0, on_player_enter/1, on_player_exit/1, on_tick/0, on_gm_open/1]).
-export([enter_area/3, exit_area/3, ask_answer/3, week_reset/0, get_player_pos/1]).
-export([on_request_rank_msg/4, on_bet/3, get_bet_ui/1, on_player_name_change/2]).
-export([deal_rank_reward_local/2, on_dict_init/0, get_player_rank_local/1]).
-export([on_cluster_open/0]).


on_init() ->
	NowTime = time:time(),
	{Order, StartTime, EndTime} = common:get_action_time(?OpenAction_XORoom, NowTime),
	ets:insert(?MainEts, #mainEtsInfo{key = ?MainEtsKey_XoRoom, value = [{StartTime, EndTime, 0, Order}]}),
	set_xo_state(#xo_state{state = ?XoStateNotOpen, next_time = StartTime, end_time = EndTime}),
	set_stat_state(?FALSE),
	set_re_calc_flag(),
	ok.

%% 玩家进入地图
%%on_player_enter(PlayerInfo = #xo_player_info{id = PlayerId, pid = PlayerPid}) ->
on_player_enter({PlayerId, PlayerPid, MapPid, Name, GuildName, ServerId, ServerName, Sex, NationalityId}) ->
	PlayerList = get_player_list(),
	IsFirstEnter = lists:keyfind(PlayerId, #xo_player_info.id, PlayerList) =:= ?FALSE,
	PlayerInfo = case lists:keyfind(PlayerId, #xo_player_info.id, PlayerList) of
					 ?FALSE ->
						 #xo_player_info{
							 id = PlayerId, pid = PlayerPid, map_pid = MapPid,
							 name = Name, guild_name = GuildName, server_id = ServerId, server_name = ServerName, sex = Sex, nationality_id = NationalityId
						 };
					 #xo_player_info{} = Info ->
						 Info#xo_player_info{
							 pid = PlayerPid, map_pid = MapPid, name = Name,
							 guild_name = GuildName, is_exit = ?FALSE, sex = Sex, nationality_id = NationalityId
						 }
				 end,

	NewPlayerList = lists:keystore(PlayerId, #xo_player_info.id, PlayerList, PlayerInfo),
	set_player_list(NewPlayerList),
	#xo_state{question = {K0, K1, K2}, next_time = NextTime, state = State} = get_xo_state(),
	{Question, Answer} =
		case cfg_xoRoomA:getRow(K1, K2) of
			{} -> {"", 0};
			Cfg -> {Cfg#xoRoomACfg.question, Cfg#xoRoomACfg.answer}
		end,
	Msg = #pk_GS2U_XOState{
		state = State,
		question_index = K0,
		question = Question,
		answer = Answer,
		start_time = NextTime
	},

	check_player_view(get_xo_state(), PlayerInfo),
	send_2_all_player(#pk_GS2U_XOJoinNum{num = length([1 || #xo_player_info{is_viewer = ?FALSE} <- NewPlayerList])}),
	case IsFirstEnter of
		?TRUE -> main:sendMsgToPlayerProcess(PlayerId, {setPlayerVariant, ?Variant_Index_38_XORoomEnterWave, K0});
		?FALSE -> ok
	end,
	m_send:send_pid_msg_2_client(PlayerPid, Msg),

	RankList = lists:sublist(lists:reverse(lists:keysort(#xo_player_info.point, NewPlayerList)), 3),
	m_send:send_pid_msg_2_client(PlayerPid, #pk_GS2U_XOIsBet{
		is_bet = PlayerInfo#xo_player_info.bet_info =/= [],
		ranks = [#pk_xo_player_rank{name = N, point = P, serverName = S, nationality_id = NId} || #xo_player_info{name = N, point = P, server_name = S, nationality_id = NId} <- RankList],
		my_point = PlayerInfo#xo_player_info.point,
		my_exp = PlayerInfo#xo_player_info.exp,
		actor_num = lists:sum([1 || #xo_player_info{is_viewer = ?FALSE} <- NewPlayerList]),
		is_viewer = PlayerInfo#xo_player_info.is_viewer
	}),
	F = fun
			(#xo_player_info{is_exit = ?TRUE}, R) -> R;
			(#xo_player_info{answer = 1}, {R1, R2}) -> {R1 + 1, R2};
			(#xo_player_info{answer = 2}, {R1, R2}) -> {R1, R2 + 1};
			(#xo_player_info{answer = 0}, {R1, R2}) -> {R1, R2}
		end,
	{N1, N2} = lists:foldl(F, {0, 0}, NewPlayerList),
	m_send:send_pid_msg_2_client(PlayerPid, #pk_GS2U_XOAnswerStat{x_num = N2, o_num = N1}),
	ok.

on_player_name_change(PlayerId, Name) ->
	PlayerList = get_player_list(),
	case lists:keyfind(PlayerId, #xo_player_info.id, PlayerList) of
		#xo_player_info{} = Info ->
			set_player_list(lists:keystore(PlayerId, #xo_player_info.id, PlayerList, Info#xo_player_info{name = Name}));
		_ -> skip
	end.
%% 玩家退出地图
on_player_exit(PlayerId) ->
	PlayerList = get_player_list(),
	case lists:keyfind(PlayerId, #xo_player_info.id, PlayerList) of
		?FALSE -> skip;
		Info ->
			NewInfo = case get_xo_state() of
						  #xo_state{state = ?XoStatePrepare} -> Info#xo_player_info{is_exit = ?TRUE};
						  #xo_state{state = ?XoStateAnswerFinish} -> Info#xo_player_info{is_exit = ?TRUE};
						  _ -> Info#xo_player_info{is_exit = ?TRUE, is_viewer = ?TRUE}
					  end,
			NewList = lists:keystore(PlayerId, #xo_player_info.id, PlayerList, NewInfo),
			set_player_list(NewList)
	end,
	send_2_all_player(#pk_GS2U_XOJoinNum{num = length([1 || #xo_player_info{is_viewer = ?FALSE} <- get_player_list()])}).

on_tick() ->
	Now = time:time(),
	case get_bet_odds(2) of
		{?TRUE, Odds} ->
			Msg = #pk_GS2U_XOBetOdds{
				odds = [#pk_xo_odds{index = I, num = N} || {I, N} <- Odds]
			},
			send_2_all_player(Msg),
			set_bet_odds(2, {?FALSE, Odds});
		_ -> skip
	end,
	on_tick_0(Now, get_stat_state()),
	on_tick_1(Now, get_xo_state()).

%% 延迟Delay后开始
on_gm_open(-1) -> on_init();
on_gm_open(Delay) ->
	main:sendMsgToMap(?MapAI_XORoom, {discard}),
	case get_xo_state() of
		#xo_state{} ->
			Now = time:time(),
			DayStart = time:daytime(time:time()),
			Start = Now + Delay * 60 - DayStart,
			#functionForeCfg{timeStart = StartTime, timeEnd = EndTime} = cfg_functionFore:getRow(230, 1),
			End = Start + (EndTime - StartTime),
			set_question_answered([]),
			set_xo_state(#xo_state{state = ?XoStateNotOpen, next_time = DayStart + Start, end_time = DayStart + End}),
			ets:insert(?MainEts, #mainEtsInfo{key = ?MainEtsKey_XoRoom, value = [{DayStart + Start, DayStart + End, 1, 0}]});
		_ -> skip
	end.

%% 进入X/O区域
enter_area(Pid, PlayerId, Answer) ->
	try
		PlayerList = get_player_list(),
		PlayerInfo = lists:keyfind(PlayerId, #xo_player_info.id, PlayerList),
		case is_record(PlayerInfo, xo_player_info) of ?TRUE -> skip; _ -> throw(?ErrorCode_XO_PlayerNotInAc) end,

		NewPlayerList = lists:keystore(PlayerId, #xo_player_info.id, PlayerList, PlayerInfo#xo_player_info{answer = Answer}),
		set_player_list(NewPlayerList),
		set_stat_state(?TRUE),
		m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOEnterAreaRet{err_code = ?ERROR_OK, type = Answer})
	catch
		ErrCode -> m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOEnterAreaRet{err_code = ErrCode, type = Answer})
	end.
%% 退出X/O区域
exit_area(Pid, PlayerId, Answer) ->
	try
		PlayerList = get_player_list(),
		PlayerInfo = lists:keyfind(PlayerId, #xo_player_info.id, PlayerList),
		case is_record(PlayerInfo, xo_player_info) of ?TRUE -> skip; _ -> throw(?ErrorCode_XO_PlayerNotInAc) end,
		case PlayerInfo#xo_player_info.answer =:= Answer of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_XO_NotInThisArea)
		end,

		NewPlayerList = lists:keystore(PlayerId, #xo_player_info.id, PlayerList, PlayerInfo#xo_player_info{answer = 0}),
		set_player_list(NewPlayerList),
		set_stat_state(?TRUE),
		m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOExitAreaRet{err_code = ?ERROR_OK, type = Answer})
	catch
		ErrCode -> m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOExitAreaRet{err_code = ErrCode, type = Answer})
	end.
%% 看台玩家直接作答
ask_answer(Pid, PlayerId, Answer) ->
	try
		PlayerList = get_player_list(),
		PlayerInfo = lists:keyfind(PlayerId, #xo_player_info.id, PlayerList),
		case is_record(PlayerInfo, xo_player_info) of ?TRUE -> skip; _ -> throw(?ErrorCode_XO_PlayerNotInAc) end,
		case PlayerInfo#xo_player_info.answer =:= Answer of
			?TRUE -> throw(?ERROR_OK);
			_ -> skip
		end,
		NewPlayerList = lists:keystore(PlayerId, #xo_player_info.id, PlayerList, PlayerInfo#xo_player_info{answer = Answer}),
		set_player_list(NewPlayerList),
		set_stat_state(?TRUE),
		m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOReplyRet{err_code = ?ERROR_OK, answer = Answer})
	catch
		ErrCode -> m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOReplyRet{err_code = ErrCode, answer = Answer})
	end.

%% 查看排行榜
on_request_rank_msg(PlayerId, Pid, Sex, Name) ->
	case get_rank_msg() of
		{?FALSE, Msg} ->
			case lists:keyfind(PlayerId, #pk_xo_rank.player_id, Msg) of
				#pk_xo_rank{} = Data ->
					NewMsg = lists:keyreplace(PlayerId, #pk_xo_rank.player_id, Msg, Data#pk_xo_rank{name = cluster:make_player_text("", Name, Sex)}),
					sync_rank_msg(NewMsg, PlayerId, Pid);
				?FALSE -> sync_rank_msg(Msg, PlayerId, Pid)
			end;
		_ ->
			PlayerList = get_player_list(),
			RankList = lists:reverse(lists:keysort(#xo_player_info.point, PlayerList)),
			F = fun(Info, Rank) ->
				case Info#xo_player_info.id =:= PlayerId of
					?TRUE -> {#pk_xo_rank{
						rank = Rank,
						player_id = Info#xo_player_info.id,
						name = cluster:make_player_text("", Name, Sex),
						guild_name = Info#xo_player_info.guild_name,
						serverName = Info#xo_player_info.server_name,
						right_num = Info#xo_player_info.right_num,
						point = Info#xo_player_info.point,
						nationality_id = Info#xo_player_info.nationality_id
					},
						Rank + 1};
					?FALSE ->
						{#pk_xo_rank{
							rank = Rank,
							player_id = Info#xo_player_info.id,
							name = cluster:make_player_text("", Info#xo_player_info.name, Info#xo_player_info.sex),
							guild_name = Info#xo_player_info.guild_name,
							serverName = Info#xo_player_info.server_name,
							right_num = Info#xo_player_info.right_num,
							point = Info#xo_player_info.point,
							nationality_id = Info#xo_player_info.nationality_id
						}, Rank + 1}
				end
				end,
			{Msg, _} = lists:mapfoldl(F, 1, RankList),
			set_rank_msg({?FALSE, Msg}),
			sync_rank_msg(Msg, PlayerId, Pid)
	end.

on_bet(PlayerId, Pid, {BetId, BetResult1, BetNum, ItemId, Num}) ->
	try
%%		 1. 判断竞猜时间
		case get_xo_state() of
			#xo_state{state = ?XoStatePrepare} -> skip;
			_ -> throw(?ErrorCode_XO_CannotBet)
		end,
		PlayerList = get_player_list(),
		PlayerInfo = lists:keyfind(PlayerId, #xo_player_info.id, PlayerList),
		case is_record(PlayerInfo, xo_player_info) of ?TRUE -> skip; _ -> throw(?ErrorCode_XO_PlayerNotInAc) end,
		#xo_player_info{bet_info = BetList} = PlayerInfo,

		BetResult = case BetId of
						1 -> 1;
						_ -> BetResult1
					end,
		NewBet = case lists:keyfind(BetId, 1, BetList) of
					 ?FALSE -> [{BetId, BetResult, BetNum} | BetList];
					 _ -> throw(?ErrorCode_XO_JoinedBet)
				 end,
		NewPlayerList = lists:keystore(PlayerId, #xo_player_info.id, PlayerList, PlayerInfo#xo_player_info{bet_info = NewBet}),
		set_player_list(NewPlayerList),
		update_odds(BetId, BetResult, BetNum),
		m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XOBetRet{id = BetId, num = BetNum})
	catch
		ErrCode ->
			m_send:send_pid_msg(Pid, {xo_bid_fail, {ItemId, Num, ErrCode, BetId, BetNum}})
	end.

get_bet_ui(PlayerId) ->
	PlayerList = get_player_list(),
	PlayerInfo = lists:keyfind(PlayerId, #xo_player_info.id, PlayerList),
	{_, Odds} = get_bet_odds(2),
	Msg = #pk_GS2U_XOBetUIRet{
		bets = [#pk_xo_bet{id = I, reslut = R, num = N} || {I, R, N} <- PlayerInfo#xo_player_info.bet_info],
		odds = [#pk_xo_odds{index = I, num = N} || {I, N} <- Odds]
	},
	m_send:send_pid_msg_2_client(PlayerInfo#xo_player_info.pid, Msg).

week_reset() ->
	case time:day_of_week(time:get_localtime()) of
		1 -> set_question_answered([]);
		_ -> skip
	end.

get_player_pos(PlayerId) ->
	get_player_pos(lists:keyfind(PlayerId, #xo_player_info.id, get_player_list()), cfg_xoRoomBase:first_row()).
get_player_pos(#xo_player_info{is_viewer = ?TRUE}, #xoRoomBaseCfg{placePoint3 = PosList}) ->
	common:list_rand(PosList);
get_player_pos(_, _) -> {0, 0}.

on_dict_init() ->
	set_player_list([]),
	set_re_calc_flag(),
	set_bet_odds(0, ?UNDEFINED),
	set_bet_odds(2, ?UNDEFINED),
	ok.

on_cluster_open() ->
	NowTime = time:time(),
	{Order, StartTime, EndTime} = common:get_action_time(?OpenAction_XORoom, NowTime),
	ets:insert(?MainEts, #mainEtsInfo{key = ?MainEtsKey_XoRoom, value = [{StartTime, EndTime, 0, Order}]}),
	set_xo_state(#xo_state{state = ?XoStateNotOpen, next_time = StartTime, end_time = EndTime}).


%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 参加活动的玩家列表
get_player_list() -> case get('xo_player_list') of ?UNDEFINED -> []; V -> V end.
set_player_list(V) -> put('xo_player_list', V).

%% 活动状态
get_xo_state() -> get('xo_xo_state').
set_xo_state(V) -> put('xo_xo_state', V).

%% 统计玩家答案 用于客户端显示支持率
get_stat_state() -> get('xo_stat_state').
set_stat_state(V) -> put('xo_stat_state', V).

%% {IsNeedReCalc, Msg} 每次答题完了 保存一次排行榜信息
get_rank_msg() -> get('xo_rank_msg').
set_rank_msg(V) -> put('xo_rank_msg', V).
set_re_calc_flag() -> set_rank_msg({?TRUE, {}}).

%% 竞猜赔率 BetId 1-无意义 2-四个选项 0-四个选择的最终每个选项的赔率
get_bet_odds(BetId) -> case get({'xo_bet_odd', BetId}) of ?UNDEFINED -> {?FALSE, []}; V -> V end.
set_bet_odds(BetId, V) -> put({'xo_bet_odd', BetId}, V).

%% 已经打过的题
get_question_answered() -> case get('xo_question_answered') of ?UNDEFINED -> []; V -> V end.
set_question_answered(V) -> put('xo_question_answered', V).


%% 同步一些答案支持率、竞猜赔率
on_tick_0(_, ?FALSE) -> ok;
on_tick_0(_Now, ?TRUE) ->
%%	case Now rem 2 =:= 0 of
%%		?TRUE ->
	set_stat_state(?FALSE),
	F = fun
			(#xo_player_info{is_exit = ?TRUE}, R) -> R;
			(#xo_player_info{answer = 1}, {R1, R2}) -> {R1 + 1, R2};
			(#xo_player_info{answer = 2}, {R1, R2}) -> {R1, R2 + 1};
			(#xo_player_info{answer = 0}, {R1, R2}) -> {R1, R2}
		end,
	{N1, N2} = lists:foldl(F, {0, 0}, get_player_list()),
	send_2_all_player(#pk_GS2U_XOAnswerStat{x_num = N2, o_num = N1}).
%%		_ -> skip
%%	end.
on_tick_1(Now, #xo_state{state = ?XoStateNotOpen, next_time = T1} = State) ->
	case Now >= T1 of
		?TRUE ->
			on_dict_init(),
			%%开始斯芬克斯的系统公告
			cluster:broadcast(xo_room, {xo_Notice}),
			[{StartTime, EndTime, _, _} | _] = ets:lookup_element(?MainEts, ?MainEtsKey_XoRoom, #mainEtsInfo.value),
			set_xo_state(State#xo_state{state = ?XoStatePrepare, next_time = T1 + cfg_globalSetup:xORoom_PreTime(),
				end_time = T1 + EndTime - StartTime});
		_ -> skip
	end;
on_tick_1(Now, #xo_state{state = ?XoStatePrepare, next_time = T1} = State) ->
	case Now >= T1 of
		?TRUE ->
			calc_odds(),
			start_answer(State);
		_ -> skip
	end;
on_tick_1(Now, #xo_state{state = ?XoStateAnswer, next_time = T1} = State) ->
	case Now >= T1 of
		?TRUE ->
			wait_answer_public(State);
		_ -> skip
	end;
on_tick_1(Now, #xo_state{state = ?XoStateWaitAnswerPublic, next_time = T1} = State) ->
	case Now >= T1 of
		?TRUE ->
			end_answer(State);
		_ -> skip
	end;
on_tick_1(Now, #xo_state{state = ?XoStateWaitAnswer, next_time = T1} = State) ->
	case Now >= T1 of
		?TRUE ->
			start_answer(State);
		_ -> skip
	end;
on_tick_1(Now, #xo_state{state = ?XoStateAnswerFinish, end_time = T2} = _State) ->
	case Now >= T2 of
		?TRUE ->
%%			活动结束  进行结算
			?LOG_INFO("-------------xo room finish-------------------------------"),
			ac_end(),    %% 这个函数里面重新写入了State，故上文传参可不代入
			on_settle_accounts();
		_ -> skip
	end;
on_tick_1(_, S) ->
	?LOG_ERROR("error state :~p", [S]).
%% 活动结束 设置下次活动开启时间
ac_end() ->
	NowTime = time:time(),
	{CurOrder, NewStartTime, NewEndTime} = common:get_action_time(?OpenAction_XORoom, NowTime),
	xo_room:master_2_slave({time_sync, NewStartTime, NewEndTime, CurOrder}),
	ets:insert(?MainEts, #mainEtsInfo{key = ?MainEtsKey_XoRoom, value = [{NewStartTime, NewEndTime, 0, CurOrder}]}),
	set_xo_state(#xo_state{state = ?XoStateNotOpen, next_time = NewStartTime, end_time = NewEndTime}).

%% 计算赔率
calc_odds() ->
	{_, Stat} = get_bet_odds(2),
	#xoRoomGuessCfg{odds = [{2, SectionValue, Min}]} = cfg_xoRoomGuess:getRow(2),
	[Fa, Fb, Fc, Fd] = [begin
							case lists:keyfind(R, 1, Stat) of
								{R, N} -> N;
								_ -> 0
							end
						end || R <- [1, 2, 3, 4]],

	%% 一.计算对应的选项权重 A选项的权重=(B选项投注数量+C选项投注数量+D选项投注数量)/(A选项投注数量+1)
	Qa = d((Fb + Fc + Fd), (Fa + 1)),
	Qb = d((Fa + Fc + Fd), (Fb + 1)),
	Qc = d((Fa + Fb + Fd), (Fc + 1)),
	Qd = d((Fa + Fb + Fc), (Fd + 1)),
	%% 二.计算对应的选项比例 A选项比例=A选项权重/(A选项权重+B选项权重+C选项权重+D选项权重)
	Ra = d(Qa, (Qa + Qb + Qc + Qd)),
	Rb = d(Qb, (Qa + Qb + Qc + Qd)),
	Rc = d(Qc, (Qa + Qb + Qc + Qd)),
	Rd = d(Qd, (Qa + Qb + Qc + Qd)),
	%% 三.计算对应的赔率 A选项赔率=A选项比例*预计的区间值+保底赔率
	Pa = Ra * SectionValue + Min,
	Pb = Rb * SectionValue + Min,
	Pc = Rc * SectionValue + Min,
	Pd = Rd * SectionValue + Min,
	set_bet_odds(0, {Pa, Pb, Pc, Pd}).
d(_, B) when B < 1 -> 0;
d(A, B) -> A / B.

%% 有人竞猜
update_odds(1, _BetResult, _BetNum) -> ok;
update_odds(BetId, BetResult, BetNum) ->
	{_, OddList} = get_bet_odds(BetId),
	New = case lists:keyfind(BetResult, 1, OddList) of
			  {_, N} -> lists:keystore(BetResult, 1, OddList, {BetResult, BetNum + N});
			  _ -> [{BetResult, BetNum} | OddList]
		  end,
	set_bet_odds(BetId, {?TRUE, New}).

%% 答对
deal_player_answer(#xo_player_info{is_exit = ?TRUE} = PlayerInfo, _Answer, _Cfg) ->
	PlayerInfo#xo_player_info{is_viewer = ?TRUE, answer = 0};
deal_player_answer(#xo_player_info{answer = Answer} = PlayerInfo, Answer, Cfg) ->
	#xo_player_info{id = PlayerId, point = Point, right_num = Right, pid = Pid, exp = OldExp, server_id = ServerId} = PlayerInfo,
	#xoRoomBaseCfg{coinNew = CoinCfg, exp = ExpCfg, point = [PointAdd, _, _, _]} = Cfg,
	Exp = add_player_award(PlayerId, Pid, ServerId, ExpCfg, CoinCfg),
	PlayerInfo#xo_player_info{
		point = Point + PointAdd,
		exp = Exp + OldExp,
		right_num = Right + 1
	};
deal_player_answer(PlayerInfo, _Answer, Cfg) ->
	%% 判断是否在看台上  如果没在 将玩家传送过去
	#xo_player_info{id = PlayerId, is_viewer = IsViewer, map_pid = MapPid, pid = Pid, exp = OldExp, server_id = ServerId} = PlayerInfo,
	#xoRoomBaseCfg{placePoint3 = PosList, coinNew = CoinCfg, exp = ExpCfg, transformBuff = BuffList} = Cfg,
	Exp = add_player_award(PlayerId, Pid, ServerId, ExpCfg, CoinCfg),
	NewPlayerInfo = case IsViewer of
						?TRUE -> PlayerInfo#xo_player_info{exp = Exp + OldExp};
						_ ->
							send_msg_2_map(MapPid, {answer_fail_addbuff, PlayerId, common:list_rand(BuffList)}),
							erlang:send_after(3000, MapPid, {xo_map_msg, {answer_fail_move, PlayerId, common:list_rand(PosList)}}),
							PlayerInfo#xo_player_info{is_viewer = ?TRUE, exp = Exp + OldExp}
					end,
	NewPlayerInfo.

%% 观众处理
check_player_view(#xo_state{state = ?XoStatePrepare}, _) -> ok;
check_player_view(_, #xo_player_info{is_viewer = ?FALSE}) -> ok;
check_player_view(_, #xo_player_info{id = PlayerId, map_pid = MapPid, is_viewer = ?TRUE}) ->
	#xoRoomBaseCfg{transformBuff = BuffList} = cfg_xoRoomBase:first_row(),
	send_msg_2_map(MapPid, {answer_fail_addbuff, PlayerId, common:list_rand(BuffList)});
check_player_view(_, _) -> ok.

add_player_award(PlayerId, Pid, ServerId, ExpCfg, CoinCfg) ->
	Level = case player_summary:is_player_exist(PlayerId) of
				?TRUE ->
					mirror_player:get_player_level(PlayerId);
				_ ->
					#mapPlayer{level = Lv} = main:getMapPlayerCluster(PlayerId),
					Lv
			end,
	Exp = get_exp(ExpCfg, 0, Level),
	Coin = get_money(CoinCfg, 0, Level),
	Language = language:get_player_language(PlayerId),
	mail:send_mail_cluster(xo_room, ServerId, #mailInfo{
		player_id = PlayerId,
		title = language:get_server_string("playerbag_full_title", Language),
		describe = language:get_server_string("playerbag_full_describ", Language),
		coinList = [#coinInfo{type = 1, num = Coin}],
		attachmentReason = ?Reason_Xo_Answer,
		exp = Exp,
		isDirect = 1
	}),
	player_item:show_get_item_dialog(Pid, [], [{1, Coin}], [], Exp, 1),
	Exp.

get_exp([], RetExp, _) -> RetExp;
get_exp([{1, ExpParam} | T], RetExp, Level) ->
	get_exp(T, ExpParam + RetExp, Level);
get_exp([{2, ExpParam} | T], RetExp, Level) ->
	#expDistributionCfg{standardEXP = StandardEXP} = cfg_expDistribution:row(Level),
	get_exp(T, ExpParam * StandardEXP + RetExp, Level).

get_money([], RetMoney, _) -> RetMoney;
get_money([{1, MoneyParam} | T], RetMoney, Level) ->
	get_money(T, MoneyParam + RetMoney, Level);
get_money([{2, MoneyParam} | T], RetMoney, Level) ->
	#expDistributionCfg{standardMoney = StandardMoney} = cfg_expDistribution:row(Level),
	get_money(T, MoneyParam * StandardMoney + RetMoney, Level).


start_answer(State = #xo_state{question = {Stage, _, _}, next_time = NextTime, end_time = EndTime}) ->
%%	1. 选题  2. 确定答题结束时间 同步状态
	case cfg_xoRoomQ:getRow(Stage + 1) of
		#xoRoomQCfg{getQuestion = Rand} ->
			K1 = common:getRandomValueFromWeightList_1(Rand, 0),
			AnsweredList = get_question_answered(),
			{L, NAnsweredList} = case [P2 || {P1, P2} <- cfg_xoRoomA:getKeyList(), P1 =:= K1, not lists:member({P1, P2}, AnsweredList)] of
									 [] -> ?LOG_ERROR("question exhausted, cfg_xoRoomA:~p", [{K1}]),
										 set_question_answered([]),
										 {[P2 || {P1, P2} <- cfg_xoRoomA:getKeyList(), P1 =:= K1], []};
									 V -> {V, AnsweredList}
								 end,
			K2 = common:list_rand(L),
			set_question_answered([{K1, K2} | NAnsweredList]),
			#xoRoomBaseCfg{point = [_, Time, _, _]} = cfg_xoRoomBase:first_row(),
			set_xo_state(State#xo_state{state = ?XoStateAnswer, next_time = NextTime + Time, question = {Stage + 1, K1, K2}}),
			{Question, Answer} =
				case cfg_xoRoomA:getRow(K1, K2) of
					{} -> {"", 0};
					Cfg -> {Cfg#xoRoomACfg.question, Cfg#xoRoomACfg.answer}
				end,
			Msg = #pk_GS2U_XOState{
				state = ?XoStateAnswer,
				question_index = Stage + 1,
				question = Question,
				answer = Answer,
				start_time = NextTime + Time
			},
			send_2_all_player(Msg);
		_ ->
			?LOG_ERROR("can not find question :~p", [{Stage + 1, State}]),
			Msg = #pk_GS2U_XOState{
				state = ?XoStateAnswerFinish,
				start_time = EndTime
			},
			send_2_all_player(Msg),
			set_xo_state(State#xo_state{state = ?XoStateAnswerFinish})
	end.

wait_answer_public(State = #xo_state{question = {Index, K1, K2}, next_time = NextTime}) ->
	#xoRoomBaseCfg{point = [_, _, Time, _]} = cfg_xoRoomBase:first_row(),
	{S, T} = {?XoStateWaitAnswerPublic, NextTime + Time},
	set_xo_state(State#xo_state{state = S, next_time = T}),
	{Question, Answer} =
		case cfg_xoRoomA:getRow(K1, K2) of
			{} -> {"", 0};
			Cfg -> {Cfg#xoRoomACfg.question, Cfg#xoRoomACfg.answer}
		end,
	Msg = #pk_GS2U_XOState{
		state = S,
		question_index = Index,
		question = Question,
		answer = Answer,
		start_time = T
	},
	send_2_all_player(Msg).

end_answer(State = #xo_state{question = {Index, K1, K2}, next_time = NextTime, end_time = EndTime}) ->
	#xoRoomACfg{question = Question, answer = Answer} = cfg_xoRoomA:getRow(K1, K2),
	{S, T} = case cfg_xoRoomQ:getRow(Index + 1) of
				 #xoRoomQCfg{} ->
					 #xoRoomBaseCfg{point = [_, _, _, Time]} = cfg_xoRoomBase:first_row(),
					 {?XoStateWaitAnswer, NextTime + Time};
				 _ -> {?XoStateAnswerFinish, EndTime}
			 end,
	set_xo_state(State#xo_state{state = S, next_time = T}),
	Cfg = cfg_xoRoomBase:first_row(),
	NewPlayerList = [deal_player_answer(PlayerInfo, Answer, Cfg) || PlayerInfo <- get_player_list()],
	set_player_list(NewPlayerList),
	set_re_calc_flag(),
	sync_point(Answer),

	Msg = #pk_GS2U_XOState{
		state = S,
		question_index = Index,
		question = Question,
		answer = Answer,
		start_time = T
	},
	send_2_all_player(Msg).


sync_point(Answer) ->
	PlayerList = get_player_list(),
	ActorNum = lists:sum([1 || #xo_player_info{is_viewer = ?FALSE} <- PlayerList]),
	RankList = lists:sublist(lists:reverse(lists:keysort(#xo_player_info.point, PlayerList)), 3),
	RankMsg = [#pk_xo_player_rank{name = Name, point = Point, serverName = S, nationality_id = NId} || #xo_player_info{name = Name, point = Point, server_name = S, nationality_id = NId} <- RankList],
	F = fun(#xo_player_info{pid = Pid, is_exit = IsExit, point = MyPoint, is_viewer = IsViewer, exp = Exp, answer = MyAnswer}) ->
		case IsExit of
			?TRUE -> skip;
			_ ->
				m_send:send_pid_msg_2_client(Pid, #pk_GS2U_XORankInfoSync{
					ranks = RankMsg,
					my_point = MyPoint,
					my_exp = Exp,
					actor_num = ActorNum,
					is_right = MyAnswer =:= Answer,
					is_viewer = IsViewer
				})
		end
		end,
	lists:foreach(F, PlayerList).

send_2_all_player(Msg) ->
	F = fun
			(#xo_player_info{is_exit = ?FALSE, pid = P}) -> m_send:send_pid_msg_2_client(P, Msg);
			(_) -> skip
		end,
	lists:foreach(F, get_player_list()).

send_msg_2_map(MapPid, Msg) ->
	gen_server:cast(MapPid, {xo_map_msg, Msg}).

sync_rank_msg(Msg, PlayerId, Pid) ->
	{M1, M2, M3, M4} = case lists:keyfind(PlayerId, #pk_xo_rank.player_id, Msg) of
						   #pk_xo_rank{point = P, right_num = R, rank = Rank, serverName = Server} ->
							   {P, R, Rank, Server};
						   _ -> {0, 0, 0, ""}
					   end,
	m_send:send_pid_msg_2_client(Pid, #pk_GS2U_RequestXOUIRankRet{
		ranks = lists:sublist(Msg, 10),
		my_point = M1,
		my_right_num = M2,
		my_rank = M3,
		my_server = M4
	}).

%% 结算
on_settle_accounts() ->
	main:sendMsgToMap(?MapAI_XORoom, {discard}),
	PlayerList = get_player_list(),
	%% 处理竞猜的结算
	AllRightNum = length(lists:filter(fun(#xo_player_info{is_viewer = IsViewer}) -> not IsViewer end, PlayerList)),
	BetInfo = bet_settle_accounts(PlayerList, AllRightNum),

	%% 排行榜结算
	RankList = lists:reverse(lists:keysort(#xo_player_info.point, PlayerList)),
	WinnerName = case RankList of
					 [#xo_player_info{name = PlayerName, server_name = ServerName, sex = Sex} | _] ->
						 ServerNames = case cluster:is_opened() of
										   ?TRUE -> ServerName;
										   ?FALSE -> ""
									   end,
						 ServerNames ++ cluster:make_player_text("", PlayerName, Sex);
					 _ ->
						 ?LOG_INFO("cannot find the playername  :~p", [RankList]),
						 ""
				 end,

	{ServerRankList, IsCorrect} = split_score_list(RankList, 1, [], 0),
	deal_rank_reward(ServerRankList, {AllRightNum, BetInfo, WinnerName, IsCorrect}).


split_score_list([], _, Ret, IsCorrect) -> {Ret, IsCorrect};
split_score_list([#xo_player_info{server_id = ServerId} = Info | T], Rank, Ret, IsCorrect) ->
	NewRet = case lists:keyfind(ServerId, 1, Ret) of
				 {_, L} -> lists:keystore(ServerId, 1, Ret, {ServerId, [{Info, Rank} | L]});
				 _ -> [{ServerId, [{Info, Rank}]} | Ret]
			 end,
	NewIsCorrect = case IsCorrect of
					   0 -> case not Info#xo_player_info.is_viewer of
								?TRUE -> 1;
								?FALSE -> 0
							end;
					   _ -> 1
				   end,
	case Info#xo_player_info.right_num =:= length(cfg_xoRoomQ:getKeyList()) of
		?TRUE ->
			m_send:send_pid_msg(Info#xo_player_info.pid, {attainment_addprogress, ?Attainments_Type_XORoomRightCount, {1}});
		?FALSE -> ok
	end,
	split_score_list(T, Rank + 1, NewRet, NewIsCorrect).

deal_rank_reward([], _) -> skip;
deal_rank_reward([{ServerId, RankList} | T], Info) ->
	cluster:cast(xo_room, ServerId, {deal_rank_reward, RankList, Info}),
	deal_rank_reward(T, Info).

deal_rank_reward_local(RankList, {AllRightNum, BetInfo, WinnerName, IsCorrect}) ->
	#xoRoomBaseCfg{orderReward = List, awardFirstNew = First, awardAllNew = All} = cfg_xoRoomBase:first_row(),
	WorldLevel = world_level:get_world_level(),
	List1 = [{W, I} || {ServerType, W, I} <- List, ServerType =:= 0 orelse ServerType =:= common:getTernaryValue(cluster:is_opened(), 2, 1)],
	{_, Index} = common:getValueByInterval(WorldLevel, List1, {0, 1}),
	DropFirst = [{P1, P2, P3, P4, P5} || {P0, P1, P2, P3, P4, P5} <- First, P0 =:= Index, AllRightNum > 0],
	on_settle_accounts_1(WinnerName, RankList, {Index, DropFirst, All, AllRightNum, BetInfo, IsCorrect}).


on_settle_accounts_1(_, [], _) -> ok;
on_settle_accounts_1(PlayerName, [{PlayerInfo, Rank} | T], {Index, DropFirst, All, AllRightNum, BetInfo, IsCorrect}) ->
	#xo_player_info{id = PlayerId, pid = PlayerPid, is_exit = IsExit, right_num = RightNum} = PlayerInfo,
	ClusterStage = cluster:get_stage(),
	[{K0, K1, K2}] = [{S, L1, L2} || {S, L1, L2} <- cfg_xoRoomRank:getKeyList(), S =:= ClusterStage andalso L1 =< Rank andalso Rank =< L2],
	#xoRoomRankCfg{awardBoxNew = Award} = cfg_xoRoomRank:getRow(K0, K1, K2),
	DropItem = [{P1, P2, P3, P4, P5} || {P0, P1, P2, P3, P4, P5} <- Award, P0 =:= Index],
	#player{level = Level, leader_role_id = LeaderRoleId} = mirror_player:get_player(PlayerId),
	Career = mirror_player:get_role_career(PlayerId, LeaderRoleId),
	Language = language:get_player_language(PlayerId),
	%% 全部答对的奖励
	AllDrop = case RightNum >= cfg_xoRoomQ:keys_length() of
				  ?TRUE ->
					  {ItemList1, EqList1, CoinList1, _} = drop:drop([], All, PlayerId, Career, Level),
					  mail:send_mail(#mailInfo{
						  player_id = PlayerId,
						  title = language:get_server_string("XOJC_TEXT8", Language),
						  describe = language:get_server_string("XOJC_TEXT9", Language),
						  coinList = [#coinInfo{type = T1, num = N, multiple = 1} || {T1, N} <- CoinList1],
						  itemList = [#itemInfo{itemID = CfgId, num = Amount, multiple = 1, isBind = Bind, expireInfo = {0, Expire}} ||
							  {CfgId, Amount, Bind, Expire} <- ItemList1],
						  attachmentReason = ?Reason_Xo_RankAward,
						  itemInstance = EqList1
					  }),
					  {ItemList1, EqList1, CoinList1};
				  _ -> {[], [], []}
			  end,
	DescribeText = case IsCorrect of
					   0 -> language:format(language:get_server_string("XOJC_TEXT7", Language), [Rank]);
					   1 -> language:format(language:get_server_string("XOJC_TEXT10", Language), [Rank])
				   end,
	%% 排名奖励
	{ItemList, EqList, CoinList, _} = drop:drop([], DropItem ++ DropFirst, PlayerId, Career, Level),
	mail:send_mail(#mailInfo{
		player_id = PlayerId,
		title = language:get_server_string("XOJC_TEXT6", Language),
		describe = DescribeText,
		sendTime = time:time(),
		coinList = [#coinInfo{type = T1, num = N, multiple = 1} || {T1, N} <- CoinList],
		itemList = [#itemInfo{itemID = CfgId, num = Amount, multiple = 1, isBind = Bind, expireInfo = {0, Expire}} ||
			{CfgId, Amount, Bind, Expire} <- ItemList],
		attachmentReason = ?Reason_Xo_RankAward,
		itemInstance = EqList
	}),

	{ItemListAll, EqListAll, CoinListAll} = AllDrop,

	{Bet1Rank, M1, Bet2Rank, M2, RName} = BetInfo,
	BetMsg1 = case lists:keyfind(PlayerId, 2, Bet1Rank) of
				  {_, _, _, MyDiamond1, MyRank1} ->
					  M1#pk_BetInfo{
						  is_beted = 1,
						  my_bet_rank = MyRank1,
						  my_bet_diamond = MyDiamond1
					  };
				  _ -> M1#pk_BetInfo{is_beted = 2}
			  end,

	BetMsg2 = case lists:keyfind(PlayerId, 2, Bet2Rank) of
				  {_, _, _, MyDiamond2, MyRank2} ->
					  M2#pk_BetInfo{
						  is_beted = 1,
						  my_bet_rank = MyRank2,
						  my_bet_diamond = MyDiamond2
					  };
				  _ -> M2#pk_BetInfo{is_beted = 2}
			  end,

	Msg = #pk_GS2U_XOResult{
		my_point = PlayerInfo#xo_player_info.point,
		my_rank = Rank,
		my_right_num = RightNum,
		player_name = PlayerName,
		items = [#pk_Dialog_Item{
			item_id = I, count = N, bind = Bind, time_limt = Time, multiple = 1
		} || {I, N, Bind, Time} <- ItemList ++ ItemListAll],
		coins = [#pk_Dialog_Coin{type = T2, amount = N} || {T2, N} <- CoinList ++ CoinListAll],
		eqs = [eq:make_eq_msg(Eq) || {_, Eq} <- EqList ++ EqListAll],
		bet_player_name = RName,
		bet_infos = [BetMsg1, BetMsg2]
	},
	[m_send:send_pid_msg_2_client(PlayerPid, Msg) || not IsExit],

	activity_new_player:on_active_condition_change_ex(PlayerId, ?SalesActivity_Attend_XoRoom, 1),

%%	bet_settle_accounts(PlayerInfo, AllRightNum),
	on_settle_accounts_1(PlayerName, T, {Index, DropFirst, All, AllRightNum, BetInfo, IsCorrect}).


%% 竞猜结算
bet_settle_accounts(PlayerList, AllRightNum) ->
	BetRet = bet_settle_accounts_0(PlayerList, AllRightNum, []),
	B1 = [{Id, PlayerId, Name, Diamond, NId} || {Id, PlayerId, Name, Diamond, NId} <- BetRet, Id =:= 1],
	B2 = [{Id, PlayerId, Name, Diamond, NId} || {Id, PlayerId, Name, Diamond, NId} <- BetRet, Id =:= 2],
	Bet1Rank = lists:zipwith(fun({P1, P2, P3, P4, P5}, Rank) ->
		{P1, P2, P3, P4, Rank, P5} end, lists:reverse(lists:keysort(4, B1)), lists:seq(1, length(B1))),
	Bet2Rank = lists:zipwith(fun({P1, P2, P3, P4, P5}, Rank) ->
		{P1, P2, P3, P4, Rank, P5} end, lists:reverse(lists:keysort(4, B2)), lists:seq(1, length(B2))),

	R = lists:reverse(common:listValueMerge([{{PlayerId, Name}, Diamond} || {_Id, PlayerId, Name, Diamond} <- BetRet])),

	RName = case lists:reverse(lists:keysort(2, R)) of
				[{{_, Name}, _} | _] ->
					{ServerName1, Name1, Sex1} = Name,
					cluster:make_player_text(ServerName1, Name1, Sex1);
				_ -> ""
			end,

	M1 = [#pk_xo_rank_info{rank = Rank, name = Name, diamond = Diamond, serverName = ServerName, nationality_id = NationalityId} || {1, _, {ServerName, Name, _Sex}, Diamond, Rank, NationalityId} <- lists:sublist(Bet1Rank, 10)],
	M2 = [#pk_xo_rank_info{rank = Rank, name = Name, diamond = Diamond, serverName = ServerName, nationality_id = NationalityId} || {2, _, {ServerName, Name, _Sex}, Diamond, Rank, NationalityId} <- lists:sublist(Bet2Rank, 10)],

	M11 = #pk_BetInfo{id = 1, ranks = M1},
	M22 = #pk_BetInfo{id = 2, ranks = M2},

	{Bet1Rank, M11, Bet2Rank, M22, RName}.

bet_settle_accounts_0([], _, Ret) -> Ret;
bet_settle_accounts_0([PlayerInfo | T], AllRightNum, Ret) ->
	R1 = bet_settle_accounts_1(PlayerInfo#xo_player_info.bet_info, PlayerInfo, AllRightNum, []),
	bet_settle_accounts_0(T, AllRightNum, R1 ++ Ret).

bet_settle_accounts_1([], _PlayerInfo, _AllRightNum, Ret) -> Ret;
bet_settle_accounts_1([{1, _R, N} | T], PlayerInfo, AllRightNum, Ret) ->
	#xo_player_info{is_viewer = IsViewer, name = PlayerName, id = PlayerId, right_num = RightNum, server_id = ServerId} = PlayerInfo,
	AllRight = not IsViewer,
	BetSuccess = AllRight,
	#xoRoomGuessCfg{gift = Gift, odds = [{1, Rate, RateBase}]} = cfg_xoRoomGuess:getRow(1),
	Language = language:get_player_language(PlayerId),
	{Get, Describe} = case BetSuccess of
						  ?TRUE -> {trunc(Gift * N * Rate),
							  language:format(language:get_tongyong_string("XOJC_TEXT3", Language), [RightNum, N])};
						  _ -> {trunc(Gift * N * RateBase),
							  language:format(language:get_tongyong_string("XOJC_TEXT5", Language), [RightNum, N])}
					  end,
	mail:send_mail_cluster(xo_room, ServerId, #mailInfo{
		player_id = PlayerId,            %% 接收者ID
		senderID = 0,           %% 发送者ID
		senderName = "xo_bet",       %% 发送者Name
		title = language:get_tongyong_string("XOJC_TEXT1", Language),               %% 标题
		describe = Describe,           %% 描述
		isDirect = 0,
		coinList = [#coinInfo{type = 0, num = Get, reason = ?Reason_Xo_BetAward}]
	}),

	Name = {PlayerInfo#xo_player_info.server_name, PlayerName, PlayerInfo#xo_player_info.sex},
	Nid = PlayerInfo#xo_player_info.nationality_id,
	bet_settle_accounts_1(T, PlayerInfo, AllRightNum, [{1, PlayerId, Name, Get, Nid} | Ret]);
bet_settle_accounts_1([{2, R, N} | T], PlayerInfo, AllRightNum, Ret) ->
	#xoRoomGuessCfg{gift = Gift, option = Option} = cfg_xoRoomGuess:getRow(2),
	BetSuccess = case lists:keyfind(R, 1, Option) of
					 {_, M1, M2} -> AllRightNum >= M1 andalso AllRightNum =< M2;
					 _ -> ?FALSE
				 end,

	OddTuple = get_bet_odds(0),
	Rate = element(R, OddTuple),
	Language = language:get_player_language(PlayerInfo#xo_player_info.id),
	{Get, Describe} = case BetSuccess of
						  ?TRUE ->
							  {
								  trunc(Gift * N * Rate),
								  language:format(language:get_tongyong_string("XOJC_TEXT2", Language), [AllRightNum, richText:get_xo_bet_text(2, R), list_to_float(hd(io_lib:format("~.1f", [Rate]))), N])
							  };
						  _ ->
							  {
								  trunc(Gift * N),
								  language:format(language:get_tongyong_string("XOJC_TEXT4", Language), [AllRightNum, richText:get_xo_bet_text(2, R), list_to_float(hd(io_lib:format("~.1f", [Rate]))), N])
							  }
					  end,
	mail:send_mail_cluster(xo_room, PlayerInfo#xo_player_info.server_id, #mailInfo{
		player_id = PlayerInfo#xo_player_info.id,            %% 接收者ID
		senderID = 0,           %% 发送者ID
		senderName = "xo_bet",       %% 发送者Name
		title = language:get_tongyong_string("XOJC_TEXT1", Language),               %% 标题
		describe = Describe,           %% 描述
		isDirect = 0,
		coinList = [#coinInfo{type = 0, num = Get, reason = ?Reason_Xo_BetAward}]
	}),
	Nid = PlayerInfo#xo_player_info.nationality_id,
	Name = {PlayerInfo#xo_player_info.server_name, PlayerInfo#xo_player_info.name, PlayerInfo#xo_player_info.sex},
	bet_settle_accounts_1(T, PlayerInfo, AllRightNum, [{2, PlayerInfo#xo_player_info.id, Name, Get, Nid} | Ret]).

get_player_rank_local(ServerID) ->
	PlayerList = [R || #xo_player_info{server_id = Sid} = R <- get_player_list(), Sid =:= ServerID],
	RankList = lists:reverse(lists:keysort(#xo_player_info.point, PlayerList)),
	[PlayerID || #xo_player_info{id = PlayerID} <- lists:sublist(RankList, 5)].
