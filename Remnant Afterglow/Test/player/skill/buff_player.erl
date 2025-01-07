%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 25. 七月 2018 15:51
%%%-------------------------------------------------------------------
-module(buff_player).
-author("cbfan").

-include("buff.hrl").
-include("record.hrl").
-include("globalDict.hrl").
-include("netmsgRecords.hrl").
-include("record.hrl").
-include("gameMap.hrl").
-include("logger.hrl").
-include("cfg_mapsetting.hrl").
-include("cfg_buffBase.hrl").
-include("variable.hrl").
-include("db_table.hrl").
-include("cfg_mapbuff.hrl").
-include("cfg_mapherobuff.hrl").

%% API
-export([
	on_load/1,
	get_player_pre_buff/1,
	get_mirror_player_pre_buff/2,
	buff_flush/0,
	on_buff_change/0,
	on_buff_change/1,
	gm_test/1,
	send_buff_msg/0
]).
-export([db_to_buff/1, buff_to_db/1]).

%% 上架加载
on_load(?TRUE) -> ok;
on_load(?FALSE) -> put_player_buff(load_buff(player:getPlayerID())).

buff_flush() ->
	List = table_player:lookup(db_buff, player:getPlayerID()),
	put_player_buff(List).


%% 获得玩家进入地图前，准备数据的BUFF数据
get_player_pre_buff(MapDataID) ->
	OrgBuffList = get_player_buff(),
	MapSettingCfg = cfg_mapsetting:getRow(MapDataID),
	MapAi = MapSettingCfg#mapsettingCfg.mapAi,
	AddBuffIDList =
		case MapAi of
			?MapAI_YanMo -> yanmo_player:get_buff_list();
			?MapAI_CareerTower_Main -> career_tower:on_get_tower_add_buff();
			_ -> []
		end,
	PlayerLv = player:getLevel(),
	WorldLvBuff = case world_level:get_world_level_buff(PlayerLv) of
					  0 -> [];
					  WB -> [WB]
				  end,
	ClusterWorldLvBuff = case world_level:get_cluster_world_level_buff(PlayerLv) of
							 0 -> [];
							 CWB -> [CWB]
						 end,
	MapBuff = get_map_cfg_buff(MapSettingCfg),
	MapHeroBuff = get_map_cfg_hero_buff(MapSettingCfg),
	VipBuff = vip:get_vip_buff(),
	SubscribeBuff = recharge_subscribe:get_player_buff(),
	BlessBuff = quick_hang:get_bless_buff(),
%%	BorderWarBuff = dragon_city_logic:get_border_war_buff(config:server_id(), MapDataID),
	DragonBadgeBuff = dragon_badge:get_dragon_badge_buff_list(),
	LiftCardBuff = recharge_life_card:get_buff(),
	King1v1Buff = king_1v1_player:get_buff_list(),
	MarryBuff = player_wedding:get_marry_buff(),
	TeamBuff = [team_player:get_team_buff()],
	AllBuffIDList =
		case MapAi of
			?MapAI_EXPEDITION_HUNT ->
				MapBuff ++ lib_expedition_battle:get_player_battle_buff(?TRUE);
			?MapAI_EXPEDITION_CITY ->
				MapBuff ++ lib_expedition_battle:get_player_battle_buff(?TRUE);
			?MapAI_EXPEDITION_DEMONCOME ->
				MapBuff ++ lib_expedition_battle:get_player_battle_buff(?TRUE);
			?MapAI_EXPEDITION_EXPLORE ->
				MapBuff ++ lib_expedition_battle:get_player_battle_buff(?TRUE);
			_ ->
				MapBuff ++ AddBuffIDList ++ WorldLvBuff ++ VipBuff ++ TeamBuff
					++ SubscribeBuff ++ BlessBuff ++ DragonBadgeBuff ++ LiftCardBuff
					++ King1v1Buff ++ MarryBuff ++ ClusterWorldLvBuff
		end,
	BuffIdList = [I || I <- AllBuffIDList, I > 0],
	{OrgBuffList, BuffIdList, MapHeroBuff}.
get_mirror_player_pre_buff({MapDataID, ?MapAI_EXPEDITION_EXPLORE}, PlayerID) -> %% IdList
	MapSettingCfg = cfg_mapsetting:getRow(MapDataID),
	{get_map_cfg_buff(MapSettingCfg) ++ lib_expedition_battle:get_mirror_player_battle_buff(PlayerID), get_map_cfg_hero_buff(MapSettingCfg)};
