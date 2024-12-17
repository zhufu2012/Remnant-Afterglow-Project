%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 战盟事件
%%% @end
%%% Created : 10. 八月 2018 14:36
%%%-------------------------------------------------------------------
-module(guild_event).
-author("zhangrj").

-include("logger.hrl").
-include("condition_compile.hrl").
-include("guild.hrl").
-include("globalDict.hrl").
-include("db_table.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("id_generator.hrl").
-include("netmsgRecords.hrl").

-export([init/1, start_link/0, handle_info/2, handle_cast/2, handle_call/3, code_change/3, terminate/2]).
-export([
	add_guild_event/1,
	add_guild_event/5,
	get_module_log_list/1,
	get_guild_module_log_list/2
]).
-record(state, {}).

start_link() ->
	gen_server:start_link({local, guild_event}, ?MODULE, [], [{timeout, ?Start_Link_TimeOut_ms}]).

init(Args) ->
	try
		State = do_init(Args),
		{ok, State}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{stop, ExcReason}
	end.

handle_call(Request, From, State) ->
	try
		{Reply, NewState} = do_call(Request, From, State),
		{reply, Reply, NewState}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{reply, {error, ExcReason}, State}
	end.

handle_cast(Request, State) ->
	try
		NewState = do_cast(Request, State),
		{noreply, NewState}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{noreply, State}
	end.

handle_info(Info, State) ->
	try
		put(?Noreply, true),
		NewState = do_cast(Info, State),
		case get(?Noreply) of
			true -> {noreply, NewState};
			false -> {stop, normal, NewState}
		end
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{noreply, State}
	end.

terminate(Reason, State) ->
	try
		do_terminate(Reason, State)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

do_init([]) ->
	ets:new(?GuildEventEts, [{keypos, #guildEvent.id}, named_table, protected, set, ?ETSRC, ?ETSWC]),
	erlang:send_after(?MainTick_INTERVAL, self(), {activeTicker}),
	load_event_data(),
	#state{}.

%% 返回{Reply, NewState}
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState
do_cast({activeTicker}, State) ->
	erlang:send_after(?MainTick_INTERVAL * 3600, self(), {activeTicker}),
	TimesTamp = time:time(),
	on_tick(TimesTamp),
	State;
do_cast({add_guild_event, Info}, State) ->
	save_guild_event(Info),
	State;
do_cast({on_guild_dismiss, GuildID}, State) ->
	on_guild_dismiss(GuildID),
	State;
do_cast({add_depot_show_eq, Equip}, State) ->
	add_depot_show_eq(Equip),
	State;
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

do_terminate(_Reason, _State) ->
	ok.

load() ->
	List = table_global:record_list(db_guild_event),
	[db_2_record(R) || R <- List].
update(Info) ->
	DBInfo = record_2_db(Info),
	table_global:insert(db_guild_event, DBInfo).
delete(ID) when is_integer(ID) ->
	table_global:delete(db_guild_event, [ID]);
delete(IDList) ->
	table_global:delete(db_guild_event, IDList).

db_2_record(Info) ->
	#guildEvent{
		id = Info#db_guild_event.id,
		guild_id = Info#db_guild_event.guild_id,
		module = Info#db_guild_event.module,
		type = Info#db_guild_event.type,
		player_id = Info#db_guild_event.player_id,
		rank = Info#db_guild_event.rank,
		time = Info#db_guild_event.time,
		params = gamedbProc:dbstring_to_term(Info#db_guild_event.params)
	}.
record_2_db(Info) ->
	#db_guild_event{
		id = Info#guildEvent.id,
		guild_id = Info#guildEvent.guild_id,
		module = Info#guildEvent.module,
		type = Info#guildEvent.type,
		player_id = Info#guildEvent.player_id,
		rank = Info#guildEvent.rank,
		time = Info#guildEvent.time,
		params = gamedbProc:term_to_dbstring(Info#guildEvent.params)
	}.

load_event_data() ->
	List = load(),
	etsBaseFunc:insertRecord(?GuildEventEts, List).

on_tick(TimesTamp) ->
	%% 战盟动态保存3天
	check_event_log(TimesTamp, ?EventModule_1, 3),
	%% 红包事件保存3天
	check_event_log(TimesTamp, ?EventModule_2, 3),
	%% 仓库事件保存7天
	check_event_log(TimesTamp, ?EventModule_3, 7),
	%% 宝箱事件保存7天
	check_event_log(TimesTamp, ?EventModule_4, 7),
	%% 装备查看检查
	check_show_eq(TimesTamp),
	ok.

%% 检查战盟事件
check_event_log(TimesTamp, Module, Day) ->
	List = get_module_log_list(Module),
	IDList = [R#guildEvent.id || R <- List, TimesTamp >= time:time_add(R#guildEvent.time, ?SECONDS_PER_DAY * Day)],
	[etsBaseFunc:deleteRecord(?GuildEventEts, ID) || ID <- IDList],
	delete(IDList).

check_show_eq(TimesTamp) ->
	T = time:time_add(TimesTamp, ?SECONDS_PER_WEEK),
	Q = ets:fun2ms(fun(#depotShowEq{time = Time}) when Time >= T -> ?TRUE end),
	ets:select_delete(?GuildDepotShowEqEts, Q).

%% 保存日志
save_guild_event(Info) ->
	etsBaseFunc:insertRecord(?GuildEventEts, Info),
	update(Info).

%% 响应战盟解散
on_guild_dismiss(GuildID) ->
	Q = ets:fun2ms(fun(#guildEvent{guild_id = GID} = R) when GID =:= GuildID -> R end),
	List = ets:select(?GuildEventEts, Q),
	IDList = [R#guildEvent.id || R <- List],
	[etsBaseFunc:deleteRecord(?GuildEventEts, ID) || ID <- IDList],
	delete(IDList).

%% 增加仓库装备显示数据
add_depot_show_eq(Equip) when is_tuple(Equip) ->
	add_depot_show_eq([Equip]);
add_depot_show_eq(Equips) ->
	List = [#depotShowEq{
		uid = Eq#eq.uid,
		eq = Eq,
		time = time:time()
	} || Eq <- Equips],
	etsBaseFunc:insertRecord(?GuildDepotShowEqEts, List).

%% TODO ---------------------- 公共进程 -------------------------
%% 获取指定模块的日志
get_module_log_list(Module) ->
	Q = ets:fun2ms(fun(#guildEvent{module = Mod} = R) when Mod =:= Module -> R end),
	ets:select(?GuildEventEts, Q).

%% 获取指定战盟指定模块的日志
get_guild_module_log_list(GuildID, Module) ->
	Q = ets:fun2ms(fun(#guildEvent{guild_id = GID, module = Mod} = R)
		when GID =:= GuildID andalso Mod =:= Module -> R end),
	ets:select(?GuildEventEts, Q).

%% 新获取一个ID
get_event_id() -> id_generator:generate(?ID_Type_GuildEvent).

%% ID和time可自动生成
add_guild_event(Event) ->
	Info = Event#guildEvent{
		id = common:getTernaryValue(Event#guildEvent.id =:= 0, get_event_id(), Event#guildEvent.id),
		time = time:time()
	},
	?MODULE ! {add_guild_event, Info}.
add_guild_event(GuildID, Module, Type, PlayerID, Params) ->
	Event = #guildEvent{
		id = id_generator:generate(?ID_Type_GuildEvent),
		guild_id = GuildID,
		module = Module,
		type = Type,
		player_id = PlayerID,
		rank = guild_pub:get_member_rank(GuildID, PlayerID),
		params = Params
	},
	guild_event:add_guild_event(Event).


