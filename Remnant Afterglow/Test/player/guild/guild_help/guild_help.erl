%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%     战盟协助
%%% @end
%%% Created : 25. 4月 2020 13:50
%%%-------------------------------------------------------------------
-module(guild_help).
-author("suw").
-behaviour(gen_server).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("logger.hrl").
-include("guild_help.hrl").
-include("record.hrl").
-include("id_generator.hrl").
-include("error.hrl").
-include("netmsgRecords.hrl").
-include("db_table.hrl").
-include("guild.hrl").
-include("mc_ship.hrl").
-include("player_task_define.hrl").
-include("activity_new.hrl").
-include("daily_task_goal.hrl").
-include("dragon_god_trail.hrl").
-include("attainment.hrl").

-define(SERVER, ?MODULE).


%%%====================================================================
%%% API functions
%%%====================================================================
-export([start_link/0]).
-export([send_2_me/1]).

start_link() ->
	gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

send_2_me(Msg) -> gen_server:cast(?SERVER, Msg).
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
	%% 打宝类协助
	ets:new(?ETS_GuildHelpRelation, [set, protected, named_table, {keypos, #guild_help_relation.helper_id}, ?ETSRC, ?ETSWC]), %% 协助关系表
	ets:new(?ETS_GuildHelpRequest, [set, protected, named_table, {keypos, #guild_help_request.help_seeker_id}, ?ETSRC, ?ETSWC]), %% 协助请求表

	%% 通用类协助
	ets:new(?ETS_GuildHelpRelationCommon, [set, protected, named_table, {keypos, #guild_help_relation_common.helper_id}, ?ETSRC, ?ETSWC]), %% 协助关系表
	ets:new(?ETS_GuildHelpRequestCommon, [set, protected, named_table, {keypos, #guild_help_request_common.help_id}, ?ETSRC, ?ETSWC]), %% 协助请求表
	#state{}.

%% 返回{Reply, NewState}
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState
%% 添加新的协助请求
do_cast({add_new_help_req, PlayerID, GuildID, MapDataID, MapAi, MonsterID, MonsterDataID, BornX, BornY, Level, FromPid}, State) ->
	add_new_req(PlayerID, GuildID, MapDataID, MapAi, MonsterID, MonsterDataID, BornX, BornY, Level, FromPid),
	State;
do_cast({player_req_help_common, PlayerID, GuildID, OpenActionID, ParamTuple}, State) ->
	add_new_req_common(PlayerID, GuildID, OpenActionID, ParamTuple),
	State;
%% 接受协助
do_cast({accept_help, ID, PlayerID}, State) ->
	accept_help(ID, PlayerID),
	State;
do_cast({accept_help_common, ID, PlayerID}, State) ->
	accept_help_common(ID, PlayerID),
	State;
%% 完成协助
do_cast({helper_award, HelpSeeker, List}, State) ->
	help_award(HelpSeeker, List),
	State;
%% 求助者取消
do_cast({cancel_request, PlayerID}, State) ->
	on_cancel_req(PlayerID),
	State;
%% 协助者中断
do_cast({interrupt_request, PlayerID}, State) ->
	on_interrupt_request(PlayerID),
	State;
%% BOSS死亡 取消协助
do_cast({monster_dead_cancel_request, PlayerID}, State) ->
	on_monster_dead_cancel_req(PlayerID),
	State;
do_cast({daily_reset, TimeStamp}, State) ->
	check_expired_msg(TimeStamp),
	State;
do_cast({help_common_finish, OpenAction, Params}, State) ->
	help_common_finish(OpenAction, Params),
	State;
do_cast({break_help_common_relation, PlayerID}, State) ->
	etsBaseFunc:deleteRecord(?ETS_GuildHelpRelationCommon, PlayerID),
	main:sendMsgToPlayerProcess(PlayerID, {guild_help_player_target_map_ai_common, ?UNDEFINED}),
	?LOG_INFO("player break common relation : ~p", [PlayerID]),
	State;
do_cast({cancel_help_common, ID}, State) ->
	cancel_help_common(ID),
	State;
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

do_terminate(_Reason, _State) ->
	ok.

add_new_req(_, 0, _, _, _, _, _, _, _, _) -> ok;
add_new_req(PlayerID, GuildID, MapDataID, MapAi, MonsterID, MonsterDataID, BornX, BornY, Level, FromPid) ->
	try
		?CHECK_THROW(not team_lib:is_have_team(PlayerID), ?ErrorCode_Guild_Help_In_Team),
		Req = make_new_req(PlayerID, GuildID, MapDataID, MapAi, MonsterID, MonsterDataID, BornX, BornY, Level),
		etsBaseFunc:insertRecord(?ETS_GuildHelpRequest, Req),
		main:sendMsgToPlayerProcess(PlayerID, {guild_help_player_target_map_ai, MapAi}),
		FromPid ! {guild_help_msg, {player_req_help_success, PlayerID, MonsterDataID, self()}},
		%% 协助请求不发给自己
		Msg = #pk_GS2U_receiveNewHelpReq{help_id = PlayerID, map_data_id = MapDataID},
		[m_send:sendMsgToClient(MemberId, Msg) || MemberId <- guild_pub:get_guild_member_id_list(GuildID), MemberId =/= PlayerID],
		m_send:sendMsgToClient(PlayerID, [#pk_GS2U_requestHelpRet{err = ?ERROR_OK}, #pk_GS2U_helpState{state = 2}]),
		?LOG_INFO("player seeker help , msg ~p ", [{PlayerID, GuildID, MapDataID, MapAi, MonsterID, MonsterDataID, BornX, BornY, Level}]),
		table_log:insert_row(log_guild_help_request, [PlayerID, MapDataID, MonsterDataID, MonsterID, mirror_player:get_player_level(PlayerID), mirror_player:get_player_battle_value(PlayerID), time:time()])
	catch
		Err -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_requestHelpRet{err = Err})
	end.
add_new_req_common(_, 0, _, _) -> ok;
add_new_req_common(PlayerID, GuildID, OpenActionID, Param) ->
	Req = make_new_req_common(PlayerID, GuildID, OpenActionID, Param),
	etsBaseFunc:insertRecord(?ETS_GuildHelpRequestCommon, Req),
	Msg = #pk_GS2U_receiveNewHelpReq{help_id = Req#guild_help_request_common.help_id, open_aciton_id = OpenActionID},
	[m_send:sendMsgToClient(MemberId, Msg) || MemberId <- guild_pub:get_guild_member_id_list(GuildID), MemberId =/= PlayerID],
	?LOG_INFO("player seeker help common, msg ~p ", [{PlayerID, GuildID, OpenActionID, Param}]).

accept_help(ID, PlayerID) ->
	try
		?CHECK_THROW(not team_lib:is_have_team(PlayerID), ?ErrorCode_Guild_Help_In_Team),
		?CHECK_THROW(not guild_help_logic:is_in_help(PlayerID), ?ErrorCode_Guild_Help_Already_Help),
		?CHECK_THROW(not guild_help_logic:is_in_help_req(PlayerID), ?ErrorCode_Guild_Help_Already_Help_Req),
		case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, ID) of
			#guild_help_request{help_seeker_id = HelpSeekerID, monster_id = MonsterID, monster_data_id = MonsterDataID, map_data_id = MapDataID, map_ai = MapAI} ->
				Info = make_new_accept(PlayerID, HelpSeekerID, MonsterID, MonsterDataID, MapDataID, MapAI),
				etsBaseFunc:insertRecord(?ETS_GuildHelpRelation, Info),
				main:sendMsgToPlayerProcess(PlayerID, {send_msg_2_map, {guild_help_msg, {player_accept_help, HelpSeekerID, MapDataID, MonsterDataID}}}),
				main:sendMsgToPlayerProcess(PlayerID, {guild_help_player_target_map_ai, MapAI}),
				table_log:insert_row(log_guild_help_accept,
					[PlayerID, mirror_player:get_player_level(PlayerID), mirror_player:get_player_battle_value(PlayerID),
						HelpSeekerID, mirror_player:get_player_level(HelpSeekerID), mirror_player:get_player_battle_value(HelpSeekerID),
						MapDataID, MonsterDataID, MonsterID, time:time()]);
			_ ->
				throw(?ErrorCode_Guild_Help_No_Exist)
		end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_respondHelpRet{err = ?ERROR_OK}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_helpState{state = 1}),
		?LOG_INFO("player accept help , player id ~p , seeker id ~p", [PlayerID, ID])
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_respondHelpRet{err = Err})
	end.

accept_help_common(ID, PlayerID) ->
	try
		case etsBaseFunc:readRecord(?ETS_GuildHelpRequestCommon, ID) of
			#guild_help_request_common{help_seeker_id = HelpSeekerID, open_action_id = OpenAction, param = Param} ->
				Info = make_new_accept_common(PlayerID, HelpSeekerID, OpenAction, Param),
				etsBaseFunc:insertRecord(?ETS_GuildHelpRelationCommon, Info);
			_ ->
				throw(?ErrorCode_Guild_Help_No_Exist)
		end,
		main:sendMsgToPlayerProcess(PlayerID, {accept_help_common_ok}),
		?LOG_INFO("player accept help , player id ~p , seeker id ~p", [PlayerID, ID])
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_respondHelpRet{err = Err})
	end.

help_award(PlayerID, List) ->
	case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
		#guild_help_request{monster_data_id = MonsterDataID, map_data_id = MapDataID, monster_level = Level} ->
			%% 通知给协助者发放奖励
			PlayerIDList = [ID || {ID, Damage} <- List, Damage > 0],
			[m_send:send_msg_2_player_proc(ID, {help_success, PlayerID, MapDataID, MonsterDataID, Level, 1}) || ID <- PlayerIDList],
			PlayerIDList =/= [] andalso m_send:send_msg_2_player_proc(PlayerID, {help_finish, PlayerIDList, 1}),
			SeekerName = richText:getPlayerTextByID(PlayerID),
			SeekerGuildID = mirror_player:get_player_element(PlayerID, #player.guildID),
			[marquee:sendGuildNotice(0, SeekerGuildID, assistanceSystem04, fun(Language) ->
				language:format(language:get_server_string("AssistanceSystem04", Language), [richText:getPlayerTextByID(HelperID), SeekerName, richText:getMonsterText(MonsterDataID, Language)]) end) || HelperID <- PlayerIDList];
		_ ->
			?LOG_ERROR("no find data , player id :~p", [PlayerID]),
			ok
	end.

%% 求助者取消请求
on_cancel_req(PlayerID) ->
	case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
		#guild_help_request{help_guild_id = GuildID} ->
			%% 删除请求
			etsBaseFunc:deleteRecord(?ETS_GuildHelpRequest, PlayerID),
			Msg = #pk_GS2U_clearNewHelpReq{help_id = PlayerID},
			[m_send:sendMsgToClient(MemberId, Msg) || MemberId <- guild_pub:get_guild_member_id_list(GuildID)];
		_ ->
			ok
	end,
	%% 删除关系
	Q = ets:fun2ms(fun(#guild_help_relation{helper_id = HelperID, help_seeker_id = HelpSeekerID}) when PlayerID =:= HelpSeekerID ->
		HelperID end),
	IDList = ets:select(?ETS_GuildHelpRelation, Q),
	lists:foreach(fun(Id) -> ets:delete(?ETS_GuildHelpRelation, Id) end, IDList),
	HelpSeekerName = richText:getPlayerTextByID(PlayerID),
	[begin
		 m_send:sendMsgToClient(ID, #pk_GS2U_helpState{state = 0, name = HelpSeekerName}),
		 main:sendMsgToPlayerProcess(ID, {guild_help_player_target_map_ai, ?UNDEFINED})
	 end || ID <- [PlayerID | IDList]],
	?LOG_INFO("player cancal help req , player id : ~p , helper list ~p", [PlayerID, IDList]).

%% boss死亡取消协助
on_monster_dead_cancel_req(PlayerID) ->
	case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
		#guild_help_request{help_guild_id = GuildID} ->
			%% 删除请求
			etsBaseFunc:deleteRecord(?ETS_GuildHelpRequest, PlayerID),
			Msg = #pk_GS2U_clearNewHelpReq{help_id = PlayerID},
			[m_send:sendMsgToClient(MemberId, Msg) || MemberId <- guild_pub:get_guild_member_id_list(GuildID)];
		_ ->
			ok
	end,
	%% 删除关系
	Q = ets:fun2ms(fun(#guild_help_relation{helper_id = HelperID, help_seeker_id = HelpSeekerID}) when PlayerID =:= HelpSeekerID ->
		HelperID end),
	IDList = ets:select(?ETS_GuildHelpRelation, Q),
	lists:foreach(fun(Id) -> ets:delete(?ETS_GuildHelpRelation, Id) end, IDList),
	[begin
		 m_send:sendMsgToClient(ID, #pk_GS2U_helpState{state = 0}),
		 main:sendMsgToPlayerProcess(ID, {guild_help_player_target_map_ai, ?UNDEFINED})
	 end || ID <- [PlayerID | IDList]],
	?LOG_INFO("monster dead cancal help req , player id : ~p , helper list ~p", [PlayerID, IDList]).

%% 协助者中断接受的请求
on_interrupt_request(PlayerID) ->
	%% 删除关系
	etsBaseFunc:deleteRecord(?ETS_GuildHelpRelation, PlayerID),
	m_send:sendMsgToClient(PlayerID, #pk_GS2U_helpState{state = 0}),
	main:sendMsgToPlayerProcess(PlayerID, {guild_help_player_target_map_ai, ?UNDEFINED}),
	?LOG_INFO("player interrupt req : ~p", [PlayerID]).

check_expired_msg(TimeStamp) ->
	Q2 = ets:fun2ms(fun(#guild_help_request_common{time = Time}) when TimeStamp >= Time -> ?TRUE end),
	ets:select_delete(?ETS_GuildHelpRequestCommon, Q2).

help_common_finish(?OpenAction_Merchant_Ship, {HelpSeekerID, AtkPlayerID, DefPlayerID, ShipID, _ShipType, Index, Reward} = Params) ->
	%% 删除关系
	etsBaseFunc:deleteRecord(?ETS_GuildHelpRelationCommon, AtkPlayerID),
	main:sendMsgToPlayerProcess(AtkPlayerID, {guild_help_player_target_map_ai_common, ?UNDEFINED}),
	case etsBaseFunc:readRecord(?ETS_GuildHelpRequestCommon, ShipID) of
		#guild_help_request_common{suc_helper_list = OldSucList, help_guild_id = GuildID} = Info ->
			%% 删除请求
			IsDel = case table_player:lookup(?TableMcShipForay, HelpSeekerID, [ShipID]) of
						[#mc_ship_foray{state = 1} | _] -> ?TRUE;
						[] -> ?TRUE;
						_ -> ?FALSE
					end,
			case IsDel of
				?TRUE ->
					etsBaseFunc:deleteRecord(?ETS_GuildHelpRequestCommon, ShipID),
					CancelMsg = #pk_GS2U_clearNewHelpReq{help_id = ShipID},
					[m_send:sendMsgToClient(MemberId, CancelMsg) || MemberId <- guild_pub:get_guild_member_id_list(GuildID)];
				_ ->
					etsBaseFunc:insertRecord(?ETS_GuildHelpRequestCommon, Info#guild_help_request_common{suc_helper_list = [AtkPlayerID | OldSucList]})
			end,
			%% 储存消息
			case Reward =/= [] of
				?TRUE ->
					Msg = guild_help_logic:make_new_help_msg_common(HelpSeekerID, ?OpenAction_Merchant_Ship, Params),
					table_player:insert(?TableHelpMsg, Msg),
					%% 通知求助者
					main:sendMsgToPlayerProcess(HelpSeekerID, {sync_ship_success_msg});
				_ ->
					ok
			end,
			%% 通知求助者
			main:sendMsgToPlayerProcess(HelpSeekerID, {sync_ship_success_msg}),
			case case Index of
					 1 -> {"D2X_Shangchuan_Notice1", d2X_Shangchuan_Notice1};
					 2 -> {"D2X_Shangchuan_Notice2", d2X_Shangchuan_Notice2};
					 3 -> {"D2X_Shangchuan_Notice3", d2X_Shangchuan_Notice3};
					 _ -> {}
				 end of
				{TextID, NoticeID} ->
					{ItemList, CurrencyList} = player_item:categorise_award(Reward),
					Name1 = richText:getPlayerTextByID(AtkPlayerID),
					Name2 = richText:getPlayerTextByID(DefPlayerID),
					Name3 = richText:getPlayerTextByID(HelpSeekerID),
					marquee:sendGuildNotice(0, guild_pub:get_player_guild_id(HelpSeekerID), NoticeID,
						fun(Language) ->
							RewardText = richText:getRewardText(ItemList, CurrencyList, Language),
							language:format(language:get_server_string(TextID, Language), [Name1, Name2, Name3, RewardText])
						end);
				_ -> ok
			end;
		_ -> ok
	end,
	%% 协助者发奖励
	player_task:update_task(AtkPlayerID, [?Task_Goal_helpMcShop, ?Task_Goal_HelpCount], {1}),
	activity_new_player:on_active_condition_change_ex(AtkPlayerID, ?SalesActivity_HelpCount_176, 1),
	daily_task:add_daily_task_goal(AtkPlayerID, ?DailyTask_Goal_66, 1, ?DailyTask_CountType_Default),
	guild_player:on_active_value_access_ex(AtkPlayerID, ?DailyTask_Goal_66, 1),
	dragon_god_trail:task_event(AtkPlayerID, ?DragonGodTrail_6, 1),
	attainment:add_attain_progress(AtkPlayerID, ?Attainments_Type_AssistKillCount, {1}),
	main:sendMsgToPlayerProcess(AtkPlayerID, {help_common_finish_award, ?OpenAction_Merchant_Ship});

help_common_finish(OpenAction, Prams) ->
	?LOG_ERROR("not handle msg , openaction ~p , params ~p", [OpenAction, Prams]).

make_new_req(PlayerID, GuildID, MapDataID, MapAi, MonsterID, MonsterDataID, BornX, BornY, Level) ->
	#guild_help_request{
		help_seeker_id = PlayerID,
		help_guild_id = GuildID,
		map_ai = MapAi,
		map_data_id = MapDataID,
		monster_id = MonsterID,
		monster_data_id = MonsterDataID,
		monster_level = Level,
		x = BornX,
		y = BornY,
		time = time:time()
	}.

make_new_req_common(PlayerID, GuildID, OpenAction, {_, ShipID} = Param) ->
	#guild_help_request_common{
		help_seeker_id = PlayerID,
		help_guild_id = GuildID,
		help_id = ShipID,
		open_action_id = OpenAction,
		param = Param,
		time = time:daytime_add(time:time(), cfg_globalSetup:dshipAssist() * ?SECONDS_PER_DAY - 1)
	}.

make_new_accept(PlayerID, HelpSeekerID, MonsterID, MonsterDataID, MapDataID, MapAI) ->
	#guild_help_relation{
		helper_id = PlayerID,           %% 协助者id
		help_seeker_id = HelpSeekerID,      %% 求助者id
		map_ai = MapAI,
		map_data_id = MapDataID,         %% 地图id
		monster_data_id = MonsterDataID,
		monster_id = MonsterID      %% 怪物id
	}.

make_new_accept_common(PlayerID, HelpSeekerID, OpenAction, Param) ->
	#guild_help_relation_common{
		helper_id = PlayerID,
		help_seeker_id = HelpSeekerID,
		open_action_id = OpenAction,
		param = Param
	}.

cancel_help_common(ID) ->
	case etsBaseFunc:readRecord(?ETS_GuildHelpRequestCommon, ID) of
		#guild_help_request_common{help_guild_id = GuildID} ->
			etsBaseFunc:deleteRecord(?ETS_GuildHelpRequestCommon, ID),
			Msg = #pk_GS2U_clearNewHelpReq{help_id = ID},
			[m_send:sendMsgToClient(MemberId, Msg) || MemberId <- guild_pub:get_guild_member_id_list(GuildID)];
		_ -> ok
	end.
