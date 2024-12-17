%%%-------------------------------------------------------------------
%%% @author xiexiaobo@d-game.cn
%%% @copyright (C) 2020, DoubleGame
%%% @doc
%%% 地图宠物
%%% @end
%%% Created : 2020-01-22 10:00
%%%-------------------------------------------------------------------
-module(map_pet).
-author('xiexiaobo@d-game.cn').

%% API
-export([enter_map/3, leave_map/1, get_pet_obj_id_list/1, get_pet_obj_id_list/2, leave_map/2]).
-export([refresh_aid_relation/2, get_aid_pet_uid/2]).
-export([to_pk_map_pet/2]).
-export([overwrite_is_fight_flag/3, get_is_fight_flag/3, get_pet_obj_list/1]).

-include("global.hrl").
-include("record.hrl").
-include("attribute.hrl").
-include("gameMap.hrl").
-include("netmsgRecords.hrl").

%%%===================================================================
%%% API
%%%===================================================================

enter_map(Id, PetObjectId, SkillList) ->
	skill_map:map_skill_init(Id, PetObjectId, SkillList),
	mapdb:setObjectHp(Id, PetObjectId, mapdb:getObjectHpMax(Id, PetObjectId)),
	mapdb:setObjectRage(Id, PetObjectId, 1),
	ok.

leave_map(Id) ->
	case mapdb:getMapPlayer(Id) of
		{} ->
			case mapdb:getMapMirrorPlayer(Id) of
				{} -> 0;
				#mapMirrorPlayer{pet_infos = PetInfos} ->
					[leave_map(Id, Pet#map_pet.object_id) || Pet <- PetInfos]
			end;
		#mapPlayer{pet_infos = PetInfos} ->
			[leave_map(Id, Pet#map_pet.object_id) || Pet <- PetInfos]
	end.
leave_map(Id, PetObjectId) ->
	mapdb:deleteObjectRage(Id, PetObjectId),
	mapdb:deleteObjectHp(Id, PetObjectId),
	mapdb:on_exit_clean_dict(Id, PetObjectId),
	erase_is_fight_flag_overwrite(Id, PetObjectId),
	ok.

get_pet_obj_id_list(ObjectId) ->
	get_pet_obj_id_list(ObjectId, ?FALSE).
get_pet_obj_id_list(#mapPlayer{pet_infos = PetInfos}, CheckIsFight) ->
	[ObjectID || #map_pet{object_id = ObjectID, is_fight = IsFight} <- PetInfos, not CheckIsFight orelse IsFight =:= 1];
get_pet_obj_id_list(#mapMirrorPlayer{pet_infos = PetInfos}, CheckIsFight) ->
	[ObjectID || #map_pet{object_id = ObjectID, is_fight = IsFight} <- PetInfos, not CheckIsFight orelse IsFight =:= 1];
get_pet_obj_id_list(ObjectId, CheckIsFight) ->
	case mapdb:getMapPlayer(ObjectId) of
		{} ->
			case mapdb:getMapMirrorPlayer(ObjectId) of
				{} -> [];
				MapMirrorPlayer -> get_pet_obj_id_list(MapMirrorPlayer, CheckIsFight)
			end;
		MapPlayer -> get_pet_obj_id_list(MapPlayer, CheckIsFight)
	end.

get_pet_obj_list(ObjectId) ->
	case mapdb:getMapPlayer(ObjectId) of
		{} ->
			case mapdb:getMapMirrorPlayer(ObjectId) of
				{} -> [];
				MapMirrorPlayer -> MapMirrorPlayer#mapMirrorPlayer.pet_infos
			end;
		MapPlayer -> MapPlayer#mapPlayer.pet_infos
	end.

refresh_aid_relation(Id, RelationMaps) ->
	OldRelationMaps = pet_aid_relation(Id),
	pet_aid_relation(Id, RelationMaps),
	ExitUidList = maps:values(OldRelationMaps) -- maps:values(RelationMaps),
	[leave_map(Id, Uid) || Uid <- ExitUidList, Uid > 0].

get_aid_pet_uid(Id, Uid) ->
	%% #{主站=>援战}
	Maps = pet_aid_relation(Id),
	maps:get(Uid, Maps, Uid).

to_pk_map_pet(PlayerId, MapPets) ->
	case lists:member(map:getMapAI(), [?MapAI_ManorWar]) of
		?TRUE ->
			LeaderId = map_role:get_leader_id(PlayerId),
			case transform:is_chariot_obj(PlayerId, LeaderId) of
				?TRUE -> [];
				?FALSE -> pet_battle:to_pk_map_pet(PlayerId, MapPets)
			end;
		?FALSE -> pet_battle:to_pk_map_pet(PlayerId, MapPets)
	end.

overwrite_is_fight_flag(ObjectID, Uid, Flag) ->
	case mapdb:getMapPlayer(ObjectID) of
		{} ->
			case mapdb:getMapMirrorPlayer(ObjectID) of
				{} -> 0;
				#mapMirrorPlayer{pet_infos = PetInfos} ->
					case lists:keyfind(Uid, #map_pet.object_id, PetInfos) of
						?FALSE -> ok;
						#map_pet{is_fight = 1} -> ok; %% 本身就上阵的无需处理
						_ ->
							is_fight_flag_overwrite(ObjectID, Uid, Flag),
							Msg = #pk_GS2U_map_pet_info_update{player_id = ObjectID, pet_infos = map_pet:to_pk_map_pet(ObjectID, PetInfos)},
							mapView:broadcastByView(Msg, ObjectID, 0)
					end
			end;
		#mapPlayer{pet_infos = PetInfos} ->
			case lists:keyfind(Uid, #map_pet.object_id, PetInfos) of
				?FALSE -> ok;
				#map_pet{is_fight = 1} -> ok;%% 本身就上阵的无需处理
				_ ->
					is_fight_flag_overwrite(ObjectID, Uid, Flag),
					Msg = #pk_GS2U_map_pet_info_update{player_id = ObjectID, pet_infos = map_pet:to_pk_map_pet(ObjectID, PetInfos)},
					mapView:broadcastByView(Msg, ObjectID, 0)
			end
	end.

get_is_fight_flag(ObjectID, Uid, NowFlag) ->
	case get({?MODULE, pet_fight_flag_overwrite, ObjectID, Uid}) of
		?UNDEFINED -> NowFlag;
		SetFlag -> SetFlag
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================
pet_aid_relation(Id) ->
	?P_DIC_GET(Id, #{}).
pet_aid_relation(Id, Maps) ->
	?P_DIC_PUT(Id, Maps).

is_fight_flag_overwrite(ObjectID, Uid, Flag) ->
	put({?MODULE, pet_fight_flag_overwrite, ObjectID, Uid}, Flag).
erase_is_fight_flag_overwrite(ObjectID, Uid) ->
	erase({?MODULE, pet_fight_flag_overwrite, ObjectID, Uid}).


