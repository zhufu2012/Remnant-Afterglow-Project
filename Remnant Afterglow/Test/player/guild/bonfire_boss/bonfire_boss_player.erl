%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2020 19:57
%%%-------------------------------------------------------------------
-module(bonfire_boss_player).
-author("suw").

-include("error.hrl").
-include("record.hrl").
-include("gameMap.hrl").
-include("bonfire_boss.hrl").
-include("reason.hrl").
-include("netmsgRecords.hrl").
-include("cfg_guildDinneDrink.hrl").
-include("logger.hrl").
-include("variable.hrl").
-include("activity_new.hrl").
-include("daily_task_goal.hrl").
-include("seven_gift_define.hrl").
-include("cfg_guildDinnerAwards.hrl").
-include("retrieve.hrl").
-include("player_task_define.hrl").
-include("attainment.hrl").

%% API
%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_enter_guild_camp/0, on_drink/1, on_get_stage_award/1, handle_msg/1, on_send_rank_detail/1, on_time_sync/0, gm_clear_t/0]).

%% 进入地图
on_enter_guild_camp() ->
	try
		case is_func_open() of
			?FALSE -> throw(?ERROR_FunctionClose);
			_ -> skip
		end,
		MapDataId = ?GuildCampMapID,
		case playerMap:getMapDataID() of
			MapDataId -> throw(?AlreadyInThisMap);
			_ -> skip
		end,

		GuildId = player:getPlayerProperty(#player.guildID),
		case GuildId > 0 of
			?TRUE -> skip;
			_ -> throw(?EnterMap_NoGuild)
		end,
		PlayerID = player:getPlayerID(),
		IsFirstEnter = case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildId) of
						   #bonfire_boss{player_drink_info = PlayerDrinkInfo} ->
							   case lists:keyfind(PlayerID, #bonfire_player_drink.player_id, PlayerDrinkInfo) of
								   ?FALSE -> ?TRUE;
								   _ -> ?FALSE
							   end;
						   _ -> ?TRUE
					   end,
		Stage = bonfire_boss_logic:get_stage(),
		RetrieveParam = case IsFirstEnter andalso (Stage =:= ?Bonfire_Drink_Stage orelse Stage =:= ?Bonfire_Exp_Stage) of
							?TRUE ->
								case retrieve:consume_times(?Retrieve_12, 1) of
									0 -> {};
									MulTime ->
										{?Retrieve_12, MulTime, retrieve:get_multi(?Retrieve_12) / 10000 - 1}
								end;
							_ -> {}
						end,

		%% 进入地图
		playerMap:on_U2GS_RequestEnterMap(#requestEnterMapParam{requestID = MapDataId, mapOwnerID = GuildId, params = #mapParams{retrieve_param = RetrieveParam}})
	catch
		ErrorCode ->
			player:send(#pk_GS2U_RequestEnterMapResult{result = ErrorCode, mapDataID = ?GuildCampMapID})
	end.

%% 请客喝酒 绑钻
on_drink(Type) ->
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		case is_func_open() of
			?FALSE -> throw(?ERROR_FunctionClose);
			_ -> skip
		end,
		case bonfire_boss_logic:is_drink_active() of
			?TRUE -> skip;
			?FALSE -> throw(?ErrorCode_GCamp_OutActiveTime)
		end,
		case GuildID > 0 of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Guild_NoGuild)
		end,
		case playerMap:getMapDataID() =:= ?GuildCampMapID of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_GCamp_NotInMap)
		end,
		Index = common:getTernaryValue(Type =:= 1, 1, 2),
		#guildDinneDrinkCfg{drinkLimit = Limit, drinkCost = DrinkCost} = cfg_guildDinneDrink:getRow(Index),
		%% 判断喝酒次数是否达到上限
		PlayerId = player:getPlayerID(),
		PlayerDrinkInfoList = bonfire_boss_logic:get_guild_drink_info(GuildID),
		DrinkInfo = case lists:keyfind(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
						?FALSE -> #bonfire_player_drink{};
						R ->
							R
					end,
		{DrinkErr, _} = bonfire_boss_logic:drink_limit_check(Index, DrinkInfo, Limit),
		?ERROR_CHECK_THROW(DrinkErr),
		Err = player:delete_cost(DrinkCost, ?Reason_GCamp_Drink),
		?ERROR_CHECK_THROW(Err),
		case Index of
			1 ->
				activity_new_player:on_active_condition_change(?SalesActivity_LowerDrink_174, 1);
			2 ->
				activity_new_player:on_active_condition_change(?SalesActivity_SeniorDrink_175, 1),
				player_task:update_task(?Task_Goal_GuildDrinkHigh, {1}),
				reincarnate:add_task_temp_data(?Task_Goal_GuildDrinkHigh, 1, 0);
			_ -> ok
		end,

		bonfire_boss:send_2_me({player_drink, PlayerId, GuildID, Index})
	catch
		ErrCode -> player:send(#pk_GS2U_GuildCampDrinkRet{err_code = ErrCode, type = Type})
	end.

%% 领取阶段奖励
on_get_stage_award(_Stage) ->
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
		PlayerId = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		#guildDinnerAwardsCfg{dinnerAllsward = AwardList, drinkNum = N} = Cfg,
		GuildBonfireData = case etsBaseFunc:readRecord(?ETS_BonfireBoss, GuildID) of
							   {} -> throw(?ErrorCode_Guild_NoGuild);
							   Data -> Data
						   end,
		PlayerDrinkInfoList = GuildBonfireData#bonfire_boss.player_drink_info,
		{DrinkInfo, _} = case lists:keytake(PlayerId, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
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

		StageList = common:listsFiterMap(fun({Stage, CfgPoint, _, _, _, _, _}) ->
			common:getTernaryValue((Mask bsr Stage) band 1 =:= 0 andalso GuildBonfireData#bonfire_boss.treat_point >= CfgPoint, Stage, ok)
										 end, AwardList),

		case StageList =/= [] of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_GCamp_StageAwardGot)
		end,

		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		bonfire_boss:send_2_me({player_stage_award, PlayerID, GuildID})
	catch
		ErrCode -> player:send(#pk_GS2U_GuildCampGetSatgeAwardRet{err_code = ErrCode})
	end.

on_time_sync() ->
	#bonfire_data{open_time = OpenTime, boss_time = BossTime, close_time = CloseTime} = bonfire_boss_logic:get_bonfire_boss_data(),
	player:send(#pk_GS2U_GuildCampInfoSync{start_timestamp = OpenTime, boss_timestamp = BossTime, end_timestamp = CloseTime}).

on_send_rank_detail(1) ->
	GuildID = player:getPlayerProperty(#player.guildID),
	player:send(#pk_GS2U_bonfire_player_rank_detail{rank_list = bonfire_boss_logic:make_player_rank_detail(GuildID)});
on_send_rank_detail(_) ->
	player:send(#pk_GS2U_bonfire_guild_rank_detail{rank_list = bonfire_boss_logic:make_guild_rank_detail()}).

handle_msg({open_event, Time}) ->
	case variable_player:get_value(?Variable_player_reset_Enter, ?Variable_player_reset_Enter_Bit8) of
		?TRUE -> ok;
		?FALSE ->
			variable_player:set_value(?Variable_player_reset_Enter, ?Variable_player_reset_Enter_Bit8, 1),
			variable_player:set_value(?Variant_Index_37_GuildCampTime, Time),
			activity_new_player:on_active_condition_change(?SalesActivity_CampFire, 1),
			daily_task:add_daily_task_goal(?DailyTask_Goal_45, 1, ?DailyTask_CountType_Enter),
			guild_player:on_active_value_access(?DailyTask_Goal_45, 1),
			seven_gift:add_task_progress(?Seven_Type_GuildFire, {1}),
			attainment:add_attain_progress(?Attainments_Type_BossBonfireCount, {1}),
			table_log:insert_row(log_bonfire_info, [player:getPlayerID(), time:time()])
	end;
handle_msg(Msg) ->
	?LOG_ERROR("unknown msg:~p", [Msg]).
%%%===================================================================
%%% Internal functions
%%%===================================================================

gm_clear_t() ->
	bonfire_boss:send_2_me({gm_clear_t, player:getPlayerID(), player:getPlayerProperty(#player.guildID)}).

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_GuildCamp) =:= 1 andalso guide:is_open_action(?OpenAction_GuildCamp).