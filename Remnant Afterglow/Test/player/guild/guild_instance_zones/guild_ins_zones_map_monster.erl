%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%	公会副本-小怪关
%%% @end
%%% Created : 10. 3月 2022 13:54
%%%-------------------------------------------------------------------
-module(guild_ins_zones_map_monster).
-author("suw").

%% API
-export([init_map/1, on_monster_dead/2, on_tick/1, on_player_enter/1, on_player_exit/1, do_settle/1]).

-include("global.hrl").
-include("record.hrl").
-include("guild_instance_zones.hrl").
-include("cfg_guildCopyNode.hrl").
-include("netmsgRecords.hrl").

%%%===================================================================
%%% API
%%%===================================================================
init_map(_MapParams) ->
	GuildID = mapSup:getMapOwnerID(),
	MapDataID = mapSup:getMapDataID(),
	{ChapterID, NodeID} = Key = guild_ins_zones_logic:map_id_to_chapter_node(MapDataID),
	guild_ins_zones_map_common:set_node_key(Key),
	#guildCopyNodeCfg{num = KeepNum, time = InternalTime, monsterAttr = Attr, monsterBorn = PosList} = cfg_guildCopyNode:row(Key),
	set_refresh_internal_keep_num({InternalTime, KeepNum}),
	MonsterSets = lists:foldl(fun({Index, MonsterID, X, Z, R}, Sets) ->
		MonsterUid = monsterMgr:addMonster(Attr, [], Index, 1, 1, 0, MonsterID, X, Z, R, 0, 0, 0, 0),
		sets:add_element(MonsterUid, Sets)
							  end, sets:new(), common:getRandomSubList(PosList, KeepNum)),
	set_monster_sets_info(MonsterSets),
	case guild_ins_zones_logic:find_node(GuildID, NodeID) of
		{} ->
			Node = #guild_ins_zones_node{guild_id = GuildID, node_id = NodeID, map_pid = self()},
			guild_instance_zones:send_2_me({insert_new_node, ChapterID, Node}),
			guild_ins_zones_map_common:set_zones_node_param1(0);
		#guild_ins_zones_node{is_pass = 0, param1 = P1} ->
			guild_ins_zones_map_common:set_zones_node_param1(P1),
			set_now_effect_buff(get_effect_buff(Key)),
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.map_pid, self()}]);
		_ -> self() ! {quit}
	end.

on_monster_dead(PlayerID, MonsterID) ->
	case guild_ins_zones_map_common:get_is_finish_flag() of
		?FALSE ->
			guild_ins_zones_map_common:add_zones_node_param1(1),
			add_player_kill_num(PlayerID, 1),
			guild_ins_zones_map_common:set_cond_change_flag(?TRUE),
			MonsterSets = get_monster_sets_info(),
			NewMonsterSets = sets:del_element(MonsterID, MonsterSets),
			set_monster_sets_info(NewMonsterSets),
			IsPass = check_pass(),
			case IsPass of
				?TRUE ->
					{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
					lists:foreach(fun(TPlayerID) ->
						case guild_ins_zones_map_common:is_not_game_over(TPlayerID) of
							?TRUE ->
								Msg = #pk_GS2U_guild_ins_zones_settle_monster{
									chapter_id = ChapterID,
									node_id = NodeID,
									is_success = 1,
									num = get_player_kill_num(TPlayerID),
									total_num = guild_ins_zones_map_common:get_zones_node_param1()
								},
								map:send_client(TPlayerID, Msg);
							?FALSE ->
								ok
						end
								  end, mapdb:getMapPlayerIDList());
				?FALSE -> ok
			end;
		?TRUE -> ok
	end.

