%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc PK规则
%%% @end
%%% Created : 2018-05-28 10:00
%%%-------------------------------------------------------------------
-module(pk_rule).
-include("cfg_mapsetting.hrl").
-include("id_generator.hrl").
-include("netmsgRecords.hrl").
-include("global.hrl").
-include("record.hrl").
-include("logger.hrl").
-include("gameMap.hrl").

-define(CAMP_RELATION_0, 0). %% 0:己方
-define(CAMP_RELATION_1, 1). %% 1:友方
-define(CAMP_RELATION_2, 2). %% 2:敌对
-define(CAMP_RELATION_3, 3). %% 3:中立
-define(CAMP_RELATION_4, 4). %% 4:队友关系
-define(CAMP_RELATION_5, 5). %% 5:自己

-define(PK_MODE_1, 1). %% 和平模式：不能攻击任何人
-define(PK_MODE_2, 2). %% 友方模式：不能攻击队友和盟友
-define(PK_MODE_3, 3). %% 全体模式：可以攻击任何人
-define(PK_MODE_4, 4). %% 跨服模式：不能攻击本服玩家
-define(PK_MODE_5, 5). %% 入侵模式：跨服活动中进攻方使用，可攻击自己入侵的对应服务器的玩家（去往非本服的其他服务器，不可攻击其他入侵玩家，不会与防守模式同时出现）
-define(PK_MODE_6, 6). %% 防守模式：跨服活动中防守方使用，可攻击入侵到本服的玩家（在本服防御其他服玩家使用，不会与入侵模式同时出现）

%% TODO 跨服模式、入侵模式、防守模式

%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_player_enter/1, on_player_leave/1]).
-export([on_player_change_mode/2]).
-export([is_object_relation/7, select_relation_objects/5]).
-export([get_relation/1]).

%% 玩家进入离开地图
on_player_enter(PlayerId) ->
	case map:getMapAI() of
		?MapAI_ClientDungeons -> ok;
		?MapAI_MainlineGuide -> ok;
		?MapAI_51 -> ok;
		?MapAI_52 -> ok;
		_ ->
			MapSettingCfg = get_map_setting_cfg(),
			case is_use_mode(MapSettingCfg) of
				?TRUE -> %% 不启用强制模式
					Mode = get_default_mode(MapSettingCfg),
					set_mode(MapSettingCfg, PlayerId, Mode, ?TRUE),
					send_mode(PlayerId);
				?FALSE -> ok
			end
	end.
%%
on_player_leave(PlayerId) ->
	erase_mode(PlayerId).

%% 玩家改变模式
on_player_change_mode(PlayerId, Mode) ->
	MapSettingCfg = get_map_setting_cfg(),
	case is_use_mode(MapSettingCfg) of
		?TRUE ->
			set_mode(MapSettingCfg, PlayerId, Mode, ?FALSE),
			broadcast_mode(PlayerId);
		?FALSE -> ok
	end.

%% 阵营关系判断，返回?TRUE|?FALSE
is_object_relation(ObjectType, ObjectId, ObjectIdRoleID, TargetObjectType, TargetObjectId, TargetRoleID, CampRelation) ->
	MapSettingCfg = get_map_setting_cfg(),
	IsUseMode = is_use_mode(MapSettingCfg),
	ObjectLeaderId = mapdb:getTeamLeaderID(ObjectType, ObjectId),
	TObjectLeaderId = mapdb:getTeamLeaderID(TargetObjectType, TargetObjectId),
	is_object_relation(IsUseMode, ObjectLeaderId, ObjectIdRoleID, TObjectLeaderId, TargetRoleID, CampRelation).

