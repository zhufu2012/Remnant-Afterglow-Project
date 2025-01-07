%%%-------------------------------------------------------------------
%%% @author zhubaicheng
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%		英雄国度
%%% @end
%%% Created : 01. 11月 2022 17:59
%%%-------------------------------------------------------------------
-module(pet_city).
-author("zhubaicheng").
-include("attribute.hrl").
-include("currency.hrl").
-include("reason.hrl").
-include("record.hrl").
-include("netmsgRecords.hrl").
-include("variable.hrl").
-include("logger.hrl").
-include("item.hrl").
-include("error.hrl").
-include("cfg_heroCountry.hrl").
-include("cfg_research.hrl").
-include("cfg_callPet.hrl").
-include("cfg_makeEquip.hrl").
-include("cfg_petMakeEquip.hrl").
-include("cfg_petProduce.hrl").
-include("cfg_prayItem.hrl").
-include("cfg_homeTask.hrl").
-include("common_bp.hrl").
-include("daily_task_goal.hrl").
-include("cfg_prayFast.hrl").

-define(BuildMain, 1). %% 大厅
-define(BuildResearch, 2). %% 研究所
-define(BuildCall, 3). %% 次元召唤阵
-define(BuildEquip, 4). %% 装备工坊
-define(BuildAltar1, 5). %% 星光祭坛1
-define(BuildAltar2, 6). %% 星光祭坛2
-define(BuildAltar3, 7). %% 星光祭坛3
-define(BuildShop, 8). %% 英雄商店
-define(BuildPray, 9). %% 祈愿所
-define(BuildStatue1, 10). %% 神像-攻击
-define(BuildStatue2, 11). %% 神像-防御
-define(BuildStatue3, 12). %% 神像-破甲
-define(BuildStatue4, 13). %% 神像-生命
-define(BuildAlterList, [?BuildAltar1, ?BuildAltar2, ?BuildAltar3]). %% 星光祭坛
-define(BuildStatueList, [?BuildStatue1, ?BuildStatue2, ?BuildStatue3, ?BuildStatue4]). %% 神像

%% 建筑等级增益
-define(FunBuildLv, 1). %% 建筑等级
-define(FunResearch, 2). %% 解锁研究序号
-define(FunCall, 3). %% 高级英雄出货概率/装备打造出货概率
-define(FunAlterSpeed, 4). %% 家园币生产速率
-define(FunAlterStorage, 5). %% 家园币储存
-define(FunStrength, 6). %% 属性提升
-define(FunPray, 7). %% 祈愿台数量
-define(FunShop, 8). %5 商店id

%% 研究增益
-define(Research_PrayTime, 1). %% 祈愿时间缩短
-define(Research_StarAlter, 2). %% 星光祭坛生产速率
-define(Research_ResearchTime, 3). %% 研究时间缩短
-define(Research_CallTime, 4). %% 召唤时间锁单
-define(Research_EquipMakeTime, 5). %% 装备打造时间缩短
-define(Research_BuildTime, 6). %% 建造时间缩短

%% 任务类型
-define(PetCityTaskType_Build, 1). %% 建筑等级
-define(PetCityTaskType_AltarCoin, 2). %% 获取家园币
-define(PetCityTaskType_EquipMake, 3). %% 装备打造
-define(PetCityTaskType_Call, 4). %% 次元召唤
-define(PetCityTaskType_ShopBuy, 5). %% 商店购买
-define(PetCityTaskType_Research, 6). %% 研究
-define(PetCityTaskType_Pray, 7). %% 祈愿

-record(pet_city, {
	player_id = 0,
	id = 0,         %% 建筑id
	lv = 0,         %% 建筑等级
	lv_time = 0,    %% 升级完成时间（0表示没有在升级）
	param = 0,      %% 装备工坊-协助英雄；次元召唤消耗道具；研究圣所选择英雄
	param2 = 0,     %% 装备工坊-选择图纸（打造完成后这里为获得的道具，打造时间为0）；研究圣所-升级序号
	make_time = 0,  %% 星光祭坛-开始储存时间；次元召唤阵召唤/装备工坊打造结束时间；研究圣所研究结束时间
	lv_list = [],   %% 研究圣所/力量神像等级列表<序号，等级>
	pray_list = [], %% 祈愿所<位置-道具id-结束时间-开始时间>
	ssr_time = [],  %% 次元召唤保底<消耗道具-未出ssr次数>
	coin = 0,       %% 星光祭坛-已存储英雄币,保留两位小数
	lv_time_start = 0,    %%升级开始时间
	time_func_start = 0   %%功能开始时间
}).

-record(pet_city_task, {
	player_id = 0,
	id = 0,          %% 任务id
	progress = 0,    %% 进度
	is_reward = 0    %% 是否已领取奖励 1是/0放屁
}).

%% API
-export([on_load/0, on_player_online/0, on_tick/1, on_sync_info/0, on_sync_info/1, on_sync_task/0, on_lv_change/0, get_prop/0]).
-export([list_2_city/1, city_2_list/1]).
-export([on_build_lv_up/1, on_build_quick_lv_up/1, on_research/2, on_get_research_reward/0, on_call/1, on_get_call_reward/0, on_alter_reward/1,
	on_equip_make/2, on_equip_make_reward/0, on_pray/2, on_pray/1, on_pray_reward/1, on_onekey_pray_quick/1, on_pray_quick/3, add_task_progress/2, on_task_complete/1, get_skill_list/1]).
-export([gm_pray_finish/0, gm_add_alter_hour/1, gm_research_finish/0, gm_call_finish/0, gm_eq_finish/0, gm_build_lv_up/2, gm_research_lv/2]).
-export([check_shop_buy/2, get_build_lv/1, get_pet_skill/0, get_pet_attr_and_qual/1]).
-export([fix_data_07020/0]).

on_load() ->
	?metrics(begin
				 PlayerId = player:getPlayerID(),
				 Info = table_player:lookup(db_pet_city, PlayerId),
				 set_all_build(Info),
				 Task = table_player:lookup(db_pet_city_task, PlayerId),
				 set_task(Task),
				 calc_prop(?TRUE)
			 end).

on_player_online() ->
	case is_func_open() of
		?TRUE ->
			on_sync_info(),
			check_task();
		?FALSE -> skip
	end.

