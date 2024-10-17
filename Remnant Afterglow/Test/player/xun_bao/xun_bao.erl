%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 寻宝：管理进程
%%% @end
%%% Created : 2018-12-12 10:00
%%%-------------------------------------------------------------------
-module(xun_bao).
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("logger.hrl").

-define(SERVER, ?MODULE).


%%%====================================================================
%%% API functions
%%%====================================================================
-export([start_link/0]).
-export([cast/1]).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

cast(Request) ->
	gen_server:cast(?SERVER, Request).


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
	xun_bao_period:on_init(),
	xun_bao_record:on_init(),
	time_update_schedule(),
	#state{}.

%% 返回{Reply, NewState}
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState
do_cast(time_update, State) ->
	time_update_schedule(),
	time_update(),
	State;
%%
do_cast(reset_period, State) ->
	xun_bao_period:gm_reset(),
	State;
do_cast({add_record, DataId, Record}, State) ->
	xun_bao_record:add_record(DataId, Record),
	State;
%%
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

do_terminate(_Reason, _State) ->
	ok.

%% 时间更新
time_update_schedule() ->
	erlang:send_after(1000, self(), time_update).
time_update() ->
	Time = time:time(),
	xun_bao_period:on_tick(Time).