%% 通过阵营关系选择对象，返回NewTargetObjectIdList
select_relation_objects(ObjectType, ObjectId, ObjectIdRoleId, TargetRoleIdList, CampRelation) ->
	MapSettingCfg = get_map_setting_cfg(),
	IsUseMode = is_use_mode(MapSettingCfg),
	ObjectLeaderId = mapdb:getTeamLeaderID(ObjectType, ObjectId),
	lists:filter(
		fun({TargetId, RoleId}) ->
			TLeaderId = mapdb:getTeamLeaderID(TargetId),
			is_object_relation(IsUseMode, ObjectLeaderId, ObjectIdRoleId, TLeaderId, RoleId, CampRelation)
		end, TargetRoleIdList).


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 玩家模式
put_mode(PlayerId, Mode) ->
	put({pk_rule_mode, PlayerId}, Mode).
get_mode(PlayerId) ->
	case get({pk_rule_mode, PlayerId}) of
		?UNDEFINED -> ?PK_MODE_1;
		Mode -> Mode
	end.
erase_mode(PlayerId) ->
	erase({pk_rule_mode, PlayerId}).

get_map_setting_cfg() ->
	MapDataID = mapSup:getMapDataID(),
	df:getMapsettingCfg(MapDataID).

%% 设置模式
set_mode(MapSettingCfg, PlayerId, Mode, IsCheck) ->
	case IsCheck orelse is_valid_mode(MapSettingCfg, Mode) of
		?TRUE ->
			df:reset_relation_cache(),
			put_mode(PlayerId, Mode);
		?FALSE -> ok
	end.

%% 默认模式
get_default_mode(MapSettingCfg) ->
	case MapSettingCfg#mapsettingCfg.pKmode of
		[] -> ?PK_MODE_1;
		[{Mode, _Valid} | _] -> Mode
	end.