on_tick(TimeStamp) ->
	guild_ins_zones_map_common:check_time_out(TimeStamp),
	Key = guild_ins_zones_map_common:get_node_key(),
	case guild_ins_zones_map_common:get_cond_change_flag() andalso TimeStamp rem 3 =:= 0 of
		?TRUE ->
			GuildID = mapSup:getMapOwnerID(),
			{ChapterID, NodeID} = Key,
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID,
				[{#guild_ins_zones_node.param1, guild_ins_zones_map_common:get_zones_node_param1()}]),
			guild_ins_zones_map_common:set_cond_change_flag(?FALSE),
			MaybeNewBuff = get_effect_buff(Key),
			case get_now_effect_buff() =/= MaybeNewBuff of
				?FALSE -> ok;
				?TRUE ->
					#guildCopyNodeCfg{effectArea = EffectArea} = cfg_guildCopyNode:row(Key),
					set_now_effect_buff(MaybeNewBuff),
					EffectArea > 0 andalso guild_instance_zones:send_2_me({effect_list_refresh, GuildID, ChapterID, NodeID, EffectArea, MaybeNewBuff})
			end,
			sync_label_info();
		?FALSE -> ok
	end,
	{Internal, Num} = get_refresh_internal_keep_num(),
	case not guild_ins_zones_map_common:get_is_finish_flag() andalso TimeStamp rem Internal =:= 0 of
		?TRUE ->
			MonsterSets = get_monster_sets_info(),
			NowNum = sets:size(MonsterSets),
			case NowNum < Num of
				?TRUE ->
					#guildCopyNodeCfg{monsterAttr = Attr, monsterBorn = PosList} = cfg_guildCopyNode:row(Key),
					NewMonsterSets = lists:foldl(fun({Index, MonsterID, X, Z, R}, Sets) ->
						MonsterUid = monsterMgr:addMonster(Attr, [], Index, 1, 1, 0, MonsterID, X, Z, R, 0, 0, 0, 0),
						sets:add_element(MonsterUid, Sets)
												 end, MonsterSets, common:getRandomSubList(PosList, Num - NowNum)),
					set_monster_sets_info(NewMonsterSets);
				?FALSE -> ok
			end;
		?FALSE -> ok
	end.

on_player_enter(PlayerID) ->
	GuildID = mapSup:getMapOwnerID(),
	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{stayTime = StayTime, monsterEfficiency = BuffList} = cfg_guildCopyNode:row(Key),
	guild_ins_zones_map_common:add_player_stay_time(PlayerID, StayTime),
	AllMapPlayerID = mapdb:getMapPlayerIDList(),
	PlayerNum = length(AllMapPlayerID),
	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.player_num, PlayerNum}]),
	guild_ins_zones_map_common:set_cond_change_flag(?TRUE),
	check_player_num_buff(PlayerID, PlayerNum, AllMapPlayerID, BuffList),
	map:send_client(PlayerID, #pk_GS2U_CopyMapLeftTime{leftTime = StayTime}).

on_player_exit(PlayerID) ->
	guild_ins_zones_map_common:del_game_over_list(PlayerID),
	erase_player_kill_num(PlayerID),
	GuildID = mapSup:getMapOwnerID(),
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.player_num, length(mapdb:getMapPlayerIDList()) - 1}]),
	guild_ins_zones_map_common:set_cond_change_flag(?TRUE).

do_settle(PlayerID) ->
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	Msg = #pk_GS2U_guild_ins_zones_settle_monster{
		chapter_id = ChapterID,
		node_id = NodeID,
		is_success = 0,
		num = get_player_kill_num(PlayerID),
		total_num = guild_ins_zones_map_common:get_zones_node_param1()
	},
	map:send_client(PlayerID, Msg),
	GuildID = mapSup:getMapOwnerID(),
	guild_ins_zones_map_common:challenge_log(GuildID, 1, PlayerID, ChapterID, NodeID, 0, 0, 0, 0, get_player_kill_num(PlayerID), guild_ins_zones_map_common:get_zones_node_param1()).

%%%===================================================================
%%% Internal functions
%%%===================================================================

get_monster_sets_info() ->
	case get({?MODULE, monster_sets_info}) of
		?UNDEFINED -> sets:new();
		R -> R
	end.
set_monster_sets_info(Sets) -> put({?MODULE, monster_sets_info}, Sets).

