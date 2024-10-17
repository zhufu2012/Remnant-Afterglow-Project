%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 寻宝周期：管理进程
%%% @end
%%% Created : 2018-12-12 10:00
%%%-------------------------------------------------------------------
-module(xun_bao_period).
-include("global.hrl").
-include("db_table.hrl").
-include("cfg_rouletteNew.hrl").

-define(TABLE_DATA, db_xun_bao_period).


%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_init/0, on_tick/1, get_info/2, gm_reset/0]).

%% 初始化
on_init() ->?metrics(begin 
	DataList = table_global:record_list(?TABLE_DATA),
	NewDataList = lists:foldl(
		fun({DataId, Level, TurnID}, List) ->
			#rouletteNewCfg{awardTime = AwardTime, awardTime2 = AwardTime2} = cfg_rouletteNew:row({DataId, Level, TurnID}),
			case length(AwardTime) > 2 orelse length(AwardTime2) > 2 of
				?TRUE ->
					Id = make_id(DataId, Level),
					case lists:keymember(Id, #db_xun_bao_period.id, List) of
						?TRUE -> List;
						?FALSE ->
							NewHotId = next_period_id(AwardTime, 0),
							[#db_xun_bao_period{id = Id, data_id = DataId, level = Level, turn_id = TurnID, hot_id = NewHotId} | List]
					end;
				?FALSE -> List
			end
		end, DataList, cfg_rouletteNew:getKeyList()),
	set_data_list(NewDataList),
	on_tick(time:time()) end).

%% 时间更新
on_tick(Time) ->?metrics(begin 
	DataList = get_data_list(),
	{NewDataList, IsChanged} = lists:mapfoldl(
		fun(Data, IsChanged) ->
			case Time >= Data#db_xun_bao_period.period_time of
				?TRUE ->
					{reset(Data), ?TRUE};
				?FALSE ->
					{Data, IsChanged}
			end
		end, ?FALSE, DataList),
	case IsChanged of
		?TRUE -> set_data_list(NewDataList);
		?FALSE -> ok
	end end).

%% 获取周期信息，返回{PeriodId, PeriodTime} 或 {}
get_info(DataId, Level) ->?metrics(begin 
	DataList = get_data_list(),
	case lists:keyfind(make_id(DataId, Level), #db_xun_bao_period.id, DataList) of
		?FALSE ->
			{};
		#db_xun_bao_period{hot_id = HotId, turn_id = TurnId, period_time = PeriodTime} ->
			{HotId, TurnId, PeriodTime}
	end end).

%% GM重置周期
gm_reset() ->?metrics(begin 
	DataList = get_data_list(),
	NewDataList = lists:map(
		fun(Data) ->
			NewData1 = reset(Data),
			#db_xun_bao_period{period_time = PeriodTime} = NewData1,
			case PeriodTime =:= Data#db_xun_bao_period.period_time of
				?TRUE ->
					NewData2 = NewData1#db_xun_bao_period{period_time = PeriodTime + 1},
					table_global:insert(?TABLE_DATA, NewData2),
					NewData2;
				?FALSE ->
					NewData1
			end
		end, DataList),
	set_data_list(NewDataList) end).


%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 寻宝周期数据列表
set_data_list(DataList) ->
	d:storage_put(xun_bao_period_data_list, DataList).
get_data_list() ->
	d:storage_get(xun_bao_period_data_list, []).

%% 寻宝周期重置
reset(Data) ->
	#db_xun_bao_period{data_id = DataId, level = Level, hot_id = HotID, turn_id = TurnID, period_time = PreiodTime} = Data,
	case PreiodTime =:= 0 of
		?TRUE ->
			#rouletteNewCfg{awardTime = PeriodList, awardTime2 = PeriodList2} = cfg_rouletteNew:row({DataId, Level, TurnID}),
			Time = time:time(),
			NewHotTime =  next_period_time(PeriodList, Time),
			NewTurnTime = next_period_time(PeriodList2, Time),
			NewPeriodTime = max(NewHotTime, NewTurnTime),
			NewData = Data#db_xun_bao_period{period_time = NewPeriodTime},
			table_global:insert(?TABLE_DATA, NewData),
			NewData;
		?FALSE ->
			#rouletteNewCfg{awardTime = PeriodList, awardTime2 = PeriodList2} = cfg_rouletteNew:row({DataId, Level, TurnID}),
			NewHotId = next_period_id(PeriodList, HotID),
			NewTurnId = next_period_id(PeriodList2, TurnID),
			Time = time:time(),
			NewHotTime =  next_period_time(PeriodList, Time),
			NewTurnTime = next_period_time(PeriodList2, Time),
			NewPeriodTime = max(NewHotTime, NewTurnTime),
			NewData = Data#db_xun_bao_period{hot_id = NewHotId, turn_id = NewTurnId, period_time = NewPeriodTime},
			table_global:insert(?TABLE_DATA, NewData),
			NewData
	end.

%% 下一个热点/轮换ID
next_period_id([], Id) -> Id;
next_period_id([_Type, _Param | List], Id) ->
	next_period_id(List, Id, hd(List)).
next_period_id([Id, NextId | _], Id, _DefaultId) ->
	NextId;
next_period_id([Id], Id, DefaultId) ->
	DefaultId;
next_period_id([_ | List], Id, DefaultId) ->
	next_period_id(List, Id, DefaultId);
next_period_id([], _Id, DefaultId) ->
	DefaultId.

%% 下一次热点/轮换时间
next_period_time([], Time) -> Time;
next_period_time([Type, Param | _List], Time) ->
	case Type of
		1 ->
			PeriodTime = time:weektime_add(Time, (Param - 1) * ?SECONDS_PER_DAY),
			case PeriodTime > Time of
				?TRUE -> PeriodTime;
				?FALSE -> time:time_add(PeriodTime, ?SECONDS_PER_WEEK)
			end;
		2 ->
			time:daytime_add(Time, Param * ?SECONDS_PER_DAY);
		3 ->
			case Param > Time of
				?TRUE -> Param;
				?FALSE -> 2147483647
			end
	end.

make_id(DataId, Level) ->
	DataId * 1000000 + Level.
