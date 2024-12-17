%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%            XO房间 管理进程(斯芬克斯房间)
%%% @end
%%% Created : 14. 十二月 2018 14:56
%%%-------------------------------------------------------------------
-module(xo_room).
-author("cbfan").
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("logger.hrl").
-include("xo_room.hrl").
-include("gameMap.hrl").

-define(SERVER, ?MODULE).


%%%====================================================================
%%% API functions
%%%====================================================================
-export([start_link/0]).
-export([send_2_me/1, call_me/1, send_2_master/1, master_2_slave/1]).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

send_2_me(Msg) -> gen_server:cast(?SERVER, Msg).
call_me(Msg) -> gen_server:call(?SERVER, Msg).

send_2_master(Msg) -> cluster:cast_master(?SERVER, Msg).
master_2_slave(Msg) -> cluster:master_broadcast_slave(?SERVER, Msg).

%%%====================================================================
%%% Behavioural functions
%%%====================================================================
-record(state, {}).

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
		NewState = do_cast(Info, State),
		{noreply, NewState}
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


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 返回State
do_init([]) ->
	cluster:start(?SERVER),
	xo_room_logic:on_init(),
	erlang:send_after(1000, self(), tick),
	#state{}.

%% 返回{Reply, NewState}
do_call({get_player_pos, PlayerId}, _CallFrom, State) ->
	Reply = xo_room_logic:get_player_pos(PlayerId),
	{Reply, State};
do_call({get_player_rank_local, ServerID}, _CallFrom, State) ->
	Reply = xo_room_logic:get_player_rank_local(ServerID),
	{Reply, State};
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState

%% 返回NewState
%% 世界服开启
do_cast({cluster_open, IsMerge}, State) ->
	xo_room_logic:on_cluster_open(),
	xo_room_logic:on_dict_init(),
	State;
%% 世界服关闭
do_cast({cluster_close, IsMerge}, State) ->
	main:sendMsgToMap(?MapAI_XORoom, {cluster_close, IsMerge}),
	State;
%% 服务器连接
do_cast({cluster_server_up, _RemoteServerId}, State) ->
	State;
%% 服务器断开
do_cast({cluster_server_down, RemoteServerId}, State) ->
	main:sendMsgToMap(?MapAI_XORoom, {cluster_server_down, RemoteServerId}),
	State;
do_cast({deal_rank_reward, RankList, Info}, State) ->
	xo_room_logic:deal_rank_reward_local(RankList, Info),
	State;
do_cast(xo_room_init, State) ->
	xo_room_logic:on_dict_init(),
	State;


do_cast(tick, State) ->
	erlang:send_after(1000, self(), tick),
	cluster:master_apply(?SERVER, fun() -> xo_room_logic:on_tick() end),
%%	xo_room_logic:on_tick(),
	State;
do_cast({player_enter, Msg}, State) ->
	xo_room_logic:on_player_enter(Msg),
	State;
do_cast({player_change_name, PlayerId, Name}, State) ->
	xo_room_logic:on_player_name_change(PlayerId, Name),
	State;
do_cast({player_exit, Msg}, State) ->
	xo_room_logic:on_player_exit(Msg),
	State;
do_cast({gm_set_ac, Delay}, State) ->
	xo_room_logic:on_gm_open(Delay),
	master_2_slave({gm_set_ac, Delay}),
	State;
do_cast({enter_area, Pid, PlayerId, Type}, State) ->
	xo_room_logic:enter_area(Pid, PlayerId, Type),
	State;
do_cast({exit_area, Pid, PlayerId, Type}, State) ->
	xo_room_logic:exit_area(Pid, PlayerId, Type),
	State;
do_cast({ask_answer, Pid, PlayerId, Answer}, State) ->
	xo_room_logic:ask_answer(Pid, PlayerId, Answer),
	State;
do_cast({get_rank, PlayerId, Pid, Sex, Name}, State) ->
	xo_room_logic:on_request_rank_msg(PlayerId, Pid, Sex, Name),
	State;
do_cast({get_bet_ui, PlayerId}, State) ->
	xo_room_logic:get_bet_ui(PlayerId),
	State;
do_cast({on_bet, PlayerId, Pid, BetInfo}, State) ->
	xo_room_logic:on_bet(PlayerId, Pid, BetInfo),
	State;
do_cast({reset}, State) ->
	cluster:master_apply(?SERVER, fun() -> xo_room_logic:week_reset() end),
	State;
do_cast({time_sync, NewStartTime, NewEndTime, NewOrder}, State) ->
	ets:insert(?MainEts, #mainEtsInfo{key = ?MainEtsKey_XoRoom, value = [{NewStartTime, NewEndTime, 0, NewOrder}]}),
	State;
do_cast({xo_Notice}, State) ->
	xo_room_player:sendMarquee(),
	State;
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

do_terminate(_Reason, _State) ->
	ok.


%%%===================================================================
%%% API
%%%===================================================================
