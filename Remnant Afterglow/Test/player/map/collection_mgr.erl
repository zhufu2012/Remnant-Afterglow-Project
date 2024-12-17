%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 通用刷新采集物
%%% @end
%%% Created : 24. 八月 2018 14:32
%%%-------------------------------------------------------------------
-module(collection_mgr).
-author("zhangrj").
-include("record.hrl").
-include("collection.hrl").
-include("cfg_mapCollectionInfo.hrl").
-include("cfg_mapCollectionBorn.hrl").
-include("logger.hrl").
-include("map.hrl").

%% API
-export([
	do_map_init/0,
	save_start_type1_time/0,
	type1_end/0,
	on_tick/1,
	on_collection_dead/1,
	daily_reset/0,
	on_active_start/1,
	on_active_end/1
]).

do_map_init() ->
	put(?CollectionFreshList, []),
	init_check_fresh(),
	ok.

%% 获取地图所有采集物配置ID
get_map_collection_ids() ->
	MapDataID = mapSup:getMapDataID(),
	Keys = cfg_mapCollectionInfo:getKeyList(),
	[R || {Map_data_id, _} = R <- Keys, Map_data_id =:= MapDataID].

%% 获取地图未刷新的采集物配置ID
get_map_collection_ids_ex() ->
	Keys = get_map_collection_ids(),
	Func =
		fun({_MapDataID, BornID} = Key, RetKeys) ->
			case is_has_fresh(BornID) of
				?TRUE -> RetKeys;
				?FALSE -> RetKeys ++ [Key]
			end
		end,
	lists:foldl(Func, [], Keys).

init_check_fresh() ->
	Keys = get_map_collection_ids(),
	lists:foreach(fun(Key) -> check_fresh(Key) end, Keys).

