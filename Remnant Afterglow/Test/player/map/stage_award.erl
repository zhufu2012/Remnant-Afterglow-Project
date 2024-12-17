%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2019, <COMPANY>
%%% @doc
%%%			阶段奖励 （伤害、 积分）   集火Boss
%%% @end
%%% Created : 07. 一月 2019 20:22
%%%-------------------------------------------------------------------
-module(stage_award).
-author("cbfan").

-include("record.hrl").
-include("global.hrl").
-include("error.hrl").
-include("gameMap.hrl").
-include("reason.hrl").
-include("netmsgRecords.hrl").
-include("guild.hrl").
-include("logger.hrl").
-include("cfg_monsterBase.hrl").
-include("cfg_mapsetting.hrl").
%% API
-export([on_ets_init/0, on_init/1, on_player_enter_map/1, on_get/2, on_refresh_boss/0, on_fire_boss/2, set_fired_boss/2, on_reset_stage/1]).


%% 阶段奖励进程字典
-define(MapStageAward, map_state_award).
-define(AliveMapAiList, [
	?MapAI_YanMo,
	?MapAI_ThunderFort, ?MapAI_ThunderFortCluster,
	?MapAI_GuildGuard,
	?MapAI_Melee,
	?MapAI_Battlefield,
	?MapAI_DomainFight,
	?MapAI_GuildWar,
	?MapAI_ManorWar
]).
-define(MulLineMapAi, [?MapAI_YanMo, ?MapAI_ThunderFort, ?MapAI_ThunderFortCluster, ?MapAI_Melee]).

-define(Ets_StageAward, ets_stage_award).
on_ets_init() ->
	ets:new(?Ets_StageAward, [set, public, named_table, ?ETSRC, ?ETSWC, {keypos, 1}]).

