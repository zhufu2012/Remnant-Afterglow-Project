%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%
%%% @end
%%% Created : 10. 3月 2022 11:36
%%%-------------------------------------------------------------------
-module(guild_ins_zones_player).
-author("suw").

%% API
-export([on_ui_op/1, on_req_info/0, on_move/2, on_mark/3, enter_map/2, on_reward/2, on_get_guild_server_progress/0,
	on_reset5/0, on_map_settle_accounts/2, on_maze_pass/2, on_hit/3, on_challenge_log/1, guild_quit/0, on_player_online/0, on_get_guild_ins_zones_boss_first_pass/1, gm_pass/1]).

-include("global.hrl").
-include("guild_instance_zones.hrl").
-include("record.hrl").
-include("cfg_guildCopyNode.hrl").
-include("error.hrl").
-include("netmsgRecords.hrl").
-include("cfg_guildCopyChapter.hrl").
-include("cfg_guildCopyRate.hrl").
-include("cfg_guildCopyTimesReward.hrl").
-include("reason.hrl").
-include("guild.hrl").
-include("db_shared_storage.hrl").

%%%===================================================================
%%% API
%%%===================================================================
on_player_online() ->
	check_guild_miss().

enter_map(ChapterID, NodeID) ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		ChapterCfg = cfg_guildCopyChapter:getRow(ChapterID),
		?CHECK_CFG(ChapterCfg),
		#guildCopyChapterCfg{consume = ConsumeID} = ChapterCfg,
		NodeCfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(NodeCfg),
		case guild_ins_zones_logic:find_node(GuildID, NodeID) of
			#guild_ins_zones_node{is_pass = 1} -> throw(?ErrorCode_GuildInsZones_Pass);
			_ -> ok
		end,
		?CHECK_THROW(check_personal_node_open(GuildID, ChapterID, NodeID), ?ErrorCode_GuildInsZones_NotOpen),
		#guild_ins_zones_player{pass_node_list = PassNodeList, challenge_times = OldTime} = Data = find_player_data(PlayerID),
		?CHECK_THROW(not lists:member({ChapterID, NodeID}, PassNodeList), ?ErrorCode_GuildInsZones_Pass),
		#guildCopyNodeCfg{type = Type, playType = PlayType, consume = ConsumeNum, mapId = MapID} = NodeCfg,
		?CHECK_THROW(ConsumeNum =:= 0 orelse dungeon_number:get_remain(ConsumeID) >= ConsumeNum, ?ErrorCode_GuildInsZones_Enter),
		case ConsumeNum > 0 of
			?TRUE ->
				dungeon_number:reduce(ConsumeID, ConsumeNum),
				update_player_data(Data#guild_ins_zones_player{challenge_times = OldTime + ConsumeNum});
			?FALSE -> ok
		end,
		case Type of
			?GuildInsNodeTypeWelfare ->
				MapParams = #mapParams{mapAIType = ?MapAI_GuildInsZonesWelfare, dungeonID = MapID, gc_param = {ChapterID, NodeID}},
				playerCMLocal:enterCopyMap(MapID, MapParams);
			?GuildInsNodeTypePersonalProgress when PlayType =:= ?GuildInsMapTypeMaze ->
				MapParams = #mapParams{mapAIType = ?MapAI_GuildInsZonesMaze, dungeonID = MapID, gc_param = {ChapterID, NodeID}},
				playerCMLocal:enterCopyMap(MapID, MapParams);
			_ ->
				playerMap:on_U2GS_RequestEnterMap(#requestEnterMapParam{requestID = MapID, mapOwnerID = GuildID})
		end,
		player:send(#pk_GS2U_guild_ins_zones_enter_ret{chapter_id = ChapterID, node_id = NodeID, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_enter_ret{chapter_id = ChapterID, node_id = NodeID, err_code = Err})
	end.

%% 打开\关闭界面
on_ui_op(Op) ->
	GuildID = player:getPlayerProperty(#player.guildID),
	GuildID > 0 andalso guild_instance_zones:send_2_me({player_op_ui, player:getPlayerID(), GuildID, Op}).

on_req_info() ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones{chapter_id = ChapterID, yesterday_chapter_id = YesChapterID, progress = Progress,
			yesterday_progress = YesProgress, bag_item_list = BagItemList, zones_node_list = NodeList}
			= guild_ins_zones_logic:find_zones(GuildID),
		#guild_ins_zones_player{pos_node = PosNode, pass_node_list = PassNodeList, challenge_times = ChallengeTimes,
			is_progress_award = IsProgressAward, times_award_list = TimesAwardList, award_node_list = AwardNodeList} = find_player_data(PlayerID),
		#guildCopyChapterCfg{consume = ConsumeID} = cfg_guildCopyChapter:getRow(ChapterID),
		player:send(#pk_GS2U_guild_ins_zones_info_ret{
			err_code = ?ERROR_OK,
			chapter_id = ChapterID,
			pos_node = PosNode,
			guild_node_list = lists:map(fun make_guild_ins_zones_node_msg/1, NodeList),
			personal_node_list = [#pk_key_value{key = C, value = N} || {C, N} <- PassNodeList],
			award_node_list = [#pk_key_value{key = C, value = N} || {C, N} <- AwardNodeList],
			use_times = dungeon_number:get_reduce(ConsumeID),
			max_times = dungeon_number:get_add_free(ConsumeID),
			progress = Progress,
			yesterday_chapter_id = YesChapterID,
			yesterday_progress = YesProgress,
			challenge_times = ChallengeTimes,
			is_progress_award = IsProgressAward,
			times_award_list = TimesAwardList,
			bag_item_list = lists:map(fun make_guild_ins_zones_bag_msg/1, BagItemList)
		})
	catch
		Err -> player:send(#pk_GS2U_guild_ins_zones_info_ret{err_code = Err})
	end.

on_mark(ChapterID, NodeID, IsMark) ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones{chapter_id = GuildChapterID, zones_node_list = NodeList} = guild_ins_zones_logic:find_zones(GuildID),
		?CHECK_THROW(ChapterID =:= GuildChapterID, ?ERROR_Param),
		Cfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(Cfg),
		#guildCopyNodeCfg{type = Type, isMark = CanMark} = Cfg,
		?CHECK_THROW(CanMark =:= 1 andalso (Type =:= ?GuildInsNodeTypeProgress orelse Type =:= ?GuildInsNodeTypeEffect), ?ErrorCode_GuildInsZones_Mark),
		case guild_ins_zones_logic:find_node(NodeList, NodeID) of
			#guild_ins_zones_node{is_pass = 1} -> throw(?ErrorCode_GuildInsZones_Pass);
			_ -> ok
		end,
		[Tuple] = df:getGlobalSetupValueList(markUserLirr, [{}]),
		AllowList = tuple_to_list(Tuple),
		MyRank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(lists:member(MyRank, AllowList), ?ErrorCode_GuildInsZones_NoPermission),
		guild_instance_zones:send_2_me({mark_node, GuildID, ChapterID, NodeID, IsMark}),
		PlayerRecord = player:getPlayerRecord(),
		IsMark =:= 1 andalso guild_instance_zones:send_2_me({add_log, GuildID, #guild_ins_zones_log{type = 2, player_id = PlayerID,
			name = PlayerRecord#player.name, player_lv = PlayerRecord#player.level, head_id = PlayerRecord#player.head_id,
			frame_id = PlayerRecord#player.frame_id, chapter_id = ChapterID, node_id = NodeID, param2 = MyRank, time = time:time()}}),
		player:send(#pk_GS2U_guild_ins_zones_remark_ret{chapter_id = ChapterID, node_id = NodeID, is_mark = IsMark, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_remark_ret{chapter_id = ChapterID, node_id = NodeID, is_mark = IsMark, err_code = Err})
	end.

on_move(ChapterID, NodeID) ->
	PlayerID = player:getPlayerID(),
	Info = find_player_data(PlayerID),
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones{chapter_id = GuildChapterID} = guild_ins_zones_logic:find_zones(GuildID),
		?CHECK_THROW(ChapterID =:= GuildChapterID, ?ERROR_Param),
		update_player_data(Info#guild_ins_zones_player{pos_node = NodeID}),
		player:send(#pk_GS2U_guild_ins_zones_move_ret{chapter_id = ChapterID, node_id = NodeID, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_move_ret{chapter_id = ChapterID, node_id = Info#guild_ins_zones_player.pos_node, err_code = Err})
	end.

on_maze_pass(ChapterID, NodeID) ->
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		PlayerID = player:getPlayerID(),
		#guild_ins_zones_player{pass_node_list = PassNodeList} = Info = find_player_data(PlayerID),
		?CHECK_THROW(not lists:member({ChapterID, NodeID}, PassNodeList), ?ErrorCode_GuildInsZones_Pass),
		#guild_ins_zones{chapter_id = GuildChapterID} = guild_ins_zones_logic:find_zones(GuildID),
		?CHECK_THROW(ChapterID =:= GuildChapterID, ?ERROR_Param),
		Cfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(Cfg),
		#guildCopyNodeCfg{playType = PlayType} = Cfg,
		?CHECK_THROW(PlayType =:= ?GuildInsMapTypeMaze, ?ERROR_Param),
		update_player_data(Info#guild_ins_zones_player{pass_node_list = [{ChapterID, NodeID} | PassNodeList]}),
		player:send(#pk_GS2U_guild_ins_zones_maze_pass_ret{chapter_id = ChapterID, node_id = NodeID, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_maze_pass_ret{chapter_id = ChapterID, node_id = NodeID, err_code = Err})
	end.

on_hit(ChapterID, NodeID, UseItem) ->
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		PlayerID = player:getPlayerID(),
		#guild_ins_zones{chapter_id = GuildChapterID, zones_node_list = NodeList, bag_item_list = BagItemList} = guild_ins_zones_logic:find_zones(GuildID),
		?CHECK_THROW(ChapterID =:= GuildChapterID, ?ERROR_Param),
		Cfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(Cfg),
		#guildCopyNodeCfg{playType = PlayType} = Cfg,
		?CHECK_THROW(PlayType =:= ?GuildInsMapTypeBoss, ?ERROR_Param),
		[Tuple] = df:getGlobalSetupValueList(markUserLirr, [{}]),
		AllowList = tuple_to_list(Tuple),
		MyRank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(lists:member(MyRank, AllowList), ?ErrorCode_GuildInsZones_NoPermission),
		case guild_ins_zones_logic:find_node(NodeList, NodeID) of
			#guild_ins_zones_node{is_pass = 0} -> ok;
			_ -> throw(?ErrorCode_GuildInsZones_Pass)
		end,
		?CHECK_THROW(guild_ins_zones_logic:check_item_use(NodeID, [UseItem], BagItemList), ?ErrorCode_GuildInsZones_ItemUse),
		guild_instance_zones:send_2_me({hit_node, PlayerID, GuildID, ChapterID, NodeID, UseItem})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_hit_ret{chapter_id = ChapterID, node_id = NodeID, err_code = Err})
	end.

%% 1-每日进度奖励
on_reward(1, Param) ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones_player{is_progress_award = IsAward} = Data = find_player_data(PlayerID),
		?CHECK_THROW(IsAward =:= 0, ?ErrorCode_GuildInsZones_HasAward),
		#guild_ins_zones{yesterday_chapter_id = ChapterID, yesterday_progress = Progress} = guild_ins_zones_logic:find_zones(GuildID),
		List = [{Cfg#guildCopyRateCfg.progress, Cfg#guildCopyRateCfg.rewardItem} || {Cp, _} = K <- cfg_guildCopyRate:getKeyList(), Cp =:= ChapterID, ((Cfg = cfg_guildCopyRate:row(K))) =/= {}],
		{_, AwardItemList} = common:getValueByInterval(Progress, List, {0, []}),
		?CHECK_THROW(AwardItemList =/= [], ?ErrorCode_GuildInsZones_NoAward),
		CurrList = [{CfgId, Amount} || {_, 2, CfgId, Amount, _, _, _} <- AwardItemList],
		ItemList = [{CfgId, Amount, Bind} || {_, 1, CfgId, Amount, _, _, Bind} <- AwardItemList],
		EqList = eq:create_eq([{I, B, Q, S} || {_, 3, I, _, Q, S, B} <- AwardItemList]),
		update_player_data(Data#guild_ins_zones_player{is_progress_award = 1}),
		player_item:reward(ItemList, EqList, CurrList, ?Reason_GuildInsZonesDailyProgress),
		player_item:show_get_item_dialog(ItemList, CurrList, EqList, 0),
		player:send(#pk_GS2U_guild_ins_zones_award_ret{type = 1, param = Param, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_award_ret{type = 1, param = Param, err_code = Err})
	end;
%% 2-次数奖励
on_reward(2, Order) ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones_player{times_award_list = AwardList, challenge_times = ChallengeTimes} = Data = find_player_data(PlayerID),
		?CHECK_THROW(not lists:member(Order, AwardList), ?ErrorCode_GuildInsZones_HasAward),
		#guild_ins_zones{chapter_id = ChapterID} = guild_ins_zones_logic:find_zones(GuildID),
		Cfg = cfg_guildCopyTimesReward:getRow(ChapterID, Order),
		?CHECK_CFG(Cfg),
		#guildCopyTimesRewardCfg{num = NeedNum, timesReward = TimesReward} = Cfg,
		?CHECK_THROW(ChallengeTimes >= NeedNum, ?ErrorCode_GuildInsZones_NoAward),
		CurrList = [{CfgId, Amount} || {_, 2, CfgId, Amount, _, _, _} <- TimesReward],
		ItemList = [{CfgId, Amount, Bind} || {_, 1, CfgId, Amount, _, _, Bind} <- TimesReward],
		EqList = eq:create_eq([{I, B, Q, S} || {_, 3, I, _, Q, S, B} <- TimesReward]),
		update_player_data(Data#guild_ins_zones_player{times_award_list = [Order | AwardList]}),
		player_item:reward(ItemList, EqList, CurrList, ?Reason_GuildInsZonesDailyProgress),
		player_item:show_get_item_dialog(ItemList, CurrList, EqList, 0),
		player:send(#pk_GS2U_guild_ins_zones_award_ret{type = 2, param = Order, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_award_ret{type = 2, param = Order, err_code = Err})

	end;
%% 3-通关奖励
on_reward(3, NodeID) ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones{chapter_id = ChapterID} = guild_ins_zones_logic:find_zones(GuildID),
		#guild_ins_zones_player{award_node_list = AwardNodeList} = Data = find_player_data(PlayerID),
		?CHECK_THROW(not lists:member({ChapterID, NodeID}, AwardNodeList), ?ErrorCode_GuildInsZones_HasAward),
		Cfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(Cfg),
		#guildCopyNodeCfg{reward1 = Reward, playType = PlayType} = Cfg,
		?CHECK_THROW(PlayType =:= ?GuildInsMapTypeBoss, ?ErrorCode_GuildInsZones_NoAward),
		CurrList = [{CfgId, Amount} || {_, 2, CfgId, Amount, _, _, _} <- Reward],
		ItemList = [{CfgId, Amount, Bind} || {_, 1, CfgId, Amount, _, _, Bind} <- Reward],
		EqList = eq:create_eq([{I, B, Q, S} || {_, 3, I, _, Q, S, B} <- Reward]),
		update_player_data(Data#guild_ins_zones_player{award_node_list = [{ChapterID, NodeID} | AwardNodeList]}),
		player_item:reward(ItemList, EqList, CurrList, ?Reason_GuildInsZonesPassNode),
		player_item:show_get_item_dialog(ItemList, CurrList, EqList, 0),
		player:send(#pk_GS2U_guild_ins_zones_award_ret{type = 3, param = NodeID, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_award_ret{type = 3, param = NodeID, err_code = Err})

	end;
on_reward(Type, Param) ->
	player:send(#pk_GS2U_guild_ins_zones_award_ret{type = Type, param = Param, err_code = ?ERROR_Param}).

on_get_guild_server_progress() ->
	List = ets:tab2list(?EtsGuildInsZones),
	SortFunc = fun(#guild_ins_zones{chapter_id = Chapter1, progress = Progress1, time = Time1},
		#guild_ins_zones{chapter_id = Chapter2, progress = Progress2, time = Time2}) ->
		case Chapter1 =:= Chapter2 of
			?TRUE ->
				case Progress1 =:= Progress2 of
					?TRUE -> Time1 < Time2;
					?FALSE -> Progress1 > Progress2
				end;
			?FALSE -> Chapter1 > Chapter2
		end
			   end,
	SortList = lists:sort(SortFunc, List),
	{RankList, _} = lists:mapfoldl(fun(#guild_ins_zones{guild_id = Gid} = R, Num) ->
		{{Gid, R, Num}, Num + 1} end, 1, SortList),
	RankList.

on_reset5() ->
	PlayerID = player:getPlayerID(),
	Time = time:time(),
	#guild_ins_zones_player{is_progress_award = IsProgressAward, next_time = NextTime, pass_node_list = PassNodeList} = Data = find_player_data(PlayerID),
	case IsProgressAward > 0 orelse Time >= NextTime of
		?TRUE ->
			NewData = case Time >= NextTime of
						  ?TRUE ->
							  FilterFunc = fun(Key) ->
								  case cfg_guildCopyNode:row(Key) of
									  #guildCopyNodeCfg{resetType = 1} -> ?TRUE;
									  _ -> ?FALSE
								  end
										   end,
							  Data#guild_ins_zones_player{is_progress_award = 0, next_time = get_next_reset_time(), pass_node_list = lists:filter(FilterFunc, PassNodeList)};
						  ?FALSE -> Data#guild_ins_zones_player{is_progress_award = 0}
					  end,
			update_player_data(NewData);
		?FALSE -> ok
	end.

on_map_settle_accounts({_, _, _, Value}, Key) ->
	try
		case cfg_guildCopyNode:row(Key) of
			#guildCopyNodeCfg{type = ?GuildInsNodeTypeWelfare, rewardItem2 = RewardItem} ->
				{ChapterID, NodeID} = Key,
				PlayerID = player:getPlayerID(),
				#guild_ins_zones_player{pass_node_list = OldPassNodeList} = Data = find_player_data(PlayerID),
				ItemList = [{CfgId, Amount, Bind} || {_, 1, CfgId, Amount, _, _, Bind} <- RewardItem],
				CurrList = [{CfgId, Amount} || {_, 2, CfgId, Amount, _, _, _} <- RewardItem],
				EqList = eq:create_eq([{I, B, Q, S} || {_, 3, I, _, Q, S, B} <- RewardItem]),
				update_player_data(Data#guild_ins_zones_player{pass_node_list = [Key | OldPassNodeList]}),
				player_item:reward(ItemList, EqList, CurrList, ?Reason_GuildInsZonesWelfare),
				Msg = #pk_GS2U_guild_ins_zones_settle_welfare{
					chapter_id = ChapterID,
					node_id = NodeID,
					is_success = 1,
					param = Value,
					item_list = [#pk_Dialog_Item{item_id = CfgId, count = Amount, multiple = 1, bind = Bind} || {CfgId, Amount, Bind} <- ItemList],
					eq_list = [eq:make_eq_msg(Eq) || {_, Eq} <- EqList],
					coin_list = [#pk_Dialog_Coin{type = CfgId, amount = Amount, multiple = 1} || {CfgId, Amount} <- CurrList]
				},
				player:send(Msg);
			_ ->
				?LOG_ERROR("error tpye ~p", [Key])
		end
	catch
		_ -> ok
	end.

on_challenge_log(1) ->
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones{log_data = LogData} = guild_ins_zones_logic:find_zones(GuildID),
		TotalPages = ceil(length(LogData) / 10),
		{SendData, RemainData} = common:split(10, LogData),
		log_data_req_cache({RemainData, TotalPages}),
		Msg = lists:map(fun make_guild_ins_zones_log_msg/1, SendData),
		player:send(#pk_GS2U_guild_ins_zones_log_ret{pages = 1, total_pages = TotalPages, log_list = Msg, err_code = ?ERROR_OK})
	catch
		Err ->
			player:send(#pk_GS2U_guild_ins_zones_log_ret{pages = 1, err_code = Err})
	end;
on_challenge_log(Pages) ->
	{LogData, TotalPages} = log_data_req_cache(),
	{SendData, RemainData} = common:split(10, LogData),
	log_data_req_cache({RemainData, TotalPages}),
	Msg = lists:map(fun make_guild_ins_zones_log_msg/1, SendData),
	player:send(#pk_GS2U_guild_ins_zones_log_ret{pages = Pages, total_pages = TotalPages, log_list = Msg, err_code = ?ERROR_OK}).

guild_quit() ->
	PlayerID = player:getPlayerID(),
	case table_player:lookup(?TableGuildInsZonesPlayer, PlayerID) of
		[] -> ok;
		[R] -> update_player_data(R#guild_ins_zones_player{pos_node = 0})
	end.

on_get_guild_ins_zones_boss_first_pass(ChapterID) ->
	PassList = db_shared_storage:get_value(?GUILD_INS_ZONES_FIRST_PASS, []),
	SendList = case ChapterID of
				   0 ->
					   [#pk_guild_ins_zones_boss_first_pass{chapter_id = C, node_id = N, guild_name = GuildName}
						   || {{C, N}, _, GuildName} <- PassList];
				   _ ->
					   [#pk_guild_ins_zones_boss_first_pass{chapter_id = C, node_id = N, guild_name = GuildName}
						   || {{C, N}, _, GuildName} <- PassList, C =:= ChapterID]
			   end,
	player:send(#pk_GS2U_guild_ins_zones_boss_first_pass_ret{list = SendList}).

gm_pass(NodeID) ->
	try
		GuildID = player:getPlayerProperty(#player.guildID),
		?CHECK_THROW(GuildID > 0, ?ErrorCode_Guild_NoGuild),
		#guild_ins_zones{chapter_id = ChapterID, zones_node_list = NodeList} = guild_ins_zones_logic:find_zones(GuildID),
		Cfg = cfg_guildCopyNode:getRow(ChapterID, NodeID),
		?CHECK_CFG(Cfg),
		#guildCopyNodeCfg{type = Type} = Cfg,
		?CHECK_THROW(lists:member(Type, [?GuildInsNodeTypeProgress, ?GuildInsNodeTypeEffect]), ?ERROR_Param),
		case guild_ins_zones_logic:find_node(NodeList, NodeID) of
			#guild_ins_zones_node{is_pass = 0} -> ok;
			_ -> throw(?ErrorCode_GuildInsZones_Pass)
		end,
		guild_instance_zones:on_update_node_element(GuildID, ChapterID, NodeID, [{#guild_ins_zones_node.is_pass, 1}, {#guild_ins_zones_node.is_mark, 0}]),
		guild_instance_zones:on_node_pass(GuildID, ChapterID, NodeID)
	catch
		_ -> ok
	end.
%%%===================================================================
%%% Internal functions
%%%===================================================================
find_player_data(PlayerID) ->
	case table_player:lookup(?TableGuildInsZonesPlayer, PlayerID) of
		[] -> #guild_ins_zones_player{player_id = PlayerID, next_time = get_next_reset_time()};
		[R] -> R
	end.

update_player_data(Data) ->
	table_player:insert(?TableGuildInsZonesPlayer, Data).

make_guild_ins_zones_bag_msg({NodeID, List}) ->
	#pk_guild_ins_zones_bag{
		node_id = NodeID,
		item_list = [#pk_key_value{key = ItemID, value = Num} || {ItemID, Num} <- List]
	}.

make_guild_ins_zones_node_msg(#guild_ins_zones_node{node_id = NodeID, is_pass = IsPass, is_mark = IsMark, player_num = PlayerNum,
	param1 = Param1, max_hp = MaxHp}) ->
	#pk_guild_ins_zones_node{
		node_id = NodeID,
		is_pass = IsPass,
		is_mark = IsMark,
		player_num = PlayerNum,
		param1 = Param1,
		max_hp = MaxHp
	}.

get_next_reset_time() ->
	time:weektime5_add(time:time(), 7 * ?SECONDS_PER_DAY).

check_personal_node_open(GuildID, ChapterID, NodeID) ->
	case cfg_guildCopyNode:getRow(ChapterID, NodeID) of
		#guildCopyNodeCfg{priorPoint = []} -> ?TRUE;
		#guildCopyNodeCfg{priorPoint = PreNeed} ->
			check_node_open_1(lists:keysort(1, PreNeed), 1, ChapterID, GuildID, ?FALSE);
		_ -> ?FALSE
	end.

check_node_open_1([], _, _, _, Ret) -> Ret;
check_node_open_1([{G, _, _} | _], Group, _, _, ?TRUE) when G > Group -> ?TRUE;
check_node_open_1([{G, _, _} | _] = Condition, Group, GuildID, ChapterID, ?FALSE) when G > Group ->
	check_node_open_1(Condition, G, GuildID, ChapterID, ?FALSE);
check_node_open_1([{G, _, _} | T], Group, GuildID, ChapterID, ?FALSE) when G < Group ->
	check_node_open_1(T, Group, GuildID, ChapterID, ?FALSE);
check_node_open_1([{Group, ?NodeOpenCondition_PassNode, NodeID} | T], Group, ChapterID, GuildID, _) ->
	case guild_ins_zones_logic:find_node(GuildID, NodeID) of
		#guild_ins_zones_node{is_pass = 1} -> check_node_open_1(T, Group, GuildID, ChapterID, ?TRUE);
		#guild_ins_zones_node{is_pass = 0} -> check_node_open_1(T, Group + 1, GuildID, ChapterID, ?FALSE);
		{} ->
			#guild_ins_zones_player{pass_node_list = PassNodeList} = find_player_data(player:getPlayerID()),
			case lists:member({ChapterID, NodeID}, PassNodeList) of
				?TRUE -> check_node_open_1(T, Group, GuildID, ChapterID, ?TRUE);
				?FALSE -> check_node_open_1(T, Group + 1, GuildID, ChapterID, ?FALSE)
			end
	end;
check_node_open_1([_ | T], Group, GuildID, ChapterID, _) ->
	check_node_open_1(T, Group + 1, GuildID, ChapterID, ?FALSE).

log_data_req_cache(Data) ->
	put({?MODULE, log_data_req_cache}, Data).

log_data_req_cache() ->
	case get({?MODULE, log_data_req_cache}) of
		?UNDEFINED -> {};
		Data -> Data
	end.

make_guild_ins_zones_log_msg(R) -> setelement(1, R, pk_guild_ins_zones_log).

check_guild_miss() ->
	case player:getPlayerProperty(#player.guildID) > 0 of
		?TRUE -> ok;
		?FALSE ->
			guild_quit()
	end.