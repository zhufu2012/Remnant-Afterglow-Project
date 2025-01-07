%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%		公会副本-采集关
%%% @end
%%% Created : 10. 3月 2022 13:51
%%%-------------------------------------------------------------------
-module(guild_ins_zones_map_collect).
-author("suw").

%% API
-export([init_map/1, on_tick/1, on_coll_dead/3, on_player_enter/1, on_player_exit/1, do_settle/1, fix_col_time/1]).

-include("global.hrl").
-include("guild_instance_zones.hrl").
-include("cfg_guildCopyNode.hrl").
-include("record.hrl").
-include("netmsgRecords.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init_map(_MapParams) ->
	GuildID = mapSup:getMapOwnerID(),
	MapDataID = mapSup:getMapDataID(),
	{ChapterID, NodeID} = Key = guild_ins_zones_logic:map_id_to_chapter_node(MapDataID),
	guild_ins_zones_map_common:set_node_key(Key),
	#guildCopyNodeCfg{collectionPos1 = PosList, collectionBorn = {CollDataID, Num, Internal}} = cfg_guildCopyNode:row(Key),
	CollList = lists:map(fun({X, Y, R}) ->
		{collection:addCollection(CollDataID, X, Y, R), CollDataID, Internal, 0} end, common:getRandomSubList(PosList, Num)),
	set_coll_info({CollList, PosList}),
	case guild_ins_zones_logic:find_node(GuildID, NodeID) of
		{} ->
			Node = #guild_ins_zones_node{guild_id = GuildID, node_id = NodeID, map_pid = self()},
			guild_instance_zones:send_2_me({insert_new_node, ChapterID, Node}),
			guild_ins_zones_map_common:set_zones_node_param1(0);
		#guild_ins_zones_node{param1 = P1} ->
			guild_ins_zones_map_common:set_zones_node_param1(P1),
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.map_pid, self()}])
	end.