on_init(MapAi) ->
	case lists:member(MapAi, [?MapAI_ThunderFort, ?MapAI_ThunderFortCluster, ?MapAI_Melee, ?MapAI_Battlefield, ?MapAI_DomainFight]) andalso get_award_stage(MapAi) =/= [] of
		?FALSE -> skip;
		_ -> mapView:broadcast(#pk_GS2U_StageAwardNowStage{stage = 0})
	end,
	erase_fired_boss(),
	erase_award_stage(MapAi).

on_reset_stage(MapAi) ->
	case lists:member(MapAi, [?MapAI_ThunderFort, ?MapAI_ThunderFortCluster, ?MapAI_Melee, ?MapAI_Battlefield, ?MapAI_DomainFight]) of
		?FALSE -> skip;
		_ -> mapView:broadcast(#pk_GS2U_StageAwardNowStage{stage = 0})
	end,
	erase_fired_boss(),
	erase_award_stage(MapAi).

on_player_enter_map(PlayerId) ->
	MapAi = map:getMapAI(),
	case lists:member(MapAi, ?AliveMapAiList) of
		?TRUE ->
			Stage = case lists:keyfind(PlayerId, 1, get_award_stage(MapAi)) of
						{_, S} -> S;
						_ -> 0
					end,
			map:send(PlayerId, #pk_GS2U_StageAwardNowStage{stage = Stage}),
			case mapdb:getMapPlayer(PlayerId) of
				#mapPlayer{guildID = GuildId} ->
					map:send(PlayerId, #pk_GS2U_FireTheBoss{boss_id = get_fired_boss(GuildId)});
				_ ->
					skip
			end;
		_ -> skip
	end,
	case lists:member(MapAi, [?MapAI_Battlefield, ?MapAI_GuildWar]) of
		?TRUE -> on_refresh_boss(PlayerId);
		_ -> skip
	end.


%% 玩家领取阶段奖励
on_get(PlayerId, Stage) ->
	try
		MapAi = map:getMapAI(),
		StageList = get_award_stage(MapAi),

		NowStage = case lists:keyfind(PlayerId, 1, StageList) of {_, V} -> V; _ -> 0 end,
		case NowStage =:= Stage - 1 of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_HurtAwardCannotGet)
		end,
		{WorldLevel, Career, Level} = case mapdb:getMapPlayer(PlayerId) of
										  #mapPlayer{serverWorldLevel = ServerWorldLevel, career = C, level = L} ->
											  {ServerWorldLevel, C, L};
										  _ -> throw(?ErrorCode_HurtAwardCannotGet)
									  end,
		case get_drop_list(MapAi, PlayerId, WorldLevel, Level, Career, Stage) of
			{EqDrop, ItemDrop, Reason} ->
				NewStageList = lists:keystore(PlayerId, 1, StageList, {PlayerId, Stage}),
				set_award_stage(NewStageList),
				DropInfo = drop:drop(EqDrop, ItemDrop, PlayerId, Career, Level),
				{ItemList, EquipmentList, CurrencyList, _NoticeList} = DropInfo,
				#mapsettingCfg{mapAi = MapAI} = df:getMapsettingCfg(mapSup:getMapDataID()),
				IsExist = player_summary:is_player_exist(PlayerId),
				on_get_cluster(IsExist, MapAI, PlayerId, Reason, {ItemList, EquipmentList, CurrencyList}),
%%				player_item:show_get_item_dialog(PlayerId, ItemList, CurrencyList, EquipmentList, 0, 1),
				map:send(PlayerId, player_item:make_show_get_item_dialog_msg(ItemList, CurrencyList, EquipmentList, 0, 7)),
				ok;
			{ItemList, CurrencyList, EqList, Reason} ->
				NewStageList = lists:keystore(PlayerId, 1, StageList, {PlayerId, Stage}),
				set_award_stage(NewStageList),
				#mapsettingCfg{mapAi = MapAI} = df:getMapsettingCfg(mapSup:getMapDataID()),
				IsExist = player_summary:is_player_exist(PlayerId),
				on_get_cluster(IsExist, MapAI, PlayerId, Reason, {ItemList, EqList, CurrencyList}),
				map:send(PlayerId, player_item:make_show_get_item_dialog_msg(ItemList, CurrencyList, EqList, 0, 7)),
				ok;
			DropErr ->
				throw(DropErr)
		end,
		map:send(PlayerId, #pk_GS2U_GetStageAwardRet{stage = Stage})
	catch
		ErrCode -> map:send(PlayerId, #pk_GS2U_GetStageAwardRet{err_code = ErrCode, stage = Stage})
	end.

on_get_cluster(false, ?MapAI_YanMo, PlayerID, Reason, Reward) ->
	#mapPlayer{serverID = ServerId} = main:getMapPlayerCluster(PlayerID),
	mail:reward_cluster(yanmo, ServerId, PlayerID, Reason, Reward);
%% battlefield_035_00 阶段奖励
on_get_cluster(false, ?MapAI_Battlefield, PlayerID, Reason, Reward) ->
	#mapPlayer{serverID = ServerID} = main:getMapPlayerCluster(PlayerID),
	Msg = {battlefield_commonUseApply, [{mail, reward, [PlayerID, Reason, Reward]}]},
	?LOG_INFO("battlefield cast stage_award! ServerID:~w ~w", [ServerID, Msg]),
	cluster:cast(?BattlefieldPID, ServerID, Msg);
on_get_cluster(false, ?MapAI_Melee, PlayerID, Reason, Reward) ->
	#mapPlayer{serverID = ServerId} = main:getMapPlayerCluster(PlayerID),
	mail:reward_cluster(?MeleePID, ServerId, PlayerID, Reason, Reward);
on_get_cluster(false, ?MapAI_GuildWar, PlayerID, Reason, Reward) ->
	#mapPlayer{serverID = ServerId} = main:getMapPlayerCluster(PlayerID),
	mail:reward_cluster(?GuildWarPid, ServerId, PlayerID, Reason, Reward);
on_get_cluster(false, ?MapAI_ManorWar, PlayerID, Reason, Reward) ->
	#mapPlayer{serverID = ServerId} = main:getMapPlayerCluster(PlayerID),
	mail:reward_cluster(?ManorWarPid, ServerId, PlayerID, Reason, Reward);
on_get_cluster(_IsExist, _MapAI, PlayerID, Reason, Reward) ->
	mail:reward(PlayerID, Reason, Reward).

%% ===============集火BOSS部分==============
on_refresh_boss() ->
	Msg = on_refresh_boss_1(),
	mapView:broadcast(Msg).

on_refresh_boss(PlayerID) ->
	Msg = on_refresh_boss_1(),
	map:send(PlayerID, Msg).

on_refresh_boss_1() ->
	F = fun(#mapMonster{data_id = BossId, id = ObjectID}, Ret) ->
		case mapdb:isObjectDead(ObjectID, ObjectID) of
			?TRUE -> Ret;
			_ ->
				case cfg_monsterBase:row(BossId) of
					#monsterBaseCfg{type = {2, _}} -> [BossId | Ret];
					_ -> Ret
				end
		end
		end,
	BossList = lists:foldl(F, [], mapdb:getMonsterList()),
	#pk_GS2U_FireTheBossList{boss_id = BossList}.



on_fire_boss(PlayerId, BossId) ->
	try
		#mapPlayer{guildID = GuildId, guildRank = GuildRank, name = Name, sex = Sex} = mapdb:getMapPlayer(PlayerId),
		case get_fired_boss(GuildId) of
			BossId ->
				throw(ok);
			_ -> skip
		end,
		case GuildId > 0 andalso GuildRank >= ?GuildRank_ViceChairman of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_FireBossGuildRankLimit)
		end,
		case lists:keyfind(BossId, #mapMonster.data_id, mapdb:getMonsterList()) of
			#mapMonster{} -> skip;
			_ -> throw(?ErrorCode_FireBossNotExit)
		end,
		MapDataID = mapSup:getMapDataID(),
		PlayerText = richText:getPlayerText(Name, Sex),
		on_fire_boss_cluster(
			fun(Language) ->
				language:format(language:get_server_string("Jihuo_CallDesc01", Language), [
					richText:getGuildRankText(GuildRank, Language),
					PlayerText,
					language:get_map_name(MapDataID, Language),
					richText:getMonsterText(BossId, Language)
				])
			end, PlayerId, GuildId),
		Msg = #pk_GS2U_FireTheBoss{boss_id = BossId},
		IdList = [Id || #mapPlayer{id = Id, guildID = Gid} <- mapdb:getMapPlayerList(), Gid =:= GuildId],
		mapView:send_to_player_list(IdList, Msg)
	catch
		ok -> ok;
		ErrCode -> map:send(PlayerId, #pk_GS2U_GenErrorNotify{errorCode = ErrCode})
	end.

on_fire_boss_cluster(LanguageFun, PlayerID, GuildID) ->
	MapDataID = mapSup:getMapDataID(),
	case df:getMapsettingCfg(MapDataID) of
		#mapsettingCfg{mapAi = ?MapAI_Battlefield} ->
			case player_summary:is_player_exist(PlayerID) of
				true ->
					%% 本服角色沿用原有逻辑
					marquee:sendGuildNotice(0, GuildID, jihuo_CallDesc01, LanguageFun);
				_ ->
					%% battlefield_033_00 集火公告
					#mapPlayer{serverID = ServerID} = main:getMapPlayerCluster(PlayerID),
					Msg = {battlefield_commonUseApply, [{marquee, sendGuildNotice, [0, GuildID, jihuo_CallDesc01, LanguageFun]}]},
					cluster:cast(?BattlefieldPID, ServerID, Msg)
			end;
		#mapsettingCfg{mapAi = ?MapAI_GuildWar} ->
			PlayerIdList = [Id || #mapPlayer{id = Id, guildID = Gid} <- mapdb:getMapPlayerList(), Gid =:= GuildID],
			marquee:sendNoticeBroadcastInMap(PlayerIdList, GuildID, jihuo_CallDesc01, LanguageFun);
		_ ->
			%% 非指定地图沿用原有逻辑
			marquee:sendGuildNotice(0, GuildID, jihuo_CallDesc01, LanguageFun)
	end.


%%%===================================================================
%%% Internal functions
%%%===================================================================
get_drop_list(?MapAI_YanMo, PlayerId, _WorldLevel, _PlayerLevel, _PlayerCareer, Stage) ->
	yanmo_map:get_stage_award(PlayerId, Stage);
get_drop_list(?MapAI_ThunderFort, PlayerId, WorldLevel, _PlayerLevel, _PlayerCareer, Stage) ->
	thunder_fort_map:get_stage_award(PlayerId, WorldLevel, Stage);
get_drop_list(?MapAI_ThunderFortCluster, PlayerId, WorldLevel, _PlayerLevel, _PlayerCareer, Stage) ->
	thunder_fort_map:get_stage_award(PlayerId, WorldLevel, Stage);
get_drop_list(?MapAI_GuildGuard, PlayerId, _WorldLevel, _PlayerLevel, _PlayerCareer, Stage) ->
	guild_guard_map:get_stage_award(PlayerId, Stage);
get_drop_list(?MapAI_Melee, PlayerId, WorldLevel, _PlayerLevel, _PlayerCareer, Stage) ->
	mapMelee:get_stage_award(PlayerId, WorldLevel, Stage);
get_drop_list(?MapAI_Battlefield, PlayerId, WorldLevel, _PlayerLevel, _PlayerCareer, Stage) ->
	mapBattlefield:get_stage_award(PlayerId, WorldLevel, Stage);
get_drop_list(?MapAI_DomainFight, PlayerId, _WorldLevel, PlayerLevel, _PlayerCareer, Stage) ->
	domain_fight_map:get_stage_award(PlayerId, PlayerLevel, Stage);
get_drop_list(?MapAI_GuildWar, PlayerId, _WorldLevel, PlayerLevel, PlayerCareer, Stage) ->
	guild_war_map:get_stage_award(PlayerId, PlayerLevel, PlayerCareer, Stage);
get_drop_list(?MapAI_ManorWar, PlayerId, WorldLevel, _PlayerLevel, PlayerCareer, Stage) ->
	manor_war_map:get_stage_award(PlayerId, WorldLevel, PlayerCareer, Stage);
get_drop_list(_, _, _, _, _, _) -> ?ERROR_Cfg.

get_award_stage(MapAi) ->
	case lists:member(MapAi, ?MulLineMapAi) of
		?TRUE ->
			case ets:lookup(?Ets_StageAward, MapAi) of
				[{_, L} | _] -> L;
				_ -> []
			end;
		_ ->
			case get('map_state_award') of
				?UNDEFINED -> [];
				List -> List
			end
	end.
set_award_stage(List) ->
	MapAi = map:getMapAI(),
	case lists:member(MapAi, ?MulLineMapAi) of
		?TRUE -> ets:insert(?Ets_StageAward, {MapAi, List});
		_ -> put('map_state_award', List)
	end.
%%	put('map_state_award', List).
erase_award_stage(MapAi) ->
	case lists:member(MapAi, ?MulLineMapAi) of
		?TRUE -> ets:delete(?Ets_StageAward, MapAi);
		_ -> erase('map_state_award')
	end.

%%	erase('map_state_award').

get_fired_boss(GuildId) ->
	List = case get('map_fired_boss') of
			   ?UNDEFINED -> [];
			   L -> L
		   end,
	case lists:keyfind(GuildId, 1, List) of
		{_, BossId} -> BossId;
		_ -> 0
	end.
set_fired_boss(GuildId, BossId) ->
	List = case get('map_fired_boss') of
			   ?UNDEFINED -> 0;
			   L -> L
		   end,
	put('map_fired_boss', [{GuildId, BossId} | List]).

erase_fired_boss() -> erase('map_fired_boss').