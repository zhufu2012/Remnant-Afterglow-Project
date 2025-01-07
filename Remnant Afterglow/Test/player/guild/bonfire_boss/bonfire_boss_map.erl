%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 09. 三月 2020 19:57
%%%-------------------------------------------------------------------
-module(bonfire_boss_map).
-author("suw").

-include("record.hrl").
-include("bonfire_boss.hrl").
-include("netmsgRecords.hrl").
-include("reason.hrl").
-include("attribute.hrl").
-include("guild.hrl").
-include("logger.hrl").
-include("cfg_dinnerBossBase.hrl").
-include("cfg_guildDinneDrink.hrl").
-include("error.hrl").
-include("cfg_guildDinnerAwards.hrl").
-include("currency.hrl").
-include("variable.hrl").
-include("gameMap.hrl").
-include("activity_new.hrl").
-include("cfg_dinnerBossAward.hrl").
-include("playerDefine.hrl").
-include("daily_task_goal.hrl").
-include("red_envelope.hrl").
-include("attainment.hrl").

-define(BonFireMapGuild, 'bonfire_map_guild').
-define(IsBossFresh, 'bonfire_boss_fresh_flag').
-define(BossUid, 'bonfire_boss_boss_uid').
-define(DamageInfo, 'bonfire_boss_damage_info').
-define(DamageTotal, 'bonfire_boss_damage_total').
-define(DamageIsChange, 'bonfire_boss_damage_change').
-define(BossHpPercent, 'bonfire_boss_hp_percent').
-define(BossStage, 'bonfire_boss_hp_stage').
-define(CollTimes, 'bonfire_boss_player_coll_times').
-define(InStageTime, 'bonfire_boss_in_stage_time').
-define(HpParams, 'bonfire_boss_hp_param_1').
-define(HpMinPercent, 'bonfire_boss_min_hp_p').
-define(StageChange, 'bonfire_bosss_tage_change').
%% API
%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_tick/1, handle_msg/1, on_player_enter/2, on_player_exit/1, guild_id_check/1,
	on_boss_damage/4, on_coll_dead/3, check_coll_time/1, get_hp_min_p/0, on_map_init/0]).

