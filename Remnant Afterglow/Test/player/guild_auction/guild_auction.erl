%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%            战盟拍卖行 管理进程
%%% @end
%%% Created : 19. 十二月 2018 15:55
%%%-------------------------------------------------------------------
-module(guild_auction).
-author("cbfan").
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("logger.hrl").
-include("guild_auction.hrl").
-include("cfg_guildOccupy.hrl").
-include("guild.hrl").
-include("cfg_guildProtect.hrl").
-include("cfg_lDZAuction2.hrl").

-define(SERVER, ?MODULE).


%%%====================================================================
%%% API functions
%%%====================================================================
-export([start_link/0]).
-export([send_2_me/1]).
-export([add_auction/1, gm_add_domain_auction/0]).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

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
	guild_auction_logic:on_init(),
	erlang:send_after(1000, self(), tick),
	#state{}.

%% 返回{Reply, NewState}
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

send_2_me(Msg) -> gen_server:cast(?SERVER, Msg).
%% 返回NewState
do_cast(tick, State) ->
	guild_auction_logic:on_tick(),
	State;
do_cast({reset}, State) ->
	State;
do_cast({add_auction, Msg}, State) ->
	guild_auction_logic:add_auction(Msg),
	State;
do_cast({open_ui, GuildId, PlayerId, Pid}, State) ->
	guild_auction_logic:open_ui(GuildId, PlayerId, Pid),
	State;
do_cast({close_ui, GuildId, PlayerId}, State) ->
	guild_auction_logic:close_ui(GuildId, PlayerId),
	State;
do_cast({bid, Msg}, State) ->
	guild_auction_logic:bid(Msg),
	State;
do_cast({bid_immediate, Msg}, State) ->
	guild_auction_logic:bid_immediate(Msg),
	State;
do_cast({set_bid_authority, Msg}, State) ->
	guild_auction_logic:set_bid_authority(Msg),
	State;
do_cast({manager_online, GuildID}, State) ->
	guild_auction_logic:on_manager_online(GuildID),
	State;
do_cast({gm_settle_accounts}, State) ->
	guild_auction_logic:on_settle_accounts(),
	State;
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

do_terminate(_Reason, _State) ->
	ok.


%%%===================================================================
%%% API
%%%===================================================================
%% Info {GuildId, ActivityId, SourceID, ItemList, EqList, PlayerList}
add_auction(Info) ->
	guild_auction:send_2_me({add_auction, Info}).

gm_add_domain_auction() ->
	GuildID = player:getPlayerProperty(#player.guildID),
	[case cfg_lDZAuction2:row(Key) of
		 #lDZAuction2Cfg{iD = Round, auctionAward = AuctionAward, numberOrder = NumberOrder, auctPerson = PersonAward} when GuildID > 0 ->
			 PlayerList = guild_pub:get_guild_member_id_list(GuildID),
			 LeaderId = guild_pub:get_guild_chairman_id(GuildID),
			 #player{level = Level, leader_role_id = LeaderRoleId} = mirror_player:get_player(LeaderId),
			 Career = mirror_player:get_role_career(LeaderId, LeaderRoleId),
			 JoinNum = length(PlayerList),
			 {_, NumIndex} = common:getValueByInterval(JoinNum, NumberOrder, {0, 0}),
			 Award = [{C, D, Bd, Nm, R} || {I, C, D, Bd, Nm, R} <- AuctionAward, NumIndex =:= I],
			 {ItemList11, EqList1, _, _} = drop:drop(Award, [], LeaderId, Career, Level),
			 {ItemList22, EqList2, _, _} = drop:drop(PersonAward, [], LeaderId, Career, Level),
			 ItemList1 = lists:append([lists:duplicate(N, {I, 1, B, T}) || {I, N, B, T} <- ItemList11]),
			 ItemList2 = lists:append([lists:duplicate(N, {I, 1, B, T}) || {I, N, B, T} <- ItemList22]),
			 guild_auction:add_auction({GuildID, ?GuildAuctionGuildDomainFight, Round, {ItemList1, EqList1}, {ItemList2, EqList2}, [{ID, mirror_player:get_player_name(ID)} || ID <- PlayerList]});
		 _ ->
			 ok
	 end || Key <- [{1, 0, 1, 1}, {2, 0, 1, 1}, {3, 0, 1, 1}, {4, 0, 1, 1}]].