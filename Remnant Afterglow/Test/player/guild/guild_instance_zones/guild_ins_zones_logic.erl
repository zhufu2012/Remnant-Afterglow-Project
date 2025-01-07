%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 10. 3月 2022 11:37
%%%-------------------------------------------------------------------
-module(guild_ins_zones_logic).
-author("suw").

%% API
-export([map_id_to_chapter_node/1, find_zones/1, find_node/2, check_guild_node_open/3, check_item_use/3, dec_item_use/3]).
-export([list_2_ins_zones/1, ins_zones_2_list/1, list_2_zones_node/1, zones_node_2_list/1, list_2_ins_zones_player/1, ins_zones_player_2_list/1]).

-include("global.hrl").
-include("guild_instance_zones.hrl").
-include("cfg_guildCopyNode.hrl").

%%%===================================================================
%%% API
%%%===================================================================
find_zones(GuildID) ->
	case etsBaseFunc:readRecord(?EtsGuildInsZones, GuildID) of
		#guild_ins_zones{} = R -> R;
		_ -> #guild_ins_zones{guild_id = GuildID, chapter_id = 1}
	end.

find_node(GuildID, NodeID) when is_integer(GuildID) ->
	#guild_ins_zones{zones_node_list = List} = find_zones(GuildID),
	find_node(List, NodeID);
find_node(List, NodeID) ->
	case lists:keyfind(NodeID, #guild_ins_zones_node.node_id, List) of
		?FALSE -> {};
		R -> R
	end.


map_id_to_chapter_node(MapDataID) ->
	map_id_to_chapter_node_(cfg_guildCopyNode:getKeyList(), MapDataID).

list_2_ins_zones(List) ->
	Record = list_to_tuple([db_guild_ins_zones | List]),
	Record#db_guild_ins_zones{
		bag_item_list = gamedbProc:dbstring_to_term(Record#db_guild_ins_zones.bag_item_list),
		log_data = gamedbProc:my_binary_to_term(Record#db_guild_ins_zones.log_data, [])
	}.
ins_zones_2_list(Record) ->
	tl(tuple_to_list(Record#db_guild_ins_zones{
		bag_item_list = gamedbProc:term_to_dbstring(Record#db_guild_ins_zones.bag_item_list),
		log_data = term_to_binary(Record#db_guild_ins_zones.log_data, [compressed])
	})).

list_2_zones_node([GuildID, NodeID, IsPass, IsMark, MaxHp, Param1, ParamList, EffectList, RankList]) ->
	#guild_ins_zones_node{
		guild_id = GuildID,
		node_id = NodeID,
		is_pass = IsPass,
		is_mark = IsMark,
		max_hp = MaxHp,
		param1 = Param1,
		param_list = gamedbProc:dbstring_to_term(ParamList),
		effect_list = gamedbProc:dbstring_to_term(EffectList),
		rank_list = gamedbProc:dbstring_to_term(RankList)
	}.
zones_node_2_list(#guild_ins_zones_node{guild_id = GuildID, node_id = NodeID, is_pass = IsPass, is_mark = IsMark,
	max_hp = MaxHp, param1 = Param1, param_list = ParamList, effect_list = EffectList, rank_list = RankList}) ->
	[
		GuildID,
		NodeID,
		IsPass,
		IsMark,
		MaxHp,
		Param1,
		gamedbProc:term_to_dbstring(ParamList),
		gamedbProc:term_to_dbstring(EffectList),
		gamedbProc:term_to_dbstring(RankList)
	].

list_2_ins_zones_player(List) ->
	Record = list_to_tuple([guild_ins_zones_player | List]),
	Record#guild_ins_zones_player{
		times_award_list = gamedbProc:dbstring_to_term(Record#guild_ins_zones_player.times_award_list),
		pass_node_list = gamedbProc:dbstring_to_term(Record#guild_ins_zones_player.pass_node_list),
		award_node_list = gamedbProc:dbstring_to_term(Record#guild_ins_zones_player.award_node_list)
	}.
ins_zones_player_2_list(Record) ->
	tl(tuple_to_list(Record#guild_ins_zones_player{
		times_award_list = gamedbProc:term_to_dbstring(Record#guild_ins_zones_player.times_award_list),
		pass_node_list = gamedbProc:term_to_dbstring(Record#guild_ins_zones_player.pass_node_list),
		award_node_list = gamedbProc:term_to_dbstring(Record#guild_ins_zones_player.award_node_list)
	})).

check_guild_node_open(GuildID, ChapterID, NodeID) ->
	case cfg_guildCopyNode:getRow(ChapterID, NodeID) of
		#guildCopyNodeCfg{priorPoint2 = []} -> ?TRUE;
		#guildCopyNodeCfg{priorPoint2 = PreNeed} ->
			check_node_open_1(lists:keysort(1, PreNeed), 1, GuildID, ?FALSE);
		_ -> ?FALSE
	end.

check_item_use(UseNodeID, UseItemList, BagItemList) ->
	case lists:keyfind(UseNodeID, 1, BagItemList) of
		?FALSE -> ?FALSE;
		{_, ItemList} ->
			lists:all(fun({ItemID, Num}) ->
				case lists:keyfind(ItemID, 1, ItemList) of
					{_, N} when N >= Num -> ?TRUE;
					_ -> ?FALSE
				end
					  end, common:listValueMerge(UseItemList))
	end.

dec_item_use(UseNodeID, UseItemList, BagItemList) ->
	case lists:keyfind(UseNodeID, 1, BagItemList) of
		?FALSE -> BagItemList;
		{_, ItemList} ->
			LeftItemList = lists:foldl(fun({ItemID, Num}, Ret) ->
				case lists:keytake(ItemID, 1, Ret) of
					?FALSE -> Ret;
					{_, {_, OldN}, Left} when OldN > Num -> [{ItemID, OldN - Num} | Left];
					{_, _, Left} -> Left
				end
									   end, ItemList, common:listValueMerge(UseItemList)),
			lists:keystore(UseNodeID, 1, BagItemList, {UseNodeID, LeftItemList})
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================
map_id_to_chapter_node_([], _MapDataID) -> {0, 0};
map_id_to_chapter_node_([Key | T], MapDataID) ->
	case cfg_guildCopyNode:row(Key) of
		#guildCopyNodeCfg{mapId = MapDataID} -> Key;
		_ -> map_id_to_chapter_node_(T, MapDataID)
	end.

check_node_open_1([], _, _, Ret) -> Ret;
check_node_open_1([{G, _, _} | _], Group, _, ?TRUE) when G > Group -> ?TRUE;
check_node_open_1([{G, _, _} | _] = Condition, Group, GuildID, ?FALSE) when G > Group ->
	check_node_open_1(Condition, G, GuildID, ?FALSE);
check_node_open_1([{G, _, _} | T], Group, GuildID, ?FALSE) when G < Group ->
	check_node_open_1(T, Group, GuildID, ?FALSE);
check_node_open_1([{Group, ?NodeOpenCondition_PassNode, NodeID} | T], Group, GuildID, _) ->
	case find_node(GuildID, NodeID) of
		#guild_ins_zones_node{is_pass = 1} -> check_node_open_1(T, Group, GuildID, ?TRUE);
		_ -> check_node_open_1(T, Group + 1, GuildID, ?FALSE)
	end;
check_node_open_1([_ | T], Group, GuildID, _) ->
	check_node_open_1(T, Group + 1, GuildID, ?FALSE).