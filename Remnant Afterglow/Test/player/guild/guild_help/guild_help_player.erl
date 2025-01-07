%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 25. 4月 2020 13:50
%%%-------------------------------------------------------------------
-module(guild_help_player).
-author("suw").

-include("error.hrl").
-include("logger.hrl").
-include("cfg_mapsetting.hrl").
-include("guild_help.hrl").
-include("record.hrl").
-include("item.hrl").
-include("reason.hrl").
-include("cfg_guildHelpPres.hrl").
-include("cfg_mapsetting.hrl").
-include("cfg_guildHelpBase.hrl").
-include("variable.hrl").
-include("guild.hrl").
-include("currency.hrl").
-include("id_generator.hrl").
-include("db_table.hrl").
-include("cfg_guildHelpAward.hrl").
-include("netmsgRecords.hrl").
-include("mc_ship.hrl").
-include("daily_task_goal.hrl").
-include("player_task_define.hrl").
-include("activity_new.hrl").
-include("dragon_god_trail.hrl").
-include("attainment.hrl").

%% API
%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_seek_help/2, on_accept_help/1, on_help_success/5, on_help_finish/2, on_use_box/1, on_read_tks_msg/1,
	on_cancel_help/0, on_interrupt_help/0, on_player_online/0, on_sync_tks_msg/0, on_req_help_info/0, on_req_msg_info/1,
	on_req_box_content/0, on_get_help_damage_rank/0, on_player_enter_area/4, on_player_exit_area/4, on_disconnect/0,
	on_add_help_score/2, on_set_target_map_ai/1, on_check_map_ai_change/1, on_accept_help_common_ok/0, on_helper_common_finish_award/1,
	on_seek_help_common/3, on_accept_help_common/1, on_read_help_msg_common/2, on_sync_ship_success_msg/0,
	on_set_target_map_ai_common/1, on_check_map_ai_change_common/1, on_reset/0]).

