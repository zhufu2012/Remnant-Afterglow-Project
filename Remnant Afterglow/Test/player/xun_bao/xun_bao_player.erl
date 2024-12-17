%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 寻宝：玩家进程
%%% @end
%%% Created : 2018-12-12 10:00
%%%-------------------------------------------------------------------
-module(xun_bao_player).
-include("global.hrl").
-include("logger.hrl").
-include("reason.hrl").
-include("error.hrl").
-include("variable.hrl").
-include("db_table.hrl").
-include("item.hrl").
-include("record.hrl").
-include("netmsgRecords.hrl").
-include("cfg_rouletteNew.hrl").
-include("cfg_rouletteTime.hrl").
-include("cfg_rouletteTimeItem.hrl").
-include("cfg_rouletteTimeItem2.hrl").
-include("cfg_rouletteRuneShow.hrl").
-include("cfg_rouletteRuneChange.hrl").
-include("cfg_roulettePreviewBig.hrl").
-include("cfg_item.hrl").
-include("daily_task_goal.hrl").
-include("activity_new.hrl").
-include("player_task_define.hrl").
-include("xun_bao.hrl").
-include("seven_gift_define.hrl").
-include("time_limit_gift_define.hrl").
-include("log_times_define.hrl").
-include("currency.hrl").
-include("attainment.hrl").
-include("player_private_list.hrl").

-define(TABLE_DATA, db_xun_bao_player).
-define(CoinItem, 1000). %% 货币假道具
-define(XunBaoCurrency, [?CURRENCY_Money, ?CURRENCY_Shengwen]).%%列表内的货币，不会直接领取，而是先放入寻宝仓库
%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_load/1, on_open_action/1, on_vip_change/0, send_update_level/0, send_data/0, on_preview_data/1]).
-export([on_draw/3, on_period_finish/3, on_draw_record/1, on_rune_show/0, on_equip_level_list/0, on_equip_level/2, on_time_item_finish/2]).
-export([get_turn_id/1, get_rune_draw_time/0, get_gem_draw_time/0, get_soul_card_draw_time/0, get_pantheon_draw_time/0, get_soul_stone_draw_time/0]).
-export([on_reset/0]).
-export([on_taitan_reset/2, on_taitan_receive/2, on_taitan_synthe/2]).%%泰坦寻宝特殊处理
-export([on_get_draw_storage_item/1, get_draw_time/1, fix_data_0913/0]).

%% 加载数据
on_load(PlayerId) -> ?metrics(begin
								  List = table_player:lookup(?TABLE_DATA, PlayerId),
								  DataList = lists:map(
									  fun(Data) ->
										  #data{
											  data_id = Data#db_xun_bao_player.data_id,                %% 寻宝Id
											  level = Data#db_xun_bao_player.level,                  %% 寻宝等级
											  hot_id = Data#db_xun_bao_player.hot_id,                    %% 热点ID
											  turn_id = Data#db_xun_bao_player.turn_id,                %% 轮换大奖ID
											  free_time = Data#db_xun_bao_player.free_time,              %% 免费开始时间
											  draw_num = Data#db_xun_bao_player.draw_num,               %% 单抽次数
											  draw_ten_num = Data#db_xun_bao_player.draw_ten_num,           %% 十连次数
											  score = Data#db_xun_bao_player.score,                  %% 积分
											  period_time = Data#db_xun_bao_player.period_time,            %% 周期结束时间
											  period_level = Data#db_xun_bao_player.period_level,           %% 周期等级
											  period_num = Data#db_xun_bao_player.period_num,             %% 周期次数
											  period_finish_list = binary_to_term(Data#db_xun_bao_player.period_finish_list),    %% 周期领奖列表 [{Index, Choice}]
											  record_list = binary_to_term(Data#db_xun_bao_player.record_list),            %% 记录列表
											  person_lucky = Data#db_xun_bao_player.person_lucky,                    %% 个人幸运值
											  time_draw_award_time = gamedbProc:dbstring_to_term(Data#db_xun_bao_player.time_draw_award_time),    %% 多次寻宝累计次数
											  first_tens = Data#db_xun_bao_player.first_tens,                        %% 首次连抽
											  drop_num_list = gamedbProc:dbstring_to_term(Data#db_xun_bao_player.drop_num_list),            %% 掉落次数列表 [{DropId, Num}]
											  today_draw_times = Data#db_xun_bao_player.today_draw_times                %% 今日寻宝次数
										  }
									  end, List),
								  put_data_list(DataList),
								  send_data() end).

%% 功能开启
on_open_action(DataId) -> ?metrics(begin
									   Second = case DataId of
													?DATA_ID_1 -> cfg_globalSetup:equipFreeTime();
													?DATA_ID_2 -> cfg_globalSetup:runeFreeTime();
													?DATA_ID_3 -> cfg_globalSetup:mountFreeTime();
													?DATA_ID_4 -> cfg_globalSetup:wingFreeTime();
													?DATA_ID_5 -> cfg_globalSetup:petFreeTime();
													?DATA_ID_6 -> cfg_globalSetup:equipFreeTime();
													?DATA_ID_7 -> cfg_globalSetup:shengwenFreeTime();
													?DATA_ID_8 -> cfg_globalSetup:shenbingFreeTime();
													?DATA_ID_9 -> cfg_globalSetup:shenhunFreeTime();
													_ -> 0
												end,
									   case Second > 0 of
										   ?TRUE ->
											   Data = get_new_data(DataId),
											   FreeTime = time:time() + Second,
											   NewData = Data#data{free_time = FreeTime},
											   update_data(NewData),
											   send_data(NewData);
										   ?FALSE ->
											   Data = get_new_data(DataId),
											   send_data(Data)
									   end end).

%% vip变化
on_vip_change() ->
	send_data(),
	ok.

%% 寻宝
on_draw(DataId, DrawTime, IsFree) ->
	?metrics(begin
				 try
					 case is_open_action(DataId) of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ERROR_xun_bao_open)
					 end,
					 Data = get_new_data(DataId),
					 Time = time:time(),
					 {DrawError, NewData1, Result} = draw(Data, Time, IsFree, DrawTime),
					 set_world_lucky_reset(?TRUE),
					 ?ERROR_CHECK_THROW(DrawError),
					 %% 寻宝记录
					 {GiftItemList, GiftCurrencyList, DrawItemList, DrawRareItemList, DrawEquipmentList, DrawCurrencyList, ResultMsgList} = Result,

					 NewData2_ = add_record(NewData1, DrawItemList, DrawEquipmentList, DrawCurrencyList, Time, ?RECORD_TYPE_NORMAL_1),
					 NewData2 =
						 case DrawRareItemList of
							 [] ->
								 NewData2_;
							 _ ->
								 add_record(NewData2_, DrawRareItemList, [], [], Time, ?RECORD_TYPE_RARE_2)
						 end,

					 {ERROR, NewData3, IsRefresh} =
						 case lists:member(DataId, ?HAVE_HOT_TYPE) of
							 ?TRUE -> check_period_num(DataId, NewData2);
							 ?FALSE -> {?ERROR_OK, NewData2, ?FALSE}
						 end,
					 case ERROR of
						 ?ERROR_xun_bao_period_finish_num -> skip;
						 Other -> ?ERROR_CHECK_THROW(Other)
					 end,
					 update_data(NewData3),
					 logdbProc:log_herodraw(DataId, Time),
					 add_task_time(DataId, DrawTime),
					 DataId =:= ?DATA_ID_17 andalso add_taitan_all_num(Data#data.level, DrawTime),
					 %% 返回应答
					 player:send(#pk_GS2U_HeroDraw{data_id = DataId, draw_time = DrawTime, isFree = IsFree, isRefresh = IsRefresh, errorCode = ?ERROR_OK,
						 drawInfo = make_draw_info_msg(NewData3), drawCfg = make_draw_cfg_msg(NewData3),
						 giftItemList = make_item_msg_list(GiftItemList), giftCurrencyList = make_currency_msg_list(GiftCurrencyList),
						 drawResultList = ResultMsgList
					 }),
					 case DataId of
						 ?DATA_ID_2 ->
							 logdbProc:log_xun_bao(4, DrawTime, IsFree),
							 time_limit_gift:check_open(?TimeLimitType_FuWenXunBao),
							 times_log:add_times(?Log_Type_DayFuWenXunBao, DrawTime);
						 ?DATA_ID_13 ->
							 logdbProc:log_xun_bao(1, DrawTime, IsFree),
							 time_limit_gift:check_open(?TimeLimitType_GemXunBao),
							 times_log:add_times(?Log_Type_DayGemXunbao, DrawTime);
						 ?DATA_ID_14 ->
							 logdbProc:log_xun_bao(2, DrawTime, IsFree),
							 time_limit_gift:check_open(?TimeLimitType_CardXunBao),
							 times_log:add_times(?Log_Type_DayCardXunBao, DrawTime);
						 ?DATA_ID_15 ->
							 logdbProc:log_xun_bao(3, DrawTime, IsFree),
							 time_limit_gift:check_open(?TimeLimitType_PantheonXunBao),
							 times_log:add_times(?Log_Type_DayPantheonXunBao, DrawTime);
						 ?DATA_ID_16 ->
							 logdbProc:log_xun_bao(7, DrawTime, IsFree),
							 time_limit_gift:check_open(?TimeLimitType_SoulStoneXunBao),
							 times_log:add_times(?Log_Type_DaySoulStoneXunBao, DrawTime);
						 ?DATA_ID_7 ->
							 logdbProc:log_xun_bao(8, DrawTime, IsFree);
						 ?DATA_ID_17 ->
							 logdbProc:log_xun_bao(10, DrawTime, IsFree);
						 _ -> ok
					 end,
					 activity_new_player:on_func_open_check(?ActivityOpenType_XunBaoDrawTime, {get_draw_num(Data), get_draw_num(NewData3)}),
					 ok
				 catch
					 Error ->
						 player:send(#pk_GS2U_HeroDraw{data_id = DataId, draw_time = DrawTime, isFree = IsFree, errorCode = Error})
				 end
			 end).
%% 玩家达到所有奖励领取条件后，系统立即重置次数奖励
check_period_num(Type, Data) ->
	try
		#data{hot_id = PeriodId, period_num = PeriodNum, period_finish_list = PeriodFinishList} = Data,
		RouletteTimeCfg = cfg_rouletteTime:row(PeriodId),
		{_, MaxPeriodNum} = common:listFindMax(1, RouletteTimeCfg#rouletteTimeCfg.condPara),
		PeriodNum2 = case common:listFindMax(1, PeriodFinishList) of%%目前领取到的奖励最大序号,对应的次数
						 {} -> 0;
						 {MaxIndex, _} ->
							 {_, N} = lists:keyfind(MaxIndex, 1, RouletteTimeCfg#rouletteTimeCfg.condPara),
							 N
					 end,
		%%是否刷新，新的次数,完整奖励阶段数
		{IsRefresh, Remaining, Count} = case PeriodNum > MaxPeriodNum of
											?TRUE ->
												C = (PeriodNum - PeriodNum2) div MaxPeriodNum,
												Num = case PeriodNum - C * MaxPeriodNum of
														  S when S < MaxPeriodNum -> C - 1;
														  _ -> C
													  end,
												{?TRUE, max(PeriodNum rem MaxPeriodNum, 0), Num};
											?FALSE -> {?FALSE, 0, 0}
										end,
		NewData = case IsRefresh of
					  ?TRUE -> Data#data{period_num = Remaining, period_finish_list = []};
					  ?FALSE -> throw(?ERROR_xun_bao_period_finish_num)
				  end,
		Career = player:getCareer(),
		AwardParaNew = RouletteTimeCfg#rouletteTimeCfg.awardParaNew1,
		Fun = fun(Index, {ItemListRet, CurrencyListRet}) ->
			List = [{P2, P3, P4, P5, P6} || {P1, P2, P3, P4, P5, P6} <- AwardParaNew, not lists:member(P1, Index)],
			L1 = [#itemInfo{itemID = CfgId, num = Amount, isBind = Bind} || {DropCareer, 1, CfgId, Bind, Amount} <- List,
				DropCareer =:= 0 orelse DropCareer =:= Career],
			L2 = [#coinInfo{type = CfgId, num = Amount, reason = ?REASON_xun_bao_period} || {DropCareer, 2, CfgId, _Bind, Amount} <- List,
				DropCareer =:= 0 orelse DropCareer =:= Career],
			{lists:append(ItemListRet, L1), lists:append(CurrencyListRet, L2)}
			  end,
		NotIndexList = [Index || {Index, _} <- PeriodFinishList],
		NotIndexLists = [NotIndexList | lists:duplicate(Count, [])],
		{ItemList, CurrencyList} = lists:foldl(Fun, {[], []}, NotIndexLists),        %% 奖励
		case ItemList =:= [] andalso CurrencyList =:= [] of
			?FALSE -> send_period_mail(Type, CurrencyList, ItemList);
			?TRUE -> ok
		end,
		{?ERROR_OK, NewData, IsRefresh andalso (ItemList =/= [] orelse CurrencyList =/= [])}
	catch
		Error -> {Error, Data, ?FALSE}
	end.

send_period_mail(?DATA_ID_2, CurrencyList, ItemList) ->
	PlayerID = player:getPlayerID(),
	Language = language:get_player_language(PlayerID),
	mail:send_mail(#mailInfo{
		player_id = PlayerID,
		senderID = 666,
		senderName = "Rune",
		title = language:get_server_string("Lyxb_yj1", Language),
		describe = language:get_server_string("Lyxb_yj2", Language),
		state = 0,
		sendTime = time:time(),
		isDirect = 0,
		multiple = 1,
		coinList = CurrencyList,
		itemList = ItemList,
		itemInstance = [],
		attachmentReason = ?REASON_xun_bao_period
	});
send_period_mail(?DATA_ID_3, CurrencyList, ItemList) ->
	PlayerID = player:getPlayerID(),
	Language = language:get_player_language(PlayerID),
	mail:send_mail(#mailInfo{
		player_id = PlayerID,
		senderID = 333,
		senderName = "zuoqi",
		title = language:get_server_string("ZQXB_yj1", Language),
		describe = language:get_server_string("ZQXB_yj2", Language),
		state = 0,
		sendTime = time:time(),
		isDirect = 0,
		multiple = 1,
		coinList = CurrencyList,
		itemList = ItemList,
		itemInstance = [],
		attachmentReason = ?REASON_xun_bao_period
	});
send_period_mail(?DATA_ID_4, CurrencyList, ItemList) ->
	PlayerID = player:getPlayerID(),
	Language = language:get_player_language(PlayerID),
	mail:send_mail(#mailInfo{
		player_id = PlayerID,
		senderID = 444,
		senderName = "chibang",
		title = language:get_server_string("CBXB_yj1", Language),
		describe = language:get_server_string("CBXB_yj2", Language),
		state = 0,
		sendTime = time:time(),
		isDirect = 0,
		multiple = 1,
		coinList = CurrencyList,
		itemList = ItemList,
		itemInstance = [],
		attachmentReason = ?REASON_xun_bao_period
	});
send_period_mail(?DATA_ID_7, CurrencyList, ItemList) ->
	PlayerID = player:getPlayerID(),
	Language = language:get_player_language(PlayerID),
	mail:send_mail(#mailInfo{
		player_id = PlayerID,
		senderID = 777,
		senderName = "ShengWen",
		title = language:get_server_string("Swxb_yj1", Language),
		describe = language:get_server_string("Swxb_yj2", Language),
		state = 0,
		sendTime = time:time(),
		isDirect = 0,
		multiple = 1,
		coinList = CurrencyList,
		itemList = ItemList,
		itemInstance = [],
		attachmentReason = ?REASON_xun_bao_period
	});
send_period_mail(?DATA_ID_9, CurrencyList, ItemList) ->
	PlayerID = player:getPlayerID(),
	Language = language:get_player_language(PlayerID),
	mail:send_mail(#mailInfo{
		player_id = PlayerID,
		senderID = 999,
		senderName = "shenhun",
		title = language:get_server_string("SHXB_yj1", Language),
		describe = language:get_server_string("SHXB_yj2", Language),
		state = 0,
		sendTime = time:time(),
		isDirect = 0,
		multiple = 1,
		coinList = CurrencyList,
		itemList = ItemList,
		itemInstance = [],
		attachmentReason = ?REASON_xun_bao_period
	});
