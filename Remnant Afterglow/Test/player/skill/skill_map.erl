%%%-------------------------------------------------------------------
%%% @author xiehonggang
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 26. 七月 2018 11:23
%%%-------------------------------------------------------------------
-module(skill_map).
-author("xiehonggang").

-include("netmsgRecords.hrl").
-include("skill_new.hrl").
-include("global.hrl").
-include("cfg_skillBase.hrl").
-include("error.hrl").
-include("id_generator.hrl").
-include("attribute.hrl").
-include("logger.hrl").
-include("record.hrl").
-include("gameMap.hrl").
%% API
-export([map_skill_init/2, map_skill_init/3, skill_clean/2, get_object_skill/3, set_object_skill_item/3, add_map_skill/3, remove_map_skill/3, transform_skill_clean/2]).
-export([send_obj_skill_fix_list_msg/2, send_obj_skill_by_view/2, check_obj_use_skill/3]).
-export([get_skill_list/2, get_use_skill_cd/2, erase_use_skill_cd/2, on_obj_enter_map/1]).
-export([check_dead_trigger_skill/4, silence/3, undo_silence/3]).
-export([cache_skill_seg/3, check_skill_hit/3, check_skill_buff/3]).
-export([deal_player_skill_cd/3, reset_player_skill_cd/2, send_skill_fix/2, erase_lock_hp/2, set_lock_hp/3, get_lock_hp/2, get_damage_limit/2,
	set_damage_limit/3, erase_damage_limit/2, get_shield_percent/2, set_shield_percent/3, erase_shield_percent/2,
	get_suck_blood_percent/2, set_suck_blood_percent/3, add_suck_blood_percent/5, erase_suck_blood_percent/2, remove_suck_blood_percent/3]).
-export([map_skill_change/3, set_object_attack_time/2, get_object_attack_time/1, erase_object_attack_time/1]).
-export([clear_skill_damage_param/3, find_skill_damage_param/5, store_skill_damage_param/6, dead_trigger_ing/3]).

%% 改对象的所有可以使用的技能
map_skill_init(ObjectID, RoleSkillList) ->
	MsgList = lists:foldl(
		fun({RoleId, SkillList}, List) ->
			set_skill_list(ObjectID, RoleId, SkillList),
			SkillInfoList = skill_lib:make_map_skill_list(SkillList),
			add_total_skill_2_map(ObjectID, RoleId, SkillInfoList),
			case id_generator:id_type(ObjectID) of
				?ID_TYPE_Player ->
					case id_generator:id_type(RoleId) of
						?ID_TYPE_MY_PET ->
							FixList = [#pk_SkillFix{skillID = SkillID, skill_index = Index, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, Index} <- SkillList],
							[#pk_SkillFixSt{role_id = RoleId, fixList = FixList} | List];
						_ ->
							FixList = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, _} <- SkillList],
							[#pk_SkillFixSt{role_id = RoleId, fixList = FixList} | List]
					end;
				_ -> List
			end
		end, [], RoleSkillList),
	map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = MsgList}).
map_skill_init(ObjectID, RoleId, SkillList) ->
	case transform:is_skill_refresh_cache(ObjectID, RoleId) of
		?FALSE ->
			set_skill_list(ObjectID, RoleId, SkillList),
			SkillInfoList = skill_lib:make_map_skill_list(SkillList),
			add_total_skill_2_map(ObjectID, RoleId, SkillInfoList),
			case id_generator:id_type(ObjectID) of
				?ID_TYPE_Player ->
					case map_role:is_role_enable(ObjectID, RoleId) of
						?TRUE ->
							case id_generator:id_type(RoleId) of
								?ID_TYPE_MY_PET ->
									MsgList = [#pk_SkillFix{skillID = SkillID, skill_index = Index, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, Index} <- SkillList],
									RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
									map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]});
								_ ->
									MsgList = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, _} <- SkillList],
									RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
									map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]})
							end;
						?FALSE -> ok
					end;
				_ -> skip
			end;
		?TRUE -> %% 变身状态下，技能先存到备份
			mapdb:setSkillListBuckUp(ObjectID, RoleId, SkillList)
	end.

add_map_skill(_ObjectID, _RoleId, []) -> ok;
add_map_skill(ObjectID, RoleId, AddSkillList) ->
	OldSkillList = get_skill_list(ObjectID, RoleId),
	NewSkillList = lists:foldl(fun({SkillID, _, _, _} = R, Ret) ->
		lists:keystore(SkillID, 1, Ret, R) end, OldSkillList, AddSkillList),
	set_skill_list(ObjectID, RoleId, NewSkillList),
	SkillInfoList = skill_lib:make_map_skill_list(AddSkillList),
	add_total_skill_2_map(ObjectID, RoleId, SkillInfoList),
	case id_generator:id_type(ObjectID) of
		?ID_TYPE_Player ->
			case map_role:is_role_enable(ObjectID, RoleId) of
				?TRUE ->
					case id_generator:id_type(RoleId) of
						?ID_TYPE_MY_PET ->
							MsgList = [#pk_SkillFix{skillID = SkillID, skill_index = Index, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, Index} <- NewSkillList],
							RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
							map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]});
						_ ->
							MsgList = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, _} <- NewSkillList],
							RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
							map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]})
					end;
				?FALSE -> ok
			end;
		_ -> skip
	end.
