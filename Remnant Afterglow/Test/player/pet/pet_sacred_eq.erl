%%%-------------------------------------------------------------------
%%% @author zhufu
%%% @copyright (C) 2023, DoubleGame
%%% @doc
%%% 英雄圣装
%%% @end
%%% Created : 26. 5月 2023 15:22
%%%-------------------------------------------------------------------
-module(pet_sacred_eq).
-author("zhufu").

-include("global.hrl").
-include("record.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("error.hrl").
-include("sacred_eq.hrl").
-include("item.hrl").
-include("db_table.hrl").
-include("netmsgRecords.hrl").
-include("player_private_list.hrl").
-include("attribute.hrl").
-include("player_task_define.hrl").
-include("attainment.hrl").

-include("cfg_item.hrl").
-include("cfg_ornamentForge.hrl").
-include("cfg_ornamentEquip.hrl").
-include("cfg_ornamentAttri.hrl").
-include("cfg_ornamentWear.hrl").
-include("cfg_ornamentStrength.hrl").
-include("cfg_ornamentAdvance.hrl").
-include("cfg_ornamentStrengthLimit.hrl").
-include("cfg_ornamentStrengthAward.hrl").
-include("cfg_ornamentSuit.hrl").
-include("cfg_ornamentSkill.hrl").
-include("cfg_equipScoreIndex.hrl").
-include("cfg_skillBase.hrl").
-include("cfg_skillCorr.hrl").
-include("cfg_buffCorr.hrl").
-include("cfg_disassemble.hrl").

-define(TablePetSacredEq, db_sacred_eq).
-define(TablePetSacredEqPos, db_sacred_eq_pos).

-export([on_load/0, send_all_info/0]).
-export([add_eq_ins/1, on_sacred_eq_add/2, on_sacred_eq_delete/1]).
-export([on_sacred_eq_op/2, on_sacred_eq_1key_op/2, on_sacred_eq_lv_up/2, on_sacred_eq_stage_up/1]).
-export([on_sacred_eq_cast/2, on_sacred_eq_suit_add/1, on_sacred_eq_fade/1]).
-export([get_prop/0, get_prop/1, get_player_skill_list/0, get_pet_skill_list/1, get_buff_list/0, get_score/0, get_max_score/0, get_char_star_type_num/3]).
-export([get_sacred_eq/1, check_item/2, clear_inherit/0, check_inherit/1, get_inherit/0, get_eq_msg/1]).
-export([list_2_sacred_eq/1, list_2_sacred_eq_pos/1, sacred_eq_2_list/1, sacred_eq_pos_2_list/1]).
%%%===================================================================
%%% API
%%%===================================================================
%%加载数据
on_load() ->
	load_data(),%%加载数据
	calc_sacred_attr(),
	calc_master_prop(),
	calc_suit_attr(),
	flush_prop(?FALSE),
	score_change().

%%发送所有英雄圣装信息
send_all_info() ->
	case is_func_open() of
		?TRUE ->
			%%同步英雄圣装数据
			player:send(#pk_GS2U_SacredEqSync{
				masterlv = variable_player:get_value(?Variable_Player_PetSacredEq_MasterLv),
				sacred_eq_list = lists:map(fun make_sacred_eq_msg/1, get_sacred_eq_list()),
				sacred_eq_pos_list = lists:map(fun make_sacred_eq_pos_msg/1, get_sacred_eq_pos_list())
			});
		_ -> skip
	end.

