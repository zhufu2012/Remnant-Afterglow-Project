%%%-------------------------------------------------------------------
%%% @author Suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%     	公会副本-福利关
%%% @end
%%% Created : 15. 6月 2022 19:54
%%%-------------------------------------------------------------------
-module(guild_ins_zones_map_welfare).
-author("Suw").

%% API
-export([on_init/1, on_object_dead/2, on_player_enter/1, do_settle/1, on_put_coll/1, on_damage/2, get_settle_param/1, on_tick/1]).

-include("global.hrl").
-include("record.hrl").
-include("cfg_guildCopyNode.hrl").
-include("guild_instance_zones.hrl").
-include("netmsgRecords.hrl").
-include("dungeons.hrl").

%%%===================================================================
%%% API
%%%===================================================================
on_init(#mapParams{gc_param = {_, _} = Key}) ->
	guild_ins_zones_map_common:set_node_key(Key),
	#guildCopyNodeCfg{playType = PlayType, welfareBorn = WelfareBorn, monsterAttr = Attr} = cfg_guildCopyNode:row(Key),
	if
		PlayType =:= ?GuildInsMapTypeWelfareCollect orelse PlayType =:= ?GuildInsMapTypeWelfareGather ->
			Sets = sets:from_list([collection:addCollection(CollDataID, X, Z, R) || {CollDataID, X, Z, R} <- WelfareBorn]),
			set_object_sets_info(Sets);
		PlayType =:= ?GuildInsMapTypeWelfareMonster orelse PlayType =:= ?GuildInsMapTypeWelfareStump ->
			Sets = sets:from_list([monsterMgr:addMonster(Attr, [], 1, 1, 1, 0, MonsterID, X, Z, R, 0, 0, 0, 0) || {MonsterID, X, Z, R} <- WelfareBorn]),
			set_object_sets_info(Sets);
		true ->
			?LOG_ERROR("unhandle type ~p", [PlayType]),
			self() ! {quit}
	end;
on_init(_) -> self() ! {quit}.

on_object_dead(PlayerID, ObjectUid) ->
	OldSets = get_object_sets_info(),
	NewSets = sets:del_element(ObjectUid, OldSets),
	set_object_sets_info(NewSets),
	Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{playType = PlayType} = cfg_guildCopyNode:row(Key),
	case PlayType of
		?GuildInsMapTypeWelfareMonster ->
			add_player_reach_value(PlayerID, 1),
			sync_label_info(),
			check_pass(PlayerID);
		?GuildInsMapTypeWelfareCollect ->
			add_player_reach_value(PlayerID, 1),
			sync_label_info(),
			check_pass(PlayerID);
		?GuildInsMapTypeWelfareGather ->
			add_player_gather_value(PlayerID, 1),
			sync_label_info(),
			check_pass(PlayerID);
		?GuildInsMapTypeWelfareStump ->
			dungeons_result:map_check_copy_map_settle_accounts(?CopySettleType_None, 0)
	end.

on_tick(TimeStamp)->
	guild_ins_zones_map_common:check_time_out(TimeStamp).

on_damage(PlayerID, Damage) ->
	Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{playType = PlayType} = cfg_guildCopyNode:row(Key),
	case PlayType of
		?GuildInsMapTypeWelfareStump ->
			add_player_reach_value(PlayerID, Damage);
		_ -> ok
	end.

on_put_coll(PlayerID) ->
	case map:getMapAI() =:= ?MapAI_GuildInsZonesWelfare of
		?TRUE ->
			AddV = get_player_gather_value(PlayerID),
			set_player_gather_value(PlayerID, 0),
			add_player_reach_value(PlayerID, AddV),
			sync_label_info(),
			check_pass(PlayerID);
		?FALSE -> ok
	end.

on_player_enter(PlayerID) ->
	Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{stayTime = StayTime} = cfg_guildCopyNode:row(Key),
	guild_ins_zones_map_common:add_player_stay_time(PlayerID, StayTime),
	sync_label_info(),
	map:send_client(PlayerID, #pk_GS2U_CopyMapLeftTime{leftTime = StayTime}).

do_settle(PlayerID) ->
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	Msg = #pk_GS2U_guild_ins_zones_settle_welfare{
		chapter_id = ChapterID,
		node_id = NodeID,
		is_success = 0
	},
	map:send_client(PlayerID, Msg).

get_settle_param(PlayerID)->
	get_player_reach_value(PlayerID).
%%%===================================================================
%%% Internal functions
%%%===================================================================
get_object_sets_info() ->
	case get({?MODULE, object_sets_info}) of
		?UNDEFINED -> sets:new();
		R -> R
	end.
set_object_sets_info(Sets) -> put({?MODULE, object_sets_info}, Sets).

get_player_reach_value(PlayerID) ->
	case get({?MODULE, player_reach_value, PlayerID}) of
		?UNDEFINED -> 0;
		L -> L
	end.
set_player_reach_value(PlayerID, List) ->
	put({?MODULE, player_reach_value, PlayerID}, List).
add_player_reach_value(PlayerID, AddV) ->
	set_player_reach_value(PlayerID, get_player_reach_value(PlayerID) + AddV).

get_player_gather_value(PlayerID) ->
	case get({?MODULE, player_gather_value, PlayerID}) of
		?UNDEFINED -> 0;
		L -> L
	end.
set_player_gather_value(PlayerID, List) ->
	put({?MODULE, player_gather_value, PlayerID}, List).
add_player_gather_value(PlayerID, AddV) ->
	set_player_gather_value(PlayerID, get_player_gather_value(PlayerID) + AddV).

sync_label_info() ->
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	AllMapPlayerID = mapdb:getMapPlayerIDList(),
	lists:foreach(fun(PlayerID) ->
		Msg = #pk_GS2U_guild_ins_zones_label_info{
			chapter_id = ChapterID,
			node_id = NodeID,
			my_value = get_player_gather_value(PlayerID),
			guild_value = get_player_reach_value(PlayerID)
		},
		?LOG_ERROR("send ~p",[Msg]),
		map:send_client(PlayerID, Msg)
				  end, AllMapPlayerID).

check_pass(PlayerID) ->
	Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{success = {_, N}} = cfg_guildCopyNode:row(Key),
	get_player_reach_value(PlayerID) >= N andalso dungeons_result:map_check_copy_map_settle_accounts(?CopySettleType_None, 0).