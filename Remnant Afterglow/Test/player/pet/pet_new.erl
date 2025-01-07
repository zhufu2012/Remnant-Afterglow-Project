%%%-------------------------------------------------------------------
%%% @author mozhenxian
%%% @copyright (C) 2022, <double_game>
%%% @doc
%%% 宠物
%%% @end
%%% Created : 02. 7月 2022 16:04
%%%-------------------------------------------------------------------
-module(pet_new).
-author("mozhenxian").

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
-include("id_generator.hrl").
-include("cfg_item.hrl").
-include("log_times_define.hrl").
-include("util.hrl").
-include("recharge_gift_packs.hrl").


-define(STATUS_FREE, 0).
-define(STATUS_FIGHT, 1).
-define(STATUS_ASSIST, 2).

-define(ACTIVE_PET, 59).

%% API
-export([
	on_load/0
	, active_pet/2, on_item_use_add_list/1, on_add_pet_list/2
	, send_all_info/0
	, get_pet/1
	, update_pet/1
	, get_pet_list/0
	, delete_pet/1
	, db_pet2pet/1
	, active_pet/1, active_pet/4, active_pet_event/0
	, get_pet/2
	, get_one_cfg_pet/1
	, get_pet_reach_star/1
	, get_pet_star_num/1
	, is_pet_active/1
	, get_pet_new/1
	, get_count_lv/1
	, get_count/0
	, make_pet_msg/1
	, send_active_attr_info/0
	, check_bounty_task/4
	, get_activate_cache/0]).
-export([get_pet_and_pos_msg/2, check_pet_wash_aptitude_activity_cond/1, get_count_star/1, get_count_sp_lv/1, get_count_type_rare/2, get_count_grade/1,
	get_fight_out_pet_show/1, get_fight_out_pet_show/2, get_pet_star/1, get_pet_cfg_id/1, get_count_rare/1, get_count_pet/1, get_is_star/1, get_count_rare_uniq/1, get_fight_out_pet/2,
	get_pet_cfg_lv_count/2, get_is_star/2, check_pet_star/2, get_count_lv_and_star/2]).
-export([gm_active_pet_star/2, gm_delete_pet/0, get_pet_list_limit/0]).
-export([fix_data_20240118/0, fix_data_20240731/0]).

%% 加载
on_load() -> ?metrics(begin load() end).


send_all_info() ->
	pet_eq_and_star:on_eq_send_online(),
	LimitNum = 200,
	case get_pet_list_limit() of
		[] -> skip;
		PL ->
			Num = length(PL),
			case Num > LimitNum of
				?TRUE ->
					F = fun(_, Acc) ->
						{SendL, LeftL} = common:split(LimitNum, Acc),
						SendL =/= [] andalso player:send(#pk_GS2U_pet_update{pets = [make_pet_msg(P) || P <- SendL]}),
						LeftL
						end,
					lists:foldl(F, PL, lists:seq(1, Num div LimitNum + 1));
				_ ->
					player:send(#pk_GS2U_pet_update{pets = [make_pet_msg(P) || P <- PL]})
			end
	end,
	pet_battle:send_all_pet_attr(),
	pet_battle:sync_to_top(0, ?TRUE),
	ok.

active_pet(_, 0) -> skip;
active_pet(ItemCfg, N) ->
	case ItemCfg#itemCfg.useType =:= ?ACTIVE_PET of
		?TRUE ->
			PetUid = active_pet(ItemCfg),
			add_activate_cache(PetUid),
			active_pet(ItemCfg, N - 1);
		?FALSE ->
			?LOG_ERROR("item ~p not found", [ItemCfg])
	end.

%% List = [{CfgId, Num}]
on_item_use_add_list([]) -> ok;
on_item_use_add_list(List) ->
	_ = [active_pet(cfg_item:getRow(CfgId), Num) || {CfgId, Num} <- List],
	active_pet_event().

%% List = [{PetCfgId, PetStar, Num}]
on_add_pet_list([], _IsReturnGet) -> ok;
on_add_pet_list(List, IsReturnGet) ->
	_ = [common:for(1, Num, fun(_) ->
		Uid = active_pet(PetCfgId, PetStar, 1, IsReturnGet),
		add_activate_cache(Uid)
							end)
		|| {PetCfgId, PetStar, Num} <- List, Num > 0],
	active_pet_event().

add_activate_cache(Uid) ->
	List = get_activate_cache(),
	?PUT(dic_pet_activate_list, [Uid | List]).

get_activate_cache() ->
	?GET(dic_pet_activate_list, []).

erase_activate_cache() ->
	?PUT(dic_pet_activate_list, []).

send_active_attr_info() ->
	List = get_activate_cache(),
	pet_battle:send_pet_attr(?PLAYER_ID, List),
	erase_activate_cache(),
	ok.


%% 激活宠物
active_pet(ItemCfg) ->
	PetLevel = case ItemCfg#itemCfg.useParam2 > 0 of
				   ?TRUE -> ItemCfg#itemCfg.useParam2;
				   ?FALSE -> 1
			   end,
	PetStar = ItemCfg#itemCfg.useParam3,
	PetCfgID = ItemCfg#itemCfg.useParam1,
	active_pet(PetCfgID, PetStar, PetLevel, ?FALSE).
active_pet(PetCfgID, PetStar, PetLevel, IsReturnGet) ->
	PetBase = cfg_petBase:getRow(PetCfgID),
	NewPet = #pet_new{
		uid = id_generator:generate(?ID_TYPE_MY_PET),
		pet_cfg_id = PetCfgID,
		star = PetStar,
		pet_lv = PetLevel,
		grade = PetBase#petBaseCfg.rareType,
		wash = pet_base:get_base_wash_attr(PetCfgID)
	},
	case PetCfgID of %% 火焰幼龙，删除龙蛋假道具
		1290459 ->
			bag_player:delete([{1102147, 1}], ?REASON_Pet_MainTask),
			bag:delete(?BAG_REPOSITORY, [{1102147, 1}], ?REASON_Pet_MainTask);
		_ -> skip
	end,
	update_pet(NewPet),

	pet_atlas:check_get(PetCfgID, PetStar),
	activity_new_player:on_func_open_check(?ActivityOpenType_GetPet, {PetCfgID}),
	case not IsReturnGet andalso PetBase#petBaseCfg.rareType of
		3 ->
			times_log:add_times(?Log_Type_PetSSR, 1),
			activity_new_player:on_active_condition_change(?SalesActivity_LifelongPetSSR, times_log:get_times(?Log_Type_PetSSR)),
			activity_new_player:on_active_condition_change(?SalesActivity_PetSSR, 1);
		_ -> ok
	end,
	case not IsReturnGet andalso PetBase#petBaseCfg.rareType >= 3 andalso PetBase#petBaseCfg.elemType of
		1 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType1SSR, 1);
		2 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType2SSR, 1);
		3 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType3SSR, 1);
		_ -> ok
	end,
	activity_new_player:check_activity_cond_param_record(?SalesActivity_FirstStarPet, PetStar),
	pet_eq_and_star:check_activity_pet_star_cond(PetStar, ?TRUE),
	time_limit_gift:check_open(?TimeLimitType_PetStar, PetStar),
	NewPet#pet_new.uid.
