%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%		战盟篝火及BOSS
%%% @end
%%% Created : 09. 三月 2020 19:56
%%%-------------------------------------------------------------------
-module(bonfire_boss).
-author("suw").

-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("logger.hrl").
-include("record.hrl").
-include("bonfire_boss.hrl").
-include("gameMap.hrl").
-include("netmsgRecords.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("guild.hrl").
-include("cfg_dinnerBossAuct.hrl").
-include("cfg_dinnerBossBase.hrl").
-include("cfg_guildDinnerAwards.hrl").
-include("cfg_guildDinneDrink.hrl").
-include("db_table.hrl").
-include("attainment.hrl").
-include("seven_gift_define.hrl").
-include("activity_new.hrl").
-include("daily_task_goal.hrl").
-include("grow_attr.hrl").
-include("currency.hrl").
-include("cfg_expDistribution.hrl").
-include("cfg_guildBuilding.hrl").
-include("attribute.hrl").
-include("variable.hrl").

-define(SERVER, ?MODULE).


%%%====================================================================
%%% API functions
%%%====================================================================
-export([start_link/0, send_2_me/1, gm_open/3]).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

send_2_me(Msg) ->
	gen_server:cast(?SERVER, Msg).

send_2_master(Msg) ->
	cluster:cast_master(?SERVER, Msg).
master_brodecast(Msg) ->
	cluster:master_broadcast_slave(?SERVER, Msg).

gm_open(DelayTime, BossDelayTime, KeepTime) ->
	send_2_me({gm_open, DelayTime, BossDelayTime, KeepTime}).
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
	ets:new(?ETS_BonfireBoss, [set, protected, named_table, {keypos, #bonfire_boss.guild_id}, ?ETSRC, ?ETSWC]), %% 本地
	ets:new(?ETS_BonfireClusterTop, [set, protected, named_table, {keypos, #bonfire_cluster_top.guild_id}, ?ETSRC, ?ETSWC]), %% 联服

	Data = case bonfire_boss_logic:is_bonfire_func_open() of
			   ?TRUE ->
				   Now = time:time(),
				   {_, OpenTime, CloseTime} = bonfire_boss_logic:get_schedule_time(Now),
				   {_, _, BossCloseTime} = bonfire_boss_logic:get_schedule_boss_time(Now),
				   #bonfire_data{stage = ?Bonfire_Idle_Stage, open_time = OpenTime, boss_time = CloseTime, close_time = BossCloseTime};
			   ?FALSE ->
				   #bonfire_data{stage = ?Bonfire_Close_Stage, open_time = 4294967295, boss_time = 4294967295, close_time = 4294967295}
		   end,
	update_bonfire_data(Data),
	time_update_schedule(),
	#state{}.

%% 返回{Reply, NewState}
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState
%% 世界服开启
do_cast({cluster_open, _IsMerge}, State) ->
	State;
%% 世界服关闭
do_cast({cluster_close, _IsMerge}, State) ->
	State;
%% 服务器连接
do_cast({cluster_server_up, _RemoteServerId}, State) ->
	State;
%% 服务器断开
do_cast({cluster_server_down, _RemoteServerId}, State) ->
	State;
do_cast(time_update, State) ->
	time_update_schedule(),
	time_update(),
	State;
do_cast({player_drink, PlayerId, GuildID, Index}, State) ->
	player_drink(PlayerId, GuildID, Index),
	State;
do_cast({player_stage_award, PlayerId, GuildID}, State) ->
	player_stage_award(PlayerId, GuildID),
	State;
do_cast({bonfire_boss_update_elem, GuildID, ElemSpec}, State) ->
	bonfire_boss_update_elem(GuildID, ElemSpec),
	State;
do_cast({player_enter_map, GuildId, PlayerId, ReParam}, State) ->
	player_enter_map(GuildId, PlayerId, ReParam),
	State;
do_cast({player_exit_map, GuildId, PlayerId}, State) ->
	player_exit_map(GuildId, PlayerId),
	State;
do_cast({add_red_money, PlayerId, GuildID, Money}, State) ->
	add_red_money(PlayerId, GuildID, Money),
	State;
do_cast({check_init_data, GuildID, PlayerList}, State) ->
	init_data(GuildID, PlayerList),
	State;
do_cast({damage_rank_sync, GuildID, RankList, TotalDamage}, State) ->
	damage_rank_update(GuildID, RankList),
	GuildInfo = guild_pub:find_guild(GuildID),
	{Name1, Name2} = case GuildInfo of
						 {} -> {"", ""};
						 _ ->
							 {GuildInfo#guild_base.chairmanPlayerName, GuildInfo#guild_base.guildName}
					 end,
	send_2_master({cluster_rank_sync, config:server_id(), GuildID, Name1, Name2, TotalDamage}),
	State;
do_cast({cluster_rank_sync, ServerID, GuildID, ChairmanName, GuildName, TotalDamage}, State) ->
	Info = #bonfire_cluster_top{guild_id = GuildID, server_id = ServerID, chairman_name = ChairmanName,
		guild_name = GuildName, total_damage = TotalDamage},
	etsBaseFunc:insertRecord(?ETS_BonfireClusterTop, Info),
	master_brodecast({updata_cluster_top_local, Info}),
	State;
do_cast({updata_cluster_top_local, Data}, State) ->
	etsBaseFunc:insertRecord(?ETS_BonfireClusterTop, Data),
	State;
do_cast({daily_reset}, State) ->
	etsBaseFunc:deleteAllRecord(?ETS_BonfireBoss),
	etsBaseFunc:deleteAllRecord(?ETS_BonfireClusterTop),
	State;
do_cast({gm_open, DelayTime, BossDelayTime, KeepTime}, State) ->
	OpenTime = time:time() + DelayTime,
	Data = #bonfire_data{stage = ?Bonfire_Idle_Stage, open_time = OpenTime, boss_time = OpenTime + BossDelayTime, close_time = OpenTime + KeepTime},
	update_bonfire_data(Data),
	Msg = #pk_GS2U_GuildCampInfoSync{start_timestamp = OpenTime, boss_timestamp = OpenTime + BossDelayTime, end_timestamp = OpenTime + KeepTime},
	main:sendMsgToAllClient(Msg),
	State;
do_cast({gm_end}, State) ->
	EndTime = time:time(),
	Data = find_bonfire_data(),
	NewData = Data#bonfire_data{boss_time = EndTime, close_time = EndTime},
	update_bonfire_data(NewData),
	State;
do_cast({gm_clear_t, PlayerId, GuildID}, State) ->
	gm_reset_drink(PlayerId, GuildID),
	State;
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
	time_update_activity(Time),
	Stage = bonfire_boss_logic:get_stage(),
	sync_rank(Time rem 2 =:= 0 andalso Stage =:= ?Bonfire_Boss_Stage),
	award_tick(Stage =:= ?Bonfire_Exp_Stage andalso Time rem cfg_globalSetup:guildDinner_AwardTime() =:= 0),
	ok.

update_bonfire_data(Data) ->
	d:storage_put('bonefire_boss_ac_data', Data).
find_bonfire_data() ->
	d:storage_get('bonefire_boss_ac_data', #bonfire_data{}).

time_update_activity(Time) ->
	#bonfire_data{stage = Stage, open_time = OpenTime, boss_time = BossTime, close_time = CloseTime} = Data = find_bonfire_data(),
	case Stage of
		?Bonfire_Close_Stage ->
			case bonfire_boss_logic:is_bonfire_func_open() of
				?TRUE ->
					{_, NewOpenTime1, NewCloseTime1} = bonfire_boss_logic:get_schedule_time(Time),
					{_, _, NewBossCloseTime1} = bonfire_boss_logic:get_schedule_boss_time(Time),
					NewData = Data#bonfire_data{stage = ?Bonfire_Idle_Stage, open_time = NewOpenTime1, boss_time = NewCloseTime1, close_time = NewBossCloseTime1},
					update_bonfire_data(NewData);
				_ ->
					skip
			end;
		?Bonfire_Idle_Stage ->
			case Time >= OpenTime of
				?TRUE ->
					main:sendMsgToMap(?MapAI_GuildCamp, {bonfire_boss_msg, {bonfire_start}}),
					NewData = Data#bonfire_data{stage = ?Bonfire_Drink_Stage},
					update_bonfire_data(NewData),
					marquee:sendConditionNotice(0, 1, 0, [{?OpenAction_GuildCamp, guildDinner_gonggao02,
						fun(Language) -> language:get_server_string("GuildDinner_gonggao02", Language) end}]);
				?FALSE ->
					case OpenTime - Time =:= 600 of
						?TRUE ->
							marquee:sendConditionNotice(0, 1, 0, [{?OpenAction_GuildCamp, guildDinner_gonggao01,
								fun(Language) ->
									language:format(language:get_server_string("GuildDinner_gonggao01", Language), [10])
								end}]);
						_ -> ok
					end,
					case OpenTime - Time =:= 300 of
						?TRUE ->
							marquee:sendConditionNotice(0, 1, 0, [{?OpenAction_GuildCamp, guildDinner_gonggao01,
								fun(Language) ->
									language:format(language:get_server_string("GuildDinner_gonggao01", Language), [5]) end}]);
						_ -> ok
					end,
					case Time >= OpenTime - 180 andalso get_is_not_push() of
						?TRUE ->
							set_is_not_push(?FALSE);
						?FALSE -> ok
					end
			end;
		?Bonfire_Drink_Stage ->
			case Time >= OpenTime + cfg_globalSetup:guildDinner_PreTime() of
				?TRUE ->
					main:sendMsgToMap(?MapAI_GuildCamp, {bonfire_boss_msg, {bonfire_pre_time_finish}}),
					NewData = Data#bonfire_data{stage = ?Bonfire_Exp_Stage},
					update_bonfire_data(NewData);
				_ -> ok
			end;
		?Bonfire_Exp_Stage ->
			case Time >= BossTime + cfg_globalSetup:guildDinnerBossTime() of
				?TRUE ->
					do_ret_stage_award(),
					marquee:sendConditionNotice(0, 1, 0, [{?OpenAction_BonfireBoss, guildDinner_gonggao05,
						fun(Language) -> language:get_server_string("GuildDinner_gonggao05", Language) end}]),
					main:sendMsgToMap(?MapAI_GuildCamp, {bonfire_boss_msg, {bonfire_boss_start}}),
					NewData = Data#bonfire_data{stage = ?Bonfire_Boss_Stage},
					update_bonfire_data(NewData);
				?FALSE ->
					case Time =:= BossTime of
						?TRUE ->
							bonfire_boss_logic:boss_refresh_broadcast();
						_ -> ok
					end
			end;
		?Bonfire_Boss_Stage ->
			case Time >= CloseTime of
				?TRUE ->
					main:sendMsgToMap(?MapAI_GuildCamp, {bonfire_boss_msg, {bonfire_end}}),
					{_, NewOpenTime, NewCloseTime} = bonfire_boss_logic:get_schedule_time(Time),
					{_, _, NewBossCloseTime} = bonfire_boss_logic:get_schedule_boss_time(Time),
					NewData = Data#bonfire_data{stage = ?Bonfire_Idle_Stage, open_time = NewOpenTime, boss_time = NewCloseTime, close_time = NewBossCloseTime},
					update_bonfire_data(NewData),
					guild_rank_award(),
					marquee:sendConditionNotice(0, 1, 0, [{?OpenAction_BonfireBoss, guildDinner_gonggao09,
						fun(Language) -> language:get_server_string("GuildDinner_gonggao09", Language) end}]),
					NewInfo = [Info#bonfire_boss{player_drink_info = [], guild_ratio = 0, guild_t2 = 0, treat_point = 0,
						guild_materials = 0} || Info <- etsBaseFunc:getAllRecord(?ETS_BonfireBoss)],
					etsBaseFunc:insertRecord(?ETS_BonfireBoss, NewInfo),
					main:sendMsgToAllPlayer({game_ac_end, ?OpenAction_BonfireBoss}),
					set_is_not_push(?TRUE);
				?FALSE -> ok
			end
	end.

bonfire_boss_update_elem(GuildID, ElemSpec) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		{} ->
			Data = lists:foldl(fun({P, V}, Ret) ->
				setelement(P, Ret, V) end, #bonfire_boss{guild_id = GuildID}, ElemSpec),
			etsBaseFunc:insertRecord(?ETS_BonfireBoss, Data);
		_ ->
			etsBaseFunc:changeFiled(?ETS_BonfireBoss, GuildID, ElemSpec)
	end.

player_enter_map(GuildID, PlayerID, ReParam) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		#bonfire_boss{player_drink_info = PlayerDrinkInfo} = Info ->
			NewPlayerDrinkInfo = case lists:keytake(PlayerID, #bonfire_player_drink.player_id, PlayerDrinkInfo) of
									 ?FALSE ->
										 [#bonfire_player_drink{player_id = PlayerID, retrieve_param = ReParam, in_map = ?TRUE} | PlayerDrinkInfo];
									 {_, OldInfo, Left} -> [OldInfo#bonfire_player_drink{in_map = ?TRUE} | Left]
								 end,
			etsBaseFunc:insertRecord(?ETS_BonfireBoss, Info#bonfire_boss{player_drink_info = NewPlayerDrinkInfo});
		_ ->
			Info = #bonfire_boss{guild_id = GuildID, player_drink_info = [#bonfire_player_drink{player_id = PlayerID, retrieve_param = ReParam, in_map = ?TRUE}]},
			etsBaseFunc:insertRecord(?ETS_BonfireBoss, Info)
	end,
	Msg = make_camp_msg(PlayerID, GuildID),
	m_send:sendMsgToClient(PlayerID, Msg).

player_exit_map(GuildID, PlayerID) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		#bonfire_boss{player_drink_info = PlayerDrinkInfo} = Info ->
			NewPlayerDrinkInfo = case lists:keytake(PlayerID, #bonfire_player_drink.player_id, PlayerDrinkInfo) of
									 ?FALSE ->
										 ok;
									 {_, OldInfo, Left} -> [OldInfo#bonfire_player_drink{in_map = ?FALSE} | Left]
								 end,
			etsBaseFunc:insertRecord(?ETS_BonfireBoss, Info#bonfire_boss{player_drink_info = NewPlayerDrinkInfo});
		_ -> ok
	end.

init_data(GuildID, PlayerIDList) ->
	Info = #bonfire_boss{guild_id = GuildID, player_drink_info = [#bonfire_player_drink{player_id = PlayerID, in_map = ?TRUE} || PlayerID <- PlayerIDList]},
	etsBaseFunc:insertRecord(?ETS_BonfireBoss, Info).

damage_rank_update(GuildID, RankList) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		#bonfire_boss{} = Info ->
			etsBaseFunc:insertRecord(?ETS_BonfireBoss, Info#bonfire_boss{guild_player_rank_list = RankList});
		_ ->
			Info = #bonfire_boss{guild_id = GuildID, guild_player_rank_list = RankList},
			etsBaseFunc:insertRecord(?ETS_BonfireBoss, Info)
	end.

sync_rank(?TRUE) ->
	Data = etsBaseFunc:getAllRecord(?ETS_BonfireClusterTop),
	GuildRankList = bonfire_boss_logic:get_guild_rank_list(Data),
	GuildTop3List = lists:sublist(GuildRankList, 3),
	Msg = bonfire_boss_logic:make_guild_rank_msg(GuildTop3List),
	AllRank = [{GuildId, R, Damage} || {R, #bonfire_cluster_top{guild_id = GuildId, total_damage = Damage}} <- GuildRankList],
	Msg =/= [] andalso main:sendMsgToMap(?MapAI_GuildCamp, {bonfire_boss_msg, {guild_top_sync, Msg, AllRank}});
sync_rank(_) ->
	ok.

guild_rank_award() ->
	Data = etsBaseFunc:getAllRecord(?ETS_BonfireClusterTop),
	LocalGuildRank = [{R, Info} || {R, #bonfire_cluster_top{server_id = ServerId} = Info} <- bonfire_boss_logic:get_guild_rank_list(Data), config:server_id() =:= ServerId],
	Week = time:day_of_week(time:get_localtime()),
	{GuildIndexList, WorldLvList} = case cfg_dinnerBossBase:getRow(Week) of
										#dinnerBossBaseCfg{guildOrder = GuildOrder, wLOrder = L2} ->
											ClusterStage = cluster:get_stage(),
											L1 = case [{P2, P3, P4} || {P1, P2, P3, P4} <- GuildOrder, P1 =:= ClusterStage] of
													 [] ->
														 ?LOG_ERROR("order is null ~p", [{Week, ClusterStage}]),
														 [];
													 L1_ -> L1_
												 end,
											{L1, L2};
										_ ->
											?LOG_ERROR("no cfg key ~p", [Week]),
											{[], []}
									end,
	WorldLvIndex = common:get_range_index(world_level:get_world_level(), WorldLvList, 1),
	{GuildAuct, PersonAuct, NumberOrder} = case cfg_dinnerBossAuct:getRow(WorldLvIndex, Week) of
											   #dinnerBossAuctCfg{dinnerAuct = L3, dinnerAuctPerson = L4, numberOrder = L5} ->
												   {L3, L4, L5};
											   _ ->
												   ?LOG_ERROR("no award cfg key ~p", [{WorldLvIndex, Week}]),
												   {[], [], []}
										   end,
	lists:foreach(fun({Rank, #bonfire_cluster_top{guild_id = GuildId, total_damage = TotalDamage}}) ->
		RankIndex = common:get_range_index(Rank, GuildIndexList, 5),
		PlayerList = [{PlayerID, PlayerName} || {_, #playerDamageInfo{player_id = PlayerID, player_name = PlayerName}} <- etsBaseFunc:getRecordField(?ETS_BonfireBoss, GuildId, #bonfire_boss.guild_player_rank_list, [])],
		JoinNum = length(PlayerList),
		{_, NumIndex} = common:getValueByInterval(JoinNum, NumberOrder, {0, 0}),
		GuildAward = [{C, D, B, N, P} || {I1, I2, C, D, B, N, P} <- GuildAuct, I1 =:= RankIndex andalso I2 =:= NumIndex],
		PersonAward = [{C, D, B, N, P} || {Index, C, D, B, N, P} <- PersonAuct, Index =:= RankIndex],
		#guild_base{chairmanPlayerID = LeaderId} = guild:get_guild_info(GuildId),
		#player{level = Level, leader_role_id = LeaderRoleId} = mirror_player:get_player(LeaderId),
		Career = mirror_player:get_role_career(LeaderId, LeaderRoleId),
		{ItemList1, EqList1, _CoinList1, _} = drop:drop(GuildAward, [], LeaderId, Career, Level),
		{ItemList2, EqList2, _CoinList2, _} = drop:drop(PersonAward, [], LeaderId, Career, Level),
		main:sendMsgToMapByOwner(?MapAI_GuildCamp, GuildId, {bonfire_boss_msg, {guild_top_settle, {bonfire_boss_logic:un_merge_item(ItemList1), EqList1}, Rank, TotalDamage}}),
		guild_auction:add_auction({GuildId, ?GuildAuctionGuildBonfire, 0, {bonfire_boss_logic:un_merge_item(ItemList1), EqList1}, {bonfire_boss_logic:un_merge_item(ItemList2), EqList2}, PlayerList}),
		[begin
			 grow_attr:update_growth(PlayerID, ?Growth_Type_BonfireBossKill, 1, {}),
			 activity_new_player:on_active_condition_change_ex(PlayerID, ?SalesActivity_GuildBoss, 1),
			 daily_task:add_daily_task_goal(PlayerID, ?DailyTask_Goal_27, 1, ?DailyTask_CountType_Default),
			 guild_player:on_active_value_access_ex(PlayerID, ?DailyTask_Goal_27, 1),
			 seven_gift:add_task_progress(PlayerID, ?Seven_Type_GuildBoss, {1})
		 end || {PlayerID, _} <- PlayerList],
		guild_pub:check_add_treasure_chest(?TreasureChestBonfireBoss, Rank, GuildId)
				  end, LocalGuildRank).

set_is_not_push(Flag) ->
	put({?MODULE, is_not_push}, Flag).

get_is_not_push() ->
	case get({?MODULE, is_not_push}) of
		?UNDEFINED -> ?TRUE;
		F -> F
	end.

player_drink(PlayerId, GuildID, Index) ->
	try
		#guildDinneDrinkCfg{drinkLimit = Limit, personalExp = E1, drinkCost = _Cost, personalBuff = PBuff, wholeBuff = WholeBuff} = cfg_guildDinneDrink:getRow(Index),
		GuildBonfireData = case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
							   {} -> throw(?ErrorCode_Guild_NoGuild);
							   Data -> Data
						   end,
		PlayerDrinkInfoList = GuildBonfireData#bonfire_boss.player_drink_info,
		{DrinkInfo, LeftList} = case lists:keytake(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
									?FALSE ->
										{#bonfire_player_drink{player_id = PlayerId, in_map = ?TRUE}, PlayerDrinkInfoList};
									{_, R, Left} ->
										{R, Left}
								end,
		{DrinkErr, DrinkInfo1} = bonfire_boss_logic:drink_limit_check(Index, DrinkInfo, Limit),
		?ERROR_CHECK_THROW(DrinkErr),
		NewDrinkInfo = DrinkInfo1#bonfire_player_drink{personal_ratio = E1 + DrinkInfo1#bonfire_player_drink.personal_ratio},

		#guildDinneDrinkCfg{wholeExp = E2, wholeExpLimit = EMax, drinkAllawardsPoints = PointList, helpPres = Point} = cfg_guildDinneDrink:getRow(Index),
		{_, P} = common:getValueByInterval(main:getServerStartDays(), PointList, {0, 0}),
		NewGuildBonfireData = GuildBonfireData#bonfire_boss{
			player_drink_info = [NewDrinkInfo | LeftList],
			guild_ratio = min(E2 + GuildBonfireData#bonfire_boss.guild_ratio, EMax),
			treat_point = GuildBonfireData#bonfire_boss.treat_point + P,
			guild_t2 = GuildBonfireData#bonfire_boss.guild_t2 + common:getTernaryValue(Index =:= 2, 1, 0)
		},
		etsBaseFunc:insertRecord(?ETS_BonfireBoss, NewGuildBonfireData),
		%% 增加协助积分
		main:sendMsgToPlayerProcess(PlayerId, {addCurrency, [{?CURRENCY_GuildHelp1, Point}], ?Reason_GCamp_Drink}),
		main:sendMsgToMapByOwner(?MapAI_GuildCamp, GuildID, {bonfire_boss_msg, {drink_success, PlayerId, PBuff, WholeBuff, Index, NewDrinkInfo}}),
		UpdateMsg = [
			#pk_CampInfoUpdate{index = #pk_CampInfo.personal_ratio, value = NewDrinkInfo#bonfire_player_drink.personal_ratio},
			#pk_CampInfoUpdate{index = #pk_CampInfo.t1, value = NewDrinkInfo#bonfire_player_drink.t1},
			#pk_CampInfoUpdate{index = #pk_CampInfo.t2, value = NewDrinkInfo#bonfire_player_drink.t2}
		],
		m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampInfoUpdate{updates = UpdateMsg}),
		UpdateMsg1 = case Index =:= 2 of
						 ?TRUE ->
							 PlayerText = richText:getPlayerTextByID(PlayerId),
							 marquee:sendGuildNotice(0, mapSup:getMapOwnerID(), guildDinner_gonggao03,
								 fun(Language) ->
									 language:format(language:get_server_string("GuildDinner_gonggao03", Language), [PlayerText, NewDrinkInfo#bonfire_player_drink.t2])
								 end),
							 [
								 #pk_CampInfoUpdate{index = #pk_CampInfo.treat_point, value = NewGuildBonfireData#bonfire_boss.treat_point},
								 #pk_CampInfoUpdate{index = #pk_CampInfo.guild_ratio, value = NewGuildBonfireData#bonfire_boss.guild_ratio},
								 #pk_CampInfoUpdate{index = #pk_CampInfo.guild_t2, value = NewGuildBonfireData#bonfire_boss.guild_t2}
							 ];
						 _ ->
							 [
								 #pk_CampInfoUpdate{index = #pk_CampInfo.treat_point, value = NewGuildBonfireData#bonfire_boss.treat_point}
							 ]
					 end,
		main:sendMsgToMapByOwner(?MapAI_GuildCamp, GuildID, {broadcast, #pk_GS2U_GuildCampInfoUpdate{updates = UpdateMsg1}}),
		m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampDrinkRet{type = Index}),
		check_bonfire_lv_up(GuildID, NewGuildBonfireData#bonfire_boss.treat_point, NewGuildBonfireData#bonfire_boss.treat_point + P)
	catch
		ErrCode ->
			m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampDrinkRet{err_code = ErrCode, type = Index})
	end.

check_bonfire_lv_up(GuildID, Old, New) ->
	W = world_level:get_world_level(),
	Cfg = case [G || G = #guildDinnerAwardsCfg{worldLvDown = L1, worldLvUp = L2} <- cfg_guildDinnerAwards:rows(), W >= L1, W =< L2] of
			  [#guildDinnerAwardsCfg{} = C] -> C;
			  _ -> throw(?ERROR_Cfg)
		  end,
	#guildDinnerAwardsCfg{dinnerAllsward = AwardList} = Cfg,
	L = [P || {_, P, _, _, _, _, _} <- AwardList],

	case common:getValueByInterval1(Old, L, 0) =/= common:getValueByInterval1(New, L, 0) of
		?TRUE ->
			marquee:sendGuildNotice(0, GuildID, guildDinner_gonggao03,
				fun(Language) -> language:get_server_string("GuildDinner_gonggao08", Language) end);
		_ -> skip
	end.

player_stage_award(PlayerId, GuildID) ->
	try
		AcStage = bonfire_boss_logic:get_stage(),
		case AcStage =:= ?Bonfire_Drink_Stage orelse AcStage =:= ?Bonfire_Exp_Stage of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_GCamp_OutActiveTime)
		end,
		W = world_level:get_world_level(),
		Cfg = case [G || G = #guildDinnerAwardsCfg{worldLvDown = L1, worldLvUp = L2} <- cfg_guildDinnerAwards:rows(), W >= L1, W =< L2] of
				  [#guildDinnerAwardsCfg{} = C] -> C;
				  _ -> throw(?ERROR_Cfg)
			  end,
		#guildDinnerAwardsCfg{dinnerAllsward = AwardList, drinkNum = N} = Cfg,
		GuildBonfireData = case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
							   {} -> throw(?ErrorCode_Guild_NoGuild);
							   Data -> Data
						   end,
		PlayerDrinkInfoList = GuildBonfireData#bonfire_boss.player_drink_info,
		{DrinkInfo, LeftList} = case lists:keytake(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
									?FALSE ->
										{#bonfire_player_drink{player_id = PlayerId, in_map = ?TRUE}, PlayerDrinkInfoList};
									{_, R, Left} ->
										{R, Left}
								end,
		#bonfire_player_drink{award_mask = Mask, t2 = T2} = DrinkInfo,

		case T2 >= N of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_GCamp_StageAwardErr)
		end,

		{AwardItemList, StageList} = lists:foldl(fun({Stage, CfgPoint, _, Tp, ItemId, Bind, ItemNum}, {R1, R2}) ->
			case (Mask bsr Stage) band 1 =:= 0 andalso GuildBonfireData#bonfire_boss.treat_point >= CfgPoint of
				?TRUE -> {[{Tp, ItemId, Bind, ItemNum} | R1], [Stage | R2]};
				?FALSE -> {R1, R2}
			end
												 end, {[], []}, AwardList),

		AddItemList = [{T, N1, B} || {1, T, B, N1} <- AwardItemList],
		AddCoinList = [{T, N1} || {2, T, _, N1} <- AwardItemList],
		mail:send_mail(#mailInfo{
			player_id = PlayerId,
			coinList = [#coinInfo{type = T, num = N1, multiple = 1, reason = ?Reason_GCamp_StageAward} || {T, N1} <- AddCoinList],
			itemList = [#itemInfo{itemID = I, num = N1, isBind = B} || {I, N1, B} <- AddItemList],
			attachmentReason = ?Reason_GCamp_StageAward,
			isDirect = 1
		}),
		NewMask = lists:foldl(fun(Stage, Ret) -> Ret bor (1 bsl Stage) end, Mask, StageList),
		NewDrinkInfo = DrinkInfo#bonfire_player_drink{award_mask = NewMask},

		bonfire_boss_update_elem(GuildID, [{#bonfire_boss.player_drink_info, [NewDrinkInfo | LeftList]}]),
		UpdateMsg = [
			#pk_CampInfoUpdate{index = #pk_CampInfo.award_mask, value = NewDrinkInfo#bonfire_player_drink.award_mask}
		],
		player_item:show_get_item_dialog(PlayerId, AddItemList, AddCoinList, [], 0, 5),
		m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampInfoUpdate{updates = UpdateMsg}),
		m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampGetSatgeAwardRet{err_code = ?ERROR_OK})
	catch
		ErrCode ->
			m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampGetSatgeAwardRet{err_code = ErrCode})
	end.


%% 奖励心跳
award_tick(?TRUE) ->
	NewList = ets:foldl(
		fun(GuildData, Acc) ->
			{GuildData1, Times} = personal_tick_award(GuildData),
			GuildData2 = tick_guild_money(GuildData1, Times),
			[GuildData2 | Acc]
		end, [], ?ETS_BonfireBoss),
	etsBaseFunc:insertRecord(?ETS_BonfireBoss, NewList);
award_tick(_) ->
	ok.

personal_tick_award(GuildData) ->
	GuildRatio = GuildData#bonfire_boss.guild_ratio,
	{NewPlayerDrinkInfo, DrinkTimes} = lists:foldl(
		fun
			(#bonfire_player_drink{player_id = PlayerId, personal_ratio = Ratio, exp = E1, retrieve_param = {P1, P2}, in_map = ?TRUE} = Info, {Ret, Times}) ->
				Level = mirror_player:get_player_level(PlayerId),
				BaseExp = get_base_exp(Level),
				W = (1 + (GuildRatio + Ratio) / 10000) * (1 + P1 * P2),
				Exp = trunc(BaseExp * W),
				main:sendMsgToPlayerProcess(PlayerId, {addPlayerExp, Exp, ?Reason_Bonfire_Tick, ?AddExpType_4, trunc(W * 100)}),
				m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampInfoExpUpdate{exp = Exp + E1}),
				{[Info#bonfire_player_drink{exp = Exp + E1} | Ret], Times + 1};
			(Info, {Ret, Times}) ->
				{[Info | Ret], Times}
		end,
		{[], 0}, GuildData#bonfire_boss.player_drink_info),
	{GuildData#bonfire_boss{player_drink_info = NewPlayerDrinkInfo}, DrinkTimes}.

tick_guild_money(GuildData, 0) -> GuildData;
tick_guild_money(GuildData, Times) ->
	case guild_pub:get_building_level(GuildData#bonfire_boss.guild_id, ?GuildBuilding_McShip) of
		Lv when Lv > 0 ->
			case cfg_guildBuilding:getRow(?GuildBuilding_McShip, Lv) of
				#guildBuildingCfg{guildDinnerExpsward = M} ->
					case M * Times > 0 of
						?TRUE ->
							guild:send_2_me({changeGuildMaterials, GuildData#bonfire_boss.guild_id, M * Times}),
							NewBonfire = GuildData#bonfire_boss{guild_materials = GuildData#bonfire_boss.guild_materials + M * Times},
							UpdateMsg1 = [
								#pk_CampInfoUpdate{index = #pk_CampInfo.guild_money, value = NewBonfire#bonfire_boss.guild_materials}
							],
							main:sendMsgToMapByOwner(?MapAI_GuildCamp, GuildData#bonfire_boss.guild_id, {broadcast, #pk_GS2U_GuildCampInfoUpdate{updates = UpdateMsg1}}),
							marquee:sendToMapAiNoticeByOwner(?MapAI_GuildCamp, GuildData#bonfire_boss.guild_id, guildDinner_gonggao06,
								fun(Language) ->
									language:format(language:get_server_string("GuildDinner_gonggao06", Language), [M * Times])
								end),
							NewBonfire;
						_ -> GuildData
					end;
				_ -> GuildData
			end;
		_ -> GuildData
	end.

get_base_exp(Lv) ->
	case cfg_expDistribution:getRow(Lv) of
		{} ->
			#expDistributionCfg{guildDinnerExp = Exp} = cfg_expDistribution:last_row(),
			Exp;
		#expDistributionCfg{guildDinnerExp = Exp} -> Exp
	end.

add_red_money(PlayerId, GuildID, Money) ->
	PlayerDrinkInfoList = bonfire_boss_logic:get_guild_drink_info(GuildID),
	{DrinkInfo, LeftList} = case lists:keytake(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
								?FALSE ->
									{#bonfire_player_drink{player_id = PlayerId, in_map = ?TRUE}, PlayerDrinkInfoList};
								{_, R, Left} ->
									{R, Left}
							end,
	NewMoney = DrinkInfo#bonfire_player_drink.coin + Money,
	bonfire_boss_update_elem(GuildID, [{#bonfire_boss.player_drink_info, [DrinkInfo#bonfire_player_drink{coin = NewMoney} | LeftList]}]),
	UpdateMsg = [
		#pk_CampInfoUpdate{index = #pk_CampInfo.coin, value = NewMoney}
	],
	m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampInfoUpdate{updates = UpdateMsg}),
	ok.


%% 结算的时候没有领取阶段奖励的发邮件给他
do_ret_stage_award() ->
	ets:foldl(fun(#bonfire_boss{player_drink_info = PlayerDrinkInfoList, treat_point = TreatPoint}, _Ret) ->
		W = world_level:get_world_level(),
		Cfg = case [G || G = #guildDinnerAwardsCfg{worldLvDown = L1, worldLvUp = L2} <- cfg_guildDinnerAwards:rows(), W >= L1, W =< L2] of
				  [#guildDinnerAwardsCfg{} = C] -> C;
				  _ -> throw(?ERROR_Cfg)
			  end,
		#guildDinnerAwardsCfg{dinnerAllsward = AwardList, drinkNum = N} = Cfg,
		%% 结算时给参与过的玩家增加篝火参与次数
		add_join_times(PlayerDrinkInfoList),
		do_ret_stage_award_1(PlayerDrinkInfoList, {TreatPoint, AwardList, N})
			  end, ok, ?ETS_BonfireBoss).

%% 增加玩法条件达成次数
add_join_times(PlayerList) ->
	PlayerIdList = [P#bonfire_player_drink.player_id || P <- PlayerList],
	F = fun(PlayerId) -> activity_new_player:on_active_condition_change_ex(PlayerId, ?SalesActivity_CampFire1, 1) end,
	lists:foreach(F, PlayerIdList).

do_ret_stage_award_1([], _) -> skip;
do_ret_stage_award_1([#bonfire_player_drink{t2 = T2, award_mask = Mask, player_id = PlayerId} | Tail], {TreatPoint, AwardList, DrinkNum}) when T2 >= DrinkNum ->
	Award = [{P1, P2, P3, P4} || {Stage, CfgPoint, _, P1, P2, P3, P4} <- AwardList, (Mask bsr Stage) band 2#1 =:= 2#0, TreatPoint >= CfgPoint],
	case Award of
		[] -> skip;
		_ ->
			AddItemList = [{T, Bind, N1} || {1, T, Bind, N1} <- Award],
			AddCoinList = [{T, N1} || {2, T, _, N1} <- Award],
			Language = language:get_player_language(PlayerId),
			mail:send_mail(#mailInfo{
				player_id = PlayerId,
				title = language:get_server_string("GuildDinner_AllReward1", Language),
				describe = language:get_server_string("GuildDinner_AllReward2", Language),
				coinList = [#coinInfo{type = T, num = N1, multiple = 1, reason = ?Reason_GCamp_StageAward} || {T, N1} <- AddCoinList],
				itemList = [#itemInfo{itemID = CfgId, isBind = Bind, num = Amount} || {CfgId, Bind, Amount} <- AddItemList],
				attachmentReason = ?Reason_GCamp_StageAward,  %% 奖励的原因
				isDirect = 0
			})
	end,

	do_ret_stage_award_1(Tail, {TreatPoint, AwardList, DrinkNum});
do_ret_stage_award_1([#bonfire_player_drink{} | T], {TreatPoint, AwardList, DrinkNum}) ->
	do_ret_stage_award_1(T, {TreatPoint, AwardList, DrinkNum}).

gm_reset_drink(PlayerId, GuildID) ->
	PlayerDrinkInfoList = bonfire_boss_logic:get_guild_drink_info(GuildID),
	{DrinkInfo, LeftList} = case lists:keytake(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
								?FALSE ->
									{#bonfire_player_drink{player_id = PlayerId, in_map = ?TRUE}, PlayerDrinkInfoList};
								{_, R, Left} ->
									{R, Left}
							end,
	NewDrinkInfo = DrinkInfo#bonfire_player_drink{t1 = 0, t2 = 0},
	bonfire_boss_update_elem(GuildID, [{#bonfire_boss.player_drink_info, [NewDrinkInfo | LeftList]}]),
	UpdateMsg = [
		#pk_CampInfoUpdate{index = #pk_CampInfo.t1, value = NewDrinkInfo#bonfire_player_drink.t1},
		#pk_CampInfoUpdate{index = #pk_CampInfo.t2, value = NewDrinkInfo#bonfire_player_drink.t2}
	],
	m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildCampInfoUpdate{updates = UpdateMsg}).


make_camp_msg(PlayerId, GuildID) ->
	#bonfire_data{open_time = OpenTime, boss_time = BossTime, close_time = CloseTime} = bonfire_boss_logic:get_bonfire_boss_data(),
	Now = time:time(),
	case Now >= OpenTime andalso Now =< CloseTime andalso etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
		#bonfire_boss{player_drink_info = PlayerDrinkInfoList} = BonfireGuildData ->
			DrinkInfo = case lists:keyfind(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
							?FALSE -> #bonfire_player_drink{player_id = PlayerId};
							R ->
								R
						end,
			CampInfo = #pk_CampInfo{
				guild_ratio = BonfireGuildData#bonfire_boss.guild_ratio,
				personal_ratio = DrinkInfo#bonfire_player_drink.personal_ratio,
				exp = DrinkInfo#bonfire_player_drink.exp,
				coin = DrinkInfo#bonfire_player_drink.coin,
				treat_point = BonfireGuildData#bonfire_boss.treat_point,
				t1 = DrinkInfo#bonfire_player_drink.t1,
				t2 = DrinkInfo#bonfire_player_drink.t2,
				award_mask = DrinkInfo#bonfire_player_drink.award_mask,
				guild_money = BonfireGuildData#bonfire_boss.guild_materials,
				guild_t2 = BonfireGuildData#bonfire_boss.guild_t2,
				double_times = element(1, DrinkInfo#bonfire_player_drink.retrieve_param)
			},
			#pk_GS2U_GuildCampInfoSync{
				start_timestamp = OpenTime,
				boss_timestamp = BossTime,
				end_timestamp = CloseTime,
				info = [CampInfo]
			};
		_ ->
			#pk_GS2U_GuildCampInfoSync{start_timestamp = OpenTime, boss_timestamp = BossTime, end_timestamp = CloseTime}
	end.