get_refresh_internal_keep_num() ->
	case get({?MODULE, refresh_internal_keep_num}) of
		?UNDEFINED -> {1, 1};
		R -> R
	end.
set_refresh_internal_keep_num(R) ->
	put({?MODULE, refresh_internal_keep_num}, R).

get_player_kill_num(PlayerID) ->
	case get({?MODULE, player_kill_num, PlayerID}) of
		?UNDEFINED -> 0;
		N -> N
	end.
set_player_kill_num(PlayerID, N) ->
	put({?MODULE, player_kill_num, PlayerID}, N).
add_player_kill_num(PlayerID, AddV) ->
	set_player_kill_num(PlayerID, get_player_kill_num(PlayerID) + AddV).
erase_player_kill_num(PlayerID) ->
	erase({?MODULE, player_kill_num, PlayerID}).

check_pass() ->
	GuildID = mapSup:getMapOwnerID(),
	TotalN = guild_ins_zones_map_common:get_zones_node_param1(),
	{ChapterID, NodeID} = Key = guild_ins_zones_map_common:get_node_key(),
	#guildCopyNodeCfg{success = {_, NeedN}} = cfg_guildCopyNode:row(Key),
	case TotalN >= NeedN of
		?TRUE ->
			guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.is_pass, 1}, {#guild_ins_zones_node.is_mark, 0}]),
			guild_instance_zones:on_node_pass(GuildID, ChapterID, NodeID),
			guild_ins_zones_map_common:set_is_finish_flag(?TRUE),
			guild_ins_zones_map_common:challenge_log(GuildID, 4, 0, ChapterID, NodeID, 0, 0, 0, 0, 0, 0),
			erlang:send_after(120000, self(), {quit}),
			?TRUE;
		?FALSE -> ?FALSE
	end.

get_effect_buff(Key) ->
	#guildCopyNodeCfg{rewardBuff1 = BuffType, rewardBuff2 = List} = cfg_guildCopyNode:row(Key),
	TotalN = guild_ins_zones_map_common:get_zones_node_param1(),
	{_, BuffID} = common:getValueByInterval(TotalN, List, {0, 0}),
	{BuffType, BuffID}.

get_now_effect_buff() ->
	case get({?MODULE, now_effect_buff}) of
		?UNDEFINED -> {0, 0};
		N -> N
	end.
set_now_effect_buff(Data) ->
	put({?MODULE, now_effect_buff}, Data).

sync_label_info() ->
	{ChapterID, NodeID} = guild_ins_zones_map_common:get_node_key(),
	TotalN = guild_ins_zones_map_common:get_zones_node_param1(),
	AllMapPlayerID = mapdb:getMapPlayerIDList(),
	PlayerNum = length(AllMapPlayerID),
	lists:foreach(fun(PlayerID) ->
		Msg = #pk_GS2U_guild_ins_zones_label_info{
			chapter_id = ChapterID,
			node_id = NodeID,
			my_value = get_player_kill_num(PlayerID),
			guild_value = TotalN,
			player_num = PlayerNum
		},
		map:send_client(PlayerID, Msg)
				  end, AllMapPlayerID).
get_player_num_buff() ->
	case get({?MODULE, player_num_buff}) of
		?UNDEFINED -> 0;
		B -> B
	end.
set_player_num_buff(R) ->
	put({?MODULE, player_num_buff}, R).

check_player_num_buff(PlayerID, Num, PlayerIDList, BuffList) ->
	{_, BuffID} = common:getValueByInterval(Num, BuffList, {0, 0}),
	case get_player_num_buff() =:= BuffID of
		?TRUE ->
			[buff_map:add_buffer2(PlayerID, PlayerID, BuffID, 0) || BuffID > 0];
		?FALSE ->
			set_player_num_buff(BuffID),
			[buff_map:add_buffer2(TargetPlayer, TargetPlayer, BuffID, 0) || TargetPlayer <- PlayerIDList, BuffID > 0]
	end.