%% 是否可选
is_valid_mode(MapSettingCfg, Mode) ->
	case lists:keyfind(Mode, 1, MapSettingCfg#mapsettingCfg.pKmode) of
		?FALSE -> ?FALSE;
		{_Mode, Valid} -> Valid =:= 1
	end.

%% 是否使用模式
is_use_mode(MapSettingCfg) ->
	MapSettingCfg#mapsettingCfg.force =:= 0.

%% 发送模式
send_mode(PlayerId) ->
	Mode = get_mode(PlayerId),
	map:send(PlayerId, #pk_GS2U_pk_mode_change{player_id = PlayerId, mode = Mode}).
broadcast_mode(PlayerId) ->
	Mode = get_mode(PlayerId),
	mapView:broadcastByView(#pk_GS2U_pk_mode_change{player_id = PlayerId, mode = Mode}, PlayerId, 0).

%% 阵营关系判断
is_object_relation(IsUseMode, ObjectId, ObjectRoleId, TargetObjectId, TargetRoleId, Relation) ->
	RealRelation = get_relation(IsUseMode, ObjectId, ObjectRoleId, TargetObjectId, TargetRoleId),
	case RealRelation =:= Relation of
		?TRUE ->
			?TRUE;
		?FALSE ->
			case Relation of
				?CAMP_RELATION_0 ->
					RealRelation =:= ?CAMP_RELATION_5;
				?CAMP_RELATION_1 ->
					RealRelation =:= ?CAMP_RELATION_0 orelse RealRelation =:= ?CAMP_RELATION_4 orelse RealRelation =:= ?CAMP_RELATION_5;
				?CAMP_RELATION_4 ->
					RealRelation =:= ?CAMP_RELATION_0 orelse RealRelation =:= ?CAMP_RELATION_5;
				_ ->
					?FALSE
			end
	end.
get_relation(_IsUseMode, Id, RoleId, Id, RoleId) ->
	?CAMP_RELATION_5;
get_relation(_IsUseMode, Id, _ObjectRoleId, Id, _TargetRoleId) ->
	?CAMP_RELATION_0;
get_relation(IsUseMode, ObjectId, _ObjectRoleId, TargetObjectId, _TargetRoleId) ->
	df:get_relation_cache({IsUseMode, ObjectId, TargetObjectId}, fun get_relation/1).
%%
get_relation({IsUseMode, ObjectId, TargetObjectId}) ->
	ObjectType = id_generator:id_type(ObjectId),
	TargetObjectType = id_generator:id_type(TargetObjectId),
	case IsUseMode andalso ObjectType =:= ?ID_TYPE_Player andalso TargetObjectType =:= ?ID_TYPE_Player of
		?TRUE ->
			mode_to_relation(ObjectId, TargetObjectId);
		?FALSE ->
			case map:getMapAI() of
				?MapAI_Border ->
					ServerId = mapdb:getObjectServerID(ObjectId),
					TargetServerId = mapdb:getObjectServerID(TargetObjectId),
					get_server_relation(ServerId, TargetServerId, ?MapAI_Border);
				?MapAI_HolyWar ->
					ServerId = mapdb:getObjectServerID(ObjectId),
					TargetServerId = holy_war_map:get_object_server_id(TargetObjectId),
					get_server_relation(ServerId, TargetServerId, ?MapAI_HolyWar);
				_ ->
					%% 强制和平模式下，玩家双方为友方
					case not IsUseMode andalso ObjectType =:= ?ID_TYPE_Player andalso TargetObjectType =:= ?ID_TYPE_Player andalso map:getMapPkMode() =:= ?PKMODE_PEACE of
						?FALSE -> df:get_relation(ObjectId, TargetObjectId);
						?TRUE -> ?CAMP_RELATION_1
					end
			end
	end.

%% 模式阵营关系
mode_to_relation(ObjectId, TargetObjectId) ->
	Mode = get_mode(ObjectId),
	case Mode of
		?PK_MODE_1 -> %% 和平模式
			AttackList = red_name_map:get_attack_list(),
			case lists:keyfind({ObjectId, TargetObjectId}, 1, AttackList) of
				{_, AttackTime} ->%% 攻击反击状态
					CdTime = df:getGlobalSetupValue(redname6, 10),
					case time:time() >= AttackTime + CdTime of %% 检查是否存在反击
						?TRUE ->
							?CAMP_RELATION_3;
						_ ->
							?CAMP_RELATION_2
					end;
				_ ->
					?CAMP_RELATION_3
			end;
		?PK_MODE_2 -> %% 友方模式
			TeamId = team_map:get_object_team_id(ObjectId),
			case TeamId =/= 0 andalso TeamId =:= team_map:get_object_team_id(TargetObjectId) of
				?TRUE -> ?CAMP_RELATION_4;
				?FALSE ->
					GuildId = mapdb:getObjectGuildID(ObjectId),
					case GuildId =/= 0 andalso GuildId =:= mapdb:getObjectGuildID(TargetObjectId) of
						?TRUE -> ?CAMP_RELATION_1;
						_ -> ?CAMP_RELATION_2
					end
			end;
		?PK_MODE_3 -> %% 全体模式
			?CAMP_RELATION_2;
		?PK_MODE_4 -> %% 跨服模式
			ServerId = mapdb:getMapPlayerProperty(ObjectId, #mapPlayer.serverID),
			TargetServerId = mapdb:getMapPlayerProperty(TargetObjectId, #mapPlayer.serverID),
			get_server_relation(ServerId, TargetServerId, map:getMapAI());
		?PK_MODE_5 -> %% TODO 入侵模式
			?CAMP_RELATION_2;
		?PK_MODE_6 -> %% TODO 防守模式
			?CAMP_RELATION_2
	end.

get_server_relation(ServerId, TargetServerId, ?MapAI_Border) ->
	case ServerId =:= TargetServerId of %% orelse dragon_city_logic:is_union_relation(ServerId, TargetServerId) of
		?TRUE -> ?CAMP_RELATION_1;
		?FALSE -> ?CAMP_RELATION_2
	end;
get_server_relation(ServerId, TargetServerId, ?MapAI_HolyWar) ->
	case ServerId == TargetServerId of
		?TRUE -> ?CAMP_RELATION_1;
		?FALSE -> ?CAMP_RELATION_2
	end;
get_server_relation(ServerId, TargetServerId, _MapAI) ->
	case ServerId =:= TargetServerId of
		?TRUE -> ?CAMP_RELATION_1;
		?FALSE -> ?CAMP_RELATION_2
	end.
