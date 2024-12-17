%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 10. 3月 2022 11:12
%%%-------------------------------------------------------------------
-module(guild_instance_zones).
-author("suw").
-behaviour(gen_server).

%% API
-export([start_link/0, cast_run/1, send_2_me/1, on_update_node_element/4, on_update_node_element_add/4, on_node_pass/3]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("global.hrl").
-include("guild_instance_zones.hrl").
-include("record.hrl").
-include("cfg_guildCopyNode.hrl").
-include("cfg_guildCopyChapter.hrl").
-include("netmsgRecords.hrl").
-include("error.hrl").
-include("map.hrl").
-include("db_shared_storage.hrl").
-include("guild.hrl").
-include("cfg_guildCopyRate.hrl").

-define(SERVER, ?MODULE).

-record(state, {}).


%%%===================================================================
%%% API
%%%===================================================================

%% @hidden
start_link() ->
	Args = [],
	gen_server:start_link({local, ?SERVER}, ?MODULE, Args, []).

%% @hidden Fun()
cast_run(Fun) when is_function(Fun, 0) ->
	gen_server:cast(?SERVER, {run, Fun}).

send_2_me(Msg) ->
	gen_server:cast(?SERVER, Msg).

on_update_node_element(GuildID, ChapterID, NodeID, ElementSpec) ->
	send_2_me({update_node_element, GuildID, ChapterID, NodeID, ElementSpec}).

on_update_node_element_add(GuildID, ChapterID, NodeID, ElementSpec) ->
	send_2_me({update_node_element_add, GuildID, ChapterID, NodeID, ElementSpec}).

on_node_pass(GuildID, ChapterID, NodeID) ->
	send_2_me({node_pass, GuildID, ChapterID, NodeID}).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

%% @hidden
init(Args) ->
	try
		do_init(Args),
		{ok, #state{}}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{stop, ExcReason}
	end.

%% @hidden
handle_call(Request, From, State) ->
	try
		Reply = do_call(Request, From),
		{reply, Reply, State}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{reply, {error, ExcReason}, State}
	end.

%% @hidden
handle_cast(Request, State) ->
	try
		do_cast(Request)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end,
	{noreply, State}.

%% @hidden
handle_info(Info, State) ->
	try
		do_cast(Info)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end,
	{noreply, State}.

%% @hidden
terminate(Reason, _State) ->
	try
		do_terminate(Reason)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end,
	ok.

%% @hidden
code_change(_OldVsn, State, _Extra) ->
	{ok, State}.


%%%===================================================================
%%% Internal functions
%%%===================================================================

-spec do_init(term()) -> any().
do_init(_Args) ->
	ets:new(?EtsGuildInsZones, [{keypos, #guild_ins_zones.guild_id}, named_table, protected, set, ?ETSRC]),
	load_data(),
	init_data(),
	ok.

-spec do_call(term(), {pid(), term()}) -> Reply :: term().
do_call(Request, From) ->
	?LOG_ERROR("no_match_call: Request=~p, From=~p", [Request, From]),
	ok.

-spec do_cast(term()) -> any().
do_cast({run, Fun}) ->
	Fun();
do_cast({insert_new_node, ChapterID, Node}) ->
	insert_new_node(ChapterID, Node);
do_cast({update_node_element, GuildID, ChapterID, NodeID, ElementSpec}) ->
	update_node_element(GuildID, ChapterID, NodeID, ElementSpec);
do_cast({update_node_element_add, GuildID, ChapterID, NodeID, ElementSpec}) ->
	update_node_element_add(GuildID, ChapterID, NodeID, ElementSpec);
do_cast({player_op_ui, PlayerID, GuildID, Op}) ->
	player_op_ui(PlayerID, GuildID, Op);
do_cast({mark_node, GuildID, ChapterID, NodeID, IsMark}) ->
	mark_node(GuildID, ChapterID, NodeID, IsMark);
do_cast({node_pass, GuildID, ChapterID, NodeID}) ->
	node_pass(GuildID, ChapterID, NodeID);
do_cast({hit_node, PlayerID, GuildID, ChapterID, NodeID, UseItem}) ->
	hit_node(PlayerID, GuildID, ChapterID, NodeID, UseItem);
do_cast({on_reset5}) ->
	reset5();
do_cast({add_collect_num, GuildID, ChapterID, EffectArea, AddItemList}) ->
	add_collect_num(GuildID, ChapterID, EffectArea, AddItemList);
do_cast({effect_list_refresh, GuildID, ChapterID, NodeID, EffectArea, NewBuff}) ->
	effect_list_refresh(GuildID, ChapterID, NodeID, EffectArea, NewBuff);
do_cast({guild_create, GuildID}) ->
	guild_create(GuildID);
do_cast({on_guild_dismiss, GuildID}) ->
	guild_dismiss(GuildID);
do_cast({add_log, GuildID, Log}) ->
	add_log(GuildID, Log);
do_cast(Request) ->
	?LOG_ERROR("no_match_cast: Request=~p", [Request]).

-spec do_terminate(term()) -> any().
do_terminate(_Reason) ->
	ok.

load_data() ->
	TableInsZonesNodeList = table_global:record_list(?TableGuildInsZonesNode),
	PartitionFunc = fun(#guild_ins_zones_node{guild_id = GuildID} = Node, Acc) ->
		case lists:keytake(GuildID, 1, Acc) of
			?FALSE -> [{GuildID, [Node]} | Acc];
			{_, {_, OldList}, Left} -> [{GuildID, [Node | OldList]} | Left]
		end
					end,
	PartitionNodeList = lists:foldl(PartitionFunc, [], TableInsZonesNodeList),
	MakeFunc = fun(#db_guild_ins_zones{guild_id = GuildID, chapter_id = ChapterID, bag_item_list = BagItemList,
		progress = Progress, yesterday_chapter_id = YesChapter, yesterday_progress = YesProgress, time = Time,
		log_data = LogData}) ->
		ZonesNodeList = case lists:keyfind(GuildID, 1, PartitionNodeList) of
							?FALSE -> [];
							{_, L} -> L
						end,
		#guild_ins_zones{
			guild_id = GuildID,
			chapter_id = ChapterID,
			zones_node_list = ZonesNodeList,
			progress = Progress,
			yesterday_chapter_id = YesChapter,
			yesterday_progress = YesProgress,
			time = Time,
			bag_item_list = BagItemList,
			log_data = LogData
		}
			   end,
	TableInsZonesList = table_global:record_list(?TableGuildInsZones),
	LoadData = lists:map(MakeFunc, TableInsZonesList),
	ets:insert(?EtsGuildInsZones, LoadData).

init_data() ->
	case table_global:size(?TableGuildInsZones) =:= 0 of
		?FALSE -> ok;
		?TRUE ->
			[check_init_next(GuildID, 1, 0) || GuildID <- guild_pub:get_all_guild_id()]
	end.

insert_new_node(ChapterID, #guild_ins_zones_node{guild_id = GuildID, node_id = NodeID} = Node) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, zones_node_list = ZonesNodeList} = Zones ->
			NewZonesNodeList = lists:keystore(NodeID, #guild_ins_zones_node.node_id, ZonesNodeList, Node),
			NewZones = Zones#guild_ins_zones{zones_node_list = NewZonesNodeList},
			update_zones(NewZones, ?TRUE),
			table_global:insert(?TableGuildInsZonesNode, Node);
		_ -> ok
	end.

%% 替换update
update_node_element(GuildID, ChapterID, NodeID, ElementSpec) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, zones_node_list = ZonesNodeList} = Zones ->
			case lists:keyfind(NodeID, #guild_ins_zones_node.node_id, ZonesNodeList) of
				?FALSE ->
					?LOG_ERROR("no data ~p", [{GuildID, NodeID, ElementSpec}]),
					ok;
				Node ->
					NewNode = lists:foldl(fun({Pos, Value}, Ret) -> setelement(Pos, Ret, Value) end, Node, ElementSpec),
					NewZones = Zones#guild_ins_zones{zones_node_list = lists:keystore(NodeID, #guild_ins_zones_node.node_id, ZonesNodeList, NewNode)},
					update_zones(NewZones, ?FALSE),
					table_global_async:insert(?TableGuildInsZonesNode, NewNode),
					check_need_sync_param(GuildID, ChapterID, NodeID, ElementSpec)
			end;
		_ -> ok
	end.


%% 加法update
update_node_element_add(GuildID, ChapterID, NodeID, ElementSpec) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, zones_node_list = ZonesNodeList} = Zones ->
			case lists:keyfind(NodeID, #guild_ins_zones_node.node_id, ZonesNodeList) of
				?FALSE ->
					?LOG_ERROR("no data ~p", [{GuildID, NodeID, ElementSpec}]),
					ok;
				Node ->
					NewNode = lists:foldl(fun({Pos, AddValue}, Ret) ->
						OldV = element(Pos, Ret),
						NewV = case is_list(OldV) of
								   ?FALSE -> max(OldV + AddValue, 0);
								   ?TRUE ->
									   common:getTernaryValue(lists:member(AddValue, OldV), OldV, [AddValue | OldV])
							   end,
						setelement(Pos, Ret, NewV) end, Node, ElementSpec),
					NewZones = Zones#guild_ins_zones{zones_node_list = lists:keystore(NodeID, #guild_ins_zones_node.node_id, ZonesNodeList, NewNode)},
					update_zones(NewZones, ?FALSE),
					table_global_async:insert(?TableGuildInsZonesNode, NewNode),
					check_need_sync_param(GuildID, ChapterID, NodeID, ElementSpec)
			end;
		_ -> ok
	end.


update_zones(Zones, IsDB) ->
	ets:insert(?EtsGuildInsZones, Zones),
	IsDB andalso table_global:insert(?TableGuildInsZones, zones_to_db_zones(Zones)).

zones_to_db_zones(Zones) ->
	#db_guild_ins_zones{
		guild_id = Zones#guild_ins_zones.guild_id,
		chapter_id = Zones#guild_ins_zones.chapter_id,
		progress = Zones#guild_ins_zones.progress,
		yesterday_chapter_id = Zones#guild_ins_zones.yesterday_chapter_id,
		yesterday_progress = Zones#guild_ins_zones.yesterday_progress,
		time = Zones#guild_ins_zones.time,
		bag_item_list = Zones#guild_ins_zones.bag_item_list,
		log_data = Zones#guild_ins_zones.log_data
	}.

player_op_ui(PlayerID, GuildID, Op) ->
	#guild_ins_zones{watching_player_list = WatchingList} = Zones = guild_ins_zones_logic:find_zones(GuildID),
	NewWatchingList = case Op of
						  0 ->
							  case lists:member(PlayerID, WatchingList) of
								  ?FALSE -> [PlayerID | WatchingList];
								  ?TRUE -> WatchingList
							  end;
						  _ -> lists:delete(PlayerID, WatchingList)
					  end,

	NewZones = Zones#guild_ins_zones{watching_player_list = NewWatchingList},
	update_zones(NewZones, ?FALSE).

check_need_sync_param(GuildID, ChapterID, NodeID, ElementSpec) ->
	NeedSyncPosList = [#guild_ins_zones_node.is_mark, #guild_ins_zones_node.is_pass, #guild_ins_zones_node.player_num,
		#guild_ins_zones_node.param1],
	case lists:any(fun(Pos) -> lists:keymember(Pos, 1, ElementSpec) end, NeedSyncPosList) of
		?TRUE ->
			#guild_ins_zones{watching_player_list = PlayerIDList, zones_node_list = ZonesNodeList} = guild_ins_zones_logic:find_zones(GuildID),
			case guild_ins_zones_logic:find_node(ZonesNodeList, NodeID) of
				#guild_ins_zones_node{is_mark = IsMark, is_pass = IsPass, player_num = PlayerNum, param1 = Param1} when PlayerIDList =/= [] ->
					Msg = #pk_GS2U_guild_ins_zones_node_param_sync{param_list = [#pk_guild_ins_zones_node_param{
						chapter_id = ChapterID,
						node_id = NodeID,
						is_mark = IsMark,
						is_pass = IsPass,
						player_num = PlayerNum,
						param1 = Param1
					}]},
					[m_send:sendMsgToClient(PlayerID, Msg) || PlayerID <- PlayerIDList];
				_ -> ok
			end;
		?FALSE -> ok
	end.

mark_node(GuildID, ChapterID, NodeID, IsMark) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, zones_node_list = ZonesNodeList} ->
			case guild_ins_zones_logic:find_node(ZonesNodeList, NodeID) of
				#guild_ins_zones_node{is_pass = 1} -> ok;
				_ ->
					case [Nid || #guild_ins_zones_node{node_id = Nid, is_mark = 1} <- ZonesNodeList, NodeID =/= Nid] of
						[] -> ok;
						List ->
							[update_node_element(GuildID, ChapterID, CancelNodeID, [{#guild_ins_zones_node.is_mark, 0}]) || CancelNodeID <- List]
					end,
					update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.is_mark, IsMark}])
			end;
		_ -> ok
	end.

node_pass(GuildID, ChapterID, NodeID) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, progress = OldProgress} = Info ->
			case cfg_guildCopyNode:getRow(ChapterID, NodeID) of
				#guildCopyNodeCfg{progress = Progress} when Progress > OldProgress ->
					NewInfo = Info#guild_ins_zones{progress = Progress, time = time:time()},
					update_zones(NewInfo, ?TRUE);
				_ -> ok
			end,
			check_init_next(GuildID, ChapterID, NodeID),
			check_first_pass(GuildID, ChapterID, NodeID);
		_ -> ok
	end.

reset5() ->
	lists:foreach(fun(#guild_ins_zones{guild_id = GuildID, chapter_id = ChapterID, progress = Progress} = Info) ->
		WeekNum = time:day_of_week(),
		case WeekNum =:= 1 of
			?TRUE ->
				#guildCopyChapterCfg{firstReward = RewardList, firstRewardNum = RewardNum} = cfg_guildCopyChapter:getRow(ChapterID),
				List = [{Cfg#guildCopyRateCfg.progress, Idx} || {Cp, Idx} = K <- cfg_guildCopyRate:getKeyList(),
					Cp =:= ChapterID, (Cfg = cfg_guildCopyRate:row(K)) =/= {}],
				{_, Index} = common:getValueByInterval(Progress, List, {0, 0}),
				case lists:keyfind(Index, 1, RewardList) of
					?FALSE -> ok;
					{_, ItemID} ->
						guild:send_2_me({add_assign_award_item, GuildID, lists:duplicate(RewardNum, ItemID), ?AssignAwardTypeGuildInsZones, 2})
				end;
			?FALSE -> ok
		end,
		case Progress >= 10000 andalso WeekNum =:= 1 of
			?TRUE ->
				#guildCopyChapterCfg{maxID = MaxID} = cfg_guildCopyChapter:first_row(),
				NextChapterID = case ChapterID < MaxID of
									?TRUE ->
										NewChapterID = ChapterID + 1,
										#guildCopyChapterCfg{week = NeedWeek} = cfg_guildCopyChapter:getRow(NewChapterID),
										NowWeekNumber = time:week_number(time:time()) - time:week_number(main:getServerStartTime()),
										common:getTernaryValue(NowWeekNumber >= NeedWeek, NewChapterID, ChapterID);
									?FALSE -> ChapterID
								end,
				NextZones = #guild_ins_zones{guild_id = GuildID, chapter_id = NextChapterID, yesterday_progress = Progress, yesterday_chapter_id = ChapterID},
				update_zones(NextZones, ?TRUE),
				DelKeyList = [K || {Gid, _} = K <- table_global:key_list(?TableGuildInsZonesNode), Gid =:= GuildID],
				table_global:delete(?TableGuildInsZonesNode, DelKeyList),
				[main:sendMsgToMapByOwner(MapAI, GuildID, {quit}) || MapAI <- ?MultiPlayerMapAIList];
			?FALSE ->
				NewZones = Info#guild_ins_zones{yesterday_progress = Progress, yesterday_chapter_id = ChapterID},
				update_zones(NewZones, ?TRUE)
		end

				  end, ets:tab2list(?EtsGuildInsZones)).

add_collect_num(GuildID, ChapterID, EffectArea, AddItemList) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, bag_item_list = OldBagItemList} = Info ->
			NewBagItemList = case lists:keytake(EffectArea, 1, OldBagItemList) of
								 ?FALSE -> [{EffectArea, AddItemList} | OldBagItemList];
								 {_, {_, OldItemList}, Left} ->
									 [{EffectArea, common:listValueMerge(OldItemList ++ AddItemList)} | Left]
							 end,
			NewInfo = Info#guild_ins_zones{bag_item_list = NewBagItemList},
			update_zones(NewInfo, ?TRUE);
		_ -> ok
	end.

effect_list_refresh(GuildID, ChapterID, NodeID, EffectArea, {Type, BuffID}) ->
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = ChapterID, zones_node_list = ZonesNodeList} = Zones ->
			case lists:keyfind(EffectArea, #guild_ins_zones_node.node_id, ZonesNodeList) of
				?FALSE ->
					ok;
				#guild_ins_zones_node{effect_list = EffectList, map_pid = MapPid} = Node ->
					NewEffectList = lists:keystore(NodeID, 1, EffectList, {NodeID, Type, BuffID}),
					NewNode = Node#guild_ins_zones_node{effect_list = NewEffectList},
					NewZones = Zones#guild_ins_zones{zones_node_list = lists:keystore(EffectArea, #guild_ins_zones_node.node_id, ZonesNodeList, NewNode)},
					update_zones(NewZones, ?FALSE),
					table_global_async:insert(?TableGuildInsZonesNode, NewNode),
					common:is_local_process_alive(MapPid) andalso (MapPid ! {guild_ins_zones_map_msg, {refresh_effect_buff, Type, BuffID}})
			end;
		_ -> ok
	end.

check_init_next(GuildID, PassChapterID, 0) ->
	KeyList = [K || {C, _} = K <- cfg_guildCopyNode:getKeyList(), C =:= PassChapterID],
	#guild_ins_zones{zones_node_list = ZonesNodeList} = guild_ins_zones_logic:find_zones(GuildID),
	lists:foreach(fun(Key) ->
		case cfg_guildCopyNode:row(Key) of
			#guildCopyNodeCfg{nodeID = NodeID, priorPoint2 = [], mapId = MapID} when MapID > 0 ->
				case guild_ins_zones_logic:find_node(ZonesNodeList, NodeID) =:= {} of
					?TRUE ->
						{ok, _} = map_server:request_map_by_id(MapID, #mapParams{}, GuildID);
					?FALSE -> ok
				end;
			_ -> ok
		end
				  end, KeyList);
check_init_next(GuildID, PassChapterID, PassNodeID) ->
	KeyList = [K || {C, _} = K <- cfg_guildCopyNode:getKeyList(), C =:= PassChapterID],
	#guild_ins_zones{zones_node_list = ZonesNodeList} = guild_ins_zones_logic:find_zones(GuildID),
	lists:foreach(fun(Key) ->
		case cfg_guildCopyNode:row(Key) of
			#guildCopyNodeCfg{nodeID = NodeID, priorPoint2 = Prior, mapId = MapID} when MapID > 0 ->
				case lists:keymember(PassNodeID, 3, Prior) andalso guild_ins_zones_logic:check_guild_node_open(GuildID, PassChapterID, NodeID) andalso
					guild_ins_zones_logic:find_node(ZonesNodeList, NodeID) =:= {} of
					?TRUE ->
						{ok, _} = map_server:request_map_by_id(MapID, #mapParams{}, GuildID);
					?FALSE -> ok
				end;
			_ -> ok
		end
				  end, KeyList).

guild_create(GuildID) ->
	check_init_next(GuildID, 1, 0).

guild_dismiss(GuildID) ->
	table_global:delete(?TableGuildInsZones, [GuildID]),
	ets:delete(?EtsGuildInsZones, GuildID),
	DelKeyList = [K || {Gid, _} = K <- table_global:key_list(?TableGuildInsZonesNode), Gid =:= GuildID],
	table_global:delete(?TableGuildInsZonesNode, DelKeyList),
	[main:sendMsgToMapByOwner(MapAI, GuildID, {quit}) || MapAI <- ?MultiPlayerMapAIList].

hit_node(PlayerID, GuildID, ChapterID, NodeID, {ItemID, Num} = UseItem) ->
	try

		#guild_ins_zones{chapter_id = GuildChapterID, zones_node_list = NodeList, bag_item_list = BagItemList} = Info = guild_ins_zones_logic:find_zones(GuildID),
		?CHECK_THROW(ChapterID =:= GuildChapterID, ?ERROR_Param),
		Cfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(Cfg),
		#guildCopyNodeCfg{mapId = MapID, playType = PlayType} = Cfg,
		?CHECK_THROW(PlayType =:= ?GuildInsMapTypeBoss, ?ERROR_Param),
		[Tuple] = df:getGlobalSetupValueList(markUserLirr, [{}]),
		AllowList = tuple_to_list(Tuple),
		MyRank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(lists:member(MyRank, AllowList), ?ErrorCode_GuildInsZones_NoPermission),
		NodeInfo = guild_ins_zones_logic:find_node(NodeList, NodeID),
		case NodeInfo of
			#guild_ins_zones_node{is_pass = 0} -> ok;
			_ -> throw(?ErrorCode_GuildInsZones_Pass)
		end,
		?CHECK_THROW(guild_ins_zones_logic:check_item_use(NodeID, [UseItem], BagItemList), ?ErrorCode_GuildInsZones_ItemUse),
		NewBagItemList = guild_ins_zones_logic:dec_item_use(NodeID, [UseItem], BagItemList),
		update_zones(Info#guild_ins_zones{bag_item_list = NewBagItemList}, ?TRUE),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_ins_zones_hit_ret{chapter_id = ChapterID, node_id = NodeID, err_code = ?ERROR_OK, use_item = #pk_key_value{key = ItemID, value = Num}}),
		MapPid = case is_process_alive(NodeInfo#guild_ins_zones_node.map_pid) of
					 ?TRUE -> NodeInfo#guild_ins_zones_node.map_pid;
					 ?FALSE ->
						 {ok, #map{map_pid = Pid}} = map_server:request_map_by_id(MapID, #mapParams{}, GuildID),
						 Pid
				 end,
		MapPid ! {guild_ins_zones_map_msg, {hit_hp, PlayerID, UseItem}}
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_ins_zones_hit_ret{chapter_id = ChapterID, node_id = NodeID, err_code = Err})
	end.

add_log(GuildID, Log) ->
	LogChapterID = Log#guild_ins_zones_log.chapter_id,
	case guild_ins_zones_logic:find_zones(GuildID) of
		#guild_ins_zones{chapter_id = LogChapterID, log_data = LogData} = Zones ->
			update_zones(Zones#guild_ins_zones{log_data = [Log | LogData]}, ?TRUE);
		_ -> ok
	end.

check_first_pass(GuildID, ChapterID, NodeID) ->
	case cfg_guildCopyNode:getRow(ChapterID, NodeID) of
		#guildCopyNodeCfg{playType = PlayType, firstRedBag = FirstRedBag, firstReward = FirstReward} when PlayType =:= ?GuildInsMapTypeBoss ->
			OldPassList = db_shared_storage:get_value(?GUILD_INS_ZONES_FIRST_PASS, []),
			case lists:keymember({ChapterID, NodeID}, 1, OldPassList) of
				?TRUE -> ok;
				?FALSE ->
					db_shared_storage:set_value(?GUILD_INS_ZONES_FIRST_PASS, [{{ChapterID, NodeID}, GuildID, guild_pub:get_guild_name(GuildID)} | OldPassList]),
					case guild_pub:find_guild(GuildID) of
						{} -> ok;
						Guild ->
							case FirstRedBag of
								{0, 0} -> ok;
								{Money, Num} ->
									m_guild_envelope:create_envelope(Guild#guild_base.id, Guild#guild_base.chairmanPlayerID, 8, Money, Num, "")
							end,
							case FirstReward of
								{0, 0} -> ok;
								{ItemID, ItemNum} ->
									guild:send_2_me({add_assign_award_item, GuildID, lists:duplicate(ItemNum, ItemID), ?AssignAwardTypeGuildInsZones, 1})
							end
					end
			end;
		_ -> ok
	end.
