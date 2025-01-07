%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 31. 3月 2022 11:30
%%%-------------------------------------------------------------------
-module(guild_knight_player).
-author("suw").

%% API
-export([on_gei_info/0, on_player_online/0, on_load/0, get_prop/0]).

-include("global.hrl").
-include("netmsgRecords.hrl").
-include("record.hrl").
-include("guild_knight.hrl").
-include("cfg_title.hrl").
-include("guild.hrl").
-include("player_private_list.hrl").

%%%===================================================================
%%% API
%%%===================================================================
on_load() ->
	Attr = player_private_list:get_value(?Private_List_GuildKnightMerge),
	put({?MODULE, guild_knight_attr}, attribute:base_prop_from_list(Attr)).

on_player_online() ->
	Data = guild_knight:get_data(),
	player:send(#pk_GS2U_guild_knight_index_sync{index = Data#guild_knight.index, max_index = Data#guild_knight.max_index, open_time = Data#guild_knight.open_time}).

on_gei_info() ->
	MyGuildID = player:getPlayerProperty(#player.guildID),
	Data = guild_knight:get_data(),
	{MyGuildRank, MyTitle, MyGuildMemberMsg, MyRank, MyLastRank, Top3Info, GuildRankMsg, MyShowRank, MyNowRank} = get_info(MyGuildID, Data),
	player:send(#pk_GS2U_guild_knight_info_ret{
		index = Data#guild_knight.index,
		myGuildRankShow = MyShowRank,
		myGuildRank = MyGuildRank,
		nowMyGuildRank = MyNowRank,
		myRank = MyRank,
		myLastRank = MyLastRank,
		myTitleID = MyTitle,
		my_member_list = MyGuildMemberMsg,
		info_list = Top3Info,
		rank_list = GuildRankMsg,
		max_index = Data#guild_knight.max_index,
		next_guild_time = Data#guild_knight.guild_next_time,
		next_member_time = Data#guild_knight.member_next_time,
		start_time = Data#guild_knight.start_time
	}).

get_prop() ->
	case get({?MODULE, guild_knight_attr}) of
		?UNDEFINED -> [];
		Prop -> Prop
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================

%%get_info(0) -> {0, 0, [], 0, [], [], 0, 0};
get_info(MyGuildID, {}) ->
	{MyGuildMemberMsg, MyRank} = get_guild_member_msg(MyGuildID, [], [], player:getPlayerID()),
	{0, 0, MyGuildMemberMsg, MyRank, 0, [], [], 0, 0};
get_info(MyGuildID, #guild_knight{guild_rank = GuildRank, title_info = TitleInfo, guild_member_rank = GuidMemberRank, last_guild_member_rank = LastGuildMemberRank}) ->
	MyGuildRank = case lists:keyfind(MyGuildID, 2, GuildRank) of
					  {Rk, _} -> Rk;
					  _ -> 0
				  end,
	PlayerID = player:getPlayerID(),
	MyTitle = case lists:keyfind(PlayerID, 1, TitleInfo) of
				  {_, TT} -> TT;
				  _ -> 0
			  end,
	MyLastRank = case lists:keyfind(MyGuildID, 1, LastGuildMemberRank) of
					 {_, MemberRank} ->
						 case lists:keyfind(PlayerID, 2, MemberRank) of
							 {MRk, _} -> MRk;
							 _ -> 0
						 end;
					 _ -> 0
				 end,
	{MyGuildMemberMsg, MyRank} = get_guild_member_msg(MyGuildID, GuidMemberRank, TitleInfo, PlayerID),
	Top3Info = make_top_3_msg(GuildRank, GuidMemberRank, TitleInfo),
	{GuildRankMsg, MyShowRank, MyNowRank} = make_guild_rank_msg(GuildRank, MyGuildID),
	{MyGuildRank, MyTitle, MyGuildMemberMsg, MyRank, MyLastRank, Top3Info, GuildRankMsg, MyShowRank, MyNowRank}.


get_guild_member_msg(GuildID, GuidMemberRank, TitleInfo, MyPlayerID) ->
	RankInfo = case lists:keyfind(GuildID, 1, GuidMemberRank) of
				   {_, L} -> L;
				   _ -> []
			   end,
	get_member_rank_msg(lists:sublist(lists:keysort(1, RankInfo), 10), GuildID, TitleInfo, MyPlayerID).

get_member_rank_msg([], GuildID, TitleInfo, MyPlayerID) ->
	{RankListMsg, {_, MyRk}} = lists:mapfoldl(
		fun({PlayerID, BtValue, TitleID}, {Acc, MyRank}) ->
			{#pk_guildMemberRank{
				rank = Acc,
				name = mirror_player:get_player_name(PlayerID),
				playerid = PlayerID,
				career = mirror_player:get_player_career(PlayerID),
				headID = mirror_player:get_player_equip_head(PlayerID),
				frameID = mirror_player:get_player_equip_frame(PlayerID),
				battleValue = BtValue,
				titleID = TitleID
			}, {Acc + 1, common:getTernaryValue(PlayerID =:= MyPlayerID, Acc, MyRank)}}
		end,
		{1, 0}, lists:reverse(lists:keysort(2, get_member_list(GuildID, TitleInfo)))),
	{RankListMsg, MyRk};
get_member_rank_msg(SettleMemberRank, GuildID, TitleInfo, MyPlayerID) ->
	L = get_member_list(GuildID, TitleInfo),
	{_, Left} = lists:partition(fun({PlayerID, _, _}) -> lists:keymember(PlayerID, 2, SettleMemberRank) end, L),
	{RankListMsg1, {_, MyRk1}} = lists:mapfoldl(
		fun({_, PlayerId}, {Acc, MyRank}) ->
			TitleID = get_title(PlayerId, TitleInfo),
			{#pk_guildMemberRank{
				rank = Acc,
				name = mirror_player:get_player_name(PlayerId),
				playerid = PlayerId,
				career = mirror_player:get_player_career(PlayerId),
				headID = mirror_player:get_player_equip_head(PlayerId),
				frameID = mirror_player:get_player_equip_frame(PlayerId),
				battleValue = fix_bt(PlayerId, mirror_player:get_player_battle_value(PlayerId), TitleID),
				titleID = TitleID
			}, {Acc + 1, common:getTernaryValue(PlayerId =:= MyPlayerID, Acc, MyRank)}}
		end,
		{1, 0}, lists:keysort(1, SettleMemberRank)),
	{RankListMsg2, {_, MyRk2}} = lists:mapfoldl(
		fun({PlayerID, BtValue, TitleID}, {Acc, MyRank}) ->
			{#pk_guildMemberRank{
				rank = Acc,
				name = mirror_player:get_player_name(PlayerID),
				playerid = PlayerID,
				career = mirror_player:get_player_career(PlayerID),
				headID = mirror_player:get_player_equip_head(PlayerID),
				frameID = mirror_player:get_player_equip_frame(PlayerID),
				battleValue = BtValue,
				titleID = TitleID
			}, {Acc + 1, common:getTernaryValue(PlayerID =:= MyPlayerID, Acc, MyRank)}}
		end,
		{length(SettleMemberRank) + 1, 0}, lists:reverse(lists:keysort(2, Left))),
	{RankListMsg1 ++ RankListMsg2, max(MyRk1, MyRk2)}.


