%%%-------------------------------------------------------------------
%%% @author xiexiaobo
%%% @copyright (C) 2018, Double Game
%%% @doc 寻宝记录：管理进程
%%% @end
%%% Created : 2018-12-12 10:00
%%%-------------------------------------------------------------------
-module(xun_bao_record).
-include("global.hrl").
-include("db_table.hrl").
-include("xun_bao.hrl").

-define(TABLE_DATA, db_xun_bao_record).

%%%====================================================================
%%% API functions
%%%====================================================================
-export([on_init/0, add_record/2, get_record_list/1, list_to_record/1, record_to_list/1]).
-export([get_new_record_list/2]).

%% 初始化
on_init() -> ?metrics(begin
						  List = table_global:record_list(?TABLE_DATA),
						  set_data_list(List) end).

%% 添加记录
add_record(DataId, Record) -> ?metrics(begin
										   Data = get_data(DataId),
										   #db_xun_bao_record{record_list = RecordList} = Data,
										   NewRecordList = get_new_record_list(Record, RecordList),
										   NewData = Data#db_xun_bao_record{record_list = NewRecordList},
										   update_data(NewData) end).

%% 获取记录列表
get_record_list(DataId) -> ?metrics(begin
										Data = get_data(DataId),
										Data#db_xun_bao_record.record_list end).

list_to_record(List) ->
	Record = list_to_tuple([?TABLE_DATA | List]),
	Record#db_xun_bao_record{
		record_list = gamedbProc:my_binary_to_term(Record#db_xun_bao_record.record_list, list)
	}.

record_to_list(Record) ->
	tl(tuple_to_list(Record#db_xun_bao_record{
		record_list = term_to_binary(Record#db_xun_bao_record.record_list, [compressed])
	})).

%% RecordList 时间大的在前
%% TODO 对于前端而言 普通类型的记录的物品列表中会有多条物品记录 在前端显示及计算时会被摊开成多条 因此前后端对于记录条数的判断是不同的 这里由后端首先进行筛选
get_new_record_list(Record, RecordList) when is_tuple(Record) ->
	get_new_record_list([Record], RecordList);
get_new_record_list(Record, RecordList) when is_list(Record) ->
	AllRecordList0 = Record ++ RecordList,
	AllRecordList = lists:filter(
		fun
			(#draw_record{}) ->
				?TRUE;
			(_) ->
				?FALSE
		end, AllRecordList0),
	case length(AllRecordList) < 50 of
		?TRUE ->
			AllRecordList;
		?FALSE ->
			SubRecordList = lists:sublist(AllRecordList, 50),
			AfterSubRareRecordList = [R || #draw_record{type = Type} = R <- SubRecordList, Type =:= ?RECORD_TYPE_RARE_2 orelse Type =:= ?RECORD_TYPE_EXCHANGE_3],
			case length(AfterSubRareRecordList) >= 3 of
				?TRUE ->
					SubRecordList;
				?FALSE ->
					{RareRecordList, NormalRecordList} =
						lists:partition(
							fun(#draw_record{type = Type}) ->
								Type =:= ?RECORD_TYPE_RARE_2 orelse Type =:= ?RECORD_TYPE_EXCHANGE_3
							end, AllRecordList),
					%% 保留三条
					SubRareRecordList = lists:sublist(RareRecordList, 3),
					SubNormalRecordList = lists:sublist(NormalRecordList, 47),
					lists:reverse(lists:keysort(#draw_record.time, SubRareRecordList ++ SubNormalRecordList))
			end
	end.

%%%===================================================================
%%% Internal functions
%%%===================================================================

%% 寻宝记录数据列表
set_data_list(DataList) ->
	d:storage_put(xun_bao_record_data_list, DataList).
get_data_list() ->
	d:storage_get(xun_bao_record_data_list, []).

%% 寻宝记录数据
get_data(DataId) ->
	DataList = get_data_list(),
	case lists:keyfind(DataId, #db_xun_bao_record.data_id, DataList) of
		?FALSE -> #db_xun_bao_record{data_id = DataId};
		Data -> Data
	end.
update_data(Data) ->
	table_global:insert(?TABLE_DATA, Data),
	DataList = get_data_list(),
	NewDataList = lists:keystore(Data#db_xun_bao_record.data_id, #db_xun_bao_record.data_id, DataList, Data),
	set_data_list(NewDataList).
