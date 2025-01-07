%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%   TODO 升星、觉醒提升技能的等级后需要刷新到地图里面去
%%% @end
%%% Created : 29. 六月 2018 10:22
%%%-------------------------------------------------------------------
-module(pet).
-author("cbfan").

-include("netmsgRecords.hrl").

-include("cfg_item.hrl").
-include("cfg_petBase.hrl").
-include("cfg_petStar.hrl").
-include("cfg_petLevel.hrl").
-include("cfg_petExpItem.hrl").
-include("cfg_petBreak.hrl").
-include("cfg_petAwaken.hrl").
-include("cfg_petSublimate.hrl").
-include("cfg_petJiBan2.hrl").
-include("cfg_petSoulLv.hrl").
-include("cfg_petSkillOpen.hrl").
-include("cfg_petPill.hrl").
-include("cfg_petPillAttr.hrl").
-include("cfg_petEqpOpen.hrl").
-include("cfg_petEquip.hrl").
-include("cfg_petEqpStr.hrl").
-include("cfg_petEqpStrBre.hrl").
-include("record.hrl").
-include("logger.hrl").
-include("item.hrl").
-include("error.hrl").
-include("db_table.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("attribute.hrl").
-include("skill_new.hrl").
-include("attainment.hrl").
-include("seven_gift_define.hrl").
-include("player_task_define.hrl").
-include("time_limit_gift_define.hrl").
-include("cfg_equipScoreIndex.hrl").
-include("activity_new.hrl").
-include("cfg_petReincarnation.hrl").
-include("cfg_petGradeUp.hrl").
-include("player_private_list.hrl").
-include("cfg_petGo.hrl").
-include("cfg_petSoulExpItem.hrl").
-include("prophecy.hrl").
-include("cfg_petUniversalBit.hrl").
-include("cfg_slayUpg.hrl").

-define(STATUS_FREE, 0).
-define(STATUS_FIGHT, 1).
-define(STATUS_ASSIST, 2).

%% API
-export([gm_add_pet/1, on_item_use_add/2, gm_set_ml_level/2, gm_add_pet_lv/2, gm_add_pet_star/2, gm_add_pet_awaken/2]).
-export([on_load/0, send_all_info/0]).
-export([on_item_eq_add/1, on_item_eq_delete/1]).
-export([on_pet_add_star/2, on_pet_add_lv/2, on_pet_break/1, on_pet_awaken/2, on_pet_awaken_potential/1, on_pet_rein/1, on_pet_add_grade/1, on_auto_level_up/1]).
-export([on_fetter_active/2, on_moling_pill/3, on_moling_add_lv/2, on_moling_auto_add_lv/1]).
-export([on_skill_put_on/4, on_skill_put_off/2, on_eq_put_on/2, on_onekey_equip_on/1]).
-export([on_eq_add_level/3, on_eq_break/3, on_pet_equip/2]).
-export([on_pet_out_change/3, on_pet_out/2, get_all_petout_id/0]).
-export([get_prop/1, dec_cost_when_add_star/4]).
-export([get_param_for_attainment/2]).
-export([
	get_count_lv/1, get_count_sublimate/1, get_count_awaken/1, get_moling_lv/0, get_count/0, get_grade/1,
	get_eq_count/0, get_count_eq_chara/1, get_count_eq_chara_all/1, get_count_eq_int/1, get_star_count_rare/1,
	get_petID_list/0, on_get_pet_list/0, get_pet_star_count/1
]).
-export([on_function_open/1, on_open_skill_box/2]).
-export([is_pet_active/1, get_equip_pet/0]).
-export([get_moling_skill_list/1, get_available_pet_skill_list/0, get_available_pet_skill_list/1, get_available_pet_skill_list_by_pet/1]).
-export([get_ml_eq/1, add_eq_ins/1]).
-export([pet_lv_star_card/1, get_star/1, get_attr/2, get_prop_common/0, get_mirror_star/2, get_mirror_attr/3]).
-export([list_2_moling/1, moling_2_list/1]).
-export([on_ultimate_lv_up/1]).
-export([check_all_pet_rein/0, auto_open_skill_box/1]).
-export([set_fight_flag/2, get_out_fight_pets/1, get_out_fight_pet_id_list/1, make_map_pets/1, to_pk_map_pet/1]).

gm_add_pet(PetId) ->
	case cfg_petBase:getRow(PetId) of
		#petBaseCfg{} ->
			case get_pet(PetId) of
				#pet{} ->
					BaseCfg = cfg_petBase:getRow(PetId),
					case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
					StarCfg = cfg_petStar:getRow(PetId, BaseCfg#petBaseCfg.starIniti),
					case StarCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
					bag_player:add(StarCfg#petStarCfg.needItem, ?REASON_pet_add_repeat);
				_ ->
					BaseCfg = cfg_petBase:getRow(PetId),
					case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
					Pet = #pet{
						pet_id = PetId,
						grade = BaseCfg#petBaseCfg.rareType
					},
					update_pet(Pet)
			end;
		_ -> ok
	end.

gm_set_ml_level(RoleIndex, Lv) ->
	OrderRoleList = role_data:get_order_role_list(),
	{_, Role} = lists:keyfind(RoleIndex, 1, OrderRoleList),
	case get_moling(Role#role.role_id) of
		#moling{} = M ->
			update_moling(M#moling{lv = Lv}, ?TRUE);
		_ -> ok
	end.

gm_add_pet_lv(PetId, Lv) ->
	case get_pet(PetId) of
		#pet{} = Pet ->
			CfgList = cfg_petBreak:rows(),
			IdList = [Cfg#petBreakCfg.iD || Cfg <- CfgList, Cfg#petBreakCfg.maxLv >= Lv],
			BreakLv =
				case IdList of
					[] -> lists:max(cfg_petBreak:getKeyList());
					_ -> lists:min(IdList)
				end,
			NewPet = Pet#pet{
				pet_lv = Lv,
				break_lv = BreakLv
			},
			update_pet(NewPet);
		_ -> ok
	end.

gm_add_pet_star(PetId, Lv) ->
	case get_pet(PetId) of
		#pet{} = Pet ->
			NewPet = Pet#pet{
				star = Lv
			},
			update_pet(NewPet);
		_ -> ok
	end.

gm_add_pet_awaken(PetId, Lv) ->
	case get_pet(PetId) of
		#pet{} = Pet ->
			NewPet = Pet#pet{
				awaken_lv = Lv
			},
			update_pet(NewPet);
		_ -> ok
	end.

on_item_use_add(_, 0) -> skip;
on_item_use_add(PetId, N) -> ?metrics(begin
										  case cfg_petBase:getRow(PetId) of
											  #petBaseCfg{} = BaseCfg ->
												  case get_pet(PetId) of
													  #pet{} ->
														  StarCfg = cfg_petStar:getRow(PetId, 0),
														  case StarCfg =:= {} of ?FALSE -> skip; _ ->
															  throw(?ERROR_Cfg) end,
														  ItemList = [{I, C * N} || {I, C} <- StarCfg#petStarCfg.needItem],
														  bag_player:add(ItemList, ?REASON_pet_add_repeat),
														  player_item:show_duplicate(3, PetId, [], ItemList);
													  _ ->
														  add_pet_1(PetId, BaseCfg),
														  on_item_use_add(PetId, N - 1)
												  end;
											  _ -> ok
										  end end).

%% 加载
on_load() -> ?metrics(begin load() end).

%% 功能开放
on_function_open(RoleIDList) ->
	?metrics(begin
				 MolingList = get_moling(),
				 lists:foreach(
					 fun(RoleID) ->
						 case get_moling(MolingList, RoleID) of
							 {} ->
								 NewML = #moling{player_id = player:getPlayerID(), role_id = RoleID},
								 update_moling(NewML, ?TRUE),
								 auto_open_skill_box(RoleID);
							 _ -> ok
						 end
					 end, RoleIDList)
			 end).
%%	check_open_skill_box(RoleID, 1).

%% 上线同步
send_all_info() -> ?metrics(begin send_info() end).

on_item_eq_add(ItemList) -> ?metrics(begin
										 item_eq_add(ItemList) end).

on_item_eq_delete(Items) -> ?metrics(begin
										 Uids = [Uid || #item{id = Uid} <- Items],
										 table_player:delete(db_eq_addition, player:getPlayerID(), Uids),
										 NewEqList = lists:foldl(fun(Uid, Ret) ->
											 lists:keydelete(Uid, #eq_addition.eq_uid, Ret) end, get_moling_eq(), Uids),
										 set_moling_eq(NewEqList) end).


%% 升星   将宠物升级到0星表示激活
on_pet_add_star(PetId, UseSpec) -> ?metrics(begin
												try
													?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
													case get_pet(PetId) of
														#pet{} = Pet -> add_star(Pet, UseSpec);
														_ -> add_pet(PetId)
													end,
													constellation:refresh_skill(PetId),
													player_task:refresh_task(?Task_Goal_PetStar),
													player:send(#pk_GS2U_PetAddStarRet{pet_id = PetId, err_code = ?ERROR_OK})
												catch
													ErrCode ->
														player:send(#pk_GS2U_PetAddStarRet{pet_id = PetId, err_code = ErrCode})
												end end).


%% 升级
on_pet_add_lv(PetId, CostList) -> ?metrics(begin
											   try
												   ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
												   pet_add_lv(PetId, CostList)
											   catch
												   ErrCode ->
													   player:send(#pk_GS2U_PetAddLvRet{pet_id = PetId, err_code = ErrCode})
											   end end).


%% 突破
on_pet_break(PetId) -> ?metrics(begin
									try
										?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
										pet_break(PetId)
									catch
										ErrCode ->
											player:send(#pk_GS2U_PetAddBreakRet{pet_id = PetId, err_code = ErrCode})
									end end).


%% 觉醒   TODO  需要实时刷新装配的技能
on_pet_awaken(PetId, UseSpec) -> ?metrics(begin
											  try
												  case variable_world:get_value(?WorldVariant_Switch_PetAwaken) == 1 andalso guide:is_open_action(?OpenAction_PetAwaken) of
													  ?TRUE -> ok;
													  ?FALSE -> throw(?ERROR_FunctionClose)
												  end,
												  pet_awaken(PetId, UseSpec)
											  catch
												  ErrCode ->
													  player:send(#pk_GS2U_PetAddAwakenRet{pet_id = PetId, err_code = ErrCode})
											  end end).

%% 晋升
on_pet_add_grade(PetId) -> ?metrics(begin
										try
											case variable_world:get_value(?WorldVariant_Switch_PetGradeUp) == 1 andalso guide:is_open_action(?OpenAction_PetGradeUp) of
												?TRUE -> ok;
												?FALSE -> throw(?ERROR_FunctionClose)
											end,
											pet_grade(PetId)
										catch
											ErrCode ->
												player:send(#pk_GS2U_PetAddGradeRet{pet_id = PetId, err_code = ErrCode})
										end end).

%% 炼魂
on_pet_awaken_potential(PetId) -> ?metrics(begin
											   try
												   case variable_world:get_value(?WorldVariant_Switch_PetSublimate) == 1 andalso guide:is_open_action(?OpenAction_PetSublimate) of
													   ?TRUE -> ok;
													   ?FALSE -> throw(?ERROR_FunctionClose)
												   end,
												   pet_awaken_potential(PetId)
											   catch
												   ErrCode ->
													   player:send(#pk_GS2U_PetAddAwakenPotentialRet{pet_id = PetId, err_code = ErrCode})
											   end end).

%% 转生
on_pet_rein(PetId) -> ?metrics(begin pet_rein(PetId) end).

%% 羁绊激活
on_fetter_active(FetterId, Lv) -> ?metrics(begin
											   try
												   fetter_active(FetterId, Lv)
											   catch
												   ErrCode ->
													   player:send(#pk_GS2U_PetFetterActiveRet{err_code = ErrCode})
											   end end).

%% 嗑丹
on_moling_pill(RoleId, Index, Num) -> ?metrics(begin
												   try
													   moling_pill(RoleId, Index, Num)
												   catch
													   ErrCode ->
														   player:send(#pk_GS2U_MolingEatPillRet{role_id = RoleId, err_code = ErrCode})
												   end end).

%% 魔灵升级 添加魔灵技能格子
on_moling_add_lv(RoleId, CostList) -> ?metrics(begin
												   try
													   ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
													   moling_add_lv(RoleId, CostList)
												   catch
													   ErrCode ->
														   player:send(#pk_GS2U_MolingAddLvRet{role_id = RoleId, err_code = ErrCode})
												   end end).

on_moling_auto_add_lv(RoleId) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
					 case variable_world:get_value(?WorldVariant_Switch_Moling) == 1 andalso guide:is_open_action(?OpenAction_Moling) of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ERROR_FunctionClose)
					 end,
					 Moling = get_moling(RoleId),

					 #moling{lv = Lv, exp = Exp} = Moling,

					 LvCfg = cfg_petSoulLv:getRow(Lv),
					 ?CHECK_CFG(LvCfg),
					 #petSoulLvCfg{exp = AllNeedExp} = LvCfg,

					 CostList = calc_ml_cost_list(lists:reverse(cfg_petSoulExpItem:getKeyList()), AllNeedExp - Exp),

					 F = fun({ItemId, Num}, Ret) ->
						 ExpItemCfg = cfg_petSoulExpItem:getRow(ItemId),
						 case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
						 ExpItemCfg#petSoulExpItemCfg.exp * Num + Ret
						 end,
					 AddExp = lists:foldl(F, 0, CostList),

					 case CostList =:= [] orelse AddExp =:= 0 of
						 ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_addLv_NoCost)
					 end,

					 case bag_player:delete_prepare(CostList) of
						 {?ERROR_OK, P} ->
							 {NewLv, NewExp} = calc_moling_exp(Moling#moling.lv, Moling#moling.exp + AddExp),
							 bag_player:delete_finish(P, ?REASON_pet_soul_add_lv),
							 update_moling(Moling#moling{
								 lv = NewLv, exp = NewExp
							 }, ?TRUE),
							 if
								 NewLv > Moling#moling.lv ->
									 PlayerId = player:getPlayerID(),
									 player_push:pet_moling_add_lv(PlayerId, RoleId, Moling#moling.lv, NewLv);
								 true ->
									 skip
							 end,

							 %% 检查开启技能格子
							 %%			case NewLv =/= Moling#moling.lv of
							 %%				?TRUE ->
							 %%					check_open_skill_box(RoleId, 1);
							 %%				?FALSE ->
							 %%					ok
							 %%			end,

							 log_pet_op(0, 8, lists:concat([Moling#moling.lv, "(", Moling#moling.exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
						 {CostErr, _} -> throw(CostErr)
					 end,
					 player:send(#pk_GS2U_MolingAutoAddLvRet{role_id = RoleId, add_exp = AddExp, err_code = ?ERROR_OK}),
					 calc_moling_prop(Moling#moling.role_id),
					 put_prop(),
					 attainment:check_attainment(?Attainments_Type_PetSoulLv),
					 player_task:refresh_task(?Task_Goal_MolingLv),
					 genius:check_genius_effect(?Genius_OpenType_MolingLv),
					 activity_new_player:on_active_condition_change(?SalesActivity_MLAddLv, 1),
					 ok
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_MolingAutoAddLvRet{role_id = RoleId, add_exp = 0, err_code = ErrCode})
				 end
			 end).

%% 开启技能格子
on_open_skill_box(RoleId, Pos) -> ?metrics(begin
											   try
												   ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
												   ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
												   case cfg_petSkillOpen:getRow(Pos) of
													   {} ->
														   throw(?ErrorCode_ML_BoxNotExist);
													   #petSkillOpenCfg{needWay = NeedWay} ->
														   Err = check_open_skill_box(RoleId, Pos, NeedWay),
														   ?ERROR_CHECK_THROW(Err);
													   _ ->
														   throw(?ErrorCode_ML_CannotOpenBox)
												   end,

												   player:send(#pk_GS2U_MolingSkillBoxOpenRet{role_id = RoleId, pos = Pos})
											   catch
												   ErrCode when is_integer(ErrCode) ->
													   ?LOG_ERROR("on_open_skill_box err:~p, RoleID ~p: Pos:~p~n", [ErrCode, RoleId, Pos]),
													   player:send(#pk_GS2U_MolingSkillBoxOpenRet{role_id = RoleId, err_code = ErrCode, pos = Pos});
												   Reason ->
													   ?LOG_ERROR("on_open_skill_box reason:~p, Pos:~p~n", [Reason, Pos])
											   end end).

%% 技能镶嵌
on_skill_put_on(RoleId, Pos, PetId, SkillId) -> ?metrics(begin
															 try
																 ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
																 skill_put_on(RoleId, Pos, PetId, SkillId)
															 catch
																 ErrCode ->
																	 player:send(#pk_GS2U_MolingSkillOpRet{role_id = RoleId, err_code = ErrCode, type = 0})
															 end end).
%% 技能镶嵌
on_skill_put_off(RoleId, Pos) -> ?metrics(begin
											  try
												  ?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
												  skill_put_off(RoleId, Pos)
											  catch
												  ErrCode ->
													  player:send(#pk_GS2U_MolingSkillOpRet{role_id = RoleId, err_code = ErrCode, type = 1})
											  end end).
%% 穿装备
on_eq_put_on(RoleId, EqUid) -> ?metrics(begin
											try
												?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
												?CHECK_THROW(is_func_open_pet_eq(), ?ERROR_FunctionClose),
												eq_put_on(RoleId, EqUid)
											catch
												ErrCode ->
													player:send(#pk_GS2U_MolingEqOpRet{role_id = RoleId, err_code = ErrCode, type = 0})
											end end).

%% 装备升级
on_eq_add_level(RoleId, Pos, EqUid) -> ?metrics(begin
													try
														?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
														eq_add_level(RoleId, Pos, EqUid)
													catch
														ErrCode ->
															player:send(#pk_GS2U_MolingEqAddLvRet{role_id = RoleId, err_code = ErrCode})
													end end).

%% 装备突破
on_eq_break(RoleId, Pos, EqUid) -> ?metrics(begin
												try
													?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
													eq_break(RoleId, Pos, EqUid)
												catch
													ErrCode ->
														player:send(#pk_GS2U_MolingEqBreakRet{role_id = RoleId, err_code = ErrCode})
												end end).

%% 一键穿戴
on_onekey_equip_on(RoleId) -> ?metrics(begin onekey_equip_on(RoleId) end).

%%-define(Attainments_Type_PetLv, 19).					%% 宠物等级[数量,宠物的等级]
%%-define(Attainments_Type_PetStar, 20).					%% 宠物星级[数量,宠物的星级]
%%-define(Attainments_Type_PetFeather, 21).				%% 宠物羽化[数量,宠物的羽化等级]
%%-define(Attainments_Type_PetSublimate, 22).				%% 宠物炼魂[数量,宠物的炼魂等级]
%%-define(Attainments_Type_PetPill, 23).					%% 宠物磕丹[数量,宠物的嗑丹类型（丹药道具ID）]
%%-define(Attainments_Type_PetSoulLv, 24).				%% 魔灵等级[魔灵的等级]
%%-define(Attainments_Type_PetCount, 25).					%% 宠物数量[数量]
get_param_for_attainment(?Attainments_Type_PetLv, Param) -> ?metrics(begin
																		 length([1 || #pet{pet_lv = P} <- get_pet_list(), P >= Param]) end);
get_param_for_attainment(?Attainments_Type_PetStar, Param) ->
	length([1 || #pet{star = Star} <- get_pet_list(), Star >= Param]);
get_param_for_attainment(?Attainments_Type_PetFeather, Param) ->
	length([1 || #pet{awaken_lv = P} <- get_pet_list(), P >= Param]);
get_param_for_attainment(?Attainments_Type_PetSublimate, Param) ->
	length([1 || #pet{awaken_potential = P} <- get_pet_list(), P >= Param]);
get_param_for_attainment(?Attainments_Type_PetPill, Param) ->
	% todo 3角色
	case get_moling() of
		#moling{pill1 = P1, pill2 = P2, pill3 = P3} ->
			case Param of
				1 -> P1;
				2 -> P2;
				3 -> P3;
				_ -> 0
			end;
		_ -> 0
	end;
get_param_for_attainment(?Attainments_Type_PetSoulLv, _Param) ->
	% todo 3角色
	case get_moling() of
		#moling{lv = Lv} -> Lv;
		_ -> 0
	end;
get_param_for_attainment(?Attainments_Type_PetCount, _Param) ->
	length(get_pet_list());
get_param_for_attainment(_, _Param) ->
	0.

get_count_lv(Level) -> ?metrics(begin
									length([1 || #pet{pet_lv = P} <- get_pet_list(), P >= Level]) end).
get_count_sublimate(Level) -> ?metrics(begin
										   length([1 || #pet{awaken_potential = P} <- get_pet_list(), P >= Level]) end).
get_count_awaken(Level) -> ?metrics(begin
										length([1 || #pet{awaken_lv = Lv} <- get_pet_list(), Lv >= Level]) end).
get_moling_lv() -> ?metrics(begin
% todo 3角色
								case get_moling() of
									#moling{lv = Lv} -> Lv;
									_ -> 0
								end end).
get_count() -> ?metrics(begin
							length(get_pet_list()) end).

get_grade(PetId) -> ?metrics(begin
								 case get_pet(PetId) of
									 #pet{grade = G} -> G;
									 {} -> 0
								 end end).

get_eq_count() -> ?metrics(begin
							   length(get_moling_eq()) end).

get_count_eq_chara(Chara) -> ?metrics(begin
										  Fun = fun(#item{cfg_id = ItemID}) ->
											  case cfg_petEquip:getRow(ItemID) of
												  {} ->
													  ?FALSE;
												  #petEquipCfg{quality = Quality} ->
													  Quality >= Chara
											  end
												end,
										  length([1 || Item <- bag_player:get_bag_item_list(?BAG_ML_EQ_EQUIP), Fun(Item)]) end).

get_count_eq_chara_all(Chara) -> ?metrics(begin
											  F = fun(#item{cfg_id = ItemID}) ->
												  case cfg_petEquip:getRow(ItemID) of
													  #petEquipCfg{quality = Q} -> Q >= Chara;
													  _ -> ?FALSE
												  end
												  end,
											  length([1 || Item <- bag_player:get_bag_item_list(?BAG_ML_EQ_EQUIP) ++ bag_player:get_bag_item_list(?BAG_ML_EQ), F(Item)]) end).

get_count_eq_int(Lv) -> ?metrics(begin
% todo 3角色
									 case get_moling() of
										 #moling{eqs = Eqs} ->
											 length([1 || {_, _, IntLv, _} <- Eqs, IntLv >= Lv]);
										 _ -> 0
									 end end).

get_star_count_rare(Rare) -> ?metrics(begin
										  lists:sum([S || #pet{pet_id = Id, star = S} <- get_pet_list(), Rare =:= 0 orelse (get_grade(Id) =:= Rare - 1)]) end).

is_pet_active(PetID) ->
	case lists:keyfind(PetID, #pet.pet_id, get_pet_list()) of
		#pet{} -> ?TRUE;
		_ -> ?FALSE
	end.

get_petID_list() -> ?metrics(begin
								 PetList = get_pet_list(),
								 [Pet#pet.pet_id || Pet <- PetList] end).

get_equip_pet() -> make_map_pets(player:getPlayerID()).
%%	?metrics(begin
%%								PetId = variable_player:get_value(?VARIABLE_PLAYER_PetId),
%%								PetShowId = variable_player:get_value(?VARIABLE_PLAYER_PetShowId),
%%								case lists:keyfind(PetId, #pet.pet_id, get_pet_list()) of
%%									#pet{star = Star, grade = Grade} ->
%%										case cfg_petGradeUp:getRow(PetId, Grade) of
%%											#petGradeUpCfg{upID = ShowPetId} -> {ShowPetId, Star};
%%											_ -> {PetShowId, Star}
%%										end;
%%									_ -> {PetShowId, 0}
%%								end end).

calc_prop() ->
	calc_pet_prop(),
	calc_fetter_prop(),
	calc_moling_prop(),
	put_prop(?TRUE).

%% 宠物
calc_pet_prop() ->
	lists:foreach(fun calc_pet_prop/1, get_pet_list()).
calc_pet_prop(Pet) ->
	%% 基础
	#petBaseCfg{attrBase = BaseAttr} = cfg_petBase:getRow(Pet#pet.pet_id),
	%% 转生
	ReinAttr =
		case Pet#pet.is_rein of
			0 -> [];
			_ ->
				#petReincarnationCfg{attrAdd = RAttr} = cfg_petReincarnation:getRow(Pet#pet.pet_id),
				RAttr
		end,
	%% 等级
	#petLevelCfg{attrAdd = LvAttr} = cfg_petLevel:getRow(Pet#pet.pet_lv),
	%% 突破
	#petBreakCfg{attribute = BreakAttr} = cfg_petBreak:getRow(Pet#pet.break_lv),
	%% 升星
	#petStarCfg{attrIncrease = StarPer, attrAdd = StarAttr} = cfg_petStar:getRow(Pet#pet.pet_id, Pet#pet.star),
	%% 觉醒
	#petAwakenCfg{attrAdd = AwakenAttr} = cfg_petAwaken:getRow(Pet#pet.pet_id, Pet#pet.awaken_lv),
	%% 晋升   todo 晋升获得属性尚未使用
	GradeCfg = cfg_petGradeUp:getRow(Pet#pet.pet_id, Pet#pet.grade),
	GradeAttr = case GradeCfg of {} -> [];_ -> GradeCfg#petGradeUpCfg.attrAdd end,
	%% 炼魂
	#petSublimateCfg{attrAdd = APAttr, attrAdd2 = _APAttr2, petUpBreak = UpBreakPer} = cfg_petSublimate:getRow(Pet#pet.awaken_potential),
	%% 必杀技
	#slayUpgCfg{attrAdd = UTAttr} = cfg_slayUpg:getRow(Pet#pet.pet_id, Pet#pet.ultimate_skill_lv),

	OtherProp = attribute:base_prop_from_list(AwakenAttr ++ APAttr ++ GradeAttr ++ StarAttr ++ ReinAttr ++ UTAttr) ++
		attribute:base_value_multi(attribute:base_prop_from_list(BreakAttr ++ LvAttr), UpBreakPer),
	BaseProp = [#prop{index = P, base = V, add = V * StarPer / 10000} || {P, V} <- BaseAttr],
	set_pet_prop(Pet#pet.pet_id, {common:listValueMerge(LvAttr ++ BaseAttr), attribute:prop_merge(OtherProp, BaseProp)}).

calc_fetter_prop() ->
	List = lists:foldl(fun({Index, Lv}, Ret) ->
		#petJiBan2Cfg{attrAdd = FetterAttr} = cfg_petJiBan2:getRow(Index, Lv),
		Ret ++ FetterAttr end, [], get_fetter_list()),
	set_fetter_prop(attribute:base_prop_from_list(common:listValueMerge(List))).

calc_moling_prop() ->
	[calc_moling_prop(M) || M <- get_moling()].
calc_moling_prop(RoleId) when is_integer(RoleId) ->
	calc_moling_prop(get_moling(RoleId));
calc_moling_prop(#moling{role_id = RoleId, skills = SkillList} = Moling) ->
	%% 魔灵装备
	{EqAttr, EqBasePart, EqIntPart, CommonProp1} = lists:foldl(fun({_, EqUid, IntensityLv, BreakLv}, {Ret1, Ret3, Ret4, Ret5}) ->
		{?ERROR_OK, [#item{cfg_id = CfgId}]} = bag_player:get_bag_item(?BAG_ML_EQ_EQUIP, EqUid),
		#eq_addition{rand_prop = RandProp} = lists:keyfind(EqUid, #eq_addition.eq_uid, get_moling_eq()),
		RandAttr = [{I, V} || {I, V, _C, _} <- RandProp],
		#petEquipCfg{attribute = Attr, type = Type, part = Part} = cfg_petEquip:getRow(CfgId),
		Attr1 = case cfg_petEqpStr:getRow(Type, IntensityLv) of
					#petEqpStrCfg{attribute = AttrIn} -> AttrIn;
					_ -> []
				end,
		Attr2 = case cfg_petEqpStrBre:getRow(Type, BreakLv) of
					#petEqpStrBreCfg{attribute = AttrB} -> AttrB;
					_ -> []
				end,
		{RandAttr_1, RandAttr_2} = attribute:partition_attribute(RandAttr),
		{Attr_1, Attr_2} = attribute:partition_attribute(Attr),
		{Attr1_1, Attr1_2} = attribute:partition_attribute(Attr1),
		{Attr2_1, Attr2_2} = attribute:partition_attribute(Attr2),
		{attribute:prop_merge(attribute:base_prop_from_list(common:listValueMerge(RandAttr_2 ++ Attr_2 ++ Attr1_2 ++ Attr2_2)), Ret1),
			[{Part, Attr_2 ++ RandAttr_2} | Ret3], [{Part, Attr1_2} | Ret4],
			attribute:prop_merge(attribute:base_prop_from_list(common:listValueMerge(RandAttr_1 ++ Attr_1 ++ Attr1_1 ++ Attr2_1)), Ret5)}
															   end, {[], [], [], []}, Moling#moling.eqs),

	%% 魔灵等级
	#petSoulLvCfg{attrAdd = MlBase} = cfg_petSoulLv:getRow(Moling#moling.lv),
	%% 技能格子
	Skill_attr = lists:foldl(fun({Pos, _, _}, Acc) ->
		case cfg_petSkillOpen:getRow(Pos) of
			{} ->
				[];
			#petSkillOpenCfg{attrAdd = Attr} ->
				Attr ++ Acc
		end
							 end, [], SkillList),
	{MlBase_1, MlBase_2} = attribute:partition_attribute(attribute:base_prop_from_list(common:listValueMerge(MlBase ++ Skill_attr))),

	CommonProp = attribute:prop_merge(CommonProp1 ++ MlBase_1, []),
	set_moling_prop(RoleId, {EqAttr, MlBase_2, EqBasePart, EqIntPart}),
	set_common_prop(RoleId, CommonProp).

put_prop() -> put_prop(?FALSE).
put_prop(IsOnline) ->
	{AL1, SL1, SSL1, SSSL1, OL1} = lists:foldl(fun(#pet{pet_id = PetID, grade = Grade}, {AL, SL, SSL, SSSL, OL}) ->
		case get_pet_prop(PetID) of
			?UNDEFINED -> {AL, SL, SSL, SSSL, OL};
			{W, O} ->
				case Grade of
					0 -> {common:listValueMerge(W ++ AL), SL, SSL, SSSL, attribute:prop_merge(O, OL)};
					1 -> {AL, common:listValueMerge(W ++ SL), SSL, SSSL, attribute:prop_merge(O, OL)};
					2 -> {AL, SL, common:listValueMerge(W ++ SSL), SSSL, attribute:prop_merge(O, OL)};
					3 -> {AL, SL, SSL, common:listValueMerge(W ++ SSSL), attribute:prop_merge(O, OL)};
					_ -> {AL, SL, SSL, SSSL, OL}
				end
		end end, {[], [], [], [], []}, get_pet_list()),

	FetterProp = get_fetter_prop(),
	put('pet_all_prop', {FetterProp, AL1, SL1, SSL1, SSSL1, OL1}),
	[attribute_player:on_prop_change() || not IsOnline].
get_prop_common() -> ?metrics(begin
								  case get('pet_all_prop') of
									  ?UNDEFINED -> {[], [], [], [], [], [], []};
									  {P1, P2, P3, P4, P5, P6} ->
										  MlCommon = lists:foldl(fun(ID, Ret) ->
											  get_common_prop(ID) ++ Ret end, [], role_data:get_all_role_id()),
										  {P1, P2, P3, P4, P5, P6, MlCommon}
								  end end).
get_prop(RoleId) -> ?metrics(begin
								 get_moling_prop(RoleId) end).

%% 宠物出战  0为出战   1为休战
on_pet_equip(T, PetId) -> ?metrics(begin
									   try
										   ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
										   Pet = get_pet(PetId),
										   ?CHECK_THROW(Pet =/= {}, ?ErrorCode_Pet_No),
										   PetOutList = get_petout_list(),
										   ?CHECK_THROW(lists:keyfind(PetId, 2, PetOutList) =/= ?FALSE, ?ErrorCode_Pet_Equip_Cant),
										   case T of
											   0 -> skill_player:set_choose_skill(2, PetId);
											   1 -> skill_player:set_choose_skill(2, 0)
										   end,
										   player_refresh:on_refresh_pet()
									   catch
										   Err -> player:send(#pk_GS2U_GenErrorNotify{errorCode = Err})
									   end end).

%% 宠物上阵
on_pet_out(Pos, PetID) -> ?metrics(begin
									   try
										   ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
										   case PetID of
											   0 -> pet_out_down(Pos);
											   _ -> pet_out_up(Pos, PetID)
										   end
									   catch
										   Err ->
											   case PetID of
												   0 -> player:send(#pk_GS2U_PetOutRet{op = 2, err_code = Err});
												   _ -> player:send(#pk_GS2U_PetOutRet{op = 1, err_code = Err})
											   end
									   end end).
%% 激活魔宠自动上阵
auto_pet_out(PetID) ->
	PetOutList = lists:keysort(1, get_petout_list()),
	case lists:keyfind(0, 2, PetOutList) of
		?FALSE -> skip;
		{Pos, 0} -> pet_out_up(Pos, PetID)
	end.

%% 宠物上阵孔位开启 Type：1 为等级要求，2为转职等级要求，3为Vip等级要求
on_pet_out_change(OldLv, NewLv, Type) when Type =:= 1 ->
	?metrics(begin
				 AllCfg = cfg_petGo:rows(),
				 F = fun(Cfg, NeedOpenList) ->
					 case Cfg#petGoCfg.needWay of
						 {Type, Lv, _} when Lv > OldLv andalso Lv =< NewLv ->
							 [Cfg#petGoCfg.iD | NeedOpenList];
						 _ -> NeedOpenList
					 end end,
				 NeedOpen = lists:foldl(F, [], AllCfg),
				 case NeedOpen =:= [] of
					 ?TRUE -> skip;
					 ?FALSE ->
						 PetOutList = player_private_list:get_value(?Private_List_index_petout),
						 NewPetOutList = [{NO, 0} || NO <- NeedOpen] ++ PetOutList,
						 player_private_list:set_value(?Private_List_index_petout, NewPetOutList),
						 set_petout_list(NewPetOutList),
						 player:send(#pk_GS2U_PetEquipList{pet_list = [#pk_key_value{key = K, value = V} || {K, V} <- NewPetOutList]})
				 end end);
on_pet_out_change(_, _, Type) ->
	?LOG_ERROR("Error Type:~p", [Type]).


%%  魔灵技 魔宠装配技17-21
get_pet_awaken_skill(PetId) ->
	#pet{awaken_lv = Awaken, grade = Grade} = get_pet(PetId),
	StarCfg = cfg_petAwaken:getRow(PetId, Awaken),
	case Grade of
		0 -> StarCfg#petAwakenCfg.skill;
		1 -> StarCfg#petAwakenCfg.skill1;
		2 -> StarCfg#petAwakenCfg.skill2;
		3 -> StarCfg#petAwakenCfg.skill3
	end.

%% 获取装配的魔灵技能
get_moling_skill(RoleId) ->
	Moling = case get_moling(RoleId) of #moling{} = M -> M; _ -> #moling{} end,
	GetIndexFun = fun
					  (1) -> ?SkillPos_17;
					  (2) -> ?SkillPos_18;
					  (3) -> ?SkillPos_19;
					  (4) -> ?SkillPos_20;
					  (5) -> ?SkillPos_21;
					  (6) -> ?SkillPos_476
				  end,
	Fun = fun({Pos, PetId, _}, Ret) ->
		case PetId > 0 of
			?TRUE ->
				{T, SkillId, _} = get_pet_awaken_skill(PetId),
				[{T, SkillId, GetIndexFun(Pos)} | Ret];
			_ -> Ret
		end
		  end,
	lists:foldl(Fun, [], Moling#moling.skills).

get_pet_skill(PetId) ->
	case get_pet(PetId) of
		#pet{star = Star, pet_lv = Lv, grade = Grade, ultimate_skill_lv = UltimateLv} ->
			StarCfg = cfg_petStar:getRow(PetId, Star),
			SkillStar = case Grade of
							0 -> [{P1, P2, P3, P4, P5} || {P1, P2, P3, P4, P5, _} <- StarCfg#petStarCfg.skill];
							1 -> StarCfg#petStarCfg.skill1;
							2 -> StarCfg#petStarCfg.skill2;
							3 -> StarCfg#petStarCfg.skill3
						end,
			StarSkillList = lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex}, Ret) ->
				case T of
					0 -> [{SkillType, SkillId, SkillIndex} | Ret];
					1 -> common:getTernaryValue(Lv >= P, [{SkillType, SkillId, SkillIndex} | Ret], Ret)
				end
										end, [], SkillStar),
			UltimateSkillStar =
				case cfg_slayUpg:getRow(PetId, UltimateLv) of
					{} ->
						[];
					#slayUpgCfg{} = UltimateCfg ->
						case Grade of
							0 -> UltimateCfg#slayUpgCfg.skill;
							1 -> UltimateCfg#slayUpgCfg.skill1;
							2 -> UltimateCfg#slayUpgCfg.skill2;
							3 -> UltimateCfg#slayUpgCfg.skill3
						end
				end,
			UltimateSkillList =
				case UltimateSkillStar of
					[] ->
						[];
					{T, P, SkillType, SkillId, SkillIndex} ->
						case T of
							0 -> [{SkillType, SkillId, SkillIndex}];
							1 -> common:getTernaryValue(Lv >= P, [{SkillType, SkillId, SkillIndex}], [])
						end
				end,
			StarSkillList ++ UltimateSkillList;
		_ -> []
	end.
get_pet_skill(PlayerId, PetId) when is_integer(PetId) ->
	DbPetList = table_player:lookup(db_pet, PlayerId, [PetId]),
	[Pet | _] = [db_pet2pet(DbPet) || DbPet <- DbPetList],
	get_pet_skill(PlayerId, Pet);
get_pet_skill(_PlayerId, Pet) ->
	case Pet of
		#pet{pet_id = PetId, star = Star, pet_lv = Lv, grade = Grade, ultimate_skill_lv = UltimateLv} ->
			StarCfg = cfg_petStar:getRow(PetId, Star),
			SkillStar = case Grade of
							0 -> [{P1, P2, P3, P4, P5} || {P1, P2, P3, P4, P5, _} <- StarCfg#petStarCfg.skill];
							1 -> StarCfg#petStarCfg.skill1;
							2 -> StarCfg#petStarCfg.skill2;
							3 -> StarCfg#petStarCfg.skill3
						end,
			StarSkillList = lists:foldl(fun({T, P, SkillType, SkillId, SkillIndex}, Ret) ->
				case T of
					0 -> [{SkillType, SkillId, SkillIndex} | Ret];
					1 -> common:getTernaryValue(Lv >= P, [{SkillType, SkillId, SkillIndex} | Ret], Ret)
				end end, [], SkillStar),
			UltimateSkillStar =
				case cfg_slayUpg:getRow(PetId, UltimateLv) of
					{} ->
						[];
					#slayUpgCfg{} = UltimateCfg ->
						case Grade of
							0 -> UltimateCfg#slayUpgCfg.skill;
							1 -> UltimateCfg#slayUpgCfg.skill1;
							2 -> UltimateCfg#slayUpgCfg.skill2;
							3 -> UltimateCfg#slayUpgCfg.skill3
						end
				end,
			UltimateSkillList =
				case UltimateSkillStar of
					[] ->
						[];
					{T, P, SkillType, SkillId, SkillIndex} ->
						case T of
							0 -> [{SkillType, SkillId, SkillIndex}];
							1 -> common:getTernaryValue(Lv >= P, [{SkillType, SkillId, SkillIndex}], [])
						end
				end,
			StarSkillList ++ UltimateSkillList;
		_ -> []
	end.

%% 13为魔宠增援技；14为魔宠普攻；
%% 15为魔宠技能1；16为魔宠技能2
%% 魔宠装配技17-21
refresh_skill() -> skill_player:on_skill_change().
refresh_skill(_RoleId) ->
	% todo 单角色刷新
	skill_player:on_skill_change().

%% 用于装配到玩家身上的魔灵技能
get_moling_skill_list(RoleId) -> ?metrics(begin
											  get_moling_skill(RoleId) end).

%% 用于宠物使用的可用主动技能
get_available_pet_skill_list() ->
	F = fun(PetId) ->
		SkillList = get_pet_skill(PetId),
		PlayerSkillList = skill_player:make_player_skill(SkillList),
		{PetId, skill_player:make_skill_fix_list(PlayerSkillList)}
		end,
	lists:map(F, get_out_fight_pet_id_list()).

get_available_pet_skill_list_by_pet(PetId) -> ?metrics(begin
														   SkillList = get_pet_skill(PetId),
														   PlayerSkillList = skill_player:make_player_skill(SkillList),
														   skill_player:make_skill_fix_list(PlayerSkillList) end).

get_available_pet_skill_list(PlayerId) ->
	F = fun(#pet{pet_id = PetId} = Pet) ->
		SkillList = get_pet_skill(PlayerId, Pet),
		PlayerSkillList = skill_player:make_player_skill(SkillList),
		{PetId, skill_player:make_skill_fix_list(PlayerSkillList)}
		end,
	lists:map(F, get_out_fight_pets(PlayerId)).

%% 使用宠物升级/升星卡
pet_lv_star_card(ItemCfg) -> ?metrics(begin
										  pet_lv_star_card_1(ItemCfg) end).

list_2_moling(List) -> ?metrics(begin
									Record = list_to_tuple([moling | List]),
									Record#moling{
										skills = gamedbProc:dbstring_to_term(Record#moling.skills),
										eqs = gamedbProc:dbstring_to_term(Record#moling.eqs)
									} end).

moling_2_list(Record) -> ?metrics(begin
									  tl(tuple_to_list(Record#moling{
										  skills = gamedbProc:term_to_dbstring(Record#moling.skills),
										  eqs = gamedbProc:term_to_dbstring(Record#moling.eqs)
									  })) end).

get_all_petout_id() -> ?metrics(begin
									[ID || {_, ID} <- lists:keysort(1, get_petout_list())] end).

on_ultimate_lv_up(PetID) -> ?metrics(begin
										 try
											 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
											 Pet = get_pet(PetID),
											 ?CHECK_THROW(Pet =/= {}, ?ErrorCode_Pet_No),
											 #pet{ultimate_skill_lv = Lv} = Pet,
											 Cfg = cfg_slayUpg:getRow(PetID, Lv),
											 ?CHECK_THROW(Cfg =/= {}, ?ERROR_Cfg),
											 #slayUpgCfg{maxLv = MaxLv} = Cfg,
											 ?CHECK_THROW(Lv < MaxLv, ?ErrorCode_Pet_MaxUltimateLv),
											 NewLv = Lv + 1,
											 NextLvCfg = cfg_slayUpg:getRow(PetID, NewLv),
											 ?CHECK_THROW(NextLvCfg =/= {}, ?ERROR_Cfg),
											 #slayUpgCfg{needItem = NeedItem} = NextLvCfg,
											 CostErr = player:delete_cost(NeedItem, [], ?REASON_pet_ultimate_lv_up),
											 ?ERROR_CHECK_THROW(CostErr),
											 NewPet = Pet#pet{ultimate_skill_lv = NewLv},
											 update_pet(NewPet),
											 refresh_skill(),
											 calc_pet_prop(NewPet),
											 put_prop(),
											 player:send(#pk_GS2U_PetUltimateLvUpRet{pet_id = PetID, err_code = ?ERROR_OK})
										 catch
											 ErrCode ->
												 player:send(#pk_GS2U_PetUltimateLvUpRet{pet_id = PetID, err_code = ErrCode})
										 end end).

check_all_pet_rein() ->
	PetList = get_pet_list(),
	lists:any(fun(Pet) ->
		ReinCfg = cfg_petReincarnation:getRow(Pet#pet.pet_id),
		case ReinCfg of
			{} -> ?FALSE;
			_ ->
				check_cond(Pet, ReinCfg#petReincarnationCfg.condition)
		end end, PetList).

on_auto_level_up(PetId) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 Pet = get_pet(PetId),
					 case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_No) end,

					 #pet{pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv} = Pet,
					 BreakCfg = cfg_petBreak:getRow(BreakLv),
					 ?CHECK_CFG(BreakCfg),
					 #petBreakCfg{maxLv = MaxLv} = BreakCfg,
					 %% 坐骑等级不能超过当前突破等级的等级上限
					 ?CHECK_THROW(Lv < MaxLv, ?ErrorCode_Pet_LvMax),
					 %% 坐骑等级不能超过当前玩家等级
					 ?CHECK_THROW(Lv < player:getLevel(), ?ErrorCode_Pet_LvMax),

					 LvCfg = cfg_petLevel:getRow(Lv),
					 ?CHECK_CFG(LvCfg),
					 #petLevelCfg{exp = AllNeedExp} = LvCfg,

					 CostList = calc_pet_cost_list(lists:reverse(cfg_petExpItem:getKeyList()), AllNeedExp - Exp),


					 F = fun({ItemId, Num}, Ret) ->
						 ExpItemCfg = cfg_petExpItem:getRow(ItemId),
						 case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
						 ExpItemCfg#petExpItemCfg.exp * Num + Ret
						 end,
					 AddExp = lists:foldl(F, 0, CostList),
					 case CostList =:= [] orelse AddExp =:= 0 of
						 ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_addLv_NoCost)
					 end,

					 case bag_player:delete_prepare(CostList) of
						 {?ERROR_OK, P} ->
							 BreakCfg = cfg_petBreak:getRow(Pet#pet.break_lv),
							 case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
							 {NewLv, NewExp} = calc_pet_exp(BreakCfg#petBreakCfg.maxLv, Pet#pet.pet_lv, Pet#pet.pet_exp + AddExp),
							 #petReincarnationCfg{levelMax = {OldMax, NewMax}} = cfg_petReincarnation:getRow(PetId),
							 case Pet#pet.is_rein of
								 0 -> case NewLv > OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_LvMax) end;
								 _ -> case NewLv > NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_LvMax) end
							 end,

							 case NewLv > player:getLevel() orelse NewLv > BreakCfg#petBreakCfg.maxLv of
								 ?FALSE -> skip;
								 _ -> throw(?ErrorCode_Pet_LvMax)
							 end,
							 bag_player:delete_finish(P, ?REASON_pet_add_lv),
							 NewPet = Pet#pet{
								 pet_lv = NewLv,
								 pet_exp = NewExp
							 },
							 update_pet(NewPet),
							 case NewLv > Pet#pet.pet_lv of
								 ?TRUE ->
									 calc_pet_prop(NewPet),
									 put_prop(),
									 [refresh_skill() || lists:member(PetId, get_out_fight_pet_id_list())],
									 attainment:check_attainment(?Attainments_Type_PetLv),
									 time_limit_gift:check_open(?TimeLimitType_PetLv),
									 seven_gift:check_task(?Seven_Type_PetLv);
%%									 player_task:refresh_task(?Task_Goal_PetLv);
								 _ -> skip
							 end,
							 activity_new_player:on_active_condition_change(?SalesActivity_PetAddLv, 1),
							 log_pet_op(PetId, 1, lists:concat([Pet#pet.pet_lv, "(", Pet#pet.pet_exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
						 {CostErr, _} -> throw(CostErr)
					 end,
					 player:send(#pk_GS2U_PetAutoAddLvRet{pet_id = PetId, err_code = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_PetAutoAddLvRet{pet_id = PetId, err_code = ErrCode})
				 end
			 end).

on_get_pet_list() ->
	get_pet_list().

get_pet_star_count(TaskStar) ->
	PetList = get_pet_list(),
	lists:foldl(fun(#pet{star = Star}, Acc) ->
		case Star >= TaskStar of
			?TRUE -> Acc + 1;
			_ -> Acc
		end end, 0, PetList).

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_pet_list() -> get('pet_list').
set_pet_list(List) -> put('pet_list', List).

get_moling() ->
	PlayerId = player:getPlayerID(),
	table_player:lookup(db_moling, PlayerId).
get_moling(RoleId) ->
	PlayerId = player:getPlayerID(),
	case table_player:lookup(db_moling, PlayerId, [RoleId]) of
		[#moling{} = M] -> M;
		_ -> {}
	end.
get_moling(MolingList, RoleId) ->
	case lists:keyfind(RoleId, #moling.role_id, MolingList) of
		?FALSE -> {};
		M -> M
	end.
set_moling(M) ->
	table_player:insert(db_moling, M).
%%	put('moling', M).

get_fetter_list() -> get('pet_fetter').
set_fetter_list(M) -> put('pet_fetter', M).

get_pet_prop(PetId) -> get({'pet_prop', PetId}).
set_pet_prop(PetId, P) -> put({'pet_prop', PetId}, P).

get_fetter_prop() -> get('pet_fetter_prop').
set_fetter_prop(M) -> put('pet_fetter_prop', M).

get_moling_prop(RoleId) ->
	case get({'moling_prop', RoleId}) of
		?UNDEFINED -> {[], [], [], []};
		Prop -> Prop
	end.
set_moling_prop(RoleId, M) ->
	put({'moling_prop', RoleId}, M).
get_common_prop(RoleId) ->
	case get({'moling_common_prop', RoleId}) of
		?UNDEFINED -> [];
		Prop -> Prop
	end.
set_common_prop(RoleId, M) ->
	put({'moling_common_prop', RoleId}, M).

get_moling_eq() -> get('moling_eq').
set_moling_eq(M) -> put('moling_eq', M).

get_petout_list() -> get('petout_list').
set_petout_list(PetOutList) -> put('petout_list', PetOutList).

load() ->
	PlayerId = player:getPlayerID(),
	%%	加载所有的宠物
	load_pet(PlayerId),
	%%  外显刷新
%%	show_pet_refresh(),
	%%	加载羁绊信息
	load_fetter(PlayerId),
	%% 加载魔宠装备
	load_moling_eq(PlayerId),
	%%  加载宠物上阵信息
	set_petout_list(player_private_list:get_value(?Private_List_index_petout)),
	calc_prop().

load_pet(PlayerId) ->
	DbPetList = table_player:lookup(db_pet, PlayerId),
	set_pet_list([db_pet2pet(DbPet) || DbPet <- DbPetList]).
load_moling_eq(PlayerId) ->
	DbEqList = lists:filter(fun(#db_eq_addition{eq_type = T}) ->
		T =:= 1 end, table_player:lookup(db_eq_addition, PlayerId)),
	set_moling_eq([#eq_addition{
		eq_uid = DbEq#db_eq_addition.eq_uid,
		cfg_id = DbEq#db_eq_addition.item_data_id,
		rand_prop = DbEq#db_eq_addition.rand_prop
	} || DbEq <- DbEqList]).
load_fetter(PlayerId) ->
	FetterList = table_player:lookup(db_pet_fetter, PlayerId),
	set_fetter_list([{FId, FLv} || #db_pet_fetter{fetter_id = FId, fetter_lv = FLv} <- FetterList]).

send_info() ->
	case get_pet_list() of
		[] -> skip;
		PL -> player:send(#pk_GS2U_PetUpdate{pets = [make_pet_msg(P) || P <- PL]})
	end,
	case get_moling() of
		[] -> skip;
		ML ->
			player:send(#pk_GS2U_MolingUpdate{ml = [make_ml_msg(M) || M <- ML]}),
			F1 = fun(M, Ret) ->
				[#pk_MolingSkill{role_id = M#moling.role_id, pos = P, pet_id = PI, skill_id = I} || {P, PI, I} <- M#moling.skills] ++ Ret
				 end,
			case lists:foldl(F1, [], ML) of
				[] -> ok;
				SkillMsg -> player:send(#pk_GS2U_MolingSkillUpdate{skills = SkillMsg})
			end,
			F2 = fun(M, Ret) ->
				[#pk_MolingEqPos{role_id = M#moling.role_id, pos = P, uid = U, lv = L, break_lv = B} || {P, U, L, B} <- M#moling.eqs] ++ Ret
				 end,
			case lists:foldl(F2, [], ML) of
				[] -> ok;
				EqMsg -> player:send(#pk_GS2U_MolingEqUpdate{eqs = EqMsg})
			end
	end,
	case get_fetter_list() of
		[] -> skip;
		FL -> player:send(#pk_GS2U_PetFetterUpdate{pfs = [#pk_PetFetter{f_id = I, f_lv = V} || {I, V} <- FL]})
	end,
	case player_private_list:get_value(?Private_List_index_petout) of
		[] ->  %%如果是初次开启上阵功能，则默认开启第一个孔位
			player_private_list:set_value(?Private_List_index_petout, [{1, 0}]),
			set_petout_list([{1, 0}]),
			player:send(#pk_GS2U_PetEquipList{pet_list = [#pk_key_value{key = 1, value = 0}]});
		PE -> player:send(#pk_GS2U_PetEquipList{pet_list = [#pk_key_value{key = K, value = V} || {K, V} <- PE]})
	end,
	case get_moling_eq() of
		[] -> skip;
		MEqs ->
			player:send(#pk_GS2U_MLEqUpdate{eqs = [#pk_EqAddition{
				eq_Uid = Eq#eq_addition.eq_uid,
				cfg_id = Eq#eq_addition.cfg_id,
				rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- Eq#eq_addition.rand_prop]
			} || Eq <- MEqs]})
	end.

pet_add_lv(PetId, CostList) ->
	Pet = get_pet(PetId),
	case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_No) end,
	F = fun({ItemId, Num}, Ret) ->
		ExpItemCfg = cfg_petExpItem:getRow(ItemId),
		case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		ExpItemCfg#petExpItemCfg.exp * Num + Ret
		end,
	AddExp = lists:foldl(F, 0, CostList),
	case CostList =:= [] orelse AddExp =:= 0 of
		?FALSE -> skip; _ -> throw(?ErrorCode_Pet_addLv_NoCost)
	end,

	case bag_player:delete_prepare(CostList) of
		{?ERROR_OK, P} ->
			BreakCfg = cfg_petBreak:getRow(Pet#pet.break_lv),
			case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
			{NewLv, NewExp} = calc_pet_exp(BreakCfg#petBreakCfg.maxLv, Pet#pet.pet_lv, Pet#pet.pet_exp + AddExp),
			#petReincarnationCfg{levelMax = {OldMax, NewMax}} = cfg_petReincarnation:getRow(PetId),
			case Pet#pet.is_rein of
				0 -> case NewLv > OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_LvMax) end;
				_ -> case NewLv > NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_LvMax) end
			end,

			case NewLv > player:getLevel() orelse NewLv > BreakCfg#petBreakCfg.maxLv of
				?FALSE -> skip;
				_ -> throw(?ErrorCode_Pet_LvMax)
			end,
			bag_player:delete_finish(P, ?REASON_pet_add_lv),
			NewPet = Pet#pet{
				pet_lv = NewLv,
				pet_exp = NewExp
			},
			update_pet(NewPet),
			case NewLv > Pet#pet.pet_lv of
				?TRUE ->
					calc_pet_prop(NewPet),
					put_prop(),
					[refresh_skill() || lists:member(PetId, get_out_fight_pet_id_list())],
					attainment:check_attainment(?Attainments_Type_PetLv),
					time_limit_gift:check_open(?TimeLimitType_PetLv),
					seven_gift:check_task(?Seven_Type_PetLv);
%%					player_task:refresh_task(?Task_Goal_PetLv);
				_ -> skip
			end,
			activity_new_player:on_active_condition_change(?SalesActivity_PetAddLv, 1),
			log_pet_op(PetId, 1, lists:concat([Pet#pet.pet_lv, "(", Pet#pet.pet_exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
		{CostErr, _} -> throw(CostErr)
	end,
	player:send(#pk_GS2U_PetAddLvRet{pet_id = PetId, err_code = ?ERROR_OK}).

get_pet(PetId) -> case lists:keyfind(PetId, #pet.pet_id, get_pet_list()) of #pet{} = P -> P; _ -> {} end.

get_star(PetId) ->
	case get_pet(PetId) of
		#pet{} = P ->
			P#pet.star;
		_ -> 0
	end.

get_mirror_star(PlayerID, PetId) ->
	PetList = table_player:lookup(db_pet, PlayerID),
	case lists:keyfind(PetId, #db_pet.pet_id, PetList) of #db_pet{star = S} -> S;_ -> 0 end.

get_attr(Type, PetId) ->
	Pet = get_pet(PetId),
	get_attr_(Type, Pet).

get_mirror_attr(PlayerID, Type, PetId) ->
	case table_player:lookup(db_pet, PlayerID, [PetId]) of
		[DB] -> get_attr_(Type, db_pet2pet(DB));
		_ -> []
	end.

get_attr_('active', Pet) ->
	%% 激活
	#petBaseCfg{attrBase = BaseAttr} = cfg_petBase:getRow(Pet#pet.pet_id),
	BaseAttr;
get_attr_('up_level', Pet) ->
	%% 升级
	#petLevelCfg{attrAdd = LvAttr} = cfg_petLevel:getRow(Pet#pet.pet_lv),
	LvAttr;
get_attr_('break', Pet) ->
	%% 突破
	#petBreakCfg{attribute = BreakAttr} = cfg_petBreak:getRow(Pet#pet.break_lv),
	BreakAttr;
get_attr_('up_star', Pet) ->
	%% 升星
	#petStarCfg{attrIncrease = _StarPer, attrAdd = StarAttr} = cfg_petStar:getRow(Pet#pet.pet_id, Pet#pet.star),
	StarAttr;
get_attr_('awaken', Pet) ->
	%% 觉醒
	#petAwakenCfg{attrAdd = AwakenAttr} = cfg_petAwaken:getRow(Pet#pet.pet_id, Pet#pet.awaken_lv),
	AwakenAttr;
get_attr_('sublimate', Pet) ->
	%% 炼魂
	#petSublimateCfg{attrAdd = APAttr, attrAdd2 = _APAttr2} = cfg_petSublimate:getRow(Pet#pet.awaken_potential),
	APAttr;
get_attr_('grade', Pet) ->
	Cfg = cfg_petGradeUp:getRow(Pet#pet.pet_id, Pet#pet.grade),
	case Cfg of #petGradeUpCfg{attrAdd = GradeAttr} -> GradeAttr; _ ->
		?LOG_ERROR("cfg_petGradeUp_error:~p-~p", [Pet#pet.pet_id, Pet#pet.grade]), [] end.

update_pet(Pet) ->
	table_player:insert(db_pet, pet2db_pet(Pet)),
	PetList = get_pet_list(),
	NewPetList = lists:keystore(Pet#pet.pet_id, #pet.pet_id, PetList, Pet),
	set_pet_list(NewPetList),
	player:send(#pk_GS2U_PetUpdate{pets = [make_pet_msg(Pet)]}).

update_moling(Moling, IsSync) ->
	table_player:insert(db_moling, Moling#moling{
		player_id = player:getPlayerID()
	}),
	set_moling(Moling),
	[player:send(#pk_GS2U_MolingUpdate{ml = [make_ml_msg(Moling)]}) || IsSync].

update_fetter(Fid, Flv) ->
	table_player:insert(db_pet_fetter, #db_pet_fetter{
		player_id = player:getPlayerID(),
		fetter_id = Fid,
		fetter_lv = Flv
	}),
	NewList = lists:keystore(Fid, 1, get_fetter_list(), {Fid, Flv}),
	set_fetter_list(NewList),
	player:send(#pk_GS2U_PetFetterUpdate{pfs = [#pk_PetFetter{f_lv = Flv, f_id = Fid}]}).

make_pet_msg(Pet) ->
	#pk_PetInfo{
		pet_id = Pet#pet.pet_id,
		pet_lv = Pet#pet.pet_lv,
		pet_exp = Pet#pet.pet_exp,
		break_lv = Pet#pet.break_lv,
		star = Pet#pet.star,
		grade = Pet#pet.grade,
		awaken_lv = Pet#pet.awaken_lv,
		awaken_potential = Pet#pet.awaken_potential,
		is_rein = Pet#pet.is_rein,
		ultimate_skill_lv = Pet#pet.ultimate_skill_lv
	}.

make_ml_msg(Ml) ->
	#pk_Moling{
		role_id = Ml#moling.role_id,
		lv = Ml#moling.lv,
		exp = Ml#moling.exp,
		pill1 = Ml#moling.pill1,
		pill2 = Ml#moling.pill2,
		pill3 = Ml#moling.pill3
	}.

is_show_changed(PetId, OldGrade) ->
	NewGrade = OldGrade + 1,
	case cfg_petGradeUp:getRow(PetId, NewGrade) of
		#petGradeUpCfg{upID = NewPetShowId} ->
			case cfg_petGradeUp:getRow(PetId, OldGrade) of
				#petGradeUpCfg{upID = OldPetShowId} ->
					OldPetShowId =/= NewPetShowId;
				_ -> ?TRUE
			end;
		_ -> ?FALSE
	end.

%%show_pet_refresh() ->
%%	PetId = variable_player:get_value(?VARIABLE_PLAYER_PetId),
%%	PetShowId = variable_player:get_value(?VARIABLE_PLAYER_PetShowId),
%%	Grade = get_grade(PetId),
%%	case cfg_petGradeUp:getRow(PetId, Grade) of
%%		#petGradeUpCfg{upID = NewPetShowId} when NewPetShowId =/= PetShowId ->
%%			variable_player:set_value(?VARIABLE_PLAYER_PetShowId, NewPetShowId),
%%			?TRUE;
%%		_ -> ?FALSE
%%	end.

set_fight_flag(PetId, Flag) ->
	Pet = get_pet(PetId),
	update_pet(Pet#pet{fight_flag = Flag}),
	ok.

get_out_fight_pet_id_list() ->
	get_out_fight_pet_id_list(player:getPlayerID()).
get_out_fight_pet_id_list(PlayerId) ->
	PetList = get_out_fight_pets(PlayerId),
	[Id || #pet{pet_id = Id} <- PetList].

make_map_pets(PlayerId) ->
	PetList = get_out_fight_pets(PlayerId),
	[#map_pet{pet_id = PetId, pet_star = PetStar, pet_grade = Grade} || #pet{pet_id = PetId, star = PetStar, grade = Grade} <- PetList].

get_out_fight_pets(PlayerId) ->
	PetList =
		case PlayerId == player:getPlayerID() of
			?TRUE ->
				get_pet_list();
			_ ->
				DbPetList = table_player:lookup(db_pet, PlayerId),
				[db_pet2pet(DbPet) || DbPet <- DbPetList]
		end,
	[Pet || #pet{fight_flag = Flag} = Pet <- PetList, Flag == ?STATUS_FIGHT].


db_pet2pet(#db_pet{} = DbPet) ->
	#pet{
		pet_id = DbPet#db_pet.pet_id,
		pet_lv = DbPet#db_pet.pet_lv,
		pet_exp = DbPet#db_pet.pet_exp,
		break_lv = DbPet#db_pet.break_lv,
		star = DbPet#db_pet.star,
		grade = DbPet#db_pet.grade,
		awaken_lv = DbPet#db_pet.awaken_lv,
		awaken_potential = DbPet#db_pet.awaken_potential,
		is_rein = DbPet#db_pet.is_rein,
		ultimate_skill_lv = DbPet#db_pet.ultimate_skill_lv,
		fight_flag = DbPet#db_pet.fight_flag,
		fight_pos = DbPet#db_pet.fight_pos,
		is_auto_skill = DbPet#db_pet.is_auto_skill
	}.

pet2db_pet(#pet{} = Pet) ->
	#db_pet{
		player_id = player:getPlayerID(),
		pet_id = Pet#pet.pet_id,
		pet_lv = Pet#pet.pet_lv,
		pet_exp = Pet#pet.pet_exp,
		break_lv = Pet#pet.break_lv,
		star = Pet#pet.star,
		grade = Pet#pet.grade,
		awaken_lv = Pet#pet.awaken_lv,
		awaken_potential = Pet#pet.awaken_potential,
		is_rein = Pet#pet.is_rein,
		ultimate_skill_lv = Pet#pet.ultimate_skill_lv,
		fight_flag = Pet#pet.fight_flag,
		fight_pos = Pet#pet.fight_pos,
		is_auto_skill = Pet#pet.is_auto_skill
	}.


add_star(#pet{star = Star, pet_id = PetId, is_rein = IsRein} = Pet, UseSpec) ->
	#petReincarnationCfg{starMax = {OldMax, NewMax}} = cfg_petReincarnation:getRow(PetId),
	case IsRein of
		0 -> case Star >= OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_StarMax) end;
		_ -> case Star >= NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_StarMax) end
	end,
	StarCfg = cfg_petStar:getRow(PetId, Star + 1),
	case StarCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	PetCfg = cfg_petBase:getRow(PetId),
	?CHECK_THROW(PetCfg =/= {}, ?ERROR_Cfg),
	Char = PetCfg#petBaseCfg.rareType,
	SpecialItemCfg = cfg_petUniversalBit:getRow(Char),
	?CHECK_THROW(SpecialItemCfg =/= {}, ?ERROR_Cfg),
	SpecialItemID = SpecialItemCfg#petUniversalBitCfg.itemID,
	{CostErr, _DecItemList} = dec_cost_when_add_star(StarCfg#petStarCfg.needItem, SpecialItemID, ?REASON_pet_add_star, UseSpec),
	?ERROR_CHECK_THROW(CostErr),
	NewPet = Pet#pet{star = Star + 1},
	PlayerId = player:getPlayerID(),
	player_push:pet_add_star(PlayerId, PetId, Star + 1), %% 升星公告
	update_pet(NewPet),
	refresh_skill(),
	calc_pet_prop(NewPet),
	put_prop(),
	player_refresh:on_refresh_pet(),
	attainment:check_attainment(?Attainments_Type_PetStar),
	activity_new_player:on_active_condition_change(?SalesActivity_PetAddStar, 1),
	log_pet_op(PetId, 3, Star, Star + 1),
	ok.

add_pet(PetId) ->
	BaseCfg = cfg_petBase:getRow(PetId),
	case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	CostErr = player:delete_cost(BaseCfg#petBaseCfg.consume, [], ?REASON_pet_add_star),
	?ERROR_CHECK_THROW(CostErr),
	add_pet_1(PetId, BaseCfg),
	ok.
%%add_pet(PetId, UseSpec) ->
%%	BaseCfg = cfg_petBase:getRow(PetId),
%%	case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
%%	StarCfg = cfg_petStar:getRow(PetId, BaseCfg#petBaseCfg.starIniti),
%%	case StarCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
%%	SpecialItemID = cfg_globalSetup:wanneng_suipian4(),
%%	{CostErr, DecItemList} = dec_cost_when_add_star(StarCfg#petStarCfg.needItem, SpecialItemID, ?REASON_pet_add_star, UseSpec),
%%	?ERROR_CHECK_THROW(CostErr),
%%	add_pet_1(PetId, BaseCfg),
%%	res_cb:on_use_res(?OpenAction_Pet, DecItemList, []),
%%	ok.

add_pet_1(PetId, BaseCfg) ->
	Pet = #pet{
		pet_id = PetId, star = BaseCfg#petBaseCfg.starIniti, grade = BaseCfg#petBaseCfg.rareType
	},
	update_pet(Pet),
	calc_pet_prop(Pet),
	put_prop(),
%%	PlayerId = player:getPlayerID(),
%%	player_push:pet_add_pet(PlayerId, PetId), %% 激活公告
	attainment:check_attainment(?Attainments_Type_PetCount),
	time_limit_gift:check_open(?TimeLimitType_GetPet),
%%	player_task:refresh_task([?Task_Goal_PetCount, ?Task_goal_PetActive]),
	guide:check_open_func(?OpenFunc_TargetType_Pet),
	prophecy:refresh_task_by_type(0, ?TaskType_companion, ?TaskType_companion_Pet),
	auto_pet_out(PetId),
	log_pet_op(PetId, 0, 0, 0),
	%% 获得S级以上的广播
	case BaseCfg#petBaseCfg.rareType >= 0 andalso not lists:keymember(PetId, 1, df:getGlobalSetupValueList(pet_No, [])) of
		?TRUE ->
			PlayerText = player:getPlayerText(),
			marquee:sendChannelNotice(0, 0, pet_GetNew,
				fun(Language) ->
					language:format(language:get_server_string("Pet_GetNew", Language),
						[PlayerText, richText:getItemText(PetId, Language)])
				end);
		_ -> skip
	end.

%% 计算花费
dec_cost_when_add_star(ItemList, _SpecialItemID, Reason, ?FALSE) -> ?metrics(begin
																				 CostErr = player:delete_cost(ItemList, [], Reason),
																				 {CostErr, ItemList} end);
dec_cost_when_add_star(ItemList, SpecialItemID, Reason, ?TRUE) ->
	case check_cost_item(ItemList, SpecialItemID) of
		{?TRUE, SpecialNum, NewItemList} ->
			DecItemList = NewItemList ++ [{SpecialItemID, SpecialNum}],
			bag_player:delete(DecItemList, Reason),
			{?ERROR_OK, DecItemList};
		_ -> {?ErrorCode_Synthetic_NeedItem, []}
	end.

%% 万能碎片判断相关
check_cost_item(NeedItemList, SpecialItemId) ->
	F = fun({NeedItemID, NeedItemNum}, {NewItemList, SpecialItemNum}) ->
		Num = bag_player:get_item_amount(NeedItemID),
		case Num >= NeedItemNum of
			?TRUE ->
				{[{NeedItemID, NeedItemNum} | NewItemList], SpecialItemNum};
			_ ->
				{[{NeedItemID, Num} | NewItemList], SpecialItemNum + NeedItemNum - Num}
		end end,
	{ItemList, SpecialItemNum1} = lists:foldl(F, {[], 0}, NeedItemList),
	Ret = {bag_player:get_item_amount(SpecialItemId) >= SpecialItemNum1, SpecialItemNum1, ItemList},
	Ret.

pet_out_up(Pos, PetID) ->
	?CHECK_THROW(get_pet(PetID) =/= {}, ?ErrorCode_Pet_No),
	%% 是否已经上阵
	PetOutList = get_petout_list(),
	AnotherPos =
		case lists:keyfind(PetID, 2, PetOutList) of
			{AP, PetID} -> AP;
			_ -> 0
		end,
	AnotherPetID =
		case lists:keyfind(Pos, 1, PetOutList) of
			{Pos, API} -> API;
			_ -> 0
		end,
	NewPetoutList = lists:keysort(1, lists:keystore(Pos, 1, PetOutList, {Pos, PetID})),
	FinalPetOutList =
		case {AnotherPos, AnotherPetID} of
			{0, _} -> NewPetoutList;
			{AnotherPos, AnotherPetID} ->
				lists:keysort(1, lists:keystore(AnotherPos, 1, NewPetoutList, {AnotherPos, AnotherPetID}))
		end,
	set_petout_list(FinalPetOutList),
	set_out_fight_pet_id_list(FinalPetOutList),
	player_private_list:set_value(?Private_List_index_petout, FinalPetOutList),
	%% 上阵即是出战，同步信息
	player_refresh:on_refresh_pet(),
	player_refresh:on_refresh_pet_skill(),
	player:send(#pk_GS2U_PetEquipList{pet_list = [#pk_key_value{key = K, value = V} || {K, V} <- FinalPetOutList]}),
	player:send(#pk_GS2U_PetOutRet{op = 1, err_code = ?ERROR_OK}).

set_out_fight_pet_id_list(PetOutList) ->
	PetIdList = [PetId || {_, PetId} <- PetOutList],
	OutIds = get_out_fight_pet_id_list(),
	F = fun(PetId) ->
		Pet = get_pet(PetId),
		case Pet =/= {} of
			?TRUE ->
				case lists:member(PetId, PetIdList) of
					?TRUE ->
						Pet#pet.fight_flag == 0 andalso update_pet(Pet#pet{fight_flag = 1});
					_ ->
						Pet#pet.fight_flag == 1 andalso update_pet(Pet#pet{fight_flag = 0})
				end;
			_ -> skip
		end
		end,
	lists:foreach(F, util:list_unique(OutIds ++ PetIdList)),
	ok.

pet_out_down(Pos) ->
	PetOutList = get_petout_list(),
	%% 该位置上是否有宠物出战
	case lists:keyfind(Pos, 1, PetOutList) of
		{Pos, OldPetID} ->
			case OldPetID of
				0 -> throw(?ErrorCode_Pet_Out_No);
				_ ->
					%%如果想要下阵的宠物是出战宠物的话，需要将出战宠物变为首上阵位的宠物，无法变更则下阵失败 on_pet_equip(0, PetId)
					NewPetoutList = lists:keysort(1, lists:keystore(Pos, 1, PetOutList, {Pos, 0})),
					set_petout_list(NewPetoutList),
					player_private_list:set_value(?Private_List_index_petout, NewPetoutList),
					set_out_fight_pet_id_list(NewPetoutList),
					player_refresh:on_refresh_pet(),
					player_refresh:on_refresh_pet_skill(),
					player:send(#pk_GS2U_PetEquipList{pet_list = [#pk_key_value{key = K, value = V} || {K, V} <- NewPetoutList]}),
					player:send(#pk_GS2U_PetOutRet{op = 2, err_code = ?ERROR_OK})
			end;
		?FALSE -> throw(?ErrorCode_Pet_Out_No)
	end.
%% 等级
calc_pet_exp(MaxLv, Lv, AddExp) when Lv >= MaxLv ->
	{Lv, AddExp};
calc_pet_exp(MaxLv, Lv, AddExp) ->
	case cfg_petLevel:getRow(Lv) of
		#petLevelCfg{exp = 0} ->
			{Lv, AddExp};
		#petLevelCfg{exp = Exp} when AddExp >= Exp ->
			calc_pet_exp(MaxLv, Lv + 1, AddExp - Exp);
		#petLevelCfg{} ->
			{Lv, AddExp};
		_ ->
			?LOG_ERROR("calc_pet_exp no petLevelCfg, level :~p", [Lv]),
			{Lv, AddExp}
	end.


%% 等级
calc_moling_exp(Lv, AddExp) ->
	case cfg_petSoulLv:getRow(Lv) of
		#petSoulLvCfg{exp = 0} ->
			{Lv, AddExp};
		#petSoulLvCfg{exp = Exp} when AddExp >= Exp ->
			calc_moling_exp(Lv + 1, AddExp - Exp);
		#petSoulLvCfg{} ->
			{Lv, AddExp};
		_ ->
			?LOG_ERROR("calc_moling_exp no petSoulLvCfg, level :~p", [Lv]),
			{Lv, AddExp}
	end.

%% 取指定稀有度宠物数量
get_pet_num_rare(NeedRareType) ->
	Fun =
		fun(Pet, Acc) ->
			#petBaseCfg{rareType = BornRareType} = cfg_petBase:getRow(Pet#pet.pet_id),
			NowRareType = Pet#pet.grade,
			case BornRareType =< NeedRareType andalso NowRareType >= NeedRareType of
				?TRUE -> Acc + 1;
				_ -> Acc
			end
		end,
	lists:foldl(Fun, 0, get_pet_list()).

get_rare(FetterId) ->
	case FetterId of
		1 -> 0;
		2 -> 1;
		3 -> 2;
		4 -> 3;
		_ -> 4
	end.


get_pill_max([{Lv, Max} | _T], PLv) when PLv =< Lv -> Max;
get_pill_max([{_, Max}], _PLv) -> Max;
get_pill_max([_ | T], PLv) -> get_pill_max(T, PLv).


%%check_skill_is_open(Lv, Pos) ->
%%	case cfg_petSkillOpen:getRow(Pos) of
%%		#petSkillOpenCfg{needPetLv = NeedLv} ->
%%			Lv >= NeedLv;
%%		_ -> ?FALSE
%%	end.

check_eqp_is_open(Lv, Pos) ->
	case cfg_petEqpOpen:getRow(Pos) of
		#petEqpOpenCfg{needLv = NeedLv} ->
			Lv >= NeedLv;
		_ -> ?FALSE
	end.

get_eq_pos() ->
	Lv = player:getLevel(),
	[Pos || #petEqpOpenCfg{needLv = NeedLv, iD = Pos} <- cfg_petEqpOpen:rows(), Lv >= NeedLv].




check_transfer(_OldInfo, [], Ret) -> Ret;
check_transfer(OldInfo, [{Pos, Uid, _} | T], {OnList, OffList}) ->
	case lists:keyfind(Pos, 1, OldInfo) of
		{Pos, Uid, _, _} -> check_transfer(OldInfo, T, {OnList, OffList});
		{Pos, Uid1, _, _} when Uid1 > 0 -> check_transfer(OldInfo, T, {[Uid | OnList], [Uid1 | OffList]});
		_ -> check_transfer(OldInfo, T, {[Uid | OnList], OffList})
	end.

%% 找每个部位评分最高的那个
get_ok_ep(_, _, [], Ret) -> Ret;
get_ok_ep(Lv, PosList, [#item{cfg_id = CfgId, id = Id} | T], Ret) ->
	#petEquipCfg{part = Part, score = ScoreBase, lvLimit = LvLimit} = cfg_petEquip:getRow(CfgId),
	Score = ScoreBase + get_eq_rand_prop_score(Id),
	case lists:member(Part, PosList) andalso Lv >= LvLimit of
		?FALSE -> get_ok_ep(Lv, PosList, T, Ret);
		_ ->
			case lists:keyfind(Part, 1, Ret) of
				?FALSE -> get_ok_ep(Lv, PosList, T, [{Part, Id, Score} | Ret]);
				{Part, Id1, Score1} ->
					{NewId, NewScore} = common:getTernaryValue(Score >= Score1, {Id, Score}, {Id1, Score1}),
					NewRet = lists:keystore(Part, 1, Ret, {Part, NewId, NewScore}),
					get_ok_ep(Lv, PosList, T, NewRet)
			end
	end.

get_eq_rand_prop_score(Uid) ->
	case lists:keyfind(Uid, #eq_addition.eq_uid, get_moling_eq()) of
		#eq_addition{rand_prop = RandProp} ->
			IndexList = [PointIndex || {_, _, _, PointIndex} <- RandProp],
			L = [begin
					 case cfg_equipScoreIndex:getRow(PointIndex) of
						 #equipScoreIndexCfg{score = S} -> S;
						 _ ->
							 ?LOG_ERROR("Err Equip Score Index :~p", [PointIndex]),
							 0
					 end
				 end || PointIndex <- IndexList],
			lists:sum(L);
		_ ->
			?LOG_ERROR("[Err] can not find eq :~p", [Uid]),
			0
	end.


pet_break(PetId) ->
	Pet = get_pet(PetId),
	case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_No) end,
	PetLv = Pet#pet.pet_lv,
	case cfg_petBreak:getRow(Pet#pet.break_lv) of
		#petBreakCfg{maxLv = PetLv} -> skip;
		_ -> throw(?ErrorCode_Pet_CannotBreak)
	end,

	BreakCfg = cfg_petBreak:getRow(Pet#pet.break_lv + 1),
	case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

	CostErr = player:delete_cost(BreakCfg#petBreakCfg.needItem, [], ?REASON_pet_break),
	?ERROR_CHECK_THROW(CostErr),
	{NewLv, NewExp} = calc_pet_exp(BreakCfg#petBreakCfg.maxLv, PetLv, Pet#pet.pet_exp),
	NewPet = Pet#pet{break_lv = Pet#pet.break_lv + 1, pet_lv = NewLv, pet_exp = NewExp},
	update_pet(NewPet),
	calc_pet_prop(NewPet),
	put_prop(),
	player:send(#pk_GS2U_PetAddBreakRet{pet_id = PetId, err_code = ?ERROR_OK}),
	player_push:pet_add_level(player:getPlayerID(), PetId, PetLv), %% 升级公告
	log_pet_op(PetId, 2, Pet#pet.break_lv, NewPet#pet.break_lv).

pet_awaken(PetId, UseSpec) ->
	Pet = get_pet(PetId),
	case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_No) end,
	#petReincarnationCfg{awakenMax = {OldMax, NewMax}} = cfg_petReincarnation:getRow(PetId),
	case Pet#pet.is_rein of
		0 -> case Pet#pet.awaken_lv >= OldMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_CannotAwaken) end;
		_ -> case Pet#pet.awaken_lv >= NewMax of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_CannotAwaken) end
	end,

	AwakenCfg = cfg_petAwaken:getRow(PetId, Pet#pet.awaken_lv + 1),
	case AwakenCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

	case Pet#pet.star >= AwakenCfg#petAwakenCfg.needLv of
		?TRUE -> skip;
		_ -> throw(?ErrorCode_Pet_CannotAwaken)
	end,

	case Pet#pet.pet_lv >= AwakenCfg#petAwakenCfg.needLevel of
		?TRUE -> skip;
		_ -> throw(?ErrorCode_Pet_CannotAwaken)
	end,

	SpecialItemID = cfg_globalSetup:wanneng_suipian4(),
	{CostErr, _DecItemList} = dec_cost_when_add_star(AwakenCfg#petAwakenCfg.needItem, SpecialItemID, ?REASON_pet_awaken, UseSpec),
	?ERROR_CHECK_THROW(CostErr),
	NewPet = Pet#pet{
		awaken_lv = Pet#pet.awaken_lv + 1
	},
	update_pet(NewPet),
	case cfg_petAwaken:getRow(PetId, Pet#pet.awaken_lv) of
		#petAwakenCfg{skillLv = SkillLv} when SkillLv =/= AwakenCfg#petAwakenCfg.skillLv ->
			awaken_refresh_skill(PetId);
		_ -> skip
	end,
	calc_pet_prop(NewPet),
	put_prop(),
	attainment:check_attainment(?Attainments_Type_PetFeather),
	time_limit_gift:check_open(?TimeLimitType_PetAwaken),
	activity_new_player:on_active_condition_change(?SalesActivity_PetAwake, 1),
	PlayerId = player:getPlayerID(),
	player_push:pet_awaken(PlayerId, PetId, NewPet#pet.awaken_lv), %% 觉醒公告
	player:send(#pk_GS2U_PetAddAwakenRet{pet_id = PetId, err_code = ?ERROR_OK}),
	log_pet_op(PetId, 4, Pet#pet.awaken_lv, NewPet#pet.awaken_lv).

%% 如果改宠物的觉醒技能被魔灵装配 需要刷新技能列表
awaken_refresh_skill(PetId) ->
	awaken_refresh_skill(get_moling(), PetId).
awaken_refresh_skill([], _PetId) -> ok;
awaken_refresh_skill([#moling{role_id = RoleId, skills = Skills} | T], PetId) ->
	case lists:keyfind(PetId, 2, Skills) of
		?FALSE -> awaken_refresh_skill(T, PetId);
		_ -> refresh_skill(RoleId)
	end.


%% 宠物晋升
pet_grade(PetId) ->
	Pet = get_pet(PetId),
	?CHECK_THROW(Pet =/= {}, ?ErrorCode_Pet_No),
	%%判断能否晋升
	BaseCfg = cfg_petBase:getRow(PetId),
	?CHECK_THROW(BaseCfg =/= {}, ?ERROR_Cfg),
	?CHECK_THROW(BaseCfg#petBaseCfg.gradeUpOpen =:= 1, ?ErrorCode_Pet_Cant_GradeUp),
	GradeCfg = cfg_petGradeUp:getRow(PetId, Pet#pet.grade),
	?CHECK_THROW(GradeCfg =/= {}, ?ERROR_Cfg),
	?CHECK_THROW(GradeCfg#petGradeUpCfg.rareTypeLimit > Pet#pet.grade, ?ErrorCode_Pet_GradeMax),
	%%扣除消耗，进行晋升
	CostErr = player:delete_cost([GradeCfg#petGradeUpCfg.needItem], [], ?REASON_pet_grade),
	?ERROR_CHECK_THROW(CostErr),
	NewPet = Pet#pet{grade = Pet#pet.grade + 1},
	PlayerId = player:getPlayerID(),
	player_push:pet_add_grade(PlayerId, PetId, NewPet#pet.grade),
	update_pet(NewPet),
	refresh_skill(),
	calc_pet_prop(NewPet),
	put_prop(),
	case is_show_changed(PetId, Pet#pet.grade) of
		?TRUE -> player_refresh:on_refresh_pet();
		?FALSE -> ok
	end,
	constellation:refresh_skill(PetId),
	log_pet_op(PetId, 13, Pet#pet.grade, NewPet#pet.grade),
	player:send(#pk_GS2U_PetAddGradeRet{pet_id = PetId, err_code = ?ERROR_OK}).



pet_awaken_potential(PetId) ->
	Pet = get_pet(PetId),
	case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ErrorCode_Pet_No) end,
	Cfg = cfg_petSublimate:getRow(Pet#pet.awaken_potential + 1),
	case Cfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

	case Pet#pet.pet_lv >= Cfg#petSublimateCfg.needLevel of
		?TRUE -> skip;
		_ -> throw(?ErrorCode_Pet_PetLvNotMeet)
	end,

	CostErr = player:delete_cost(Cfg#petSublimateCfg.needItem, [], ?REASON_pet_awaken_p),
	?ERROR_CHECK_THROW(CostErr),
	NewPet = Pet#pet{awaken_potential = Pet#pet.awaken_potential + 1},
	update_pet(NewPet),
	calc_pet_prop(NewPet),
	put_prop(),
	PlayerId = player:getPlayerID(),
	player_push:pet_awaken_potential(PlayerId, PetId, NewPet#pet.awaken_potential), %% 炼魂公告
	attainment:check_attainment(?Attainments_Type_PetSublimate),
	time_limit_gift:check_open(?TimeLimitType_PetSublimate),
	player_task:refresh_task(?Task_Goal_PetSublimate),
	activity_new_player:on_active_condition_change(?SalesActivity_PetSublimate, 1),
	player:send(#pk_GS2U_PetAddAwakenPotentialRet{pet_id = PetId, err_code = ?ERROR_OK}),
	log_pet_op(PetId, 5, Pet#pet.awaken_potential, NewPet#pet.awaken_potential).

%% 转生
pet_rein(PetId) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Pet = get_pet(PetId),
		case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		case Pet#pet.is_rein of
			0 -> skip;
			_ -> throw(?ErrorCode_Pet_Rein)
		end,
		ReinCfg = cfg_petReincarnation:getRow(PetId),
		case ReinCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		IsCond = check_cond(Pet, ReinCfg#petReincarnationCfg.condition),
		case IsCond of ?TRUE -> skip; _ -> throw(?ErrorCode_Condition_Rein) end,
		check_consume(ReinCfg#petReincarnationCfg.consume),
		NewPet = Pet#pet{is_rein = 1},
		update_pet(NewPet),
		calc_pet_prop(NewPet),
		put_prop(),
		player:send(#pk_GS2U_PetReincarnationRet{pet_id = PetId, err_code = ?ERROR_OK}),
		log_pet_op(PetId, 12, Pet#pet.is_rein, NewPet#pet.is_rein)
	catch
		ErrCode -> player:send(#pk_GS2U_PetReincarnationRet{pet_id = PetId, err_code = ErrCode})
	end.

%% 检查转生条件
check_cond(Pet, ConList) ->
	OrderList = common:group_by(ConList, 1),
	Func =
		fun({_, List}) ->
			Func0 =
				fun({K, V}) ->
					case K of
						1 -> Pet#pet.pet_lv >= V;
						2 -> Pet#pet.star >= V;
						3 -> Pet#pet.awaken_lv >= V;
						4 -> Pet#pet.awaken_potential >= V;
						_ -> ?FALSE
					end
				end,
			lists:all(Func0, List)
		end,
	lists:any(Func, OrderList).

%% 检查转生消耗
check_consume(Consume) ->
	%% 检查消耗是否足够
	Func0 =
		fun({Way, P1, P2}) ->
			case Way of
				1 -> %% 消耗物品
					case bag_player:get_item_amount(P1) >= P2 of
						?TRUE ->
							ok;
						?FALSE ->
							throw(?ErrorCode_Consume_Rein)
					end;
				2 -> %% 消耗货币
					case currency:get_today_delete_max(P1) >= P2 of
						?TRUE ->
							ok;
						?FALSE ->
							throw(?ErrorCode_Consume_Rein)
					end;
				_ -> ok
			end
		end,
	lists:foreach(Func0, Consume),
	%% 扣除消耗
	Func =
		fun({Way, P1, P2}) ->
			case Way of
				1 -> %% 消耗物品
					player:delete_cost([{P1, P2}], [], ?REASON_pet_rein);
				2 -> %% 消耗货币
					player:delete_cost([], [{P1, P2}], ?REASON_pet_rein);
				_ -> ok
			end
		end,
	lists:foreach(Func, Consume).

fetter_active(FetterId, Lv) ->
	?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
	LvCheck = case lists:keyfind(FetterId, 1, get_fetter_list()) of
				  {FetterId, Lv1} -> Lv =:= Lv1 + 1;
				  ?FALSE -> Lv =:= 1
			  end,
	?CHECK_THROW(LvCheck, ?ErrorCode_Pet_FetterCannotActive),
	Cfg = cfg_petJiBan2:getRow(FetterId, Lv),
	?CHECK_THROW(Cfg =/= {}, ?ERROR_Cfg),

	RareType = get_rare(FetterId),
	?CHECK_THROW(RareType =/= 4, ?ERROR_Param),
	PetNum = get_pet_num_rare(RareType),
	?CHECK_THROW(PetNum >= Cfg#petJiBan2Cfg.num, ?ErrorCode_Pet_FetterCannotActive),


	update_fetter(FetterId, Lv),
	calc_fetter_prop(),
	put_prop(),
	PlayerId = player:getPlayerID(),
	Language = language:get_player_language(PlayerId),
	FetterName = language:get_tongyong_string(Cfg#petJiBan2Cfg.name, Language),
	player_push:pet_fetter_level(PlayerId, FetterName, Lv), %% 羁绊公告
	player:send(#pk_GS2U_PetFetterActiveRet{err_code = ?ERROR_OK}),
	log_pet_op(FetterId, 6, Lv - 1, Lv).

moling_pill(RoleId, Index, Num) ->
	case variable_world:get_value(?WorldVariant_Switch_Moling) == 1 andalso guide:is_open_action(?OpenAction_Moling) of
		?TRUE -> ok;
		?FALSE -> throw(?ERROR_FunctionClose)
	end,
	Moling = get_moling(RoleId),
	NowUse = case Index of
				 1 -> Moling#moling.pill1;
				 2 -> Moling#moling.pill2;
				 3 -> Moling#moling.pill3;
				 _ -> throw(?ERROR_Cfg)
			 end,
	#petPillAttrCfg{itemID = PillItemId} = cfg_petPillAttr:getRow(Index),
	PlayerLv = player:getLevel(),
	MaxUseNum = get_pill_max([{Id, Max} || #petPillCfg{iD = Id, itemID = I, max = Max} <- cfg_petPill:rows(), I =:= PillItemId], PlayerLv),
	case NowUse + Num > MaxUseNum of ?FALSE -> skip; _ -> throw(?ErrorCode_ML_PillMax) end,
	CostErr = player:delete_cost([{PillItemId, Num}], [], ?REASON_pet_soul_pill),
	?ERROR_CHECK_THROW(CostErr),
	NowMoling = case Index of
					1 -> Moling#moling{pill1 = Moling#moling.pill1 + Num};
					2 -> Moling#moling{pill2 = Moling#moling.pill2 + Num};
					3 -> Moling#moling{pill3 = Moling#moling.pill3 + Num}
				end,
	update_moling(NowMoling, ?TRUE),
	player:send(#pk_GS2U_MolingEatPillRet{role_id = RoleId, err_code = ?ERROR_OK}),
	calc_moling_prop(NowMoling),
	put_prop(),
	attainment:check_attainment(?Attainments_Type_PetPill),
	activity_new_player:on_active_condition_change(?SalesActivity_MLPill, 1),
	log_pet_op(0, 7,
		gamedbProc:term_to_dbstring([Moling#moling.pill1, Moling#moling.pill2, Moling#moling.pill3]),
		gamedbProc:term_to_dbstring([NowMoling#moling.pill1, NowMoling#moling.pill2, NowMoling#moling.pill3])).

moling_add_lv(RoleId, CostList) ->
	case variable_world:get_value(?WorldVariant_Switch_Moling) == 1 andalso guide:is_open_action(?OpenAction_Moling) of
		?TRUE -> ok;
		?FALSE -> throw(?ERROR_FunctionClose)
	end,
	Moling = get_moling(RoleId),

	F = fun({ItemId, Num}, Ret) ->
		ExpItemCfg = cfg_petSoulExpItem:getRow(ItemId),
		case ExpItemCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
		ExpItemCfg#petSoulExpItemCfg.exp * Num + Ret
		end,
	AddExp = lists:foldl(F, 0, CostList),

	case bag_player:delete_prepare(CostList) of
		{?ERROR_OK, P} ->
			{NewLv, NewExp} = calc_moling_exp(Moling#moling.lv, Moling#moling.exp + AddExp),
			bag_player:delete_finish(P, ?REASON_pet_soul_add_lv),
			update_moling(Moling#moling{
				lv = NewLv, exp = NewExp
			}, ?TRUE),
			if
				NewLv > Moling#moling.lv ->
					PlayerId = player:getPlayerID(),
					player_push:pet_moling_add_lv(PlayerId, RoleId, Moling#moling.lv, NewLv);
				true ->
					skip
			end,

			%% 检查开启技能格子
%%			case NewLv =/= Moling#moling.lv of
%%				?TRUE ->
%%					check_open_skill_box(RoleId, 1);
%%				?FALSE ->
%%					ok
%%			end,

			log_pet_op(0, 8, lists:concat([Moling#moling.lv, "(", Moling#moling.exp, ")"]), lists:concat([NewLv, "(", NewExp, ")"]));
		{CostErr, _} -> throw(CostErr)
	end,
	player:send(#pk_GS2U_MolingAddLvRet{role_id = RoleId, err_code = ?ERROR_OK}),
	calc_moling_prop(Moling#moling.role_id),
	put_prop(),
	attainment:check_attainment(?Attainments_Type_PetSoulLv),
	player_task:refresh_task(?Task_Goal_MolingLv),
	genius:check_genius_effect(?Genius_OpenType_MolingLv),
	activity_new_player:on_active_condition_change(?SalesActivity_MLAddLv, 1),
	ok.

%% 检查开启技能格子 way:1等级开放，2vip等级开放
%%check_open_skill_box(RoleId, Way) ->
%%	[check_open_skill_box(RoleId, Pos, Way) ||
%%		#petSkillOpenCfg{iD = Pos, needWay = NeedWay} <- cfg_petSkillOpen:rows(), NeedWay =:= Way].
check_open_skill_box(RoleId, Pos, _Way) ->
	try
		Moling = get_moling(RoleId),
		case is_skill_box_open(RoleId, Pos) of
			?TRUE ->
				throw(?ErrorCode_ML_BoxAlreadyOpen);
			?FALSE ->
				Err = open_skill_box(RoleId, Pos, Moling#moling.lv),
				?ERROR_CHECK_THROW(Err)
		end,
		?ERROR_OK
	catch
		ErrCode ->
%%			?LOG_ERROR("check_open_skill_box err:~p, pos:~p, way:~p~n", [ErrCode, Pos, _Way]),
			ErrCode
	end.

open_skill_box(RoleId, Pos, Lv) ->
	try
		case cfg_petSkillOpen:getRow(Pos) of
			#petSkillOpenCfg{needWay = 1, needPetLv = MLLv} ->
				case Lv >= MLLv of
					?TRUE ->
						Moling = get_moling(RoleId),
						SkillBox = {Pos, 0, 0},
						NewSkillList = lists:keystore(Pos, 1, Moling#moling.skills, SkillBox),
						update_moling(Moling#moling{skills = NewSkillList}, ?FALSE),
						calc_moling_prop(Moling#moling.role_id),
						put_prop(),
						player:send(#pk_GS2U_MolingSkillUpdate{skills =
						[#pk_MolingSkill{role_id = RoleId, pos = P, pet_id = PI, skill_id = SI} || {P, PI, SI} <- NewSkillList]});
					?FALSE ->
						throw(?ErrorCode_ML_lvNotMeet)
				end;
			#petSkillOpenCfg{needWay = 2, needPetLv = VipLv, needItem = NeedItem} ->
				case vip:get_vip_lv() >= VipLv of
					?TRUE ->
						{ItemList, CoinList} = lists:foldl(
							fun({T, I, A}, {IL, CL}) ->
								case T of
									1 -> {[{I, A} | IL], CL};
									2 -> {IL, [{I, A} | CL]};
									_ -> {IL, CL}
								end
							end, {[], []}, NeedItem),
						Err = player:delete_cost(ItemList, CoinList, ?REASON_Moling_open_skillbox),
						?ERROR_CHECK_THROW(Err),
						Moling = get_moling(RoleId),
						SkillBox = {Pos, 0, 0},
						NewSkillList = lists:keystore(Pos, 1, Moling#moling.skills, SkillBox),
						update_moling(Moling#moling{skills = NewSkillList}, ?FALSE),
						calc_moling_prop(Moling#moling.role_id),
						put_prop(),
						player:send(#pk_GS2U_MolingSkillUpdate{skills =
						[#pk_MolingSkill{role_id = RoleId, pos = P, pet_id = PI, skill_id = SI} || {P, PI, SI} <- NewSkillList]});
					?FALSE ->
						throw(?ErrorCode_ML_VipLvNotEnough)
				end;
			{} ->
				throw(?ErrorCode_ML_BoxNotExist);
			_ ->
				throw(?ERROR_Cfg)
		end,
		?ERROR_OK
	catch
		ErrCode -> ErrCode
	end.

is_skill_box_open(RoleId, Pos) ->
	Moling = get_moling(RoleId),
	case lists:keyfind(Pos, 1, Moling#moling.skills) of
		?FALSE -> ?FALSE;
		_ -> ?TRUE
	end.

skill_put_on(RoleId, Pos, PetId, SkillId) ->
	?CHECK_THROW(is_func_open_moling(), ?ERROR_FunctionClose),
	Pet = get_pet(PetId),
	case Pet =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	Moling = get_moling(RoleId),
	{_, S1, _} = get_pet_awaken_skill(PetId),
	case S1 =:= SkillId of ?TRUE -> skip; _ -> throw(?ErrorCode_Pet_NoSkill) end,
%%	case check_skill_is_open(Moling#moling.lv, Pos) of ?TRUE -> skip; _ ->
%%		throw(?ErrorCode_ML_NoSkillPos) end,

	case lists:keyfind(PetId, 2, Moling#moling.skills) of
		?TRUE -> throw(?ErrorCode_Skill_TypeRepeat);
		_ -> skip
	end,

	case skill_player:check_skill_assembling_type(SkillId, [S || {_, _, S} <- Moling#moling.skills, S > 0]) of
		?TRUE -> skip;
		_ -> throw(?ErrorCode_Skill_TypeRepeat)
	end,
	case is_skill_box_open(RoleId, Pos) of
		?TRUE -> ok;
		?FALSE -> throw(?ErrorCode_ML_NoSkillPos)
	end,

	%% 若已装备在其他角色上则先卸下
	RoleIDList = role_data:get_all_role_id(),
	MolingList = get_moling(),
	F = fun(RoleID0) ->
		ML = get_moling(MolingList, RoleID0),
		SkillPList = ML#moling.skills,
		SkillInfoList = [SkillInfo || {_, P, S} = SkillInfo <- SkillPList, P =:= PetId, S =:= SkillId],
		case SkillInfoList of
			[{Pos0, PetId, SkillId} | _] ->
				skill_put_off(RoleID0, Pos0);
			[] ->
				skip
		end
		end,
	lists:foreach(F, RoleIDList -- [RoleId]),

	NewMoling = Moling#moling{skills = lists:keystore(Pos, 1, Moling#moling.skills, {Pos, PetId, SkillId})},
	update_moling(NewMoling, ?FALSE),
	player:send(#pk_GS2U_MolingSkillUpdate{skills = [#pk_MolingSkill{role_id = RoleId, pos = Pos, pet_id = PetId, skill_id = SkillId}]}),
	player:send(#pk_GS2U_MolingSkillOpRet{role_id = RoleId, err_code = ?ERROR_OK, type = 0}),
	refresh_skill(RoleId),
	calc_moling_prop(NewMoling),
	put_prop(),
	log_pet_op(0, 9, gamedbProc:term_to_dbstring(Moling#moling.skills), gamedbProc:term_to_dbstring(NewMoling#moling.skills)).



skill_put_off(RoleId, Pos) ->
	?CHECK_THROW(is_func_open_moling(), ?ERROR_FunctionClose),
	Moling = get_moling(RoleId),
	case is_skill_box_open(RoleId, Pos) of
		?TRUE -> ok;
		?FALSE -> throw(?ErrorCode_ML_NoSkillPos)
	end,
	NewMoling = Moling#moling{skills = lists:keyreplace(Pos, 1, Moling#moling.skills, {Pos, 0, 0})},
	update_moling(NewMoling, ?FALSE),
	player:send(#pk_GS2U_MolingSkillUpdate{skills = [#pk_MolingSkill{role_id = RoleId, pos = Pos, pet_id = 0}]}),
	player:send(#pk_GS2U_MolingSkillOpRet{role_id = RoleId, err_code = ?ERROR_OK, type = 1}),
	refresh_skill(RoleId),
	calc_moling_prop(NewMoling),
	put_prop(),
	log_pet_op(0, 9, gamedbProc:term_to_dbstring(Moling#moling.skills), gamedbProc:term_to_dbstring(NewMoling#moling.skills)).

eq_put_on(RoleId, EqUid) ->
	{Err, Item} = bag_player:get_bag_item(?BAG_ML_EQ, EqUid),
	?ERROR_CHECK_THROW(Err),
	[#item{cfg_id = CfgId}] = Item,
	EqCfg = cfg_petEquip:getRow(CfgId),
	case EqCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,

	Pos = EqCfg#petEquipCfg.part,
	Moling = get_moling(RoleId),
	case check_eqp_is_open(player:getLevel(), Pos) of ?TRUE -> skip; _ -> throw(?ErrorCode_ML_NoEqPos) end,

	case Moling#moling.lv >= EqCfg#petEquipCfg.lvLimit of ?TRUE -> skip; _ -> throw(?ErrorCode_ML_lvNotMeet) end,

	bag_player:transfer(?BAG_ML_EQ, EqUid, ?BAG_ML_EQ_EQUIP),
	case lists:keyfind(Pos, 1, Moling#moling.eqs) of
		{_, OldEqUid, Lv1, B1} when OldEqUid > 0 ->
			Lv = Lv1,
			Break = B1,
			bag_player:transfer(?BAG_ML_EQ_EQUIP, OldEqUid, ?BAG_ML_EQ);
		{_, _, Lv2, B2} -> Lv = Lv2, Break = B2;
		_ -> Lv = 0, Break = 0
	end,
	NewMoling = Moling#moling{eqs = lists:keystore(Pos, 1, Moling#moling.eqs, {Pos, EqUid, Lv, Break})},
	update_moling(NewMoling, ?FALSE),
	player:send(#pk_GS2U_MolingEqUpdate{eqs = [#pk_MolingEqPos{role_id = RoleId, pos = Pos, uid = EqUid, lv = Lv, break_lv = Break}]}),
	player:send(#pk_GS2U_MolingEqOpRet{role_id = RoleId, err_code = ?ERROR_OK, type = 0}),
	guide:check_open_func(?OpenFunc_TargetType_PetEq1),
	calc_moling_prop(NewMoling),
	put_prop(),
	attainment:check_attainment(?Attainments_Type_PetEqCount),
%%	player_task:refresh_task(?Task_Goal_PetEqCount),
	log_pet_op(0, 10, gamedbProc:term_to_dbstring(Moling#moling.eqs), gamedbProc:term_to_dbstring(NewMoling#moling.eqs)).

eq_add_level(RoleId, Pos, EqUid) ->
	?CHECK_THROW(is_func_open_pet_eq(), ?ERROR_FunctionClose),
	{Err, [Item]} = bag_player:get_bag_item(?BAG_ML_EQ_EQUIP, EqUid),
	?ERROR_CHECK_THROW(Err),
	Moling = get_moling(RoleId),
	case check_eqp_is_open(player:getLevel(), Pos) of ?TRUE -> skip; _ ->
		throw(?ErrorCode_ML_NoEqPos) end,

	{Lv, Break} = case lists:keyfind(Pos, 1, Moling#moling.eqs) of
					  {_, EqUid, Lv1, B1} ->
						  {Lv1, B1};
					  _ -> throw(?ErrorCode_ML_EqCannotAddLv)
				  end,

	#petEquipCfg{type = Type} = cfg_petEquip:getRow(Item#item.cfg_id),
	BreakCfg = cfg_petEqpStrBre:getRow(Type, Break),
	case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	case Lv < BreakCfg#petEqpStrBreCfg.lv of ?TRUE -> skip; _ -> throw(?ErrorCode_ML_EqLvMax) end,

	LvCfg = cfg_petEqpStr:getRow(Type, Lv + 1),
	case LvCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	CostErr = player:delete_cost(LvCfg#petEqpStrCfg.itemConsume, [], ?REASON_pet_soul_eqaddlv),
	?ERROR_CHECK_THROW(CostErr),
	case rand:uniform(10000) =< LvCfg#petEqpStrCfg.strRate of
		?TRUE ->
			update_moling(Moling#moling{eqs = lists:keystore(Pos, 1, Moling#moling.eqs, {Pos, EqUid, Lv + 1, Break})}, ?FALSE),
			player:send(#pk_GS2U_MolingEqUpdate{eqs = [#pk_MolingEqPos{role_id = RoleId, pos = Pos, uid = EqUid, lv = Lv + 1, break_lv = Break}]}),
			player:send(#pk_GS2U_MolingEqAddLvRet{role_id = RoleId, err_code = ?ERROR_OK, is_success = 1}),
			calc_moling_prop(Moling#moling.role_id),
			put_prop(),
			log_pet_op(0, 11, EqUid, lists:concat([Pos, ":", Lv, "->", Lv + 1])),
			time_limit_gift:check_open(?TimeLimitType_PetEqInt),
			ok;
		_ ->
			player:send(#pk_GS2U_MolingEqAddLvRet{role_id = RoleId, err_code = ?ERROR_OK, is_success = 0}),
			log_pet_op(0, 11, EqUid, lists:concat([Pos, ":", Lv, "->", Lv]))
	end,
	ok.



eq_break(RoleId, Pos, EqUid) ->
	?CHECK_THROW(is_func_open_pet_eq(), ?ERROR_FunctionClose),
	{Err, [Item]} = bag_player:get_bag_item(?BAG_ML_EQ_EQUIP, EqUid),
	?ERROR_CHECK_THROW(Err),
	Moling = get_moling(RoleId),
	case check_eqp_is_open(player:getLevel(), Pos) of ?TRUE -> skip; _ ->
		throw(?ErrorCode_ML_NoEqPos) end,

	{Lv, Break} = case lists:keyfind(Pos, 1, Moling#moling.eqs) of
					  {_, EqUid, Lv1, B1} ->
						  {Lv1, B1};
					  _ -> throw(?ErrorCode_ML_EqCannotAddLv)
				  end,

	#petEquipCfg{type = Type} = cfg_petEquip:getRow(Item#item.cfg_id),
	BreakCfg = cfg_petEqpStrBre:getRow(Type, Break),
	case BreakCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
	case Lv =:= BreakCfg#petEqpStrBreCfg.lv of ?TRUE -> skip; _ -> throw(?ErrorCode_ML_CannotBreak) end,
	case Break < BreakCfg#petEqpStrBreCfg.lvMax of ?TRUE -> skip; _ -> throw(?ErrorCode_ML_EqLvMax) end,

	CostErr = player:delete_cost(BreakCfg#petEqpStrBreCfg.itemConsume, [], ?REASON_ml_eq_break),
	?ERROR_CHECK_THROW(CostErr),
	update_moling(Moling#moling{eqs = lists:keystore(Pos, 1, Moling#moling.eqs, {Pos, EqUid, Lv, Break + 1})}, ?FALSE),
	player:send(#pk_GS2U_MolingEqUpdate{eqs = [#pk_MolingEqPos{role_id = RoleId, pos = Pos, uid = EqUid, lv = Lv, break_lv = Break + 1}]}),
	player:send(#pk_GS2U_MolingEqBreakRet{role_id = RoleId, err_code = ?ERROR_OK}),
	calc_moling_prop(Moling#moling.role_id),
	put_prop(),
	log_pet_op(0, 12, EqUid, lists:concat([Pos, ":", Break, "->", Break + 1])),
	ok.

onekey_equip_on(RoleId) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleId), ?ERROR_NoRole),
		?CHECK_THROW(is_func_open_pet_eq(), ?ERROR_FunctionClose),
		Moling = get_moling(RoleId),
		Equips = get_ok_ep(Moling#moling.lv, get_eq_pos(), bag_player:get_bag_item_list(?BAG_ML_EQ) ++ bag_player:get_bag_item_list(?BAG_ML_EQ_EQUIP), []),
		case Equips =:= [] of
			?FALSE ->
				{OnList, OffList} = check_transfer(Moling#moling.eqs, Equips, {[], []}),
				Err = bag_player:transfer(?BAG_ML_EQ, OnList, ?BAG_ML_EQ_EQUIP),
				?ERROR_CHECK_THROW(Err),
				Err1 = bag_player:transfer(?BAG_ML_EQ_EQUIP, OffList, ?BAG_ML_EQ),
				?ERROR_CHECK_THROW(Err1),
				NewEqs = lists:foldl(fun({Pos, Uid, _}, Ret) ->
					case lists:keyfind(Pos, 1, Ret) of
						{_, _, Lv, Break} -> lists:keystore(Pos, 1, Ret, {Pos, Uid, Lv, Break});
						_ -> lists:keystore(Pos, 1, Ret, {Pos, Uid, 0, 0})
					end end, Moling#moling.eqs, Equips),
				update_moling(Moling#moling{
					eqs = NewEqs
				}, ?FALSE),
				player:send(#pk_GS2U_MolingEqUpdate{eqs = [#pk_MolingEqPos{role_id = RoleId, pos = Pos, uid = EqUid, lv = Lv, break_lv = Break} || {Pos, EqUid, Lv, Break} <- NewEqs]}),
				player:send(#pk_GS2U_MolingEqOneKeyOpRet{role_id = RoleId, err_code = ?ERROR_OK, type = 0}),
				guide:check_open_func(?OpenFunc_TargetType_PetEq1),
				calc_moling_prop(RoleId),
				put_prop();
			_ ->
				throw(?ErrorCode_Astro_NoEqForOneKeyOn)
		end
	catch
		ErrCode -> player:send(#pk_GS2U_MolingEqOneKeyOpRet{role_id = RoleId, err_code = ErrCode, type = 0})
	end.

%%
item_eq_add(ItemList0) ->
	ItemList = lists:filter(fun(#item{id = EqUid}) -> get_ml_eq(EqUid) =:= {} end, ItemList0),

	F = fun(#item{cfg_id = CfgId, id = EqUid}, {R1, R2, R3}) ->
		Cfg = #petEquipCfg{starRule = RuleList} = cfg_petEquip:getRow(CfgId),
		PropList = [Cfg#petEquipCfg.starAttribute1, Cfg#petEquipCfg.starAttribute2, Cfg#petEquipCfg.starAttribute3],
		PointList = [Cfg#petEquipCfg.starScore1, Cfg#petEquipCfg.starScore2, Cfg#petEquipCfg.starScore3],
		RandProp = astrolabe:make_rand_prop(RuleList, {PropList, PointList}, []),

		R11 = #eq_addition{
			eq_uid = EqUid,
			cfg_id = CfgId,
			rand_prop = RandProp
		},

		R22 = #db_eq_addition{
			eq_uid = EqUid,
			player_id = player:getPlayerID(),
			item_data_id = CfgId,
			eq_type = 1,  %% 1魔灵 2翼灵 3兽灵
			rand_prop = RandProp
		},

		R33 = #pk_EqAddition{
			eq_Uid = EqUid,
			cfg_id = CfgId,
			rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- RandProp]
		},
		{[R11 | R1], [R22 | R2], [R33 | R3]}
		end,
	{EqList, EqDBList, EqMsgList} = lists:foldl(F, {[], [], []}, ItemList),
	set_moling_eq(EqList ++ get_moling_eq()),
	table_player:insert(db_eq_addition, EqDBList),
	player:send(#pk_GS2U_MLEqUpdate{eqs = EqMsgList}),
	guide:check_open_func(?OpenFunc_TargetType_PetEq),
	ok.


%% 操作 0-add 1-升级 2-突破 3-升星 4-觉醒 5-炼魂 6-羁绊 7-魔灵吃药 8-魔灵升级 9-魔灵技能装配 10-魔灵装备 11-魔灵装备升级 12-转生 13-晋升
log_pet_op(PetId, Op, P1, P2) ->
	table_log:insert_row(log_pet_op, [player:getPlayerID(), time:time(), PetId, Op, P1, P2]).

%% 2019-06-03 cbfan添加 使用实例的方式添加其他装备
%% 添加实例回调
add_eq_ins(Eq = #eq_addition{eq_uid = EqUid, cfg_id = CfgId, rand_prop = RandProp}) -> ?metrics(begin
																									set_moling_eq([Eq] ++ get_moling_eq()),
																									table_player:insert(db_eq_addition, #db_eq_addition{
																										eq_uid = EqUid,
																										player_id = player:getPlayerID(),
																										item_data_id = CfgId,
																										eq_type = 1,  %% 1魔灵 2翼灵 3兽灵
																										rand_prop = RandProp
																									}),
																									EqMsg = #pk_EqAddition{
																										eq_Uid = EqUid,
																										cfg_id = CfgId,
																										rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- RandProp]
																									},
																									player:send(#pk_GS2U_MLEqUpdate{eqs = [EqMsg]}),
																									guide:check_open_func(?OpenFunc_TargetType_PetEq),
																									ok end).
get_ml_eq(Uid) -> ?metrics(begin
							   case lists:keyfind(Uid, #eq_addition.eq_uid, get_moling_eq()) of
								   #eq_addition{} = E -> E;
								   _ -> {}
							   end end).

%% 宠物使用升级升星卡
pet_lv_star_card_1(ItemCfg) ->
	#itemCfg{useParam1 = PetID, useParam2 = ToLv, useParam3 = ToStar, useParam4 = ExpItemId} = ItemCfg,
	%% 判断激活 没有激活则激活
	{Pet, Sign} = case get_pet(PetID) of
					  {} ->
						  %% 初始化宠物 存入进程字典
						  BaseCfg = cfg_petBase:getRow(PetID),
						  case BaseCfg =:= {} of ?FALSE -> skip; _ -> throw(?ERROR_Cfg) end,
						  Pet1 = #pet{
							  pet_id = PetID, star = BaseCfg#petBaseCfg.starIniti, grade = BaseCfg#petBaseCfg.rareType
						  },
						  PetList = get_pet_list(),
						  NewPetList = lists:keystore(Pet1#pet.pet_id, #pet.pet_id, PetList, Pet1),
						  set_pet_list(NewPetList),
						  {Pet1, 1};
					  M -> {M, 0}
				  end,
	case ToLv > cfg_petLevel:keys_length() of ?TRUE -> throw(?ERROR_Cfg);_ -> skip end, %% 不能超过最大等级
	#petStarCfg{starMax = MaxStar} = cfg_petStar:getRow(PetID, Pet#pet.star),
	case ToStar > MaxStar of ?TRUE -> throw(?ERROR_Cfg);_ -> skip end, %% 不能超过最大星级
	ItemList1 = case ToLv of
					0 -> [];
					_ ->
						case Pet#pet.pet_lv >= ToLv of
							%% 等级已经达到卡片配置 返回经验道具
							?TRUE ->
								%% 返还升到卡片配置等级的经验道具
								[{ItemID}] = ExpItemId,
								LvItemList = get_level_item(ToLv, ItemID, 0),
								%% 返还升到卡片配置等级所消耗的突破道具
								BreakLv = get_break(ToLv),
								BreakItemList = get_break_item(BreakLv),

								item:item_merge(LvItemList) ++ item:item_merge(BreakItemList);
							_ ->
								item_add_lv(ItemCfg, Pet#pet.star)
						end
				end,
	ItemList2 = case ToStar of
					0 ->
						case Sign of
							0 -> get_star_item(PetID, 1); %% 只使用升级卡，返还激活消耗的碎片
							_ -> []
						end;
					_ ->
						case Pet#pet.star >= ToStar of
							?TRUE ->
								%% 已经达到卡片配置星级，返还升星道具
								StarItemList = get_star_item(PetID, ToStar),
								%% 恭喜获得
								item:item_merge(StarItemList);
							_ ->
								%% 卡片道具升星
								item_add_star(ItemCfg, Pet#pet.pet_lv, Sign)
						end
				end,
	guide:check_open_func(?OpenFunc_TargetType_Pet),
	ItemList = ItemList1 ++ ItemList2,
	case ItemList of
		[] -> ok;
		_ ->
			player_item:reward(ItemList, [], [], ?REASON_pet_add_item),
			player_item:show_get_item_dialog(item:item_merge(ItemList), [], [], 0, 4)
	end.

%% 宠物使用道具卡升级
item_add_lv(ItemCfg, OldStar) ->
	#itemCfg{useParam1 = PetID, useParam2 = ToLv, useParam3 = ToStar, useParam4 = ExpItemId} = ItemCfg,
	try
		Pet = get_pet(PetID),
		%% 返还升到当前等级的经验道具
		[{ItemID}] = ExpItemId,
		LvItemList = get_level_item(Pet#pet.pet_lv, ItemID, Pet#pet.pet_exp),

		%% 返还升到当前等级所消耗的突破道具,
		BreakItemList = get_break_item(Pet#pet.break_lv),
		%% 恭喜获得
		ItemList = item:item_merge(LvItemList) ++ item:item_merge(BreakItemList),
		%% 更新宠物信息
		BreakLv1 = get_break(ToLv),
		NewPet = Pet#pet{pet_lv = ToLv, pet_exp = 0, break_lv = BreakLv1},
		%% 判断是否进行道具升星
		case OldStar >= ToStar of
			?TRUE ->
				update_pet(NewPet),
				player:send(#pk_GS2U_PetAddLvRet{pet_id = PetID, err_code = ?ERROR_OK});
			?FALSE ->
				%% 存入进程字典
				PetList = get_pet_list(),
				NewPetList = lists:keystore(NewPet#pet.pet_id, #pet.pet_id, PetList, NewPet),
				set_pet_list(NewPetList)
		end,
		calc_pet_prop(NewPet),
		put_prop(),
		[refresh_skill() || lists:member(PetID, get_out_fight_pet_id_list())],
		attainment:check_attainment(?Attainments_Type_PetLv),
		time_limit_gift:check_open(?TimeLimitType_PetLv),
		seven_gift:check_task(?Seven_Type_PetLv),
%%		player_task:refresh_task(?Task_Goal_PetLv),
		activity_new_player:on_active_condition_change(?SalesActivity_PetAddLv, 1),
		log_pet_op(PetID, 1, lists:concat([Pet#pet.pet_lv, "(", Pet#pet.pet_exp, ")"]), lists:concat([ToLv])),
		ItemList
	catch
		ErrCode -> ErrCode
	end.

%% 宠物使用道具卡升星
item_add_star(ItemCfg, OldLv, Sign) ->
	#itemCfg{useParam1 = PetID, useParam2 = ToLv, useParam3 = ToStar} = ItemCfg,
	try
		Pet = get_pet(PetID),
		%% 返还宠物升到当前星级的消耗道具
		StarItem1 = case Sign of
						0 -> get_star_item(PetID, Pet#pet.star);
						1 -> []
					end,
		NewPet = Pet#pet{star = ToStar},
		%% 更新
		update_pet(NewPet),
		player_push:pet_add_star(player:getPlayerID(), PetID, ToStar), %% 升星公告
		refresh_skill(),
		calc_pet_prop(NewPet),
		put_prop(),
		player_refresh:on_refresh_pet(),
		attainment:check_attainment(?Attainments_Type_PetStar),
		activity_new_player:on_active_condition_change(?SalesActivity_PetAddStar, 1),
		log_pet_op(PetID, 3, Pet#pet.star, ToStar),
		%% 判断是否进行过道具升级
		case OldLv >= ToLv of
			?TRUE -> skip;
			?FALSE ->
				player:send(#pk_GS2U_PetAddLvRet{pet_id = PetID, err_code = ?ERROR_OK})
		end,
		player:send(#pk_GS2U_PetAddStarRet{pet_id = PetID, err_code = ?ERROR_OK}),
		item:item_merge(StarItem1)
	catch
		ErrCode -> player:send(#pk_GS2U_PetAddStarRet{pet_id = PetID, err_code = ErrCode})
	end.

%% 升到指定等级需要消耗的经验道具
get_level_item(Lv, ItemID, Exp1) ->
	ItemExp = case cfg_petExpItem:getRow(ItemID) of
				  {} -> throw(?ERROR_Param);
				  #petExpItemCfg{exp = E1} -> E1
			  end,
	AllExp = get_level_item_1(Lv, 0) + Exp1,
	ItemNum = ceil(AllExp / ItemExp),%% 返还的经验道具数量
	[{ItemID, ItemNum, 1}].
get_level_item_1(1, Ret) -> Ret;
get_level_item_1(Lv, Ret) ->
	%% 获得升到Lv级需要的经验
	Exp = case cfg_petLevel:getRow(Lv - 1) of
			  {} -> 0;
			  #petLevelCfg{exp = E} -> E
		  end,
	get_level_item_1(Lv - 1, Ret + Exp).

%% 获得指定等级下的最大突破等级
get_break(Level) ->
	get_break_1(Level, 0).
get_break_1(Lv, N) ->
	#petBreakCfg{maxLv = MaxLv} = cfg_petBreak:getRow(N),
	case Lv > MaxLv of
		?TRUE -> get_break_1(Lv, N + 1);
		_ -> N
	end.

%% 获得指定突破等级所消耗的所有突破道具
get_break_item(BreakLv) ->
	get_break_item(BreakLv, []).
get_break_item(0, Ret) -> Ret;
get_break_item(BreakLv, Ret) ->
	#petBreakCfg{needItem = NeedItem} = cfg_petBreak:getRow(BreakLv),
	Item = [{X, Y, 1} || {X, Y} <- NeedItem],
	get_break_item(BreakLv - 1, Ret ++ Item).


%% 获得升到指定星级需要的消耗道具
get_star_item(PetID, Star) ->
	get_star_item(PetID, Star, []).

get_star_item(_PetID, 0, Ret) -> Ret;
get_star_item(PetID, Star, Ret) ->
	#petStarCfg{needItem = NeedItem} = cfg_petStar:getRow(PetID, Star),
	Item = [{X, Y, 1} || {X, Y} <- NeedItem],
	get_star_item(PetID, Star - 1, Ret ++ Item).

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Pet) =:= 1 andalso guide:is_open_action(?OpenAction_Pet).

is_func_open_moling() ->
	variable_world:get_value(?WorldVariant_Switch_Moling) =:= 1 andalso guide:is_open_action(?OpenAction_Moling).

is_func_open_pet_eq() ->
	variable_world:get_value(?WorldVariant_Switch_PetEq) =:= 1 andalso guide:is_open_action(?OpenAction_PetEq).

%% attrAdd字段为空则视为需自动开启
auto_open_skill_box(RoleID) ->
	Moling = case get_moling(RoleID) of
				 {} -> #moling{};
				 ML -> ML
			 end,
	F = fun(Index) ->
		IsNotOpen = not is_skill_box_open(RoleID, Index),
		case cfg_petSkillOpen:getRow(Index) of
			#petSkillOpenCfg{attrAdd = []} when IsNotOpen ->
				%% 无需处理错误
				_Err = open_skill_box(RoleID, Index, Moling#moling.lv);
			_ ->
				skip
		end
		end,
	lists:foreach(F, cfg_petSkillOpen:getKeyList()).

calc_pet_cost_list(ExpItemIDList, RestExp) ->
	calc_pet_cost_list(ExpItemIDList, RestExp, []).

calc_pet_cost_list([], _, CostListAcc) ->
	CostListAcc;
calc_pet_cost_list(_, RestExp, CostListAcc) when RestExp =< 0 ->
	CostListAcc;
calc_pet_cost_list([ItemID | ExpItemIDList], RestExp, CostListAcc) ->
	ExpCfg = cfg_petExpItem:getRow(ItemID),
	#petExpItemCfg{exp = UnitExp} = ExpCfg,
	Amount = bag_player:get_item_amount(ItemID),
	case Amount of
		0 ->
			calc_pet_cost_list(ExpItemIDList, RestExp, CostListAcc);
		_ ->
			AllExp = UnitExp * Amount,
			case AllExp >= RestExp of
				?TRUE ->
					UseAmount = ceil(RestExp / UnitExp),
					calc_pet_cost_list(ExpItemIDList, RestExp - UnitExp * UseAmount, [{ItemID, UseAmount} | CostListAcc]);
				?FALSE ->
					calc_pet_cost_list(ExpItemIDList, RestExp - AllExp, [{ItemID, Amount} | CostListAcc])
			end
	end.

calc_ml_cost_list(ExpItemIDList, RestExp) ->
	calc_ml_cost_list(ExpItemIDList, RestExp, []).

calc_ml_cost_list([], _, CostListAcc) ->
	CostListAcc;
calc_ml_cost_list(_, RestExp, CostListAcc) when RestExp =< 0 ->
	CostListAcc;
calc_ml_cost_list([ItemID | ExpItemIDList], RestExp, CostListAcc) ->
	ExpCfg = cfg_petSoulExpItem:getRow(ItemID),
	#petSoulExpItemCfg{exp = UnitExp} = ExpCfg,
	Amount = bag_player:get_item_amount(ItemID),
	case Amount of
		0 ->
			calc_ml_cost_list(ExpItemIDList, RestExp, CostListAcc);
		_ ->
			AllExp = UnitExp * Amount,
			case AllExp >= RestExp of
				?TRUE ->
					UseAmount = ceil(RestExp / UnitExp),
					calc_ml_cost_list(ExpItemIDList, RestExp - UnitExp * UseAmount, [{ItemID, UseAmount} | CostListAcc]);
				?FALSE ->
					calc_ml_cost_list(ExpItemIDList, RestExp - AllExp, [{ItemID, Amount} | CostListAcc])
			end
	end.

to_pk_map_pet(#map_pet{object_id = ObjectId, pet_id = PetId, pet_star = PetStar, pet_grade = 0}) ->
	#pk_map_pet{pet_object_id = ObjectId, pet_id = PetId, pet_star = PetStar};
to_pk_map_pet(#map_pet{object_id = ObjectId, pet_id = PetId, pet_star = PetStar, pet_grade = PetGrade}) ->
	case cfg_petGradeUp:getRow(PetId, PetGrade) of
		#petGradeUpCfg{upID = ShowPetId} ->
			#pk_map_pet{pet_object_id = ObjectId, pet_id = ShowPetId, pet_star = PetStar};
		_ -> #pk_map_pet{pet_object_id = ObjectId, pet_id = PetId, pet_star = PetStar}
	end;
to_pk_map_pet(L) ->
	[to_pk_map_pet(E) || E <- L].