get_member_list(GuildID, TitleInfo) ->
	GuildInfo = guild_pub:find_guild(GuildID),
	L = case GuildInfo of
			{} -> [];
			_ ->
				lists:map(fun({PlayerID, _, BtValue}) ->
					{NewBt, TitleID} = get_bt_title(PlayerID, BtValue, TitleInfo),
					{PlayerID, NewBt, TitleID}
						  end, guild_pub:get_guild_maps_member(GuildID))
		end,
	L.


get_bt_title(PlayerID, BattleValue, OldTitleInfo) ->
	case lists:keyfind(PlayerID, 1, OldTitleInfo) of
		?FALSE -> {BattleValue, 0};
		{_, TitleID} ->
			case player_title:is_exist_title(PlayerID, TitleID) of
				?TRUE ->
					case cfg_title:getRow(TitleID) of
						#titleCfg{attribute = Attribute} ->
							AddProp = attribute_part:calc_attr_prop(Attribute, PlayerID),
							{max(BattleValue - AddProp, 0), TitleID}
					end;
				_ -> {BattleValue, TitleID}
			end
	end.


make_top_3_msg([], _, _) -> [];
make_top_3_msg(GuildRankList, GuidMemberRank, TitleInfo) ->
	lists:map(fun({Rank, GuildId}) ->
		{GuildMemberMsg, _} = get_guild_member_msg(GuildId, GuidMemberRank, TitleInfo, 0),
		#pk_top3Info{
			rank = Rank,
			guildName = guild_pub:get_guild_name(GuildId),
			member_list = GuildMemberMsg,
			top1_model = get_guild_member_top1_model(GuildId, GuidMemberRank)
		}
			  end,
		lists:sublist(lists:keysort(1, GuildRankList), ?TopMax)).