active_pet_event() ->
	player_task:refresh_task([?Task_Goal_PetReachStar, ?Task_Goal_PetStarCount, ?Task_goal_PetActive, ?Task_Goal_PetLv, ?Task_Goal_PetActiveAndFightNum]),
	guide:check_open_func([?OpenFunc_TargetType_Pet, ?OpenFunc_TargetType_GetSpPet, ?OpenFunc_TargetType_PetLvAndStar]),
	time_limit_gift:check_open(?TimeLimitType_PetStarNum),
	time_limit_gift:check_open(?TimeLimitType_PetTypeRareNum),
	recharge_gift_packs:on_open_condition_change([?RechargeGiftPacksCond_PetStar]),
	attainment:check_attainment([?Attainments_Type_SSRHeroCount, ?Attainments_Type_SPHeroCount]).

%% 新增指定星级宠物
gm_active_pet_star(ItemCfgId, Star) ->
	ItemCfg = cfg_item:getRow(ItemCfgId),
	?CHECK_THROW(ItemCfg#itemCfg.useType =:= ?ACTIVE_PET, {pet_item_not_found, ItemCfgId}),
	PetLevel = case ItemCfg#itemCfg.useParam2 > 0 of
				   ?TRUE -> ItemCfg#itemCfg.useParam2;
				   ?FALSE -> 1
			   end,
	PetCfgID = ItemCfg#itemCfg.useParam1,
	case cfg_petStar:getRow(PetCfgID, Star) of
		#petStarCfg{} ->
			PetBase = cfg_petBase:getRow(PetCfgID),
			Pet = #pet_new{
				uid = id_generator:generate(?ID_TYPE_MY_PET),
				pet_cfg_id = PetCfgID,
				star = Star,
				pet_lv = PetLevel,
				grade = PetBase#petBaseCfg.rareType,
				wash = pet_base:get_base_wash_attr(PetCfgID)
			},
			NewPet = Pet#pet_new{},
			update_pet(NewPet),
			pet_atlas:check_get(PetCfgID, Star),
			guide:check_open_func([?OpenFunc_TargetType_Pet, ?OpenFunc_TargetType_GetSpPet, ?OpenFunc_TargetType_PetLvAndStar]),
			pet_battle:send_pet_attr(?PLAYER_ID, NewPet#pet_new.uid),
			recharge_gift_packs:on_open_condition_change([?RechargeGiftPacksCond_PetStar]),
			attainment:check_attainment([?Attainments_Type_SSRHeroCount, ?Attainments_Type_SPHeroCount]),
			player_task:refresh_task([?Task_Goal_PetReachStar, ?Task_Goal_PetStarCount, ?Task_goal_PetActive, ?Task_Goal_PetLv]);
		_ -> skip
	end.

%% 删除宠物
delete_pet([]) -> ok;
delete_pet(PetUidList) ->
	RecordCostPetList = [pet_new:get_pet(Uid1) || Uid1 <- PetUidList],
	PlayerId = player:getPlayerID(),          %% PetUidList亦可
	table_player:delete(db_pet_new, PlayerId, [{PlayerId, Uid} || Uid <- PetUidList]),
	PetList = get_pet_list(),
	DeleteFun = fun(Uid, Ret) -> lists:keydelete(Uid, #pet_new.uid, Ret) end,
	NewPetList = lists:foldl(DeleteFun, PetList, PetUidList),
	set_pet_list(NewPetList),
	%% 需要增加删除宠物的协议
	Msg = #pk_GS2U_pet_delete{delete_uid_list = PetUidList},
	player:send(Msg),
	pet_shengshu:on_pet_delete(RecordCostPetList),
	pet_pos:on_pet_delete(PetUidList).

gm_delete_pet() ->
	FightUidList = pet_pos:get_fight_and_assist_uid_list(),
	AllUidList = [Uid || #pet_new{uid = Uid, been_link_uid = 0, link_uid = 0} <- pet_new:get_pet_list()],
	DeleteUidList2 = lists:foldl(fun(Uid, Acc) ->
		pet_soul:get_pet_link_uid(pet_new:get_pet(Uid)) ++ Acc
								 end, [], FightUidList),
	DeleteUidList = AllUidList -- lists:usort(DeleteUidList2),
	delete_pet(DeleteUidList).

load() ->
	PlayerId = player:getPlayerID(),
	%% 加载所有宠物装备
	pet_eq_and_star:on_eq_load(PlayerId),
	%%	加载所有的宠物
	set_pet_list(load_pet(PlayerId)),
	ok.

load_pet(PlayerId) ->
	DbPetList = table_player:lookup(db_pet_new, PlayerId),
	[db_pet2pet(DbPet) || DbPet <- DbPetList].

get_pet_and_pos_msg(PlayerId, FuncId) ->
	PetList = load_pet(PlayerId),
	PetGuard = pet_shengshu:get_pet_guard(PlayerId),
	PetSharePos = pet_shengshu:get_pet_pos_list(PlayerId),
	PetMsg = [make_pet_msg(P, PetList, PetGuard, PetSharePos) || P <- PetList],
	PosMsg = pet_pos:get_pet_pos_msg(PlayerId, PetList, FuncId),
	{PetMsg, PosMsg}.

get_pet(PlayerId, Uid) ->
	case player:getPlayerID() == PlayerId of
		?TRUE -> get_pet(Uid);
		_ ->
			PetList = table_player:lookup(db_pet_new, PlayerId),
			case lists:keyfind(Uid, #db_pet_new.uid, PetList) of
				#db_pet_new{} = DbPet -> db_pet2pet(DbPet);
				_ -> {}
			end
	end.

get_pet(Uid) ->
	case lists:keyfind(Uid, #pet_new.uid, get_pet_list()) of
		#pet_new{} = P -> P;
		_ -> {}
	end.
get_pet_star(Uid) ->
	case lists:keyfind(Uid, #pet_new.uid, get_pet_list()) of
		#pet_new{star = Star} -> Star;
		_ -> 0
	end.
get_pet_cfg_id(Uid) ->
	case lists:keyfind(Uid, #pet_new.uid, get_pet_list()) of
		#pet_new{pet_cfg_id = C} -> C;
		_ -> 0
	end.
get_one_cfg_pet(PetCfgId) ->
	case lists:keyfind(PetCfgId, #pet_new.pet_cfg_id, get_pet_list()) of
		#pet_new{} = P -> P;
		_ -> {}
	end.

%%判断英雄是否到达对应星级
get_is_star(NeedStar) ->
	lists:any(fun(#pet_new{star = Star}) -> Star >= NeedStar end, get_pet_list()).
get_is_star(0, NeedStar) ->
	get_is_star(NeedStar);
get_is_star(NeedPetCfgID, NeedStar) ->
	lists:any(fun(#pet_new{pet_cfg_id = PetCfgID} = Pet) ->
		case NeedPetCfgID =:= PetCfgID of
			?FALSE -> ?FALSE;
			?TRUE ->
				case pet_soul:link_pet(player:getPlayerID(), Pet) of
					#pet_new{star = Star} when Star >= NeedStar -> ?TRUE;
					_ -> ?FALSE
				end
		end
			  end,
		get_pet_list()).

%%英雄现在达到或者曾经达到过X星及以上，(具体英雄ID , 星级 )  ，配0则表示为任意英雄达到对应星级
check_pet_star(PetCfgId, NeedStar) ->
	case pet_new:get_is_star(PetCfgId, NeedStar) of%%当前英雄就满足条件
		?TRUE -> ?TRUE;
		_ ->%%当前英雄都不满足条件，就检查图鉴中
			case PetCfgId of
				0 ->%%任意英雄
					lists:any(fun(#atlas{max_star = Star}) ->
						Star >= NeedStar end, pet_atlas:get_atlas_list());
				_ ->%%具体英雄
					pet_atlas:get_atlas_max_star(PetCfgId) >= NeedStar
			end
	end.

%%满足对应等级和对应星级的英雄数量
get_count_lv_and_star(NeedLv, NeedStar) ->
	length([1 || #pet_new{pet_lv = Lv, star = Star} <- get_pet_list(), Lv >= NeedLv, Star >= NeedStar]).


update_pet(PetList) when is_list(PetList) ->
	table_player:insert(db_pet_new, [pet2db_pet(Pet) || Pet <- PetList]),
	OldPetList = get_pet_list(),
	NewPetList = lists:foldl(
		fun(Pet, Ret) ->
			lists:keystore(Pet#pet_new.uid, #pet_new.uid, Ret, Pet)
		end, OldPetList, PetList),
	set_pet_list(NewPetList),
	Msg = #pk_GS2U_pet_update{pets = [make_pet_msg(Pet) || Pet <- PetList]},
	player:send(Msg),
	pet_shengshu:on_pet_guard_change();
update_pet(Pet) ->
	table_player:insert(db_pet_new, pet2db_pet(Pet)),
	PetList = get_pet_list(),
	NewPetList = lists:keystore(Pet#pet_new.uid, #pet_new.uid, PetList, Pet),
	set_pet_list(NewPetList),
	Msg = #pk_GS2U_pet_update{pets = [make_pet_msg(Pet)]},
	player:send(Msg),
	pet_shengshu:on_pet_guard_change().

get_pet_list() -> get('pet_new_list').
set_pet_list(List) -> put('pet_new_list', List).
%% 只获得前1000个
get_pet_list_limit() ->
	PetList = get_pet_list(),
	case length(PetList) > 1000 of
		?FALSE -> PetList;
		?TRUE -> lists:sublist(lists:sort(fun sort_pet_fun/2, PetList), 1000)
	end.

db_pet2pet(#db_pet_new{} = DbPet) ->
	#pet_new{
		pet_cfg_id = DbPet#db_pet_new.pet_cfg_id,
		uid = DbPet#db_pet_new.uid,
		pet_lv = DbPet#db_pet_new.pet_lv,
		pet_exp = DbPet#db_pet_new.pet_exp,
		break_lv = DbPet#db_pet_new.break_lv,
		star = DbPet#db_pet_new.star,
		grade = DbPet#db_pet_new.grade,
		fight_flag = DbPet#db_pet_new.fight_flag,
		fight_pos = DbPet#db_pet_new.fight_pos,
		is_auto_skill = DbPet#db_pet_new.is_auto_skill,
		wash = gamedbProc:dbstring_to_term(DbPet#db_pet_new.wash),
		is_lock = DbPet#db_pet_new.is_lock,
		wash_material = gamedbProc:dbstring_to_term(DbPet#db_pet_new.wash_material),
		wash_preview = gamedbProc:dbstring_to_term(DbPet#db_pet_new.wash_preview),
		link_uid = DbPet#db_pet_new.link_uid,
		been_link_uid = DbPet#db_pet_new.been_link_uid,
		appendage_uid = DbPet#db_pet_new.appendage_uid,
		been_appendage_uid = DbPet#db_pet_new.been_appendage_uid,
		get_by_egg = DbPet#db_pet_new.get_by_egg,
		hatch_id = DbPet#db_pet_new.hatch_id,
		shared_flag = DbPet#db_pet_new.shared_flag,
		point = DbPet#db_pet_new.point,
		star_pos = gamedbProc:dbstring_to_term(DbPet#db_pet_new.star_pos),
		sp_lv = DbPet#db_pet_new.sp_lv
	}.

pet2db_pet(#pet_new{} = Pet) ->
	#db_pet_new{
		player_id = player:getPlayerID(),
		uid = Pet#pet_new.uid,
		pet_cfg_id = Pet#pet_new.pet_cfg_id,
		pet_lv = Pet#pet_new.pet_lv,
		pet_exp = Pet#pet_new.pet_exp,
		break_lv = Pet#pet_new.break_lv,
		star = Pet#pet_new.star,
		grade = Pet#pet_new.grade,
		fight_flag = Pet#pet_new.fight_flag,
		fight_pos = Pet#pet_new.fight_pos,
		is_auto_skill = Pet#pet_new.is_auto_skill,
		wash = gamedbProc:term_to_dbstring(Pet#pet_new.wash),
		is_lock = Pet#pet_new.is_lock,
		wash_material = gamedbProc:term_to_dbstring(Pet#pet_new.wash_material),
		wash_preview = gamedbProc:term_to_dbstring(Pet#pet_new.wash_preview),
		link_uid = Pet#pet_new.link_uid,
		been_link_uid = Pet#pet_new.been_link_uid,
		appendage_uid = Pet#pet_new.appendage_uid,
		been_appendage_uid = Pet#pet_new.been_appendage_uid,
		get_by_egg = Pet#pet_new.get_by_egg,
		hatch_id = Pet#pet_new.hatch_id,
		shared_flag = Pet#pet_new.shared_flag,
		point = Pet#pet_new.point,
		star_pos = gamedbProc:term_to_dbstring(Pet#pet_new.star_pos),
		sp_lv = Pet#pet_new.sp_lv
	}.

make_pet_msg(Pet) ->
	make_pet_msg(Pet, pet_new:get_pet_list(), pet_shengshu:get_pet_guard(), pet_shengshu:get_pet_pos_list()).
make_pet_msg(Pet, PetList, PetGuard, PetSharePos) ->
	case Pet#pet_new.link_uid of
		0 ->
			{BeenLinkCfgId, BeenLinkSpLv} = case lists:keyfind(Pet#pet_new.been_link_uid, #pet_new.uid, PetList) of
												#pet_new{pet_cfg_id = BLCfgId, sp_lv = BLSpLv} ->
													{BLCfgId, BLSpLv};
												_ -> {0, 0}
											end,
			#pk_pet_info{
				uid = Pet#pet_new.uid,
				pet_cfg_id = Pet#pet_new.pet_cfg_id,
				pet_lv = pet_shengshu:shared_pet_lv(Pet, PetList, PetGuard, PetSharePos),
				pet_exp = Pet#pet_new.pet_exp,
				break_lv = pet_shengshu:shared_pet_break_lv(Pet, PetList, PetGuard, PetSharePos),
				star = Pet#pet_new.star,
				grade = Pet#pet_new.grade,
				fight_flag = Pet#pet_new.fight_flag,
				fight_pos = Pet#pet_new.fight_pos,
				is_auto_skill = Pet#pet_new.is_auto_skill,
				wash_list = pet_base:make_pk_wash_attr(pet_shengshu:shared_pet_wash(Pet, PetList, PetGuard)),
				is_lock = Pet#pet_new.is_lock,
				wash_preview = pet_base:make_pk_wash_attr(Pet#pet_new.wash_preview),
				wash_material = [#pk_key_value{key = Tid, value = Num} || {Tid, Num} <- Pet#pet_new.wash_material],
				link_uid = Pet#pet_new.link_uid,
				been_link_uid = Pet#pet_new.been_link_uid,
				appendage_uid = Pet#pet_new.appendage_uid,
				been_appendage_uid = Pet#pet_new.been_appendage_uid,
				get_by_egg = Pet#pet_new.get_by_egg,
				hatch_id = Pet#pet_new.hatch_id,
				shared_flag = Pet#pet_new.shared_flag,
				pet_lv_original = pet_shengshu:original_pet_lv(Pet),
				point = Pet#pet_new.point,
				star_pos = [Pos || {Pos, Star} <- Pet#pet_new.star_pos, Star =:= Pet#pet_new.star],
				sp_lv = Pet#pet_new.sp_lv,
				been_link_pet_cfg_id = BeenLinkCfgId,
				been_link_pet_sp_lv = BeenLinkSpLv
			};
		LinkUid ->
			LinkPet = case root_link_pet(LinkUid, PetList) of
						  #pet_new{shared_flag = 0} = P -> P;
						  #pet_new{shared_flag = 1} = P ->
							  P#pet_new{
								  pet_lv = pet_shengshu:shared_pet_lv(P, PetList, PetGuard, PetSharePos),
								  wash = pet_shengshu:shared_pet_wash(P, PetList, PetGuard),
								  break_lv = pet_shengshu:shared_pet_break_lv(P, PetList, PetGuard, PetSharePos)
							  };
						  _ -> {}
					  end,
			{BeenLinkCfgId, BeenLinkSpLv} = case lists:keyfind(Pet#pet_new.been_link_uid, #pet_new.uid, PetList) of
												#pet_new{pet_cfg_id = BLCfgId, sp_lv = BLSpLv} ->
													{BLCfgId, BLSpLv};
												_ -> {0, 0}
											end,
			LinkBaseAttr = pet_base:get_base_wash_attr(LinkPet#pet_new.pet_cfg_id),
			AddWashLit = pet_base:desc_wash_attr(LinkPet#pet_new.wash, LinkBaseAttr),
			PetBaseAttr = pet_base:get_base_wash_attr(Pet#pet_new.pet_cfg_id),
			#pk_pet_info{
				uid = Pet#pet_new.uid,
				pet_cfg_id = Pet#pet_new.pet_cfg_id,
				pet_lv = LinkPet#pet_new.pet_lv,
				pet_exp = LinkPet#pet_new.pet_exp,
				break_lv = LinkPet#pet_new.break_lv,
				star = LinkPet#pet_new.star,
				grade = Pet#pet_new.grade,
				fight_flag = Pet#pet_new.fight_flag,
				fight_pos = Pet#pet_new.fight_pos,
				is_auto_skill = Pet#pet_new.is_auto_skill,
				wash_list = pet_base:make_pk_wash_attr(AddWashLit ++ PetBaseAttr),
				is_lock = Pet#pet_new.is_lock,
				wash_preview = pet_base:make_pk_wash_attr(LinkPet#pet_new.wash_preview),
				wash_material = [#pk_key_value{key = Tid, value = Num} || {Tid, Num} <- LinkPet#pet_new.wash_material],
				link_uid = Pet#pet_new.link_uid,
				been_link_uid = Pet#pet_new.been_link_uid,
				appendage_uid = Pet#pet_new.appendage_uid,
				been_appendage_uid = Pet#pet_new.been_appendage_uid,
				get_by_egg = Pet#pet_new.get_by_egg,
				hatch_id = Pet#pet_new.hatch_id,
				shared_flag = Pet#pet_new.shared_flag,
				pet_lv_original = pet_shengshu:original_pet_lv(Pet),
				point = Pet#pet_new.point,
				star_pos = [Pos || {Pos, Star} <- Pet#pet_new.star_pos, Star =:= Pet#pet_new.star],
				sp_lv = Pet#pet_new.sp_lv,
				been_link_pet_cfg_id = BeenLinkCfgId,
				been_link_pet_sp_lv = BeenLinkSpLv
			}
	end.

root_link_pet(LinkUid, PetList) ->
	case lists:keyfind(LinkUid, #pet_new.uid, PetList) of
		#pet_new{link_uid = 0} = P -> P;
		#pet_new{link_uid = NextLinkUid} ->
			root_link_pet(NextLinkUid, PetList);
		_ -> {}
	end.

%% 某宠物达到的最高星级
get_pet_reach_star(PetCfgId) ->
	PetList = get_pet_list(),
	lists:foldl(fun(#pet_new{pet_cfg_id = Id, star = Star}, Ret) ->
		case Id =:= PetCfgId andalso Star >= Ret of
			?TRUE -> Star;
			_ -> Ret
		end end, 0, PetList).

%% 达到星级要求的宠物种类数量
get_pet_star_num(StarNeed) ->
	PetList = get_pet_list(),
	AllIdList = lists:foldl(fun(#pet_new{pet_cfg_id = Id, star = Star}, Ret) ->
		case Star >= StarNeed of
			?TRUE -> [Id | Ret];
			_ -> Ret
		end end, [], PetList),
	length(lists:usort(AllIdList)).

%% 根据图鉴是否有记录判断是否曾经激活过
is_pet_active(PetID) ->
	case lists:keyfind(PetID, #atlas.atlas_id, pet_atlas:get_atlas_list()) of
		#atlas{} -> ?TRUE;
		_ -> ?FALSE
	end.

%%[{Cfg,Num}] 判断哪些是第一次获得的英雄
get_pet_new(List) ->
	AtlasList = pet_atlas:get_atlas_list(),
	F = fun({CfgId, Num}, {Ret, AtlasAcc}) ->
		case cfg_item:getRow(CfgId) of
			#itemCfg{useParam1 = CfgPetId} ->
				case cfg_petBase:getRow(CfgPetId) of
					#petBaseCfg{} ->
						case lists:keyfind(CfgPetId, #atlas.atlas_id, AtlasAcc) of
							#atlas{} -> {Ret, AtlasAcc};
							_ ->
								{[#pk_key_2value{key = CfgPetId, value1 = Num, value2 = 1} | Ret], [#atlas{atlas_id = CfgPetId} | AtlasAcc]}
						end;
					_ -> {Ret, AtlasAcc}
				end;
			_ -> {Ret, AtlasAcc}
		end end,
	{NewPetList, _} = lists:foldl(F, {[], AtlasList}, List),
	NewPetList.

get_count_lv(Level) ->
	length([1 || #pet_new{pet_lv = P} <- get_pet_list(), P >= Level]).

get_count() ->
	length(get_pet_list()).

get_count_star(Star) ->
	length([1 || #pet_new{star = P} <- get_pet_list(), P >= Star]).

get_count_sp_lv(SpLv) ->
	length([1 || #pet_new{sp_lv = P} <- get_pet_list(), P >= SpLv]).

get_count_type_rare(Type, Rare) ->
	length([1 || #pet_new{pet_cfg_id = CfgID} <- get_pet_list(), (Cfg = cfg_petBase:getRow(CfgID)) =/= {} andalso {Cfg#petBaseCfg.elemType, Cfg#petBaseCfg.rareType} =:= {Type, Rare}]).
%%成就系统-激活X个Y品质的英雄 336
get_count_grade(Grade) ->
	length([1 || #pet_new{grade = P} <- get_pet_list(), Grade =:= P]).

get_count_rare(Rare) ->
	length([1 || #pet_new{pet_cfg_id = CfgID} <- get_pet_list(), (Cfg = cfg_petBase:getRow(CfgID)) =/= {} andalso Cfg#petBaseCfg.rareType =:= Rare]).

get_count_pet(PetCfgID) ->
	length([1 || #pet_new{pet_cfg_id = CfgID} <- get_pet_list(), PetCfgID =:= CfgID]).

get_count_rare_uniq(Rare) ->
	CfgList = common:uniq([CfgID || #pet_new{pet_cfg_id = CfgID} <- get_pet_list()]),
	length([1 || CfgID <- CfgList, (Cfg = cfg_petBase:getRow(CfgID)) =/= {} andalso Cfg#petBaseCfg.rareType =:= Rare]).

%%对应英雄cfgid达到对应等级的数量
get_pet_cfg_lv_count(PetCfgId, Level) ->
	length([1 || #pet_new{pet_cfg_id = CfgId, pet_lv = P} <- get_pet_list(), CfgId =:= PetCfgId, P >= Level]).

%% 赏金任务检查是否可派遣
check_bounty_task(LockUnitList, NeedRare, NeedNum, FightType) ->
	PetList = get_pet_list() -- [get_pet(LockUid) || LockUid <- LockUnitList],
	F = fun(#pet_new{uid = Uid, pet_cfg_id = PetCfgId} = P, {NumAcc, TypeAcc, RetAcc, LastPet}) ->
		case cfg_petBase:getRow(PetCfgId) of
			#petBaseCfg{rareType = Rare, elemType = Type} ->
				case Rare >= NeedRare andalso NumAcc >= 0 of
					?TRUE ->
						case lists:member(Type, TypeAcc) of %% 同时满足星级和类型判断
							?TRUE ->
								{NumAcc - 1, lists:delete(Type, TypeAcc), [P | RetAcc], lists:keydelete(Uid, #pet_new.uid, LastPet)};
							?FALSE ->
								{NumAcc, TypeAcc, RetAcc, LastPet}
						end;
					?FALSE -> {NumAcc, TypeAcc, RetAcc, LastPet}
				end end end,
	{RetNum, RetType, _RetPet, LastPet} = lists:foldl(F, {NeedNum, FightType, [], PetList}, PetList),
	case RetNum =< 0 andalso length(RetType) =:= 0 of
		?TRUE -> ?TRUE;
		_ ->
			F1 = fun(#pet_new{uid = Uid, pet_cfg_id = PetCfgId} = P, {NumAcc, TypeAcc, RetAcc, LastPet1}) ->
				case cfg_petBase:getRow(PetCfgId) of
					#petBaseCfg{elemType = Type} ->
						case lists:member(Type, TypeAcc) of %% 满足类型判断
							?TRUE ->
								{NumAcc - 1, lists:delete(Type, TypeAcc), [P | RetAcc], lists:keydelete(Uid, #pet_new.uid, LastPet1)};

							?FALSE ->
								{NumAcc, TypeAcc, RetAcc, LastPet1}
						end;
					?FALSE -> {NumAcc, TypeAcc, RetAcc, LastPet1}
				end end,
			{RetNum1, RetType1, _RetPet1, _LastPet1} = lists:foldl(F1, {NeedNum, FightType, [], LastPet}, LastPet),
			RetNum1 =< 0 andalso length(RetType1) =:= 0
	end.

check_pet_wash_aptitude_activity_cond(Pet) ->
	PetWashAptitude = pet_battle:calc_pet_wash_aptitude(Pet),
	activity_new_player:check_activity_cond_param_record(?SalesActivity_FirstPetWashAptitude, PetWashAptitude),
	activity_new_player:on_active_condition_change(?SalesActivity_PetWashAptitude, PetWashAptitude),
	time_limit_gift:check_open(?TimeLimitType_PetWashAptitude, PetWashAptitude),
	ok.

%% 用于展示的pet，有功能id为防守阵容（0为正常阵容）
get_fight_out_pet_show(FuncId) ->
	PetList = get_pet_list(),
	PetGuard = pet_shengshu:get_pet_guard(),
	PetSharePos = pet_shengshu:get_pet_pos_list(),
	UidList = case FuncId of
				  0 -> pet_pos:get_fight_uid_list();
				  _ -> pet_pos:get_def_uid_list(FuncId)
			  end,
	lists:foldl(fun(Uid, Ret) ->
		case lists:keyfind(Uid, #pet_new.uid, PetList) of
			#pet_new{} = Pet ->
				PetMsg = make_pet_msg(Pet, PetList, PetGuard, PetSharePos),
				[PetMsg | Ret];
			_ -> Ret
		end end, [], UidList).
get_fight_out_pet_show(PlayerID, FuncId) ->
	case PlayerID =:= player:getPlayerID() of
		?FALSE ->
			{PetMsgList, PosMsgList} = get_pet_and_pos_msg(PlayerID, FuncId),
			lists:foldl(fun(#pk_PetPos{uid = Uid, type = Type, pos = Pos}, Ret) ->
				case Type =:= ?STATUS_FIGHT andalso lists:keyfind(Uid, #pk_pet_info.uid, PetMsgList) of
					#pk_pet_info{} = PetMsg -> [PetMsg#pk_pet_info{fight_pos = Pos} | Ret];
					_ -> Ret
				end end, [], PosMsgList);
		?TRUE ->
			get_fight_out_pet_show(FuncId)
	end.

%% 包含上层链接英雄,比如A->B->C，如果上阵C，则包含ABC,如果上线B，则包含AB
get_fight_out_pet(PlayerID, FuncId) ->
	case PlayerID =:= player:getPlayerID() of
		?FALSE ->
			{PetMsgList, PosMsgList} = get_pet_and_pos_msg(PlayerID, FuncId),
			lists:foldl(fun(#pk_PetPos{uid = Uid, type = Type, pos = Pos}, Ret) ->
				case Type =:= ?STATUS_FIGHT andalso lists:keyfind(Uid, #pk_pet_info.uid, PetMsgList) of
					#pk_pet_info{} = PetMsg ->
						get_fight_out_pet_0(PetMsg#pk_pet_info{fight_pos = Pos}, PetMsgList, Ret);
					_ -> Ret
				end end, [], PosMsgList);
		?TRUE ->
			PetList = get_pet_list(),
			PetGuard = pet_shengshu:get_pet_guard(),
			PetSharePos = pet_shengshu:get_pet_pos_list(),
			UidList = case FuncId of
						  0 -> pet_pos:get_fight_uid_list();
						  _ -> pet_pos:get_def_uid_list(FuncId)
					  end,
			lists:foldl(fun(Uid, Ret) -> get_fight_out_pet_1(Uid, PetList, PetGuard, PetSharePos, Ret) end, [], UidList)
	end.

get_fight_out_pet_0(#pk_pet_info{been_link_uid = 0} = PetMsg, _PetMsgList, Ret) -> [PetMsg | Ret];
get_fight_out_pet_0(#pk_pet_info{been_link_uid = BeenLinkUid} = PetMsg, PetMsgList, Ret) ->
	case lists:keyfind(BeenLinkUid, #pk_pet_info.uid, PetMsgList) of
		?FALSE -> [PetMsg | Ret];
		#pk_pet_info{} = NextPetMsg ->
			get_fight_out_pet_0(NextPetMsg#pk_pet_info{fight_flag = 0, fight_pos = 0}, PetMsgList, [PetMsg | Ret])
	end.

get_fight_out_pet_1(0, _PetList, _PetGuard, _PetSharePos, Ret) -> Ret;
get_fight_out_pet_1(Uid, PetList, PetGuard, PetSharePos, Ret) ->
	case lists:keyfind(Uid, #pet_new.uid, PetList) of
		#pet_new{been_link_uid = BeenLinkUid} = Pet ->
			PetMsg = make_pet_msg(Pet, PetList, PetGuard, PetSharePos),
			get_fight_out_pet_1(BeenLinkUid, PetList, PetGuard, PetSharePos, [PetMsg | Ret]);
		_ -> Ret
	end.


sort_pet_fun(#pet_new{uid = UID1, pet_lv = PetLv1, grade = Grade1, star = Star1, fight_flag = FightFlag1},
	#pet_new{uid = UID2, pet_lv = PetLv2, grade = Grade2, star = Star2, fight_flag = FightFlag2}) ->
	%% 出战>品质>星级>等级>UID小的（获取早）
	{FightFlag1, Grade1, Star1, PetLv1, UID1} > {FightFlag2, Grade2, Star2, PetLv2, UID2}.

fix_data_20240118() ->
	List = get_pet_list(),
	FixPetList = [Pet#pet_new{wash = pet_base:get_base_wash_attr(1290469)} || #pet_new{pet_cfg_id = 1290469, wash = Wash} = Pet <- List, lists:keymember(900, 2, Wash)],
	case FixPetList of
		[] -> ok;
		_ ->
			update_pet(FixPetList)
	end.

fix_data_20240731() ->
	L = [
		{1, [{2100545, 3}]},
		{2, [{2100545, 7}]},
		{3, [{2100543, 1}, {2100545, 9}]},
		{4, [{2100543, 4}, {2100545, 9}]},
		{5, [{2100541, 1}, {2100543, 4}, {2100545, 9}]},
		{6, [{2100541, 2}, {2100543, 4}, {2100545, 9}]},
		{7, [{2100541, 3}, {2100543, 4}, {2100545, 9}]},
		{8, [{2100541, 5}, {2100543, 9}, {2100545, 9}]},
		{9, [{2100541, 8}, {2100543, 14}, {2100545, 9}]},
		{10, [{2100541, 11}, {2100543, 19}, {2100545, 9}]}
	],
	List = get_pet_list(),
	AwardList = lists:foldl(fun(#pet_new{sp_lv = SPLv}, Acc) ->
		case SPLv > 0 of
			?TRUE ->
				case lists:keyfind(SPLv, 1, L) of
					?FALSE -> Acc;
					{_, Award} -> Award ++ Acc
				end;
			?FALSE -> Acc
		end
							end, [], List),
	case AwardList =/= [] of
		?TRUE ->
			Language = player:get_language(),
			mail:send_mail(#mailInfo{
				player_id = player:getPlayerID(),
				title = language:get_server_string("D3_HeroHuiTuiMail_Title1", Language),
				describe = language:get_server_string("D3_HeroHuiTuiMail_Dec1", Language),
				itemList = [#itemInfo{itemID = I, num = N} || {I, N} <- common:listValueMerge(AwardList)],
				attachmentReason = ?REASON_Fix_Data,
				one_key_op = 0
			});
		?FALSE -> skip
	end.