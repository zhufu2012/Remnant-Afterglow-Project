%%%-------------------------------------------------------------------
%%% @author mozhenxian
%%% @copyright (C) 2022, <double_game>
%%% @doc
%%% 宠物升级、洗髓、突破、回退
%%% @end
%%% Created : 02. 7月 2022 16:04
%%%-------------------------------------------------------------------
-module(pet_base).
-author("mozhenxian").
-include("record.hrl").
-include("logger.hrl").
-include("cfg_petLevel.hrl").
-include("netmsgRecords.hrl").
-include("reason.hrl").
-include("cfg_petExpItem.hrl").
-include("error.hrl").
-include("cfg_petBreak.hrl").
-include("cfg_petWash.hrl").
-include("util.hrl").
-include("cfg_petBase.hrl").
-include("player_task_define.hrl").
-include("variable.hrl").
-include("seven_gift_define.hrl").
-include("activity_new.hrl").
-include("cfg_petStar.hrl").
-include("time_limit_gift_define.hrl").
-include("attainment.hrl").
-define(ATTR_TYPE_HP, 25080).
-define(ATTR_TYPE_ATK, 25081).
-define(ATTR_TYPE_DEF, 25082).
-define(ATTR_TYPE_BRE, 25083).

%% 1玩家等级,参数-等级；
%% 2当前宠物等级,参数-等级；
%% 3洗髓满当前所有资质,参数-默认0；
%% 4当前魔宠星级,参数-星级；
-define(BREAK_TYPE_PLAYER_LV, 1).
-define(BREAK_TYPE_PET_LV, 2).
-define(BREAK_TYPE_WASH_FULL, 3).
-define(BREAK_TYPE_PET_STAR, 4).

-define(ALL_TYPE_LIST, [?ATTR_TYPE_HP, ?ATTR_TYPE_ATK, ?ATTR_TYPE_DEF, ?ATTR_TYPE_BRE]).

%% API
-export([
	level_up/2
	, wash_preview/2
	, save_wash_attrs/1
	, make_pk_wash_attr/1
	, break_up/1
	, return_material/1
	, return_material/2
	, return_lv_material/1
	, cancel_wash_attrs/1
	, get_base_wash_attr/1
	, do_return_material/1
	, save_pet_sys_attr_by_uid/1
	, save_pet_sys_attr/0
	, get_pet_sys_attr/0
	, gm_set_break_lv/2
	, refresh_pet_and_skill/1
	, refresh_pet_attr_and_skill/1
	, get_new_lv/3
	, desc_wash_attr/2
	, merge_wash_attr/2
	, save_pet_sys_attr/1
	, log_pet_op/3
	, log_pet_substitution/3
	, log_pet_star/3, total_qualification_point/1, compare_attr/2
	, is_full_wash/1
	, is_lv_limit/1
	, get_link_uid_list/1
	, get_full_wash_num/0
	, pet_cultivation_transfer/2
	, pet_cultivation_replace/2
	, get_alternative_pet_id/1]).
-export([get_been_link_uid_list/2, is_original_pet/1]).
-export([save_pet_sys_attr_flag/0, save_pet_sys_attr_flag/1]).