%% 添加实例回调
add_eq_ins(#sacred_eq{} = Sac) ->
	add_eq_ins([Sac]);
add_eq_ins(SacList) ->
	F = fun(#sacred_eq{uid = Uid} = Sac, Ret) ->
		case get_sacred_eq(Uid) of
			#sacred_eq{} -> Ret;
			_ ->
				update_sacred_eq(Sac),
				[Uid | Ret]
		end
		end,
	lists:foldl(F, [], SacList),
	ok.

%%圣装添加
on_sacred_eq_add(AddList, Reason) ->
	?metrics(begin
				 sacred_eq_add(AddList, Reason) end).
%%圣装删除
on_sacred_eq_delete(DeleteList) ->
	?metrics(begin
				 sacred_eq_delete(DeleteList) end).

%%英雄圣装穿戴卸下操作
on_sacred_eq_op(Op, Uid) ->
	?metrics(begin
				 sacred_eq_op(Op, Uid) end).

%%英雄圣装一键装备卸下
on_sacred_eq_1key_op(Op, UidList) ->
	?metrics(begin
				 sacred_eq_1key_op(Op, UidList) end).

%%英雄圣装-升级
on_sacred_eq_lv_up(Uid, AddLevel) ->
	?metrics(begin
				 sacred_eq_lv_up(Uid, AddLevel) end).

%%英雄圣装升阶段
on_sacred_eq_stage_up(Uid) ->
	?metrics(begin
				 acred_eq_stage_up(Uid) end).

%%圣装祝福
on_sacred_eq_cast(Op, Pos) ->
	?metrics(begin
				 sacred_eq_cast(Op, Pos) end).

%%英雄圣装大师属性点亮
on_sacred_eq_suit_add(NewSuit) ->
	?metrics(begin
				 sacred_eq_suit_add(NewSuit) end).

%%英雄圣装 圣装分解
on_sacred_eq_fade(UidList) ->
	?metrics(begin
				 sacred_eq_fade(UidList) end).

%% 英雄圣装 功能是否开启
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetSacredEq) == 1 andalso guide:is_open_action(?OpenAction_PetSacredEq).

%%获取属性
%%[基础属性（英雄）（受祝福属性影响（已处理））
%%极品属性（英雄）（受祝福属性影响（已处理））
%%强化属性 （英雄） 加成（不受其他影响）
%%大师属性 （英雄） 加成（不受其他影响）
%%套装属性 （英雄）加成（不受其他影响）]
%%卓越属性（玩家）（受祝福属性影响（已处理））
%%祝福属性 （玩家）  加成（不受其他影响）
get_prop() ->
	get_prop(player:getPlayerID()).
get_prop(PlayerId) ->
	case player:getPlayerID() =:= PlayerId of
		?TRUE ->%%玩家进程
			case is_func_open() of
				?TRUE -> get_sacred_all_prop();
				?FALSE -> {[], [], []}
			end;
		?FALSE ->%%其他进程
			SacredEqPosList = [EqPos || #sacred_eq_pos{} = EqPos <- table_player:lookup(?TablePetSacredEqPos, PlayerId)],
			SacredEqList = [Eq || #sacred_eq{} = Eq <- table_player:lookup(?TablePetSacredEq, PlayerId)],
			Fun = fun({BaseProp, RandProp, BeyondProp, CastProp, IntProp}, {BasePropListRet, RandPropListRet, BeyondPropListRet, CastPropListRet, IntPropListRet}) ->
				{attribute:prop_merge(BaseProp, BasePropListRet), attribute:prop_merge(RandProp, RandPropListRet),
					attribute:prop_merge(BeyondProp, BeyondPropListRet), attribute:prop_merge(CastProp, CastPropListRet), attribute:prop_merge(IntProp, IntPropListRet)}
				  end,
			AttrList = calc_sacred_attr(SacredEqList, SacredEqPosList),%%[{}}]
			{BasePropList, RandPropList, BeyondPropList, CastPropList, IntPropList} = lists:foldl(Fun, {[], [], [], [], []}, AttrList),
			SuitPropList = calc_suit_attr(SacredEqList, SacredEqPosList, ?FALSE),%%套装属性
			MasterLv = variable_player:get_player_value(PlayerId, ?Variable_Player_PetSacredEq_MasterLv),
			Fun2 = fun(Lv, PropRet) ->
				case cfg_ornamentStrengthAward:getRow(Lv) of
					#ornamentStrengthAwardCfg{attribute = Attr} ->
						attribute:base_prop_from_list(Attr) ++ PropRet;
					_ -> PropRet
				end end,
			MasterPropList = lists:foldl(Fun2, [], lists:seq(1, MasterLv)),
			Fun3 = fun(#prop{index = Index} = Prop, {PropRet, RandRet}) ->
				case Index >= 20000 of
					?TRUE -> {[Prop#prop{index = Index - 20000} | PropRet], RandRet};
					?FALSE ->
						case Index >= 10000 of
							?TRUE -> {PropRet, [Prop | RandRet]};
							?FALSE -> {[Prop | PropRet], RandRet}
						end
				end end,
			{PetPropList, PlayPropList} = lists:foldl(Fun3, {[], []}, attribute:prop_merge(BasePropList ++ RandPropList ++ IntPropList ++ MasterPropList, SuitPropList)),
			{PetPropList, BeyondPropList ++ PlayPropList, CastPropList}
	end.

%%获取玩家技能列表
get_player_skill_list() ->
	List = [CastProp || #sacred_eq_pos{pos = Pos, bless_prop = CastProp} <- get_sacred_eq_pos_list(), CastProp =/= [] andalso is_cast_active(Pos)],
	MyCareer = player:getCareer(),
	get_skill_list(List, MyCareer, 1).

get_pet_skill_list(PlayerID) ->
	case PlayerID =:= player:getPlayerID() of
		?TRUE ->
			List = [CastProp || #sacred_eq_pos{pos = Pos, bless_prop = CastProp} <- get_sacred_eq_pos_list(), CastProp =/= [] andalso is_cast_active(Pos)],
			MyCareer = player:getCareer(),
			get_skill_list(List, MyCareer, 2);
		?FALSE ->
			List = [CastProp || #sacred_eq_pos{pos = Pos, bless_prop = CastProp} <- table_player:lookup(?TablePetSacredEqPos, PlayerID), CastProp =/= [] andalso is_cast_active(Pos)],
			MyCareer = mirror_player:get_player_career(PlayerID),
			get_skill_list(List, MyCareer, 2)
	end.

%% 1为玩家技能  2为英雄
get_skill_list(L, MyCareer, P) ->
	get_skill_list(L, [], MyCareer, P).
get_skill_list([], Ret, _, _) -> Ret;
get_skill_list([{1, _} | T], Ret, MyCareer, P) ->
	get_skill_list(T, Ret, MyCareer, P);
get_skill_list([{2, ID} | T], Ret, MyCareer, P) ->
	case cfg_ornamentSkill:getRow(ID) of
		#ornamentSkillCfg{skill = Sk} ->
			Skill = [{Type, Skill, Index} || {TargetType, C, Type, Skill, Index} <- Sk, TargetType =:= P andalso (C =:= 0 orelse C =:= MyCareer)],
			get_skill_list(T, Skill ++ Ret, MyCareer, P);
		_ -> get_skill_list(T, Ret, MyCareer, P)
	end;
get_skill_list([L | T], Ret, MyCareer, P) when is_list(L) ->
	get_skill_list(T, get_skill_list(L, Ret, MyCareer, P), MyCareer, P).

%%获取buff列表
get_buff_list() ->
	List = [CastProp || #sacred_eq_pos{pos = Pos, bless_prop = CastProp} <- get_sacred_eq_pos_list(), is_cast_active(Pos), CastProp =/= []],
	get_buff_list(List, []).
get_buff_list([], Ret) -> Ret;
get_buff_list([{1, _} | T], Ret) ->
	get_buff_list(T, Ret);
get_buff_list([{2, ID} | T], Ret) ->
	case cfg_ornamentSkill:getRow(ID) of
		#ornamentSkillCfg{buffCorr = Buff} ->
			get_buff_list(T, Buff ++ Ret);
		_ -> get_buff_list(T, Ret)
	end;
get_buff_list([L | T], Ret) when is_list(L) ->
	get_buff_list(T, get_buff_list(L, Ret)).

%%获取当前评分
get_score() ->
	lists:sum([Score || Pos <- lists:seq(?Pos_Min, ?Pos_Max), (Score = get_sacred_eq_score(Pos)) =/= ?UNDEFINED]).
%%获取英雄圣装历史最大评分
get_max_score() ->
	variable_player:get_value(?Variable_Player_MaxSacredEqScore).

%%获取穿戴有多少个A阶B品质C星级及以上的英雄圣装
get_char_star_type_num(Stage, Character, Star) ->
	lists:foldl(
		fun(#sacred_eq_pos{uid = Uid}, Acc) ->
			case get_sacred_eq(Uid) of
				#sacred_eq{cfg_id = CfgId} ->
					case cfg_item:getRow(CfgId) of
						#itemCfg{order = Order, character = C, detailedType3 = S} ->
							case C > Character of
								?TRUE when Order >= Stage ->
									Acc + 1;
								?FALSE when (C =:= Character andalso S >= Star andalso Order >= Stage) ->
									Acc + 1;
								_ -> Acc
							end;
						_ -> Acc
					end;
				_ -> Acc
			end
		end, 0, get_sacred_eq_pos_list()).

%%根据uid获取圣装数据
get_sacred_eq(0) -> {};
get_sacred_eq(Uid) ->
	case lists:keyfind(Uid, #sacred_eq.uid, get_sacred_eq_list()) of
		#sacred_eq{} = Info -> Info;
		_ -> {}
	end.

%%合成道具检查，检查对应道具是否满足要求（品质，星级,攻防部位）
check_item({Character, IsAttack, Star}, Uid) ->
	case get_sacred_eq(Uid) of
		#sacred_eq{cfg_id = CfgId} ->
			#itemCfg{character = C, detailedType2 = I, detailedType3 = S} = cfg_item:getRow(CfgId),
			Character =:= C andalso IsAttack =:= I andalso Star =:= S;
		_ ->
			?FALSE
	end.

%%清空 道具
clear_inherit() ->
	put(sacred_eq_synthetic, []).
%%计算-保存 道具配置+货币配置
check_inherit(UidList) ->
	NewUidList = lists:filter(fun(Uid) ->%%去掉列表中，未强化未升阶的但可以走通用拆解的幻彩或暗金装备，合成时这种装备是直接消耗掉的，强化过或升阶过的才走fade_sacred_eq拆解
		case bag_player:get_bag_item(?BAG_ORNAMENT, Uid) of
			{?ERROR_OK, [#item{cfg_id = CfgId}]} ->
				case cfg_item:getRow(CfgId) of
					#itemCfg{order = 1} ->
						case get_sacred_eq(Uid) of
							#sacred_eq{int_lv = 0} ->
								case cfg_disassemble:getRow(CfgId, 0, 0) of
									#disassembleCfg{consumeEquip = []} ->%%不能通用拆解
										?TRUE;
									#disassembleCfg{} ->%%去掉能通用拆解
										?FALSE;
									_ -> ?TRUE
								end;
							#sacred_eq{} -> ?TRUE;
							{} -> ?FALSE
						end;
					#itemCfg{} -> ?TRUE;
					{} -> ?FALSE
				end;
			_ -> ?FALSE
		end end, UidList),
	case fade_sacred_eq(NewUidList) of
		{[], [], [], [], [], [], []} ->
			ok;
		{_, _, ItemListY, RetItemN, RetCurrencyY, RetCurrencyN, _} ->
			AllItem = item:item_merge(ItemListY ++ RetItemN),
			AllCurr = common:listValueMerge(RetCurrencyY ++ RetCurrencyN),
			ItemList = [{{1, CfgId}, Amount} || {CfgId, Amount, 1} <- AllItem],
			CurrList = [{{2, K}, V} || {K, V} <- AllCurr],
			put(sacred_eq_synthetic, ItemList ++ CurrList)
	end.

%%获取新装备继承旧装备的道具数量
get_inherit() ->
	case get(sacred_eq_synthetic) of
		?UNDEFINED -> [];
		L -> L
	end.

%%
get_eq_msg(UidList) ->
	F = fun(Uid, Ret) ->
		case get_sacred_eq(Uid) of
			#sacred_eq{} = Eq -> [make_sacred_eq_msg(Eq) | Ret];
			_ -> Ret
		end
		end,
	lists:foldl(F, [], UidList).

list_2_sacred_eq(List) ->
	Record = list_to_tuple([sacred_eq | List]),
	Record#sacred_eq{
		base_prop = gamedbProc:dbstring_to_term(Record#sacred_eq.base_prop),
		rand_prop = gamedbProc:dbstring_to_term(Record#sacred_eq.rand_prop),
		beyond_prop = gamedbProc:dbstring_to_term(Record#sacred_eq.beyond_prop)
	}.
list_2_sacred_eq_pos(List) ->
	Record = list_to_tuple([sacred_eq_pos | List]),
	Record#sacred_eq_pos{
		bless_prop = gamedbProc:dbstring_to_term(Record#sacred_eq_pos.bless_prop),
		bless_prop_temp = gamedbProc:dbstring_to_term(Record#sacred_eq_pos.bless_prop_temp)
	}.

sacred_eq_2_list(Record) ->
	tl(tuple_to_list(Record#sacred_eq{
		base_prop = gamedbProc:term_to_dbstring(Record#sacred_eq.base_prop),
		rand_prop = gamedbProc:term_to_dbstring(Record#sacred_eq.rand_prop),
		beyond_prop = gamedbProc:term_to_dbstring(Record#sacred_eq.beyond_prop)
	})).
sacred_eq_pos_2_list(Record) ->
	tl(tuple_to_list(Record#sacred_eq_pos{
		bless_prop = gamedbProc:term_to_dbstring(Record#sacred_eq_pos.bless_prop),
		bless_prop_temp = gamedbProc:term_to_dbstring(Record#sacred_eq_pos.bless_prop_temp)
	})).
%%%===================================================================
%%% Internal functions
%%%===================================================================
%%保存英雄圣装数据
set_sacred_eq_list(List) ->
	put({?MODULE, sacred_eq_list}, List).
get_sacred_eq_list() ->
	case get({?MODULE, sacred_eq_list}) of
		?UNDEFINED -> [];
		L -> L
	end.

%%保存英雄圣装部位数据
set_sacred_eq_pos_list(List) ->
	put({?MODULE, sacred_eq_pos_list}, List).
get_sacred_eq_pos_list() ->
	case get({?MODULE, sacred_eq_pos_list}) of
		?UNDEFINED -> [];
		L -> L
	end.

%%获取对应部位数据
get_sacred_eq_pos(Pos) ->
	case lists:keyfind(Pos, #sacred_eq_pos.pos, get_sacred_eq_pos_list()) of
		#sacred_eq_pos{} = Info -> Info;
		_ -> #sacred_eq_pos{player_id = player:getPlayerID(), pos = Pos}
	end.

%%更新英雄圣装数据
update_sacred_eq(#sacred_eq{} = SacredEq) -> update_sacred_eq([SacredEq]);
update_sacred_eq([]) -> ok;
update_sacred_eq(SacredEqList) ->
	F = fun(#sacred_eq{uid = Uid} = SacredEq, {Ret1, Ret2}) ->
		{lists:keystore(Uid, #sacred_eq.uid, Ret1, SacredEq), [make_sacred_eq_msg(SacredEq) | Ret2]}
		end,
	{NewSacredEqPosList, UpdateSacredPosMsg} = lists:foldl(F, {get_sacred_eq_list(), []}, SacredEqList),
	set_sacred_eq_list(NewSacredEqPosList),
	table_player:insert(?TablePetSacredEq, SacredEqList),
	player:send(#pk_GS2U_SacredEqUpdate{sacred_eq_list = UpdateSacredPosMsg}).

%%更新装备部位信息
update_sacred_eq_pos(#sacred_eq_pos{} = SacredEqPos) ->
	update_sacred_eq_pos([SacredEqPos]);
update_sacred_eq_pos([]) -> ok;
update_sacred_eq_pos(SacredEqPosList) ->
	F = fun(#sacred_eq_pos{pos = Pos} = SacredEqPos, {Ret1, Ret2}) ->
		{lists:keystore(Pos, #sacred_eq_pos.pos, Ret1, SacredEqPos), [make_sacred_eq_pos_msg(SacredEqPos) | Ret2]}
		end,
	{NewSacredEqPosList, UpdateSacredEqPosMsg} = lists:foldl(F, {get_sacred_eq_pos_list(), []}, SacredEqPosList),
	set_sacred_eq_pos_list(NewSacredEqPosList),
	table_player:insert(?TablePetSacredEqPos, SacredEqPosList),
	player:send(#pk_GS2U_SacredEqPosUpdate{sacred_eq_pos_list = UpdateSacredEqPosMsg}).

%%加载数据到进程
load_data() ->
	PlayerID = player:getPlayerID(),
	ItemList = table_player:lookup(db_item_player, PlayerID),    %% 所有道具数据
	SacredEqList = [SacredEq || SacredEq <- table_player:lookup(?TablePetSacredEq, PlayerID), (lists:keymember(SacredEq#sacred_eq.uid, #db_item_player.id, ItemList) =/= ?FALSE)],
	set_sacred_eq_list(SacredEqList),%%英雄圣装装备数据
	SacredEqPosList = [SacredEqPos || SacredEqPos <- table_player:lookup(?TablePetSacredEqPos, PlayerID)],
	set_sacred_eq_pos_list(SacredEqPosList).    %%英雄圣装部位数据

%%圣装添加
sacred_eq_add(AddList, Reason) ->
	F = fun(#item{cfg_id = CfgId} = Item, Ret) ->
		case cfg_ornamentEquip:getRow(CfgId) of
			#ornamentEquipCfg{} ->
				%%替换道具-继承
				{L, #sacred_eq{cfg_id = CfgId2} = SacredEq} = sacred_eq_inherit(Item, Reason),
				case L of%%是否有返还道具
					[] -> ok;
					_ ->
						ItemList = [{K, V, 1} || {{1, K}, V} <- L],
						CurrList = [{K, V} || {{2, K}, V} <- L],
						player:add_rewards(ItemList, CurrList, ?Reason_SacredEq_Inherit),    %%添加道具，货币
						player_item:show_get_item_dialog(ItemList, CurrList, [], 0, 5)
				end,
				case CfgId2 of%%是否升阶
					CfgId -> ok;
					NewCfgId ->
						bag_player:update_item(?BAG_ORNAMENT, [Item#item{cfg_id = NewCfgId}], ?Reason_SacredEq_Inherit)%%升阶
				end,
				[SacredEq | Ret];
			_ -> Ret
		end end,
	SacredEqList = lists:foldl(F, [], AddList),
	update_sacred_eq(SacredEqList),
	%% 升阶道具id会变化，此处若需要处理这种情况则视情况修改
	ShowList = [{{CfgId, Bind}, Uid} || #item{cfg_id = CfgId, id = Uid, bind = Bind} <- AddList],
	player_item:add_show_item(ShowList),
	ok.

%%圣装删除
sacred_eq_delete(DeleteList) ->
	F = fun(#item{id = Uid}, {DeleteSacredEqListRet, NewSacredEqListRet}) ->
		case lists:keyfind(Uid, #sacred_eq.uid, NewSacredEqListRet) of
			#sacred_eq{} = Info ->
				{[Info | DeleteSacredEqListRet], lists:keydelete(Uid, #sacred_eq.uid, NewSacredEqListRet)};
			?FALSE ->
				{DeleteSacredEqListRet, NewSacredEqListRet}
		end end,
	{DeleteSacredEqList, NewSacredEqList} = lists:foldl(F, {[], get_sacred_eq_list()}, DeleteList),
	table_player:delete(?TablePetSacredEq, player:getPlayerID(), [Uid || #sacred_eq{uid = Uid} <- DeleteSacredEqList]),
	set_sacred_eq_list(NewSacredEqList),
	player:send(#pk_GS2U_SacredEqUpdate{sacred_eq_list = [make_sacred_eq_msg(R) || R <- DeleteSacredEqList], op = 1}).

%%圣装装配卸下
sacred_eq_op(Op, Uid) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Err = eq_op(Op, Uid),
		?ERROR_CHECK_THROW(Err),
		calc_sacred_attr(),
		calc_master_prop(),
		calc_suit_attr(),
		flush_prop(?TRUE),
		score_change(),
		skill_player:on_skill_change(),
		player_task:refresh_task(?Task_Goal_PetSacred_Eq),
		attainment:check_attainment(?Attainments_Type_SacredEqCount),
		player:send(#pk_GS2U_SacredEqOpRet{op = Op, uid = Uid})
	catch
		ErrCode ->
			player:send(#pk_GS2U_SacredEqOpRet{err_code = ErrCode, op = Op, uid = Uid})
	end.

%%圣装一键穿戴卸下操作
sacred_eq_1key_op(Op, UidList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		UidList2 = lists:usort(UidList),
		?CHECK_THROW(length(UidList2) =:= length(UidList), ?ERROR_Param),
		F = fun(Uid, Ret) ->
			case eq_op(Op, Uid) of
				?ERROR_OK -> [Uid | Ret];
				_ -> Ret
			end
			end,
		SacredEqUidList = lists:foldl(F, [], UidList2),
		?CHECK_THROW(SacredEqUidList =/= [], ?ErrorCode_SacredEq_OneKeyOpNoWear),
		calc_sacred_attr(),
		calc_master_prop(),
		calc_suit_attr(),
		flush_prop(?TRUE),
		score_change(),
		buff_player:on_buff_change(),
		skill_player:on_skill_change(),
		player_task:refresh_task(?Task_Goal_PetSacred_Eq),
		attainment:check_attainment(?Attainments_Type_SacredEqCount),
		player:send(#pk_GS2U_SacredEqOneKeyOpRet{op = Op, uids = UidList})
	catch
		ErrCode ->
			player:send(#pk_GS2U_SacredEqOneKeyOpRet{err_code = ErrCode, op = Op, uids = UidList})
	end.

%%穿戴
eq_op(0, Uid) ->
	try
		{Err1, _} = bag_player:get_bag_item(?BAG_ORNAMENT, Uid),
		?ERROR_CHECK_THROW(Err1),
		SacredEq = get_sacred_eq(Uid),
		?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist),
		BaseCfg = cfg_ornamentEquip:getRow(SacredEq#sacred_eq.cfg_id),
		?CHECK_CFG(BaseCfg),
		ItemCfg = cfg_item:getRow(SacredEq#sacred_eq.cfg_id),
		?CHECK_CFG(ItemCfg),
		?CHECK_THROW(check_wear(Uid), ?ErrorCode_SacredEq_WearCondition),%%检查穿戴条件(熔岩决斗场关卡通关)
		SacredEqPos = get_sacred_eq_pos(ItemCfg#itemCfg.detailedType),
		case SacredEqPos of
			#sacred_eq_pos{uid = Uid} -> throw(?ERROR_OK);
			#sacred_eq_pos{uid = OldUid} when OldUid > 0 ->%%有装备，替换
				Err2 = bag_player:transfer(?BAG_ORNAMENT_EQUIP, OldUid, ?BAG_ORNAMENT),%%先卸下
				?ERROR_CHECK_THROW(Err2),
				Err3 = bag_player:transfer(?BAG_ORNAMENT, Uid, ?BAG_ORNAMENT_EQUIP),%%再穿上新装备
				?ERROR_CHECK_THROW(Err3);
			_ ->%%无装备
				Err4 = bag_player:transfer(?BAG_ORNAMENT, Uid, ?BAG_ORNAMENT_EQUIP),
				?ERROR_CHECK_THROW(Err4)
		end,
		update_sacred_eq_pos(SacredEqPos#sacred_eq_pos{uid = Uid}),
		log_pet_sacred_eq(1, Uid, SacredEq#sacred_eq.cfg_id, SacredEqPos, [], []),
		?ERROR_OK
	catch
		ErrCode -> ErrCode
	end;
eq_op(1, Uid) ->%%卸下
	try
		{Err1, _} = bag_player:get_bag_item(?BAG_ORNAMENT_EQUIP, Uid),
		?ERROR_CHECK_THROW(Err1),
		SacredEq = get_sacred_eq(Uid),
		?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist),
		BaseCfg = cfg_ornamentEquip:getRow(SacredEq#sacred_eq.cfg_id),
		?CHECK_CFG(BaseCfg),
		ItemCfg = cfg_item:getRow(SacredEq#sacred_eq.cfg_id),
		?CHECK_CFG(ItemCfg),
		SacredEqPos = get_sacred_eq_pos(ItemCfg#itemCfg.detailedType),
		case SacredEqPos of
			#sacred_eq_pos{uid = Uid} ->%%穿戴着，卸下
				Err2 = bag_player:transfer(?BAG_ORNAMENT_EQUIP, Uid, ?BAG_ORNAMENT),
				?ERROR_CHECK_THROW(Err2);
			#sacred_eq_pos{uid = OldUid} when OldUid =/= 0 -> throw(?ErrorCode_SacredEq_NoWearSacredEq);
			#sacred_eq_pos{uid = 0} -> throw(?ERROR_OK)
		end,
		update_sacred_eq_pos(SacredEqPos#sacred_eq_pos{uid = 0}),
		log_pet_sacred_eq(2, Uid, SacredEq#sacred_eq.cfg_id, SacredEqPos, [], []),
		?ERROR_OK
	catch
		ErrCode -> ErrCode
	end;
eq_op(_, _) ->
	?ERROR_Param.

%%圣装升级
sacred_eq_lv_up(Uid, AddLevel) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(AddLevel >= 1, ?ERROR_Param),
		{Err1, _} = bag_player:get_bag_item(?BAG_ORNAMENT_EQUIP, Uid),
		?ERROR_CHECK_THROW(Err1),
		SacredEq = get_sacred_eq(Uid),
		?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist),%%没有对应圣装
		#sacred_eq{cfg_id = SacredCfg, int_lv = IntLv} = SacredEq,
		SacredEqPos = lists:keyfind(Uid, #sacred_eq_pos.uid, get_sacred_eq_pos_list()),
		?CHECK_THROW(SacredEqPos =/= ?FALSE, ?ErrorCode_SacredEq_NotWear),%%没有穿戴圣装
		BaseCfg = cfg_ornamentEquip:getRow(SacredCfg),
		?CHECK_CFG(BaseCfg),
		ItemCfg = cfg_item:getRow(SacredCfg),
		?CHECK_CFG(ItemCfg),
		?CHECK_THROW(ItemCfg#itemCfg.character >= cfg_globalSetup:peishi_qj10(), ?ErrorCode_SacredEq_CharaNotEnough),
		MaxLevelGap = case cfg_ornamentStrengthLimit:getRow(ItemCfg#itemCfg.character) of%%与最大等级的等级差
						  #ornamentStrengthLimitCfg{number = LimitLv} when IntLv >= LimitLv ->
							  throw(?ErrorCode_SacredEq_IntLvLimit);
						  #ornamentStrengthLimitCfg{number = LimitLv} ->
							  LimitLv - IntLv;
						  _ -> throw(?ERROR_Cfg)
					  end,
		StageLevelGap = case cfg_ornamentAdvance:getRow(SacredCfg) of%%与当前阶段等级差
							#ornamentAdvanceCfg{strengthLvNeed = NeedLv} when IntLv >= NeedLv ->
								throw(?ErrorCode_SacredEq_IntLvLimit);
							#ornamentAdvanceCfg{strengthLvNeed = NeedLv} ->
								NeedLv - IntLv;
							_ -> throw(?ERROR_Cfg)
						end,
		%%获取当前可升级的最大值
		NowAddLevel = min(AddLevel, min(MaxLevelGap, StageLevelGap)) - 1,
		Pos = SacredEqPos#sacred_eq_pos.pos,
		F = fun
				(Lv, {AddLv, ErrAcc, DeListAcc}) when ErrAcc =:= ?ERROR_OK ->
					case cfg_ornamentStrength:getRow(Pos, Lv) of
						#ornamentStrengthCfg{needExp = []} ->
							{AddLv, ?ErrorCode_SacredEq_IntLvLimit, DeListAcc};
						#ornamentStrengthCfg{needExp = NeedExp} ->
							{DeleteError, _} = player:delete_cost_prepare(NeedExp),
							case DeleteError of
								?ERROR_OK ->
									{AddLv + 1, ErrAcc, NeedExp ++ DeListAcc};
								_ ->
									{AddLv, ?ERROR_item_bag_amount, DeListAcc}
							end;
						_ ->
							?LOG_ERROR("~n cfg_ornamentStrength no cfg , key:~p", [{Pos, Lv}]),
							{AddLv, ?ERROR_Cfg, DeListAcc}
					end;
				(_, Acc) -> Acc
			end,
		%%提升的等级
		{NewAddLv, DeItemList} = case lists:foldl(F, {0, ?ERROR_OK, []}, lists:seq(IntLv, IntLv + NowAddLevel)) of
									 {0, _, _} -> throw(?ERROR_item_bag_amount);
									 {P1, _, DeList} ->
										 Err3 = player:delete_cost(DeList, ?Reason_SacredEq_Int),
										 ?ERROR_CHECK_THROW(Err3),
										 {P1, DeList}
								 end,
		update_sacred_eq(SacredEq#sacred_eq{int_lv = IntLv + NewAddLv, bind = 1}),%%升级后绑定装备，分解出的装备也是绑定的
		calc_sacred_attr(),
		calc_master_prop(),
		flush_prop(?TRUE),
		score_change(),
		player:send(#pk_GS2U_SacredEqLvUpRet{uid = Uid, pos = ItemCfg#itemCfg.detailedType, add_level = NewAddLv}),
		log_pet_sacred_eq(3, Uid, AddLevel, {IntLv, IntLv + NewAddLv}, DeItemList, [])
	catch
		Error ->
			player:send(#pk_GS2U_SacredEqLvUpRet{err_code = Error, uid = Uid, add_level = AddLevel})
	end.

%%圣装升阶段
acred_eq_stage_up(Uid) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		{Err1, [Item]} = bag_player:get_bag_item(?BAG_ORNAMENT_EQUIP, Uid),
		?ERROR_CHECK_THROW(Err1),
		SacredEq = get_sacred_eq(Uid),
		?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist),%%没有对应道具
		SacredEqPos = lists:keyfind(Uid, #sacred_eq_pos.uid, get_sacred_eq_pos_list()),
		?CHECK_THROW(SacredEqPos =/= ?FALSE, ?ErrorCode_SacredEq_NotWear),
		BreakCfg = cfg_ornamentAdvance:getRow(SacredEq#sacred_eq.cfg_id),
		case BreakCfg of
			#ornamentAdvanceCfg{isStrength = 0} -> throw(?ErrorCode_SacredEq_CantBreak);
			#ornamentAdvanceCfg{strengthLvNeed = NeedLv} when SacredEq#sacred_eq.int_lv < NeedLv ->
				throw(?ErrorCode_SacredEq_LvNotEnough);
			#ornamentAdvanceCfg{strengthLvNeed = NeedLv} when SacredEq#sacred_eq.int_lv >= NeedLv -> ok;
			_ -> throw(?ERROR_Cfg)
		end,
		#ornamentAdvanceCfg{ornamentAdvanceID = NewCfgId, needItem = CostList} = BreakCfg,
		Order = case cfg_item:getRow(NewCfgId) of
					{} ->
						?LOG_ERROR(" cfg_item no cfg,cfg_id:", NewCfgId),
						throw(?ERROR_Cfg);
					#itemCfg{order = P1} -> P1
				end,
		NewItem = Item#item{cfg_id = NewCfgId, bind = 1},%%升阶绑定装备
		Err2 = player:delete_cost(CostList, ?Reason_SacredEq_Break),
		?ERROR_CHECK_THROW(Err2),
		bag_player:update_item(?BAG_ORNAMENT_EQUIP, [NewItem], ?Reason_SacredEq_Break),
		update_sacred_eq(SacredEq#sacred_eq{cfg_id = NewCfgId, bind = 1}),%%升阶绑定装备
		calc_sacred_attr(),
		calc_master_prop(),
		calc_suit_attr(),
		flush_prop(?TRUE),
		score_change(),
		skill_player:on_skill_change(),
		player_task:refresh_task(?Task_Goal_PetSacred_Eq),
		attainment:check_attainment(?Attainments_Type_SacredEqCount),
		log_pet_sacred_eq(4, Uid, Order, {Item#item.cfg_id, NewCfgId}, [], CostList),
		player:send(#pk_GS2U_SacredEqStageUpRet{uid = Uid, pos = SacredEqPos#sacred_eq_pos.pos}),
		[KeyStageList] = df:getGlobalSetupValueList(peishi_ShengJieGongGao, [{5, 8, 10, 12, 15, 16, 17, 18, 19, 20}]),
		case lists:member(Order, tuple_to_list(KeyStageList)) of
			?TRUE ->
				PlayerText = player:getPlayerText(),
				marquee:sendChannelNotice(0, 0, peishi_gonggao2,
					fun(Language) ->
						language:format(language:get_server_string("Peishi_gonggao2", Language),
							[PlayerText, richText:getItemText(NewCfgId, Language), Order])
					end);
			?FALSE -> ok
		end
	catch
		Error ->
			player:send(#pk_GS2U_SacredEqStageUpRet{err_code = Error, uid = Uid})
	end.

%%圣装祝福 (op::   0:祝福, 1:替换, 2:放弃)
sacred_eq_cast(0, Pos) ->%%祝福
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(Pos >= ?Pos_Min andalso Pos =< ?Pos_Max, ?ERROR_Param),
		SacredEqPos = get_sacred_eq_pos(Pos),
		case SacredEqPos of
			#sacred_eq_pos{uid = 0} -> throw(?ErrorCode_SacredEq_NotWear);
			#sacred_eq_pos{bless_prop_temp = []} -> ok;
			#sacred_eq_pos{} -> throw(?ErrorCode_SacredEq_CastInfoExist)
		end,
		SacredEq = get_sacred_eq(SacredEqPos#sacred_eq_pos.uid),
		?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist),
		ItemCfg = cfg_item:getRow(SacredEq#sacred_eq.cfg_id),
		?CHECK_CFG(ItemCfg),
		CastCfg = cfg_ornamentForge:getRow(Pos),
		?CHECK_CFG(CastCfg),
		?CHECK_THROW(ItemCfg#itemCfg.character >= cfg_globalSetup:peishi_qj11(), ?ErrorCode_SacredEq_CharaNotEnough),
		?CHECK_THROW(ItemCfg#itemCfg.order >= cfg_globalSetup:peishi_qj14(), ?ErrorCode_SacredEq_OrderNotEnough),
		Err1 = player:delete_cost(CastCfg#ornamentForgeCfg.needItem, ?Reason_SacredEq_Cast),
		?ERROR_CHECK_THROW(Err1),
		NewCastTime = SacredEqPos#sacred_eq_pos.bless_times + 1,
		CastPropTemp = make_cast_rand(SacredEqPos#sacred_eq_pos.bless_prop, CastCfg, NewCastTime),
		NewSacredEqPos = SacredEqPos#sacred_eq_pos{bless_times = NewCastTime, bless_prop_temp = CastPropTemp},
		update_sacred_eq_pos(NewSacredEqPos),
		player:send(#pk_GS2U_SacredEqCastRet{pos = Pos, op = 0, sacred_eq_pos = make_sacred_eq_pos_msg(NewSacredEqPos)}),
		log_pet_sacred_eq(5, SacredEqPos#sacred_eq_pos.uid, Pos, {NewCastTime, CastPropTemp}, CastCfg#ornamentForgeCfg.needItem, [])
	catch
		Error ->
			player:send(#pk_GS2U_SacredEqCastRet{err_code = Error, pos = Pos, op = 0})
	end;
sacred_eq_cast(1, Pos) ->%%替换
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		SacredEqPos = get_sacred_eq_pos(Pos),
		NewBlessProp = case SacredEqPos of
						   #sacred_eq_pos{uid = 0} -> throw(?ErrorCode_SacredEq_NotWear);
						   #sacred_eq_pos{bless_prop_temp = []} -> throw(?ErrorCode_SacredEq_CastInfoNotExist);
						   #sacred_eq_pos{bless_prop_temp = P} -> P
					   end,
		SacredEq = get_sacred_eq(SacredEqPos#sacred_eq_pos.uid),
		?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist),
		NewSacredEqPos = SacredEqPos#sacred_eq_pos{
			bless_prop = NewBlessProp,
			bless_prop_temp = []
		},
		update_sacred_eq_pos(NewSacredEqPos),
		calc_sacred_attr(),
		flush_prop(?TRUE),
		score_change(),
		skill_player:on_skill_change(),
		player:send(#pk_GS2U_SacredEqCastRet{pos = Pos, op = 1, sacred_eq_pos = make_sacred_eq_pos_msg(NewSacredEqPos)}),
		log_pet_sacred_eq(6, SacredEqPos#sacred_eq_pos.uid, Pos, {NewBlessProp, SacredEqPos#sacred_eq_pos.bless_prop_temp}, [], []),
		%%公告
		PlayerText = player:getPlayerText(),
		F2 = fun({Type, ID}, ?FALSE) ->
			{Notice, Prefix, S1, S2} = case Type of
										   1 ->
											   case cfg_ornamentAttri:getRow(ID, 1) of
												   #ornamentAttriCfg{prefix = P1, notice = 1} ->
													   {?TRUE, P1, peishi_gonggao5, "Peishi_gonggao5"};
												   #ornamentAttriCfg{prefix = P1, notice = 2} ->
													   {?TRUE, P1, peishi_gonggao4, "Peishi_gonggao4"};
												   _ -> {?FALSE, "", "", ""}
											   end;
										   2 -> case cfg_ornamentSkill:getRow(ID) of
													#ornamentSkillCfg{prefix = P1, notice = 1} ->
														{?TRUE, P1, peishi_gonggao5, "Peishi_gonggao5"};
													#ornamentSkillCfg{prefix = P1, notice = 2} ->
														{?TRUE, P1, peishi_gonggao4, "Peishi_gonggao4"};
													_ -> {?FALSE, "", "", ""}
												end
									   end,
			case Notice of
				?TRUE ->
					marquee:sendChannelNotice(0, 0, S1,
						fun(Language) ->
							language:format(language:get_server_string(S2, Language),
								[PlayerText, richText:getItemText(SacredEq#sacred_eq.cfg_id, Language), language:get_tongyong_string(Prefix, Language)])
						end),
					?TRUE;
				?FALSE -> ?FALSE
			end;
			(_, ?TRUE) -> ?TRUE
			 end,
		lists:foldl(F2, ?FALSE, NewBlessProp)
	catch
		Error ->
			player:send(#pk_GS2U_SacredEqCastRet{err_code = Error, pos = Pos, op = 1})
	end;
sacred_eq_cast(2, Pos) ->%%放弃
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		SacredEqPos = get_sacred_eq_pos(Pos),
		case SacredEqPos of
			#sacred_eq_pos{uid = 0} -> throw(?ErrorCode_SacredEq_NotWear);
			#sacred_eq_pos{bless_prop_temp = []} -> throw(?ErrorCode_SacredEq_CastInfoNotExist);
			#sacred_eq_pos{uid = Uid} ->
				SacredEq = get_sacred_eq(Uid),
				?CHECK_THROW(SacredEq =/= {}, ?ErrorCode_SacredEq_NotExist)
		end,
		NewSacredEqPos = SacredEqPos#sacred_eq_pos{
			bless_prop_temp = []
		},
		update_sacred_eq_pos(NewSacredEqPos),
		log_pet_sacred_eq(7, SacredEqPos#sacred_eq_pos.uid, Pos, {SacredEqPos#sacred_eq_pos.bless_prop_temp}, [], []),
		player:send(#pk_GS2U_SacredEqCastRet{pos = Pos, op = 2, sacred_eq_pos = make_sacred_eq_pos_msg(NewSacredEqPos)})
	catch
		Error ->
			player:send(#pk_GS2U_SacredEqCastRet{err_code = Error, pos = Pos, op = 2})
	end.


%%英雄圣装大师属性点亮(大师属性只在这里计算)
sacred_eq_suit_add(NewMasterLv) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		OldMasterLv = variable_player:get_value(?Variable_Player_PetSacredEq_MasterLv),
		?CHECK_THROW(NewMasterLv > OldMasterLv, ?ErrorCode_SacredEq_MasterCondition2),
		case calc_master_lv(NewMasterLv, OldMasterLv) of
			NewMasterLv ->
				variable_player:set_value(?Variable_Player_PetSacredEq_MasterLv, NewMasterLv),
				case NewMasterLv >= cfg_globalSetup:peishi_qj7() andalso NewMasterLv rem cfg_globalSetup:peishi_qj8() == 0 of
					?TRUE ->
						PlayerText = player:getPlayerText(),
						marquee:sendChannelNotice(0, 0, peishi_gonggao3,
							fun(Language) ->
								language:format(language:get_server_string("Peishi_gonggao3", Language), [PlayerText, NewMasterLv])
							end);
					?FALSE -> ok
				end;
			OldMasterLv -> throw(?ErrorCode_SacredEq_MasterCondition)
		end,
		calc_master_prop(),
		flush_prop(?TRUE),
		score_change(),
		log_pet_sacred_eq(8, 0, NewMasterLv, {OldMasterLv, NewMasterLv}, [], []),
		player:send(#pk_GS2U_SacredEqSuitAddRet{newmasterlv = NewMasterLv})
	catch
		Error ->
			player:send(#pk_GS2U_SacredEqSuitAddRet{err_code = Error, newmasterlv = NewMasterLv})
	end.

%%圣装分解
sacred_eq_fade(UidList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		NewUidList = lists:usort(UidList),
		?CHECK_THROW(length(NewUidList) =:= length(UidList), ?ERROR_Param),
		{UpdateItemList, NewSacredEqList, ItemListY, RetItemN, CurrencyListY, RetCurrencyN, DecUids} =
			case fade_sacred_eq(NewUidList) of
				{[], [], [], [], [], [], []} ->
					throw(?ErrorCode_SacredEq_NoDec);
				{P1, P2, P3, P4, P5, P6, P7} ->
					{P1, P2, P3, P4, P5, P6, P7}
			end,
		ItemList = ItemListY ++ RetItemN,
		CurrencyList = CurrencyListY ++ RetCurrencyN,
		Err2 = bag_player:delete_item(?BAG_ORNAMENT, DecUids, ?Reason_SacredEq_Fade),
		?ERROR_CHECK_THROW(Err2),
		NeedUpdateItemList = [Item || {Item, ?TRUE} <- UpdateItemList],%%需要更新，需要飘字
		NoNeedUpdateItemList = [Item || {Item, ?FALSE} <- UpdateItemList],%%不需要更新，需要飘字
		bag_player:update_item(?BAG_ORNAMENT, NeedUpdateItemList, ?Reason_SacredEq_Fade),
		update_sacred_eq(NewSacredEqList),
		player_item:reward(ItemList, [], CurrencyList, ?Reason_SacredEq_Fade),
		player_item:show_get_item_dialog(ItemList ++ [{C, N, B} || #item{cfg_id = C, amount = N, bind = B} <- NoNeedUpdateItemList], CurrencyList, [], 0, 5),
		player:send(#pk_GS2U_SacredEqFadeRet{}),
		log_pet_sacred_eq(9, 0, 0, {UidList, NewSacredEqList}, ItemList, CurrencyList)
	catch
		Error -> player:send(#pk_GS2U_SacredEqFadeRet{err_code = Error})
	end.

%% 分解圣装 return {UpdateItem, UpdateSacredEq, RetItemY,   RetItemN, RetCurrencyY, RetCurrencyN, DecUids}
%%               更新的item列表   更新的eq列表  分解出道具列表（双倍） 分解出道具列表（不可双倍）
fade_sacred_eq(Uids) -> fade_sacred_eq(Uids, [], [], [], [], [], [], []).
fade_sacred_eq([], UpdateItem, UpdateSacredEq, RetItemY, RetItemN, RetCurrencyY, RetCurrencyN, DecUids) ->
	{UpdateItem, UpdateSacredEq, item:item_merge(RetItemY), item:item_merge(RetItemN),
		common:listValueMerge(RetCurrencyY), common:listValueMerge(RetCurrencyN), DecUids};
fade_sacred_eq([Uid | T], UpdateItem, UpdateSacredEq, RetItemY, RetItemN, RetCurrencyY, RetCurrencyN, DecUids) ->
	case bag_player:get_bag_item(?BAG_ORNAMENT, Uid) of
		{?ERROR_OK, [Item]} ->
			case get_fade_ret(Item, get_sacred_eq(Uid)) of
				{ItemU, OrnU, ItemY, ItemN, CurrencyY, CurrencyN, 0} ->
					fade_sacred_eq(T, ItemU ++ UpdateItem, OrnU ++ UpdateSacredEq, ItemY ++ RetItemY, ItemN ++ RetItemN, CurrencyY ++ RetCurrencyY, CurrencyN ++ RetCurrencyN, DecUids);
				{ItemU, OrnU, ItemY, ItemN, CurrencyY, CurrencyN, DecUid} ->
					fade_sacred_eq(T, ItemU ++ UpdateItem, OrnU ++ UpdateSacredEq, ItemY ++ RetItemY, ItemN ++ RetItemN, CurrencyY ++ RetCurrencyY, CurrencyN ++ RetCurrencyN, [DecUid | DecUids])
			end;
		_ -> fade_sacred_eq(T, UpdateItem, UpdateSacredEq, RetItemY, RetItemN, RetCurrencyY, RetCurrencyN, DecUids)
	end.

%% 获取分解材料
%% return {UpdateItem, UpdateOrn, RetItemY, RetItemN, RetCurrencyY, RetCurrencyN, DecUid}
get_fade_ret(#item{cfg_id = CfgId} = Item, #sacred_eq{cfg_id = CfgId} = Orn) ->
	get_fade_ret(Item, Orn, cfg_item:getRow(CfgId));
get_fade_ret(_, _) -> {[], [], [], [], [], [], 0}.

get_fade_ret(#item{cfg_id = CfgId} = Item, #sacred_eq{cfg_id = CfgId, int_lv = IntLv} = Orn, #itemCfg{detailedType = Pos} = ItemCfg) ->
	get_fade_ret(Item, Orn, ItemCfg, cfg_ornamentEquip:getRow(CfgId), cfg_ornamentStrength:getRow(Pos, IntLv));
get_fade_ret(_, _, _) -> {[], [], [], [], [], [], 0}.

get_fade_ret(#item{cfg_id = CfgId}, #sacred_eq{uid = Uid}, #itemCfg{}, #ornamentEquipCfg{decomposeItem = []}, #ornamentStrengthCfg{lv = 0}) ->%%没有强化过的，并且不能通过cfg_ornamentequip表拆解的，使用通用拆解表
	case cfg_disassemble:getRow(CfgId, 0, 0) of
		{} -> {[], [], [], [], [], [], 0};
		#disassembleCfg{consumeEquip = GetList} ->%%拆解的都是道具
			{[], [], [], [{P2, P3, 1} || {_P1, P2, P3, _P4, _P5} <- GetList], [], [], Uid}
	end;
%%1阶带等级的装备
get_fade_ret(#item{} = Item, #sacred_eq{} = Orn, #itemCfg{order = 1}, #ornamentEquipCfg{}, #ornamentStrengthCfg{lv = IntLv, decomposeItem = DecList2}) when IntLv > 0 ->
	DecList = DecList2,
	Item0 = [{I, N, 1} || {1, I, N} <- DecList],
	Currency0 = [{I, N} || {2, I, N} <- DecList],
	{[{Item, ?FALSE}], [Orn#sacred_eq{int_lv = 0}], [], Item0, [], Currency0, 0};
%%多阶装备
get_fade_ret(Item, #sacred_eq{uid = Uid} = Orn, #itemCfg{}, #ornamentEquipCfg{decomposeItem = DecList1}, #ornamentStrengthCfg{decomposeItem = DecList2}) ->
	Item1 = [{I, N, 1} || {1, I, N} <- DecList1],
	Currency1 = [{I, N} || {2, I, N} <- DecList1],
	OrnIns = [make_base_sacred_eq(Item, Orn, I) || {3, I, 1} <- DecList1],
	UpdateItem = [{I, ?TRUE} || {I, _} <- OrnIns],%%是否需要更新
	UpdateOrn = [O || {_, O} <- OrnIns],
	Item2 = [{I, N, 1} || {1, I, N} <- DecList2],
	Currency2 = [{I, N} || {2, I, N} <- DecList2],
	case OrnIns =/= [] of
		?TRUE -> {UpdateItem, UpdateOrn, [], Item1 ++ Item2, [], Currency1 ++ Currency2, 0};
		?FALSE -> {[], [], Item1, Item2, Currency1, Currency2, Uid}
	end;
get_fade_ret(_, _, _, _, _) -> {[], [], [], [], [], [], 0}.


%%继承合成时的道具，进行升阶和升级(返回多余的道具和货币，新的装备数据)
sacred_eq_inherit(#item{cfg_id = CfgId} = Item, Reason) when Reason =:= ?REASON_Synthetic ->
	ItemList = get_inherit(),
	clear_inherit(),
	case ItemList of
		[] -> {[], make_sacred_eq(Item)};
		_ ->
			QC = cfg_globalSetup:peishi_qj10(),%%%% 达到此品质及以上的英雄圣装可以强化
			case cfg_item:getRow(CfgId) of
				#itemCfg{character = C, detailedType = Pos} when C >= QC ->
					case cfg_ornamentStrengthLimit:getRow(C) of
						{} -> {ItemList, make_sacred_eq(Item)};
						#ornamentStrengthLimitCfg{number = LvMaxLimit} ->%%等级上限
							{NewCfg, Lv, NewItemList} = eq_inherit({CfgId, 0, 1, LvMaxLimit, Pos}, ItemList),%%继承等级和阶段
							{NewItemList, make_sacred_eq(Item#item{cfg_id = NewCfg}, Lv)}
					end;
				_ -> {ItemList, make_sacred_eq(Item)}
			end
	end;
sacred_eq_inherit(Item, _) ->
	clear_inherit(),
	{[], make_sacred_eq(Item)}.

%%继承等级和阶段       当前cfg 等级 阶数 总等级限制
eq_inherit({Cfg, Lv, _, LvMaxLimit, _}, ItemList) when LvMaxLimit =:= Lv -> {Cfg, Lv, ItemList};
eq_inherit({Cfg, Lv, _, _, _}, []) -> {Cfg, Lv, []};
eq_inherit({Cfg, Lv, Stage, LvMaxLimit, Pos}, ItemList) ->%%先升级再升阶
	case cfg_ornamentAdvance:getRow(Cfg) of
		#ornamentAdvanceCfg{strengthLvNeed = LvLimit} when LvLimit > Lv andalso LvMaxLimit > Lv ->%%升级
			NeedLvList = lists:seq(Lv, LvLimit - 1),
			F = fun(Lv2, {LvRet, ItemListRet, IsLv}) ->
				case cfg_ornamentStrength:getRow(Pos, Lv2) of
					#ornamentStrengthCfg{needExp = LvNeedItem} ->
						case subtract(ItemListRet, LvNeedItem) of
							?FALSE ->
								{LvRet, ItemListRet, ?FALSE};
							NewItemListRet ->
								{Lv2 + 1, NewItemListRet, IsLv}
						end;
					_ -> {LvRet, ItemListRet, IsLv}
				end end,
			case lists:foldl(F, {Lv, ItemList, ?TRUE}, NeedLvList) of%%是否还能继续升级
				{NewLv, NewItemList, ?TRUE} ->
					eq_inherit({Cfg, NewLv, Stage, LvMaxLimit, Pos}, NewItemList);
				{NewLv, NewItemList, ?FALSE} ->
					{Cfg, NewLv, NewItemList}
			end;
		#ornamentAdvanceCfg{strengthLvNeed = LvLimit, needItem = StageNeedItem, ornamentAdvanceID = NewCfg} when LvLimit =:= Lv andalso LvMaxLimit >= Lv andalso NewCfg =/= 0 ->%%升阶
			case subtract(ItemList, StageNeedItem) of%%不能再继续升阶了
				?FALSE ->
					{Cfg, Lv, ItemList};
				NewItemListRet ->
					eq_inherit({NewCfg, Lv, Stage + 1, LvMaxLimit, Pos}, NewItemListRet)
			end;
		_ ->
			{Cfg, Lv, ItemList}
	end.

subtract(ItemList, NeedItem) ->
	case length(ItemList) < length(NeedItem) of
		?TRUE -> ?FALSE;
		_ ->
			StageNeedItem = [{{A, B}, C} || {A, B, C} <- NeedItem],
			subtract(ItemList, StageNeedItem, [])
	end.
subtract([], _, Res) -> Res;
subtract(_, [], Res) -> Res;
subtract([{K, C} | T1], L2, Acc) ->
	case lists:keyfind(K, 1, L2) of
		{K, D} ->
			Result = C - D,
			case Result of
				0 -> subtract(T1, L2, Acc);
				_ when Result < 0 -> ?FALSE;
				_ -> subtract(T1, L2, [{K, Result} | Acc])
			end;
		?FALSE -> subtract(T1, L2, [{K, C} | Acc])
	end.

%% 穿戴条件检查
check_wear(Uid) ->
	check_wear(Uid, get_sacred_eq_list()).
check_wear(Uid, SacredEqList) ->
	case lists:keyfind(Uid, #sacred_eq.uid, SacredEqList) of
		?FALSE -> ?FALSE;
		#sacred_eq{cfg_id = CfgId} ->
			#itemCfg{order = Order} = cfg_item:getRow(CfgId),
			case cfg_ornamentWear:getRow(Order) of
				#ornamentWearCfg{ornamentDungeon = []} -> ?TRUE;
				#ornamentWearCfg{ornamentDungeon = Conditions} ->
					check_wear(lists:sort(Conditions), 1, ?TRUE);
				_ -> ?FALSE
			end
	end.

check_wear([], _, Ret) -> Ret;    % 全部数据校验完成
check_wear([{G, _, _} | _], Group, ?TRUE) when G > Group -> ?TRUE;    % 某组校验成功
check_wear([{G, _, _} | _] = Condition, Group, ?FALSE) when G > Group ->    % group矫正
	check_wear(Condition, G, ?FALSE);
check_wear([{G, _, _} | T], Group, ?FALSE) when G < Group -> % 跳过该组+
	check_wear(T, Group, ?FALSE);
check_wear([{Group, 1, Lv} | T], Group, _) ->%%玩家等级
	case player:getLevel() >= Lv of
		?TRUE -> check_wear(T, Group, ?TRUE);
		?FALSE -> check_wear(T, Group + 1, ?FALSE)
	end;
check_wear([{Group, 2, DungeonID} | T], Group, _) ->%%关卡
	case playerCopyMap:is_pass_dungeon(DungeonID) of
		?TRUE -> check_wear(T, Group, ?TRUE);
		?FALSE -> check_wear(T, Group + 1, ?FALSE)
	end;
check_wear([_ | T], Group, _) ->
	check_wear(T, Group + 1, ?FALSE).

%%================================= 属性与评分计算  start ================================================
%%保存评分ID
set_sacred_eq_score(Pos, Score) -> put({sacred_score, Pos}, Score).
get_sacred_eq_score(Pos) -> get({sacred_score, Pos}).

%%保存各部位属性(基础属性prop，极品属性prop,(祝福属性prop+强化属性prop+卓越属性prop),基础属性,强化属性)
set_sacred_prop(Pos, Prop) -> put({sacred_prop, Pos}, Prop).
get_sacred_prop(Pos) -> get({sacred_prop, Pos}).

%%保存大师属性
put_master_prop(Prop) -> put(sacred_master_prop, Prop).
get_master_prop() -> get(sacred_master_prop).

%%保存套装属性
put_suit_prop(Prop) -> put(sacred_suit_prop, Prop).
get_suit_prop() -> get(sacred_suit_prop).

%%保存角色属性 (基础属性prop，极品属性prop,卓越属性prop,祝福属性prop,强化属性prop,大师属性prop,套装属性prop
put_sacred_all_prop(Prop) -> put(sacred_all_prop, Prop).
get_sacred_all_prop() ->
	case get(sacred_all_prop) of
		?UNDEFINED -> {[], [], []};
		L -> L
	end.

%%属性刷新
%%基础属性（英雄）（受祝福属性影响（已处理））
%%极品属性（英雄）（受祝福属性影响（已处理））
%%卓越属性（玩家）（受祝福属性影响（已处理））
%%祝福属性 （玩家）  加成（不受其他影响）
%%强化属性 （英雄） 加成（不受其他影响）
%%大师属性 （英雄） 加成（不受其他影响）
%%套装属性 （英雄）加成（不受其他影响）
flush_prop(IsSync) ->
	%%大师属性
	MasterProp = get_master_prop(),
	%%套装属性
	SuitProp = get_suit_prop(),
	F = fun(Pos, {RBase, RRand, RBeyond, RCast, RInt}) ->
		case get_sacred_prop(Pos) of
			?UNDEFINED -> {RBase, RRand, RBeyond, RCast, RInt};
			{Base, Rand, Beyond, Cast, Int} ->
				{attribute:prop_merge(Base, RBase), attribute:prop_merge(Rand, RRand), attribute:prop_merge(Beyond, RBeyond),
					attribute:prop_merge(Cast, RCast), attribute:prop_merge(Int, RInt)}
		end end,
	{BaseProp, RandProp, BeyondProp, CastProp, IntProp} = lists:foldl(F, {[], [], [], [], []}, lists:seq(?Pos_Min, ?Pos_Max)),
	Fun = fun(#prop{index = Index} = Prop, {PropRet, RandRet}) ->
		case Index >= 20000 of
			?TRUE -> {[Prop#prop{index = Index - 20000} | PropRet], RandRet};
			?FALSE ->
				case Index >= 10000 of
					?TRUE -> {PropRet, [Prop | RandRet]};
					?FALSE -> {[Prop | PropRet], RandRet}
				end
		end end,
	{PetPropList, RandProp2} = lists:foldl(Fun, {[], []}, attribute:prop_merge(BaseProp ++ RandProp ++ IntProp ++ MasterProp, SuitProp)),
	put_sacred_all_prop({PetPropList, BeyondProp ++ RandProp2, CastProp}),
	case IsSync of
		?TRUE ->
			pet_battle:calc_player_add_fight(),
			pet_base:save_pet_sys_attr(?FALSE),
			player_refresh:on_refresh_pet_attr(?TRUE),
			player_refresh:on_refresh_pet_skill(),
			pet_battle:sync_to_top(0, ?TRUE);
		?FALSE -> ok
	end.

%%历史最高评分更新
score_change() ->
	Score = get_score(),
	OldScore = variable_player:get_value(?Variable_Player_MaxSacredEqScore),
	case OldScore < Score of
		?TRUE ->
			variable_player:set_value(?Variable_Player_MaxSacredEqScore, Score),
			common_bp:sync_update(3);
		?FALSE -> ok
	end.

%%计算属性
%% 基础属性  极品属性 卓越属性 祝福属性  强化属性
calc_sacred_attr() ->
	SacredEqList = get_sacred_eq_list(),
	SacredPosEqList = get_sacred_eq_pos_list(),
	[calc_sacred_attr(Pos, SacredEqList, SacredPosEqList, ?TRUE) || Pos <- lists:seq(?Pos_Min, ?Pos_Max)].
calc_sacred_attr(SacredEqList, SacredPosEqList) ->%%其他进程调用
	[calc_sacred_attr(Pos, SacredEqList, SacredPosEqList, ?FALSE) || Pos <- lists:seq(?Pos_Min, ?Pos_Max)].
calc_sacred_attr(Pos, SacredEqList, SacredPosEqList, IsSave) ->%%是否保存属性
	{BasePropList, RandPropList, BeyondPropList, CastPropList, IntPropList, SacredEqScore} =
		case lists:keyfind(Pos, #sacred_eq_pos.pos, SacredPosEqList) of
			#sacred_eq_pos{uid = Uid, bless_prop = BlessProp} when Uid =/= 0 ->
				case check_wear(Uid, SacredEqList) of%%穿戴条件不满足，属性不计算
					?FALSE ->
						{[], [], [], [], [], 0};
					?TRUE ->
						case lists:keyfind(Uid, #sacred_eq.uid, SacredEqList) of
							?FALSE -> {[], [], [], [], [], 0};
							#sacred_eq{base_prop = BaseP, rand_prop = RandP, beyond_prop = BeyondP, cfg_id = CfgId, int_lv = IniLv} ->
								case cfg_item:getRow(CfgId) of
									{} ->
										?LOG_ERROR(" cfg_item no cfg ,cfg_id:~p", [CfgId]),
										{[], [], [], [], [], 0};
									#itemCfg{order = Order, character = Chara, detailedType3 = Star} ->
										{BaseAttr, _} = get_attr(BaseP, Order),%%基础
										{RandAttr, _} = get_attr(RandP, Order),%%极品
										{BeyondAttr, _} = get_attr(BeyondP, Order),%%卓越
										#ornamentStrengthCfg{strengthAttribute = IntAttr} = cfg_ornamentStrength:getRow(Pos, IniLv),
										{CastAttr, CastScore} = case is_cast_active({Order, Chara, Star}) of
																	?TRUE -> get_attr(BlessProp, 1);
																	?FALSE -> {[], 0}
																end,
										IntLvScore = lists:foldl(fun(P, Score) ->%%强化评分
											case cfg_ornamentStrength:getRow(Pos, P - 1) of
												#ornamentStrengthCfg{strengthPoint = Point} ->
													Score + Point;
												_ -> Score
											end end, 0, lists:seq(1, IniLv)),
										StageScore = case cfg_ornamentEquip:getRow(CfgId) of%%升阶评分
														 #ornamentEquipCfg{ornamentPoint = StagePoint} -> StagePoint;
														 {} -> 0
													 end,
										BaseProp1 = attribute:base_prop_from_list(BaseAttr),%%基础属性
										RandProp1 = attribute:base_prop_from_list(RandAttr),%%极品属性
										BeyondProp = attribute:base_prop_from_list(BeyondAttr),%%卓越属性
										IntProp = attribute:base_prop_from_list(IntAttr),%%强化属性
										CastProp1 = attribute:base_prop_from_list(CastAttr),%%祝福属性
										{BaseProp, RandProp, CastProp} = cast_attr_add(CastProp1, BaseProp1, RandProp1, []),%%祝福属性对基础属性 极品属性的加成
										AllScore = CastScore + IntLvScore + StageScore,
										{BaseProp, RandProp, BeyondProp, CastProp, IntProp, AllScore}
								end
						end
				end;
			_ -> {[], [], [], [], [], 0}
		end,
	case IsSave of
		?FALSE -> {BasePropList, RandPropList, BeyondPropList, CastPropList, IntPropList};
		?TRUE ->
			set_sacred_eq_score(Pos, SacredEqScore),%%保存评分id列表
			set_sacred_prop(Pos, {BasePropList, RandPropList, BeyondPropList, CastPropList, IntPropList}),
			{BasePropList, RandPropList, BeyondPropList, CastPropList, IntPropList}
	end.

%% 计算套装属性
calc_suit_attr() ->
	calc_suit_attr(get_sacred_eq_list(), get_sacred_eq_pos_list(), ?TRUE).
calc_suit_attr(SacredEqList, SacredEqPosList, IsSave) ->%%其他进程调用
	Prop = case length(SacredEqPosList) =:= ?Pos_Max of
			   ?TRUE ->
				   F = fun(#sacred_eq_pos{uid = 0}, _) -> [];
					   (#sacred_eq_pos{uid = Uid}, SuitRet) ->
						   case check_wear(Uid) of%%穿戴条件不满足，属性不计算
							   ?FALSE -> [];
							   ?TRUE ->
								   case lists:keyfind(Uid, #sacred_eq.uid, SacredEqList) of
									   ?FALSE -> [];
									   #sacred_eq{cfg_id = CfgId} ->
										   case cfg_item:getRow(CfgId) of
											   {} ->
												   ?LOG_ERROR(" cfg_item no cfg ,cfg_id:~p", [CfgId]),
												   [];
											   #itemCfg{character = Char} ->
												   lists:filter(fun(Char2) -> Char >= Char2 end, SuitRet)
										   end
								   end
						   end
					   end,
				   SuitList = lists:foldl(F, cfg_ornamentSuit:getKeyList(), SacredEqPosList),
				   AttrList = lists:flatten([Attribute || #ornamentSuitCfg{attribute = Attribute} <- cfg_ornamentSuit:rows(SuitList)]),
				   attribute:base_prop_from_list(common:listValueMerge(AttrList));
			   ?FALSE -> []
		   end,
	?IF(IsSave, put_suit_prop(Prop), Prop).

%% 计算 大师属性
calc_master_prop() ->
	calc_master_prop(variable_player:get_value(?Variable_Player_PetSacredEq_MasterLv)).
calc_master_prop(MasterLv) ->
	Fun = fun(Lv, PropRet) ->
		case cfg_ornamentStrengthAward:getRow(Lv) of
			#ornamentStrengthAwardCfg{attribute = Attr} ->
				attribute:base_prop_from_list(Attr) ++ PropRet;
			_ -> PropRet
		end end,
	PropList = lists:foldl(Fun, [], lists:seq(1, MasterLv)),
	put_master_prop(PropList).

calc_master_lv(Lv, OldMasterLv) ->
	Cfg = cfg_ornamentStrengthAward:getRow(Lv),
	?CHECK_CFG(Cfg),
	#ornamentStrengthAwardCfg{number = Amount, charAndStar = [{Chara, Star}], strengthLv = POrder} = Cfg,
	F = fun
			(#sacred_eq_pos{uid = Uid}, N) when Uid > 0 ->
				case check_wear(Uid) of%%穿戴条件不满足，属性不计算
					?FALSE -> N;
					?TRUE ->
						SacredEq = get_sacred_eq(Uid),
						case cfg_item:getRow(SacredEq#sacred_eq.cfg_id) of
							#itemCfg{character = C, detailedType3 = S, order = Order} when C >= Chara, S >= Star, Order >= POrder ->
								N + 1;
							_ -> N
						end
				end;
			(_, N) -> N
		end,
	case lists:foldl(F, 0, get_sacred_eq_pos_list()) >= Amount of
		?TRUE -> Lv;
		?FALSE -> OldMasterLv
	end.

%% 获取属性列表和评分(属性库ID列表,阶数)
get_attr(IDs, Order) -> get_attr(IDs, Order, {[], 0}).
get_attr([], _, Ret) -> Ret;
get_attr([{1, ID} | T], Order, {Ret1, Ret2}) ->%%属性
	case cfg_ornamentAttri:getRow(ID, Order) of
		#ornamentAttriCfg{attribute = Attr, point = ScorePoint} ->
			get_attr(T, Order, {Ret1 ++ Attr, ScorePoint + Ret2});
		_ -> get_attr(T, Order, {Ret1, Ret2})
	end;
get_attr([{2, ID} | T], Order, {Ret1, Ret2}) ->%%技能
	case cfg_ornamentSkill:getRow(ID) of
		#ornamentSkillCfg{point = Point} ->
			get_attr(T, Order, {Ret1, Point + Ret2});
		_ -> get_attr(T, Order, {Ret1, Ret2})
	end;
get_attr([ID | T], Order, {Ret1, Ret2}) ->
	case cfg_ornamentAttri:getRow(ID, Order) of
		#ornamentAttriCfg{attribute = Attr} ->
			get_attr(T, Order, {Ret1 ++ Attr, Ret2});
		_ -> get_attr(T, Order, {Ret1, Ret2})
	end.

%% 祝福对 基础属性极品属性  的加成
cast_attr_add([], BaseProp, RandProp, CastProp) -> {BaseProp, RandProp, CastProp};
cast_attr_add([#prop{index = ?P_HaishenJCW, base = Base_W} | T], BaseProp, RandProp, CastProp) ->
	NewBase = [P#prop{add = Base * (Multi + Base_W) / 10000 + Add} || #prop{multi = Multi, base = Base, add = Add} = P <- BaseProp],
	cast_attr_add(T, NewBase, RandProp, CastProp);
cast_attr_add([#prop{index = ?P_HaishenJPW, base = Rand_W} | T], BaseProp, RandProp, CastProp) ->
	NewRand = [P#prop{add = Base * (Multi + Rand_W) / 10000 + Add} || #prop{multi = Multi, base = Base, add = Add} = P <- RandProp],
	cast_attr_add(T, BaseProp, NewRand, CastProp);
cast_attr_add([Prop | T], BaseProp, RandProp, CastProp) ->
	cast_attr_add(T, BaseProp, RandProp, [Prop | CastProp]).

%%判断是否激活对应部位的圣装祝福
is_cast_active({Order, Chara, _Star}) ->
	ActiveChara = cfg_globalSetup:peishi_qj11(),
	ActiveOrder = cfg_globalSetup:peishi_qj14(),
	Chara >= ActiveChara andalso Order >= ActiveOrder;
is_cast_active(Pos) ->
	case get_sacred_eq_pos(Pos) of
		#sacred_eq_pos{uid = Uid} when Uid =/= 0 ->
			case get_sacred_eq(Uid) of
				#sacred_eq{cfg_id = CfgId} ->
					case cfg_item:getRow(CfgId) of
						#itemCfg{character = Chara, order = Order} ->
							ActiveChara = cfg_globalSetup:peishi_qj11(),
							ActiveOrder = cfg_globalSetup:peishi_qj14(),
							Chara >= ActiveChara andalso Order >= ActiveOrder;
						_ -> ?FALSE
					end;
				_ -> ?FALSE
			end;
		_ -> ?FALSE
	end.
%%================================= 属性与评分计算  end ================================================
%%生成英雄圣装实例
make_sacred_eq(#item{} = Item, Lv) ->
	SacredEq = make_sacred_eq(Item),
	SacredEq#sacred_eq{int_lv = Lv}.
make_sacred_eq(#item{id = Uid, cfg_id = CfgId, bind = Bind}) ->
	Cfg = cfg_ornamentEquip:getRow(CfgId),
	#sacred_eq{
		player_id = player:getPlayerID(),
		uid = Uid,
		cfg_id = CfgId,
		bind = Bind,
		base_prop = Cfg#ornamentEquipCfg.baseAttribute,
		rand_prop = make_rand_prop(Cfg),
		beyond_prop = make_beyond_prop(Cfg)
	}.

%%极品属性装配
make_rand_prop(#ornamentEquipCfg{starRule = Rule} = Cfg) ->
	AttrList = [
		Cfg#ornamentEquipCfg.starAttribute1,
		Cfg#ornamentEquipCfg.starAttribute2,
		Cfg#ornamentEquipCfg.starAttribute3,
		Cfg#ornamentEquipCfg.starAttribute4,
		Cfg#ornamentEquipCfg.starAttribute5,
		Cfg#ornamentEquipCfg.starAttribute6,
		Cfg#ornamentEquipCfg.starAttribute7,
		Cfg#ornamentEquipCfg.starAttribute8,
		Cfg#ornamentEquipCfg.starAttribute9
	],
	rand_prop(Rule, AttrList, []).

%%卓越属性装配
make_beyond_prop(#ornamentEquipCfg{starRule2 = Rule} = Cfg) ->
	AttrList = [
		Cfg#ornamentEquipCfg.starAttribute1,
		Cfg#ornamentEquipCfg.starAttribute2,
		Cfg#ornamentEquipCfg.starAttribute3,
		Cfg#ornamentEquipCfg.starAttribute4,
		Cfg#ornamentEquipCfg.starAttribute5,
		Cfg#ornamentEquipCfg.starAttribute6,
		Cfg#ornamentEquipCfg.starAttribute7,
		Cfg#ornamentEquipCfg.starAttribute8,
		Cfg#ornamentEquipCfg.starAttribute9
	],
	rand_prop(Rule, AttrList, []).

%%随机祝福属性
make_cast_rand(OldCast, #ornamentForgeCfg{starRule = RuleList} = CastCfg, Time) ->
	Rule = case [[R1, R2, R3] || {Min, Max, R1, R2, R3} <- RuleList, Time >= Min, Max == 0 orelse Time =< Max] of
			   [] -> [];
			   [L | _] -> [R0 || R0 <- L, R0 > 0]
		   end,
	AttrList = [
		CastCfg#ornamentForgeCfg.starAttribute1,
		CastCfg#ornamentForgeCfg.starAttribute2,
		CastCfg#ornamentForgeCfg.starAttribute3,
		CastCfg#ornamentForgeCfg.starAttribute4,
		CastCfg#ornamentForgeCfg.starAttribute5,
		CastCfg#ornamentForgeCfg.starAttribute6,
		CastCfg#ornamentForgeCfg.starAttribute7,
		CastCfg#ornamentForgeCfg.starAttribute8,
		CastCfg#ornamentForgeCfg.starAttribute9,
		CastCfg#ornamentForgeCfg.starAttribute10,
		CastCfg#ornamentForgeCfg.starAttribute11,
		CastCfg#ornamentForgeCfg.starAttribute12,
		CastCfg#ornamentForgeCfg.starAttribute13,
		CastCfg#ornamentForgeCfg.starAttribute14,
		CastCfg#ornamentForgeCfg.starAttribute15
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

rand_prop([], _, Ret) -> lists:reverse(Ret);
rand_prop([Index | T], AttrList, Ret) ->
	AttrList0 = case Index =< length(AttrList) of
					?TRUE -> lists:nth(Index, AttrList);
					_ -> []
				end,
	AttrList1 = [{AttrI, AttrW} || {AttrI, AttrW} <- AttrList0, check_prop(AttrI, Ret)],
	case common:getRandomValueFromWeightList_1(AttrList1, 0) of
		0 -> rand_prop(T, AttrList, Ret);
		I -> rand_prop(T, AttrList, [I | Ret])
	end.
%% 属性是否可用
check_prop(AttrI, AttrList) ->
	case get_attr([AttrI], 1) of
		{[{I, _} | _], _} ->
			{P, _} = get_attr(AttrList, 1),
			not lists:keymember(I, 1, P);
		_ -> ?FALSE
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
%%回归初始装备数据
make_base_sacred_eq(#item{} = Item, #sacred_eq{bind = BaseBind} = Orn, CfgId) ->
	NewItem = Item#item{cfg_id = CfgId, bind = BaseBind},
	NewOrn = Orn#sacred_eq{cfg_id = CfgId, bind = BaseBind, int_lv = 0},
	{NewItem, NewOrn}.

%% pk_sacred_eq 拼装消息
make_sacred_eq_msg(#sacred_eq{} = Info) ->
	#pk_sacred_eq{
		uid = Info#sacred_eq.uid,
		cfg_id = Info#sacred_eq.cfg_id,
		bind = Info#sacred_eq.bind,
		int_lv = Info#sacred_eq.int_lv,
		base_prop = Info#sacred_eq.base_prop,
		rand_prop = Info#sacred_eq.rand_prop,
		beyond_prop = Info#sacred_eq.beyond_prop
	}.

%% pk_sacred_eq_pos 拼装消息
make_sacred_eq_pos_msg(#sacred_eq_pos{} = Info) ->
	#pk_sacred_eq_pos{
		uid = Info#sacred_eq_pos.uid,
		pos = Info#sacred_eq_pos.pos,
		bless_prop = lists:sort([#pk_key_value{key = K, value = V} || {K, V} <- Info#sacred_eq_pos.bless_prop]),
		bless_prop_temp = lists:sort([#pk_key_value{key = K, value = V} || {K, V} <- Info#sacred_eq_pos.bless_prop_temp])
	}.

%%英雄圣装操作日志
%%1 装配卸下 2卸下  3 升级   4 升阶   5 祝福  6替换祝福  7放弃祝福  8 点亮  9拆解
%%op = 1时, uid为装配
log_pet_sacred_eq(Op, Uid, Pram, PramList, ItemList, CoinList) ->
	PlayerId = player:getPlayerID(),
	Time = time:time(),
	L = [PlayerId, Time, Op, Uid, Pram, common:formatString(PramList), gamedbProc:term_to_dbstring(ItemList), gamedbProc:term_to_dbstring(CoinList)],
	table_log:insert_row(log_pet_sacred_eq, L).