check_fresh({MapDataID, BornID}) ->
	R = cfg_mapCollectionInfo:getRow(MapDataID, BornID),
	init_fresh_by_type(R#mapCollectionInfoCfg.bornType, R).

%% 保存采集物刷新信息
put_collection_refresh(List) ->
	put(?CollectionFreshList, List).
get_collection_refresh() ->
	case get(?CollectionFreshList) of
		?UNDEFINED -> [];
		List -> List
	end.
store_collection_refresh(Info) ->
	List = get_collection_refresh(),
	NewList = lists:keystore(Info#collectionFresh.id, #collectionFresh.id, List, Info),
	put_collection_refresh(NewList).
%% 仅用作45类型刷新时删除老的信息
delete_collection_refresh(Index) ->
	List = get_collection_refresh(),
	NewList = [R || R <- List, R#collectionFresh.cur_index =/= Index],
	put_collection_refresh(NewList).

%% 保存刷新ID（自增）
put_collection_add_id(ID) ->
	put(collectionAddID, ID).
get_collection_add_id() ->
	case get(collectionAddID) of
		?UNDEFINED -> 1;
		ID -> ID + 1
	end.

%% 保存已经刷新的采集物波数序号
add_has_fresh_ids(ID) ->
	List = get_has_fresh_ids(),
	case lists:member(ID, List) of
		?TRUE -> ok;
		?FALSE -> put_has_fresh_ids([ID | List])
	end.
del_has_fresh_ids(ID) ->
	List = get_has_fresh_ids(),
	put_has_fresh_ids(lists:delete(ID, List)).
is_has_fresh(ID) ->
	List = get_has_fresh_ids(),
	lists:member(ID, List).
put_has_fresh_ids(List) ->
	put(has_fresh_collection_ids, List).
get_has_fresh_ids() ->
	case get(has_fresh_collection_ids) of
		?UNDEFINED -> [];
		List -> List
	end.

%% 保存活动开始时间
save_start_type1_time() ->
	clean_collection_fresh(1),
	NowTime = time:time(),
	put(collection_type1_start_time, NowTime).
type1_end() ->
	clean_collection_fresh(1),
	put(collection_type1_start_time, 0).
%% 0表示活动还没开始
get_start_type1_time() ->
	case get(collection_type1_start_time) of
		?UNDEFINED -> 0;
		Time -> Time
	end.

%% 初始化刷新
init_fresh_by_type(1, R) ->
	case get_start_type1_time() of
		0 -> ok;
		Time ->
			NowTime = time:time(),
			[Integral, _, ID] = R#mapCollectionInfoCfg.born,
			case NowTime >= Time + Integral of
				?TRUE -> fresh_collection(R, cfg_mapCollectionBorn:getRow(ID), NowTime, 1);
				?FALSE -> ok
			end
	end;
init_fresh_by_type(2, R) ->
	[StartTime, _, ID] = R#mapCollectionInfoCfg.born,
	NowTime = time:time(),
	case time:daytime_offset(NowTime) >= StartTime of
		?TRUE -> fresh_collection(R, cfg_mapCollectionBorn:getRow(ID), NowTime, 1);
		?FALSE -> ok
	end;
init_fresh_by_type(3, R) ->
	[StartTime, _, ID] = R#mapCollectionInfoCfg.born,
	NowTime = time:time(),
	case time:daytime_offset(NowTime) >= StartTime of
		?TRUE -> fresh_collection(R, cfg_mapCollectionBorn:getRow(ID), NowTime, 1);
		?FALSE -> ok
	end;
init_fresh_by_type(_, _) ->
	ok.

%% 刷新波次
fresh_collection(CfgInfo, {}, _FirstTime, _CurWave) ->
	?LOG_INFO("fresh_collection has no config ~p", [CfgInfo#mapCollectionInfoCfg.born]),
	ok;
fresh_collection(CfgInfo, CfgBorn, FirstTime, CurWave) ->
	%% 采集物1
	case CfgBorn#mapCollectionBornCfg.collection1 of
		[ID1, Num1 | _] ->
			PosList1 = find_pos(0, Num1, CfgBorn#mapCollectionBornCfg.pos1, CfgBorn#mapCollectionBornCfg.pos1, []),
			add_collection_list(ID1, CfgInfo, FirstTime, CurWave, PosList1);
		_ -> ok
	end,

	%% 采集物234
	CollectionList = CfgBorn#mapCollectionBornCfg.collection234,
	Func =
		fun({ID, Num2, Num3, Num4}, {List2, List3, List4}) ->
			PosList2 = find_pos(0, Num2, List2, CfgBorn#mapCollectionBornCfg.pos2, []),
			add_collection_list(ID, CfgInfo, FirstTime, CurWave, PosList2),
			PosList3 = find_pos(0, Num3, List3, CfgBorn#mapCollectionBornCfg.pos3, []),
			add_collection_list(ID, CfgInfo, FirstTime, CurWave, PosList3),
			PosList4 = find_pos(0, Num4, List4, CfgBorn#mapCollectionBornCfg.pos4, []),
			add_collection_list(ID, CfgInfo, FirstTime, CurWave, PosList4),
			{List2 -- PosList2, List3 -- PosList3, List4 -- PosList4}
		end,
	lists:foldl(Func, {CfgBorn#mapCollectionBornCfg.pos2, CfgBorn#mapCollectionBornCfg.pos3, CfgBorn#mapCollectionBornCfg.pos4}, CollectionList),
	add_has_fresh_ids(CfgInfo#mapCollectionInfoCfg.bornID),
	ok.

%% 查找合适的位置
find_pos(MaxNum, MaxNum, _PosList, _AllPos, RetList) -> RetList;
find_pos(Num, MaxNum, [], AllPos, RetList) ->
	find_pos(Num, MaxNum, AllPos, AllPos, RetList);
find_pos(Num, MaxNum, PosList, AllPos, RetList) ->
	Rand = rand:uniform(length(PosList)),
	Pos = lists:nth(Rand, PosList),
	NewPosList = lists:delete(Pos, PosList),
	find_pos(Num + 1, MaxNum, NewPosList, AllPos, [Pos | RetList]).

add_collection_list(_ID, _CfgInfo, _FirstTime, _CurWave, []) -> ok;
add_collection_list(ID, CfgInfo, FirstTime, CurWave, [Pos | T]) ->
	add_collection(ID, CfgInfo, Pos, FirstTime, CurWave),
	add_collection_list(ID, CfgInfo, FirstTime, CurWave, T).

%% 添加采集物
add_collection(ID, CfgInfo, Pos, FirstTime, CurWave) ->
	IndexID = get_collection_add_id(),
	NowTime = time:time(),
	Info = #collectionFresh{
		id = IndexID,
		co_data_id = ID,
		cur_index = CfgInfo#mapCollectionInfoCfg.bornID,
		next_index = CfgInfo#mapCollectionInfoCfg.next,
		cur_wave = CurWave,
		fresh_type = CfgInfo#mapCollectionInfoCfg.bornType,
		first_time = FirstTime,
		fresh_time = NowTime,
		pos = Pos
	},
	add_collection(Info),
	put_collection_add_id(IndexID).
add_collection(Info) ->
	{X, Z, RotW} = Info#collectionFresh.pos,
	ObjectID = collection:addCollection(Info#collectionFresh.co_data_id, X, Z, RotW),
	store_collection_refresh(Info#collectionFresh{co_id = ObjectID}),
	ok.

on_tick(_TimesTamp) ->
	%% 刷第一波的(1,2,3类型）
	NewInitList = get_map_collection_ids_ex(),
	lists:foreach(fun(Key) -> check_fresh(Key) end, NewInitList),
	%% 持续刷 (3,4,5类型）
	List = get_collection_refresh(),
	tick_check(List, []),
	ok.

tick_check([], _List) -> ok;
tick_check([Info | T], List) ->
	case (not lists:member(Info#collectionFresh.cur_index, List)) orelse Info#collectionFresh.fresh_type =:= 3 of
		?TRUE ->
			case Info#collectionFresh.fresh_type =:= 3 of
				?TRUE ->    %% 每采集掉一个 补充一个 维持总数
					check_type_3(Info);
				?FALSE ->
					NextCfg = cfg_mapCollectionInfo:getRow(mapSup:getMapDataID(), Info#collectionFresh.next_index),
					case NextCfg of
						{} -> ok;
						_ ->
							case NextCfg#mapCollectionInfoCfg.bornType of
								4 -> check_type_4(Info, NextCfg);
								5 -> check_type_5(Info, NextCfg);
								_ -> ok
							end
					end
			end,
			tick_check(T, [Info#collectionFresh.cur_index | List]);
		?FALSE -> tick_check(T, List)
	end.

check_type_3(Info) when Info#collectionFresh.dead_time > 0 ->
	#mapCollectionInfoCfg{born = [_, Integral, BornPosID | _]} = cfg_mapCollectionInfo:getRow(mapSup:getMapDataID(), Info#collectionFresh.cur_index),
	NowTime = time:time(),
	case NowTime >= Info#collectionFresh.dead_time + Integral of
		?TRUE ->
			BornCfg = cfg_mapCollectionBorn:getRow(BornPosID),
			case lists:member(Info#collectionFresh.co_data_id, BornCfg#mapCollectionBornCfg.collection1) of
				?TRUE -> PosList = BornCfg#mapCollectionBornCfg.pos1;
				?FALSE ->
					PosList = BornCfg#mapCollectionBornCfg.pos2 ++ BornCfg#mapCollectionBornCfg.pos3 ++ BornCfg#mapCollectionBornCfg.pos4
			end,
			FreshPosList = [R#collectionFresh.pos || R <- get_collection_refresh(),
				R#collectionFresh.cur_index =:= Info#collectionFresh.cur_index,
				R#collectionFresh.id =/= Info#collectionFresh.id],
			PrePosList = PosList -- FreshPosList,
			RealPosList = common:getTernaryValue(PrePosList =:= [], PosList, PrePosList),
			Pos = lists:nth(rand:uniform(length(RealPosList)), RealPosList),
			%% 补充一个新的采集物
			NewInfo = Info#collectionFresh{
				fresh_time = NowTime,
				dead_time = 0,
				pos = Pos
			},
			add_collection(NewInfo),
			ok;
		?FALSE -> ok
	end;
check_type_3(_Info) ->
	ok.

check_type_4(CurInfo, NextCfg) ->
	NowTime = time:time(),
	#mapCollectionInfoCfg{born = [Integral, StopTime, BornPosID | _], bornID = NextBornID} = NextCfg,
	StartTime = get_start_type1_time(),
	Finish = (StartTime =:= 0 orelse NowTime >= StartTime + StopTime) andalso StopTime =/= -1,
	case NowTime > CurInfo#collectionFresh.fresh_time + Integral andalso not Finish of
		?TRUE ->
			BornCfg = cfg_mapCollectionBorn:getRow(BornPosID),
			delete_collection_refresh(CurInfo#collectionFresh.cur_index),
			CurWave = CurInfo#collectionFresh.cur_wave,
			NextWave = common:getTernaryValue(CurInfo#collectionFresh.cur_index =:= NextBornID, CurWave + 1, 1),
			fresh_collection(NextCfg, BornCfg, CurInfo#collectionFresh.first_time, NextWave);
		?FALSE -> ok
	end.

check_type_5(CurInfo, NextCfg) ->
	NowTime = time:time(),
	#mapCollectionInfoCfg{born = [Integral, MaxWave, BornPosID | _], bornID = NextBornID} = NextCfg,
	Finish = CurInfo#collectionFresh.cur_wave >= MaxWave andalso MaxWave =/= -1,
	DeadTimeList = [R#collectionFresh.dead_time || R <- get_collection_refresh(),
		R#collectionFresh.cur_index =:= CurInfo#collectionFresh.cur_index],

	AllDeadTime = lists:foldl(fun(DeadTime, T) ->
		common:getTernaryValue(DeadTime =:= 0, 0, max(DeadTime, T)) end, 0, DeadTimeList),
	case AllDeadTime > 0 andalso NowTime > AllDeadTime + Integral andalso not Finish of
		?TRUE ->
			BornCfg = cfg_mapCollectionBorn:getRow(BornPosID),
			delete_collection_refresh(CurInfo#collectionFresh.cur_index),
			CurWave = CurInfo#collectionFresh.cur_wave,
			NextWave = common:getTernaryValue(CurInfo#collectionFresh.cur_index =:= NextBornID, CurWave + 1, 1),
			fresh_collection(NextCfg, BornCfg, CurInfo#collectionFresh.first_time, NextWave);
		?FALSE -> ok
	end.

%% 采集物死亡
on_collection_dead(ObjectID) ->
	List = get_collection_refresh(),
	case lists:keyfind(ObjectID, #collectionFresh.co_id, List) of
		?FALSE -> ok;
		Info -> store_collection_refresh(Info#collectionFresh{dead_time = time:time()})
	end.

%% 清除某类型的数据
clean_collection_fresh(Type) ->
	Keys = get_map_collection_ids(),
	Func =
		fun({MapDataID, BornID}) ->
			#mapCollectionInfoCfg{bornType = BornType, next = NextID} = cfg_mapCollectionInfo:getRow(MapDataID, BornID),
			case BornType =:= Type of
				?TRUE ->
					delete_collection_refresh(BornID),
					delete_collection_refresh(NextID),
					del_has_fresh_ids(BornID),
					del_has_fresh_ids(NextID);
				?FALSE -> ok
			end
		end,
	lists:foreach(Func, Keys).

daily_reset() ->
	clean_collection_fresh(2),
	clean_collection_fresh(3),
	ok.
%% ---------------- 公共进程调用 -----------
on_active_start(MapDataID) ->
	MapList = map_server:lookup_map_by_id(MapDataID),
	lists:foreach(fun(#map{map_pid = MapPid}) -> MapPid ! {on_active_start} end, MapList).

on_active_end(MapDataID) ->
	MapList = map_server:lookup_map_by_id(MapDataID),
	lists:foreach(fun(#map{map_pid = MapPid}) -> MapPid ! {on_active_end} end, MapList).