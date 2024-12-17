%%%-------------------------------------------------------------------
%%% @author 祝福
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%  英雄装备  英雄装备魂石
%%% @end
%%% Created : 05. 11月 2022 10:09
%%%-------------------------------------------------------------------
-module(pet_bless_eq).
-author("祝福").

-include("global.hrl").
-include("netmsgRecords.hrl").
-include("variable.hrl").
-include("record.hrl").
-include("logger.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("item.hrl").
-include("db_table.hrl").
-include("bless_eq.hrl").
-include("cfg_item.hrl").
-include("attribute.hrl").
-include("time_limit_gift_define.hrl").
-include("game_guidance.hrl").
-include("cfg_petExpansion.hrl").
-include("cfg_petEquip.hrl").
-include("cfg_petEquipSuit.hrl").
-include("cfg_petGoNew.hrl").
-include("cfg_petOrnamentForge.hrl").
-include("cfg_petOrnamentSkill.hrl").
-include("cfg_ornamentAttri.hrl").
-include("pet_new.hrl").
-include("attainment.hrl").
-include("player_private_list.hrl").
-include("cfg_heroGemLimit.hrl").
-include("cfg_heroGemBase.hrl").
-include("cfg_heroGemSuit.hrl").

-define(TablePetEq, db_bless_eq).
-define(TablePetEqPos, db_bless_eq_pos).

%% API
-export([on_load/0, send_all_info/0, on_function_open/0]).
-export([on_bless_eq_op/4, on_bless_eq_1key_op/4, on_bless_eq_cast/4, on_soul_stone_1key_op/5]).
-export([on_bless_eq_add/1, on_bless_eq_delete/1, add_eq_ins/1, on_synthesize_update/2]).
-export([get_prop/1, get_prop/2, get_bless_eq_prop/1, calc_battle_prop/0, calc_battle_prop/1]).
-export([get_orn_count/0, get_count_eq_chara/1, get_count_eq_chara2/1, get_count_eq_int/1, get_soul_lv/1]).
-export([bless_eqpos_2_list/1, bless_eq_2_list/1, lists_2_bless/1, lists_2_bless_pos/1]).
%%%====================================================================
%%% API functions
%%%===================================================================
%% 加载
on_load() ->
	load_data(),%%加载英雄装备数据
	%% 计算阶段等级-英雄装备阶段
	calc_stage_lv(),
	%% 计算总属性
	calc_bless_eq_prop().

%%功能开启时再同步一次
on_function_open() ->
	send_all_info().

%% 发送英雄装备数据
send_all_info() ->
	case is_func_open() of
		?TRUE ->
			OrnMsgList = lists:map(fun make_bless_eq_msg/1, get_bless_eq_list()),
			OrnPosMsgList = lists:map(fun make_bless_eq_pos_msg/1, [BlessPos || #bless_eq_pos{uid = Uid} = BlessPos <- get_bless_eq_pos_list(), Uid =/= 0]),
			Stage_lv = get_all_stage_lv(),%%这个当前阶段等级数也要发出去
			player:send(#pk_GS2U_BlessEqSync{stage_list = Stage_lv, orn_list = OrnMsgList, orn_pos_list = OrnPosMsgList});
		_ -> skip
	end.

%% 穿戴 装备英雄装备
on_bless_eq_op(Op, Uid, BattlePos, Stage) when Op >= 0, Op =< 1 ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Err1 = check_unlock(BattlePos, Stage),
		?ERROR_CHECK_THROW(Err1),
		{Err2, Pos} = bless_eq_op(Op, Uid, BattlePos, Stage),
		?ERROR_CHECK_THROW(Err2),
		check_stage_soul_list(BattlePos),%%检查魂石列表，不正常卸下
		{SuitIdList, _AttrList} = calc_suit(BattlePos, Stage),%%套装属性
		%%计算装备阶段数
		calc_stage_lv(),
		calc_bless_eq_prop(BattlePos),
		flush_battle(BattlePos),
		check_notice({BattlePos, Stage}),%%检查发送公告
		attainment:check_attainment(?Attainments_Type_PetBlessEQCount),
		time_limit_gift:check_open(?TimeLimitType_EquipPetEqNum),
		guide:check_open_func(?OpenFunc_TargetType_PetBlessEqNum),
		Msg = #pk_GS2U_BlessEqOpRet{err_code = ?ERROR_OK, op = Op, uid = Uid, pos = Pos, stage = Stage, battle_pos = BattlePos, suitlist = common:to_kv_msg(SuitIdList)},
		player:send(Msg)
	catch
		ErrCode ->
			player:send(#pk_GS2U_BlessEqOpRet{err_code = ErrCode, op = Op, uid = Uid})
	end;
on_bless_eq_op(Op, Uid, BattlePos, Stage) ->
	player:send(#pk_GS2U_BlessEqOpRet{err_code = ?ERROR_Param, op = Op, uid = Uid, stage = Stage, battle_pos = BattlePos}).

%% 一键穿戴英雄装备
on_bless_eq_1key_op(Op, Uids, BattlePos, Stage) ->
	?metrics(begin
				 bless_eq_1key_op(Op, Uids, BattlePos, Stage)
			 end).

%%  英雄装备-祝福  出战位  阶段位  孔位  操作(0 获取新祝福   1保存祝福 2放弃祝福)
on_bless_eq_cast(Battle, Stage, Pos, Op) ->
	?metrics(begin
				 bless_eq_cast(Battle, Stage, Pos, Op)
			 end).

%% 英雄魂石一键镶嵌/卸下
on_soul_stone_1key_op(Op, Pos, Stage, BattlePos, OpPosList) ->
	?metrics(begin
				 soul_stone_1key_op(Op, Pos, Stage, BattlePos, OpPosList)
			 end).


%%英雄出战位出现变动，装备属性需要进行刷新
calc_battle_prop() ->
	calc_bless_eq_prop().
%%英雄出战位出现变动，装备属性需要进行刷新
calc_battle_prop(BattlePos) ->
	calc_bless_eq_prop(BattlePos).


%% 获取属性(增加的资质,增加的英雄属性)
get_prop(0) -> {[], []};
get_prop(BattlePos) ->
	get_bless_eq_prop(BattlePos).

%%英雄装备属性(增加的资质,增加的英雄属性)
get_prop(_PlayerId, 0) -> {[], []};
get_prop(PlayerId, BattlePos) ->
	case player:getPlayerID() == PlayerId of
		?TRUE -> get_prop(BattlePos);
		_ ->
			StageLv = get_stage_lv(PlayerId, BattlePos),
			EqPosList = [EqPos || #bless_eq_pos{battle_pos = BattlePos_, uid = Uid, stage = Stg} = EqPos <- table_player:lookup(?TablePetEqPos, PlayerId), Stg =< StageLv andalso BattlePos_ =:= BattlePos andalso Uid > 0],
			PetEqList = [BlessEq || #bless_eq{uid = Uid} = BlessEq <- table_player:lookup(?TablePetEq, PlayerId), Uid =/= 0 andalso lists:keymember(Uid, #bless_eq_pos.uid, EqPosList)],
			{AttrList1, SoulPosList} =
				lists:foldl(fun(#bless_eq_pos{uid = Uid, cast_prop = CastProp, soul_stone_list = SoulStoneList, stage = Stage, pos = Pos}, {Acc, SoulPosListAcc}) ->
					case lists:keyfind(Uid, #bless_eq.uid, PetEqList) of
						?FALSE -> {Acc, SoulPosListAcc};
						#bless_eq{cfg_id = CfgId, rand_prop = RandProp} ->
							#petEquipCfg{attribute = BaseAttr, starAttribute1 = StatAttr1, starAttribute2 = StatAttr2, starAttribute3 = StatAttr3} = cfg_petEquip:getRow(CfgId),
							CastProps = get_attr(CastProp, 1),%%祝福属性
							BaseAttrList = [{K, V} || {K, V} <- BaseAttr],%%基础属性
							F = fun({K, V}, Ret) ->
								StatAttr = case K of
											   1 -> StatAttr1;
											   2 -> StatAttr2;
											   3 -> StatAttr3
										   end,
								case lists:keyfind(V, 1, StatAttr) of
									{V, Value, _, _, _} -> [{V, Value} | Ret];
									_ -> Ret
								end
								end,
							RandPropList = lists:foldl(F, [], RandProp),%%卓越属性
							%%魂石属性,魂石位置信息
							{SoulStonePropList, NewSoulPosListAcc} = case SoulStoneList of%%魂石列表为空
																		 [] -> {[], SoulPosListAcc};
																		 _ ->
																			 Ls = lists:sort([Cfg#itemCfg.detailedType2 || {_, _, CfgID} <- SoulStoneList, (Cfg = cfg_item:getRow(CfgID)) =/= {}]),
																			 {get_soul_attr(SoulStoneList), [{{Stage, Pos}, Ls} | SoulPosListAcc]}
																	 end,
							{BaseAttrList ++ RandPropList ++ CastProps ++ SoulStonePropList ++ Acc, NewSoulPosListAcc}
					end end, {[], []}, EqPosList),
			AttrList2 = lists:foldl(fun({_, StageEqPosList}, Acc) ->%%英雄装备套装属性
				PosEqList = get_bless_eq_list([Uid || #bless_eq_pos{uid = Uid} <- StageEqPosList], PetEqList),
				{_, SuitAttr} = calc_suit_1(PosEqList),
				SuitAttr ++ Acc end, [], common:group_record(#bless_eq_pos.stage, EqPosList)),
			SoulSuitAttrList = get_soul_stone_suit_attr(SoulPosList, BattlePos, StageLv),
			AllProp = attribute:base_prop_from_list(common:listValueMerge(AttrList1 ++ AttrList2 ++ SoulSuitAttrList)),
			%%增加的资质  增加的英雄属性
			lists:foldl(fun(#prop{index = T, base = V} = Prop, {QualAcc, BlessEqAcc}) ->
				NT = T - 20000,
				case lists:member(NT, ?P_PET_QUALITY_LIST) of
					?TRUE -> {[{T, V} | QualAcc], BlessEqAcc};
					?FALSE -> {QualAcc, [Prop#prop{index = NT} | BlessEqAcc]}
				end end, {[], []}, AllProp)
	end.


%%获取英雄装备数量
get_orn_count() ->
	length(get_bless_eq_list()).

%%已装备的英雄装备到达某一品质的数量 品质向下兼容
get_count_eq_chara(Chara) ->
	F = fun(#bless_eq_pos{uid = Uid}, Ret) ->
		case get_bless_eq(Uid) of
			#bless_eq{cfg_id = CfgId} ->
				case cfg_petEquip:getRow(CfgId) of
					#petEquipCfg{quality = C} when C >= Chara -> Ret + 1;
					_ -> Ret
				end;
			_ -> Ret
		end
		end,
	lists:foldl(F, 0, [BlessEqPos || #bless_eq_pos{uid = Uid} = BlessEqPos <- get_bless_eq_pos_list(), Uid =/= 0]).

%%已装备的英雄装备到达某一品质的数量 品质不向下兼容
get_count_eq_chara2(Chara) ->
	F = fun(#bless_eq_pos{uid = Uid}, Ret) ->
		case get_bless_eq(Uid) of
			#bless_eq{cfg_id = CfgId} ->
				case cfg_petEquip:getRow(CfgId) of
					#petEquipCfg{quality = C} when C =:= Chara -> Ret + 1;
					_ -> Ret
				end;
			_ -> Ret
		end
		end,
	lists:foldl(F, 0, [BlessEqPos || #bless_eq_pos{uid = Uid} = BlessEqPos <- get_bless_eq_pos_list(), Uid =/= 0]).

%%所有装备中 等级超过对应等级
get_count_eq_int(Level) ->
	F = fun(#bless_eq_pos{uid = Uid}, Ret) ->
		case get_bless_eq(Uid) of
			#bless_eq{int_lv = Lv} when Lv >= Level -> Ret + 1;
			_ -> Ret
		end
		end,
	lists:foldl(F, 0, [BlessEqPos || #bless_eq_pos{uid = Uid} = BlessEqPos <- get_bless_eq_pos_list(), Uid =/= 0]).

%% 英雄装备合成 走通用合成
add_eq_ins(#bless_eq{} = Eq) ->
	?metrics(begin
				 EqList = get_bless_eq_list(),
				 NewEqList = [Eq | EqList],
				 set_bless_eq_list(NewEqList),
				 player:send(#pk_GS2U_BlessEqUpdate{orn_list = [make_bless_eq_msg(R) || R <- NewEqList]}),
				 table_player:insert(?TablePetEq, [Eq]),
				 guide:check_open_func(?OpenFunc_TargetType_PetEq),
				 ok
			 end).
%% 魂石合成-祝福注释-这里也要确定是否公告
on_synthesize_update(Uid, CfgId) ->
	[{BlessEq, Pos} | _] = [{BlessEqPos, element(1, Key)} || #bless_eq_pos{soul_stone_list = SoulStoneList} = BlessEqPos <- get_bless_eq_pos_list(),
		(Key = lists:keyfind(Uid, 2, SoulStoneList)) =/= ?FALSE],
	#bless_eq_pos{battle_pos = Battle, stage = Stage, soul_stone_list = OldSoulStoneList} = BlessEq,
	NewBlessEq = BlessEq#bless_eq_pos{soul_stone_list = lists:keyreplace(Pos, 1, OldSoulStoneList, {Pos, Uid, CfgId})},
	update_bless_eq_pos(NewBlessEq),
	calc_bless_eq_prop(Battle),%%刷新属性
	flush_battle(Battle),
	check_notice({Battle, Stage}),
	attainment:check_attainment(?Attainments_Type_PetEq_SoulStone_Lv_Num).


%% 添加英雄装备
on_bless_eq_add(AddList) ->
	F = fun(#item{cfg_id = CfgId} = Item, Ret) ->
		case cfg_petEquip:getRow(CfgId) of
			#petEquipCfg{} ->
				[make_bless_eq(Item) | Ret];
			_ -> Ret
		end
		end,
	OrnList = lists:foldl(F, [], AddList),
	update_bless_eq(OrnList),
	guide:check_open_func(?OpenFunc_TargetType_Ornament),
	ok.

%% 删除英雄装备
on_bless_eq_delete(DeleteList) ->
	F = fun(Uid, {EqAcc, Ret}) ->
		case lists:keyfind(Uid, #bless_eq.uid, Ret) of
			?FALSE ->
				{EqAcc, Ret};
			Data ->
				{[Data | EqAcc], lists:keydelete(Uid, #bless_eq.uid, Ret)}
		end
		end,
	Uids = [Uid || #item{id = Uid} <- DeleteList],
	{DeleteEqList, NewEqList} = lists:foldl(F, {[], get_bless_eq_list()}, Uids),
	set_bless_eq_list(NewEqList),
	table_player:delete(?TablePetEq, player:getPlayerID(), Uids),
	player:send(#pk_GS2U_BlessEqUpdate{orn_list = [make_bless_eq_msg(R) || R <- DeleteEqList], op = 1}).

%%成就系统-镶嵌X个Y级魂石 494
get_soul_lv(Lv) ->
	F = fun({_, _, CfgId}, Acc) ->
		case cfg_item:getRow(CfgId) of
			#itemCfg{detailedType2 = SoulLv} when SoulLv >= Lv ->
				Acc + 1;
			_ -> Acc
		end end,
	lists:foldl(F, 0, lists:flatten([SoulStoneList || #bless_eq_pos{uid = U, soul_stone_list = SoulStoneList} <- get_bless_eq_pos_list(), U =/= 0])).

bless_eq_2_list(Record) ->
	tl(tuple_to_list(Record#bless_eq{
		rand_prop = gamedbProc:term_to_dbstring(Record#bless_eq.rand_prop)
	})).

bless_eqpos_2_list(Record) ->
	tl(tuple_to_list(Record#bless_eq_pos{
		cast_prop = gamedbProc:term_to_dbstring(Record#bless_eq_pos.cast_prop),
		cast_prop_temp = gamedbProc:term_to_dbstring(Record#bless_eq_pos.cast_prop_temp),
		soul_stone_list = gamedbProc:term_to_dbstring(Record#bless_eq_pos.soul_stone_list)
	})).
lists_2_bless(List) ->
	Record = list_to_tuple([bless_eq | List]),
	Record#bless_eq{
		rand_prop = gamedbProc:dbstring_to_term(Record#bless_eq.rand_prop)
	}.
lists_2_bless_pos(List) ->
	Record = list_to_tuple([bless_eq_pos | List]),
	Record#bless_eq_pos{
		cast_prop = gamedbProc:dbstring_to_term(Record#bless_eq_pos.cast_prop),
		cast_prop_temp = gamedbProc:dbstring_to_term(Record#bless_eq_pos.cast_prop_temp),
		soul_stone_list = gamedbProc:dbstring_to_term(Record#bless_eq_pos.soul_stone_list)
	}.
%%%===================================================================
%%% Internal functions
%%%===================================================================
%% 设置 装备背包列表数据到进程字典
set_bless_eq_list(L) ->
	put({?MODULE, bless_eq_list}, L).
get_bless_eq_list() ->
	case get({?MODULE, bless_eq_list}) of
		?UNDEFINED -> [];
		Info -> Info
	end.
%%设置 装备背包位置列表数据到进程字典
set_bless_eq_pos_list(L) ->
	put(bless_eq_pos_list, L).
get_bless_eq_pos_list() ->
	case get(bless_eq_pos_list) of
		?UNDEFINED -> [];
		Info -> Info
	end.

%% 保存对应出战位，对应阶段的当前套装的魂石装备格数，魂石等级  Pos:{BattlePos,Stage} SuitList:[{MinPos1,MinLv1},{MinPos2,MinLv2}]
set_soul_suit(Pos, SuitList) -> put({soul_stone_suit, Pos}, SuitList).
get_soul_suit(Pos) ->
	case get({soul_stone_suit, Pos}) of
		?UNDEFINED -> [];
		L -> L
	end.

%%保存各出战位的阶段数
put_all_stage_lv(StageLvList) ->
	player_private_list:set_value(?Private_List_PetBlessEqStageLv, StageLvList).
get_all_stage_lv() ->
	case player_private_list:get_value(?Private_List_PetBlessEqStageLv) of
		[] -> [1, 1, 1];
		Data -> Data
	end.
%%获取对应出战位的阶段数
get_stage_lv(BattlePos) ->
	lists:nth(BattlePos, get_all_stage_lv()).
get_stage_lv(PlayerID, BattlePos) ->
	List = case player_private_list:get_value_ex(PlayerID, ?Private_List_PetBlessEqStageLv) of
			   [] -> [1, 1, 1];
			   Data -> Data
		   end,
	lists:nth(BattlePos, List).

%%%%获取对应出战位的装备位置数据列表
%%get_bless_eq_pos_list(BattlePos)->
%%  PosList=get_bless_eq_pos_list(),
%%  F=fun(#bless_eq_pos{battle_pos = BattlePos2} ) ->
%%    case BattlePos =:= BattlePos2 of
%%      ?TRUE->true;
%%      ?FALSE->false
%%    end
%%    end,
%%  lists:filter(F,PosList).

%%获取 对应出战位 对应阶段数的位置数据列表
get_bless_eq_pos_list(BattlePos, Stage) ->
	PosList = get_bless_eq_pos_list(),
	F = fun(#bless_eq_pos{battle_pos = BattlePos2, stage = Stage2}) ->
		BattlePos =:= BattlePos2 andalso Stage =:= Stage2
		end,
	lists:filter(F, PosList).
%%获取对应uid的装备数据
get_bless_eq(0) -> {};
get_bless_eq(Uid) ->
	case lists:keyfind(Uid, #bless_eq.uid, get_bless_eq_list()) of
		#bless_eq{} = Orn -> Orn;
		_ -> {}
	end.
%%获取对应uidlist的装备数据列表
get_bless_eq_list(UidList) ->
	get_bless_eq_list(UidList, get_bless_eq_list()).
get_bless_eq_list(UidList, EqList) ->
	F = fun(Uid, Ret) ->
		case lists:keyfind(Uid, #bless_eq.uid, EqList) of
			#bless_eq{} = Orn -> [Orn | Ret];
			_ -> Ret
		end
		end,
	lists:foldl(F, [], UidList).

%%获取玩家    对应英雄出战位的对应阶段  对应位置的装备部位数据  ---
get_bless_eq_pos(BattlePos, Stage, Pos) ->
	Fun = fun(#bless_eq_pos{pos = Pos2, stage = Stage2, battle_pos = BattlePos2}) ->
		Pos =:= Pos2 andalso BattlePos =:= BattlePos2 andalso Stage =:= Stage2
		  end,
	case lists:filter(Fun, get_bless_eq_pos_list()) of
		[OrnPos] -> OrnPos;
		_ -> {}
	end.
%%%%通过uid，获取对应英雄装备部位数据
%%get_bless_eq_pos(Uid)->
%%  case lists:keyfind(Uid, #bless_eq_pos.uid, get_bless_eq_pos_list()) of
%%    #bless_eq_pos{} = BlessEqPos -> BlessEqPos;
%%    _ -> {}
%%  end.

%% 加载数据
load_data() ->
	PlayerID = player:getPlayerID(),
	%%玩家 所有道具数据
	ItemList = table_player:lookup(db_item_player, PlayerID),
	%%该玩家 英雄装备数据--
	OrnamentList = [DbOrn || DbOrn <- table_player:lookup(?TablePetEq, PlayerID), (lists:keymember(DbOrn#bless_eq.uid, #db_item_player.id, ItemList) =/= ?FALSE)],
	%%设置 英雄装备数据 到进程字典
	set_bless_eq_list(OrnamentList),
	%%英雄装备位置数据
	%%设置英雄装备位置数据 到进程字典
	L = [DbOrnPos || DbOrnPos <- table_player:lookup(?TablePetEqPos, PlayerID), DbOrnPos#bless_eq_pos.uid =:= 0 orelse (lists:keyfind(DbOrnPos#bless_eq_pos.uid, #db_item_player.id, ItemList) =/= ?FALSE)],
	set_bless_eq_pos_list(L).


%%刷新战力 属性
flush_battle(BattlePos) ->
	pet_battle:calc_player_add_fight(),
	case get_fight_list(BattlePos) of
		{} -> ok;
		#pet_new{uid = PetUid} ->
			pet_base:save_pet_sys_attr_by_uid(PetUid),
			pet_base:refresh_pet_and_skill([PetUid])
	end.

%% 更新配饰
update_bless_eq(Orn) when is_record(Orn, bless_eq) -> update_bless_eq([Orn]);
update_bless_eq([]) -> ok;
update_bless_eq(OrnList) when is_list(OrnList) ->
	F = fun(#bless_eq{uid = Uid} = Orn, {Ret1, Ret2}) ->
		{lists:keystore(Uid, #bless_eq.uid, Ret1, Orn), [make_bless_eq_msg(Orn) | Ret2]}
		end,
	{NewOrnList, UpdatePosMsg} = lists:foldl(F, {get_bless_eq_list(), []}, OrnList),
	table_player:insert(?TablePetEq, OrnList),
	set_bless_eq_list(NewOrnList),
	Msg = #pk_GS2U_BlessEqUpdate{orn_list = UpdatePosMsg},
	player:send(Msg).

%%更新装备部位信息
update_bless_eq_pos(#bless_eq_pos{} = BlessEqPos) ->
	update_bless_eq_pos([BlessEqPos]);
update_bless_eq_pos(BlessEqPosList) ->
	F = fun(#bless_eq_pos{pos = Pos, stage = Stage, battle_pos = BattlePos} = BlessEqPos, {Ret1, Ret2}) ->
		{keystore3(Ret1, Pos, Stage, BattlePos, BlessEqPos), [make_bless_eq_pos_msg(BlessEqPos) | Ret2]}
		end,
	{NewBlessEqPosList, UpdateEqPosMsg} = lists:foldl(F, {get_bless_eq_pos_list(), []}, BlessEqPosList),
	set_bless_eq_pos_list(NewBlessEqPosList),
	table_player:insert(?TablePetEqPos, BlessEqPosList),
	player:send(#pk_GS2U_BlessEqPosUpdate{orn_pos_list = UpdateEqPosMsg}).




%%替换或增加 对应出战位 阶段 位置的 装备部位数据
keystore3([#bless_eq_pos{pos = Pos, stage = Stage, battle_pos = BattlePos} = H | T], A, B, C, Key) ->
	case Pos =:= A andalso Stage =:= B andalso BattlePos =:= C of
		?TRUE -> [Key | T];
		?FALSE -> [H | keystore3(T, A, B, C, Key)]
	end;
keystore3([], _, _, _, Key) -> [Key].

%%装配魂石列表(是否报错,要装配的魂石列表)  返回新的魂石列表(成功装配的) 注意uid
gem_bag_on_list(IsErr, SoulStoneList) ->
	F = fun({GemPos, GemUid, _}, Acc) ->
		case gem_bag_on(GemUid) of
			{?ERROR_OK, NewGemUid1, CfgId1} ->
				[{GemPos, NewGemUid1, CfgId1} | Acc];
			Err when IsErr =:= ?TRUE -> throw(Err);
			_ -> Acc
		end end,
	lists:foldl(F, [], SoulStoneList).
%%装配 单个魂石
gem_bag_on(GemUid) ->
	case bag_player:get_bag_item(?BAG_HERO_STONE, GemUid) of
		{?ERROR_OK, [#item{amount = 1, cfg_id = CfgId}]} ->%%只有一个
			{bag_player:transfer(?BAG_HERO_STONE, GemUid, ?BAG_HERO_STONE_EQUIP), GemUid, CfgId};
		{?ERROR_OK, [#item{amount = Amount, cfg_id = CfgId} = Item]} ->%%有多个，需要拆分
			EqItem = item:new(Item, 1),
			bag_player:add_finish(?BAG_HERO_STONE, {[Item#item{amount = Amount - 1}], []}, ?REASON_Pet_Bless_soul_on),
			bag_player:add_finish(?BAG_HERO_STONE_EQUIP, {[], [EqItem]}, ?REASON_Pet_Bless_soul_on),
			{?ERROR_OK, EqItem#item.id, CfgId};
		{Err, _} -> Err
	end.
%%卸下魂石列表,(是否报错,要卸下的魂石列表)  返回现在的魂石列表(没有卸下成功的)
%%卸下没有任何问题，装配则需要注意uid
gem_bag_off_list(IsErr, SoulStoneList) ->
	F = fun({_, GemUid, _}) ->
		case gem_bag_off(GemUid) of
			?ERROR_OK -> ?FALSE;
			Err when IsErr =:= ?TRUE -> throw(Err);
			_ -> ?TRUE
		end end,
	lists:filter(F, SoulStoneList).
%%卸下 单个魂石
gem_bag_off(GemUid) ->
	case bag_player:get_bag_item(?BAG_HERO_STONE_EQUIP, GemUid) of
		{?ERROR_OK, [#item{cfg_id = CfgId}]} ->
			bag_player:delete_item(?BAG_HERO_STONE_EQUIP, [GemUid], ?REASON_Pet_Bless_soul_off),
			bag_player:add([{CfgId, 1}], ?REASON_Pet_Bless_soul_off),
			?ERROR_OK;
		{Err, _} -> Err
	end.

%% 一键穿戴英雄装备
bless_eq_1key_op(Op, Uids, BattlePos, Stage) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Err = check_unlock(BattlePos, Stage),
		?ERROR_CHECK_THROW(Err),
		F = fun(Uid, Ret) ->
			case bless_eq_op(Op, Uid, BattlePos, Stage) of
				{?ERROR_OK, _} -> [Uid | Ret];
				_ -> Ret
			end
			end,
		EqUids = lists:foldl(F, [], lists:usort(Uids)),
		check_stage_soul_list(BattlePos),%%检查魂石列表，不正常卸下
		%%更新阶段等级
		NewStageLv = calc_stage_lv(BattlePos),
		{SuitIdList, _AttrList} = calc_suit(BattlePos, Stage),%%套装属性
		case Op =:= 0 of
			?TRUE -> ?CHECK_THROW(EqUids =/= [], ?ErrorCode_Bless_Eq_OneKeyOp0NoWear);
			?FALSE -> ?CHECK_THROW(EqUids =/= [], ?ErrorCode_Bless_Eq_OneKeyOp1NoWear)
		end,
		calc_stage_lv(),
		calc_bless_eq_prop(BattlePos),%%记录属性
		flush_battle(BattlePos),
		check_notice({BattlePos, Stage}),%%检查发送公告
		attainment:check_attainment(?Attainments_Type_PetBlessEQCount),
		time_limit_gift:check_open(?TimeLimitType_EquipPetEqNum),
		guide:check_open_func(?OpenFunc_TargetType_PetBlessEqNum),
		Msg = #pk_GS2U_BlessEqOneKeyOpRet{err_code = ?ERROR_OK, op = Op, uids = EqUids, battle_pos = BattlePos, stagelv = NewStageLv, suitlist = common:to_kv_msg(SuitIdList)},
		player:send(Msg)
	catch
		ErrCode ->
			player:send(#pk_GS2U_BlessEqOneKeyOpRet{err_code = ErrCode, op = Op})
	end.

%%	英雄装备-装配		0 装备  1 卸下 确定在其他阶段出战位 没有装备该装备
bless_eq_op(0, Uid, BattlePos, Stage) ->
	try
		{Err1, _} = bag_player:get_bag_item(?BAG_ML_EQ, Uid),
		?ERROR_CHECK_THROW(Err1),
		Orn = get_bless_eq(Uid),
		?CHECK_THROW(Orn =/= {}, ?ErrorCode_Bless_Eq_NotExist),
		BaseCfg = cfg_petEquip:getRow(Orn#bless_eq.cfg_id),
		?CHECK_THROW(BaseCfg =/= {}, ?ERROR_Cfg),
		#petEquipCfg{part = Part, quality = Quality} = BaseCfg,
		OrnPos = get_bless_eq_pos(BattlePos, Stage, Part),
		case OrnPos of
			#bless_eq_pos{uid = Uid} -> throw(?ERROR_OK);
			#bless_eq_pos{uid = 0} ->%%位置上没有穿戴 英雄装备
				Err2 = bag_player:transfer(?BAG_ML_EQ, Uid, ?BAG_ML_EQ_EQUIP),
				?ERROR_CHECK_THROW(Err2),
				update_bless_eq_pos(OrnPos#bless_eq_pos{uid = Uid});
			#bless_eq_pos{uid = OldUid, soul_stone_list = OldSoulStoneList} ->%%位置上有穿戴英雄装备
				{Err2, TransPrepared2} = bag_player:transfer_prepare(?BAG_ML_EQ, Uid, ?BAG_ML_EQ_EQUIP),
				?ERROR_CHECK_THROW(Err2),
				{Err3, TransPrepared3} = bag_player:transfer_prepare(?BAG_ML_EQ_EQUIP, OldUid, ?BAG_ML_EQ),
				?ERROR_CHECK_THROW(Err3),
				bag_player:transfer_finish(TransPrepared2),
				bag_player:transfer_finish(TransPrepared3),
				%%检查当前魂石列表
				{NewSoulStoneList, ReMoveList} = check_soul_stone_list(Part, Quality, OldSoulStoneList),
				gem_bag_off_list(?TRUE, ReMoveList),
				update_bless_eq_pos(OrnPos#bless_eq_pos{uid = Uid, pos = Part, stage = Stage, battle_pos = BattlePos, soul_stone_list = NewSoulStoneList});
			_ ->%%没有这个位置，添加 英雄装备部位数据
				Err2 = bag_player:transfer(?BAG_ML_EQ, Uid, ?BAG_ML_EQ_EQUIP),
				?ERROR_CHECK_THROW(Err2),
				update_bless_eq_pos(#bless_eq_pos{player_id = player:getPlayerID(), uid = Uid, pos = Part, stage = Stage, battle_pos = BattlePos})
		end,
		{?ERROR_OK, Part}
	catch
		ErrCode -> throw(ErrCode)
	end;
%%	英雄装备-卸下		0 装备  1 卸下
bless_eq_op(1, Uid, BattlePos, Stage) ->
	try
		%%物品是否在 英雄穿戴背包中
		{Err1, _} = bag_player:get_bag_item(?BAG_ML_EQ_EQUIP, Uid),
		?ERROR_CHECK_THROW(Err1),
		Orn = get_bless_eq(Uid),
		?CHECK_THROW(Orn =/= {}, ?ErrorCode_Bless_Eq_NotExist),
		BaseCfg = cfg_petEquip:getRow(Orn#bless_eq.cfg_id),
		?CHECK_THROW(BaseCfg =/= {}, ?ERROR_Cfg),
		#petEquipCfg{part = Part} = BaseCfg,

		OrnPos = get_bless_eq_pos(BattlePos, Stage, Part),
		?CHECK_THROW(OrnPos =/= {}, ?ErrorCode_Bless_Eq_NotWear),
		#bless_eq_pos{uid = OldUid, soul_stone_list = OldSoulStoneList} = OrnPos,
		?CHECK_THROW(OldUid =:= Uid, ?ErrorCode_Bless_Eq_NotWear),
		%%将英雄装备穿戴背包 的装备 -> 英雄装备背包
		Err2 = bag_player:transfer(?BAG_ML_EQ_EQUIP, Uid, ?BAG_ML_EQ),
		?ERROR_CHECK_THROW(Err2),
		%%魂石卸下
		gem_bag_off_list(?TRUE, OldSoulStoneList),
		%%卸下对应位置的装备
		update_bless_eq_pos(OrnPos#bless_eq_pos{uid = 0, soul_stone_list = []}),
		{?ERROR_OK, BaseCfg#petEquipCfg.part}
	catch
		ErrCode -> throw(ErrCode)
	end.

%%           出战位  阶段位  孔位  操作(0 获取新祝福   1保存祝福 2放弃祝福)
bless_eq_cast(Battle, Stage, Pos, 0) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_cast_open(), ?ERROR_FunctionClose),
		?CHECK_THROW((Battle >= 1 andalso Battle =< ?Bless_Eq_BattlePos_Max) andalso (Stage >= 1 andalso Stage =< ?Bless_Eq_Stage_Max)
			andalso (Pos >= 1 andalso Stage =< ?Bless_Eq_Pos_Max), ?ERROR_Param),
		BlessEqPos = get_bless_eq_pos(Battle, Stage, Pos),
		%%对应位置有装备才能
		case BlessEqPos of
			#bless_eq_pos{uid = 0} ->%%没有装备英雄装备,不能进行祝福相关操作
				throw(?ErrorCode_Bless_Eq_NotWear);
			#bless_eq_pos{cast_prop_temp = []} ->%%暂时保存祝福为空，可重置祝福
				ok;
			#bless_eq_pos{} -> throw(?ErrorCode_Bless_Eq_CastInfoExist);
			_ -> throw(?ErrorCode_Bless_Eq_NotWear)
		end,
		BlessEq = get_bless_eq(BlessEqPos#bless_eq_pos.uid),
		?CHECK_THROW(BlessEq =/= {}, ?ErrorCode_Bless_Eq_NotExist),
		ItemCfg = cfg_petEquip:getRow(BlessEq#bless_eq.cfg_id),
		?CHECK_THROW(ItemCfg =/= {}, ?ERROR_Cfg),
		CastCfg = cfg_petOrnamentForge:getRow(Pos),
		?CHECK_THROW(CastCfg =/= {}, ?ERROR_Cfg),
		Err1 = player:delete_cost(CastCfg#petOrnamentForgeCfg.needItem, ?REASON_Pet_BlessEqCast),
		?ERROR_CHECK_THROW(Err1),

		NewCastTime = BlessEqPos#bless_eq_pos.cast_time + 1,
		CastProp = make_cast_rand(BlessEqPos#bless_eq_pos.cast_prop, CastCfg, NewCastTime),

		NewBlessEqPos = BlessEqPos#bless_eq_pos{cast_time = NewCastTime, cast_prop_temp = CastProp},
		update_bless_eq_pos(NewBlessEqPos),
		player:send(#pk_GS2U_BlessEqCastRet{err_code = ?ERROR_OK, pos = Pos, stage = Stage, battle_pos = Battle, op = 1, bless_eq_pos = make_bless_eq_pos_msg(NewBlessEqPos)})
	catch
		ErrCode ->
			player:send(#pk_GS2U_BlessEqCastRet{err_code = ErrCode, pos = Pos, stage = Stage, battle_pos = Battle, op = 0})
	end;
%%英雄装备 祝福保存(替换)
bless_eq_cast(Battle, Stage, Pos, 1) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_cast_open(), ?ERROR_FunctionClose),
		?CHECK_THROW((Battle >= 1 andalso Battle =< ?Bless_Eq_BattlePos_Max) andalso (Stage >= 1 andalso Stage =< ?Bless_Eq_Stage_Max)
			andalso (Pos >= 1 andalso Stage =< ?Bless_Eq_Pos_Max), ?ERROR_Param),
		Bless_eq_pos = get_bless_eq_pos(Battle, Stage, Pos),
		%%对应位置有装备才能
		case Bless_eq_pos of
			#bless_eq_pos{uid = 0} ->%%没有装备英雄装备,不能进行祝福相关操作
				throw(?ErrorCode_Bless_Eq_NotWear);
			#bless_eq_pos{cast_prop_temp = []} ->%%暂时保存祝福为空，报错
				throw(?ErrorCode_Bless_Eq_CastInfoNotExist);
			#bless_eq_pos{} -> ok;
			_ -> throw(?ErrorCode_Bless_Eq_NotWear)
		end,
		BlessEq = get_bless_eq(Bless_eq_pos#bless_eq_pos.uid),
		?CHECK_THROW(BlessEq =/= {}, ?ErrorCode_Bless_Eq_NotExist),
		ItemCfg = cfg_petEquip:getRow(BlessEq#bless_eq.cfg_id),
		?CHECK_THROW(ItemCfg =/= {}, ?ERROR_Cfg),
		NewBlessEqPos = Bless_eq_pos#bless_eq_pos{cast_prop_temp = [], cast_prop = Bless_eq_pos#bless_eq_pos.cast_prop_temp},
		update_bless_eq_pos(NewBlessEqPos),
		calc_bless_eq_prop(Battle),%%记录属性
		flush_battle(Battle),
		player:send(#pk_GS2U_BlessEqCastRet{err_code = ?ERROR_OK, pos = Pos, stage = Stage, battle_pos = Battle, op = 1, bless_eq_pos = make_bless_eq_pos_msg(NewBlessEqPos)})
	catch
		ErrCode ->
			player:send(#pk_GS2U_BlessEqCastRet{err_code = ErrCode, pos = Pos, stage = Stage, battle_pos = Battle, op = 1})
	end;
%%英雄装备 放弃祝福(放弃)
bless_eq_cast(Battle, Stage, Pos, 2) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_cast_open(), ?ERROR_FunctionClose),
		?CHECK_THROW((Battle >= 1 andalso Battle =< ?Bless_Eq_BattlePos_Max) andalso (Stage >= 1 andalso Stage =< ?Bless_Eq_Stage_Max)
			andalso (Pos >= 1 andalso Stage =< ?Bless_Eq_Pos_Max), ?ERROR_Param),
		Bless_eq_pos = get_bless_eq_pos(Battle, Stage, Pos),
		%%对应位置有装备才能
		case Bless_eq_pos of
			#bless_eq_pos{uid = 0} ->%%没有装备英雄装备,不能进行祝福相关操作
				throw(?ErrorCode_Bless_Eq_NotWear);
			#bless_eq_pos{cast_prop_temp = []} ->%%暂时保存祝福为空，报错
				throw(?ErrorCode_Bless_Eq_CastInfoNotExist);
			#bless_eq_pos{} -> ok;
			_ -> throw(?ErrorCode_Bless_Eq_NotWear)
		end,
		Bless_eq = get_bless_eq(Bless_eq_pos#bless_eq_pos.uid),
		?CHECK_THROW(Bless_eq =/= {}, ?ErrorCode_Bless_Eq_NotExist),
		ItemCfg = cfg_petEquip:getRow(Bless_eq#bless_eq.cfg_id),
		?CHECK_THROW(ItemCfg =/= {}, ?ERROR_Cfg),
		NewBlessEq = Bless_eq_pos#bless_eq_pos{cast_prop_temp = []},
		update_bless_eq_pos(NewBlessEq),
		player:send(#pk_GS2U_BlessEqCastRet{err_code = ?ERROR_OK, pos = Pos, stage = Stage, battle_pos = Battle, op = 2, bless_eq_pos = make_bless_eq_pos_msg(NewBlessEq)})
	catch
		ErrCode ->
			player:send(#pk_GS2U_BlessEqCastRet{err_code = ErrCode, pos = Pos, stage = Stage, battle_pos = Battle, op = 2})
	end;
bless_eq_cast(_, _, _, Op) ->
	player:send(#pk_GS2U_BlessEqCastRet{err_code = ?ERROR_Param, op = Op}).


%% 英雄装备魂石一键镶嵌/卸下 1镶嵌  2卸下
soul_stone_1key_op(1, Pos, Stage, BattlePos, SoulPosList) ->%%
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_soul_stone_open(), ?ERROR_FunctionClose),
		%%检查出战位-阶段等数据是否正确
		Err1 = check_unlock(BattlePos, Stage),
		?ERROR_CHECK_THROW(Err1),
		PosSoulList = lists:ukeysort(1, SoulPosList),%%去除重复数据
		?CHECK_THROW(PosSoulList =/= [], ?ERROR_Param),
		%%老魂石列表
		#bless_eq_pos{uid = BlessEqUid, soul_stone_list = OldSoulPosList} = OldBlessEqPos = case get_bless_eq_pos(BattlePos, Stage, Pos) of
																								#bless_eq_pos{uid = 0} ->%%没有装备英雄装备,不能进行 镶嵌操作
																									throw(?ErrorCode_Bless_Eq_NotWear);
																								#bless_eq_pos{} = Info ->
																									Info;
																								_ ->
																									throw(?ErrorCode_Bless_Eq_NotWear)
																							end,
		{Err2, ItemList} = bag_player:get_bag_item(?BAG_HERO_STONE, [Uid || {_, Uid} <- PosSoulList]),
		?ERROR_CHECK_THROW(Err2),
		%%检查道具数量是否足够
		check_soul_num(ItemList, PosSoulList),
		%%对应装备数据
		#bless_eq{cfg_id = BlessEqCfgId} = get_bless_eq(BlessEqUid),
		#petEquipCfg{part = Part, quality = Quality} = cfg_petEquip:getRow(BlessEqCfgId),
		%%镶嵌数据
		AddSoulPosList = [{P, U, Item#item.cfg_id} || {P, U} <- PosSoulList, (Item = lists:keyfind(U, #item.id, ItemList)) =/= ?FALSE],
		%%检查镶嵌的数据是否满足品质要求，魂石类型要求
		{AddSoulList, _} = check_soul_stone_list(Part, Quality, AddSoulPosList),
		?IF(length(PosSoulList) =:= length(AddSoulList), skip, throw(?ERROR_Param)),%%每个装备的魂石格子可以镶嵌的魂石是固定的
		Fun = fun({SoulPos, _, _}, RemoveSoulList) ->
			case lists:keyfind(SoulPos, 1, OldSoulPosList) of
				?FALSE -> RemoveSoulList;
				{_, OldUid, OldCfgId} ->
					[{SoulPos, OldUid, OldCfgId} | RemoveSoulList]
			end
			  end,
		%%要装配的魂石列表   要卸下的魂石列表
		RemoveSoulList = lists:foldl(Fun, [], AddSoulList),
		%%先卸下魂石
		gem_bag_off_list(?TRUE, RemoveSoulList),
		%%装配后这部分的列表[pos,newuid,cfgid]
		NewSoulList2 = gem_bag_on_list(?TRUE, AddSoulList),
		NewSoulList = NewSoulList2 ++ OldSoulPosList -- RemoveSoulList,
		NewBlessEqPos = OldBlessEqPos#bless_eq_pos{soul_stone_list = NewSoulList},
		update_bless_eq_pos(NewBlessEqPos),
		calc_bless_eq_prop(BattlePos),
		flush_battle(BattlePos),
		check_notice({BattlePos, Stage}),
		attainment:check_attainment(?Attainments_Type_PetEq_SoulStone_Lv_Num),
		player:send(#pk_GS2U_BlessEqSoulStoneOPRet{pos = Pos, stage = Stage, battle_pos = BattlePos,
			op = 1, op_pos = [#pk_key_big_value{key = K, value = V} || {K, V, _} <- NewSoulList]})
	catch
		Error ->
			player:send(#pk_GS2U_BlessEqSoulStoneOPRet{pos = Pos, stage = Stage, battle_pos = BattlePos,
				op = 1, err_code = Error})
	end;
%%卸下英雄魂石
soul_stone_1key_op(2, Pos, Stage, BattlePos, SoulPosList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(is_soul_stone_open(), ?ERROR_FunctionClose),
		PosSoulList = lists:ukeysort(1, SoulPosList),
		?CHECK_THROW(PosSoulList =/= [], ?ERROR_Param),
		#bless_eq_pos{soul_stone_list = OldSoulPosList} = OldBlessEqPos = case get_bless_eq_pos(BattlePos, Stage, Pos) of
																			  #bless_eq_pos{uid = 0} ->%%没有装备英雄装备,不能进行 镶嵌操作
																				  throw(?ErrorCode_Bless_Eq_NotWear);
																			  #bless_eq_pos{} = Info ->
																				  Info;
																			  _ ->
																				  throw(?ErrorCode_Bless_Eq_NotWear)
																		  end,
		{Err1, ItemList} = bag_player:get_bag_item(?BAG_HERO_STONE_EQUIP, [Uid || {_, Uid} <- PosSoulList]),
		?ERROR_CHECK_THROW(Err1),
		%%检查道具数量是否足够  没有问题就返回[{P, Uid, Item#item.cfg_id}]
		RemoveSoulPosList = check_soul_num(ItemList, PosSoulList),
		Fun = fun({SoulPos, Uid, CfgId} = P, {RemoveSoulList, Acc}) ->
			case lists:member(P, Acc) of
				?FALSE -> throw(?ERROR_Param);
				_ -> {[{SoulPos, Uid, CfgId} | RemoveSoulList], lists:keydelete(Uid, 2, Acc)}
			end
			  end,
		%% 卸下的魂石列表  剩余的魂石列表
		{RemoveList, NewSoulPosList} = lists:foldl(Fun, {[], OldSoulPosList}, RemoveSoulPosList),
		%%卸下魂石
		gem_bag_off_list(?TRUE, RemoveList),
		NewBlessEqPos = OldBlessEqPos#bless_eq_pos{soul_stone_list = NewSoulPosList},
		update_bless_eq_pos(NewBlessEqPos),
		calc_bless_eq_prop(BattlePos),
		flush_battle(BattlePos),
		check_notice({BattlePos, Stage}),%%检查发送公告
		player:send(#pk_GS2U_BlessEqSoulStoneOPRet{pos = Pos, stage = Stage, battle_pos = BattlePos,
			op = 2, op_pos = [#pk_key_big_value{key = K, value = V} || {K, V} <- SoulPosList]})
	catch
		Error ->
			player:send(#pk_GS2U_BlessEqSoulStoneOPRet{pos = Pos, stage = Stage, battle_pos = BattlePos,
				op = 2, err_code = Error})
	end;
soul_stone_1key_op(Op, Pos, Stage, BattlePos, OpPosList) ->
	player:send(#pk_GS2U_BlessEqSoulStoneOPRet{err_code = ?ERROR_Param, pos = Pos, stage = Stage, battle_pos = BattlePos, op = Op,
		op_pos = [#pk_key_big_value{key = K, value = V} || {K, V} <- OpPosList]}).


%%检查出战位-阶段等数据是否正确
check_unlock(BattlePos, Stage) ->
	try
		?CHECK_THROW(Stage > 0 andalso Stage =< ?Bless_Eq_Stage_Max, ?ErrorCode_Bless_Eq_StageNotUnLock),
		?CHECK_THROW(BattlePos > 0 andalso BattlePos =< ?Bless_Eq_BattlePos_Max, ?ErrorCode_Bless_Eq_BattleNotUnLock),
		%%出战位未解锁
		?CHECK_THROW(pet_pos:is_pet_pos_unlock(?STATUS_FIGHT, BattlePos), ?ErrorCode_Bless_Eq_BattleNotUnLock),
		Stage_lv = get_stage_lv(BattlePos),
		%%阶段未解锁
		?CHECK_THROW(Stage_lv >= Stage, ?ErrorCode_Bless_Eq_StageNotUnLock),
		?ERROR_OK
	catch
		Error -> Error
	end.

rand_prop([], _, Ret) -> lists:reverse(Ret);
rand_prop([Index | T], AttrList, Ret) ->
	AttrList0 = case Index =< length(AttrList) of
					?TRUE -> lists:nth(Index, AttrList);
					_ -> []
				end,
	case AttrList0 of%%某配置可能有问题，没填之类的
		[] -> throw(?ERROR_Cfg);
		_ -> ok
	end,
	%%{属性id，值，品质，评分值，权重值}
	AttrList1 = [{Weight, {Index, Id}} || {Id, _, _, _, Weight} <- AttrList0, check_prop(Id, Ret)],%%检查是否已经有该属性
	case common:getRandomValueFromWeightList(AttrList1, 0) of
		0 -> rand_prop(T, AttrList, Ret);
		{Key, Value} ->
			%%这里要将评分与属性合在一起
			rand_prop(T, AttrList, [{Key, Value} | Ret])
	end.
%%检查是否发送公告
check_notice({BattlePos, Stage}) ->
	OldSuitList = player_private_list:get_value(?Private_List_bless_eq_soul_stone_notice),
	SuitList = get_soul_suit({BattlePos, Stage})--OldSuitList,%%需要公告的套装列表
	case length(SuitList) =:= 0 of
		?TRUE -> skip;
		?FALSE ->
			PlayerText = player:getPlayerText(),
			Fun2 = fun({MaxNum, MaxLv}) ->
				marquee:sendChannelNotice(0, 0, d3_Soul_Stone_Notice1,
					fun(Language) ->
						language:format(language:get_server_string("D3_Soul_Stone_Notice1", Language), [PlayerText, MaxNum, MaxLv])
					end) end,
			lists:map(Fun2, SuitList),
			player_private_list:set_value(?Private_List_bless_eq_soul_stone_notice, SuitList ++ OldSuitList)
	end.

%% 属性是否可用
check_prop(Id, AttrList) ->
	case lists:keymember(Id, 1, AttrList) of
		?TRUE -> ?FALSE;
		?FALSE -> ?TRUE
	end.

%%检查要装备的魂石的数量是否有问题，返回 PosSoulList[ {pos,uid,cfgid}]
check_soul_num(ItemList, PosSoulList) ->
	UidCountList = common:listValueMerge([{Uid, 1} || {_, Uid} <- PosSoulList]),
	ItemCountList = [{P, Uid, Item#item.cfg_id} || {P, Uid} <- PosSoulList, (Item = lists:keyfind(Uid, #item.id, ItemList)) =/= ?FALSE,
		(Counts = lists:keyfind(Uid, 1, UidCountList)) =/= ?FALSE, Item#item.amount >= element(2, Counts)],
	?IF(length(PosSoulList) =:= length(ItemCountList), ItemCountList, throw(?ERROR_item_bag_amount)).

%%检查目前装备的魂石或者想装配的魂石是否有问题，  返回{   正常的部分(或者可以装配的)  , 该卸下的（不能装配的）}
check_soul_stone_list(Part, Quality, SoulStonePosList) ->
	GemList = [{Uid, Cfg#itemCfg.detailedType, Cfg#itemCfg.detailedType2} || {_, Uid, CfgId} <- SoulStonePosList, (Cfg = cfg_item:getRow(CfgId)) =/= {}],
	F = fun({Pos, SoulUid, _}) ->
		case cfg_heroGemLimit:getRow(Part, Pos) of
			{} -> ?FALSE;
			#heroGemLimitCfg{petEquipQuality = CfgPetEquipQuality, gemType = CfgGemType} ->
				case lists:keyfind(SoulUid, 1, GemList) of
					?FALSE ->
						?FALSE;
					{_, GemType, _} when GemType =:= CfgGemType andalso Quality >= CfgPetEquipQuality ->
						?TRUE;
					_ ->
						?FALSE
				end
		end end,
	Correct = lists:filter(F, SoulStonePosList),
	ErrList = SoulStonePosList--Correct,
	{Correct, ErrList}.

%%检查当前阶段之后的阶段 魂石列表是否正常,不正常就把魂石列表卸下（当不满足阶段要求时，需要卸下之后阶段的魂石）（在更新后使用）
%%					    出战位     出现变化的阶段
check_stage_soul_list(BattlePos) ->
	IsRemove = pet_pos:is_pet_pos_unlock(?STATUS_FIGHT, BattlePos),%%当前位置英雄未解锁
	%%最大阶段，超过该阶段的都需要卸下魂石
	MaxStage = calc_stage_lv(BattlePos),
	F = fun
			(#bless_eq_pos{stage = S, soul_stone_list = SoulStoneList, battle_pos = BattlePos2} = OldBlessEqPos, Acc) when
				BattlePos2 =:= BattlePos andalso S > MaxStage orelse IsRemove =:= ?FALSE ->
				L = gem_bag_off_list(?FALSE, SoulStoneList),
				case L of
					[] -> skip;
					_ ->
						?LOG_ERROR(" pet_bless_eq stage Condition not met,soul_stone remove error!  oldsoullist:~p,newsoullist:~p", [SoulStoneList, L])
				end,
				[OldBlessEqPos#bless_eq_pos{soul_stone_list = L} | Acc];
			(_, Acc) ->
				Acc
		end,
	BlessEqPosList = lists:foldl(F, [], get_bless_eq_pos_list()),
	update_bless_eq_pos(BlessEqPosList).

%% 英雄装备 功能是否开启
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetBlessEq) == 1 andalso guide:is_open_action(?OpenAction_PetBlessEq).
%% 英雄装备祝福 功能是否开启
is_cast_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetBlessEqCast) == 1 andalso guide:is_open_action(?OpenAction_PetBlessEqCast).
%% 英雄魂石 功能是否开启
is_soul_stone_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetBlessEqSoulStone) == 1 andalso guide:is_open_action(?OpenAction_PetBlessEqSoulStone).


%%计算套装属性-每个玩家有三个出战位  每个出战位根据阶段等级 有不同的阶段位数
%%calc_suit() ->
%%  [calc_suit(BattlePos) || BattlePos <- lists:seq(1, ?Bless_Eq_BattlePos_Max)].
%%计算对应出战位的套装属性
%%calc_suit(BattlePos) ->
%%  %%对应出战位的阶段数
%%  StageLv = get_stage_lv(BattlePos),
%%  [calc_suit(BattlePos, Stage) || Stage <- lists:seq(1, StageLv)].
%%计算的时候是套装类型 序号 属性 值 都算  但发送给客户端只需要 对应阶段位 给件数  给序号  都是列表
calc_suit(BattlePos, Stage) ->
	PetBlessPos = get_bless_eq_pos_list(BattlePos, Stage),
	case [Uid || #bless_eq_pos{uid = Uid} <- PetBlessPos, Uid =/= 0] of
		[] -> {[], []};
		UidList ->
			PosEqList = get_bless_eq_list(UidList),
			calc_suit_1(PosEqList)
	end.

calc_suit_1([]) -> {[], []};
calc_suit_1(PosEqList) ->
	CfgIdList = [CfgId || #bless_eq{cfg_id = CfgId} <- PosEqList],
	PetEquipList = [{EquipCfg#petEquipCfg.quality, EquipCfg#petEquipCfg.star} || CfgId <- CfgIdList, (EquipCfg = cfg_petEquip:getRow(CfgId)) =/= {}],
	lists:foldl(fun(SuitN, {SuitList, AttrList}) ->
		#petEquipSuitCfg{qualityStarSort = QualityStarSortList, attributeSort = AttributeSortList} = cfg_petEquipSuit:getRow(SuitN),
		MatchIndexList = common:listValueMerge(lists:foldl(fun({C, S}, Ret1) ->
			lists:foldl(fun({Index, NeedCha, NeedStar}, Ret2) ->
				case C > NeedCha orelse (C =:= NeedCha andalso S >= NeedStar) of
					?TRUE -> [{Index, 1} | Ret2];
					?FALSE -> Ret2
				end
						end, Ret1, QualityStarSortList)
														   end, [], PetEquipList)),
		case [Index || {Index, Num} <- MatchIndexList, Num >= SuitN] of
			[] -> {SuitList, AttrList};
			IndexList ->
				MatchIndex = lists:max(IndexList),
				{[{SuitN, MatchIndex} | SuitList], [{K, V} || {Index, K, V} <- AttributeSortList, Index =:= MatchIndex] ++ AttrList}
		end
				end, {[], []}, cfg_petEquipSuit:getKeyList()).

%%计算 总的阶段等级
calc_stage_lv() ->
	%%计算并保存所有出战位数据到进程字典
	StageLvList = [calc_stage_lv(BattlePos) || BattlePos <- lists:seq(1, ?Bless_Eq_BattlePos_Max)],%%%%所有出战位
	put_all_stage_lv(StageLvList),
	StageLvList.
%%     计算对应 出战位的阶段等级
calc_stage_lv(BattlePos) ->
	calc_stage_lv(BattlePos, cfg_petExpansion:getKeyList(), 1).
calc_stage_lv(_BattlePos, [], RetStageLv) -> RetStageLv;
calc_stage_lv(BattlePos, [StageLv | T], RetStageLv) ->
	#petExpansionCfg{unlock = Unlock} = cfg_petExpansion:getRow(StageLv),
	case lists:all(fun(CondParam) -> is_condition(CondParam, StageLv, BattlePos) end, Unlock) of
		?TRUE -> calc_stage_lv(BattlePos, T, StageLv);
		?FALSE -> RetStageLv
	end.

%%装备需求（序号ID，参数1，参数2，参数3）
%%序号ID=1 装备需求：参数1=装备品质；参数2=装备星级；参数3=件数
is_condition({1, Pam1, Pam2, Pam3}, StageLv, BattlePos) ->
	UidList = [Uid || #bless_eq_pos{uid = Uid} <- get_bless_eq_pos_list(BattlePos, StageLv - 1), Uid =/= 0],
	case UidList of
		[] -> ?FALSE;
		_ ->
			CfgIdList = [CfgId || #bless_eq{cfg_id = CfgId} <- get_bless_eq_list(UidList)],
			PetEquipList = [{EquipCfg#petEquipCfg.quality, EquipCfg#petEquipCfg.star} || CfgId <- CfgIdList, (EquipCfg = cfg_petEquip:getRow(CfgId)) =/= {}],
			F = fun({C, S}) -> C > Pam1 orelse (C =:= Pam1 andalso S >= Pam2) end,
			Num = length(lists:filter(F, PetEquipList)),
			Num >= Pam3
	end;

%%英雄星级
%%序号ID=2 出战英雄需求： 参数1=英雄星数；参数2、3=0
is_condition({2, Pam1, _, _}, _, BattlePos) ->
	case get_fight_list(BattlePos) of
		{} -> ?FALSE;
		#pet_new{star = Star} -> Star >= Pam1
	end;
is_condition({_, _, _, _}, _, _) ->
	?FALSE.


%%获取对应出战位的英雄数据
get_fight_list(PetPos) ->
	case pet_pos:get_pet_pos(?STATUS_FIGHT, PetPos) of
		#pet_pos{uid = Uid} when Uid > 0 -> pet_new:get_pet(Uid);
		_ -> {}
	end.

%% -------------------------- 属性 --------------------------
%%  Battle
put_bless_eq_prop(Pos, Prop) -> put({bless_eq_prop, Pos}, Prop).
get_bless_eq_prop(Pos) -> get({bless_eq_prop, Pos}).

%%刷新装备属性 总属性
calc_bless_eq_prop() ->
	[calc_bless_eq_prop(BattlePos) || BattlePos <- lists:seq(1, ?Bless_Eq_BattlePos_Max)].
%%刷新装备属性 对应出战位总属性
calc_bless_eq_prop(BattlePos) ->
	StageLv = get_stage_lv(BattlePos),
	EqPosList = [EqPos || #bless_eq_pos{battle_pos = BattlePos_, uid = Uid, stage = Stg} = EqPos <- get_bless_eq_pos_list(),
		Stg =< StageLv andalso BattlePos_ =:= BattlePos andalso Uid > 0],
	%%装备属性(基础属性-祝福属性-卓越属性-魂石属性)   魂石位置等级列表（计算魂石套装属性用）
	{AttrList1, SoulPosList} = lists:foldl(
		fun(#bless_eq_pos{uid = Uid, pos = Pos, stage = Stage, cast_prop = CastProp, soul_stone_list = SoulStoneList}, {Acc, SoulPosListAcc}) ->
			case get_bless_eq(Uid) of
				{} -> {Acc, SoulPosListAcc};
				#bless_eq{cfg_id = CfgId, rand_prop = RandProp} ->
					#petEquipCfg{attribute = BaseAttr, starAttribute1 = StatAttr1, starAttribute2 = StatAttr2, starAttribute3 = StatAttr3} = cfg_petEquip:getRow(CfgId),
					CastProps = get_attr(CastProp, 1),
					BaseAttrList = [{K, V} || {K, V} <- BaseAttr],%%基础属性
					F = fun({K, V}, Ret) ->
						StatAttr = case K of
									   1 -> StatAttr1;
									   2 -> StatAttr2;
									   3 -> StatAttr3
								   end,
						case lists:keyfind(V, 1, StatAttr) of
							{V, Value, _, _, _} -> [{V, Value} | Ret];
							_ -> Ret
						end
						end,
					RandPropList = lists:foldl(F, [], RandProp),
					{SoulStonePropList, NewSoulPosListAcc} = case SoulStoneList of%%魂石列表为空
																 [] -> {[], SoulPosListAcc};
																 _ ->
																	 Ls = lists:sort([Cfg#itemCfg.detailedType2 || {_, _, CfgID} <- SoulStoneList, (Cfg = cfg_item:getRow(CfgID)) =/= {}]),
																	 {get_soul_attr(SoulStoneList), [{{Stage, Pos}, Ls} | SoulPosListAcc]}
															 end,
					{BaseAttrList ++ RandPropList ++ CastProps ++ SoulStonePropList ++ Acc, NewSoulPosListAcc}
			end end, {[], []}, EqPosList),
	AttrList2 = lists:foldl(fun({_, StageEqPosList}, Acc) ->%%英雄装备套装属性
		PosEqList = get_bless_eq_list([Uid || #bless_eq_pos{uid = Uid} <- StageEqPosList]),
		{_, SuitAttr} = calc_suit_1(PosEqList),
		SuitAttr ++ Acc end, [], common:group_record(#bless_eq_pos.stage, EqPosList)),
	SoulSuitAttrList = get_soul_stone_suit_attr(SoulPosList, BattlePos, StageLv),%%魂石套装属性
	AllProp = attribute:base_prop_from_list(common:listValueMerge(AttrList1 ++ AttrList2 ++ SoulSuitAttrList)),
	%%增加的资质  增加的英雄属性
	{BlessEqQual, BlessEqAttr} = lists:foldl(fun(#prop{index = T, base = V} = Prop, {QualAcc, BlessEqAcc}) ->
		NT = T - 20000,
		case lists:member(NT, ?P_PET_QUALITY_LIST) of
			?TRUE -> {[{T, V} | QualAcc], BlessEqAcc};
			?FALSE -> {QualAcc, [Prop#prop{index = NT} | BlessEqAcc]}
		end end, {[], []}, AllProp),
	put_bless_eq_prop(BattlePos, {BlessEqQual, BlessEqAttr}).

%% 获取属性列表
get_attr(IDs, Order) -> get_attr(IDs, Order, []).
get_attr([], _, Ret) -> Ret;
get_attr([{1, ID} | T], Order, Ret) ->
	case cfg_ornamentAttri:getRow(ID, Order) of
		#ornamentAttriCfg{attribute = Attr} -> get_attr(T, Order, Ret ++ Attr);
		_ -> get_attr(T, Order, Ret)
	end;
get_attr([{2, _} | T], Order, Ret) ->
	get_attr(T, Order, Ret);
get_attr([ID | T], Order, Ret) ->
	case cfg_ornamentAttri:getRow(ID, Order) of
		#ornamentAttriCfg{attribute = Attr} -> get_attr(T, Order, Ret ++ Attr);
		_ -> get_attr(T, Order, Ret)
	end.

%%获取  魂石基础属性列表
get_soul_attr(SoulStoneList) ->
	CfgIdList = [CfgId || {_, _, CfgId} <- SoulStoneList],
	F = fun(CfgId, AttrAcc) ->
		case cfg_item:getRow(CfgId) of
			#itemCfg{detailedType = GemType, detailedType2 = GemLv} ->
				case cfg_heroGemBase:getRow(GemType, GemLv) of
					#heroGemBaseCfg{attribute = Attr} ->
						AttrAcc ++ Attr;
					{} ->
						?LOG_ERROR(" cfg_heroGemBase no cfg ~p", [CfgId]),
						AttrAcc
				end;
			_ ->
				?LOG_ERROR("cfg_item no cfg ~p", [CfgId]),
				AttrAcc
		end
		end,
	lists:foldl(F, [], CfgIdList).


%%计算单个出战位的魂石套装属性(同时更新套装格套装等级) [{{阶段，位置},魂石等级列表(小->大)}]  阶段数
get_soul_stone_suit_attr([], BattlePos, StageLv) ->
	[set_soul_suit({BattlePos, Stage}, []) || Stage <- lists:seq(1, StageLv)],
	[];
get_soul_stone_suit_attr(KeySoulPosList, BattlePos, StageLv) ->
	F = fun(Stage, Acc) ->
		%%每个部位的
		List = [{length(SoulLvList), SoulLvList} || {{St, _}, SoulLvList} <- KeySoulPosList, St =:= Stage],
		case length(List) of
			?Bless_Eq_Pos_Max ->%%满足4个部位
				%%最小格数
				{MinNum, _} = lists:min(List),
				Fun = fun({C, L, Attr}, {AttrAcc, SuitAcc}) ->
					Fun2 = fun({Length, LvList}, MinLvAcc) ->
						case Length >= C of
							?TRUE -> %%某部位对应格数的最小魂石等级
								[lists:nth(Length - C + 1, LvList) | MinLvAcc];
							?FALSE -> [0 | MinLvAcc]
						end
						   end,
					MinLv = lists:min(lists:foldl(Fun2, [], List)),%%阶段各部位最小魂石等级
					case MinLv >= L of
						?TRUE ->
							{[Attr | AttrAcc], [{C, L} | SuitAcc]};
						?FALSE -> {AttrAcc, SuitAcc}
					end
					  end,
				SuitList = [{Count, Lv, Cfg#heroGemSuitCfg.attribute} || {Count, Lv} <- cfg_heroGemSuit:getKeyList(), Count =< MinNum,
					(Cfg = cfg_heroGemSuit:getRow(Count, Lv)) =/= {}],
				%%{属性列表，激活套装id列表}
				{A, B} = lists:foldl(Fun, {[], []}, SuitList),
				CountList = lists:foldl(fun({C, _, _}, CountAcc) ->
					?IF(lists:member(C, CountAcc), CountAcc, [C | CountAcc]) end, [], SuitList),
				StageSuitList = lists:foldl(fun(Count, StageSuitAcc) ->
					L = [{C, L} || {C, L} <- B, C =:= Count],
					?IF(L =:= [], StageSuitAcc, [lists:max(L) | StageSuitAcc])
											end, [], CountList),
				set_soul_suit({BattlePos, Stage}, StageSuitList),
				A ++ Acc;
			_ ->%%数量不够，无套装属性
				set_soul_suit({BattlePos, Stage}, []),
				Acc
		end
		end,
	lists:flatten(lists:foldl(F, [], lists:seq(1, StageLv))).

%%生成卓越属性
make_cast_rand(OldCast, #petOrnamentForgeCfg{starRule = RuleList} = CastCfg, Time) ->
	Rule = case [[R1, R2, R3] || {Min, Max, R1, R2, R3} <- RuleList, Time >= Min, Max == 0 orelse Time =< Max] of
			   [] -> [];
			   [L | _] -> [R0 || R0 <- L, R0 > 0]
		   end,
	AttrList = [
		CastCfg#petOrnamentForgeCfg.starAttribute1,
		CastCfg#petOrnamentForgeCfg.starAttribute2,
		CastCfg#petOrnamentForgeCfg.starAttribute3,
		CastCfg#petOrnamentForgeCfg.starAttribute4,
		CastCfg#petOrnamentForgeCfg.starAttribute5,
		CastCfg#petOrnamentForgeCfg.starAttribute6,
		CastCfg#petOrnamentForgeCfg.starAttribute7,
		CastCfg#petOrnamentForgeCfg.starAttribute8,
		CastCfg#petOrnamentForgeCfg.starAttribute9,
		CastCfg#petOrnamentForgeCfg.starAttribute10,
		CastCfg#petOrnamentForgeCfg.starAttribute11,
		CastCfg#petOrnamentForgeCfg.starAttribute12,
		CastCfg#petOrnamentForgeCfg.starAttribute13,
		CastCfg#petOrnamentForgeCfg.starAttribute14,
		CastCfg#petOrnamentForgeCfg.starAttribute15
	],
	make_cast_rand(0, OldCast, Rule, AttrList, []).
make_cast_rand(CastNum, _, RandRule, AttrList, NewCast) when CastNum >= 10 ->
	?LOG_ERROR("cast loop ~p times more, rule:~p, list:~p", [CastNum, RandRule, AttrList]),
	NewCast;
make_cast_rand(CastNum, OldCast, RandRule, AttrList, _) ->
	NewCast = rand_cast(RandRule, AttrList, []),
	case lists:sort(OldCast) =:= lists:sort(NewCast) of
		?TRUE -> make_cast_rand(CastNum + 1, OldCast, RandRule, AttrList, NewCast);
		?FALSE -> NewCast
	end.
rand_cast([], _, Ret) -> Ret;
rand_cast([Index | T], AttrList, Ret) ->
	AttrList0 = case Index =< length(AttrList) of
					?TRUE -> lists:nth(Index, AttrList);
					_ -> []
				end,
	AttrList1 = [{{AttrT, AttrI}, AttrW} || {AttrT, AttrI, AttrW} <- AttrList0, not lists:member({AttrT, AttrI}, Ret)],
	case common:getRandomValueFromWeightList_1(AttrList1, {0, 0}) of
		{0, 0} -> rand_cast(T, AttrList, Ret);
		{AT, AI} -> rand_cast(T, AttrList, Ret ++ [{AT, AI}])
	end.


%% 生成配饰实例
make_bless_eq(#item{id = Uid, cfg_id = CfgId, bind = Bind}) ->
	Cfg = cfg_petEquip:getRow(CfgId),
	Orn = #bless_eq{
		player_id = player:getPlayerID(),
		uid = Uid,
		cfg_id = CfgId,
		bind = Bind,
		rand_prop = make_rand_prop(Cfg)
	},
	Orn.

%% 生成极品属性
make_rand_prop(#petEquipCfg{starRule = Rule} = Cfg) ->
	AttrList = [
		Cfg#petEquipCfg.starAttribute1,
		Cfg#petEquipCfg.starAttribute2,
		Cfg#petEquipCfg.starAttribute3
	],
	rand_prop(Rule, AttrList, []).
%% 拼装消息
make_bless_eq_msg(#bless_eq{} = Orn) ->
	#petEquipCfg{part = Pos} = cfg_petEquip:getRow(Orn#bless_eq.cfg_id),
	#pk_bless_eq{
		uid = Orn#bless_eq.uid,
		cfg_id = Orn#bless_eq.cfg_id,
		bind = Orn#bless_eq.bind,
		int_lv = Orn#bless_eq.int_lv,
		rand_prop = common:to_kv_msg(Orn#bless_eq.rand_prop),
		pos = Pos
	}.
make_bless_eq_pos_msg(#bless_eq_pos{} = OrnPos) ->
	CfgId = case get_bless_eq(OrnPos#bless_eq_pos.uid) of
				#bless_eq{cfg_id = ID} -> ID;
				{} -> 0
			end,
	#pk_bless_eq_pos{
		uid = OrnPos#bless_eq_pos.uid,
		cfg_id = CfgId,
		pos = OrnPos#bless_eq_pos.pos,
		stage = OrnPos#bless_eq_pos.stage,
		battle_pos = OrnPos#bless_eq_pos.battle_pos,
		cast_prop = [ID || {1, ID} <- OrnPos#bless_eq_pos.cast_prop],
		cast_prop_temp = [ID || {1, ID} <- OrnPos#bless_eq_pos.cast_prop_temp],
		soul_stone_list = [#pk_key_big_value{key = K, value = V} || {K, V, _} <- OrnPos#bless_eq_pos.soul_stone_list]
	}.