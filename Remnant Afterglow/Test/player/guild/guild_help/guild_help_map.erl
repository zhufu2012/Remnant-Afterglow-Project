%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 25. 4月 2020 13:50
%%%-------------------------------------------------------------------
-module(guild_help_map).
-author("suw").

-include("record.hrl").
-include("id_generator.hrl").
-include("gameMap.hrl").
-include("logger.hrl").
-include("guild_help.hrl").
-include("cfg_monsterBase.hrl").
-include("error.hrl").
-include("netmsgRecords.hrl").

-define(CACHE_DAMAGE, 'guild_help_cache_damage').
-define(CACHE_Monster, 'guild_help_cache_monster').
-define(CACHE_Monster_Help, 'guild_help_cache_monster_help').
-define(CACHE_AREA, 'guild_help_cache_area').
%% API
%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_player_enter/2, on_player_exit/2, on_check_helper_damage/4, handle_msg/2, handle_map_msg/1,
	on_monster_dead/2, on_tick/1, check_player_in_help/3, is_helper/2, on_monster_drop/3]).

%% 玩家消息
handle_msg(PlayerID, {player_req_help, GuildID, MapDataID, MonsterID}) ->
	player_req_help(PlayerID, GuildID, MapDataID, MonsterID);
handle_msg(PlayerID, {player_accept_help, HelpSeekerID, MapDataID, MonsterDataID}) ->
	player_accept_help(PlayerID, HelpSeekerID, MapDataID, MonsterDataID);
handle_msg(PlayerID, {get_help_damage_rank}) ->
	get_help_damage_rank(PlayerID);
handle_msg(PlayerID, {enter_boss_area, MapDataID, BossID}) ->
	enter_boss_area(PlayerID, MapDataID, BossID);
handle_msg(PlayerID, {exit_boss_area, MapDataID, BossID}) ->
	exit_boss_area(PlayerID, MapDataID, BossID);
handle_msg(PlayerID, {help_cancel, HelperIDList, MonsterDataID}) ->
	player_cancel_help(PlayerID, HelperIDList, MonsterDataID);
handle_msg(PlayerID, {help_interrupt, SeekerID, MonsterDataID}) ->
	player_interrupt_help(PlayerID, SeekerID, MonsterDataID);
handle_msg(PlayerID, Msg) ->
	?LOG_ERROR("unknow msg ~p from ~p", [Msg, PlayerID]).

%% 其他消息
handle_map_msg({player_req_help_success, PlayerID, MonsterDataID, FromPid}) ->
	player_req_help_success(PlayerID, MonsterDataID, FromPid);
handle_map_msg(Msg) ->
	?LOG_ERROR("unknow msg ~p", [Msg]).

