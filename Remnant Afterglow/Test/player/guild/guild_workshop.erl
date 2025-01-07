%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2021, DoubleGame
%%% @doc
%%%		战争工坊
%%% @end
%%% Created : 09. 8月 2021 17:16
%%%-------------------------------------------------------------------
-module(guild_workshop).
-author("suw").
-behaviour(gen_server).

%% API
-export([start_link/0, cast_run/1]).
-export([make_chariot_msg/1, send_2_me/1, list_2_chariot/1, chariot_2_list/1]).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("global.hrl").
-include("error.hrl").
-include("id_generator.hrl").
-include("cfg_guildchariot.hrl").
-include("guild.hrl").
-include("netmsgRecords.hrl").
-include("cfg_chariotscience.hrl").

-define(SERVER, ?MODULE).

-record(state, {}).


%%%===================================================================
%%% API
%%%===================================================================

%% @hidden
start_link() ->
	Args = [],
	gen_server:start_link({local, ?SERVER}, ?MODULE, Args, []).

%% @hidden Fun()
cast_run(Fun) when is_function(Fun, 0) ->
	gen_server:cast(?SERVER, {run, Fun}).

send_2_me(Msg) -> gen_server:cast(?SERVER, Msg).

list_2_chariot(List) ->
	R = list_to_tuple([chariot_info | List]),
	R#chariot_info{
		own_list = gamedbProc:dbstring_to_term(R#chariot_info.own_list),
		build_list = gamedbProc:dbstring_to_term(R#chariot_info.build_list),
		queue_list = gamedbProc:dbstring_to_term(R#chariot_info.queue_list)
	}.

chariot_2_list(R) ->
	tl(tuple_to_list(R#chariot_info{
		own_list = gamedbProc:term_to_dbstring(R#chariot_info.own_list),
		build_list = gamedbProc:term_to_dbstring(R#chariot_info.build_list),
		queue_list = gamedbProc:term_to_dbstring(R#chariot_info.queue_list)
	})).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @hidden
init(Args) ->
	try
		do_init(Args),
		{ok, #state{}}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{stop, ExcReason}
	end.

%% @hidden
handle_call(Request, From, State) ->
	try
		Reply = do_call(Request, From),
		{reply, Reply, State}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{reply, {error, ExcReason}, State}
	end.

%% @hidden
handle_cast(Request, State) ->
	try
		do_cast(Request)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end,
	{noreply, State}.

%% @hidden
handle_info(Info, State) ->
	try
		do_cast(Info)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end,
	{noreply, State}.

%% @hidden
terminate(Reason, _State) ->
	try
		do_terminate(Reason)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end,
	ok.

%% @hidden
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%%%===================================================================
%%% Internal functions
%%%===================================================================

-spec do_init(term()) -> any().
do_init(_Args) ->
	{WaiBuildList, WaitMoneyList} = table_global:fold(fun(#chariot_info{guild_id = GuildID, build_list = BuildList, queue_list = QueueList}, {Ret1, Ret2}) ->
		case BuildList of
			[{_, _, EndTime} | _] -> {ordsets:add_element({EndTime, GuildID}, Ret1), Ret2};
			[] ->
				case QueueList =/= [] of
					?TRUE -> {Ret1, [GuildID | Ret2]};
					_ -> {Ret1, Ret2}
				end
		end
													  end, {ordsets:new(), []}, ?TableGuildChariot),
	put({?MODULE, build_wait}, WaiBuildList),
	put({?MODULE, wait_money_guild}, WaitMoneyList),
	time_update_schedule(),
	ok.

-spec do_call(term(), {pid(), term()}) -> Reply :: term().
do_call(Request, From) ->
	?LOG_ERROR("no_match_call: Request=~p, From=~p", [Request, From]),
	ok.

-spec do_cast(term()) -> any().
do_cast(time_update) ->
	time_update_schedule(),
	time_update();
do_cast({build_chariot, PlayerID, GuildID, ToBuildList}) ->
	build_chariot(PlayerID, GuildID, ToBuildList);
do_cast({cancel_chariot, PlayerID, GuildID, ChariotID}) ->
	cancel_chariot(PlayerID, GuildID, ChariotID);
do_cast({guild_money_increase, GuildID}) ->
	check_wait_chariot(GuildID);
do_cast({apply_use_chariot, PlayerID, GuildID, ChariotID}) ->
	apply_use_chariot(PlayerID, GuildID, ChariotID);
do_cast({manor_use_chariot, PlayerId, GuildId, ChariotId, MapPid}) ->
	manor_use_chariot(PlayerId, GuildId, ChariotId, MapPid);
do_cast({run, Fun}) ->
	Fun();
do_cast({gm_quick_finish, PlayerID, GuildID}) ->
	gm_force_finish(PlayerID, GuildID);
do_cast(Request) ->
	?LOG_ERROR("no_match_cast: Request=~p", [Request]).

-spec do_terminate(term()) -> any().
do_terminate(_Reason) ->
	ok.

%% 时间更新
time_update_schedule() ->
	erlang:send_after(2000, self(), time_update).
time_update() ->
	Time = time:time(),
	check_build_finish(get_build_wait(), Time),
	ok.

build_chariot(PlayerID, GuildID, MaybeToBuildList) ->
	try
		GuildInfo = guild_pub:find_guild(GuildID),
		?CHECK_THROW(GuildInfo =/= {}, ?ErrorCode_Guild_NoGuild),
		ToBuildList = [R || {Type, N} = R <- MaybeToBuildList, N > 0 andalso guild_pub:is_chariot_unlock(Type, GuildInfo#guild_base.chariot_science_list)],
		?CHECK_THROW(ToBuildList =/= [], ?ErrorCode_Guild_No_Chariot_Build),
		BuildNum = lists:sum([N || {_, N} <- ToBuildList]),
		?CHECK_THROW(BuildNum > 0, ?ErrorCode_Guild_No_Chariot_Build),
		#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = QueueList} = ChariotInfo = case table_global:lookup(?TableGuildChariot, GuildID) of
																											  [] ->
																												  #chariot_info{guild_id = GuildID};
																											  [R] -> R
																										  end,
		?CHECK_THROW(length(OwnList) + length(BuildList) + length(QueueList) + BuildNum < guild_pub:get_attr_value_by_index(GuildInfo#guild_base.building_list, ?Guild_ChariotNum), ?ErrorCode_Guild_No_Chariot_Full),
		{NewBuildList, NewQueueList} = do_build(GuildID, 0, ToBuildList, BuildList, QueueList, GuildInfo),
		NewChariotInfo = ChariotInfo#chariot_info{build_list = NewBuildList, queue_list = NewQueueList},
		table_global:insert(?TableGuildChariot, NewChariotInfo),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_workshop_info_ret{list = make_chariot_msg(NewChariotInfo)}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_chariot_build_ret{error = ?ERROR_OK})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_chariot_build_ret{error = Err})
	end.

cancel_chariot(PlayerID, GuildID, ChariotID) ->
	try
		GuildInfo = guild_pub:find_guild(GuildID),
		?CHECK_THROW(GuildInfo =/= {}, ?ErrorCode_Guild_NoGuild),
		NewInfo = case table_global:lookup(?TableGuildChariot, GuildID) of
					  [] -> throw(?ErrorCode_Guild_No_Chariot);
					  [#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = QueueList} = ChariotInfo] ->
						  case lists:keyfind(ChariotID, 1, OwnList) of
							  {_, Type, _} ->
								  NewChariotInfo = ChariotInfo#chariot_info{own_list = lists:keydelete(ChariotID, 1, OwnList)},
								  table_global:insert(?TableGuildChariot, NewChariotInfo),
								  #guildchariotCfg{needs = Needs} = cfg_guildchariot:getRow(Type),
								  BackNeeds = trunc(Needs * guild_pub:get_attr_value_by_index(GuildInfo#guild_base.building_list, ?Guild_ChariotBack) / 10000),
								  guild:send_2_me({changeGuildMoney, GuildID, BackNeeds}),
								  NewChariotInfo;
							  _ ->
								  case lists:keyfind(ChariotID, 1, BuildList) of
									  {_, Type, _} ->
										  #guildchariotCfg{needs = BackNeeds} = cfg_guildchariot:getRow(Type),
										  guild:send_2_me({changeGuildMoney, GuildID, BackNeeds}),
										  del_build_wait(GuildID),
										  case QueueList of
											  [] ->
												  NewChariotInfo = ChariotInfo#chariot_info{build_list = []},
												  table_global:insert(?TableGuildChariot, NewChariotInfo);
											  [{I, T} | RemainQue] ->
												  {NewBuildList, NewQueueList} = do_build(GuildID, I, [{T, 1}], [], RemainQue, GuildInfo#guild_base{guildMoney = GuildInfo#guild_base.guildMoney + BackNeeds}),
												  NewChariotInfo = ChariotInfo#chariot_info{build_list = NewBuildList, queue_list = NewQueueList},
												  table_global:insert(?TableGuildChariot, NewChariotInfo)
										  end,
										  NewChariotInfo;
									  _ ->
										  case lists:keymember(ChariotID, 1, QueueList) of
											  ?TRUE ->
												  NewChariotInfo = ChariotInfo#chariot_info{queue_list = lists:keydelete(ChariotID, 1, QueueList)},
												  table_global:insert(?TableGuildChariot, NewChariotInfo),
												  NewChariotInfo;
											  _ -> throw(?ErrorCode_Guild_No_Chariot)
										  end
								  end
						  end
				  end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_chariot_build_cancel_ret{cancel_id = ChariotID, error = ?ERROR_OK}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_workshop_info_ret{list = make_chariot_msg(NewInfo)})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_chariot_build_cancel_ret{cancel_id = ChariotID, error = Err})
	end.

do_build(GuildID, ChariotID, [{Type, Num} | ToBuildList], [], QueueList, GuildInfo) ->
	#guildchariotCfg{needs = NeedMoney} = cfg_guildchariot:getRow(Type),
	case GuildInfo#guild_base.guildMoney >= NeedMoney andalso guild:call_me({del_guild_money, GuildID, NeedMoney}) of
		?TRUE ->
			NewChariotID = case ChariotID =:= 0 of
							   ?TRUE ->
								   id_generator:generate(?ID_TYPE_Chariot);
							   ?FALSE ->
								   ChariotID
						   end,
			NewBuildList = [{NewChariotID, Type, time:time() + get_build_time(GuildID, cfg_guildchariot:getRow(Type))}],
			NewQueueList = lists:reverse(unfold_queue_build_list([{Type, Num - 1} | ToBuildList], lists:reverse(QueueList))),
			del_wait_money_guild_list(GuildID),
			add_build_wait(GuildID, NewBuildList),
			{NewBuildList, NewQueueList};
		?FALSE ->
			NewQueueList = lists:reverse(unfold_queue_build_list([{Type, Num} | ToBuildList], lists:reverse(QueueList))),
			add_wait_money_guild_list(GuildID),
			{[], NewQueueList}
	end;
do_build(_GuildID, _ChariotID, ToBuildList, BuildList, QueueList, _GuildInfo) ->
	NewQueueList = lists:reverse(unfold_queue_build_list(ToBuildList, lists:reverse(QueueList))),
	{BuildList, NewQueueList}.

unfold_queue_build_list([], Res) -> Res;
unfold_queue_build_list([{_, 0} | T], Res) ->
	unfold_queue_build_list(T, Res);
unfold_queue_build_list([{Type, Num} | T], Res) ->
	unfold_queue_build_list([{Type, Num - 1} | T], [{id_generator:generate(?ID_TYPE_Chariot), Type} | Res]).

add_build_wait(GuildID, [{_, _, EndTime} | _]) ->
	NewSets = ordsets:add_element({EndTime, GuildID}, get_build_wait()),
	put({?MODULE, build_wait}, NewSets).
get_build_wait() ->
	case get({?MODULE, build_wait}) of
		?UNDEFINED -> ordsets:new();
		L -> L
	end.
del_build_wait({_, _} = Key) ->
	NewSets = ordsets:del_element(Key, get_build_wait()),
	put({?MODULE, build_wait}, NewSets);
del_build_wait(GuildID) when is_integer(GuildID) ->
	OldSets = get_build_wait(),
	case lists:keyfind(GuildID, 2, OldSets) of
		?FALSE -> ok;
		Key ->
			NewSets = ordsets:del_element(Key, OldSets),
			put({?MODULE, build_wait}, NewSets)
	end.

add_wait_money_guild_list(GuildID) ->
	OldList = get_wait_money_guild_list(),
	case lists:member(GuildID, OldList) of
		?FALSE -> put({?MODULE, wait_money_guild}, [GuildID | OldList]);
		_ -> ok
	end.
get_wait_money_guild_list() ->
	case get({?MODULE, wait_money_guild}) of
		?UNDEFINED -> [];
		L -> L
	end.
del_wait_money_guild_list(GuildID) ->
	OldList = get_wait_money_guild_list(),
	case lists:member(GuildID, OldList) of
		?FALSE -> put({?MODULE, wait_money_guild}, lists:delete(GuildID, OldList));
		_ -> ok
	end.

check_build_finish([{EndTime, GuildID} | T], Time) when Time >= EndTime ->
	build_finish({EndTime, GuildID}),
	check_build_finish(T, Time);
check_build_finish(_, _) -> ok.

build_finish({_EndTime, GuildID} = Key) ->
	del_build_wait(Key),
	case guild_pub:find_guild(GuildID) of
		{} -> ok;
		GuildInfo ->
			case table_global:lookup(?TableGuildChariot, GuildID) of
				[] -> ok;
				[#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = []} = Info] ->
					NewInfo = Info#chariot_info{own_list = OwnList ++ BuildList, build_list = []},
					table_global:insert(?TableGuildChariot, NewInfo);
				[#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = [{ID, Type} | QueueRemain]} = Info] ->
					{NewBuildList, NewQueueList} = do_build(GuildID, ID, [{Type, 1}], [], QueueRemain, GuildInfo),
					NewInfo = Info#chariot_info{own_list = OwnList ++ BuildList, build_list = NewBuildList, queue_list = NewQueueList},
					table_global:insert(?TableGuildChariot, NewInfo)
			end
	end.

gm_force_finish(PlayerID, GuildID) ->
	[del_build_wait(Key) || {_, G} = Key <- get_build_wait(), G =:= GuildID],
	case guild_pub:find_guild(GuildID) of
		{} -> ok;
		GuildInfo ->
			case table_global:lookup(?TableGuildChariot, GuildID) of
				[] -> ok;
				[#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = []} = Info] ->
					NewInfo = Info#chariot_info{own_list = OwnList ++ [setelement(3, R, 1) || R <- BuildList], build_list = []},
					table_global:insert(?TableGuildChariot, NewInfo),
					m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_workshop_info_ret{list = make_chariot_msg(NewInfo)});
				[#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = [{ID, Type} | QueueRemain]} = Info] ->
					{NewBuildList, NewQueueList} = do_build(GuildID, ID, [{Type, 1}], [], QueueRemain, GuildInfo),
					NewInfo = Info#chariot_info{own_list = OwnList ++ [setelement(3, R, 1) || R <- BuildList], build_list = NewBuildList, queue_list = NewQueueList},
					table_global:insert(?TableGuildChariot, NewInfo),
					m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_workshop_info_ret{list = make_chariot_msg(NewInfo)})
			end
	end.

get_build_time(GuildID, #guildchariotCfg{time = Time}) ->
	trunc((10000 - guild_pub:get_attr_value_by_index(GuildID, ?Guild_ChariotTimeDec)) * Time / 10000);
get_build_time(GuildID, {}) ->
	?LOG_ERROR("cfg null"),
	trunc((10000 - guild_pub:get_attr_value_by_index(GuildID, ?Guild_ChariotTimeDec)) * 900 / 10000).

make_chariot_msg(#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = QueueList}) ->
	List1 = [#pk_chariot_stc{id = ID, type = Type, end_time = Time} || {ID, Type, Time} <- OwnList],
	List2 = [#pk_chariot_stc{id = ID, type = Type, end_time = Time} || {ID, Type, Time} <- BuildList],
	List3 = [#pk_chariot_stc{id = ID, type = Type, end_time = 0} || {ID, Type} <- QueueList],
	List1 ++ List2 ++ List3.

check_wait_chariot(GuildID) ->
	WaitList = get_wait_money_guild_list(),
	case lists:member(GuildID, WaitList) of
		?TRUE ->
			del_wait_money_guild_list(GuildID),
			case table_global:lookup(?TableGuildChariot, GuildID) of
				[] -> throw(?ErrorCode_Guild_No_Chariot);
				[#chariot_info{build_list = BuildList, queue_list = QueueList} = ChariotInfo] ->
					case BuildList =/= [] of
						?TRUE -> ok;
						_ ->
							case QueueList of
								[] -> ok;
								[{ID, Type} | QueueRemain] ->
									case guild_pub:find_guild(GuildID) of
										{} -> ok;
										GuildInfo ->
											{NewBuildList, NewQueueList} = do_build(GuildID, ID, [{Type, 1}], BuildList, QueueRemain, GuildInfo),
											case NewBuildList =/= [] of
												?TRUE ->
													NewChariotInfo = ChariotInfo#chariot_info{build_list = NewBuildList, queue_list = NewQueueList},
													table_global:insert(?TableGuildChariot, NewChariotInfo);
												_ -> ok
											end
									end
							end
					end
			end;
		?FALSE ->
			ok
	end.

apply_use_chariot(PlayerID, GuildID, ChariotID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		Rank = guild_pub:get_member_rank(GuildID, PlayerID),
		IsOpen = variant:isBitOn(Guild#guild_base.chariot_use_rule, Rank),
		?CHECK_THROW(IsOpen, ?ErrorCode_Guild_RankEnough),
		case table_global:lookup(?TableGuildChariot, GuildID) of
			[] -> throw(?ErrorCode_Guild_No_Chariot);
			[#chariot_info{own_list = OwnList} = ChariotInfo] ->
				case lists:keyfind(ChariotID, 1, OwnList) of
					?FALSE -> throw(?ErrorCode_Guild_No_Chariot);
					{_, Type, _} ->
						#guildchariotCfg{transformModel = TransBuffID} = cfg_guildchariot:getRow(Type),
						{Venue, _} = domain_fight_logic:get_guild_venue(GuildID),
						?CHECK_THROW(Venue > 0, ?ErrorCode_DomainFight_Enter_Not_Permission),
						{MapPid, _, _} = domain_fight_logic:get_venue_map(Venue),
						?CHECK_THROW(is_pid(MapPid) andalso is_process_alive(MapPid), ?ErrorCode_DomainFight_Not_Start),
						{ExBuffList, ExSkillList} = lists:foldl(fun(Key, {R1, R2}) ->
							case cfg_chariotscience:row(Key) of
								#chariotscienceCfg{strengthen = {2, BuffID}} -> {[BuffID | R1], R2};
								#chariotscienceCfg{strengthen = {3, SkillID}} -> {R1, [SkillID | R2]};
								_ -> {R1, R2}
							end
																end, {[], []}, Guild#guild_base.chariot_science_list),
						MapPid ! {domain_map_msg, {use_chariot, PlayerID, TransBuffID, ExBuffList, ExSkillList}},
						table_global:insert(?TableGuildChariot, ChariotInfo#chariot_info{own_list = lists:keydelete(ChariotID, 1, OwnList)})
				end
		end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_ManorWarChariotsRet{type = 1, chariot_id = ChariotID, err_code = ?ERROR_OK})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_ManorWarChariotsRet{type = 1, chariot_id = ChariotID, err_code = Err})
	end.

manor_use_chariot(PlayerId, GuildId, ChariotId, MapPid) ->
	try
		Guild = guild_pub:find_guild(GuildId),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		Rank = guild_pub:get_member_rank(GuildId, PlayerId),
		IsOpen = variant:isBitOn(Guild#guild_base.chariot_use_rule, Rank),
		?CHECK_THROW(IsOpen, ?ErrorCode_Guild_RankEnough),
		case table_global:lookup(?TableGuildChariot, GuildId) of
			[#chariot_info{own_list = OwnList} = ChariotInfo] ->
				case lists:keyfind(ChariotId, 1, OwnList) of
					?FALSE -> throw(?ErrorCode_Guild_No_Chariot);
					{_, Type, _} ->
						#guildchariotCfg{transformModel = TransBuffId} = cfg_guildchariot:getRow(Type),
						{ExBuffList, ExSkillList} = lists:foldl(
							fun(Key, {R1, R2}) ->
								case cfg_chariotscience:row(Key) of
									#chariotscienceCfg{strengthen = {2, BuffID}} -> {[BuffID | R1], R2};
									#chariotscienceCfg{strengthen = {3, SkillID}} -> {R1, [SkillID | R2]};
									_ -> {R1, R2}
								end
							end, {[], []}, Guild#guild_base.chariot_science_list),
						m_send:send_pid_msg(MapPid, {manor_war_msg, {use_chariot, PlayerId, TransBuffId, ExBuffList, ExSkillList}}),
						table_global:insert(?TableGuildChariot, ChariotInfo#chariot_info{own_list = lists:keydelete(ChariotId, 1, OwnList)})

				end;
			_ -> throw(?ErrorCode_Guild_No_Chariot)
		end,
		m_send:sendMsgToClient(PlayerId, #pk_GS2U_ManorChariotsRet{chariot_id = ChariotId})
	catch
	    ErrCode ->
		    m_send:sendMsgToClient(PlayerId, #pk_GS2U_ManorChariotsRet{err_code = ErrCode, chariot_id = ChariotId})
	end.


