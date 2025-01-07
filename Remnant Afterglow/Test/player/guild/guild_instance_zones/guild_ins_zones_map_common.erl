%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 10. 3月 2022 16:42
%%%-------------------------------------------------------------------
-module(guild_ins_zones_map_common).
-author("suw").

%% API
-export([add_player_stay_time/2, del_game_over_list/1, check_time_out/1, get_cond_change_flag/0, set_cond_change_flag/1,
	get_node_key/0, set_node_key/1, time_out_settle/1, on_handle_msg/1, get_zones_node_param1/0, set_zones_node_param1/1,
	add_zones_node_param1/1, get_is_finish_flag/0, set_is_finish_flag/1, is_not_game_over/1, challenge_log/11]).

-include("global.hrl").
-include("gameMap.hrl").
-include("guild_instance_zones.hrl").
-include("record.hrl").
-include("guild.hrl").

%%%===================================================================
%%% API
%%%===================================================================
add_player_stay_time(PlayerID, StayTime) ->
	OldList = get_player_stay_time_list(),
	case lists:keyfind(PlayerID, 2, OldList) of
		?FALSE ->
			NewList = ordsets:add_element({map:timesTamp() + StayTime, PlayerID}, OldList),
			set_player_stay_time_list(NewList);
		_ -> ok
	end.
del_game_over_list(PlayerID) ->
	NewList = lists:keydelete(PlayerID, 2, get_player_stay_time_list()),
	set_player_stay_time_list(NewList).
is_not_game_over(PlayerID) ->
	List = get_player_stay_time_list(),
	lists:keymember(PlayerID, 2, List).

check_time_out(TimeStamp) ->
	case get_is_finish_flag() of
		?FALSE ->
			case get_player_stay_time_list() of
				[] -> ok;
				[{OverTime, _} | _] when TimeStamp < OverTime -> ok;
				List ->
					Left = do_check_settle(List, TimeStamp),
					set_player_stay_time_list(Left)
			end;
		?TRUE -> ok
	end.

get_cond_change_flag() ->
	case get({?MODULE, cond_change_flag}) of
		?UNDEFINED -> ?FALSE;
		B -> B
	end.
set_cond_change_flag(Flag) ->
	put({?MODULE, cond_change_flag}, Flag).

get_is_finish_flag() ->
	case get({?MODULE, is_finish_flag}) of
		?UNDEFINED -> ?FALSE;
		B -> B
	end.
set_is_finish_flag(Flag) ->
	put({?MODULE, is_finish_flag}, Flag).

get_zones_node_param1() ->
	case get({?MODULE, zones_node_param1}) of
		?UNDEFINED -> 0;
		N -> N
	end.
set_zones_node_param1(N) ->
	put({?MODULE, zones_node_param1}, N).
add_zones_node_param1(AddV) ->
	set_zones_node_param1(get_zones_node_param1() + AddV).

get_node_key() ->
	case get({?MODULE, node_key}) of
		?UNDEFINED -> {0, 0};
		K -> K
	end.
set_node_key(K) ->
	put({?MODULE, node_key}, K).

on_handle_msg({time_out_settle, PlayerID}) ->
	time_out_settle(PlayerID);
on_handle_msg({refresh_effect_buff, Type, BuffID}) ->
	refresh_effect_buff(Type, BuffID);
on_handle_msg({hit_hp, PlayerID, UseItem}) ->
	hit_hp(PlayerID, UseItem);
on_handle_msg(Msg) ->
	?LOG_ERROR("unhandle msg ~p", [Msg]).

challenge_log(GuildID, Type, PlayerID, ChapterID, NodeID, BossID, BossLv, UseItem, Param1, Param2, Param3) when Type =:= 1 ->
	case mapdb:getMapPlayer(PlayerID) of
		{} -> ok;
		#mapPlayer{name = Name, level = Level, headID = HeadID, frameID = FrameID} ->
			Log = #guild_ins_zones_log{
				type = Type,
				player_id = PlayerID,
				name = Name,
				player_lv = Level,
				head_id = HeadID,
				frame_id = FrameID,
				chapter_id = ChapterID,
				node_id = NodeID,
				boss_id = BossID,
				boss_lv = BossLv,
				use_item = UseItem,
				param1 = Param1,
				param2 = Param2,
				param3 = Param3,
				time = map:timesTamp()
			},
			guild_instance_zones:send_2_me({add_log, GuildID, Log})
	end;
challenge_log(GuildID, Type, PlayerID, ChapterID, NodeID, BossID, BossLv, UseItem, Param1, Param2, Param3) ->
	Log = #guild_ins_zones_log{
		type = Type,
		player_id = PlayerID,
		head_id = guild_pub:get_guild_property(GuildID, #guild_base.headIcon),
		chapter_id = ChapterID,
		node_id = NodeID,
		boss_id = BossID,
		boss_lv = BossLv,
		use_item = UseItem,
		param1 = Param1,
		param2 = Param2,
		param3 = Param3,
		time = map:timesTamp()
	},
	guild_instance_zones:send_2_me({add_log, GuildID, Log}).
%%%===================================================================
%%% Internal functions
%%%===================================================================
get_player_stay_time_list() ->
	case get({?MODULE, player_stay_time}) of
		?UNDEFINED -> [];
		L -> L
	end.
set_player_stay_time_list(List) ->
	put({?MODULE, player_stay_time}, List).

do_check_settle([{OverTime, PlayerID} | T], TimeStamp) when TimeStamp >= OverTime ->
	self() ! {guild_ins_zones_map_msg, {time_out_settle, PlayerID}},
	do_check_settle(T, TimeStamp);
do_check_settle(L, _TimeStamp) -> L.

time_out_settle(PlayerID) ->
	case map:getMapAI() of
		?MapAI_GuildInsZonesBoss -> guild_ins_zones_map_boss:do_settle(PlayerID);
		?MapAI_GuildInsZonesCollect -> guild_ins_zones_map_collect:do_settle(PlayerID);
		?MapAI_GuildInsZonesMonster -> guild_ins_zones_map_monster:do_settle(PlayerID);
		?MapAI_GuildInsZonesWelfare -> guild_ins_zones_map_welfare:do_settle(PlayerID);
		_ -> ok
	end.

refresh_effect_buff(Type, BuffID) ->
	case map:getMapAI() of
		?MapAI_GuildInsZonesBoss -> guild_ins_zones_map_boss:refresh_effect_buff(Type, BuffID);
		_ -> ok
	end.

hit_hp(PlayerID, UseItem) ->
	case map:getMapAI() of
		?MapAI_GuildInsZonesBoss -> guild_ins_zones_map_boss:hit_boss_hp(PlayerID, UseItem);
		_ -> ok
	end.