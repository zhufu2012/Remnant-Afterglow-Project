%%%-------------------------------------------------------------------
%%% @author zhubaicheng
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%		宠物抽奖
%%% @end
%%% Created : 30. 6月 2022 15:36
%%%-------------------------------------------------------------------
-module(pet_draw).
-author("zhubaicheng").
-include("db_table.hrl").
-include("error.hrl").
-include("global.hrl").
-include("item.hrl").
-include("player_task_define.hrl").
-include("netmsgRecords.hrl").
-include("reason.hrl").
-include("record.hrl").
-include("variable.hrl").
-include("cfg_heroRoulette1.hrl").
-include("cfg_heroRoulette2.hrl").
-include("cfg_item.hrl").
-include("cfg_petBase.hrl").
-include("util.hrl").
-include("seven_gift_define.hrl").
-include("activity_new.hrl").
-include("time_limit_gift_define.hrl").
-include("log_times_define.hrl").
-include("currency.hrl").
-include("attainment.hrl").
-include("player_private_list.hrl").
-include("cfg_heroRoulette3.hrl").
%% API
-export([on_load/0, on_player_online/0, on_reset/0, on_function_open/0, on_vip_change/2]).
-export([lists_2_draw/1, draw_2_list/1]).
-export([on_info_req/1, on_lib_req/1, on_draw/3, on_reward_score/3, on_set_wish/2, on_switch_element/2]).
-export([get_now_element/3, get_normal_draw_time/0, get_senior_draw_time/0, get_unknown_draw_time/0, get_history_draw_time/0, get_daily_draw_time/0, get_draw_ten_item/1]).
-export([get_related_item_list/0, send_red/0, send_bubbles/2, get_pet_element/1]).

-define(ELEMENT_TYPE_FIRE, 1). %% 风
-define(ELEMENT_TYPE_WIND, 2). %% 火
-define(ELEMENT_TYPE_SOIL, 3). %% 土
-define(ELEMENT_ORDER, [1, 2, 3]). %% 元素切换顺序

-define(CostItem, cost_item). %% 消耗类型 道具
-define(CostCoin, cost_coin). %% 消耗类型 货币
-define(CostFree, cost_free). %% 免费抽

-define(NormalDraw, 1). %% 普通抽奖
-define(SeniorDraw, 2). %% 高级抽奖
-define(UnknownDraw, 3). %% 未知抽奖

-define(RareR, 1). %% R稀有度
-define(RareSSR, 3). %% SSR稀有度

on_load() ->
	load_db().

