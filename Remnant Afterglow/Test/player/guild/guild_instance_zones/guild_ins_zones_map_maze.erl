%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%		公会副本-迷宫关
%%% @end
%%% Created : 10. 3月 2022 13:54
%%%-------------------------------------------------------------------
-module(guild_ins_zones_map_maze).
-author("suw").

%% API
%%-export([init_map/1, on_player_enter/1, on_player_trans/2, do_settle/1]).
-export([on_player_enter/1]).

-include("global.hrl").
-include("guild_instance_zones.hrl").
-include("cfg_guildCopyNode.hrl").
-include("netmsgRecords.hrl").

%%-record(maze_way, {
%%	player_id = 0,
%%	way_list = []
%%}).
%%%===================================================================
%%% API
%%%===================================================================
%%init_map(_MapParams) ->
%%	GuildID = mapSup:getMapOwnerID(),
%%	MapDataID = mapSup:getMapDataID(),
%%	{ChapterID, NodeID} = Key = guild_ins_zones_logic:map_id_to_chapter_node(MapDataID),
%%	guild_ins_zones_map_common:set_node_key(Key).
%%	case guild_ins_zones_logic:find_node(GuildID, NodeID) of
%%		{} ->
%%			Node = #guild_ins_zones_node{guild_id = GuildID, node_id = NodeID, map_pid = self()},
%%			guild_instance_zones:send_2_me({insert_new_node, ChapterID, Node}),
%%			guild_ins_zones_map_common:set_zones_node_param1(0),
%%			set_find_right_way_list([]);
%%		#guild_ins_zones_node{is_pass = IsPass, param1 = Param1, param_list = ParamList} ->
%%			guild_ins_zones_map_common:set_zones_node_param1(Param1),
%%			set_find_right_way_list(ParamList),
%%			guild_ins_zones_map_common:set_is_finish_flag(common:int_to_bool(IsPass)),
%%			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.map_pid, self()}])
%%	end.
%%

on_player_enter(PlayerID) ->
	MapDataID = mapSup:getMapDataID(),
	{ChapterID, NodeID} = guild_ins_zones_logic:map_id_to_chapter_node(MapDataID),
	map:send_client(PlayerID, #pk_GS2U_guild_ins_zones_label_info{chapter_id = ChapterID, node_id = NodeID}).
%%	mapView:add_hider(PlayerID),
%%	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
%%	Msg = #pk_GS2U_guild_ins_zones_maze_find_way{
%%		chapter_id = ChapterID,
%%		node_id = NodeID,
%%		find_way_list = get_find_right_way_list()
%%	},
%%	map:send_client([PlayerID], Msg),
%%	ok.
%%
%%on_player_trans(PlayerID, TransID) ->
%%	GuildID = mapSup:getMapOwnerID(),
%%	#maze_way{way_list = WayList} = Info = get_player_way_info(PlayerID),
%%	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
%%	#guildCopyNodeCfg{rightWay = RightWay} = cfg_guildCopyNode:row(Key),
%%	IsPass = guild_ins_zones_map_common:get_is_finish_flag(),
%%	case check_way_right(WayList, RightWay, TransID) of
%%		?FALSE -> ok;
%%		?TRUE ->
%%			case IsPass of
%%				?FALSE ->
%%					guild_instance_zones:on_update_node_element_add(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.param_list, TransID}]),
%%					add_right_way(TransID);
%%				?TRUE -> ok
%%			end,
%%			NewWayList = WayList ++ [TransID],
%%			update_player_way_info(PlayerID, Info#maze_way{way_list = NewWayList}),
%%			case check_player_pass(RightWay, NewWayList) of
%%				?FALSE -> ok;
%%				?TRUE ->
%%					case IsPass of
%%						?FALSE ->
%%							guild_instance_zones:on_update_node_element_add(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.param1, 1}]),
%%							guild_ins_zones_map_common:add_zones_node_param1(1),
%%							check_pass();
%%						?TRUE -> ok
%%					end,
%%					Msg = #pk_GS2U_guild_ins_zones_settle_maze{
%%						chapter_id = ChapterID,
%%						node_id = NodeID,
%%						is_success = 1,
%%						total_num = guild_ins_zones_map_common:get_zones_node_param1()
%%					},
%%					map:send(PlayerID, Msg)
%%			end
%%	end.
%%
%%do_settle(PlayerID) ->
%%	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
%%	Msg = #pk_GS2U_guild_ins_zones_settle_maze{
%%		chapter_id = ChapterID,
%%		node_id = NodeID,
%%		is_success = 0,
%%		total_num = guild_ins_zones_map_common:get_zones_node_param1()
%%	},
%%	map:send(PlayerID, Msg).
%%%%%===================================================================
%%%%% Internal functions
%%%%%===================================================================
%%get_player_way_info(PlayerID) ->
%%	case get({?MODULE, player_way, PlayerID}) of
%%		?UNDEFINED -> #maze_way{player_id = PlayerID};
%%		R -> R
%%	end.
%%update_player_way_info(PlayerID, Info) ->
%%	put({?MODULE, player_way, PlayerID}, Info).
%%
%%get_find_right_way_list() ->
%%	case get({?MODULE, find_right_way_list}) of
%%		?UNDEFINED -> [];
%%		L -> L
%%	end.
%%set_find_right_way_list(L) ->
%%	put({?MODULE, find_right_way_list}, L).
%%
%%add_right_way(TransID) ->
%%	List = get_find_right_way_list(),
%%	case lists:member(TransID, List) of
%%		?TRUE -> ok;
%%		?FALSE ->
%%			NewList = [TransID | List],
%%			set_find_right_way_list(NewList),
%%			{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
%%			Msg = #pk_GS2U_guild_ins_zones_maze_find_way{
%%				chapter_id = ChapterID,
%%				node_id = NodeID,
%%				find_way_list = NewList
%%			},
%%			mapView:broadcast(Msg)
%%	end.
%%
%%check_way_right([], [TransID | _T2], TransID) -> ?TRUE;
%%check_way_right([], _, _) -> ?FALSE;
%%check_way_right(_, [], _) -> ?FALSE;
%%check_way_right([_ | T1], [_ | T2], TransID) ->
%%	check_way_right(T1, T2, TransID).
%%
%%check_player_pass(L, L) -> ?TRUE;
%%check_player_pass(_, _) -> ?FALSE.
%%
%%check_pass() ->
%%	GuildID = mapSup:getMapOwnerID(),
%%	TotalN = guild_ins_zones_map_common:get_zones_node_param1(),
%%	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
%%	#guildCopyNodeCfg{success = {_, NeedN}} = cfg_guildCopyNode:row(Key),
%%	case TotalN >= NeedN of
%%		?TRUE ->
%%			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.is_pass, 1}, {#guild_ins_zones_node.is_mark, 0}]),
%%			guild_instance_zones:on_node_pass(GuildID, ChapterID, NodeID),
%%			guild_ins_zones_map_common:set_is_finish_flag(?TRUE),
%%			?TRUE;
%%		?FALSE -> ?FALSE
%%	end.