remove_map_skill(_ObjectID, _RoleId, []) -> ok;
remove_map_skill(ObjectID, RoleId, RemoveSkillIDList) ->
	OldSkillList = get_skill_list(ObjectID, RoleId),
	NewSkillList = lists:foldl(fun(SkillID, Ret) ->
		lists:keydelete(SkillID, 1, Ret) end, OldSkillList, RemoveSkillIDList),
	set_skill_list(ObjectID, RoleId, NewSkillList),
	[erlang:erase({?MapObjectSkillItem, ObjectID, RoleId, SkillID}) || SkillID <- RemoveSkillIDList],
%%	%% 移除该技能cd
%%	UseSkillCdList = get_use_skill_cd(ObjectID, RoleId),
%%	NewCdMap = maps:filter(fun(SkillID, _) ->
%%		not lists:member(SkillID, RemoveSkillIDList) end, UseSkillCdList#use_skill_cd.cd_map),
%%	set_use_skill_cd(ObjectID, RoleId, #use_skill_cd{cd_map = NewCdMap}),

	case id_generator:id_type(ObjectID) of
		?ID_TYPE_Player ->
			case map_role:is_role_enable(ObjectID, RoleId) of
				?TRUE ->
					case id_generator:id_type(RoleId) of
						?ID_TYPE_MY_PET ->
							MsgList = [#pk_SkillFix{skillID = SkillID, skill_index = Index, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, Index} <- NewSkillList],
							RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
							map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]});
						_ ->
							MsgList = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, _} <- NewSkillList],
							RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
							map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]})
					end;
				?FALSE -> ok
			end;
		_ -> skip
	end.

map_skill_change(ObjectID, RoleId, SkillList) ->
	set_skill_list(ObjectID, RoleId, SkillList),
	SkillInfoList = skill_lib:make_map_skill_list(SkillList),
	add_total_skill_2_map(ObjectID, RoleId, SkillInfoList).

