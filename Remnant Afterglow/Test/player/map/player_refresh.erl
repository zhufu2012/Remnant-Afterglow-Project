%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%            玩家信息刷新到地图  玩家进程
%%% @end
%%% Created : 09. 八月 2018 10:19
%%%-------------------------------------------------------------------
-module(player_refresh).
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
-include("player_task_define.hrl").

%% API
-export([on_refresh_skill/2, on_refresh_pet_skill/0, on_refresh_buff_fix/1, on_refresh_eq/1, on_refresh_mount/1, on_refresh_wing/1, on_refresh_f_wing/0,
	on_refresh_attr/2, on_refresh_pet/0, on_refresh_mount_speed/0, on_refresh_guard/1, on_player_fresh_appearance/3, on_player_fresh_fashion/1]).
-export([on_refresh_holy/1, on_refresh_hud_show_info/0]).
-export([on_refresh_title/1, on_refresh_name/0, on_refresh_honor/1, on_refresh_lv/0,
	on_refresh_guild/0, on_refresh_task/0, on_refresh_func/0, on_refresh_vip/0, on_refresh_sex/0]).
-export([on_refresh_dungeon_state/1, on_refresh_weapon/1, on_refresh_nationality/0, on_refresh_shield/0, on_refresh_ancient_holy_eq/0, on_refresh_military/0]).
-export([on_refresh_drop_sp/0, on_refresh_element_attr/0, on_refresh_dark_point/0, on_refresh_sj_level/0, on_refresh_sj_buff/0]).
-export([on_refresh_skill_not_send/1, on_refresh_leader_id/1, on_refresh_role_create/1, on_refresh_task_item/1, on_refresh_is_fly/1]).
-export([on_refresh_weapon_show/1, on_refresh_aid_pet_attr/1, on_refresh_aid_pet_relation/0]).
-export([on_refresh_pet_attr/1]).
-export([on_refresh_rune_score/0, on_refresh_eq_drop_fix_list/1, on_refresh_eq_career_drop_fix_list/1]).
-export([
	on_player_refresh/1,on_refresh_divinity/0
]).

on_refresh_skill(RoleIdList, WithFunc) ->
	MapDataID = playerMap:getMapDataID(),
	MsgList = {skill_refresh, [{RoleId, skill_player:get_available_skill_fix_list(RoleId, MapDataID)} || RoleId <- RoleIdList], WithFunc},
	on_player_refresh(MsgList).

on_refresh_pet_skill() ->
	on_player_refresh({pet_skill_refresh, pet_battle:get_available_pet_skill_list(player:getPlayerID())}).

%% 宠物属性变化
on_refresh_pet_attr(IsSendChange) ->
	MsgList = {pet_attr_refresh, pet_battle:get_available_pet_attr(player:getPlayerID(), playerMap:getMapDataID(), attribute_player:get_player_attr()), IsSendChange},
	on_player_refresh(MsgList).

%% 援战宠物属性变化
on_refresh_aid_pet_attr(IsSendChange) ->
	MsgList = {aid_pet_attr_refresh, pet_battle:get_available_aid_pet_attr(player:getPlayerID(), playerMap:getMapDataID(), attribute_player:get_player_attr()), IsSendChange},
	on_player_refresh(MsgList).

on_refresh_aid_pet_relation() ->
	MsgList = {aid_pet_relation_refresh, pet_pos:get_aid_relation()},
	on_player_refresh(MsgList).

on_refresh_skill_not_send(RoleId) ->
	on_player_refresh({skill_refresh_ont_send, RoleId, skill_player:get_available_skill_fix_list(RoleId, playerMap:getMapDataID())}).

