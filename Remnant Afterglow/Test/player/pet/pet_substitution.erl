%%%-------------------------------------------------------------------
%%% @author admin
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%      宠物置换
%%% @end
%%% Created : 04. 7月 2022 20:48
%%%-------------------------------------------------------------------
-module(pet_substitution).
-author("admin").

-include("cfg_heroSubstitute1.hrl").
-include("cfg_heroSubstitute2.hrl").
-include("cfg_heroSubstitute3.hrl").
-include("cfg_petBase.hrl").
-include("record.hrl").
-include("error.hrl").
-include("variable.hrl").
-include("reason.hrl").
-include("cfg_item.hrl").
-include("cfg_petStar.hrl").
-include("netmsgRecords.hrl").
-include("currency.hrl").
-include("attainment.hrl").
-include("activity_new.hrl").
-include("player_task_define.hrl").
-include("seven_gift_define.hrl").
-include("time_limit_gift_define.hrl").
-include("cfg_heroStarConversion.hrl").

-define(LOW, 1).
-define(HIGH, 2).


%% API
-export([pet_substitution_low/2, pet_substitution_high/4, check_is_star_cons/1]).

%% 低星置换 同系别同品质同初始星数
pet_substitution_low(Uid, ?LOW) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_low_func_open(), ?ERROR_FunctionClose),
%%                                                  获得宠物实例
					 PetObject = pet_new:get_pet(Uid),
					 ?CHECK_THROW(PetObject =/= {}, ?ErrorCode_Pet_No),
					 #pet_new{star = Star, grade = Grade} = PetObject,
					 PetBase = cfg_petBase:getRow(PetObject#pet_new.pet_cfg_id),
					 ?CHECK_THROW(PetBase =/= {}, ?ERROR_Cfg),
					 HeroSubstituteCfg = cfg_heroSubstitute1:getRow(?LOW),
%%                                                  检测星级 检测品质
					 case check_star_garde(Star, Grade, HeroSubstituteCfg) of
						 ?TRUE -> skip;
						 ?FALSE -> throw(?ErrorCode_PetSubstitute_StarAndGrade)
					 end,
%%													培养情况检测
					 case PetObject#pet_new.pet_lv =:= 1 andalso PetObject#pet_new.wash_material =:= [] of
						 ?TRUE -> skip;
						 ?FALSE -> throw(?ErrorCode_PetSubstitute_Culture)
					 end,
%%													出战，助战
					 case PetObject#pet_new.fight_flag =:= 0 of
						 ?TRUE -> skip;
						 ?FALSE -> throw(?ErrorCode_PetSubstitute_Fight)
					 end,
%%													突破
					 case PetObject#pet_new.break_lv =:= 0 of
						 ?TRUE -> skip;
						 ?FALSE -> throw(?ErrorCode_PetSubstitute_BreakLv)
					 end,
%%                                                   获取这个元素系列可置换的宠物列表
					 KeyList = cfg_heroSubstitute2:getKeyList(),
					 PetObjectElemType = PetBase#petBaseCfg.elemType,
					 WeightPetList = lists:foldl(fun({ElemType, Order}, Ret) ->
						 case ElemType =:= PetObjectElemType of
							 ?TRUE ->
								 #heroSubstitute2Cfg{weight = Weight, pet = Pet, condition = Condition} = cfg_heroSubstitute2:getRow(ElemType, Order),
								 case check_condition(Condition) of
									 ?TRUE -> [{Weight, Pet} | Ret];
									 ?FALSE -> Ret
								 end;
							 ?FALSE -> Ret
						 end end, [], KeyList),
					 HeroPool = case lists:keyfind(PetObject#pet_new.pet_cfg_id, 2, WeightPetList) of
									?FALSE -> throw(?ErrorCode_PetSubstitute_PetNotSubstitute);
									H -> lists:delete(H, WeightPetList)
								end,
					 NewPetID = common:getRandomValueFromWeightList(HeroPool, 0),
					 ?CHECK_THROW(NewPetID > 0, ?ERROR_Param),
					 Cost = HeroSubstituteCfg#heroSubstitute1Cfg.consume,
					 CurrencyError = currency:delete([Cost], ?REASON_pet_Substitute),
					 ?ERROR_CHECK_THROW(CurrencyError),
					 NewPetObject = PetObject#pet_new{pet_cfg_id = NewPetID},
					 pet_new:update_pet(NewPetObject),
					 pet_pos:check_repeat(NewPetObject),
					 pet_atlas:check_get(NewPetID, NewPetObject#pet_new.star),
					 pet_base:refresh_pet_and_skill([Uid]),
					 pet_base:log_pet_substitution(PetObject, NewPetID, low),
					 pet_base:log_pet_op([NewPetObject], ?REASON_pet_Substitute, get),
					 efun_log:hero_get(NewPetID, NewPetObject#pet_new.star, 0, ?REASON_pet_Substitute),
					 %%成就系统-激活X个Y品质的英雄 336 激活X个英雄 337
					 attainment:check_attainment([?Attainments_Type_SSRHeroCount, ?Attainments_Type_SPHeroCount]),
					 guide:check_open_func([?OpenFunc_TargetType_Pet, ?OpenFunc_TargetType_GetSpPet]),
					 player:send(#pk_GS2U_PetSubstitutionRet{uid = Uid, pet_id = NewPetID})
				 catch Err ->
					 player:send(#pk_GS2U_PetSubstitutionRet{uid = Uid, err_code = Err})
				 end end).
%% 高星转换
pet_substitution_high(Uid, TargetPetID, CostUidList, ?HIGH) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_high_func_open(), ?ERROR_FunctionClose),
					 ?CHECK_THROW(not common:check_elem_is_repeat(CostUidList), ?ERROR_Param),
					 %% 获得宠物实例
					 Pet = pet_new:get_pet(Uid),
					 ?CHECK_THROW(Pet =/= {}, ?ErrorCode_Pet_No),
					 #pet_new{pet_cfg_id = CfgId, star = Star, grade = Grade} = Pet,
					 %% 排除自身，不可自己转换自己
					 ?CHECK_THROW(TargetPetID =/= Pet#pet_new.pet_cfg_id, ?ErrorCode_PetSubstitute_Self),
					 PetBaseCfg = cfg_petBase:getRow(Pet#pet_new.pet_cfg_id),
					 NewPetBaseCfg = cfg_petBase:getRow(TargetPetID),
					 ?CHECK_THROW(PetBaseCfg =/= {} andalso NewPetBaseCfg =/= {}, ?ErrorCode_PetSubstitute_PetCfg),
					 #petBaseCfg{rareType = NewRareType, elemType = NewElemType} = NewPetBaseCfg,
					 HeroSubstituteCfg = cfg_heroSubstitute1:getRow(?HIGH),
					 CostPetList = [UsePet || UID <- CostUidList, (UsePet = pet_new:get_pet(UID)) =/= {}],
					 ?CHECK_THROW(CostPetList =/= [], ?ErrorCode_PetSubstitute_NotExist),
					 %% 检测星级 检测品质
					 ?CHECK_THROW(check_star_garde(Star, Grade, HeroSubstituteCfg), ?ErrorCode_PetSubstitute_StarAndGrade),
					 %% 出战，助战
					 ?CHECK_THROW(Pet#pet_new.fight_flag =:= 0, ?ErrorCode_PetSubstitute_Fight),
					 {ItemList, CoinList, PetList, ElemPetList} = get_cost_list(Pet, TargetPetID, PetBaseCfg),%%获取高星置换的消耗数据
					 ItemReturnList = case check_cost_pet(CostUidList, PetList, ElemPetList, TargetPetID) of%检查消耗是否满足条件，并计算需要返还多少高级道具
										  {?TRUE, List} -> List;
										  _ -> throw(?ErrorCode_PetSubstitute_CostPet)%%消耗宠物不满足条件
									  end,
					 {NewItemList, NewCoinList, NewItemReturnList} = calc_return_list(ItemList, CoinList, ItemReturnList),
					 %% 消耗的宠物，存在升星，突破等操作
					 ?CHECK_THROW(check_init(CostUidList), ?ErrorCode_PetSubstitute_NotInit),
					 {CostErr, CostPrepare} = player:delete_cost_prepare(NewItemList, NewCoinList),
					 ?ERROR_CHECK_THROW(CostErr),
					 %% 判断宠物是否被培养过，如果是需要回退再转换消耗
					 dec_cost_befor(CostUidList),
					 %% 删除被消耗的宠物实例
					 pet_new:delete_pet(CostUidList),
					 player:delete_cost_finish(CostPrepare, ?REASON_pet_Substitute),
					 %%返还高级材料
					 player:add_rewards(NewItemReturnList, ?REASON_pet_SubstituteReturnItem),
					 player_item:show_get_item_dialog([{P1, P2} || {1, P1, P2} <- NewItemReturnList], [{P1, P2} || {2, P1, P2} <- NewItemReturnList], [], 0, 1),
					 %% 消耗宠物有在照看孵化的更新孵化状态
					 lists:foreach(fun(P) ->
						 case P#pet_new.hatch_id of
							 0 -> skip;
							 _ -> pet_hatch:looking_pet_cost(P#pet_new.pet_cfg_id, P#pet_new.hatch_id)
						 end end, CostPetList),
					 OldBase = pet_base:get_base_wash_attr(CfgId),
					 TargetBase = pet_base:get_base_wash_attr(TargetPetID),
					 RealWashAddList = pet_base:compare_attr(OldBase, Pet#pet_new.wash),
					 NewWash = pet_base:merge_wash_attr(TargetBase, RealWashAddList),
					 NewPetObject1 = Pet#pet_new{pet_cfg_id = TargetPetID, wash = NewWash, grade = NewRareType},
					 NewPetObject = case NewPetObject1#pet_new.shared_flag of
										1 ->
											NewPetObject1#pet_new{point = pet_battle:cal_single_pet_score(NewPetObject1)};
										_ -> NewPetObject1
									end,
					 pet_new:update_pet(NewPetObject),
					 pet_pos:check_repeat(NewPetObject),
					 pet_atlas:check_get(TargetPetID, NewPetObject#pet_new.star),
					 %% 高星置换 可能被换成其他系别 更新孵化状态
					 case NewPetObject#pet_new.hatch_id of
						 0 -> skip;
						 Hatch -> pet_hatch:looking_pet_trans(Pet#pet_new.pet_cfg_id, NewPetObject#pet_new.uid, Hatch)
					 end,
					 %% 属性 技能刷新
					 pet_base:refresh_pet_and_skill([Uid]),
					 pet_base:log_pet_substitution(Pet, TargetPetID, high),
					 pet_base:log_pet_op([NewPetObject], ?REASON_pet_Substitute, get),
					 efun_log:hero_get(TargetPetID, NewPetObject#pet_new.star, 0, ?REASON_pet_Substitute),

					 attainment:check_attainment([?Attainments_Type_SSRHeroCount, ?Attainments_Type_SPHeroCount]),
					 guide:check_open_func([?OpenFunc_TargetType_Pet, ?OpenFunc_TargetType_GetSpPet]),
					 activity_new_player:on_func_open_check(?ActivityOpenType_GetPet, {TargetPetID}),
					 time_limit_gift:check_open(?TimeLimitType_PetTypeRareNum),
					 seven_gift:check_task(?Seven_Type_PetAtlas),
					 seven_gift:check_task(?Seven_Type_PetStar),
					 player_task:refresh_task([?Task_Goal_PetReachStar]),
					 new_bounty_task:update_bounty_task_sync(),%%赏金任务是否可派遣红点 刷新
					 case NewRareType >= 3 andalso NewElemType of
						 1 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType1SSR, 1);
						 2 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType2SSR, 1);
						 3 -> activity_new_player:on_active_condition_change(?SalesActivity_PetType3SSR, 1);
						 _ -> ok
					 end,
					 player:send(#pk_GS2U_PetSubstitutionRet{uid = Uid, pet_id = TargetPetID})
				 catch Err ->
					 player:send(#pk_GS2U_PetSubstitutionRet{uid = Uid, pet_id = TargetPetID, err_code = Err})
				 end
			 end).

get_cost_list(#pet_new{pet_cfg_id = PetCfgId, star = Star, star_pos = StarPos, grade = Grade}, TargetPetID, PetBaseCfg) ->
	%% 获取该星级下可以转换的宠物列表
	KeyList = cfg_heroSubstitute3:getKeyList(),
	PetObjectElemType = PetBaseCfg#petBaseCfg.elemType,
	HeroSubstituteCfg = cfg_heroSubstitute1:getRow(?HIGH),
	F = fun({Sta, ElemType, Order}, List) ->
		Cfg = cfg_heroSubstitute3:getRow(Sta, ElemType, Order),
		case check_condition(Cfg#heroSubstitute3Cfg.condition) of %% 加入可转换条件
			?TRUE ->
				case (Star >= HeroSubstituteCfg#heroSubstitute1Cfg.star2 orelse PetObjectElemType =:= ElemType orelse
					Grade >= HeroSubstituteCfg#heroSubstitute1Cfg.quality2) andalso Star =:= Sta of
					?TRUE -> [Cfg | List];
					?FALSE -> List
				end;
			?FALSE -> List end end,
	HeroList = lists:foldl(F, [], KeyList),
	case lists:keyfind(PetCfgId, #heroSubstitute3Cfg.pet, HeroList) of%%能否被高星置换
		#heroSubstitute3Cfg{iFSubstitute = 1} -> ok;
		_ -> throw(?ErrorCode_PetSubstitute_PetNotSubstitute)
	end,
	TargetHero = case lists:keyfind(TargetPetID, #heroSubstitute3Cfg.pet, HeroList) of
					 ?FALSE -> throw(?ErrorCode_PetSubstitute_TargetPet);
					 H -> H
				 end,
	NowStarPos = [Pos || {Pos, PosStar} <- StarPos, PosStar =:= Star],
	Consume = case Grade >= 4 of
				  ?FALSE ->
					  Consume2 = [{P1, P2, P3, P4} || {P, P1, P2, P3, P4} <- TargetHero#heroSubstitute3Cfg.consume2, lists:member(P, NowStarPos)],
					  TargetHero#heroSubstitute3Cfg.consume ++ Consume2;
				  _ ->
					  Consume4 = [{P1, P2, P3, P4} || {P, P1, P2, P3, P4} <- TargetHero#heroSubstitute3Cfg.consume4, lists:member(P, NowStarPos)],
					  TargetHero#heroSubstitute3Cfg.consume3 ++ Consume4
			  end,
	F1 = fun({Index, Id, Num, Star1}, {IList, CList, PList, EPList}) ->
		case Index of
			1 -> {[{Id, Num} | IList], CList, PList, EPList}; %% 道具消耗
			2 -> {IList, [{Id, Num} | CList], PList, EPList}; %% 货币消耗
			3 -> {IList, CList, [{Id, Num, Star1} | PList], EPList}; %% 宠物消耗
			4 -> {IList, CList, PList, [{Id, Num, Star1} | EPList]};%%阵营英雄消耗
			_ -> throw(?ErrorCode_PetSubstitute_CostCfg)
		end end,
	{PL1, PL2, PetNeedList, ElemPetNeedList} = lists:foldl(F1, {[], [], [], []}, Consume),
	{PL1, PL2, pet_merge(PetNeedList, []), pet_merge(ElemPetNeedList, [])}.

%%<id,星级>,数量 统计
pet_merge([{Id, Num, Star} | Tail], Ret) ->
	case lists:keyfind({Id, Star}, 1, Ret) of
		{Key, Val} -> pet_merge(Tail, lists:keystore(Key, 1, Ret, {Key, Val + Num}));
		_ -> pet_merge(Tail, [{{Id, Star}, Num} | Ret])
	end;
pet_merge([], Ret) ->
	[{I, N, B} || {{I, B}, N} <- Ret].

%% 检测转换消耗的宠物的种类和数量、星级 @doc todo 这里如果要消耗多个不同星级的同ID魔宠 检查会有问题
check_cost_pet(CostUidList, PetNeedList, ElemPetNeedList, CfgId) ->
	{BaseCostList, ComCostList, ItemReturnList} = fix_high_star_cost(CfgId, CostUidList),
	F1 = fun({ID, Num, Star}) ->
		lists:sum([N || {I, N, S} <- BaseCostList, ID =:= I, S >= Star]) >= Num
		 end,
	Ret1 = lists:all(F1, PetNeedList),
	F2 = fun({EleType, Num, Star}) ->
		lists:sum([N || {T, N, S} <- ComCostList, (EleType =:= 0 orelse T =:= EleType), S >= Star]) >= Num
		 end,
	Ret2 = lists:all(F2, ElemPetNeedList),
	{Ret1 andalso Ret2, ItemReturnList}.

%% [Uid] -> {本体5星材料数量，元素材料5星数量}
fix_high_star_cost(CfgId, CostUidList) ->
	F = fun(Uid, {Ret1, Ret2, Ret3}) ->
		case pet_new:get_pet(Uid) of
			#pet_new{pet_cfg_id = PetCfgId, grade = Grade, star = PetStar, star_pos = StarPosList} when PetCfgId =:= CfgId ->%材料是目标
				case cfg_heroStarConversion:getRow(Grade, PetStar) of
					{} -> {[{CfgId, 1, PetStar} | Ret1], Ret2, Ret3};
					#heroStarConversionCfg{baseNum = {BaseNum, ComNum}, materialSpecial = SpecialItemList} ->
						{Num1, Num2, ItemList} = calc_star_pos(PetStar, Grade, StarPosList, ?TRUE),%%消耗是目标
						case cfg_petBase:getRow(PetCfgId) of
							{} -> {[{CfgId, BaseNum + Num1, 5} | Ret1], Ret2, Ret3};
							#petBaseCfg{elemType = ElemType} ->
								{[{CfgId, BaseNum + Num1, 5} | Ret1], [{ElemType, ComNum + Num2, 5} | Ret2], Ret3 ++ ItemList ++ SpecialItemList}
						end
				end;
			#pet_new{pet_cfg_id = PetCfgId, grade = Grade, star = PetStar, star_pos = StarPosList} ->%%消耗不是目标
				case cfg_heroStarConversion:getRow(Grade, PetStar) of
					{} -> {Ret1, [{PetCfgId, 1, PetStar} | Ret2], Ret3};
					#heroStarConversionCfg{materialNum = ComNum, materialSpecial = SpecialItemList} ->
						{_, Num2, ItemList} = calc_star_pos(PetStar, Grade, StarPosList, ?FALSE),%%消耗不是目标
						case cfg_petBase:getRow(PetCfgId) of
							{} -> {Ret1, Ret2, Ret3};
							#petBaseCfg{elemType = ElemType} ->
								{Ret1, [{ElemType, ComNum + Num2, 5} | Ret2], Ret3 ++ ItemList ++ SpecialItemList}
						end
				end;
			_ -> {Ret1, Ret2, Ret3}
		end
		end,
	lists:foldr(F, {[], [], []}, CostUidList).

%%计算消耗的12星及以上英雄，星位消耗数据 ,返回 转换出的本体，通用材料，返还高级材料
calc_star_pos(Star, Grade, StarPosList, IsBody) ->
	Key = #heroStarConversionCfg.materialSpecial,
	PosList = [{(Pos - 1) * 3 + Key + 1, (Pos - 1) * 3 + Key + 2, (Pos - 1) * 3 + Key + 3} || {Pos, S} <- StarPosList, S =:= Star],%%对应星级拥有的星位的键位置
	case PosList =/= [] andalso cfg_heroStarConversion:getRow(Grade, Star) of
		#heroStarConversionCfg{} = Cfg ->
			ValueList = [{element(Key1, Cfg), element(Key2, Cfg), element(Key3, Cfg)} || {Key1, Key2, Key3} <- PosList],
			lists:foldl(fun({{Num1, Num2}, Num3, Item}, {BaseNumAcc2, MaterialNumAcc2, ItemListAcc2}) ->
				case IsBody of
					?TRUE -> {BaseNumAcc2 + Num1, MaterialNumAcc2 + Num2, ItemListAcc2 ++ Item};
					_ ->%%不是本体
						{BaseNumAcc2, MaterialNumAcc2 + Num3, ItemListAcc2 ++ Item}
				end end, {0, 0, []}, ValueList);
		_ -> {0, 0, []}
	end.

%%最终计算消耗的道具 货币 和返还的道具数据   这里处理的是，返还的道具中是否包含消耗的道具或货币 需要去掉这部分，相当于减少消耗的道具或货币
calc_return_list(ItemList, CoinList, ItemReturnList) ->
	case ItemReturnList of
		[] -> {ItemList, CoinList, ItemReturnList};
		_ ->
			lists:foldl(
				fun({Type, ItemId, Num}, {Acc1, Acc2, Acc3}) ->
					NsAcc1 = ?IF(Type =:= 1, Acc1, Acc2),
					case lists:keytake(ItemId, 1, NsAcc1) of
						?FALSE -> {Acc1, Acc2, [{Type, ItemId, Num} | Acc3]};
						{_, {_, CostNum}, T} ->
							case CostNum > Num of
								?TRUE ->
									case Type =:= 1 of
										?TRUE ->
											{[{ItemId, CostNum - Num} | T], Acc2, Acc3};
										_ ->
											{Acc1, [{ItemId, CostNum - Num} | T], Acc3}
									end;
								?FALSE when CostNum =:= Num ->
									case Type =:= 1 of
										?TRUE ->
											{T, Acc2, Acc3};
										_ ->
											{Acc1, T, Acc3}
									end;
								_ ->
									case Type =:= 1 of
										?TRUE ->
											{T, Acc2, [{Type, ItemId, Num - CostNum} | Acc3]};
										_ ->
											{Acc1, T, [{Type, ItemId, Num - CostNum} | Acc3]}
									end
							end
					end
				end, {common:listValueMerge(ItemList), common:listValueMerge(CoinList), []}, ItemReturnList)
	end.


%% 删除消耗宠物之前，检测培养情况，已经培养过的宠物需要先回退
dec_cost_befor(CostUidList) ->
	F = fun(Uid) ->
		PetObject = pet_new:get_pet(Uid),
%%        被用来消耗的宠物 只允许 有升级和洗髓的操作
		case PetObject#pet_new.pet_lv =:= 1 andalso PetObject#pet_new.wash_material =:= [] of
			?TRUE -> skip;
			?FALSE ->
				pet_base:return_material([Uid], 0)
		end end,
	lists:foreach(F, CostUidList).

is_low_func_open() ->%%初星置换
	variable_world:get_value(?WorldVariant_Switch_PetSubstitutionLow) =:= 1 andalso guide:is_open_action(?OpenAction_PetSubstitutionLow).
is_high_func_open() ->%%高星置换
	variable_world:get_value(?WorldVariant_Switch_PetSubstitutionHigh) =:= 1 andalso guide:is_open_action(?OpenAction_PetSubstitutionHigh).
%% 检测星级和品质
check_star_garde(Star, Grade, HeroSubstituteCfg) ->
	lists:member(Star, HeroSubstituteCfg#heroSubstitute1Cfg.star1) andalso lists:member(Grade, HeroSubstituteCfg#heroSubstitute1Cfg.quality).


%% 检测消耗的宠物 是否为原生宠物，只允许宠物有培养操作（等级、洗髓）
check_init(UidList) ->
%%	HeroSubstitute = cfg_heroSubstitute1:getRow(Type),
	F = fun(Uid) ->
		Pet = pet_new:get_pet(Uid),
		PetCfg = cfg_petBase:getRow(Pet#pet_new.pet_cfg_id),
%%		lists:member(Pet#pet_new.grade, HeroSubstitute#heroSubstitute1Cfg.quality)
%%			andalso lists:member(Pet#pet_new.star, HeroSubstitute#heroSubstitute1Cfg.star1)

		Pet#pet_new.fight_flag =:= 0 %% 出战变动
			andalso Pet#pet_new.break_lv =:= 0 %% 突破变动
			andalso Pet#pet_new.been_link_uid =:= 0 %% 链接情况
			andalso Pet#pet_new.been_appendage_uid =:= 0 %% 附灵情况
			andalso Pet#pet_new.link_uid =:= 0
			andalso Pet#pet_new.appendage_uid =:= 0
			andalso Pet#pet_new.get_by_egg =:= 0
			andalso check_is_star_cons(PetCfg)
		end,
	lists:all(F, UidList).

%% 判断是否可用与消耗
check_is_star_cons(PetCfg) ->
	case PetCfg#petBaseCfg.isStarCons of
		1 -> ?TRUE;
		0 ->
			case PetCfg#petBaseCfg.isStarConsCancel of
				[] -> ?FALSE;
				L -> lists:any(
					fun({1, P1, P2, P3}) ->
						pet_new:is_pet_active(P1) orelse pet_new:is_pet_active(P2) orelse pet_new:is_pet_active(P3);
						(_) -> ?FALSE
					end, L)
			end
	end.

check_condition([{1, P1, P2, P3} | _]) ->
	pet_new:is_pet_active(P1) orelse pet_new:is_pet_active(P2) orelse pet_new:is_pet_active(P3);
check_condition(_) -> ?TRUE.