send_period_mail(_, _, _) -> skip.


%%周期领奖-一次性全部领取
on_period_finish(DataId, 0, 0) ->
	try
		case is_open_action(DataId) of
			?TRUE -> ok;
			?FALSE -> throw(?ERROR_xun_bao_open)
		end,
		Data = get_new_data(DataId),
		#data{hot_id = PeriodId, period_num = PeriodNum, period_finish_list = PeriodFinishList} = Data,%%		[{Index, Choice}]
		RouletteTimeCfg = cfg_rouletteTime:row(PeriodId),
		Choice = RouletteTimeCfg#rouletteTimeCfg.num,
		AwardParaNew = case Choice of
						   1 ->
							   RouletteTimeCfg#rouletteTimeCfg.awardParaNew1;
						   2 ->
							   RouletteTimeCfg#rouletteTimeCfg.awardParaNew2
					   end,
		%%去掉之前已领取的
		CondParaList = [{I, N} || {I, N} <- RouletteTimeCfg#rouletteTimeCfg.condPara, lists:keyfind(I, 1, PeriodFinishList) =:= ?FALSE],
		Career = player:getCareer(),
		F = fun({I, Num}, {ItemListRet, CurrencyListRet, IndexListRet}) ->
			case PeriodNum >= Num of
				?TRUE ->
					L = [{P2, P3, P4, P5, P6} || {P1, P2, P3, P4, P5, P6} <- AwardParaNew, P1 =:= I],
					ItemLists = [{CfgId, Amount, Bind, 0} || {DropCareer, 1, CfgId, Bind, Amount} <- L,
						DropCareer =:= 0 orelse DropCareer =:= Career],
					CurrencyLists = [{CfgId, Amount} || {DropCareer, 2, CfgId, _Bind, Amount} <- L,
						DropCareer =:= 0 orelse DropCareer =:= Career],
					{ItemLists ++ ItemListRet, CurrencyLists ++ CurrencyListRet, [{I, Choice} | IndexListRet]};
				?FALSE -> {ItemListRet, CurrencyListRet, IndexListRet}
			end
			end,
		{ItemList, CurrencyList, IndexList} = lists:foldl(F, {[], [], []}, CondParaList),
		case IndexList of
			[] -> throw(?ERROR_xun_bao_period_finish_num);
			_ -> ok
		end,
		%% 寻宝仓库
		BagId = get_bag_id(DataId),
		{AddError, AddPrepared} = bag:add_prepare(BagId, ItemList),
		?ERROR_CHECK_THROW(AddError),
		%% 更新领奖记录
		NewPeriodFinishList = IndexList ++ PeriodFinishList,
		NewData = Data#data{period_finish_list = NewPeriodFinishList},
		update_data(NewData),
		%% 发放奖励
		Reason = ?REASON_xun_bao_period,
		bag:add_finish(BagId, AddPrepared, Reason),
		currency:add(CurrencyList, Reason),
		player_item:show_get_item_dialog_with_from(ItemList, CurrencyList, [], 0, 0, ?ShowDialogFrom_14),
		%% 返回应答
		player:send(#pk_GS2U_HeroDrawAddAward{data_id = DataId, draw_list = [#pk_HeroDrawFinishAward{index = I, choice = C} || {I, C} <- NewPeriodFinishList],
			errorCode = ?ERROR_OK})
	catch
		Error -> player:send(#pk_GS2U_HeroDrawAddAward{data_id = DataId, errorCode = Error})
	end;
%% 周期领奖
on_period_finish(DataId, Index, Choice) -> ?metrics(begin
														try
															case is_open_action(DataId) of
																?TRUE -> ok;
																?FALSE -> throw(?ERROR_xun_bao_open)
															end,
															Data = get_new_data(DataId),
															#data{hot_id = PeriodId, period_num = PeriodNum, period_finish_list = PeriodFinishList} = Data,
															%% 领奖条件
															case lists:keymember(Index, 1, PeriodFinishList) of
																?TRUE ->
																	throw(?ERROR_xun_bao_period_finish);
																?FALSE -> ok
															end,
															RouletteTimeCfg = cfg_rouletteTime:row(PeriodId),
															case lists:keyfind(Index, 1, RouletteTimeCfg#rouletteTimeCfg.condPara) of
																?FALSE ->
																	throw(?ERROR_xun_bao_period_finish_index);
																{_Index, NeedNum} when PeriodNum < NeedNum ->
																	throw(?ERROR_xun_bao_period_finish_num);
																{_Index, _NeedNum} -> ok
															end,
															%% 选择奖励
															Career = player:getCareer(),
															AwardParaNew = case Choice of
																			   1 ->
																				   RouletteTimeCfg#rouletteTimeCfg.awardParaNew1;
																			   2 ->
																				   RouletteTimeCfg#rouletteTimeCfg.awardParaNew2
																		   end,
															List = [{P2, P3, P4, P5, P6} || {P1, P2, P3, P4, P5, P6} <- AwardParaNew, P1 =:= Index],
															ItemList = [{CfgId, Amount, Bind, 0} || {DropCareer, 1, CfgId, Bind, Amount} <- List,
																DropCareer =:= 0 orelse DropCareer =:= Career],
															CurrencyList = [{CfgId, Amount} || {DropCareer, 2, CfgId, _Bind, Amount} <- List,
																DropCareer =:= 0 orelse DropCareer =:= Career],
															%% 寻宝仓库
															BagId = get_bag_id(DataId),
															{AddError, AddPrepared} = bag:add_prepare(BagId, ItemList),
															?ERROR_CHECK_THROW(AddError),
															%% 更新领奖记录
															NewPeriodFinishList = [{Index, Choice} | PeriodFinishList],
															NewData = Data#data{period_finish_list = NewPeriodFinishList},
															update_data(NewData),
															%% 发放奖励
															Reason = ?REASON_xun_bao_period,
															bag:add_finish(BagId, AddPrepared, Reason),
															currency:add(CurrencyList, Reason),
															player_item:show_get_item_dialog_with_from(ItemList, CurrencyList, [], 0, 0, ?ShowDialogFrom_14),
															%% 返回应答
															player:send(#pk_GS2U_HeroDrawAddAward{data_id = DataId, draw_list = [#pk_HeroDrawFinishAward{index = Index, choice = Choice}],
																errorCode = ?ERROR_OK})
														catch
															Error ->
																player:send(#pk_GS2U_HeroDrawAddAward{data_id = DataId, errorCode = Error})
														end end).

%% 寻宝记录
on_draw_record(DataId) -> ?metrics(begin
									   try
										   case is_open_action(DataId) of
											   ?TRUE -> ok;
											   ?FALSE -> throw(?ERROR_xun_bao_open)
										   end,
										   #data{record_list = RecordList} = get_new_data(DataId),
										   MyList = common:listsFiterMap(fun make_draw_record_msg/1, RecordList),
										   AllList = common:listsFiterMap(fun make_draw_record_msg/1, xun_bao_record:get_record_list(DataId)),
										   player:send(#pk_GS2U_HeroDrawRecord{data_id = DataId, myList = MyList, allList = AllList})
									   catch
										   _Error -> player:send(#pk_GS2U_HeroDrawRecord{data_id = DataId})
									   end end).
%%请求寻宝预览数据
on_preview_data(DataId) ->
	try
		case is_open_action(DataId) of
			?TRUE -> ok;
			?FALSE -> throw(1)
		end,
		Data = get_new_data(DataId),
		#data{level = Level, turn_id = Turn_Id} = Data,
		RouletteCfg = cfg_rouletteNew:getRow(DataId, Level, Turn_Id),
		PreviewBigList = [make_previewbig_msg(ID, Type, Cfg) || {Type, ID} <- RouletteCfg#rouletteNewCfg.previewBig, (Cfg = cfg_roulettePreviewBig:getRow(ID)) =/= {}],
		player:send(#pk_GS2U_PreviewBigListRet{data_id = DataId, previewBigList = PreviewBigList})
	catch
		_ ->
			player:send(#pk_GS2U_PreviewBigListRet{data_id = DataId, previewBigList = []})
	end.
%% 龙印寻宝预览
on_rune_show() -> ?metrics(begin
							   Career = player:getCareer(),
							   PlayerLevel = player:getLevel(),
							   F = fun(Id, Ret) ->
								   #rouletteRuneShowCfg{itemShow = ItemShow, lvLimit = LimitFlag} = cfg_rouletteRuneShow:row(Id),
								   IsSatisfied = case LimitFlag =:= 1 of
													 ?TRUE ->
														 RouletteNewCfg = cfg_rouletteNew:row({?DATA_ID_2, Id, 0}),
														 RouletteNewCfg =/= {} andalso RouletteNewCfg#rouletteNewCfg.lvLimit =< PlayerLevel;
													 ?FALSE ->
														 ?TRUE
												 end,
								   case IsSatisfied of
									   ?TRUE ->
										   Msg = #pk_HeroDrawRuneShow{
											   runeNum = Id,
											   itemShow = make_item_msg_list(ItemShow, Career),
											   currencyShow = make_currency_msg_list(ItemShow, Career)
										   },
										   [Msg | Ret];
									   ?FALSE ->
										   Ret
								   end
								   end,
							   List = lists:foldl(F, [], cfg_rouletteRuneShow:getKeyList()),
							   player:send(#pk_GS2U_HeroDrawRuneShow{list = List}) end).

%% 装备寻宝等级列表
on_equip_level_list() -> ?metrics(begin
									  try
										  DataId = ?DATA_ID_1,
										  case is_open_action(DataId) of
											  ?TRUE -> ok;
											  ?FALSE -> throw(?ERROR_xun_bao_open)
										  end,
										  #data{level = Level} = get_new_data(DataId),
										  IsAutoLevel = variable_player:get_value(?VARIABLE_PLAYER_xun_bao_choice_level) =:= 0,
										  MsgList = lists:map(
											  fun(#rouletteNewCfg{levelLimit = LevelLimit, preview = Preview, previewLimtLv = PreviewLimtLv}) ->
												  #pk_HeroDrawEquipLevel{levelLimit = LevelLimit, preview = Preview, previewLimtLv = PreviewLimtLv}
											  end, cfg_rouletteNew:rows()),
										  player:send(#pk_GS2U_HeroDrawEquipLevelList{levelLimit = Level, auto_level = IsAutoLevel, list = MsgList})
									  catch
										  Error -> Error
									  end end).

%% 装备寻宝等级修改
on_equip_level(ChoiceLevel, IsAutoLevel) -> ?metrics(begin
														 try
															 DataId = ?DATA_ID_1,
															 case is_open_action(DataId) of
																 ?TRUE -> ok;
																 ?FALSE -> throw(?ERROR_xun_bao_open)
															 end,
															 RouletteCfg = cfg_rouletteNew:row({DataId, ChoiceLevel, 0}),
															 case RouletteCfg =/= {} andalso player:getLevel() >= RouletteCfg#rouletteNewCfg.previewLimtLv of
																 ?TRUE -> ok;
																 ?FALSE -> throw(?ERROR_xun_bao_draw_level)
															 end,
															 Data = get_new_data(DataId),
															 NewData = Data#data{level = ChoiceLevel},
															 update_data(NewData),
															 send_data(NewData),
															 case IsAutoLevel of
																 ?TRUE ->
																	 variable_player:set_value(?VARIABLE_PLAYER_xun_bao_choice_level, 0);
																 ?FALSE ->
																	 variable_player:set_value(?VARIABLE_PLAYER_xun_bao_choice_level, 1)
															 end,
															 player:send(#pk_GS2U_HeroDrawEquipLevel{error = ?ERROR_OK})
														 catch
															 Error ->
																 player:send(#pk_GS2U_HeroDrawEquipLevel{error = Error})
														 end end).

%% 多次寻宝领奖
on_time_item_finish(DataId, TimeId) -> ?metrics(begin
													try
														case is_open_action(DataId) of
															?TRUE -> ok;
															?FALSE -> throw(?ERROR_xun_bao_open)
														end,
														Data = get_new_data(DataId),
														#data{level = Level, turn_id = TurnId, time_draw_award_time = TimeNumList} = Data,
														RouletteCfg = cfg_rouletteNew:row({DataId, Level, TurnId}),
														?CHECK_CFG(RouletteCfg),
														#rouletteNewCfg{rouletteTimeItemID = TimeIdList} = RouletteCfg,
														?CHECK_THROW(lists:member(TimeId, TimeIdList), ?ERROR_Param),
														TimeItemNum = get_roulette_time_item_num(TimeId),%%奖励次数
														Num = case lists:keyfind(TimeId, 1, TimeNumList) of%%当前次数
																  ?FALSE -> 0;
																  {_, P} -> P
															  end,
														%% 领奖条件
														case Num >= TimeItemNum of
															?TRUE -> ok;
															?FALSE -> throw(?ERROR_xun_bao_period_finish_num)
														end,
														RouletteTimeItemCfg = get_roulette_time_item_cfg(TimeId),
														case RouletteTimeItemCfg =/= {} of
															?TRUE -> ok;
															?FALSE -> throw(?ERROR_xun_bao_time_item_cfg)
														end,
														%%	领奖次数
														ReceiveNum = Num div TimeItemNum,
														%% 寻宝仓库
														DropTuple = drop:drop([{P1, P2, P3, P4 * ReceiveNum, P5} || {P1, P2, P3, P4, P5} <- RouletteTimeItemCfg#rouletteTimeItemCfg.award],
															[{P1, P2, P3, P4, P5 * ReceiveNum} || {P1, P2, P3, P4, P5} <- RouletteTimeItemCfg#rouletteTimeItemCfg.itemShow],
															player:getPlayerID(), player:getCareer(), player:getLevel()),
														{ItemList, EquipmentList, CurrencyList, _NoticeList} = DropTuple,
														GainPrepared = draw_gain_prepare(DataId, ItemList, EquipmentList, CurrencyList),
														NumTimeNumList = add_draw_num(TimeNumList, [TimeId], -TimeItemNum * ReceiveNum),%%新的累计寻宝次数,仅减少对应奖励id的次数
														%% 更新领奖记录
														Time = time:time(),
														NewData1 = add_record(Data#data{time_draw_award_time = NumTimeNumList}, ItemList, EquipmentList, CurrencyList, Time, ?RECORD_TYPE_EXCHANGE_3),
														update_data(NewData1),
														send_data(NewData1),
														%% 发放奖励
														draw_gain_finish(GainPrepared, ?REASON_xun_bao_time_item),
														player_item:show_get_item_dialog_with_from(ItemList, CurrencyList, EquipmentList, 0, 0, ?ShowDialogFrom_14),

														PlayerText = player:getPlayerText(),
														[{_, _, GetItemID, _, Count} | _] = RouletteTimeItemCfg#rouletteTimeItemCfg.itemShow,
														marquee:sendChannelNotice(0, 0, xBNotice3,
															fun(Language) ->
																language:format(language:get_server_string("XBNotice3", Language), [PlayerText, richText:getItemText(GetItemID, Count * ReceiveNum, Language)])
															end),
														%% 返回应答
														player:send(#pk_GS2U_HeroDrawTimeAward{data_id = DataId, errorCode = ?ERROR_OK})
													catch
														Error ->
															player:send(#pk_GS2U_HeroDrawTimeAward{data_id = DataId, time_id = TimeId, errorCode = Error})
													end end).

%% 每日重置 5点
on_reset() ->
	DataList = get_data_list(),
	F = fun(#data{today_draw_times = TodayDrawTimes} = Data) ->
		case TodayDrawTimes =/= 0 of
			?TRUE ->
				NewData = Data#data{today_draw_times = 0},
				update_data(NewData);
			?FALSE -> ok
		end
		end,
	lists:foreach(F, DataList).

%%泰坦寻宝 赛季改变时，未领取的奖励需要以邮件的方式发给玩家
on_taitan_reset(NewSeasonId, OldSeasonId) ->
	case OldSeasonId =:= NewSeasonId of
		?TRUE -> ok;%%赛季相同
		?FALSE ->%%赛季不同，出现了赛季变更，需要检查原来是否有这个新赛季的数据，有就清除，老赛季没领取的也需要领取，并加上领取记录
			%%每个赛季，泰坦寻宝积分70 都得重置
			case currency:get_delete_max(?CURRENCY_TaiTanXunBao) of
				0 -> ok;
				DeleteNum -> currency:delete(?CURRENCY_TaiTanXunBao, DeleteNum, ?REASON_xun_bao_taitan_reset)
			end,
			PlayerId = player:getPlayerID(),
			%%获取老赛季数据，以及领取记录和累计次数
			{[NowSeasonId, TaiTanTimeList, DrawRecordList], SeasonRecordList, OldTimeNum} = case player_private_list:get_value_ex(PlayerId, ?Private_List_TaiTanXunBaoTimeList) of
																								[] ->
																									{[OldSeasonId, [], []], [], 0};
																								[Id, OldTimeList, OldRecordList] = Info ->
																									RecordList = [{S, O} || {S, O} <- OldRecordList, S =:= Id],%%老赛季的领取记录
																									OldNum = case lists:keyfind(Id, 1, OldTimeList) of%%老赛季的累计次数
																												 {_, Value} ->
																													 Value;
																												 _ -> 0
																											 end,
																									{Info, RecordList, OldNum}
																							end,
			{AddRecord, ItemCfgList} = lists:foldl(fun({S, O}, {Acc, ItemListAcc}) ->
				case S =:= NowSeasonId of
					?TRUE ->
						case lists:member({S, O}, SeasonRecordList) of%%已领取
							?TRUE -> {Acc, ItemListAcc};
							_ ->
								#rouletteTimeItem2Cfg{times = Times, item = Item} = cfg_rouletteTimeItem2:getRow(S, O),
								case OldTimeNum >= Times of
									?TRUE -> {[{S, O} | Acc], Item ++ ItemListAcc};
									_ -> {Acc, ItemListAcc}
								end
						end;
					_ -> {Acc, ItemListAcc}
				end end, {[], []}, cfg_rouletteTimeItem2:getKeyList()),
			case ItemCfgList of
				[] -> ok;
				_ ->%%发送邮件
					PlayerCareer = player:getCareer(),
					CurrList = common:listValueMerge([{CurrType, CurrNum} || {Career, 2, CurrType, _, _, _, CurrNum} <- ItemCfgList, (Career =:= 0 orelse PlayerCareer =:= Career)]),
					ItemList = item:item_merge([{ItemID, Num, Bind} || {Career, 1, ItemID, _, _, Bind, Num} <- ItemCfgList, (Career =:= 0 orelse PlayerCareer =:= Career)]),
					EqList = eq:create_eq([{ItemID, Bind, Quality, Star} || {Career, 3, ItemID, Quality, Star, Bind, _} <- ItemCfgList, (Career =:= 0 orelse PlayerCareer =:= Career)]),
					Language = language:get_player_language(PlayerId),
					mail:send_mail(#mailInfo{
						player_id = PlayerId,
						senderName = "taitanxunbao",
						title = language:get_server_string("D3_Taitanxunbao_Mail_Title1", Language),
						describe = language:get_server_string("D3_Taitanxunbao_Mail_Desc1", Language),
						sendTime = time:time(),
						coinList = [#coinInfo{type = C, num = CN} || {C, CN} <- CurrList],
						itemList = [#itemInfo{itemID = Id, num = N, isBind = B} || {Id, N, B} <- ItemList],
						itemInstance = EqList,
						attachmentReason = ?REASON_xun_bao_taitan_draw
					})
			end,
			NewTaiTanTimeList = case lists:keyfind(NewSeasonId, 1, TaiTanTimeList) of%%如果新赛季在当前累计记录中也有，说明赛季已过一次了
									?FALSE -> TaiTanTimeList;
									_ -> lists:keydelete(NewSeasonId, 1, TaiTanTimeList)
								end,
			NewDrawRecordList = [{S, O} || {S, O} <- DrawRecordList, S =/= NewSeasonId] ++ AddRecord,
			player_private_list:set_value_ex(PlayerId, ?Private_List_TaiTanXunBaoTimeList, [NewSeasonId, NewTaiTanTimeList, NewDrawRecordList]),
			send_data(?DATA_ID_17)%%重置泰坦寻宝后，需要同步寻宝数据
	end.

%%领取泰坦奖励
on_taitan_receive(SeasonId, Oder) ->
	try
		?CHECK_THROW(is_open_action(?DATA_ID_17), ?ERROR_xun_bao_open),
		PlayerId = player:getPlayerID(),
		[NowSeasonId, TaiTanTimeList, DrawRecordList] = case player_private_list:get_value_ex(PlayerId, ?Private_List_TaiTanXunBaoTimeList) of
															[] -> throw(?ERROR_xun_bao_taitan_NoDraw);%%报错-没有可领取的奖励
															L -> L
														end,
		TimeNum = case NowSeasonId =/= SeasonId of%%当前赛季 累计泰坦寻宝次数
					  ?TRUE -> throw(?ERROR_xun_bao_taitan_NoSeason);
					  _ ->
						  case lists:keyfind(SeasonId, 1, TaiTanTimeList) of
							  {_, Value} -> Value;
							  _ -> 0
						  end
				  end,
		ReceiveList = case Oder of
						  0 ->%%全部领取
							  [{S, O} || {S, O} <- cfg_rouletteTimeItem2:getKeyList(), S =:= SeasonId];
						  _ -> [{SeasonId, Oder}]
					  end,
		{AddRecord, ItemCfgList} = lists:foldl(fun({Season, Order}, {AddRecordAcc, ItemListAcc}) ->
			#rouletteTimeItem2Cfg{times = Times, item = CfgList} = cfg_rouletteTimeItem2:getRow(Season, Order),
			case TimeNum >= Times andalso not lists:member({Season, Order}, DrawRecordList) of
				?TRUE ->
					{[{Season, Order} | AddRecordAcc], ItemListAcc ++ CfgList};
				_ -> {AddRecordAcc, ItemListAcc}
			end end, {[], []}, ReceiveList),
		case AddRecord of
			[] -> throw(?ERROR_xun_bao_taitan_NoDraw);
			_ -> ok
		end,
		PlayerCareer = player:getCareer(),
		CurrList = [{CurrType, CurrNum} || {Career, 2, CurrType, _, _, _, CurrNum} <- ItemCfgList, (Career =:= 0 orelse PlayerCareer =:= Career)],
		ItemList = [{ItemID, Num, Bind} || {Career, 1, ItemID, _, _, Bind, Num} <- ItemCfgList, (Career =:= 0 orelse PlayerCareer =:= Career)],
		EqList = eq:create_eq([{ItemID, Bind, Quality, Star} || {Career, 3, ItemID, Quality, Star, Bind, _} <- ItemCfgList, (Career =:= 0 orelse PlayerCareer =:= Career)]),
		player_item:reward(ItemList, EqList, CurrList, ?REASON_xun_bao_receive_draw),
		player_item:show_get_item_dialog(ItemList, CurrList, EqList, 0, 1),
		player_private_list:set_value_ex(PlayerId, ?Private_List_TaiTanXunBaoTimeList, [NowSeasonId, TaiTanTimeList, AddRecord ++ DrawRecordList]),
		send_data(?DATA_ID_17),
		player:send(#pk_GS2U_ReceiveTaiTanDrawRet{data_id = ?DATA_ID_17, season_id = SeasonId, oder = Oder})
	catch
		Error ->
			player:send(#pk_GS2U_ReceiveTaiTanDrawRet{data_id = ?DATA_ID_17, season_id = SeasonId, oder = Oder, errorCode = Error})
	end.

on_taitan_synthe(CfgId, Num) ->
	try
		?CHECK_THROW(is_open_action(?DATA_ID_17), ?ERROR_xun_bao_open),
		?CHECK_THROW(Num >= 0, ?ERROR_Param),
		Cfg = df:getItemDefineCfg(CfgId),
		?CHECK_CFG(Cfg),
		#itemCfg{detailedType3 = ItemSeasonId, detailedType = DetailedType} = Cfg,
		?CHECK_THROW(DetailedType =:= 258, ?ERROR_Param),
		SeasonId = border_war_player_bp:on_get_player_season(player:getPlayerID()),
		?CHECK_THROW(ItemSeasonId =/= SeasonId, ?ERROR_xun_bao_taitan_NotSynthe),
		RouletteCfg = cfg_rouletteNew:getRow(?DATA_ID_17, SeasonId, 0),
		?CHECK_CFG(Cfg),
		#rouletteNewCfg{consItem = ConsItem} = RouletteCfg,
		NewNum = Num div 2,
		CostNum = NewNum * 2,
		{ItemError, CostPrepare} = player:delete_cost_prepare([{CfgId, CostNum}], []),
		?ERROR_CHECK_THROW(ItemError),
		player:delete_cost_finish(CostPrepare, ?REASON_xun_bao_taitan_synthe),
		player_item:reward([{ConsItem, NewNum}], [], [], ?REASON_xun_bao_taitan_synthe),
		player_item:show_get_item_dialog([{ConsItem, NewNum}], [], [], 0, 1),
		player:send(#pk_GS2U_ReceiveTaiTanSyntheRet{cfg_id = CfgId, num = CostNum})
	catch
		Error ->
			player:send(#pk_GS2U_ReceiveTaiTanSyntheRet{cfg_id = CfgId, num = Num, errorCode = Error})
	end.

%% 仅用于领取表现 不存在实际物品的改变
on_get_draw_storage_item(TransferList) ->
	try
		F1 = fun({BagId, IdList0, TargetBagId}, CoinRet) ->
			IdList1 = lists:usort(IdList0),
			case TargetBagId of
				?BAG_XUN_BAO_1 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_2 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_3 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_4 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_5 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_6 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_7 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_8 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_9 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_10 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_11 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_12 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_13 -> throw(?ERROR_item_bag_param);
				?BAG_XUN_BAO_14 -> throw(?ERROR_item_bag_param);
				_ -> ok
			end,
			{IdList2, Coin, DelCoin} = lists:foldl(fun(Uid, {ItemAcc, CoinAcc, CoinUid}) ->
				case bag_player:get_bag_item(BagId, Uid) of
					{?ERROR_OK, [#item{cfg_id = CfgId, amount = N} | _]} ->
						CoinCfgId = CfgId - ?CoinItem,
						case lists:member(CoinCfgId, ?XunBaoCurrency) of
							?TRUE -> {ItemAcc, [{CoinCfgId, N} | CoinAcc], [Uid | CoinUid]};
							?FALSE -> {[Uid | ItemAcc], CoinAcc, CoinUid}
						end;
					_ -> throw(?ERROR_item_bag_find_item)
				end end, {[], [], []}, IdList1),
			RetErrCode = bag_player:transfer(BagId, IdList2, TargetBagId),
			?ERROR_CHECK_THROW(RetErrCode),
			bag_player:delete_item(BagId, DelCoin, ?REASON_xun_bao_draw),
			currency:add(Coin, ?REASON_xun_bao_draw),
			Coin ++ CoinRet
			 end,
		CoinList = lists:foldl(F1, [], TransferList),
		CoinMerge = common:listValueMerge(CoinList),
%% 用于表现
%%		F2 = fun({_, UidList, TargetBagId_}, Acc) ->
%%			lists:foldl(fun(Uid, Acc_) ->
%%				case bag_player:get_bag_item(TargetBagId_, Uid) of
%%					{?ERROR_OK, [#item{cfg_id = CfgID, amount = Amount}]} ->
%%						[{CfgID, Amount} | Acc_];
%%					_ -> Acc_
%%				end end, [], UidList) ++ Acc
%%			 end,
%%		%fixme 暂未处理 装备 货币 存在的情况
%%		GetItemList = common:listValueMerge(lists:foldl(F2, [], TransferList)),
%%		player_item:show_get_item_dialog_with_from(GetItemList, [], [], 0, 7, ?ShowDialogFrom_14),
		F2 = fun({_, UidList, TargetBagId_}, {ItemList, EqList}) ->
			lists:foldl(fun(Uid, {ItemList1, EqList1} = Acc1) ->
				case bag_player:get_bag_item(TargetBagId_, Uid) of
					{?ERROR_OK, [#item{cfg_id = CfgID, amount = Amount} = Item]} ->
						case eq:get_eq(Uid) of
							{} -> {[{CfgID, Amount} | ItemList1], EqList1};
							Eq -> {ItemList1, [{Item, Eq} | EqList1]}
						end;
					_ -> Acc1
				end end, {ItemList, EqList}, UidList)
			 end,
		{ItemList, EqList} = lists:foldl(F2, {[], []}, TransferList),
		GetItemList = common:listValueMerge(ItemList),
		player_item:show_get_item_dialog_with_from(GetItemList, CoinMerge, EqList, 0, 7, ?ShowDialogFrom_14),
		player:send(#pk_GS2U_GetDrawStorageItemRet{transfer_list = [#pk_BagTransfer{bag_type = BagID_, ids = IDList_, target_bag_type = TargetBagID_} || {BagID_, IDList_, TargetBagID_} <- TransferList], errorCode = ?ERROR_OK})
	catch
		ErrCode ->
			player:send(#pk_GS2U_GetDrawStorageItemRet{transfer_list = [#pk_BagTransfer{bag_type = BagID_, ids = IDList_, target_bag_type = TargetBagID_} || {BagID_, IDList_, TargetBagID_} <- TransferList], errorCode = ErrCode})
	end.

%% 任务获取符文寻宝次数
get_rune_draw_time() ->
	Data = get_new_data(?DATA_ID_2),
	get_draw_num(Data).
%% 任务获取宝石寻宝X次
get_gem_draw_time() ->
	Data = get_new_data(?DATA_ID_13),
	get_draw_num(Data).
%% 任务获取卡片寻宝X次
get_soul_card_draw_time() ->
	Data = get_new_data(?DATA_ID_14),
	get_draw_num(Data).
%% 任务获取黄金寻宝X次
get_pantheon_draw_time() ->
	Data = get_new_data(?DATA_ID_15),
	get_draw_num(Data).
%% 任务获取魂石寻宝X次
get_soul_stone_draw_time() ->
	Data = get_new_data(?DATA_ID_16),
	get_draw_num(Data).

get_draw_time(ID) ->
	Data = get_new_data(ID),
	get_draw_num(Data).

%%数据更新
fix_data_0913() ->
	Data13 = get_new_data(?DATA_ID_13),%%1
	Data16 = get_new_data(?DATA_ID_16),%%4
	Data15 = get_new_data(?DATA_ID_15),%%3
	#data{time_draw_award_time = OldTimeNumList13} = Data13,
	#data{time_draw_award_time = OldTimeNumList16} = Data16,
	#data{time_draw_award_time = OldTimeNumList15} = Data15,
	NewTimeNumList13 = case lists:keytake(2, 1, OldTimeNumList13) of
						   ?FALSE -> OldTimeNumList13;
						   {_, {2, Num1}, Lp} ->
							   [{1, Num1} | Lp]
					   end,
	NewTimeNumList16 = case lists:keytake(2, 1, OldTimeNumList16) of
						   ?FALSE -> OldTimeNumList16;
						   {_, {2, Num2}, Lp2} ->
							   [{4, Num2} | Lp2]
					   end,
	NewTimeNumList15 = case lists:keytake(2, 1, OldTimeNumList15) of
						   ?FALSE -> OldTimeNumList15;
						   {_, {2, Num3}, Lp3} ->
							   [{3, Num3} | Lp3]
					   end,
	List13 = common:listValueMerge(NewTimeNumList13),
	List16 = common:listValueMerge(NewTimeNumList16),
	List15 = common:listValueMerge(NewTimeNumList15),
	Data132 = Data13#data{time_draw_award_time = List13},
	Data162 = Data16#data{time_draw_award_time = List16},
	Data152 = Data15#data{time_draw_award_time = List15},
	update_data(Data132),
	update_data(Data162),
	update_data(Data152),
	send_data(Data132),
	send_data(Data162),
	send_data(Data152),
	0.
%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 进程字典
put_data_list(DataList) ->
	put(xun_bao_player_data_list, DataList).
get_data_list() ->
	case get(xun_bao_player_data_list) of
		?UNDEFINED -> [];
		DataList -> DataList
	end.

%% 当次连抽攒满幸运值时不重置
set_world_lucky_reset(Bool) ->
	put(xun_bao_player_world_lucky, Bool).
get_world_lucky_reset() ->
	case get(xun_bao_player_world_lucky) of
		?UNDEFINED -> ?TRUE;
		Bool -> Bool
	end.

%% 寻宝数据
get_data(DataId) ->
	DataList = get_data_list(),
	case lists:keyfind(DataId, #data.data_id, DataList) of
		?FALSE ->
			Level = get_draw_level(DataId),
			#data{data_id = DataId, level = Level, period_level = Level};
		Data ->
			Data
	end.
update_data(Data) ->
	PlayerId = player:getPlayerID(),
	table_player:insert(?TABLE_DATA,
		#db_xun_bao_player{
			player_id = PlayerId,
			data_id = Data#data.data_id,                %% 寻宝Id
			level = Data#data.level,                  %% 寻宝等级
			hot_id = Data#data.hot_id,                    %% 热点ID
			turn_id = Data#data.turn_id,                %% 轮换大奖ID
			free_time = Data#data.free_time,              %% 免费开始时间
			draw_num = Data#data.draw_num,               %% 单抽次数
			draw_ten_num = Data#data.draw_ten_num,           %% 十连次数
			score = Data#data.score,                  %% 积分
			period_time = Data#data.period_time,            %% 周期结束时间
			period_level = Data#data.period_level,           %% 周期等级
			period_num = Data#data.period_num,             %% 周期次数
			period_finish_list = term_to_binary(Data#data.period_finish_list),    %% 周期领奖列表 [{Index, Choice}]
			record_list = term_to_binary(Data#data.record_list),            %% 记录列表
			person_lucky = Data#data.person_lucky,                        %% 个人幸运值
			time_draw_award_time = gamedbProc:term_to_dbstring(Data#data.time_draw_award_time),        %%  多次寻宝累计次数
			first_tens = Data#data.first_tens,                        %% 首次连抽
			drop_num_list = gamedbProc:term_to_dbstring(Data#data.drop_num_list),            %% 掉落次数列表 [{DropId, Num}]
			today_draw_times = Data#data.today_draw_times            %% 今日抽奖次数
		}),
	DataList = get_data_list(),
	NewDataList = lists:keystore(Data#data.data_id, #data.data_id, DataList, Data),
	put_data_list(NewDataList).

%% 寻宝等级
get_draw_level(DataId) when DataId =:= ?DATA_ID_2 ->
	RuneScore = fazhen:get_max_score(),
	LevelList = [KeyLevel || {KeyID, KeyLevel, _TurnID} <- cfg_rouletteNew:getKeyList(), KeyID =:= DataId],
	common:listFind(fun(KeyLevel) -> KeyLevel =< RuneScore end, lists:reverse(LevelList), 0);
get_draw_level(DataId) when DataId =:= ?DATA_ID_14 ->
	Level = player:getReinLevel(),
	LevelList = [KeyLevel || {KeyID, KeyLevel, _TurnID} <- cfg_rouletteNew:getKeyList(), KeyID =:= DataId],
	common:listFind(fun(KeyLevel) -> KeyLevel =< Level end, lists:reverse(LevelList), 0);
get_draw_level(DataId) when DataId =:= ?DATA_ID_17 ->
	Level = border_war_player_bp:on_get_player_season(player:getPlayerID()),
	LevelList = [KeyLevel || {KeyID, KeyLevel, _TurnID} <- cfg_rouletteNew:getKeyList(), KeyID =:= DataId],
	common:listFind(fun(KeyLevel) -> KeyLevel =:= Level end, lists:reverse(LevelList), 0);
get_draw_level(DataId) ->
	Level = player:getLevel(),
	LevelList = [KeyLevel || {KeyID, KeyLevel, _TurnID} <- cfg_rouletteNew:getKeyList(), KeyID =:= DataId],
	common:listFind(fun(KeyLevel) -> KeyLevel =< Level end, lists:reverse(LevelList), 0).

%% 寻宝次数
get_draw_num(Data) ->
	#data{draw_num = DrawNum, draw_ten_num = DrawTenNum} = Data,
	DrawNum + DrawTenNum.

%% 新的寻宝配置
get_new_roulette_cfg(DataId, _RouletteCfg) when DataId =:= ?DATA_ID_1 ->
	cfg_rouletteNew:row({DataId, get_draw_level(DataId), 0});
get_new_roulette_cfg(_DataId, RouletteCfg) ->
	RouletteCfg.

%% 多次寻宝奖励次数
get_roulette_time_item_num(0) ->
	0;
get_roulette_time_item_num(Id) ->
	hd([KeyNum || {KeyID, KeyNum} <- cfg_rouletteTimeItem:getKeyList(), KeyID =:= Id]).

%% 多次寻宝配置
get_roulette_time_item_cfg(0) ->
	{};
get_roulette_time_item_cfg(Id) ->
	NumList = [KeyNum || {KeyID, KeyNum} <- cfg_rouletteTimeItem:getKeyList(), KeyID =:= Id],
	KeyNum = hd(NumList),
	cfg_rouletteTimeItem:row({Id, KeyNum}).

%%泰坦寻宝，记录赛季累计次数
add_taitan_all_num(SeasonId, DrawTime) ->
	PlayerId = player:getPlayerID(),
	[_, TaiTanTimeList, DrawRecordList] = case player_private_list:get_value_ex(PlayerId, ?Private_List_TaiTanXunBaoTimeList) of
											  [] -> [SeasonId, [], []];
											  Info -> Info
										  end,
	NewTaiTanTimeList = case lists:keyfind(SeasonId, 1, TaiTanTimeList) of
							{_, OldTimes} ->
								lists:keystore(SeasonId, 1, TaiTanTimeList, {SeasonId, OldTimes + DrawTime});
							_ -> [{SeasonId, DrawTime} | TaiTanTimeList]
						end,
	NewTaiTanXunBaoTimeList = [SeasonId, NewTaiTanTimeList, DrawRecordList],
	player_private_list:set_value_ex(PlayerId, ?Private_List_TaiTanXunBaoTimeList, NewTaiTanXunBaoTimeList).

%% 抽签算法，返回{Error, NewData, Result}
%% Result = {GiftItemList, GiftCurrencyList, DrawItemList, DrawEquipmentList, DrawCurrencyList}
draw(Data, Time, IsFree, 1) -> %% 单抽
	try
		#data{data_id = DataId, level = Level, turn_id = TurnId, draw_num = DrawNum, period_num = PeriodNum,
			person_lucky = PersonLuckyNum, time_draw_award_time = TimeNumList, today_draw_times = TodayTimes} = Data,
		RouletteCfg = cfg_rouletteNew:row({DataId, Level, TurnId}),
		PlayerId = player:getPlayerID(),
		Career = player:getCareer(),
		PlayerLevel = player:getLevel(),
		%% 检查免费时间
		NewFreeTime = check_draw_free(Data, Time, RouletteCfg#rouletteNewCfg.freeOnce, IsFree),

		%% 检查VIP次数 注意检查顺序 免费次数不计入VIP限次里面
		?CHECK_THROW(check_draw_times(DataId, IsFree, 1, TodayTimes), ?ERROR_xun_bao_today_times_limit),

		%% vip筛选
		VipLv = vip:get_vip_lv(),
		DrawNumList = [{Num, Cons} || {LvF, LvC, Num, Cons} <- RouletteCfg#rouletteNewCfg.numb, LvF =< VipLv, VipLv =< LvC orelse LvC == 0],

		%% 消耗道具
		{Err, ConsNum} = case lists:keyfind(1, 1, DrawNumList) of
							 {1, Num1} -> {?ERROR_OK, Num1};
							 _ -> {?ERROR_Cfg, 0} end,
		?ERROR_CHECK_THROW(Err),
		CostPrepared = draw_cost_prepare(RouletteCfg#rouletteNewCfg.consItem, RouletteCfg#rouletteNewCfg.consItem2, ConsNum, IsFree),
		%% 固定产出
		GiftItemList = [{CfgId, Amount, Bind, 0} || {DropCareer, 1, CfgId, Bind, Amount} <- RouletteCfg#rouletteNewCfg.item,
			DropCareer =:= 0 orelse DropCareer =:= Career],
		GiftCurrencyList = [{CfgId, Amount} || {DropCareer, 2, CfgId, _Bind, Amount} <- RouletteCfg#rouletteNewCfg.item,
			DropCareer =:= 0 orelse DropCareer =:= Career],
		%% 抽签产出
		Num = get_draw_num(Data),
		{EquipAward, NewPersonLuckyNum} =
			case DrawNum of
				0 ->
					{roulette(RouletteCfg#rouletteNewCfg.firstTime, RouletteCfg), PersonLuckyNum + RouletteCfg#rouletteNewCfg.luck};
				1 ->
					{roulette(RouletteCfg#rouletteNewCfg.secondTime, RouletteCfg), PersonLuckyNum + RouletteCfg#rouletteNewCfg.luck};
				_ -> roulette(RouletteCfg, Num + 1, Career, PersonLuckyNum + RouletteCfg#rouletteNewCfg.luck)
			end,

		DropTuple = drop:drop(EquipAward, [], PlayerId, Career, PlayerLevel),
		{OldDrawItemList, DrawEquipmentList, DrawCurrencyList, _NoticeList} = DropTuple,
		DrawItemList0 = get_rune_change(RouletteCfg, PlayerLevel, OldDrawItemList),
		%% 判断是否为大奖 TODO 仅判断了道具作为大奖的情况 若之后有装备及货币的大奖需要修改
		RareItemIDList = [I || {_, I, _, _, _} <- RouletteCfg#rouletteNewCfg.awardShow],
		{DrawItemList, DrawRareItemList} =
			lists:foldl(fun({I, _, _, _} = Item, {ItemListAcc, RareItemListAcc}) ->
				case lists:member(I, RareItemIDList) of
					?TRUE ->
						{ItemListAcc, [Item | RareItemListAcc]};
					?FALSE ->
						{[Item | ItemListAcc], RareItemListAcc}
				end end, {[], []}, DrawItemList0),

		ResultMsg = make_draw_result_msg(DrawItemList0, DrawEquipmentList, DrawCurrencyList),
		%% 检查仓库容量
		GainPrepared = draw_gain_prepare(DataId, GiftItemList ++ DrawItemList0, DrawEquipmentList, GiftCurrencyList ++ DrawCurrencyList),
		%% 扣除消耗
		Reason = ?REASON_xun_bao_draw,
		draw_cost_finish(CostPrepared, Reason, IsFree),
		%% 发放产出
		draw_gain_finish(GainPrepared, Reason),
		%% 任务
		daily_task:add_daily_task_goal(?DailyTask_Goal_40, 1, ?DailyTask_CountType_Default),
		add_active_condition(DataId, 1),
		update_task(DataId, 1),
		activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBao, 1),
		player_task:update_task([?Task_Goal_Roulette], {1, DataId}),
		NumTimeNumList = add_draw_num(TimeNumList, RouletteCfg#rouletteNewCfg.rouletteTimeItemID, 1),%%增加寻宝累计次数
		%% 返回
		Data1 = get_new_data(DataId),
		NewData = Data1#data{free_time = NewFreeTime, draw_num = DrawNum + 1, period_num = PeriodNum + 1,
			time_draw_award_time = NumTimeNumList, person_lucky = NewPersonLuckyNum, today_draw_times = common:getTernaryValue(IsFree, TodayTimes, TodayTimes + 1)},
		Result = {GiftItemList, GiftCurrencyList, DrawItemList, DrawRareItemList, DrawEquipmentList, DrawCurrencyList, [ResultMsg]},
		{?ERROR_OK, NewData, Result}
	catch
		Error -> {Error, Data, {}}
	end;
draw(Data, _Time, _IsFree, DrawNum) -> %% 非单抽
	try
		#data{data_id = DataId, level = Level, turn_id = TurnId, draw_ten_num = DrawTenNum, period_num = PeriodNum,
			person_lucky = PersonLuckyNum, time_draw_award_time = TimeNumList, first_tens = FirstInfo, today_draw_times = TodayTimes} = Data,
		RouletteCfg = cfg_rouletteNew:row({DataId, Level, TurnId}),
		PlayerId = player:getPlayerID(),
		Career = player:getCareer(),
		PlayerLevel = player:getLevel(),
		?CHECK_THROW(check_draw_times(DataId, ?FALSE, DrawNum, TodayTimes), ?ERROR_xun_bao_today_times_limit),

		%% vip筛选
		VipLv = vip:get_vip_lv(),
		DrawNumList = [{Num, Cons} || {LvF, LvC, Num, Cons} <- RouletteCfg#rouletteNewCfg.numb, LvF =< VipLv, VipLv =< LvC orelse LvC == 0],

		%% 消耗道具
		{Err, ConsNum} = case lists:keyfind(DrawNum, 1, DrawNumList) of
							 {DrawNum, Num1} -> {?ERROR_OK, Num1};
							 _ -> {?ERROR_Cfg, 0} end,
		?ERROR_CHECK_THROW(Err),
		CostPrepared = draw_cost_prepare(RouletteCfg#rouletteNewCfg.consItem, RouletteCfg#rouletteNewCfg.consItem2, ConsNum, ?FALSE),
		%% 固定产出
		GiftItemList = [{CfgId, Amount * DrawNum, Bind, 0} || {DropCareer, 1, CfgId, Bind, Amount} <- RouletteCfg#rouletteNewCfg.item,
			DropCareer =:= 0 orelse DropCareer =:= Career],
		GiftCurrencyList = [{CfgId, Amount * DrawNum} || {DropCareer, 2, CfgId, _Bind, Amount} <- RouletteCfg#rouletteNewCfg.item,
			DropCareer =:= 0 orelse DropCareer =:= Career],
		%% 抽签产出
		Num = get_draw_num(Data),
		{OldDrawEquipAwardList, NewPersonLuckyNum} = lists:foldl(
			fun(N, {DrawEquipAwardList1, PersonLucky}) ->
				{EquipAward, NewPersonLucky} = roulette(RouletteCfg, Num + N, Career, PersonLucky + RouletteCfg#rouletteNewCfg.luck),
				{EquipAward ++ DrawEquipAwardList1, NewPersonLucky}
			end, {[], PersonLuckyNum}, lists:seq(1, DrawNum)),
		%% 替换首抽奖励
		Data1 = get_new_data(DataId),
		{NewDrawEquipAwardList, Data2} =
			case variant:isBitOn(FirstInfo, DrawNum div 10) of
				?FALSE when DrawNum =:= 10 ->
					List = get_first_change(OldDrawEquipAwardList, RouletteCfg#rouletteNewCfg.firstTenTime, RouletteCfg#rouletteNewCfg.commWeight),
					{List, Data1#data{first_tens = variant:setBit(FirstInfo, DrawNum div 10, 1)}};
				?FALSE when DrawNum =:= 20 ->
					List = get_first_change(OldDrawEquipAwardList, RouletteCfg#rouletteNewCfg.firstDoubleTenTime, RouletteCfg#rouletteNewCfg.commWeight),
					{List, Data1#data{first_tens = variant:setBit(FirstInfo, DrawNum div 10, 1)}};
				?FALSE when DrawNum =:= 30 ->
					List = get_first_change(OldDrawEquipAwardList, RouletteCfg#rouletteNewCfg.thirtyTime, RouletteCfg#rouletteNewCfg.commWeight),
					{List, Data1#data{first_tens = variant:setBit(FirstInfo, DrawNum div 10, 1)}};
				?FALSE when DrawNum =:= 50 ->
					List = get_first_change(OldDrawEquipAwardList, RouletteCfg#rouletteNewCfg.fiftyTime, RouletteCfg#rouletteNewCfg.commWeight),
					{List, Data1#data{first_tens = variant:setBit(FirstInfo, DrawNum div 10, 1)}};
				_ -> {OldDrawEquipAwardList, Data1}
			end,
		{DrawItemList0, DrawEquipmentList, DrawCurrencyList} = lists:foldl(
			fun(EquipAward, {DrawItemList1, DrawEquipmentList1, DrawCurrencyList1}) ->
				DropTuple = drop:drop([EquipAward], [], PlayerId, Career, PlayerLevel),
				{OldDrawItemList, DrawEquipmentList2, DrawCurrencyList2, _NoticeList} = DropTuple,
				DrawItemList2 = get_rune_change(RouletteCfg, PlayerLevel, OldDrawItemList),
				DrawItemList3 = DrawItemList1 ++ DrawItemList2,
				DrawEquipmentList3 = DrawEquipmentList1 ++ DrawEquipmentList2,
				DrawCurrencyList3 = DrawCurrencyList1 ++ DrawCurrencyList2,
				{DrawItemList3, DrawEquipmentList3, DrawCurrencyList3}
			end, {[], [], []}, NewDrawEquipAwardList),

		RareItemIDList = [I || {_, I, _, _, _} <- RouletteCfg#rouletteNewCfg.awardShow],
		{DrawItemList, DrawRareItemList} =
			lists:foldl(fun({I, _, _, _} = Item, {ItemListAcc, RareItemListAcc}) ->
				case lists:member(I, RareItemIDList) of
					?TRUE ->
						{ItemListAcc, [Item | RareItemListAcc]};
					?FALSE ->
						{[Item | ItemListAcc], RareItemListAcc}
				end end, {[], []}, DrawItemList0),

		ResultMsgList = make_draw_result_msg(DrawItemList0, DrawEquipmentList, DrawCurrencyList),
		%% 检查仓库容量
		GainPrepared = draw_gain_prepare(DataId, GiftItemList ++ DrawItemList0, DrawEquipmentList, GiftCurrencyList ++ DrawCurrencyList),
		%% 扣除消耗
		Reason = ?REASON_xun_bao_draw,
		draw_cost_finish(CostPrepared, Reason, ?FALSE),
		%% 发放产出
		draw_gain_finish(GainPrepared, Reason),
		%% 任务
		daily_task:add_daily_task_goal(?DailyTask_Goal_40, DrawNum, ?DailyTask_CountType_Default),
		add_active_condition(DataId, DrawNum),
		update_task(DataId, DrawNum),
		activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBao, DrawNum),
		player_task:update_task([?Task_Goal_Roulette], {DrawNum, DataId}),
		NumTimeNumList = add_draw_num(TimeNumList, RouletteCfg#rouletteNewCfg.rouletteTimeItemID, DrawNum),%%增加寻宝累计次数
		%% 返回
		NewData = Data2#data{draw_ten_num = DrawTenNum + DrawNum, period_num = PeriodNum + DrawNum,
			time_draw_award_time = NumTimeNumList, person_lucky = NewPersonLuckyNum, today_draw_times = TodayTimes + DrawNum},
		Result = {GiftItemList, GiftCurrencyList, DrawItemList, DrawRareItemList, DrawEquipmentList, DrawCurrencyList, [ResultMsgList]},
		{?ERROR_OK, NewData, Result}
	catch
		Error -> {Error, Data, {}}
	end.

%%
check_draw_free(Data, Time, FreeOnce, ?TRUE) -> %% 免费
	case FreeOnce > 0 of
		?TRUE -> ok;
		?FALSE -> throw(?ERROR_xun_bao_draw_free)
	end,
	case Time + 10 >= Data#data.free_time of
		?TRUE -> ok;
		?FALSE -> throw(?ERROR_xun_bao_draw_free)
	end,
	Time + FreeOnce;
check_draw_free(Data, _Time, _FreeOnce, _IsFree) ->
	Data#data.free_time.
%%
%% 优先ConsItem1 不足使用ConsItem2
draw_cost_prepare(_ConsItem1, _ConsItem2, _ConsNumb, ?TRUE) -> %% 免费
	{};
draw_cost_prepare(ConsItem1, ConsItem2, ConsNumb, _IsFree) ->
	CostList = check_cost_item(ConsItem1, ConsItem2, ConsNumb),
	{Error, Prepared} = bag_player:delete_prepare(CostList),
	?ERROR_CHECK_THROW(Error),
	Prepared.

check_cost_item(ConsItemID1, ConsItemID2, NeedNum) ->
	Num = bag_player:get_item_amount(ConsItemID1),
	case Num >= NeedNum of
		?TRUE ->
			[{ConsItemID1, NeedNum}];
		_ ->
			[{ConsItemID1, Num}, {ConsItemID2, NeedNum - Num}]
	end.

draw_cost_finish(_Prepared, _Reason, ?TRUE) -> %% 免费
	ok;
draw_cost_finish(Prepared, Reason, _IsFree) ->
	bag_player:delete_finish(Prepared, Reason).
%%
draw_gain_prepare(DataId, List, EquipmentList, CurrencyList) ->
	BagId = get_bag_id(DataId),
	{ItemList, EquipList} = lists:unzip(EquipmentList),
	NewList = [{CfgId, Amount, Bind} || #item{cfg_id = CfgId, bind = Bind, amount = Amount} <- ItemList] ++ List,
	{Error, _Prepared} = bag:add_prepare(BagId, NewList),
	?ERROR_CHECK_THROW(Error),
	{BagId, List, ItemList, EquipList, CurrencyList}.
draw_gain_finish(Prepared, Reason) ->
	{BagId, List, ItemList, EquipList, CurrencyList} = Prepared,
	case List =/= [] of
		?TRUE -> bag:add_raw(BagId, List, Reason);
		?FALSE -> ok
	end,
	case ItemList =/= [] of
		?TRUE -> bag:add_item_raw(BagId, ItemList, Reason);
		?FALSE -> ok
	end,
	eq:add_eq_ins_list(EquipList),
	currency:add([{C, N} || {C, N} <- CurrencyList, not lists:member(C, ?XunBaoCurrency)], Reason),
	case CurrencyList =/= [] of
		?TRUE ->
			bag:add_raw(BagId, [{?CoinItem + Currency, N} || {Currency, N} <- CurrencyList, lists:member(Currency, ?XunBaoCurrency)], Reason);
		?FALSE -> ok
	end.

%% 转盘算法，返回 EquipAward
%% 判断特殊情况：个人幸运是否满
roulette(RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	if
		PersonLuckyNum =:= RouletteCfg#rouletteNewCfg.luckMax andalso RouletteCfg#rouletteNewCfg.luckMax =/= 0 ->
			%% 个人幸运满获得大奖
			world_lucky_add(RouletteCfg),
			{do_roulette(RouletteCfg#rouletteNewCfg.luckWeight, MyCareer), 0};
		?TRUE ->
			roulette1(?SPEC_REWARD, RouletteCfg, Num, MyCareer, PersonLuckyNum)
	end.

%% 特殊掉落
roulette([], RouletteCfg) ->
	MyCareer = player:getCareer(),
	do_roulette(RouletteCfg#rouletteNewCfg.commWeight, MyCareer);
roulette(DropList, RouletteCfg) ->
	world_lucky_add(RouletteCfg),
	[{Career, DropId, Bind, 1, 10000} || {Career, DropId, Bind} <- DropList].

%% 判断是否到累计的连抽掉落
roulette1([], RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	do_roulette_spec(RouletteCfg, Num, MyCareer, PersonLuckyNum);
roulette1([NeedNum | List], RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	if
		Num rem NeedNum =:= 0 -> roulette2(NeedNum, List, RouletteCfg, Num, MyCareer, PersonLuckyNum);
		true -> roulette1(List, RouletteCfg, Num, MyCareer, PersonLuckyNum)
	end.

%% 不同档位的累计连抽掉落
roulette2(10, List, RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	world_lucky_add(RouletteCfg),
	case RouletteCfg#rouletteNewCfg.tenWeight of
		[] -> roulette1(List, RouletteCfg, Num, MyCareer, PersonLuckyNum);
		Cfg -> {do_roulette(Cfg, MyCareer), PersonLuckyNum}
	end;
roulette2(20, List, RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	world_lucky_add(RouletteCfg),
	case RouletteCfg#rouletteNewCfg.doubleTenWeight of
		[] -> roulette1(List, RouletteCfg, Num, MyCareer, PersonLuckyNum);
		Cfg -> {do_roulette(Cfg, MyCareer), PersonLuckyNum}
	end;
roulette2(30, List, RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	world_lucky_add(RouletteCfg),
	case RouletteCfg#rouletteNewCfg.thirtyWeight of
		[] -> roulette1(List, RouletteCfg, Num, MyCareer, PersonLuckyNum);
		Cfg -> {do_roulette(Cfg, MyCareer), PersonLuckyNum}
	end;
roulette2(50, List, RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	world_lucky_add(RouletteCfg),
	case RouletteCfg#rouletteNewCfg.fiftyWeight of
		[] -> roulette1(List, RouletteCfg, Num, MyCareer, PersonLuckyNum);
		Cfg -> {do_roulette(Cfg, MyCareer), PersonLuckyNum}
	end;
roulette2(_, List, RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	roulette1(List, RouletteCfg, Num, MyCareer, PersonLuckyNum).

%% 指定配置的掉落
do_roulette(WeightDropList, MyCareer) ->
	WeightValueList = [{Weight, {Career, DropId, Bind}} || {Career, DropId, Bind, Weight} <- WeightDropList, Career =:= 0 orelse Career =:= MyCareer],
	{Career, DropId, Bind} = common:getRandomValueFromWeightList(WeightValueList, {0, 0, 0}),
	[{Career, DropId, Bind, 1, 10000}].

%% 判断是否可以抽出大奖，
do_roulette_spec(RouletteCfg, Num, MyCareer, PersonLuckyNum) ->
	Data = get_data(RouletteCfg#rouletteNewCfg.type),
	{Career, DropId, Bind} = do_roulette_spec2(Num, MyCareer, RouletteCfg, Data#data.drop_num_list, RouletteCfg#rouletteNewCfg.specWeight),
	%% 世界幸运值修改
	case lists:keymember(DropId, 2, RouletteCfg#rouletteNewCfg.weightAdd) of
		?TRUE -> world_lucky_reset(RouletteCfg);
		?FALSE -> world_lucky_add(RouletteCfg)
	end,
	case DropId > 0 of
		?TRUE ->
			%% 特殊掉落列表修改
			NewDropNumList = lists:keystore(DropId, 1, Data#data.drop_num_list, {DropId, Num}),
			update_data(Data#data{drop_num_list = NewDropNumList}),
			%% 个人幸运值修改
			case lists:keymember(DropId, 2, RouletteCfg#rouletteNewCfg.luckWeight) of
				?TRUE -> {[{Career, DropId, Bind, 1, 10000}], 0};
				?FALSE -> {[{Career, DropId, Bind, 1, 10000}], PersonLuckyNum}
			end;
		?FALSE ->
			{do_roulette(RouletteCfg#rouletteNewCfg.commWeight, MyCareer), PersonLuckyNum}
	end.

%% 判断是否为特殊掉落
do_roulette_spec2(_Num, _MyCareer, _RouletteCfg, _DropNumList, []) -> {0, 0, 0};
do_roulette_spec2(Num, MyCareer, RouletteCfg, DropNumList, [{Career, DropId, Bind, Weight, N} | List]) ->
	if
		Career =:= 0 orelse Career =:= MyCareer ->
			DropNum = case lists:keyfind(DropId, 1, DropNumList) of
						  ?FALSE -> N;
						  {_DropId, M} -> M + N
					  end,
			case Num >= DropNum of
				?TRUE ->
					MewWeight =
						%% 判断是否享受火力全开加成
					case get_world_lucky(RouletteCfg, MyCareer) of
						[] -> Weight;
						[{W, DId}] when DId =:= DropId -> Weight + W;
						_ -> Weight
					end,
					case common:getRandomValueFromWeightList([{10000 - MewWeight, {0, 0, 0}}, {MewWeight, {Career, DropId, Bind}}], {0, 0, 0, 0}) of
						{0, 0, 0} -> do_roulette_spec2(Num, MyCareer, RouletteCfg, DropNumList, List);
						Reward -> Reward
					end;
				?FALSE -> do_roulette_spec2(Num, MyCareer, RouletteCfg, DropNumList, List)
			end;
		?TRUE -> do_roulette_spec2(Num, MyCareer, RouletteCfg, DropNumList, List)
	end.

world_lucky_add(RouletteCfg) ->
	LuckyNum = variable_world:get_value(?WorldVariant_XunBaoLucky),
	AddLucky = RouletteCfg#rouletteNewCfg.allLuck,
	case RouletteCfg#rouletteNewCfg.allLuck of
		0 -> skip;
		AddLucky -> Max = RouletteCfg#rouletteNewCfg.allLuckMax,
			case LuckyNum =:= min(LuckyNum + AddLucky, Max) of
				?TRUE -> skip;
				?FALSE ->
					case LuckyNum + AddLucky >= Max of
						?TRUE -> variable_world:set_value(?WorldVariant_XunBaoLucky, Max),
							world_lucky_full_notice(),
							set_world_lucky_reset(?FALSE);
						?FALSE -> variable_world:set_value(?WorldVariant_XunBaoLucky, LuckyNum + AddLucky)
					end
			end
	end.

%% 世界幸运值满了就重置，未满则增加
world_lucky_reset(RouletteCfg) ->
	LuckyNum = variable_world:get_value(?WorldVariant_XunBaoLucky),
	case RouletteCfg#rouletteNewCfg.allLuck of
		0 -> skip;
		AddLucky ->
			Max = RouletteCfg#rouletteNewCfg.allLuckMax,
			IsReset = get_world_lucky_reset(),
			if
				LuckyNum =:= Max andalso IsReset -> variable_world:set_value(?WorldVariant_XunBaoLucky, 0);
				LuckyNum =:= Max -> skip;
				true -> case LuckyNum + AddLucky >= Max of
							?TRUE -> variable_world:set_value(?WorldVariant_XunBaoLucky, Max),
								world_lucky_full_notice(),
								set_world_lucky_reset(?FALSE);
							?FALSE -> variable_world:set_value(?WorldVariant_XunBaoLucky, LuckyNum + AddLucky)
						end
			end
	end.

world_lucky_full_notice() ->
	marquee:sendChannelNotice(0, 0, d2Y_XB_Notice1,
		fun(Language) -> language:format(language:get_server_string("D2Y_XB_Notice1", Language), []) end).

%% 抽奖时如果幸运值已满，则增加概率
get_world_lucky(RouletteCfg, MyCareer) ->
	LuckyNum = variable_world:get_value(?WorldVariant_XunBaoLucky),
	Max = RouletteCfg#rouletteNewCfg.allLuckMax,
	if
		LuckyNum =:= Max andalso Max =/= 0 ->
			[{Weight, DropId} || {Career, DropId, _Bind, Weight, _} <-
				RouletteCfg#rouletteNewCfg.weightAdd, Career =:= 0 orelse Career =:= MyCareer];
		true -> []
	end.

%% 网络消息
make_draw_info_msg(Data) ->
	#data{data_id = DataId, level = Level, turn_id = TurnId, free_time = FreeTime, period_num = PeriodNum,
		period_finish_list = PeriodFinishList, person_lucky = PersonLucky, time_draw_award_time = TimeNumList, today_draw_times = TodayDrawTimes} = Data,
	NewFreeTime = case cfg_rouletteNew:row({DataId, Level, TurnId}) of
					  RouletteCfg when RouletteCfg#rouletteNewCfg.freeOnce > 0 -> FreeTime;
					  _ -> 2147483647
				  end,
	ParamList = case DataId of
					?DATA_ID_17 ->
						[_, ParamTimeList, DrawRecordList] = case player_private_list:get_value_ex(player:getPlayerID(), ?Private_List_TaiTanXunBaoTimeList) of
																 [] -> [Level, [], []];
																 Info -> Info
															 end,
						ParamTime1 = case lists:keyfind(Level, 1, ParamTimeList) of
										 {_, Time} -> #pk_key_value{key = 0, value = Time};
										 _ -> #pk_key_value{key = 0, value = 0}
									 end,
						OderKeyList = [Oder || {SeasonId, Oder} <- cfg_rouletteTimeItem2:getKeyList(), SeasonId =:= Level],
						ParamTime2 = lists:foldl(fun(OderId, Acc) ->
							case lists:member({Level, OderId}, DrawRecordList) of
								?TRUE -> [#pk_key_value{key = OderId, value = 1} | Acc];
								_ -> [#pk_key_value{key = OderId, value = 0} | Acc]
							end end, [], OderKeyList),
						[ParamTime1] ++ ParamTime2;
					_ -> []
				end,
	#pk_HeroDrawInfo{
		data_id = DataId,
		free_time = NewFreeTime,
		period_num = PeriodNum,
		finishAwardList = [#pk_HeroDrawFinishAward{index = Index, choice = Choice} || {Index, Choice} <- PeriodFinishList],
		person_lucky = PersonLucky,
		time_draw_award_time = [#pk_key_value{key = TimeId, value = TimeNum} || {TimeId, TimeNum} <- TimeNumList],
		today_times = TodayDrawTimes,
		param_list = ParamList
	}.
make_draw_record_msg(#draw_record{} = Record) ->
	#pk_HeroDrawRecord{
		time = Record#draw_record.time,
		playerId = Record#draw_record.player_id,
		playerName = Record#draw_record.player_name,
		type = Record#draw_record.type,
		itemList = make_item_msg_list(Record#draw_record.item_list),
		currencyList = make_currency_msg_list(Record#draw_record.currency_list),
		equipmentList = [eq:make_eq_msg(Equipment) || {_Item, Equipment} <- Record#draw_record.equipment_list]
	};
make_draw_record_msg(_) -> ok.
make_draw_result_msg(DrawItemList, DrawEquipmentList, DrawCurrencyList) ->
	case length(DrawItemList) + length(DrawEquipmentList) + length(DrawCurrencyList) > 10 of
		?TRUE ->
			#pk_HeroDrawResult{
				itemList = make_item_msg_list(item:item_merge(DrawItemList)),
				currencyList = make_currency_msg_list(common:listValueMerge(DrawCurrencyList)),
				equipmentList = [eq:make_eq_msg(Equipment) || {_Item, Equipment} <- DrawEquipmentList]
			};
		?FALSE ->
			#pk_HeroDrawResult{
				itemList = make_item_msg_list(DrawItemList),
				currencyList = make_currency_msg_list(DrawCurrencyList),
				equipmentList = [eq:make_eq_msg(Equipment) || {_Item, Equipment} <- DrawEquipmentList]
			}
	end.

%%listValueMerge4(KeyValueTupleList) ->
%%	Fun = fun({Key, Value, Bind, Time}, List) ->
%%		case lists:keyfind(Key, 1, List) of
%%			?FALSE -> [{Key, Value, Bind, Time} | List];
%%			{_, OldValue, Bind, Time} -> lists:keyreplace(Key, 1, List, {Key, OldValue + Value, Bind, Time})
%%		end
%%		  end,
%%	lists:foldl(Fun, [], KeyValueTupleList).

make_draw_cfg_msg(Data) ->
	#data{data_id = DataId, level = Level, hot_id = HotId, turn_id = TurnId, period_time = PeriodTime, first_tens = FirstInfo} = Data,
	RouletteCfg = cfg_rouletteNew:row({DataId, Level, TurnId}),
	NewRouletteCfg = get_new_roulette_cfg(DataId, RouletteCfg),
	Career = player:getCareer(),
	VipLv = vip:get_vip_lv(),
	LuckyAdd = case RouletteCfg#rouletteNewCfg.weightAdd of [{_, _, _, _, Add} | _] -> Add * 10000; _ -> 0 end,
	IsTurn = length(RouletteCfg#rouletteNewCfg.awardTime2) > 3,
	SortShow = sort_item_currency(NewRouletteCfg#rouletteNewCfg.itemShow, 1001, []),
	TimeAwardShow = lists:append([make_award_num_msg_list(TimeId, Career) || TimeId <- RouletteCfg#rouletteNewCfg.rouletteTimeItemID]),%%多次寻宝相关配置
	TimeAllAwardShow = make_all_award_num_msg(RouletteCfg#rouletteNewCfg.rouletteTimeItem2ID),
	PeriodType = case RouletteCfg#rouletteNewCfg.awardTime of
					 [] -> 0;
					 [T | _] -> T
				 end,
	Msg1 = #pk_HeroDrawCfg{
		data_id = DataId,
		levelLimit = Level,
		turnId = TurnId,
		consItem = RouletteCfg#rouletteNewCfg.consItem,
		genericConsItem = RouletteCfg#rouletteNewCfg.consItem2,
		consNumList = make_key_value_msg_list(RouletteCfg#rouletteNewCfg.numb, VipLv),
		item = make_item_msg_list(RouletteCfg#rouletteNewCfg.item, Career),
		currency = make_currency_msg_list(RouletteCfg#rouletteNewCfg.item, Career),
		rollingEquipShow = make_equipment_msg_list(RouletteCfg#rouletteNewCfg.rollingEquipShow, Career),
		rollingItemShow = make_item_msg_list(NewRouletteCfg#rouletteNewCfg.rollingItemShow, Career),
		rollingCurrencyShow = make_currency_msg_list(NewRouletteCfg#rouletteNewCfg.rollingItemShow, Career),
		equipShow = make_exchange_equipment_msg_list(RouletteCfg#rouletteNewCfg.equipShow, Career),
		showNum = [#pk_key_value{key = RuneId, value = Score} || {Score, RuneId} <- RouletteCfg#rouletteNewCfg.showNum],
		itemShow = make_sort_item_msg_list(SortShow, Career),
		currencyShow = make_sort_currency_msg_list(SortShow, Career),
		shopID = RouletteCfg#rouletteNewCfg.shopID,
		textID = RouletteCfg#rouletteNewCfg.xunbao_text,
		textTitle = language:get_server_string(RouletteCfg#rouletteNewCfg.xunbao_title, language:get_player_language(player:getPlayerID())),
		textDoc = RouletteCfg#rouletteNewCfg.xunbao_Doc,
		personLuckyMax = RouletteCfg#rouletteNewCfg.luckMax,
		worldLuckyMax = RouletteCfg#rouletteNewCfg.allLuckMax,
		worldLuckyAddRate = LuckyAdd,
		show = make_show_msg_list(RouletteCfg#rouletteNewCfg.show, Career),
		modelLeft = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.modelLeft, Career),
		modelcentre = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.modelCentre, Career),
		modelright = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.modelRight, Career),
		scoreModel = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.model, Career),
		timeShow = make_time_show_list1(RouletteCfg, FirstInfo, Career, VipLv),
		isTurn = IsTurn,
		slotLeft = RouletteCfg#rouletteNewCfg.slotLeft,
		slotCenter = RouletteCfg#rouletteNewCfg.slotCentre,
		slotRight = RouletteCfg#rouletteNewCfg.slotRight,
		awardExpireTime = PeriodTime,
		modelLeft2 = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.modelLeft2, Career),
		modelCenter2 = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.modelCentre2, Career),
		modelRight2 = make_model_show_msg_list(RouletteCfg#rouletteNewCfg.modelRight2, Career),
		effect = [#pk_HeroDrawEffect{item_id = ItemID_, min = Min_, max = Max_, index = Index_} || {ItemID_, Min_, Max_, Index_} <- RouletteCfg#rouletteNewCfg.effects],
		xunbao_Show = RouletteCfg#rouletteNewCfg.xunbao_Show,
		awardShow = make_award_show_msg_list(RouletteCfg#rouletteNewCfg.awardShow),
		timeAwardShow = TimeAwardShow,
		timeallAwardShow = TimeAllAwardShow,
		awardExpireType = PeriodType
	},
	case cfg_rouletteTime:row(HotId) of
		{} ->
			Msg1;
		RouletteTimeCfg ->
			Msg1#pk_HeroDrawCfg{
				awardList = make_award_msg_list(RouletteTimeCfg, Career),
				awardShowitem = RouletteTimeCfg#rouletteTimeCfg.showitem,
				awardNum = RouletteTimeCfg#rouletteTimeCfg.num
			}
	end.
make_time_show_list1(RouletteCfg, FirstInfo, Career, VipLv) ->
	DrawTimeList = [DrawTime || {LvF, LvC, DrawTime, _} <- RouletteCfg#rouletteNewCfg.numb, LvF =< VipLv, VipLv =< LvC orelse LvC == 0],
	F = fun(1, List) -> List;
		(DrawNum, List) ->
			case variant:isBitOn(FirstInfo, DrawNum div 10) of
				?FALSE when DrawNum =:= 10 ->
					make_time_show_list2(10, RouletteCfg#rouletteNewCfg.firstTenTimeShow, Career) ++ List;
				?FALSE when DrawNum =:= 20 ->
					make_time_show_list2(20, RouletteCfg#rouletteNewCfg.firstDoubleTenTimeShow, Career) ++ List;
				?FALSE when DrawNum =:= 30 ->
					make_time_show_list2(30, RouletteCfg#rouletteNewCfg.thirtyTimeShow, Career) ++ List;
				?FALSE when DrawNum =:= 50 ->
					make_time_show_list2(50, RouletteCfg#rouletteNewCfg.fiftyTimeShow, Career) ++ List;
				_ -> List
			end end,
	lists:foldl(F, [], DrawTimeList).

make_time_show_list2(DrawNum, Cfg, MyCareer) ->
	[#pk_HeroDrawTimesShow{drawTimes = DrawNum, type = Type, typeId = TypeID, quality = Quality, star = Star, bind = Bind,
		num = Num} || {Career, Type, TypeID, Quality, Star, Bind, Num} <- Cfg, Career =:= 0 orelse Career =:= MyCareer].

make_award_msg_list(RouletteTimeCfg, Career) ->
	Fun = fun(List, Index) -> [{P2, P3, P4, P5, P6} || {P1, P2, P3, P4, P5, P6} <- List, P1 =:= Index] end,
	lists:map(
		fun({Index, NeedNum}) ->
			List1 = Fun(RouletteTimeCfg#rouletteTimeCfg.awardParaNew1, Index),
			List2 = Fun(RouletteTimeCfg#rouletteTimeCfg.awardParaNew2, Index),
			#pk_HeroDrawAward{
				index = Index,
				needNum = NeedNum,
				itemParaNew1 = make_item_msg_list(List1, Career),
				currencyParaNew1 = make_currency_msg_list(List1, Career),
				itemParaNew2 = make_item_msg_list(List2, Career),
				currencyParaNew2 = make_currency_msg_list(List2, Career)
			}
		end, RouletteTimeCfg#rouletteTimeCfg.condPara).

make_previewbig_msg(ID, Type, Cfg) ->
	{ItemID, MI, SX, SY, SZ, RX, RY, RZ, Z} =
		case Cfg#roulettePreviewBigCfg.previewBigShow =/= [] of
			?TRUE ->
				Data = [{ItemID, MI, SX, SY, SZ, RX, RY, RZ, Z} || {Ca, ItemID, MI, SX, SY, SZ, RX, RY, RZ, Z} <- Cfg#roulettePreviewBigCfg.previewBigShow,
					Ca =:= role_data:get_leader_element(#role.career) orelse Ca =:= 0],
				case Data =/= [] of
					?TRUE -> lists:nth(1, Data);
					?FALSE -> {0, 0, 0, 0, 0, 0, 0, 0, 0}
				end;
			?FALSE -> {0, 0, 0, 0, 0, 0, 0, 0, 0}
		end,
	ItemList = [#pk_key_2value{key = ItemId, value1 = A, value2 = B} || {Ca, ItemId, A, B} <- Cfg#roulettePreviewBigCfg.previewItemID, Ca =:= role_data:get_leader_element(#role.career) orelse Ca =:= 0],
	TY = case ItemID =:= 0 of
			 ?TRUE -> 0;
			 ?FALSE -> 1
		 end,
	Msg = #pk_NewModelInfo{
		type = TY,
		item_id = ItemID,    %%物品id
		model_id = MI,        %%模型id
		shift_x = SX,        %%偏移x
		shift_y = SY,        %%偏移y
		shift_z = SZ,        %%偏移z
		rotate_x = RX,        %%旋转x
		rotate_y = RY,        %%旋转y
		rotate_z = RZ,        %%旋转z
		zoom = Z            %%缩放
	},

	Text = case Cfg#roulettePreviewBigCfg.text =:= "0" of
			   ?TRUE -> "";
			   ?FALSE ->
				   Language = language:get_player_language(player:getPlayerID()),
				   language:get_server_string(Cfg#roulettePreviewBigCfg.text, Language)
		   end,
	#pk_RoulettePreviewBigInfo{
		id = ID,
		type = Type,
		model = Msg,
		itemlist = ItemList,
		picPath = Cfg#roulettePreviewBigCfg.previewPic,
		text = Text
	}.

sort_item_currency([{RuneScoreId, DropCareer, Type, CfgId, Bind, Amount, Exchange} | List], Index, Ret) ->
	sort_item_currency(List, Index + 1, [{Index, DropCareer, Type, CfgId, Bind, Amount, Exchange, RuneScoreId} | Ret]);
sort_item_currency(_, _, Ret) -> Ret.

make_item_msg_list(List, Career) ->
	ItemList = [{CfgId, Amount, Bind, 0} || {DropCareer, 1, CfgId, Bind, Amount} <- List, DropCareer =:= 0 orelse DropCareer =:= Career],
	make_item_msg_list(ItemList).
make_item_msg_list(ItemList) ->
	[#pk_HeroDrawItem{cfgId = CfgId, amount = Amount, bind = Bind} || {CfgId, Amount, Bind, _ExpireTime} <- ItemList].

make_sort_item_msg_list(List, Career) ->
	ItemList = [{Sort, CfgId, Amount, Bind, 0, Exchange, RuneScoreId} || {Sort, DropCareer, 1, CfgId, Bind, Amount, Exchange, RuneScoreId} <- List, DropCareer =:= 0 orelse DropCareer =:= Career],
	make_sort_item_msg_list(ItemList).
make_sort_item_msg_list(ItemList) ->
	[#pk_HeroDrawItem{index = Sort, cfgId = CfgId, amount = Amount, bind = Bind, exchange = Exchange, runescoreid = RuneScoreId} || {Sort, CfgId, Amount, Bind, _ExpireTime, Exchange, RuneScoreId} <- ItemList].

make_exchange_equipment_msg_list(List, Career) ->
	MsgList = [#pk_HeroDrawEquipment{cfgId = CfgId, bind = Bind, quality = Quality, star = Star, exchange = Exchange} || {DropCareer, CfgId, Quality, Star, Bind, Exchange} <- List,
		DropCareer =:= 0 orelse DropCareer =:= Career],
	sort_index_eq_msg(MsgList, 1, []). %% eq从1开始sort
make_equipment_msg_list(List, Career) ->
	MsgList = [#pk_HeroDrawEquipment{cfgId = CfgId, bind = Bind, quality = Quality, star = Star} || {DropCareer, CfgId, Quality, Star, Bind} <- List,
		DropCareer =:= 0 orelse DropCareer =:= Career],
	sort_index_eq_msg(MsgList, 1, []). %% eq从1开始sort

sort_index_eq_msg([#pk_HeroDrawEquipment{} = I | List], Index, Ret) ->
	sort_index_eq_msg(List, Index + 1, [I#pk_HeroDrawEquipment{index = Index} | Ret]);
sort_index_eq_msg(_, _, Ret) -> Ret.

make_currency_msg_list(List, Career) ->
	CurrencyList = [{CfgId, Amount} || {DropCareer, 2, CfgId, _Bind, Amount} <- List, DropCareer =:= 0 orelse DropCareer =:= Career],
	make_currency_msg_list(CurrencyList).
make_currency_msg_list(CurrencyList) ->
	[#pk_HeroDrawCurrency{cfgId = CfgId, amount = Amount} || {CfgId, Amount} <- CurrencyList].

make_sort_currency_msg_list(List, Career) ->
	CurrencyList = [{Sort, CfgId, Amount, Exchange} || {Sort, DropCareer, 2, CfgId, _Bind, Amount, Exchange, _} <- List, DropCareer =:= 0 orelse DropCareer =:= Career],
	make_sort_currency_msg_list(CurrencyList).
make_sort_currency_msg_list(CurrencyList) ->
	[#pk_HeroDrawCurrency{index = Sort, cfgId = CfgId, amount = Amount, exchange = Exchange} || {Sort, CfgId, Amount, Exchange} <- CurrencyList].


make_key_value_msg_list(List, VipLv) ->
	[#pk_key_value{key = Num, value = Cost} || {LvF, LvC, Num, Cost} <- List, LvF =< VipLv, VipLv =< LvC orelse LvC == 0].
make_show_msg_list(List, Career) ->
	[#pk_HeroDrawAwardShow{index = Index, type = Type, typeId = TypeID, order = Order, star = Star, bind = Bind, number = Num, show = Show}
		|| {Index, C, Type, TypeID, Order, Star, Bind, Num, Show} <- List, C =:= Career orelse C =:= 0].
make_model_show_msg_list(List, Career) ->
	List1 = [#pk_HeroDrawModelShow{itemId = ItemId, modelId = ModelId, zoom = Zoom, shift_x = X1, shift_y = Y1, shift_z = Z1,
		rotate_x = X2, rotate_y = Y2, rotate_z = Z2} || {C, ItemId, ModelId, X1, Y1, Z1, X2, Y2, Z2, Zoom} <- List, C =:= Career orelse C =:= 0],
	case length(List1) >= 1 of
		?TRUE -> hd(List1);
		?FALSE -> #pk_HeroDrawModelShow{}
	end.
make_award_show_msg_list(List) ->
	[#pk_HeroAwardShow{type = Type, equip_id = EquipID, num = Num, quality = Quality, star = Star}
		|| {Type, EquipID, Num, Quality, Star} <- List].

%%多次寻宝配置
make_award_num_msg_list(TimeId, Career) ->
	case get_roulette_time_item_cfg(TimeId) of
		{} ->
			?LOG_ERROR("~ncfg_rouletteTimeItem no cfg,key:~p", [TimeId]),
			[];
		RouletteTimeItemCfg ->
			[#pk_HeroAwardNumCfg{
				time_id = TimeId,
				timeNum = RouletteTimeItemCfg#rouletteTimeItemCfg.time,
				timeEquipShow = make_equipment_msg_list(RouletteTimeItemCfg#rouletteTimeItemCfg.equipShow, Career),
				timeItemShow = make_item_msg_list(RouletteTimeItemCfg#rouletteTimeItemCfg.itemShow, Career),
				timeCurrencyShow = make_currency_msg_list(RouletteTimeItemCfg#rouletteTimeItemCfg.itemShow, Career),
				show = RouletteTimeItemCfg#rouletteTimeItemCfg.show
			}]
	end.

%%赛季累计寻宝配置
make_all_award_num_msg(Num2Id) ->
	PlayerCareer = player:getCareer(),
	Fun = fun(Item2Cfg) ->
		#pk_HeroAllAwardNumCfg{
			id = Item2Cfg#rouletteTimeItem2Cfg.iD,
			oder = Item2Cfg#rouletteTimeItem2Cfg.oder,
			times = Item2Cfg#rouletteTimeItem2Cfg.times,
			oder_max = Item2Cfg#rouletteTimeItem2Cfg.oderMax,
			item_list = [#pk_HeroAllAwardNumShow{type = Type, cfg_id = CfgId, num = Num, quality = Quality, star = Star, is_band = common:int_to_bool(IsBand)}
				|| {Career, Type, CfgId, Quality, Star, IsBand, Num} <- Item2Cfg#rouletteTimeItem2Cfg.item, Career =:= 0 orelse Career =:= PlayerCareer],
			show = Item2Cfg#rouletteTimeItem2Cfg.show
		} end,
	[Fun(Cfg) || {Id, Order} <- cfg_rouletteTimeItem2:getKeyList(), Id =:= Num2Id,
		(Cfg = cfg_rouletteTimeItem2:getRow(Id, Order)) =/= {}].

%% 发送寻宝信息
send_update_level() ->
	?metrics(begin
				 case is_open_action(?DATA_ID_1) of
					 ?TRUE ->
						 IsAutoLevel = variable_player:get_value(?VARIABLE_PLAYER_xun_bao_choice_level) =:= 0,
						 get_new_data(?DATA_ID_1, IsAutoLevel);
					 ?FALSE -> ok
				 end,
				 send_data()
			 end).
send_data() ->
	?metrics(begin
				 lists:foreach(
					 fun(DataId) ->
						 case is_open_action(DataId) of
							 ?TRUE -> send_data(get_new_data(DataId));
							 ?FALSE -> ok
						 end
					 end, [?DATA_ID_1, ?DATA_ID_2, ?DATA_ID_3, ?DATA_ID_4, ?DATA_ID_5, ?DATA_ID_6, ?DATA_ID_7, ?DATA_ID_8, ?DATA_ID_9, ?DATA_ID_13, ?DATA_ID_14, ?DATA_ID_15, ?DATA_ID_16, ?DATA_ID_17])
			 end).

send_data(DataId) when is_integer(DataId) ->
	send_data(get_new_data(DataId));
send_data(Data) ->
	player:send(#pk_GS2U_HeroDrawNotify{drawInfo = make_draw_info_msg(Data), drawCfg = make_draw_cfg_msg(Data)}).

%% 获取最新寻宝数据
get_new_data(DataId) when DataId =:= ?DATA_ID_1 ->
	get_new_data(DataId, ?FALSE);
get_new_data(DataId) ->
	get_new_data(DataId, ?TRUE).
get_new_data(DataId, IsAutoLevel) ->
	Data = get_data(DataId),
	{NewData1, IsChanged1} = maybe_update_level(Data, IsAutoLevel),
	{NewData2, IsChanged2} = maybe_update_period(NewData1),
	case IsChanged1 orelse IsChanged2 of
		?TRUE ->
			update_data(NewData2);
		?FALSE -> ok
	end,
	NewData2.

%% 获取寻宝轮次
get_turn_id(DataId) -> ?metrics(begin
									#data{turn_id = TurnId} = get_new_data(DataId),
									TurnId end).

%% 更新寻宝等级，返回{NewData, IsChanged}
maybe_update_level(Data, IsAutoLevel) ->
	#data{data_id = DataId, level = Level} = Data,
	NewLevel = get_draw_level(DataId),
	case IsAutoLevel andalso NewLevel > Level of
		?TRUE ->
			NewData = Data#data{level = NewLevel},
			{NewData, ?TRUE};
		?FALSE ->
			{Data, ?FALSE}
	end.

%% 更新寻宝周期，返回{NewData, IsChanged}
maybe_update_period(Data) ->
	#data{data_id = DataId, level = Level, period_time = PeriodTime, period_level = PeriodLevel, hot_id = HotId} = Data,
	case xun_bao_period:get_info(DataId, PeriodLevel) of
		{} ->
			{Data, ?FALSE};
		{_HotId, _TurnId, PeriodTime} ->
			{Data, ?FALSE};
		{NewHotId, NewTurnId, NewPeriodTime} ->
			case cfg_rouletteTime:row(HotId) of
				{} -> ok;
				RouletteTimeCfg ->
					send_award_mail(Data, RouletteTimeCfg)
			end,
			NewData = Data#data{hot_id = NewHotId, turn_id = NewTurnId, period_time = NewPeriodTime, period_level = Level, period_num = 0, period_finish_list = []},
			%%重置寻宝数据的位置
			{NewData, ?TRUE}
	end.
send_award_mail(Data, RouletteTimeCfg) ->
	#data{data_id = DataId, period_num = PeriodNum, period_finish_list = PeriodFinishList} = Data,
	List = lists:foldl(
		fun({Index, NeedNum}, List1) ->
			case lists:keymember(Index, 1, PeriodFinishList) orelse PeriodNum < NeedNum of
				?TRUE ->
					List1;
				?FALSE ->
					List2 = [{P2, P3, P4, P5, P6} || {P1, P2, P3, P4, P5, P6} <- RouletteTimeCfg#rouletteTimeCfg.awardParaNew1, P1 =:= Index],
					List2 ++ List1
			end
		end, [], RouletteTimeCfg#rouletteTimeCfg.condPara),
	case List =/= [] of
		?TRUE ->
			PlayerID = player:getPlayerID(),
			Language = language:get_player_language(PlayerID),
			{Title, Describe} = case DataId of
									?DATA_ID_1 ->
										{language:get_server_string("Xb_fanhuan1", Language), language:get_server_string("Xb_fanhuan2", Language)};
									?DATA_ID_2 ->
										{language:get_server_string("Xb_fanhuan1", Language), language:get_server_string("Xb_fanhuan2", Language)};
									?DATA_ID_3 ->
										{language:get_server_string("Xb_fanhuan3", Language), language:get_server_string("Xb_fanhuan4", Language)};
									?DATA_ID_4 ->
										{language:get_server_string("Xb_fanhuan7", Language), language:get_server_string("Xb_fanhuan8", Language)};
									?DATA_ID_5 ->
										{language:get_server_string("Xb_fanhuan5", Language), language:get_server_string("Xb_fanhuan6", Language)};
									?DATA_ID_6 ->
										{language:get_server_string("Xb_fanhuan1", Language), language:get_server_string("Xb_fanhuan2", Language)};
									?DATA_ID_7 ->
										{language:get_server_string("Xb_fanhuan9", Language), language:get_server_string("Xb_fanhuan10", Language)};
									?DATA_ID_8 ->
										{language:get_server_string("Xb_fanhuan11", Language), language:get_server_string("Xb_fanhuan12", Language)};
									?DATA_ID_9 ->
										{language:get_server_string("Xb_fanhuan13", Language), language:get_server_string("Xb_fanhuan14", Language)}
								end,
			Career = player:getCareer(),
			Reason = ?REASON_xun_bao_period,
			ItemList = [#itemInfo{itemID = CfgId, num = Amount, isBind = Bind} || {DropCareer, 1, CfgId, Bind, Amount} <- List,
				DropCareer =:= 0 orelse DropCareer =:= Career],
			CurrencyList = [#coinInfo{type = CfgId, num = Amount, reason = Reason} || {DropCareer, 2, CfgId, _Bind, Amount} <- List,
				DropCareer =:= 0 orelse DropCareer =:= Career],
			mail:send_mail(#mailInfo{
				player_id = PlayerID,           %% 接收者ID
				title = Title,               %% 标题
				describe = Describe,           %% 描述
				coinList = CurrencyList,           %% 货币奖励列表
				itemList = ItemList,           %% 奖励的道具
				attachmentReason = Reason,  %% 奖励的原因
				isDirect = 0          %% 是否是直接添加  1 -直接  0- 不直接  (继承领奖中心功能)  不支持世界邮件处理
			});
		?FALSE -> ok
	end.

%%增加寻宝累计奖励次数 Num为负就是减少次数,统一增加,单个减少  TimeIdList就是要修改次数的列表
add_draw_num(TimeNumList, TimeIdList, Num) ->
	lists:foldl(fun(TimeId, Acc) ->
		case lists:keyfind(TimeId, 1, Acc) of
			?FALSE ->
				[{TimeId, Num} | Acc];
			{_, TimeNum} ->
				lists:keyreplace(TimeId, 1, Acc, {TimeId, TimeNum + Num})
		end end, TimeNumList, TimeIdList).

%% 寻宝记录
add_record(Data, ItemList, EquipmentList, CurrencyList, Time, Type) ->
	#data{data_id = DataId, record_list = RecordList} = Data,
	PlayerId = player:getPlayerID(),
	PlayerName = player:getPlayerText(),
	Record = #draw_record{
		player_id = PlayerId,              %% 玩家Id
		player_name = PlayerName,           %% 玩家名字
		type = Type, %% 记录类型
		item_list = ItemList,             %% 物品列表 [{CfgId, Amount, Bind, ExpireTime}]
		currency_list = CurrencyList,         %% 货币列表 [{CfgId, Amount}]
		equipment_list = EquipmentList,        %% 装备列表 [{Item, Equipment}]
		time = Time                    %% 时间
	},
	AddRecordList =
		[#draw_record{player_id = PlayerId,
			player_name = PlayerName, type = Type, item_list = [Item],
			currency_list = [], equipment_list = [], time = Time} || Item <- ItemList] ++
		[#draw_record{player_id = PlayerId,
			player_name = PlayerName, type = Type, item_list = [],
			currency_list = [Curr], equipment_list = [], time = Time} || Curr <- CurrencyList] ++
		[#draw_record{player_id = PlayerId,
			player_name = PlayerName, type = Type, item_list = [],
			currency_list = [], equipment_list = [Equip], time = Time} || Equip <- EquipmentList],
	%% 筛选后取
	NewRecordList = xun_bao_record:get_new_record_list(AddRecordList, RecordList),
%%	NewRecordList = lists:sublist([Record | RecordList], 50),
	NewData = Data#data{record_list = NewRecordList},
	player:send(#pk_GS2U_HeroDrawRecordAdd{data_id = DataId, type = 1, record = make_draw_record_msg(Record)}),
	add_global_record(DataId, ItemList, EquipmentList, Time, Type),
	NewData.
add_global_record(DataId, ItemList, EquipmentList, Time, Type) ->
	OpenActionId = case DataId of
					   ?DATA_ID_1 -> ?OpenAction_XunBao_1;
					   ?DATA_ID_2 -> ?OpenAction_XunBao_2;
					   ?DATA_ID_3 -> ?OpenAction_XunBao_3;
					   ?DATA_ID_4 -> ?OpenAction_XunBao_4;
					   ?DATA_ID_5 -> ?OpenAction_XunBao_5;
					   ?DATA_ID_6 -> ?OpenAction_XunBao_6;
					   ?DATA_ID_7 -> ?OpenAction_XunBao_7;
					   ?DATA_ID_8 -> ?OpenAction_XunBao_8;
					   ?DATA_ID_9 -> ?OpenAction_XunBao_9;
					   ?DATA_ID_13 -> ?OpenAction_XunBao_13;
					   ?DATA_ID_14 -> ?OpenAction_XunBao_14;
					   ?DATA_ID_15 -> ?OpenAction_XunBao_15;
					   ?DATA_ID_16 -> ?OpenAction_XunBao_16;
					   ?DATA_ID_17 -> ?OpenAction_XunBao_17
				   end,
	NewItemList = [{CfgId, Amount, Bind, ExpireTime} || {CfgId, Amount, Bind, ExpireTime} <- ItemList, richText:check_affiche(OpenActionId, CfgId)],
	NewEquipmentList = [{Item, Equipment} || {Item, Equipment} <- EquipmentList, richText:check_affiche(OpenActionId, Item#item.cfg_id)],
	case Type =:= ?RECORD_TYPE_RARE_2 orelse Type =:= ?RECORD_TYPE_EXCHANGE_3 orelse length(NewItemList) > 0 orelse length(NewEquipmentList) > 0 of
		?TRUE ->
			PlayerID = player:getPlayerID(),
			PlayerText = player:getPlayerText(),
			Record =
				case Type of
					?RECORD_TYPE_NORMAL_1 ->
						#draw_record{
							player_id = PlayerID,              %% 玩家Id
							player_name = PlayerText,           %% 玩家名字
							type = Type,
							item_list = NewItemList,             %% 物品列表 [{CfgId, Amount, Bind, ExpireTime}]
							equipment_list = NewEquipmentList,        %% 装备列表 [{Item, Equipment}]
							time = Time                    %% 时间
						};
					_ ->
						#draw_record{
							player_id = PlayerID,              %% 玩家Id
							player_name = PlayerText,           %% 玩家名字
							type = Type,
							item_list = ItemList,             %% 物品列表 [{CfgId, Amount, Bind, ExpireTime}]
							equipment_list = EquipmentList,        %% 装备列表 [{Item, Equipment}]
							time = Time                    %% 时间
						}
				end,
			AddRecordList =
				[#draw_record{player_id = PlayerID,
					player_name = PlayerText, type = Type, item_list = [Item],
					currency_list = [], equipment_list = [], time = Time} || Item <- Record#draw_record.item_list] ++
				[#draw_record{player_id = PlayerID,
					player_name = PlayerText, type = Type, item_list = [],
					currency_list = [], equipment_list = [Equip], time = Time} || Equip <- Record#draw_record.equipment_list],
			xun_bao:cast({add_record, DataId, AddRecordList}),
			player:send(#pk_GS2U_HeroDrawRecordAdd{data_id = DataId, type = 2, record = make_draw_record_msg(Record)}),
			%% 消息提示
			case Type of
				%% 兑换公告不在此处发
				?RECORD_TYPE_EXCHANGE_3 ->
					skip;
				_ ->
					PlayerText = player:getPlayerText(),
					lists:foreach(
						fun({CfgId, Amount, _, _}) ->
							NeedNoticeList = df:getGlobalSetupValueList(treasureHuntNotice, [{13, 1330300}, {14, 1330100}]),
							NeedNoticeIDList = [CfgId_ || {DataId_, CfgId_} <- NeedNoticeList, DataId =:= DataId_],
							case lists:member(CfgId, NeedNoticeIDList) of
								?TRUE ->
									case DataId of
										?DATA_ID_1 ->
											marquee:sendChannelNotice(0, 0, xB_zhuangbei,
												fun(Language) ->
													language:format(language:get_server_string("XB_zhuangbei", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_2 ->
											marquee:sendChannelNotice(0, 0, xB_longyin,
												fun(Language) ->
													language:format(language:get_server_string("XB_longyin", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_3 ->
											marquee:sendChannelNotice(0, 0, xB_zuoqi,
												fun(Language) ->
													language:format(language:get_server_string("XB_zuoqi", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_4 ->
											marquee:sendChannelNotice(0, 0, xB_chibang,
												fun(Language) ->
													language:format(language:get_server_string("XB_chibang", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_5 ->
											marquee:sendChannelNotice(0, 0, xB_mochong,
												fun(Language) ->
													language:format(language:get_server_string("XB_mochong", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_6 ->
											marquee:sendChannelNotice(0, 0, xB_zhuangbei,
												fun(Language) ->
													language:format(language:get_server_string("XB_zhuangbei", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_7 ->
											marquee:sendChannelNotice(0, 0, xB_shengwen,
												fun(Language) ->
													language:format(language:get_server_string("XB_shengwen", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_8 ->
											marquee:sendChannelNotice(0, 0, xB_shenbing,
												fun(Language) ->
													language:format(language:get_server_string("XB_shenbing", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_9 ->
											marquee:sendChannelNotice(0, 0, xB_shenhun,
												fun(Language) ->
													language:format(language:get_server_string("XB_shenhun", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_13 ->
											marquee:sendChannelNotice(0, 0, xBNotice1,
												fun(Language) ->
													language:format(language:get_server_string("XBNotice1", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_14 ->
											marquee:sendChannelNotice(0, 0, xBNotice2,
												fun(Language) ->
													language:format(language:get_server_string("XBNotice2", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_15 ->%% 黄金寻宝
											marquee:sendChannelNotice(0, 0, xBNotice4,
												fun(Language) ->
													language:format(language:get_server_string("XBNotice4", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_16 ->%% 魂石寻宝-公告需修改
											marquee:sendChannelNotice(0, 0, xBNotice5,
												fun(Language) ->
													language:format(language:get_server_string("XBNotice5", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										?DATA_ID_17 ->%% 泰坦寻宝-极品公告
											marquee:sendChannelNotice(0, 0, xBNotice_taitan,
												fun(Language) ->
													language:format(language:get_server_string("XBNotice_taitan", Language),
														[PlayerText, richText:getItemText(CfgId, Amount, Language)])
												end);
										_ ->
											skip
									end;
								_ ->
									skip
							end
						end, NewItemList),
					lists:foreach(
						fun({_, Equipment}) ->
							case DataId of
								?DATA_ID_1 ->
									marquee:sendChannelNotice(0, 0, xB_zhuangbei,
										fun(Language) ->
											language:format(language:get_server_string("XB_zhuangbei", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_2 ->
									marquee:sendChannelNotice(0, 0, xB_longyin,
										fun(Language) ->
											language:format(language:get_server_string("XB_longyin", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_3 ->
									marquee:sendChannelNotice(0, 0, xB_zuoqi,
										fun(Language) ->
											language:format(language:get_server_string("XB_zuoqi", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_4 ->
									marquee:sendChannelNotice(0, 0, xB_chibang,
										fun(Language) ->
											language:format(language:get_server_string("XB_chibang", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_5 ->
									marquee:sendChannelNotice(0, 0, xB_mochong,
										fun(Language) ->
											language:format(language:get_server_string("XB_mochong", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_6 ->
									marquee:sendChannelNotice(0, 0, xB_zhuangbei,
										fun(Language) ->
											language:format(language:get_server_string("XB_zhuangbei", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_7 ->
									marquee:sendChannelNotice(0, 0, xB_shengwen,
										fun(Language) ->
											language:format(language:get_server_string("XB_shengwen", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_8 ->
									marquee:sendChannelNotice(0, 0, xB_shenbing,
										fun(Language) ->
											language:format(language:get_server_string("XB_shenbing", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								?DATA_ID_9 ->
									marquee:sendChannelNotice(0, 0, xB_shenhun,
										fun(Language) ->
											language:format(language:get_server_string("XB_shenhun", Language),
												[PlayerText, richText:getItemText_Equip3(Equipment, 0, Language)])
										end);
								_ ->
									skip
							end
						end, NewEquipmentList)
			end;
		?FALSE -> ok
	end.

%% 替换首抽奖励
get_first_change(OldList, [], _CommonCfg) -> OldList;
get_first_change(OldList, FirstCfg, CommonCfg) ->
	MyCareer = player:getCareer(),
	FirstList = [{Career, DropId, Bind, 1, 10000} || {Career, DropId, Bind} <- FirstCfg, Career =:= 0 orelse Career =:= MyCareer],
	{CommonList, SpeList} = lists:splitwith(fun({_C, ID, _B, _, _}) -> lists:keymember(ID, 2, CommonCfg) end, OldList),
	case CommonList =:= [] of
		?TRUE -> tl(SpeList) ++ FirstList;
		_ -> SpeList ++ FirstList ++ tl(CommonList)
	end.

%% 核心龙印替换
get_rune_change(#rouletteNewCfg{type = ?DATA_ID_2, lvLimit = Limit}, PlayerLevel, ItemList) when PlayerLevel < Limit ->
	lists:map(
		fun({CfgId, Amount, Bind, ExpireTime}) ->
			NewCfgId = case cfg_rouletteRuneChange:row(CfgId) of
						   #rouletteRuneChangeCfg{itemId = List} when List =/= [] ->
							   Index = rand:uniform(length(List)),
							   lists:nth(Index, List);
						   _ ->
							   CfgId
					   end,
			{NewCfgId, Amount, Bind, ExpireTime}
		end, ItemList);
get_rune_change(_, _, ItemList) ->
	ItemList.

%% 寻宝仓库
get_bag_id(?DATA_ID_1) -> ?BAG_XUN_BAO_1;
get_bag_id(?DATA_ID_2) -> ?BAG_XUN_BAO_2;
get_bag_id(?DATA_ID_3) -> ?BAG_XUN_BAO_3;
get_bag_id(?DATA_ID_4) -> ?BAG_XUN_BAO_4;
get_bag_id(?DATA_ID_5) -> ?BAG_XUN_BAO_5;
get_bag_id(?DATA_ID_6) -> ?BAG_XUN_BAO_6;
get_bag_id(?DATA_ID_7) -> ?BAG_XUN_BAO_7;
get_bag_id(?DATA_ID_8) -> ?BAG_XUN_BAO_8;
get_bag_id(?DATA_ID_9) -> ?BAG_XUN_BAO_9;
get_bag_id(?DATA_ID_13) -> ?BAG_XUN_BAO_10;
get_bag_id(?DATA_ID_14) -> ?BAG_XUN_BAO_11;
get_bag_id(?DATA_ID_15) -> ?BAG_XUN_BAO_12;
get_bag_id(?DATA_ID_16) -> ?BAG_XUN_BAO_13;
get_bag_id(?DATA_ID_17) -> ?BAG_XUN_BAO_14.
%% 寻宝运营活动
%%add_active_condition(?DATA_ID_1, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoEquip, N);
%%add_active_condition(?DATA_ID_2, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoRune, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllRune, N);
%%add_active_condition(?DATA_ID_3, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoMount, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllLook, N);
%%add_active_condition(?DATA_ID_4, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoWing, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllLook, N);
%%add_active_condition(?DATA_ID_5, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoPet, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllLook, N);
%%add_active_condition(?DATA_ID_6, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_XunBaoExt, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllHoly, N);
%%add_active_condition(?DATA_ID_7, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoShengWen, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllRune, N);
%%add_active_condition(?DATA_ID_8, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoWeapon, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllHoly, N);
%%add_active_condition(?DATA_ID_9, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoGodSoul, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllRune, N);
%%add_active_condition(?DATA_ID_10, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoExtreme, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllHoly, N);
%%add_active_condition(?DATA_ID_11, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoGodWing, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllLook, N);
%%add_active_condition(?DATA_ID_12, N) ->
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoHolyEq, N),
%%	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoAllHoly, N);
%% %% 符文寻宝
add_active_condition(?DATA_ID_2, N) ->
	activity_new_player:on_active_condition_change(?SalesActivity_RuneXunBao, N),
	attainment:add_attain_progress(?Attainments_Type_RuneXunBao_Count, {N});
%% 宝石寻宝
add_active_condition(?DATA_ID_13, N) ->
	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoGem, N),
	attainment:add_attain_progress(?Attainments_Type_EqTreasureHuntCount, {N});
%% 卡片寻宝
add_active_condition(?DATA_ID_14, N) ->
	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoCard, N),
	attainment:add_attain_progress(?Attainments_Type_CardTreasureHuntCount, {N});
%%	黄金寻宝
add_active_condition(?DATA_ID_15, N) ->
	activity_new_player:on_active_condition_change(?SalesActivity_Attend_XunBaoPantheon, N);
%%	魂石寻宝
add_active_condition(?DATA_ID_16, N) ->
	activity_new_player:on_active_condition_change(?SalesActivity_XunBaoSoulStone, N),
	attainment:add_attain_progress(?Attainments_Type_SoulStoneXunBao_Count, {N});
add_active_condition(?DATA_ID_7, N) ->
	activity_new_player:on_active_condition_change(?SalesActivity_XunBaoShenWen, N),
	attainment:add_attain_progress(?Attainments_Type_ShengWenXunBao_Count, {N});
add_active_condition(_, _) ->
	skip.

update_task(?DATA_ID_2, N) ->
	player_task:update_task(?Task_Goal_RuneXunBao, {N});
update_task(_, _) ->
	skip.

%% 功能开启
is_open_action(?DATA_ID_1) -> is_open_action(?OpenAction_XunBao_1, ?WorldVariant_Switch_XunBao_1);
is_open_action(?DATA_ID_2) -> is_open_action(?OpenAction_XunBao_2, ?WorldVariant_Switch_XunBao_2);
is_open_action(?DATA_ID_3) -> is_open_action(?OpenAction_XunBao_3, ?WorldVariant_Switch_XunBao_3);
is_open_action(?DATA_ID_4) -> is_open_action(?OpenAction_XunBao_4, ?WorldVariant_Switch_XunBao_4);
is_open_action(?DATA_ID_5) -> is_open_action(?OpenAction_XunBao_5, ?WorldVariant_Switch_XunBao_5);
is_open_action(?DATA_ID_6) -> is_open_action(?OpenAction_XunBao_6, ?WorldVariant_Switch_XunBao_6);
is_open_action(?DATA_ID_7) -> is_open_action(?OpenAction_XunBao_7, ?WorldVariant_Switch_XunBao_7);
is_open_action(?DATA_ID_8) -> is_open_action(?OpenAction_XunBao_8, ?WorldVariant_Switch_XunBao_8);
is_open_action(?DATA_ID_9) -> is_open_action(?OpenAction_XunBao_9, ?WorldVariant_Switch_XunBao_9);
is_open_action(?DATA_ID_13) -> is_open_action(?OpenAction_XunBao_13, ?WorldVariant_Switch_XunBao_13);
is_open_action(?DATA_ID_14) -> is_open_action(?OpenAction_XunBao_14, ?WorldVariant_Switch_XunBao_14);
is_open_action(?DATA_ID_15) -> is_open_action(?OpenAction_XunBao_15, ?WorldVariant_Switch_XunBao_15);
is_open_action(?DATA_ID_16) -> is_open_action(?OpenAction_XunBao_16, ?WorldVariant_Switch_XunBao_16);
is_open_action(?DATA_ID_17) -> is_open_action(?OpenAction_XunBao_17, ?WorldVariant_Switch_XunBao_17);
is_open_action(_DataId) -> ?FALSE.
%%
is_open_action(OpenActionId, _FunctionSwitchId) ->
	guide:is_open_action(?OpenAction_XunBao_0) andalso guide:is_open_action(OpenActionId) andalso
		variable_world:get_value(?WorldVariant_Switch_XunBao_0) =:= 1.%% andalso variable_world:get_value(FunctionSwitchId) =:= 1.

check_draw_times(DataId, IsFree, Times, TodayTimes) ->
	case IsFree of
		?TRUE ->
			?TRUE;
		?FALSE ->
			%% {宝石寻宝次数,卡片寻宝次数，符文寻宝次数}
			VipLimitControlList = df:getGlobalSetupValueList(treasureHunt, [{13, 3099}, {14, 3100}, {2, 3101}, {15, 3100}]),
			VipFunID =
				case lists:keyfind(DataId, 1, VipLimitControlList) of
					?FALSE ->
						0;
					{_, VipFunID_} ->
						VipFunID_
				end,
			case VipFunID of
				0 ->
					?FALSE;
				_ ->
					VipLimit = vipFun:callVip(VipFunID, 0),
					VipLimit >= TodayTimes + Times
			end
	end.

add_task_time(DataId, Time) ->
	case DataId of
		?DATA_ID_13 ->
			seven_gift:add_task_progress(?Seven_Type_XunBao13, {Time});
		?DATA_ID_14 ->
			seven_gift:add_task_progress(?Seven_Type_XunBao14, {Time});
		_ -> skip
	end.