on_map_init() ->
	case guild_pub:find_guild(mapSup:getMapOwnerID()) of
		{} ->
			?LOG_ERROR("error init ~p", [mapSup:getMapOwnerID()]),
			self() ! {quit};
		_ ->
			#bonfire_data{stage = Stage, boss_time = BossTime, close_time = CloseTime} = bonfire_boss_logic:get_bonfire_boss_data(),
			Week = time:day_of_week(time:get_localtime()),
			case {Stage, cfg_dinnerBossBase:getRow(Week)} of
				{?Bonfire_Boss_Stage, #dinnerBossBaseCfg{bossStage = BossStageList}} ->
					MoreTime = cfg_globalSetup:guildDinnerBossTime(),
					TimesTamp = time:time(),
					UseTime = max(0, TimesTamp - BossTime - MoreTime),
					TotalTime = CloseTime - BossTime - MoreTime,
					Percent = common:format_number(UseTime / TotalTime, 4),
					set_boss_hp_percent(Percent),
					{_, StageNum} = common:getValueByInterval(get_boss_hp_percent() * 100, BossStageList, {0, 0}),
					set_boss_stage(StageNum); %% 地图初始化时检查阶段，已经过去的阶段不再触发
				_ ->
					skip
			end
	end.

handle_msg({guild_top_sync, Msg, AllRank}) ->
	guild_top_msg_sync(Msg, AllRank);
handle_msg({stage_event_end}) ->
	stage_event_end();
handle_msg({bonfire_start}) ->
	check_player_init();
handle_msg({bonfire_pre_time_finish}) ->
	camp_open_event_all();
handle_msg({bonfire_boss_start}) ->
	bonfire_boss_start();
handle_msg({bonfire_end}) ->
	set_hp_min_p(0),
	monsterMgr:killAllMonsters(),
	collection:killAllCollections(),
	on_boss_end(),
	erase(?IsBossFresh),
	erase(?BonFireMapGuild),
	erase(?BossUid),
	erase(?DamageIsChange),
	erase(?DamageTotal),
	erase(?BossHpPercent),
	erase(?BossStage),
	erase(?CollTimes),
	erase(?InStageTime),
	erase(?HpParams),
	erase(?HpMinPercent),
	erase(?StageChange),
	mapSup:setMapIsCheckNoPlayer(?TRUE);
handle_msg({guild_top_settle, {ItemList, EqList}, GuildRank, TotalDamage}) ->
	on_guild_settle({ItemList, EqList}, GuildRank, TotalDamage),
	erase(?DamageInfo),
	ok;
handle_msg({drink_success, PlayerId, PBuff, WholeBuff, _Index, _NewDrinkInfo}) ->
	add_inspire_buff(PlayerId, PBuff, WholeBuff),
%%	check_envelope(Index, NewDrinkInfo),
	ok;
handle_msg(Msg) ->
	?LOG_ERROR("bonfire unknow msg ~p", [Msg]).

on_tick(TimesTamp) ->
	#bonfire_data{stage = Stage, boss_time = BossTime, close_time = CloseTime} = bonfire_boss_logic:get_bonfire_boss_data(),
	case Stage =:= ?Bonfire_Boss_Stage andalso not get_boss_fresh_flag() andalso bonfire_boss_logic:is_boss_func_open() of
		?TRUE ->
			set_boss_fresh_flag(?TRUE),
			fresh_boss(),
			mapView:broadcast(#pk_GS2U_bornfire_boss_refresh_sync{});
		_ -> skip
	end,
	case Stage =:= ?Bonfire_Boss_Stage andalso get_boss_fresh_flag() of
		?TRUE ->
			BossUid = get_boss_uid(),
			get_in_stage_time() orelse map:kill_object(BossUid, BossUid),
			MoreTime = cfg_globalSetup:guildDinnerBossTime(),
			UseTime = max(0, TimesTamp - BossTime - MoreTime),
			TotalTime = CloseTime - BossTime - MoreTime,
			Percent = common:format_number(UseTime / TotalTime, 4),
			set_boss_hp_percent(Percent),
			check_boss_stage(),
			case get_in_stage_time() of
				?FALSE ->
					{P1, P2, P3} = get_hp_params(),
					MinPercent = UseTime * (P2 - P1) / (TotalTime * (P1 - P2) + P3) + (1 - P2) - (P2 - P1) / (TotalTime * (P1 - P2) + P3) * TotalTime * P2,
					set_hp_min_p(common:format_number(MinPercent, 4));
				_ -> skip
			end;
		_ -> skip
	end,
	on_tick_rank(TimesTamp rem 2 =:= 0),
	ok.

on_player_enter(PlayerId, MapParams) ->
	Stage = bonfire_boss_logic:get_stage(),
	case Stage =:= ?Bonfire_Drink_Stage orelse Stage =:= ?Bonfire_Exp_Stage orelse Stage =:= ?Bonfire_Boss_Stage of
		?TRUE ->
			ReParam = case MapParams#mapParams.retrieve_param of
						  {_, ReTimes, ReMulti} -> {ReTimes, ReMulti};
						  _ -> {0, 0}
					  end,
			bonfire_boss:send_2_me({player_enter_map, mapSup:getMapOwnerID(), PlayerId, ReParam}),
			enter_buff_check(PlayerId);
		_ -> skip
	end,
	case Stage =:= ?Bonfire_Exp_Stage orelse Stage =:= ?Bonfire_Boss_Stage of
		?TRUE ->
			{Open, _} = bonfire_boss_logic:get_bonfire_time(),
			Time = time:time() - Open - cfg_globalSetup:guildDinner_PreTime(),
			send_2_player(PlayerId, {open_event, Time});
		_ -> skip
	end,
	case Stage =:= ?Bonfire_Boss_Stage of
		?TRUE ->
			map:sendMsgToPlayerProcess(PlayerId, {game_ac_join, ?OpenAction_BonfireBoss}),
			DamageList = get_damage_info(),
			RankList = bonfire_boss_logic:get_rank_list(DamageList),
			RankTop3List = lists:sublist(RankList, 10),
			SendRankMsg = bonfire_boss_logic:make_player_rank_msg(RankTop3List),
			L = [{PlayerID, R, Damage} || {R, #playerDamageInfo{player_id = PlayerID, damage = Damage}} <- RankList],
			sync_person_top_all(SendRankMsg, L);
		_ -> skip
	end,
	case Stage =:= ?Bonfire_Idle_Stage of
		?FALSE -> ok;
		?TRUE -> map:sendMsgToPlayerProcess(PlayerId, {requestEnterMap, 0})
	end.

on_player_exit(PlayerId) ->
	Stage = bonfire_boss_logic:get_stage(),
	case Stage =:= ?Bonfire_Exp_Stage orelse Stage =:= ?Bonfire_Boss_Stage of
		?TRUE -> bonfire_boss:send_2_me({player_exit_map, mapSup:getMapOwnerID(), PlayerId});
		_ -> skip
	end.

guild_id_check(#mapPlayer{guildID = GuildId, id = PlayerId}) ->
	case map:getMapAI() of
		?MapAI_GuildCamp ->
			case mapSup:getMapOwnerID() =:= GuildId of
				?TRUE -> skip;
				_ -> main:sendMsgToPlayerProcess(PlayerId, {requestEnterMap, 0})
			end;
		_ -> skip
	end.

on_boss_damage(PlayerID, TargetID, _MonsterDataID, Damage) ->
	case get_boss_uid() =:= TargetID of
		?TRUE ->
			DamageList = get_damage_info(),
			NewDamageList = case lists:keytake(PlayerID, #playerDamageInfo.player_id, DamageList) of
								{_, #playerDamageInfo{damage = Damage1} = HurtInfo, Left} ->
									[HurtInfo#playerDamageInfo{damage = Damage1 + Damage} | Left];
								_ ->
									case mapdb:getMapPlayer(PlayerID) of
										#mapPlayer{} = MapPlayer ->
											[#playerDamageInfo{
												player_id = PlayerID,
												battle_value = MapPlayer#mapPlayer.battleValue,
												server_id = MapPlayer#mapPlayer.serverID,
												career = MapPlayer#mapPlayer.career,
												server_name = MapPlayer#mapPlayer.enter_server_name,
												player_name = MapPlayer#mapPlayer.name,
												player_sex = MapPlayer#mapPlayer.sex,
												damage = Damage
											} | DamageList];
										_ ->
											DamageList
									end
							end,
			set_damage_total(get_damage_total() + Damage),
			set_damage_info(NewDamageList),
			set_damage_change_flag(?TRUE);
		_ -> skip
	end.

on_coll_dead(PlayerID, _CollectionID, DataID) ->
	Week = time:day_of_week(time:get_localtime()),
	WorldLvList = case cfg_dinnerBossBase:getRow(Week) of
					  #dinnerBossBaseCfg{wLOrder = L} ->
						  L;
					  _ ->
						  ?LOG_ERROR("no cfg key ~p", [Week]),
						  []
				  end,
	WorldLvIndex = common:get_range_index(world_level:get_world_level(), WorldLvList, 1),
	case mapdb:getMapPlayer(PlayerID) of
		{} -> skip;
		#mapPlayer{id = PlayerID, career = Career, level = Lv} ->
			case cfg_dinnerBossAward:getRow(WorldLvIndex, Week) of
				#dinnerBossAwardCfg{collectionDrop = CollDropList} ->
					DropList = [{C, D, B, N, P} || {Stage, CollID, C, D, B, N, P} <- CollDropList, Stage =:= get_boss_stage(), CollID =:= DataID],
					{ItemList, EquipmentList, CurrencyList, _NoticeList} = drop:drop(DropList, [], PlayerID, Career, Lv),
					Language = language:get_player_language(PlayerID),
					map:send_mail(PlayerID, #mailInfo{
						player_id = PlayerID,
						title = language:get_server_string("playerbag_full_title", Language),
						describe = language:get_server_string("playerbag_full_describ", Language),
						coinList = [#coinInfo{type = CoinType, num = CoinNum, reason = ?REASON_Bonfire_Boss_Coll} || {CoinType, CoinNum} <- CurrencyList],
						itemList = [#itemInfo{itemID = ItemID, num = Count, isBind = IsBind} || {ItemID, Count, IsBind, _ExpireTime} <- ItemList],
						itemInstance = EquipmentList,
						attachmentReason = ?REASON_Bonfire_Boss_Coll,
						isDirect = 1
					}),
					add_player_coll_times(PlayerID, 1),
					map:send(PlayerID, player_item:make_show_get_item_dialog_msg(ItemList, CurrencyList, EquipmentList, 0, 1));
				_ ->
					?LOG_ERROR("no cfg find key ~p", [{WorldLvIndex, Week}])
			end
	end.

check_coll_time(PlayerID) ->
	get_player_coll_times(PlayerID) < cfg_globalSetup:guildDinnerBossLimit().
%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 排行同步心跳
on_tick_rank(?TRUE) ->
	case get_damage_change_flag() of
		?TRUE ->
			set_damage_change_flag(?FALSE),
			DamageList = get_damage_info(),
			RankList = bonfire_boss_logic:get_rank_list(DamageList),
			bonfire_boss:send_2_me({damage_rank_sync, mapSup:getMapOwnerID(), RankList, get_damage_total()}),
			RankTop3List = lists:sublist(RankList, 10),
			SendRankMsg = bonfire_boss_logic:make_player_rank_msg(RankTop3List),
			L = [{PlayerID, R, Damage} || {R, #playerDamageInfo{player_id = PlayerID, damage = Damage}} <- RankList],
			sync_person_top_all(SendRankMsg, L);
		_ -> skip
	end;
on_tick_rank(_) ->
	ok.

set_boss_fresh_flag(Flag) ->
	put(?IsBossFresh, Flag).
get_boss_fresh_flag() ->
	case get(?IsBossFresh) of
		?UNDEFINED -> ?FALSE;
		R -> R
	end.

set_boss_uid(Uid) ->
	put(?BossUid, Uid).
get_boss_uid() ->
	case get(?BossUid) of
		?UNDEFINED -> 0;
		R -> R
	end.

set_damage_info(RankList) ->
	put(?DamageInfo, RankList).
get_damage_info() ->
	case get(?DamageInfo) of
		?UNDEFINED -> [];
		R -> R
	end.

set_damage_total(Total) ->
	put(?DamageTotal, Total).
get_damage_total() ->
	case get(?DamageTotal) of
		?UNDEFINED -> 0;
		R -> R
	end.

set_damage_change_flag(Flag) ->
	put(?DamageIsChange, Flag).
get_damage_change_flag() ->
	case get(?DamageIsChange) of
		?UNDEFINED -> ?FALSE;
		R -> R
	end.

set_boss_hp_percent(Percent) ->
	put(?BossHpPercent, Percent).
get_boss_hp_percent() ->
	case get(?BossHpPercent) of
		?UNDEFINED -> 0;
		R -> R
	end.

set_boss_stage(Num) ->
	put(?BossStage, Num).
get_boss_stage() ->
	case get(?BossStage) of
		?UNDEFINED -> 0;
		R -> R
	end.

set_in_stage_time(Flag) ->
	put(?InStageTime, Flag).
get_in_stage_time() ->
	case get(?InStageTime) of
		?UNDEFINED -> ?FALSE;
		R -> R
	end.

set_stage_change_flag(Flag) ->
	put(?StageChange, Flag).
get_stage_change_flag() ->
	case get(?StageChange) of
		?UNDEFINED -> ?FALSE;
		R -> R
	end.

%% 血量参数
get_hp_params() ->
	case get(?HpParams) of
		?UNDEFINED ->
			Params = df:getGlobalSetupValueList(guildBossHPShow, [{0, 0, 30, 0}, {30, 30, 70, 15}, {70, 70, 100, 15}]),
			{_, P1, P2, P3} = common:getValueByInterval(get_boss_hp_percent() * 100, Params, {0, 0, 30, 0}),
			put(?HpParams, {P1 / 100, P2 / 100, P3}),
			{P1 / 100, P2 / 100, P3};
		R ->
			case get_stage_change_flag() of
				?TRUE ->
					set_stage_change_flag(?FALSE),
					Params = df:getGlobalSetupValueList(guildBossHPShow, [{0, 0, 30, 0}, {30, 30, 70, 15}, {70, 70, 100, 15}]),
					{_, P1, P2, P3} = common:getValueByInterval(get_boss_hp_percent() * 100, Params, {0, 0, 30, 0}),
					put(?HpParams, {P1 / 100, P2 / 100, P3}),
					{P1 / 100, P2 / 100, P3};
				?FALSE ->
					R
			end
	end.

set_hp_min_p(Num) ->
	put(?HpMinPercent, Num).
get_hp_min_p() ->
	case get(?HpMinPercent) of
		?UNDEFINED -> 1;
		R -> R
	end.

add_player_coll_times(PlayerID, Times) ->
	Old = case get(?CollTimes) of
			  ?UNDEFINED -> [];
			  R -> R
		  end,
	New = case lists:keytake(PlayerID, 1, Old) of
			  ?FALSE -> [{PlayerID, Times} | Old];
			  {_, {_, OldTimes}, Left} -> [{PlayerID, OldTimes + Times} | Left]
		  end,
	put(?CollTimes, New).
get_player_coll_times(PlayerID) ->
	List = case get(?CollTimes) of
			   ?UNDEFINED -> [];
			   R -> R
		   end,
	case lists:keyfind(PlayerID, 1, List) of
		?FALSE -> 0;
		{_, T} -> T
	end.

fresh_boss() ->
	Week = time:day_of_week(time:get_localtime()),
	case cfg_dinnerBossBase:getRow(Week) of
		#dinnerBossBaseCfg{boss = M1, bossBorn = M2, monsterAttr = MonsterAttr} ->
			[begin
				 {_Index, MonsterId} = lists:keyfind(Index, 1, M1),
				 ID = monsterMgr:addMonster(MonsterAttr, [], Index, 1, 0, 0, MonsterId, X, Z, R, 0, 0, 0, 0),
				 set_boss_uid(ID)
			 end || {Index, X, Z, R} <- M2];
		_ ->
			?LOG_ERROR("no cfg key ~p", [Week]),
			skip
	end.

%% 给已经在地图的玩家推送
camp_open_event_all() ->
	PlayerList = mapdb:getMapPlayerIDList(),
	[send_2_player(PlayerId, {open_event, 0}) || PlayerId <- PlayerList],
	ok.

send_2_player(PlayerId, Msg) ->
	m_send:send_msg_2_player_proc(PlayerId, {guild_camp_msg, Msg}).

%% 初始化已经在地图的玩家
check_player_init() ->
	PlayerList = mapdb:getMapPlayerIDList(),
	bonfire_boss:send_2_me({check_init_data, mapSup:getMapOwnerID(), PlayerList}).

%% 盟内排行
sync_person_top_all(SendRankMsg, L) ->
	BinFillMsg = #pk_GS2U_bonfire_player_rank_sync{rank_list = SendRankMsg},
	BinFill = netmsgWrite:packNetMsgBinFill(BinFillMsg),
	lists:foreach(fun(PlayerID) ->
		{Rank, Damage} = case lists:keyfind(PlayerID, 1, L) of
							 {_, R, D} -> {R, D};
							 ?FALSE -> {0, 0}
						 end,
		Msg = #pk_GS2U_bonfire_player_rank_sync{
			my_rank = Rank,
			my_damage = Damage,
			bin_fill = BinFill
		},
		map:send(PlayerID, Msg)
				  end,
		mapdb:getMapPlayerIDList()).

%% 活动结束信息同步及发奖
on_boss_end() ->
	set_damage_change_flag(?FALSE),
	DamageList = get_damage_info(),
	RankList = bonfire_boss_logic:get_rank_list(DamageList),
	bonfire_boss:send_2_me({damage_rank_sync, mapSup:getMapOwnerID(), RankList, get_damage_total()}),
	guild_award_settle(RankList).

on_guild_settle({ItemList, EqList}, GuildRank, GuildDamage) ->
	DamageList = get_damage_info(),
	RankList = bonfire_boss_logic:get_rank_list(DamageList),
	RankTop10List = lists:sublist(RankList, 10),
	MemberClassList = guild_pub:get_guild_member_list(mapSup:getMapOwnerID()),
	SendRankMsg = lists:map(fun({Rank, #playerDamageInfo{player_id = PlayerID, career = Career, player_name = PlayerName, battle_value = Bt, damage = Damage}}) ->
		#pk_bonfirePlayerHurtDetail{
			rank = Rank,
			player_id = PlayerID,
			career = Career,
			head_id = mirror_player:get_player_equip_head(PlayerID),
			head_frame = mirror_player:get_player_equip_frame(PlayerID),
			guild_postion = bonfire_boss_logic:get_member_class(PlayerID, MemberClassList),
			player_name = PlayerName,
			battle_value = Bt,
			damage = Damage
		}
							end, RankTop10List),
	L = [{PlayerID, R, Damage} || {R, #playerDamageInfo{player_id = PlayerID, damage = Damage}} <- RankList],
	ItemMsg = [#pk_itemInfo{itemID = I, count = N, multiple = 1, bindState = B} || {I, N, B, _E} <- ItemList],
	EqMsg = [eq:make_eq_msg(Eq) || {_, Eq} <- EqList],
	lists:foreach(fun(PlayerID) ->
		{Rank, Damage} = case lists:keyfind(PlayerID, 1, L) of
							 {_, R, D} -> {R, D};
							 ?FALSE -> {0, 0}

						 end,
		Msg = #pk_GS2U_bonfire_end{
			my_rank = Rank,
			my_guild_rank = GuildRank,
			my_damage = Damage,
			my_guild_damage = GuildDamage,
			rank_list = SendRankMsg,
			item_list = ItemMsg,
			eq_list = EqMsg
		},
		map:send(PlayerID, Msg)
				  end,
		mapdb:getMapPlayerIDList()).

%% 增加BUFF
add_inspire_buff(MyPlayerId, PBuff, WholeBuff) ->
	PBuff > 0 andalso buff_map:add_buffer2(MyPlayerId, MyPlayerId, PBuff, 0),
	[buff_map:add_buffer2(PlayerId, RoleId, PlayerId, RoleId, WholeBuff, 0) || {PlayerId, RoleId} <- mapdb:get_player_role_id_list(), WholeBuff > 0].

%% 进图BUFF检查
enter_buff_check(PlayerID) ->
	case etsBaseFunc:readRecord(?ETS_BonfireBoss, mapSup:getMapOwnerID()) of
		{} -> ok;
		#bonfire_boss{player_drink_info = PlayerDrinkInfoList, guild_t2 = WholeBuffNum} ->
			PersonBuffNum = case lists:keyfind(PlayerID, #bonfire_player_drink.player_id, PlayerDrinkInfoList) of
								?FALSE -> 0;
								#bonfire_player_drink{t1 = T1, t2 = T2} ->
									T1 + T2
							end,
			#guildDinneDrinkCfg{personalBuff = PBuff, wholeBuff = WholeBuff} = cfg_guildDinneDrink:last_row(),
			[buff_map:add_buffer2(PlayerID, PlayerID, PBuff, 0) || _ <- lists:duplicate(PersonBuffNum, 1), PBuff > 0],
			[buff_map:add_buffer2(PlayerID, PlayerID, WholeBuff, 0) || _ <- lists:duplicate(WholeBuffNum, 1), WholeBuff > 0]
	end.

%% BOSS阶段检查
check_boss_stage() ->
	Week = time:day_of_week(time:get_localtime()),
	case cfg_dinnerBossBase:getRow(Week) of
		#dinnerBossBaseCfg{bossStage = BossStageList, stageBossEvent = BossEvent, stageCollection = CollEvent, collectionPos = CollPos} ->
			{_, StageNum} = common:getValueByInterval(get_boss_hp_percent() * 100, BossStageList, {0, 0}),
			HasStage = get_boss_stage(),
			case StageNum =/= 0 andalso StageNum > HasStage of
				?TRUE ->
					set_boss_stage(StageNum),
					set_stage_change_flag(?TRUE),
					stage_event(StageNum, BossEvent, CollEvent, CollPos);
				_ -> skip
			end;
		_ ->
			?LOG_ERROR("no cfg key ~p", [Week]),
			skip
	end.

%% 阶段事件
stage_event(Stage, BossEvent, CollEvent, CollPos) ->
	case lists:keyfind(Stage, 1, BossEvent) of
		{_, WdTime, SayIndex} ->
			MonsterID = get_boss_uid(),
			case mapdb:getMonster(MonsterID) of
				{} ->
					?LOG_ERROR("no monster data");
				Monster ->
					monsterMgr:onObjectLeaveFight(MonsterID, MonsterID),
					mapdb:updateMonster(Monster#mapMonster{group = 0}),
					df:reset_relation_cache(),
					mapView:broadcast(#pk_GS2U_MonsterList{info_list = [map:makeLookInfoMonster(MonsterID)]}),
					buff_map:add_buffer(MonsterID, MonsterID, MonsterID, MonsterID, 30074, 0),
					ok
			end,
			set_in_stage_time(?TRUE),
			mapView:broadcast(#pk_GS2U_bonfire_boss_say{index = SayIndex}),
			erlang:send_after(WdTime * 1000, self(), {bonfire_boss_msg, {stage_event_end}});
		_ -> skip
	end,
	[[collection:addCollection(CollID, X, Z, R, 0, 0, 0, DecInterval, DecPer) || {ID, X, Z, R} <- CollPos, ID =:= CollID]
		|| {Stg, CollID, DecInterval, DecPer} <- CollEvent, Stg =:= Stage].

guild_award_settle(RankList) ->
	Week = time:day_of_week(time:get_localtime()),
	{HurtList, WorldLvList} = case cfg_dinnerBossBase:getRow(Week) of
								  #dinnerBossBaseCfg{hurtOrder = L1, wLOrder = L2} ->
									  {L1, L2};
								  _ ->
									  ?LOG_ERROR("no cfg key ~p", [Week]),
									  {[], []}
							  end,
	WorldLvIndex = common:get_range_index(world_level:get_world_level(), WorldLvList, 1),
	AwardList = case cfg_dinnerBossAward:getRow(WorldLvIndex, Week) of
					#dinnerBossAwardCfg{bossAward = R} -> R;
					_ ->
						?LOG_ERROR("no award cfg key ~p", [{WorldLvIndex, Week}]),
						[]
				end,
	lists:foreach(fun({R, #playerDamageInfo{player_id = PlayerID, career = Career}}) ->
		RankIndex = common:get_range_index(R, HurtList, 5),
		ItemList = [{CfgId, Amount, Bind, 0} || {Index, DropCareer, 1, CfgId, Bind, Amount} <- AwardList, Index =:= RankIndex andalso (DropCareer =:= 0 orelse DropCareer =:= Career)],
		CurrencyList = [{CfgId, Amount} || {Index, DropCareer, 2, CfgId, _Bind, Amount} <- AwardList, Index =:= RankIndex andalso (DropCareer =:= 0 orelse DropCareer =:= Career)],
		Language = language:get_player_language(PlayerID),
		map:send_mail(PlayerID, #mailInfo{
			player_id = PlayerID,
			title = language:get_server_string("GuildDinnerMail1", Language),
			describe = language:get_server_string("GuildDinnerMail2", Language),
			coinList = [#coinInfo{type = CoinType, num = CoinNum, reason = ?REASON_Bonfire_Boss_Person_Rank} || {CoinType, CoinNum} <- CurrencyList],
			itemList = [#itemInfo{itemID = ItemID, num = Count, isBind = IsBind} || {ItemID, Count, IsBind, _ExpireTime} <- ItemList],
			attachmentReason = ?REASON_Bonfire_Boss_Person_Rank,
			isDirect = 0
		}),
		map:sendMsgToPlayerProcess(PlayerID, {setPlayerVariantBit, ?Variable_player_reset_Enter, ?Variable_player_reset_Enter_Bit10, 1}),
		player_offevent:save_offline_event(PlayerID, ?Offevent_Type_Attainments, {attainment_addprogress, ?Attainments_Type_BonfireCount, {1}})
				  end, RankList),
	ok.

guild_top_msg_sync(Msg, AllRank) ->
	{Rank, Damage} = case lists:keyfind(mapSup:getMapOwnerID(), 1, AllRank) of
						 {_, R, D} -> {R, D};
						 _ -> {0, 0}
					 end,
	mapView:broadcast_client(#pk_GS2U_bonfire_guild_rank_sync{
		my_rank = Rank,
		my_damage = Damage,
		rank_list = Msg
	}).

%% 阶段结束同步
stage_event_end() ->
	MonsterID = get_boss_uid(),
	case mapdb:getMonster(MonsterID) of
		{} ->
			?LOG_ERROR("no monster data");
		Monster ->
			monsterMgr:onObjectLeaveFight(MonsterID, MonsterID),
			mapdb:updateMonster(Monster#mapMonster{group = Monster#mapMonster.groupBorn}),
			df:reset_relation_cache(),
			mapView:broadcast([#pk_GS2U_MonsterList{info_list = [map:makeLookInfoMonster(MonsterID)]}, #pk_GS2U_bonfire_boss_event_end{}]),
			buff_map:remove_buff(MonsterID, MonsterID, 30074),
			ok
	end,
	set_in_stage_time(?FALSE),
	collection:killAllCollections(),
	erase(?CollTimes).


%% 红包检查
%%check_envelope(1, #bonfire_player_drink{t1 = T1, player_id = PlayerId}) ->
%%	#guildDinneDrinkCfg{drinkToRedpacketNum = N} = cfg_guildDinneDrink:getRow(1),
%%	[send_envelope(PlayerId, 1) || T1 rem N =:= 0];
%%
%%check_envelope(2, #bonfire_player_drink{t2 = T2, player_id = PlayerId}) ->
%%	#guildDinneDrinkCfg{drinkToRedpacketNum = N} = cfg_guildDinneDrink:getRow(2),
%%	[send_envelope(PlayerId, 2) || T2 rem N =:= 0].
%%
%%%% 触发红包
%%send_envelope(PlayerId, Index) ->
%%	#guildDinneDrinkCfg{redPacket = {Money, Number}, drinkPasswords = StrList} = cfg_guildDinneDrink:getRow(Index),
%%	GuildId = mapSup:getMapOwnerID(),
%%	Cmd = get_red_envelope_cmd(StrList, PlayerId),
%%	RedEnvelop = #guildRedEnvelope{
%%		guildId = GuildId,
%%		type = 1,
%%		cmd = Cmd,
%%		money = Money,
%%		rest_number = Number,
%%		rest_money = Money,
%%		number = Number,
%%		sender_id = PlayerId,
%%		text = "",
%%		sender_name = mirror_player:get_player_name(PlayerId)
%%	},
%%	red_envelopeSup ! {camp_red_envelope, RedEnvelop, self()},
%%	ok.
%%
%%get_red_envelope_cmd(StrList, StrPlayerId) ->
%%	try
%%		StrIndex = common:list_rand(StrList),
%%		Language = language:get_player_language(StrPlayerId),
%%		Name = mirror_player:get_player_name(StrPlayerId),
%%		ShortName = lists:reverse(lists:sublist(lists:reverse(Name), 2)),
%%		Str = language:format(language:get_tongyong_string(StrIndex, Language), [ShortName]),
%%		Cmd = unicode:characters_to_list(Str),
%%		Cmd
%%	catch
%%		Class:ExcReason:Stacktrace ->
%%			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
%%			""
%%	end.

bonfire_boss_start() ->
	map:sendMsgToPlayerProcess({game_ac_join, ?OpenAction_BonfireBoss}).