send_skill_fix(ObjectID, RoleId) ->
	SkillList = get_skill_list(ObjectID, RoleId),
	case id_generator:id_type(ObjectID) of
		?ID_TYPE_Player ->
			case map_role:is_role_enable(ObjectID, RoleId) of
				?TRUE ->
					case id_generator:id_type(RoleId) of
						?ID_TYPE_MY_PET ->
							MsgList = [#pk_SkillFix{skillID = SkillID, skill_index = Index, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, Index} <- SkillList],
							RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
							map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]});
						_ ->
							MsgList = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixIDList} || {SkillID, Level, FixIDList, _} <- SkillList],
							RoleFixSt = #pk_SkillFixSt{role_id = RoleId, fixList = MsgList},
							map:send(ObjectID, #pk_GS2U_MySkillFix{fix_skill_list = [RoleFixSt]})
					end;
				?FALSE -> ok
			end;
		_ -> skip
	end.

%% 进入地图初始化Cd  TODO  切换地图保存cd
on_obj_enter_map(ObjId) ->
	RoleIdList = map_role:get_role_id_list(?ID_TYPE_Player, ObjId),
	lists:foreach(
		fun(RoleId) ->
			on_obj_enter_map(ObjId, RoleId)
		end, RoleIdList).
on_obj_enter_map(ObjId, RoleId) ->
	case get({?MapObjectCleanSkillInfo, ObjId, RoleId}) of
		?UNDEFINED -> skip;
		List ->
			TimeMillisecond = time:time_ms(),
			F = fun(SkillId, Map) ->
				case get_object_skill(ObjId, RoleId, SkillId) of
					#skill_map_info{cd_para = {_CdGroup, CD, InitCd, N, _Interval}} when InitCd > 0 ->
						case N < 2 of
							?TRUE -> maps:put(SkillId, {TimeMillisecond - CD + InitCd, 0}, Map);
							_ ->
								maps:put(SkillId, {TimeMillisecond, CD * N - InitCd}, Map)
						end;
					_ -> Map
				end
				end,
			CdMap = lists:foldl(F, maps:new(), List),
			case maps:size(CdMap) > 0 of
				?TRUE ->
					set_use_skill_cd(ObjId, RoleId, #use_skill_cd{cd_map = CdMap});
				_ -> skip
			end
	end.

%% 将周围对象的技能推送给PlayerIDList
%% ObjectList = [{ObjID, RoleId}]
send_obj_skill_fix_list_msg([], _) -> ok;
send_obj_skill_fix_list_msg(_, []) -> ok;
send_obj_skill_fix_list_msg(PlayerIDList, ObjectList) ->
	Msg = make_obj_skill_msg(ObjectList),
	case Msg#pk_GS2U_ObjectSkillFix.objectFixList of
		[] -> ok;
		_ -> mapView:send_to_player_list(PlayerIDList, Msg)
	end.
%% 把object技能推送周围
send_obj_skill_by_view(ObjectId, RoleId) ->
	case map_role:is_role_enable(ObjectId, RoleId) of
		?TRUE ->
			Msg = make_obj_skill_msg([{ObjectId, RoleId}]),
			case Msg#pk_GS2U_ObjectSkillFix.objectFixList of
				[] -> ok;
				_ -> mapView:broadcastByView_client(Msg, ObjectId, ObjectId)
			end;
		?FALSE -> ok
	end.

%% ObjectList = [{ObjID, RoleId}]
make_obj_skill_msg(ObjectList) ->
	F = fun({ObjID, RoleId}) ->
		SkillList = get_skill_list(ObjID, RoleId),
		MsgList = [#pk_SkillFix{skillID = SkillID, level = Level, fixIDList = FixIDList, skill_index = SkillIndex} || {SkillID, Level, FixIDList, SkillIndex} <- SkillList],
		#pk_ObjectSkillFix{objectID = ObjID, roleID = RoleId, fixList = MsgList}
		end,
	MsgList = lists:map(F, ObjectList),
	#pk_GS2U_ObjectSkillFix{objectFixList = MsgList}.

%% 存储修正后的技能
set_object_skill_item(ObjectID, RoleId, SkillItem) ->
	put({?MapObjectSkillItem, ObjectID, RoleId, SkillItem#skill_map_info.skill_id}, SkillItem).
%% 获取object对应技能id的数据
get_object_skill(ObjectID, RoleId, SkillID) ->
	case get({?MapObjectSkillItem, ObjectID, RoleId, SkillID}) of
		?UNDEFINED ->
%%			?LOG_INFO("skill not store in map :~p", [{SkillID, ObjectID, mapSup:getMapDataID()}]), %% 变身结束后这里打印太频繁，先去掉
			{};
		SkillItem ->
			SkillItem
	end.
add_total_skill_2_map(ObjectID, RoleId, SkillList) ->
	F = fun(X) ->
		set_object_skill_item(ObjectID, RoleId, X),
		X#skill_map_info.skill_id
		end,
	L = lists:map(F, SkillList),
	case get({?MapObjectCleanSkillInfo, ObjectID, RoleId}) of
		?UNDEFINED ->
			put({?MapObjectCleanSkillInfo, ObjectID, RoleId}, L);
		List ->
			put({?MapObjectCleanSkillInfo, ObjectID, RoleId}, (List -- L) ++ L)
	end.
%% 存储未修正的技能信息  [{SkillID, Level, FixIDList, SkillIndex}]
set_skill_list(ObjectID, RoleId, Info) ->
	put({?MapObjectSkillInfo, ObjectID, RoleId}, Info).
get_skill_list(ObjectID, RoleId) ->
	case get({?MapObjectSkillInfo, ObjectID, RoleId}) of
		?UNDEFINED -> [];
		List -> List
	end.
skill_clean(ObjectID, RoleId) ->
	erlang:erase({?MapObjectSkillInfo, ObjectID, RoleId}),
	erase_use_skill_cd(ObjectID, RoleId),
	erase_science_list(ObjectID, RoleId),
	erase_cache_skill(ObjectID, RoleId),
	erase_lock_hp(ObjectID, RoleId),
	erase_damage_limit(ObjectID, RoleId),
	erase_suck_blood_percent(ObjectID, RoleId),
	erase_shield_percent(ObjectID, RoleId),
	erase_cache_skill_damage_param(ObjectID, RoleId),
	erase_dead_trigger_ing(ObjectID, RoleId),
	case get({?MapObjectCleanSkillInfo, ObjectID, RoleId}) of
		?UNDEFINED ->
			ok;
		List ->
			[erlang:erase({?MapObjectSkillItem, ObjectID, RoleId, SkillID}) || SkillID <- List],
			erlang:erase({?MapObjectCleanSkillInfo, ObjectID, RoleId})
	end.
transform_skill_clean(ObjectID, RoleId) ->
	UseSkillCdList = get_use_skill_cd(ObjectID, RoleId),
	skill_clean(ObjectID, RoleId),
	NewCdMap = maps:filter(fun(SkillID, _) ->
		case cfg_skillBase:getRow(SkillID) of
			#skillBaseCfg{skillkeep = 1} -> ?TRUE;
			_ -> ?FALSE
		end
						   end, UseSkillCdList#use_skill_cd.cd_map),
	set_use_skill_cd(ObjectID, RoleId, #use_skill_cd{cd_map = NewCdMap}).

get_use_skill_cd(ObjId, RoleId) ->
	case get({'use_skill_cd', ObjId, RoleId}) of ?UNDEFINED -> #use_skill_cd{};Ret -> Ret end.
set_use_skill_cd(ObjId, RoleId, V) -> put({'use_skill_cd', ObjId, RoleId}, V).
erase_use_skill_cd(ObjId, RoleId) -> erase({'use_skill_cd', ObjId, RoleId}).

get_science_list(ObjId, RoleId) -> case get({'science_list', ObjId, RoleId}) of ?UNDEFINED -> [];Ret -> Ret end.
set_science_list(ObjId, RoleId, V) -> put({'science_list', ObjId, RoleId}, V).
erase_science_list(ObjId, RoleId) -> erase({'science_list', ObjId, RoleId}).


get_lock_hp(ObjId, RoleId) -> case get({'lock_hp_percent', ObjId, RoleId}) of
								  Per when is_integer(Per) -> Per;
								  _ -> 0
							  end.
set_lock_hp(ObjId, RoleId, V) -> put({'lock_hp_percent', ObjId, RoleId}, V).
erase_lock_hp(ObjId, RoleId) -> erase({'lock_hp_percent', ObjId, RoleId}).

get_damage_limit(ObjId, RoleId) -> case get({'damage_limit_percent', ObjId, RoleId}) of
									   Per when is_integer(Per) -> Per;
									   _ -> 10000
								   end.
set_damage_limit(ObjId, RoleId, V) -> put({'damage_limit_percent', ObjId, RoleId}, V).
erase_damage_limit(ObjId, RoleId) -> erase({'damage_limit_percent', ObjId, RoleId}).

get_shield_percent(ObjId, RoleId) -> case get({'damage_shield_percent', ObjId, RoleId}) of
										 Per when is_integer(Per) -> Per;
										 _ -> 0
									 end.
set_shield_percent(ObjId, RoleId, V) -> put({'damage_shield_percent', ObjId, RoleId}, V).
erase_shield_percent(ObjId, RoleId) -> erase({'damage_shield_percent', ObjId, RoleId}).

get_suck_blood_percent(ObjId, RoleId) -> case get({'damage_suck_blood_percent', ObjId, RoleId}) of
											 ?UNDEFINED -> [];
											 L -> L
										 end.
add_suck_blood_percent(ObjId, RoleId, IDTuple, Percent, Limit) ->
	L = get_suck_blood_percent(ObjId, RoleId),
	NL = lists:keystore(IDTuple, 1, L, {IDTuple, Percent, Limit}),
	set_suck_blood_percent(ObjId, RoleId, NL).
remove_suck_blood_percent(ObjId, RoleId, IDTuple) ->
	L = get_suck_blood_percent(ObjId, RoleId),
	NL = lists:keydelete(IDTuple, 1, L),
	set_suck_blood_percent(ObjId, RoleId, NL).
set_suck_blood_percent(ObjId, RoleId, List) ->
	put({'damage_suck_blood_percent', ObjId, RoleId}, List).
erase_suck_blood_percent(ObjId, RoleId) -> erase({'damage_suck_blood_percent', ObjId, RoleId}).


cache_skill_seg(PlayerId, RoleId, SkillId) ->
	case cfg_skillBase:getRow(SkillId) of
		#skillBaseCfg{damageArray = Arr, skillType = TypeTuple} ->
			T = max(length(Arr), 1),
			SkillMap = get_cache_skill(PlayerId, RoleId),
			{BuffTimes, TargetNum} = case get_object_skill(PlayerId, RoleId, SkillId) of
										 #skill_map_info{activate_effect = Effect, target = Target} ->
											 BuffIdList = [BuffId1 || {_P1, _P2, _P3, 2, BuffId1} <- Effect],
											 Sum = lists:sum([N || {_P1, _P2, _P3, N} <- Target]),
											 {length(BuffIdList), Sum};
										 _ -> {0, 0}
									 end,

			{HitTimes, BuffTriggerTimes} = case element(1, TypeTuple) of
											   2 -> {T, T * BuffTimes * TargetNum};
											   _ -> {T * TargetNum, T * BuffTimes * TargetNum}
										   end,

			NewSkillMap = maps:put(SkillId, {SkillId, HitTimes + 1, BuffTriggerTimes + 1}, SkillMap),
			set_cache_skill(PlayerId, RoleId, NewSkillMap);
		_ -> skip
	end.

check_skill_hit(PlayerId, RoleId, SkillId) ->
	SkillMap = get_cache_skill(PlayerId, RoleId),
	case maps:find(SkillId, SkillMap) of
		{ok, {_, T, T1}} when T > 0 ->
			NewSkillMap = maps:put(SkillId, {SkillId, T - 1, T1}, SkillMap),
			set_cache_skill(PlayerId, RoleId, NewSkillMap),
			?TRUE;
		_ -> ?FALSE
	end.
check_skill_buff(PlayerId, RoleId, SkillId) ->
	SkillMap = get_cache_skill(PlayerId, RoleId),
	case maps:find(SkillId, SkillMap) of
		{ok, {_, T, T1}} when T1 > 0 ->
			NewSkillMap = maps:put(SkillId, {SkillId, T, T1 - 1}, SkillMap),
			set_cache_skill(PlayerId, RoleId, NewSkillMap),
			?TRUE;
		_ -> ?FALSE
	end.



get_cache_skill(ObjId, RoleId) -> case get({'cache_skill_seg', ObjId, RoleId}) of ?UNDEFINED -> #{}; Map -> Map end.
set_cache_skill(ObjId, RoleId, Map) -> put({'cache_skill_seg', ObjId, RoleId}, Map).
erase_cache_skill(ObjId, RoleId) -> erase({'cache_skill_seg', ObjId, RoleId}).


%% 返回 {ErrCode, SkillEffect}
check_obj_use_skill(AttackerID, AttackerRoleId, SkillID) ->
	try
		case mapdb:isObjectDead(AttackerID, AttackerRoleId) of
			?TRUE -> throw(?ErrorCode_Skill_NotAlive);
			_ -> ok
		end,
		SkillItem = get_object_skill(AttackerID, AttackerRoleId, SkillID),
		case SkillItem =:= {} orelse cfg_skillBase:getRow(SkillID) =:= {} of
			?TRUE -> throw(?ErrorCode_Skill_NotExist);
			_ -> skip
		end,

		#skillBaseCfg{skillType = SkillType, skillEffect = {Effect, _, _}} = cfg_skillBase:getRow(SkillID),
		SkillTypeEle3 = element(3, SkillType),
		case lists:member(SkillTypeEle3, get_science_list(AttackerID, AttackerRoleId)) of
			?TRUE -> throw(?ErrorCode_Skill_Science);
			_ -> skip
		end,
		#skill_map_info{cd_para = CdParam, cost = CostList} = SkillItem,
		%% (技能组,基础冷却时间,初始冷却时间,技能存储次数,释放间隔)  误差允许
		{CdGroup, CD, _InitCd, N, Interval} = CdParam,
		CdInfo = get_use_skill_cd(AttackerID, AttackerRoleId),
		MilTime = time:time_ms(),

		CDReductionTypeList = df:getGlobalSetupValueList(cDreduction, []),
		FixCD = case lists:keyfind(SkillTypeEle3, 2, CDReductionTypeList) of
					?FALSE -> CD;
					{CDReduceP, _, MinFixCD} ->
						P1 = attribute_map:get_attribute(AttackerID, AttackerRoleId),
						max(MinFixCD, trunc(CD * (10000 - ?MAP(P1, CDReduceP)) / 10000))
				end,

		%% 1. 检查技能冷却  释放间隔/组/CD
		check_use_skill_cd_1(Interval, element(1, SkillType), MilTime, CdInfo),
		check_use_skill_cd_2(CdGroup, MilTime, CdInfo),
		check_use_skill_cd_3(CdGroup, {FixCD, N}, SkillID, MilTime, CdInfo),
		%% 3. 检查技能消耗
		F = fun
				({1, Rage}) -> mapdb:getObjectRage(AttackerID, AttackerRoleId) >= Rage;
				({2, _Rage}) -> mapdb:getObjectHp(AttackerID, AttackerRoleId) > 0;
				(_) -> ?FALSE
			end,
		case lists:all(F, CostList) of
			?TRUE -> skip;
			_ ->
%%				?LOG_ERROR("Skill Cost Err :~p", [{SkillID, CostList, mapdb:getObjectRage(AttackerID)}]),
				throw(?ErrorCode_Skill_NoEnoughCost)
		end,

		%% 可以使用直接更新技能CD
		update_use_skill_cd(AttackerID, AttackerRoleId, {FixCD, N, Interval}, CdInfo, CdGroup, MilTime, SkillID),
		{?ERROR_OK, Effect}
	catch
		Ret ->
			{Ret, 0}
	end.

check_use_skill_cd_1(0, _, _MilTime, _CdInfo) -> ok;
check_use_skill_cd_1(_, T, _MilTime, _CdInfo) when T =/= 2 -> ok;
check_use_skill_cd_1(_, _, _MilTime, #use_skill_cd{next_use_time = _NextCanUseTime}) -> %% 有问题 先不判断了
	ok.
%%	[throw(?ErrorCode_Skill_CD1) || MilTime < NextCanUseTime].

check_use_skill_cd_2(0, _MilTime, _) -> ok;
check_use_skill_cd_2(999, _MilTime, _) -> ok;
check_use_skill_cd_2(Gid, MilTime, #use_skill_cd{group_cd_list = GList}) ->
	case lists:keyfind(Gid, 1, GList) of
		{_, T} -> [throw(?ErrorCode_Skill_CD2) || MilTime < T];
		?FALSE -> ok
	end.

check_use_skill_cd_3(999, _, _, _, _) -> ok;
check_use_skill_cd_3(_, {CD, N}, SkillId, MilTime, #use_skill_cd{cd_map = CdMap}) ->
	{CdTime, CdAccumulate} = maps:get(SkillId, CdMap, {0, 0}),
	case N < 2 of
		?TRUE ->
			case MilTime - CdTime - CD > -1000 of
				?TRUE -> skip;
				_ -> throw(?ErrorCode_Skill_CD3)
			end;
		_ ->
			CdAll = max(0, min(MilTime - CdTime + CdAccumulate, N * CD)),
			RestCd = CdAll - CD,
			case RestCd > 0 of
				?TRUE -> skip;
				?FALSE -> throw(?ErrorCode_Skill_CD1)
			end
	end.

update_use_skill_cd(ObjId, RoleId, {CD, N, Interval}, Info, Group, MilTime, SkillId) ->
	#use_skill_cd{next_use_time = _T, group_cd_list = GList, cd_map = CdMap} = Info,
	{CdTime, CdAccumulate} = maps:get(SkillId, CdMap, {0, 0}),
	NewInfo = case Group > 0 of
				  ?TRUE ->
					  Info#use_skill_cd{
						  next_use_time = MilTime + Interval,
						  group_cd_list = lists:keystore(Group, 1, GList, {Group, MilTime + CD})
					  };
				  _ -> Info#use_skill_cd{next_use_time = MilTime + Interval}
			  end,

	NewMap = case N < 2 of
				 ?TRUE ->
					 maps:put(SkillId, {MilTime, CdAccumulate}, CdMap);
				 _ ->
					 CdAll1 = max(0, min(MilTime - CdTime + CdAccumulate, N * CD)),
					 RestCd1 = CdAll1 - CD,
					 maps:put(SkillId, {MilTime, RestCd1}, CdMap)
			 end,
	set_use_skill_cd(ObjId, RoleId, NewInfo#use_skill_cd{cd_map = NewMap}).


%% 沉默
silence(ObjectID, RoleId, SkillType) ->
	set_science_list(ObjectID, RoleId, [SkillType | get_science_list(ObjectID, RoleId)]).
undo_silence(ObjectID, RoleId, SkillType) ->
	set_science_list(ObjectID, RoleId, get_science_list(ObjectID, RoleId) -- [SkillType]).

check_dead_trigger_skill(AttackerID, PlayerId, RoleId, Hp) ->
	case dead_trigger_ing(PlayerId, RoleId) of
		?FALSE ->
			SkillList = get_skill_list(PlayerId, RoleId),
			CdInfo = get_use_skill_cd(PlayerId, RoleId),
			AttackerType = id_generator:id_type(AttackerID),
			FixAttackerType = case AttackerType of
								  ?ID_TYPE_Monster ->
									  case mapdb:getMonster(AttackerID) of
										  #mapMonster{attach_owner_id = AttachOwnerID} when AttachOwnerID > 0 ->
											  id_generator:id_type(AttachOwnerID);
										  _ -> AttackerType
									  end;
								  _ -> AttackerType
							  end,
			SkillId = select_dead_trigger_skill(SkillList, {0, 0}, {common:rand(1, 10000), CdInfo, PlayerId, RoleId, time:time_ms(), FixAttackerType, AttackerID}),
			case SkillId =:= 0 of
				?FALSE ->
					#objectPos{x = PosX, y = PosY} = mapdb:getObjectPos(PlayerId),
					skill_new:object_use_skill(PlayerId, PlayerId, RoleId, SkillId, PosX, PosY, [#pk_role_skill_hit{object_id = PlayerId, role_id = RoleId}], 0),
					Msg = #pk_U2GS_SkillHit{skillid = SkillId * 100 + 1, attackerid = PlayerId, attacker_role_id = RoleId,
						targetList = [#pk_role_skill_hit{object_id = PlayerId, role_id = RoleId}]},
					gen_server:cast(self(), {send_protocol, PlayerId, {dead_trigger, Msg}}),
					dead_trigger_ing(PlayerId, RoleId, ?TRUE),
					1;
				_ -> Hp
			end;
		?TRUE -> 1
	end.


select_dead_trigger_skill([], {RetSkillId, _}, _) -> RetSkillId;
select_dead_trigger_skill([{SkillId, _, _, _} | T], {RetSkillId, RetCd}, {Rand, CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID}) ->
	#use_skill_cd{cd_map = CdMap, group_cd_list = GList} = CdInfo,
	case cfg_skillBase:getRow(SkillId) of
		#skillBaseCfg{skillType = {_, _, 3}, trigPara = TrigPara} ->
			case lists:keyfind(202, 1, TrigPara) of
				{202, Percent} when Rand =< Percent ->
					{CdTime, _} = maps:get(SkillId, CdMap, {0, 0}),
					#skill_map_info{cd_para = {CdGroup, CD, _, _, _}} = get_object_skill(PlayerId, RoleId, SkillId),
					GroupRet = check_cd_group(CdGroup, MilTime, GList),
					case GroupRet andalso MilTime - CdTime - CD > - 1000 andalso CD > RetCd of
						?TRUE ->
							select_dead_trigger_skill(T, {SkillId, CD}, {common:rand(1, 10000), CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID});
						_ ->
							select_dead_trigger_skill(T, {RetSkillId, RetCd}, {Rand, CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID})
					end;
				_ ->
					case lists:member(AttackerType, [?ID_TYPE_Player, ?ID_TYPE_MirrorPlayer]) andalso lists:keyfind(204, 1, TrigPara) of
						{204, Percent} when Rand =< Percent ->
							{CdTime, _} = maps:get(SkillId, CdMap, {0, 0}),
							#skill_map_info{cd_para = {CdGroup, CD, _, _, _}} = get_object_skill(PlayerId, RoleId, SkillId),
							GroupRet = check_cd_group(CdGroup, MilTime, GList),
							case GroupRet andalso MilTime - CdTime - CD > - 1000 andalso CD > RetCd of
								?TRUE ->
									select_dead_trigger_skill(T, {SkillId, CD}, {common:rand(1, 10000), CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID});
								_ ->
									select_dead_trigger_skill(T, {RetSkillId, RetCd}, {Rand, CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID})
							end;
						_ ->
							select_dead_trigger_skill(T, {RetSkillId, RetCd}, {Rand, CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID})
					end
			end;
		_ ->
			select_dead_trigger_skill(T, {RetSkillId, RetCd}, {Rand, CdInfo, PlayerId, RoleId, MilTime, AttackerType, AttackerID})
	end.

check_cd_group(0, _MilTime, _) -> ?TRUE;
check_cd_group(Gid, MilTime, GList) ->
	case lists:keyfind(Gid, 1, GList) of
		{_, T} -> MilTime > T;
		?FALSE -> ?TRUE
	end.

%% 增减玩家技能cd
%% TargetList = [{ObjId, RoleId}]
deal_player_skill_cd(TargetList, SkillIndex, Cd) ->
	F = fun({ObjId, RoleId}) ->
		try
			deal_player_skill_cd_1(ObjId, RoleId, SkillIndex, Cd)
		catch
			ok -> skip
		end
		end,
	lists:foreach(F, TargetList).
deal_player_skill_cd_1(PlayerId, RoleId, SkillIndex, Cd) ->
	?ASSERT_THROW(id_generator:id_type(PlayerId) =:= ?ID_TYPE_Player, ok),
	SkillTuple = lists:keyfind(SkillIndex, 4, get_skill_list(PlayerId, RoleId)),
	?ASSERT_THROW(SkillTuple =/= ?FALSE, ok),
	SkillId = element(1, SkillTuple),

	SkillInfo = get_object_skill(PlayerId, RoleId, SkillId),
	?ASSERT_THROW(SkillInfo =/= {}, ok),
	#skill_map_info{cd_para = {CdGroup, CD, _, N, _}} = SkillInfo,
	MaxCd = common:getTernaryValue(N < 2, CD, CD * N),
	ChangeCd = min(MaxCd, Cd),

	CdInfo = #use_skill_cd{group_cd_list = CdGroupList, cd_map = CdMap} = get_use_skill_cd(PlayerId, RoleId),
	{CdTime, CdAccumulate} = maps:get(SkillId, CdMap, {0, 0}),

	Now = time:time_ms(),
	NewCd = min(max(CdTime + MaxCd - Now, 0) + ChangeCd, MaxCd),
	NewCdTime = Now + NewCd - MaxCd,
	NewCdMap = maps:put(SkillId, {NewCdTime, CdAccumulate}, CdMap),
	NewCdGroupList = case lists:keyfind(CdGroup, 1, CdGroupList) of
						 {_, T} -> lists:keystore(CdGroup, 1, CdGroupList, {CdGroup, T + ChangeCd});
						 _ -> CdGroupList
					 end,
	set_use_skill_cd(PlayerId, RoleId, CdInfo#use_skill_cd{cd_map = NewCdMap, group_cd_list = NewCdGroupList}),
	map:send(PlayerId, #pk_GS2U_PlayerSkillCdChange{role_id = RoleId, index = SkillIndex, change_cd = Cd}),
	ok.

%% 重置玩家技能cd
%% TargetList = [{ObjId, RoleId}]
reset_player_skill_cd(TargetList, SkillIndex) ->
	F = fun({ObjId, RoleId}) ->
		try
			reset_player_skill_cd_1(ObjId, RoleId, SkillIndex)
		catch
			ok -> skip
		end
		end,
	lists:foreach(F, TargetList).
reset_player_skill_cd_1(PlayerId, RoleId, SkillIndex) ->
	?ASSERT_THROW(id_generator:id_type(PlayerId) =:= ?ID_TYPE_Player, ok),
	SkillTuple = lists:keyfind(SkillIndex, 4, get_skill_list(PlayerId, RoleId)),
	?ASSERT_THROW(SkillTuple =/= ?FALSE, ok),
	SkillId = element(1, SkillTuple),

	SkillInfo = get_object_skill(PlayerId, RoleId, SkillId),
	?ASSERT_THROW(SkillInfo =/= {}, ok),
	#skill_map_info{cd_para = {CdGroup, CD, _, N, _}} = SkillInfo,
	MaxCd = common:getTernaryValue(N < 2, CD, CD * N),

	CdInfo = #use_skill_cd{group_cd_list = CdGroupList, cd_map = CdMap} = get_use_skill_cd(PlayerId, RoleId),
	{_CdTime, CdAccumulate} = maps:get(SkillId, CdMap, {0, 0}),

	Now = time:time_ms(),
	NewCdMap = maps:put(SkillId, {Now - MaxCd, CdAccumulate}, CdMap),
	NewCdGroupList = case lists:keyfind(CdGroup, 1, CdGroupList) of
						 {_, _T} -> lists:keystore(CdGroup, 1, CdGroupList, {CdGroup, Now});
						 _ -> CdGroupList
					 end,
	set_use_skill_cd(PlayerId, RoleId, CdInfo#use_skill_cd{cd_map = NewCdMap, group_cd_list = NewCdGroupList}),
	map:send(PlayerId, #pk_GS2U_PlayerSkillCdChange{role_id = RoleId, index = SkillIndex, change_cd = -MaxCd}),
	ok.

set_object_attack_time(PlayerId, Value) ->
	put({map_obj_attack_time, PlayerId}, Value).
get_object_attack_time(PlayerId) ->
	case get({map_obj_attack_time, PlayerId}) of ?UNDEFINED -> 0; V -> V end.
erase_object_attack_time(PlayerId) ->
	erase({map_obj_attack_time, PlayerId}).

get_cache_skill_damage_param(ObjId, RoleId) ->
	case get({'cache_skill_damage_param', ObjId, RoleId}) of
		?UNDEFINED -> #{};
		M -> M
	end.
set_cache_skill_damage_param(ObjId, RoleId, Map) ->
	put({'cache_skill_damage_param', ObjId, RoleId}, Map).
erase_cache_skill_damage_param(ObjId, RoleId) ->
	erase({'cache_skill_damage_param', ObjId, RoleId}).

clear_skill_damage_param(ObjId, RoleId, SkillID) ->
	M = get_cache_skill_damage_param(ObjId, RoleId),
	set_cache_skill_damage_param(ObjId, RoleId, M#{SkillID => #{}}).
find_skill_damage_param(ObjId, RoleId, SkillID, TargetID, TargetRoleID) ->
	case get_cache_skill_damage_param(ObjId, RoleId) of
		#{SkillID := #{{TargetID, TargetRoleID} := Param}} -> Param;
		_ -> {}
	end.
store_skill_damage_param(ObjId, RoleId, SkillID, TargetID, TargetRoleID, Param) ->
	ParamMap = get_cache_skill_damage_param(ObjId, RoleId),
	OldMap = case ParamMap of
				 #{SkillID := M} -> M;
				 #{} -> #{}
			 end,
	NewMap = OldMap#{{TargetID, TargetRoleID} => Param},
	NParamMap = ParamMap#{SkillID => NewMap},
	set_cache_skill_damage_param(ObjId, RoleId, NParamMap).

dead_trigger_ing(ObjId, RoleId) ->
	?P_DIC_GET({ObjId, RoleId}, ?FALSE).
dead_trigger_ing(ObjId, RoleId, Flag) ->
	?P_DIC_PUT({ObjId, RoleId}, Flag).
erase_dead_trigger_ing(ObjId, RoleId) ->
	?P_DIC_ERASE(dead_trigger_ing, {ObjId, RoleId}).
