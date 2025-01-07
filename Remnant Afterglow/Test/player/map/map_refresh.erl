%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%               玩家信息刷新到地图  地图进程
%%% @end
%%% Created : 08. 八月 2018 21:07
%%%-------------------------------------------------------------------
-module(map_refresh).
-author("cbfan").

-include("logger.hrl").
-include("cfg_mapsetting.hrl").
-include("cfg_arena.hrl").
-include("variable.hrl").
-include("netmsgRecords.hrl").
-include("id_generator.hrl").
-include("globalDict.hrl").
-include("playerDefine.hrl").
-include("record.hrl").
-include("gameMap.hrl").
-include("skill.hrl").
-include("buff.hrl").

-include("error.hrl").
-include("copyMap.hrl").
-include("cfg_dungeon_Teleport.hrl").
-include("util.hrl").

-include("attribute.hrl").
-include("protocol.hrl").

%% API
-export([on_refresh/2]).
-export([
	set_check_change_fashion/2
]).

on_refresh(PlayerID, {skill_refresh, List, WithFunc}) ->
	[skill_map:map_skill_init(PlayerID, RoleId, SkillIDFixList) || {RoleId, SkillIDFixList} <- List],
	map:sendMsgToPlayerProcess(PlayerID, {do_with_func, WithFunc});