on_tick(TimesTamp) ->
	guild_ins_zones_map_common:check_time_out(TimesTamp),
	check_coll_refresh(TimesTamp),
	case guild_ins_zones_map_common:get_cond_change_flag() of
		?TRUE ->
			guild_ins_zones_map_common:set_cond_change_flag(?FALSE),
			GuildID = mapSup:getMapOwnerID(),
			{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID,
				[{#guild_ins_zones_node.param1, guild_ins_zones_map_common:get_zones_node_param1()}]),
			sync_label_info();
		?FALSE -> ok
	end.

on_coll_dead(PlayerID, CollectionID, DataID) ->
	case guild_ins_zones_map_common:get_is_finish_flag() of
		?FALSE ->
			case mapdb:getMapPlayer(PlayerID) of
				{} -> skip;
				#mapPlayer{} ->
					{CollInfo, BornList} = get_coll_info(),
					case lists:keytake(CollectionID, 1, CollInfo) of
						?FALSE ->
							?LOG_ERROR("can't find PlayerID ~p, CollectionID ~p, DataID ~p", [PlayerID, CollectionID, DataID]);
						{_, {ID, DataID, Internal, _}, LeftList} ->
							guild_ins_zones_map_common:set_cond_change_flag(?TRUE),
							NewCollInfo = [{ID, DataID, Internal, map:timesTamp() + Internal} | LeftList],
							set_coll_info({NewCollInfo, BornList}),
							GuildID = mapSup:getMapOwnerID(),
							{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
							guild_ins_zones_map_common:add_zones_node_param1(1),
							#guildCopyNodeCfg{rewardItem1 = RewardItemList, effectArea = EffectArea, collectionLimitReward = PassAward} = cfg_guildCopyNode:row(Key),
							AwardItem1 = case lists:keyfind(DataID, 1, RewardItemList) of
											 {_, ItemID, NumMin, NumMax} ->
												 GetNum = common:rand(NumMin, NumMax),
												 [{ItemID, GetNum}];
											 _ -> []
										 end,
							IsPass = check_pass(),
							AwardItem2 = case IsPass of
											 ?TRUE -> PassAward;
											 ?FALSE -> []
										 end,
							add_player_collect_num(PlayerID, 1),
							add_player_collect_item(PlayerID, AwardItem1),
							add_guild_collect_item(AwardItem2 ++ AwardItem1),

							guild_instance_zones:send_2_me({add_collect_num, GuildID, ChapterID, EffectArea, AwardItem2 ++ AwardItem1}),
							case IsPass of
								?TRUE ->
									Param1 = guild_ins_zones_map_common:get_zones_node_param1(),
									GuildTotalItem = get_guild_collect_item(),
									lists:foreach(fun(TPlayerID) ->
										case guild_ins_zones_map_common:is_not_game_over(TPlayerID) of
											?TRUE ->
												Msg = #pk_GS2U_guild_ins_zones_settle_collect{
													chapter_id = ChapterID,
													node_id = NodeID,
													total_num = Param1,
													is_success = 1,
													item_list = [#pk_key_value{key = ItemID, value = Num} || {ItemID, Num} <- get_player_collect_item(TPlayerID)],
													total_item_list = [#pk_key_value{key = ItemID, value = Num} || {ItemID, Num} <- GuildTotalItem]
												},
												map:send_client(TPlayerID, Msg);
											?FALSE -> ok
										end
												  end, mapdb:getMapPlayerIDList());
								?FALSE -> ok
							end
					end
			end;
		?TRUE -> ok
	end.


on_player_enter(PlayerID) ->
	GuildID = mapSup:getMapOwnerID(),
	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{stayTime = StayTime} = cfg_guildCopyNode:row(Key),
	guild_ins_zones_map_common:add_player_stay_time(PlayerID, StayTime),
	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.player_num, length(mapdb:getMapPlayerIDList())}]),
	guild_ins_zones_map_common:set_cond_change_flag(?TRUE),
	map:send_client(PlayerID, #pk_GS2U_CopyMapLeftTime{leftTime = StayTime}).

on_player_exit(PlayerID) ->
	guild_ins_zones_map_common:del_game_over_list(PlayerID),
	erase_player_collect_num(PlayerID),
	erase_player_collect_item(PlayerID),
	GuildID = mapSup:getMapOwnerID(),
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.player_num, length(mapdb:getMapPlayerIDList()) - 1}]),
	guild_ins_zones_map_common:set_cond_change_flag(?TRUE).

