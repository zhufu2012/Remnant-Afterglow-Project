%%%-------------------------------------------------------------------
%%% @author zhubaicheng
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%		上阵/助战、英雄大师
%%% @end
%%% Created : 30. 6月 2022 15:35
%%%-------------------------------------------------------------------
-module(pet_pos).
-author("zhubaicheng").
-include("attribute.hrl").
-include("error.hrl").
-include("netmsgRecords.hrl").
-include("player_private_list.hrl").
-include("player_task_define.hrl").
-include("record.hrl").
-include("db_table.hrl").
-include("variable.hrl").
-include("cfg_petGoNew.hrl").
-include("cfg_petTrain.hrl").
-include("cfg_petLevel.hrl").
-include("cfg_petBreak.hrl").
-include("cfg_petBase.hrl").
-include("util.hrl").
-include("activity_new.hrl").
-include("time_limit_gift_define.hrl").
-include("attainment.hrl").
-include("pet_new.hrl").
-include("reason.hrl").
-include("item.hrl").
-include("cfg_item.hrl").
-include("cfg_heroAltar2.hrl").
-include("cfg_petStar.hrl").
-include("cfg_petStar2.hrl").

%% API
-export([on_load/0, send_all_info/0, update_pet_pos/1, get_pet_pos_list/0]).
-export([on_active_pos/2, on_set_pet_fight/3, on_set_pet_fight/4, on_set_pet_fight_one_key/1, on_set_pet_def/4, on_copy_def_pos/1, on_auto_skill/3, on_master_active/1,
	on_set_pet_def_one_key/2, on_off_pet_def_one_key/1]).
-export([auto_active_pos/0, get_fight_list/0, get_assist_list/0, on_get_fight_list/1, get_fight_uid_list/0, get_fight_uid_list/1,
	get_fight_uid_list_with_pos/1, get_fight_uid_and_pos_list/0, on_get_assist_list/1, get_assist_id_list/0,
	get_fight_num/0, assist_pet_change/2, get_fight_and_assist_uid_list/0, get_def_uid_list/1, get_pet_pos/2, is_pos_active/2,
	get_fight_aid_uid_list/0, get_fight_aid_uid_list/1]).
-export([get_pet_pos_msg/3, get_prop/0, get_pet_master_lv/0, is_cfg_pet_fight/1, get_pet_cfg_id/2, get_pet_pos_ring_eq_list/2,
	get_pet_pos_ring_eq_list/3, is_pet_pos_unlock/2, on_pet_delete/1, check_repeat/1, get_fight_uid_list_with_passive_pet/0, get_pet_pos_quality/1,
	get_pet_pos_def_list/0, get_aid_uid_list/0, on_get_aid_uid_list/1]).
-export([get_pet_pos_altar_effect/3, get_altar_effect_star/1, get_altar_effect_level/1, get_altar_effect_rate/1,
	get_aid_uid_and_pos_list/0, get_aid_relation/0, on_altar_stone_inlay/2, get_def_aid_uid_and_pos_list/2, on_get_aid_uid_and_pos_list/1,
	get_aid_relation/2, on_synthesize_update/2, get_pet_pos/3]).
-export([get_altar_stone_total_lv/0, get_aid_skill/3]).

on_load() ->
	PlayerId = player:getPlayerID(),
	set_pet_pos_list(load_pos(PlayerId)),
	set_pet_pos_def_list(load_pos_def(PlayerId)),
	check_open_pos(),
	calc_prop(?TRUE),
	pet_base:save_pet_sys_attr(?TRUE),
	ok.