lists_2_draw(List) ->
	Record = list_to_tuple([db_pet_draw | List]),
	Record#db_pet_draw{
		wish = gamedbProc:dbstring_to_term(Record#db_pet_draw.wish),
		count_time = gamedbProc:dbstring_to_term(Record#db_pet_draw.count_time),
		spec_time = gamedbProc:dbstring_to_term(Record#db_pet_draw.spec_time)
	}.

draw_2_list(Record) ->
	tl(tuple_to_list(Record#db_pet_draw{
		wish = gamedbProc:term_to_dbstring(Record#db_pet_draw.wish),
		count_time = gamedbProc:term_to_dbstring(Record#db_pet_draw.count_time),
		spec_time = gamedbProc:term_to_dbstring(Record#db_pet_draw.spec_time)
	})).

on_player_online() ->
	calc_related_item_list(),
	send_red(),
	change_bubbles(?TRUE, 0, vip:get_vip_lv()).

%% 重置每日抽奖次数
on_reset() ->
	F = fun(#db_pet_draw{id = Id} = Db, Ret) ->
		lists:keystore(Id, #db_pet_draw.id, Ret, Db#db_pet_draw{day_time = 0})
		end,
	List = lists:foldl(F, [], get_pet_draw_list()),
	update_draw(List).

%%宠物抽奖功能开启
on_function_open() ->
	player_task:check_add_condition_task(?ConditionTask_1).

on_vip_change(OldLv, NewLv) ->
	change_bubbles(?FALSE, OldLv, NewLv).

%% 抽奖信息请求
on_info_req(Id) ->
	try
		Cfg = cfg_heroRoulette1:getRow(Id),
		?CHECK_CFG(Cfg),
		DrawInfo = get_pet_draw_info(Id),
		Msg = make_info_msg(DrawInfo, Cfg),
		send_red(),
		player:send(#pk_GS2U_PetDrawInfoRet{err_code = ?ERROR_OK, info = Msg})
	catch
		Err -> player:send(#pk_GS2U_PetDrawInfoRet{err_code = Err})
	end.

%% 抽奖库请求
on_lib_req(Id) ->
	try
		Cfg = cfg_heroRoulette1:getRow(Id),
		?CHECK_CFG(Cfg),
%%		#heroRoulette1Cfg{switch1 = SwitchTime} = Cfg,
%%		#db_pet_draw{element_time = ElementTime} = get_pet_draw_info(Id),
%%		NowElement = get_now_element(ElementTime, SwitchTime, time:time()),
		LibList = get_lib(Id, all, ?FALSE),
		F = fun(LibId, Ret) ->
			#heroRoulette2Cfg{dropItem = Item, dropCondition = DropCondition, qualityShow = QualityShow} = cfg_heroRoulette2:getRow(LibId),
			[#pk_PetDrawLibrary{
				id = LibId,
				index_item = make_lib_msg(Item, DropCondition),
				quality_show = [#pk_key_value{key = Q, value = S} || {Q, S} <- QualityShow]} | Ret]
			end,
		LibMsgList = lists:foldl(F, [], LibList),
		player:send(#pk_GS2U_PetDrawLibRet{err_code = ?ERROR_OK, id = Id, lib = LibMsgList})
	catch
		Err -> player:send(#pk_GS2U_PetDrawLibRet{err_code = Err})
	end.

get_lib(Id, NowElement, IsCalc) ->
	case cfg_heroRoulette1:getRow(Id) of
		#heroRoulette1Cfg{firstWeight = First, contWeight = Cont, specWeight = Spec, commWeight = Comm} ->

			FirstLib = [Lib || {T, _, _, Lib, _} <- First, NowElement =:= all orelse (T =:= 0 orelse T =:= NowElement)],
			ContLib = case IsCalc of%%是否计算累计次数
						  ?TRUE ->
							  DrawAccumulateList = player_private_list:get_value(?Private_List_pet_draw_accumulate_list),
							  F = fun({T, _, _, Lib, _, _, Times}, ContLibRet) ->
								  case NowElement =:= all orelse (T =:= 0 orelse T =:= NowElement) of
									  ?TRUE ->
										  case lists:keyfind({T, Lib}, 1, DrawAccumulateList) of
											  ?FALSE when Times =:= 0 -> [Lib | ContLibRet];
											  ?FALSE -> ContLibRet;
											  {_, Times2} when Times2 >= Times -> [Lib | ContLibRet];
											  _ -> ContLibRet
										  end;
									  ?FALSE -> ContLibRet
								  end
								  end,
							  lists:foldl(F, [], Cont);
						  ?FALSE ->
							  [Lib || {T, _, _, Lib, _, _, _} <- Cont, NowElement =:= all orelse (T =:= 0 orelse T =:= NowElement)]
					  end,
			SpecLib = [Lib || {T, _, Lib, _, _, _} <- Spec, NowElement =:= all orelse (T =:= 0 orelse T =:= NowElement)],
			CommLib = [Lib || {T, _, Lib, _, _} <- Comm, NowElement =:= all orelse (T =:= 0 orelse T =:= NowElement)],
			lists:usort(FirstLib ++ ContLib ++ SpecLib ++ CommLib);
		_ -> throw(?ERROR_Cfg)
	end.

%% 抽奖
on_draw(Id, Num, IsFree) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(Id), ?ERROR_FunctionClose),
					 Cfg = cfg_heroRoulette1:getRow(Id),
					 ?CHECK_CFG(Cfg),
					 #heroRoulette1Cfg{consItem = Consume1, consItem2 = Consume2, score1 = {CoinType, CoinNum}, dayNum = VipTime, switch1 = SwitchTime} = Cfg,
					 #db_pet_draw{day_time = DayTime, wish = WishList, element_time = ElementTime} = Info = get_pet_draw_info(Id),
					 ?CHECK_THROW(Num > 0, ?ErrorCode_PetDrawTimeMinus),
					 ?CHECK_THROW(DayTime + Num =< vipFun:callVip(VipTime, 0), ?ErrorCode_PetDrawTime),
					 VipLv = vip:get_vip_lv(),
					 Consume11 = [{T, I, N} || {VF, VC, T, I, N} <- Consume1, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
					 %% 消耗检查
					 {CostPrepareType, Prepare, DecConsume} = check_consume(Id, Num, Consume11, Consume2, IsFree),
					 %% 次数循环抽奖
					 {NewInfo, Ret} =
						 case draw_loop(Num, Cfg, Info, IsFree, []) of
							 {?ERROR_OK, RetInfo, Ret0} ->
								 {RetInfo, Ret0};
							 Err0 ->
								 throw(Err0)
						 end,
					 NextFreeTime = NewInfo#db_pet_draw.free_time,
					 F = fun({Item, Coin}, {ItemAcc, CoinAcc}) ->
						 ItemList = common:merge_reward(Item ++ ItemAcc),
						 CoinList = common:listValueMerge(Coin ++ CoinAcc),
						 {ItemList, CoinList}
						 end,
					 {ItemList, CurrencyList} = lists:foldl(F, {[], []}, Ret),
					 {PetList, AwardItemList, AllItem} = award_prepare(ItemList),
					 ?CHECK_THROW(AllItem =/= [], ?ErrorCode_PetDrawNoAward), %% 奖励检查为空
					 Reason = case {Id, Num} of
								  {1, 1} -> ?REASON_pet_draw_normal_one;
								  {1, 10} -> ?REASON_pet_draw_normal_ten;
								  {1, 50} -> ?REASON_pet_draw_normal_fifty;
								  {2, 1} -> ?REASON_pet_draw_high_one;
								  {2, 5} -> ?REASON_pet_draw_high_five;
								  {2, 20} -> ?REASON_pet_draw_high_twenty;
								  {3, 1} -> ?REASON_pet_draw_unknown_one;
								  {3, 10} -> ?REASON_pet_draw_unknown_ten;
								  {3, 50} -> ?REASON_pet_draw_unknown_fifty;
								  _ -> ?REASON_pet_draw
							  end,
					 %% 判断完成，进行消耗/奖励
					 case CostPrepareType of
						 ?CostItem -> bag_player:delete_finish(Prepare, Reason);
						 ?CostCoin -> currency:delete_finish(Prepare, Reason);
						 ?CostFree -> skip
					 end,
					 ItemMsg = lists:reverse(calc_update_atlas(Ret)),
					 pet_new:on_item_use_add_list(PetList),
					 GetPetCacheList = [pet_new:get_pet(Uid) || Uid <- pet_new:get_activate_cache()],
					 pet_new:send_active_attr_info(),
					 case AwardItemList =/= [] of
						 ?TRUE -> bag_player:add(AwardItemList, Reason);
						 ?FALSE -> ok
					 end,
					 TotalCurrency = common:listValueMerge([{CoinType, CoinNum * Num} | CurrencyList]),
					 currency:add(TotalCurrency, Reason), %% 积分奖励
					 update_draw(NewInfo),
					 refresh_task(Id, Num),
					 send_red(),
					 Msg = make_info_msg(NewInfo, Cfg), %% 重新发送界面信息
					 player:send(#pk_GS2U_PetDrawInfoRet{err_code = ?ERROR_OK, info = Msg}),
					 player:send(#pk_GS2U_PetDrawRet{err_code = ?ERROR_OK, id = Id, num = Num, is_free = IsFree, next_free_time = NextFreeTime,
						 draw_item = ItemMsg,
						 draw_coin = [#pk_key_value{key = T, value = N} || {T, N} <- TotalCurrency]}),
					 send_notice(Id, PetList),
					 activity_new_player:on_active_condition_change(?SalesActivity_PetDrawn, Num),
					 case Id of
						 ?NormalDraw ->
							 activity_new_player:on_active_condition_change(?SalesActivity_PetNormalDrawn, Num),
							 time_limit_gift:check_open(?TimeLimitType_PetDrawnNormal),
							 times_log:add_times(?Log_Type_DayPetDrawnNormal, Num),
							 attainment:check_attainment(?Attainments_PetCallCount),
							 activity_new_player:on_func_open_check(?ActivityOpenType_PetNormalDrawTime, {Info#db_pet_draw.draw_time, NewInfo#db_pet_draw.draw_time}),
							 ok;
						 ?SeniorDraw ->
							 activity_new_player:on_active_condition_change(?SalesActivity_PetHigherDrawn, Num),
							 time_limit_gift:check_open(?TimeLimitType_PetDrawnHigher),
							 times_log:add_times(?Log_Type_DayPetDrawnHigher, Num),
							 attainment:check_attainment(?Attainments_Type_PetDestinyCallCount),
							 activity_new_player:on_func_open_check(?ActivityOpenType_PetSeniorDrawTime, {Info#db_pet_draw.draw_time, NewInfo#db_pet_draw.draw_time}),
							 ok;
						 ?UnknownDraw ->
							 activity_new_player:on_active_condition_change(?SalesActivity_UnknownDraw, Num),
							 attainment:check_attainment(?Attainments_Type_UnknownCount);
						 _ -> ok
					 end,
					 pet_base:log_pet_op(GetPetCacheList, Reason, get),
					 WishPetCfgIDList = [get_cfg_pet(PetItemId) || {_, PetItemId} <- WishList],
					 [efun_log:hero_get(Pet#pet_new.pet_cfg_id, Pet#pet_new.star, common:bool_to_int(lists:member(Pet#pet_new.pet_cfg_id, WishPetCfgIDList)), Reason) || Pet <- GetPetCacheList],
					 efun_log:hero_draw(Reason, GetPetCacheList, WishPetCfgIDList, get_now_element(ElementTime, SwitchTime, time:time()), {CostPrepareType, DecConsume}),
					 case Id of
						 1 -> logdbProc:log_xun_bao(5, Num, IsFree);
						 2 -> logdbProc:log_xun_bao(6, Num, IsFree);
						 3 -> logdbProc:log_xun_bao(9, Num, IsFree)
					 end,
					 ok
				 catch
					 Err ->
						 player:send(#pk_GS2U_PetDrawRet{err_code = Err, id = Id, num = Num, is_free = IsFree})
				 end end).

%% 判断是否是新的宠物并更新图鉴
calc_update_atlas(Ret) ->
	AtlasList = pet_atlas:get_atlas_list(),
	F = fun({[{_, I, N}], _}, {AtlasAcc, UpdateAcc, ItemAcc}) ->
		PetCfgId = get_cfg_pet(I),
		PetCfg = cfg_petBase:getRow(PetCfgId),
		case is_pet(PetCfgId) of
			?FALSE -> {AtlasAcc, UpdateAcc, [#pk_PetDrawItem{cfgId = I, amount = N} | ItemAcc]}; %% 道具叠加
			?TRUE ->
				case lists:keyfind(PetCfgId, #atlas.atlas_id, AtlasAcc) of
					#atlas{} ->
						{AtlasAcc, UpdateAcc, [#pk_PetDrawItem{cfgId = I, amount = N} | ItemAcc]}; %% 已经获得过的
					_ ->
						case PetCfg#petBaseCfg.rareType > ?RareR of %% R稀有度不显示New
							?TRUE ->
								{[#atlas{atlas_id = PetCfgId} | AtlasAcc], [#atlas{atlas_id = PetCfgId} | UpdateAcc],
									[#pk_PetDrawItem{cfgId = I, amount = N, is_new = 1} | ItemAcc]}; %% 新获得的宠物
							_ ->
								PetDrawItemList = case df:getItemDefineCfg(I) of%%要求突出显示，就显示
													  #itemCfg{prominentShow = Show} when Show =/= [] ->
														  [#pk_PetDrawItem{cfgId = I, amount = N, is_new = 1} | ItemAcc];
													  _ ->
														  [#pk_PetDrawItem{cfgId = I, amount = N} | ItemAcc]
												  end,
								{[#atlas{atlas_id = PetCfgId} | AtlasAcc], [#atlas{atlas_id = PetCfgId} | UpdateAcc],
									PetDrawItemList}
						end
				end
		end end,
	{_, UpdateAtlasList, ItemMsg} = lists:foldl(F, {AtlasList, [], []}, Ret),
	pet_atlas:update_atlas(UpdateAtlasList),
	ItemMsg.

%% 领取积分奖励
on_reward_score(Id, Type, Num) ->
	try
		?CHECK_THROW(Num >= 1, ?ERROR_Param),%%最少1次
		Cfg = cfg_heroRoulette1:getRow(Id),
		?CHECK_CFG(Cfg),
		#heroRoulette1Cfg{score2 = ScoreCondition, scoreReward = ScoreReward} = Cfg,
		?CHECK_THROW(ScoreCondition =/= {0, 0}, ?ErrorCode_PetDrawScoreReward),
		%%{货币类型，消耗货币总数量}
		Prepared = case ScoreCondition of%%判断配置条件
					   {P1, P2} ->
						   case currency:delete_prepare([{P1, P2 * Num}]) of
							   {?ERROR_OK, CurrencyPrepared} -> CurrencyPrepared;
							   _ -> throw(?ErrorCode_DecPetDrawNormal)
						   end;
					   _ -> throw(?ErrorCode_PetDrawScoreReward)
				   end,
		Ret = case lists:keyfind(Type, 1, ScoreReward) of
				  {Type, Lib} ->
					  lists:flatten([get_lib_ret(Lib, Type, 1, []) || _ <- lists:seq(1, Num)]);
				  _ -> throw(?ErrorCode_PetDrawScoreReward)
			  end,
		F = fun({Item, _Coin}, ItemAcc) ->
			common:merge_reward(Item ++ ItemAcc)
			end,
		ItemList = lists:foldl(F, [], Ret),
		{PetList, AwardItemList, AllItem} = award_prepare(ItemList),
		?CHECK_THROW(AllItem =/= [], ?ErrorCode_PetDrawNoAward), %% 奖励检查为空
		currency:delete_finish(Prepared, ?REASON_pet_draw_score),
		case AwardItemList =/= [] of
			?TRUE -> bag:add_raw(?BAG_PLAYER, AwardItemList, ?REASON_pet_draw_score);
			?FALSE -> ok
		end,
		player:send(#pk_GS2U_pet_new{list = pet_new:get_pet_new(PetList)}),
		pet_new:on_item_use_add_list(PetList),
		GetPetCacheList = [pet_new:get_pet(Uid) || Uid <- pet_new:get_activate_cache()],
		pet_new:send_active_attr_info(),
		MsgItem = [#pk_PetDrawItem{cfgId = I, amount = N} || {[{_, I, N} | _], _} <- Ret],
		player_item:show_get_item_dialog(AllItem, [], [], 0, 0),
		send_red(),
		player:send(#pk_GS2U_PetDrawScoreAwardRet{err_code = ?ERROR_OK, id = Id,
			draw_item = MsgItem}),
		pet_base:log_pet_op(GetPetCacheList, ?REASON_pet_draw_score, get),
		ok
	catch
		Err -> player:send(#pk_GS2U_PetDrawScoreAwardRet{err_code = Err, id = Id})
	end.

%% 设置宠物心愿单
on_set_wish(Id, WishList) ->
	try
		SortList = lists:ukeysort(1, WishList),
		?CHECK_THROW(length(SortList) =:= length(WishList), ?ErrorCode_PetDrawWishRepeatType),
		Cfg = cfg_heroRoulette1:getRow(Id),
		?CHECK_CFG(Cfg),
		#heroRoulette1Cfg{number = WishCondition, numberVip = WishVip} = Cfg,
		#db_pet_draw{draw_time = DrawTime, wish = Wish} = Db = get_pet_draw_info(Id),
		VipLv = vip:get_vip_lv(),
		case WishCondition of
			0 -> throw(?ErrorCode_PetDrawWishForbidden);
			Num -> ?CHECK_THROW(DrawTime >= Num orelse VipLv >= WishVip, ?ErrorCode_PetDrawWishTime)
		end,
		F = fun({Type, CfgId}) ->
			PetCfgId = get_cfg_pet(CfgId),
			PetCfg = cfg_petBase:getRow(PetCfgId),
			?CHECK_CFG(PetCfg),
			#petBaseCfg{elemType = ElemType, rareType = RareType} = PetCfg,
			?CHECK_THROW(ElemType =:= Type, ?ErrorCode_PetDrawElementType),
			?CHECK_THROW(RareType =:= ?RareSSR, ?ErrorCode_PetDrawWishSSR)
			end,
		lists:foreach(F, WishList),
		case SortList =:= Wish of
			?TRUE -> skip;
			_ -> update_draw(Db#db_pet_draw{wish = SortList})
		end,
		ChangeType = case length(Wish) > length(SortList) of
						 ?TRUE -> 1;
						 ?FALSE -> 2
					 end,
		efun_log:hero_wish_change_up(ChangeType, Wish, SortList),
		player:send(#pk_GS2U_PetDrawSetWishRet{err_code = ?ERROR_OK, id = Id, wish_list = [#pk_key_value{key = Type, value = CfgId} || {Type, CfgId} <- WishList]})
	catch
		Err ->
			player:send(#pk_GS2U_PetDrawSetWishRet{err_code = Err, id = Id, wish_list = [#pk_key_value{key = Type, value = CfgId} || {Type, CfgId} <- WishList]})
	end.

%% 手动切换元素限定
on_switch_element(Id, Type) ->
	try
		Cfg = cfg_heroRoulette1:getRow(Id),
		?CHECK_CFG(Cfg),
		#heroRoulette1Cfg{switch1 = SwitchTime, switch2 = {CostType, CostNum}} = Cfg,
		?CHECK_THROW(SwitchTime =:= 0 orelse CostType =:= 0, ?ErrorCode_PetDrawElementCantSwitch),
		#db_pet_draw{element_time = ElementTime} = Db = get_pet_draw_info(Id),
		Time = time:time(),
		NowElement = get_now_element(ElementTime, SwitchTime, Time),
		?CHECK_THROW(Type =/= NowElement, ?ErrorCode_PetDrawElementType),
		CurrencyError = currency:delete([{CostType, CostNum}], ?REASON_pet_draw_switch_element),
		?ERROR_CHECK_THROW(CurrencyError),
		update_draw(Db#db_pet_draw{element_time = ElementTime + calc_switch_time(NowElement, Type)}),
		player:send(#pk_GS2U_ChangeElementRes{err_code = ?ERROR_OK, id = Id, element = Type})
	catch
		Err ->
			player:send(#pk_GS2U_ChangeElementRes{err_code = Err, id = Id, element = Type})
	end.

%% 抽奖总次数
get_normal_draw_time() ->
	#db_pet_draw{draw_time = DrawTime} = get_pet_draw_info(?NormalDraw),
	DrawTime.
get_senior_draw_time() ->
	#db_pet_draw{draw_time = DrawTime} = get_pet_draw_info(?SeniorDraw),
	DrawTime.
get_unknown_draw_time() ->
	#db_pet_draw{draw_time = DrawTime} = get_pet_draw_info(?UnknownDraw),
	DrawTime.

%% 历史总次数
get_history_draw_time() ->
	get_normal_draw_time() + get_senior_draw_time() + get_unknown_draw_time().

%% 每日总次数
get_daily_draw_time() ->
	#db_pet_draw{day_time = NormalTime} = get_pet_draw_info(?NormalDraw),
	#db_pet_draw{day_time = SeniorTime} = get_pet_draw_info(?SeniorDraw),
	#db_pet_draw{day_time = UnknownTime} = get_pet_draw_info(?UnknownDraw),
	NormalTime + SeniorTime + UnknownTime.

%%获取英雄抽奖 的道具配置
get_draw_ten_item(Index) ->
	#heroRoulette1Cfg{consItem = Consume1} = cfg_heroRoulette1:getRow(Index),
	VipLv = vip:get_vip_lv(),
	[{T, I, N} || {VF, VC, T, I, N} <- Consume1, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC].

%% 发送红点
send_red() ->
	try
		Time = time:time(),
		Cfg1 = cfg_heroRoulette1:getRow(?NormalDraw),
		?CHECK_CFG(Cfg1),
		Cfg2 = cfg_heroRoulette1:getRow(?SeniorDraw),
		?CHECK_CFG(Cfg2),
		Cfg3 = cfg_heroRoulette1:getRow(?UnknownDraw),
		?CHECK_CFG(Cfg3),
		#heroRoulette1Cfg{score2 = NormalScore, consItem = NormalItem} = Cfg1,
		#heroRoulette1Cfg{consItem = SeniorItem} = Cfg2,
		#heroRoulette1Cfg{consItem = UnknownItem} = Cfg3,
		#db_pet_draw{free_time = NormalFreeTime} = get_pet_draw_info(?NormalDraw),

		VipLv = vip:get_vip_lv(),
		NormalItem1 = [{T, I, N} || {VF, VC, T, I, N} <- NormalItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
		SeniorItem1 = [{T, I, N} || {VF, VC, T, I, N} <- SeniorItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
		UnknownItem1 = [{T, I, N} || {VF, VC, T, I, N} <- UnknownItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
		{_, NormalItemCfg, NormalNum} = common:listFindMax(1, NormalItem1),
		{_, SeniorItemCfg, SeniorNum} = common:listFindMax(1, SeniorItem1),
		{_, UnknownItemCfg, UnknownNum} = common:listFindMax(1, UnknownItem1),
		{Err1, _} = currency:delete_prepare([NormalScore]),
		{Err2, _} = bag_player:delete_prepare([{NormalItemCfg, NormalNum}]),
		{Err3, _} = bag_player:delete_prepare([{SeniorItemCfg, SeniorNum}]),
		{Err4, _} = bag_player:delete_prepare([{UnknownItemCfg, UnknownNum}]),
		player:send(#pk_GS2U_PetDrawRed{
			normal_score = ?IF(Err1 =:= ?ERROR_OK, 1, 0),
			normal_free = common:bool_to_int(Time >= NormalFreeTime),
			normal_ten = ?IF(Err2 =:= ?ERROR_OK, 1, 0),
			senior_ten = ?IF(Err3 =:= ?ERROR_OK, 1, 0),
			unknown_ten = ?IF(Err4 =:= ?ERROR_OK, 1, 0)}),
		Err2 =:= ?ERROR_OK andalso player_task:check_add_condition_task(?ConditionTask_1),
		ok
	catch
		_ -> ?LOG_ERROR("check cfg_heroRoulette1")
	end.

%% 红点刷新用道具
set_related_item_list(List) ->
	put({?MODULE, related_item_list}, List).
get_related_item_list() ->
	case get({?MODULE, related_item_list}) of
		?UNDEFINED -> [];
		L -> L
	end.

%% 上线/vip变化发送气泡
change_bubbles(IsOnline, OldLv, NewLv) ->
	try
		NorFunc = is_func_open(?NormalDraw),
		SenFunc = is_func_open(?SeniorDraw),
		UnknownFunc = is_func_open(?UnknownDraw),
		case NorFunc =:= ?TRUE orelse SenFunc =:= ?TRUE orelse UnknownFunc =:= ?TRUE of
			?TRUE ->
				Cfg1 = cfg_heroRoulette1:getRow(?NormalDraw),
				?CHECK_CFG(Cfg1),
				Cfg2 = cfg_heroRoulette1:getRow(?SeniorDraw),
				?CHECK_CFG(Cfg2),
				Cfg3 = cfg_heroRoulette1:getRow(?UnknownDraw),
				?CHECK_CFG(Cfg3),
				#heroRoulette1Cfg{consItem = NormalItem} = Cfg1,
				#heroRoulette1Cfg{consItem = SeniorItem} = Cfg2,
				#heroRoulette1Cfg{consItem = UnknownItem} = Cfg3,
				OldNormalItem1 = [{T, I, N} || {VF, VC, T, I, N} <- NormalItem, VF == 0 orelse VF =< OldLv, VC == 0 orelse OldLv =< VC],
				OldSeniorItem1 = [{T, I, N} || {VF, VC, T, I, N} <- SeniorItem, VF == 0 orelse VF =< OldLv, VC == 0 orelse OldLv =< VC],
				OldUnknownItem1 = [{T, I, N} || {VF, VC, T, I, N} <- UnknownItem, VF == 0 orelse VF =< OldLv, VC == 0 orelse OldLv =< VC],
				NewNormalItem1 = [{T, I, N} || {VF, VC, T, I, N} <- NormalItem, VF == 0 orelse VF =< NewLv, VC == 0 orelse NewLv =< VC],
				NewSeniorItem1 = [{T, I, N} || {VF, VC, T, I, N} <- SeniorItem, VF == 0 orelse VF =< NewLv, VC == 0 orelse NewLv =< VC],
				NewUnknownItem1 = [{T, I, N} || {VF, VC, T, I, N} <- UnknownItem, VF == 0 orelse VF =< NewLv, VC == 0 orelse NewLv =< VC],
				{_, _, OldNorNeed} = common:listFindMax(1, OldNormalItem1),
				{_, _, OldSenNeed} = common:listFindMax(1, OldSeniorItem1),
				{_, _, OldUnNeed} = common:listFindMax(1, OldUnknownItem1),
				{NorTimes, NormalItemCfg, NewNorNeed} = common:listFindMax(1, NewNormalItem1),
				{SenTimes, SeniorItemCfg, NewSenNeed} = common:listFindMax(1, NewSeniorItem1),
				{UnTimes, UnknownItemCfg, NewUnNeed} = common:listFindMax(1, NewUnknownItem1),
				%% 普通抽奖倍数
				NorDiv = case NewNorNeed of
							 45 -> cfg_globalSetup:xunbaotanchuangtuisong5();
							 9 -> cfg_globalSetup:xunbaotanchuangtuisong4();
							 _ -> cfg_globalSetup:xunbaotanchuangtuisong2()
						 end,
				%% 高级抽奖数量
				SenDiv = case NewSenNeed of
							 20 -> cfg_globalSetup:xunbaotanchuangtuisong6();
							 _ -> cfg_globalSetup:xunbaotanchuangtuisong3()
						 end,
				{Err2, _} = bag_player:delete_prepare([{NormalItemCfg, NorDiv}]),
				{Err3, _} = bag_player:delete_prepare([{SeniorItemCfg, SenDiv}]),
				{Err4, _} = bag_player:delete_prepare([{UnknownItemCfg, NewUnNeed}]),
				NorBubble = (IsOnline == ?TRUE orelse NewNorNeed =/= OldNorNeed) andalso Err2 =:= ?ERROR_OK andalso NorFunc =:= ?TRUE,
				SenBubble = (IsOnline == ?TRUE orelse NewSenNeed =/= OldSenNeed) andalso Err3 =:= ?ERROR_OK andalso SenFunc =:= ?TRUE,
				UnBubble = (IsOnline == ?TRUE orelse NewUnNeed =/= OldUnNeed) andalso Err4 =:= ?ERROR_OK andalso UnknownFunc =:= ?TRUE,
				case NorBubble orelse SenBubble orelse UnBubble of
					?TRUE ->
						player:send(#pk_GS2U_PetDrawBubbles{
							normal_bubble = common:bool_to_int(NorBubble),
							normal_times = NorTimes,
							senior_bubble = common:bool_to_int(SenBubble),
							senior_times = SenTimes,
							unknown_bubble = common:bool_to_int(UnBubble),
							unknown_times = UnTimes
						});
					?FALSE -> ok
				end;
			_ -> skip
		end
	catch
		_ -> ?LOG_ERROR("check cfg_heroRoulette1")
	end.

%% 道具变化发送气泡
send_bubbles(UpdateList, OldUpdateList) ->
	try
		NorFunc = is_func_open(?NormalDraw),
		SenFunc = is_func_open(?SeniorDraw),
		UnFunc = is_func_open(?UnknownDraw),
		case NorFunc =:= ?TRUE orelse SenFunc =:= ?TRUE orelse UnFunc =:= ?TRUE of
			?TRUE ->
				Cfg1 = cfg_heroRoulette1:getRow(?NormalDraw),
				?CHECK_CFG(Cfg1),
				Cfg2 = cfg_heroRoulette1:getRow(?SeniorDraw),
				?CHECK_CFG(Cfg2),
				Cfg3 = cfg_heroRoulette1:getRow(?UnknownDraw),
				?CHECK_CFG(Cfg3),
				#heroRoulette1Cfg{consItem = NormalItem} = Cfg1,
				#heroRoulette1Cfg{consItem = SeniorItem} = Cfg2,
				#heroRoulette1Cfg{consItem = UnknownItem} = Cfg3,
				VipLv = vip:get_vip_lv(),
				NormalItem1 = [{T, I, N} || {VF, VC, T, I, N} <- NormalItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
				SeniorItem1 = [{T, I, N} || {VF, VC, T, I, N} <- SeniorItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
				UnknownItem1 = [{T, I, N} || {VF, VC, T, I, N} <- UnknownItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
				{NorTimes, NormalItemCfg, NorNeed} = common:listFindMax(1, NormalItem1), %% 普通10连道具
				{SenTimes, SeniorItemCfg, SenNeed} = common:listFindMax(1, SeniorItem1), %% 高级5连道具
				{UnTimes, UnknownCfg, UnNeed} = common:listFindMax(1, UnknownItem1), %% 未知10连道具
				OldNorNum = lists:sum([N || #item{cfg_id = C, amount = N} <- OldUpdateList, C =:= NormalItemCfg]),
				OldSenNum = lists:sum([N || #item{cfg_id = C, amount = N} <- OldUpdateList, C =:= SeniorItemCfg]),
				OldUnNum = lists:sum([N || #item{cfg_id = C, amount = N} <- OldUpdateList, C =:= UnknownCfg]),
				NewNorNum = lists:sum([N || #item{cfg_id = C, amount = N} <- UpdateList, C =:= NormalItemCfg]),
				NewSenNum = lists:sum([N || #item{cfg_id = C, amount = N} <- UpdateList, C =:= SeniorItemCfg]),
				NewUnNum = lists:sum([N || #item{cfg_id = C, amount = N} <- UpdateList, C =:= UnknownCfg]),
				%% 普通抽奖倍数
				NorDiv = case NorNeed of
							 45 -> cfg_globalSetup:xunbaotanchuangtuisong5();
							 9 -> cfg_globalSetup:xunbaotanchuangtuisong4();
							 _ -> cfg_globalSetup:xunbaotanchuangtuisong2()
						 end,
				%% 高级抽奖数量
				SenDiv = case SenNeed of
							 20 -> cfg_globalSetup:xunbaotanchuangtuisong6();
							 _ -> cfg_globalSetup:xunbaotanchuangtuisong3()
						 end,
				NorBubble = NewNorNum > OldNorNum andalso NorFunc andalso OldNorNum div NorDiv < NewNorNum div NorDiv,
				SenBubble = NewSenNum > OldSenNum andalso SenFunc andalso OldSenNum div SenDiv < NewSenNum div SenDiv,
				UnBubble = NewUnNum > OldUnNum andalso UnFunc andalso OldUnNum div UnNeed < NewUnNum div UnNeed,
				case NorBubble orelse SenBubble orelse UnBubble of
					?TRUE ->
						player:send(#pk_GS2U_PetDrawBubbles{
							normal_bubble = common:bool_to_int(NorBubble),
							normal_times = NorTimes,
							senior_bubble = common:bool_to_int(SenBubble),
							senior_times = SenTimes,
							unknown_bubble = common:bool_to_int(UnBubble),
							unknown_times = UnTimes
						});
					?FALSE -> ok
				end;
			_ -> skip
		end
	catch
		_ -> ?LOG_ERROR("check cfg_heroRoulette1")
	end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
set_pet_draw_list(L) -> put(pet_draw_list, L).
get_pet_draw_list() ->
	case get(pet_draw_list) of
		?UNDEFINED -> [];
		R -> R
	end.

get_pet_draw_info(Id) ->
	case lists:keyfind(Id, #db_pet_draw.id, get_pet_draw_list()) of
		?FALSE ->
			#db_pet_draw{player_id = player:getPlayerID(), id = Id};
		Db ->
			Db
	end.

load_db() ->
	PlayerId = player:getPlayerID(),
	Db = table_player:lookup(db_pet_draw, PlayerId),
	set_pet_draw_list(Db).


update_draw(#db_pet_draw{} = Db) ->
	update_draw([Db]);
update_draw(DbList) ->
	F = fun(#db_pet_draw{id = Id} = Db, Ret) ->
		lists:keystore(Id, #db_pet_draw.id, Ret, Db#db_pet_draw{player_id = player:getPlayerID()})
		end,
	NewList = lists:foldl(F, get_pet_draw_list(), DbList),
	set_pet_draw_list(NewList),
	NewDb = [Db#db_pet_draw{player_id = player:getPlayerID()} || Db <- DbList],
	table_player:insert(db_pet_draw, NewDb).

make_info_msg(DbInfo, Cfg) ->
	Time = time:time(),
	#db_pet_draw{id = Id,
		free_time = FreeTime,
		day_time = DayTime,
		draw_time = DrawTime,
		element_time = ElementTime,
		wish = Wish
	} = DbInfo,
	#heroRoulette1Cfg{
		consItem = CostItem,
		consItem2 = CostCoin,
		dayNum = VipTime,
		freeOnce = FreeOnce,
		score2 = {ScoreCoinType, ScoreCostNum},
		scoreReward = ScoreReward,
		number = WishTime,
		numberVip = WishVip,
		switch1 = SwitchTime, %% 每日切换元素时间
		switch2 = {SwitchCoinType, SwitchCost},
		quality = Quality,
		preview = Preview
	} = Cfg,
	VipLv = vip:get_vip_lv(),
	CostItem1 = [{VF, VC, T, I, N} || {VF, VC, T, I, N} <- CostItem, VF == 0 orelse VF =< VipLv, VC == 0 orelse VipLv =< VC],
	CostCoin1 = [{0, 0, T, I, N} || {T, I, N} <- CostCoin],
	NowElement = get_now_element(ElementTime, SwitchTime, Time),
	NowText = get_now_per_text(Id, NowElement),
	#pk_PetDrawInfo{
		id = Id,
		day_time = DayTime,
		day_limit = vipFun:callVip(VipTime, 0),
		all_time = DrawTime,
		wish_time = WishTime,
		wish_vip = WishVip,
		can_free = can_free(FreeOnce),
		free_time = FreeTime,
		cost_item = make_cost_msg(CostItem1),
		cost_coin = make_cost_msg(CostCoin1),
		score_cost = #pk_key_value{key = ScoreCoinType, value = ScoreCostNum},
		score_award = [#pk_key_value{key = Type, value = LibId} || {Type, LibId} <- ScoreReward],
		pet_wish = [#pk_PetWish{type = Type, pet_id = PetCfgId} || {Type, PetCfgId} <- Wish],
		element = NowElement,
		switch_time = get_next_switch_time(SwitchTime, Time),
		switch_cost = #pk_key_value{key = SwitchCoinType, value = SwitchCost},
		show_per = [#pk_PetDrawShow{type = T, quality = Q, per = P} || {T, Q, P} <- Quality],
		preview = Preview,
		per_text = NowText
	}.

calc_switch_time(NowType, SwitchType) ->
	Add = SwitchType - NowType,
	case Add >= 0 of
		?TRUE -> Add;
		?FALSE -> Add + length(?ELEMENT_ORDER)
	end.

%% 计算下次元素切换时间
get_next_switch_time(SwitchTime, Time) ->
	RealSwitchTime = time:daytime_add(Time, SwitchTime),
	case Time < RealSwitchTime of
		?TRUE -> time:time_sub(RealSwitchTime, Time);
		?FALSE -> time:time_sub(time:time_add(RealSwitchTime, ?SECONDS_PER_DAY), Time)
	end.

%%获取当前的概率公示文字
get_now_per_text(Id, NowElement) ->
	StartDay = main:getServerStartDays(),%%开服天数
	try
		L = [{Cfg#heroRoulette3Cfg.serviceDays, Cfg#heroRoulette3Cfg.xunbao_text} || {P1, P2, P3} <- cfg_heroRoulette3:getKeyList(), P1 =:= Id, P2 =:= NowElement,
			(Cfg = cfg_heroRoulette3:getRow(P1, P2, P3)) =/= {}],
		case [Text || {{Day1, Day2}, Text} <- L, Day1 =< StartDay, Day2 >= StartDay orelse Day2 =:= 0] of
			[] ->
				throw(?ERROR_Cfg);
			[XunBaoText | _] ->
				XunBaoText
		end
	catch
		_ ->
			?LOG_ERROR("heroRoulette3Cfg no cfg error,id:~p ,camp:~p  ,startday:~p", [Id, NowElement, StartDay]),
			""
	end.

%% 配置是否允许免费筹建
can_free(FreeOnce) ->
	case FreeOnce of
		0 -> 0;
		_ -> 1
	end.

make_cost_msg(Cost) ->
	[#pk_PetDrawConsume{vip_f = VF, vip_c = VC, draw_time = T, item = I, num = N} || {VF, VC, T, I, N} <- Cost].

%% 生成经过判断条件的奖励库
make_lib_msg(DropItem, DropCondition) ->
	BanList = [Index || {Index, Type, P1, P2, P3} <- DropCondition, not check_condition(Index, Type, P1, P2, P3)],
	F = fun({Index, ItemCfg, _Num}, Ret) ->
		case lists:member(Index, BanList) of
			?FALSE -> [{Index, ItemCfg} | Ret];
			?TRUE -> Ret
		end end,
	OkList = lists:foldl(F, [], DropItem),
	SortList = lists:ukeysort(2, OkList),
	[#pk_key_value{key = I, value = C} || {I, C} <- SortList].

%% 根据抽奖次数，先检查道具，再检查货币
check_consume(Id, Num, Consume1, Consume2, IsFree) ->
	try
		?CHECK_THROW(IsFree =/= 1, {?CostFree, 0, [{0, 0}]}),
		case Id of
			?UnknownDraw ->
				case lists:keyfind(10, 1, Consume1) of
					{_, CoinType2, _} ->
						case bag_player:delete_prepare([{CoinType2, Num}]) of
							{?ERROR_OK, CoinPrepare2} ->
								throw({?CostItem, CoinPrepare2, [{CoinType2, Num}]});
							_ -> throw(?ErrorCode_PetDrawCost)
						end;
					_ -> throw(?ErrorCode_PetDrawCostTime)
				end;
			_ ->
				ok
		end,
		case lists:keyfind(Num, 1, Consume1) of
			{Num, ConsumeCfgId, ItemCOstNum} ->
				case bag_player:delete_prepare([{ConsumeCfgId, ItemCOstNum}]) of
					{?ERROR_OK, CostItemPrepare} -> throw({?CostItem, CostItemPrepare, [{ConsumeCfgId, ItemCOstNum}]});
					_ -> skip
				end;
			_ -> skip
		end,
		case lists:keyfind(Num, 1, Consume2) of
			{Num, CoinType, CoinCostNum} ->
				case currency:delete_prepare(CoinType, CoinCostNum) of
					{?ERROR_OK, CoinPrepare} -> throw({?CostCoin, CoinPrepare, [{CoinType, CoinCostNum}]});
					_ -> throw(?ErrorCode_PetDrawCost)
				end;
			_ -> throw(?ErrorCode_PetDrawCostTime)
		end
	catch
		{Type, Prepare, Consume} -> {Type, Prepare, Consume};
		Err -> throw(Err)
	end.

%% 次数循环
draw_loop(0, _Cfg, Info, _IsFree, Ret) ->
	{?ERROR_OK, Info, Ret};
draw_loop(Num, Cfg, Info, IsFree, Ret) when Num > 0 ->
	case draw(Cfg, Info, IsFree) of
		{?ERROR_OK, NewInfo, Ret0} ->
			draw_loop(Num - 1, Cfg, NewInfo, IsFree, Ret ++ Ret0);
		Err ->
			throw(Err)
	end.

%% 先判断首抽，再判断保底，特殊掉落，没有再进行普通掉落
%% 返回 {错误码, NewDb, 物品id列表[{CfgId, Num]]}
draw(Cfg, Info, IsFree) ->
	try
		#heroRoulette1Cfg{freeOnce = FreeOnce, firstWeight = First, contWeight = Count, specWeight = Spec, commWeight = Comm, switch1 = SwitchTime} = Cfg,
		#db_pet_draw{wish = Wish, free_time = FreeTime, draw_time = DrawTime, day_time = DayTime,
			count_time = CountList, spec_time = SpecTime, element_time = ElementTime} = Info,
		NewDrawTime = DrawTime + 1, %% 本次抽奖次数
		NewFreeTime = case IsFree of
						  1 ->
							  ?CHECK_THROW(FreeOnce =/= 0, ?ErrorCode_PetDrawCantFree),
							  case time:time() >= FreeTime of
								  ?TRUE ->
									  time:time_add(time:time(), FreeOnce);
								  ?FALSE ->
									  case recharge_subscribe:is_pet_drawn_free() of
										  ?FALSE -> throw(?ErrorCode_PetDrawFreeTime);
										  ?TRUE ->
											  variable_player:set_value(?Variant_Index_26, ?Variant_Index_26_Bit27, 1),
											  FreeTime
									  end
							  end;
						  _ -> FreeTime
					  end,
		NowTime = time:time(),
		NowElement = get_now_element(ElementTime, SwitchTime, NowTime),
		LeaderCareer = role_data:get_leader_career(), %% 判断职业时，0代表所有职业
		%% 次数检查
		TimeLib = [{LibId, Type, Bind} || {Type, Time, Career, LibId, Bind} <- First,
			lists:member(Type, [0, NowElement]), lists:member(Career, [0, LeaderCareer]), NewDrawTime =:= Time],
		case TimeLib of
			[{LibId0, Type0, Bind0} | _] ->
				case get_lib_ret(LibId0, Type0, Bind0, Wish) of
					[] -> skip;
					TimeRet ->
						throw({?ERROR_OK, Info#db_pet_draw{day_time = DayTime + 1, draw_time = NewDrawTime,
							free_time = NewFreeTime, count_time = add_count_time(Type0, CountList),
							spec_time = add_spec_time(Spec, {NowElement, LeaderCareer}, SpecTime)}, TimeRet})
				end;
			_ -> skip
		end,
		%%奖励库累计次数
		DrawAccumulateList = player_private_list:get_value(?Private_List_pet_draw_accumulate_list),
		%% 保底：累计X抽，对应宠物类型
		F = fun({Type, Time, Career, LibId, Bind, Weight, Accumulate_Times}, {NewDrawAccumulateListRet, CountLibRet}) ->
			Key = {NowElement, LibId},
			{Ret1, Ret2} = case lists:keyfind(Key, 1, NewDrawAccumulateListRet) of
							   ?FALSE when Accumulate_Times =:= 0 ->
								   {[{Key, 1} | NewDrawAccumulateListRet], [{Weight, {LibId, Type, Bind}} | CountLibRet]};
							   ?FALSE -> {[{Key, 1} | NewDrawAccumulateListRet], CountLibRet};
							   {_, AccumulateTimes} when AccumulateTimes >= Accumulate_Times ->
								   {lists:keyreplace(Key, 1, NewDrawAccumulateListRet, {Key, AccumulateTimes + 1}), [{Weight, {LibId, Type, Bind}} | CountLibRet]};
							   {_, AccumulateTimes} ->
								   {lists:keyreplace(Key, 1, NewDrawAccumulateListRet, {Key, AccumulateTimes + 1}), CountLibRet}
						   end,
			case lists:member(Type, [0, NowElement]) andalso lists:member(Career, [0, LeaderCareer]) andalso check_count_time(Type, Time, CountList) of
				?TRUE ->
					{Ret1, Ret2};
				?FALSE ->
					{Ret1, CountLibRet}
			end
			end,
		{NewDrawAccumulateList, CountLib} = lists:foldl(F, {DrawAccumulateList, []}, Count),
		player_private_list:set_value(?Private_List_pet_draw_accumulate_list, NewDrawAccumulateList),
%%		%% 保底：累计X抽，对应宠物类型
%%		CountLib = [{Weight, {LibId, Type, Bind}} || {Type, Time, Career, LibId, Bind, Weight, Accumulate_Times} <- Count, Accumulate_Times =< NewDrawTime,
%%			lists:member(Type, [0, NowElement]), lists:member(Career, [0, LeaderCareer]), check_count_time(Type, Time, CountList)],
		case common:getRandomValueFromWeightList(CountLib, 0) of
			{LibId1, Type1, Bind1} ->
				case get_lib_ret(LibId1, Type1, Bind1, Wish) of
					[] -> skip;
					CountRet -> %% 抽奖完成，重置保底
						throw({?ERROR_OK, Info#db_pet_draw{day_time = DayTime + 1, draw_time = NewDrawTime,
							free_time = NewFreeTime, count_time = del_count_time(Type1, CountList),
							spec_time = add_spec_time(Spec, {NowElement, LeaderCareer}, SpecTime)}, CountRet})
				end;
			_ -> skip
		end,
%% 特殊普通掉落
		SpecialLib = [{Weight, {LibId, Type, Bind}} || {Type, Career, LibId, Bind, Weight, Time} <- Spec,
			lists:member(Type, [0, NowElement]), lists:member(Career, [0, LeaderCareer]), check_lib_time({Type, LibId}, Time, SpecTime)],
		case common:random_by_order_list(SpecialLib, 0) of
			{LibId2, Type2, Bind2} ->
				AddLibTime = add_spec_time(Spec, {NowElement, LeaderCareer}, SpecTime),
				NewLibTime = lists:keystore({Type2, LibId2}, 1, AddLibTime, {{Type2, LibId2}, 0}), %% 重置这个库的次数
				case get_lib_ret(LibId2, Type2, Bind2, Wish) of
					[] -> skip;
					SpecRet ->
						throw({?ERROR_OK, Info#db_pet_draw{day_time = DayTime + 1, draw_time = NewDrawTime,
							free_time = NewFreeTime, count_time = add_count_time(Type2, CountList), spec_time = NewLibTime}, SpecRet})
				end;
			_ -> skip
		end,
%% 普通掉落
		CommLib = [{Weight, {LibId, Type, Bind}} || {Type, Career, LibId, Bind, Weight} <- Comm,
			lists:member(Type, [0, NowElement]), lists:member(Career, [0, LeaderCareer])],
		case common:getRandomValueFromWeightList(CommLib, 0) of
			{LibId3, Type3, Bind3} ->
				case get_lib_ret(LibId3, Type3, Bind3, Wish) of
					[] -> skip;
					CommonRet -> %% 抽奖完成，重置保底
						throw({?ERROR_OK, Info#db_pet_draw{day_time = DayTime + 1, draw_time = NewDrawTime,
							free_time = NewFreeTime, count_time = add_count_time(Type3, CountList),
							spec_time = add_spec_time(Spec, {NowElement, LeaderCareer}, SpecTime)}, CommonRet})
				end;
			_ -> skip
		end,
		?ErrorCode_PetDrawEmpty
	catch
		{?ERROR_OK, NewInfo, Ret} -> {?ERROR_OK, NewInfo, Ret};
		Err -> throw(Err)
	end.

add_count_time(Type, CountList) ->
	case lists:keyfind(Type, 1, CountList) of
		{Type, Count} ->
			lists:keystore(Type, 1, CountList, {Type, Count + 1});
		_ -> lists:keystore(Type, 1, CountList, {Type, 1})
	end.

%% 清除保底
del_count_time(Type, CountList) ->
	lists:keystore(Type, 1, CountList, {Type, 0}).

check_count_time(Type, Num, CountList) ->
	case lists:keyfind(Type, 1, CountList) of
		{Type, Count} ->
			Count + 1 >= Num;
		_ -> ?FALSE
	end.

%% 累计特殊库次数
add_spec_time([], _, LibTime) -> LibTime;
add_spec_time([{Type, C, Lib, _B, _P, _N} | SpecWeight], {Element, Career}, LibTime) ->
	case lists:member(Type, [0, Element]) andalso lists:member(C, [0, Career]) of
		?TRUE ->
			case lists:keyfind({Type, Lib}, 1, LibTime) of
				{{Type, Lib}, Time} ->
					add_spec_time(SpecWeight, {Element, Career}, lists:keystore({Type, Lib}, 1, LibTime, {{Type, Lib}, Time + 1}));
				_ ->
					add_spec_time(SpecWeight, {Element, Career}, lists:keystore({Type, Lib}, 1, LibTime, {{Type, Lib}, 1}))
			end;
		?FALSE -> add_spec_time(SpecWeight, {Element, Career}, LibTime)
	end.

check_lib_time({Type, Lib}, Time, LibTime) ->
	case lists:keyfind({Type, Lib}, 1, LibTime) of
		{{Type, Lib}, Time0} ->
			Time0 + 1 >= Time;
		_ -> ?FALSE
	end.

%% 根据库取结果
get_lib_ret(LibId, Type, Bind, Wish) -> %% 奖励库id、宠物类型、是否绑定、心愿单
	case cfg_heroRoulette2:getRow(LibId) of
		#heroRoulette2Cfg{dropPro = DropPro, dropPro2 = AddWeightList, dropItem = DropItem, dropCoin = DropCoin, dropCondition = Condition} ->
			IndexList = [{I, Weight} || {I, Weight} <- DropPro, check_index(I, Condition)],
			WeightList = lists:foldl(
				fun({Index, RawWeight}, Acc) ->
					%% todo 心愿单增加权重
					RealWeight = add_wish_weight(Index, RawWeight, AddWeightList, DropItem, Wish),
					[{Index, RealWeight} | Acc]
				end, [], IndexList),
			RewardIndex = common:getRandomValueFromWeightList_1(WeightList, 0),
			Item = [{Bind, ItemCfg, Num} || {Index0, ItemCfg, Num} <- DropItem, Index0 =:= RewardIndex], %% 次数物品奖励
			Coin = [{TCoinType, Num} || {Index0, TCoinType, Num} <- DropCoin, Index0 =:= RewardIndex], %% 次数物品奖励
			%% 宠物类型筛选
			FilterItem = filter_pet_type(Item, Type, []),
			case FilterItem =:= [] of
				?TRUE -> [];
				?FALSE -> [{FilterItem, Coin}]
			end;
		_ -> []
	end.

%% 取符合条件的序号
check_index(Index, Condition) ->
	case lists:keyfind(Index, 1, Condition) of
		{Index, Type0, P1, P2, P3} ->
			check_condition(Index, Type0, P1, P2, P3);
		_ -> ?TRUE %% 如果没有配置则无限制
	end.

%% 检查库中系数是否符合条件
check_condition(_, 0, _, _, _) -> ?TRUE;
check_condition(_, 1, PlayerLv, _, _) -> player:getLevel() >= PlayerLv;
check_condition(_, 2, PetID, _, _) -> pet_new:is_pet_active(PetID);
check_condition(_, 3, P1, P2, P3) ->
	pet_new:is_pet_active(P1) orelse pet_new:is_pet_active(P2) orelse pet_new:is_pet_active(P3);
check_condition(_, 4, StarDay, _, _) -> main:getServerStartDays() >= StarDay;
check_condition(I, Type, P1, P2, P3) ->
	?LOG_ERROR("check cfg_heroRoulette2 dropCondition:~p", [{I, Type, P1, P2, P3}]),
	?FALSE.

%% 增加单个奖励序号的心愿单权重
add_wish_weight(_Index, Weight, _AddWeightList, _DropItem, []) -> Weight;
add_wish_weight(Index, Weight, AddWeightList, DropItem, [{_Type, CfgId} | Wish]) ->
	case lists:keyfind(CfgId, 2, DropItem) of
		{DropIndex, CfgId, _} ->
			case lists:keyfind(Index, 1, AddWeightList) of
				{AddIndex, AddWeight} when DropIndex =:= AddIndex ->
					add_wish_weight(Index, Weight + AddWeight, AddWeightList, DropItem, Wish);
				_ -> add_wish_weight(Index, Weight, AddWeightList, DropItem, Wish)
			end;
		_ -> add_wish_weight(Index, Weight, AddWeightList, DropItem, Wish)
	end.

%% 宠物类别：0不限，1风、2火、3土
filter_pet_type([], _, Ret) -> Ret;
filter_pet_type([{Bind, ItemCfg, Num} | TimeItem], 0, Ret) ->
	filter_pet_type(TimeItem, 0, [{Bind, ItemCfg, Num} | Ret]);
filter_pet_type([{Bind, ItemCfg, Num} | TimeItem], Type, Ret) ->
	case get_pet_element(get_cfg_pet(ItemCfg)) =:= Type orelse is_pet(get_cfg_pet(ItemCfg)) =:= ?FALSE of %% 若类型符合 或不是宠物 加入结果
		?TRUE -> filter_pet_type(TimeItem, Type, [{Bind, ItemCfg, Num} | Ret]);
		_ -> filter_pet_type(TimeItem, Type, Ret)
	end.

award_prepare(ItemList0) ->
	ItemList = [{CfgId, Amount, Bind} || {Bind, CfgId, Amount} <- ItemList0, is_pet(get_cfg_pet(CfgId)) =:= ?FALSE],
	PetList = [{CfgId, Amount} || {_Bind, CfgId, Amount} <- ItemList0, is_pet(get_cfg_pet(CfgId)) =:= ?TRUE],
	AllItem = [{CfgId, Amount} || {_Bind, CfgId, Amount} <- ItemList0],
	{Error, _Prepared} = bag_player:add_prepare(ItemList),
	?ERROR_CHECK_THROW(Error),
	{PetList, ItemList, AllItem}.

%% 从道具表获得魔宠表配置
get_cfg_pet(CfgId) ->
	case cfg_item:getRow(CfgId) of
		#itemCfg{useParam1 = CfgPet} -> CfgPet;
		_ -> 0
	end.

is_pet(PetCfgId) ->
	case cfg_petBase:getRow(PetCfgId) of
		#petBaseCfg{} -> ?TRUE;
		_ -> ?FALSE
	end.

get_pet_element(PetCfgId) ->
	case cfg_petBase:getRow(PetCfgId) of
		#petBaseCfg{elemType = Elem} -> Elem;
		_ -> 0
	end.

%% 输入玩家手动切换次数，一天之内切换的时间，当前时间
%% 计算当前玩家元素限定
get_now_element(CostSwitchTime, SwitchTime, Time) ->
	case SwitchTime of
		0 -> 0; %% 配置无另外类型切换
		_ ->
			Length = length(?ELEMENT_ORDER),
			OffSet = time:timezone_offset(Time),%%偏移时间
			((Time + OffSet - SwitchTime) div ?DayTick_Seconds + CostSwitchTime) rem Length + 1
	end.

is_func_open(1) ->
	variable_world:get_value(?WorldVariant_Switch_PetNormalDraw) =:= 1 andalso guide:is_open_action(?OpenAction_PetNormalDraw);
is_func_open(2) ->
	variable_world:get_value(?WorldVariant_Switch_PetSeniorDraw) =:= 1 andalso guide:is_open_action(?OpenAction_PetSeniorDraw);
is_func_open(3) ->
	variable_world:get_value(?WorldVariant_Switch_PetUnknownDraw) =:= 1 andalso guide:is_open_action(?OpenAction_PetUnknownDraw);
is_func_open(_) ->
	?FALSE.

refresh_task(Id, Num) ->
	case Id of
		?NormalDraw ->
			seven_gift:check_task(?Seven_Type_PetNormalDraw),
			player_task:refresh_task(?Task_Goal_PetNormalDrawTime),
			case Num >= 10 of
				?TRUE ->
					player_task:update_task(?Task_Goal_Pet_TenDrawNum, {1, Num});
				?FALSE -> ok
			end;
		?SeniorDraw ->
			seven_gift:check_task(?Seven_Type_PetSeniorDraw),
			player_task:refresh_task(?Task_Goal_PetSeniorDrawTime);
		?UnknownDraw ->
			player_task:update_task(?Task_Goal_PetUnknownDrawTime, {10});
		_ -> skip
	end.


%% 是否是SSR品质以上
over_ssr(CfgId) ->
	case cfg_petBase:getRow(get_cfg_pet(CfgId)) of
		#petBaseCfg{rareType = RareType} ->
			RareType >= 3;
		_ -> ?FALSE
	end.

%% 公告
send_notice(Id, PetList) ->
	PlayerText = player:getPlayerText(),
	send_notice_loop(PlayerText, Id, [{CfgId, Num} || {CfgId, Num} <- PetList, over_ssr(CfgId)]).

send_notice_loop(PlayerText, Id, [{CfgId, 1} | PetList]) ->
	send_notice(PlayerText, Id, CfgId),
	send_notice_loop(PlayerText, Id, PetList);
send_notice_loop(PlayerText, Id, [{CfgId, Num} | PetList]) ->
	send_notice(PlayerText, Id, CfgId),
	send_notice_loop(PlayerText, Id, [{CfgId, Num - 1} | PetList]);
send_notice_loop(_, _, _) -> ok.

send_notice(PlayerText, Id, CfgId) ->
	case Id of
		?NormalDraw ->
			marquee:sendChannelNotice(0, 0, d3_yxzh_Notice1,
				fun(Language) ->
					{Text1, GradeText1} = richText:getItemPetText(CfgId, Language),
					language:format(language:get_server_string("D3_yxzh_Notice1", Language), [PlayerText, GradeText1, Text1]) end);
		?SeniorDraw ->
			marquee:sendChannelNotice(0, 0, d3_yxzh_Notice2,
				fun(Language) ->
					{Text2, GradeText2} = richText:getItemPetText(CfgId, Language),
					language:format(language:get_server_string("D3_yxzh_Notice2", Language), [PlayerText, GradeText2, Text2]) end);
		?UnknownDraw ->
			marquee:sendChannelNotice(0, 0, d3_yxzh_Notice3,
				fun(Language) ->
					{Text3, GradeText3} = richText:getItemPetText(CfgId, Language),
					language:format(language:get_server_string("D3_yxzh_Notice3", Language), [PlayerText, GradeText3, Text3]) end);
		_ -> skip
	end.

calc_related_item_list() ->
	try
		Cfg1 = cfg_heroRoulette1:getRow(?NormalDraw),
		?CHECK_CFG(Cfg1),
		Cfg2 = cfg_heroRoulette1:getRow(?SeniorDraw),
		?CHECK_CFG(Cfg2),
		Cfg3 = cfg_heroRoulette1:getRow(?UnknownDraw),
		?CHECK_CFG(Cfg3),
		#heroRoulette1Cfg{consItem = NormalItem} = Cfg1,
		#heroRoulette1Cfg{consItem = SeniorItem} = Cfg2,
		#heroRoulette1Cfg{consItem = UnknownItem} = Cfg3,
		ItemList = lists:usort(lists:foldl(
			fun({_, _, _, Item, _}, Ret) ->
				[Item | Ret]
			end, [], NormalItem ++ SeniorItem ++ UnknownItem)),
		set_related_item_list(ItemList)
	catch
		_ -> ?LOG_ERROR("check cfg_heroRoulette1")
	end.