get_mirror_player_pre_buff({MapDataID, _}, _) ->
	MapSettingCfg = cfg_mapsetting:getRow(MapDataID),
	{get_map_cfg_buff(MapSettingCfg), get_map_cfg_hero_buff(MapSettingCfg)}.

get_map_cfg_buff(#mapsettingCfg{buffID = []}) -> [];
get_map_cfg_buff(#mapsettingCfg{buffID = BuffIndexList}) ->
	PKeyList = cfg_mapbuff:getKeyList(),
	lists:foldl(fun(Index, Acc) ->
		#mapbuffCfg{jointService = JoinServer} = cfg_mapbuff:getRow(Index, 1),
		CfgKeyList = lists:reverse(common:list_break_filter(Index, 1, PKeyList)),
		Key = common:getValueByInterval(map_buff_world_lv(JoinServer), 2, CfgKeyList, {Index, 1}),
		#mapbuffCfg{buffID = BuffList} = cfg_mapbuff:row(Key),
		BuffList ++ Acc
				end, [], BuffIndexList).

get_map_cfg_hero_buff(#mapsettingCfg{heroBuff = []}) -> [];
get_map_cfg_hero_buff(#mapsettingCfg{heroBuff = BuffIndexList}) ->
	PKeyList = cfg_mapherobuff:getKeyList(),
	lists:foldl(fun(Index, Acc) ->
		#mapherobuffCfg{jointService = JoinServer} = cfg_mapherobuff:getRow(Index, 1),
		CfgKeyList = lists:reverse(common:list_break_filter(Index, 1, PKeyList)),
		Key = common:getValueByInterval(map_buff_world_lv(JoinServer), 2, CfgKeyList, {Index, 1}),
		#mapherobuffCfg{heroBuffID = BuffList} = cfg_mapherobuff:row(Key),
		BuffList ++ Acc
				end, [], BuffIndexList).

map_buff_world_lv(1) -> cluster_share:max_world_lv();
map_buff_world_lv(_) -> world_level:get_world_level().

%% todo 各关联系统3角色拆分
on_buff_change() ->
%%	OrnamentBuff = ornament:get_buff_list(),
	ShieldBuff = holy_shield:get_buff_list(),
%%	DivineTalentBuff = divine_talent:get_buff_list(),
	DGWeaponBuff = g_dragon_weapon:get_buff_list(),
	DGEqBuff = g_dragon_eq:get_buff_list(),
	PetSpBuff = pet_eq_and_star:get_buff_list(),
	ServerSealBuff = server_seal_player:get_player_buff(),
	PetSacredBuff = pet_sacred_eq:get_buff_list(),
	PublicBuffFixList = ShieldBuff ++ DGWeaponBuff ++ DGEqBuff ++ PetSpBuff ++ ServerSealBuff ++ PetSacredBuff,

	RoleList = role_data:get_role_list(),
	RoleIdList = [RoleID || #role{role_id = RoleID} <- RoleList],
	lists:foreach(
		fun(#role{role_id = RoleId, career = Career} = Role) ->
			SkillBuff = skill_up:get_buff_list(RoleId, Career),
			SkillFixBuff = skill_player:get_skill_buff_fix(Role),
			BuffFixList = SkillBuff ++ PublicBuffFixList ++ SkillFixBuff,
			role_data:set_role_property(RoleId, #role.buff_fixes, BuffFixList)
		end, RoleList),
	send_buff_msg(RoleIdList),
	player_refresh:on_refresh_buff_fix(RoleIdList).
on_buff_change(RoleId) ->
	Role = role_data:get_role(RoleId),
	Career = Role#role.career,
%%	OrnamentBuff = ornament:get_buff_list(),
	ShieldBuff = holy_shield:get_buff_list(),
%%	DivineTalentBuff = divine_talent:get_buff_list(),
	DGWeaponBuff = g_dragon_weapon:get_buff_list(),
	DGEqBuff = g_dragon_eq:get_buff_list(),

	SkillBuff = skill_up:get_buff_list(RoleId, Career),
	SkillFixBuff = skill_player:get_skill_buff_fix(Role),

	BuffFixList = SkillBuff ++ ShieldBuff ++ DGWeaponBuff ++ DGEqBuff ++ SkillFixBuff,
	role_data:set_role_property(RoleId, #role.buff_fixes, BuffFixList),
	send_buff_msg([RoleId]),
	player_refresh:on_refresh_buff_fix([RoleId]),
	ok.

gm_test(BuffFixList) ->
	?LOG_ERROR("buff fix replace :~p", [BuffFixList]),
	LeaderRoleId = role_data:get_leader_id(),
	role_data:set_role_property(LeaderRoleId, #role.buff_fixes, BuffFixList),
	send_buff_msg([LeaderRoleId]),
	player_refresh:on_refresh_buff_fix([LeaderRoleId]).

send_buff_msg() ->
	send_buff_msg(role_data:get_all_role_id()).
send_buff_msg(RoleId) when is_integer(RoleId) ->
	send_buff_msg([RoleId]);
send_buff_msg(RoleIdList) ->
	player:send(#pk_GS2U_MyBuffFix{
		fix_list = pack_buff_msg(RoleIdList)
	}).

pack_buff_msg(RoleIdList) ->
	F = fun(RoleId, Acc) ->
		L = [#pk_BuffFix{
			fix_type = P1,
			fix_param = P2,
			fix_id = P3
		} || {P1, P2, P3} <- role_data:get_role_element(RoleId, #role.buff_fixes)],
		L ++ Acc
		end,
	lists:foldl(F, [], RoleIdList).

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 玩家进程字段
put_player_buff(List) -> put(?PlayerBuffDBData, List).
get_player_buff() -> get(?PlayerBuffDBData).

%% 上线，从数据库载入buff, 返回#objectBuff{}
load_buff(PlayerID) ->
	OffLineTime = player:getPlayerProperty(#player.offlinetime),
	List = table_player:lookup(db_buff, PlayerID),
	lists:map(
		fun(Buff) ->
			FixDataList = [fix(BuffObj) || BuffObj <- Buff#objectBuff.dataList],
			BuffDataList = do_load_check(FixDataList, OffLineTime * 1000),
			Buff#objectBuff{dataList = BuffDataList}
		end, List).

do_load_check(BuffDataList, OffLineTime) ->
	Func1 = fun(BuffObj, Ret) ->
		case cfg_buffBase:getRow(BuffObj#buff_obj.buff_data_id) of
			#buffBaseCfg{groupID = GroupID} = Cfg ->
				[{GroupID, Cfg, BuffObj} | Ret];
			_ -> Ret
		end
			end,
	Milliseconds = time:time_ms(),
	BuffDataList1 = lists:foldl(Func1, [], BuffDataList),
	BuffDataList2 = common:group_by(BuffDataList1, 1),
	TimeLost = Milliseconds - OffLineTime,
	%% 进行中的>等级>剩余时间
	SortFunc = fun({#buffBaseCfg{level = Lv1}, #buff_obj{is_pause = IsPause1, valid_time = VT1}}, {#buffBaseCfg{level = Lv2}, #buff_obj{is_pause = IsPause2, valid_time = VT2}}) ->
		case IsPause1 =:= IsPause2 of
			?FALSE -> IsPause1 < IsPause2;
			?TRUE ->
				case Lv1 =:= Lv2 of
					?FALSE -> Lv1 > Lv2;
					?TRUE ->
						VT1 =< VT2
				end
		end
			   end,
	Func2 = fun
				({0, GroupList}, Ret) -> %% 独立分组
					load_buff_normal(GroupList, Milliseconds, OffLineTime, Ret);
				({_, [{#buffBaseCfg{replace = 2}, _} | _] = GroupList}, Ret) -> %% 可暂停分组
					load_buff_pause(lists:sort(SortFunc, GroupList), Milliseconds, OffLineTime, TimeLost, Ret);
				({_, GroupList}, Ret) -> %% 其他分组
					load_buff_normal(GroupList, Milliseconds, OffLineTime, Ret)
			end,
	lists:foldl(Func2, [], BuffDataList2).


load_buff_normal([], _Milliseconds, _OffLineTime, Ret) -> Ret;
load_buff_normal([{BuffCfg, BuffObj} | T], Milliseconds, OffLineTime, Ret) ->
	case check_load({BuffCfg, BuffObj}, Milliseconds, OffLineTime, Milliseconds - OffLineTime) of
		{continue, NewBuffObj} ->
			load_buff_normal(T, Milliseconds, OffLineTime, [NewBuffObj | Ret]);
		_ ->
			load_buff_normal(T, Milliseconds, OffLineTime, Ret)
	end.
load_buff_pause([], _Milliseconds, _OffLineTime, _TimeLost, Ret) -> Ret;
load_buff_pause([{BuffCfg, BuffObj} | T], Milliseconds, OffLineTime, TimeLost, Ret) ->
	case check_load({BuffCfg, BuffObj}, Milliseconds, OffLineTime, TimeLost) of
		{continue, NewBuffObj} -> %% 这个BUFF足以抵消TimeLost,后续按正常流程加载
			load_buff_normal(T, Milliseconds, OffLineTime, [NewBuffObj#buff_obj{is_pause = 0, is_enable = ?TRUE} | Ret]);
		{time_overflow, DecTime} -> %% 还有时间没扣完,下一个取消暂停继续扣
			load_buff_pause(next_unpause(T), Milliseconds, OffLineTime, DecTime, Ret);
		_ ->
			load_buff_pause(T, Milliseconds, OffLineTime, TimeLost, Ret)
	end.

next_unpause([]) -> [];
next_unpause([{BuffCfg, BuffObj} | T]) -> [{BuffCfg, BuffObj#buff_obj{is_pause = 0, is_enable = ?TRUE}} | T].

check_load({BuffCfg, BuffObj}, Milliseconds, OffLineTime, TimeLost) ->
	try
		#buffBaseCfg{deleteType = DelType} = BuffCfg,
		case DelType band ?OffLine_Del_Buff > 0 of ?TRUE -> throw(skip); ?FALSE -> skip end,
		#buff_obj{last_dot_effect_time = T1, last_dot_effect_time_1 = T2, last_dot_effect_time_6 = T6, is_pause = IsPause} = BuffObj,
		case BuffCfg#buffBaseCfg.isCountOfflineTime =:= 1 andalso IsPause =:= 0 of
			?TRUE ->
				case element(1, BuffObj#buff_obj.time_para) of
					0 -> BuffObj;
					_ ->
						case TimeLost >= 0 of
							?TRUE -> skip;
							_ -> throw(skip)
						end,
						ValidTime = BuffObj#buff_obj.valid_time - TimeLost,
						case ValidTime > 0 of
							?TRUE -> skip;
							_ -> throw({time_overflow, -ValidTime})
						end,
						NewBuffObj = BuffObj#buff_obj{
							start_time = Milliseconds,
							valid_time = ValidTime
						},
						{continue, NewBuffObj}
				end;
			_ ->
				T11 = Milliseconds + (OffLineTime - T1 div 1000) * 1000,
				T22 = Milliseconds + (OffLineTime - T2 div 1000) * 1000,
				T66 = Milliseconds + (OffLineTime - T6 div 1000) * 1000,
				NewBuffObj = BuffObj#buff_obj{
					start_time = Milliseconds,
					last_dot_effect_time = T11,
					last_dot_effect_time_1 = T22,
					last_dot_effect_time_6 = T66
				},
				{continue, NewBuffObj}
		end
	catch
		Result -> Result
	end.

fix(BuffObj) when is_tuple(BuffObj) andalso element(1, BuffObj) =:= buff_obj andalso tuple_size(BuffObj) < tuple_size(#buff_obj{}) ->
	OldSize = tuple_size(BuffObj),
	NewSize = tuple_size(#buff_obj{}),
	DiffSize = NewSize - OldSize,
	DiffValueList = lists:reverse(lists:sublist(lists:reverse(tuple_to_list(#buff_obj{})), DiffSize)),
	fix(list_to_tuple(tuple_to_list(BuffObj) ++ DiffValueList));
fix(BuffObj = #buff_obj{injury_liquidation = {_, _, _, _} = Injury}) ->
	fix(BuffObj#buff_obj{injury_liquidation = erlang:append_element(Injury, 0)});
fix(BuffObj) -> BuffObj.

db_to_buff(List) ->
	Buff = list_to_tuple([objectBuff | List]),
	Buff#objectBuff{
		dataList = gamedbProc:dbstring_to_term(Buff#objectBuff.dataList)
	}.
buff_to_db(Buff) ->
	NBuff = Buff#objectBuff{
		dataList = gamedbProc:term_to_dbstring(Buff#objectBuff.dataList)
	},
	tl(tuple_to_list(NBuff)).