on_refresh(PlayerID, {pet_skill_refresh, PetSkillIDFixList}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{pet_infos = PetInfos} ->
			[begin
				 case lists:keyfind(PetObjectId, 1, PetSkillIDFixList) of
					 false -> skip;
					 {_, SkillIDFixList} ->
						 case get({?MapObjectHP, PlayerID, PetObjectId}) of
							 ?UNDEFINED -> map_pet:enter_map(PlayerID, PetObjectId, SkillIDFixList);
							 _ -> skill_map:map_skill_init(PlayerID, PetObjectId, SkillIDFixList)
						 end
				 end
			 end || #map_pet{object_id = PetObjectId} <- PetInfos];
		_ -> ok
	end;
on_refresh(PlayerID, {pet_attr_refresh, PetAttrList, IsSendChange}) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> ok;
		#mapPlayer{} ->
			F = fun({PetObjectId, NewAttr}) ->
				Ret = attribute_map:on_object_refresh(PlayerID, PetObjectId, NewAttr, IsSendChange),
				Ret == no_changed andalso map:sendBattleProp(mapdb:getPlayerPID(PlayerID), PlayerID, PetObjectId)
				end,
			lists:foreach(F, PetAttrList)
	end;
on_refresh(PlayerID, {aid_pet_attr_refresh, PetAttrList, IsSendChange}) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> ok;
		#mapPlayer{} ->
			F = fun({PetObjectId, NewAttr}) ->
				attribute_map:on_object_refresh(PlayerID, PetObjectId, NewAttr, IsSendChange) end,
			lists:foreach(F, PetAttrList)
	end;
on_refresh(PlayerID, {aid_pet_relation_refresh, RelationMaps}) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> ok;
		#mapPlayer{} ->
			map_pet:refresh_aid_relation(PlayerID, RelationMaps)
	end;
on_refresh(PlayerID, {skill_refresh_ont_send, RoleId, SkillIDFixList}) ->
	skill_map:map_skill_change(PlayerID, RoleId, SkillIDFixList);

on_refresh(PlayerID, {buff_fix_refresh, RoleId, BuffFixList}) ->
	case map_role:get_role(PlayerID, RoleId) of
		#mapRole{buff_fixes = BuffFixList} -> ok;
		#mapRole{} = MapRole ->
			NewMapRole = MapRole#mapRole{buff_fixes = BuffFixList},
			map_role:update_role(PlayerID, NewMapRole);
		_ -> ok
	end;

on_refresh(PlayerID, {eq_refresh, RoleId, EqList, EqPosInfo}) ->
	case map_role:get_role(PlayerID, RoleId) of
		#mapRole{look_eq_list = EqList, eq_pos_info = EqPosInfo} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{look_eq_list = EqList, eq_pos_info = EqPosInfo},
			map_role:update_role(PlayerID, NewMapRole),
			mapView:broadcastByView(#pk_GS2U_LookInfoPlayer_EqLookinfo{
				id = PlayerID,
				role_id = RoleId,
				eq_list = [#pk_EqLookInfo{itemid = ItemId, level = Lv} || {ItemId, Lv} <- EqList]
			}, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{look_eq_list = EqList, eq_pos_info = EqPosInfo},
			map_role:update_role(PlayerID, NewMapRole)
	end;
on_refresh(PlayerID, {mount_refresh, RoleID, {MountId, Star}}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{mount_id = MountId, mount_star = Star} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{mount_id = MountId, mount_star = Star},
			map_role:update_role(PlayerID, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID,
				[{#pk_LookInfoRole.mount_id, MountId, ?VALUE_uint32}, {#pk_LookInfoRole.mount_star, Star, ?VALUE_uint16}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{mount_id = MountId, mount_star = Star},
			map_role:update_role(PlayerID, NewMapRole)
	end;
on_refresh(PlayerID, {mount_speed_refresh, MaxSpeed}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{mountMaxSpeed = MaxSpeed} -> ok;
		#mapPlayer{mountMaxSpeed = OldMaxSpeed} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{mountMaxSpeed = MaxSpeed},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			case NewMapPlayer#mapPlayer.mountStatus =:= 1 andalso OldMaxSpeed =/= MaxSpeed of
				?TRUE ->
					%% 更新坐骑速度
					mapView:broadcastByView(#pk_GS2U_MountChangeStatus{playerID = PlayerID, mountStatus = 1, move_speed = MaxSpeed}, PlayerID, 0);
				_ -> skip
			end
	end;
on_refresh(PlayerID, {wing_refresh, RoleID, WingID}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{wing_id = WingID} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{wing_id = WingID},
			map_role:update_role(PlayerID, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.wing_id, WingID, ?VALUE_uint32}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{wing_id = WingID},
			map_role:update_role(PlayerID, NewMapRole)
	end;
on_refresh(PlayerID, {pet_refresh, MapPets}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{pet_infos = OldPetInfos} = OldMapPlayer ->
			case lists:member(map:getMapAI(), ?NoPetMapAIList) of
				?FALSE ->
					%%			NewMapPets = gen_map_pet_object_ids(PetInfos, MapPets),
					NewMapPlayer = OldMapPlayer#mapPlayer{pet_infos = MapPets},
					mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
					Msg = #pk_GS2U_map_pet_info_update{player_id = PlayerID, pet_infos = map_pet:to_pk_map_pet(PlayerID, MapPets)},
					mapView:broadcastByView(Msg, PlayerID, 0),
					[map_pet:leave_map(PlayerID, OldUID) || #map_pet{object_id = OldUID} <- OldPetInfos, not lists:keymember(OldUID, #map_pet.object_id, MapPets)];
				?TRUE -> skip
			end,
			ok;
		_ -> ?LOG_WARNING("error in ~p, player_id = ~p", [pet_refresh, PlayerID])
	end;
on_refresh(PlayerID, {guard_refresh, RoleID, GuardID}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{guard_id = GuardID} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{guard_id = GuardID},
			map_role:update_role(PlayerID, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.guard_id, GuardID, ?VALUE_uint32}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{guard_id = GuardID},
			map_role:update_role(PlayerID, NewMapRole)
	end;
on_refresh(PlayerID, {gd_refresh, GdID}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{gd_id = GdID} -> ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{gd_id = GdID},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;

on_refresh(PlayerID, {fwing_refresh, FWingLv}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{fwinglevel = FWingLv} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{fwinglevel = FWingLv},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			case map:isFWingState(NewMapPlayer) of
				?FALSE -> skip;
				_ ->
					Speed = wing:getfwingspeed(FWingLv),
					case NewMapPlayer#mapPlayer.mountStatus =:= 1 andalso map:isFWingOpen(NewMapPlayer) of
						?TRUE ->
							mapdb:updateMapPlayer(PlayerID, NewMapPlayer#mapPlayer{mountSpeed = Speed});
						_ ->
							case map:isFWingOpen(NewMapPlayer) of
								?TRUE ->
									mapdb:updateMapPlayer(PlayerID, NewMapPlayer#mapPlayer{mountSpeed = Speed}),
									mapdb:set_object_speed(PlayerID, Speed);
								_ -> skip
							end
					end
			end
	end;
on_refresh(PlayerID, {attr_refresh, RoleID, AttrList, IsSendChange}) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} ->
			ok;
		#mapPlayer{mountStatus = MountState, mountMaxSpeed = MountMaxSpeed, mountSpeed = Speed} = MapPlayer ->
			NewAttrList = case MountState =:= 1 of
							  ?TRUE ->
								  attribute:set_value(?P_YiDongSuDu, MountMaxSpeed, AttrList);
							  _ ->
								  case map:isFWingOpen(MapPlayer) of
									  ?TRUE -> attribute:set_value(?P_YiDongSuDu, Speed, AttrList);
									  _ -> AttrList
								  end
						  end,
			attribute_map:on_object_refresh(PlayerID, RoleID, NewAttrList, IsSendChange)
	end;
on_refresh(PlayerID, {holy_refresh, RoleID, HolyIdList}) ->
	MapPlayer = mapdb:getMapPlayer(PlayerID),
	case map_role:get_role(MapPlayer, RoleID) of
		#mapRole{holy_id_list = HolyIdList} -> ok;
		#mapRole{enable = 1} = OldMapRole ->
			NewMapRole = OldMapRole#mapRole{holy_id_list = HolyIdList},
			map_role:update_role(MapPlayer, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.holy_id_list, HolyIdList, ?VALUE_vector_uint32}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0);
		#mapRole{enable = 0} = OldMapRole ->
			NewMapRole = OldMapRole#mapRole{holy_id_list = HolyIdList},
			map_role:update_role(MapPlayer, NewMapRole)
	end;

on_refresh(PlayerID, {title_refresh, RoleID, TitleID}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{title_id = TitleID} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{title_id = TitleID},
			map_role:update_role(PlayerID, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.title_id, TitleID, ?VALUE_uint32}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{title_id = TitleID},
			map_role:update_role(PlayerID, NewMapRole)
	end;

on_refresh(PlayerID, {guild_refresh, GuildID, GuildRank, GuildName}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{guildID = GuildID, guildRank = GuildRank, guildName = GuildName} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{guildID = GuildID, guildRank = GuildRank, guildName = GuildName},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			df:reset_relation_cache(),
			RefreshList = [{#pk_LookInfoPlayer.guildID, GuildID},
				{#pk_LookInfoPlayer.guildRank, GuildRank},
				{#pk_LookInfoPlayer.guildName, GuildName}],
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, RefreshList),
			mapView:broadcastByView(Msg, PlayerID, 0),
			bonfire_boss_map:guild_id_check(NewMapPlayer)
	end;

on_refresh(PlayerID, {name_refresh, Name}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{name = Name} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{name = Name},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.name, Name}]),
			mapView:broadcastByView(Msg, PlayerID, 0),
			on_name_refresh(PlayerID, Name)
	end;

on_refresh(PlayerID, {sex_refresh, Sex}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{sex = Sex} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{sex = Sex},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.sex, Sex}]),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;

on_refresh(PlayerID, {honor_refresh, RoleID, HonorLv}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{honor_lv = HonorLv} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{honor_lv = HonorLv},
			map_role:update_role(PlayerID, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.honor_lv, HonorLv, ?VALUE_uint32}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{honor_lv = HonorLv},
			map_role:update_role(PlayerID, NewMapRole)
	end;

on_refresh(PlayerID, {lv_refresh, Level, BuffID}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{level = Level} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{level = Level},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.level, Level, ?VALUE_uint16}]),
			mapView:broadcastByView(Msg, PlayerID, 0),
			map:on_player_level_up(PlayerID, Level),
			case BuffID > 0 andalso not buff_map:is_buff_exist(PlayerID, BuffID) of
				?TRUE -> buff_map:add_buffer(PlayerID, PlayerID, BuffID, 0);
				_ -> skip
			end,
			case BuffID =:= 0 of
				?TRUE ->
					RoleIdList = map_role:get_role_id_list(NewMapPlayer),
					lists:foreach(
						fun(RoleId) ->
							buff_map:remove_sb_buff_by_type(PlayerID, RoleId, 3, 6, 10)
						end, RoleIdList);
				_ -> skip
			end,
			ok
	end;

on_refresh(PlayerID, {task_refresh, TaskList}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{drop_task_list = TaskList} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{drop_task_list = TaskList},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			ok
	end;

on_refresh(PlayerId, {func_refresh, FuncList}) ->
	case mapdb:getMapPlayer(PlayerId) of
		#mapPlayer{func_list = FuncList} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{func_list = FuncList},
			mapdb:updateMapPlayer(PlayerId, NewMapPlayer),
			ok
	end;

%% FIXME vip到期删除buff
on_refresh(PlayerID, {vip_refresh, VipLv}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{vip = VipLv} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{vip = VipLv},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			on_vip_buff_refresh(PlayerID, VipLv),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.vip, VipLv, ?VALUE_uint32}]),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;


on_refresh(PlayerID, {hud_refresh, IsShowHonor}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{showHud = IsShowHonor} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{showHud = IsShowHonor},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.showFateLevel, IsShowHonor, ?VALUE_bool}]),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;

on_refresh(PlayerID, {hang_state_refresh, DungeonID}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{hang_dungeon_id = DungeonID} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{hang_dungeon_id = DungeonID},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.hang_dungeon_id, DungeonID, ?VALUE_uint32}]),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;

on_refresh(PlayerID, {weapon_refresh, RoleID, WeaponList}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{weapon_list = WeaponList} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{weapon_list = WeaponList},
			map_role:update_role(PlayerID, NewMapRole),
			mapView:broadcastByView(#pk_GS2U_LookInfoRole_WeaponInfo{
				id = PlayerID,
				role_id = RoleID,
				weapon_list = [#pk_WeaponLookInfo{
					weapon_id = WeaponId,
					weapon_vfx = WeaponVfx,
					weapon_level = WeaponLevel,
					weapon_star = common:list_find_n(1, 1, WeaponStars, 2, 0),
					weapon_reopen = WeaponReopen,
					weapon_stars = common:to_kv_msg(WeaponStars)
				} || {WeaponId, WeaponVfx, WeaponReopen, WeaponLevel, WeaponStars} <- WeaponList]
			}, PlayerID, 0);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{weapon_list = WeaponList},
			map_role:update_role(PlayerID, NewMapRole)
	end;
on_refresh(PlayerID, {weapon_show_refresh, RoleID, IsWeaponShow, WeaponList}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{is_show_weapon = IsWeaponShow} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{is_show_weapon = IsWeaponShow},
			map_role:update_role(PlayerID, NewMapRole),
			case IsWeaponShow of
				1 ->
					mapView:broadcastByView(#pk_GS2U_LookInfoRole_WeaponInfo{
						id = PlayerID,
						role_id = RoleID,
						weapon_list = [#pk_WeaponLookInfo{
							weapon_id = WeaponId,
							weapon_vfx = WeaponVfx,
							weapon_level = WeaponLevel,
							weapon_star = common:list_find_n(1, 1, WeaponStars, 2, 0),
							weapon_reopen = WeaponReopen,
							weapon_stars = common:to_kv_msg(WeaponStars)
						} || {WeaponId, WeaponVfx, WeaponReopen, WeaponLevel, WeaponStars} <- WeaponList]
					}, PlayerID, 0);
				_ ->
					mapView:broadcastByView(#pk_GS2U_LookInfoRole_WeaponInfo{
						id = PlayerID,
						role_id = RoleID
					}, PlayerID, 0)
			end;
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{is_show_weapon = IsWeaponShow},
			map_role:update_role(PlayerID, NewMapRole)
	end;

on_refresh(PlayerID, {nationality_refresh, NationalityId}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{nationality_id = NationalityId} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{nationality_id = NationalityId},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.nationality_id, NationalityId}]),
			mapView:broadcastByView(Msg, PlayerID, 0),
			case map:getMapAI() of
				?MapAI_GuildGuard -> guild_guard_map:on_player_nationality_change(PlayerID, NationalityId);
				_ -> ok
			end
	end;

on_refresh(PlayerID, {shield_refresh, ShieldId}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{shield_id = ShieldId} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{shield_id = ShieldId},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [
				{#pk_LookInfoPlayer.shield_id, ShieldId, ?VALUE_uint32}
			]),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;

on_refresh(PlayerID, {military_refresh, Rank}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{military_rank = Rank} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{military_rank = Rank},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
%%			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.titleID, TitleID, ?VALUE_uint32}]),
%%			mapView:broadcastByView(Msg, PlayerID, 0)
	end;
%% 古神圣装
on_refresh(PlayerID, {'ancient_holy_eq', EqCfgId, EnhanceLevel}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{ancient_holy_eq_id = EqCfgId, ancient_holy_eq_enhance_level = EnhanceLevel} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{ancient_holy_eq_id = EqCfgId, ancient_holy_eq_enhance_level = EnhanceLevel},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, [{#pk_LookInfoPlayer.ancient_holy_eq_id, EqCfgId, ?VALUE_uint32},
				{#pk_LookInfoPlayer.ancient_holy_eq_enhance_level, EnhanceLevel, ?VALUE_uint32}]),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;

%% 玩家掉落数据变化
on_refresh(PlayerID, {drop_sp_refresh, DropSpData}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{drop_sp_list = DropSpData} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{drop_sp_list = DropSpData},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;

%% 圣甲等级变化
on_refresh(PlayerID, {sj_level_refresh, SJLevel}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{sj_level = SJLevel} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{sj_level = SJLevel},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;
on_refresh(PlayerID, {sj_buff_refresh, BuffList}) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> ok;
		#mapPlayer{} ->
			map_armor:on_sj_buff_change(PlayerID, BuffList)
	end;

%% 元素属性变化
on_refresh(PlayerID, {element_attr_refresh, ElementAttr}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{element_attr = ElementAttr} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{element_attr = ElementAttr},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;

%% 玩家暗炎值变化
on_refresh(PlayerID, {dark_point_refresh, DarkPoint}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{dark_point = DarkPoint} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{dark_point = DarkPoint},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;
%% 领队变化
on_refresh(PlayerID, {leader_refresh, RoleId}) ->
	map_role:set_leader_id(PlayerID, RoleId);
%% 角色创建变化
on_refresh(PlayerID, {role_create_refresh, RoleID, Param}) ->
	{MapRoleList, Attribute, SkillIDFixList, AllBuff} = Param,
	map_role:set_role_list(PlayerID, MapRoleList),
	attribute_map:on_object_enter(PlayerID, RoleID, Attribute),
	map_shield:on_enter_map(PlayerID, RoleID),
	map:setObjectRageMax(PlayerID, RoleID),
	skill_map:map_skill_init(PlayerID, RoleID, SkillIDFixList),
	{_, AllBuffIDList} = AllBuff,
	[buff_map:add_buffer2(PlayerID, RoleID, PlayerID, RoleID, BuffID, 0) || BuffID <- AllBuffIDList],
	buff_map:create_role_copy_buff(PlayerID, RoleID),
	mapdb:setObjectHpMax(PlayerID),
	mapView:refreshMapObject(PlayerID),
	%%发送最终完整属性
	map:sendBattleProp(mapdb:getPlayerPID(PlayerID), PlayerID, RoleID),
	map:sendObjectRage(PlayerID, RoleID),
	%%同步一次血量
	map:sendObjectHP(PlayerID, RoleID),
	map_shield:send_player_sd(PlayerID),
	%% 刷新自动装配的 坐骑 翅膀 称号
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{mount_id = 0, mount_star = 0, wing_id = 0, title_id = 0} ->
			skip;
		#mapRole{mount_id = MountID, mount_star = MountStar, wing_id = WingID, title_id = TitleID} ->
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID,
				[
					{#pk_LookInfoRole.mount_id, MountID, ?VALUE_uint32},
					{#pk_LookInfoRole.mount_star, MountStar, ?VALUE_uint16},
					{#pk_LookInfoRole.wing_id, WingID, ?VALUE_uint32},
					{#pk_LookInfoRole.title_id, TitleID, ?VALUE_uint32}
				]),
			mapView:broadcastByView_client(Msg, PlayerID, 0)
	end;
%% 任务掉落限制
on_refresh(PlayerID, {task_item_refresh, ItemList}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{task_item_list = ItemList} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{task_item_list = ItemList},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer),
			ok
	end;

%% 时装刷新
on_refresh(PlayerID, {fashion_refresh, RoleID, FashionIDList, FashionColor}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{fashion_id_list = FashionIDList, fashion_color = FashionColor} -> ok;
		#mapRole{enable = 1} = MapRole ->
			case get_check_change_fashion() of
				{MOD, FUN} -> CanChange = MOD:FUN(PlayerID);
				_ -> CanChange = ?TRUE
			end,
			case CanChange of
				?TRUE ->
					NewMapRole = MapRole#mapRole{fashion_id_list = FashionIDList, fashion_color = FashionColor},
					map_role:update_role(PlayerID, NewMapRole),
					Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.fashionCfgIDList, FashionIDList, ?VALUE_vector_uint32}, {#pk_LookInfoRole.fashion_color, FashionColor, ?VALUE_uint32}]),
					mapView:broadcastByView_client(Msg, PlayerID, 0);
				?FALSE -> ok
			end;
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{fashion_id_list = FashionIDList, fashion_color = FashionColor},
			map_role:update_role(PlayerID, NewMapRole)
	end;

%% 外观刷新
on_refresh(PlayerID, {appearance_refresh, RoleID, Index, Value}) ->
	MapRole = map_role:get_role(PlayerID, RoleID),
	case element(Index, MapRole) of
		Value -> ok;
		_ ->
			case MapRole of
				#mapRole{enable = 1} = MapRole ->
					NewMapRole = setelement(Index, MapRole, Value),
					map_role:update_role(PlayerID, NewMapRole),
					LookInfoRoleIndex = get_look_info_role_index(Index),
					case LookInfoRoleIndex of
						0 ->
							ok;
						_ ->
							Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{LookInfoRoleIndex, Value, ?VALUE_uint32}]),
							mapView:broadcastByView_client(Msg, PlayerID, 0)
					end;
				#mapRole{enable = 0} = MapRole ->
					NewMapRole = setelement(Index, MapRole, Value),
					map_role:update_role(PlayerID, NewMapRole)
			end
	end;
on_refresh(PlayerID, {is_fly, RoleID, IsFly}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{is_fly = IsFly} -> ok;
		#mapRole{} = MapRole ->
			NewMapRole = MapRole#mapRole{is_fly = IsFly},
			map_role:update_role(PlayerID, NewMapRole),
			Msg = map:make_LookInfoRole_update_msg(PlayerID, RoleID, [{#pk_LookInfoRole.fwingstate, IsFly, ?VALUE_uint8}]),
			mapView:broadcastByView_client(Msg, PlayerID, 0)
	end;

on_refresh(PlayerID, {rune_score_refresh, RuneScore}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{rune_score = RuneScore} ->
			ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{rune_score = RuneScore},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;
on_refresh(PlayerID, {eq_drop_fix_list_refresh, List}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{eq_drop_fix_list = List} -> ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{eq_drop_fix_list = List},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;
on_refresh(PlayerID, {eq_career_drop_fix_list_refresh, List}) ->
	case mapdb:getMapPlayer(PlayerID) of
		#mapPlayer{eq_career_drop_fix_list = List} -> ok;
		#mapPlayer{} = OldMapPlayer ->
			NewMapPlayer = OldMapPlayer#mapPlayer{eq_career_drop_fix_list = List},
			mapdb:updateMapPlayer(PlayerID, NewMapPlayer)
	end;

on_refresh(PlayerID, {up_map_player, UPList}) ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> ok;
		MapPlayer ->
			{MapPlayer2, RefreshList} = lists:foldl(
				fun({Key, Value}, {MAcc, FAcc}) ->
					MAcc2 = setelement(Key, MAcc, Value),
					case get_look_info_player_index(Key) of
						?UNDEFINED -> FAcc2 = FAcc;
						Index -> FAcc2 = [{Index, Value} | FAcc]
					end,
					{MAcc2, FAcc2}
				end, {MapPlayer, []}, UPList),
			mapdb:updateMapPlayer(PlayerID, MapPlayer2),
			Msg = map:make_LookInfoPlayer_update_msg(PlayerID, RefreshList),
			mapView:broadcastByView(Msg, PlayerID, 0)
	end;

on_refresh(PlayerID, {divinity, RoleID, Value}) ->
	case map_role:get_role(PlayerID, RoleID) of
		#mapRole{divinity = Value} -> ok;
		#mapRole{enable = 1} = MapRole ->
			NewMapRole = MapRole#mapRole{divinity = Value},
			map_role:update_role(PlayerID, NewMapRole);
		#mapRole{enable = 0} = MapRole ->
			NewMapRole = MapRole#mapRole{honor_lv = Value},
			map_role:update_role(PlayerID, NewMapRole)
	end;

on_refresh(PlayerID, Msg) ->
	?LOG_ERROR("unhandle fresh infomation :~p", [{PlayerID, Msg}]),
	ok.

%%%===================================================================
%%% Internal functions
%%%===================================================================
on_vip_buff_refresh(PlayerID, VipLv) ->
	BuffList = vip:get_vip_buff(VipLv),
	[buff_map:add_buffer(PlayerID, PlayerID, BuffID, 0) || BuffID <- BuffList].

on_name_refresh(PlayerId, Name) ->
	case map:getMapAI() of
		?MapAI_GuildGuard -> guild_guard_map:on_player_name_change(PlayerId, Name);
		?MapAI_XORoom -> xo_room:send_2_master({player_change_name, PlayerId, Name});
		_ -> skip
	end.

get_look_info_role_index(Index) ->
	case Index of
		#mapRole.hair_color ->
			#pk_LookInfoRole.hair_color_id;
		#mapRole.skin_color ->
			#pk_LookInfoRole.skin_color_id;
		#mapRole.height ->
			#pk_LookInfoRole.height;
		#mapRole.tattoo ->
			#pk_LookInfoRole.tattoo;
		#mapRole.tattoo_color ->
			#pk_LookInfoRole.tattoo_color;
		#mapRole.is_show_helmet ->
			#pk_LookInfoRole.is_show_helmet;
		_ ->
			0
	end.

gen_map_pet_object_ids(PetInfos, MapPets) ->
	F = fun(#map_pet{pet_id = PetId} = Pet) ->
		case lists:keyfind(PetId, #map_pet.pet_id, PetInfos) of
			#map_pet{object_id = ObjectId} -> Pet#map_pet{object_id = ObjectId};
			_ -> Pet
		end
		end,
	MapPets2 = lists:map(F, MapPets),
	LeftObjIds = [ObjId || #map_pet{object_id = ObjId} <- PetInfos, lists:keymember(ObjId, #map_pet.object_id, MapPets2) == ?FALSE],
	F2 = fun(#map_pet{object_id = ObjId} = Pet, {AccLeftIds, Acc}) ->
		case ObjId of
			0 ->
				case AccLeftIds of
					[PetObjectId | Left] when PetObjectId =/= 0 ->
						{Left, [Pet#map_pet{object_id = PetObjectId} | Acc]};
					_ ->
						{AccLeftIds, [Pet#map_pet{object_id = id_generator:generate(?ID_TYPE_MY_PET)} | Acc]}
				end;
			_ ->
				{AccLeftIds, [Pet | Acc]}
		end
		 end,
	{_, NewMapPets} = lists:foldl(F2, {LeftObjIds, []}, MapPets2),
	NewMapPets.

get_look_info_player_index(#mapPlayer.mate_id) ->
	#pk_LookInfoPlayer.weddingPlayerID;
get_look_info_player_index(#mapPlayer.mate_name) ->
	#pk_LookInfoPlayer.weddingPlayerName;
get_look_info_player_index(_) ->
	?UNDEFINED.

set_check_change_fashion(Mod, Fun) ->
	put(check_change_fashion_fun, {Mod, Fun}).
get_check_change_fashion() ->
	get(check_change_fashion_fun).