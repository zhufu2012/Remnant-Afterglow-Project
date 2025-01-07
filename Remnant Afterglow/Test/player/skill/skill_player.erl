%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%          玩家技能成长   TODO  同步到地图的技能需要判断绑定情况
%%% @end
%%% Created : 02. 八月 2018 16:16
%%%-------------------------------------------------------------------
-module(skill_player).
-author("cbfan").

-include("cfg_character_Ambit.hrl").
-include("cfg_mapsetting.hrl").
-include("cfg_arena.hrl").
-include("cfg_skillUpg.hrl").
-include("netmsgRecords.hrl").
-include("id_generator.hrl").
-include("record.hrl").
-include("skill.hrl").
-include("playerDefine.hrl").
-include("globalDict.hrl").
-include("logDefine.hrl").
-include("error.hrl").
-include("itemDefine.hrl").
-include("gameMap.hrl").
-include("fastTeam.hrl").
-include("logger.hrl").
-include("cfg_skillBase.hrl").
-include("cfg_buffBase.hrl").
-include("cfg_skillCorr.hrl").
-include("cfg_skillEquip.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("skill_new.hrl").
-include("attainment.hrl").
-include("seven_gift_define.hrl").
-include("player_task_define.hrl").
-include("variable.hrl").
-include("item.hrl").
-include("cfg_item.hrl").
-include("expedition.hrl").


-export([
	get_skill_attr/1,
	skill_fix_combo_skill/1,
	get_available_skill_fix_list/2,
	get_init_bind_skill_list/0,
	get_init_bind_skill_by_hand_list/0,
%%	on_skill_add_level/3,
%%	on_one_key_add_level/2,
	on_bind_skill/3,
%%	on_bind_skill_normal/2,
%%	on_player_init/1,
	on_player_online/1,
%%	on_player_level_up/2,
	check_skill_assembling_type/2
]).

-export([
	get_count_skill_lv/2,
	get_skill_by_index/2,
	change_skill/2,
	make_player_skill_msg/1,
	get_skill_info/2,
	get_role_index_skill_lv/3
	, get_special_skill_info/1
	, get_expedition_skill_mirror/1
]).
-export([make_player_skill/1, make_skill_fix_list/1, make_player_skill_msg/2, calc_skill_attr/1]).
-export([log_invalid_op/2, on_tick/0]).
-export([on_skill_change/0, on_skill_change/1, on_load/0, gm_do_skill/3]).
-export([set_choose_skill/2, get_count_change_career_skill_lv/3]).
-export([auto_bind_skill/2, auto_bind_skill_by_hand/2, get_skill_prop/1, get_skill_prop_common/0, get_skill_buff_fix/1, send_skill_msg/0]).
%%%% 创建玩家初始技能
%%on_player_init(Career) ->
%%	case cfg_character_Ambit:getRow(Career, 0) of
%%		#character_AmbitCfg{skillInit = SkillInit} ->
%%			[#playerSkillInfo{index = Index, skillID = SkillID, level = 1} || {SkillID, Index} <- SkillInit, cfg_skillBase:getRow(SkillID) =/= {}];
%%		_ ->
%%			[]
%%	end.
%%
%%%% 新角色技能初始化
%%skill_init(Career) ->
%%	case cfg_character_Ambit:getRow(Career, 0) of
%%		#character_AmbitCfg{skillInit = SkillInit} ->
%%			SkillInfoList = [#playerSkillInfo{index = Index, skillID = SkillID, level = 1}
%%				|| {SkillID, Index} <- SkillInit, cfg_skillBase:getRow(SkillID) =/= {}],
%%			SkillInfoList;
%%		_ -> []
%%	end.
%%
%%%% 玩家升级
%%on_player_level_up(_OldLevel, NewLevel) ->
%%	case player_level_up(NewLevel) of
%%		?TRUE ->
%%			on_skill_change();
%%		_ -> skip
%%	end.
%%
on_load() ->
	check_bind_skill_hand_init().
%%	RoleList = role_data:get_role_list(),
%%	lists:foreach(
%%		fun(#role{role_id = RoleId, skillList = SkillList}) ->
%%			List = [1, 2 | cfg_skillEquip:getKeyList()],
%%			AddList = [{1, SkillID, Idx, Lv} || #playerSkillInfo{index = Idx, level = Lv, skillID = SkillID} <- SkillList, lists:member(Idx, List), SkillID > 0],
%%			set_lv_up_skill(RoleId, AddList)
%%		end, RoleList).

%% 玩家上线 TODO  修改技能存储方式a
on_player_online(IsReconnect) ->
%%	player_level_up(player:getLevel()),
	skill_up:on_player_online(),
	refresh_skill(),
	case IsReconnect of
		?TRUE -> send_skill_msg();
		_ -> skip
	end,
	ok.

%%%% 技能升级
%%on_skill_add_level(RoleId, SkillIndex, SkillID) -> skill_add_level(RoleId, SkillIndex, SkillID).
%%
%%%% 一键升级
%%on_one_key_add_level(RoleId, SkillIndex) -> one_key_add_level(RoleId, SkillIndex).

%% 装配技能
on_bind_skill(0, RoleId, BindList) -> bind_skill(RoleId, BindList);
on_bind_skill(1, RoleId, BindList) -> bind_skill_by_hand(RoleId, BindList).

%% 普攻装配技能
%%on_bind_skill_normal(RoleId, SkillIndexes) -> bind_skill_normal(RoleId, SkillIndexes).


get_init_bind_skill_list() ->
	[#bind_skill_info{idx = ButtonIndex} || ButtonIndex <- lists:seq(1, ?Max_ButtonIndex)].
get_init_bind_skill_by_hand_list() ->
	[#bind_skill_info{idx = ButtonIndex} || ButtonIndex <- lists:seq(1, ?Max_ButtonIndexByHand)].
check_bind_skill_hand_init() ->
	BindIndexList = lists:seq(1, ?Max_ButtonIndexByHand),
	NewRoleList = common:listsFiterMap(fun(#role{bindSkillInfoListByHand = BindSkillList} = Role) ->
		AddBindSkillList = lists:foldl(fun(Index, Ret) ->
			case lists:keymember(Index, #bind_skill_info.idx, BindSkillList) of
				?TRUE -> Ret;
				?FALSE -> [#bind_skill_info{idx = Index} | Ret]
			end
									   end, [], BindIndexList),
		case AddBindSkillList =/= [] of
			?TRUE -> Role#role{bindSkillInfoListByHand = AddBindSkillList ++ BindSkillList};
			?FALSE -> ok
		end

									   end, role_data:get_role_list()),
	NewRoleList =/= [] andalso role_data:update_role(NewRoleList).

%%	获得玩家一切可用技能 TODO  将没有装配的主动技能干掉
get_available_skill_fix_list(_RoleId, 2110136) ->
	holy_wing:get_holy_wing_skill_list();
get_available_skill_fix_list(RoleId, MapDataID) ->
	MapAi = playerCopyMap:get_map_ai_by_map_data_id(MapDataID),
	case lists:member(MapAi, ?ExpeditionMapAIList) of
		?TRUE -> get_expedition_skill(RoleId);
		_ -> get_common_skill(RoleId, MapDataID)
	end.

get_expedition_skill(RoleId) ->
	#role{skillList = SkillList} = role_data:get_role(RoleId),
	FormatList = get_special_skill_cfg(RoleId) ++ get_roll_skill(SkillList),
	PatchedSkillList = skill_fix_combo_skill(FormatList),
	RetSkillList = [Tuple || Tuple <- PatchedSkillList, element(1, Tuple) =/= 0],
	RetSkillList.
get_expedition_skill_mirror({ID, Career}) ->
	FormatList = get_special_skill_cfg_mirror({ID, Career}),
	PatchedSkillList = skill_fix_combo_skill(FormatList),
	RetSkillList = [Tuple || Tuple <- PatchedSkillList, element(1, Tuple) =/= 0],
	RetSkillList.

get_common_skill(RoleId, MapDataID) ->
	SelfSkillList0 = role_data:get_role_element(RoleId, #role.skillList),
	{MapSelfSkillList, MapFixList} =
		case df:getMapsettingCfg(MapDataID) of
			#mapsettingCfg{mapAi = ?MapAI_CareerTower_Minor} ->
				career_tower:on_get_career_tower_skill_list(RoleId, SelfSkillList0, MapDataID);
			_ ->
				{SelfSkillList0, []}
		end,
	SelfSkillList = add_skill(MapFixList, MapSelfSkillList),
	FormatList = [{SkillID, Level, FixList, Index} ||
		#playerSkillInfo{skillID = SkillID, level = Level, fix_list = FixList, index = Index} <- SelfSkillList],
	%% 最终
	PatchedSkillList = skill_fix_combo_skill(FormatList),
	RetSkillList = [Tuple || Tuple <- PatchedSkillList, element(1, Tuple) =/= 0],
	RetSkillList.

make_skill_fix_list(SkillList) ->
	FormatList = [{SkillID, Level, FixList, Index} ||
		#playerSkillInfo{skillID = SkillID, level = Level, fix_list = FixList, index = Index} <- SkillList],
	%% 最终
	PatchedSkillList = skill_fix_combo_skill(FormatList),
	RetSkillList = [Tuple || Tuple <- PatchedSkillList, element(1, Tuple) =/= 0],
	RetSkillList.

%% 玩家技能面板属性 是否受到修正的影响
get_skill_attr(RoleId) ->
	F = fun(#playerSkillInfo{skillID = SkillId}, Ret) ->
		case cfg_skillBase:getRow(SkillId) of
			#skillBaseCfg{skillType = {1, _, _}, attrPara = Attr} ->
				[{I, V} || {_, I, V, _} <- Attr] ++ Ret;
			_ -> Ret
		end
		end,
	SkillUpAttr = skill_up:get_skill_attr(RoleId),
	RetAttr = lists:foldl(F, SkillUpAttr, role_data:get_role_element(RoleId, #role.skillList)),
	attribute:base_prop_from_list(common:listValueMerge(RetAttr)).

get_skill_prop(RoleId) ->
	Prop = get_skill_attr(RoleId),
	{_, Prop_2} = attribute:partition_attribute(Prop),
	Prop_2.
get_skill_prop_common() ->
	Prop = lists:foldl(fun(ID, Ret) ->
		get_skill_attr(ID) ++ Ret end, [], role_data:get_all_role_id()),
	{Prop_1, _} = attribute:partition_attribute(Prop),
	Prop_1.

calc_skill_attr(SkillList) ->
	F = fun(#playerSkillInfo{skillID = SkillId}, Ret) ->
		case cfg_skillBase:getRow(SkillId) of
			#skillBaseCfg{skillType = {1, _, _}, attrPara = Attr} ->
				[{I, V} || {_, I, V, _} <- Attr] ++ Ret;
			_ -> Ret
		end
		end,
	RetAttr = lists:foldl(F, [], SkillList),
	attribute:base_prop_from_list(common:listValueMerge(RetAttr)).

%% 返回包含普攻所有连击的技能列表
%% SkillFixList ==> [{SkillId, SkillLevel, FixIDList, SkillIndex}]
skill_fix_combo_skill(SkillFixList) ->
	RetSkillList = lists:foldl(fun skill_addition/2, [], SkillFixList),
	[Tuple || Tuple <- RetSkillList, element(1, Tuple) =/= 0].

get_count_skill_lv(0, _) -> 0;
get_count_skill_lv(RoleId, Lv) ->
	SkillIndex = cfg_skillEquip:getKeyList(),
	length([1 || #playerSkillInfo{index = Index} <- role_data:get_role_element(RoleId, #role.skillList),
		skill_up:get_skill_level(RoleId, Index) >= Lv, lists:member(Index, SkillIndex)]).

get_count_change_career_skill_lv(0, _, _) -> 0;
get_count_change_career_skill_lv(RoleId, Lv, CareerLv) ->
	SkillIndex = [Index || #skillEquipCfg{iD = Index, type = Type, changeRole = ChangeRole} <- cfg_skillEquip:rows(), ChangeRole =:= CareerLv, lists:member(Type, [1, 2])],
	length([1 || #playerSkillInfo{index = Index} <- role_data:get_role_element(RoleId, #role.skillList),
		skill_up:get_skill_level(RoleId, Index) >= Lv, lists:member(Index, SkillIndex)]).

get_skill_by_index(RoleId, Index) ->
	SkillList = role_data:get_role_element(RoleId, #role.skillList),
	case lists:keyfind(Index, #playerSkillInfo.index, SkillList) of
		#playerSkillInfo{skillID = SkillId} -> SkillId;
		_ -> 0
	end.

get_skill_info(RoleId, Index) ->
	SkillList = role_data:get_role_element(RoleId, #role.skillList),
	case lists:keyfind(Index, #playerSkillInfo.index, SkillList) of
		#playerSkillInfo{} = Skill -> Skill;
		_ -> #playerSkillInfo{index = Index}
	end.


%% 魔、翼、兽、圣灵技能装配的时候判断
check_skill_assembling_type(SkillId, SkillList) ->
	case cfg_skillBase:getRow(SkillId) of
		#skillBaseCfg{assemblingType = Type} when Type > 0 ->
			check_skill_group_1(SkillList, Type);
		_ -> ?TRUE
	end.

check_skill_group_1([], _Type) -> ?TRUE;
check_skill_group_1([SkillId | T], Type) ->
	case cfg_skillBase:getRow(SkillId) of
		#skillBaseCfg{assemblingType = Type} -> ?FALSE;
		_ -> check_skill_group_1(T, Type)
	end.

%% {1, SkillId, SkillIdx}
%%get_lv_up_skill(RoleId) -> case get({lv_up_skill, RoleId}) of ?UNDEFINED -> []; L -> L end.
%%set_lv_up_skill(RoleId, L) -> put({lv_up_skill, RoleId}, L).

get_role_index_skill_lv(Index, RoleN, TargetLv) ->
	Lv =
		case role_data:get_nth_role_id(RoleN) of
			0 -> 0;
			RoleID ->
				case table_player:lookup(db_skill_up, player:getPlayerID(), [{RoleID, Index}]) of
					[#skill_up{level = Lv_} | _] -> Lv_;
					_ ->
						0
				end
		end,
	Lv >= TargetLv.

log_invalid_op(_Tp, _Msg) ->
	case get('invalid_mark') of
		?UNDEFINED ->
%%			?LOG_ERROR("found invalid hit, :~p ", [{Tp, Msg}]),
			put('invalid_mark', ?FALSE);
		?TRUE ->
%%			?LOG_ERROR("found invalid hit, :~p ", [{Tp, Msg}]),
			put('invalid_mark', ?FALSE);
		_ ->
			skip
	end.
on_tick() ->
	put('invalid_mark', ?TRUE).
change_skill(_RoleId, _Career) ->
	ok.
%%	#character_AmbitCfg{skillActi = SkillActive, skillInit = InitSkillList} = cfg_character_Ambit:getRow(Career, 0),
%%	SkillInitList = InitSkillList ++ [{ID, Index} || {_, _, ID, Index} <- SkillActive],
%%	OldSkillList = get_lv_up_skill(RoleId),
%%	Func = fun({T, ID, Index, Level}, Ret) ->
%%		case lists:keyfind(Index, 2, SkillInitList) of
%%			{I, _} -> [{T, I, Index, Level} | Ret];
%%			?FALSE -> [{T, ID, Index, Level} | Ret]
%%		end
%%		   end,
%%	NewSkillList = lists:foldl(Func, [], OldSkillList),
%%	set_lv_up_skill(RoleId, NewSkillList),
%%	genius:on_change_career_reset_dot(),
%%	refresh_skill(RoleId).

%%%===================================================================
%%% Internal functions
%%%===================================================================
%%player_level_up(NewLevel) ->
%%	RoleList = role_data:get_role_list(),
%%	lists:foreach(
%%		fun(#role{role_id = RoleId, career = Career}) ->
%%			SkillList = get_lv_up_skill(RoleId),
%%			#character_AmbitCfg{skillActi = SkillActive, skillInit = InitSkillList} = cfg_character_Ambit:getRow(Career, 0),
%%			%% 学习技能 (激活条件,激活参数,技能ID,技能位置)  TODO  [{1,12,104007,4},{1,20,104006,3},{1,40,104008,5},{1,70,104009,6},{1,1,1104,89},{1,1,1105,90},{1,1,1106,91}],
%%			StudyFunc = fun({1, ActiveLevel, SkillId, SkillIndex}, IsUpdateSkill) ->
%%				IsUpdateSkill1 = case lists:keyfind(SkillIndex, 3, SkillList) of
%%									 {1, SkillId, SkillIndex} -> ?FALSE;
%%									 _ ->
%%										 case NewLevel >= ActiveLevel andalso cfg_skillBase:getRow(SkillId) =/= {} of
%%											 ?TRUE -> player_study_skill(RoleId, SkillIndex, SkillId);
%%											 _ -> ?FALSE
%%										 end
%%								 end,
%%				case IsUpdateSkill of
%%					?TRUE -> ?TRUE;
%%					_ -> IsUpdateSkill1
%%				end
%%						end,
%%			lists:foldl(StudyFunc, ?FALSE, SkillActive ++ [{1, 1, Id, Idx} || {Id, Idx} <- InitSkillList])
%%		end, RoleList).

%%player_study_skill(RoleId, SkillIndex, SkillID) ->
%%	SkillInfoList = get_lv_up_skill(RoleId),
%%	case lists:keyfind(SkillIndex, 3, SkillInfoList) of
%%		?FALSE ->
%%			NewSkillInfo = {1, SkillID, SkillIndex, 1},
%%			NewSkillInfoList = [NewSkillInfo | SkillInfoList],
%%			update_bind_skill(RoleId, NewSkillInfo),
%%			set_lv_up_skill(RoleId, NewSkillInfoList),
%%			?TRUE;
%%		_ -> %% TODO 先不管
%%			?FALSE
%%	end.

%%update_bind_skill(RoleId, {_, _SkillId, SkillIndex, _}) ->
%%	try
%%		Role = role_data:get_role(RoleId),
%%		#role{bindSkillInfoList = BindSkillInfoList} = Role,
%%		case cfg_skillEquip:getRow(SkillIndex) of
%%			#skillEquipCfg{} -> skip;
%%			_ -> throw(ok)
%%		end,
%%
%%		Func = fun(#bind_skill_info{skill_idx = SkillIdx, skill_idx_list = SkillIdxList}) ->
%%			SkillIdx =/= SkillIndex andalso not lists:member(SkillIndex, SkillIdxList)
%%			   end,
%%		case lists:all(Func, BindSkillInfoList) of
%%			?TRUE -> skip;
%%			_ -> throw(ok)
%%		end,
%%		SortBindSkillInfoList = lists:keysort(#bind_skill_info.idx, BindSkillInfoList),
%%
%%		NewBind = update_bind_skill_1(SortBindSkillInfoList, SkillIndex, SortBindSkillInfoList),
%%		role_data:update_role(Role#role{bindSkillInfoList = NewBind})
%%	catch
%%		ok -> ok
%%	end.

%%update_bind_skill_1([], _, Ret) -> Ret;
%%update_bind_skill_1([#bind_skill_info{idx = 1} | T], SkillIndex, Ret) ->
%%	update_bind_skill_1(T, SkillIndex, Ret);
%%update_bind_skill_1([#bind_skill_info{idx = Idx, skill_idx = 0} = Info | _], SkillIndex, Ret) ->
%%	lists:keystore(Idx, #bind_skill_info.idx, Ret, Info#bind_skill_info{skill_idx = SkillIndex});
%%update_bind_skill_1([#bind_skill_info{} | T], SkillIndex, Ret) ->
%%	update_bind_skill_1(T, SkillIndex, Ret).




skill_addition({SkillID, Level, FixList, Pos} = Info, T) ->
	{NInfo, NT} = case lists:keyfind(SkillID, 1, T) of
					  {_, Level1, FixList1, Pos1} ->
						  S = {SkillID, max(Level1, Level), FixList ++ FixList1, max(Pos, Pos1)},
						  {S, lists:keystore(SkillID, 1, T, S)};
					  _ ->
						  {Info, [Info | T]}
				  end,
	{T1, _} = skill_addition_1(NInfo, NT, 20),
	T1.

skill_addition_1(Info, T, N) when N =< 0 ->
	?LOG_ERROR("recursion to ten times :~p", [{Info, T}]),
	{T, 0};
skill_addition_1({SkillID, _, FixList, _} = Info, T, N) ->
	case cfg_skillBase:getRow(SkillID) of
		#skillBaseCfg{combPara = Comb, randPara = Rand, activateEffect = Effect} ->
			{T0, N0} = skill_addition_fix(FixList, T, N),
			{T1, N1} = skill_addition_combo(Info, Comb, T0, N0),
			{T2, N2} = skill_addition_rand(Info, Rand, T1, N1),
			{T3, N3} = skill_addition_effect(Info, Effect, T2, N2),
			{T3, N3};
		_ ->
			[?LOG_ERROR("no skillbase cfg :~p", [SkillID]) || SkillID =/= 0],
			{T, N}
	end.

skill_addition_fix([], Exist, N) -> {Exist, N};
skill_addition_fix([FixId | T], Exist, N) ->
	{NewExist, NewN} = case cfg_skillCorr:row(FixId) of
						   #skillCorrCfg{activateEffect = Effect} ->
							   skill_addition_fix_1(Effect, Exist, N);
						   _ ->
							   {Exist, N}
					   end,
	skill_addition_fix(T, NewExist, NewN).
skill_addition_fix_1([], Exist, N) -> {Exist, N};
skill_addition_fix_1([{_, _, _, 1, SkillId} | T], Exist, N) ->
	{NewExist, NewN} = case lists:keyfind(SkillId, 1, Exist) of
						   ?FALSE ->
							   FixSkill = {SkillId, 1, [], 0},
							   skill_addition_1(FixSkill, [FixSkill | Exist], N - 1);
						   _ ->
							   {Exist, N}
					   end,
	skill_addition_fix_1(T, NewExist, NewN);
skill_addition_fix_1([_ | T], Exist, N) ->
	skill_addition_fix_1(T, Exist, N).

%% 连招和随机技能需要继承修正
skill_addition_combo(_, _, T, N) when N =< 0 -> {T, 0};
skill_addition_combo(_, {0, _}, T, N) -> {T, N};
skill_addition_combo({SkillID, SkillLevel, FixIDList, _}, {ComboSkillId, _}, T, N) ->
	case lists:keyfind(ComboSkillId, 1, T) of
		{SkillID, _, _, _} -> {T, N};   %% 自己触发自己
		{_, Level, F, 0} ->
			ComboSkill = {ComboSkillId, Level, lists:usort(FixIDList ++ F), 0},
			skill_addition_1(ComboSkill, [ComboSkill | T], N - 1);
		_ ->
			ComboSkill = {ComboSkillId, SkillLevel, FixIDList, 0},
			skill_addition_1(ComboSkill, [ComboSkill | T], N - 1)
	end.

skill_addition_rand(_, _, T, N) when N =< 0 -> {T, 0};
skill_addition_rand(_, [], T, N) -> {T, N};
skill_addition_rand({SkillID, SkillLevel, FixIDList, SkillIndex}, [{_, RandSkillId} | T_Rand], T, N) ->
	{NT, NN} = case lists:keyfind(RandSkillId, 1, T) of
				   {SkillID, _, _, _} ->
					   {T, N};
				   {_, Level, F, 0} ->
					   RandSkill = {RandSkillId, Level, lists:usort(FixIDList ++ F), 0},
					   {T1, N1} = skill_addition_1(RandSkill, [RandSkill | T], N - 1),
					   {T1, N1};
				   _ ->
					   RandSkill = {RandSkillId, SkillLevel, FixIDList, 0},
					   {T1, N1} = skill_addition_1(RandSkill, [RandSkill | T], N - 1),
					   {T1, N1}
			   end,
	skill_addition_rand({SkillID, SkillLevel, FixIDList, SkillIndex}, T_Rand, NT, NN).

skill_addition_effect(_, _, T, N) when N =< 0 -> {T, 0};
skill_addition_effect(_, [], T, N) -> {T, N};
skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, [{_, _, _, 1, TriggerSkillId} | T_T], T, N) ->
	{T1, N1} = case lists:keymember(TriggerSkillId, 1, T) of
				   ?TRUE -> {T, N};
				   _ ->
					   ComboSkill = {TriggerSkillId, SkillLevel, [], 0},
					   skill_addition_1(ComboSkill, [ComboSkill | T], N - 1)
			   end,
	skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, T_T, T1, N1);
skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, [{_, _, _, 2, TriggerBuffId} | T_T], T, N) ->
	case cfg_buffBase:getRow(TriggerBuffId) of
		#buffBaseCfg{activateEffect = EffectList} when EffectList =/= [] ->
			{T1, N1} = skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, EffectList, T, N - 1),
			skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, T_T, T1, N1);
		_ -> skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, T_T, T, N)
	end;
skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, [_ | T_T], T, N) ->
	skill_addition_effect({SkillID, SkillLevel, FixIDList, SkillIndex}, T_T, T, N).


%%skill_add_level(RoleId, SkillIndex, SkillID) ->
%%	try
%%		{ErrorCode, NewSkillInfo, CoinList} = check_skill_add_level(RoleId, SkillIndex, SkillID),
%%		?ERROR_CHECK_THROW(ErrorCode),
%%
%%		%% 其他响应（学习技能任务等）
%%		attainment:check_attainment(?Attainments_Type_SkillLv),
%%		seven_gift:check_task(?Seven_Type_SkillLv),
%%		player_task:refresh_task(?Task_Goal_SkillLv),
%%		res_cb:on_use_res(?OpenAction_Skill, [], CoinList),
%%
%%		on_skill_change(),
%%		{1, SkillID, SkillIndex, SkillLv} = NewSkillInfo,
%%		%%记录日志
%%		Msg = #pk_GS2U_SkillAddLevelRet{
%%			role_id = RoleId,
%%			err_code = 0,
%%			skill = #pk_SkillBase{
%%				index = SkillIndex,
%%				skill_id = SkillID,
%%				skill_level = SkillLv}
%%		},
%%		player:send(Msg),
%%		skill_up:check_broadcast(RoleId, SkillIndex, 0)
%%	catch
%%		ErrCode -> player:send(#pk_GS2U_SkillAddLevelRet{role_id = RoleId, err_code = ErrCode})
%%	end.
%%check_skill_add_level(RoleId, Index, SkillID) ->
%%	try
%%%%		SkillList = player:getPlayerProperty(#player.skillList),
%%		SkillList = get_lv_up_skill(RoleId),
%%		case lists:keyfind(Index, 3, SkillList) of
%%%%			#playerSkillInfo{skillID = SkillID, level = Level} = Info ->
%%			{1, SkillID, Index, Level} ->
%%				case cfg_skillUpg:getRow(Level, Index) of
%%					#skillUpgCfg{needLv = NeedLv, charaCons = Cons, maxLv = MaxLv} when MaxLv > Level ->
%%						LvErrCode = common:getTernaryValue(player:getLevel() >= NeedLv, ?ERROR_OK, ?ErrorCode_Team_LevelNotMatch),
%%						?ERROR_CHECK_THROW(LvErrCode),
%%						Career = role_data:get_role_element(RoleId, #role.career),
%%						CoinList = [{Coin, Num} || {C, Coin, Num} <- Cons, C =:= Career],
%%						CostErrCode = player:delete_cost([], CoinList, ?Reason_Skill_LevelUp),
%%						?ERROR_CHECK_THROW(CostErrCode),
%%						NewInfo = {1, SkillID, Index, Level + 1},
%%						NewSkillList = lists:keystore(Index, 3, SkillList, NewInfo),
%%						set_lv_up_skill(RoleId, NewSkillList),
%%						{?ERROR_OK, NewInfo, CoinList};
%%					_ ->
%%						throw(?ErrorCode_Skill_NotLevelUp)
%%				end;
%%			_ -> throw(?ErrorCode_Skill_NotLearn)
%%		end
%%	catch
%%		Err -> {Err, [], []}
%%	end.


%%one_key_add_level(RoleId, 0) ->
%%	try
%%		SkillList = get_lv_up_skill(RoleId),
%%		List = [1 | cfg_skillEquip:getKeyList()],
%%		AddList = [{Idx, Lv, SkillID} || {1, SkillID, Idx, Lv} <- SkillList, lists:member(Idx, List), SkillID > 0],
%%		case AddList =:= [] of
%%			?TRUE -> throw(?ErrorCode_Skill_CannotOneKeyLevelUp);
%%			_ -> skip
%%		end,
%%		PrepareList = [{SkillIdx, _LvMin} | _] = lists:keysort(2, [{Idx, Lv} || {Idx, Lv, _} <- AddList]),
%%		MaxLevel = 900,
%%		{LevelUpErrCode, NewList, CostList} = one_key_add_level_0(PrepareList, SkillIdx, MaxLevel),
%%
%%		FF = fun({Idx, Lv}, Ret) ->
%%			case lists:keyfind(Idx, 1, AddList) of
%%				{_, Lv, _} -> Ret;
%%				{_, OldLv, SkillID} ->
%%					[#pk_OnekeySkillChange{
%%						index = Idx,
%%						skill_id = SkillID,
%%						old_lv = OldLv,
%%						new_lv = Lv
%%					} | Ret];
%%				_ -> Ret
%%			end end,
%%
%%		ChangeListMsg = lists:foldl(FF, [], NewList),
%%		[?ERROR_CHECK_THROW(LevelUpErrCode) || ChangeListMsg =:= []],
%%		CostErrCode = player:delete_cost([], CostList, ?Reason_Skill_LevelUp),
%%		?ERROR_CHECK_THROW(CostErrCode),
%%
%%		F1 = fun({Idx, Lv}, Ret) ->
%%			{1, P1, P2, _P3} = lists:keyfind(Idx, 3, Ret),
%%			lists:keystore(Idx, 3, Ret, {1, P1, P2, Lv})
%%			 end,
%%		NewSkillList = lists:foldl(F1, SkillList, NewList),
%%		set_lv_up_skill(RoleId, NewSkillList),
%%		on_skill_change(),
%%
%%		attainment:check_attainment(?Attainments_Type_SkillLv),
%%		seven_gift:check_task(?Seven_Type_SkillLv),
%%		player_task:refresh_task(?Task_Goal_SkillLv),
%%		res_cb:on_use_res(?OpenAction_Skill, [], CostList),
%%
%%		player:send(#pk_GS2U_SkillOneKeyAddLevelRet{role_id = RoleId, change_list = ChangeListMsg}),
%%
%%		F2 = fun({Idx, Lv}, Ret) ->
%%			case lists:keyfind(Idx, 1, AddList) of
%%				{_, Lv, _} -> Ret;
%%				{_, _OldLv, _} -> skill_up:check_broadcast(RoleId, Idx, 0);
%%				_ -> Ret
%%			end end,
%%		lists:foldl(F2, [], NewList)
%%	catch
%%		ErrCode -> player:send(#pk_GS2U_SkillOneKeyAddLevelRet{role_id = RoleId, err_code = ErrCode})
%%	end;
%%one_key_add_level(RoleId, SkillIndex) ->
%%	try
%%		SkillList = get_lv_up_skill(RoleId),
%%		List = [SkillIndex],
%%		AddList = [{Idx, Lv, SkillID} || {1, SkillID, Idx, Lv} <- SkillList, lists:member(Idx, List), SkillID > 0],
%%		case AddList =:= [] of
%%			?TRUE -> throw(?ErrorCode_Skill_CannotOneKeyLevelUp);
%%			_ -> skip
%%		end,
%%		PrepareList = [{SkillIdx, LvMin} | _] = lists:keysort(2, [{Idx, Lv} || {Idx, Lv, _} <- AddList]),
%%		LevelSplit = cfg_globalSetup:skillFastLevel(),
%%		MaxLevel = ((LvMin div LevelSplit) + 1) * LevelSplit,
%%		{LevelUpErrCode, NewList, CostList} = one_key_add_level_0(PrepareList, SkillIdx, MaxLevel),
%%
%%		FF = fun({Idx, Lv}, Ret) ->
%%			case lists:keyfind(Idx, 1, AddList) of
%%				{_, Lv, _} -> Ret;
%%				{_, OldLv, SkillID} ->
%%					[#pk_OnekeySkillChange{
%%						index = Idx,
%%						skill_id = SkillID,
%%						old_lv = OldLv,
%%						new_lv = Lv
%%					} | Ret];
%%				_ -> Ret
%%			end end,
%%
%%		ChangeListMsg = lists:foldl(FF, [], NewList),
%%		[?ERROR_CHECK_THROW(LevelUpErrCode) || ChangeListMsg =:= []],
%%		CostErrCode = player:delete_cost([], CostList, ?Reason_Skill_LevelUp),
%%		?ERROR_CHECK_THROW(CostErrCode),
%%
%%		F1 = fun({Idx, Lv}, Ret) ->
%%			{1, P1, P2, _P3} = lists:keyfind(Idx, 3, Ret),
%%			lists:keystore(Idx, 3, Ret, {1, P1, P2, Lv})
%%			 end,
%%		NewSkillList = lists:foldl(F1, SkillList, NewList),
%%		set_lv_up_skill(RoleId, NewSkillList),
%%		on_skill_change(),
%%
%%		attainment:check_attainment(?Attainments_Type_SkillLv),
%%		seven_gift:check_task(?Seven_Type_SkillLv),
%%		player_task:refresh_task(?Task_Goal_SkillLv),
%%		res_cb:on_use_res(?OpenAction_Skill, [], CostList),
%%
%%		player:send(#pk_GS2U_SkillOneKeyAddLevelRet{role_id = RoleId, change_list = ChangeListMsg}),
%%
%%		F2 = fun({Idx, Lv}, Ret) ->
%%			case lists:keyfind(Idx, 1, AddList) of
%%				{_, Lv, _} -> Ret;
%%				{_, _OldLv, _} -> skill_up:check_broadcast(RoleId, Idx, 0);
%%				_ -> Ret
%%			end end,
%%		lists:foldl(F2, [], NewList)
%%	catch
%%		ErrCode -> player:send(#pk_GS2U_SkillOneKeyAddLevelRet{role_id = RoleId, err_code = ErrCode})
%%	end.


%%check_level_up(Index, SkillList, CostList) ->
%%	try
%%		case lists:keyfind(Index, 1, SkillList) of
%%			{Index, Level} ->
%%				case cfg_skillUpg:getRow(Level, Index) of
%%					#skillUpgCfg{needLv = NeedLv, charaCons = Cons, maxLv = MaxLv} when MaxLv > Level ->
%%						LvErrCode = common:getTernaryValue(player:getLevel() >= NeedLv, ?ERROR_OK, ?ErrorCode_Team_LevelNotMatch),
%%						?ERROR_CHECK_THROW(LvErrCode),
%%						Career = role_data:get_leader_career(),
%%						CoinList = [{Coin, Num} || {C, Coin, Num} <- Cons, C =:= Career],
%%						NewCostList = common:listValueMerge(CoinList ++ CostList),
%%						{CurrencyError, _CurrencyPrepared} = currency:delete_prepare(NewCostList),
%%						?ERROR_CHECK_THROW(CurrencyError),
%%						NewSkillList = lists:keystore(Index, 1, SkillList, {Index, Level + 1}),
%%						{?ERROR_OK, NewSkillList, NewCostList};
%%					_ ->
%%						throw(?ErrorCode_Skill_NotLevelUp)
%%				end;
%%			_ -> throw(?ErrorCode_Skill_NotLearn)
%%		end
%%	catch
%%		Err -> {Err, SkillList, CostList}
%%	end.

%%one_key_add_level_0(SkillInfoList, SkillIndex, MaxLevel) ->
%%	MaxCircleCount = length(SkillInfoList) * 900,   %% 避免死循环
%%	one_key_add_level_1(SkillInfoList, SkillIndex, [], [], MaxLevel, 1, MaxCircleCount).
%%one_key_add_level_1(SkillInfoList, SkillIndex, CostList, ExceptSkillIndexList, MaxLevel, CircleCount, MaxCircleCount) ->
%%	{ErrorCode, NewSkillInfoList, NewCostList} = check_level_up(SkillIndex, SkillInfoList, CostList),
%%	case ErrorCode of
%%		?Success ->
%%			{PriorSkillIndex, PriorSkillLevel} = get_prior(NewSkillInfoList, ExceptSkillIndexList),
%%			case PriorSkillLevel >= MaxLevel orelse CircleCount > MaxCircleCount of
%%				?TRUE -> {ErrorCode, NewSkillInfoList, NewCostList};
%%				_ ->
%%					one_key_add_level_1(NewSkillInfoList, PriorSkillIndex, NewCostList, ExceptSkillIndexList, MaxLevel, CircleCount + 1, MaxCircleCount)
%%			end;
%%		_ ->
%%			{PriorSkillIndex, PriorSkillLevel} = get_prior(NewSkillInfoList, [SkillIndex | ExceptSkillIndexList]),
%%			case PriorSkillIndex == 0 of
%%				?TRUE -> {ErrorCode, NewSkillInfoList, NewCostList};
%%				_ ->
%%					case PriorSkillLevel >= MaxLevel orelse CircleCount > MaxCircleCount of
%%						?TRUE -> {ErrorCode, SkillInfoList, CostList};
%%						_ ->
%%							one_key_add_level_1(NewSkillInfoList, PriorSkillIndex, NewCostList, [SkillIndex | ExceptSkillIndexList], MaxLevel, CircleCount + 1, MaxCircleCount)
%%					end
%%			end
%%	end.


%%%%get_prior(SkillInfoList) -> get_prior(SkillInfoList, []).
%%get_prior([], _) ->
%%	{0, 0};
%%get_prior(SkillInfoList, ExceptSkillIndexList) ->
%%	FilterList = [{Idx, Lv} || {Idx, Lv} <- SkillInfoList, not lists:member(Idx, ExceptSkillIndexList)],
%%	case FilterList of
%%		[] -> {0, 0};
%%		_ ->
%%			[{SkillIndex, Level} | _] = lists:keysort(2, FilterList),
%%			{SkillIndex, Level}
%%	end.

bind_skill(RoleId, BindList) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
		Role = role_data:get_role(RoleId),
		NewRole = lists:foldl(
			fun(#pk_BindSkillBase{bind_index = BindIndex, skill_index = SkillIndex}, Role1) ->
				bind_skill(Role1, SkillIndex, BindIndex)
			end, Role, BindList),
		role_data:update_role(NewRole),
		send_skill_msg(),
		#role{bindSkillInfoList = BindSkillList3} = NewRole,
		player:send(#pk_GS2U_RequestBindSkillRet{
			role_id = RoleId, type = 0, err_code = ?ERROR_OK,
			new_bind_list = [#pk_BindSkillBase{bind_index = I, skill_index = S} || #bind_skill_info{idx = I, skill_idx = S} <- BindSkillList3, I =/= 1]
		})
	catch
		ErrCode -> player:send(#pk_GS2U_RequestBindSkillRet{role_id = RoleId, err_code = ErrCode})
	end.
bind_skill(Role, SkillIdx, BindIndex) ->
	#role{role_id = RoleId, skillList = SkillList, bindSkillInfoList = BindSkillList, bindSkillInfoListByHand = BindSkillListByHand} = Role,
	?CHECK_THROW(SkillIdx =:= 0 orelse lists:keymember(SkillIdx, #playerSkillInfo.index, SkillList), ?ErrorCode_Skill_NotLearn),
	OldSkillIdx = case lists:keyfind(BindIndex, #bind_skill_info.idx, BindSkillList) of
					  #bind_skill_info{skill_idx = SkillIdx} ->
						  throw(?ErrorCode_Skill_AlreadyEquip);
					  #bind_skill_info{skill_idx = I} -> I;
					  _ ->
						  ?LOG_ERROR("skill bind wrong, RileID: ~p, BindIndex: ~p, BindSkillList: ~p", [RoleId, BindIndex, BindSkillList]),
						  throw(?ErrorCode_Skill_CannotEquip)
				  end,
	%% 检查是否可以装配
	case SkillIdx =:= 0 orelse check_can_equip(SkillIdx, BindIndex, BindSkillList) of
		?TRUE -> skip;
		_ -> throw(?ErrorCode_Skill_CannotEquip)
	end,
	%% 1. 直接镶嵌上去  2. 把镶嵌的技能从原来的位置取下来
	F_Off = fun
				(#bind_skill_info{idx = Idx, skill_idx = SkillIdx1} = Info, Ret) when SkillIdx =/= 0 andalso SkillIdx =:= SkillIdx1 ->
					lists:keystore(Idx, #bind_skill_info.idx, Ret, Info#bind_skill_info{skill_idx = OldSkillIdx});
				(_, Ret) -> Ret
			end,
	BindSkillList1 = lists:foldl(F_Off, BindSkillList, BindSkillList),
	BindSkillList2 = lists:keystore(BindIndex, #bind_skill_info.idx, BindSkillList1, #bind_skill_info{idx = BindIndex, skill_idx = SkillIdx}),
	BindSkillList3 = case lists:keyfind(1, #bind_skill_info.idx, BindSkillList2) of
						 #bind_skill_info{skill_idx_list = NormalList} = NormalSkillInfo when SkillIdx =/= 0 ->
							 lists:keystore(1, #bind_skill_info.idx, BindSkillList2, NormalSkillInfo#bind_skill_info{
								 skill_idx_list = NormalList -- [SkillIdx]});
						 _ -> BindSkillList2
					 end,
	case SkillIdx =:= 0 of
		?FALSE ->
			case lists:keymember(SkillIdx, #bind_skill_info.skill_idx, BindSkillListByHand) of
				?FALSE ->
					case OldSkillIdx > 0 andalso lists:keyfind(OldSkillIdx, #bind_skill_info.skill_idx, BindSkillListByHand) of
						#bind_skill_info{idx = ReplaceIdx} ->
							NewBindSkillListByHand = lists:keyreplace(ReplaceIdx, #bind_skill_info.idx, BindSkillListByHand, #bind_skill_info{idx = ReplaceIdx, skill_idx = SkillIdx}),
							Role#role{bindSkillInfoList = BindSkillList3, bindSkillInfoListByHand = NewBindSkillListByHand};
						?FALSE ->
							case lists:keysort(#bind_skill_info.idx, [BindInfo || #bind_skill_info{idx = Idx, skill_idx = 0} = BindInfo <- BindSkillListByHand, Idx =/= 1]) of
								[] -> Role#role{bindSkillInfoList = BindSkillList3};
								[#bind_skill_info{idx = NullIdx} | _] ->
									NewBindSkillListByHand = lists:keyreplace(NullIdx, #bind_skill_info.idx, BindSkillListByHand, #bind_skill_info{idx = NullIdx, skill_idx = SkillIdx}),
									Role#role{bindSkillInfoList = BindSkillList3, bindSkillInfoListByHand = NewBindSkillListByHand}
							end
					end;
				?TRUE ->
					Role#role{bindSkillInfoList = BindSkillList3}
			end;
		?TRUE ->
			BindSkillListByHand1 = lists:foldl(fun
												   (#bind_skill_info{idx = Idx, skill_idx = SkillIdx1} = Info, Ret) when OldSkillIdx =:= SkillIdx1 ->
													   lists:keystore(Idx, #bind_skill_info.idx, Ret, Info#bind_skill_info{skill_idx = 0});
												   (_, Ret) -> Ret
											   end, BindSkillListByHand, BindSkillListByHand),
			BindSkillListByHand2 = lists:keysort(#bind_skill_info.idx, BindSkillListByHand1),
			{BindSkillListByHandSub1, BindSkillListByHandSub2} = lists:splitwith(fun(#bind_skill_info{idx = Idx, skill_idx = SkillIdx_}) ->
				SkillIdx_ =/= 0 orelse Idx =:= 1 end, BindSkillListByHand2),
			BindSkillListByHandSub3 = lists:zipwith(fun(Idx, {SkillIdx_, SkillIdxList_}) ->
				#bind_skill_info{idx = Idx, skill_idx = SkillIdx_, skill_idx_list = SkillIdxList_} end,
				[Idx || #bind_skill_info{idx = Idx} <- BindSkillListByHandSub2],
				lists:sort(fun({X, _}, _) -> X > 0 end,
					[{SkillIdx_, SkillIdxList_} || #bind_skill_info{skill_idx = SkillIdx_, skill_idx_list = SkillIdxList_} <- BindSkillListByHandSub2])
			),
			BindSkillListByHand3 = BindSkillListByHandSub1 ++ BindSkillListByHandSub3,
			Role#role{bindSkillInfoList = BindSkillList3, bindSkillInfoListByHand = BindSkillListByHand3}
	end.

%% 自动装配
auto_bind_skill(RoleId, SkillIdx) -> ?metrics(begin
												  try
													  Role = role_data:get_role(RoleId),
													  #role{skillList = SkillList, bindSkillInfoList = BindSkillList} = Role,
													  case lists:keyfind(SkillIdx, #playerSkillInfo.index, SkillList) of
														  #playerSkillInfo{} -> ok;
														  _ -> throw(?ErrorCode_Skill_NotLearn)
													  end,
													  case lists:keyfind(SkillIdx, #bind_skill_info.skill_idx, BindSkillList) of
														  #bind_skill_info{} -> throw(?ErrorCode_Skill_AlreadyEquip);
														  _ -> ok
													  end,
													  NullBindList = [BindInfo || #bind_skill_info{idx = Idx, skill_idx = 0} = BindInfo <- BindSkillList, Idx =/= 1],
													  BindIndex = case lists:keysort(#bind_skill_info.idx, NullBindList) of
																	  [#bind_skill_info{idx = Idx} | _] -> Idx;
																	  _ -> throw(?ErrorCode_Skill_CannotEquip)
																  end,
													  case check_can_equip(SkillIdx, BindIndex, BindSkillList) of
														  ?TRUE -> ok;
														  ?FALSE -> throw(?ErrorCode_Skill_CannotEquip)
													  end,
													  NewBindSkillList = lists:keystore(BindIndex, #bind_skill_info.idx, BindSkillList, #bind_skill_info{idx = BindIndex, skill_idx = SkillIdx}),
													  role_data:update_role(Role#role{bindSkillInfoList = NewBindSkillList}),
													  send_skill_msg(),
													  player:send(#pk_GS2U_RequestBindSkillRet{
														  err_code = ?ERROR_OK, type = 0,
														  new_bind_list = [#pk_BindSkillBase{bind_index = I, skill_index = S} || #bind_skill_info{idx = I, skill_idx = S} <- NewBindSkillList, I =/= 1]
													  })
												  catch
													  _ErrCode -> ok
												  end end).

bind_skill_by_hand(RoleId, BindList) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
		Role = role_data:get_role(RoleId),
		NewRole = lists:foldl(
			fun(#pk_BindSkillBase{bind_index = BindIndex, skill_index = SkillIndex}, Role1) ->
				bind_skill_by_hand(Role1, SkillIndex, BindIndex)
			end, Role, BindList),
		role_data:update_role(NewRole),
		send_skill_msg(),
		#role{bindSkillInfoListByHand = BindSkillList3} = NewRole,
		player:send(#pk_GS2U_RequestBindSkillRet{
			role_id = RoleId, type = 1, err_code = ?ERROR_OK,
			new_bind_list = [#pk_BindSkillBase{bind_index = I, skill_index = S} || #bind_skill_info{idx = I, skill_idx = S} <- BindSkillList3, I =/= 1]
		})
	catch
		ErrCode -> player:send(#pk_GS2U_RequestBindSkillRet{role_id = RoleId, type = 1, err_code = ErrCode})
	end.
bind_skill_by_hand(Role, SkillIdx, BindIndex) ->
	#role{role_id = RoleId, skillList = SkillList, bindSkillInfoListByHand = BindSkillList} = Role,
	?CHECK_THROW(SkillIdx =:= 0 orelse lists:keymember(SkillIdx, #playerSkillInfo.index, SkillList), ?ErrorCode_Skill_NotLearn),
	?CHECK_THROW(lists:keymember(SkillIdx, #bind_skill_info.skill_idx, Role#role.bindSkillInfoList), ?ErrorCode_Skill_CannotEquip),
	OldSkillIdx = case lists:keyfind(BindIndex, #bind_skill_info.idx, BindSkillList) of
					  #bind_skill_info{skill_idx = SkillIdx} ->
						  throw(?ErrorCode_Skill_AlreadyEquip);
					  #bind_skill_info{skill_idx = I} -> I;
					  _ ->
						  ?LOG_ERROR("skill bind wrong, RileID: ~p, BindIndex: ~p, BindSkillList: ~p", [RoleId, BindIndex, BindSkillList]),
						  throw(?ErrorCode_Skill_CannotEquip)
				  end,
	%% 检查是否可以装配
	case SkillIdx =:= 0 orelse check_can_equip_by_hand(SkillIdx, BindIndex) of
		?TRUE -> skip;
		_ -> throw(?ErrorCode_Skill_CannotEquip)
	end,
	%% 1. 直接镶嵌上去  2. 把镶嵌的技能从原来的位置取下来
	F_Off = fun
				(#bind_skill_info{idx = Idx, skill_idx = SkillIdx1} = Info, Ret) when SkillIdx =/= 0 andalso SkillIdx =:= SkillIdx1 ->
					lists:keystore(Idx, #bind_skill_info.idx, Ret, Info#bind_skill_info{skill_idx = OldSkillIdx});
				(_, Ret) -> Ret
			end,
	BindSkillList1 = lists:foldl(F_Off, BindSkillList, BindSkillList),
	BindSkillList2 = lists:keystore(BindIndex, #bind_skill_info.idx, BindSkillList1, #bind_skill_info{idx = BindIndex, skill_idx = SkillIdx}),
	BindSkillList3 = case lists:keyfind(1, #bind_skill_info.idx, BindSkillList2) of
						 #bind_skill_info{skill_idx_list = NormalList} = NormalSkillInfo when SkillIdx =/= 0 ->
							 lists:keystore(1, #bind_skill_info.idx, BindSkillList2, NormalSkillInfo#bind_skill_info{
								 skill_idx_list = NormalList -- [SkillIdx]});
						 _ -> BindSkillList2
					 end,
	Role#role{bindSkillInfoListByHand = BindSkillList3}.

%% 自动装配
auto_bind_skill_by_hand(RoleId, SkillIdx) -> ?metrics(begin
														  try
															  Role = role_data:get_role(RoleId),
															  #role{skillList = SkillList, bindSkillInfoListByHand = BindSkillList} = Role,
															  case lists:keyfind(SkillIdx, #playerSkillInfo.index, SkillList) of
																  #playerSkillInfo{} -> ok;
																  _ -> throw(?ErrorCode_Skill_NotLearn)
															  end,
															  case lists:keyfind(SkillIdx, #bind_skill_info.skill_idx, BindSkillList) of
																  #bind_skill_info{} ->
																	  throw(?ErrorCode_Skill_AlreadyEquip);
																  _ -> ok
															  end,
															  NullBindList = [BindInfo || #bind_skill_info{idx = Idx, skill_idx = 0} = BindInfo <- BindSkillList, Idx =/= 1],
															  BindIndex = case lists:keysort(#bind_skill_info.idx, NullBindList) of
																			  [#bind_skill_info{idx = Idx} | _] -> Idx;
																			  _ -> throw(?ErrorCode_Skill_CannotEquip)
																		  end,
															  case check_can_equip_by_hand(SkillIdx, BindIndex) of
																  ?TRUE -> ok;
																  ?FALSE -> throw(?ErrorCode_Skill_CannotEquip)
															  end,
															  NewBindSkillList = lists:keystore(BindIndex, #bind_skill_info.idx, BindSkillList, #bind_skill_info{idx = BindIndex, skill_idx = SkillIdx}),
															  role_data:update_role(Role#role{bindSkillInfoListByHand = NewBindSkillList}),
															  send_skill_msg(),
															  player:send(#pk_GS2U_RequestBindSkillRet{
																  err_code = ?ERROR_OK, type = 1,
																  new_bind_list = [#pk_BindSkillBase{bind_index = I, skill_index = S} || #bind_skill_info{idx = I, skill_idx = S} <- NewBindSkillList, I =/= 1]
															  })
														  catch
															  _ErrCode -> ok
														  end end).

check_can_equip(SkillIndex, BindIndex, _BindSkillList) ->
	case cfg_skillEquip:getRow(SkillIndex) of
		#skillEquipCfg{type = 1} ->
			CareerLv = change_role:get_career_lv(),
			[Tuple | _] = df:getGlobalSetupValueList(autoSkillUnlockPosition, [{0, 0, 0, 0, 1, 2}]),
			UnlockPosNum = length([Lv || Lv <- tuple_to_list(Tuple), Lv =< CareerLv]),
			UnlockPosNum >= BindIndex - 1;
		_ -> ?FALSE
	end.

check_can_equip_by_hand(SkillIndex, BindIndex) ->
	case cfg_skillEquip:getRow(SkillIndex) of
		#skillEquipCfg{type = 1} ->
			CareerLv = change_role:get_career_lv(),
			[Tuple | _] = df:getGlobalSetupValueList(skillUnlockPosition, [{0, 0, 0, 0, 1, 2}]),
			UnlockPosNum = length([Lv || Lv <- tuple_to_list(Tuple), Lv =< CareerLv]),
			UnlockPosNum >= BindIndex - 1;
		_ -> ?FALSE
	end.

%%bind_skill_normal(RoleId, SkillIndexes) ->
%%	try
%%		BindIndex = 1,
%%		Role = role_data:get_role(RoleId),
%%		#role{skillList = SkillList, bindSkillInfoList = BindSkillList} = Role,
%%		case length(SkillIndexes) > 4 of
%%			?TRUE -> throw(?ErrorCode_Skill_NumMax);
%%			_ -> skip
%%		end,
%%
%%		CheckExistFun = fun(SkillIdx) ->
%%			case cfg_skillEquip:getRow(SkillIdx) of
%%				#skillEquipCfg{autoEquip = 1} -> ok;
%%				_ -> throw(?ErrorCode_Skill_CannotEquip)
%%			end,
%%
%%			case lists:keyfind(SkillIdx, #playerSkillInfo.index, SkillList) of
%%				#playerSkillInfo{} -> ok;
%%				_ -> throw(?ErrorCode_Skill_NotLearn)
%%			end,
%%			case lists:keyfind(SkillIdx, #bind_skill_info.skill_idx, BindSkillList) of
%%				#bind_skill_info{} ->
%%					throw(?ErrorCode_Skill_AlreadyEquip);
%%				_ -> skip
%%			end end,
%%		lists:foreach(CheckExistFun, SkillIndexes),
%%
%%		BindSkillList1 = lists:keystore(BindIndex, #bind_skill_info.idx, BindSkillList, #bind_skill_info{idx = BindIndex, skill_idx_list = SkillIndexes}),
%%		role_data:update_role(Role#role{bindSkillInfoList = BindSkillList1}),
%%		player:send(#pk_GS2U_RequestBindNormalAttackRet{
%%			role_id = RoleId,
%%			err_code = ?ERROR_OK,
%%			skill_idxs = SkillIndexes
%%		}),
%%		send_skill_msg()
%%	catch
%%		ErrCode -> player:send(#pk_GS2U_RequestBindNormalAttackRet{role_id = RoleId, err_code = ErrCode})
%%	end.


send_skill_msg() ->
	MapDataId = playerMap:getMapDataID(),
	if
		MapDataId == 2110136 -> ok;
		true ->
			Msg = make_player_skill_msg(MapDataId),
			player:send(Msg)
	end.

make_player_skill_msg(#role{} = R) ->
	#pk_GS2U_SyncPlayerSkillList{role_skill_list = [make_role_skill_msg(R)]};
make_player_skill_msg(2110136) ->
	holy_wing:get_holy_wing_skill_msg();
make_player_skill_msg(MapDataID) ->
	MapAi = playerCopyMap:get_map_ai_by_map_data_id(MapDataID),
	RoleList = role_data:get_role_list(),
	case lists:member(MapAi, ?ExpeditionMapAIList) of
		?TRUE ->
			RoleMsgList = [
				begin
					FormatList = get_special_skill_cfg(RoleId) ++ get_roll_skill(SkillList),
					BindSkill = get_bind_skill(FormatList),
					#pk_role_skill{
						role_id = RoleId,
						skill_list = get_common_atk_skill(FormatList),
						bind_skill_list = BindSkill,
						bind_skill_list_by_hand = BindSkill
					}
				end
				|| #role{role_id = RoleId, skillList = SkillList} <- RoleList],
			#pk_GS2U_SyncPlayerSkillList{role_skill_list = RoleMsgList};
		_ ->
			RoleMsgList = lists:map(fun make_role_skill_msg/1, RoleList),
			#pk_GS2U_SyncPlayerSkillList{role_skill_list = RoleMsgList}
	end.

get_common_atk_skill(FormatList) ->
	[#pk_SkillBase{index = Index, skill_id = SkillID,
		skill_level = Lv, break_lv = 1, awaken_lv = 1} || {SkillID, Lv, [], Index} <- FormatList, SkillID =/= 0].
get_bind_skill(FormatList) ->
	[#pk_BindSkillBase{bind_index = Index - 1, skill_index = Index
	} || {SkillID, _Lv, [], Index} <- FormatList, SkillID =/= 0, Index > 2].

make_player_skill_msg(_SkillList, _M2) ->
%% TODO 三主角技能？？？
	#pk_GS2U_SyncPlayerSkillList{
		role_skill_list = [
%%			#pk_role_skill{
%%				role_id = role_data:get_leader_id(),
%%				skill_list = [make_skill_msg(Skill) || Skill <- SkillList, Skill#playerSkillInfo.skillID =/= 0],
%%				bind_skill_list = [#pk_BindSkillBase{bind_index = Idx, skill_index = SkillIdx} || {Idx, SkillIdx} <- M2],
%%				bind_skills_normal = []
%%			}
		]
	}.
make_skill_msg(RoleId, Skill) ->
	SkillInfo = skill_up:get_skill_up(RoleId, Skill#playerSkillInfo.index),
	#pk_SkillBase{
		index = Skill#playerSkillInfo.index,
		skill_id = Skill#playerSkillInfo.skillID,
		skill_level = SkillInfo#skill_up.level,
		break_lv = skill_up:find_state_level(SkillInfo, 1),
		awaken_lv = skill_up:find_state_level(SkillInfo, 2),
		exp = skill_up:find_state_level(SkillInfo, 3)
	}.
make_role_skill_msg(#role{role_id = RoleId, skillList = SkillList, bindSkillInfoList = BindSkillList, bindSkillInfoListByHand = BindSkillListByHand}) ->
	F = fun(#bind_skill_info{idx = Idx, skill_idx = SkillIdx, skill_idx_list = SkillIdxList}, {R1, R2}) ->
		case Idx =:= 1 of
			?TRUE -> {SkillIdxList, R2};
			_ -> {R1, [#pk_BindSkillBase{bind_index = Idx, skill_index = SkillIdx} | R2]}
		end
		end,
	{M1, M2} = lists:foldl(F, {[], []}, BindSkillList),
	M3 = [#pk_BindSkillBase{bind_index = Idx, skill_index = SkillIdx} || #bind_skill_info{idx = Idx, skill_idx = SkillIdx} <- BindSkillListByHand, Idx =/= 1],
	#pk_role_skill{
		role_id = RoleId,
		skill_list = [make_skill_msg(RoleId, Skill) || Skill <- SkillList, Skill#playerSkillInfo.skillID =/= 0],
		bind_skill_list = M2,
		bind_skills_normal = M1,
		bind_skill_list_by_hand = M3
	}.

on_skill_change() ->
	WithFunc = fun() -> skill_player:send_skill_msg() end,
	on_skill_change(WithFunc).
on_skill_change(WithFunc) ->
	refresh_skill(),
	buff_player:on_buff_change(),
	attribute_player:on_prop_change(),
	RoleIdList = role_data:get_all_role_id(),
	player_refresh:on_refresh_skill(RoleIdList, WithFunc),
	ok.

refresh_skill() ->
%%	Astrolabe = astrolabe:get_skill_list(),
	Genius = genius:get_skill_list(),
%%	Ornament = ornament:get_skill_list(),
%%	Horcrux = horcrux:get_skill_list(),
%%	Weapon = weapon:get_skill_list(),
	ShieldSkill = holy_shield:get_skill_list(),
	ConstellationSkill = constellation:get_skill_list(),
%%	AncientHolyEqSkill = ancient_holy_eq:get_skill_list(),
%%	DivineTalentSkill = divine_talent:get_skill_list(),
%%	HolyWingSKill = holy_wing:get_skill_list(),
	BloodSkill = bloodline:get_skill_list(),
%%	SJSkill = shengjia:get_skill_list(),
	SJSkill = shengjia:get_skill_list(),
	DGStatue = g_dragon_statue:get_skill_list(),
	DGEq = g_dragon_eq:get_skill_list(),
	CupSkill = cup:get_skill_list(),
	ServerSealSkill = server_seal_player:get_player_skill(),
	CardSkill = eq:get_card_skill_list(),
	PetSacredEqSkill = pet_sacred_eq:get_player_skill_list(),%%英雄圣装技能
	OtherSkillList = Genius ++ ShieldSkill ++ BloodSkill ++ SJSkill ++ DGStatue ++ DGEq ++ CupSkill ++ ConstellationSkill ++ ServerSealSkill ++ CardSkill ++ PetSacredEqSkill,

	%% 角色1专属技能
	{BookSkill1, BookSkill2, BookSkill3} = get_skill_by_book(),
	FirstRoleSkillList = BookSkill1,
	%% 角色2专属技能
	SecondRoleSkillList = BookSkill2,
	%% 角色3专属技能
	ThirdRoleSkillList = BookSkill3,

	OrderRoleList = role_data:get_order_role_list(),
	NRoleList = lists:map(
		fun({Order, #role{role_id = RoleId, career = Career, dragon_id = DragonID} = Role}) ->
%%			LvUp = get_lv_up_skill(RoleId),
			SkillUp = skill_up:get_skill_list(RoleId, Career),
			Pet = pet:get_moling_skill_list(RoleId),
			Dragon = g_dragon:get_skill_list(RoleId),
			LordRing = lord_ring:get_skill_list(RoleId),
			Prophecy = prophecy:get_skill_list(RoleId),
			Mount = mount:get_skill_list(RoleId),
			Wing = wing:get_skill_list(RoleId),
			ChangeRole = change_role:get_skill_list(RoleId),
			Relic = relic:get_skill_list(RoleId),
			DressUp = dress_up:get_skill_list(RoleId),
			DGWeapon = g_dragon_weapon:get_skill_list(DragonID),
			EqSuit = eq:get_suit_skill_list(RoleId),
			Weapon = weapon:get_skill_list(RoleId),
			Astrolabe = astrolabe:get_skill_list(RoleId),


			OrderSkill = case Order of
							 1 -> FirstRoleSkillList;
							 2 -> SecondRoleSkillList;
							 _ -> ThirdRoleSkillList
						 end,

			SkillList = SkillUp ++ Pet ++ Dragon ++ OtherSkillList ++ OrderSkill ++ LordRing ++ Prophecy ++ Mount
				++ Wing ++ ChangeRole ++ Relic ++ DressUp ++ DGWeapon ++ EqSuit ++ Weapon ++ Astrolabe,
			NewSkillList = add_skill(SkillList, []),
			Role#role{skillList = NewSkillList}
		end, OrderRoleList),
	role_data:update_role(NRoleList).

get_skill_buff_fix(#role{skillList = SkillList}) ->
	lists:foldl(fun(#playerSkillInfo{skillID = SkillID}, Ret) ->
		case cfg_skillBase:getRow(SkillID) of
			#skillBaseCfg{buffCorr = [{0, 0, 0}]} -> Ret;
			#skillBaseCfg{skillType = {1, _, 0}, skillEffect = {0, _, _}, buffCorr = BuffCorr} ->
				[fix_buff_corr_type(B) || {T, _, _} = B <- BuffCorr, T > 0] ++ Ret;
			_ -> Ret
		end
				end, [], SkillList).
fix_buff_corr_type({2, P1, P2}) -> {3, P1, P2};
fix_buff_corr_type({3, P1, P2}) -> {1, P1, P2};
fix_buff_corr_type({101, P1, P2}) -> {2, P1, P2}.

make_player_skill(SkillList) ->
	add_skill(SkillList, []).

add_skill([], SkillList) -> SkillList;
add_skill([{1, SkillId, Index} | T], SkillList) ->
	case lists:keytake(Index, #playerSkillInfo.index, SkillList) of
		?FALSE -> add_skill(T, [#playerSkillInfo{index = Index, skillID = SkillId, level = 1} | SkillList]);
		{value, PlayerSkillInfo, Tail} ->
			add_skill(T, [PlayerSkillInfo#playerSkillInfo{index = Index, skillID = SkillId} | Tail])
	end;
%% 龙神技能修更随技能
add_skill([{1, SkillId, Index, FixList} | T], SkillList) when is_list(FixList) ->
	case lists:keytake(Index, #playerSkillInfo.index, SkillList) of
		?FALSE ->
			add_skill(T, [#playerSkillInfo{index = Index, skillID = SkillId, level = 1, fix_list = FixList} | SkillList]);
		{value, PlayerSkillInfo, Tail} ->
			add_skill(T, [PlayerSkillInfo#playerSkillInfo{index = Index, skillID = SkillId, fix_list = FixList} | Tail])
	end;
add_skill([{1, SkillId, Index, Level} | T], SkillList) ->
	case lists:keytake(Index, #playerSkillInfo.index, SkillList) of
		?FALSE -> add_skill(T, [#playerSkillInfo{index = Index, skillID = SkillId, level = Level} | SkillList]);
		{value, PlayerSkillInfo, Tail} ->
			add_skill(T, [PlayerSkillInfo#playerSkillInfo{index = Index, skillID = SkillId, level = Level} | Tail])
	end;
add_skill([{2, FixID, Index} | T], SkillList) ->
	case lists:keytake(Index, #playerSkillInfo.index, SkillList) of
		?FALSE ->
			add_skill(T, [#playerSkillInfo{index = Index, skillID = 0, level = 1, fix_list = [FixID]} | SkillList]);
		{value, PlayerSkillInfo, Tail} ->
			FixList = case lists:member(FixID, PlayerSkillInfo#playerSkillInfo.fix_list) of
						  ?TRUE -> PlayerSkillInfo#playerSkillInfo.fix_list;
						  _ -> [FixID | PlayerSkillInfo#playerSkillInfo.fix_list]
					  end,
			add_skill(T, [PlayerSkillInfo#playerSkillInfo{index = Index, fix_list = FixList} | Tail])
	end.


gm_do_skill(Index, SkillId, FixList) ->
	?LOG_ERROR("skill change :~p", [{Index, SkillId, FixList}]),
	RoleId = role_data:get_leader_id(),
	role_data:update_role_with(
		fun(#role{skillList = SkillList} = Role) ->
			NewSkillList = lists:keystore(Index, #playerSkillInfo.index, SkillList, #playerSkillInfo{index = Index, level = 1, skillID = SkillId, fix_list = FixList}),
			Role#role{skillList = NewSkillList}
		end, RoleId),
	send_skill_msg(),
	player_refresh:on_refresh_skill([RoleId], null),
	attribute_player:on_prop_change(),
	ok.

%% 龙神宠物切换技能
set_choose_skill(Type, Id) -> ?metrics(begin
										   try
											   ?CHECK_THROW(Id == 0 orelse check_condition(Type, Id), ?ERROR_Param),
											   set_choose_id(Type, Id),
											   player_refresh:on_refresh_pet_skill(),
											   SL = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixList, skill_index = Pos} || {SkillID, Level, FixList, Pos} <- pet:get_available_pet_skill_list()],
											   player:send(#pk_GS2U_skill_choose_ret{type = Type, skill_list = SL})
										   catch
											   _ -> player:send(#pk_GS2U_skill_choose_ret{type = Type})
										   end end).
-define(SKILL_LIST_DRAGON_GOD, [7, 8, 9, 10, 11, 12]). %% 龙神技能位
-define(SKILL_LIST_PET, [13, 14, 15, 16]). %% 宠物技能位

check_condition(1, Id) ->
	g_dragon:is_gd_active(Id);
check_condition(2, Id) -> pet:is_pet_active(Id);
check_condition(_Type, _Id) -> ?FALSE.
set_choose_id(2, Id) -> pet:set_fight_flag(Id, 1).
%%get_choose_skill(RoleId, 1, _) ->
%%	get_skill_info_(RoleId, ?SKILL_LIST_DRAGON_GOD);
%%get_choose_skill(RoleId, 2, _) ->
%%	get_skill_info_(RoleId, ?SKILL_LIST_PET).
%%refresh_skill(RoleId, _Type, _Id) ->
%%	refresh_skill(RoleId),
%%	player_refresh:on_refresh_skill_not_send(RoleId),
%%	attribute_player:on_prop_change().

%%get_skill_info_(RoleId, PosL) ->
%%	SkillL = get_available_skill_fix_list(RoleId, playerMap:getMapDataID()),
%%	F1 = fun(SId, Acc1) ->
%%		case lists:keyfind(SId, 1, SkillL) of
%%			?FALSE -> Acc1;
%%			S -> %% {SkillID, Level, FixList, Index}
%%				[S | Acc1]
%%		end
%%		 end,
%%	F = fun(Pos, Acc) ->
%%		case lists:keyfind(Pos, 4, SkillL) of
%%			?FALSE -> Acc;
%%			S -> %% {SkillID, Level, FixList, Index}
%%				L = lists:foldl(F1, Acc, element(3, S)),
%%				[S | L]
%%		end
%%		end,
%%	lists:foldl(F, [], PosL).

get_skill_by_book() ->
	L = common:listValueMerge([{CfgID, Num} || #item{cfg_id = CfgID, amount = Num} <- bag_player:get_bag_item_list(?BAG_SKILL_BOOK)]),
	F = fun({CfgId, 1}, {SkillList1, SkillList2, SkillList3}) ->
		#itemCfg{useType = 71, useParam1 = P1, useParam2 = P2} = df:getItemDefineCfg(CfgId),
		{[{1, P1, P2} | SkillList1], SkillList2, SkillList3};
		({CfgId, 2}, {SkillList1, SkillList2, SkillList3}) ->
			#itemCfg{useType = 71, useParam1 = P1, useParam2 = P2} = df:getItemDefineCfg(CfgId),
			{[{1, P1, P2} | SkillList1], [{1, P1, P2} | SkillList2], SkillList3};
		({CfgId, Amount}, {SkillList1, SkillList2, SkillList3}) when Amount >= 3 ->
			#itemCfg{useType = 71, useParam1 = P1, useParam2 = P2} = df:getItemDefineCfg(CfgId),
			{[{1, P1, P2} | SkillList1], [{1, P1, P2} | SkillList2], [{1, P1, P2} | SkillList3]};
		(_, _) -> skip
		end,
	lists:foldl(F, {[], [], []}, L).


get_special_skill_info(RoleId) ->
	[#playerSkillInfo{skillID = SkillID, level = Level, fix_list = FixList, index = Index} ||
		{SkillID, Level, FixList, Index} <- get_special_skill_cfg(RoleId)].

get_special_skill_cfg(RoleId) ->
	Career = player:getCareer(RoleId),
	CfgSkillList =
		case Career of
			1004 -> df:getGlobalSetupValueList(expeditionSkill1, []);
			1005 -> df:getGlobalSetupValueList(expeditionSkill2, []);
			1006 -> df:getGlobalSetupValueList(expeditionSkill3, []);
			1007 -> df:getGlobalSetupValueList(expeditionSkill4, []);
			_ -> []
		end,
	SkillList1 = [{SkillID, 1, [], Index} || {SkillID, Index} <- CfgSkillList],
	constellation:get_season_gem_skill() ++ SkillList1.

get_special_skill_cfg_mirror({PlayerID, Career}) ->
	CfgSkillList =
		case Career of
			1004 -> df:getGlobalSetupValueList(expeditionSkill1, []);
			1005 -> df:getGlobalSetupValueList(expeditionSkill2, []);
			1006 -> df:getGlobalSetupValueList(expeditionSkill3, []);
			1007 -> df:getGlobalSetupValueList(expeditionSkill4, []);
			_ -> []
		end,
	SkillList1 = [{SkillID, 1, [], Index} || {SkillID, Index} <- CfgSkillList],
	constellation:get_mirror_season_gem_skill(PlayerID) ++ SkillList1.

%% 携带角色技能
get_roll_skill(SkillList) ->
	[{SkillID, Level, FixList, Index} || #playerSkillInfo{skillID = SkillID, level = Level, index = Index, fix_list = FixList} <- SkillList,
		lists:member(Index, [?SkillPos_2, ?SkillPos_7, ?SkillPos_675, ?SkillPos_678, ?SkillPos_687, ?SkillPos_688])].