do_settle(PlayerID) ->
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	Msg = #pk_GS2U_guild_ins_zones_settle_collect{
		chapter_id = ChapterID,
		node_id = NodeID,
		total_num = guild_ins_zones_map_common:get_zones_node_param1(),
		is_success = 0,
		item_list = [#pk_key_value{key = ItemID, value = Num} || {ItemID, Num} <- get_player_collect_item(PlayerID)],
		total_item_list = [#pk_key_value{key = ItemID, value = Num} || {ItemID, Num} <- get_guild_collect_item()]
	},
	map:send(PlayerID, Msg),
	GuildID = mapSup:getMapOwnerID(),
	guild_ins_zones_map_common:challenge_log(GuildID, 1, PlayerID, ChapterID, NodeID, 0, 0, 0, 0, get_player_collect_num(PlayerID), guild_ins_zones_map_common:get_zones_node_param1()).

fix_col_time(ColTime) ->
	Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{collectionTime = ColTimeList} = cfg_guildCopyNode:row(Key),
	Num = length(mapdb:getMapPlayerIDList()),
	{_, Per} = common:getTernaryValue(Num, ColTimeList, {1, 10000}),
	trunc(ColTime * Per / 10000).
%%%===================================================================
%%% Internal functions
%%%===================================================================
check_coll_refresh(Time) ->
	{CollInfo, BornList} = get_coll_info(),
	Func = fun({ID, DataID, Internal, RefreshTime}, Ret) ->
		case RefreshTime =/= 0 andalso Time >= RefreshTime of
			?TRUE ->
				[{X, Y, R}] = common:getRandomSubList(BornList, 1),
				[{collection:addCollection(DataID, X, Y, R), DataID, Internal, 0} | Ret];
			?FALSE -> [{ID, DataID, Internal, RefreshTime} | Ret]
		end
		   end,
	NewCollInfo = lists:foldl(Func, [], CollInfo),
	set_coll_info({NewCollInfo, BornList}).

get_coll_info() ->
	case get({?MODULE, 'get_coll_info'}) of
		?UNDEFINED -> {[], []};
		R -> R
	end.
set_coll_info(Info) -> put({?MODULE, 'get_coll_info'}, Info).

get_player_collect_num(PlayerID) ->
	case get({?MODULE, player_collect_num, PlayerID}) of
		?UNDEFINED -> 0;
		L -> L
	end.
set_player_collect_num(PlayerID, List) ->
	put({?MODULE, player_collect_num, PlayerID}, List).
add_player_collect_num(PlayerID, AddV) ->
	set_player_collect_num(PlayerID, get_player_collect_num(PlayerID) + AddV).
erase_player_collect_num(PlayerID) ->
	erase({?MODULE, player_collect_num, PlayerID}).

get_player_collect_item(PlayerID) ->
	case get({?MODULE, player_collect_item, PlayerID}) of
		?UNDEFINED -> [];
		L -> L
	end.
set_player_collect_item(PlayerID, List) ->
	put({?MODULE, player_collect_item, PlayerID}, List).
add_player_collect_item(PlayerID, AddL) ->
	set_player_collect_item(PlayerID, common:listValueMerge(AddL ++ get_player_collect_item(PlayerID))).
erase_player_collect_item(PlayerID) ->
	erase({?MODULE, player_collect_item, PlayerID}).

get_guild_collect_item() ->
	case get({?MODULE, guild_collect_item}) of
		?UNDEFINED -> [];
		L -> L
	end.
set_guild_collect_item(List) ->
	put({?MODULE, guild_collect_item}, List).
add_guild_collect_item(AddL) ->
	set_guild_collect_item(common:listValueMerge(AddL ++ get_guild_collect_item())).

check_pass() ->
	GuildID = mapSup:getMapOwnerID(),
	TotalN = guild_ins_zones_map_common:get_zones_node_param1(),
	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{success = {_, NeedN}} = cfg_guildCopyNode:row(Key),
	case TotalN >= NeedN of
		?TRUE ->
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.is_pass, 1}, {#guild_ins_zones_node.is_mark, 0}]),
			guild_instance_zones:on_node_pass(GuildID, ChapterID, NodeID),
			[do_settle(PlayerID) || PlayerID <- mapdb:getMapPlayerIDList()],
			guild_ins_zones_map_common:set_is_finish_flag(?TRUE),
			guild_ins_zones_map_common:challenge_log(GuildID, 4, 0, ChapterID, NodeID, 0, 0, 0, 0, 0, 0),
			erlang:send_after(120000, self(), {quit}),
			?TRUE;
		?FALSE -> ?FALSE
	end.

sync_label_info() ->
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	TotalN = guild_ins_zones_map_common:get_zones_node_param1(),
	AllMapPlayerID = mapdb:getMapPlayerIDList(),
	PlayerNum = length(AllMapPlayerID),
	lists:foreach(fun(PlayerID) ->
		Msg = #pk_GS2U_guild_ins_zones_label_info{
			chapter_id = ChapterID,
			node_id = NodeID,
			my_value = get_player_collect_num(PlayerID),
			guild_value = TotalN,
			player_num = PlayerNum
		},
		map:send_client(PlayerID, Msg)
				  end, AllMapPlayerID).