%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2022, <DoubleGame>
%%% @doc
%%% 宠物圣树
%%% @end
%%% Created : 15. 9月 2022 20:11
%%%-------------------------------------------------------------------
-module(pet_shengshu).
-author("admin").

-include("item.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("global.hrl").
-include("record.hrl").
-include("db_table.hrl").
-include("variable.hrl").
-include("cfg_item.hrl").
-include("skill_new.hrl").
-include("cfg_petStar.hrl").
-include("cfg_petBase.hrl").
-include("netmsgRecords.hrl").
-include("cfg_petSymbiosis.hrl").
-include("cfg_petSymbiosis2.hrl").
-include("cfg_petSymbiosis3.hrl").
-include("cfg_globalSetupText.hrl").
-include("attainment.hrl").
-include("cfg_petBreak.hrl").
-include("player_task_define.hrl").

%% API
-export([on_load/0, send_all_info/0]).
-export([shared_pet_wash_and_lv/2, shared_pet_wash/3, shared_pet_lv/4, original_pet_lv/1]).
-export([get_pet_guard/0, get_pet_guard/1, is_guard_full/1, guard_count/1, guard_count/0, update_pet_point/1, get_pet_pos_list/0, get_pet_pos_list/1, get_count_shenshu/0, is_shengshu_pos/1]).
-export([on_unlock_pos/1, on_pet_enter/2, on_reset_pos_cd/1, on_pet_guard_change/1, on_pet_guard_change/0, on_pet_delete/1, on_pos_level_up/1, shared_pet_break_lv/4, on_pos_level_back/1, on_dismantle/1, on_pet_remove/1]).

-define(OP_IN, 1). % 入驻
-define(OP_OUT, 2). % 卸下
-define(GuardNum, 3). % 圣树守卫数量

-define(Season1, 0). % 一期
-define(Season2, 1). % 二期
%%%===================================================================
%%% API
%%%===================================================================
on_load() ->
	PlayerId = player:getPlayerID(),
	load(PlayerId),
	check_open_pos(),
	ok.

send_all_info() ->
	PetGuard = get_pet_guard(),
	case PetGuard of
		{} -> skip;
		_ -> player:send(make_grand_msg(PetGuard))
	end,
	player:send(#pk_GS2U_PetEnterSync{pet_enter = [make_enter_msg(PetEnter) || PetEnter <- get_pet_pos_list()]}).

%% 按顺序解锁
on_unlock_pos(Pos) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Cfg = cfg_petSymbiosis:getRow(Pos),
		?CHECK_CFG(Cfg),
		OpenedPosList = get_pet_pos_list(),
		% 未解锁
		?CHECK_THROW(lists:keyfind(Pos, #pet_shared_pos.pos, OpenedPosList) =:= ?FALSE, ?ErrorCode_PetShengShu_UnlockRepeat),
		% 按顺序解锁 不要了
%%		?CHECK_THROW(Pos =:= 1 orelse lists:keyfind(Pos - 1, #pet_shared_pos.pos, OpenedPosList) =/= ?FALSE, ?ErrorCode_PetShengShu_UnlockDisorder),
		#petSymbiosisCfg{need = CostList, condition = Conditions} = Cfg,
		CondErr = check_open_conditions(Conditions),
		?ERROR_CHECK_THROW(CondErr),
		CostErr = player:delete_cost(CostList, ?REASON_PetShengShu_UnlockPos),
		?ERROR_CHECK_THROW(CostErr),
		case get_pet_guard() of
			#pet_shared_guard{state = ?Season2} ->
				update_pos(#pet_shared_pos{pos = Pos, lv = get_guard_min_lv(), unlock_time = time:time()});
			_ -> update_pos(#pet_shared_pos{pos = Pos, unlock_time = time:time()})
		end,
		player_task:refresh_task(?Task_Goal_PetShengShuPos),
		player:send(#pk_GS2U_PetUnlockPosRet{pos = Pos, err_code = ?ERROR_OK})
	catch
		Error -> player:send(#pk_GS2U_PetUnlockPosRet{err_code = Error})
	end.

%% 入驻或卸下，神灵英雄、圣树守卫无法入驻
on_pet_enter(Pos, Uid) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Cfg = cfg_petSymbiosis:getRow(Pos),
		?CHECK_CFG(Cfg),
		OpenedPosList = get_pet_pos_list(),
		PetPos = lists:keyfind(Pos, #pet_shared_pos.pos, OpenedPosList),
		% 已解锁
		?CHECK_THROW(PetPos =/= ?FALSE, ?ErrorCode_PetShengShu_LockedPos),
		Pet = pet_new:get_pet(Uid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
		?CHECK_THROW(not pet_soul:check_is_soul(Pet), ?ErrorCode_PetShengShu_GodPetEnter),
		?CHECK_THROW(not is_guard(Uid), ?ErrorCode_PetShengShu_GuardPetEnter),
		{Op, Cd} = case PetPos of
					   #pet_shared_pos{uid = 0, cd = CD} -> % 入驻
						   ?CHECK_THROW(CD =< time:time(), ?ErrorCode_PetShengShu_InCD),
						   ?CHECK_THROW(lists:keyfind(Uid, #pet_shared_pos.uid, OpenedPosList) =:= ?FALSE, ?ErrorCode_PetShengShu_PetEnteredOther),
						   NewPos = PetPos#pet_shared_pos{uid = Uid},
						   update_pos(NewPos),
						   pet_new:update_pet(Pet#pet_new{shared_flag = 1, point = pet_battle:cal_single_pet_score(Pet)}),
						   pet_base:save_pet_sys_attr_by_uid(Uid),
						   pet_base:refresh_pet_and_skill([Uid]),
						   attainment:check_attainment(?Attainments_Type_PetResonanceCount),
						   {?OP_IN, 0};
					   #pet_shared_pos{uid = Uid} -> % 卸下
						   CD = df:getGlobalSetupValue(petSymbiosisCD, 0),
						   NextOpenTime = time:time() + CD,
						   NewPos = PetPos#pet_shared_pos{uid = 0, cd = NextOpenTime},
						   update_pos(NewPos),
						   pet_new:update_pet(Pet#pet_new{shared_flag = 0, point = 0}),
						   pet_base:save_pet_sys_attr_by_uid(Uid),
						   pet_base:refresh_pet_and_skill([Uid]),
						   {?OP_OUT, NextOpenTime};
					   _ ->
						   throw(?ErrorCode_PetShengShu_OtherPetEntered)
				   end,
		UidList = pet_soul:sync_link_pet(Uid),
		pet_base:save_pet_sys_attr_by_uid(UidList),
		player:send(#pk_GS2U_PetEnterRet{pos = Pos, uid = Uid, op = Op, cd = Cd, err_code = ?ERROR_OK}),
		Op =:= ?OP_OUT andalso on_pet_guard_change(pet_new:get_pet(Uid)),
		ok
	catch
		Error -> player:send(#pk_GS2U_PetEnterRet{err_code = Error})
	end.
on_pet_remove(Uid) ->
	case lists:keyfind(Uid, #pet_shared_pos.uid, get_pet_pos_list()) of
		?FALSE -> ok;
		#pet_shared_pos{pos = Pos} -> on_pet_enter(Pos, Uid)
	end.

%% 重置栏位cd
on_reset_pos_cd(Pos) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Cfg = cfg_petSymbiosis:getRow(Pos),
		?CHECK_CFG(Cfg),
		OpenedPosList = get_pet_pos_list(),
		PetPos = lists:keyfind(Pos, #pet_shared_pos.pos, OpenedPosList),
		% 已解锁
		?CHECK_THROW(PetPos =/= ?FALSE, ?ErrorCode_PetShengShu_LockedPos),
		#pet_shared_pos{uid = PetUid, cd = NextOpenTime} = PetPos,
		% 未入驻
		?CHECK_THROW(PetUid =:= 0, ?ErrorCode_PetShengShu_EnteredState),
		% cd中
		NowTime = time:time(),
		?CHECK_THROW(NextOpenTime =/= 0 andalso NextOpenTime > NowTime, ?ErrorCode_PetShengShu_NoCD),
		[{Type, Num}] = df:getGlobalSetupValueList(petSymbiosisCDNeed, [{0, 30}]),
		TotalCD = df:getGlobalSetupValue(petSymbiosisCD, 0),
		CostNum = ceil((NextOpenTime - NowTime) / TotalCD * Num),
		CostErr = currency:delete(Type, CostNum, ?REASON_PetShengShu_ResetCD),
		?ERROR_CHECK_THROW(CostErr),
		update_pos(PetPos#pet_shared_pos{cd = 0}),
		player:send(#pk_GS2U_ResetPosCDRet{pos = Pos, err_code = ?ERROR_OK})
	catch
		Error -> player:send(#pk_GS2U_ResetPosCDRet{err_code = Error})
	end.

%% {wash, lv}
shared_pet_wash_and_lv(PlayerId, Pet) ->
	#pet_new{uid = Uid, shared_flag = IsShared} = Pet,
	case IsShared of
		0 -> {Pet#pet_new.wash, Pet#pet_new.pet_lv};
		1 -> %%	入驻宠物
			PetGuard = get_pet_guard(PlayerId),
			case is_guard_full(PetGuard) of
				?FALSE -> % 圣树守卫未满，圣树等级为1，洗练属性都为0
					PetBase = pet_base:get_base_wash_attr(Pet#pet_new.pet_cfg_id),
					{PetBase, 1};
				?TRUE ->
					PetSharePos = get_pet_pos_list(PlayerId),
					#pet_shared_guard{uid = SharedUid} = PetGuard,
					#pet_new{pet_lv = SharedLv} = SharedPet = pet_new:get_pet(PlayerId, SharedUid),
					Lv = case get_guard_season(PetGuard) of
							 ?Season1 ->
								 SharedLv;
							 ?Season2 ->
								 #pet_shared_pos{lv = PosLv} = lists:keyfind(Uid, #pet_shared_pos.uid, PetSharePos),
								 #petSymbiosis2Cfg{lvlimt = LvLimit} = cfg_petSymbiosis2:getRow(PosLv),
								 min(LvLimit, SharedLv)
						 end,
					{share_wash(Pet, SharedPet), Lv}
			end
	end.

shared_pet_lv(Pet, PetList, PetGuard, PetSharePos) ->
	#pet_new{uid = Uid, shared_flag = IsShared} = Pet,
	case IsShared of
		0 -> Pet#pet_new.pet_lv;
		1 -> %%	入驻宠物
			case is_guard_full(PetGuard) of
				?FALSE -> % 圣树守卫未满，圣树等级为1，洗练属性都为0
					1;
				?TRUE ->
					#pet_shared_guard{uid = SharedUid} = PetGuard,
					SharedPet = lists:keyfind(SharedUid, #pet_new.uid, PetList),
					case get_guard_season(PetGuard) of
						?Season1 ->
							SharedPet#pet_new.pet_lv;
						?Season2 ->
							#pet_shared_pos{lv = PosLv} = lists:keyfind(Uid, #pet_shared_pos.uid, PetSharePos),
							#petSymbiosis2Cfg{lvlimt = LvLimit} = cfg_petSymbiosis2:getRow(PosLv),
							min(LvLimit, SharedPet#pet_new.pet_lv)
					end
			end
	end.

shared_pet_wash(Pet, PetList, PetGuard) ->
	try
		#pet_new{shared_flag = IsShared} = Pet,
		case IsShared of
			0 -> Pet#pet_new.wash;
			1 -> %%	入驻宠物
				case is_guard_full(PetGuard) of
					?FALSE -> % 圣树守卫未满，圣树等级为1，洗练属性都为0
						pet_base:get_base_wash_attr(Pet#pet_new.pet_cfg_id);
					?TRUE ->
						#pet_shared_guard{uid = SharedUid} = PetGuard,
						SharedPet = lists:keyfind(SharedUid, #pet_new.uid, PetList),
						share_wash(Pet, SharedPet)
				end
		end
	catch
		_Err -> Pet#pet_new.wash
	end.

shared_pet_break_lv(Pet, PetList, PetGuard, PetSharePos) ->
	#pet_new{uid = Uid, shared_flag = IsShared} = Pet,
	case IsShared of
		0 -> Pet#pet_new.break_lv;
		1 -> %%	入驻宠物
			case is_guard_full(PetGuard) of
				?FALSE ->
					0;
				?TRUE ->
					#pet_shared_guard{uid = SharedUid} = PetGuard,
					SharedPet = lists:keyfind(SharedUid, #pet_new.uid, PetList),
					case get_guard_season(PetGuard) of
						?Season1 ->
							SharedPet#pet_new.break_lv;
						?Season2 ->
							#pet_shared_pos{lv = PosLv} = lists:keyfind(Uid, #pet_shared_pos.uid, PetSharePos),
							#petSymbiosis2Cfg{lvlimt = LvLimit} = cfg_petSymbiosis2:getRow(PosLv),
							find_shared_break_lv(SharedPet#pet_new.break_lv, LvLimit)
					end
			end
	end.

original_pet_lv(Pet) ->
	#pet_new{shared_flag = IsShared} = Pet,
	case IsShared of
		0 -> 0;
		1 -> Pet#pet_new.pet_lv
	end.

%% 入驻宠物回退时，更新入驻前的评分，用于前端界面显示
update_pet_point(#pet_new{shared_flag = 1, uid = Uid, point = OldPoint}) ->
	NewPet = pet_new:get_pet(Uid),
	NewPoint = pet_battle:cal_single_pet_score(NewPet, ?FALSE),
	OldPoint =/= NewPoint andalso pet_new:update_pet(NewPet#pet_new{point = NewPoint});
update_pet_point(_) -> ok.

%% 增加宠物圣树守卫（宠物圣树守卫未满时: 孵化，抽卡，其他方式获得宠物 -> pet_new:update_pet）
on_pet_guard_change() ->
	case is_guard_full() of
		?TRUE -> skip;
		?FALSE ->
			AllPet = pet_new:get_pet_list(),
			case new_guard_list(AllPet) of
				[] -> skip;
				NewPetGuardList ->
					OldGuardList = get_pet_guard(),
					Season = get_guard_season(OldGuardList),
					case OldGuardList =:= {} orelse length(OldGuardList#pet_shared_guard.uid_list) < length(NewPetGuardList) of
						?FALSE -> skip;
						?TRUE -> % 增加才更新
							GuardUidList = [Uid || #pet_new{uid = Uid} <- NewPetGuardList],
							#pet_new{uid = SharedPetUid} = lists:last(NewPetGuardList),
							NewPetGuard = #pet_shared_guard{uid_list = GuardUidList, uid = SharedPetUid, state = Season},
							update_guard(NewPetGuard),
							check_state(NewPetGuardList, NewPetGuard),
							update_share_pet(AllPet)
					end
			end
	end,
	ok.
%% 宠物圣树守卫更新(非入驻宠物升级、洗髓、回退导致共享宠物变动)
on_pet_guard_change(#pet_new{} = Pet) -> on_pet_guard_change([Pet]);
on_pet_guard_change(PetList) when is_list(PetList) ->
	AllPet = pet_new:get_pet_list(),
	NewPetGuardList = new_guard_list(AllPet),
	case NewPetGuardList of
		[] -> skip;
		_ ->
			GuardUidList = [Uid || #pet_new{uid = Uid} <- NewPetGuardList],
			#pet_new{uid = NewSharedPetUid} = lists:last(NewPetGuardList),
			#pet_shared_guard{uid_list = OldGuardUidList, uid = OldSharedPetUid} = Grand = get_pet_guard(),
			OldGuardList = [pet_new:get_pet(Uid) || Uid <- OldGuardUidList],
			case (is_same_pet_list(NewPetGuardList, OldGuardList) andalso not lists:keymember(OldSharedPetUid, #pet_new.uid, PetList)) orelse (length(NewPetGuardList) =:= 1) of
				?TRUE -> % 新旧圣树守卫效果一样，或uid完全一样且强化的宠物不是共享宠物时，无需操作；只有一个护卫也不必更新
					skip;
				_ ->
					NewPetGuard = Grand#pet_shared_guard{uid_list = GuardUidList, uid = NewSharedPetUid},
					update_guard(NewPetGuard),
					check_state(NewPetGuardList, NewPetGuard),
					is_guard_full() andalso update_share_pet(AllPet) % 未满状态属性固定，无需更新
			end
	end,
	ok.
%% 入驻圣树或圣树守卫被消耗后（高星置换消耗、升星消耗 -> pet_new:delete_pet）
on_pet_delete(#pet_new{} = Pet) -> on_pet_delete([Pet]);
on_pet_delete(PetList) when is_list(PetList) ->
	PetEnterList = get_pet_pos_list(),
	DelEnteredPetList = lists:filter(fun(Pet) -> Pet#pet_new.shared_flag =:= 1 end, PetList), % 被删除的入驻圣树英雄列表
	case PetEnterList =:= [] orelse DelEnteredPetList =:= [] of
		?TRUE -> skip;
		_ ->
			NeedUpdate = fun(#pet_new{uid = Uid}) ->
				case lists:keyfind(Uid, #pet_shared_pos.uid, PetEnterList) of
					?FALSE -> ?FALSE;
					PetEnter -> {?TRUE, PetEnter#pet_shared_pos{uid = 0, cd = 0}}
				end end,
			update_pos(lists:filtermap(NeedUpdate, DelEnteredPetList)) % 间接导致数据更改，需要通知前端
	end,
	PetGuard = get_pet_guard(),
	case PetGuard of
		{} -> skip;
		#pet_shared_guard{uid_list = GuardUidList} ->
			DelUidList = lists:filtermap(fun(#pet_new{uid = PetUid}) ->
				case lists:member(PetUid, GuardUidList) of ?FALSE -> ?FALSE; ?TRUE -> {?TRUE, PetUid} end end, PetList),
			case DelUidList of
				[] -> skip;
				_ ->
					RestUidList = GuardUidList -- DelUidList,
					case length(RestUidList) < guard_candidate_count() of
						?TRUE -> % 可更新
							set_pet_guard(PetGuard#pet_shared_guard{uid_list = RestUidList}), % 更新圣树守卫数量
							on_pet_guard_change();
						?FALSE ->
							AllPetList = pet_new:get_pet_list(),
							NewGuardList = new_guard_list(AllPetList),
							NewSharedUid = case NewGuardList of
											   [] -> 0;
											   _ -> #pet_new{uid = Uid} = lists:last(NewGuardList), Uid end,
							update_guard(PetGuard#pet_shared_guard{uid_list = [Uid || #pet_new{uid = Uid} <- NewGuardList], uid = NewSharedUid}),
							update_share_pet(AllPetList)
					end
			end
	end,
	ok.

%% 入驻位置升级
on_pos_level_up(Pos) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Guard = get_pet_guard(),
		?CHECK_THROW(Guard =/= {}, ?ErrorCode_PetShengShu_GuardState),
		#pet_shared_guard{state = State} = Guard,
		?CHECK_THROW(State =:= ?Season2, ?ErrorCode_PetShengShu_GuardState),
		OpenedPosList = get_pet_pos_list(),
		PetPos = lists:keyfind(Pos, #pet_shared_pos.pos, OpenedPosList),
		?CHECK_THROW(PetPos =/= ?FALSE, ?ErrorCode_PetShengShu_LockedPos),
		#pet_shared_pos{lv = Lv, uid = Uid} = PetPos,
		Cfg = cfg_petSymbiosis2:getRow(Lv),
		?CHECK_CFG(Cfg),
		#petSymbiosis2Cfg{need = CostList, lvMax = MaxLv} = Cfg,
		?CHECK_THROW(Lv < MaxLv, ?ErrorCode_PetShengShu_PosLvMax),
		CostErr = player:delete_cost(CostList, ?REASON_Pet_Shengshu_PosLv),
		?ERROR_CHECK_THROW(CostErr),
		case Lv of
			0 -> update_pos(PetPos#pet_shared_pos{lv = Lv + 1, unlock_time = time:time()});
			_ -> update_pos(PetPos#pet_shared_pos{lv = Lv + 1})
		end,
		update_share_pet([pet_new:get_pet(Uid)]),
		player:send(#pk_GS2U_PetPosLevelUp{pos = Pos, err_code = ?ERROR_OK})
	catch
		Error -> player:send(#pk_GS2U_PetPosLevelUp{pos = Pos, err_code = Error})
	end.


%% 入驻位置回退
on_pos_level_back(Pos) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Guard = get_pet_guard(),
		?CHECK_THROW(Guard =/= {}, ?ErrorCode_PetShengShu_GuardState),
		#pet_shared_guard{state = State} = Guard,
		?CHECK_THROW(State =:= ?Season2, ?ErrorCode_PetShengShu_GuardState),
		OpenedPosList = get_pet_pos_list(),
		PetPos = lists:keyfind(Pos, #pet_shared_pos.pos, OpenedPosList),
		?CHECK_THROW(PetPos =/= ?FALSE, ?ErrorCode_PetShengShu_LockedPos),
		#pet_shared_pos{lv = Lv, uid = Uid} = PetPos,
		?CHECK_THROW(Lv > 1, ?ERROR_Param),
		Cfg = cfg_petSymbiosis2:getRow(Lv),
		?CHECK_CFG(Cfg),
		#petSymbiosis2Cfg{consume = Consume, return = Return} = Cfg,
		CostErr = currency:delete([Consume], ?REASON_Pet_Shengshu_PosLvBack),
		?ERROR_CHECK_THROW(CostErr),
		player:add_rewards(Return, ?REASON_Pet_Shengshu_PosLvBack),
		update_pos(PetPos#pet_shared_pos{lv = 1}),
		update_share_pet([pet_new:get_pet(Uid)]),
		player:send(#pk_GS2U_PetPosLevelBackRet{pos = Pos, err_code = ?ERROR_OK})
	catch
		Error -> player:send(#pk_GS2U_PetPosLevelBackRet{pos = Pos, err_code = Error})
	end.

%% 道具分解
on_dismantle(CostList0) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		CostList = item:item_merge(CostList0),
		{DismantleErr, RetCostList, RetItemList, RetCurrencyList} = check_dismantle(CostList, [], [], []),
		?ERROR_CHECK_THROW(DismantleErr),
		CostErr = player:delete_cost(RetCostList, [], ?REASON_Pet_Shengshu_Dismantle),
		?ERROR_CHECK_THROW(CostErr),
		?CHECK_THROW(RetCostList =/= [], ?ErrorCode_PetShengShu_CantDismantle),
		player:add_rewards(RetItemList, RetCurrencyList, ?REASON_Pet_Shengshu_Dismantle),
		player_item:show_get_item_dialog(RetItemList, RetCurrencyList, [], 0, 1),
		player:send(#pk_GS2U_PetPosDismantleRet{cost_list = common:to_kv_msg(RetCostList)})
	catch
		ErrCode ->
			player:send(#pk_GS2U_PetPosDismantleRet{err_code = ErrCode})
	end.


%%%===================================================================
%%% Internal functions
%%%===================================================================
check_open_conditions([]) -> ?ERROR_OK;
check_open_conditions([{1, Layer} | T]) ->
	case career_tower:get_main_layer() >= Layer of
		?TRUE -> check_open_conditions(T);
		?FALSE -> ?ErrorCode_PetPosActive_PetTower
	end;
check_open_conditions([{2, VipLv} | T]) ->
	case vip:get_vip_lv() >= VipLv of
		?TRUE -> check_open_conditions(T);
		?FALSE -> ?ErrorCode_PetPosActive_VIP
	end;
check_open_conditions([{3, URHeroNum} | T]) ->
	case pet_new:get_count_rare_uniq(5) >= URHeroNum of
		?TRUE -> check_open_conditions(T);
		?FALSE -> ?ErrorCode_PetPosActive_URHero
	end;
check_open_conditions([{Type, _} | _]) ->
	?LOG_ERROR("unknow type ~p", [Type]),
	?ERROR_Param.


is_guard(PetUid) ->
	PetGuard = get_pet_guard(),
	case PetGuard of
		{} -> ?FALSE;
		#pet_shared_guard{uid_list = UidList} -> lists:member(PetUid, UidList)
	end.
%% 符合圣树守卫选择条件的宠物数量（包括已成为圣树守卫的
guard_candidate_count() ->
	AllPet = pet_new:get_pet_list(),
	case AllPet of
		?UNDEFINED -> 0;
		_ -> % 入驻的不可选，再排除神灵英雄
			PetGuardList = lists:filter(
				fun(Pet) -> Pet#pet_new.shared_flag =:= 0 andalso not pet_soul:check_is_soul(Pet) end,
				AllPet),
			length(PetGuardList)
	end.
%% 圣树守卫是否满员
is_guard_full() -> guard_count() =:= ?GuardNum.
is_guard_full(GuardData) -> guard_count(GuardData) =:= ?GuardNum.

guard_count() ->
	GuardData = get_pet_guard(),
	case GuardData =/= {} of
		?FALSE -> 0;
		?TRUE ->
			length(GuardData#pet_shared_guard.uid_list)
	end.
guard_count({}) -> 0;
guard_count(GuardData) -> length(GuardData#pet_shared_guard.uid_list).

%% 圣树期数
get_guard_season(#pet_shared_guard{state = State}) -> State;
get_guard_season({}) -> ?Season1.

%% 初始化无需解锁的栏位
check_open_pos() ->
	PetPosList = get_pet_pos_list(),
	F = fun(Pos) ->
		case {cfg_petSymbiosis:getRow(Pos), lists:keyfind(Pos, #pet_shared_pos.pos, PetPosList)} of
			{#petSymbiosisCfg{need = [], condition = []}, ?FALSE} ->
				{?TRUE, #pet_shared_pos{pos = Pos, unlock_time = time:time()}};
			_ -> ?FALSE
		end end,
	OpenPosList = lists:filtermap(F, cfg_petSymbiosis:getKeyList()),
	update_pos(OpenPosList).
%% 取等级低，等级相同取洗髓资质评分低，不然就随便一个
is_lower_pet(#pet_new{pet_lv = Lv1} = Pet1, #pet_new{pet_lv = Lv2} = Pet2) ->
	case Lv1 =/= Lv2 of
		?TRUE -> Lv1 < Lv2;
		?FALSE ->
			WashP1 = pet_battle:calc_pet_wash_aptitude(Pet1),
			WashP2 = pet_battle:calc_pet_wash_aptitude(Pet2),
			case WashP1 =/= WashP2 of
				?TRUE -> WashP1 < WashP2;
				_ -> ?TRUE
			end
	end.
%% 等级和洗练是否相同(uid相同不用比较)
is_same_pet_list(NewPetList, OldPetList) ->
	PetPairList = lists:zip(NewPetList, OldPetList),
	lists:all(fun({Pet1, Pet2}) -> is_same_pet(Pet1, Pet2) end, PetPairList).
is_same_pet(#pet_new{uid = Uid1}, #pet_new{uid = Uid2}) when Uid1 =:= Uid2 -> ?TRUE;
is_same_pet(#pet_new{pet_lv = Lv1} = Pet1, #pet_new{pet_lv = Lv2} = Pet2) ->
	WashP1 = pet_battle:calc_pet_wash_aptitude(Pet1),
	WashP2 = pet_battle:calc_pet_wash_aptitude(Pet2),
	(Lv1 =:= Lv2) andalso (WashP1 =:= WashP2).

share_wash(Pet, #pet_new{pet_cfg_id = PetCfgId, wash = SharedWash}) ->
	SharedPetBase = pet_base:get_base_wash_attr(PetCfgId),
	AddWash = pet_base:compare_attr(SharedPetBase, SharedWash),
	PetBase = pet_base:get_base_wash_attr(Pet#pet_new.pet_cfg_id),
	pet_base:merge_wash_attr(PetBase, AddWash).

new_guard_list(?UNDEFINED) -> [];
new_guard_list(AllPet) ->
	PetList = lists:filter(fun(NewPet) ->
		NewPet#pet_new.shared_flag =:= 0 andalso not pet_soul:check_is_soul(NewPet) end, AllPet), % 入驻的不可选，再排除神灵英雄
	SortPetList = lists:sort(fun(Pet1, Pet2) -> not is_lower_pet(Pet1, Pet2) end, PetList),
	case SortPetList of
		[] -> [];
		_ -> % 三个或三个以下等级最高的圣树守卫
			lists:sublist(SortPetList, min(?GuardNum, length(SortPetList)))
	end.
%% 更新入驻宠物属性，并发送通知
update_share_pet(?UNDEFINED) -> skip;
update_share_pet(AllPet) ->
	EnteredUidList = [Uid || #pet_new{shared_flag = 1, uid = Uid} <- AllPet],
	UidList = lists:foldl(fun(Uid, Acc) ->
		player:send(#pk_GS2U_pet_update{pets = [pet_new:make_pet_msg(pet_new:get_pet(Uid))]}),
		pet_base:save_pet_sys_attr_by_uid(Uid),
		pet_base:refresh_pet_and_skill([Uid]),
		Acc ++ pet_soul:sync_link_pet(Uid) end, [], EnteredUidList),
	case UidList of
		[] -> skip;
		_ -> pet_base:save_pet_sys_attr_by_uid(UidList)
	end.

load(PlayerId) ->
	DBPetGuardList = table_player:lookup(db_pet_shared_guard, PlayerId),
	DBPetPosList = table_player:lookup(db_pet_shared_pos, PlayerId),
	case DBPetGuardList of
		[] -> skip;
		[DBPetGuard | _] -> set_pet_guard(db_guard2guard(DBPetGuard))
	end,
	set_pet_pos_list([db_pos2pos(DBPetPos) || DBPetPos <- DBPetPosList]),
	ok.

db_guard2guard(DbGuard) ->
	#pet_shared_guard{
		uid_list = gamedbProc:dbstring_to_term(DbGuard#db_pet_shared_guard.uid_list),
		uid = DbGuard#db_pet_shared_guard.uid,
		state = DbGuard#db_pet_shared_guard.state
	}.

guard2db_guard(Guard) ->
	#db_pet_shared_guard{
		player_id = player:getPlayerID(),
		uid_list = gamedbProc:term_to_dbstring(Guard#pet_shared_guard.uid_list),
		uid = Guard#pet_shared_guard.uid,
		state = Guard#pet_shared_guard.state
	}.

db_pos2pos(DbPos) ->
	#pet_shared_pos{
		pos = DbPos#db_pet_shared_pos.pos,
		uid = DbPos#db_pet_shared_pos.uid,
		cd = DbPos#db_pet_shared_pos.cd,
		lv = DbPos#db_pet_shared_pos.lv,
		unlock_time = DbPos#db_pet_shared_pos.unlock_time
	}.

pos2db_pos(Pos) ->
	#db_pet_shared_pos{
		player_id = player:getPlayerID(),
		pos = Pos#pet_shared_pos.pos,
		uid = Pos#pet_shared_pos.uid,
		cd = Pos#pet_shared_pos.cd,
		lv = Pos#pet_shared_pos.lv,
		unlock_time = Pos#pet_shared_pos.unlock_time
	}.

make_enter_msg(#pet_shared_pos{pos = Pos, uid = 0, cd = Cd, lv = Lv, unlock_time = Time}) ->
	#pk_PetEnter{pos = Pos, cd = Cd, lv = Lv, unlock_time = Time};
make_enter_msg(#pet_shared_pos{pos = Pos, uid = Uid, cd = Cd, lv = Lv, unlock_time = Time}) ->
	#pet_new{pet_cfg_id = CfgId} = pet_new:get_pet(Uid),
	#pk_PetEnter{pos = Pos, uid = Uid, pet_cfg_id = CfgId, cd = Cd, lv = Lv, unlock_time = Time}.

make_grand_msg(#pet_shared_guard{uid_list = UidList, uid = SharedUid, state = State}) ->
	#pk_GS2U_PetGuardSync{uid_list = UidList, shared_uid = SharedUid, state = State}.

update_guard(PetGuard) ->
	set_pet_guard(PetGuard),
	table_player:insert(db_pet_shared_guard, guard2db_guard(PetGuard)),
	player:send(make_grand_msg(PetGuard)).

update_pos([]) -> ok;
update_pos(#pet_shared_pos{} = PetPos) -> update_pos([PetPos]);
update_pos(PetPosList) when is_list(PetPosList) ->
	table_player:insert(db_pet_shared_pos, [pos2db_pos(PetPos) || PetPos <- PetPosList]),
	F = fun(PetPos, Acc) -> lists:keystore(PetPos#pet_shared_pos.pos, #pet_shared_pos.pos, Acc, PetPos) end,
	NewPetPosList = lists:foldl(F, get_pet_pos_list(), PetPosList),
	set_pet_pos_list(NewPetPosList),
	player:send(#pk_GS2U_PetEnterSync{pet_enter = [make_enter_msg(PetPos) || PetPos <- PetPosList]}),
	ok.

set_pet_guard(GuardData) -> put({?MODULE, pet_guard}, GuardData).
get_pet_guard() -> case get({?MODULE, pet_guard}) of ?UNDEFINED -> {}; GuardData -> GuardData end.
get_pet_guard(PlayerId) ->
	DBPetGuardList = table_player:lookup(db_pet_shared_guard, PlayerId),
	case DBPetGuardList of [] -> {}; [DBPetGuard | _] -> db_guard2guard(DBPetGuard) end.

set_pet_pos_list(PosData) -> put({?MODULE, pet_pos}, PosData).
get_pet_pos_list() -> get({?MODULE, pet_pos}).
get_pet_pos_list(PlayerId) ->
	DBPetPosList = table_player:lookup(db_pet_shared_pos, PlayerId),
	[db_pos2pos(DBPetPos) || DBPetPos <- DBPetPosList].
%%成就系统-X个英雄共鸣圣树-341
get_count_shenshu() ->
	length([1 || #pet_shared_pos{uid = Uid} <- get_pet_pos_list(), Uid =/= 0]).

%%支线任务-是否已解锁圣树某个位置
is_shengshu_pos(Pos) ->
	lists:keyfind(Pos, #pet_shared_pos.pos, get_pet_pos_list()) =/= ?FALSE.

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetShengShu) =:= 1 andalso guide:is_open_action(?OpenAction_PetShengShu).

%% 检查是否进入二期
check_state(NewPetGuardList, Grand) ->
	case Grand of
		#pet_shared_guard{state = ?Season1} ->
			AllLv = [Lv || #pet_new{pet_lv = Lv} <- NewPetGuardList],
			MinLv = lists:min(AllLv),
			PosMinLv = get_guard_min_lv(),
			case MinLv >= cfg_globalSetup:yingxiongshengshudengji() andalso length(NewPetGuardList) =:= ?GuardNum of
				?TRUE ->
					%% 检查所有位置保证最低等级
					PosList = get_pet_pos_list(),
					NewPosList = [Pos#pet_shared_pos{lv = PosMinLv} || #pet_shared_pos{} = Pos <- PosList],
					update_pos(NewPosList),
					update_guard(Grand#pet_shared_guard{state = ?Season2});
				?FALSE -> skip
			end;
		_ -> skip
	end.

%% 获取二期最低入驻等级
get_guard_min_lv() ->
	MinLv = cfg_globalSetup:yingxiongshengshudengji(),
	KeyList = cfg_petSymbiosis2:getKeyList(),
	get_guard_min_lv(KeyList, MinLv).
get_guard_min_lv([], MinLv) ->
	?LOG_ERROR("no min season2 guard_lv, check cfg_petSymbiosis2:~p", [MinLv]),
	0;
get_guard_min_lv([Id | KeyList], MinLv) ->
	#petSymbiosis2Cfg{lvlimt = LvLimit} = cfg_petSymbiosis2:getRow(Id),
	case LvLimit >= MinLv of
		?TRUE -> Id;
		?FALSE -> get_guard_min_lv(KeyList, MinLv)
	end.

find_shared_break_lv(BreakLv, LvLimit) ->
	find_shared_break_lv(BreakLv, LvLimit, BreakLv).
find_shared_break_lv(_BreakLv, _LvLimit, LastBreakLv) when LastBreakLv =< 0 -> 0;
find_shared_break_lv(BreakLv, LvLimit, LastBreakLv) ->
	case cfg_petBreak:getRow(BreakLv) of
		#petBreakCfg{maxLv = MaxLv} when MaxLv < LvLimit ->
			LastBreakLv;
		_ ->
			find_shared_break_lv(BreakLv - 1, LvLimit, BreakLv)
	end.

check_dismantle([], RCostList, RItemList, RCurrencyList) ->
	{?ERROR_OK, RCostList, item:item_merge(RItemList), common:listValueMerge(RCurrencyList)};
check_dismantle([{ItemId, Num} | T], RCostList, RItemList, RCurrencyList) ->
	case cfg_petSymbiosis3:row(ItemId) of
		#petSymbiosis3Cfg{returnItem = ReturnList, returnLimit = LimitList} ->
			case check_limit(LimitList) of
				?ERROR_OK ->
					ItemList = [{I, N * Num} || {1, I, N} <- ReturnList],
					CurrencyList = [{I, N * Num} || {2, I, N} <- ReturnList],
					NewRCostList = [{ItemId, Num} | RCostList],
					NewRItemList = ItemList ++ RItemList,
					NewRCurrencyList = CurrencyList ++ RCurrencyList,
					check_dismantle(T, NewRCostList, NewRItemList, NewRCurrencyList);
				_Err ->
					check_dismantle(T, RCostList, RItemList, RCurrencyList)
			end;
		_ ->
			check_dismantle(T, RCostList, RItemList, RCurrencyList)
	end.

check_limit([]) -> ?ERROR_OK;
check_limit([{1, Num} | T]) ->
	case length([1 || #pet_shared_pos{unlock_time = Time} <- get_pet_pos_list(), Time > 0]) >= Num of
		?TRUE -> check_limit(T);
		?FALSE -> ?ErrorCode_PetShengShu_PosUnlockNum
	end;
check_limit([_ | T]) ->
	check_limit(T).