%% 升级
level_up(Uid, UseItems) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_new{pet_cfg_id = PetCfgId, shared_flag = SharedFlag, pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv} = Pet =
			case pet_new:get_pet(Uid) of
				{} ->
					?LOG_ERROR("uid not find ~p", [Uid]),
					throw(?ERROR_Param);
				P -> P
			end,
		PowerBefore = pet_battle:cal_single_pet_score(Pet),
		?CHECK_THROW(SharedFlag =/= 1, ?ErrorCode_PetShengShu_ForbidUpdate),
		Items = [{1, Id, Num} || #pk_key_value{key = Id, value = Num} <- UseItems],
		MaxLv = check_max_lv_limit(BreakLv, Lv),
		AddExp = item_is_legal(UseItems, 0),
		util:dec_items(Items, ?REASON_pet_add_lv),
		NewExp = Exp + AddExp,
		{NewLv, LeftExp} = get_new_lv(Lv, MaxLv, NewExp),
		NewPet =
			case NewLv > Lv of
				?TRUE -> %% 升级
					NewPet1 = Pet#pet_new{pet_exp = LeftExp, pet_lv = NewLv},
					pet_new:update_pet(NewPet1),
					pet_soul:sync_link_pet(Uid),
					player_task:refresh_task(?Task_Goal_PetLv),
					activity_new_player:check_activity_cond_param_record(?SalesActivity_FirstPetLv, NewLv),
					activity_new_player:on_active_condition_change(?SalesActivity_PetLv, NewLv),
					time_limit_gift:check_open(?TimeLimitType_PetLevel, NewLv),
					NewPet1;
				_ ->
					NewPet2 = Pet#pet_new{pet_exp = NewExp},
					pet_new:update_pet(NewPet2),
					pet_soul:sync_link_pet(Uid),
					NewPet2
			end,
		log_pet_levelup(Pet, Lv, NewLv),
		PowerAfter = pet_battle:cal_single_pet_score(NewPet),
		efun_log:hero_change(1, PetCfgId, Pet, NewPet, PowerBefore, PowerAfter, [{1, Id, Num} || #pk_key_value{key = Id, value = Num} <- UseItems]),
		seven_gift:check_task(?Seven_Type_PetNewLv),
		pet_battle:calc_player_add_fight(),
		save_pet_sys_attr_by_uid(Uid),
		pet_battle:sync_to_top(Uid),
		refresh_pet_attr_and_skill(Uid),
		pet_shengshu:on_pet_guard_change(pet_new:get_pet(Uid)),
		player_task:update_task(?Task_Goal_PetFinishTaskUpLv, {1}),
		case NewLv > Lv of
			?TRUE -> %% 升级
				attainment:check_attainment(?Attainments_Type_PetLv),
				guide:check_open_func([?OpenFunc_TargetType_PetLv, ?OpenFunc_TargetType_Pet, ?OpenFunc_TargetType_PetLvAndStar]),

				player:send(#pk_GS2U_pet_upgrade_ret{ret_code = 0, uid = Uid, flag = 1});
			_ ->
				player:send(#pk_GS2U_pet_upgrade_ret{ret_code = 0, uid = Uid})
		end
	catch
		Error ->
			player:send(#pk_GS2U_pet_upgrade_ret{ret_code = Error, uid = Uid})
	end,
	ok.

get_new_lv(CurLv, MaxLv, LeftExp) ->
	#petLevelCfg{exp = NeedExp} = cfg_petLevel:getRow(CurLv),
	case CurLv >= MaxLv of
		?TRUE -> {CurLv, LeftExp};
		_ ->
			case LeftExp >= NeedExp of
				?TRUE ->
					get_new_lv(CurLv + 1, MaxLv, LeftExp - NeedExp);
				_ -> {CurLv, LeftExp}
			end
	end.

%% 洗髓预览
wash_preview(Uid, Times) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_wash_func_open(), ?ERROR_FunctionClose),
		lists:member(Times, [1, 3]) == ?FALSE andalso throw(?ERROR_Param),
		#pet_new{shared_flag = SharedFlag, pet_cfg_id = PetCfgId, break_lv = BreakLv, wash_material = WashMaterial, wash = Wash} = Pet =
			case pet_new:get_pet(Uid) of
				{} ->
					?LOG_ERROR("uid not find ~p", [Uid]),
					throw(?ERROR_Param);
				P -> P
			end,
		?CHECK_THROW(SharedFlag =/= 1, ?ErrorCode_PetShengShu_ForbidUpdate),
		#petWashCfg{washNum = NumList, needItem = NeedItems} = Cfg = cfg_petWash:getRow(BreakLv),
		FullAttr = get_full_wash_attr(Wash, BreakLv, PetCfgId), %% 获取已满的资质
		Items = util:make_items(NeedItems, Times),
		util:check_itmes(Items),
		AddList = merge_wash_attr([], get_wash_attr(NumList, Cfg, Times, [], FullAttr)),
		#petBreakCfg{waskQualiLimit = WashLimit} = cfg_petBreak:getRow(BreakLv),
		Base = pet_base:get_base_wash_attr(PetCfgId),
		NewWashLimit = merge_wash_attr(Base, WashLimit),
		NewWash = [{Type, min(Value, get_max_by_type(Type, NewWashLimit))} || {Type, Value} <- merge_wash_attr(Wash, AddList)],
		RealAddList = compare_attr(Wash, NewWash),
		util:dec_items(Items, ?REASON_pet_wash),
		NewWashMaterial = merge_item([{Tid, Num} || {_, Tid, Num} <- Items], WashMaterial),
		pet_new:update_pet(Pet#pet_new{wash_material = NewWashMaterial, wash_preview = RealAddList}),
		log_pet_wash(Uid, Times, Base),
		player_task:update_task(?Task_Goal_PetWashTime, {Times}),
		player:send(#pk_GS2U_pet_wash_preview_ret{add_attr_list = make_pk_wash_attr(RealAddList), uid = Uid})
	catch
		E -> player:send(#pk_GS2U_pet_wash_preview_ret{ret_code = E, uid = Uid})
	end,
	ok.

%% 保存洗髓属性
save_wash_attrs(Uid) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_wash_func_open(), ?ERROR_FunctionClose),
		#pet_new{wash = Wash, break_lv = BreakLv, pet_cfg_id = PetCfgId, wash_preview = AddAttrList} = Pet = pet_new:get_pet(Uid),
		PowerBefore = pet_battle:cal_single_pet_score(Pet),
		?IF(AddAttrList == [], throw(?ERROR_Param), skip),
		Base = pet_base:get_base_wash_attr(PetCfgId),
		#petBreakCfg{waskQualiLimit = WashLimit} = cfg_petBreak:getRow(BreakLv),
		NewWashLimit = merge_wash_attr(Base, WashLimit),
		NewWash = [{Type, min(Value, get_max_by_type(Type, NewWashLimit))} || {Type, Value} <- merge_wash_attr(Wash, AddAttrList)],
		NewPet = Pet#pet_new{wash = NewWash, wash_preview = []},
		pet_new:update_pet(NewPet),
		pet_soul:sync_link_pet(Uid),
		pet_battle:calc_player_add_fight(),
		save_pet_sys_attr_by_uid(Uid),
		pet_battle:set_send_attr_flag(?FALSE),
		player_refresh:on_refresh_pet_attr(?FALSE),
		pet_battle:sync_to_top(Uid),
		pet_battle:set_send_attr_flag(?TRUE),
		pet_battle:send_pet_attr(?PLAYER_ID, Uid),
		pet_shengshu:on_pet_guard_change(pet_new:get_pet(Uid)),
		player:send(#pk_GS2U_pet_wash_save_ret{uid = Uid, ret_code = 0}),
		PowerAfter = pet_battle:cal_single_pet_score(NewPet),
		efun_log:hero_change(2, PetCfgId, Pet, NewPet, PowerBefore, PowerAfter, []),
		player_task:refresh_task(?Task_Goal_PetWashFull),%%任意英雄完成 x 次四个资质洗髓达到满资质
		pet_new:check_pet_wash_aptitude_activity_cond(NewPet),
		ok
	catch
		E -> player:send(#pk_GS2U_pet_wash_save_ret{uid = Uid, ret_code = E})
	end,
	ok.

cancel_wash_attrs(Uid) ->
	#pet_new{} = Pet = pet_new:get_pet(Uid),
	pet_new:update_pet(Pet#pet_new{wash_preview = []}),
	player:send(#pk_GS2U_pet_wash_save_ret{uid = Uid, ret_code = 0}),
	ok.
%%养成转移
pet_cultivation_transfer(Uid, TargetUid) ->
	try
		?CHECK_THROW(variable_world:get_value(?WorldVariant_Switch_PetCultivationTransfer) =:= 1 andalso guide:is_open_action(?OpenAction_PetCultivationTransfer), ?ERROR_FunctionClose),
		Pet = pet_new:get_pet(Uid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetEqAndStar_CostPetNo),
		TargetPet = pet_new:get_pet(TargetUid),
		?CHECK_THROW(TargetPet =/= {}, ?ErrorCode_PetEqAndStar_CostPetNo),
		?CHECK_THROW(TargetPet#pet_new.shared_flag =/= 1, ?ErrorCode_Pet_OnShengShu),
		?CHECK_THROW(not pet_soul:check_is_soul(TargetPet), ?ErrorCode_Pet_SoulCultivation),
		?CHECK_THROW(not is_original_pet(Pet), ?ErrorCode_Pet_NoCultivation),
		?CHECK_THROW(is_original_pet(TargetPet), ?ErrorCode_Pet_NOT_Orig),
		#pet_new{pet_cfg_id = PetCfgId, pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv, wash = Wash, wash_material = WashMaterial, wash_preview = WashPreview} = Pet,
		Cfg = cfg_petBreak:getRow(BreakLv),
		?CHECK_CFG(Cfg),
		DecErr = currency:delete([Cfg#petBreakCfg.consume], ?REASON_pet_cultivation_transfer),
		?ERROR_CHECK_THROW(DecErr),
		PetBaseWash = pet_base:get_base_wash_attr(PetCfgId),
		NewWashLimit = merge_wash_attr(PetBaseWash, Cfg#petBreakCfg.waskQualiLimit),
		MergeWash = [{Type, min(Value, get_max_by_type(Type, NewWashLimit))} || {Type, Value} <- merge_wash_attr(Wash, WashPreview)],
		AddWash = pet_base:compare_attr(PetBaseWash, MergeWash),
		TargetPetBaseWash = pet_base:get_base_wash_attr(TargetPet#pet_new.pet_cfg_id),
		NewWash = pet_base:merge_wash_attr(TargetPetBaseWash, AddWash),
		NewPet = Pet#pet_new{pet_lv = 1, break_lv = 0, wash_material = [], wash_preview = [], pet_exp = 0, wash = get_base_wash_attr(PetCfgId)},
		NewTargetPet = TargetPet#pet_new{pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv, wash = NewWash, wash_material = WashMaterial},
		pet_new:update_pet([NewPet, NewTargetPet]),
		pet_shengshu:update_pet_point(NewPet),
		pet_soul:sync_link_pet(Uid),
		pet_soul:sync_link_pet(TargetUid),
		pet_battle:calc_player_add_fight(),
		save_pet_sys_attr_by_uid([Uid, TargetUid]),
		refresh_pet_and_skill([Uid, TargetUid]),
		pet_shengshu:on_pet_guard_change([NewPet, NewTargetPet]),
		player:send(#pk_GS2U_pet_cultivation_transfer_ret{uid = Uid, target_uid = TargetUid, err_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_cultivation_transfer_ret{uid = Uid, target_uid = TargetUid, err_code = Err})
	end.

%%养成替换，Uid(被替换英雄)<->TargetUid(替换英雄)
%%1.高等级<->低等级，并且替换英雄等级<=n级才显示
%%2.入驻圣树不能养成替换
%%3.UR英雄不能养成替换
%%4.如果替换英雄没有等级，将被替换英雄的等级等 转移到替换英雄上
%%5.如果替换英雄有等级，需要将等级回退掉，获得养成材料，然后将被替换英雄的等级等 转移到替换英雄上
pet_cultivation_replace(Uid, TargetUid) ->
	OrgPet = pet_new:get_pet(Uid),
	OrgTargetPet = pet_new:get_pet(TargetUid),
	try
		PlayerID = player:getPlayerID(),
		{Pet, TargetPet1, ExtraUidList} = case {pet_soul:check_is_soul(OrgPet), pet_soul:check_is_soul(OrgTargetPet)} of
											  {?TRUE, ?TRUE} ->%%双方都是UR英雄
												  case pet_soul:link_pet(PlayerID, OrgPet) of
													  #pet_new{uid = Uid} ->
														  throw(?ErrorCode_Pet_SoulCultivationReplace1); %% UR没有连接 不能替换
													  LinkPet ->
														  case pet_soul:link_pet(PlayerID, OrgTargetPet) of
															  #pet_new{uid = TargetUid} ->
																  throw(?ErrorCode_Pet_SoulCultivationReplace1); %% UR没有连接 不能替换
															  LinkTargetPet ->
																  {LinkPet, LinkTargetPet, pet_soul:get_pet_link_uid(LinkPet) ++ pet_soul:get_pet_link_uid(LinkTargetPet)}
														  end
												  end;
											  {?TRUE, ?FALSE} ->
												  case pet_soul:link_pet(PlayerID, OrgPet) of
													  #pet_new{uid = Uid} ->
														  throw(?ErrorCode_Pet_SoulCultivationReplace1); %% UR没有连接 不能替换
													  LinkPet ->
														  {LinkPet, OrgTargetPet, lists:usort(pet_soul:get_pet_link_uid(LinkPet))} %%  LinkPet 交换 OrgTargetPet
												  end;
											  {?FALSE, ?TRUE} ->
%%												  throw(?ErrorCode_Pet_SoulCultivationReplace2);
												  case pet_soul:link_pet(PlayerID, OrgTargetPet) of
													  #pet_new{uid = TargetUid} ->
														  throw(?ErrorCode_Pet_SoulCultivationReplace1); %% UR没有连接 不能替换
													  LinkPet ->
														  {OrgPet, LinkPet, lists:usort(pet_soul:get_pet_link_uid(LinkPet))} %%   OrgPet 交换  LinkPet
												  end;
											  {?FALSE, ?FALSE} -> {OrgPet, OrgTargetPet, []} %% 之前逻辑
										  end,
		?CHECK_THROW(Pet#pet_new.pet_lv > TargetPet1#pet_new.pet_lv, ?ErrorCode_Pet_CultivationReplaceLv),%%高等级<->低等级
		?CHECK_THROW(TargetPet1#pet_new.pet_lv =< cfg_globalSetup:heroReplaceCondition(), ?ErrorCode_Pet_CultivationReplaceLvUpperLimit),%%替换英雄等级<=n级
		#pet_new{pet_cfg_id = PetCfgId, pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv, wash = Wash, wash_material = WashMaterial, wash_preview = WashPreview} = Pet,
		Cfg = cfg_petBreak:getRow(BreakLv),
		?CHECK_CFG(Cfg),
		TargetPet = case TargetPet1#pet_new.shared_flag =:= 1 of
						?TRUE ->
							pet_shengshu:on_pet_remove(TargetPet1#pet_new.uid),
							pet_new:get_pet(TargetPet1#pet_new.uid);
						?FALSE -> TargetPet1
					end,
		PetBaseWash = pet_base:get_base_wash_attr(PetCfgId),%%被替换英雄的基础资质
		NewWashLimit = merge_wash_attr(PetBaseWash, Cfg#petBreakCfg.waskQualiLimit),%%替换英雄，新的资质限制
		MergeWash = [{Type, min(Value, get_max_by_type(Type, NewWashLimit))} || {Type, Value} <- merge_wash_attr(Wash, WashPreview)],
		AddWash = pet_base:compare_attr(PetBaseWash, MergeWash),
		TargetPetBaseWash = pet_base:get_base_wash_attr(TargetPet#pet_new.pet_cfg_id),%%替换英雄的基础资质
		NewWash = merge_wash_attr(TargetPetBaseWash, AddWash),%%新英雄的资质
		NewPet = Pet#pet_new{pet_lv = 1, break_lv = 0, wash_material = [], wash_preview = [], pet_exp = 0, wash = get_base_wash_attr(PetCfgId)},
		NewTargetPet = TargetPet#pet_new{pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv, wash = NewWash, wash_material = WashMaterial},
		ReturnItemList = case is_original_pet(TargetPet) of
							 ?FALSE -> do_return_material(TargetPet#pet_new.uid);%%回退材料
							 ?TRUE -> []
						 end,
		pet_new:update_pet([NewPet, NewTargetPet]),
		player:send(#pk_GS2U_pet_update{pets = [pet_new:make_pet_msg(pet_new:get_pet(PetUid)) || PetUid <- ExtraUidList]}),
		{?ERROR_OK, ReturnItemList, [NewPet#pet_new.uid, NewTargetPet#pet_new.uid] ++ ExtraUidList, ExtraUidList}
	catch
		Err -> {Err, [], [], []}
	end.
%% 宠物是否是初始养成
is_original_pet(#pet_new{pet_lv = 1, pet_exp = 0, break_lv = 0, wash_material = [], wash_preview = []}) ->
	?TRUE;
is_original_pet(_) -> ?FALSE.

%% 突破
break_up(Uid) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_new{pet_lv = Lv, pet_exp = Exp, break_lv = BreakLv} = Pet = pet_new:get_pet(Uid),
		NewBreakLv = BreakLv + 1,
		MaxLv = get_lv_limit(NewBreakLv),
		{NewLv, NewExp} = get_new_lv(Lv, MaxLv, Exp),
		#petBreakCfg{needItem = NeedItem, condition = Condition} = cfg_petBreak:getRow(BreakLv),
		check_condition(Condition, Pet),
		util:dec_items(util:make_items(NeedItem), ?REASON_pet_break),
		NewPet = Pet#pet_new{pet_lv = NewLv, pet_exp = NewExp, break_lv = NewBreakLv},
		pet_new:update_pet(NewPet),
		pet_soul:sync_link_pet(Uid),
		pet_battle:sync_to_top(Uid),
		player_refresh:on_refresh_pet_attr(?FALSE),
		save_pet_sys_attr_by_uid(Uid),
		pet_battle:send_pet_attr(?PLAYER_ID, [Uid]),
		player:send(#pk_GS2U_pet_break_up_ret{ret_code = 0, uid = Uid}),
		player_task:update_task(?Task_Goal_PetBreakUp, {1}),
		log_pet_break(Pet, BreakLv, NewBreakLv),
		ok
	catch
		E -> player:send(#pk_GS2U_pet_break_up_ret{ret_code = E, uid = Uid})
	end,
	ok.


%% 回退
%% 1、回退等级经验消耗道具 2、回退突破消耗道具 3、回退洗髓消耗道具
return_material(MaybeUidList) ->
	return_material(MaybeUidList, 1).
return_material(MaybeUidList, Type) ->
	try
		PetList = [Pet || Uid <- MaybeUidList, (Pet = pet_new:get_pet(Uid)) =/= {}],
		UidList = [Pet#pet_new.uid || Pet <- PetList],
		F = fun(Uid) ->
			do_return_material(Uid)
			end,
		ReturnItems = lists:flatten(lists:map(F, UidList)),
		reset_pets(UidList),
		ReturnItems =/= [] andalso util:add_items(ReturnItems, ?REASON_pet_return),
		pet_battle:send_pet_attr(?PLAYER_ID, UidList),
		pet_shengshu:on_pet_guard_change(PetList),
		pet_battle:calc_player_add_fight(),
		save_pet_sys_attr_by_uid(UidList),
		refresh_pet_and_skill(UidList),
		log_pet_return(PetList),
		player:send(#pk_GS2U_return_pet_material_ret{uid_list = UidList, item_list = [#pk_key_value{key = Tid, value = Num} || {Tid, Num} <- ReturnItems], ispop = Type, ret_code = 0})
	catch
		E -> player:send(#pk_GS2U_return_pet_material_ret{ret_code = E, ispop = Type})
	end,
	ok.

save_pet_sys_attr_by_uid(UidList) when is_list(UidList) ->
	FightUidList = pet_pos:get_fight_and_assist_uid_list(),
	LinkUidList = get_link_uid_list(FightUidList),
	BLinkUidList = get_been_link_uid_list(FightUidList),
	case lists:any(fun(Uid) -> lists:member(Uid, BLinkUidList ++ LinkUidList ++ FightUidList) end, UidList) of
		?TRUE ->
			save_pet_sys_attr(?FALSE),
			?TRUE;
		_ -> ?FALSE
	end;
save_pet_sys_attr_by_uid(Uid) ->
	FightUidList = pet_pos:get_fight_and_assist_uid_list(),
	LinkUidList = get_link_uid_list(FightUidList),
	BLinkUidList = get_been_link_uid_list(FightUidList),
	case lists:member(Uid, BLinkUidList ++ LinkUidList ++ FightUidList) of
		?TRUE ->
			save_pet_sys_attr(?FALSE),
			?TRUE;
		_ -> ?FALSE
	end.
save_pet_sys_attr() ->
	save_pet_sys_attr(?FALSE).
save_pet_sys_attr(IsOnline) ->
	case save_pet_sys_attr_flag() of
		?TRUE ->
			Attr = attribute:base_prop_from_list(pet_battle:get_player_add_attr(player:getPlayerID())),
			put(pet_sys_attr, Attr),
			IsOnline orelse attribute_player:on_prop_change();
		?FALSE ->
			ok
	end.

get_pet_sys_attr() ->
	case get(pet_sys_attr) of
		?UNDEFINED -> [];
		Attr -> Attr
	end.

save_pet_sys_attr_flag() -> ?P_DIC_GET(?TRUE).
save_pet_sys_attr_flag(Flag) -> ?P_DIC_PUT(Flag).

get_link_uid_list([]) -> [];
get_link_uid_list([Uid | UidList]) ->
	case pet_new:get_pet(Uid) of
		#pet_new{link_uid = LinkUid} when LinkUid > 0 ->
			[LinkUid | get_link_uid_list([LinkUid | UidList])];
		_ -> get_link_uid_list(UidList)
	end.

get_been_link_uid_list([]) -> [];
get_been_link_uid_list([Uid | UidList]) ->
	case pet_new:get_pet(Uid) of
		#pet_new{been_link_uid = BLinkUid} when BLinkUid > 0 ->
			[BLinkUid | get_been_link_uid_list([BLinkUid | UidList])];
		_ -> get_been_link_uid_list(UidList)
	end.
get_been_link_uid_list(PlayerID, []) -> [];
get_been_link_uid_list(PlayerID, [Uid | UidList]) ->
	case pet_new:get_pet(PlayerID, Uid) of
		#pet_new{been_link_uid = BLinkUid} when BLinkUid > 0 ->
			[BLinkUid | get_been_link_uid_list(PlayerID, [BLinkUid | UidList])];
		_ -> get_been_link_uid_list(PlayerID, UidList)
	end.

%% 刷新宠物(包括属性)和宠物技能
refresh_pet_and_skill(PetUidList) ->
	%% 出战
	FightUidList = pet_pos:get_fight_uid_list(),
	%% 援战
	AidUidList = pet_pos:get_aid_uid_list(),
	%% 需要刷新的UID
	NeedRefreshList = common:uniq(get_been_link_uid_list(PetUidList) ++ PetUidList),
	{FightRefresh, NotFightRefresh} = lists:partition(fun(Uid) -> lists:member(Uid, FightUidList) end, NeedRefreshList),
	case FightRefresh =/= [] orelse lists:any(fun(Uid) -> lists:member(Uid, AidUidList) end, NotFightRefresh) of
		?TRUE ->
			player_refresh:on_refresh_pet(),
			player_refresh:on_refresh_pet_attr(?FALSE),
			player_refresh:on_refresh_pet_skill(),
			pet_battle:sync_to_top(0, ?TRUE);
		?FALSE -> ok
	end,
	case NotFightRefresh =/= [] of
		?TRUE ->
			AssistPetIds = pet_battle:get_assist_pet_uid_list(?PLAYER_ID),
			case lists:any(fun(PetUid) -> lists:member(PetUid, AssistPetIds) end, NotFightRefresh) of
				?TRUE -> pet_battle:sync_to_top(0, ?TRUE);
				_ -> skip
			end,
			pet_battle:get_send_attr_flag() andalso pet_battle:send_pet_attr(?PLAYER_ID, NotFightRefresh);
		?FALSE -> ok
	end.
%% 只刷新宠物技能和宠物属性
refresh_pet_attr_and_skill(PetUid) ->
	%% 出战
	FightUidList = pet_pos:get_fight_uid_list(),
	%% 援战
	AidUidList = pet_pos:get_aid_uid_list(),
	NeedRefreshList = common:uniq([PetUid | get_been_link_uid_list([PetUid])]),
	{FightRefresh, NotFightRefresh} = lists:partition(fun(Uid) -> lists:member(Uid, FightUidList) end, NeedRefreshList),
	case FightRefresh =/= [] orelse lists:any(fun(Uid) -> lists:member(Uid, AidUidList) end, NotFightRefresh) of
		?TRUE ->
			player_refresh:on_refresh_pet_attr(?FALSE),
			player_refresh:on_refresh_pet_skill();
		?FALSE -> ok
	end,
	case NotFightRefresh =/= [] of
		?TRUE -> pet_battle:send_pet_attr(?PLAYER_ID, NotFightRefresh);
		?FALSE -> ok
	end.

%% 资质是否达到当前上限
is_full_wash(#pet_new{pet_cfg_id = PetCfgId, wash = Wash, break_lv = BreakLv}) ->
	#petBaseCfg{qualBase = BaseWash} = cfg_petBase:getRow(PetCfgId),
	#petBreakCfg{waskQualiLimit = LimitList} = cfg_petBreak:getRow(BreakLv),
	F = fun({Type, Value}, Ret) ->
		NewValue = dec_base(Type, Value, BaseWash),
		case lists:keyfind(Type, 1, LimitList) of
			{_, MaxValue} when NewValue >= MaxValue -> Ret;
			_ -> ?FALSE
		end end,
	lists:foldl(F, ?TRUE, Wash).

is_lv_limit(#pet_new{pet_lv = Lv, break_lv = BreakLv}) ->
	#petBreakCfg{maxLv = MaxLv} = cfg_petBreak:getRow(BreakLv),
	Lv >= MaxLv.
%% ================================= lib ==================================
get_base_wash_attr(PetCfgId) ->
	#petBaseCfg{qualBase = Base} = cfg_petBase:getRow(PetCfgId),
	Base.

check_condition(ConditionList, Pet) ->
	lists:all(fun check_break_condition/1, [{Con, Pet} || Con <- ConditionList]) == ?FALSE andalso throw(?ErrorCode_Pet_NOT_MATCH).

%% 条件类型：
%% 1玩家等级,参数-等级；
%% 2当前宠物等级,参数-等级；
%% 3洗髓满当前所有资质,参数-默认0；
%% 4当前魔宠星级,参数-星级；
check_break_condition({{?BREAK_TYPE_PLAYER_LV, CfgValue}, #pet_new{}}) ->
	#player{level = PlayerLv} = player:getPlayerRecord(),
	PlayerLv >= CfgValue;
check_break_condition({{?BREAK_TYPE_PET_LV, CfgValue}, #pet_new{pet_lv = PetLv}}) ->
	PetLv >= CfgValue;
check_break_condition({{?BREAK_TYPE_WASH_FULL, _CfgValue}, #pet_new{break_lv = BreakLv, wash = Wash}}) ->
	#petBreakCfg{waskQualiLimit = LimitList} = cfg_petBreak:getRow(BreakLv),
	F = fun({Type, Value}) ->
		case lists:keyfind(Type, 1, LimitList) of
			{_, MaxValue} -> Value >= MaxValue;
			_ -> ?FALSE
		end
		end,
	lists:all(F, Wash);
check_break_condition({{?BREAK_TYPE_PET_STAR, CfgValue}, #pet_new{star = PetStar}}) ->
	PetStar >= CfgValue.

get_full_wash_attr(Wash, BreakLv, PetCfgId) ->
	#petBaseCfg{qualBase = BaseWash} = cfg_petBase:getRow(PetCfgId),
	#petBreakCfg{waskQualiLimit = LimitList} = cfg_petBreak:getRow(BreakLv),
	F = fun({Type, Value}, Acc) ->
		NewValue = dec_base(Type, Value, BaseWash),
		case lists:keyfind(Type, 1, LimitList) of
			{_, MaxValue} when NewValue >= MaxValue ->
				[Type | Acc];
			_ -> Acc
		end
		end,
	lists:foldl(F, [], Wash).

dec_base(Type, Value, BaseWash) ->
	case lists:keyfind(Type, 1, BaseWash) of
		{_, B} -> Value - B;
		_ -> Value
	end.

%%获取满资质的英雄的数量
get_full_wash_num() ->
	L = [{PetCfgId, BreakLv, WashList} || #pet_new{wash = WashList, break_lv = BreakLv, pet_cfg_id = PetCfgId} <- pet_new:get_pet_list()],
	Fun = fun({PetCfg, Break, Wash}, Num) ->
		#petBaseCfg{qualBase = BaseWash} = cfg_petBase:getRow(PetCfg),
		#petBreakCfg{waskQualiLimit = LimitList} = cfg_petBreak:getRow(Break),
		F = fun({Type, Value}) ->
			NewValue = dec_base(Type, Value, BaseWash),
			case lists:keyfind(Type, 1, LimitList) of
				{_, MaxValue} when NewValue >= MaxValue ->
					?TRUE;
				_ -> ?FALSE
			end
			end,
		case lists:all(F, Wash) of
			?TRUE -> Num + 1;
			?FALSE -> Num
		end
		  end,
	lists:foldl(Fun, 0, L).

get_max_by_type(Type, WashLimit) ->
	{_, V} = lists:keyfind(Type, 1, WashLimit),
	V.

compare_attr(Old, New) ->
	listValueSub(common:listValueMerge(New), common:listValueMerge(Old)).

listValueSub(TupleList, [{Key, DecValue} | DecTupleList]) ->
	case lists:keyfind(Key, 1, TupleList) of
		{_, NewValue} ->
			AddValue = NewValue - DecValue,
			NewTupleList = lists:keyreplace(Key, 1, TupleList, {Key, AddValue}),
			listValueSub(NewTupleList, DecTupleList);
		?FALSE ->
			listValueSub(TupleList, DecTupleList)
	end;
listValueSub(TupleList, []) ->
	TupleList.


get_wash_attr(_, _, 0, Acc, _) -> Acc;
get_wash_attr(NumList, Cfg, AccNum, Acc, FullAttr) ->
	%% 按权重随机洗髓条数
	{Total, WeightList} = util:restruct_weight_list(NumList),
	[Num] = util:get_rand_n(Total, WeightList, 1),
	%% 确认要洗髓的资质类型
	AttrIdList = util:rand_list_n(Num, ?ALL_TYPE_LIST -- FullAttr),
	%% 获取每种选中资质洗髓 随机增加值
	AddList = get_wash_add_value(AttrIdList, Cfg),
	get_wash_attr(NumList, Cfg, AccNum - 1, AddList ++ Acc, FullAttr).

make_pk_wash_attr(L) ->
	[#pk_wash_value{type = Type, value = Value} || {Type, Value} <- L].


merge_wash_attr(Wash, AddList) ->
	F = fun({Type, Value}, Acc) ->
		case lists:keyfind(Type, 1, Acc) of
			{_, OldValue} -> lists:keyreplace(Type, 1, Acc, {Type, OldValue + Value});
			_ -> [{Type, Value} | Acc]
		end
		end,
	lists:foldl(F, Wash, AddList).

get_wash_add_value(AttrIdList, Cfg) ->
	F = fun(Type) ->
		L = make_weight_cfg(get_cfg_by_attr_type(Type, Cfg)),
		{Sum, WeightList} = util:restruct_weight_list([{Id, W} || {Id, W, _, _} <- L]),
		[SelectId] = util:get_rand_n(Sum, WeightList, 1),
		{_, _, Min, Max} = lists:keyfind(SelectId, 1, L),
		{Type, util:rand(Min, Max)}
		end,
	lists:map(F, AttrIdList).

make_weight_cfg(List) ->
	F = fun({W, Min, Max}, AccId) ->
		{{AccId, W, Min, Max}, AccId + 1}
		end,
	{Ret, _} = lists:mapfoldl(F, 1, List),
	Ret.
get_cfg_by_attr_type(?ATTR_TYPE_HP, Cfg) -> Cfg#petWashCfg.hpRange;
get_cfg_by_attr_type(?ATTR_TYPE_ATK, Cfg) -> Cfg#petWashCfg.attRange;
get_cfg_by_attr_type(?ATTR_TYPE_DEF, Cfg) -> Cfg#petWashCfg.defRange;
get_cfg_by_attr_type(?ATTR_TYPE_BRE, Cfg) -> Cfg#petWashCfg.breRange.


check_max_lv_limit(BreakLv, CurLv) ->
	#petBreakCfg{maxLv = MaxLv} = cfg_petBreak:getRow(BreakLv),
	CurLv >= MaxLv andalso throw(?ErrorCode_Pet_TouchMaxLv),
	MaxLv.

get_lv_limit(BreakLv) ->
	#petBreakCfg{maxLv = MaxLv} = cfg_petBreak:getRow(BreakLv),
	MaxLv.

item_is_legal([], Exp) -> Exp;
item_is_legal([#pk_key_value{key = ItemId, value = Num} | L], AccExp) ->
	case cfg_petExpItem:getRow(ItemId) of
		#petExpItemCfg{exp = Exp} ->
			item_is_legal(L, AccExp + Exp * Num);
		_ -> throw(?ERROR_Param)
	end.

%% return  ==========================================
do_return_material(Uid) ->
	#pet_new{} = Pet = pet_new:get_pet(Uid),
	A = return_lv_material(Pet),
	B = return_break_material(Pet),
	C = return_wash_material(Pet),
	Items = merge_item(A ++ B ++ C, []),
	Items.

return_wash_material(#pet_new{wash_material = WashMaterial}) -> WashMaterial.

merge_item(AddItemList, Items) ->
	F = fun({Tid, Num}, Acc) ->
		case lists:keyfind(Tid, 1, Acc) of
			{_, OldNum} -> lists:keyreplace(Tid, 1, Acc, {Tid, Num + OldNum});
			_ -> [{Tid, Num} | Acc]
		end
		end,
	lists:foldl(F, Items, AddItemList).


return_break_material(#pet_new{break_lv = BreakLv}) when BreakLv =< 0 -> [];
return_break_material(#pet_new{break_lv = BreakLv}) ->
	F = fun(Lv, Acc) ->
		#petBreakCfg{needItem = NeedItem} = cfg_petBreak:getRow(Lv),
		merge_item(NeedItem, Acc)
		end,
	lists:foldl(F, [], lists:seq(0, BreakLv - 1)).

return_lv_material(#pet_new{pet_lv = PetLv, pet_exp = LeftExp}) ->
	TotalExp = cal_total_exp(PetLv, LeftExp),
	CfgList = lists:reverse(cfg_petExpItem:rows()),
	exchange_exp_item(TotalExp, CfgList, []).

exchange_exp_item(Exp, CfgList, AccItems) ->
	case find_match_item(Exp, CfgList) of
		{LeftExp, ItemId, Num} ->
			exchange_exp_item(LeftExp, CfgList, [{ItemId, Num} | AccItems]);
		_ -> AccItems
	end.

find_match_item(Exp, CfgList) ->
	F = fun(#petExpItemCfg{exp = NeedExp}) ->
		Exp >= NeedExp
		end,
	case util:break_when_true(F, CfgList) of
		#petExpItemCfg{iD = ItemId, exp = DecExp} ->
			Num = Exp div DecExp,
			LeftExp = Exp rem DecExp,
			{LeftExp, ItemId, Num};
		_ -> ?FALSE
	end.


cal_total_exp(CurLv, LeftExp) when CurLv =< 1 -> LeftExp;
cal_total_exp(CurLv, LeftExp) ->
	F = fun(Lv, AccExp) ->
		#petLevelCfg{exp = Exp} = cfg_petLevel:getRow(Lv),
		Exp + AccExp
		end,
	lists:foldl(F, LeftExp, lists:seq(1, CurLv - 1)).

reset_pets(UidList) ->
	F = fun(Uid) ->
		#pet_new{pet_cfg_id = PetCfgID} = Pet = pet_new:get_pet(Uid),
		pet_new:update_pet(Pet#pet_new{pet_lv = 1, break_lv = 0, wash_material = [], pet_exp = 0, wash_preview = [], wash = get_base_wash_attr(PetCfgID)}),
		pet_shengshu:update_pet_point(Pet),
		pet_soul:sync_link_pet(Uid)
		end,
	lists:foreach(F, UidList).


%% return  ==========================================
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Pet) =:= 1 andalso guide:is_open_action(?OpenAction_Pet).

%%英雄洗髓功能
is_wash_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetEq) =:= 1 andalso guide:is_open_action(?OpenAction_Pet_Wash).

gm_set_break_lv(PetCfgId, BreakLv) ->
	PetList = pet_new:get_pet_list(),
	F = fun(#pet_new{pet_cfg_id = CfgId} = Pet) ->
		CfgId == PetCfgId andalso pet_new:update_pet(Pet#pet_new{break_lv = BreakLv})
		end,
	lists:foreach(F, PetList).

desc_wash_attr(Wash, DescList) ->
	F = fun({Type, Value}, Acc) ->
		case lists:keyfind(Type, 1, Acc) of
			{_, OldValue} -> lists:keyreplace(Type, 1, Acc, {Type, OldValue - Value});
			_ -> [{Type, Value} | Acc]
		end
		end,
	lists:foldl(F, Wash, DescList).

%% 总资质评分
total_qualification_point(#pet_new{pet_cfg_id = CfgId, star = Star, wash = Wash, fight_flag = FightType, fight_pos = FightPos, star_pos = StarPos}) ->
	EqList = pet_pos:get_pet_pos_ring_eq_list(FightType, FightPos),
	#petStarCfg{qualiIncrease = Percent} = cfg_petStar:getRow(CfgId, Star),
	Base = pet_base:get_base_wash_attr(CfgId),
	StarPosAddPercent = pet_eq_and_star:get_star_pos_qual(StarPos, CfgId),
	NewQualificationBase = pet_battle:calc_qual(Base, Percent, StarPosAddPercent),
	EqQualification = pet_eq_and_star:get_eq_quality(player:getPlayerID(), EqList),
	WashQualification = compare_attr(Base, Wash),
	trunc(lists:foldl(fun({_, Value}, Point) ->
		Point + Value end, 0, common:listValueMerge(NewQualificationBase ++ EqQualification ++ WashQualification))).

log_pet_wash(Uid, Times, Base) ->
	Pet = pet_new:get_pet(Uid),
	CalPoint = fun({_, Value}, Point) -> Point + Value end,
	WashPoint = lists:foldl(CalPoint, 0, compare_attr(Base, Pet#pet_new.wash)),
	AddWashPoint = lists:foldl(CalPoint, 0, Pet#pet_new.wash_preview),
	#pet_new{pet_cfg_id = CfgId, uid = Uid, star = Star, pet_lv = Lv} = Pet,
	L = [player:getPlayerID(), CfgId, Uid, Star, Lv, Times, WashPoint, WashPoint + AddWashPoint, time:time()],
	%?LOG_ALERT("~n log_pet_wash data: ~p ~n", [L]),
	table_log:insert_row(log_pet_wash, L).

log_pet_levelup(Pet, Lv, NewLv) ->
	#pet_new{pet_cfg_id = CfgId, uid = Uid, star = Star} = Pet,
	L = [player:getPlayerID(), CfgId, Uid, Star, Lv, NewLv, time:time()],
	%?LOG_ALERT("~n log_pet_levelup data: ~p , lv: ~p ~n", [L, Pet#pet_new.pet_lv]),
	table_log:insert_row(log_pet_level_up, L).

log_pet_return(PetList) ->
	ToLog =
		fun(Pet) ->
			#pet_new{pet_cfg_id = CfgId, uid = Uid, star = Star, pet_lv = Lv} = Pet,
			[player:getPlayerID(), CfgId, Uid, Star, Lv, total_qualification_point(Pet), time:time()]
		end,
	%?LOG_ALERT("~n log_pet_return data: ~p ~n", [lists:map(ToLog, PetList)]),
	table_log:insert_row_list(log_pet_return, lists:map(ToLog, PetList)).

log_pet_break(Pet, BreakLv, NewBreakLv) ->
	#pet_new{pet_cfg_id = CfgId, uid = Uid, star = Star} = Pet,
	L = [player:getPlayerID(), player:getLevel(), player:getVip(), CfgId, Uid, Star, BreakLv, NewBreakLv, time:time()],
	%?LOG_ALERT("~n log_pet_break data: ~p ~n", [L]),
	table_log:insert_row(log_pet_break, L).

log_pet_star(OldPet, OldPetStar, NewPetStar) ->
	#pet_new{pet_cfg_id = CfgId, uid = Uid, pet_lv = Lv} = OldPet,
	L = [player:getPlayerID(), player:getLevel(), player:getVip(), CfgId, Uid, Lv, OldPetStar, NewPetStar, time:time()],
	%?LOG_ALERT("~n log_pet_star data: ~p ~n", [L]),
	table_log:insert_row(log_pet_star_up, L).

log_pet_substitution(Pet, NewPetCfgID, Type) ->
	#pet_new{pet_cfg_id = CfgId, uid = Uid, star = Star, pet_lv = Lv} = Pet,
	LogType = case Type of low -> 0; high -> 1 end,
	L = [player:getPlayerID(), player:getLevel(), player:getVip(), CfgId, Uid, Star, Lv, total_qualification_point(Pet), NewPetCfgID, LogType, time:time()],
	%?LOG_ALERT("~n log_pet_substitution data: ~p ~n", [L]),
	table_log:insert_row(log_pet_substitution, L).

log_pet_op([], _Reason, _Op) ->ok;
log_pet_op(PetList, Reason, Op) ->
	%?LOG_ALERT("~n op list: ~p reason: ~p ~n", [PetList, Reason]),
	PlayerID = player:getPlayerID(),
	PlayerLv = player:getLevel(),
	Vip = player:getVip(),
	ToLog =
		fun(Pet) ->
			#pet_new{pet_cfg_id = CfgId, uid = Uid, star = Star, pet_lv = Lv} = Pet,
			LogOp = case Op of get -> 1; lose -> 0 end,
			[PlayerID, PlayerLv, Vip, CfgId, Uid, Star, Lv, Reason, LogOp, time:time()]
		end,
	table_log:insert_row_list(log_pet_get_or_lose, lists:map(ToLog, PetList)).

get_alternative_pet_id(CfgID) ->
	case cfg_petBase:getRow(CfgID) of
		#petBaseCfg{alternativeHero = AlternativeID} -> AlternativeID;
		{} -> 0
	end.