on_player_online() ->
	?metrics(begin
	%% 上线推送状态给前端
				 player:send(#pk_GS2U_helpState{state = 0}),
				 sync_red_point(),
				 on_sync_tks_msg(),
				 on_sync_ship_success_msg()
			 end).

on_reset() ->
	PlayerID = player:getPlayerID(),
	Now = time:time(),
	IDList = [I || #db_help_thanks_msg{id = I, expire_time = E} <- table_player:lookup(?TableThanksMsg, PlayerID), Now >= E],
	table_player:delete(?TableThanksMsg, PlayerID, IDList).

%% 同步感谢消息
on_sync_tks_msg() ->
	PlayerID = player:getPlayerID(),
	IDList = [I || #db_help_thanks_msg{id = I} <- table_player:lookup(?TableThanksMsg, PlayerID)],
	player:send(#pk_GS2U_receiveTksMsg{id_list = IDList}).

%% 下线取消协助
on_disconnect() ->
	?metrics(begin
				 PlayerID = player:getPlayerID(),
				 case etsBaseFunc:readRecord(?ETS_GuildHelpRelation, PlayerID) of
					 #guild_help_relation{help_seeker_id = SeekerID, monster_data_id = MonsterDataID1} ->
						 guild_help:send_2_me({interrupt_request, PlayerID}),
						 send_msg_2_map({help_interrupt, SeekerID, MonsterDataID1});
					 _ ->
						 skip
				 end,
				 case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
					 #guild_help_request{monster_data_id = MonsterDataID2} ->
						 Q2 = ets:fun2ms(fun(#guild_help_relation{help_seeker_id = HelpSeekerID, helper_id = HelperID}) when PlayerID =:= HelpSeekerID ->
							 HelperID end),
						 HelperIDList = lists:usort(ets:select(?ETS_GuildHelpRelation, Q2)),
						 guild_help:send_2_me({cancel_request, PlayerID}),
						 send_msg_2_map({help_cancel, HelperIDList, MonsterDataID2});
					 _ ->
						 skip
				 end,
				 case etsBaseFunc:readRecord(?ETS_GuildHelpRelationCommon, PlayerID) of
					 #guild_help_relation_common{} ->
						 guild_help:send_2_me({break_help_common_relation, PlayerID});
					 _ ->
						 skip
				 end
			 end).

%% 进入boss区域
%% 1-pantheon 2-holy_war 3-demons
on_player_enter_area(GamePlay, MapDataID, BossID, Type) ->
	?metrics(begin
				 PlayerID = player:getPlayerID(),
				 IsHelp = guild_help_logic:is_in_help_monster_area(PlayerID, MapDataID, BossID),
				 player_enter_area_1(GamePlay, MapDataID, BossID, Type, IsHelp)
			 end).

on_player_exit_area(GamePlay, MapDataID, BossID, Type) ->
	?metrics(begin
				 PlayerID = player:getPlayerID(),
				 IsHelp = guild_help_logic:is_in_help_monster_area(PlayerID, MapDataID, BossID),
				 player_exit_area_1(GamePlay, MapDataID, BossID, Type, IsHelp)
			 end).

%% 请求协助信息
on_req_help_info() ->
	?metrics(begin
				 try
					 GuildID = player:getPlayerProperty(#player.guildID),
					 PlayerID = player:getPlayerID(),
					 ?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_Help_No_Guild),
					 Q1 = ets:fun2ms(fun(#guild_help_request{help_guild_id = OGuildID, help_seeker_id = SeekerID,
						 map_data_id = MapDataID, map_ai = MapAI, monster_data_id = MDID, monster_level = MLv, x = PosX, y = PoxY}) when OGuildID =:= GuildID ->
						 {SeekerID, MapDataID, MapAI, MDID, MLv, PosX, PoxY} end),
					 List = ets:select(?ETS_GuildHelpRequest, Q1),
					 Msg = make_helper_msg(List),

					 Q2 = ets:fun2ms(fun(#guild_help_request_common{help_guild_id = OGuildID, help_seeker_id = SeekerID, open_action_id = OpenAction, help_id = HelpID, param = P, suc_helper_list = SucList})
						 when OGuildID =:= GuildID andalso OpenAction =:= ?OpenAction_Merchant_Ship ->
						 {SucList, SeekerID, HelpID, P} end),
					 List2 = ets:select(?ETS_GuildHelpRequestCommon, Q2),
					 Msg2 = make_ship_helper_msg([{P2, P3, P4} || {P1, P2, P3, P4} <- List2, not lists:member(PlayerID, P1)]),

					 player:send(#pk_GS2U_getHelpRequstRet{list = Msg, ship_list = Msg2, err = ?ERROR_OK})
				 catch
					 Err ->
						 player:send(#pk_GS2U_getHelpRequstRet{err = Err})
				 end
			 end).

%% 发起协助请求
on_seek_help(MonsterID, MapDataID) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 ?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_Help_No_Guild),
					 Now = time:time(),
					 ?CHECK_THROW(Now >= get_last_req_time() + 10, ?ErrorCode_Guild_Help_CD),
					 ?CHECK_THROW(playerMap:getMapDataID() =:= MapDataID, ?ErrorCode_Guild_Help_Map),
					 ?CHECK_THROW(not team_lib:is_have_team(PlayerID), ?ErrorCode_Guild_Help_In_Team),
					 ?CHECK_THROW(not guild_help_logic:is_in_help(PlayerID), ?ErrorCode_Guild_Help_Already_Help),
					 ?CHECK_THROW(not guild_help_logic:is_in_help_req(PlayerID), ?ErrorCode_Guild_Help_Already_Help_Req),

					 #mapsettingCfg{mapAi = MapAI, mapOpenaction = OpenAction} = df:getMapsettingCfg(MapDataID),
					 ?CHECK_THROW(lists:member(MapAI, ?HELP_MAP_AI) orelse MapAI =:= ?MapAI_WorldBoss orelse MapAI == ?MapAI_DarkLord, ?ErrorCode_Guild_Help_Map_Ai),
					 ?CHECK_THROW(cfg_guildHelpBase:getRow(OpenAction) =/= {}, ?ErrorCode_Guild_Help_Map_Ai),

					 set_last_req_time(Now),
					 send_msg_2_map({player_req_help, GuildID, MapDataID, MonsterID})

				 catch
					 Err ->
						 player:send(#pk_GS2U_requestHelpRet{err = Err})
				 end
			 end).

%% 发起通用协助请求
on_seek_help_common(OpenActionID, Param1, Param2) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 ?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_Help_No_Guild),
					 Now = time:time(),
					 ?CHECK_THROW(Now >= get_last_req_time() + 10, ?ErrorCode_Guild_Help_CD),
					 ?CHECK_THROW(not guild_help_logic:is_in_help_req_common(Param2), ?ErrorCode_Guild_Help_Has_Seek_Help),
					 set_last_req_time(Now),
					 HelpErr = check_can_help(OpenActionID, PlayerID, {Param1, Param2}),
					 ?ERROR_CHECK_THROW(HelpErr),
					 guild_help:send_2_me({player_req_help_common, PlayerID, GuildID, OpenActionID, {Param1, Param2}}),
					 player:send(#pk_GS2U_requestHelpCommonRet{err = ?ERROR_OK, openActionID = OpenActionID, param1 = Param1, param2 = Param2})
				 catch
					 Err ->
						 player:send(#pk_GS2U_requestHelpCommonRet{err = Err, openActionID = OpenActionID, param1 = Param1, param2 = Param2})
				 end
			 end).

%% 接受协助请求
on_accept_help(ID) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 ?CHECK_THROW(not team_lib:is_have_team(PlayerID), ?ErrorCode_Guild_Help_In_Team),
					 ?CHECK_THROW(not guild_help_logic:is_in_help(PlayerID), ?ErrorCode_Guild_Help_Already_Help),
					 ?CHECK_THROW(not guild_help_logic:is_in_help_req(PlayerID), ?ErrorCode_Guild_Help_Already_Help_Req),
					 Info = etsBaseFunc:readRecord(?ETS_GuildHelpRequest, ID),
					 ?CHECK_THROW(Info =/= {}, ?ErrorCode_Guild_Help_No_Exist),
					 #guild_help_request{help_guild_id = HelpGuildID, help_seeker_id = HelpSeekerID} = Info,
					 ?CHECK_THROW(GuildID =:= HelpGuildID, ?ErrorCode_Guild_Help_Not_Same_Guild),
					 ?CHECK_THROW(PlayerID =/= HelpSeekerID, ?ErrorCode_Guild_Help_Same_Player),
					 guild_help:send_2_me({accept_help, ID, PlayerID})
				 catch
					 Err ->
						 player:send(#pk_GS2U_respondHelpRet{err = Err})
				 end
			 end).

%% 接受通用协助请求
on_accept_help_common(ID) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Info = etsBaseFunc:readRecord(?ETS_GuildHelpRequestCommon, ID),
					 ?CHECK_THROW(Info =/= {}, ?ErrorCode_Guild_Help_No_Exist),
					 ?CHECK_THROW(not guild_help_logic:is_in_help_common(PlayerID), ?ErrorCode_Guild_Help_Already_Help),
					 #guild_help_request_common{help_guild_id = HelpGuildID, help_seeker_id = HelpSeekerID} = Info,
					 ?CHECK_THROW(GuildID =:= HelpGuildID, ?ErrorCode_Guild_Help_Not_Same_Guild),
					 ?CHECK_THROW(PlayerID =/= HelpSeekerID, ?ErrorCode_Guild_Help_Same_Player),
					 guild_help:send_2_me({accept_help_common, ID, PlayerID})
				 catch
					 Err ->
						 player:send(#pk_GS2U_respondHelpCommonRet{err = Err})
				 end
			 end).

%% 接受协助请求成功
on_accept_help_common_ok() ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 Data = etsBaseFunc:readRecord(?ETS_GuildHelpRelationCommon, PlayerID),
					 ?CHECK_THROW(Data =/= {}, ?ErrorCode_Guild_Help_No_Exist),
					 #guild_help_relation_common{help_seeker_id = HelpSeekerID, open_action_id = OpenAction, param = Param} = Data,
					 HandleErr = handle_common_help(OpenAction, HelpSeekerID, Param),
					 ?ERROR_CHECK_THROW(HandleErr),
					 player:send(#pk_GS2U_respondHelpCommonRet{err = ?ERROR_OK})
				 catch
					 Err ->
						 player:send(#pk_GS2U_respondHelpCommonRet{err = Err})
				 end
			 end).

%% 求助者取消请求
on_cancel_help() ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 case etsBaseFunc:readRecord(?ETS_GuildHelpRequest, PlayerID) of
						 #guild_help_request{monster_data_id = MonsterDataID} ->
							 Q2 = ets:fun2ms(fun(#guild_help_relation{help_seeker_id = HelpSeekerID, helper_id = HelperID}) when PlayerID =:= HelpSeekerID ->
								 HelperID end),
							 HelperIDList = lists:usort(ets:select(?ETS_GuildHelpRelation, Q2)),
							 guild_help:send_2_me({cancel_request, PlayerID}),
							 send_msg_2_map({help_cancel, HelperIDList, MonsterDataID});
						 _ ->
							 throw(?ErrorCode_Guild_Help_No_Req)
					 end,
					 player:send(#pk_GS2U_cancelHelpRet{err = ?ERROR_OK})
				 catch
					 Err ->
						 player:send(#pk_GS2U_cancelHelpRet{err = Err})
				 end
			 end).

%% 协助者中断协助
on_interrupt_help() ->
	try
		PlayerID = player:getPlayerID(),
		case etsBaseFunc:readRecord(?ETS_GuildHelpRelation, PlayerID) of
			#guild_help_relation{help_seeker_id = SeekerID, monster_data_id = MonsterDataID} ->
				guild_help:send_2_me({interrupt_request, PlayerID}),
				send_msg_2_map({help_interrupt, SeekerID, MonsterDataID});
			_ ->
				throw(?ErrorCode_Guild_Help_No_Req)
		end,
		player:send(#pk_GS2U_cancelHelpRet{err = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_cancelHelpRet{err = Err})
	end.

%% 协助成功
on_help_success(SeekerID, MapDataID, MonsterId, MonsterLv, MergeTimes) ->
	?metrics(begin
				 GuildID = player:getPlayerProperty(#player.guildID),
				 PlayerID = player:getPlayerID(),
				 Class = guild_pub:get_guild_member_class(GuildID, PlayerID),
				 Value = variable_player:get_value(?Variant_Index_35_GuidHelpScore),
				 AddLimit = dragon_badge:get_prestige_limit() + recharge_subscribe:get_subscribe_value(?RechargeSubscribe4, 0),
				 <<NowScore:16, _P1:8, _P2:8>> = <<Value:32>>,
				 #mapsettingCfg{mapAi = MapAi, mapOpenaction = OpenAction} = cfg_mapsetting:getRow(MapDataID),
				 case cfg_guildHelpPres:getRow(Class) of
					 #guildHelpPresCfg{presLimit = Limit} when NowScore < (Limit + AddLimit) ->
						 case cfg_guildHelpBase:getRow(OpenAction) of
							 #guildHelpBaseCfg{helpPres = Point} ->
								 Percent = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Help) + dragon_badge:get_prestige_percent(),
								 NewPoint = trunc((Point * (100 + Percent) / 100) * MergeTimes),
								 AddPoint = min((Limit + AddLimit) - NowScore, NewPoint),
								 currency:add(?CURRENCY_GuildHelp, AddPoint, ?Reason_GuildHelp_Success),
								 player:send(#pk_GS2U_helpSuccess{err = ?ERROR_OK, percent = Percent, score = AddPoint, mapDataID = MapDataID,
									 monsterID = MonsterId, monsterLv = MonsterLv, playerName = mirror_player:get_player_name(SeekerID)});
							 _ ->
								 ?LOG_ERROR("no cfg key ~p", [OpenAction]),
								 player:send(#pk_GS2U_helpSuccess{err = ?ERROR_OK, mapDataID = MapDataID, monsterID = MonsterId,
									 monsterLv = MonsterLv, playerName = mirror_player:get_player_name(SeekerID)})
						 end;
					 #guildHelpPresCfg{} ->
						 player:send(#pk_GS2U_helpSuccess{err = ?ERROR_OK, mapDataID = MapDataID, monsterID = MonsterId,
							 monsterLv = MonsterLv, playerName = mirror_player:get_player_name(SeekerID)});
					 _ ->
						 ?LOG_ERROR("no cfg key ~p", [Class]),
						 player:send(#pk_GS2U_helpSuccess{err = ?ERROR_OK, mapDataID = MapDataID, monsterID = MonsterId,
							 monsterLv = MonsterLv, playerName = mirror_player:get_player_name(SeekerID)})
				 end,
				 case MapAi of
					 ?MapAI_Demon ->
						 dragon_god_trail:task_event(?DragonGodTrail_3, 1),
						 dragon_god_trail:task_event(?DragonGodTrail_42, 1);
					 ?MapAI_DemonCluster ->
						 dragon_god_trail:task_event(?DragonGodTrail_3, 1);
					 ?MapAI_DemonCx ->
						 dragon_god_trail:task_event(?DragonGodTrail_43, 1);
					 ?MapAI_WorldBoss ->
						 dragon_god_trail:task_event(?DragonGodTrail_5, 1);
					 ?MapAI_Pantheon ->
						 dragon_god_trail:task_event(?DragonGodTrail_4, 1);
					 ?MapAI_PantheonCluster ->
						 dragon_god_trail:task_event(?DragonGodTrail_4, 1);
					 _ -> ok
				 end,
				 daily_task:add_daily_task_goal(?DailyTask_Goal_66, 1, ?DailyTask_CountType_Default),
				 guild_player:on_active_value_access(?DailyTask_Goal_66, 1),
				 player_task:update_task([?Task_Goal_HelpBoss, ?Task_Goal_HelpCount], {1}),
				 reincarnate:add_task_temp_data(?Task_Goal_HelpCount, 1, 0),
				 attainment:add_attain_progress(?Attainments_Type_AssistKillCount, {1}),
				 activity_new_player:on_active_condition_change(?SalesActivity_HelpCount_176, 1)
			 end).

%% 协助结束
on_help_finish(PlayerIDList, MergeTimes) ->
	?metrics(begin
				 [{MaxNum, ItemID} | _] = df:getGlobalSetupValueList(guildHelpBox, [{50, 1380207}]),
				 NowNum = bag_player:get_item_amount(?BAG_PLAYER, ItemID) + bag_player:get_item_amount(?BAG_REPOSITORY, ItemID),
				 GetNum = max(min(MaxNum - NowNum, MergeTimes), 0),
				 case GetNum =< 0 of
					 ?TRUE ->
						 ?LOG_INFO("max num ~p", [NowNum]),
						 ok;
					 _ ->
						 PlayerId = player:getPlayerID(),
						 bag_player:add([{ItemID, GetNum, 1}], ?Reason_GuildHelp_Seeker_Finish),
						 [insert_box_content(PlayerId, PlayerIDList) || _ <- lists:seq(1, GetNum)]
				 end,
				 player_task:update_task([?Task_Goal_HelpCount], {1}),
				 reincarnate:add_task_temp_data(?Task_Goal_HelpCount, 1, 0),
				 attainment:add_attain_progress(?Attainments_Type_AssistKillCountEd, {1})
			 end).

%% 获取心意宝箱关联玩家
on_req_box_content() ->
	PlayerID = player:getPlayerID(),
	L = case table_player:lookup(db_help_box, PlayerID) of
			[#db_help_box{help_list = List} | _] ->
				[PlayerList | _T] = gamedbProc:dbstring_to_term(List),
				PlayerList;
			_ -> []
		end,
	player:send(#pk_GS2U_getHelpBoxContentRet{player_info_list = [make_helper_info(ID) || ID <- L]}).

%% 使用心意宝箱
on_use_box(Index) ->
	?metrics(begin
				 ID = id_generator:generate(?ID_TYPE_Help_Msg),
				 PlayerID = player:getPlayerID(),
				 ExpireTime = time:daytime_add(time:time(), 2 * ?SECONDS_PER_DAY - 1),
				 %% 给自己发奖励
				 Value = variable_player:get_value(?Variant_Index_35_GuidHelpScore),
				 <<NowScore:16, P1:8, P2:8>> = <<Value:32>>,

				 LvList = lists:usort([Lv || {1, Lv} <- cfg_guildHelpAward:getKeyList()]),
				 PlayerLv = player:getPlayerProperty(#player.level),
				 Level = common:getValueByInterval1(PlayerLv, LvList, 0),
				 case cfg_guildHelpAward:getRow(1, Level) of
					 #guildHelpAwardCfg{num = DailyMax, award = AwardList} ->
						 case P2 < DailyMax of
							 ?TRUE ->
								 CurrList = [{Type, Num} || {2, Type, Num} <- AwardList],
								 ItemList = [{ItemID, Num, 1} || {1, ItemID, Num} <- AwardList],
								 <<NewValue:32>> = <<NowScore:16, P1:8, (P2 + 1):8>>,
								 variable_player:set_value(?Variant_Index_35_GuidHelpScore, NewValue),
								 player:add_rewards(ItemList, CurrList, ?Reason_GuildHelp_Tks_box),
								 player_item:show_get_item_dialog(ItemList, CurrList, [], 0);
							 _ -> skip
						 end;
					 _ ->
						 ?LOG_ERROR("no cfg key ~p", [{1, Level}]),
						 throw(?ERROR_Cfg)
				 end,
				 %% 给其他人发感谢
				 case table_player:lookup(db_help_box, PlayerID) of
					 [#db_help_box{help_list = List} = Info | _] ->
						 [PlayerList | T] = gamedbProc:dbstring_to_term(List),
						 MsgList = [make_help_rd(ID, PlayerID, HelpID, Index, ExpireTime) || HelpID <- PlayerList],
						 table_player:insert(?TableThanksMsg, MsgList),
						 %% 通知其他人收到了感谢
						 [main:sendMsgToPlayerProcess(HelpID, {help_recive_tks}) || HelpID <- PlayerList],
						 %% 更新列表
						 case T =:= [] of
							 ?TRUE ->
								 table_player:delete(db_help_box, PlayerID);
							 _ ->
								 table_player:insert(db_help_box, Info#db_help_box{help_list = gamedbProc:term_to_dbstring(T)})
						 end;
					 _ -> ok
				 end,
				 ok
			 end).

%% 请求消息内容
on_req_msg_info(ID) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 #db_help_thanks_msg{help_id = HelpId, index = Index} = case table_player:lookup(?TableThanksMsg, PlayerID, [ID]) of
																				[R | _] -> R;
																				_ ->
																					throw(?ErrorCode_Guild_Help_No_Msg)
																			end,
					 player:send(#pk_GS2U_getHelpBoxMsgRet{err = ?ERROR_OK, player_info = make_helper_info(HelpId), index = Index})
				 catch
					 Err ->
						 player:send(#pk_GS2U_getHelpBoxMsgRet{err = Err})
				 end
			 end).

%% 阅读消息
on_read_tks_msg(ID) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),
					 case table_player:lookup(?TableThanksMsg, PlayerID, [ID]) of
						 [R | _] -> R;
						 _ ->
							 throw(?ErrorCode_Guild_Help_No_Msg)
					 end,
					 Value = variable_player:get_value(?Variant_Index_35_GuidHelpScore),
					 <<NowScore:16, P1:8, P2:8>> = <<Value:32>>,
					 LvList = lists:usort([Lv || {2, Lv} <- cfg_guildHelpAward:getKeyList()]),
					 PlayerLv = player:getPlayerProperty(#player.level),
					 Level = common:getValueByInterval1(PlayerLv, LvList, 0),
					 case cfg_guildHelpAward:getRow(2, Level) of
						 #guildHelpAwardCfg{num = DailyMax, award = AwardList} ->
							 case P1 < DailyMax of
								 ?TRUE ->
									 CurrList = [{Type, Num} || {2, Type, Num} <- AwardList],
									 ItemList = [{ItemID, Num, 1} || {1, ItemID, Num} <- AwardList],
									 <<NewValue:32>> = <<NowScore:16, (P1 + 1):8, P2:8>>,
									 variable_player:set_value(?Variant_Index_35_GuidHelpScore, NewValue),
									 player:add_rewards(ItemList, CurrList, ?Reason_GuildHelp_Tks_box),
									 player_item:show_get_item_dialog(ItemList, CurrList, [], 0);
								 _ -> skip
							 end;
						 _ ->
							 ?LOG_ERROR("no cfg key ~p", [{2, Level}]),
							 throw(?ERROR_Cfg)
					 end,
					 table_player:delete(?TableThanksMsg, PlayerID, [ID]),
					 player:send(#pk_GS2U_getHelpBoxAwardRet{err = ?ERROR_OK}),
					 on_sync_tks_msg()
				 catch
					 Err ->
						 player:send(#pk_GS2U_getHelpBoxAwardRet{err = Err})
				 end
			 end).

%% 请求伤害列表
on_get_help_damage_rank() ->
	send_msg_2_map({get_help_damage_rank}).

%% 增加协助积分(不受战盟等级加成)
on_add_help_score(Point, Reason) when Point > 0 ->
	GuildID = player:getPlayerProperty(#player.guildID),
	Class = guild_pub:get_guild_member_class(GuildID, player:getPlayerID()),
	Value = variable_player:get_value(?Variant_Index_35_GuidHelpScore),
	<<NowScore:16, _P1:8, _P2:8>> = <<Value:32>>,
	AddLimit = recharge_subscribe:get_subscribe_value(?RechargeSubscribe4, 0),
	case cfg_guildHelpPres:getRow(Class) of
		#guildHelpPresCfg{presLimit = Limit} when NowScore < Limit + AddLimit ->
			AddPoint = min((Limit + AddLimit) - NowScore, Point),
			currency:add(?CURRENCY_GuildHelp, AddPoint, Reason),
			ok;
		#guildHelpPresCfg{} ->
			skip;
		_ ->
			?LOG_ERROR("no cfg key ~p", [Class]),
			skip
	end;
on_add_help_score(_, _) -> ok.

%% 增加协助积分(受战盟等级加成)
on_add_help_score_multi(Point, Reason) when Point > 0 ->
	GuildID = player:getPlayerProperty(#player.guildID),
	Percent = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Help) + dragon_badge:get_prestige_percent(),
	NewPoint = trunc(Point * (100 + Percent) / 100),
	currency:add(?CURRENCY_GuildHelp, NewPoint, Reason),
	?ERROR_OK;
on_add_help_score_multi(_, _) -> ok.

on_set_target_map_ai(MapAI) ->
	put('guild_help_target_map_ai', MapAI).
on_check_map_ai_change(ToMapAi) ->
	case get('guild_help_target_map_ai') of
		?UNDEFINED -> ok;
		TargetMapAI ->
			case ToMapAi =/= TargetMapAI of
				?TRUE ->
					on_interrupt_help();
				_ -> ok
			end
	end.


on_set_target_map_ai_common(MapAI) ->
	put('guild_help_target_map_ai_common', MapAI).
on_check_map_ai_change_common(ToMapAi) ->
	case get('guild_help_target_map_ai_common') of
		?UNDEFINED -> ok;
		TargetMapAI ->
			case ToMapAi =/= TargetMapAI of
				?TRUE ->
					guild_help:send_2_me({break_help_common_relation, player:getPlayerID()});
				_ -> ok
			end
	end.

%% 通用协助者完成协助奖励发放
on_helper_common_finish_award(OpenActionID) ->
	case cfg_guildHelpBase:getRow(OpenActionID) of
		#guildHelpBaseCfg{helpPres = Point} ->
			on_add_help_score_multi(Point, ?Reason_GuildHelp_Success);
		_ ->
			?LOG_ERROR("no cfg key ~p", [OpenActionID])
	end.

%% 玩家阅读通用协助完成消息
on_read_help_msg_common(ID, TksIndex) ->
	?metrics(begin
				 try
					 PlayerID = player:getPlayerID(),

					 {RetItem1, RetCurrency1} = case table_player:lookup(?TableHelpMsg, PlayerID, [ID]) of
													[#help_msg_common{open_action_id = OpenAction, param = Param} | _] ->
														{HandleErr, RetAward} = handle_common_help_msg(OpenAction, Param, TksIndex),
														?ERROR_CHECK_THROW(HandleErr),
														table_player:delete(?TableHelpMsg, PlayerID, [ID]),
														RetAward;
													_ ->
														throw(?ErrorCode_Guild_Help_No_Msg)
												end,

					 %% 给自己发奖励
					 Value = variable_player:get_value(?Variant_Index_35_GuidHelpScore),
					 <<NowScore:16, P1:8, P2:8>> = <<Value:32>>,
					 LvList = lists:usort([Lv || {1, Lv} <- cfg_guildHelpAward:getKeyList()]),
					 PlayerLv = player:getLevel(),
					 Level = common:getValueByInterval1(PlayerLv, LvList, 0),
					 {RetItem2, RetCurrency2} = case cfg_guildHelpAward:getRow(1, Level) of
													#guildHelpAwardCfg{num = DailyMax, award = AwardList} ->
														case P2 < DailyMax of
															?TRUE ->
																CurrList = [{Type, Num} || {2, Type, Num} <- AwardList],
																ItemList = [{ItemID, Num, 1} || {1, ItemID, Num} <- AwardList],
																<<NewValue:32>> = <<NowScore:16, P1:8, (P2 + 1):8>>,
																variable_player:set_value(?Variant_Index_35_GuidHelpScore, NewValue),
																player:add_rewards(ItemList, CurrList, ?Reason_GuildHelp_Tks_box),
																{ItemList, CurrList};
															_ -> {[], []}
														end;
													_ ->
														?LOG_ERROR("no cfg key ~p", [{1, Level}]),
														throw(?ERROR_Cfg)
												end,
					 player_item:show_get_item_dialog(RetItem1 ++ RetItem2, RetCurrency1 ++ RetCurrency2, [], 0),
					 player:send(#pk_GS2U_helpCommonRewardRet{err = ?ERROR_OK})
				 catch
					 Err ->
						 player:send(#pk_GS2U_helpCommonRewardRet{err = Err})
				 end
			 end).

on_sync_ship_success_msg() ->
	PlayerID = player:getPlayerID(),
	Msg = [make_ship_success_msg(Info) || #help_msg_common{open_action_id = ?OpenAction_Merchant_Ship} = Info <- table_player:lookup(?TableHelpMsg, PlayerID)],
	player:send(#pk_GS2U_shipHelpFinishMsg{msg_list = Msg}).
%%%===================================================================
%%% Internal functions
%%%===================================================================

send_msg_2_map(Msg) ->
	playerMap:sendMsgToMap({guild_help_msg, Msg}).

make_help_rd(ID, PlayerID, HelpID, Index, ExpireTime) ->
	#db_help_thanks_msg{
		id = ID,
		player_id = HelpID,
		help_id = PlayerID,
		index = Index,
		expire_time = ExpireTime
	}.

insert_box_content(PlayerID, HelpList) ->
	case table_player:lookup(db_help_box, PlayerID) of
		[#db_help_box{help_list = List} = Info | _] ->
			OldList = gamedbProc:dbstring_to_term(List),
			NewList = gamedbProc:term_to_dbstring([HelpList | OldList]),
			table_player:insert(db_help_box, Info#db_help_box{help_list = NewList});
		_ ->
			NewList = gamedbProc:term_to_dbstring([HelpList]),
			table_player:insert(db_help_box, #db_help_box{player_id = PlayerID, help_list = NewList})
	end.

get_last_req_time() ->
	case get('guild_help_last_req_time') of
		?UNDEFINED ->
			0;
		R -> R
	end.
set_last_req_time(Time) ->
	put('guild_help_last_req_time', Time).

%% 进入boss区域
player_enter_area_1(1, MapDataID, BossID, Type, ?TRUE) ->
	send_msg_2_map({enter_boss_area, MapDataID, BossID}),
	pantheon_player:enter_demon_area(MapDataID, BossID, Type);
player_enter_area_1(1, MapDataID, BossID, Type, ?FALSE) ->
	pantheon_player:enter_demon_area(MapDataID, BossID, Type);
player_enter_area_1(2, MapDataID, BossID, _Type, ?TRUE) ->
	send_msg_2_map({enter_boss_area, MapDataID, BossID}),
	holy_war_player:on_enter_area(MapDataID, BossID);
player_enter_area_1(2, MapDataID, BossID, _Type, ?FALSE) ->
	holy_war_player:on_enter_area(MapDataID, BossID);
player_enter_area_1(3, MapDataID, BossID, Type, ?TRUE) ->
	send_msg_2_map({enter_boss_area, MapDataID, BossID}),
	demon_player:enter_demon_area(MapDataID, BossID, Type);
player_enter_area_1(3, MapDataID, BossID, Type, ?FALSE) ->
	demon_player:enter_demon_area(MapDataID, BossID, Type);
player_enter_area_1(GamePlay, _, _, _, _) ->
	?LOG_ERROR("unknow gameplay ~p", [GamePlay]).

%% 退出boss区域
player_exit_area_1(1, MapDataID, BossID, Type, ?TRUE) ->
	send_msg_2_map({exit_boss_area, MapDataID, BossID}),
	pantheon_player:exit_demon_area_help(MapDataID, BossID, Type);
player_exit_area_1(1, MapDataID, BossID, Type, ?FALSE) ->
	pantheon_player:exit_demon_area(MapDataID, BossID, Type);
player_exit_area_1(2, MapDataID, BossID, _Type, ?TRUE) ->
	send_msg_2_map({exit_boss_area, MapDataID, BossID}),
	holy_war_player:on_exit_area_help(MapDataID, BossID);
player_exit_area_1(2, MapDataID, BossID, _Type, ?FALSE) ->
	holy_war_player:on_exit_area(MapDataID, BossID);
player_exit_area_1(3, MapDataID, BossID, Type, ?TRUE) ->
	send_msg_2_map({exit_boss_area, MapDataID, BossID}),
	demon_player:exit_demon_area_help(MapDataID, BossID, Type);
player_exit_area_1(3, MapDataID, BossID, Type, ?FALSE) ->
	demon_player:exit_demon_area(MapDataID, BossID, Type);
player_exit_area_1(GamePlay, _, _, _, _) ->
	?LOG_ERROR("unknow gameplay ~p", [GamePlay]).

make_helper_msg(List) ->
	lists:map(fun({SeekerID, MapDataID, MapAI, MonsterDataID, MonsterLv, PosX, PoxY}) ->
		#pk_helper_msg{
			help_id = SeekerID,
			playerID = SeekerID,
			map_data_id = MapDataID,
			map_ai = MapAI,
			boss_data_id = MonsterDataID,
			monster_lv = MonsterLv,
			x = PosX,
			y = PoxY,
			player_info = make_helper_info(SeekerID)
		}
			  end, List).

make_ship_helper_msg(List) ->
	lists:foldl(
		fun({SeekerID, HelpID, {PlunderID, ShipID}}, Ret) ->
			case table_player:lookup(?TableMcShipForay, SeekerID, [ShipID]) of
				[#mc_ship_foray{plunder_list = PlList, ship_type = ShipType, retake_list = RkList} | _] ->
					[#pk_ship_helper_msg{
						help_id = HelpID,
						playerID = SeekerID,
						plunder_id = PlunderID,
						ship_type = ShipType,
						plunder_guild_name = guild_pub:get_guild_name(mirror_player:get_player_element(PlunderID, #player.guildID, 0)),
						plunder_name = mirror_player:get_player_name(PlunderID),
						plunder_sex = mirror_player:get_player_sex(PlunderID),
						plunder_battlev = mirror_player:get_player_battle_value(PlunderID),
						plunder_list = playerItem:make_award_msg(PlList),
						retake_list = playerItem:make_award_msg(RkList),
						player_info = make_helper_info(SeekerID)
					} | Ret];
				_ ->
					Ret
			end
		end, [], List).

make_helper_info(PlayerID) ->
	#pk_helper_info{
		playerID = PlayerID,
		playerName = mirror_player:get_player_name(PlayerID),
		playerLv = mirror_player:get_player_level(PlayerID),
		playerSex = mirror_player:get_player_sex(PlayerID),
		vip = mirror_player:get_player_vip(PlayerID),
		headid = mirror_player:get_player_equip_head(PlayerID),
		head_frame = mirror_player:get_player_equip_frame(PlayerID),
		career = mirror_player:get_player_career(PlayerID)
	}.


make_ship_success_msg(#help_msg_common{id = ID, param = {_, AtkPlayerID, DefPlayerID, _, ShipType, Index, Reward}}) ->
	#pk_ship_help_succ{
		msg_id = ID,
		ship_type = ShipType,
		index = Index,
		plunder_name = mirror_player:get_player_name(DefPlayerID),
		plunder_sex = mirror_player:get_player_sex(DefPlayerID),
		reward_list = playerItem:make_award_msg(Reward),
		player_info = make_helper_info(AtkPlayerID)
	}.

handle_common_help(?OpenAction_Merchant_Ship, HelpSeekerID, {PlunderID, ShipID}) ->
	Err = mc_ship_player:on_help_recapture_ship(HelpSeekerID, PlunderID, ShipID),
	case Err =:= ?ERROR_OK of
		?TRUE ->
			on_set_target_map_ai_common(?MapAI_MerchantShip);
		_ ->
			guild_help:send_2_me({break_help_common_relation, player:getPlayerID()})
	end,
	Err;
handle_common_help(Other, HelpSeekerID, Param) ->
	?LOG_ERROR("unhandle type ~p , helpseeker ~p,param ~p ", [Other, HelpSeekerID, Param]),
	?ERROR_Type.

handle_common_help_msg(?OpenAction_Merchant_Ship, {HelpSeeker, AtkPlayerID, _, _, _, _, Reward}, TksIndex) ->
	{RetItem, RetCurrency} = player_item:categorise_award(Reward),
	player_item:reward(RetItem, [], RetCurrency, ?REASON_Merchant_Ship_Help_Retake),
	ID = id_generator:generate(?ID_TYPE_Help_Msg),
	ExpireTime = time:daytime_add(time:time(), 2 * ?SECONDS_PER_DAY - 1),
	MsgList = make_help_rd(ID, HelpSeeker, AtkPlayerID, TksIndex, ExpireTime),
	table_player:insert(?TableThanksMsg, MsgList),
	%% 通知其他人收到了感谢
	main:sendMsgToPlayerProcess(AtkPlayerID, {help_recive_tks}),
	{?ERROR_OK, {RetItem, RetCurrency}};
handle_common_help_msg(Other, Param, _) ->
	?LOG_ERROR("unhandle type ~p , param ~p ", [Other, Param]),
	{?ERROR_Type, {[], []}}.

check_can_help(?OpenAction_Merchant_Ship, HelpSeekerID, {_, ShipID}) ->
	case table_player:lookup(?TableMcShipForay, HelpSeekerID, [ShipID]) of
		[] -> ?ErrorCode_MerchantShip_Ship_No_Foray_Msg;
		[#mc_ship_foray{state = 1} | _] -> ?ErrorCode_MerchantShip_Ship_Retake_All;
		_ -> ?ERROR_OK
	end;
check_can_help(_, _, _) -> ?ERROR_OK.

sync_red_point() ->
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		PlayerID = player:getPlayerID(),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_Help_No_Guild),
		Q1 = ets:fun2ms(fun(#guild_help_request{help_guild_id = OGuildID, help_seeker_id = SeekerID,
			map_data_id = MapDataID}) when OGuildID =:= GuildID -> {SeekerID, MapDataID} end),
		Msg1 = [#pk_help_red_stc{help_id = P1, player_id = P1, map_data_id = P2} || {P1, P2} <- ets:select(?ETS_GuildHelpRequest, Q1)],
		Q2 = ets:fun2ms(fun(#guild_help_request_common{help_seeker_id = SeekerID, help_guild_id = OGuildID, open_action_id = OpenAction, help_id = HelpID, suc_helper_list = SucList})
			when OGuildID =:= GuildID ->
			{SucList, HelpID, OpenAction, SeekerID} end),
		Msg2 = [#pk_help_red_stc{help_id = P2, open_aciton_id = P4, player_id = P5} || {P1, P2, P4, P5} <- ets:select(?ETS_GuildHelpRequestCommon, Q2), not lists:member(PlayerID, P1)],
		player:send(#pk_GS2U_HelpRedSync{red_list = Msg1 ++ Msg2})
	catch
		_Err ->
			player:send(#pk_GS2U_HelpRedSync{})
	end.