make_guild_rank_msg(GuildRankList, MyGuildID) ->
	Top3List = lists:sublist(lists:keysort(1, GuildRankList), ?TopMax),
	{Msg1, {_, Rank1}} = lists:mapfoldl(fun({Rank, GuildID}, {R1, R2}) ->
		#guild_base{id = GuildID, guildName = GuildName, chairmanPlayerName = ChiefName, building_list = BuildingList} = guild:get_guild_info(GuildID),
		{#pk_guildRank{
			rank = Rank,
			guildName = GuildName,
			chiefName = ChiefName,
			totalBattleValue = guild_pub:get_guild_total_battle_value(GuildID),
			now_member_num = guild_pub:get_guild_member_num(GuildID),
			max_member_num = guild_pub:get_attr_value_by_index(BuildingList, ?Guild_Member)
		}, {R1 + 1, common:getTernaryValue(MyGuildID =:= GuildID, Rank, R2)}}
										end,
		{1, 0}, Top3List),
	L = guild_knight:get_guild_rank(),
	{_, Left} = lists:partition(fun({_, GuildId}) -> lists:keymember(GuildId, 2, Top3List) end, L),
	{Msg2, {_, Rank2}} = lists:mapfoldl(fun({_, GuildID}, {R1, R2}) ->
		#guild_base{id = GuildID, guildName = GuildName, chairmanPlayerName = ChiefName, building_list = BuildingList} = guild:get_guild_info(GuildID),
		{#pk_guildRank{
			rank = R1,
			guildName = GuildName,
			chiefName = ChiefName,
			totalBattleValue = guild_pub:get_guild_total_battle_value(GuildID),
			now_member_num = guild_pub:get_guild_member_num(GuildID),
			max_member_num = guild_pub:get_attr_value_by_index(BuildingList, ?Guild_Member)
		}, {R1 + 1, common:getTernaryValue(MyGuildID =:= GuildID, R1, R2)}}
										end,
		{length(Top3List) + 1, 0}, lists:keysort(1, Left)),
	NowMyGuildRank = case lists:keyfind(MyGuildID, 2, L) of
						 {Rk, _} -> Rk;
						 _ -> 0
					 end,
	{Msg1 ++ Msg2, max(Rank1, Rank2), NowMyGuildRank}.

fix_bt(_, BattleValue, 0) -> BattleValue;
fix_bt(PlayerID, BattleValue, TitleID) ->
	case player_title:is_exist_title(PlayerID, TitleID) of
		?TRUE ->
			case cfg_title:getRow(TitleID) of
				#titleCfg{attribute = Attribute} ->
					AddProp = attribute_part:calc_attr_prop(Attribute, PlayerID),
					max(BattleValue - AddProp, 0);
				_ ->
					?LOG_ERROR("no title cfg ~p", [TitleID]),
					BattleValue
			end;
		_ -> BattleValue
	end.

get_title(PlayerID, TitleInfo) ->
	case lists:keyfind(PlayerID, 1, TitleInfo) of
		{_, T} -> T;
		_ -> 0
	end.

get_guild_member_top1_model(GuildID, GuidMemberRank) ->
	case lists:keyfind(GuildID, 1, GuidMemberRank) of
		{_, L} -> case lists:keyfind(1, 1, L) of
					  {_, PlayerID} ->
						  UIMsg = ui_cache:get_player_ui(PlayerID),
						  UIMsg#pk_playerModelUI{
							  role_list = [R || R <- UIMsg#pk_playerModelUI.role_list, R#pk_roleModel.is_leader =:= 1]
						  };
					  _ -> #pk_playerModelUI{}
				  end;
		_ -> #pk_playerModelUI{}
	end.