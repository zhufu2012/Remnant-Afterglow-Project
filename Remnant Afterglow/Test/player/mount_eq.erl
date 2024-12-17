%%%-------------------------------------------------------------------
%%% @author zhufu
%%% @copyright (C) 2023, DoubleGame
%%% @doc
%%%  骑装  坐骑装备
%%% @end
%%% Created : 10. 4月 2023 16:33
%%%-------------------------------------------------------------------
-module(mount_eq).
-author("zhufu").


-export([load_shouling_eq/1, on_item_eq_add/1, on_item_eq_delete/1]).
-export([on_eq_pos_unlock/2, on_eq_put_on/3, on_eq_put_off/3, on_onekey_equip_on/2]).
-export([on_eq_add_level/4, on_eq_break/4, on_eq_star/1, on_eq_resolve/1]).

-export([send_unlock_pos_list/0, get_shouling_eq/0, get_eq_count/0, add_eq_ins/1, get_sl_eq/1, get_mount_star_suit/1, get_all_unlock_pos/1]).
-export([get_count_eq_chara/1, get_count_eq_star/1, get_count_eq_chara_all/1, get_count_eq_int/1]).
-include("global.hrl").
-include("error.hrl").
-include("record.hrl").
-include("db_table.hrl").
-include("item.hrl").
-include("variable.hrl").
-include("netmsgRecords.hrl").
-include("attainment.hrl").
-include("player_task_define.hrl").
-include("mount.hrl").
-include("reason.hrl").
-include("time_limit_gift_define.hrl").
-include("cfg_mountEquip.hrl").
-include("cfg_mountEqpOpenNew.hrl").
-include("cfg_mountEqpBre.hrl").
-include("cfg_mountEqpStr.hrl").
-include("cfg_equipScoreIndex.hrl").
-include("cfg_mountEquipStar.hrl").
-include("cfg_mountStarSuit.hrl").
-include("cfg_disassemble.hrl").
-include("cfg_mountEquipUnlock.hrl").
-include("player_private_list.hrl").
-include("cfg_item.hrl").
%%%===================================================================
%%% API
%%%===================================================================
load_shouling_eq(PlayerId) ->
	DbEqList = lists:filter(fun(#db_eq_addition{eq_type = T}) ->
		T =:= 3 end, table_player:lookup(db_eq_addition, PlayerId)),
	set_shouling_eq([#eq_addition{
		eq_uid = DbEq#db_eq_addition.eq_uid,
		cfg_id = DbEq#db_eq_addition.item_data_id,
		rand_prop = DbEq#db_eq_addition.rand_prop
	} || DbEq <- DbEqList]).

%% 获得坐骑装备
on_item_eq_add(ItemList) ->
	?metrics(begin item_eq_add(ItemList) end).

%% 删除坐骑装备
on_item_eq_delete(Items) ->
	?metrics(begin item_eq_delete(Items) end).

%%兽灵装备格子解锁
on_eq_pos_unlock(SuitId, Pos) ->
	?metrics(begin eq_pos_unlock(SuitId, Pos) end).


%% 一键穿戴
on_onekey_equip_on(RoleID, SuitId) ->
	?metrics(begin eq_put_on(RoleID, SuitId) end).

%% 穿装备
on_eq_put_on(RoleID, SuitId, EqUid) ->
	?metrics(begin eq_put_on(RoleID, SuitId, EqUid) end).
%% 卸下装备
on_eq_put_off(RoleID, SuitId, EqUid) ->
	?metrics(begin eq_put_off(RoleID, SuitId, EqUid) end).

%% 装备升级
on_eq_add_level(RoleID, SuitId, Pos, EqUid) ->
	?metrics(begin eq_add_level(RoleID, SuitId, Pos, EqUid) end).

%% 装备突破
on_eq_break(RoleID, SuitId, Pos, EqUid) ->
	?metrics(begin eq_break(RoleID, SuitId, Pos, EqUid) end).


%%坐骑装备升星
on_eq_star(EqUid) ->
	?metrics(begin eq_star(EqUid) end).

%%装备分解（基础装备分解） 装备拆解(只有幻彩和暗金装备才能拆解)
on_eq_resolve(EqUidList) ->
	?metrics(begin eq_resolve(EqUidList) end).