%% 打开界面时调用刷新/每分钟更新，检查所有建筑状态
on_tick(TimesTamp) ->
	?metrics(begin
				 RechargeAlterAcc = get_research_add(?Research_StarAlter),
				 FightAlterAdd = get_fight_pet_star_add(),
				 OldBuild = get_all_build(),
				 NewBuild = lists:foldl(
					 fun(#pet_city{id = Id} = Build, Ret) ->
						 %% 星光圣坛家园币生产
						 Build1 = case lists:member(Id, ?BuildAlterList) of
									  ?TRUE ->
										  #pet_city{coin = Coin, make_time = LastTime} = Build,
										  DuringTime = (TimesTamp - LastTime) div 60, %% 经过的时间
										  CoinSpeed = case get_fun_acc(Id, ?FunAlterSpeed) of
														  [{?CURRENCY_PetCity, Speed} | _] -> Speed;
														  _ -> 0 end,
										  CoinStorage = case get_fun_acc(Id, ?FunAlterStorage) of
															[{Storage, _} | _] -> Storage;
															_ -> 0 end,
										  AddCoin = calc_minute_add_coin(CoinSpeed, FightAlterAdd, RechargeAlterAcc, DuringTime),
										  NewCoin = common:format_number(min(CoinStorage, Coin + AddCoin), 2),
										  case NewCoin < Coin of
											  ?TRUE ->
												  ?LOG_ERROR("error_city_coin:~p", [{Coin, CoinSpeed, RechargeAlterAcc, FightAlterAdd, DuringTime, time:time(), LastTime}]),
												  Build#pet_city{coin = Coin, make_time = TimesTamp};
											  ?FALSE ->
												  Build#pet_city{coin = NewCoin, make_time = LastTime + DuringTime * 60}
										  end; %% 时间往后偏移整分钟
									  _ -> Build
								  end,
%%						 %% 研究所升级
%%						 Build2 = case Id =:= ?BuildResearch of
%%									  ?TRUE ->
%%										  #pet_city{lv_list = LvList, param2 = ResearchId, make_time = EndTime} = Build1,
%%										  IsSearch = lists:keymember(ResearchId, 1, cfg_research:getKeyList()),
%%										  case TimesTamp >= EndTime andalso IsSearch of
%%											  ?TRUE ->
%%												  NewLv = case lists:keyfind(ResearchId, 1, LvList) of
%%															  {_, ResearchLv} -> ResearchLv + 1;
%%															  _ -> 1
%%														  end,
%%												  case cfg_research:getRow(ResearchId, NewLv) of
%%													  #researchCfg{} ->
%%														  add_task_progress(?PetCityTaskType_Research, {1}),
%%														  Build1#pet_city{param = 0, param2 = 0, make_time = 0,
%%															  lv_list = lists:keystore(ResearchId, 1, LvList, {ResearchId, NewLv})};
%%													  _ ->
%%														  ?LOG_ERROR("no cfg_research NewLv:~p", [{ResearchId, NewLv}]),
%%														  Build1
%%												  end;
%%											  _ -> Build1
%%										  end;
%%									  ?FALSE -> Build1
%%								  end,
						 Build3 = case Id of
									  ?BuildResearch -> Build1;
									  _ -> tick_build(Id, Build1, TimesTamp)
								  end,
						 %% 所有建筑升级检查
						 Build4 = case TimesTamp >= Build3#pet_city.lv_time andalso Build3#pet_city.lv_time =/= 0 of%%升级
									  ?TRUE ->
										  init_build(Build3#pet_city{lv = Build3#pet_city.lv + 1, lv_time = 0, lv_time_start = 0});
									  ?FALSE -> Build3
								  end,
						 [Build4 | Ret]
					 end, [], OldBuild),
				 {UpdateBuild, IsLvUp} = compare_build(NewBuild, OldBuild),
				 update_build(UpdateBuild),
				 ?IF(IsLvUp, calc_prop(), skip),
				 UpdateId = [Id || #pet_city{id = Id} <- UpdateBuild],
				 refresh_build_lv_up(UpdateId, ?TRUE, IsLvUp),
				 refresh_task(?PetCityTaskType_Build)
			 end).

%% 计算建筑时间变化
%% 装备工坊打造
tick_build(?BuildEquip, Build, TimesTamp) ->
	#pet_city{param = PetUid, param2 = MakeItemId, make_time = MakeTime} = Build,
	case MakeTime =:= 0 orelse TimesTamp < MakeTime of
		?TRUE -> Build;
		?FALSE ->
			case cfg_makeEquip:getRow(MakeItemId) of
				#makeEquipCfg{} = Cfg ->
					ResultItem = get_make_equip_reward(Cfg, PetUid),
					Build#pet_city{param = 0, param2 = ResultItem, make_time = 0, time_func_start = 0};
				_ -> Build
			end
	end;
tick_build(_, Build, _) -> Build.

%% 同步信息
on_sync_info() ->
	on_tick(time:time()),
	Info = get_all_build(),
	MsgList = make_build_msg(Info),
	player:send(#pk_GS2U_pet_city_info{build_list = MsgList}).

%% 单个建筑同步
on_sync_info(Id) ->
	on_tick(time:time()),
	Build = get_build(Id),
	MsgList = make_build_msg([Build]),
	player:send(#pk_GS2U_pet_city_update{build_list = MsgList}).

on_sync_task() ->
	AllTask = get_task(),
	MsgList = make_task_msg(AllTask),
	player:send(#pk_GS2U_pet_city_task{task_list = MsgList}).

%% 玩家等级改变检查新任务
on_lv_change() ->
	check_task().

list_2_city(List) ->
	R = list_to_tuple([pet_city | List]),
	R#pet_city{
		lv_list = gamedbProc:dbstring_to_term(R#pet_city.lv_list),
		pray_list = gamedbProc:dbstring_to_term(R#pet_city.pray_list),
		ssr_time = gamedbProc:dbstring_to_term(R#pet_city.ssr_time)
	}.

city_2_list(R) ->
	tl(tuple_to_list(R#pet_city{
		lv_list = gamedbProc:term_to_dbstring(R#pet_city.lv_list),
		pray_list = gamedbProc:term_to_dbstring(R#pet_city.pray_list),
		ssr_time = gamedbProc:term_to_dbstring(R#pet_city.ssr_time)
	})).

%% 建筑升级
on_build_lv_up(Id) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city{lv = Lv} = Build = get_build(Id),
		Cfg = cfg_heroCountry:getRow(Id, Lv),
		?CHECK_CFG(Cfg),
		#heroCountryCfg{levelMax = LvMax, needCondition = Condition, needConsume = Consume, needTime = NeedTime} = Cfg,
		?CHECK_THROW(Lv < LvMax, ?ErrorCode_PetCity_BuildLvMax),
		?CHECK_THROW(check_lv_condition(Condition), ?ErrorCode_PetCity_BuildLvCondition),
		CostErr = currency:delete(Consume, ?REASON_pet_city_build_lv), %% 检查并消耗
		?ERROR_CHECK_THROW(CostErr),
		case NeedTime of
			0 ->
				NewBuild = init_build(Build#pet_city{lv = Lv + 1}),
				update_build(NewBuild),
				refresh_build_lv_up([Id]),
				refresh_task(?PetCityTaskType_Build);
			_ ->
				RealNeedTime = trunc(NeedTime * (10000 - get_research_add(?Research_BuildTime)) / 10000),%%建筑升级缩短增益
				NowTime = time:time(),
				NewTime = time:time_add(NowTime, RealNeedTime),
				update_build(Build#pet_city{lv_time = NewTime, lv_time_start = NowTime})
		end,
		player:send(#pk_GS2U_pet_city_build_level_up{id = Id, error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_build_level_up{id = Id, error_code = Err})
	end.

%% 建筑加速建造
on_build_quick_lv_up(Id) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city{lv = Lv, lv_time = LvTime} = Build = get_build(Id),
		Cfg = cfg_heroCountry:getRow(Id, Lv),
		?CHECK_CFG(Cfg),
		?CHECK_THROW(LvTime =/= 0, ?ErrorCode_PetCity_BuildLvNoNeedUp),
		DecTime = time:time_sub(LvTime, time:time()),
		Cost = df:getGlobalSetupValueList(fastCompleteHome, [{300, 0, 0}, {301, 0, 50}]),
		[{LeastTime, _, _} | _] = Cost, %% 最少的时间
		RealTime = ?IF(DecTime < LeastTime, LeastTime, DecTime),
		{_, CoinType, Num} = common:getValueByInterval4(RealTime, Cost, error_cfg),
		CostErr = currency:delete([{CoinType, Num}], ?REASON_pet_city_build_lv_quick),
		?ERROR_CHECK_THROW(CostErr),
		NewBuild = init_build(Build#pet_city{lv = Lv + 1, lv_time = 0, lv_time_start = 0}),
		update_build(NewBuild),
		refresh_build_lv_up([Id]),
		refresh_task(?PetCityTaskType_Build),
		player:send(#pk_GS2U_pet_city_quick_build{id = Id, error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_quick_build{id = Id, error_code = Err})
	end.

%% 研究圣所研究升级
on_research(Id, PetUid) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city{lv_list = LvList, param2 = ResearchId} = Build = get_build(?BuildResearch),
		?CHECK_THROW(ResearchId =:= 0, ?ErrorCode_PetCity_ResearchExist),
		Pet = pet_new:get_pet(PetUid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
		#pet_new{star = PetStar} = pet_soul:link_pet(player:getPlayerID(), Pet),
		#pet_new{pet_cfg_id = PetCfgId} = Pet,
		IsPetWork = check_pet_work(PetCfgId),
		?CHECK_THROW(IsPetWork =:= ?FALSE, ?ErrorCode_PetCity_PetWorkingOtherBuild),
		NowLv = case lists:keyfind(Id, 1, LvList) of
					{_, Lv} -> Lv;
					_ -> 0
				end,
		Cfg = cfg_research:getRow(Id, NowLv),
		?CHECK_CFG(Cfg),
		#researchCfg{needConsume = Consume, needCondition = Condition, needTime = NeedTime, maxLevel = MaxLv} = Cfg,
		?CHECK_THROW(NowLv < MaxLv, ?ErrorCode_PetCity_ResearchMaxLv),
		ConCheck = check_research(Condition, PetStar),
		?CHECK_THROW(ConCheck, ?ErrorCode_PetCity_ResearchCondition),
		CostErr = currency:delete([Consume], ?REASON_pet_city_research),
		?ERROR_CHECK_THROW(CostErr),
		RealNeedTime = trunc(NeedTime * (10000 - get_research_add(?Research_ResearchTime)) / 10000),%%研究时长缩短增益
		NowTime = time:time(),
		update_build(Build#pet_city{param = PetUid, param2 = Id, make_time = time:time_add(NowTime, RealNeedTime), time_func_start = NowTime}),
		player:send(#pk_GS2U_pet_city_research{pet_id = PetUid, id = Id, error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_research{pet_id = PetUid, id = Id, error_code = Err})
	end.

%%领取 研究圣所的研究
on_get_research_reward() ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city{param2 = ResearchId} = get_build(?BuildResearch),
		?CHECK_THROW(ResearchId =/= 0, ?ErrorCode_PetCity_NoResearchExist),
		{ResearchErr, NewBuild} = research_finish(?TRUE),
		?ERROR_CHECK_THROW(ResearchErr),
		update_build(NewBuild),
		refresh_build_lv_up([?BuildResearch]),
		add_task_progress(?PetCityTaskType_Research, {1}),
		player:send(#pk_GS2U_pet_city_research_reward{})
	catch
		Err ->
			player:send(#pk_GS2U_pet_city_research_reward{error_code = Err})
	end.

%% 开始次元召唤
on_call(Id) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		Cfg = cfg_callPet:getRow(Id),
		?CHECK_CFG(Cfg),
		#pet_city{param = OldItem, make_time = OldTime} = Build = get_build(?BuildCall),
		?CHECK_THROW(OldItem =:= 0 andalso OldTime =:= 0, ?ErrorCode_PetCity_OldCall),
		#callPetCfg{needConsume = CoinCost, needTime = NeedTime} = Cfg,
		CostErr = player:delete_cost([{Id, 1}], [CoinCost], ?REASON_pet_city_call),
		?ERROR_CHECK_THROW(CostErr),
		RealNeedTime = trunc(NeedTime * (10000 - get_research_add(?Research_CallTime)) / 10000),%%次元召唤研究加速增益
		NowTime = time:time(),
		update_build(Build#pet_city{param = Id, make_time = time:time_add(NowTime, RealNeedTime), time_func_start = NowTime}),
		player:send(#pk_GS2U_pet_city_call{id = Id, error_code = ?ERROR_OK}),
		common_bp:on_condition_reach(?CommonBpCond_PetCityCall, 1)
	catch
		Err -> player:send(#pk_GS2U_pet_city_call{id = Id, error_code = Err})
	end.

%% 领取次元召唤奖励
on_get_call_reward() ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		CallErr = call_finish(?TRUE),
		?ERROR_CHECK_THROW(CallErr),
		player:send(#pk_GS2U_pet_city_call_reward{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_call_reward{error_code = Err})
	end.

%% 领取星光祭坛奖励
on_alter_reward(Id) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(lists:member(Id, ?BuildAlterList), ?ERROR_Param),
		#pet_city{coin = Coin, make_time = LastTime} = Build = get_build(Id),
		RechargeAlterAcc = get_research_add(?Research_StarAlter),
		FightAlterAdd = get_fight_pet_star_add(),
		Time = time:time(),
		DuringTime = time:time_sub(Time, LastTime) div 60, %% 经过的时间
		CoinSpeed = case get_fun_acc(Id, ?FunAlterSpeed) of
						[{?CURRENCY_PetCity, Speed} | _] -> Speed;
						_ -> 0 end,
		CoinStorage = case get_fun_acc(Id, ?FunAlterStorage) of
						  [{Storage, _} | _] -> Storage;
						  _ -> 0 end,
		AddCoin = calc_minute_add_coin(CoinSpeed, FightAlterAdd, RechargeAlterAcc, DuringTime),
		NewCoin = trunc(min(CoinStorage, Coin + AddCoin)),
		?CHECK_THROW(NewCoin > 0, ?ErrorCode_PetCity_CoinEmpty),
		currency:add(?CURRENCY_PetCity, NewCoin, ?REASON_pet_city_alter_coin),
		player_item:show_get_item_dialog([], [{?CURRENCY_PetCity, NewCoin}], [], 0, 1),
		update_build(Build#pet_city{coin = 0, make_time = Time}), %% 取当前时间
		add_task_progress(?PetCityTaskType_AltarCoin, {NewCoin}),
		player:send(#pk_GS2U_pet_city_alter_reward{id = Id, error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_alter_reward{id = Id, error_code = Err})
	end.

%% 进行装备打造
on_equip_make(PetUid, Id) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city{make_time = MakeTime} = Build = get_build(?BuildEquip),
		?CHECK_THROW(MakeTime =:= 0, ?ErrorCode_PetCity_PetEquipMaking),
		Pet = pet_new:get_pet(PetUid),
		?CHECK_THROW(Pet =/= {}, ?ErrorCode_PetNotExist),
		#pet_new{star = PetStar, pet_cfg_id = PetCfgId} = Pet,
		IsPetWork = check_pet_work(PetCfgId),
		?CHECK_THROW(IsPetWork =:= ?FALSE, ?ErrorCode_PetCity_PetWorkingOtherBuild),
		LowestStar = get_lowest_pet_star(),
		?CHECK_THROW(PetStar >= LowestStar, ?ErrorCode_PetCity_PetStarLow),
		Cfg = cfg_makeEquip:getRow(Id),
		?CHECK_CFG(Cfg),
		#makeEquipCfg{needConsume = Item, needCoin = Coin, needTime = NeedTime} = Cfg,
		CostItem = case Item of
					   {0, 0} -> [{Id, 1}];
					   _ -> [Item] ++ [{Id, 1}]
				   end,
		{ItemError, ItemPrepared} = bag_player:delete_prepare(CostItem),
		?ERROR_CHECK_THROW(ItemError),
		{CoinError, CoinCostRet} = currency:delete_prepare([Coin]),
		?ERROR_CHECK_THROW(CoinError),
		bag_player:delete_finish(ItemPrepared, ?REASON_pet_city_make_equip),
		currency:delete_finish(CoinCostRet, ?REASON_pet_city_make_equip),
		DecTime = get_research_add(?Research_EquipMakeTime),
		RealNeedTime = trunc(NeedTime * (10000 - DecTime) / 10000),
		NowTime = time:time(),
		update_build(Build#pet_city{param = PetUid, param2 = Id, make_time = time:time_add(NowTime, RealNeedTime), time_func_start = NowTime}),
		player:send(#pk_GS2U_pet_city_equip_make{hero_id = PetUid, id = Id, error_code = ?ERROR_OK}),
		common_bp:on_condition_reach(?CommonBpCond_PetCityEquip, 1)
	catch
		Err -> player:send(#pk_GS2U_pet_city_equip_make{hero_id = PetUid, id = Id, error_code = Err})
	end.

%% 领取装备打造奖励
on_equip_make_reward() ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		MakeErr = eq_make_finish(?TRUE),
		?ERROR_CHECK_THROW(MakeErr),
		player:send(#pk_GS2U_pet_city_equip_make_reward{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_equip_make_reward{error_code = Err})
	end.

%% 祈愿
on_pray(Pos, Item) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		MaxPos = case get_fun_acc(?BuildPray, ?FunPray) of
					 [{Max, _} | _] -> Max;
					 _ -> 0 end,
		?CHECK_THROW(Pos =< MaxPos andalso Pos > 0, ?ErrorCode_PetCity_PrayPos),
		#pet_city{pray_list = PrayList} = Build = get_build(?BuildPray),
		Pray = lists:keyfind(Pos, 1, PrayList),
		?CHECK_THROW(Pray =:= ?FALSE, ?ErrorCode_PetCity_RepeatPray),
		Cfg = cfg_prayItem:getRow(Item),
		?CHECK_CFG(Cfg),
		#prayItemCfg{needTime = NeedTime} = Cfg,
		{CostErr, RetPrepared} = bag_player:delete_prepare([{Item, 1}]),
		?ERROR_CHECK_THROW(CostErr),
		bag_player:delete_finish(RetPrepared, ?REASON_pet_city_pray),
		RealNeedTime = trunc(NeedTime * (10000 - get_research_add(?Research_PrayTime)) / 10000),
		NowTime = time:time(),
		NewPrayList = lists:keystore(Pos, 1, PrayList, {Pos, Item, time:time_add(NowTime, RealNeedTime), NowTime}),
		update_build(Build#pet_city{pray_list = NewPrayList}),
		player:send(#pk_GS2U_pet_city_pray{pos = Pos, item = Item, error_code = ?ERROR_OK}),
		common_bp:on_condition_reach(?CommonBpCond_PetCityPray, 1),
		daily_task:add_daily_task_goal(?DailyTask_Goal_81, 1, ?DailyTask_CountType_Default),
		ok
	catch
		Err -> player:send(#pk_GS2U_pet_city_pray{pos = Pos, item = Item, error_code = Err})
	end.

%%一键祈愿
%%[{pos,item}]
on_pray(ItemList2) ->
	ItemList = lists:ukeysort(1, ItemList2),
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(length(ItemList2) =:= length(ItemList), ?ERROR_Param),
		MaxPos = case get_fun_acc(?BuildPray, ?FunPray) of
					 [{Max, _} | _] -> Max;
					 _ -> 0 end,
		#pet_city{pray_list = PrayList} = Build = get_build(?BuildPray),
		?CHECK_THROW(lists:all(fun({Pos, _}) ->
			Pos =< MaxPos andalso Pos > 0 end, ItemList), ?ErrorCode_PetCity_NoPray),
		NowTime = time:time(),
		Fun = fun({Pos, Item}, {PrayListAcc, DeleteAcc}) ->
			case lists:keyfind(Pos, 1, PrayListAcc) of
				{_, P, _, _} when P =/= 0 ->%%还有正在祈愿的道具
					throw(?ErrorCode_PetCity_RepeatPray);
				_ ->
					Cfg = cfg_prayItem:getRow(Item),
					?CHECK_CFG(Cfg),
					#prayItemCfg{needTime = NeedTime} = Cfg,
					RealNeedTime = trunc(NeedTime * (10000 - get_research_add(?Research_PrayTime)) / 10000),
					{lists:keystore(Pos, 1, PrayListAcc, {Pos, Item, time:time_add(NowTime, RealNeedTime), NowTime}), [{Item, 1} | DeleteAcc]}
			end end,
		{NewPrayList, DeleteList} = lists:foldl(Fun, {PrayList, []}, ItemList),
		{CostErr, RetPrepared} = bag_player:delete_prepare(DeleteList),
		?ERROR_CHECK_THROW(CostErr),
		bag_player:delete_finish(RetPrepared, ?REASON_pet_city_pray),
		update_build(Build#pet_city{pray_list = NewPrayList}),
		player:send(#pk_GS2U_pet_city_pray2{itemlist = [#pk_key_value{key = K, value = V} || {K, V} <- ItemList]}),
		common_bp:on_condition_reach(?CommonBpCond_PetCityPray, length(ItemList)),
		daily_task:add_daily_task_goal(?DailyTask_Goal_81, length(ItemList), ?DailyTask_CountType_Default)
	catch
		Err ->
			player:send(#pk_GS2U_pet_city_pray2{error_code = Err, itemlist = [#pk_key_value{key = K, value = V} || {K, V} <- ItemList]})
	end.

%% 祈愿领奖
on_pray_reward(Pos) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		NowTime = time:time(),
		#pet_city{pray_list = PrayList} = Build = get_build(?BuildPray),
		case Pos of
			0 -> %% 一键领取所有位置
				{Reward, UpdatePos0} = lists:foldl(fun({Pos1, Item, TimeEnd, TimeStart}, {RewardL, LastPosL}) -> %% 奖励物品，留下的列表
					case NowTime >= TimeEnd of
						?TRUE ->
							Cfg = cfg_prayItem:getRow(Item),
							?CHECK_CFG(Cfg),
							#prayItemCfg{gift = Reward} = Cfg,
							{Reward ++ RewardL, LastPosL};
						?FALSE -> {RewardL, [{Pos1, Item, TimeEnd, TimeStart} | LastPosL]}
					end end, {[], []}, PrayList),
				?CHECK_THROW(Reward =/= [], ?ErrorCode_PetCity_PrayNoReward),
				UpdatePos = lists:keysort(1, UpdatePos0),
				RewardNum = length(PrayList) - length(UpdatePos), %% 本次奖励次数
				player:add_rewards(Reward, ?REASON_pet_city_pray),
				show_reward_dialog(Reward),
				update_build(Build#pet_city{pray_list = UpdatePos}),
				add_task_progress(?PetCityTaskType_Pray, {RewardNum});
			_ -> %% 单独领取位置
				PrayItem = case lists:keyfind(Pos, 1, PrayList) of
							   {_, Item, Time, _} ->
								   ?CHECK_THROW(NowTime >= Time, ?ErrorCode_PetCity_PrayTime),
								   Item;
							   _ -> throw(?ErrorCode_PetCity_NoPray)
						   end,
				Cfg = cfg_prayItem:getRow(PrayItem),
				?CHECK_CFG(Cfg),
				#prayItemCfg{gift = Reward} = Cfg,
				player:add_rewards(Reward, ?REASON_pet_city_pray),
				show_reward_dialog(Reward),
				update_build(Build#pet_city{pray_list = lists:keydelete(Pos, 1, PrayList)}),
				add_task_progress(?PetCityTaskType_Pray, {1})
		end,
		player:send(#pk_GS2U_pet_city_pray_reward{pos = Pos, error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_pray_reward{pos = Pos, error_code = Err})
	end.

%%使用加速道具进行 祈愿加速
on_pray_quick(Pos, DiamondNum, KvItemList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		?CHECK_THROW(DiamondNum >= 0, ?ERROR_Param),
		#pet_city{pray_list = PrayList} = Build = get_build(?BuildPray),
		{Pos, Item, OldTimeEnd, OldTimeStart} = case lists:keyfind(Pos, 1, PrayList) of%%{位置,祈愿道具,原祈愿结束时间,原祈愿开始时间}
													{_, _, TimeEnd, _} = T ->
														?CHECK_THROW(time:time() < TimeEnd, ?ErrorCode_PetCity_PrayComplete),
														T;
													_ -> throw(?ErrorCode_PetCity_NoPray)
												end,
		ItemList = [{K, V} || #pk_key_value{key = K, value = V} <- KvItemList],
		ItemFastTime = lists:foldl(fun({ItemId, Num}, Acc) ->%%道具加速时间
			case cfg_prayFast:getRow(ItemId) of
				#prayFastCfg{fastTime = FastTime} -> FastTime * Num + Acc;
				{} -> throw(?ERROR_Cfg)
			end end, 0, ItemList),
		{CurrError, CurrPrepared} = currency:delete_prepare([{0, DiamondNum}]),%%钻石数量足够
		?ERROR_CHECK_THROW(CurrError),
		DiamondList = df:getGlobalSetupValueList(jiasuka_Diamond, [{1, 1}, {600, 2}, {1800, 5}, {3600, 10}, {7200, 20}, {28800, 80}, {57600, 160}, {86400, 240}]),
		MaxRemainTime = case DiamondNum > 0 of%%最大剩余时间
							?TRUE ->
								Length = length(DiamondList),
								{{MaxCfgRemainTime, MaxCfgDiamondNum}, {MinCfgRemainTime, MinCfgDiamondNum}} = listFind(fun({_, V}) ->
									V > DiamondNum end, DiamondList, lists:nth(1, DiamondList), {lists:nth(Length - 1, DiamondList), lists:nth(Length, DiamondList)}),
								max(1, ceil(((DiamondNum - MinCfgDiamondNum) / (MaxCfgDiamondNum - MinCfgDiamondNum)) * (MaxCfgRemainTime - MinCfgRemainTime) + MinCfgRemainTime));
							?FALSE ->%%==0
								1
						end,
		NowTime = time:time(),
		RemainTime = OldTimeEnd - ItemFastTime - NowTime,%%剩余时间
		?CHECK_THROW(MaxRemainTime >= RemainTime, ?ERROR_Cfg),%%剩余时间在范围内
		NewTimeStart = NowTime - OldTimeEnd + OldTimeStart,%%新的开始时间
		{DelErr, ItemPrepared} = bag_player:delete_prepare(ItemList),
		?ERROR_CHECK_THROW(DelErr),
		currency:delete_finish(CurrPrepared, ?REASON_pet_city_quick_pray),
		bag_player:delete_finish(ItemPrepared, ?REASON_pet_city_quick_pray),
		update_build(Build#pet_city{pray_list = lists:keystore(Pos, 1, PrayList, {Pos, Item, NowTime - 2, NewTimeStart - 2})}),
		player:send(#pk_GS2U_pet_city_quick_prayRet{pos = Pos, diamond_num = DiamondNum, item_list = KvItemList})
	catch
		Error ->
			player:send(#pk_GS2U_pet_city_quick_prayRet{error_code = Error, pos = Pos, diamond_num = DiamondNum, item_list = KvItemList})
	end.

%%一键加速祈愿
on_onekey_pray_quick(QuickPrayList) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city{pray_list = PrayList} = Build = get_build(?BuildPray),
		DiamondList = df:getGlobalSetupValueList(jiasuka_Diamond, [{1, 0}, {60, 1}, {300, 3}, {600, 5}, {1800, 10}, {3600, 20}, {7200, 30}, {28800, 100}, {57600, 150}, {86400, 200}]),
		NowTime = time:time(),
		{DelItemList, DelDiamondNum, NewPrayList} = lists:foldl(fun(#pk_quick_pray{pos = Pos, diamond_num = DiamondNum, item_list = KvItemList}, {DelItemListAcc, DiamondNumAcc, OldPrayList}) ->
			ItemList = [{K, V} || #pk_key_value{key = K, value = V} <- KvItemList],
			?CHECK_THROW(DiamondNum >= 0, ?ERROR_Param),
			{_, Item, OldTimeEnd, OldTimeStart} = case lists:keyfind(Pos, 1, PrayList) of%%{位置,祈愿道具,原祈愿结束时间,原祈愿开始时间}
													  {_, _, TimeEnd, _} = T ->
														  ?CHECK_THROW(NowTime < TimeEnd, ?ErrorCode_PetCity_PrayComplete),
														  T;
													  _ -> throw(?ErrorCode_PetCity_NoPray)
												  end,
			MaxRemainTime = case DiamondNum > 0 of%%最大剩余时间
								?TRUE ->
									Length = length(DiamondList),
									{{MaxCfgRemainTime, MaxCfgDiamondNum}, {MinCfgRemainTime, MinCfgDiamondNum}} = listFind(fun({_, V}) ->
										V > DiamondNum end, DiamondList, lists:nth(1, DiamondList), {lists:nth(Length - 1, DiamondList), lists:nth(Length, DiamondList)}),
									max(1, ceil(((DiamondNum - MinCfgDiamondNum) / (MaxCfgDiamondNum - MinCfgDiamondNum)) * (MaxCfgRemainTime - MinCfgRemainTime) + MinCfgRemainTime));
								?FALSE ->%%==0
									1
							end,
			ItemFastTime = lists:foldl(fun({ItemId, Num}, Acc) ->%%道具加速时间
				case cfg_prayFast:getRow(ItemId) of
					#prayFastCfg{fastTime = FastTime} -> FastTime * Num + Acc;
					{} -> throw(?ERROR_Cfg)
				end end, 0, ItemList),
			RemainTime = OldTimeEnd - ItemFastTime - NowTime,%%剩余时间
			?CHECK_THROW(MaxRemainTime >= RemainTime, ?ERROR_Cfg),%%剩余时间在范围内
			NewTimeStart = NowTime - OldTimeEnd + OldTimeStart,%%新的开始时间
			{ItemList ++ DelItemListAcc, DiamondNum + DiamondNumAcc, lists:keystore(Pos, 1, OldPrayList, {Pos, Item, NowTime - 2, NewTimeStart - 2})}
																end, {[], 0, PrayList}, QuickPrayList),
		{CurrError, CurrPrepared} = currency:delete_prepare([{0, DelDiamondNum}]),%%钻石数量足够
		?ERROR_CHECK_THROW(CurrError),
		{ItemErr, ItemPrepared} = bag_player:delete_prepare(DelItemList),
		?ERROR_CHECK_THROW(ItemErr),
		currency:delete_finish(CurrPrepared, ?REASON_pet_city_quick_pray),
		bag_player:delete_finish(ItemPrepared, ?REASON_pet_city_quick_pray),
		update_build(Build#pet_city{pray_list = NewPrayList}),
		player:send(#pk_GS2U_pet_city_onekey_quick_prayRet{quick_pray_list = QuickPrayList})
	catch
		Error ->
			player:send(#pk_GS2U_pet_city_onekey_quick_prayRet{error_code = Error, quick_pray_list = QuickPrayList})
	end.

%% 任务完成
on_task_complete(Id) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		#pet_city_task{progress = Progress, is_reward = IsReward} = T = get_task(Id),
		?CHECK_THROW(IsReward =:= 0, ?ErrorCode_PetCity_TaskIsComplete),
		Cfg = cfg_homeTask:getRow(Id),
		?CHECK_CFG(Cfg),
		#homeTaskCfg{content = [{TaskTypeCfg, T1, T2} | _], gift = Reward} = Cfg,
		TargetNum = get_target_num(TaskTypeCfg, T1, T2),
		?CHECK_THROW(Progress >= TargetNum, ?ErrorCode_PetCity_TaskNotComplete),
		player:add_rewards(Reward, ?REASON_pet_city_task),
		show_reward_dialog(Reward),
		update_task(T#pet_city_task{is_reward = 1}),
		check_task(),
		player:send(#pk_GS2U_pet_city_task_complete{id = Id, error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_task_complete{id = Id, error_code = Err})
	end.

get_skill_list(PlayerId) ->
	case PlayerId == player:getPlayerID() of
		?TRUE -> get_pet_skill();
		_ -> get_pet_skill(PlayerId)
	end.

%% 根据等级列表获取技能(技能类型,ID,学习位)
get_pet_skill() ->
	#pet_city{lv_list = LvList} = get_build(?BuildResearch),
	lists:foldl(fun({Id, Lv}, Acc) ->
		case cfg_research:getRow(Id, Lv) of
			#researchCfg{skill = Skill0} ->
				Skill = [{ST, SI, SP} || {ST, SI, SP} <- [Skill0], SP > 0],
				Skill ++ Acc;
			_ -> Acc
		end end, [], LvList).
get_pet_skill(PlayerId) ->
	case table_player:lookup(db_pet_city, PlayerId, [?BuildResearch]) of
		[#pet_city{lv_list = LvList} | _] ->
			lists:foldl(fun({Id, Lv}, Acc) ->
				case cfg_research:getRow(Id, Lv) of
					#researchCfg{skill = Skill0} ->
						Skill = [{ST, SI, SP} || {ST, SI, SP} <- [Skill0], SP > 0],
						Skill ++ Acc;
					_ -> Acc
				end end, [], LvList);
		_ -> []
	end.

put_prop(L) -> put({?MODULE, prop}, L).
get_prop() -> case get({?MODULE, prop}) of
				  ?UNDEFINED -> [];
				  P -> P
			  end.

calc_prop() -> calc_prop(?FALSE).
calc_prop(IsOnline) ->
	LvNum = lists:foldl(
		fun(#pet_city{id = Id, lv = Lv}, LvAcc) ->
			case cfg_heroCountry:getRow(Id, Lv) of
				#heroCountryCfg{addNum = Add} -> Add + LvAcc;
				_ -> LvAcc
			end
		end, 0, get_all_build()),
	LvProp = [{?P_GuDingZhanDouLi, LvNum}],
	#pet_city{lv_list = LvList} = get_build(?BuildResearch),
	ResearchProp = lists:foldl(
		fun({Id, Lv}, Acc) ->
			case cfg_research:getRow(Id, Lv) of
				#researchCfg{playerAdd = {K, V}} when V =/= 0 -> [{K, V}] ++ Acc;
				_ -> Acc
			end end, [], LvList),
	Prop = attribute:base_prop_from_list(LvProp ++ ResearchProp),
	put_prop(Prop),
	[attribute_player:on_prop_change() || not IsOnline].

%% 获取属性和资质 [{K,V}]
%% 神像+研究所
get_pet_attr_and_qual(PlayerId) ->
	StatueProp = lists:foldl(
		fun(Id, Acc) ->
			get_fun_acc(PlayerId, Id, ?FunStrength) ++ Acc
		end, [], ?BuildStatueList),
	LvList = case PlayerId == player:getPlayerID() of
				 ?TRUE ->
					 #pet_city{lv_list = List} = get_build(?BuildResearch),
					 List;
				 _ ->
					 case table_player:lookup(db_pet_city, PlayerId, [?BuildResearch]) of
						 [#pet_city{lv_list = List1} | _] -> List1;
						 _ -> []
					 end
			 end,
	ResearchAttr = lists:foldl(
		fun({Id, Lv}, Acc) ->
			case cfg_research:getRow(Id, Lv) of
				#researchCfg{petAdd = {K, V}} when V =/= 0 -> [{K, V}] ++ Acc;
				_ -> Acc
			end end, [], LvList),
	StatueProp ++ ResearchAttr.

%% 完成所有祈愿
gm_pray_finish() ->
	try
		#pet_city{pray_list = PrayList} = Build = get_build(?BuildPray),
		{Reward, UpdatePos0} = lists:foldl(fun({_, Item, _, _}, {RewardL, LastPosL}) -> %% 奖励物品，留下的列表
			Cfg = cfg_prayItem:getRow(Item),
			?CHECK_CFG(Cfg),
			#prayItemCfg{gift = Reward} = Cfg,
			{Reward ++ RewardL, LastPosL} end, {[], []}, PrayList),
		UpdatePos = lists:keysort(1, UpdatePos0),
		RewardNum = length(PrayList) - length(UpdatePos), %% 本次奖励次数
		player:add_rewards(Reward, ?REASON_pet_city_pray),
		show_reward_dialog(Reward),
		update_build(Build#pet_city{pray_list = UpdatePos}),
		add_task_progress(?PetCityTaskType_Pray, {RewardNum}),
		player:send(#pk_GS2U_pet_city_pray_reward{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_pray_reward{error_code = Err})
	end.

%% 对已解锁的星光祭坛存储N小时星光祭坛产量
gm_add_alter_hour(Hour) ->
	RechargeAlterAcc = get_research_add(?Research_StarAlter),
	FightAlterAdd = get_fight_pet_star_add(),
	UpdateList = lists:foldl(
		fun(Id, Acc) ->
			case get_build(Id) of
				#pet_city{coin = Coin, lv = Lv} = Build when Lv =/= 0 ->
					DuringTime = Hour * 60, %% 一小时的分钟
					CoinSpeed = case get_fun_acc(Id, ?FunAlterSpeed) of
									[{?CURRENCY_PetCity, Speed} | _] -> Speed;
									_ -> 0 end,
					CoinStorage = case get_fun_acc(Id, ?FunAlterStorage) of
									  [{Storage, _} | _] -> Storage;
									  _ -> 0 end,
					AddCoin = calc_minute_add_coin(CoinSpeed, FightAlterAdd, RechargeAlterAcc, DuringTime),
					NewCoin = common:format_number(min(CoinStorage, Coin + AddCoin), 2),
					[Build#pet_city{coin = NewCoin} | Acc]; %% 时间往后偏移整分钟
				_ -> Acc
			end
		end, [], ?BuildAlterList),
	update_build(UpdateList).

%% 完成当前研究的内容
gm_research_finish() ->
	#pet_city{param2 = ResearchId, make_time = MakeTime, lv_list = LvList} = Build = get_build(?BuildResearch),
	case ResearchId of
		0 ->
			case MakeTime of %% 防止有错误数据
				0 -> skip;
				_ -> update_build(Build#pet_city{make_time = 0, time_func_start = 0})
			end;
		_ ->
%%			add_task_progress(?PetCityTaskType_Research, {1}),
			NowLv = case lists:keyfind(ResearchId, 1, LvList) of
						{_, Lv} -> Lv;
						_ -> 0
					end,
			Cfg = cfg_research:getRow(ResearchId, NowLv),
			#researchCfg{needTime = NeedTime} = Cfg,
			NowTime = time:time(),
			RealNeedTime = trunc(NowTime - NeedTime * (10000 - get_research_add(?Research_ResearchTime)) / 10000),
			update_build(Build#pet_city{make_time = NowTime, time_func_start = RealNeedTime}),
			refresh_fight_pet(?TRUE)
	end.

%% 完成当前次元召唤的内容
gm_call_finish() ->
	try
		CallErr = call_finish(?FALSE),
		?ERROR_CHECK_THROW(CallErr),
		player:send(#pk_GS2U_pet_city_call_reward{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_call_reward{error_code = Err})
	end.

%% 完成给当前锻造工坊的内容
gm_eq_finish() ->
	try
		MakeErr = eq_make_finish(?FALSE),
		?ERROR_CHECK_THROW(MakeErr),
		player:send(#pk_GS2U_pet_city_equip_make_reward{error_code = ?ERROR_OK})
	catch
		Err -> player:send(#pk_GS2U_pet_city_equip_make_reward{error_code = Err})
	end.

%% 将建筑升至N级
gm_build_lv_up(Id, Lv) ->
	Build = get_build(Id),
	case cfg_heroCountry:getRow(Id, Lv) of
		#heroCountryCfg{} ->
			update_build(Build#pet_city{lv = Lv, lv_time = 0, lv_time_start = 0}),
			refresh_build_lv_up([Id]);
		_ -> skip
	end.

%% 设置研究等级
gm_research_lv(Id, Lv) ->
	case cfg_research:getRow(Id, Lv) of
		#researchCfg{maxLevel = MaxLevel} ->
			#pet_city{lv_list = LvList, param2 = ResearchId} = Build = get_build(?BuildResearch),
			case ResearchId of
				Id when MaxLevel =:= Lv -> %%正好就是当前研究的,并且设置等级为最高等级
					update_build(Build#pet_city{lv_list = lists:keystore(Id, 1, LvList, {Id, Lv}), param2 = 0, make_time = 0, time_func_start = 0});
				_ -> update_build(Build#pet_city{lv_list = lists:keystore(Id, 1, LvList, {Id, Lv})})
			end;
		_ -> skip
	end.

%% 检查商店购买   商品id列表     消耗的货币列表
check_shop_buy(ShopIdList, DecCurrencyList) ->
	CheckList = get_fun_acc(?BuildShop, ?FunShop),
	IsPetCityShop = lists:any(fun({ShopId, _}) ->
		lists:member(ShopId, ShopIdList)
							  end, CheckList),
	case IsPetCityShop of
		?TRUE ->
			CorrValue = lists:sum([Count || {CurrType, Count} <- DecCurrencyList, CurrType =:= ?CURRENCY_TradeGold]),
			common_bp:on_condition_reach(?CommonBpCond_PetCityShop, CorrValue),
			add_task_progress(?PetCityTaskType_ShopBuy, {1});
		?FALSE -> skip
	end.

%%%===================================================================
%%% Internal functions
%%%===================================================================
set_all_build(L) -> put({?MODULE, build}, L).
get_all_build() ->
	case get({?MODULE, build}) of
		?UNDEFINED -> [];
		R -> R
	end.

get_build(Id) ->
	case lists:keyfind(Id, #pet_city.id, get_all_build()) of
		#pet_city{} = B -> B;
		_ -> #pet_city{player_id = player:getPlayerID(), id = Id}
	end.

%% 初始化，特别处理星光祭坛开始储存时间
init_build(Build) ->
	Build1 = Build#pet_city{lv_time = 0, lv_time_start = 0},
	case lists:member(Build#pet_city.id, ?BuildAlterList) andalso Build1#pet_city.lv =:= 1 of
		?TRUE ->
			Build1#pet_city{make_time = time:time()};
		?FALSE ->
			Build1
	end.

set_task(L) -> put({?MODULE, task}, L).
get_task() ->
	case get({?MODULE, task}) of
		?UNDEFINED -> [];
		R -> R
	end.
get_task(Id) ->
	case lists:keyfind(Id, #pet_city_task.id, get_task()) of
		#pet_city_task{} = B -> B;
		_ -> {}
	end.
get_task_in_progress() ->
	[T || #pet_city_task{is_reward = IsReward} = T <- get_task(), IsReward =:= 0].

%% 对比更新前后建筑变化，有变化则加入更新
compare_build(NewBuild, OldBuild) ->
	lists:foldl(fun(#pet_city{id = Id, lv = NewLv} = New, {Ret, IsLvUp}) ->
		case lists:keyfind(Id, #pet_city.id, OldBuild) of
			#pet_city{lv = OldLv} = Old ->
				case Old =:= New of
					?TRUE -> {Ret, IsLvUp};
					?FALSE ->
						case OldLv =/= NewLv of %% 检查等级，若等级相同则保持结果，若不同则刷新属性
							?TRUE -> {[New | Ret], ?TRUE};
							?FALSE -> {[New | Ret], IsLvUp}
						end
				end;
			_ -> {[New | Ret], ?TRUE}
		end end, {[], ?FALSE}, NewBuild).

get_fight_pet_star_add() ->
	FightPetUidList = pet_pos:get_fight_uid_list(),
	StarNum = lists:foldl(fun(Uid, Acc) ->
		case pet_soul:link_pet(player:getPlayerID(), pet_new:get_pet(Uid)) of
			#pet_new{star = Star} -> Star + Acc;
			_ -> Acc
		end end, 0, FightPetUidList),
	case cfg_petProduce:getRow(StarNum) of
		#petProduceCfg{probabilityAdd = Add} -> Add;
		_ -> 0
	end.

%% 研究所对应不同类型的加速
get_research_add(Id) ->
	case get_build(?BuildResearch) of
		#pet_city{lv_list = LvList} ->
			lists:foldl(fun({Index, Lv}, Acc) ->
				case cfg_research:getRow(Index, Lv) of
					#researchCfg{countryAddition = {Id, Add}} -> Acc + Add;
					_ -> Acc
				end end, 0, LvList);
		_ -> 0
	end.

%% 获取指定建筑功能相关加成
get_fun_acc(Build, FunType) ->
	#pet_city{id = Id, lv = Lv} = get_build(Build),
	Ret = case cfg_heroCountry:getRow(Id, Lv) of
			  #heroCountryCfg{functionRelevant = Fun} ->
				  [{P1, P2} || {T, P1, P2} <- Fun, T =:= FunType];
			  _ -> []
		  end,
	common:listValueMerge(Ret).

get_fun_acc(PlayerId, Id, FunType) ->
	#pet_city{id = Id, lv = Lv} =
		case PlayerId == player:getPlayerID() of
			?TRUE -> get_build(Id);
			_ ->
				case table_player:lookup(db_pet_city, PlayerId, [Id]) of
					[#pet_city{} = Build0 | _] -> Build0;
					_ -> #pet_city{player_id = player:getPlayerID(), id = Id}
				end
		end,
	Ret = case cfg_heroCountry:getRow(Id, Lv) of
			  #heroCountryCfg{functionRelevant = Fun} ->
				  [{P1, P2} || {T, P1, P2} <- Fun, T =:= FunType];
			  _ -> []
		  end,
	common:listValueMerge(Ret).

make_build_msg(Info) ->
	lists:foldl(
		fun(#pet_city{id = Id, lv = Lv, lv_time = LvTime, lv_time_start = TimeStart, time_func_start = FuncStart, param = Param0, param2 = Param2, make_time = MakeTime,
			lv_list = LvList, pray_list = PrayList, coin = Coin}, Acc) ->
			Param = case lists:member(Id, ?BuildAlterList) of
						?TRUE -> trunc(Coin);
						?FALSE -> Param0
					end,
			[#pk_PetCityBuild{id = Id, lv = Lv, time = LvTime, param = Param, param2 = Param2, make_time = MakeTime,
				lv_list = [#pk_key_value{key = K, value = V} || {K, V} <- LvList],
				pray_list = [#pk_key_3value{key = K, value1 = V1, value2 = V2, value3 = V3} || {K, V1, V2, V3} <- PrayList],
				time_start = TimeStart, time_func_start = FuncStart} | Acc]
		end, [], Info).

make_task_msg(List) ->
	[#pk_PetCityTask{task_id = Id, progress = P, is_reward = I} ||
		#pet_city_task{id = Id, progress = P, is_reward = I} <- List].

update_build([]) -> skip;
update_build(List) when is_list(List) ->
	update_build(List, ?TRUE);
update_build(Build) -> update_build([Build], ?TRUE).
update_build(List, IsUpdate) ->
	Info = get_all_build(),
	NewInfo = lists:foldl(
		fun(Build, Ret) ->
			lists:keystore(Build#pet_city.id, #pet_city.id, Ret, Build)
		end, Info, List),
	set_all_build(NewInfo),
	table_player:insert(db_pet_city, List),
	IsUpdate andalso player:send(#pk_GS2U_pet_city_update{build_list = make_build_msg(List)}).

update_task(List) when is_list(List) ->
	AllTask = get_task(),
	NewInfo = lists:foldl(
		fun(Task, Ret) ->
			lists:keystore(Task#pet_city_task.id, #pet_city_task.id, Ret, Task)
		end, AllTask, List),
	set_task(NewInfo),
	table_player:insert(db_pet_city_task, List),
	player:send(#pk_GS2U_pet_city_task_update{task_list = make_task_msg(List)});
update_task(Task) -> update_task([Task]).

%% 功能是否开放
is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_PetCity) =:= 1 andalso guide:is_open_action(?OpenAction_PetCity).

%% 检查建筑升级条件
check_lv_condition([{1, Lv, _} | Condition]) ->
	PlayerLv = player:getLevel(),
	case PlayerLv >= Lv of
		?TRUE -> check_lv_condition(Condition);
		?FALSE -> ?FALSE
	end;
check_lv_condition([{2, Id, Lv} | Condition]) ->
	#pet_city{lv = BuildLv} = get_build(Id),
	case BuildLv >= Lv of
		?TRUE -> check_lv_condition(Condition);
		?FALSE -> ?FALSE
	end;
check_lv_condition([{3, OpenId, _} | Condition]) ->
	case guide:is_open_action(OpenId) of
		?TRUE -> check_lv_condition(Condition);
		?FALSE -> ?FALSE
	end;
check_lv_condition([]) -> ?TRUE;
check_lv_condition(Condition) ->
	?LOG_ERROR("check error condition:~p", [Condition]),
	?FALSE.

%% 检查英雄是否在所有的建筑中工作
check_pet_work(0) -> ?FALSE;
check_pet_work(PetCfgId) ->
	#pet_city{param = P1} = get_build(?BuildResearch),
	C1 = pet_new:get_pet_cfg_id(P1),
	IsP1 = PetCfgId =:= C1,
	#pet_city{param = P2} = get_build(?BuildEquip),
	C2 = pet_new:get_pet_cfg_id(P2),
	IsP2 = PetCfgId =:= C2,
	IsP1 orelse IsP2.

%% 检查研究条件 参数1-宠物id
check_research(Condition, PetStar) ->
	#pet_city{lv_list = LvList} = get_build(?BuildResearch),
	lists:all(fun
				  ({1, NeedStar, _}) -> %% 宠物星级
					  PetStar >= NeedStar;
				  ({2, Id, NeedLv}) -> %% 研究所前置天赋等级
					  case lists:keyfind(Id, 1, LvList) of
						  {_, Lv} -> Lv >= NeedLv;
						  _ -> ?FALSE
					  end;
				  ({3, NeedLv, _}) -> %5 研究圣所等级
					  get_build_lv(?BuildResearch) >= NeedLv;
				  (Err) ->
					  ?LOG_ERROR("error_researchCfg:~p", [Err]),
					  ?FALSE
			  end, Condition).

%%英雄国度更新
%%记录祈愿，装备打造，召唤，以及正在升级的 等数据的开始时间
fix_data_07020() ->
	BuildList = get_all_build(),
	Fun = fun(#pet_city{id = BuildId, lv = Lv, lv_time = LvTiemEnd, make_time = MakeTime, pray_list = PrayList,
		param = Param, param2 = Param2, lv_list = LvList} = PetInfo, Acc) ->
		BuildCfg = cfg_heroCountry:getRow(BuildId, Lv),
		#heroCountryCfg{needTime = BuildUpNeedTime} = BuildCfg,%%建筑升级所需时间
		%%本次建筑升级开始时间
		LvTiemStart = ?IF(LvTiemEnd =:= 0, 0, trunc(LvTiemEnd - BuildUpNeedTime * (10000 - get_research_add(?Research_BuildTime)) / 10000)),
		NewPetInfo = case BuildId of
						 ?BuildCall when Param =/= 0 andalso MakeTime =/= 0 ->%%次元召唤阵 -
							 Cfg = cfg_callPet:getRow(Param),
							 #callPetCfg{needTime = NeedTime} = Cfg,
							 FuncStart = trunc(MakeTime - NeedTime * (10000 - get_research_add(?Research_CallTime)) / 10000),%%本次使用开始时间
							 PetInfo#pet_city{lv_time_start = LvTiemStart, time_func_start = FuncStart};
						 ?BuildResearch when Param2 =/= 0 andalso MakeTime =/= 0 ->%%研究所 正在使用
							 NowLv = case lists:keyfind(Param2, 1, LvList) of
										 {_, Lv} -> Lv;
										 _ -> 0
									 end,
							 Cfg = cfg_research:getRow(Param2, NowLv),
							 #researchCfg{needTime = NeedTime} = Cfg,
							 FuncStart = trunc(MakeTime - NeedTime * (10000 - get_research_add(?Research_ResearchTime)) / 10000),%%本次使用开始时间
							 PetInfo#pet_city{lv_time_start = LvTiemStart, time_func_start = FuncStart};
						 ?BuildEquip when Param2 =/= 0 andalso MakeTime =/= 0 ->%%装备工坊 正在使用
							 Cfg = cfg_makeEquip:getRow(Param2),
							 #makeEquipCfg{needTime = NeedTime} = Cfg,
							 FuncStart = trunc(MakeTime - NeedTime * (10000 - get_research_add(?Research_EquipMakeTime)) / 10000),%%本次使用开始时间
							 PetInfo#pet_city{lv_time_start = LvTiemStart, time_func_start = FuncStart};
						 ?BuildPray -> %%祈愿圣所
							 F2 = fun
									  ({Pos, ItemId, EndTime}, ListAcc) ->
										  Cfg = cfg_prayItem:getRow(ItemId),
										  #prayItemCfg{needTime = NeedTime} = Cfg,
										  FuncStart = trunc(EndTime - NeedTime * (10000 - get_research_add(?Research_PrayTime)) / 10000),%%本次使用开始时间
										  [{Pos, ItemId, EndTime, FuncStart} | ListAcc];
									  (_, ListAcc) ->
										  ListAcc
								  end,
							 NewPrayList = lists:foldl(F2, [], PrayList),%%新的祈愿数据
							 PetInfo#pet_city{lv_time_start = LvTiemStart, pray_list = NewPrayList};
						 _ ->%%其他
							 PetInfo#pet_city{lv_time_start = LvTiemStart}
					 end,
		[NewPetInfo | Acc]
		  end,
	NewBuildList = lists:foldl(Fun, [], BuildList),
	update_build(NewBuildList, ?FALSE),%%不同步
	on_sync_info().

%% 装备工坊协助英雄最低等级
get_lowest_pet_star() ->
	lists:min(cfg_petMakeEquip:getKeyList()).

%% 装备打造随机奖励
get_make_equip_reward(Cfg, PetUid) ->
	#makeEquipCfg{initialProbability = R1Per, result1 = R1, result2 = R2} = Cfg,
	PetPerList = get_pet_per(PetUid),%%英雄星级给与的基础概率
	BuildPerList = get_fun_acc(?BuildEquip, ?FunCall),%% 建筑等级给予的基础概率
	PerList = common:listValueMerge(PetPerList ++ BuildPerList),
	AddPer = case lists:keyfind(1, 1, PerList) of %% 库1增加概率 0
				 {_, AddPer0} -> AddPer0;
				 _ -> 0 end,
	DecPer = case lists:keyfind(2, 1, PerList) of %% 库1减少概率（库2增加概率）
				 {_, DecPer0} -> DecPer0;
				 _ -> 0 end,
	RealPer = R1Per + AddPer - DecPer,
	RealPer1 = max(0, RealPer),
	RealPer2 = min(10000, RealPer1),
	WeightList = case common:rand(1, 10000) =< RealPer2 of
					 ?TRUE -> R1;
					 ?FALSE -> R2
				 end,
	common:getRandomValueFromWeightList_1(WeightList, 0).

%% 获取协助宠物获得的库概率加成
get_pet_per(PetUid) ->
	Star = pet_new:get_pet_star(PetUid),
	case Star of
		0 -> [];
		_ -> case cfg_petMakeEquip:getRow(Star) of
				 #petMakeEquipCfg{probabilityAdd = Per} -> [Per];
				 _ ->
					 ?LOG_ERROR("no cfg_petMakeEquip:~p", [{PetUid, Star}]),
					 []
			 end
	end.

%% 获取对应建筑Id的等级
get_build_lv(Id) ->
	case get_build(Id) of
		#pet_city{lv = Lv} -> Lv;
		_ -> 0
	end.

%% 检查所有任务放入任务列表，刷新新的任务
check_task() ->
	AllTask = get_task(),
	AllTaskId = [Id || #pet_city_task{id = Id} <- AllTask],
	CheckTask = cfg_homeTask:getKeyList() -- AllTaskId,
	UpdateTask = lists:foldl(fun(Id, Ret) ->
		#homeTaskCfg{needCondition = NeedCondition, content = [Content | _]} = cfg_homeTask:getRow(Id),
		case check_task_condition(NeedCondition) of
			?TRUE ->
				[#pet_city_task{player_id = player:getPlayerID(), id = Id, progress = get_progress(Content)} | Ret];
			?FALSE -> Ret
		end
							 end, [], CheckTask),
	update_task(UpdateTask).

%% 判断任务前置条件
check_task_condition(List) ->
	lists:all(fun
				  ({1, Lv, _}) -> %% 玩家等级
					  player:getLevel() >= Lv;
				  ({2, TaskId, _}) -> %% 已领取奖励任务
					  is_task_reward(TaskId);
				  ({3, Id, BuildLv}) -> %% 建筑等级
					  get_build_lv(Id) >= BuildLv;
				  (_) ->
					  ?LOG_ERROR("check cfg_homeTask NeedCondition:~p", [List]),
					  ?FALSE
			  end, List).

%% 是否已经领取了任务奖励
is_task_reward(TaskId) ->
	case get_task(TaskId) of
		#pet_city_task{is_reward = IsReward} ->
			IsReward =:= 1;
		_ -> ?FALSE
	end.

%% 增加任务完成进度，根据次数推进任务进度类型
add_task_progress(ProgressTask, {P1}) -> add_task_progress(ProgressTask, {P1, 0});
add_task_progress(ProgressTask, {P1, P2}) ->
	Fun = fun(#pet_city_task{id = Id, progress = P} = T, List) ->
		case cfg_homeTask:getRow(Id) of
			#homeTaskCfg{content = [{TaskType, T1, T2} | _]} when ProgressTask =:= TaskType ->
				TargetNum = get_target_num(TaskType, T1, T2),
				AddProgress = check_add_progress(ProgressTask, P1, P2),
				FinalProgress = min(TargetNum, P + AddProgress),
				case FinalProgress =:= P of
					?TRUE -> List;
					?FALSE -> [T#pet_city_task{progress = FinalProgress} | List]
				end;
			_ -> List
		end end,
	UpdateList = lists:foldl(Fun, [], get_task_in_progress()),
	update_task(UpdateList).

%% 获取配置目标数量
get_target_num(TaskType, P1, P2) ->
	case TaskType of
		?PetCityTaskType_Build -> P2;
		?PetCityTaskType_AltarCoin -> P2;
		?PetCityTaskType_EquipMake -> P1;
		?PetCityTaskType_Call -> P1;
		?PetCityTaskType_ShopBuy -> 1;
		?PetCityTaskType_Research -> P1;
		?PetCityTaskType_Pray -> P1;
		_ -> throw(?ErrorCode_PetCity_TaskType)
	end.

%% 检查输入的参数，对应推进的进度
check_add_progress(TaskType, P1, _P2) ->
	case TaskType of
		?PetCityTaskType_AltarCoin ->
			P1;
		?PetCityTaskType_EquipMake ->
			P1;
		?PetCityTaskType_Call ->
			P1;
		?PetCityTaskType_ShopBuy ->
			P1;
		?PetCityTaskType_Research ->
			P1;
		?PetCityTaskType_Pray ->
			P1;
		_ -> 0
	end.

%% 刷新任务进度，可直接获取任务进度类型
refresh_task(TaskType) ->
	Fun = fun(#pet_city_task{id = Id, progress = P} = T, List) ->
		case cfg_homeTask:getRow(Id) of
			#homeTaskCfg{content = [{TaskTypeCfg, T1, T2} | _]} when TaskType =:= TaskTypeCfg ->
				TargetNum = get_target_num(TaskTypeCfg, T1, T2),
				NowProgress = max(get_progress(TaskType, T1, T2), P),
				FinalProgress = min(TargetNum, NowProgress),
				case FinalProgress =:= P of
					?TRUE -> List;
					?FALSE -> [T#pet_city_task{progress = FinalProgress} | List]
				end;
			_ -> List
		end end,
	UpdateList = lists:foldl(Fun, [], get_task_in_progress()),
	update_task(UpdateList).

%% 获取任务完成进度
get_progress({T, P1, P2}) ->
	get_progress(T, P1, P2).
get_progress(?PetCityTaskType_Build, P1, _) ->
	get_build_lv(P1);
get_progress(_TaskType, _P1, _P2) ->
	0.

%% 领取研究奖励 是否检查时间,返回 是否可领取,及NewPetCity
research_finish(IsCheckTime) ->
	#pet_city{lv_list = LvList, param2 = ResearchId, make_time = EndTime} = Build = get_build(?BuildResearch),
	case IsCheckTime of
		?TRUE -> ?CHECK_THROW(time:time() >= EndTime, ?ErrorCode_PetCity_ResearchExist);
		?FALSE -> skip
	end,
	%% 研究所升级
	IsSearch = lists:keymember(ResearchId, 1, cfg_research:getKeyList()),
	case time:time() >= EndTime of
		?TRUE ->
			NewLv = case lists:keyfind(ResearchId, 1, LvList) of
						{_, ResearchLv} -> ResearchLv + 1;
						_ -> 1
					end,
			case cfg_research:getRow(ResearchId, NewLv) of
				#researchCfg{} ->
					{?ERROR_OK, Build#pet_city{param = 0, param2 = 0, make_time = 0, time_func_start = 0,
						lv_list = lists:keystore(ResearchId, 1, LvList, {ResearchId, NewLv})}};
				_ ->
					?LOG_ERROR("no cfg_research NewLv:~p", [{ResearchId, NewLv}]),
					{?ERROR_Cfg, Build}
			end;
		_ when IsSearch =:= ?TRUE -> {?ErrorCode_PetCity_ResearchComplete, Build};
		_ -> {?ERROR_Cfg, Build}
	end.

%% 领取次元召唤奖励 是否检查时间
call_finish(IsCheckTime) ->
	try
		#pet_city{lv = Lv, param = Id, make_time = MakeTime, ssr_time = SSRTime} = Build = get_build(?BuildCall),
		case IsCheckTime of
			?TRUE -> ?CHECK_THROW(time:time() >= MakeTime, ?ErrorCode_PetCity_CallTime);
			?FALSE -> skip
		end,
		Cfg = cfg_callPet:getRow(Id),
		?CHECK_CFG(Cfg),
		#callPetCfg{buildProbability = BuildPer, mustSSR = MustSSR, result1 = R1, result2 = R2, needTime = NeedTime} = Cfg,
		MustSSRTime = case lists:keyfind(Lv, 1, MustSSR) of
						  {_, T} -> T;
						  _ -> 0
					  end,
		SSRPer = case lists:keyfind(Lv, 1, BuildPer) of
					 {_, Per} -> Per;
					 _ -> throw(?ErrorCode_PetCity_CallPerCfg)
				 end,
		ThisSSRTime = case lists:keyfind(Id, 1, SSRTime) of %% 该道具没抽到ssr的次数
						  {_, Time} -> Time;
						  _ -> 0
					  end,
		PerList = get_fun_acc(?BuildCall, ?FunCall),
		DecPer = case lists:keyfind(1, 1, PerList) of %% 库1增加概率
					 {_, AddPer0} -> AddPer0;
					 _ -> 0 end,
		AddPer = case lists:keyfind(2, 1, PerList) of %% 库2增加概率
					 {_, DecPer0} -> DecPer0;
					 _ -> 0 end,
		RealPer = SSRPer + AddPer - DecPer, %% 最终SSR库概率
		RealPer1 = max(0, RealPer),
		RealPer2 = min(10000, RealPer1),
		{WeightList, NewSSRTime} =
			case ThisSSRTime >= MustSSRTime andalso MustSSRTime =/= 0 of
				?TRUE -> %% 到保底次数，必出SSR
					{R2, 0};
				?FALSE ->
					case common:rand(1, 10000) =< RealPer2 of
						?TRUE -> {R2, 0};
						?FALSE -> {R1, ThisSSRTime + 1}
					end
			end,
		case IsCheckTime of
			?TRUE ->
				UpdateSSRTime = lists:keystore(Id, 1, SSRTime, {Id, NewSSRTime}),
				Result = common:getRandomValueFromWeightList_1(WeightList, 0),
				RewardItem = [{Result, 1}],
				player_item:show_get_item_dialog(RewardItem, [], [], 0),
				bag_player:add(RewardItem, ?REASON_pet_city_call),
				update_build(Build#pet_city{param = 0, make_time = 0, ssr_time = UpdateSSRTime, time_func_start = 0}),
				add_task_progress(?PetCityTaskType_Call, {1});
			?FALSE ->
				FuncStart = trunc(MakeTime - NeedTime * (10000 - get_research_add(?Research_CallTime)) / 10000),%%本次使用开始时间
				update_build(Build#pet_city{make_time = time:time(), time_func_start = FuncStart})
		end,
		?ERROR_OK
	catch
		Err -> Err
	end.

%% 完成装备打造 是否检查时间
eq_make_finish(IsCheckTime) ->
	try
		#pet_city{param = PetUid, param2 = Id, make_time = MakeTime} = Build = get_build(?BuildEquip),
		Result =
			case MakeTime of
				0 ->
					?CHECK_THROW(Id =/= 0, ?ErrorCode_PetCity_PetEquipNoMaking),
					Id;
				_ ->
					case IsCheckTime of
						?TRUE -> ?CHECK_THROW(time:time() >= MakeTime, ?ErrorCode_PetCity_PetEquipMaking);
						?FALSE -> skip
					end,
					Cfg = cfg_makeEquip:getRow(Id),
					?CHECK_CFG(Cfg),
					get_make_equip_reward(Cfg, PetUid)
			end,
		RewardItem = [{Result, 1}],
		case IsCheckTime of
			?TRUE ->
				player_item:show_get_item_dialog(RewardItem, [], [], 0),
				bag_player:add(RewardItem, ?REASON_pet_city_call),
				update_build(Build#pet_city{param = 0, param2 = 0, make_time = 0, time_func_start = 0}),
				add_task_progress(?PetCityTaskType_EquipMake, {1});
			?FALSE ->
				#makeEquipCfg{needTime = NeedTime} = cfg_makeEquip:getRow(Id),
				FuncStart = trunc(MakeTime - NeedTime * (10000 - get_research_add(?Research_EquipMakeTime)) / 10000),%%本次使用开始时间
				update_build(Build#pet_city{make_time = time:time(), time_func_start = FuncStart})
		end,
		?ERROR_OK
	catch
		Err -> Err
	end.

show_reward_dialog(Reward) ->
	ItemList = [{P1, P2} || {1, P1, P2} <- Reward],
	CoinList = [{P1, P2} || {2, P1, P2} <- Reward],
	MergeItem = common:listValueMerge(ItemList),
	MergeCoin = common:listValueMerge(CoinList),
	player_item:show_get_item_dialog(MergeItem, MergeCoin, [], 0, 1).


%% 神像提供玩家属性，玩家属性提供属性给宠物。需要先刷新玩家属性，再刷新宠物
refresh_fight_pet(IsCalc) ->
	?IF(IsCalc, calc_prop(), skip),
	pet_battle:calc_player_add_fight(),
	pet_base:save_pet_sys_attr(?FALSE),
	player_refresh:on_refresh_pet(),
	player_refresh:on_refresh_pet_attr(?FALSE),
	pet_battle:sync_to_top(0, ?TRUE).

%% 建筑变化检查属性
%% IsTick 如果是每分钟刷新调用，则不计算玩家属性，由tick自行刷新
%% IsTickCalc 每分钟是否计算过属性
refresh_build_lv_up(IdList) ->
	refresh_build_lv_up(IdList, ?FALSE, ?FALSE).
refresh_build_lv_up(IdList, IsTick, IsTickCalc) ->
	?IF(IsTick, skip, calc_prop()),
	NeedCalc = case IsTick of %% 判断刷新宠物是否需要计算
				   ?TRUE -> case IsTickCalc of %% 如果每分钟已经计算过了，那接下来也不需要计算了
								?TRUE -> ?FALSE;
								?FALSE -> ?TRUE
							end;
				   ?FALSE -> ?FALSE
			   end,
	CheckIdList = ?BuildStatueList ++ [?BuildResearch], %% 判断是否有神像/研究所更新，有则计算出战宠物属性
	IsCalc = (CheckIdList -- IdList) =/= CheckIdList,
	?IF(IsCalc, refresh_fight_pet(NeedCalc), skip).

%% 星光祭坛计算每分钟增加的金币， 每分钟速度、出战英雄增加速度、星光祭坛增加速率、经过的分钟
calc_minute_add_coin(CoinSpeed, FightAlterAdd, RechargeAlterAcc, DuringTime) ->
	AddCoin = (CoinSpeed + FightAlterAdd) * (RechargeAlterAcc + 10000) / 10000 * DuringTime,
	common:format_number(AddCoin, 2).


%% 查找最大剩余时间和钻石 与 最小剩余时间和钻石
listFind(FindFun, [Value | List], OldValue, DefaultValue) ->
	case FindFun(Value) of
		true -> {Value, OldValue};
		false -> listFind(FindFun, List, Value, DefaultValue)
	end;
listFind(_FindFun, [], _, DefaultValue) ->
	DefaultValue.