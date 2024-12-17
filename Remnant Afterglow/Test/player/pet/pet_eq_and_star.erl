%%%-------------------------------------------------------------------
%%% @author root
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%% %% 宠物装备 + 宠物升星
%%% @end
%%% Created : 15. 7月 2022 17:14
%%%-------------------------------------------------------------------
-module(pet_eq_and_star).
-author("root").

-include("record.hrl").
-include("db_table.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("item.hrl").
-include("cfg_item.hrl").
-include("skill_new.hrl").
-include("netmsgRecords.hrl").
-include("cfg_petStar.hrl").
-include("cfg_petStar2.hrl").
-include("cfg_petBase.hrl").
-include("cfg_petEquipNew.hrl").
-include("cfg_petEquipSkill.hrl").
-include("cfg_petEqpOpenNew.hrl").
-include("activity_new.hrl").
-include("attainment.hrl").
-include("player_task_define.hrl").
-include("seven_gift_define.hrl").
-include("time_limit_gift_define.hrl").
-include("pet_new.hrl").
-include("recharge_gift_packs.hrl").
-include("cfg_petReturnLimit.hrl").
-include("cfg_petReturnLimit2.hrl").
-include("cfg_petStarReturn.hrl").

%% API
-export([on_eq_load/1, on_eq_send_online/0]).
-export([on_add_star/2, on_add_sp_lv/2, on_add_star_pos/3, on_add_star_quick/1, on_pet_promotion/2, get_skill_list/2, on_set_lock/2, on_sp_return/1, on_pet_star_rollback/1, on_pet_quick_nine_star/2]).
-export([on_eq_equip_on/3, on_eq_remove/2, on_eq_skill_reset/2, get_eq_quality/2, check_eq_empty/1]).
-export([on_item_eq_delete/1, on_item_eq_add/1, add_eq_ins/1, get_count_eq_chara/1, check_activity_pet_star_cond/2, get_star_pos_qual/2]).
-export([calc_pet_skill/5, get_sp_skill/3, get_pet_skill/2, get_buff_list/0]).
-export([fix_data_20221208/0]).

%%% ============================================== Export Function ==========================================

%% 加载宠物装备
on_eq_load(PlayerId) ->
	DbEqList = table_player:lookup(db_pet_eq, PlayerId),
	set_eq_list([db_to_eq(DbEq) || DbEq <- DbEqList]),
	%% 属性还是只能在pet_new里算
	ok.

%% 上线同步宠物装备 先发装备，再发宠物
on_eq_send_online() ->
	case is_eq_func_open() of
		?TRUE ->
			EqList = get_eq_list(),
			Msg = #pk_GS2U_pet_eq_sync{eq_list = [make_eq_msg(Eq) || Eq <- EqList]},
			player:send(Msg);
		_ -> skip
	end.

%% 锁定 宠物锁定后不能作为升星材料 1-锁定 0-解除锁定
on_set_lock(PetUid, IsLock) -> ?metrics(begin
											try
												?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
												PetList = pet_new:get_pet_list(),
												OldPet = lists:keyfind(PetUid, #pet_new.uid, PetList),
												?CHECK_THROW(OldPet =/= ?FALSE, ?ErrorCode_Pet_No),
												?CHECK_THROW(IsLock =/= OldPet#pet_new.is_lock, ?ERROR_OK),
												NewState = case IsLock of 0 -> 0; _ -> 1 end,
												NewPet = OldPet#pet_new{is_lock = NewState},
												pet_new:update_pet(NewPet),
												player:send(#pk_GS2U_pet_set_lock_ret{uid = PetUid, err_code = ?ERROR_OK, is_lock = NewState})
											catch
												ErrCode ->
													player:send(#pk_GS2U_pet_set_lock_ret{uid = PetUid, err_code = ErrCode})
											end end).

%% 宠物进化（升星）
on_add_star(PetUid, AssistCostPetUidList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 ?CHECK_THROW(is_star_func_open(), ?ERROR_FunctionClose),
					 OldPet = pet_new:get_pet(PetUid),
					 ?CHECK_THROW(OldPet =/= {}, ?ErrorCode_Pet_No),
					 OldPetStar = OldPet#pet_new.star,
					 PetCfgId = OldPet#pet_new.pet_cfg_id,
					 PetBase = cfg_petBase:getRow(PetCfgId),
					 ?CHECK_CFG(PetBase),
					 #petBaseCfg{rareStar = NeedStar} = PetBase,
					 ?CHECK_THROW(NeedStar =:= 0 orelse OldPetStar =< NeedStar, ?ErrorCode_PetEqAndStar_NeedPromotion),
					 case cfg_petStar:getRow(PetCfgId, OldPetStar) of
						 #petStarCfg{starMax = MaxStar, upNeedItem = NeedList} ->
							 ?CHECK_THROW(OldPetStar < MaxStar, ?ErrorCode_Pet_StarMax),
							 ?CHECK_THROW(NeedList =/= [], ?ERROR_Cfg),
							 %% 判断宠物状态 升级或者驯化过的宠物，将返回消耗材料
							 ?CHECK_THROW(not lists:member(PetUid, AssistCostPetUidList), ?ErrorCode_PetEqAndStar_CostPetRepeat),
							 PowerBefore = pet_battle:cal_single_pet_score(OldPet),
							 {_, DeletePetCfgList} = delete_start_cost(AssistCostPetUidList, NeedList, ?TRUE, ?TRUE),
							 ItemCost = [{1, Cfg, Num} || {3, Cfg, _, Num} <- NeedList],
							 PetCost = [{3, CfgId, Star} || #pet_new{pet_cfg_id = CfgId, star = Star} <- DeletePetCfgList],
							 NewPetStar = OldPetStar + 1,
							 PlayerId = player:getPlayerID(),
							 %% 升星公告
							 add_star_push(PlayerId, PetCfgId, NewPetStar),
							 NewPet = OldPet#pet_new{star = NewPetStar},
							 pet_new:update_pet(NewPet),
							 pet_soul:sync_link_pet(PetUid),
							 %% 重新计算宠物资质、助战转换率  属性
							 %% 更新主动技等级,提升技能效果
							 pet_battle:calc_player_add_fight(),
							 pet_base:save_pet_sys_attr_by_uid(PetUid),
							 pet_base:refresh_pet_and_skill([PetUid]),
							 PowerAfter = pet_battle:cal_single_pet_score(NewPet),
							 player:send(#pk_GS2U_pet_add_star_new_ret{pet_uid = PetUid, err_code = ?ERROR_OK}),
							 log_op(1, [PetUid, AssistCostPetUidList, NewPet]),
							 attainment:check_attainment(?Attainments_Type_PetStar),
							 activity_new_player:on_active_condition_change(?SalesActivity_PetAddStar, 1),
							 player_task:refresh_task([?Task_Goal_PetStar, ?Task_Goal_PetReachStar, ?Task_Goal_PetStarCount]),
							 seven_gift:check_task(?Seven_Type_PetStar),
							 activity_new_player:check_activity_cond_param_record(?SalesActivity_FirstStarPet, NewPetStar),
							 check_activity_pet_star_cond(NewPetStar, ?FALSE),
							 time_limit_gift:check_open(?TimeLimitType_PetStar, NewPetStar),
							 time_limit_gift:check_open(?TimeLimitType_PetStarNum),
							 pet_atlas:check_get(PetCfgId, NewPetStar),
							 pet_base:log_pet_star(OldPet, OldPetStar, NewPetStar),
							 recharge_gift_packs:on_open_condition_change([?RechargeGiftPacksCond_PetStar]),
							 guide:check_open_func(?OpenFunc_TargetType_PetLvAndStar),
							 efun_log:hero_change(3, PetCfgId, OldPet, NewPet, PowerBefore, PowerAfter, ItemCost ++ PetCost),
							 ok;
						 _ -> throw(?ERROR_Cfg)
					 end
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_pet_add_star_new_ret{pet_uid = PetUid, err_code = ErrCode})
				 end end).

%% sp英雄战阶升级
on_add_sp_lv(PetUid, AssistCostPetUidList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 OldPet = pet_new:get_pet(PetUid),
					 ?CHECK_THROW(OldPet =/= {}, ?ErrorCode_Pet_No),
					 #pet_new{sp_lv = OldPetSpLv, pet_cfg_id = PetCfgId, link_uid = LinkUid} = OldPet,
					 Cfg = cfg_petStar2:getRow(PetCfgId, OldPetSpLv),
					 ?CHECK_CFG(Cfg),
					 #petStar2Cfg{starMax = MaxStar, upNeedItem = NeedList} = Cfg,
					 ?CHECK_THROW(OldPetSpLv < MaxStar, ?ErrorCode_Pet_StarMax),
					 ?CHECK_THROW(NeedList =/= [], ?ERROR_Cfg),
					 %% 判断宠物状态 升级或者驯化过的宠物，将返回消耗材料
					 ?CHECK_THROW(not lists:member(PetUid, AssistCostPetUidList), ?ErrorCode_PetEqAndStar_CostPetRepeat),
					 delete_start_cost(AssistCostPetUidList, NeedList, ?TRUE),
					 NewPet = OldPet#pet_new{sp_lv = OldPetSpLv + 1},
					 pet_new:update_pet(NewPet),
					 pet_soul:sync_link_pet(PetUid),
					 RefreshPetUid = case cfg_petBase:getRow(PetCfgId) of
										 #petBaseCfg{sPType = SpType} when (SpType =:= 1 orelse SpType =:= 3) andalso LinkUid > 0 ->
											 LinkUid;
										 _ -> PetUid
									 end,
					 %% 重新计算宠物资质、助战转换率  属性
					 %% 更新主动技等级,提升技能效果
					 pet_battle:calc_player_add_fight(),
					 pet_base:save_pet_sys_attr_by_uid(RefreshPetUid),
					 pet_base:refresh_pet_and_skill([RefreshPetUid]),
					 buff_player:on_buff_change(),
					 player:send(#pk_GS2U_pet_add_sp_lv{pet_uid = PetUid, err_code = ?ERROR_OK})
				 catch
					 ErrCode -> player:send(#pk_GS2U_pet_add_sp_lv{pet_uid = PetUid, err_code = ErrCode})
				 end end).

%% 宠物星位点亮
on_add_star_pos(PetUid, Pos, AssistCostPetUidList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 ?CHECK_THROW(is_star_func_open(), ?ERROR_FunctionClose),
					 PetList = pet_new:get_pet_list(),
					 OldPet = lists:keyfind(PetUid, #pet_new.uid, PetList),
					 ?CHECK_THROW(OldPet =/= ?FALSE, ?ErrorCode_Pet_No),
					 #pet_new{star = OldPetStar, star_pos = StarPos, pet_cfg_id = PetCfgId} = OldPet,
					 PetBase = cfg_petBase:getRow(PetCfgId),
					 ?CHECK_CFG(PetBase),
					 #petBaseCfg{rareStar = NeedStar} = PetBase,
					 ?CHECK_THROW(NeedStar =:= 0 orelse OldPetStar =< NeedStar, ?ErrorCode_PetEqAndStar_NeedPromotion),
					 ?CHECK_THROW(lists:member({Pos, OldPetStar}, StarPos) =:= ?FALSE, ?ErrorCode_PetEqAndStar_PosHaveLight),
					 PetCfgId = OldPet#pet_new.pet_cfg_id,
					 case cfg_petStar:getRow(PetCfgId, OldPetStar) of
						 #petStarCfg{starMax = MaxStar, upNeedItem2 = NeedList2} ->
							 ?CHECK_THROW(OldPetStar < MaxStar, ?ErrorCode_Pet_StarMax),
							 NeedList = [{T, P1, P2, N} || {P, T, P1, P2, N} <- NeedList2, P =:= Pos],
							 ?CHECK_THROW(NeedList =/= [], ?ERROR_Cfg),
							 %% 判断宠物状态 升级或者驯化过的宠物，将返回消耗材料
							 ?CHECK_THROW(not lists:member(PetUid, AssistCostPetUidList), ?ErrorCode_PetEqAndStar_CostPetRepeat),
							 PowerBefore = pet_battle:cal_single_pet_score(OldPet),
							 {_, DeletePetCfgList} = delete_start_cost(AssistCostPetUidList, NeedList, ?TRUE, ?TRUE),
							 ItemCost = [{1, Cfg, Num} || {3, Cfg, _, Num} <- NeedList],
							 PetCost = [{3, CfgId, Star} || #pet_new{pet_cfg_id = CfgId, star = Star} <- DeletePetCfgList],
							 FullStarPos = lists:usort([QPos || {QPos, _, _, _, _} <- NeedList2]),
							 {NewPetStar, NewStarPos} = check_add_star(Pos, StarPos, OldPetStar, FullStarPos),
							 NewPet = OldPet#pet_new{star = NewPetStar, star_pos = NewStarPos},
							 pet_new:update_pet(NewPet),
							 pet_soul:sync_link_pet(PetUid),
							 %% 重新计算宠物资质、助战转换率  属性
							 %% 更新主动技等级,提升技能效果
							 pet_battle:calc_player_add_fight(),
							 pet_base:save_pet_sys_attr_by_uid(PetUid),
							 pet_base:refresh_pet_and_skill([PetUid]),
							 PowerAfter = pet_battle:cal_single_pet_score(NewPet),
							 player:send(#pk_GS2U_pet_add_star_pos_ret{pet_uid = PetUid, star_pos = Pos, err_code = ?ERROR_OK}),
							 case NewPetStar =/= OldPetStar of
								 ?TRUE ->
									 player:send(#pk_GS2U_pet_add_star_new_ret{pet_uid = PetUid, err_code = ?ERROR_OK}),
									 %% 升星公告
									 PlayerId = player:getPlayerID(),
									 add_star_push(PlayerId, PetCfgId, NewPetStar),
									 log_op(1, [PetUid, AssistCostPetUidList, NewPet]),
									 attainment:check_attainment(?Attainments_Type_PetStar),
									 activity_new_player:on_active_condition_change(?SalesActivity_PetAddStar, 1),
									 player_task:refresh_task([?Task_Goal_PetStar, ?Task_Goal_PetReachStar, ?Task_Goal_PetStarCount]),
									 seven_gift:check_task(?Seven_Type_PetStar),
									 activity_new_player:check_activity_cond_param_record(?SalesActivity_FirstStarPet, NewPetStar),
									 pet_base:log_pet_star(OldPet, OldPetStar, NewPetStar),
									 recharge_gift_packs:on_open_condition_change([?RechargeGiftPacksCond_PetStar]),
									 guide:check_open_func(?OpenFunc_TargetType_PetLvAndStar),
									 pet_atlas:check_get(PetCfgId, NewPetStar),
									 efun_log:hero_change(3, PetCfgId, OldPet, NewPet, PowerBefore, PowerAfter, ItemCost ++ PetCost);
								 ?FALSE ->
									 skip
							 end;
						 _ -> throw(?ERROR_Cfg)
					 end
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_pet_add_star_pos_ret{pet_uid = PetUid, err_code = ErrCode})
				 end end).

check_add_star(Pos, StarPos, OldPetStar, FullStarPos) ->
	NewPos = lists:keystore(Pos, 1, StarPos, {Pos, OldPetStar}),
	MaxStarPos = lists:usort([P || {P, Star} <- NewPos, Star =:= OldPetStar]), %% 检查本星级是否已满
	case MaxStarPos =:= FullStarPos of
		?TRUE -> {OldPetStar + 1, NewPos};
		?FALSE -> {OldPetStar, NewPos}
	end.

%% 快速进化  %% [{PetUid, AssistCostPetUidList}]
on_add_star_quick(CostList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 ?CHECK_THROW(is_star_func_open(), ?ERROR_FunctionClose),
					 on_add_star_quick_check(CostList),
					 {UidList, ReturnList} = on_add_star_quick_logic(CostList, {[], []}),
					 ?CHECK_THROW(UidList =/= [], ?ErrorCode_PetEqAndStar_CostBad),
					 case ReturnList =/= [] of
						 ?TRUE ->
							 MergeReturnList = common:listValueMerge(ReturnList),
							 player_item:show_get_item_dialog(MergeReturnList, [], [], 0);
						 _ -> skip
					 end,
					 %% 更新主动技等级,提升技能效果
					 pet_battle:calc_player_add_fight(),
					 pet_base:save_pet_sys_attr(),
					 pet_base:refresh_pet_and_skill(UidList),
					 attainment:check_attainment(?Attainments_Type_PetStar),
					 activity_new_player:on_active_condition_change(?SalesActivity_PetAddStar, 1),
					 log_op(2, [CostList, UidList]),
					 player_task:refresh_task([?Task_Goal_PetStar, ?Task_Goal_PetReachStar, ?Task_Goal_PetStarCount]),
					 seven_gift:check_task(?Seven_Type_PetStar),
					 recharge_gift_packs:on_open_condition_change([?RechargeGiftPacksCond_PetStar]),
					 guide:check_open_func(?OpenFunc_TargetType_PetLvAndStar),
					 player:send(#pk_GS2U_pet_add_star_new_quickly_ret{pet_uid_list = UidList, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_pet_add_star_new_quickly_ret{err_code = ErrCode})
				 end end).

%%英雄晋升
on_pet_promotion(PetUid, AssistCostPetUidList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		%% 判断宠物状态 升级或者驯化过的宠物，将返回消耗材料
		?CHECK_THROW(not lists:member(PetUid, AssistCostPetUidList), ?ErrorCode_PetEqAndStar_CostPetRepeat),
		OldPet = pet_new:get_pet(PetUid),
		?CHECK_THROW(OldPet =/= {}, ?ErrorCode_Pet_No),
		#pet_new{uid = PetUid, star = PetStar, pet_cfg_id = OldPetCfgId} = OldPet,
		case cfg_petBase:getRow(OldPetCfgId) of
			#petBaseCfg{rareUpCost = NeedList, rareStar = NeedStar, newPet = NewPetCfgId} ->
				?CHECK_THROW(NeedStar =/= 0, ?ErrorCode_PetEqAndStar_NotPromotion),%%该英雄无法晋升
				?CHECK_THROW(PetStar >= NeedStar, ?ErrorCode_PetEqAndStar_StarNoCondition),%%未达到可晋升星级，无法晋升
				case cfg_petBase:getRow(NewPetCfgId) of
					#petBaseCfg{rareType = NewRareType, elemType = ElemType} ->
						PowerBefore = pet_battle:cal_single_pet_score(OldPet),
						{_, DeletePetCfgList} = delete_start_cost(AssistCostPetUidList, NeedList, ?TRUE),
						SharedPetWashBase = pet_base:get_base_wash_attr(OldPetCfgId), %% 继承资质
						PetWashBase = pet_base:get_base_wash_attr(NewPetCfgId),
						AddWash = pet_base:compare_attr(SharedPetWashBase, OldPet#pet_new.wash),
						NewWash = pet_base:merge_wash_attr(PetWashBase, AddWash),

						NewPet1 = OldPet#pet_new{pet_cfg_id = NewPetCfgId, wash = NewWash, grade = NewRareType},
						NewPet = case NewPet1#pet_new.shared_flag of
									 1 -> NewPet1#pet_new{point = pet_battle:cal_single_pet_score(NewPet1)};
									 _ -> NewPet1
								 end,
						pet_new:update_pet(NewPet),
						pet_soul:sync_link_pet(PetUid),
						pet_pos:check_repeat(NewPet),%%更新各功能的防守阵容
						pet_atlas:check_get(NewPetCfgId, PetStar),%%新英雄再次升星 原来的图鉴不需要更新
						%% 重新计算宠物资质、助战转换率  属性
						%% 更新主动技等级,提升技能效果
						pet_battle:calc_player_add_fight(),
						pet_base:save_pet_sys_attr_by_uid(PetUid),
						pet_base:refresh_pet_and_skill([PetUid]),
						pet_shengshu:on_pet_guard_change(pet_new:get_pet(PetUid)),%%刷新圣树守卫 需要仔细检查

						pet_battle:send_pet_attr(player:getPlayerID(), NewPet#pet_new.uid),
						player:send(#pk_GS2U_pet_promotion_ret{pet_uid = PetUid, pet_cfgid = OldPetCfgId}),

						PlayerName = richText:getPlayerTextBySelf(),
						marquee:sendChannelNotice(0, 0, d3_HeroRankChange_1,
							fun(Language) ->
								{ColorText, _} = richText:getPetText(OldPetCfgId, Language),
								{_, GradeName} = richText:getPetText(NewPetCfgId, Language),
								language:format(language:get_server_string("D3_HeroRankChange_1", Language), [PlayerName, ColorText, GradeName])
							end),


						guide:check_open_func([?OpenFunc_TargetType_Pet, ?OpenFunc_TargetType_GetSpPet, ?OpenFunc_TargetType_PetLvAndStar]),
						activity_new_player:on_func_open_check(?ActivityOpenType_GetPet, {NewPetCfgId}),
						time_limit_gift:check_open(?TimeLimitType_PetTypeRareNum),
						attainment:check_attainment([?Attainments_Type_SSRHeroCount]),
						seven_gift:check_task(?Seven_Type_PetAtlas),
						seven_gift:check_task(?Seven_Type_PetStar),
						player_task:refresh_task([?Task_Goal_PetReachStar, ?Task_Goal_PetTypeCount]),
						new_bounty_task:update_bounty_task_sync(),%%赏金任务是否可派遣红点 刷新


						case NewRareType >= 3 andalso ElemType of
							1 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType1SSR, 1);
							2 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType2SSR, 1);
							3 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType3SSR, 1);
							_ -> ok
						end,

						PowerAfter = pet_battle:cal_single_pet_score(NewPet),
						ItemCost = [{1, Cfg, Num} || {3, Cfg, _, Num} <- NeedList],
						PetCost = [{3, CfgId, Star} || #pet_new{pet_cfg_id = CfgId, star = Star} <- DeletePetCfgList],
						log_op(6, [PetUid, AssistCostPetUidList, NewPet]),
						pet_base:log_pet_op([NewPet], ?REASON_pet_Substitute, get),
						efun_log:hero_change(4, OldPetCfgId, OldPet, NewPet, PowerBefore, PowerAfter, ItemCost ++ PetCost),
						ok;
					_ ->
						throw(?ERROR_Cfg)
				end;
			_ -> throw(?ERROR_Cfg)
		end
	catch
		ErrCode ->
			player:send(#pk_GS2U_pet_promotion_ret{pet_uid = PetUid, err_code = ErrCode})
	end.

%% 获取技能
get_skill_list(PetUid, PlayerId) ->
	%% 升星技能+宠物装备技能
	case PlayerId == player:getPlayerID() of
		?TRUE ->
			get_pet_skill(PetUid);
		_ ->
			get_pet_skill(PetUid, PlayerId)
	end.

%% 宠物装备合成 走通用合成
add_eq_ins(#pet_eq{} = Eq) ->
	?metrics(begin
				 EqList = get_eq_list(),
				 set_eq_list([Eq | EqList]),
				 Msg = #pk_GS2U_pet_eq_sync{eq_list = [make_eq_msg(Eq)]},
				 player:send(Msg),
				 table_player:insert(db_pet_eq, eq_to_db(Eq, player:getPlayerID())),
				 guide:check_open_func(?OpenFunc_TargetType_PetEq),
				 ok
			 end).
%% 背包增加宠物装备
on_item_eq_add(ItemList) -> ?metrics(begin item_eq_add(ItemList) end).
%% 背包删除宠物装备
on_item_eq_delete(ItemList) ->
	?metrics(begin
				 UidList = [Uid || #item{id = Uid} <- ItemList],
				 table_player:delete(db_pet_eq, player:getPlayerID(), UidList),
				 EqList = get_eq_list(),
				 DeleteFun = fun(Uid, Ret) -> lists:keydelete(Uid, #pet_eq.uid, Ret) end,
				 NewEqList = lists:foldl(DeleteFun, EqList, UidList),
				 set_eq_list(NewEqList)
			 end).

%% 穿戴宠物装备
on_eq_equip_on(PetPos, EqUid, Pos) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_eq_func_open(), ?ERROR_FunctionClose),
					 PetPosInfo = pet_pos:get_pet_pos(?STATUS_FIGHT, PetPos),
					 ?CHECK_THROW(PetPosInfo =/= {}, ?ErrorCode_PetPosLock),
					 #pet_pos{uid = PetUid, ring_eq_list = PosList} = PetPosInfo,
					 PetList = pet_new:get_pet_list(),
					 OldPet = lists:keyfind(PetUid, #pet_new.uid, PetList),
					 ?CHECK_THROW(OldPet =/= ?FALSE, ?ErrorCode_Pet_No),
					 LinkPet = pet_soul:link_pet(player:getPlayerID(), OldPet),
					 {ExistErr, _ItemList} = bag_player:get_bag_item(?BAG_PET_EQ, EqUid),
					 ?ERROR_CHECK_THROW(ExistErr),
					 ?CHECK_THROW(check_eq_pos_open(LinkPet#pet_new.star, Pos), ?ErrorCode_PetEqAndStar_NoPos),
					 TransErr1 = bag_player:transfer(?BAG_PET_EQ, EqUid, ?BAG_PET_EQ_EQUIP),
					 ?ERROR_CHECK_THROW(TransErr1),
					 case lists:keyfind(Pos, 1, PosList) of
						 {_, OldUid} when OldUid > 0 ->
							 TransErr2 = bag_player:transfer(?BAG_PET_EQ_EQUIP, OldUid, ?BAG_PET_EQ),
							 ?ERROR_CHECK_THROW(TransErr2);
						 _ -> ok
					 end,
					 NewPosList = lists:keystore(Pos, 1, PosList, {Pos, EqUid}),
					 NewPetPosInfo = PetPosInfo#pet_pos{ring_eq_list = NewPosList},
					 pet_pos:update_pet_pos(NewPetPosInfo),
					 pet_soul:sync_link_pet(PetUid),
					 %% 技能更新
					 pet_battle:calc_player_add_fight(),
					 pet_base:save_pet_sys_attr_by_uid(PetUid),
					 pet_base:refresh_pet_attr_and_skill(PetUid),
					 check_activity_pet_eq_cond(),
					 log_op(3, NewPetPosInfo),
					 player_task:refresh_task(?Task_Goal_PetEqCount),
					 attainment:check_attainment(?Attainments_Type_PetRingCount),
					 guide:check_open_func(?OpenFunc_TargetType_PetEq1),
					 player:send(#pk_GS2U_pet_eq_equip_on_ret{pet_pos = PetPos, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_pet_eq_equip_on_ret{pet_pos = PetPos, err_code = ErrCode})
				 end end).

%% 卸下宠物装备
on_eq_remove(PetPos, Pos) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_eq_func_open(), ?ERROR_FunctionClose),
					 #pet_pos{uid = PetUid, ring_eq_list = PosList} = PetPosInfo = pet_pos:get_pet_pos(?STATUS_FIGHT, PetPos),

					 case lists:keyfind(Pos, 1, PosList) of
						 {_, OldUid} when OldUid > 0 ->
							 Err = bag_player:transfer(?BAG_PET_EQ_EQUIP, OldUid, ?BAG_PET_EQ),
							 ?ERROR_CHECK_THROW(Err);
						 _ -> throw(?ErrorCode_PetEqAndStar_NoPosEq)
					 end,
					 NewPosList = lists:keydelete(Pos, 1, PosList),
					 NewPetPosInfo = PetPosInfo#pet_pos{ring_eq_list = NewPosList},
					 pet_pos:update_pet_pos(NewPetPosInfo),
					 case PetUid > 0 of
						 ?TRUE ->
							 pet_soul:sync_link_pet(PetUid),
							 %% 技能更新
							 pet_battle:calc_player_add_fight(),
							 pet_base:save_pet_sys_attr_by_uid(PetUid),
							 pet_base:refresh_pet_attr_and_skill(PetUid);
						 ?FALSE -> ok
					 end,
					 log_op(4, NewPetPosInfo),
					 attainment:check_attainment(?Attainments_Type_PetRingCount),
					 guide:check_open_func(?OpenFunc_TargetType_PetEq1),
					 player:send(#pk_GS2U_pet_eq_remove_ret{pet_pos = PetPos, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_pet_eq_remove_ret{pet_pos = PetPos, err_code = ErrCode})
				 end end).

%% 装备技能重置(下线也需要保留确认机会)
on_eq_skill_reset(EqUid, Type) -> ?metrics(begin
											   try
												   ?CHECK_THROW(is_eq_func_open(), ?ERROR_FunctionClose),
												   case Type of
													   1 -> eq_skill_reset(EqUid);
													   0 -> eq_skill_save(EqUid);
													   _ -> throw(?ERROR_Param)
												   end,
												   player:send(#pk_GS2U_pet_eq_skill_reset_ret{eq_uid = EqUid, type = Type, err_code = ?ERROR_OK})
											   catch
												   ErrCode ->
													   player:send(#pk_GS2U_pet_eq_skill_reset_ret{eq_uid = EqUid, type = Type, err_code = ErrCode})
											   end end).

%% 获取宠物身上超过某品质的装备数量
get_count_eq_chara(Cha) ->
	F = fun(#pet_pos{ring_eq_list = EqList}, Ret) ->
		length([1 || {_Pos, EqUid} <- EqList, get_eq_character(EqUid) >= Cha]) + Ret
		end,
	lists:foldl(F, 0, pet_pos:get_pet_pos_list()).

fix_data_20221208() ->
	EquipItemList = [ID || #item{id = ID} <- bag_player:get_bag_item_list(?BAG_PET_EQ_EQUIP)],
	F = fun(#pet_pos{ring_eq_list = EqList}, Ret) ->
		[EqUid || {_Pos, EqUid} <- EqList, EqUid > 0] ++ Ret
		end,
	NowEquipList = lists:foldl(F, [], pet_pos:get_pet_pos_list()),
	bag_player:transfer(?BAG_PET_EQ_EQUIP, EquipItemList--NowEquipList, ?BAG_PET_EQ).

%% SP回退
on_sp_return(Uid) ->
	try
		?CHECK_THROW(variable_world:get_value(?WorldVariant_Switch_SpReturn) =:= 1 andalso guide:is_open_action(?OpenAction_SpReturn), ?ERROR_FunctionClose),
		Pet = pet_new:get_pet(Uid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetEqAndStar_CostPetNo),
		#pet_new{pet_cfg_id = PetCfgID, sp_lv = SpLv} = Pet,
		?CHECK_THROW(SpLv > 0, ?ErrorCode_Pet_Return),
		ConsumeCfg = cfg_petReturnLimit2:getRow(SpLv),
		?CHECK_CFG(ConsumeCfg),
		PetStarCfg = cfg_petStar2:getRow(PetCfgID, SpLv),
		?CHECK_CFG(PetStarCfg),
		#petStar2Cfg{returnNeedItem = ReturnItem} = PetStarCfg,
		?CHECK_THROW(ReturnItem =/= [], ?ERROR_Param),
		#petReturnLimit2Cfg{returnItem = ReturnConsume} = ConsumeCfg,
		ConsumeErr = player:delete_cost(ReturnConsume, ?REASON_Pet_SpReturn),
		?ERROR_CHECK_THROW(ConsumeErr),
		NPet = Pet#pet_new{sp_lv = 0},
		pet_new:update_pet(NPet),
		ItemList = [{CfgID, Num} || {3, CfgID, _, Num} <- ReturnItem],
		PetList = [{PetCfgID_, 5, Num} || {4, PetCfgID_, _, Num} <- ReturnItem],
		bag_player:add(ItemList, ?REASON_Pet_SpReturn),
		pet_new:on_add_pet_list(PetList, ?TRUE),
		GetPetCacheList = [pet_new:get_pet(PetUid) || PetUid <- pet_new:get_activate_cache()],
		pet_new:send_active_attr_info(),
		pet_battle:calc_player_add_fight(),
		pet_base:save_pet_sys_attr_by_uid(Uid),
		pet_base:refresh_pet_and_skill([Uid]),
		buff_player:on_buff_change(),
		player:send(#pk_GS2U_return_sp_pet_ret{err_code = ?ERROR_OK, uid = Uid}),
		pet_base:log_pet_op(GetPetCacheList, ?REASON_Pet_SpReturn, get)
	catch
		Error ->
			player:send(#pk_GS2U_return_sp_pet_ret{err_code = Error, uid = Uid})
	end.

%%高星英雄 星级回退,将10星及以上英雄，进行回退
on_pet_star_rollback(Uid) ->
	try
		?CHECK_THROW(variable_world:get_value(?WorldVariant_Switch_PetStarRollback) =:= 1 andalso guide:is_open_action(?OpenAction_PetStarRollback), ?ERROR_FunctionClose),
		Pet = pet_new:get_pet(Uid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetEqAndStar_CostPetNo),
		#pet_new{pet_cfg_id = CfgId, star = Star, star_pos = StarPos} = Pet,
		PetStatCfg = cfg_petStar:getRow(CfgId, Star),
		?CHECK_CFG(PetStatCfg),
		PetReturnLimitCfg = cfg_petReturnLimit:getRow(Star),
		?CHECK_THROW(PetReturnLimitCfg =/= {}, ?ErrorCode_Pet_Return),
		#petReturnLimitCfg{canReturn = CanReturn, returnItem = CostItem} = PetReturnLimitCfg,
		?CHECK_THROW(CanReturn =:= 1, ?ErrorCode_Pet_Return),
		#petStarCfg{returnNeedItem = ReturnNeedItem, returnNeedItem2 = ReturnNeedItem2} = PetStatCfg,
		NowStarPos = [Pos || {Pos, PosStar} <- StarPos, PosStar =:= Star],
		StarPosItem = [{P1, P2, P3, P4} || {P, P1, P2, P3, P4} <- ReturnNeedItem2, lists:member(P, NowStarPos)],
		ReturnList = ReturnNeedItem ++ StarPosItem,%%ReturnNeedItem包含了上一个星级星位的消耗
		DecErr = player:delete_cost(CostItem, ?REASON_Pet_StarRollbackCost),
		?ERROR_CHECK_THROW(DecErr),
		NewPet = Pet#pet_new{star = 9, star_pos = []},
		pet_new:update_pet(NewPet),
		pet_soul:sync_link_pet(Uid),
		ReturnPetList = [{PetCfgId, PetStar, Num} || {1, PetCfgId, PetStar, Num} <- ReturnList],
		ReturnItemList = [{ItemCfgId, Num} || {3, ItemCfgId, _, Num} <- ReturnList],
		bag_player:add(ReturnItemList, ?REASON_Pet_StarRollback),
		pet_new:on_add_pet_list(ReturnPetList, ?TRUE),
		GetPetCacheList = [pet_new:get_pet(PetUid) || PetUid <- pet_new:get_activate_cache()],
		pet_base:log_pet_op(GetPetCacheList, ?REASON_Pet_StarRollback, get),
		pet_new:send_active_attr_info(),
		pet_battle:calc_player_add_fight(),
		pet_base:save_pet_sys_attr_by_uid(Uid),
		pet_base:refresh_pet_and_skill([Uid]),
		buff_player:on_buff_change(),
		player:send(#pk_GS2U_pet_star_rollback_ret{pet_uid = Uid, base_star = Star, base_star_pos = [Pos || {Pos, PosStar} <- StarPos, PosStar =:= Star]})
	catch
		Error -> player:send(#pk_GS2U_pet_star_rollback_ret{pet_uid = Uid, err_code = Error})
	end.

%% 快速9星
%% 注意代码逻辑需要和前端保持一致，不然返还可能与前端显示不一致
on_pet_quick_nine_star(PetUid, MEqualUidList) ->
	try
		TargetPet = pet_new:get_pet(PetUid),
		?CHECK_THROW(TargetPet =/= {}, ?ErrorCode_PetEqAndStar_CostPetNo),
		#pet_new{star = TargetStar, pet_cfg_id = TargetCfgID} = TargetPet,
		?CHECK_THROW(TargetStar < 9, ?ErrorCode_PetEqAndStar_GreaterThan9),
		PetStarCfg = cfg_petStar:getRow(TargetCfgID, TargetStar),
		?CHECK_CFG(PetStarCfg),
		#petStarCfg{fastNineNeedItem = FastNineNeedList} = PetStarCfg,
		check_pet_list_repeat([PetUid | MEqualUidList]),
		TargetElement = pet_draw:get_pet_element(TargetCfgID),
		EqualPetList = [Pet || Pet <- check_pet(MEqualUidList, ?FALSE), pet_base:is_original_pet(Pet) orelse throw(?ErrorCode_Pet_NOT_Orig)],
		{FinalType1List, FinalType2List, FinalType3Num, FinalType4List, FinalTempType3Type2} =
			lists:foldl(fun(#pet_new{pet_cfg_id = PetCfgID} = Pet, {Type1Ret, Type2Ret, Type3Ret, Type4Ret, TempType3Type2}) ->
				PetEle = pet_draw:get_pet_element(PetCfgID),
				?CHECK_THROW(PetEle > 0, ?ERROR_Cfg),
				EqualFiveList = get_pet_equal_five(Pet),
				Type1List = common:listValueMerge([{P1, P2} || {1, P1, P2} <- EqualFiveList]),
				Type2List = common:listValueMerge([{P1, P2} || {2, P1, P2} <- EqualFiveList]),
				Type3Num = lists:sum([P2 || {3, _P1, P2} <- EqualFiveList]),
				Type4List = common:listValueMerge([{P1, P2} || {4, P1, P2} <- EqualFiveList]),
				case {PetCfgID =:= TargetCfgID, PetEle =:= TargetElement} of
					{?TRUE, _} ->
						{Type1List ++ Type1Ret, Type2List ++ Type2Ret, Type3Num + Type3Ret, Type4List ++ Type4Ret, TempType3Type2};
					{?FALSE, ?TRUE} ->
						Type2TransList = [{pet_draw:get_pet_element(P1), P2} || {P1, P2} <- Type1List],
						{Type1Ret, Type2TransList ++ Type2List ++ Type2Ret, Type3Num + Type3Ret, Type4Ret, TempType3Type2};
					{?FALSE, ?FALSE} ->
						Type2TransList = [{pet_draw:get_pet_element(P1), P2} || {P1, P2} <- Type1List],
						{Type1Ret, Type2Ret, Type3Num + Type3Ret, Type4List ++ Type4Ret, Type2TransList ++ Type2List ++ TempType3Type2}
				end
						end, {[], [], 0, [], []}, EqualPetList),
		NeedType1List = [{P1, P2} || {1, P1, P2} <- FastNineNeedList],
		NeedType2List = [{P1, P2} || {2, P1, P2} <- FastNineNeedList],
		NeedType3Num = lists:sum([P2 || {3, _P1, P2} <- FastNineNeedList]),
		NeedType4List = [{P1, -P2} || {4, P1, P2} <- FastNineNeedList],

		RemainType1List1 = quick_nine_compare_type1(FinalType1List, NeedType1List),
		{RemainType2List1, RemainType1List2} = quick_nine_compare_type2(FinalType2List, NeedType2List, RemainType1List1),
		{ReturnType1List, ReturnType2List} = quick_nine_compare_type3(TargetElement, FinalType3Num, NeedType3Num, RemainType1List2, RemainType2List1, FinalTempType3Type2),
		NeedType4Merge = common:listValueMerge(NeedType4List ++ FinalType4List),
		NeedDecItemList = [{ItemID, -Num} || {ItemID, Num} <- NeedType4Merge, Num < 0],
		ReturnItemList = [{ItemID, Num} || {ItemID, Num} <- NeedType4Merge, Num > 0],
		{ItemError, ItemPrepared} = bag_player:delete_prepare(NeedDecItemList),
		?ERROR_CHECK_THROW(ItemError),
		bag_player:delete_finish(ItemPrepared, ?REASON_Pet_QuickStarNine),
		consume_pet(?FALSE, MEqualUidList, ?REASON_Pet_QuickStarNine),
		pet_new:update_pet(TargetPet#pet_new{star = 9}),
		pet_soul:sync_link_pet(PetUid),

		ReturnPetList = [{CfgID, 5, Num} || {CfgID, Num} <- ReturnType1List] ++ [{get_pet_star_return(P1), 5, Num} || {P1, Num} <- ReturnType2List],
		pet_new:on_add_pet_list(ReturnPetList, ?TRUE),
		ReturnPetUidList = pet_new:get_activate_cache(),
		bag_player:add(ReturnItemList, ?REASON_Pet_QuickStarNine),
		player:send(#pk_GS2U_pet_quick_nine_star_ret{pet_uid = PetUid, err_code = ?ERROR_OK, retrun_pet_uid_list = ReturnPetUidList,
			item_list = [#pk_Dialog_Item{item_id = I, count = N} || {I, N} <- ReturnItemList]}),
		pet_new:send_active_attr_info(),
		pet_battle:calc_player_add_fight(),
		pet_base:save_pet_sys_attr_by_uid(PetUid),
		pet_base:refresh_pet_and_skill([PetUid]),
		pet_atlas:check_get(TargetCfgID, 9),
		GetPetCacheList = [pet_new:get_pet(PetUid_) || PetUid_ <- ReturnPetUidList],
		pet_base:log_pet_op(GetPetCacheList, ?REASON_Pet_QuickStarNine, get)
	catch
		Error -> player:send(#pk_GS2U_pet_quick_nine_star_ret{pet_uid = PetUid, err_code = Error})
	end.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 升星功能开启  %% 用基础模块的功能开关
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Pet) =:= 1 andalso guide:is_open_action(?OpenAction_Pet).
%% 宠物装备功能开关
is_eq_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetEq) =:= 1 andalso guide:is_open_action(?OpenAction_PetEq).

%%英雄升星功能开关
is_star_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetEq) =:= 1 andalso guide:is_open_action(?OpenAction_Pet_Star).

%% 进程字典
%% 宠物装备
get_eq_list() -> get(pet_eq_and_star_eq_list).
set_eq_list(List) -> put(pet_eq_and_star_eq_list, List).

%% 数据转换
eq_to_db(#pet_eq{uid = Uid, cfg_id = CfgId, reset_time = ResetTime, skill_list = SkillList, reset_skill_list = ResetSkillList}, PlayerId) ->
	#db_pet_eq{player_id = PlayerId, uid = Uid, cfg_id = CfgId, reset_time = ResetTime, skill_list = gamedbProc:term_to_dbstring(SkillList),
		reset_skill_list = gamedbProc:term_to_dbstring(ResetSkillList)}.
db_to_eq(#db_pet_eq{uid = Uid, cfg_id = CfgId, reset_time = ResetTime, skill_list = SkillList, reset_skill_list = ResetSkillList}) ->
	#pet_eq{uid = Uid, cfg_id = CfgId, reset_time = ResetTime, skill_list = gamedbProc:dbstring_to_term(SkillList),
		reset_skill_list = gamedbProc:dbstring_to_term(ResetSkillList)}.

%% 协议
make_eq_msg(PetEq) ->
	#pk_pet_eq{uid = PetEq#pet_eq.uid, cfg_id = PetEq#pet_eq.cfg_id, reset_time = PetEq#pet_eq.reset_time,
		skill_list = make_eq_skill_msg(PetEq#pet_eq.skill_list),
		reset_skill_list = make_eq_skill_msg(PetEq#pet_eq.reset_skill_list)}.
make_eq_skill_msg(SkillList) ->
	[#pk_pet_eq_skill{pos = Pos, skill_id = SkillId} || {Pos, SkillId, _, _} <- SkillList].


%% 检查消耗宠物uid是否重复
check_pet_list_repeat([Uid | PetUidList]) ->
	case lists:member(Uid, PetUidList) of
		?FALSE ->
			check_pet_list_repeat(PetUidList);
		_ -> throw(?ErrorCode_PetEqAndStar_CostPetRepeat)
	end;
check_pet_list_repeat([]) -> ok.

%% 检查宠物是否可以用于升星
check_pet([], _) -> [];
check_pet(PetUidList, IsCheckFight) ->
	%% 出战、助战状态不可用于升星
	%% 处于锁定状态不能用于升星
	%% 幻兽不能作为消耗宠物  被链接的宠物不能用于消耗 被附灵的宠物不能用于消耗
	%% 通过孵化获得的宠物不能用于升星
	%% 作为升星材料的宠物身上有装备不能升星
	check_pet_logic(PetUidList, [], IsCheckFight).
check_pet_logic([Uid | UidList], Ret, IsCheckFight) ->
	case pet_new:get_pet(Uid) of
		#pet_new{pet_cfg_id = CfgId, fight_flag = Flag, is_lock = IsLock, get_by_egg = GetByEgg, link_uid = LinkUid,
			been_link_uid = BeenLinkUid, been_appendage_uid = BeenAppendageUid} = Pet ->
			case cfg_petBase:getRow(CfgId) of
				#petBaseCfg{} = PetCfg ->
					?CHECK_THROW(pet_substitution:check_is_star_cons(PetCfg), ?ErrorCode_PetEqAndStar_CostPetStarCost);
				_ -> throw(?ErrorCode_PetEqAndStar_CostPetStarCost)
			end,
			?CHECK_THROW(BeenLinkUid =:= 0, ?ErrorCode_PetEqAndStar_CostPetLinked),%% 被链接的宠物不能用于消耗
			?CHECK_THROW(LinkUid =:= 0, ?ErrorCode_PetEqAndStar_CostPetLinked2),%% 链接的宠物不能用于消耗
			?CHECK_THROW(BeenAppendageUid =:= 0, ?ErrorCode_PetEqAndStar_CostPetBeenAppendage),%% 被附灵的宠物不能用于消耗
			case IsCheckFight of
				?TRUE ->%%需要检查是否英雄在助战,在助战也通过
					?CHECK_THROW(Flag =:= 0 orelse Flag =:= 2, ?ErrorCode_PetEqAndStar_CostPetFightFlag);%% 放入的消耗宠物处于出战中
				_ ->
					?CHECK_THROW(Flag =:= 0, ?ErrorCode_PetEqAndStar_CostPetBadFightFlag)%% 放入的消耗宠物处于助战中或出战中
			end,
			?CHECK_THROW(IsLock =:= 0, ?ErrorCode_PetEqAndStar_CostPetLocked),%% 放入的消耗宠物处于锁定状态不能用于升星
			?CHECK_THROW(GetByEgg =:= 0, ?ErrorCode_PetEqAndStar_GetByEgg),%% 通过孵化获得的宠物不能用于升星
			check_pet_logic(UidList, [Pet | Ret], IsCheckFight);
		_ -> throw(?ErrorCode_PetEqAndStar_CostPetNo)
	end;
check_pet_logic(_, Ret, _) -> Ret.

delete_start_cost_error(PetUidList, CfgNeedList, IsPush) ->
	try
		{ReturnList, _} = delete_start_cost(PetUidList, CfgNeedList, IsPush),
		{?ERROR_OK, ReturnList}
	catch
		Error -> {Error, []}
	end.
%% 扣除升星消耗    判断宠物状态 升级或者驯化过的宠物，将返回消耗材料 IsPush:是否恭喜获得  IsCheckFight:是否需要检查消耗的英雄是否已助战，并将该英雄下阵
delete_start_cost(PetUidList, CfgNeedList, IsPush) ->
	delete_start_cost(PetUidList, CfgNeedList, IsPush, ?FALSE).
delete_start_cost(PetUidList, CfgNeedList, IsPush, IsCheckFight) ->
	%% 检查消耗宠物uid是否重复
	check_pet_list_repeat(PetUidList),
	PetList = check_pet(PetUidList, IsCheckFight),
	NeedPet1List = [{V1, V2, Num} || {1, V1, V2, Num} <- CfgNeedList],
	NeedPet4List = [{V1, V2, Num} || {4, V1, V2, Num} <- CfgNeedList],
	ItemList = [{V1, Num} || {3, V1, _, Num} <- CfgNeedList],
	SpiltNeedFun = fun({Type, V1, V2, Num}, {Type2List, Type5List}) ->
		case Type of
			2 -> %% 保证不限类型的放到列表尾
				NewType2List = case V1 of
								   0 -> Type2List ++ [{V1, V2, Num}];
								   _ -> [{V1, V2, Num} | Type2List]
							   end,
				{NewType2List, Type5List};
			5 -> NewType5List = case V1 of
									0 -> Type5List ++ [{V1, V2, Num}];
									_ -> [{V1, V2, Num} | Type2List]
								end,
				{Type2List, NewType5List};
			_ -> {Type2List, Type5List}
		end;
		(_, Ret) ->
			?LOG_ERROR("cfg_petStar, error_need:~p", [CfgNeedList]),
			Ret
				   end,
	{NeedPet2List, NeedPet5List} = lists:foldl(SpiltNeedFun, {[], []}, CfgNeedList),
	{DeletePetUidList1, ReturnList1, PetList1} = calc_type1_pet_cost(NeedPet1List, PetList, {[], [], PetList}),
	{DeletePetUidList2, ReturnList2, PetList2} = calc_type2_pet_cost(NeedPet2List, PetList1, {[], [], PetList1}),
	{DeletePetUidList4, ReturnList4, PetList4} = calc_type4_pet_cost(NeedPet4List, PetList2, {[], [], PetList2}),
	{DeletePetUidList5, ReturnList5, _PetList5} = calc_type5_pet_cost(NeedPet5List, PetList4, {[], [], PetList4}),
	DeletePetUidList = DeletePetUidList2 ++ DeletePetUidList1 ++ DeletePetUidList4 ++ DeletePetUidList5,
	ReturnList = ReturnList2 ++ ReturnList1 ++ ReturnList4 ++ ReturnList5,
	case ItemList =/= [] of
		?TRUE ->
			ItemErr = player:delete_cost(ItemList, [], ?REASON_pet_add_star),
			?ERROR_CHECK_THROW(ItemErr);
		_ -> skip
	end,
	DeletePetList = consume_pet(IsCheckFight, DeletePetUidList, ?REASON_pet_add_star),
	case ReturnList =/= [] of
		?TRUE ->
			player_item:reward(ReturnList, [], [], ?REASON_pet_add_item),
			IsPush andalso player_item:show_get_item_dialog(ReturnList, [], [], 0);
		_ -> skip
	end,
	{ReturnList, DeletePetList}.

consume_pet(IsCheckFight, DeletePetUidList, Reason) ->
	IsCheckFight andalso check_pet_fight(DeletePetUidList),
	%% 宠物照看时被消耗掉
	check_looking_pet_cost(DeletePetUidList),
	DeletePetList = [pet_new:get_pet(Uid) || Uid <- DeletePetUidList],
	%% 删除宠物
	pet_new:delete_pet(DeletePetUidList),
	pet_base:log_pet_op(DeletePetList, Reason, lose),
	DeletePetList.

%% 指定魔宠、指定星级
calc_type1_pet_cost([NeedPet | NeedPetList], PetList, Ret) ->
	{_DeletePetUidList1, _ReturnList1, PetList1} = NewRet = calc_type1_pet_cost_filter(NeedPet, PetList, Ret),
	calc_type1_pet_cost(NeedPetList, PetList1, NewRet);
calc_type1_pet_cost([], _PetList, Ret) -> Ret.
calc_type1_pet_cost_filter({NeedCfgId, Star, Num} = NeedPet, [#pet_new{uid = Uid, pet_cfg_id = CfgId, star = Star} | PetList], {Ret1, Ret2, Ret3} = Ret) ->
	case NeedCfgId =:= CfgId orelse pet_base:get_alternative_pet_id(NeedCfgId) =:= CfgId of
		?TRUE ->
			NewRet1 = [Uid | Ret1],
			%% 升级或者驯化过的宠物，将返回消耗材料 从pet_new调用
			NewRet2 = pet_back(Uid) ++ Ret2,
			NewRet3 = lists:keydelete(Uid, #pet_new.uid, Ret3),
			NewRet = {NewRet1, NewRet2, NewRet3},
			case Num - 1 =< 0 of
				?TRUE -> NewRet;
				_ ->
					calc_type1_pet_cost_filter({NeedCfgId, Star, Num - 1}, PetList, NewRet)
			end;
		?FALSE ->
			case PetList =/= [] of
				?TRUE ->
					calc_type1_pet_cost_filter(NeedPet, PetList, Ret);
				_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
			end
	end;
calc_type1_pet_cost_filter(NeedPet, [_ | PetList], Ret) ->
	case PetList =/= [] of
		?TRUE ->
			calc_type1_pet_cost_filter(NeedPet, PetList, Ret);
		_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
	end;
calc_type1_pet_cost_filter(_NeedPet, [], _Ret) -> throw(?ErrorCode_PetEqAndStar_CostBad).

%% 保证不限类型的放到列表尾
calc_type2_pet_cost([NeedPet | NeedPetList], PetList, Ret) ->
	{_DeletePetUidList1, _ReturnList1, PetList1} = NewRet = calc_type2_pet_cost_filter(NeedPet, PetList, Ret),
	calc_type2_pet_cost(NeedPetList, PetList1, NewRet);
calc_type2_pet_cost([], _PetList, Ret) -> Ret.
calc_type2_pet_cost_filter({ElemType, Star, Num} = NeedPet, [#pet_new{uid = Uid, pet_cfg_id = CfgId, star = Star} | PetList], {Ret1, Ret2, Ret3} = Ret) ->
	case ElemType =/= 0 of
		?TRUE ->
			case cfg_petBase:getRow(CfgId) of
				#petBaseCfg{elemType = ElemType} ->
					NewRet1 = [Uid | Ret1],
					%% 升级或者驯化过的宠物，将返回消耗材料 从pet_new调用
					NewRet2 = pet_back(Uid) ++ Ret2,
					NewRet3 = lists:keydelete(Uid, #pet_new.uid, Ret3),
					NewRet = {NewRet1, NewRet2, NewRet3},
					case Num - 1 =< 0 of
						?TRUE -> NewRet;
						_ ->
							calc_type2_pet_cost_filter({ElemType, Star, Num - 1}, PetList, NewRet)
					end;
				_ ->
					case PetList =/= [] of
						?TRUE ->
							calc_type2_pet_cost_filter(NeedPet, PetList, Ret);
						_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
					end
			end;
		_ ->
			NewRet1 = [Uid | Ret1],
			%% 升级或者驯化过的宠物，将返回消耗材料 从pet_new调用
			NewRet2 = pet_back(Uid) ++ Ret2,
			NewRet3 = lists:keydelete(Uid, #pet_new.uid, Ret3),
			NewRet = {NewRet1, NewRet2, NewRet3},
			case Num - 1 =< 0 of
				?TRUE -> NewRet;
				_ ->
					calc_type2_pet_cost_filter({ElemType, Star, Num - 1}, PetList, NewRet)
			end
	end;
calc_type2_pet_cost_filter(NeedPet, [_ | PetList], Ret) ->
	case PetList =/= [] of
		?TRUE ->
			calc_type2_pet_cost_filter(NeedPet, PetList, Ret);
		_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
	end;
calc_type2_pet_cost_filter(_NeedPet, [], _Ret) -> throw(?ErrorCode_PetEqAndStar_CostBad).

%% 指定sp英雄、指定战阶
calc_type4_pet_cost([NeedPet | NeedPetList], PetList, Ret) ->
	{_DeletePetUidList1, _ReturnList1, PetList1} = NewRet = calc_type4_pet_cost_filter(NeedPet, PetList, Ret),
	calc_type1_pet_cost(NeedPetList, PetList1, NewRet);
calc_type4_pet_cost([], _PetList, Ret) -> Ret.
calc_type4_pet_cost_filter({CfgId, SpLv, Num}, [#pet_new{uid = Uid, pet_cfg_id = CfgId, sp_lv = SpLv} | PetList], {Ret1, Ret2, Ret3}) ->
	NewRet1 = [Uid | Ret1],
	%% 升级或者驯化过的宠物，将返回消耗材料 从pet_new调用
	NewRet2 = pet_back(Uid) ++ Ret2,
	NewRet3 = lists:keydelete(Uid, #pet_new.uid, Ret3),
	NewRet = {NewRet1, NewRet2, NewRet3},
	case Num - 1 =< 0 of
		?TRUE -> NewRet;
		_ ->
			calc_type4_pet_cost_filter({CfgId, SpLv, Num - 1}, PetList, NewRet)
	end;
calc_type4_pet_cost_filter(NeedPet, [_ | PetList], Ret) ->
	case PetList =/= [] of
		?TRUE ->
			calc_type4_pet_cost_filter(NeedPet, PetList, Ret);
		_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
	end;
calc_type4_pet_cost_filter(_NeedPet, [], _Ret) -> throw(?ErrorCode_PetEqAndStar_CostBad).

%% 保证不限类型的放到列表尾
calc_type5_pet_cost([NeedPet | NeedPetList], PetList, Ret) ->
	{_DeletePetUidList1, _ReturnList1, PetList1} = NewRet = calc_type5_pet_cost_filter(NeedPet, PetList, Ret),
	calc_type5_pet_cost(NeedPetList, PetList1, NewRet);
calc_type5_pet_cost([], _PetList, Ret) -> Ret.
calc_type5_pet_cost_filter({ElemType, SpLv, Num} = NeedPet, [#pet_new{uid = Uid, pet_cfg_id = CfgId, sp_lv = SpLv} | PetList], {Ret1, Ret2, Ret3} = Ret) ->
	case ElemType =/= 0 of
		?TRUE ->
			case cfg_petBase:getRow(CfgId) of
				#petBaseCfg{elemType = ElemType} ->
					NewRet1 = [Uid | Ret1],
					%% 升级或者驯化过的宠物，将返回消耗材料 从pet_new调用
					NewRet2 = pet_back(Uid) ++ Ret2,
					NewRet3 = lists:keydelete(Uid, #pet_new.uid, Ret3),
					NewRet = {NewRet1, NewRet2, NewRet3},
					case Num - 1 =< 0 of
						?TRUE -> NewRet;
						_ ->
							calc_type5_pet_cost_filter({ElemType, SpLv, Num - 1}, PetList, NewRet)
					end;
				_ ->
					case PetList =/= [] of
						?TRUE ->
							calc_type5_pet_cost_filter(NeedPet, PetList, Ret);
						_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
					end
			end;
		_ ->
			NewRet1 = [Uid | Ret1],
			%% 升级或者驯化过的宠物，将返回消耗材料 从pet_new调用
			NewRet2 = pet_back(Uid) ++ Ret2,
			NewRet3 = lists:keydelete(Uid, #pet_new.uid, Ret3),
			NewRet = {NewRet1, NewRet2, NewRet3},
			case Num - 1 =< 0 of
				?TRUE -> NewRet;
				_ ->
					calc_type5_pet_cost_filter({ElemType, SpLv, Num - 1}, PetList, NewRet)
			end
	end;
calc_type5_pet_cost_filter(NeedPet, [_ | PetList], Ret) ->
	case PetList =/= [] of
		?TRUE ->
			calc_type2_pet_cost_filter(NeedPet, PetList, Ret);
		_ -> throw(?ErrorCode_PetEqAndStar_CostPetBadCondition)
	end;
calc_type5_pet_cost_filter(_NeedPet, [], _Ret) -> throw(?ErrorCode_PetEqAndStar_CostBad).

on_add_star_quick_check(CostList) ->
	PetUidList = [PetUid || {PetUid, _} <- CostList],
	CheckFun1 = fun(List) ->
		Fun = fun(Uid) -> lists:member(Uid, List) andalso throw(?ErrorCode_PetEqAndStar_CostPetRepeat) end,
		lists:foreach(Fun, PetUidList)
				end,
	CheckFun = fun({_, AssistCostPetUidList}) ->
		CheckFun1(AssistCostPetUidList)
			   end,
	lists:foreach(CheckFun, CostList).

on_add_star_quick_logic([{PetUid, AssistCostPetUidList} | List], {Ret1, Ret2} = Ret) ->
	PetList = pet_new:get_pet_list(),
	OldPet = lists:keyfind(PetUid, #pet_new.uid, PetList),
	case OldPet =/= ?FALSE of
		?TRUE ->
			OldPetStar = OldPet#pet_new.star,
			PetCfgId = OldPet#pet_new.pet_cfg_id,
			case cfg_petStar:getRow(PetCfgId, OldPetStar) of
				#petStarCfg{starMax = MaxStar, upNeedItem = NeedList} when OldPetStar < MaxStar ->
					%% 判断宠物状态 升级或者驯化过的宠物，将返回消耗材料
					FixAssistCostPetUidList = lists:delete(PetUid, AssistCostPetUidList),
					case delete_start_cost_error(FixAssistCostPetUidList, NeedList, ?FALSE) of
						{?ERROR_OK, ReturnList} ->
							NewPetStar = OldPetStar + 1,
							PlayerId = player:getPlayerID(),
							%% 升星公告
							add_star_push(PlayerId, PetCfgId, NewPetStar),
							NewPet = OldPet#pet_new{star = NewPetStar},
							pet_new:update_pet(NewPet),
							pet_soul:sync_link_pet(NewPet#pet_new.uid),
							NewRet = {[PetUid | Ret1], ReturnList ++ Ret2},
							pet_base:log_pet_star(OldPet, OldPetStar, NewPetStar),
							pet_atlas:check_get(PetCfgId, NewPetStar),
							on_add_star_quick_logic(List, NewRet);
						_ -> on_add_star_quick_logic(List, Ret)
					end;
				_ -> on_add_star_quick_logic(List, Ret)
			end;
		_ -> on_add_star_quick_logic(List, Ret)
	end;
on_add_star_quick_logic([], Ret) -> Ret.

get_pet_skill(PetUid) ->
	case lists:keyfind(PetUid, #pet_new.uid, pet_new:get_pet_list()) of
		?FALSE -> [];
		#pet_new{pet_cfg_id = CfgId, grade = Grade, fight_flag = FightFlag, fight_pos = FightPos, sp_lv = SpLv} = Pet ->
			#pet_new{star = Star} = pet_soul:link_pet(player:getPlayerID(), Pet),
			calc_pet_skill(CfgId, Star, Grade, {FightFlag, FightPos}, SpLv)
	end.
%% 计算宠物技能
calc_pet_skill(CfgId, Star, Grade, FightPosKey, SpLv) ->
	case cfg_petStar:getRow(CfgId, Star) of
		#petStarCfg{} = StarCfg ->
			SkillStar = case Grade of
							_ -> [{P1, P2, P3, P4, P5} || {P1, P2, P3, P4, P5, _} <- StarCfg#petStarCfg.skill]
%%									1 -> StarCfg#petStarCfg.skill1;
%%									2 -> StarCfg#petStarCfg.skill2;
%%									_ -> StarCfg#petStarCfg.skill3
						end,
			PetSkillList = lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex}, Ret) ->
				case T of
					0 -> [{SkillType, SkillId, SkillIndex} | Ret];
					1 -> common:getTernaryValue(Star >= P, [{SkillType, SkillId, SkillIndex} | Ret], Ret);
					_ -> Ret
				end;
				(_, Ret) ->
					?LOG_ERROR("cfg_petStar, error_key:~p-~p, error_skill_grade:~p", [CfgId, Star, Grade]),
					Ret
									   end, [], SkillStar),
			EqSkillList = get_eq_skill(FightPosKey, Star),
			PetSkillList ++ EqSkillList ++ get_pet_transform_skill(StarCfg) ++ get_sp_skill(CfgId, Star, SpLv);
		_ ->
			?LOG_ERROR("cfg_petStar, error_key:~p-~p", [CfgId, Star]),
			[]
	end.

get_pet_transform_skill(#petStarCfg{transSkill = TransSkill}) ->
	[{SkillType, SkillId, Index} || {_ConType, _Star, SkillType, SkillId, Index} <- TransSkill,
		cfg_skillBase:getRow(SkillId) =/= {}].

get_sp_skill(CfgId, Star, SpLv) ->
	case cfg_petStar2:getRow(CfgId, SpLv) of
		#petStar2Cfg{skill = Skill} ->
			lists:foldl(fun({T, P, 1, SkillId, SkillIndex, SkillLv}, Ret) ->
				case T of
					0 -> [{1, SkillId, SkillIndex, SkillLv} | Ret];
					1 -> common:getTernaryValue(Star >= P, [{1, SkillId, SkillIndex, SkillLv} | Ret], Ret)
				end;
				({T, P, 2, SkillId, SkillIndex, _SkillLv}, Ret) ->
					case T of
						0 -> [{2, SkillId, SkillIndex} | Ret];
						1 -> common:getTernaryValue(Star >= P, [{2, SkillId, SkillIndex} | Ret], Ret)
					end;
				(_, Ret) ->
					?LOG_ERROR("check cfg_petStar2:~p, Star:~p", [{CfgId, SpLv}, Star]),
					Ret
						end, [], Skill);
		_ -> []
	end.

%% 获取宠物装备技能
get_eq_skill({FightType, FightPos}, Star) ->
	Fun = fun({EqPos, Uid}, {RetPos, Ret}) when Uid > 0 ->
		case check_eq_pos_open(Star, EqPos) andalso lists:keyfind(Uid, #pet_eq.uid, get_eq_list()) of
			#pet_eq{skill_list = SkillList} ->
				NewRet = [begin
							  case cfg_petEquipSkill:getRow(Quality, Order) of
								  #petEquipSkillCfg{skill = {Type, NewId, _}} ->
									  {Type, NewId, get_skill_pos(RetPos, Pos)};
								  _ -> {1, OldId, get_skill_pos(RetPos, Pos)} %% 策划删配置，造成数据库数据配置为空
							  end
						  end || {Pos, OldId, Quality, Order} <- SkillList] ++ Ret,
				{RetPos + length(SkillList), NewRet};
			_ -> {RetPos, Ret}
		end;
		(_, Ret) -> Ret
		  end,
	{_, EqSkillList} = lists:foldl(Fun, {0, []}, pet_pos:get_pet_pos_ring_eq_list(FightType, FightPos)),
	EqSkillList.

get_skill_pos(Start, Pos) -> get_skill_pos(Start + Pos).
get_skill_pos(1) -> ?SkillPos_678;
get_skill_pos(2) -> ?SkillPos_679;
get_skill_pos(3) -> ?SkillPos_680;
get_skill_pos(4) -> ?SkillPos_681;
get_skill_pos(5) -> ?SkillPos_682;
get_skill_pos(6) -> ?SkillPos_683;
get_skill_pos(7) -> ?SkillPos_684;
get_skill_pos(8) -> ?SkillPos_685;
get_skill_pos(_) -> ?SkillPos_686. %% 9

%% 其他进程 获取宠物技能
get_pet_skill(PetUid, PlayerId) ->
	case table_player:lookup(db_pet_new, PlayerId, [PetUid]) of
		[#db_pet_new{} = DbPet] ->
			#pet_new{pet_cfg_id = CfgId, grade = Grade, fight_flag = FightType, fight_pos = FightPos, sp_lv = SpLv} = Pet = pet_new:db_pet2pet(DbPet),
			#pet_new{star = Star} = pet_soul:link_pet(PlayerId, Pet),
			calc_pet_skill(PlayerId, CfgId, Star, Grade, {FightType, FightPos}, SpLv);
		_ -> []
	end.
calc_pet_skill(PlayerId, CfgId, Star, Grade, FightPosKey, SpLv) ->
	case cfg_petStar:getRow(CfgId, Star) of
		#petStarCfg{} = StarCfg ->
			SkillStar = case Grade of
							_ -> [{P1, P2, P3, P4, P5} || {P1, P2, P3, P4, P5, _} <- StarCfg#petStarCfg.skill]
%%									1 -> StarCfg#petStarCfg.skill1;
%%									2 -> StarCfg#petStarCfg.skill2;
%%									_ -> StarCfg#petStarCfg.skill3
						end,
			PetSkillList = lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex}, Ret) ->
				case T of
					0 -> [{SkillType, SkillId, SkillIndex} | Ret];
					1 -> common:getTernaryValue(Star >= P, [{SkillType, SkillId, SkillIndex} | Ret], Ret);
					_ -> Ret
				end;
				(_, Ret) ->
					?LOG_ERROR("cfg_petStar, error_key:~p-~p, error_skill_grade:~p", [CfgId, Star, Grade]),
					Ret
									   end, [], SkillStar),
			EqSkillList = get_eq_skill(FightPosKey, Star, PlayerId),
			PetSkillList ++ EqSkillList ++ get_pet_transform_skill(StarCfg) ++ get_sp_skill(CfgId, Star, SpLv);
		_ ->
			?LOG_ERROR("cfg_petStar, error_key:~p-~p", [CfgId, Star]),
			[]
	end.
%% 其他进程 获取宠物装备技能
get_eq_skill({FightType, FightPos}, Star, PlayerId) ->
	UidList = [Uid || {Pos, Uid} <- pet_pos:get_pet_pos_ring_eq_list(PlayerId, FightType, FightPos), Uid > 0 andalso check_eq_pos_open(Star, Pos)],
	Fun = fun(#db_pet_eq{skill_list = DbSkillList}, {RetPos, Ret}) ->
		SkillList = gamedbProc:dbstring_to_term(DbSkillList),
		NewRet = [begin
					  case cfg_petEquipSkill:getRow(Quality, Order) of
						  #petEquipSkillCfg{skill = {Type, NewId, _}} ->
							  {Type, NewId, get_skill_pos(RetPos, Pos)};
						  _ -> {1, OldId, get_skill_pos(RetPos, Pos)} %% 策划删配置，造成数据库数据配置为空
					  end
				  end || {Pos, OldId, Quality, Order} <- SkillList] ++ Ret,
		{RetPos + length(SkillList), NewRet}
		  end,
	{_, EqSkillList} = lists:foldl(Fun, {0, []}, table_player:lookup(db_pet_eq, PlayerId, UidList)),
	EqSkillList.

%% 生成宠物装备
item_eq_add(ItemList) ->
	PlayerId = player:getPlayerID(),
	Fun = fun(#item{id = Uid, cfg_id = CfgId}, {R1, R2, R3}) ->
		SkillList = rand_eq_skill_list(CfgId),
		Eq = #pet_eq{uid = Uid, cfg_id = CfgId, skill_list = SkillList},
		{[Eq | R1], [eq_to_db(Eq, PlayerId) | R2], [make_eq_msg(Eq) | R3]}
		  end,
	{EqList, DbEqList, MsgEqList} = lists:foldl(Fun, {get_eq_list(), [], []}, ItemList),
	set_eq_list(EqList),
	table_player:insert(db_pet_eq, DbEqList),
	Msg = #pk_GS2U_pet_eq_sync{eq_list = MsgEqList},
	player:send(Msg),
	guide:check_open_func(?OpenFunc_TargetType_PetEq),
	ok.
rand_eq_skill_list(EqCfgId) ->
	case cfg_petEquipNew:getRow(EqCfgId) of
		#petEquipNewCfg{skillNum = SkillNum, skillQualLimim = WeightList} ->
			case SkillNum > 0 of
				?TRUE ->
					CharacterList = [{Pos, common:getRandomValueFromWeightList_1(WeightList, 1)} || Pos <- lists:seq(1, SkillNum)],
					rand_eq_skill(CharacterList);
				_ -> []
			end;
		_ ->
			?LOG_ERROR("cfg_petEquipNew, error_id:~p", [EqCfgId]),
			[]
	end.
%% 随机技能，组不能相同
rand_eq_skill(C) -> rand_eq_skill(C, [], []).
rand_eq_skill([], _, Ret) -> Ret;
rand_eq_skill([{Pos, Character} | CharacterList], HasGroup, Ret) ->
	WeightFun = fun({CfgChar, Order}, Acc) ->
		case CfgChar == Character of
			?TRUE ->
				case cfg_petEquipSkill:getRow(CfgChar, Order) of
					#petEquipSkillCfg{weight = Wight, skill = {_, SkillId, _}, weightGroup = Group} ->
						[{Wight, {Group, SkillId, Order}} | Acc];
					_ ->
						?LOG_ERROR("cfg_petEquipSkill, error_key:~p-~p", [CfgChar, Order]),
						Acc
				end;
			_ -> Acc
		end end,
	WeightList = lists:foldl(WeightFun, [], cfg_petEquipSkill:getKeyList()),
	FilterGroupList = [{Wight, {Group, SkillId, Order}} || {Wight, {Group, SkillId, Order}} <- WeightList, not lists:member(Group, HasGroup)],
	{RandGroup, RetSkillId, RetOrder} = common:getRandomValueFromWeightList(FilterGroupList, {0, 1}),
	rand_eq_skill(CharacterList, [RandGroup | HasGroup], [{Pos, RetSkillId, Character, RetOrder} | Ret]).

%% 检查装备孔位开启
check_eq_pos_open(Star, Pos) ->
	case cfg_petEqpOpenNew:getRow(Pos) of
		#petEqpOpenNewCfg{needStar = NeedStar} ->
			Star >= NeedStar;
		_ ->
			?FALSE
	end.

%% 装备技能重置
eq_skill_reset(EqUid) ->
	EqList = get_eq_list(),
	OldEq = lists:keyfind(EqUid, #pet_eq.uid, EqList),
	?CHECK_THROW(OldEq =/= ?FALSE, ?ErrorCode_PetEqAndStar_NoEq),
	EqCfgId = OldEq#pet_eq.cfg_id,
	ResetSKillList = case cfg_petEquipNew:getRow(EqCfgId) of
						 #petEquipNewCfg{skillNum = SkillNum, skillQualLimim = WeightList, needItem = NeedItem} ->
							 case SkillNum > 0 of
								 ?TRUE ->
									 CharacterList = [{Pos, common:getRandomValueFromWeightList_1(WeightList, 1)} || Pos <- lists:seq(1, SkillNum)],
									 CostErr = player:delete_cost(NeedItem, ?Reason_PetEqAndStar_EqSkillReset),
									 ?ERROR_CHECK_THROW(CostErr),
									 rand_eq_skill(CharacterList);
								 _ -> throw(?ErrorCode_PetEqAndStar_CannotReset)
							 end;
						 _ -> throw(?ERROR_Cfg)
					 end,
	NewResetTime = OldEq#pet_eq.reset_time + 1,
	NewEq = OldEq#pet_eq{reset_skill_list = ResetSKillList, reset_time = NewResetTime},
	update_eq(NewEq),
	log_op(4, NewEq).
%% 装备技能保存
eq_skill_save(EqUid) ->
	EqList = get_eq_list(),
	OldEq = lists:keyfind(EqUid, #pet_eq.uid, EqList),
	?CHECK_THROW(OldEq =/= ?FALSE, ?ErrorCode_PetEqAndStar_NoEq),
	ResetSKillList = OldEq#pet_eq.reset_skill_list,
	?CHECK_THROW(ResetSKillList =/= [], ?ErrorCode_PetEqAndStar_NoEqResetSKillList),
	NewEq = OldEq#pet_eq{skill_list = ResetSKillList, reset_skill_list = []},
	update_eq(NewEq),
	%% 是否需要计算属性 todo+++++++++++++++++++++++++++++++++++++=
	pet_battle:calc_player_add_fight(),
	pet_base:save_pet_sys_attr(),
	F = fun(#pet_pos{uid = Uid, ring_eq_list = EqList_}) ->
		case lists:keymember(EqUid, 2, EqList_) of
			?TRUE ->
				Uid > 0 andalso pet_base:refresh_pet_and_skill([Uid]),
				Uid > 0 andalso pet_battle:send_pet_attr(player:getPlayerID(), Uid),
				?TRUE;
			_ -> ?FALSE
		end
		end,
	util:break_when_true(F, pet_pos:get_pet_pos_list()),
	log_op(4, NewEq).

update_eq(NewEq) ->
	table_player:insert(db_pet_eq, eq_to_db(NewEq, player:getPlayerID())),
	NewEqList = lists:keystore(NewEq#pet_eq.uid, #pet_eq.uid, get_eq_list(), NewEq),
	set_eq_list(NewEqList),
	Msg = #pk_GS2U_pet_eq_sync{eq_list = [make_eq_msg(NewEq)]},
	player:send(Msg).

%% 获取宠物装备增加的资质 %% [{10003,50},{10001,50},{10005,50},{10004,50}]
get_eq_quality(PlayerId, EqList) ->
	case player:getPlayerID() == PlayerId of
		?TRUE -> get_eq_quality_logic(EqList);
		_ -> get_eq_quality_logic(PlayerId, EqList)
	end.
get_eq_quality_logic(EqList) ->
	Fun = fun({_, Uid}, Ret) when Uid > 0 ->
		case lists:keyfind(Uid, #pet_eq.uid, get_eq_list()) of
			#pet_eq{cfg_id = CfgId} ->
				case cfg_petEquipNew:getRow(CfgId) of
					#petEquipNewCfg{quali = QualityList} ->
						common:listValueMerge(Ret ++ QualityList);
					_ ->
						?LOG_ERROR("cfg_petEquipNew, error_key:~p", [CfgId]),
						Ret
				end;
			_ -> Ret
		end;
		(_, Ret) -> Ret
		  end,
	lists:foldl(Fun, [], EqList).
get_eq_quality_logic(PlayerId, EqList) ->
	Fun = fun({_, Uid}, Ret) when Uid > 0 ->
		case table_player:lookup(db_pet_eq, PlayerId, [Uid]) of
			[#db_pet_eq{cfg_id = CfgId} | _] ->
				case cfg_petEquipNew:getRow(CfgId) of
					#petEquipNewCfg{quali = QualityList} ->
						common:listValueMerge(Ret ++ QualityList);
					_ ->
						?LOG_ERROR("cfg_petEquipNew, error_key:~p", [CfgId]),
						Ret
				end;
			_ -> Ret
		end;
		(_, Ret) -> Ret
		  end,
	lists:foldl(Fun, [], EqList).
%% 获取宠物星级增加的资质 目前貌似不用

%% 升星公告判断
add_star_push(PlayerId, PetCfgId, Star) ->
	case cfg_petStar:getRow(PetCfgId, Star) of
		#petStarCfg{gonggao = 0} -> skip;
		_ ->
			PlayerName = richText:getPlayerTextByID(PlayerId),
			marquee:sendChannelNotice(0, 0, noticeText12,
				fun(Language) ->
					{ColorText, _GradeName} = richText:getPetText(PetCfgId, Language),
					language:format(language:get_server_string("NoticeText12", Language),
						[PlayerName, ColorText, Star])
				end)
	end.

%% 宠物照看时被消耗掉
check_looking_pet_cost(DeletePetUidList) ->
	Fun = fun(Uid) ->
		case pet_new:get_pet(Uid) of
			#pet_new{pet_cfg_id = PetCfgId, hatch_id = HatchId} when HatchId > 0 ->
				pet_hatch:looking_pet_cost(PetCfgId, HatchId);
			_ -> skip
		end
		  end,
	lists:foreach(Fun, DeletePetUidList).


%% 日志 op:1-进化 2-快速进化 3-穿戴宠物装备 4-卸下宠物装备 5-装备技能重置(保存) 6- 英雄晋升
log_op(Op, Args) ->
	table_log:insert_row(log_pet_eq_and_star_op, [player:getPlayerID(),
		Op,
		gamedbProc:term_to_dbstring(Args),
		time:time()
	]).

pet_back(Uid) -> pet_base:do_return_material(Uid).

%% 获取装备品质
get_eq_character(EqUid) ->
	case lists:keyfind(EqUid, #pet_eq.uid, get_eq_list()) of
		#pet_eq{cfg_id = EqCfg} ->
			case df:getItemDefineCfg(EqCfg) of
				#itemCfg{character = C} -> C;
				_ -> 0
			end;
		_ -> 0
	end.

%% 检查装备为空
check_eq_empty(EqList) ->
	length([EqUid || {_Pos, EqUid} <- EqList, EqUid =/= 0]) =:= 0.

check_activity_pet_star_cond(NewPetStar, IsBackward) ->
	List = [
		{5, ?SalesActivity_TotalPetGetStar5, ?SalesActivity_PetGetStar5},
		{6, ?SalesActivity_TotalPetGetStar6, ?SalesActivity_PetGetStar6},
		{7, ?SalesActivity_TotalPetGetStar7, ?SalesActivity_PetGetStar7},
		{8, ?SalesActivity_TotalPetGetStar8, ?SalesActivity_PetGetStar8},
		{9, ?SalesActivity_TotalPetGetStar9, ?SalesActivity_PetGetStar9},
		{10, ?SalesActivity_TotalPetGetStar10, ?SalesActivity_PetGetStar10},
		{11, ?SalesActivity_TotalPetGetStar11, ?SalesActivity_PetGetStar11},
		{12, ?SalesActivity_TotalPetGetStar12, ?SalesActivity_PetGetStar12}
	],

	case IsBackward of
		?TRUE ->
			[begin
				 activity_new_player:check_activity_cond_param_record(TotalCondID, 1),
				 activity_new_player:on_active_condition_change(CondID, 1)
			 end || {Star, TotalCondID, CondID} <- List, Star =< NewPetStar];
		?FALSE ->
			case lists:keyfind(NewPetStar, 1, List) of
				?FALSE -> ok;
				{_, TotalCondID, CondID} ->
					activity_new_player:check_activity_cond_param_record(TotalCondID, 1),
					activity_new_player:on_active_condition_change(CondID, 1)
			end

	end.

check_activity_pet_eq_cond() ->
	Num = length(bag_player:get_bag_item_list(?BAG_PET_EQ_EQUIP)),
	activity_new_player:on_active_condition_change(?SalesActivity_PetEqNum, Num),
	time_limit_gift:check_open(?TimeLimitType_PetEqWearNum, Num),
	ok.

get_star_pos_qual(StarPos, CfgId) ->
	Ret = lists:foldl(fun({Pos, Star}, Acc) ->
		#petStarCfg{qualiIncrease2 = QualAddPercent2} = cfg_petStar:getRow(CfgId, Star + 1),
		case lists:keyfind(Pos, 1, QualAddPercent2) of
			{Pos, Type, Value} -> [{Type, Value} | Acc];
			_ -> Acc
		end end, [], StarPos),
	common:listValueMerge(Ret).

get_buff_list() ->
	PetList = pet_new:get_pet_list(),
	F = fun(PetUid, Ret) ->
		case lists:keyfind(PetUid, #pet_new.uid, PetList) of
			#pet_new{pet_cfg_id = CfgId, star = Star, link_uid = 0, sp_lv = SpLv} ->
				calc_sp_pet_buff(CfgId, Star, SpLv) ++ Ret;
			#pet_new{pet_cfg_id = CfgId, link_uid = LinkUid, sp_lv = SpLv} ->
				case lists:keyfind(LinkUid, #pet_new.uid, PetList) of
					#pet_new{star = Star} ->
						calc_sp_pet_buff(CfgId, Star, SpLv) ++ Ret;
					_ -> Ret
				end;
			_ -> Ret
		end
		end,
	lists:foldl(F, [], pet_pos:get_fight_uid_list_with_passive_pet()).

calc_sp_pet_buff(CfgId, Star, SpLv) ->
	case cfg_petStar2:getRow(CfgId, SpLv) of
		#petStar2Cfg{buff = BuffList} ->
			%% (激活条件1,激活参数1,修正类型1,修正参数,修正ID)
			lists:foldl(fun({T, P, CorrType, Param, CorrID}, Ret) ->
				case T of
					0 -> [{CorrType, Param, CorrID} | Ret];
					1 -> common:getTernaryValue(Star >= P, [{CorrType, Param, CorrID} | Ret], Ret)
				end;
				(_, Ret) ->
					?LOG_ERROR("cfg_petStar2, err ~p", [{CfgId, Star, SpLv}]),
					Ret
						end, [], BuffList);
		_ -> []
	end.

%%检查哪些列表中哪些英雄处于上阵助战状态 是这种状态的就下阵
check_pet_fight(CostPetUidList) ->
	lists:foreach(fun(PetUid) ->
		case pet_new:get_pet(PetUid) of
			#pet_new{fight_flag = 2, fight_pos = FightPos} ->%%已助战
				pet_pos:on_set_pet_fight(2, FightPos, PetUid);%%助战下阵
			#pet_new{fight_flag = 0} -> ok;
			_ -> ok
		end end, CostPetUidList).

get_pet_equal_five(#pet_new{pet_cfg_id = CfgID, star = Star}) ->
	case cfg_petStar:getRow(CfgID, Star) of
		{} -> throw(?ERROR_Cfg);
		#petStarCfg{equalFive = EqualFive} -> EqualFive
	end.
get_pet_star_return(Element) ->
	#petStarReturnCfg{petID = PetID} =
		case cfg_petStarReturn:getRow(Element) of
			{} ->
				?LOG_ERROR("err cfg_petStarReturn ~p", [Element]),
				cfg_petStarReturn:first_row();
			Row -> Row
		end,
	PetID.

quick_nine_compare_type1(Type1List, NeedType1List) ->
	lists:foldl(fun({CfgID, Num}, Ret) ->
		case lists:keyfind(CfgID, 1, Ret) of
			{_, FindNum} when FindNum =:= Num -> lists:keydelete(CfgID, 1, Ret);
			{_, FindNum} when FindNum > Num -> lists:keystore(CfgID, 1, Ret, {CfgID, FindNum - Num});
			_ -> throw(?ErrorCode_PetEqAndStar_CostBad)
		end
				end, common:listValueMerge(Type1List), common:listValueMerge(NeedType1List)).

quick_nine_compare_type2(Type2List, NeedType2List, TransType1List) ->
	lists:foldl(fun({Ele, Num}, {Ret1, Ret2}) ->
		case lists:keyfind(Ele, 1, Ret1) of
			{_, FindNum} when FindNum =:= Num -> {lists:keydelete(Ele, 1, Ret1), Ret2};
			{_, FindNum} when FindNum > Num -> {lists:keystore(Ele, 1, Ret1, {Ele, FindNum - Num}), Ret2};
			Res ->
				DecNum = case Res of
							 {_, N} -> Num - N;
							 ?FALSE -> Num
						 end,
				Type2TransList = [{pet_draw:get_pet_element(P1), P1, P2} || {P1, P2} <- Ret2],
				case lists:keyfind(Ele, 1, Type2TransList) of
					{_, CfgID, FindNumTrans} when FindNumTrans =:= DecNum ->
						{lists:keydelete(Ele, 1, Ret1), lists:keydelete(CfgID, 1, Ret2)};
					{_, CfgID, FindNumTrans} when FindNumTrans > DecNum ->
						{lists:keydelete(Ele, 1, Ret1), lists:keystore(CfgID, 1, Ret2, {CfgID, FindNumTrans - DecNum})};
					_ -> throw(?ErrorCode_PetEqAndStar_CostBad)
				end
		end
				end, {common:listValueMerge(Type2List), common:listValueMerge(TransType1List)}, common:listValueMerge(NeedType2List)).

quick_nine_compare_type3(TargetElement, Type3Num, NeedType3Num, RemainType1List, RemainType2List, TempType3Type2) when Type3Num >= NeedType3Num ->
	LeftType3Num = Type3Num - NeedType3Num,
	{RemainType1List, RemainType2List ++ TempType3Type2 ++ [{TargetElement, LeftType3Num * 5} || LeftType3Num > 0]};
quick_nine_compare_type3(TargetElement, Type3Num, NeedType3Num, RemainType1List, RemainType2List, TempType3Type2List) ->
	DiffType3Num1 = NeedType3Num - Type3Num,
	{TempType3Type2ListOther, TempType3Type2ListSelf} = lists:partition(fun({E, _, _}) ->
		E =/= TargetElement end, lists:sort([{E, N div 5, N rem 5} || {E, N} <- common:listValueMerge(TempType3Type2List)])),
	{DiffType3Num2, TempType3Type2List1} = quick_nine_compare_type3_1(DiffType3Num1, TempType3Type2ListOther ++ TempType3Type2ListSelf, []),
	case DiffType3Num2 =< 0 of
		?TRUE -> {RemainType1List, RemainType2List ++ [{E, N1 * 5 + N2} || {E, N1, N2} <- TempType3Type2List1]};
		?FALSE ->
			NeedFill1 = DiffType3Num2 * 5,
			{NeedFill2, RemainType2List1} = quick_nine_compare_type3_1(NeedFill1, [{E, N, 0} || {E, N} <- RemainType2List], []),
			case NeedFill2 =< 0 of
				?TRUE ->
					{RemainType1List, [{E, N1} || {E, N1, _} <- RemainType2List1] ++ [{E, N1 * 5 + N2} || {E, N1, N2} <- TempType3Type2List1]};
				?FALSE ->
					{NeedFill3, RemainType1List1} = quick_nine_compare_type3_1(NeedFill2, [{CfgID, Num, 0} || {CfgID, Num} <- RemainType1List], []),
					?CHECK_THROW(NeedFill3 =:= 0, ?ErrorCode_PetEqAndStar_CostBad),
					{[{CfgID, N1} || {CfgID, N1, _} <- RemainType1List1], [{E, N1 * 5 + N2} || {E, N1, N2} <- TempType3Type2List1]}
			end

	end.
quick_nine_compare_type3_1(DiffType3Num, [], RemainRet) -> {DiffType3Num, RemainRet};
quick_nine_compare_type3_1(DiffType3Num, [{E, N1, N2} | T], RemainRet) when N1 >= DiffType3Num ->
	{0, [{E, N1 - DiffType3Num, N2} | T] ++ RemainRet};
quick_nine_compare_type3_1(DiffType3Num, [{E, N1, N2} | T], RemainRet) ->
	quick_nine_compare_type3_1(DiffType3Num - N1, T, [{E, 0, N2} | RemainRet]).