%%获取穿戴的坐骑装备到达某一品质的数量
get_count_eq_chara(Chara) ->
	Fun = fun(#item{cfg_id = ItemID}) ->
		case cfg_mountEquipStar:getRow(ItemID) of
			#mountEquipStarCfg{equipID = EqCfgId} ->
				case cfg_mountEquip:getRow(EqCfgId) of
					{} ->
						?FALSE;
					#mountEquipCfg{quality = Quality} ->
						Quality >= Chara
				end;
			_ -> ?FALSE
		end end,
	length([1 || Item <- bag_player:get_bag_item_list(?BAG_SL_EQ_EQUIP), Fun(Item)]).

%%成就系统-495 获取穿戴的坐骑装备到达某一星级的数量
get_count_eq_star(Star) ->
	Fun = fun(#item{cfg_id = ItemID}) ->
		case cfg_mountEquipStar:getRow(ItemID) of
			#mountEquipStarCfg{star = EqStar} when EqStar >= Star ->
				?TRUE;
			_ -> ?FALSE
		end end,
	length([1 || Item <- bag_player:get_bag_item_list(?BAG_SL_EQ_EQUIP), Fun(Item)]).

%%获取所有坐骑装备到达某一品质的数量
get_count_eq_chara_all(Chara) ->
	F = fun(#item{cfg_id = ItemID}) ->
		case cfg_mountEquipStar:getRow(ItemID) of
			#mountEquipStarCfg{equipID = EqCfgId} ->
				case cfg_mountEquip:getRow(EqCfgId) of
					#mountEquipCfg{quality = Q} -> Q >= Chara;
					_ -> ?FALSE
				end;
			_ -> ?FALSE
		end end,
	length([1 || Item <- bag_player:get_bag_item_list(?BAG_SL_EQ_EQUIP) ++ check_mount_eq(bag_player:get_bag_item_list(?BAG_SL_EQ)), F(Item)]).

%%获取等级 达到lv的数量
get_count_eq_int(Lv) ->
	case mount:get_shouling(role_data:get_leader_id()) of
		#shouling{eqs = Eqs} ->
			length([1 || {_, _, IntLv, _} <- Eqs, IntLv >= Lv]);
		_ -> 0
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================

get_shouling_eq() -> get('shouling_eq').
set_shouling_eq(M) -> put('shouling_eq', M).

%%保存对应套的最大套装id
set_shouling_eq_suit(SuitId, SuitMaxId) -> put({'shouling_eq_suit', SuitId}, SuitMaxId).
%%获取当前套装最大id
get_shouling_eq_suit(SuitId) -> get({'shouling_eq_suit', SuitId}).

%%更新坐骑装备附件数据
update_shouling_eq(UpEqAddition) when is_tuple(UpEqAddition) ->
	update_shouling_eq([UpEqAddition]);
update_shouling_eq(UpEqAdditionList) ->
	F = fun(UpEqAddition, Acc) ->
		lists:keystore(UpEqAddition#eq_addition.eq_uid, #eq_addition.eq_uid, Acc, UpEqAddition)
		end,
	EqAdditionList = lists:foldl(F, get_shouling_eq(), UpEqAdditionList),
	set_shouling_eq(EqAdditionList),
	PlayerId = player:getPlayerID(),
	table_player:insert(db_eq_addition, [#db_eq_addition{
		eq_uid = EqUid,
		player_id = PlayerId,
		item_data_id = CfgId,
		eq_type = 3,  %% 1魔灵 2翼灵 3兽灵
		rand_prop = RandProp} || #eq_addition{eq_uid = EqUid, cfg_id = CfgId, rand_prop = RandProp} <- UpEqAdditionList]),
	player:send(#pk_GS2U_SLEqUpdate{eqs = [#pk_EqAddition{eq_Uid = Uid, cfg_id = CfgId,
		rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- RandProp]}
		|| #eq_addition{eq_uid = Uid, cfg_id = CfgId, rand_prop = RandProp} <- UpEqAdditionList]}).

%%发送当前已解锁的装备位
send_unlock_pos_list() ->
	UnLocKSuitPos = case mount:get_shouling(role_data:get_leader_id()) of
						#shouling{unlock_suit_pos = List} -> List;
						_ -> []
					end,
	player:send(#pk_GS2U_ShoulingEqPosUnLockListRet{unlock_pos_list = [#pk_key_value{key = SuitId, value = Pos} || {SuitId, Pos} <- get_all_unlock_pos(UnLocKSuitPos)]}).

%%获取坐骑装备数量
get_eq_count() ->
	length(get_shouling_eq()).

%% 添加实例回调
add_eq_ins(Eq = #eq_addition{eq_uid = EqUid, cfg_id = CfgId, rand_prop = RandProp}) ->
	set_shouling_eq([Eq] ++ get_shouling_eq()),
	table_player:insert(db_eq_addition, #db_eq_addition{
		eq_uid = EqUid,
		player_id = player:getPlayerID(),
		item_data_id = CfgId,
		eq_type = 3,  %% 1魔灵 2翼灵 3兽灵
		rand_prop = RandProp
	}),
	EqMsg = #pk_EqAddition{
		eq_Uid = EqUid,
		cfg_id = CfgId,
		rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- RandProp]
	},
	player:send(#pk_GS2U_SLEqUpdate{eqs = [EqMsg]}),
	guide:check_open_func(?OpenFunc_TargetType_MountEq),
	ok.
%%通过uid获取附加属性
get_sl_eq(Uid) ->
	case lists:keyfind(Uid, #eq_addition.eq_uid, get_shouling_eq()) of
		#eq_addition{} = E -> E;
		_ -> {}
	end.

%%获得坐骑装备
item_eq_add(ItemList0) ->
	ItemList2 = check_mount_eq(ItemList0),
	case ItemList2 of
		[] -> ok;
		_ ->
			ItemList = lists:filter(fun(#item{id = EqUid}) -> mount_eq:get_sl_eq(EqUid) =:= {} end, ItemList2),
			F = fun(#item{cfg_id = CfgId, id = EqUid}, {R1, R2, R3}) ->
				case cfg_mountEquipStar:getRow(CfgId) of
					{} ->
						?LOG_ERROR(" cfg_mountEquipStar no cfg_id: ~p", [CfgId]),
						{R1, R2, R3};
					#mountEquipStarCfg{equipID = EqCfgId} ->
						Cfg = #mountEquipCfg{starRule = RuleList} = cfg_mountEquip:getRow(EqCfgId),
						PropList = [Cfg#mountEquipCfg.starAttribute1, Cfg#mountEquipCfg.starAttribute2, Cfg#mountEquipCfg.starAttribute3],
						PointList = [Cfg#mountEquipCfg.starScore1, Cfg#mountEquipCfg.starScore2, Cfg#mountEquipCfg.starScore3],
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
							eq_type = 3,  %% 1魔灵 2翼灵 3兽灵
							rand_prop = RandProp
						},

						R33 = #pk_EqAddition{
							eq_Uid = EqUid,
							cfg_id = CfgId,
							rand_props = [#pk_RandProp{index = I, value = V, character = C, p_index = P} || {I, V, C, P} <- RandProp]
						},
						{[R11 | R1], [R22 | R2], [R33 | R3]}
				end end,
			{EqList, EqDBList, EqMsgList} = lists:foldl(F, {[], [], []}, ItemList),
			set_shouling_eq(EqList ++ get_shouling_eq()),
			table_player:insert(db_eq_addition, EqDBList),
			player:send(#pk_GS2U_SLEqUpdate{eqs = EqMsgList}),
			guide:check_open_func(?OpenFunc_TargetType_MountEq),
			ok
	end.
%%删除坐骑装备
item_eq_delete(Items) ->
	ItemList = check_mount_eq(Items),
	case ItemList of
		[] -> ok;
		_ ->
			Uids = [Uid || #item{id = Uid} <- ItemList],
			table_player:delete(db_eq_addition, player:getPlayerID(), Uids),
			NewEqList = lists:foldl(fun(Uid, Ret) ->
				lists:keydelete(Uid, #eq_addition.eq_uid, Ret) end, get_shouling_eq(), Uids),
			set_shouling_eq(NewEqList)
	end.

%%解锁兽灵装备格子
eq_pos_unlock(SuitId, Pos) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		RoleID = role_data:get_leader_id(),
		Shou_ling = case mount:get_shouling(RoleID) of
						#shouling{} = M -> M;
						_ -> #shouling{}
					end,
		#shouling{unlock_suit_pos = UnLocKSuitPos} = Shou_ling,
		UnLockPosList = get_all_unlock_pos(UnLocKSuitPos),
		?CHECK_THROW(not lists:member({SuitId, Pos}, UnLockPosList), ?ErrorCode_mount_eq_pos_unlock),%%不需要再解锁
		UnLockCfg = cfg_mountEquipUnlock:getRow(SuitId, Pos),
		?CHECK_CFG(UnLockCfg),
		?CHECK_THROW(check_pos_lock(UnLockCfg#mountEquipUnlockCfg.needPoint), ?ErrorCode_mount_Grade_Deficient),%%满足解锁条件
		CostErr = player:delete_cost(UnLockCfg#mountEquipUnlockCfg.itemConsume, ?REASON_Shouling_pos_unlock),
		?ERROR_CHECK_THROW(CostErr),
		mount:update_shouling(RoleID, Shou_ling#shouling{unlock_suit_pos = [{SuitId, Pos} | UnLocKSuitPos]}, ?TRUE),
		player:send(#pk_GS2U_ShoulingEqPosUnLockRet{suit_id = SuitId, pos = Pos}),
		log_mount_op(0, 22, gamedbProc:term_to_dbstring([{SuitId, Pos}]), [])
	catch
		ErrCode ->
			?LOG_ERROR("~n~p", [ErrCode]),
			player:send(#pk_GS2U_ShoulingEqPosUnLockRet{suit_id = SuitId, pos = Pos, err_code = ErrCode})
	end.


%%一键装备
eq_put_on(RoleID, SuitId) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		Shouling = case mount:get_shouling(RoleID) of #shouling{} = M -> M; _ ->
			#shouling{} end,
		AllItem = check_mount_eq(bag_player:get_bag_item_list(?BAG_SL_EQ)) ++ bag_player:get_bag_item_list(?BAG_SL_EQ_EQUIP),
		OtherEq = dec_other_role_eq(AllItem, [Info || {{S, _}, _, _, _} = Info <- Shouling#shouling.eqs, S =/= SuitId]),%%去掉非当前套装的其他已穿戴装备
		UnLockPosList = get_all_unlock_pos(Shouling#shouling.unlock_suit_pos),
		Equips = get_ok_ep(Shouling#shouling.lv, [P || {S, P} <- UnLockPosList, S =:= SuitId], SuitId, OtherEq, []),%%在这些装备中找到最高评分的各部位装备
		case Equips =:= [] of
			?FALSE ->
				{OnList, OffList} = check_transfer(Shouling#shouling.eqs, Equips, {[], []}),
				Err = bag_player:transfer(?BAG_SL_EQ, OnList, ?BAG_SL_EQ_EQUIP),
				?ERROR_CHECK_THROW(Err),
				Err1 = bag_player:transfer(?BAG_SL_EQ_EQUIP, OffList, ?BAG_SL_EQ),
				?ERROR_CHECK_THROW(Err1),
				NewEqs = lists:foldl(fun({Suit, Pos, Uid, _}, Ret) ->
					case lists:keyfind({Suit, Pos}, 1, Ret) of
						{_, _, Lv, Break} ->
							lists:keystore({Suit, Pos}, 1, Ret, {{Suit, Pos}, Uid, Lv, Break});
						_ -> lists:keystore({Suit, Pos}, 1, Ret, {{Suit, Pos}, Uid, 0, 0})
					end end, Shouling#shouling.eqs, Equips),
				mount:update_shouling(RoleID, Shouling#shouling{
					eqs = NewEqs
				}, ?FALSE),
				player:send(#pk_GS2U_ShoulingEqUpdate{role_id = RoleID, eqs = [#pk_ShoulingEqPos{suit_id = S, pos = Pos, uid = EqUid, lv = Lv, break_lv = Break} || {{S, Pos}, EqUid, Lv, Break} <- NewEqs]}),
				player:send(#pk_GS2U_ShoulingEqOneKeyOpRet{role_id = RoleID, err_code = ?ERROR_OK, type = 0}),
				guide:check_open_func(?OpenFunc_TargetType_MountEq1),
				mount:calc_shouling_prop(RoleID),
				SuitMaxId = get_shouling_eq_suit(SuitId),
				SuitNoticeList = player_private_list:get_value(?Private_List_mount_eq_notice),%%已公告过的列表
				case SuitMaxId =/= 0 andalso not lists:member(SuitMaxId, SuitNoticeList) of
					?FALSE -> skip;
					?TRUE ->
						PlayerText = player:getPlayerText(),
						marquee:sendChannelNotice(0, 0, d3_Mount_Notice1,
							fun(Language) ->
								language:format(language:get_server_string("D3_Mount_Notice1", Language), [PlayerText, SuitMaxId])
							end),
						player_private_list:set_value(?Private_List_mount_eq_notice, [SuitMaxId | SuitNoticeList])
				end,
				attainment:check_attainment([?Attainments_Type_MountEqCount, ?Attainments_Type_ShouLingEq_Star_Num]),
				time_limit_gift:check_open(?TimeLimitType_MountEqQualityNum),
				time_limit_gift:check_open(?TimeLimitType_MountEqStarNum),
				mount:put_prop(),
				log_mount_op(0, 20, gamedbProc:term_to_dbstring(Shouling#shouling.eqs), gamedbProc:term_to_dbstring(NewEqs));
			_ ->
				player:send(#pk_GS2U_ShoulingEqOneKeyOpRet{role_id = RoleID, suit_id = SuitId, err_code = ?ErrorCode_Astro_NoEqForOneKeyOn, type = 0})
		end
	catch
		ErrCode ->
			?LOG_ERROR("~n~p", [ErrCode]),
			player:send(#pk_GS2U_ShoulingEqOneKeyOpRet{role_id = RoleID, suit_id = SuitId, err_code = ErrCode, type = 0})
	end.
%%穿装备
eq_put_on(RoleID, SuitId, EqUid) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		{Err, Item} = bag_player:get_bag_item(?BAG_SL_EQ, EqUid),
		?ERROR_CHECK_THROW(Err),
		[#item{cfg_id = CfgId}] = Item,
		EquipCfg = cfg_mountEquipStar:getRow(CfgId),
		?CHECK_CFG(EquipCfg),
		#mountEquipStarCfg{equipID = EquipCfgId} = EquipCfg,
		EqCfg = cfg_mountEquip:getRow(EquipCfgId),
		?CHECK_CFG(EqCfg),
		Pos = EqCfg#mountEquipCfg.part,
		Shouling = case mount:get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		UnLockPosList = get_all_unlock_pos(Shouling#shouling.unlock_suit_pos),%%获取所有已解锁的装备格子位
		?CHECK_THROW(lists:member({SuitId, Pos}, UnLockPosList), ?ErrorCode_Mount_NoEqPos),
		?CHECK_THROW(Shouling#shouling.lv >= EqCfg#mountEquipCfg.lvLimit, ?ErrorCode_SL_lvNotMeet),
		Err2 = bag_player:transfer(?BAG_SL_EQ, EqUid, ?BAG_SL_EQ_EQUIP),
		?ERROR_CHECK_THROW(Err2),
		case lists:keyfind({SuitId, Pos}, 1, Shouling#shouling.eqs) of
			{_, OldEqUid, Lv1, B1} when OldEqUid > 0 ->
				Lv = Lv1, Break = B1,
				Err3 = bag_player:transfer(?BAG_SL_EQ_EQUIP, OldEqUid, ?BAG_SL_EQ),
				?ERROR_CHECK_THROW(Err3);
			{_, _, Lv2, B2} -> Lv = Lv2, Break = B2;
			_ -> Lv = 0, Break = 0
		end,
		NewShouling = Shouling#shouling{eqs = lists:keystore({SuitId, Pos}, 1, Shouling#shouling.eqs, {{SuitId, Pos}, EqUid, Lv, Break})},
		mount:update_shouling(RoleID, NewShouling, ?FALSE),
		player:send(#pk_GS2U_ShoulingEqUpdate{role_id = RoleID, eqs = [#pk_ShoulingEqPos{suit_id = SuitId, pos = Pos, uid = EqUid, lv = Lv, break_lv = Break}]}),
		player:send(#pk_GS2U_ShoulingEqOpRet{role_id = RoleID, err_code = ?ERROR_OK, type = 0, suit_id = SuitId}),
		guide:check_open_func(?OpenFunc_TargetType_MountEq1),
		mount:calc_shouling_prop(RoleID),
		SuitMaxId = get_shouling_eq_suit(SuitId),
		SuitNoticeList = player_private_list:get_value(?Private_List_mount_eq_notice),%%已公告过的列表
		case SuitMaxId =/= 0 andalso not lists:member(SuitMaxId, SuitNoticeList) of
			?FALSE -> skip;
			?TRUE ->
				PlayerText = player:getPlayerText(),
				marquee:sendChannelNotice(0, 0, d3_Mount_Notice1,
					fun(Language) ->
						language:format(language:get_server_string("D3_Mount_Notice1", Language), [PlayerText, SuitMaxId])
					end),
				player_private_list:set_value(?Private_List_mount_eq_notice, [SuitMaxId | SuitNoticeList])
		end,
		mount:put_prop(),
		attainment:check_attainment([?Attainments_Type_MountEqCount, ?Attainments_Type_ShouLingEq_Star_Num]),
		time_limit_gift:check_open(?TimeLimitType_MountEqQualityNum),
		time_limit_gift:check_open(?TimeLimitType_MountEqStarNum),
		player_task:refresh_task(?Task_Goal_MountEqCount),
		log_mount_op(0, 10, gamedbProc:term_to_dbstring(Shouling#shouling.eqs), gamedbProc:term_to_dbstring(NewShouling#shouling.eqs))
	catch
		ErrCode ->
			player:send(#pk_GS2U_ShoulingEqOpRet{err_code = ErrCode, type = 0, suit_id = SuitId})
	end.
%%卸下坐骑装备
eq_put_off(RoleID, SuitId, EqUid) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		?CHECK_THROW(EqUid =/= 0, ?ERROR_Param),
		Shouling = case mount:get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		{NewEqsList, {{_, Pos}, 0, Lv, Break}} = case lists:keytake(EqUid, 2, Shouling#shouling.eqs) of
													 {value, {{SuitId, _} = P1, _, P2, P3}, OtherOldEqsList} ->
														 {[{P1, 0, P2, P3} | OtherOldEqsList], {P1, 0, P2, P3}};
													 {value, _, _} -> throw(?ERROR_Param);
													 _ -> throw(?ErrorCode_mount_eq_NoEquip)
												 end,
		Err = bag_player:transfer(?BAG_SL_EQ_EQUIP, EqUid, ?BAG_SL_EQ),
		?ERROR_CHECK_THROW(Err),
		mount:update_shouling(RoleID, Shouling#shouling{eqs = NewEqsList}, ?TRUE),
		player:send(#pk_GS2U_ShoulingEqUpdate{role_id = RoleID, eqs = [#pk_ShoulingEqPos{suit_id = SuitId, pos = Pos, uid = 0, lv = Lv, break_lv = Break}]}),
		player:send(#pk_GS2U_ShoulingEqOpRet{role_id = RoleID, err_code = ?ERROR_OK, type = 1, suit_id = SuitId}),
		guide:check_open_func(?OpenFunc_TargetType_MountEq1),
		mount:calc_shouling_prop(RoleID),
		mount:put_prop(),
		attainment:check_attainment([?Attainments_Type_MountEqCount, ?Attainments_Type_ShouLingEq_Star_Num]),
		time_limit_gift:check_open(?TimeLimitType_MountEqQualityNum),
		time_limit_gift:check_open(?TimeLimitType_MountEqStarNum),
		player_task:refresh_task(?Task_Goal_MountEqCount),
		log_mount_op(0, 19, gamedbProc:term_to_dbstring(Shouling#shouling.eqs), gamedbProc:term_to_dbstring(NewEqsList))
	catch
		ErrCode ->
			player:send(#pk_GS2U_ShoulingEqOpRet{err_code = ErrCode, type = 1, suit_id = SuitId})
	end.
%%装备升级
eq_add_level(RoleID, SuitId, Pos, EqUid) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		{Err, ItemList} = bag_player:get_bag_item(?BAG_SL_EQ_EQUIP, EqUid),
		?ERROR_CHECK_THROW(Err),
		[Item] = ItemList,
		EquipCfg = cfg_mountEquipStar:getRow(Item#item.cfg_id),
		?CHECK_CFG(EquipCfg),
		#mountEquipStarCfg{equipID = EquipCfgId} = EquipCfg,
		Cfg = cfg_mountEquip:getRow(EquipCfgId),
		?CHECK_CFG(Cfg),
		#mountEquipCfg{type = Type} = Cfg,
		Shouling = case mount:get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		UnLockPosList = get_all_unlock_pos(Shouling#shouling.unlock_suit_pos),
		?CHECK_THROW(lists:member({SuitId, Pos}, UnLockPosList), ?ErrorCode_Mount_NoEqPos),
		{Lv, Break} = case lists:keyfind({SuitId, Pos}, 1, Shouling#shouling.eqs) of
						  {_, EqUid, Lv1, B1} ->
							  {Lv1, B1};
						  _ -> throw(?ErrorCode_SL_EqCannotAddLv)
					  end,
		BreakCfg = cfg_mountEqpBre:getRow(Type, Break),
		?CHECK_CFG(BreakCfg),
		case Lv < BreakCfg#mountEqpBreCfg.lv of ?TRUE -> skip; _ -> throw(?ErrorCode_SL_EqLvMax) end,
		LvCfg = cfg_mountEqpStr:getRow(Type, Lv),
		?CHECK_CFG(LvCfg),
		CostErr = player:delete_cost(LvCfg#mountEqpStrCfg.itemConsume, [], ?REASON_Shouling_eqaddlv),
		?ERROR_CHECK_THROW(CostErr),
		case rand:uniform(10000) =< LvCfg#mountEqpStrCfg.strRate of
			?TRUE ->
				mount:update_shouling(RoleID, Shouling#shouling{eqs = lists:keystore({SuitId, Pos}, 1, Shouling#shouling.eqs, {{SuitId, Pos}, EqUid, Lv + 1, Break})}, ?FALSE),
				attainment:check_attainment(?Attainments_Type_MountEqLvCount),%%成就系统-X个坐骑装备升级到XX级 344
				player:send(#pk_GS2U_ShoulingEqUpdate{role_id = RoleID, eqs = [#pk_ShoulingEqPos{suit_id = SuitId, pos = Pos, uid = EqUid, lv = Lv + 1, break_lv = Break}]}),
				player:send(#pk_GS2U_ShoulingEqAddLvRet{role_id = RoleID, suit_id = SuitId, err_code = ?ERROR_OK, is_success = 1}),
				mount:calc_shouling_prop(RoleID),
				mount:put_prop(),
				log_mount_op(0, 11, EqUid, lists:concat(["success,{", SuitId, ",", Pos, "},(", Lv, "->", Lv, ")"])),
				time_limit_gift:check_open(?TimeLimitType_MountEqInt);
			_ ->
				player:send(#pk_GS2U_ShoulingEqAddLvRet{role_id = RoleID, suit_id = SuitId, err_code = ?ERROR_OK, is_success = 0}),
				log_mount_op(0, 11, EqUid, lists:concat(["fail,{", SuitId, ",", Pos, "},Lv:", Lv]))
		end
	catch
		ErrCode ->
			?LOG_ERROR("~n~p", [ErrCode]),
			player:send(#pk_GS2U_ShoulingEqAddLvRet{role_id = RoleID, suit_id = SuitId, err_code = ErrCode})
	end.

%%装备突破
eq_break(RoleID, SuitId, Pos, EqUid) ->
	try
		?CHECK_THROW(role_data:is_role_exist(RoleID), ?ERROR_NoRole),
		?ERROR_CHECK_THROW(check_func_open()),
		{Err, ItemList} = bag_player:get_bag_item(?BAG_SL_EQ_EQUIP, EqUid),
		?ERROR_CHECK_THROW(Err),
		[Item] = ItemList,
		Shouling = case mount:get_shouling(RoleID) of #shouling{} = M -> M; _ -> #shouling{} end,
		UnLockPosList = get_all_unlock_pos(Shouling#shouling.unlock_suit_pos),
		?CHECK_THROW(lists:member({SuitId, Pos}, UnLockPosList), ?ErrorCode_Mount_NoEqPos),
		{Lv, Break} = case lists:keyfind({SuitId, Pos}, 1, Shouling#shouling.eqs) of
						  {_, EqUid, Lv1, B1} ->
							  {Lv1, B1};
						  _ -> throw(?ErrorCode_SL_EqCannotAddLv)
					  end,
		EquipCfg = cfg_mountEquipStar:getRow(Item#item.cfg_id),
		?CHECK_CFG(EquipCfg),
		#mountEquipStarCfg{equipID = EquipCfgId} = EquipCfg,
		#mountEquipCfg{type = Type} = cfg_mountEquip:getRow(EquipCfgId),
		BreakCfg = cfg_mountEqpBre:getRow(Type, Break),
		?CHECK_CFG(BreakCfg),
		case Lv =:= BreakCfg#mountEqpBreCfg.lv of ?TRUE -> skip; _ -> throw(?ErrorCode_SL_CannotBreak) end,
		case Break < BreakCfg#mountEqpBreCfg.lvMax of ?TRUE -> skip; _ -> throw(?ErrorCode_SL_EqLvMax) end,
		CostErr = player:delete_cost(BreakCfg#mountEqpBreCfg.itemConsume, [], ?REASON_sl_eq_break),
		?ERROR_CHECK_THROW(CostErr),
		mount:update_shouling(RoleID, Shouling#shouling{eqs = lists:keystore({SuitId, Pos}, 1, Shouling#shouling.eqs, {{SuitId, Pos}, EqUid, Lv, Break + 1})}, ?FALSE),
		player:send(#pk_GS2U_ShoulingEqUpdate{role_id = RoleID, eqs = [#pk_ShoulingEqPos{suit_id = SuitId, pos = Pos, uid = EqUid, lv = Lv, break_lv = Break + 1}]}),
		player:send(#pk_GS2U_ShoulingEqBreakRet{role_id = RoleID, err_code = ?ERROR_OK}),
		mount:calc_shouling_prop(RoleID),
		mount:put_prop(),
		log_mount_op(0, 12, EqUid, lists:concat(["{", SuitId, ",", Pos, "},(", Break, "->", Break + 1, ")"]))
	catch
		ErrCode ->
			?LOG_ERROR("~n~p", [ErrCode]),
			player:send(#pk_GS2U_ShoulingEqBreakRet{role_id = RoleID, err_code = ErrCode})
	end.

%%坐骑装备升星
eq_star(EqUid) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		{Err, ItemList} = bag_player:get_bag_item(?BAG_SL_EQ_EQUIP, EqUid),
		?ERROR_CHECK_THROW(Err),
		[Item] = ItemList,
		#item{cfg_id = CfgId} = Item,
		EqStarCfg = cfg_mountEquipStar:getRow(CfgId),
		?CHECK_CFG(EqStarCfg),
		#mountEquipStarCfg{nextNedd = NextList, nextID = NextCfg, star = Star, equipID = EquipCfgId} = EqStarCfg,
		EqBaseCfg = cfg_mountEquip:getRow(EquipCfgId),
		?CHECK_CFG(EqBaseCfg),
		case NextCfg =:= 0 of
			?TRUE -> throw(?ErrorCode_mount_eq_MaxStar);
			?FALSE -> skip
		end,
		RoleID = role_data:get_leader_id(),
		%%    必须装备上的才能升星 eqs=[{{套装序号,位置},Uid,等级,突破等级}]
		#shouling{eqs = EqsList} = case mount:get_shouling(RoleID) of
									   #shouling{} = M -> M;
									   _ -> #shouling{}
								   end,
		{NewEqAddItion, {Suit, Pos}} = case lists:keyfind(EqUid, 2, EqsList) of
										   ?FALSE -> throw(?ErrorCode_mount_eq_CannotAddStar);
										   {P, _, _, _} ->
											   case lists:keyfind(EqUid, #eq_addition.eq_uid, get_shouling_eq()) of
												   ?FALSE -> throw(?ErrorCode_mount_eq_CannotAddStar);
												   #eq_addition{} = EqAddItion ->
													   {EqAddItion#eq_addition{cfg_id = NextCfg}, P}
											   end
									   end,
		DeleteErr = player:delete_cost(NextList, [], ?REASON_mount_eq_star_lv),
		?ERROR_CHECK_THROW(DeleteErr),
		bag_player:update_item(?BAG_SL_EQ_EQUIP, [Item#item{cfg_id = NextCfg}], ?REASON_mount_eq_star_lv),
		update_shouling_eq(NewEqAddItion),
		player:send(#pk_GS2U_ShoulingEqStar{cfgid = NextCfg}),
		mount:calc_shouling_prop(RoleID),
		SuitMaxId = get_shouling_eq_suit(Suit),
		SuitNoticeList = player_private_list:get_value(?Private_List_mount_eq_notice),%%已公告过的列表
		case SuitMaxId =/= 0 andalso not lists:member(SuitMaxId, SuitNoticeList) of
			?FALSE -> skip;
			?TRUE ->
				PlayerText = player:getPlayerText(),
				marquee:sendChannelNotice(0, 0, d3_Mount_Notice1,
					fun(Language) ->
						language:format(language:get_server_string("D3_Mount_Notice1", Language), [PlayerText, SuitMaxId])
					end),
				player_private_list:set_value(?Private_List_mount_eq_notice, [SuitMaxId | SuitNoticeList])
		end,
		mount:put_prop(),
		attainment:check_attainment(?Attainments_Type_ShouLingEq_Star_Num),
		time_limit_gift:check_open(?TimeLimitType_MountEqStarNum),
		%%坐骑装备升星-日志
		log_mount_op(0, 18, EqUid, lists:concat(["{", Suit, ",", Pos, "},(", Star, "->", Star + 1, "),(", CfgId, "->", NextCfg, ")"]))
	catch
		ErrCode ->
			?LOG_ERROR("~n~p", [ErrCode]),
			player:send(#pk_GS2U_ShoulingEqStar{error = ErrCode})
	end.

%%坐骑装备分解（多星->0星）
eq_resolve(UidList) ->
	try
		?ERROR_CHECK_THROW(check_func_open()),
		NewUidList = lists:usort(UidList),
		?CHECK_THROW(NewUidList =/= [], ?ERROR_Param),
		{Err, ItemList} = bag_player:get_bag_item(?BAG_SL_EQ, NewUidList),
		?ERROR_CHECK_THROW(Err),
		F = fun(#item{id = Uid, cfg_id = CfgId} = Item, {ResolveAcc, AddZeroStarAcc, DeleteUidAcc, ShowZeroStarAcc}) ->
			case lists:keyfind(Uid, #eq_addition.eq_uid, get_shouling_eq()) of
				?FALSE -> %%没有这个装备
					{ResolveAcc, AddZeroStarAcc, DeleteUidAcc, ShowZeroStarAcc};
				#eq_addition{cfg_id = CfgId} ->
					case cfg_mountEquipStar:getRow(CfgId) of
						#mountEquipStarCfg{star = 0} ->%%0星的进行分解
							ItemCfg = cfg_disassemble:getRow(CfgId, 0, 0),
							?CHECK_CFG(ItemCfg),
							#disassembleCfg{consumeEquip = GetList} = ItemCfg,
							L = [{P2, P3} || {_P1, P2, P3, _P4, _P5} <- GetList],%%分解获得的道具
							{ResolveAcc ++ L, AddZeroStarAcc, [Uid | DeleteUidAcc], ShowZeroStarAcc};
						#mountEquipStarCfg{resolve = Resolve, equipID = ZeroStarCfgId} ->%%拆解
							NewItem = item:new(Item#item{cfg_id = ZeroStarCfgId}, 1),
							{ResolveAcc ++ Resolve, [NewItem | AddZeroStarAcc], [Uid | DeleteUidAcc], [{ZeroStarCfgId, 1} | ShowZeroStarAcc]};
						_ ->%%无配置
							?LOG_ERROR("mount_eq is cfg_mountEquipStar no cfg ~p ", [CfgId]),
							throw(?ERROR_Cfg)
					end;
				_ ->%%配置不匹配-不应该出现，如果有，是代码问题
					?LOG_ERROR("mount_eq is eq_addition no cfg ,uid: ~p ,cfg_id: ~p", [Uid, CfgId]),
					throw(?ERROR_Cfg)
			end end,
		%%分解出来的所有道具[{cfgid,num}] 用于添加的道具(0星)  删除uid列表  0星装备列表[{cfgid,1}]
		{ResolveItemList, AddZeroStarList, DeleteUidList, ShowZeroStarList} = lists:foldl(F, {[], [], [], []}, ItemList),
		AllResolveItemList = common:listValueMerge(ResolveItemList),
		bag_player:delete_item(?BAG_SL_EQ, DeleteUidList, ?REASON_mount_eq_BreakDown),
		bag_player:add_item(?BAG_SL_EQ, AddZeroStarList, ?REASON_mount_eq_BreakDown),
		player:add_rewards(AllResolveItemList, [], ?REASON_mount_eq_BreakDown), %% 获得分解奖励
		player_item:show_get_item_dialog(AllResolveItemList ++ ShowZeroStarList, [], [], 0, 1),
		player:send(#pk_GS2U_ShoulingEqBreakDownRet{itemlist = [#pk_itemInfo{itemID = ItemId, count = Count, multiple = 1} || {ItemId, Count} <- AllResolveItemList]}),
		%%坐骑装备分解-日志
		log_mount_op(0, 21, gamedbProc:term_to_dbstring(NewUidList), gamedbProc:term_to_dbstring([AllResolveItemList ++ ShowZeroStarList, AddZeroStarList, DeleteUidList]))
	catch
		ErrCode ->
			?LOG_ERROR("~n~p", [ErrCode]),
			player:send(#pk_GS2U_ShoulingEqBreakDownRet{err_code = ErrCode})
	end.

%% 找每个部位评分最高的那个
get_ok_ep(_, _, SuitId, [], Ret) -> [{SuitId, Part, Id, Score} || {Part, Id, Score, _, _} <- Ret];
get_ok_ep(Lv, PosList, SuitId, [#item{cfg_id = EqCfgId, id = Id} | T], Ret) ->
	#mountEquipStarCfg{equipID = CfgId, star = Star} = cfg_mountEquipStar:getRow(EqCfgId),
	#mountEquipCfg{part = Part, score = ScoreBase, lvLimit = LvLimit, quality = Quality} = cfg_mountEquip:getRow(CfgId),
	Score = ScoreBase + get_eq_rand_prop_score(Id),
	case lists:member(Part, PosList) andalso Lv >= LvLimit of
		?FALSE -> get_ok_ep(Lv, PosList, SuitId, T, Ret);
		_ ->
			case lists:keyfind(Part, 1, Ret) of
				?FALSE -> get_ok_ep(Lv, PosList, SuitId, T, [{Part, Id, Score, Quality, Star} | Ret]);
				{Part, Id1, Score1, Quality1, Star1} ->
					{NewId, NewScore, NewQuality, NewStar} =
						case Quality =:= Quality1 of
							?TRUE ->%%同品质
								case Score =:= Score1 of
									?TRUE ->%%评分相同看星级
										common:getTernaryValue(Star >= Star1, {Id, Score, Quality, Star}, {Id1, Score1, Quality1, Star1});
									?FALSE ->%%评分不同看评分
										common:getTernaryValue(Score >= Score1, {Id, Score, Quality, Star}, {Id1, Score1, Quality1, Star1})
								end;
							?FALSE ->%%不同品质看品质
								common:getTernaryValue(Quality >= Quality1, {Id, Score, Quality, Star}, {Id1, Score1, Quality1, Star1})
						end,
					NewRet = lists:keystore(Part, 1, Ret, {Part, NewId, NewScore, NewQuality, NewStar}),
					get_ok_ep(Lv, PosList, SuitId, T, NewRet)
			end
	end.
%%坐骑装备评分
get_eq_rand_prop_score(Uid) ->
	case lists:keyfind(Uid, #eq_addition.eq_uid, get_shouling_eq()) of
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

%%获取星级套装属性
get_mount_star_suit(EqsList) ->
	SuitList = lists:usort([Suit || {{Suit, _}, _, _, _} <- EqsList]),%%有哪些套装需要计算套装属性
	SuitAllProp = lists:foldl(fun(Suit_Id, SuitPropAcc) ->
		UidList = [Uid || {Suit, Uid, _, _} <- EqsList, Uid =/= 0, Suit_Id =:= Suit],%% eqs=[{{套装序号,位置},Uid,等级,突破等级}]
		{_, ItemList} = bag_player:get_bag_item(?BAG_SL_EQ_EQUIP, UidList),
		StarList = [Cfg#mountEquipStarCfg.num2 || #item{cfg_id = CfgId} <- ItemList, (Cfg = cfg_mountEquipStar:getRow(CfgId)) =/= {}],
		case length(StarList) =:= 6 of%%6件
			?TRUE ->
				MinStar = lists:min(StarList),%%最小星级
				SuitAttrList = [{SuitId, Cfg#mountStarSuitCfg.attribute} || SuitId <- cfg_mountStarSuit:getKeyList(), SuitId =< MinStar, (Cfg = cfg_mountStarSuit:getRow(SuitId)) =/= {}],
				case SuitAttrList of
					[] ->
						set_shouling_eq_suit(Suit_Id, 0),
						SuitPropAcc;
					_ ->
						{SuitMaxId, _} = lists:max(SuitAttrList),
						set_shouling_eq_suit(Suit_Id, SuitMaxId),
						SuitPropAcc ++ lists:flatten([Attr || {_, Attr} <- SuitAttrList])
				end;
			?FALSE ->
				set_shouling_eq_suit(Suit_Id, 0),
				SuitPropAcc
		end end, [], SuitList),
	attribute:base_prop_from_list(common:listValueMerge(SuitAllProp)).


%%获取所有已解锁的装备格子位(不需要道具且条件满足的(默认开的)+已解锁的(通过道具解锁了的))
get_all_unlock_pos(UnLockPosList) ->
	UnLockPosList ++ [{SuitId, Pos} || {SuitId, Pos} <- cfg_mountEquipUnlock:getKeyList(), Pos >= 1 andalso not lists:member({SuitId, Pos}, UnLockPosList),
		(Cfg = cfg_mountEquipUnlock:getRow(SuitId, Pos)) =/= {}, Cfg#mountEquipUnlockCfg.itemConsume =:= [] andalso Cfg#mountEquipUnlockCfg.needPoint =:= []].

check_pos_lock(NeedPoint) ->
	Grade = mount:get_mount_grade(),
	check_pos_lock(NeedPoint, Grade).
check_pos_lock(NeedPoint, Grade) ->
	lists:all(fun({Type, Param}) ->
		case Type of
			1 -> player:getLevel() >= Param;
			2 -> Grade >= Param;
			_ -> ?FALSE
		end end, NeedPoint).

%%返回其中的坐骑装备item列表
check_mount_eq(ItemList) ->
	[Item || #item{cfg_id = CfgId} = Item <- ItemList, (Cfg = cfg_item:getRow(CfgId)) =/= {}, Cfg#itemCfg.itemType =:= 24].

%% TODO 仅坐骑 部分功能需特殊检测
check_func_open() ->
	player:check_func_open(?WorldVariant_Switch_MountEq, ?OpenAction_MountEq).

check_transfer(_OldInfo, [], Ret) -> Ret;
check_transfer(OldInfo, [{SuitId, Pos, Uid, _} | T], {OnList, OffList}) ->
	case lists:keyfind({SuitId, Pos}, 1, OldInfo) of
		{_, Uid, _, _} -> check_transfer(OldInfo, T, {OnList, OffList});
		{_, Uid1, _, _} when Uid1 > 0 -> check_transfer(OldInfo, T, {[Uid | OnList], [Uid1 | OffList]});
		_ -> check_transfer(OldInfo, T, {[Uid | OnList], OffList})
	end.

dec_other_role_eq(AllItem, EqList) ->
	lists:foldl(fun({_, Uid, _, _}, ResEq) ->
		lists:keydelete(Uid, #item.id, ResEq)
				end, AllItem, EqList).

%%坐骑id 为0表示兽灵
%%操作 0-add 1-升级 2-突破 3-升星 4-觉醒 5-炼魂 6-羁绊激活 7-魔灵吃药 8-魔灵升级 9-魔灵技能装配 10-兽灵装备 11-魔灵装备升级 12-魔灵装备突破 13-开启触发技能格子 14-触发技能打造
%%18-坐骑装备升星  19 坐骑装备卸下 20 一键装备 21 坐骑装备分解  22 坐骑装备位解锁
log_mount_op(Id, Op, P1, P2) ->
	table_log:insert_row(log_mount_op, [player:getPlayerID(), time:time(), Id, Op, P1, P2]).