send_all_info() ->
	List = get_pet_pos_list(),
	player:send(#pk_GS2U_PetPosSync{pet_pos = make_pet_pos_msg(List)}),
	player:send(#pk_GS2U_PetPosDefSync{pet_pos = make_pet_pos_def_msg(get_pet_pos_def_list())}),
	player:send(#pk_GS2U_PetMasterUpdate{lv = get_pet_master_lv()}).

%% 激活上阵位置
on_active_pos(Type, Pos) ->
	try
		Cfg = cfg_petGoNew:getRow(Type, Pos),
		?CHECK_CFG(Cfg),
		#petGoNewCfg{needWay = Need, activation = Activation} = Cfg,
		case check_pet_pos_active(Type, Pos, Need) of
			{?TRUE, _} ->
				DecErr = check_pet_pos_active_consume(Activation),
				?ERROR_CHECK_THROW(DecErr),
				update_pet_pos(#pet_pos{key = {Type, Pos}, type = Type, pos = Pos}),
				case Type of
					?STATUS_FIGHT ->%%开启对应出战位
						player_task:refresh_task(?Task_Goal_PetFightPosNum);
					?STATUS_ASSIST ->%%开启对应助战位
						player_task:refresh_task(?Task_Goal_PetAssistPosNum);
					_ -> ok
				end,
				PlayerText = player:getPlayerText(),
				case Need of%%注意，如果出战位不再根据英雄塔层数解锁，这里的代码和公告需要修改
					{4, Layer, _} when Type =:= ?STATUS_FIGHT ->%%出战位激活公告
						marquee:sendChannelNotice(0, 0, notice_YingXiongZhenWei1,
							fun(Language) ->
								language:format(language:get_server_string("Notice_YingXiongZhenWei1", Language),
									[PlayerText, Layer, Pos])
							end);
					{4, Layer, _} when Type =:= ?STATUS_ASSIST ->%%助战位激活公告
						marquee:sendChannelNotice(0, 0, notice_YingXiongZhenWei2,
							fun(Language) ->
								language:format(language:get_server_string("Notice_YingXiongZhenWei2", Language),
									[PlayerText, Layer, Pos])
							end);
					_ -> ok
				end,
				player:send(#pk_GS2U_PetPosActive{err_code = ?ERROR_OK, type = Type, pos = Pos});
			{?FALSE, Error} -> throw(Error)
		end
	catch
		Err ->
			player:send(#pk_GS2U_PetPosActive{err_code = Err, type = Type, pos = Pos})
	end.

%%英雄出战/助战   Type:出战1/助战2  Pos:位置  Uid:宠物uid  Replace:替换方式 (0 常规 1 无损替换)
on_set_pet_fight(Type, Pos, Uid) ->
	on_set_pet_fight(Type, Pos, Uid, 0).
on_set_pet_fight(Type, Pos, Uid, Replace) ->
	try
		Pet = pet_new:get_pet(Uid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
		PetPosList = get_pet_pos_list(),
		%% 检查是否在别的位置上阵
		AlreadyOn = [U || #pet_pos{key = TP, uid = U} <- PetPosList, TP =/= {Type, Pos}, U =:= Uid],
		?CHECK_THROW(length(AlreadyOn) < 1, ?ErrorCode_PetPosOn),
		%% 幻兽检查上阵之后的列表
		CheckPosList = [Uid | [U || #pet_pos{uid = U} <- PetPosList, U > 0]],
		check_sp_type(Type, Pet),
		Op = case lists:keyfind({Type, Pos}, #pet_pos.key, get_pet_pos_list()) of
				 #pet_pos{uid = Uid} = PetPos -> %% 卸下
					 pet_new:update_pet(Pet#pet_new{fight_flag = 0, fight_pos = 0}),
					 update_pet_pos(PetPos#pet_pos{uid = 0, is_auto_skill = 0}),
					 ?OP_OFF;
				 #pet_pos{uid = 0} = PetPos -> %% 上阵
					 check_soul(Pet, CheckPosList),
					 ?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, PetPosList), ?ErrorCode_PetPosOn),
					 pet_new:update_pet(Pet#pet_new{fight_flag = Type, fight_pos = Pos}),
					 update_pet_pos(PetPos#pet_pos{uid = Uid, is_auto_skill = 1}),
					 attainment:check_attainment(?Attainments_Type_PetAssistCount),%%成就系统-X个英雄助战-340
					 ?OP_ON;
				 #pet_pos{uid = OldUid} = PetPos when Replace =:= 0 -> %% 常规替换
					 OldPet = pet_new:get_pet(OldUid),
					 ?CHECK_THROW(OldPet =/= {}, ?ErrorCode_PetNotExist),
					 check_soul(Pet, lists:delete(OldUid, CheckPosList)),
					 ?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, lists:keydelete(OldUid, #pet_pos.uid, PetPosList)), ?ErrorCode_PetPosOn),
					 pet_new:update_pet(OldPet#pet_new{fight_flag = 0, fight_pos = 0}),
					 pet_new:update_pet(Pet#pet_new{fight_flag = Type, fight_pos = Pos}),
					 update_pet_pos(PetPos#pet_pos{uid = Uid, is_auto_skill = 1}),
					 ?OP_ON;
				 #pet_pos{uid = OldUid} = PetPos when Replace =:= 1 -> %%无损替换
					 OldPet = pet_new:get_pet(OldUid),
					 ?CHECK_THROW(OldPet =/= {}, ?ErrorCode_PetNotExist),
					 check_soul(Pet, lists:delete(OldUid, CheckPosList)),
					 ?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, lists:keydelete(OldUid, #pet_pos.uid, PetPosList)), ?ErrorCode_PetPosOn),
					 try
						 pet_base:save_pet_sys_attr_flag(?FALSE),
						 {ReplaceErr, ReturnItemList, SendAttrList, CalcList} = pet_base:pet_cultivation_replace(OldUid, Uid),%%养成替换
						 ?ERROR_CHECK_THROW(ReplaceErr),
						 NewPet = (pet_new:get_pet(OldUid))#pet_new{fight_flag = 0, fight_pos = 0},
						 NewTargetPet = (pet_new:get_pet(Uid))#pet_new{fight_flag = Type, fight_pos = Pos},
						 bag_player:add(ReturnItemList, ?REASON_Pet_CultivationReplace),
						 player_item:show_get_item_dialog(ReturnItemList, [], [], 0, 1),
						 pet_new:update_pet(NewPet),
						 pet_new:update_pet(NewTargetPet),
						 pet_shengshu:update_pet_point(NewPet),
						 pet_soul:sync_link_pet(OldUid),
						 pet_soul:sync_link_pet(Uid),
						 update_pet_pos(PetPos#pet_pos{uid = Uid, is_auto_skill = 1}),
						 pet_shengshu:on_pet_guard_change([NewPet, NewTargetPet] ++ [pet_new:get_pet(PetUid) || PetUid <- CalcList]),
						 pet_battle:send_pet_attr(?PLAYER_ID, SendAttrList) %% 发送这些英雄的属性
					 after
						 pet_base:save_pet_sys_attr_flag(?TRUE)
					 end,
					 ?OP_ON;
				 _ -> %% 未解锁
					 throw(?ErrorCode_PetPosLock)
			 end,
		?IF(Type =:= ?STATUS_FIGHT, pet_bless_eq:calc_battle_prop(Pos), ok),%%因出战位修改，计算对应英雄装备是否需要生效
		pet_battle:calc_player_add_fight(),
		pet_base:save_pet_sys_attr(),
		case Type =:= ?STATUS_FIGHT of
			?TRUE ->
				pet_battle:send_pet_attr(?PLAYER_ID, [Uid]), %% 目前只有出战影响属性，助战和援战不影响
				player_refresh:on_refresh_pet(),
				case Op =:= ?OP_ON of
					?TRUE ->
						pet_battle:set_send_attr_flag(?FALSE), %% 已经send_pet_attr过了，让on_refresh_pet_attr里面不再发送了
						player_refresh:on_refresh_pet_attr(?TRUE),
						pet_battle:set_send_attr_flag(?TRUE),
						player_refresh:on_refresh_pet_skill();
					?FALSE -> ok
				end,
				buff_player:on_buff_change();
			?FALSE -> ok
		end,
		case Type =:= ?STATUS_AID of
			?TRUE ->
				player_refresh:on_refresh_pet_skill(),
				player_refresh:on_refresh_aid_pet_relation(),
				Op =:= ?OP_ON andalso player_refresh:on_refresh_aid_pet_attr(?TRUE);
			?FALSE ->
				ok
		end,
		pet_battle:sync_to_top(0, ?TRUE),
		player:send(#pk_GS2U_PetOutFightRet{err_code = ?ERROR_OK, op = Op, type = Type, pos = Pos, uid = Uid}),
		player_task:refresh_task(?Task_Goal_PetFightNum),
		Op =:= ?OP_ON andalso player_task:refresh_task([?Task_Goal_PetFight, ?Task_Goal_PetActiveAndFightNum, ?Task_Goal_PetFightPos, ?Task_Goal_PetAssistPos, ?Task_Goal_PetTypeCount]),
		Type =:= ?STATUS_AID andalso attainment:check_attainment(?Attainments_Type_AltarHeroCount),
		ok
	catch
		Err -> player:send(#pk_GS2U_PetOutFightRet{err_code = Err, type = Type, pos = Pos})
	end.


%% 一键上阵 出战/助战  [{{Type, Pos}, Uid}] Uid为0则不判断 TODO 无用了，暂不维护
on_set_pet_fight_one_key(List) ->
	try
		PosList = get_pet_pos_list(),
		CheckList = [{{Type, Pos}, Uid} || {{Type, Pos}, Uid} <- List, Uid =/= 0], %% 取出没有0的部分
		SortPosList = lists:ukeysort(1, CheckList),
		SortUidList = lists:ukeysort(2, CheckList),
		?CHECK_THROW(length(CheckList) =:= length(SortPosList), ?ErrorCode_PetPosRepeat),
		?CHECK_THROW(length(CheckList) =:= length(SortUidList), ?ErrorCode_PetPosRepeat),
		OldList = [Uid || #pet_pos{uid = Uid} <- PosList, Uid =/= 0],
		NewList = [Uid || {_, Uid} <- CheckList],
		OffList = [U || U <- lists:usort(OldList -- NewList), U =/= 0],
		RefreshList = [U || U <- lists:usort(OldList ++ NewList), U =/= 0],
		UpdatePetOffList = lists:foldl(
			fun(Uid, Ret) -> %% 更新宠物下阵标志
				Pet = pet_new:get_pet(Uid),
				[Pet#pet_new{fight_flag = 0, fight_pos = 0} | Ret]
			end, [], OffList),
		{UpdatePetList, UpdatePos, _} = lists:foldl(
			fun({{Type, Pos}, Uid}, {Ret, PosAcc, CheckPosAcc}) -> %% 更新位置上阵，更新宠物上阵标志，根据前端发的Uid = 0注意要遍历空位置
				Pet = pet_new:get_pet(Uid),
				case lists:keyfind({Type, Pos}, #pet_pos.key, PosList) of %% 不能遍历未解锁的
					?FALSE -> {Ret, PosAcc, CheckPosAcc};
					PetPos ->
						case Pet =/= {} of
							?FALSE -> {Ret, PosAcc, CheckPosAcc};
							?TRUE ->
								check_sp_type(Type, Pet),
								?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, CheckPosAcc), ?ErrorCode_PetPosOn),
								{[Pet#pet_new{fight_flag = Type, fight_pos = Pos} | Ret],
									[PetPos#pet_pos{uid = Uid, is_auto_skill = 1} | PosAcc],
									lists:keystore({Type, Pos}, #pet_pos.key, CheckPosAcc, PetPos#pet_pos{uid = Uid, is_auto_skill = 1})}
						end
				end
			end, {[], [], PosList}, List),
		update_pet_pos(UpdatePos),
		pet_new:update_pet(UpdatePetList ++ UpdatePetOffList),
		attainment:check_attainment(?Attainments_Type_PetAssistCount),%%成就系统-X个英雄助战-340
		pet_battle:set_send_attr_flag(?FALSE),
		pet_battle:calc_player_add_fight(),
		pet_base:save_pet_sys_attr(),
		player_refresh:on_refresh_pet(),
		pet_battle:sync_to_top(0, ?TRUE),
		pet_bless_eq:calc_battle_prop(),%%因出战位修改，计算对应英雄装备是否需要生效
		pet_battle:set_send_attr_flag(?TRUE),
		pet_base:refresh_pet_and_skill(RefreshList),
		player_task:refresh_task([?Task_Goal_PetFightNum, ?Task_Goal_PetFightPos, ?Task_Goal_PetAssistPos, ?Task_Goal_PetTypeCount]),
		player_task:refresh_task([?Task_Goal_PetFight, ?Task_Goal_PetActiveAndFightNum]),
		player:send(#pk_GS2U_PetOutFightOneKey{err_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_PetOutFightOneKey{err_code = Err})
	end.

%% 设置防守阵容
on_set_pet_def(FuncId, Type, Pos, Uid) ->
	try
		throw(?ERROR_FunctionClose),
		Pet = pet_new:get_pet(Uid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
		%% 检查是否在别的位置上阵
		AlreadyOn = [U || {{F, T, P}, U} <- get_pet_pos_def_list(), F =:= FuncId, T =/= Type orelse P =/= Pos, U =:= Uid],
		?CHECK_THROW(length(AlreadyOn) < 1, ?ErrorCode_PetPosOn),
		check_sp_type(Type, Pet),
		%% 幻兽检查上阵之后的列表
		CheckPosList = [Uid | [U || {{F, _T, _P}, U} <- get_pet_pos_def_list(), U > 0 andalso F =:= FuncId]],
		Op = case lists:keyfind({FuncId, Type, Pos}, 1, get_pet_pos_def_list()) of
				 {{FuncId, Type, Pos}, Uid} -> %% 卸下
					 update_pet_pos_def(#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = 0}),
					 ?OP_OFF;
				 {{FuncId, Type, Pos}, 0} -> %% 上阵
					 ?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, [#pet_pos{type = T, pos = P, uid = U} || {{F, T, P}, U} <- get_pet_pos_def_list(), F =:= FuncId]), ?ErrorCode_PetPosOn),
					 check_soul(Pet, CheckPosList),
					 update_pet_pos_def(#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = Uid}),
					 ?OP_ON;
				 {{FuncId, Type, Pos}, OldUid} -> %% 替换
					 OldPet = pet_new:get_pet(OldUid),
					 ?CHECK_THROW(OldPet =/= {}, ?ErrorCode_PetNotExist),
					 ?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, [#pet_pos{type = T, pos = P, uid = U} || {{F, T, P}, U} <- get_pet_pos_def_list(), F =:= FuncId andalso U =/= OldUid]), ?ErrorCode_PetPosOn),
					 check_soul(Pet, lists:delete(OldUid, CheckPosList)),
					 update_pet_pos_def(#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = Uid}),
					 ?OP_ON;
				 _ -> %% 防守阵容未有记录，在普通阵容中查找是否解锁
					 case lists:keymember({Type, Pos}, #pet_pos.key, get_pet_pos_list()) of
						 ?TRUE ->
							 check_soul(Pet, CheckPosList),
							 update_pet_pos_def(#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = Uid}),
							 ?OP_ON;
						 ?FALSE -> throw(?ErrorCode_PetPosLock)
					 end
			 end,
		player:send(#pk_GS2U_PetOutDef{err_code = ?ERROR_OK, fun_id = FuncId, op = Op, type = Type, pos = Pos, uid = Uid})
	catch
		Err -> player:send(#pk_GS2U_PetOutDef{err_code = Err, fun_id = FuncId, type = Type, pos = Pos, uid = Uid})
	end.

%% 复制默认阵容到对应功能防守阵容
on_copy_def_pos(FuncId) ->
	try
		throw(?ERROR_FunctionClose),
		DefList = [Uid || {{F, _, _}, Uid} <- get_pet_pos_def_list(), F =:= FuncId],
		?CHECK_THROW(DefList =:= [], ?ErrorCode_PetPosDefExist),
		UpdateList = [#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = Uid} ||
			#pet_pos{type = Type, pos = Pos, uid = Uid} <- get_pet_pos_list(), Uid =/= 0],
		update_pet_pos_def(UpdateList),
		player:send(#pk_GS2U_CopyPetPosDef{err_code = ?ERROR_OK, func_id = FuncId})
	catch
		Err -> player:send(#pk_GS2U_CopyPetPosDef{err_code = Err, func_id = FuncId})
	end.

%% 切换是否自动释放技能 1是/0否
on_auto_skill(Type, Pos, IsAutoSkill) ->
	try
		Uid = case lists:keyfind({Type, Pos}, #pet_pos.key, get_pet_pos_list()) of
				  #pet_pos{type = ?STATUS_FIGHT, uid = 0} ->
					  throw(?ErrorCode_PetPosNotExist);
				  #pet_pos{type = ?STATUS_FIGHT, is_auto_skill = IsAutoSkill} ->
					  case IsAutoSkill of
						  1 -> throw(?ErrorCode_PetAutoSkillAlreadyOn);
						  0 -> throw(?ErrorCode_PetAutoSkillAlreadyOff);
						  _ -> throw(?ErrorCode_PetAutoSkill)
					  end;
				  #pet_pos{type = ?STATUS_FIGHT, uid = Uid0} = PetPos ->
					  update_pet_pos(PetPos#pet_pos{type = ?STATUS_FIGHT, pos = Pos, uid = Uid0, is_auto_skill = IsAutoSkill}),
					  Uid0;
				  _ -> throw(?ErrorCode_PetAutoSkill)
			  end,
		player:send(#pk_GS2U_PetAutoSkillRet{err_code = ?ERROR_OK, is_auto_skill = IsAutoSkill, uid = Uid, pos = Pos})
	catch
		Err -> player:send(#pk_GS2U_PetAutoSkillRet{err_code = Err, pos = Pos})
	end.


%% 一键上阵防守阵容  [{{Type, Pos}, Uid}] Uid为0则不判断
on_set_pet_def_one_key(FuncId, List) ->
	try
		throw(?ERROR_FunctionClose),
		PosList = get_pet_pos_list(),
		CheckList = [{{Type, Pos}, Uid} || {{Type, Pos}, Uid} <- List, Uid =/= 0], %% 取出没有0的部分
		SortPosList = lists:ukeysort(1, CheckList),
		SortUidList = lists:ukeysort(2, CheckList),
		?CHECK_THROW(length(CheckList) =:= length(SortPosList), ?ErrorCode_PetPosRepeat),
		?CHECK_THROW(length(CheckList) =:= length(SortUidList), ?ErrorCode_PetPosRepeat),
		{UpdatePos, _} = lists:foldl(
			fun({{Type, Pos}, Uid}, {PosAcc, CheckPosAcc}) -> %% 更新位置上阵，更新宠物上阵标志，根据前端发的Uid = 0注意要遍历空位置
				Pet = pet_new:get_pet(Uid),
				?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
				check_sp_type(Type, Pet),
				?CHECK_THROW(check_repeat_fight(Type, Pos, Pet, [#pet_pos{type = T, pos = P, uid = U} || {{F, T, P}, U} <- CheckPosAcc, F =:= FuncId]), ?ErrorCode_PetPosOn),
				case lists:keymember({Type, Pos}, #pet_pos.key, PosList) of %% 不能遍历未解锁的
					?TRUE -> {[#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = Uid} | PosAcc],
						lists:keystore({FuncId, Type, Pos}, 1, CheckPosAcc, {{FuncId, Type, Pos}, Uid})};
					?FALSE -> {PosAcc, CheckPosAcc}
				end
			end, {[], get_pet_pos_def_list()}, List),
		update_pet_pos_def(UpdatePos),
		player:send(#pk_GS2U_PetOutDefOneKey{err_code = ?ERROR_OK, func_id = FuncId})
	catch
		Err -> player:send(#pk_GS2U_PetOutDefOneKey{err_code = Err, func_id = FuncId})
	end.
%% 一键下阵
on_off_pet_def_one_key(FuncId) ->
	try
		throw(?ERROR_FunctionClose),
		{NewPosList, DelPosList} = lists:partition(fun({{FId, _, _}, _}) -> FId =/= FuncId end, get_pet_pos_def_list()),
		set_pet_pos_def_list(NewPosList),
		table_player:delete(db_pet_pos_def, player:getPlayerID(), [Key || {Key, _} <- DelPosList]),
		player:send(#pk_GS2U_PetPosDefSync{pet_pos = make_pet_pos_def_msg(NewPosList)}),
		player:send(#pk_GS2U_PetOffDefOneKey{err_code = ?ERROR_OK, func_id = FuncId})
	catch
		Err -> player:send(#pk_GS2U_PetOffDefOneKey{err_code = Err, func_id = FuncId})
	end.

%% 英雄大师激活
on_master_active(Lv) ->
	try
		NowLv = get_pet_master_lv(),
		?CHECK_THROW(Lv =:= NowLv + 1, ?ErrorCode_PetMasterCondition),
		Cfg = cfg_petTrain:getRow(Lv),
		?CHECK_CFG(Cfg),
		check_master(Cfg),
		update_master(Lv),
		calc_prop(),
		player:send(#pk_GS2U_PetMasterActiveRet{err_code = ?ERROR_OK, f_lv = Lv})
	catch
		Err -> player:send(#pk_GS2U_PetMasterActiveRet{err_code = Err, f_lv = Lv})
	end.

%% 其他进程
%% 出战宠物
on_get_fight_list(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, pos = Pos, uid = Uid, is_auto_skill = IsAutoSkill}, Ret) ->
		case Type =:= ?STATUS_FIGHT andalso Uid =/= 0 of
			?TRUE ->
				[#pet_pos{key = {Type, Pos}, type = Type, pos = Pos, uid = Uid, is_auto_skill = IsAutoSkill} | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).

%% 助战宠物
on_get_assist_list(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, pos = _Pos, uid = Uid}, Ret) ->
		case Type =:= ?STATUS_ASSIST andalso Uid =/= 0 of
			?TRUE -> [Uid | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).

%% 援战宠物
on_get_aid_uid_list(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, pos = _Pos, uid = Uid}, Ret) ->
		case Type =:= ?STATUS_AID andalso Uid =/= 0 of
			?TRUE -> [Uid | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).
on_get_aid_uid_and_pos_list(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, pos = Pos, uid = Uid}, Ret) ->
		case Type =:= ?STATUS_AID andalso Uid =/= 0 of
			?TRUE -> [{Uid, Pos} | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).

%%达到等级-自动激活上阵  流程特殊处理
auto_active_pos() ->
	try
		PosList = get_pet_pos_list(),
		Type = 1,
		Pos = 2,
		case lists:keymember({Type, Pos}, #pet_pos.key, PosList) of%%已经开启了
			?TRUE -> ok;
			_ ->
				case cfg_petGoNew:getRow(Type, Pos) of
					{} -> ok;
					#petGoNewCfg{needWay = Need, activation = Activation} ->
						case check_pet_pos_active(Type, Pos, Need) of
							{?TRUE, _} ->
								DecErr = check_pet_pos_active_consume(Activation),
								?ERROR_CHECK_THROW(DecErr),
								update_pet_pos(#pet_pos{key = {Type, Pos}, type = Type, pos = Pos}),
								player_task:refresh_task(?Task_Goal_PetFightPosNum),
								player:send(#pk_GS2U_PetPosActive{type = Type, pos = Pos});
							_ -> ok
						end
				end
		end
	catch
		_ -> ok
	end.

%% 玩家进程
%% 出战
get_fight_list() ->
	[{{Type, Pos}, Uid, Skill} || #pet_pos{type = Type, pos = Pos, uid = Uid, is_auto_skill = Skill} <- get_pet_pos_list(), Type =:= ?STATUS_FIGHT andalso Uid =/= 0].
%% 助战
get_assist_list() ->
	[{{Type, Pos}, Uid, Skill} || #pet_pos{type = Type, pos = Pos, uid = Uid, is_auto_skill = Skill} <- get_pet_pos_list(), Type =:= ?STATUS_ASSIST andalso Uid =/= 0].

get_assist_id_list() ->
	[Uid || #pet_pos{type = Type, uid = Uid} <- get_pet_pos_list(), Type =:= ?STATUS_ASSIST andalso Uid =/= 0].

get_fight_uid_list() ->
	[Uid || #pet_pos{type = Type, uid = Uid} <- get_pet_pos_list(), Type =:= ?STATUS_FIGHT andalso Uid =/= 0].

get_aid_uid_list() ->
	[Uid || #pet_pos{type = Type, uid = Uid} <- get_pet_pos_list(), Type =:= ?STATUS_AID andalso Uid =/= 0].

get_fight_aid_uid_list() ->
	[Uid || #pet_pos{type = Type, uid = Uid} <- get_pet_pos_list(), Uid =/= 0 andalso (Type =:= ?STATUS_FIGHT orelse Type =:= ?STATUS_AID)].

get_fight_uid_list_with_passive_pet() -> %% 包含提供技能/buff的被动宠物
	Func = fun(#pet_pos{type = Type, uid = Uid}, Acc) ->
		case Type =:= ?STATUS_FIGHT andalso Uid =/= 0 andalso pet_new:get_pet(Uid) of
			#pet_new{been_link_uid = 0} -> [Uid | Acc];
			#pet_new{been_link_uid = BeenLinkUid} ->
				case pet_new:get_pet(BeenLinkUid) of
					#pet_new{pet_cfg_id = PetCfgID} ->
						case cfg_petBase:getRow(PetCfgID) of
							#petBaseCfg{sPType = SpType} when SpType =:= 1 orelse SpType =:= 3 ->
								[Uid, BeenLinkUid | Acc];
							_ -> [Uid | Acc]
						end;
					_ -> [Uid | Acc]
				end;
			_ -> Acc
		end
		   end,
	lists:foldl(Func, [], get_pet_pos_list()).

%%任务2126 target_num为英雄上阵的数量；target_num1为对应的品质需求
get_pet_pos_quality(Quality) ->
	lists:foldl(fun(#pet_pos{uid = Uid}, Num) ->
		case pet_new:get_pet(Uid) of
			#pet_new{grade = Grade} when Grade >= Quality -> Num + 1;
			_ -> Num
		end end, 0, get_pet_pos_list()).

get_fight_uid_and_pos_list() ->
	[{Uid, Pos} || #pet_pos{type = Type, pos = Pos, uid = Uid} <- get_pet_pos_list(), Type =:= ?STATUS_FIGHT andalso Uid =/= 0].
get_aid_uid_and_pos_list() ->
	[{Uid, Pos} || #pet_pos{type = Type, pos = Pos, uid = Uid} <- get_pet_pos_list(), Type =:= ?STATUS_AID andalso Uid =/= 0].

get_fight_and_assist_uid_list() ->
	[Uid || #pet_pos{uid = Uid} <- get_pet_pos_list(), Uid =/= 0].

get_def_uid_list(FuncId) ->
	[Uid || {{{F, Type, _Pos}, Uid}} <- get_pet_pos_def_list(), Type =:= ?STATUS_FIGHT andalso Uid =/= 0 andalso F =:= FuncId].

get_def_aid_uid_and_pos_list(PlayerID, FuncId) ->
	case player:getPlayerID() =:= PlayerID of
		?TRUE ->
			[{Uid, Pos} || {{F, Type, Pos}, Uid} <- get_pet_pos_def_list(), Type =:= ?STATUS_AID andalso Uid =/= 0 andalso F =:= FuncId];
		?FALSE ->
			[{Uid, Pos} || {{F, Type, Pos}, Uid} <- load_pos_def(PlayerID), Type =:= ?STATUS_AID andalso Uid =/= 0 andalso F =:= FuncId]
	end.

get_pet_pos(Type, Pos) ->
	case lists:keyfind({Type, Pos}, #pet_pos.key, get_pet_pos_list()) of
		#pet_pos{} = PetPos -> PetPos;
		?FALSE -> {}
	end.
get_pet_pos(PlayerID, Type, Pos) ->
	case PlayerID =:= player:getPlayerID() of
		?TRUE -> get_pet_pos(Type, Pos);
		?FALSE ->
			case lists:keyfind({Type, Pos}, #pet_pos.key, load_pos(PlayerID)) of
				#pet_pos{} = PetPos -> PetPos;
				?FALSE -> {}
			end
	end.

get_pet_pos_ring_eq_list(Type, Pos) ->
	case lists:keyfind({Type, Pos}, #pet_pos.key, get_pet_pos_list()) of
		#pet_pos{ring_eq_list = RingList} -> RingList;
		?FALSE -> []
	end.
get_pet_pos_ring_eq_list(PlayerID, Type, Pos) ->
	case PlayerID =:= player:getPlayerID() of
		?TRUE -> get_pet_pos_ring_eq_list(Type, Pos);
		?FALSE ->
			case table_player:lookup(db_pet_pos, PlayerID, [{Type, Pos}]) of
				[#db_pet_pos{ring_eq_list = RingList}] -> gamedbProc:dbstring_to_term(RingList);
				[] -> []
			end
	end.
get_pet_pos_altar_effect(PlayerID, Type, Pos) ->
	CfgList = case PlayerID =:= player:getPlayerID() of
				  ?TRUE ->
					  case lists:keyfind({Type, Pos}, #pet_pos.key, get_pet_pos_list()) of
						  #pet_pos{altar_list = AltarList} -> [CfgID || {_, _, CfgID} <- AltarList, CfgID > 0];
						  ?FALSE -> []
					  end;
				  ?FALSE ->
					  case table_player:lookup(db_pet_pos, PlayerID, [{Type, Pos}]) of
						  [#db_pet_pos{altar_list = AltarList}] ->
							  [CfgID || {_, _, CfgID} <- gamedbProc:dbstring_to_term(AltarList), CfgID > 0];
						  [] -> []
					  end
			  end,
	LvList = lists:foldl(fun(CfgID, Acc) ->
		#itemCfg{detailedType = AltarPos, detailedType2 = Lv} = cfg_item:getRow(CfgID),
		lists:keystore(AltarPos, 1, Acc, {AltarPos, Lv})
						 end, [{P, 0} || {P, 0} <- cfg_heroAltar2:getKeyList()], CfgList),
	lists:map(fun(Key) ->
		#heroAltar2Cfg{effect = Effect} = cfg_heroAltar2:row(Key),
		Effect
			  end, LvList).
%% 圣坛星级上限
get_altar_effect_star(EffectList) ->
	case lists:keyfind(1, 1, EffectList) of
		?FALSE -> 5;
		{_, Star} -> Star
	end.
%% 圣坛等级上限
get_altar_effect_level(EffectList) ->
	case lists:keyfind(2, 1, EffectList) of
		?FALSE -> 1;
		{_, Lv} -> Lv
	end.
%% 圣坛属性转化率
get_altar_effect_rate(EffectList) ->
	case lists:keyfind(3, 1, EffectList) of
		?FALSE -> 0;
		{_, Rate} -> Rate
	end.

get_fight_uid_list(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, uid = Uid}, Ret) ->
		case Type =:= ?STATUS_FIGHT andalso Uid =/= 0 of
			?TRUE -> [Uid | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).
get_fight_aid_uid_list(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, uid = Uid}, Ret) ->
		case Uid =/= 0 andalso (Type =:= ?STATUS_FIGHT orelse Type =:= ?STATUS_AID) of
			?TRUE -> [Uid | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).

get_fight_uid_list_with_pos(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, uid = Uid, pos = Pos}, Ret) ->
		case Type =:= ?STATUS_FIGHT andalso Uid =/= 0 of
			?TRUE -> [{Uid, Pos} | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], PetList).

get_prop() ->
	case get_master_prop() of
		?UNDEFINED -> [];
		Prop -> Prop
	end.

%% 出战数量
get_fight_num() ->
	length(get_fight_list()).

%%对应出战位是否已激活
is_pos_active(Type, Pos) ->
	case cfg_petGoNew:getRow(Type, Pos) of
		{} -> ?FALSE;
		_ ->
			case get_pet_pos(Type, Pos) of
				{} -> ?FALSE;
				_ -> ?TRUE
			end
	end.

%% 改变助战宠物数据
assist_pet_change(PlayerId, #pet_new{fight_flag = 2, pet_lv = PetLv} = Pet) ->
	%% 等级以出战宠物中最低的为准
	PetList = pet_new:get_pet_list(),
	PetGuardList = pet_shengshu:get_pet_guard(),
	PetSharePos = pet_shengshu:get_pet_pos_list(),
	OutMinList = lists:foldl(fun(FightPet, Ret) ->
		case FightPet of
			{} -> [1 | Ret];
			_ ->
				LinkPet = pet_soul:link_pet(PlayerId, FightPet),
				[pet_shengshu:shared_pet_lv(LinkPet, PetList, PetGuardList, PetSharePos) | Ret]
		end
							 end, [], [pet_new:get_pet(Uid) || #pet_pos{type = Type, uid = Uid} <- get_pet_pos_list(), Type =:= ?STATUS_FIGHT]),
	FixLv = max(lists:min(OutMinList), PetLv),
	Pet#pet_new{pet_lv = FixLv};
assist_pet_change(_, Pet) -> Pet.

is_cfg_pet_fight(PetCfgID) ->
	lists:any(fun(Uid) ->
		case pet_new:get_pet(Uid) of
			#pet_new{pet_cfg_id = PetCfgID} -> ?TRUE;
			_ -> ?FALSE
		end
			  end, get_fight_uid_list()).
%% 上阵列表 [{{Type, Pos}, Uid, IsAutoSkill}]
get_pet_pos_list() ->
	case get('pet_pos_list') of
		?UNDEFINED -> [];
		L -> L
	end.

is_pet_pos_unlock(Type, Pos) ->
	lists:keymember({Type, Pos}, #pet_pos.key, get_pet_pos_list()).

%% 宠物消耗，强制置为0
on_pet_delete(UidList) ->
	Update = lists:foldl(fun({{FuncId, Type, Pos}, Uid}, Acc) ->
		case lists:member(Uid, UidList) of
			?FALSE -> Acc;
			?TRUE -> [#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos} | Acc]
		end end, [], get_pet_pos_def_list()),
	?IF(Update =/= [], update_pet_pos_def(Update), skip).

%% 检查是否在同一个阵容上有重复英雄，有则下阵，仅处理防守阵容
check_repeat(#pet_new{uid = CheckUid, pet_cfg_id = PetCfg}) ->
	DefList = get_pet_pos_def_list(),
	Update = lists:foldl(fun({{FuncId, Type, Pos}, Uid}, Acc) ->
		case CheckUid =:= Uid of
			?FALSE -> Acc;
			?TRUE ->
				PosCfgList = [pet_new:get_pet_cfg_id(U) || {{F, T, _P}, U} <- DefList, F =:= FuncId, T =:= Type, U =/= Uid],
				case lists:member(PetCfg, PosCfgList) of
					?FALSE -> Acc;
					?TRUE ->
						[#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = 0} | Acc]
				end
		end end, [], DefList),
	?IF(Update =/= [], update_pet_pos_def(Update), skip).

on_altar_stone_inlay(Pos, MaybeUidList) ->
	try
		Type = ?STATUS_AID,
		UidList = common:uniq(MaybeUidList),
		?CHECK_THROW(UidList =/= [], ?ERROR_Param),
		PetPos = get_pet_pos(Type, Pos),
		?CHECK_THROW(PetPos =/= {}, ?ErrorCode_PetPosLock),
		#pet_pos{altar_list = OldAltarList, uid = AidUid} = PetPos,
		{OffUidList, OnUidList} = lists:partition(fun(Uid) -> lists:keymember(Uid, 2, OldAltarList) end, UidList),
		{OffItemErr, OffItemList} = bag_player:get_bag_item(?BAG_AltarStoneEquip, OffUidList),
		?ERROR_CHECK_THROW(OffItemErr),
		{OnItemErr, OnItemList} = bag_player:get_bag_item(?BAG_PLAYER, OnUidList),
		?ERROR_CHECK_THROW(OnItemErr),

		OnExtendList = common:uniq(fun(E) -> element(1, E) end, [altar_stone_extend(Item) || Item <- OnItemList]),
		{NAltarList1, ReplaceUidList} = do_altar_stone_inlay(OnExtendList, OldAltarList, []),
		do_altar_stone_replace_off(bag_player:get_bag_item_no_error(?BAG_AltarStoneEquip, ReplaceUidList)),

		OffExtendList = [altar_stone_extend(Item) || Item <- OffItemList, not lists:member(Item#item.id, ReplaceUidList)],
		NAltarList2 = do_altar_stone_uninlay(OffExtendList, NAltarList1),

		NPetPos = PetPos#pet_pos{altar_list = NAltarList2},
		update_pet_pos(NPetPos),

		player:send(#pk_GS2U_PetPosInlayRet{pos = Pos, uid_list = UidList, err_code = ?ERROR_OK}),
		%% 援战位且对应出战位有英雄，则刷新相关属性及技能
		case AidUid > 0 andalso get_pet_pos(?STATUS_FIGHT, Pos) of
			#pet_pos{uid = FightUid} when FightUid > 0 ->
				pet_battle:calc_player_add_fight(),
				pet_base:save_pet_sys_attr(),
				player_refresh:on_refresh_pet_skill(),
				player_refresh:on_refresh_aid_pet_attr(?FALSE);
			_ -> ok
		end,
		attainment:check_attainment(?Attainments_Type_AltarStoneLvTotal),
		ok
	catch
		Err ->
			player:send(#pk_GS2U_PetPosInlayRet{pos = Pos, uid_list = MaybeUidList, err_code = Err})
	end.

get_aid_relation() ->
	PetPosList = get_pet_pos_list(),
	FightList = [{Uid, Pos} || #pet_pos{type = ?STATUS_FIGHT, pos = Pos, uid = Uid} <- PetPosList],
	lists:foldl(fun({Uid, Pos}, MapAcc) ->
		TargetUid = case lists:keyfind({?STATUS_AID, Pos}, #pet_pos.key, PetPosList) of
						?FALSE -> 0;
						#pet_pos{uid = AidUid} -> AidUid
					end,
		maps:put(Uid, TargetUid, MapAcc)
				end, maps:new(), FightList).
get_aid_relation(PetAidList, FightList) ->
	lists:foldl(fun({Uid, Pos}, MapAcc) ->
		TargetUid = case lists:keyfind(Pos, 2, PetAidList) of
						?FALSE -> 0;
						{AidUid, _} -> AidUid
					end,
		maps:put(Uid, TargetUid, MapAcc)
				end, maps:new(), FightList).

on_synthesize_update(Uid, CfgId) ->
	case common:listFind2(fun(#pet_pos{type = Type, altar_list = AltarList}) ->
		Type =:= ?STATUS_AID andalso lists:keymember(Uid, 2, AltarList) end, get_pet_pos_list(), {}) of
		{} ->
			?LOG_ERROR("uid not in altar list ~p", [Uid]),
			ok;
		#pet_pos{pos = FightPos, altar_list = AltarList, uid = AidUid} = PetPos ->
			{Pos, _, _} = lists:keyfind(Uid, 2, AltarList),
			NPetPos = PetPos#pet_pos{altar_list = lists:keystore(Pos, 1, AltarList, {Pos, Uid, CfgId})},
			update_pet_pos(NPetPos),
			attainment:check_attainment(?Attainments_Type_AltarStoneLvTotal),
			%% 援战位且对应出战位有英雄，则刷新相关属性及技能
			case AidUid > 0 andalso get_pet_pos(?STATUS_FIGHT, FightPos) of
				#pet_pos{uid = FightUid} when FightUid > 0 ->
					pet_battle:calc_player_add_fight(),
					pet_base:save_pet_sys_attr(),
					player_refresh:on_refresh_pet_skill(),
					player_refresh:on_refresh_aid_pet_attr(?FALSE);
				_ -> ok
			end
	end.

get_altar_stone_total_lv() ->
	lists:foldl(fun(#pet_pos{altar_list = AltarList}, Acc1) ->
		lists:foldl(fun({_Pos, _Uid, CfgId}, Acc2) ->
			case CfgId > 0 of
				?TRUE ->
					#itemCfg{detailedType2 = Lv} = cfg_item:getRow(CfgId),
					Lv + Acc2;
				?FALSE ->
					Acc2
			end
					end, Acc1, AltarList)
				end, 0, get_pet_pos_list()).

%% 援助技能
get_aid_skill(PlayerId, FightPos, AidList) ->
	case lists:keyfind(FightPos, 2, AidList) of
		?FALSE -> [];
		{AidPetUid, _} ->
			#pet_new{pet_cfg_id = CfgId, sp_lv = SpLv} = Pet = pet_new:get_pet(PlayerId, AidPetUid),
			#pet_new{star = Star} = pet_soul:link_pet(PlayerId, Pet),
			AltarEffectList = pet_pos:get_pet_pos_altar_effect(PlayerId, ?STATUS_AID, FightPos),
			MaxStar = pet_pos:get_altar_effect_star(AltarEffectList),
			FinalStar = min(MaxStar, Star),
			AltarSkill1 = case cfg_petStar:getRow(CfgId, FinalStar) of
							  {} -> [];
							  #petStarCfg{altarSkill = Skill1} -> Skill1
						  end,
			AltarSkill2 = case cfg_petStar2:getRow(CfgId, SpLv) of
							  {} -> [];
							  #petStar2Cfg{altarSkill = Skill2} -> Skill2
						  end,
			[{SkillType, SkillId, Index} || {_ConType, _Star, SkillType, SkillId, Index, _} <- AltarSkill1 ++ AltarSkill2]
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================
set_pet_pos_list(L) -> put('pet_pos_list', L).

%% 防守列表 {{FuncId, Type, Pos}, Uid}
get_pet_pos_def_list() ->
	case get('pet_pos_def_list') of
		?UNDEFINED -> [];
		L -> L
	end.
set_pet_pos_def_list(L) -> put('pet_pos_def_list', L).

get_master_prop() -> get(pet_master_prop).
put_master_prop(Attr) -> put(pet_master_prop, Attr).

set_pet_master_lv(Lv) ->
	variable_player:set_value(?Variable_Player_PetMaster, Lv).
get_pet_master_lv() ->
	variable_player:get_value(?Variable_Player_PetMaster).

check_open_pos() ->
	F = fun({Type, Pos}, Ret) ->
		case cfg_petGoNew:getRow(Type, Pos) of
			#petGoNewCfg{needWay = {0, 0, 0}, activation = {0, 0, 0}} ->
				case lists:keyfind({Type, Pos}, #pet_pos.key, Ret) of
					?FALSE ->
						lists:keystore({Type, Pos}, #pet_pos.key, Ret, #pet_pos{key = {Type, Pos}, type = Type, pos = Pos, is_auto_skill = 1});
					_ -> Ret
				end;
			_ -> Ret
		end end,
	NewList = lists:foldl(F, get_pet_pos_list(), cfg_petGoNew:getKeyList()),
	set_pet_pos_list(NewList).


load_pos(PlayerId) ->
	PetList = table_player:lookup(db_pet_pos, PlayerId),
	F = fun(#db_pet_pos{type = Type, pos = Pos, uid = Uid, is_auto_skill = IsAutoSkill, ring_eq_list = RingEqList, altar_list = AltarList}) ->
		#pet_pos{
			key = {Type, Pos},
			type = Type,
			pos = Pos,
			uid = Uid,
			is_auto_skill = IsAutoSkill,
			ring_eq_list = gamedbProc:dbstring_to_term(RingEqList),
			altar_list = gamedbProc:dbstring_to_term(AltarList)
		}
		end,
	lists:map(F, PetList).

load_pos_def(PlayerId) ->
	DefList = table_player:lookup(db_pet_pos_def, PlayerId),
	F = fun(#db_pet_pos_def{func_id = FuncId, type = Type, pos = Pos, uid = Uid}, Ret) ->
		case Type of
			?STATUS_FIGHT -> [{{FuncId, Type, Pos}, Uid} | Ret];
			?STATUS_AID -> [{{FuncId, Type, Pos}, Uid} | Ret];
			_ -> Ret
		end end,
	lists:foldl(F, [], DefList).

get_pet_pos_msg(PlayerId, PetList, FuncId) ->
	PosList = case FuncId of
				  0 -> load_pos(PlayerId);
				  _ ->
					  [#pet_pos{type = Type, pos = Pos, uid = Uid, is_auto_skill = 1} ||
						  {{F, Type, Pos}, Uid} <- load_pos_def(PlayerId), F =:= FuncId]
			  end,
	make_pet_pos_msg(PosList, PetList).

%% 更新宠物位置信息
update_pet_pos(PetPosList) when is_list(PetPosList) ->
	NewPosList = lists:foldl(
		fun(#pet_pos{type = T, pos = P} = PetPos, Ret) ->
			lists:keystore({T, P}, #pet_pos.key, Ret, PetPos)
		end, get_pet_pos_list(), PetPosList),
	set_pet_pos_list(NewPosList),
	table_player:insert(db_pet_pos, [pos_to_db(Pos) || Pos <- PetPosList]),
	player:send(#pk_GS2U_PetPosSync{pet_pos = make_pet_pos_msg(NewPosList)});
update_pet_pos(#pet_pos{type = T, pos = P} = PetPos) ->
	NewPosList = lists:keystore({T, P}, #pet_pos.key, get_pet_pos_list(), PetPos),
	set_pet_pos_list(NewPosList),
	table_player:insert(db_pet_pos, pos_to_db(PetPos)),
	player:send(#pk_GS2U_PetPosSync{pet_pos = make_pet_pos_msg(NewPosList)}).

pos_to_db(#pet_pos{} = PetPos) ->
	#db_pet_pos{
		player_id = player:getPlayerID(),
		type = PetPos#pet_pos.type,
		pos = PetPos#pet_pos.pos,
		uid = PetPos#pet_pos.uid,
		is_auto_skill = PetPos#pet_pos.is_auto_skill,
		ring_eq_list = gamedbProc:term_to_dbstring(PetPos#pet_pos.ring_eq_list),
		altar_list = gamedbProc:term_to_dbstring(PetPos#pet_pos.altar_list)
	}.

make_pet_pos_msg(List) ->
	make_pet_pos_msg(List, pet_new:get_pet_list()).
make_pet_pos_msg(List, PetList) ->
	[#pk_PetPos{type = T, pos = P, uid = U, pet_cfg_id = get_pet_cfg_id(U, PetList), is_auto_skill = I,
		pos_ring_list = [#pk_pet_eq_pos{pos = Pos, uid = Uid} || {Pos, Uid} <- RingEqList],
		altar_stone_list = [Uid || {_, Uid, _} <- AltarList]} ||
		#pet_pos{type = T, pos = P, uid = U, is_auto_skill = I, ring_eq_list = RingEqList, altar_list = AltarList} <- List].

%% 更新英雄防守信息
update_pet_pos_def(DB) when is_list(DB) ->
	NewPosList = lists:foldl(
		fun(#db_pet_pos_def{func_id = F, type = T, pos = P, uid = U}, Ret) ->
			lists:keystore({F, T, P}, 1, Ret, {{F, T, P}, U})
		end, get_pet_pos_def_list(), DB),
	set_pet_pos_def_list(NewPosList),
	table_player:insert(db_pet_pos_def, [def_to_db(Pos) || Pos <- DB]),
	player:send(#pk_GS2U_PetPosDefSync{pet_pos = make_pet_pos_def_msg(NewPosList)});
update_pet_pos_def(#db_pet_pos_def{func_id = FuncId, type = T, pos = P, uid = U} = DB) ->
	NewPosList = lists:keystore({FuncId, T, P}, 1, get_pet_pos_def_list(), {{FuncId, T, P}, U}),
	set_pet_pos_def_list(NewPosList),
	table_player:insert(db_pet_pos_def, DB#db_pet_pos_def{
		player_id = player:getPlayerID(),
		func_id = FuncId, type = T, pos = P, uid = U}),
	player:send(#pk_GS2U_PetPosDefSync{pet_pos = make_pet_pos_def_msg(NewPosList)}).


def_to_db(#db_pet_pos_def{} = DB) ->
	DB#db_pet_pos_def{player_id = player:getPlayerID()}.

make_pet_pos_def_msg(List) ->
	make_pet_pos_def_msg(List, pet_new:get_pet_list()).
make_pet_pos_def_msg(List, PetList) ->
	[#pk_PetPosDef{func_id = FuncId, type = T, pos = P, uid = U, pet_cfg_id = get_pet_cfg_id(U, PetList)} ||
		{{FuncId, T, P}, U} <- List].

get_pet_cfg_id(Uid, PetList) ->
	case lists:keyfind(Uid, #pet_new.uid, PetList) of
		#pet_new{pet_cfg_id = CfgId} -> CfgId;
		_ -> 0
	end.

%% 更新大师等级
update_master(Lv) ->
	set_pet_master_lv(Lv),
	player:send(#pk_GS2U_PetMasterUpdate{lv = Lv}),
	activity_new_player:on_active_condition_change(?SalesActivity_PetMasterLv, Lv),
	time_limit_gift:check_open(?TimeLimitType_PetMasterLv),
	ok.

%% 检查解锁上阵位条件
check_pet_pos_active(Type, Pos, Need) ->
	PosList = get_pet_pos_list(),
	?CHECK_THROW(lists:keymember({Type, Pos}, #pet_pos.key, PosList) =:= ?FALSE, ?ErrorCode_PetPosIsExist),
	case Need of
		{0, _, _} -> {?TRUE, ?ERROR_Cfg};
		{1, PlayerLv, _} -> %% 玩家等级
			{player:getLevel() >= PlayerLv, ?ErrorCode_PetPosActive_PlayerLv};
		{2, ReinLv, _} -> %% 转生等级
			{player:getPlayerProperty(#player.rein_lv) >= ReinLv, ?ErrorCode_PetPosActive_Rein};
		{3, VipLv, _} -> %% vip等级
			{vip:get_vip_lv() >= VipLv, ?ErrorCode_PetPosActive_VIP};
		{4, Layer, _} -> %% 宠物塔层数
			{career_tower:get_main_layer() >= Layer, ?ErrorCode_PetPosActive_PetTower};
		{5, Rare, Num} -> %% 获得xx个不同ID的xx品质英雄，参数1=品质，参数2=数量
			{pet_new:get_count_rare_uniq(Rare) >= Num, ?ErrorCode_PetPosActive_PetRareNum};
		_ ->
			throw(?ERROR_Cfg)
	end.

check_pet_pos_active_consume({0, 0, 0}) -> ?ERROR_OK;
check_pet_pos_active_consume(Consume) -> player:delete_cost([Consume], ?REASON_pet_pos_active).

%% 检查英雄大师激活条件
check_master(#petTrainCfg{condition = ConditionList}) ->
	check_master(ConditionList);
check_master([{1, Quality, Num} | List]) -> %5 宠物图鉴，参数1 品质，参数2 数量
	case pet_atlas:check_atlas_active(Quality) >= Num of
		?TRUE -> check_master(List);
		?FALSE -> throw(?ErrorCode_PetMasterConditionAtlas)
	end;
check_master([{2, Star, Num} | List]) -> %5 上阵魔宠，参数1 星级要求，参数2 数量
	case get_pet_star_num(Star) >= Num of
		?TRUE -> check_master(List);
		?FALSE -> throw(?ErrorCode_PetMasterConditionStar)
	end;
check_master([]) ->
	ok;
check_master(Last) ->
	?LOG_ERROR("check active:~p", [Last]),
	throw(?ErrorCode_PetMasterCondition).

%% 上阵宠物对应星级数量
get_pet_star_num(Star) ->
	UidList = [Uid || #pet_pos{uid = Uid} <- get_pet_pos_list(), Uid > 0 andalso get_pet_star(Uid) >= Star],
	length(UidList).

%%SSR-UR-UR是一套星级
get_pet_star(Uid) ->
	case pet_new:get_pet(Uid) of
		#pet_new{} = Pet ->
			case pet_soul:link_pet(player:getPlayerID(), Pet) of
				#pet_new{star = Star} -> Star;
				_ -> 0
			end;
		_ -> 0
	end.

%% 幻兽相关检查
check_soul(#pet_new{link_uid = LUid, been_link_uid = BLUid, appendage_uid = AUid, been_appendage_uid = _BAUid}, CheckPosList) ->
	?CHECK_THROW(LUid =:= 0 orelse check_on(LUid, CheckPosList) =/= ?TRUE, ?ErrorCode_PetPosOn_Linked2),
	?CHECK_THROW(BLUid =:= 0 orelse check_on(BLUid, CheckPosList) =/= ?TRUE, ?ErrorCode_PetPosOn_Linked),
	?CHECK_THROW(AUid =:= 0, ?ErrorCode_PetSoul_Appendage).

%% 是否已经上阵 true是/false否
check_on(Uid, CheckPosList) ->
	lists:member(Uid, CheckPosList).


calc_prop() ->
	calc_prop(?FALSE).
calc_prop(IsOnline) ->
	calc_master_prop(),
	[attribute_player:on_prop_change() || not IsOnline].

calc_master_prop() ->
	Lv = get_pet_master_lv(),
	case cfg_petTrain:getRow(Lv) of
		#petTrainCfg{attrAdd = Attr} -> put_master_prop(attribute:base_prop_from_list(Attr));
		_ -> []
	end.

%% 检查特殊英雄是否可上阵
check_sp_type(Type, Pet) ->
	#pet_new{pet_cfg_id = PetCfgId} = Pet,
	Cfg = cfg_petBase:getRow(PetCfgId),
	?CHECK_CFG(Cfg),
	#petBaseCfg{sPType = SpType} = Cfg,
	case SpType of
		1 when Type =:= ?STATUS_FIGHT -> throw(?ErrorCode_PetPosSpType);
		3 when Type =:= ?STATUS_FIGHT -> throw(?ErrorCode_PetPosSpType);
		_ -> skip
	end.

check_repeat_fight(Type, Pos, #pet_new{pet_cfg_id = PetCfgID, been_link_uid = BeenLinkUid}, PetPosList) ->
	%% 1.相同英雄不能重复上阵
	Flag1 = lists:all(fun(#pet_pos{uid = Uid, type = CheckType, pos = CheckPos}) ->
		case {CheckType, CheckPos} =/= {Type, Pos} andalso Uid > 0 andalso pet_new:get_pet(Uid) of
			#pet_new{pet_cfg_id = PetCfgID} -> ?FALSE;
			#pet_new{pet_cfg_id = OtherPetCfgID} when Type =:= ?STATUS_FIGHT andalso CheckType =:= ?STATUS_FIGHT -> %% 相互替代英雄不能同时上阵
				pet_base:get_alternative_pet_id(OtherPetCfgID) =/= PetCfgID;
			_ -> ?TRUE
		end
					  end, PetPosList),
	%% 2.相同链接被动技能英雄不能重复出战
	Flag2 = Flag1 andalso
		case (Type =:= ?STATUS_FIGHT orelse Type =:= ?STATUS_AID) andalso BeenLinkUid > 0 andalso pet_new:get_pet(BeenLinkUid) of
			#pet_new{pet_cfg_id = BeenPetCfgID} ->
				case cfg_petBase:getRow(BeenPetCfgID) of
					#petBaseCfg{sPType = SpType} when SpType =:= 1 orelse SpType =:= 3 ->
						lists:all(fun(#pet_pos{uid = Uid, type = CheckType, pos = CheckPos}) ->
							case (CheckType =:= ?STATUS_FIGHT orelse CheckType =:= ?STATUS_AID) andalso Pos =/= CheckPos andalso Uid > 0 andalso pet_new:get_pet(Uid) of
								#pet_new{been_link_uid = PosBeenLinkUid} when PosBeenLinkUid > 0 ->
									case pet_new:get_pet(PosBeenLinkUid) of
										#pet_new{pet_cfg_id = BeenPetCfgID} -> ?FALSE;
										_ -> ?TRUE
									end;
								_ -> ?TRUE
							end
								  end, PetPosList);
					_ -> ?TRUE
				end;
			_ -> ?TRUE
		end,
	Flag2.

altar_stone_extend(#item{id = Uid, cfg_id = CfgID} = Item) ->
	#itemCfg{detailedType = Pos} = cfg_item:getRow(CfgID),
	{Pos, Uid, Item}.

do_altar_stone_inlay([], AltarList, ReplaceUidList) -> {AltarList, ReplaceUidList};
do_altar_stone_inlay([{Pos, Uid, #item{amount = Amount, cfg_id = CfgID} = Item} | T], AltarList, ReplaceUidList) ->
	InlayID = case Amount =:= 1 of
				  ?TRUE ->
					  bag_player:transfer(?BAG_PLAYER, Uid, ?BAG_AltarStoneEquip),
					  Uid;
				  ?FALSE ->
					  NItem = item:new(Item, 1),
					  bag_player:add_finish(?BAG_PLAYER, {[Item#item{amount = Amount - 1}], []}, ?REASON_item_bag_split),
					  bag_player:add_finish(?BAG_AltarStoneEquip, {[], [NItem]}, ?REASON_item_bag_split),
					  NItem#item.id
			  end,
	case lists:keyfind(Pos, 1, AltarList) of
		{_, OldInlayID, _} when OldInlayID > 0 ->
			NAltarList = lists:keystore(Pos, 1, AltarList, {Pos, InlayID, CfgID}),
			do_altar_stone_inlay(T, NAltarList, [OldInlayID | ReplaceUidList]);
		_ ->
			NAltarList = lists:keystore(Pos, 1, AltarList, {Pos, InlayID, CfgID}),
			do_altar_stone_inlay(T, NAltarList, ReplaceUidList)
	end.

do_altar_stone_uninlay([], AltarList) -> AltarList;
do_altar_stone_uninlay([{Pos, Uid, #item{cfg_id = CfgID}} | T], AltarList) ->
	bag_player:delete_item(?BAG_AltarStoneEquip, [Uid], ?REASON_item_bag_merge),
	bag_player:add([{CfgID, 1}], ?REASON_item_bag_merge),
	NAltarList = lists:keystore(Pos, 1, AltarList, {Pos, 0, 0}),
	do_altar_stone_uninlay(T, NAltarList).

do_altar_stone_replace_off([]) -> ok;
do_altar_stone_replace_off(List) ->
	bag_player:delete_item(?BAG_AltarStoneEquip, [Uid || #item{id = Uid} <- List], ?REASON_item_bag_merge),
	bag_player:add([{CfgID, 1} || #item{cfg_id = CfgID} <- List], ?REASON_item_bag_merge).