on_refresh_buff_fix(RoleIdList) ->
	MsgList = [{buff_fix_refresh, RoleId, role_data:get_role_element(RoleId, #role.buff_fixes)} || RoleId <- RoleIdList],
	on_player_refresh(MsgList).

on_refresh_eq(RoleId) ->
	expedition_player:player_info_change(),
	on_player_refresh({eq_refresh, RoleId, role_data:get_role_element(RoleId, #role.eq_cfg_list), eq:get_eq_pos_info(RoleId)}).

on_refresh_pet() ->
	on_player_refresh({pet_refresh, pet_battle:get_equip_pet()}).
on_refresh_mount(RoleIdList) ->
	MsgList = [{mount_refresh, RoleId, mount:get_now_used_mount(RoleId)} || RoleId <- RoleIdList],
	on_player_refresh(MsgList).
on_refresh_mount_speed() ->
	on_player_refresh({mount_speed_refresh, mount:get_max_speed()}).
on_refresh_wing(RoleID) ->
	expedition_player:player_info_change(),
	on_player_refresh({wing_refresh, RoleID, role_data:get_role_element(RoleID, #role.wing_id)}).
%% 飞翼等级变化
on_refresh_f_wing() ->
	on_player_refresh({fwing_refresh, player:getPlayerProperty(#player.fwinglevel)}).

%% 圣物变化 TODO 取圣灵装配的圣物列表
on_refresh_holy(RoleID) ->
	on_player_refresh({holy_refresh, RoleID, [role_data:get_role_element(RoleID, #role.holy_id)]}).

%% 玩家属性变化
on_refresh_attr(RoleIdList, IsSendChange) ->
	MapDataID = playerMap:getMapDataID(),
	MsgList = [{attr_refresh, RoleId, attribute_player:get_available_attr(RoleId, MapDataID), IsSendChange} || RoleId <- RoleIdList],
	on_player_refresh(MsgList).

%% 玩家称号变化
on_refresh_title(RoleID) ->
	on_player_refresh({title_refresh, RoleID, role_data:get_role_element(RoleID, #role.show_title_id)}).

%% 战盟属性职位变化
on_refresh_guild() ->
	PlayerID = player:getPlayerID(),
	GuildID = player:getPlayerProperty(#player.guildID),
	on_player_refresh({guild_refresh, GuildID, guild_pub:get_member_rank(GuildID, PlayerID), guild_pub:get_guild_name(GuildID)}).

%% 玩家改名
on_refresh_name() ->
	expedition_player:player_info_change(),
	on_player_refresh({name_refresh, player:getPlayerProperty(#player.name)}).

%% 玩家修改性别
on_refresh_sex() ->
	expedition_player:player_info_change(),
	on_player_refresh({sex_refresh, player:getPlayerProperty(#player.sex)}).

%% 玩家头衔更改
on_refresh_honor(RoleID) ->
	on_player_refresh({honor_refresh, RoleID, player_honor:get_honor_lv(RoleID)}).

%% 玩家升级
on_refresh_lv() ->
	PlayerLv = player:getLevel(),
	BuffID = case guide:is_open_action(?OpenAction_WorldLevel) of
				 ?TRUE -> world_level:get_world_level_buff(PlayerLv);
				 _ -> 0
			 end,
	expedition_player:player_info_change(),
	on_player_refresh({lv_refresh, PlayerLv, BuffID}).

%% 玩家任务变化
on_refresh_task() ->
	on_player_refresh({task_refresh, player_task:get_progress_task_list() ++ role_task:get_progress_task_list() ++ donate_roulette_player:get_active_task()}),
	player_task:on_task_item_change().

%% 玩家功能开放
on_refresh_func() ->
	on_player_refresh({func_refresh, guide:get_open_func_list()}).

%% 玩家vip变化
on_refresh_vip() ->
	on_player_refresh({vip_refresh, vip:get_vip_lv()}).

%% 玩家是否显示头衔变化
on_refresh_hud_show_info() ->
	on_player_refresh({hud_refresh, variable_player:get_value(?FixedVariant_Index_92, ?FixedVariant_Index_92_Bit_1)}).

on_refresh_dungeon_state(DungeonID) ->
	on_player_refresh({hang_state_refresh, DungeonID}).

%% 玩家国籍变化
on_refresh_nationality() ->
	on_player_refresh({nationality_refresh, player:getPlayerProperty(#player.nationality_id)}).

%% 玩家装配的神兵变化
on_refresh_weapon(RoleID) ->
	on_player_refresh({weapon_refresh, RoleID, role_data:get_role_element(RoleID, #role.weapon_list)}).

%% 玩家装配的神兵变化
on_refresh_weapon_show(RoleID) ->
	on_player_refresh({weapon_show_refresh, RoleID, role_data:get_role_element(RoleID, #role.is_show_weapon), role_data:get_role_element(RoleID, #role.weapon_list)}).

%% 玩家圣盾外显变化
on_refresh_shield() ->
	ShieldId = player:getPlayerProperty(#player.shield_id),
	on_player_refresh({shield_refresh, ShieldId}).

%% 玩家军衔变化
on_refresh_military() ->
	on_player_refresh({military_refresh, player:getPlayerProperty(#player.military_rank)}).

%% 玩家古神圣装变化
on_refresh_ancient_holy_eq() ->
	on_player_refresh({'ancient_holy_eq', player:getPlayerProperty(#player.ancient_holy_eq_id),
		player:getPlayerProperty(#player.ancient_holy_eq_enhance_level)}).

%% 玩家掉落数据变化
on_refresh_drop_sp() ->
	DropSpData = drop_sp:get_player_data(playerMap:getMapDataID()),
	on_player_refresh({drop_sp_refresh, DropSpData}).

%% 玩家圣甲等级变化
on_refresh_sj_level() ->
	on_player_refresh({sj_level_refresh, shengjia:get_sj_level()}).
on_refresh_sj_buff() ->
	on_player_refresh({sj_buff_refresh, shengjia:get_buff_list()}).

%% 玩家元素属性变化
on_refresh_element_attr() ->
	on_player_refresh({element_attr_refresh, shengwen:get_rule_prop()}).

%% 玩家暗炎值变化
on_refresh_dark_point() ->
	on_player_refresh({dark_point_refresh, dark_flame:get_dark_flame()}).

%% 领队变化
on_refresh_leader_id(RoleId) ->
	on_player_refresh({leader_refresh, RoleId}).

%% 角色变化
on_refresh_role_create(RoleID) ->
	MapDataID = playerMap:getMapDataID(),
	case MapDataID =/= 0 of
		?TRUE ->
			MapAI = playerMap:getMapAI(),
			Attribute = attribute_player:get_enter_map_attribute(MapAI, MapDataID, RoleID),
			MapRoleList = role_data:make_all_map_role(MapDataID),
			SkillIDFixList = skill_player:get_available_skill_fix_list(RoleID, MapDataID),
			AllBuff = buff_player:get_player_pre_buff(MapDataID),
			Param = {MapRoleList, Attribute, SkillIDFixList, AllBuff},
			SkillMsg = skill_player:make_player_skill_msg(role_data:get_role(RoleID)),
			player:send(SkillMsg),
			on_player_refresh({role_create_refresh, RoleID, Param});
		_ -> ok
	end.

%% 守护变化
on_refresh_guard(RoleID) ->
	on_player_refresh({guard_refresh, RoleID, role_data:get_role_element(RoleID, #role.guard_id)}).
%% 任务掉落物品限制变化
on_refresh_task_item(ItemList) ->
	on_player_refresh({task_item_refresh, ItemList}).

%% 时装刷新
on_player_fresh_fashion(RoleID) ->
	on_player_refresh({fashion_refresh, RoleID, role_data:get_role_element(RoleID, #role.fashion_id_list), role_data:get_role_element(RoleID, #role.fashion_color)}).

%% 外观刷新
on_player_fresh_appearance(RoleID, Index, Value) ->
	on_player_refresh({appearance_refresh, RoleID, Index, Value}).

%% 飞翼激活刷新
on_refresh_is_fly(RoleID) ->
	RoleWing = role_data:get_role_element(RoleID, #role.wing_id),
	IsFly = case RoleWing of
				0 -> 0;
				_ -> wing:is_fly_open(RoleWing) end,
	on_player_refresh({is_fly, RoleID, IsFly}).

%% 符文评分更新
on_refresh_rune_score() ->
	on_player_refresh({rune_score_refresh, fazhen:get_max_score()}).

%% 装备掉落转换记录更新
on_refresh_eq_drop_fix_list(Data) ->
	on_player_refresh({eq_drop_fix_list_refresh, Data}).

%% 装备职业掉落转换记录更新
on_refresh_eq_career_drop_fix_list(Data) ->
	on_player_refresh({eq_career_drop_fix_list_refresh, Data}).

%% 神威值 变化
on_refresh_divinity() ->
	RoleId = role_data:get_leader_id(),
	on_player_refresh({divinity, RoleId, career_tower_atlas:get_divinity()}).
%%%===================================================================
%%% Internal functions
%%%===================================================================

on_player_refresh([]) -> ok;
on_player_refresh(Msg) ->
	PlayerID = player:getPlayerID(),
	MapPID = get_map_pid(),
	case common:is_process_alive(MapPID) of
		?FALSE -> skip;
		?TRUE -> MapPID ! {playerRefreshNew, PlayerID, Msg}
	end.

get_map_pid() ->
	EnterMap = get(?PlayerEnterMap),
	case EnterMap of
		?UNDEFINED -> 0;
		_ -> EnterMap#playerEnterMap.map_pid
	end.