on_tick(TimeStamp) ->
	?metrics(begin
				 MapAI = map:getMapAI(),
				 case lists:member(MapAI, ?HELP_MAP_AI) of
					 ?TRUE ->
						 SeekerList = lists:append([get_monster_cache_help(MonsterDataID) || {MonsterDataID, _} <- get_cache_monster()]),
						 lists:foreach(fun(SeekerID) ->
							 {MonsterDataID, AreaPlayerList} = get_area_player(SeekerID),
							 case MonsterDataID =/= 0 of
								 ?TRUE ->
									 Func = fun
												({_, infinity}, Ret) ->
													Ret;
												({PlayerID, LeaveTime}, Ret) when LeaveTime < TimeStamp ->
													clear_player_cache_damage(PlayerID),
													lists:keydelete(PlayerID, 1, Ret);
												(_, Ret) -> Ret
											end,
									 NewAreaPlayerList = lists:foldl(Func, AreaPlayerList, AreaPlayerList),
									 case NewAreaPlayerList =:= [] of
										 ?TRUE ->
											 case mapdb:getMapPlayer(SeekerID) of
												 #mapPlayer{helper_seeker = {SeekerID, MonsterDataId}, serverID = ServerID, helper_list = HelperList} ->
													 send_msg_2_proc(MapAI, ServerID, {cancel_request, SeekerID}),
													 player_cancel_help(SeekerID, HelperList, MonsterDataId),
													 map:send(SeekerID, #pk_GS2U_sendDemonRank{bin_fill = netmsgWrite:packNetMsgBinFill(#pk_GS2U_sendDemonRank{})});
												 _ -> skip
											 end;
%%											 send_help_seeker_damage(map:getMapAI(), SeekerID, MonsterDataID, 0),
%%											 clear_area_player(SeekerID);
										 ?FALSE ->
											 case length(AreaPlayerList) =:= length(NewAreaPlayerList) of
												 ?TRUE -> skip;
												 ?FALSE ->
													 %% 有变化同步一遍伤害
													 case mapdb:getMapPlayer(SeekerID) of
														 #mapPlayer{helper_seeker = {SeekerID, MonsterDataId}, helper_list = HelperList} ->
															 TotalDamage = get_damage_sum(HelperList),
															 send_help_seeker_damage(MapAI, SeekerID, MonsterDataId, TotalDamage);
														 _ -> skip
													 end,
													 set_area_player(SeekerID, MonsterDataID, NewAreaPlayerList)
											 end
									 end;
								 ?FALSE ->
									 skip
							 end
									   end, SeekerList);
					 ?FALSE -> skip
				 end
			 end).

on_player_enter(PlayerID, MapAi) ->
	?metrics(begin
				 case lists:member(MapAi, ?HELP_MAP_AI) orelse MapAi =:= ?MapAI_WorldBoss orelse MapAi == ?MapAI_DarkLord of
					 ?TRUE ->
						 case mapdb:getMapPlayer(PlayerID) of
							 #mapPlayer{helper_seeker = {SeekerID, _}, serverID = ServerID, name = PlayerName} when SeekerID > 0 andalso SeekerID =/= PlayerID -> %% 协助者
								 case mapdb:getMapPlayer(SeekerID) of
									 #mapPlayer{helper_list = List} = Info ->
										 NewHelperList = case lists:member(PlayerID, List) of
															 ?TRUE -> List;
															 _ -> [PlayerID | List]
														 end,
										 mapdb:updateMapPlayer(SeekerID, Info#mapPlayer{helper_list = NewHelperList}),
										 map:send(SeekerID, #pk_GS2U_playerStartHelpU{playerName = PlayerName}),
										 MapAi =:= ?MapAI_WorldBoss andalso wb_map:calc_speed_up_hp_rate();
									 _ ->
										 %% 求助者不在地图 强制取消协助
										 clear_player_cache_damage(PlayerID),
										 clear_helper_flag(PlayerID),
										 send_msg_2_proc(map:getMapAI(), ServerID, {interrupt_request, PlayerID})
								 end;
							 _ ->
								 skip
						 end;
					 _ ->
						 skip
				 end,
				 ok
			 end).

on_player_exit(PlayerID, MapAi) ->
	?metrics(begin
				 IsDemon = lists:member(MapAi, ?HELP_MAP_AI),
				 if
					 IsDemon ->
						 case mapdb:getMapPlayer(PlayerID) of
							 #mapPlayer{helper_seeker = {SeekerID, MonsterDataID}, serverID = ServerID} when SeekerID > 0 andalso SeekerID =/= PlayerID -> %% 协助者
								 send_msg_2_proc(MapAi, ServerID, {interrupt_request, PlayerID}),
								 clear_player_cache_damage(PlayerID),
								 clear_helper_flag(PlayerID),
								 exit_area_player(SeekerID, PlayerID, MonsterDataID),
								 case mapdb:getMapPlayer(SeekerID) of
									 #mapPlayer{helper_list = List} = Info ->
										 NewHelperList = List--[PlayerID],
										 mapdb:updateMapPlayer(SeekerID, Info#mapPlayer{helper_list = NewHelperList}),
										 send_help_seeker_damage(map:getMapAI(), SeekerID, MonsterDataID, get_damage_sum(NewHelperList));
									 _ ->
										 skip
								 end;
							 #mapPlayer{helper_seeker = {PlayerID, MonsterDataID}, helper_list = List, serverID = ServerID} -> %% 求助者
								 send_msg_2_proc(MapAi, ServerID, {cancel_request, PlayerID}),
								 lists:foreach(fun(ID) ->
									 clear_player_cache_damage(ID),
									 clear_helper_flag(ID)
											   end, List),
								 del_cache_monster(MonsterDataID, ?FALSE),
								 del_monster_help(MonsterDataID, [PlayerID]),
								 clear_area_player(PlayerID),
								 send_help_seeker_damage(map:getMapAI(), PlayerID, MonsterDataID, 0);
							 _ ->
								 skip
						 end;
					 MapAi =:= ?MapAI_WorldBoss ->
						 case mapdb:getMapPlayer(PlayerID) of
							 #mapPlayer{helper_seeker = {SeekerID, MonsterDataID}, serverID = ServerID} when SeekerID > 0 andalso SeekerID =/= PlayerID -> %% 协助者
								 send_msg_2_proc(MapAi, ServerID, {interrupt_request, PlayerID}),
								 DecDamage = get_player_cache_damage(PlayerID),
								 clear_player_cache_damage(PlayerID),
								 clear_helper_flag(PlayerID),
								 case mapdb:getMapPlayer(SeekerID) of
									 #mapPlayer{helper_list = List} = Info ->
										 NewHelperList = List--[PlayerID],
										 mapdb:updateMapPlayer(SeekerID, Info#mapPlayer{helper_list = NewHelperList}),
										 DecDamage > 0 andalso send_help_seeker_damage(map:getMapAI(), SeekerID, MonsterDataID, -DecDamage);
									 _ ->
										 skip
								 end,
								 wb_map:calc_speed_up_hp_rate();
							 #mapPlayer{helper_seeker = {PlayerID, MonsterDataID}, helper_list = List, serverID = ServerID} -> %% 求助者
								 send_msg_2_proc(MapAi, ServerID, {cancel_request, PlayerID}),
								 TotalDamage = get_damage_sum(List),
								 lists:foreach(fun(ID) ->
									 clear_player_cache_damage(ID),
									 clear_helper_flag(ID)
											   end, List),
								 del_cache_monster(MonsterDataID, ?FALSE),
								 del_monster_help(MonsterDataID, [PlayerID]),
								 clear_area_player(PlayerID),
								 TotalDamage > 0 andalso send_help_seeker_damage(map:getMapAI(), PlayerID, MonsterDataID, -TotalDamage),
								 wb_map:calc_speed_up_hp_rate();
							 _ ->
								 skip
						 end;
					 MapAi =:= ?MapAI_DarkLord ->
						 case mapdb:getMapPlayer(PlayerID) of
							 #mapPlayer{helper_seeker = {SeekerID, MonsterDataID}, serverID = ServerID} when SeekerID > 0 andalso SeekerID =/= PlayerID -> %% 协助者
								 send_msg_2_proc(MapAi, ServerID, {interrupt_request, PlayerID}),
								 DecDamage = get_player_cache_damage(PlayerID),
								 clear_player_cache_damage(PlayerID),
								 clear_helper_flag(PlayerID),
								 case mapdb:getMapPlayer(SeekerID) of
									 #mapPlayer{helper_list = List} = Info ->
										 NewHelperList = List--[PlayerID],
										 mapdb:updateMapPlayer(SeekerID, Info#mapPlayer{helper_list = NewHelperList}),
										 DecDamage > 0 andalso send_help_seeker_damage(map:getMapAI(), SeekerID, MonsterDataID, -DecDamage);
									 _ ->
										 skip
								 end;
							 #mapPlayer{helper_seeker = {PlayerID, MonsterDataID}, helper_list = List, serverID = ServerID} -> %% 求助者
								 send_msg_2_proc(MapAi, ServerID, {cancel_request, PlayerID}),
								 TotalDamage = get_damage_sum(List),
								 lists:foreach(fun(ID) ->
									 clear_player_cache_damage(ID),
									 clear_helper_flag(ID)
											   end, List),
								 del_cache_monster(MonsterDataID, ?FALSE),
								 del_monster_help(MonsterDataID, [PlayerID]),
								 clear_area_player(PlayerID),
								 TotalDamage > 0 andalso send_help_seeker_damage(map:getMapAI(), PlayerID, MonsterDataID, -TotalDamage);
							 _ ->
								 skip
						 end;
					 ?TRUE ->
						 skip
				 end,
				 ok
			 end).

%% 检查是否为协助伤害
on_check_helper_damage(TargetID, AttackerID, Damage, ?ID_TYPE_Monster) ->
	MapAI = map:getMapAI(),
	MonsterDataId = case mapdb:getMonster(TargetID) of
						#mapMonster{data_id = D} -> D;
						_ -> 0
					end,
	IsDemon = lists:member(MapAI, ?HELP_MAP_AI),
	if
		IsDemon ->
			case mapdb:getMapPlayer(AttackerID) of
				#mapPlayer{helper_seeker = {SeekerID, MonsterDataId}} when (SeekerID > 0 andalso SeekerID =/= AttackerID) -> %% 协助者
					cache_player_damage(AttackerID, Damage),
					case mapdb:getMapPlayer(SeekerID) of
						#mapPlayer{helper_seeker = {SeekerID, MonsterDataId}, helper_list = HelperList} -> %% 找到求助者
							TotalDamage = get_damage_sum(HelperList),
							send_help_seeker_damage(MapAI, SeekerID, MonsterDataId, TotalDamage);
						_ -> skip
					end,
					map:send(AttackerID, #pk_GS2U_myHelpDamage{damage = get_player_cache_damage(AttackerID)}),
					?TRUE;
				#mapPlayer{helper_seeker = {AttackerID, MonsterDataId}, helper_list = HelperList} -> %% 求助者
					cache_player_damage(AttackerID, Damage),
					TotalDamage = get_damage_sum(HelperList),
					send_help_seeker_damage(MapAI, AttackerID, MonsterDataId, TotalDamage),
					?TRUE;
				_ ->
					?FALSE
			end;
		MapAI =:= ?MapAI_WorldBoss ->
			case mapdb:getMapPlayer(AttackerID) of
				#mapPlayer{helper_seeker = {SeekerID, MonsterDataId}} when (SeekerID > 0 andalso SeekerID =/= AttackerID) -> %% 协助者
					cache_player_damage(AttackerID, Damage),
					case mapdb:getMapPlayer(SeekerID) of
						#mapPlayer{helper_seeker = {SeekerID, MonsterDataId}} -> %% 找到求助者
							Damage > 0 andalso send_help_seeker_damage(MapAI, SeekerID, MonsterDataId, Damage);
						_ -> skip
					end,
					map:send(AttackerID, #pk_GS2U_myHelpDamage{damage = get_player_cache_damage(AttackerID)}),
					?TRUE;
				#mapPlayer{helper_seeker = {AttackerID, MonsterDataId}} -> %% 求助者
					cache_player_damage(AttackerID, Damage),
					?FALSE;
				_ ->
					?FALSE
			end;
		MapAI =:= ?MapAI_DarkLord ->
			case mapdb:getMapPlayer(AttackerID) of
				#mapPlayer{helper_seeker = {SeekerID, MonsterDataId}} when (SeekerID > 0 andalso SeekerID =/= AttackerID) -> %% 协助者
					cache_player_damage(AttackerID, Damage),
					case mapdb:getMapPlayer(SeekerID) of
						#mapPlayer{helper_seeker = {SeekerID, MonsterDataId}} -> %% 找到求助者
							Damage > 0 andalso send_help_seeker_damage(MapAI, SeekerID, MonsterDataId, Damage);
						_ -> skip
					end,
					map:send(AttackerID, #pk_GS2U_myHelpDamage{damage = get_player_cache_damage(AttackerID)}),
					?TRUE;
				#mapPlayer{helper_seeker = {AttackerID, MonsterDataId}} -> %% 求助者
					cache_player_damage(AttackerID, Damage),
					?FALSE;
				_ ->
					?FALSE
			end;
		?TRUE ->
			?FALSE
	end;
on_check_helper_damage(_, _, _, _) ->
	?FALSE.

on_monster_dead(MapAI, MonsterDataID) ->
	?metrics(begin
				 case lists:member(MapAI, ?HELP_MAP_AI) orelse MapAI =:= ?MapAI_WorldBoss orelse MapAI == ?MapAI_DarkLord of
					 ?TRUE ->
						 HelpSeekerList = get_monster_cache_help(MonsterDataID),
						 lists:foreach(fun(HelpSeeker) ->
							 case mapdb:getMapPlayer(HelpSeeker) of
								 #mapPlayer{helper_seeker = {HelpSeeker, _}, helper_list = List, serverID = ServerID} -> %% 求助者
									 send_msg_2_proc(MapAI, ServerID, {monster_dead_cancel_request, HelpSeeker}),
									 lists:foreach(fun(PlayerID) ->
										 clear_player_cache_damage(PlayerID),
										 clear_helper_flag(PlayerID)
												   end, List);
								 _ ->
									 ?LOG_ERROR("no map player ~p", [HelpSeeker]),
									 skip
							 end end, HelpSeekerList),
						 del_cache_monster(MonsterDataID, ?TRUE),
						 clear_monster_help_cache(MonsterDataID);
					 _ ->
						 skip
				 end
			 end).
on_monster_drop(MapAI, MonsterDataID, DropPlayerIdList) when is_list(DropPlayerIdList) ->
	[on_monster_drop(MapAI, MonsterDataID, DropPlayerId) || DropPlayerId <- DropPlayerIdList];
on_monster_drop(MapAI, MonsterDataID, DropPlayerId) ->
	case lists:member(MapAI, ?HELP_MAP_AI) orelse MapAI =:= ?MapAI_WorldBoss orelse MapAI == ?MapAI_DarkLord of
		?TRUE ->
			case mapdb:getMapPlayer(DropPlayerId) of
				#mapPlayer{helper_seeker = {DropPlayerId, MonsterDataID}, helper_list = List, serverID = ServerID} -> %% 求助者
					HelperList = List--[DropPlayerId],
					send_msg_2_proc(MapAI, ServerID, {helper_award, DropPlayerId, [{ID, get_player_cache_damage(ID)} || ID <- HelperList]});
				_ -> skip
			end;
		_ ->
			skip
	end.

%% 检查是否为协助状态造成的伤害
check_player_in_help(_, _, ?TRUE) -> ?TRUE;
check_player_in_help(AttackerID, TargetID, Flag) ->
	MapAi = map:getMapAI(),
	case lists:member(MapAi, ?HELP_MAP_AI) orelse MapAi =:= ?MapAI_WorldBoss orelse MapAi == ?MapAI_DarkLord of
		?TRUE ->
			case mapdb:getMapPlayer(AttackerID) of
				#mapPlayer{helper_seeker = {SeekerID, MonsterDataID}} when SeekerID > 0 andalso SeekerID =/= AttackerID ->
					case mapdb:getMonster(TargetID) of
						#mapMonster{data_id = MonsterDataID} ->
							?TRUE;
						_ ->
							Flag
					end;
				_ ->
					Flag
			end;
		_ ->
			Flag
	end.

is_helper(PlayerID, MonsterDataID) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{helper_seeker = {SeekerID, MonsterDataID}} when SeekerID > 0 andalso SeekerID =/= PlayerID ->
			?TRUE;
		_ ->
			?FALSE
	end.


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 进入boss区域
enter_boss_area(PlayerID, _MapDataID, MonsterDataID) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{helper_seeker = {SeekerID, MonsterDataID}} when SeekerID > 0 -> %% 求助者或协助者
			enter_area_player(SeekerID, PlayerID, MonsterDataID);
		_ ->
			skip
	end.

%% 退出boss区域
exit_boss_area(PlayerID, _MapDataID, MonsterDataID) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{helper_seeker = {SeekerID, MonsterDataID}} when SeekerID > 0 ->%% 求助者或协助者
			exit_area_player(SeekerID, PlayerID, MonsterDataID);
		_ ->
			skip
	end.

%% 区域内协助玩家
enter_area_player(SeekerID, PlayerID, MonsterDataID) ->
	{_, OldList} = get_area_player(SeekerID),
	NewList = case lists:keytake(PlayerID, 1, OldList) of
				  ?FALSE ->
					  [{PlayerID, infinity} | OldList];
				  {_, _, Left} ->
					  [{PlayerID, infinity} | Left]
			  end,
	set_area_player(SeekerID, MonsterDataID, NewList).

exit_area_player(SeekerID, PlayerID, MonsterDataID) ->
	{_, OldList} = get_area_player(SeekerID),
	AddTime = case SeekerID =:= PlayerID of
				  ?TRUE ->
					  cfg_globalSetup:demon_OutMap(); %% 求助者伤害清空时间
				  _ ->
					  10
			  end,
	ExpireTime = time:time() + AddTime,
	NewList = case lists:keytake(PlayerID, 1, OldList) of
				  ?FALSE ->
					  [{PlayerID, ExpireTime} | OldList];
				  {_, _, Left} ->
					  [{PlayerID, ExpireTime} | Left]
			  end,
	set_area_player(SeekerID, MonsterDataID, NewList).
set_area_player(SeekerID, MonsterDataID, List) ->
	put({?CACHE_AREA, SeekerID}, {MonsterDataID, List}).
get_area_player(SeekerID) ->
	case get({?CACHE_AREA, SeekerID}) of
		?UNDEFINED ->
			{0, []};
		R -> R
	end.
clear_area_player(SeekerID) ->
	erase({?CACHE_AREA, SeekerID}).

%% 请求协助
player_req_help(PlayerID, GuildID, MapDataID, MonsterID) ->
	?metrics(begin
				 try
					 MapMonster = mapdb:getMonster(MonsterID),
					 PlayerPos = mapdb:getObjectPos(PlayerID),
					 MonsterPos = mapdb:getObjectPos(MonsterID),
					 case MapMonster =/= {} andalso MonsterPos =/= {} andalso PlayerPos =/= {} of
						 ?TRUE -> skip;
						 _ -> throw(?ErrorCode_Guild_Help_No_Object)
					 end,
					 case demon_map:is_super_boss(MonsterID) of
						 ?FALSE -> ok;
						 ?TRUE -> throw(?ERROR_Param)
					 end,
					 #mapMonster{data_id = MonsterDataID, bornX = BornX, bornY = BornY, level = Level} = MapMonster,
					 LocalMapDataId = mapSup:getMapDataID(),
					 ?CHECK_THROW(MapDataID =:= LocalMapDataId, ?ErrorCode_Guild_Help_Map),
					 #monsterBaseCfg{watchRadius = WatchRadius} = cfg_monsterBase:getRow(MonsterDataID),
					 case mapView:getDistance(PlayerPos#objectPos.x, PlayerPos#objectPos.y, MonsterPos#objectPos.x, MonsterPos#objectPos.y) >= WatchRadius of
						 ?TRUE -> throw(?ErrorCode_Guild_Help_Out_Range);
						 ?FALSE -> ok
					 end,
					 MapPlayer = mapdb:getMapPlayer(PlayerID),
					 case MapPlayer =/= {} of
						 ?TRUE -> skip;
						 _ -> throw(?ErrorCode_Guild_Help_Out_Range)
					 end,
					 case MapPlayer#mapPlayer.isMaxFatigue of
						 ?TRUE ->
							 throw(?ErrorCode_Guild_Help_Max_Fatigue);
						 ?FALSE ->
							 skip
					 end,
					 send_msg_2_proc(map:getMapAI(), MapPlayer#mapPlayer.serverID, {add_new_help_req, PlayerID, GuildID, MapDataID, map:getMapAI(), MonsterID, MonsterDataID, BornX, BornY, Level, self()})
				 catch
					 Err ->
						 map:send(PlayerID, #pk_GS2U_requestHelpRet{err = Err})
				 end
			 end).
player_req_help_success(PlayerID, MonsterDataID, FromPid) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> FromPid ! {interrupt_request, PlayerID};
		MapPlayer ->
			cache_monster_help(MonsterDataID, PlayerID),
			cache_monsters(MonsterDataID),
			mapdb:updateMapPlayer(PlayerID, MapPlayer#mapPlayer{helper_seeker = {PlayerID, MonsterDataID}, helper_list = [PlayerID]}),
			cache_player_damage(PlayerID, get_rank_damage(map:getMapAI(), PlayerID, mapSup:getMapDataID(), MonsterDataID))
	end.

%% 接受协助请求
player_accept_help(PlayerID, HelpSeekerID, MapDataID, MonsterDataID) ->
	?metrics(begin
				 LocalMapDataId = mapSup:getMapDataID(),
				 case MapDataID =:= LocalMapDataId of
					 ?TRUE ->
						 send_help_seeker_damage(map:getMapAI(), PlayerID, MonsterDataID, 0),
						 MapPlayer = mapdb:getMapPlayer(PlayerID),
						 case MapPlayer =/= {} of
							 ?TRUE ->
								 mapdb:updateMapPlayer(PlayerID, MapPlayer#mapPlayer{helper_seeker = {HelpSeekerID, MonsterDataID}, helper_list = []}),
								 case mapdb:getMapPlayer(HelpSeekerID) of
									 #mapPlayer{helper_list = List} = Info ->
										 NewHelperList = case lists:member(PlayerID, List) of
															 ?TRUE -> List;
															 _ -> [PlayerID | List]
														 end,
										 mapdb:updateMapPlayer(HelpSeekerID, Info#mapPlayer{helper_list = NewHelperList}),
										 map:getMapAI() =:= ?MapAI_WorldBoss andalso wb_map:calc_speed_up_hp_rate(),
										 %% 协助者已经在目标地图了，直接通知求助者：开始协助
										 map:send(HelpSeekerID, #pk_GS2U_playerStartHelpU{playerName = MapPlayer#mapPlayer.name});
									 _ ->
										 %% 求助者不在地图 强制取消协助
										 clear_player_cache_damage(PlayerID),
										 clear_helper_flag(PlayerID),
										 send_msg_2_proc(map:getMapAI(), MapPlayer#mapPlayer.serverID, {interrupt_request, PlayerID})
								 end;
							 _ -> skip
						 end;
					 ?FALSE -> ok
				 end
			 end).

%% 求助者取消
player_cancel_help(PlayerID, HelperIDList, MonsterDataID) ->
	?metrics(begin
				 HelpSeekerDamage = get_player_cache_damage(PlayerID),
				 DecDamage = get_damage_sum(HelperIDList),
				 lists:foreach(fun(ID) ->
					 clear_player_cache_damage(ID),
					 clear_helper_flag(ID)
							   end, [PlayerID | HelperIDList]),
				 del_cache_monster(MonsterDataID, ?FALSE),
				 del_monster_help(MonsterDataID, [PlayerID]),
				 clear_area_player(PlayerID),
				 MapAI = map:getMapAI(),
				 IsDemon = lists:member(MapAI, ?HELP_MAP_AI),
				 if
					 IsDemon ->
						 send_help_seeker_damage(MapAI, PlayerID, MonsterDataID, HelpSeekerDamage);
					 MapAI =:= ?MapAI_WorldBoss ->
						 wb_map:calc_speed_up_hp_rate(),
						 DecDamage > 0 andalso send_help_seeker_damage(MapAI, PlayerID, MonsterDataID, -DecDamage);
					 MapAI =:= ?MapAI_DarkLord ->
						 DecDamage > 0 andalso send_help_seeker_damage(MapAI, PlayerID, MonsterDataID, -DecDamage);
					 ?TRUE ->
						 skip
				 end
			 end).

%% 协助者中断
player_interrupt_help(PlayerID, SeekerID, MonsterDataID) ->
	?metrics(begin
				 DecDamage = get_player_cache_damage(PlayerID),
				 clear_player_cache_damage(PlayerID),
				 clear_helper_flag(PlayerID),
				 MapAI = map:getMapAI(),
				 IsDemon = lists:member(MapAI, ?HELP_MAP_AI),
				 case mapdb:getMapPlayer(SeekerID) of
					 #mapPlayer{helper_list = List} = Info ->
						 NewList = List -- [PlayerID],
						 mapdb:updateMapPlayer(SeekerID, Info#mapPlayer{helper_list = NewList}),
						 TotalDamage = get_damage_sum(NewList),
						 if
							 IsDemon ->
								 send_help_seeker_damage(MapAI, SeekerID, MonsterDataID, TotalDamage);
							 MapAI =:= ?MapAI_WorldBoss ->
								 wb_map:calc_speed_up_hp_rate(),
								 DecDamage > 0 andalso send_help_seeker_damage(MapAI, SeekerID, MonsterDataID, -DecDamage);
							 MapAI =:= ?MapAI_DarkLord ->
								 DecDamage > 0 andalso send_help_seeker_damage(MapAI, SeekerID, MonsterDataID, -DecDamage);
							 ?TRUE ->
								 skip
						 end;
					 _ ->
						 ok
				 end
			 end).


%% 协助伤害缓存
cache_player_damage(PlayerID, Damage) ->
	put({?CACHE_DAMAGE, PlayerID}, get_player_cache_damage(PlayerID) + Damage).
get_player_cache_damage(PlayerID) ->
	case get({?CACHE_DAMAGE, PlayerID}) of
		?UNDEFINED -> 0;
		R -> R
	end.
clear_player_cache_damage(PlayerID) ->
	erase({?CACHE_DAMAGE, PlayerID}).

%% 该怪物的求助者
get_monster_cache_help(MonsterDataID) ->
	case get({?CACHE_Monster_Help, MonsterDataID}) of
		?UNDEFINED -> [];
		R -> R
	end.
cache_monster_help(MonsterDataID, SeekerID) ->
	OldList = get_monster_cache_help(MonsterDataID),
	NewList = lists:usort([SeekerID | OldList]),
	put({?CACHE_Monster_Help, MonsterDataID}, NewList).
clear_monster_help_cache(MonsterDataID) ->
	erase({?CACHE_Monster_Help, MonsterDataID}).
del_monster_help(MonsterDataID, DelList) ->
	OldList = get_monster_cache_help(MonsterDataID),
	NewList = OldList -- DelList,
	put({?CACHE_Monster_Help, MonsterDataID}, NewList).

%% 被协助的怪物列表
get_cache_monster() ->
	case get(?CACHE_Monster) of
		?UNDEFINED -> [];
		R -> R
	end.
cache_monsters(MonsterDataID) ->
	OldList = get_cache_monster(),
	NewList = case lists:keytake(MonsterDataID, 1, OldList) of
				  ?FALSE -> [{MonsterDataID, 1} | OldList];
				  {_, {_, OldNum}, Left} -> [{MonsterDataID, OldNum + 1} | Left]
			  end,
	put(?CACHE_Monster, NewList).
del_cache_monster(MonsterDataID, IsAll) ->
	OldList = get_cache_monster(),
	NewList = case IsAll of
				  ?TRUE -> lists:keydelete(MonsterDataID, 1, OldList);
				  ?FALSE ->
					  case lists:keytake(MonsterDataID, 1, OldList) of
						  ?FALSE -> OldList;
						  {_, {_, OldNum}, Left} ->
							  NewNum = OldNum - 1,
							  case NewNum =:= 0 of
								  ?TRUE -> Left;
								  ?FALSE ->
									  [{MonsterDataID, NewNum} | Left]
							  end
					  end
			  end,
	put(?CACHE_Monster, NewList).


%% 同步伤害
send_help_seeker_damage(?MapAI_Demon, AttackerID, MonsterDataId, TotalDamage) ->
	monster_hunt_map:replace_damage_cache(MonsterDataId, AttackerID, TotalDamage),
	DamageInfo = map:get_demonsDamageInfo(AttackerID, TotalDamage),
	MapDataID = mapSup:getMapDataID(),
	demon_worker:send_2_me(MapDataID, {on_help_seeker_damage, MapDataID, MonsterDataId, DamageInfo});
send_help_seeker_damage(?MapAI_DemonCx, AttackerID, MonsterDataId, TotalDamage) ->
	monster_hunt_map:replace_damage_cache(MonsterDataId, AttackerID, TotalDamage),
	DamageInfo = map:get_demonsDamageInfo(AttackerID, TotalDamage),
	MapDataID = mapSup:getMapDataID(),
	demon_worker:send_2_me(MapDataID, {on_help_seeker_damage, MapDataID, MonsterDataId, DamageInfo});
send_help_seeker_damage(?MapAI_DemonCluster, AttackerID, MonsterDataId, TotalDamage) ->
	monster_hunt_map:replace_damage_cache(MonsterDataId, AttackerID, TotalDamage),
	DamageInfo = map:get_demonsDamageInfo(AttackerID, TotalDamage),
	MapDataID = mapSup:getMapDataID(),
	demon_server:cast_master_worker(MapDataID, {on_help_seeker_damage, MapDataID, MonsterDataId, DamageInfo});
send_help_seeker_damage(?MapAI_Pantheon, AttackerID, MonsterDataId, TotalDamage) ->
	monster_hunt_map:replace_damage_cache(MonsterDataId, AttackerID, TotalDamage),
	DamageInfo = map:get_demonsDamageInfo(AttackerID, TotalDamage),
	pantheon_mgr ! {on_help_seeker_damage, mapSup:getMapDataID(), MonsterDataId, DamageInfo};
send_help_seeker_damage(?MapAI_PantheonCluster, AttackerID, MonsterDataId, TotalDamage) ->
	monster_hunt_map:replace_damage_cache(MonsterDataId, AttackerID, TotalDamage),
	DamageInfo = map:get_demonsDamageInfo(AttackerID, TotalDamage),
	cluster:master_cast_master(pantheon_mgr, {on_help_seeker_damage, mapSup:getMapDataID(), MonsterDataId, DamageInfo});
send_help_seeker_damage(?MapAI_HolyWar, AttackerID, MonsterDataId, TotalDamage) ->
	case mapdb:getMapPlayer(AttackerID) of
		#mapPlayer{name = Name, serverID = ServerId, enter_server_name = ServerName} ->
			monster_hunt_map:replace_damage_cache(MonsterDataId, AttackerID, TotalDamage),
			holy_war:send_2_master({on_help_seeker_damage, mapSup:getMapDataID(), MonsterDataId, TotalDamage, 100, AttackerID, Name, ServerId, ServerName});
		_ -> ok
	end;
send_help_seeker_damage(?MapAI_WorldBoss, AttackerID, MonsterDataId, Damage) ->
	wb_map:on_boss_damage_help(AttackerID, MonsterDataId, Damage);
send_help_seeker_damage(?MapAI_DarkLord, AttackerID, MonsterDataId, Damage) ->
	dark_lord_map:on_boss_damage_help(AttackerID, MonsterDataId, Damage);
send_help_seeker_damage(_, _, _, _) ->
	ok.

get_damage_sum(List) ->
	lists:sum([get_player_cache_damage(PlayerID) || PlayerID <- List]).

%% 清除标记
clear_helper_flag(PlayerID) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{} = Info ->
			mapdb:updateMapPlayer(PlayerID, Info#mapPlayer{helper_list = [], helper_seeker = {}});
		_ -> skip
	end.

send_msg_2_proc(MapAi, ServerID, Msg) ->
	case MapAi of
		?MapAI_DemonCluster ->
			cluster:cast_process(demon_server, ServerID, guild_help, Msg);
		?MapAI_PantheonCluster ->
			cluster:cast_process(pantheon_mgr, ServerID, guild_help, Msg);
		?MapAI_HolyWar ->
			cluster:cast_process(holy_war, ServerID, guild_help, Msg);
		?MapAI_WorldBoss ->
			case cluster:is_opened() andalso wb_player:is_cluster_map(mapSup:getMapDataID()) of
				?TRUE ->
					cluster:cast_process(?WorldBossPID, ServerID, guild_help, Msg);
				_ ->
					guild_help:send_2_me(Msg)
			end;
		?MapAI_DarkLord ->
			cluster:cast_process(?DarkLordPid, ServerID, guild_help, Msg);
		_ ->
			guild_help:send_2_me(Msg)
	end.

%% 协助伤害列表
get_help_damage_rank(PlayerID) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{helper_list = List} when List =/= [] ->
			map:send(PlayerID, #pk_GS2U_getHelpDamageInfoRet{list = make_helper_damage(List--[PlayerID])});
		_ ->
			map:send(PlayerID, #pk_GS2U_getHelpDamageInfoRet{list = []})
	end.

make_helper_damage(List) ->
	RankList = lists:reverse(lists:keysort(2, [{ID, get_player_cache_damage(ID)} || ID <- List])),
	{_, Msg} = lists:foldl(fun({ID, Damage}, {N, Ret}) ->
		case mapdb:getMapPlayer(ID) of
			#mapPlayer{name = PlayerName} ->
				{N + 1, [#pk_helper_damage{
					playerID = ID,
					playerName = PlayerName,
					rank = N,
					damage = Damage
				} | Ret]};
			_ -> {N, Ret}
		end end, {1, []}, RankList),
	Msg.

%% 获取排行榜上的伤害
get_rank_damage(?MapAI_Demon, PlayerID, MapDataID, MonsterDataID) ->
	demon_common:get_player_rank_damage(PlayerID, MapDataID, MonsterDataID);
get_rank_damage(?MapAI_DemonCx, PlayerID, MapDataID, MonsterDataID) ->
	demon_common:get_player_rank_damage(PlayerID, MapDataID, MonsterDataID);
get_rank_damage(?MapAI_DemonCluster, PlayerID, MapDataID, MonsterDataID) ->
	demon_common:get_player_rank_damage(PlayerID, MapDataID, MonsterDataID);
get_rank_damage(?MapAI_Pantheon, PlayerID, MapDataID, MonsterDataID) ->
	pantheon:get_player_rank_damage(PlayerID, MapDataID, MonsterDataID);
get_rank_damage(?MapAI_PantheonCluster, PlayerID, MapDataID, MonsterDataID) ->
	pantheon:get_player_rank_damage(PlayerID, MapDataID, MonsterDataID);
get_rank_damage(?MapAI_HolyWar, PlayerID, MapDataID, MonsterDataID) ->
	holy_war_logic:get_player_rank_damage(PlayerID, MapDataID, MonsterDataID);
get_rank_damage(?MapAI_WorldBoss, PlayerID, _MapDataID, MonsterDataID) ->
	wb_map:get_player_rank_damage(PlayerID, MonsterDataID);
get_rank_damage(?MapAI_DarkLord, PlayerID, _MapDataID, MonsterDataID) ->
	dark_lord_map:get_player_rank_damage(PlayerID, MonsterDataID);
get_rank_damage(_, _, _, _) -> 0.
