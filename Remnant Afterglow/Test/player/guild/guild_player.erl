%%%-------------------------------------------------------------------
%%% @author Administrator
%%% @copyright (C) 2016, <COMPANY>
%%% @doc
%%% 帮派玩家进程
%%% @end
%%% Created : 26. 二月 2016 14:38
%%%-------------------------------------------------------------------
-module(guild_player).
-include("cfg_guildSacrifice.hrl").
-include("variable.hrl").
-include("netmsgRecords.hrl").
-include("condition_compile.hrl").
-include("record.hrl").
-include("globalDict.hrl").
-include("guild.hrl").
-include("logDefine.hrl").
-include("cfg_chariotLevel.hrl").
-include("error.hrl").
-include("copyMap.hrl").
-include("logger.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("playerDefine.hrl").
-include("cfg_guildBuilding.hrl").
-include("item.hrl").
-include("cfg_equipBase.hrl").
-include("cfg_item.hrl").
-include("db_table.hrl").
-include("attainment.hrl").
-include("player_task_define.hrl").
-include("currency.hrl").
-include("cfg_globalSetupText.hrl").
-include("daily_task_goal.hrl").
-include("seven_gift_define.hrl").
-include("activity_new.hrl").
-include("cfg_chariotscience.hrl").
-include("cfg_guildActivity.hrl").
-include("chatDefine.hrl").

%% API
-export([
	create_guild/1, guild_msg_create_guild_result/2, query_guild_list/0, get_my_guild_info/0, get_my_guild_applicant_info/0,
	change_guild_announcement/1, change_guild_link/1, change_guild_member_rank/1, kick_out_guild_member/1, quit_guild/0, request_join_guild/1,
	operate_guild_applicant/1, operate_all_guild_applicant/1, on_onekey_refuse_app/0, change_guild_name/1, change_guild_name/2,
	dissolve_guild/0, invite_player/1, apply_invite/1, on_fete_god/2, get_my_guild_member_info/0,
	on_get_fete_god_award/1, on_player_online/0, on_cancel_join_guild/1, on_get_guild_salary/0, on_set_enter_condition/2,
	on_set_auto_join/1, on_donate_guild_money/1, on_get_money_log_list/0, on_get_guild_money/0, on_player_offline/1,
	change_player_property/1, on_player_join_guild/0, on_tick/1, get_player_guild_level/0, up_level_building/1]).

-export([on_invited/2, invite_by_money/3, on_invited_by_money/3, guild_impeach/0, get_guild_event/0, get_guild_wish/0,
	on_get_guild_bag_data/0, on_donate_item/1, on_get_guild_bag_item/2, on_delete_guild_bag_item/1, depot_auto_clear_set/4,
	req_donate_value/0, show_demons_eq/1, on_assign_treasure_chest/1, on_assign_treasure_rule_set/1, on_get_prestige_salary/0,
	on_get_assign_treasure_event/0, req_prestige_value/1, on_chariot_info_req/0, on_guild_science_info_req/0, on_guild_science_update/1,
	on_build_chariot/1, on_chariot_cancel/1, on_chariot_use_rule_set/1, on_active_value_access/2, on_active_value_access_ex/3,
	on_assign_guild_award/3, on_assign_award_rule_set/2, on_assign_award_list_req/1, on_assign_award_log_req/1, get_active_value/0]).

-define(CreateGuildLock, player_create_guild_wait).

%%创建帮派
create_guild(#pk_U2GS_CreateGuild{headIcon = Icon} = Msg) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 case get(?CreateGuildLock) of
						 1 ->
							 throw(?Guild_CreateResult_HasGuild);
						 _ -> ok
					 end,
					 Name = Msg#pk_U2GS_CreateGuild.strGuildName,
					 NameLen = string:len(Name),
					 case NameLen =< 0 orelse Name =:= "" orelse Name =:= [] of
						 ?TRUE ->
							 throw(?GS2U_CretaResult_NoName);
						 ?FALSE -> ok
					 end,
					 ?CHECK_THROW(string:trim(Name) =:= Name, ?Guild_ModifyAnnouncement_Forbidden),
					 case (NameLen < ?Min_CreateGuildName_Len) or (NameLen > ?Max_CreateGuildName_Len * 3) of
						 true ->
							 throw(?Guild_CreateResult_NameOutOfLenght);
						 false -> ok
					 end,

					 case df:checkForbidden(Name) of
						 false -> ok;
						 true ->
							 throw(?Guild_ModifyAnnouncement_Forbidden)
					 end,

					 case player:getPlayerProperty(#player.guildID) =:= 0 of
						 true -> ok;
						 false ->
							 throw(?Guild_CreateResult_HasGuild)
					 end,

					 AllGuild = table_global:record_list(?TableGuild),

					 IsNameMulty = lists:all(fun(#guild_base{guildName = GuildName}) ->
						 (GuildName =/= Name) end, AllGuild),
					 case IsNameMulty of
						 ?TRUE -> ok;
						 _ ->
							 throw(?GS2U_CreateGuildResult_Fail_Name_Multy)
					 end,

					 GuildCount = etsBaseFunc:getCount(?Ets_GuildMemberMaps),
					 case GuildCount >= ?Guild_Max_Count of
						 ?TRUE ->
							 throw(?GS2U_CreateResult_MaxCount);
						 ?FALSE -> ok
					 end,

					 %%检查30级及以上玩家是否退过工会，且间隔时间大于24小时.只有大于24小时才能申请
					 PlayerLevel = player:getPlayerProperty(#player.level),
					 case (PlayerLevel >= cfg_globalSetup:joinGuildLimit())
						 andalso (time:time() < time:time_add(player:getPlayerProperty(#player.quitGuildTime), ?SECONDS_PER_DAY)) of
						 true ->
							 ClearSpent = df:getGlobalSetupValue(guildClearTime1, 0),
							 FreeClearTimes = df:getGlobalSetupValue(guildClearTime2, 0),
							 ClearTimes = variable_player:get_value(?FixedVariant_Index_56_ClearQuitGuildTimes),
							 case ClearTimes >= FreeClearTimes of
								 ?FALSE ->
									 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}]),
									 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1);
								 ?TRUE ->
									 SpentGold = ClearSpent * (ClearTimes - FreeClearTimes + 1),
									 CurrencyError = currency:delete(?CURRENCY_GoldBind, SpentGold, ?Gold_Change_ClearQuitGuildTime),
									 ?ERROR_CHECK_THROW(CurrencyError),
									 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1),
									 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}])
							 end;
						 false -> ok
					 end,

					 %% 道具和货币分开扣除（道具不足时扣除道具）
					 Cost = df:getGlobalSetupValueList(builtGuildNeed, []),
					 CoinList = [{ID, Num} || {Type, ID, Num} <- Cost, Type =:= 2],
					 ItemList = [{ID, Num} || {Type, ID, Num} <- Cost, Type =:= 1],

					 {ItemError, ItemPrepared} = bag_player:delete_prepare(ItemList),
					 case ItemError =:= ?ERROR_OK of
						 ?TRUE ->
							 bag_player:delete_finish(ItemPrepared, ?Reason_Guild_Create);
						 ?FALSE ->
							 CurrencyError1 = currency:delete(CoinList, ?Reason_Guild_Create),
							 ?ERROR_CHECK_THROW(CurrencyError1)
					 end,
					 put(?CreateGuildLock, 1),
					 #player{name = PName, level = PLevel, sex = PSex, nationality_id = PNation, battleValue = PBt} = player:getPlayerRecord(),
					 guildPID ! {playerMsgCreateGuild, {player:getPlayerID(), PName, PLevel, PSex, PNation, PBt, Name, Icon}},
					 ok
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_CreateGuildResult{result = ErrorCode, guildID = 0}),
						 ok
				 end end).

%%创建帮派结果
guild_msg_create_guild_result(GuildID, Result) ->
	?metrics(begin
				 put(?CreateGuildLock, 0),
				 case Result of
					 ?ERROR_OK ->
						 player:setPlayerGuildID(GuildID),
						 logdbProc:log_playerAction(?Player_Action_CreateGuild, GuildID),
						 player:send(#pk_GS2U_CreateGuildResult{result = Result, guildID = GuildID}),
						 activity_new_player:on_active_condition_change(?SalesActivity_Guild_CreateGuild, 1),
						 expedition:send_2_master({create_guild, player:getPlayerID(), GuildID}),
						 ok;
					 _ ->
						 player:send(#pk_GS2U_CreateGuildResult{result = Result, guildID = 0})
				 end end).

%%查询所有帮派列表
query_guild_list() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 AllGuildList = table_global:record_list(?TableGuild),
						 SortList = guild_pub:sort_guild(AllGuildList),
						 PlayerID = player:getPlayerID(),
						 {ResultList, _} = lists:mapfoldl(fun(Record, RankNum) ->
							 IsApp = case lists:keymember(PlayerID, #guildApplicant.playerID, Record#guild_base.applicantList) of
										 ?FALSE -> 0;
										 _ -> 1
									 end,
							 {Venue, _} = domain_fight_logic:get_guild_venue(Record#guild_base.id),
							 SendInfo = #pk_GuildInfoSmall{
								 nGuildID = Record#guild_base.id,
								 headIcon = Record#guild_base.headIcon,
								 strGuildName = Record#guild_base.guildName,
								 nChairmanPlayerID = Record#guild_base.chairmanPlayerID,
								 strChairmanPlayerName = Record#guild_base.chairmanPlayerName,
								 nLevel = proplists:get_value(?GuildBuilding_Lobby, Record#guild_base.building_list, 1),
								 nMemberCount = etsBaseFunc:getRecordField(?Ets_GuildMemberMaps, Record#guild_base.id, #guild_member_maps.member_total, 1),
								 strAnnouncement = Record#guild_base.announcement,
								 isApp = IsApp,
								 rank = RankNum,
								 guildBattleValue = guild_pub:get_guild_total_battle_value(Record#guild_base.id),
								 autoJoin = Record#guild_base.autoJoin,
								 rating = Venue,
								 condition_list = [#pk_guildCondition{type = Type, value = Value} || {Type, Value} <- Record#guild_base.enterCondition],
								 is_knight = common:bool_to_int(lists:keymember(Record#guild_base.id, 2, guild_knight:get_topN())),
								 strLink = Record#guild_base.link_url
							 },
							 {SendInfo, RankNum + 1}
														  end, 1, SortList),
						 player:send(#pk_GS2U_GuildInfoSmallList{info_list = ResultList});
					 ?FALSE ->
						 player:send(#pk_GS2U_GuildInfoSmallList{})
				 end end).


get_guild_rank(GuildID) ->
	GuildList = guild_pub:sort_guild(),
	get_guild_rank_1(GuildList, GuildID, 1).

get_guild_rank_1([], _, _) -> 0;
get_guild_rank_1([#guild_base{id = GuildID} | _], GuildID, Num) -> Num;
get_guild_rank_1([_ | T], GuildID, Num) -> get_guild_rank_1(T, GuildID, Num + 1).



make_guild_building_msg(BuildingList) ->
	Func =
		fun({ID, Lv}) ->
			#pk_guildBuilding{
				buildingID = ID,
				level = Lv
			}
		end,
	lists:map(Func, BuildingList).

%% 获取帮派事件
get_guild_event() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 case guild_pub:find_guild(GuildID) of
							 {} -> ok;
							 _ ->
								 EventList0 = lists:keysort(#guildEvent.time, guild_event:get_guild_module_log_list(GuildID, ?EventModule_1)),
								 EventList = lists:sublist(lists:reverse(EventList0), 50),
								 player:send(#pk_GS2U_GetMyGuildEventRet{event_list = [guild_pub:make_guild_dynamic(R) || R <- EventList]}),
								 ok
						 end;
					 ?FALSE ->
						 player:send(#pk_GS2U_GetMyGuildEventRet{})
				 end end).


%% 获取帮派许愿
get_guild_wish() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 case guild_pub:find_guild(GuildID) of
							 {} -> ok;
							 Guild ->
								 player:send(#pk_GS2U_GetMyGuildWishDataRet{wish_list = lists:flatten([guild_wish:make_wish_info(Info) || Info <- Guild#guild_base.wishList])}),
								 ok
						 end;
					 ?FALSE ->
						 player:send(#pk_GS2U_GetMyGuildWishDataRet{})
				 end end).


%%查询自己帮派的信息（全部信息）
get_my_guild_info() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 case guild_pub:find_guild(GuildID) of
							 {} -> ok;
							 Guild ->
								 MsgGuildBase = #pk_GuildBaseData{
									 nGuildID = Guild#guild_base.id,
									 headIcon = Guild#guild_base.headIcon,
									 strGuildName = Guild#guild_base.guildName,
									 nChairmanPlayerID = Guild#guild_base.chairmanPlayerID,
									 strChairmanPlayerName = Guild#guild_base.chairmanPlayerName,
									 nRank = get_guild_rank(Guild#guild_base.id),
									 nLevel = proplists:get_value(?GuildBuilding_Lobby, Guild#guild_base.building_list, 1),
									 memberCount = guild_pub:get_guild_member_num(Guild#guild_base.id),
									 strAnnouncement = Guild#guild_base.announcement,
									 feteValue = Guild#guild_base.feteValue,
									 feteCount = length(Guild#guild_base.feteIDList),
									 feteTotalTimes = lists:sum([N || {_, N} <- Guild#guild_base.feteIDList]),
									 createTime = Guild#guild_base.createTime,
									 changeNameTime = Guild#guild_base.changeNameTime,
									 guildMoney = Guild#guild_base.guildMoney,
									 autoJoin = Guild#guild_base.autoJoin,
									 building_materials = Guild#guild_base.building_materials,
									 treasure_chest = Guild#guild_base.treasure_chest,
									 treasure_chest_consume = Guild#guild_base.treasure_chest_consume,
									 assign_treasure_rule = Guild#guild_base.treasure_assign_rule,
									 condition_list = [#pk_guildCondition{type = Type, value = Value} || {Type, Value} <- Guild#guild_base.enterCondition],
									 building_list = make_guild_building_msg(Guild#guild_base.building_list),
									 wish_limit_num = Guild#guild_base.wish_limit_num,
									 chariot_science_list = [#pk_key_value{key = ID, value = Lv} || {ID, Lv} <- Guild#guild_base.chariot_science_list],
									 chariot_use_rule = Guild#guild_base.chariot_use_rule,
									 active_value = Guild#guild_base.active_value,
									 active_less_day = Guild#guild_base.active_less_day,
									 guild_ins_zones_assign_rule = Guild#guild_base.guild_ins_zones_assign_rule,
									 is_knight = common:bool_to_int(lists:keymember(GuildID, 2, guild_knight:get_topN())),
									 strLink = Guild#guild_base.link_url
								 },
								 PlayerID = player:getPlayerID(),
								 TotalBv = guild_pub:get_guild_total_battle_value(GuildID),
								 MyRank = guild_pub:get_member_rank(GuildID, PlayerID),
								 {MyFeteListMsg, RecentGiftTime, MyAccessList, MyLessDay} =
									 case guild_pub:find_guild_member(PlayerID) of
										 #guild_member{feteList = FeteList, giveList = GiveList, active_value_access = AccessList,
											 active_less_day = LessDay} ->
											 {[#pk_FeteAwardsList{feteID = FeteID} || FeteID <- FeteList],
												 common:listKeyMax(#giveInfo.giveTime, GiveList), AccessList, LessDay};
										 _ -> {[], 0, [], 0}
									 end,
								 player:send(#pk_GS2U_GuildFullInfo{stBase = MsgGuildBase, total_bv = TotalBv, my_rank = MyRank,
									 feteList = MyFeteListMsg, last_give_time = RecentGiftTime, active_value_access = [#pk_key_value{key = P1, value = P2} || {P1, P2} <- MyAccessList],
									 active_less_day = MyLessDay}),
								 ok
						 end;
					 ?FALSE ->
						 player:send(#pk_GS2U_GuildFullInfo{})
				 end end).


get_my_guild_member_info() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 case GuildID of
							 0 -> player:send(#pk_GS2U_GuildAllMemberInfo{member_list = []});
							 _ ->
								 #guildActivityCfg{access = AccessCfg} = cfg_guildActivity:first_row(),
								 ConvertFunc = fun(#guild_member{} = Member) ->
									 #pk_GuildMemberData{
										 nPlayerID = Member#guild_member.playerID,
										 strPlayerName = Member#guild_member.playerName,
										 nPlayerLevel = Member#guild_member.playerLevel,
										 nRank = Member#guild_member.rank,
										 sex = Member#guild_member.playerSex,
										 vip = Member#guild_member.playerVip,
										 headID = Member#guild_member.playerHeadID,
										 nContribute = Member#guild_member.prestige,
										 nweeklyContr = Member#guild_member.weekly_prestige,
										 bOnline = guild_pub:get_guild_mem_off_flag(Member#guild_member.isOnline, Member#guild_member.lastOffTime),
										 battleValue = Member#guild_member.battleValue,
										 offlineTime = Member#guild_member.lastOffTime,
										 frame = Member#guild_member.playerFrame,
										 join_time = Member#guild_member.joinTime,
										 nationality_id = Member#guild_member.playerNational,
										 state_mark = Member#guild_member.state_mark,
										 active_value = guild_pub:calc_active_value(Member#guild_member.active_value_access, AccessCfg, 0)
									 }
											   end,
								 MemberList = [ConvertFunc(MemberData) || MemberData <- guild_pub:get_guild_all_member_record(GuildID)],
								 player:send(#pk_GS2U_GuildAllMemberInfo{member_list = MemberList})
						 end;
					 ?FALSE ->
						 player:send(#pk_GS2U_GuildAllMemberInfo{})
				 end end).


%%获取申请入帮信息
get_my_guild_applicant_info() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 case GuildID of
							 0 -> ok;
							 _ ->
								 case guild_pub:find_guild(GuildID) of
									 {} -> ok;
									 Guild ->
										 case guild_pub:get_member_rank(GuildID, player:getPlayerID()) of
											 Rank when Rank >= ?GuildRank_ViceChairman ->
												 ConvertFunc = fun(#guildApplicant{playerID = PlayerID_A}) ->
													 #player{name = PlayerName_A, sex = PlayerSex, level = Level_A,
														 battleValue = BattleValue_A, vip = Vip, head_id = HeadId, frame_id = FrameId} = mirror_player:get_player(PlayerID_A),
													 #pk_GuildApplicantData{
														 nPlayerID = PlayerID_A,
														 strPlayerName = PlayerName_A,
														 player_sex = PlayerSex, nPlayerLevel = Level_A,
														 vip = Vip, headID = HeadId, battleValue = BattleValue_A,
														 frame = FrameId
													 } end,
												 ApplicantList = [ConvertFunc(ApplicantData) || ApplicantData <- Guild#guild_base.applicantList, is_record(ApplicantData, guildApplicant)],
												 player:send(#pk_GS2U_GuildApplicantInfoList{info_list = ApplicantList});
											 _ -> ok
										 end
								 end
						 end;
					 ?FALSE ->
						 player:send(#pk_GS2U_GuildApplicantInfoList{})
				 end end).


%%修改帮派公告
change_guild_announcement(#pk_U2GS_RequestChangeGuildAnnouncement{strAnnouncement = Announcement} = Msg) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_ChangeRank_NoGuild);
						 _ -> ok
					 end,

					 AnnouncementLen = string:len(Announcement),
					 case AnnouncementLen > ?Max_GuildAnnouncement_CharCount * 3 of
						 true ->
							 throw(?Guild_ModifyAnnouncement_Toolong);
						 false -> ok
					 end,

					 case df:checkForbidden(Announcement) of
						 true ->
							 throw(?Guild_ModifyAnnouncement_Forbidden);
						 false -> ok
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 Rank = case lists:keyfind(PlayerID, 1, MemberList) of
								false -> throw(?Guild_ModifyAnnouncement_NotMember);
								{_, Rk, _} -> Rk

							end,
					 case Rank >= ?GuildRank_ViceChairman of
						 true -> ok;
						 false -> throw(?Guild_ModifyAnnouncement_NoPermission)
					 end,
					 guildPID ! {playerMsgChangeGuildAnnouncement, PlayerID, GuildID, Msg}
				 catch
					 Code -> player:send(#pk_GS2U_RequestChangeGuildAnnouncementResult{result = Code})
				 end end).
%%修改公会的Link群网址
change_guild_link(#pk_U2GS_RequestChangeGuildLinkUrl{strLink = StrLink} = Msg) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_ChangeRank_NoGuild);
						 _ -> ok
					 end,
					 LinkLen = string:len(StrLink),
					 case LinkLen > ?Max_GuildLink_CharCount * 3 of
						 ?TRUE ->
							 throw(?Guild_ModifyLinkUrl_Toolong);
						 ?FALSE -> ok
					 end,
					 StrLink2 = case string:str(StrLink, "https://line.me/") =:= 1 orelse string:str(StrLink, "http://line.me/") =:= 1 of%%前缀判断
									?TRUE ->
										case string:str(StrLink, "https://line.me/") =:= 1 of
											?TRUE -> StrLink--"https://line.me/";
											?FALSE -> StrLink-- "http://line.me/"
										end;
									?FALSE -> throw(?Guild_ModifyLinkUrl_PrefixErr)
								end,
					 case df:checkForbidden(StrLink2) of
						 ?TRUE ->
							 throw(?Guild_ModifyLinkUrl_Forbidden);
						 ?FALSE -> ok
					 end,
					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 Rank = case lists:keyfind(PlayerID, 1, MemberList) of
								?FALSE -> throw(?Guild_ModifyLinkUrl_NotMember);
								{_, Rk, _} -> Rk
							end,
					 case Rank >= ?GuildRank_Chairman of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?Guild_ModifyLinkUrl_NoPermission)
					 end,
					 guildPID ! {playerMsgChangeGuildLinkUrl, PlayerID, GuildID, Msg}
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_RequestChangeGuildLinkUrlResult{result = ErrCode})
				 end end).

%%调整帮派成员职位
change_guild_member_rank(#pk_U2GS_RequestGuildMemberRankChange{nPlayerID = TargetPlayerID, nRank = TargetRank} = Msg) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 case PlayerID =:= TargetPlayerID of
						 true -> throw(?Guild_ChangeRank_SamePlayer);
						 false -> ok
					 end,

					 %%帮派记录
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_ChangeRank_NoGuild);
						 _ -> ok
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 %%任命者成员信息记录
					 MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
					 Rank = case MemberRecord of
								false -> throw(?Guild_ChangeRank_NoSource);
								{_, R1, _} -> R1
							end,

					 %%目标玩家的成员信息记录
					 TargetMemberRecord = lists:keyfind(TargetPlayerID, 1, MemberList),
					 TargetNowRank = case TargetMemberRecord of
										 false -> throw(?Guild_ChangeRank_NoTarget);
										 {_, R2, _} -> R2
									 end,

					 %% 任命者权限检查
					 case Rank < TargetNowRank orelse Rank =< ?GuildRank_Elder of
						 true -> throw(?Guild_ChangeRank_NoPermission);
						 false -> ok
					 end,

					 case Rank of
						 ?GuildRank_Chairman -> ok;
						 ?GuildRank_SuperElder ->
							 case TargetRank =:= ?GuildRank_Chairman of
								 ?TRUE -> throw(?Guild_ChangeRank_NoPermission);
								 ?FALSE -> ok
							 end;
						 ?GuildRank_ViceChairman ->
							 case TargetRank < ?GuildRank_ViceChairman andalso TargetNowRank < ?GuildRank_ViceChairman of
								 ?TRUE -> ok;
								 ?FALSE -> throw(?Guild_ChangeRank_NoPermission)
							 end;
						 _ -> throw(?Guild_ChangeRank_NoPermission)
					 end,

					 guildPID ! {playerMsgRequestGuildMemberRankChange, player:getPlayerProperty(#player.guildID), player:getPlayerID(), Msg}
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_GuildMemberRankChangedResult{result = ErrorCode, nPlayerID = TargetPlayerID, nNewRank = TargetRank})
				 end end).

%%踢成员
kick_out_guild_member(#pk_U2GS_RequestGuildKickOutMember{nPlayerID = TargetPlayerID} = Msg) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 case PlayerID =:= TargetPlayerID of
						 true ->
							 throw(?Guild_KickOut_SamePlayer);
						 false ->
							 ok
					 end,

					 %%帮派记录
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} ->
							 throw(?Guild_KickOut_NoGuild);
						 _ ->
							 ok
					 end,

					 case guild_pub:active_can_exit_guild() of
						 ?TRUE ->
							 ok;
						 ?FALSE ->
							 throw(?ErrorCode_Guild_InActivity)
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} ->
										  M;
									  _ ->
										  throw(?Guild_ChangeRank_NoGuild)
								  end,
					 %%踢人者成员信息记录
					 MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
					 Rank = case MemberRecord of
								false ->
									throw(?Guild_KickOut_NoSource);
								{_, R1, _} ->
									R1
							end,

					 %%目标玩家的成员信息记录
					 TargetMemberRecord = lists:keyfind(TargetPlayerID, 1, MemberList),
					 TargetNowRank = case TargetMemberRecord of
										 false ->
											 throw(?Guild_KickOut_NoTarget);
										 {_, R2, _} ->
											 R2
									 end,

					 %% 判断权限
					 case Rank of
						 ?GuildRank_Chairman ->
							 ok;
						 ?GuildRank_SuperElder ->
							 case TargetNowRank of
								 ?GuildRank_Chairman ->
									 throw(?Guild_KickOut_NoPermission);
								 _ ->
									 ok
							 end;
						 ?GuildRank_ViceChairman ->
							 case TargetNowRank of
								 ?GuildRank_Normal ->
									 ok;
								 ?GuildRank_Elite ->
									 ok;
								 _ ->
									 throw(?Guild_KickOut_NoPermission)
							 end;
						 ?GuildRank_Elder ->
							 case TargetNowRank of
								 ?GuildRank_Normal ->
									 ok;
								 _ ->
									 throw(?Guild_KickOut_NoPermission)
							 end;
						 _ ->
							 throw(?Guild_KickOut_NoPermission)
					 end,
					 guildPID ! {playerMsgKickOutGuildMember, self(), PlayerID, GuildID, Msg}
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_RequestGuildKickOutMemberResult{result = ErrorCode})
				 end end).

%%主动退出帮派
quit_guild() ->
	?metrics(begin
				 guildPID ! {playerMsgRequestGuildQuit, self(), player:getPlayerID(), player:getPlayerProperty(#player.guildID)} end).

%%申请入帮
request_join_guild(#pk_U2GS_RequestJoinGuild{nGuildID = GuildID}) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 case guide:is_open_action(?OpenAction_guild) of
						 ?TRUE -> ok;
						 ?FALSE ->
							 throw(?Guild_Join_NotOpenAction)
					 end,

					 case player:getPlayerProperty(#player.guildID) =:= 0 of
						 true -> ok;
						 false ->
							 throw(?Guild_Join_AlreadyInGuild)
					 end,

					 ApplicantList = guild_pub:get_player_applicant_list(player:getPlayerID()),
					 case length(ApplicantList) >= ?GuildApplicant_MaxCount of
						 ?TRUE ->
							 throw(?Guild_Join_MaxApplicantGuild);
						 ?FALSE -> ok
					 end,


					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} ->
							 throw(?Guild_Join_NoGuild);
						 _ -> ok
					 end,

					 GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
										   #guild_member_maps{} = R ->
											   R;
										   _ ->
											   throw(?Guild_ChangeRank_NoGuild)
									   end,
					 %% 最大人数限制
					 MemberCount = GuildMemberMaps#guild_member_maps.member_total,
					 MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
					 case MemberCount < MaxMemberCount of
						 true -> ok;
						 false ->
							 throw(?Guild_Join_MaxMemberCount)
					 end,

					 GuildChangeCfg = cfg_globalSetupText:getRow(guildChange),
					 #globalSetupTextCfg{param2 = [{LimitDay, ChangeCD, ChangeCurr, ChangeNum}]} = GuildChangeCfg,

					 case time:time() > time:time_add(main:getServerStartTime(), LimitDay * ?SECONDS_PER_DAY) of
						 ?TRUE -> %% 已超过特殊时间
							 %%检查30级及以上玩家是否退过工会，且间隔时间大于24小时.只有大于24小时才能申请
							 PlayerLevel = player:getPlayerProperty(#player.level),
							 case (PlayerLevel >= cfg_globalSetup:joinGuildLimit())
								 andalso (time:time() < time:time_add(player:getPlayerProperty(#player.quitGuildTime), ?SECONDS_PER_DAY)) of
								 true ->
									 ClearSpent = df:getGlobalSetupValue(guildClearTime1, 0),
									 FreeClearTimes = df:getGlobalSetupValue(guildClearTime2, 0),
									 ClearTimes = variable_player:get_value(?FixedVariant_Index_56_ClearQuitGuildTimes),
									 case ClearTimes >= FreeClearTimes of
										 ?FALSE ->
											 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}]),
											 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1);
										 ?TRUE ->
											 SpentGold = ClearSpent * (ClearTimes - FreeClearTimes + 1),
											 CurrencyError = currency:delete(?CURRENCY_GoldBind, SpentGold, ?Gold_Change_ClearQuitGuildTime),
											 ?ERROR_CHECK_THROW(CurrencyError),
											 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1),
											 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}])
									 end;
%%				throw(?Guild_Join_StillInCD);
								 false -> ok
							 end;
						 ?FALSE -> %% 特殊时间内
							 ClearTimes = variable_player:get_value(?FixedVariant_Index_56_ClearQuitGuildTimes),
							 case time:time() - player:getPlayerProperty(#player.quitGuildTime) > ChangeCD * ?SECONDS_PER_MINUTE of
								 ?TRUE -> %% CD已过
									 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}]),
									 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1);
								 ?FALSE ->
									 CurrencyError = currency:delete(ChangeCurr, ChangeNum, ?Gold_Change_ClearQuitGuildTime),
									 ?ERROR_CHECK_THROW(CurrencyError),
									 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1),
									 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}])
							 end

					 end,

					 case Guild#guild_base.enterCondition of
						 [] -> ok;
						 ConditionList ->
							 Func = fun({Type, Value}) ->
								 case Type of
									 ?Guild_EnterCondition_BattleValue ->
										 player:getPlayerProperty(#player.battleValue) < Value
								 end
									end,
							 case not lists:any(Func, ConditionList) andalso Guild#guild_base.autoJoin =:= 1 of
								 ?TRUE ->
									 guildPID ! {conditionEnterGuild, GuildID, player:getPlayerID()},
									 throw(ok);
								 ?FALSE -> ok
							 end
					 end,
					 case Guild#guild_base.autoJoin =:= 1 andalso Guild#guild_base.enterCondition =/= [] of
						 ?FALSE -> ok;
						 _ ->
							 [{_, BValue} | _] = Guild#guild_base.enterCondition,
							 case player:getPlayerProperty(#player.battleValue) >= BValue of
								 ?TRUE -> ok;
								 ?FALSE ->
									 throw(?Guild_Error_BattleValue)
							 end
					 end,

					 guildPID ! {playerMsgRequestJoinGuild,
						 self(),
						 player:getPlayerID(),
						 player:getPlayerProperty(#player.name),
						 player:getPlayerProperty(#player.sex),
						 player:getPlayerProperty(#player.level),
						 GuildID,
						 player:getPlayerProperty(#player.battleValue)
					 }
				 catch
					 ok -> ok;
					 ErrorCode ->
						 player:send(#pk_GS2U_RequestJoinGuildResult{result = ErrorCode})
				 end end).

%%操作入帮的申请者
operate_guild_applicant(#pk_U2GS_RequestGuildApplicant{nPlayerID = TargetPlayerID, nAllowOrRefuse = IsAllow}) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 PlayerID = player:getPlayerID(),
					 case GuildID =:= 0 of
						 true -> throw(?Guild_OperateApplicant_HaveNoGuild);
						 false -> ok
					 end,
					 %%帮派记录
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_OperateApplicant_NoGuild);
						 _ -> ok
					 end,

					 GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
										   #guild_member_maps{} = R -> R;
										   _ -> throw(?Guild_ChangeRank_NoGuild)
									   end,
					 %%成员信息记录
					 MemberRecord = lists:keyfind(PlayerID, 1, GuildMemberMaps#guild_member_maps.member_list),
					 Rank = case MemberRecord of
								false -> throw(?Guild_OperateApplicant_NoMember);
								{_, R1, _} -> R1
							end,

					 %%成员权限检查
					 case Rank =:= ?GuildRank_ViceChairman orelse Rank =:= ?GuildRank_Chairman orelse Rank =:= ?GuildRank_SuperElder of
						 false -> throw(?Guild_OperateApplicant_NoPermission);
						 _ -> ok
					 end,

					 %%申请成员记录
					 ApplicantRecord = guild_pub:get_guild_applicatn_record(Guild, TargetPlayerID),
					 case ApplicantRecord of
						 {} -> throw(?Guild_OperateApplicant_NoApplicant);
						 _ -> ok
					 end,
					 case IsAllow of
						 1 ->%%同意
							 %% 最大人数限制
							 MemberCount = GuildMemberMaps#guild_member_maps.member_total,
							 MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
							 case MemberCount < MaxMemberCount of
								 true -> ok;
								 false -> throw(?Guild_OperateApplicant_MaxMemberCount)
							 end,
							 guildPID ! {playerMsgOperateGuildApplicant, self(), PlayerID, GuildID, TargetPlayerID, true};
						 0 ->%%拒绝
							 guildPID ! {playerMsgOperateGuildApplicant, self(), PlayerID, GuildID, TargetPlayerID, false}
					 end
				 catch
					 ErrorCode -> player:send(#pk_GS2U_RequestGuildApplicantResult{result = ErrorCode})
				 end end).

%% 操作申请人
operate_all_guild_applicant(#pk_U2GS_RequestGuildApplicantOPAll{nAllowOrRefuse = Flag} = _Msg) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 PlayerID = player:getPlayerID(),
					 case GuildID =:= 0 of
						 true ->
							 throw(?Guild_OperateApplicant_HaveNoGuild);
						 false ->
							 ok
					 end,
					 %%帮派记录
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} ->
							 throw(?Guild_OperateApplicant_NoGuild);
						 _ ->
							 ok
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} ->
										  M;
									  _ ->
										  throw(?Guild_ChangeRank_NoGuild)
								  end,

					 %%成员信息记录
					 MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
					 Rank = case MemberRecord of
								false ->
									throw(?Guild_OperateApplicant_NoMember);
								{_, Rk, _} ->
									Rk
							end,

					 %%成员权限检查
					 case Rank =:= ?GuildRank_ViceChairman orelse Rank =:= ?GuildRank_Chairman orelse Rank =:= ?GuildRank_SuperElder of
						 false ->
							 throw(?Guild_OperateApplicant_NoPermission);
						 _ ->
							 ok
					 end,
					 [operate_guild_applicant(#pk_U2GS_RequestGuildApplicant{nPlayerID = ApplicantInfo#guildApplicant.playerID, nAllowOrRefuse = Flag}) || ApplicantInfo <- Guild#guild_base.applicantList]
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_RequestGuildApplicantResult{result = ErrorCode})
				 end end).

%% 一键拒绝
on_onekey_refuse_app() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 PlayerID = player:getPlayerID(),
					 case GuildID =:= 0 of
						 true -> throw(?Guild_OperateApplicant_HaveNoGuild);
						 false -> ok
					 end,
					 %%帮派记录
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_OperateApplicant_NoGuild);
						 _ -> ok
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 %%成员信息记录
					 MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
					 Rank = case MemberRecord of
								false -> throw(?Guild_OperateApplicant_NoMember);
								{_, Rk, _} -> Rk
							end,

					 %%成员权限检查
					 case Rank =:= ?GuildRank_ViceChairman orelse Rank =:= ?GuildRank_Chairman orelse Rank =:= ?GuildRank_SuperElder of
						 false -> throw(?Guild_OperateApplicant_NoPermission);
						 _ -> ok
					 end,
					 guildPID ! {onekeyRefuseGuildApplicant, GuildID, PlayerID}
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_onkeyRefuseGuildAppResult{result = ErrorCode})
				 end end).

%%更改帮派名称
change_guild_name(#pk_U2GS_RequestChangeGuildName{strGuildName = NewGuildName}) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 NameLen = string:len(NewGuildName),
					 case (NameLen < ?Min_CreateGuildName_Len) or (NameLen > ?Max_CreateGuildName_Len) of
						 true ->
							 throw(?Guild_ChangeName_OutOfLength);
						 false -> ok
					 end,

					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} ->
							 throw(?Guild_ChangeName_NoGuild);
						 _ -> ok
					 end,

					 %%同名检测
					 IsNameMulty = lists:all(fun(#guild_base{guildName = GuildName}) ->
						 (GuildName =/= NewGuildName) end, table_global:record_list(?TableGuild)),
					 case IsNameMulty of
						 ?TRUE -> ok;
						 _ ->
							 throw(?Guild_ChangeName_SameName)
					 end,

					 ChangeNameTime = time:time_add(Guild#guild_base.changeNameTime, ?SECONDS_PER_DAY * 7),
					 case ChangeNameTime < time:time() of
						 true -> ok;
						 false ->
							 throw(?Guild_ChangeName_CD)
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} ->
										  M;
									  _ ->
										  throw(?Guild_ChangeRank_NoGuild)
								  end,

					 PlayerID = player:getPlayerID(),
					 Member = lists:keyfind(PlayerID, 1, MemberList),
					 Rank = case Member of
								false ->
									throw(?Guild_ChangeName_NotGuildMember);
								{_, Rk, _} ->
									Rk
							end,

					 case Rank >= ?GuildRank_ViceChairman of
						 true -> ok;
						 false ->
							 throw(?Guild_ChangeName_NoPermission)
					 end,

					 %%帮会改名消费改名道具
					 todo,
					 guildPID ! {playerMsgChangeGuildName, self(), PlayerID, GuildID, NewGuildName},
					 ok
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_ChangeGuildNameResult{result = ErrorCode})
				 end end).

%% 改变战盟名字
change_guild_name(GuildId, Name) ->
	?metrics(begin
				 try
					 case Name =:= "" orelse Name =:= [] of
						 ?TRUE -> throw(?ErrorCode_Change_Name_Unvalid);
						 ?FALSE -> ok
					 end,

					 NameLen = string:len(Name),
					 case (NameLen < ?Min_CreatePlayerName_Len) or (NameLen > ?Max_CreatePlayerName_Len * 3) of
						 true -> throw(?ErrorCode_Change_Name_Unvalid);
						 false -> ok
					 end,
					 case df:checkForbidden(Name) of
						 true -> throw(?ErrorCode_Change_Name_Forbidden);
						 false -> ok
					 end,

					 AllGuild = table_global:record_list(?TableGuild),

					 IsNameMulty = lists:all(fun(#guild_base{guildName = GuildName}) ->
						 (GuildName =/= Name) end, AllGuild),
					 case IsNameMulty of
						 ?TRUE -> ok;
						 _ -> throw(?ErrorCode_Change_Name_Exist)
					 end,
					 guildPID ! {playerMsgChangeGuildName, self(), 0, GuildId, Name},
					 ok
				 catch
					 ErrorCode ->
						 ErrorCode
				 end end).

%%解散帮派
dissolve_guild() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} ->
							 throw(?Guild_Dissolve_NoGuild);
						 _ -> ok
					 end,
					 case guild_pub:active_can_exit_guild() of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ErrorCode_Guild_InActivity)
					 end,
					 case guild_knight:check_dissolve_guild(GuildID) of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ErrorCode_Guild_Dissolve)
					 end,
					 PlayerID = player:getPlayerID(),

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 %%成员信息记录
					 MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
					 Rank = case MemberRecord of
								false -> throw(?Guild_Dissolve_NotGuildMember);
								{_, Rk, _} -> Rk
							end,

					 %%判断成员是否有操作的权利
					 case Rank =:= ?GuildRank_Chairman of
						 true -> ok;
						 _ -> throw(?Guild_Dissolve_NoPermission)
					 end,

					 guildPID ! {playerMsgDissolveGuild, PlayerID, GuildID},
					 logdbProc:log_playerAction(?Player_action_DismissGuild, GuildID),
					 player:send(#pk_GS2U_DissolveGuildResult{result = 0})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_DissolveGuildResult{result = ErrorCode})
				 end end).

%%邀请入帮
invite_player(#pk_U2GS_GuildInvite{playerID = TargetPlayerID}) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 {Err, InviteMsg} = check_invite(TargetPlayerID),
					 ?ERROR_CHECK_THROW(Err),
					 m_send:send_msg_2_player_proc(TargetPlayerID, {guild_invite, self(), InviteMsg})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_GuildInviteResult{result = ErrorCode})
				 end end).

%% 邀请检查
check_invite(TargetPlayerID) ->
	try
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		case PlayerID =:= TargetPlayerID of
			true -> throw(?Guild_Invite_SamePlayer);
			false -> ok
		end,
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_Invite_NoGuild);
			_ -> ok
		end,

		GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
							  #guild_member_maps{} = R -> R;
							  _ -> throw(?Guild_ChangeRank_NoGuild)
						  end,

		Member = lists:keyfind(PlayerID, 1, GuildMemberMaps#guild_member_maps.member_list),
		Rank = case Member of
				   false -> throw(?Guild_Invite_NotGuildMember);
				   {_, Rk, _} -> Rk
			   end,

		case Rank =:= ?GuildRank_Chairman orelse Rank =:= ?GuildRank_ViceChairman orelse Rank =:= ?GuildRank_SuperElder of
			true -> ok;
			false -> throw(?Guild_Invite_NoPermission)
		end,

		%% 最大人数限制
		MemberCount = GuildMemberMaps#guild_member_maps.member_total,
		MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
		case MemberCount < MaxMemberCount of
			true -> ok;
			false -> throw(?Guild_Invite_MaxMember)
		end,

		case main:isOnline(TargetPlayerID) of
			?TRUE -> ok;
			?FALSE -> throw(?Guild_Invite_NotOnLine)
		end,

		%%被邀请者是否开启仙盟功能
		GuideList = etsBaseFunc:getRecordField(?ETS_PlayerOnLine, TargetPlayerID, #playerOnLine.funcList),
		case lists:member(13, GuideList) of
			?TRUE -> ok;
			?FALSE -> throw(?Guild_Invite_NoOpenGuild)
		end,

		%%被邀请者是否有帮派
		case table_global:member(?TableGuildMember, TargetPlayerID) of
			#guild_member{guildID = Gid} when Gid > 0 ->
				throw(?Guild_Invite_TargetHasGuild);
			_ -> ok
		end,
		%% 发送邀请消息
		InviteMsg = #pk_GS2U_GuildInviteTip{
			guildID = GuildID,
			guildName = Guild#guild_base.guildName,
			playerID = PlayerID,
			playerName = player:getPlayerProperty(#player.name),
			battleValue = player:getPlayerProperty(#player.battleValue),
			level = player:getLevel(),
			vip = vip:get_vip_lv()
		},
		{?ERROR_OK, InviteMsg}
	catch
		ErrCode -> {ErrCode, {}}
	end.


%% ================================邀请加入战盟花钱清除对方的cd  START========
%% 被邀请加入战盟
on_invited(FromPid, Msg) ->
	?metrics(begin
				 PlayerLevel = player:getLevel(),
				 LimitTime = time:time_add(player:getPlayerProperty(#player.quitGuildTime), ?SECONDS_PER_DAY),
				 {T, C, N} = case (PlayerLevel >= cfg_globalSetup:joinGuildLimit()) andalso (time:time() < LimitTime) of
								 ?TRUE ->
									 ClearSpent = cfg_globalSetup:guildClearTime1(),
									 FreeClearTimes = cfg_globalSetup:guildClearTime2(),
									 ClearTimes = variable_player:get_value(?FixedVariant_Index_56_ClearQuitGuildTimes),
									 case ClearTimes < FreeClearTimes of
										 ?TRUE ->
											 {0, 0, 0};
										 ?FALSE ->
											 SpentGold = ClearSpent * (ClearTimes - FreeClearTimes + 1),
											 {LimitTime, ?CURRENCY_GoldBind, SpentGold}
									 end;
								 _ -> {0, 0, 0}
							 end,
				 case T =:= 0 of
					 ?TRUE -> player:send(Msg);
					 _ ->
						 m_send:send_pid_msg_2_client(FromPid, #pk_GS2U_GuildInviteResult{result = 0, limit_timestamp = T, money_type = C, money = N})
				 end end).
invite_by_money(?FALSE, TargetPlayerID, _) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 {Err, InviteMsg} = check_invite(TargetPlayerID),
					 ?ERROR_CHECK_THROW(Err),
					 m_send:sendMsgToClient(TargetPlayerID, InviteMsg),
					 player:send(#pk_GS2U_GuildInviteByMoneyRet{result = ?ERROR_OK})
				 catch
					 ErrCode ->
						 player:send(#pk_GS2U_GuildInviteByMoneyRet{result = ErrCode})
				 end end);
invite_by_money(_, TargetPlayerID, MoneyCost) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		{Err, InviteMsg} = check_invite(TargetPlayerID),
		?ERROR_CHECK_THROW(Err),
		CostErr = player:delete_cost([], MoneyCost, ?Reason_Guild_InviteClearCd),
		?ERROR_CHECK_THROW(CostErr),
		m_send:send_msg_2_player_proc(TargetPlayerID, {guild_invite_by_money, player:getPlayerID(), InviteMsg, MoneyCost})

	catch
		ErrCode -> player:send(#pk_GS2U_GuildInviteByMoneyRet{result = ErrCode})
	end.
on_invited_by_money(FromPlayerId, Msg, Money) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerLevel = player:getLevel(),
					 LimitTime = time:time_add(player:getPlayerProperty(#player.quitGuildTime), ?SECONDS_PER_DAY),
					 case (PlayerLevel >= cfg_globalSetup:joinGuildLimit()) andalso (time:time() < LimitTime) of
						 ?TRUE ->
							 ClearSpent = cfg_globalSetup:guildClearTime1(),
							 FreeClearTimes = cfg_globalSetup:guildClearTime2(),
							 ClearTimes = variable_player:get_value(?FixedVariant_Index_56_ClearQuitGuildTimes),
							 case ClearTimes < FreeClearTimes of
								 ?TRUE -> ?ErrorCode_Guild_InviteErrState;
								 ?FALSE ->
									 SpentGold = ClearSpent * (ClearTimes - FreeClearTimes + 1),
									 case Money of
										 [{?CURRENCY_GoldBind, SpentGold}] ->
											 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1),
											 player:setPlayerProperty(#player.quitGuildTime, 0),
											 player:send(Msg),
											 m_send:sendMsgToClient(FromPlayerId, #pk_GS2U_GuildInviteByMoneyRet{result = 0});
										 _ ->
											 %%
											 throw(?ErrorCode_Guild_InviteErrState)
									 end
							 end;
						 _ -> ?ErrorCode_Guild_InviteErrState
					 end
				 catch
					 ErrCode ->
						 Language = language:get_player_language(FromPlayerId),
						 mail:send_mail(#mailInfo{
							 player_id = FromPlayerId,
							 title = language:get_server_string("playerbag_full_title", Language),
							 describe = language:get_server_string("playerbag_full_describ", Language),
							 isDirect = 1,
							 coinList = [#coinInfo{type = T, num = C, reason = ?Reason_Guild_InviteClearCdRet} || {T, C} <- Money]
						 }),

						 m_send:sendMsgToClient(FromPlayerId, #pk_GS2U_GuildInviteByMoneyRet{result = ErrCode})
				 end end).

%% ================================邀请加入战盟花钱清除对方的cd  END========


%% 邀I请回复
apply_invite(#pk_U2GS_GuildApplyInvite{isAllow = IsAllow, inviterID = InviterID, guildID = GuildID}) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 case IsAllow of
						 1 ->%%同意
							 case player:getPlayerProperty(#player.guildID) of
								 0 ->
									 ok;
								 _ ->
									 throw(?Guild_ApplyInvite_HasOtherGuild)
							 end,

							 Guild = guild_pub:find_guild(GuildID),
							 case Guild of
								 {} ->
									 throw(?Guild_ApplyInvite_NoGuild);
								 _ ->
									 ok
							 end,

							 GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
												   #guild_member_maps{} = R ->
													   R;
												   _ ->
													   throw(?Guild_ChangeRank_NoGuild)
											   end,

							 Member = lists:keyfind(InviterID, 1, GuildMemberMaps#guild_member_maps.member_list),
							 Rank = case Member of
										false ->
											throw(?Guild_ApplyInvite_NotGuildMember);
										{_, Rk, _} ->
											Rk
									end,
							 case Rank =:= ?GuildRank_Chairman orelse Rank =:= ?GuildRank_ViceChairman orelse Rank =:= ?GuildRank_SuperElder of
								 true ->
									 ok;
								 false ->
									 throw(?Guild_ApplyInvite_NoPermission)
							 end,
							 %%人数检测
							 MemberCount = GuildMemberMaps#guild_member_maps.member_total,
							 MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
							 case MemberCount < MaxMemberCount of
								 true ->
									 ok;
								 false ->
									 throw(?Guild_ApplyInvite_MaxMember)
							 end,

							 %%检查30级及以上玩家是否退过工会，且间隔时间大于24小时.只有大于24小时才能申请
							 PlayerLevel = player:getPlayerProperty(#player.level),
							 case (PlayerLevel >= cfg_globalSetup:joinGuildLimit())
								 andalso (time:time() < time:time_add(player:getPlayerProperty(#player.quitGuildTime), ?SECONDS_PER_DAY)) of
								 true ->
									 ClearSpent = df:getGlobalSetupValue(guildClearTime1, 0),
									 FreeClearTimes = df:getGlobalSetupValue(guildClearTime2, 0),
									 ClearTimes = variable_player:get_value(?FixedVariant_Index_56_ClearQuitGuildTimes),
									 case ClearTimes >= FreeClearTimes of
										 ?FALSE ->
											 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}]),
											 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1);
										 ?TRUE ->
											 SpentGold = ClearSpent * (ClearTimes - FreeClearTimes + 1),
											 CurrencyError = currency:delete(?CURRENCY_GoldBind, SpentGold, ?Gold_Change_ClearQuitGuildTime),
											 ?ERROR_CHECK_THROW(CurrencyError),
											 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, ClearTimes + 1),
											 player:setPlayerPropertyList([{#player.quitGuildTime, 0}, {#player.guildID, 0}])
									 end;
								 false ->
									 ok
							 end,

							 guildPID ! {playerMsgApplyInvite,
								 player:getPlayerID(), {player:getPlayerProperty(#player.name), player:getPlayerProperty(#player.level),
									 player:getPlayerProperty(#player.battleValue), player:getPlayerProperty(#player.sex), player:getPlayerProperty(#player.vip),
									 player:getPlayerProperty(#player.frame_id), player:getPlayerProperty(#player.nationality_id)},
								 GuildID},
							 m_send:sendMsgToClient(InviterID, #pk_GS2U_GuildApplyInviteIsAllow{name = player:getPlayerProperty(#player.name), result = 1});
						 _ ->%%拒绝
							 m_send:sendMsgToClient(InviterID, #pk_GS2U_GuildApplyInviteIsAllow{name = player:getPlayerProperty(#player.name), result = 0})
					 end,
					 player:send(#pk_GS2U_GuildApplyInviteResult{result = ?ERROR_OK})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_GuildApplyInviteResult{result = ErrorCode})
				 end end).

%% 封天祭祀
on_fete_god(FeteID, WantFeteTimes) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} ->
							 throw(?Guild_FeteGod_noGuild);
						 _ ->
							 ok
					 end,

					 Index = case FeteID of
								 6 -> ?VARIABLE_PLAYER_RESET_FeteType1;
								 7 -> ?VARIABLE_PLAYER_RESET_FeteType2;
								 8 -> ?VARIABLE_PLAYER_RESET_FeteType3;
								 _ -> throw(?Guild_FeteGod_wrongType)
							 end,

					 GuildMemberList = case guild_pub:get_guild_member_maps(GuildID) of
										   #guild_member_maps{member_list = M} -> M;
										   _ -> throw(?Guild_ChangeRank_NoGuild)
									   end,
					 case lists:keyfind(player:getPlayerID(), 1, GuildMemberList) of
						 false -> throw(?Guild_FeteGod_noMember);
						 Info -> Info
					 end,

					 FeteCfg = df:getGuildFeteCfg(FeteID),
					 case FeteCfg#guildSacrificeCfg.sacriType =:= ?FeteGod_Type_Fete of
						 ?TRUE -> ok;
						 ?FALSE ->
							 throw(?Guild_FeteGod_wrongType)
					 end,

					 %% 检查是否祭天
					 FeteCount = variable_player:get_value(Index),
					 ValidTimes = min(max(vipFun:callVip(FeteCfg#guildSacrificeCfg.sacrificeTimes, 0) - FeteCount, 0), WantFeteTimes),
					 case ValidTimes =< 0 of
						 ?FALSE -> ok;
						 ?TRUE -> throw(?Guild_FeteGod_hasFeted)
					 end,

					 %% 封天祭祀条件判断
					 CoinList = [{I, N * ValidTimes} || {I, N} <- [FeteCfg#guildSacrificeCfg.needNumber]],
					 ItemList = [{I, N * ValidTimes} || {I, N} <- [FeteCfg#guildSacrificeCfg.needItem]],
					 DeleteError = player:delete_cost(ItemList, CoinList, ?Reason_Guild_FeteGod),
					 ?ERROR_CHECK_THROW(DeleteError),

					 %% 增加仙盟经验
					 ServerDay = main:getServerStartDays(),
					 IntegralList0 = [{Day, Pt} || {Day, Pt} <- FeteCfg#guildSacrificeCfg.integralNew, Day =< ServerDay],
					 Integral = case lists:sort(fun({Day1, _}, {Day2, _}) ->
						 Day1 > Day2 end, IntegralList0) of
									[{_, Pt} | _] -> Pt * ValidTimes;
									_ -> 0
								end,
					 %% 计算任务奖励
					 TaskList = player_task:get_progress_task_list() ++ role_task:get_progress_task_list(),
					 TaskAward = player_task:check_task_item_limit([{ID, Num * WantFeteTimes, Bind, Time} || {T, ID, Num, Bind, Time} <- FeteCfg#guildSacrificeCfg.taskAward, lists:member(T, TaskList)], player_task:on_get_task_item_list()),
					 guildPID ! {playerMsgFeteGod, player:getPlayerID(), GuildID, FeteID, Integral, ValidTimes, TaskAward},

					 %% 祭祀奖励
					 Percent = guild_pub:get_attr_value_by_index(Guild#guild_base.building_list, ?Guild_FeteGodAdd),
					 {_, AwardIndex} = common:getValueByInterval(player:getLevel(), FeteCfg#guildSacrificeCfg.rewardOder, {1, 1}),
					 Career = player:getCareer(),
					 AddValueList = [{I, trunc(N * ValidTimes * Percent / 10000)} || {Idx, Cr, 2, I, N} <- FeteCfg#guildSacrificeCfg.reward, Idx =:= AwardIndex andalso (Cr =:= 0 orelse Cr =:= Career)],
					 ItemAwardList = [{I, N * ValidTimes} || {Idx, Cr, 1, I, N} <- FeteCfg#guildSacrificeCfg.reward, Idx =:= AwardIndex andalso (Cr =:= 0 orelse Cr =:= Career)],
					 player:add_rewards(ItemAwardList ++ TaskAward, AddValueList, ?Reason_Guild_FeteGod),
					 %% 数据记录
					 variable_player:set_value(Index, FeteCount + ValidTimes),
					 FeteGodTimes = variable_player:get_value(?FixedVariant_Index_31_GuildFeteGod),
					 variable_player:set_value(?FixedVariant_Index_31_GuildFeteGod, FeteGodTimes + ValidTimes),

					 %% 公告
					 %%		AnnounceIndex = case FeteID of
					 %%							6 -> ?Variable_Player_reset_announce_1;
					 %%							7 -> ?Variable_Player_reset_announce_2;
					 %%							8 -> ?Variable_Player_reset_announce_3;
					 %%							_ -> 0
					 %%						end,
					 %%		IsAnnounce = variable_player:get_value(?Variable_Player_reset_announce, AnnounceIndex),
					 %%		case FeteCount + ValidTimes >= guild_pub:get_attr_value_by_index(GuildID, AttrIndex) andalso not IsAnnounce of
					 %%			?TRUE ->
					 %%				variable_player:set_value(?Variable_Player_reset_announce, AnnounceIndex, 1),
					 %%				PlayerText = player:getPlayerText(),
					 %%				case FeteID of
					 %%					6 ->
					 %%						guild_pub:send_guild_notice(GuildID, guildNewNotice2,
					 %%							fun(Language) ->
					 %%								language:format(language:get_server_string("GuildNewNotice2", Language),
					 %%									[PlayerText, FeteCount + ValidTimes, GuildMoney * (FeteCount + ValidTimes)])
					 %%							end);
					 %%					7 ->
					 %%						guild_pub:send_guild_notice(GuildID, guildNewNotice3,
					 %%							fun(Language) ->
					 %%								language:format(language:get_server_string("GuildNewNotice3", Language),
					 %%									[PlayerText, FeteCount + ValidTimes, GuildMoney * (FeteCount + ValidTimes)])
					 %%							end);
					 %%					8 ->
					 %%						guild_pub:send_guild_notice(GuildID, guildNewNotice4,
					 %%							fun(Language) ->
					 %%								language:format(language:get_server_string("GuildNewNotice4", Language),
					 %%									[PlayerText, FeteCount + ValidTimes, GuildMoney * (FeteCount + ValidTimes)])
					 %%							end);
					 %%					_ -> ok
					 %%				end;
					 %%			?FALSE -> ok
					 %%		end,
					 %% 相关事件处理
					 [logdbProc:insert_log_GuildScrifice(GuildID, FeteID) || _K <- lists:seq(1, ValidTimes)],
					 player_task:update_task(?Task_Goal_FeteGod, {ValidTimes}),
					 activity_new_player:on_active_condition_change(?SalesActivity_AllFeteGod_179, ValidTimes),
					 case FeteID of
						 6 ->
							 activity_new_player:on_active_condition_change(?SalesActivity_LowFeteGod_172, ValidTimes),
							 attainment:add_attain_progress(?Attainments_Type_GeneralDonationCount, {ValidTimes});
						 7 ->
							 activity_new_player:on_active_condition_change(?SalesActivity_MidFeteGod, ValidTimes),
							 player_task:update_task(?Task_Goal_GuildFeteHigh, {ValidTimes}),
							 attainment:add_attain_progress(?Attainments_Type_HighDonationCount, {ValidTimes});
						 _ -> ok
					 end,
					 daily_task:add_daily_task_goal(?DailyTask_Goal_59, WantFeteTimes, ?DailyTask_CountType_Default),
					 seven_gift:add_task_progress(?Seven_Type_GuildDonation, {WantFeteTimes, FeteID}),
					 on_active_value_access(?DailyTask_Goal_59, WantFeteTimes)
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_FeteGodResult{feteID = FeteID, result = ErrorCode})
				 end end).

%% 领取封天祭祀奖励
on_get_fete_god_award(FeteIdList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_FeteGod_noGuild);
						 _ -> ok
					 end,

					 CfgList = [FeteGodCfg || FeteGodCfg <- [df:getGuildFeteCfg(FeteID) || FeteID <- FeteIdList], FeteGodCfg#guildSacrificeCfg.sacriType =:= ?FeteGod_Type_Award],
					 case CfgList =/= [] of
						 ?TRUE -> ok;
						 ?FALSE ->
							 throw(?Guild_FeteGod_wrongType)
					 end,

					 GuildMemberList = case guild_pub:get_guild_member_maps(GuildID) of
										   #guild_member_maps{member_list = M} -> M;
										   _ -> throw(?Guild_ChangeRank_NoGuild)
									   end,
					 PlayerID = player:getPlayerID(),
					 case lists:keyfind(PlayerID, 1, GuildMemberList) of
						 false -> throw(?Guild_FeteGod_noGuild);
						 _ -> ok
					 end,
					 MemberInfo = case guild_pub:find_guild_member(PlayerID) of
									  #guild_member{guildID = Gid} = Info when Gid > 0 ->
										  Info;
									  _ -> throw(?Guild_FeteGod_noGuild)
								  end,

					 FeteIdList1 = [FeteID || FeteID <- FeteIdList, not lists:member(FeteID, MemberInfo#guild_member.feteList)],
					 case FeteIdList1 =:= [] of
						 ?TRUE -> throw(?Guild_FeteGod_hasGetAward);
						 ?FALSE -> ok
					 end,

					 ValidCfg = [Cfg || #guildSacrificeCfg{iD = ID, needNumber = {_, NeedValue}} = Cfg <- CfgList, Guild#guild_base.feteValue >= NeedValue, lists:member(ID, FeteIdList1)],
					 case ValidCfg =/= [] of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?Guild_FeteGod_noFeteValue)
					 end,
					 ValidFeteIDList = [FeteGodCfg#guildSacrificeCfg.iD || FeteGodCfg <- ValidCfg],
					 Career = player:getCareer(),
					 PlayerLv = player:getLevel(),
					 {AwardsList, ItemAwardList} = lists:foldl(fun(SacCfg, {L1, L2}) ->
						 {_, AwardIndex} = common:getValueByInterval(PlayerLv, SacCfg#guildSacrificeCfg.rewardOder, {1, 1}),
						 CurrList = [{I, N} || {Idx, Cr, 2, I, N} <- SacCfg#guildSacrificeCfg.reward, Idx =:= AwardIndex andalso (Cr =:= 0 orelse Cr =:= Career)],
						 ItemList = [{I, N} || {Idx, Cr, 1, I, N} <- SacCfg#guildSacrificeCfg.reward, Idx =:= AwardIndex andalso (Cr =:= 0 orelse Cr =:= Career)],
						 {CurrList ++ L1, ItemList ++ L2}
															   end, {[], []}, ValidCfg),
					 player:add_rewards(ItemAwardList, AwardsList, ?Reason_Guild_FeteGod),
					 %% 保存数据
					 guildPID ! {playerMsgGetFeteGodAward, player:getPlayerID(), GuildID, ValidFeteIDList}
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_getFeteGodAwardResult{feteIdList = FeteIdList, result = ErrorCode})
				 end end).

%% 升级战盟建筑
up_level_building(BuildingID) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_FeteGod_noGuild);
						 _ -> ok
					 end,
					 Level = case lists:keyfind(BuildingID, 1, Guild#guild_base.building_list) of
								 {_, Lv} -> Lv;
								 _ -> throw(?ErrorCode_Guild_NoGuild)
							 end,
					 Cfg = cfg_guildBuilding:getRow(BuildingID, Level + 1),
					 case Cfg of
						 {} -> throw(?ErrorCode_Guild_MaxLevel);
						 _ -> ok
					 end,
					 LobbyLv = proplists:get_value(?GuildBuilding_Lobby, Guild#guild_base.building_list, 1),
					 case LobbyLv >= Cfg#guildBuildingCfg.hallLv of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ErrorCode_Guild_LobbyLevel)
					 end,
					 Rank = guild_pub:get_member_rank(GuildID, PlayerID),
					 case Rank >= ?GuildRank_ViceChairman of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ErrorCode_Guild_RankEnough)
					 end,
					 Materials = case guild_pub:find_guild(GuildID) of
									 #guild_base{building_materials = M} -> M;
									 _ -> 0
								 end,

					 case Materials >= Cfg#guildBuildingCfg.needItem of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ErrorCode_Guild_MoneyEnough)
					 end,
					 guildPID ! {uplevelBuilding, PlayerID, GuildID, BuildingID},
					 ok
				 catch
					 Result ->
						 player:send(#pk_GS2U_uplevelGuildBuildingResult{buildingID = BuildingID, result = Result})
				 end end).

%% 请求仙盟仓库数据
on_get_guild_bag_data() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 case guild_pub:find_guild(GuildID) of
						 {} ->
							 throw(?Guild_GuildBag_NoGuild);
						 _ ->
							 ok
					 end,
					 EqList = etsBaseFunc:getRecordField(?GuildDepotEts, GuildID, #guildDepot.equip_list, []),
					 EventList0 = lists:keysort(#guildEvent.time, guild_event:get_guild_module_log_list(GuildID, ?EventModule_3)),
					 EventList = lists:sublist(lists:reverse(EventList0), 50),
					 Msg = #pk_GS2U_SendGuildBagData{
						 eq_list = [eq:make_eq_msg(Eq) || Eq <- EqList],
						 event_list = [guild_pub:make_guild_dynamic(R) || R <- EventList]
					 },
					 player:send(Msg)
				 catch
					 _ErrorCode -> player:send(#pk_GS2U_SendGuildBagData{eq_list = []})
				 end end).

%% 返回捐赠道具
get_donate_items(IDList) ->
	Func =
		fun(ItemDBID) ->
			Equip =
				case eq:get_eq(ItemDBID) of
					{} -> throw({ItemDBID, ?ErrorCode_Guild_NotItem});
					Eq -> Eq
				end,
			Item =
				case bag_player:get_item(ItemDBID) of
					{?Success, [IT | _]} -> IT;
					{Err, _} -> throw({ItemDBID, Err})
				end,
			{Item, Equip}
		end,
	lists:map(Func, IDList).

%% 捐献物品
on_donate_item(IDList0) ->
	?metrics(begin
%% 玩家进程 处理捐献物品
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 %% 判断捐献次数 职务等
					 GuildID = player:getPlayerProperty(#player.guildID),
					 case guild_pub:find_guild(GuildID) of
						 {} -> throw(?Guild_GuildBag_NoGuild);
						 _ -> ok
					 end,

					 IDList = lists:usort(IDList0),
					 DonateItems = get_donate_items(IDList),
					 case etsBaseFunc:readRecord(?GuildDepotEts, GuildID) of
						 {} -> ok;
						 Depot ->
							 MaxCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Depot),
							 case length(Depot#guildDepot.equip_list) >= MaxCount of
								 ?TRUE ->
									 throw(?ErrorCode_Guild_DepotFull);
								 ?FALSE ->
									 ok
							 end
					 end,
					 lists:foreach(fun({Item, Equip}) ->
						 case can_donate(Item, Equip) of
							 ?TRUE -> ok;
							 ?FALSE -> throw({Item#item.id, ?ErrorCode_Guild_CanNotDonate})
						 end,
						 case eq:is_eq_wear(Equip#eq.uid) of
							 ?TRUE -> throw({Item#item.id, ?ErrorCode_Guild_HasEquip});
							 ?FALSE -> ok
						 end
								   end, DonateItems),

					 PlayerID = player:getPlayerID(),
					 DecIDList = [Equip#eq.uid || {_Item, Equip} <- DonateItems],
					 bag_player:delete_item(DecIDList, ?Reason_Guild_Donate),
					 guildPID ! {donateGuildItem, GuildID, PlayerID, DonateItems},
					 ok
				 catch
					 {DBID, Code} ->
						 player:send(#pk_GS2U_donateItemResult{itemID = DBID, result = Code});
					 ErrorCode ->
						 player:send(#pk_GS2U_donateItemResult{itemID = 0, result = ErrorCode})
				 end,
				 ok end).

req_donate_value() ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 PlayerID = player:getPlayerID(),
						 Value = case guild_pub:find_guild_member(PlayerID) of
									 #guild_member{guildID = GuildID, donate_integral = V} when GuildID > 0 ->
										 V;
									 _ -> 0
								 end,
						 player:send(#pk_GS2U_donateIntegralRet{value = Value}),
						 ok;
					 ?FALSE ->
						 player:send(#pk_GS2U_donateIntegralRet{})
				 end end).

req_prestige_value(Type) ->
	?metrics(begin
				 case is_func_open() of
					 ?TRUE ->
						 GuildID = player:getPlayerProperty(#player.guildID),
						 PlayerID = player:getPlayerID(),
						 Value = case guild_pub:find_guild_member(PlayerID) of
									 #guild_member{guildID = GuildID, prestige = V, weekly_prestige = WV} when GuildID > 0 ->
										 common:getTernaryValue(Type =:= 1, V, WV);
									 _ -> 0
								 end,
						 player:send(#pk_GS2U_guild_member_prestige_ret{type = Type, value = Value}),
						 ok;
					 ?FALSE ->
						 player:send(#pk_GS2U_guild_member_prestige_ret{type = Type})
				 end end).

can_donate(Item, Equip) ->
	DonateCondition = df:getGlobalSetupValueList(guildWarehouse_condition, []),
	can_donate(Item, Equip, DonateCondition).
can_donate(_Item, _Equip, []) -> ?TRUE;
%% {品质,星数，阶数，是否可以捐绑定，是否可以捐限时装备，是否可以捐强化过的装备，是否可以捐镶嵌了宝石的装备}
can_donate(Item, Equip, [{Character, CharacterMax, Star, Order, Bind, Expire, _Suit, _Gem} | _]) ->
	#equipBaseCfg{order = EquipOrder} = cfg_equipBase:getRow(Item#item.cfg_id),
	Cond0 = EquipOrder >= Order andalso Equip#eq.character >= Character andalso Equip#eq.character =< CharacterMax andalso Equip#eq.star >= Star,
	Cond1 = Item#item.bind =:= 0 orelse Bind =:= 1,
	Cond2 = Item#item.expire_time =:= 0 orelse Expire =:= 1,
	Cond0 andalso Cond1 andalso Cond2.

%% 领取公会仓库的物品
on_get_guild_bag_item(ItemDBID, Num) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 PlayerID = player:getPlayerID(),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_GuildBag_NoGuild);
						 _ -> ok
					 end,
					 CommonItemList = df:getGlobalSetupValueList(guildWarehouse_ChangeItem, []),
					 case lists:keymember(ItemDBID, 1, CommonItemList) of
						 ?TRUE ->
							 exchange_common_item(Guild, ItemDBID, Num),
							 throw(ok);
						 ?FALSE -> ok
					 end,

					 Depot = case etsBaseFunc:readRecord(?GuildDepotEts, GuildID) of
								 {} -> #guildDepot{id = GuildID};
								 D -> D
							 end,
					 Equip =
						 case lists:keyfind(ItemDBID, #eq.uid, Depot#guildDepot.equip_list) of
							 ?FALSE -> throw(?Guild_GuildBag_BagNoItem);
							 E -> E
						 end,
					 Item =
						 case lists:keyfind(ItemDBID, #item.id, Depot#guildDepot.item_list) of
							 ?FALSE -> throw(?Guild_GuildBag_BagNoItem);
							 I -> I
						 end,
					 Member = guild_pub:find_guild_member(PlayerID),
					 ?CHECK_THROW(Member =/= {} andalso Member#guild_member.guildID =:= GuildID, ?Guild_GuildBag_NoMember),
					 NeedIntegral = guild_pub:get_exchange_integral(Item, Equip),
					 case Member#guild_member.donate_integral >= NeedIntegral of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?ErrorCode_Guild_Integral)
					 end,
					 Reply = guild_pub:gen_call({exchange_depot_item, GuildID, PlayerID, Equip, Item}),
					 case Reply of
						 0 ->
							 guildPID ! {add_member_integral, GuildID, PlayerID, -NeedIntegral},
							 eq:add_eq_ins({Item, Equip}, ?Reason_Guild_Exchange),
							 PlayerText = player:getPlayerText(),
							 guild_pub:send_guild_notice(GuildID, guildNewNotice20,
								 fun(Language) ->
									 language:format(language:get_server_string("GuildNewNotice20", Language),
										 [PlayerText, 1, richText:getItemText({Item, Equip}, Language)])
								 end);
						 _ -> throw(Reply)
					 end,
					 player:send(#pk_GS2U_changeItemResult{id = ItemDBID, result = 0}),
					 ok
				 catch
					 ok -> ok;
					 ErrorCode ->
						 player:send(#pk_GS2U_changeItemResult{id = ItemDBID, result = ErrorCode})
				 end end).
%% 兑换公共道具
exchange_common_item(Guild, ID, Num) ->
	try
		CommonItemList = df:getGlobalSetupValueList(guildWarehouse_ChangeItem, []),
		{_, NeedIntegral, Times} = lists:keyfind(ID, 1, CommonItemList),
		CurTimes = variable_player:get_value(?Variant_Index_9_GuildDepot_ExchangeTimes),
		case CurTimes + Num > Times of
			?TRUE -> throw(?ErrorCode_Guild_ExchangedMax);
			?FALSE -> ok
		end,
		PlayerID = player:getPlayerID(),
		Member = guild_pub:find_guild_member(PlayerID),
		?CHECK_THROW(Member =/= {} andalso Member#guild_member.guildID =:= Guild#guild_base.id, ?Guild_GuildBag_NoMember),
		case Member#guild_member.donate_integral >= NeedIntegral * Num of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Guild_Integral)
		end,

		guildPID ! {add_member_integral, Guild#guild_base.id, player:getPlayerID(), -NeedIntegral * Num},
		variable_player:set_value(?Variant_Index_9_GuildDepot_ExchangeTimes, CurTimes + Num),
		bag_player:add([{ID, Num}], ?Reason_Guild_Exchange),
		#itemCfg{character = Character} = df:getItemDefineCfg(ID),
		guild_event:add_guild_event(Guild#guild_base.id, ?EventModule_3, 2, player:getPlayerID(), [0, ID, Character, Num]),
		PlayerText = player:getPlayerText(),
		guild_pub:send_guild_notice(Guild#guild_base.id, guildNewNotice20,
			fun(Language) ->
				language:format(language:get_server_string("GuildNewNotice20", Language),
					[PlayerText, Num, richText:getItemText(ID, Language)])
			end),
		player:send(#pk_GS2U_changeItemResult{id = ID, result = 0}),
		ok
	catch
		ErrorCode -> player:send(#pk_GS2U_changeItemResult{id = ID, result = ErrorCode})
	end.

%% 删除仓库物品
on_delete_guild_bag_item(IDList) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_GuildBag_NoGuild);
						 _ -> ok
					 end,
					 PlayerID = player:getPlayerID(),
					 MemberList = guild_pub:get_guild_member_list(GuildID),
					 {_, Rank} =
						 case lists:keyfind(PlayerID, 1, MemberList) of
							 false -> throw(?Guild_GuildBag_NoMember);
							 R0 -> R0
						 end,
					 case Rank >= ?GuildRank_ViceChairman of
						 ?FALSE -> throw(?Guild_GuildBag_NoPermission);
						 ?TRUE -> ok
					 end,
					 Depot = etsBaseFunc:readRecord(?GuildDepotEts, GuildID),
					 case Depot of
						 {} -> throw(?ErrorCode_Guild_DepotEmpty);
						 R -> R
					 end,
					 lists:foreach(
						 fun(ID) ->
							 Item = lists:keyfind(ID, #item.id, Depot#guildDepot.item_list),
							 Equip = lists:keyfind(ID, #eq.uid, Depot#guildDepot.equip_list),
							 case Item =/= ?FALSE andalso Equip =/= ?FALSE of
								 ?TRUE -> ok;
								 ?FALSE -> throw({ID, ?ErrorCode_Guild_NotExist})
							 end
						 end, IDList),

					 guildPID ! {playerMsgDeleteGuildItem, PlayerID, GuildID, IDList}
				 catch
					 {DBID, ErrorCode} ->
						 player:send(#pk_GS2U_deleteFromGuildBagResult{saleID = DBID, result = ErrorCode});
					 ErrorCode ->
						 player:send(#pk_GS2U_deleteFromGuildBagResult{saleID = 0, result = ErrorCode})
				 end end).
depot_auto_clear_set(Enable, Chara, Star, Order) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_GuildBag_NoGuild);
						 _ -> ok
					 end,
					 MemberList = guild_pub:get_guild_member_list(GuildID),
					 PlayerID = player:getPlayerID(),
					 {_, Rank} =
						 case lists:keyfind(PlayerID, 1, MemberList) of
							 false -> throw(?Guild_GuildBag_NoMember);
							 R0 -> R0
						 end,
					 case Rank >= ?GuildRank_ViceChairman of
						 ?FALSE -> throw(?Guild_GuildBag_NoPermission);
						 ?TRUE -> ok
					 end,
					 guild:send_2_me({depot_auto_clear_set, {PlayerID, GuildID, Enable, Chara, Star, Order}})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_GuildDepotAutoClearSet{err_code = ErrorCode})
				 end end).

%%上线，帮派相关处理
on_player_online() ->
	?metrics(begin
%%给帮派发送成员上线
				 GuildID = player:getPlayerProperty(#player.guildID),
				 case GuildID of
					 0 ->
						 %% 检查玩家是否有公会ID(下线之后被同意加入)
						 PlayerID = player:getPlayerID(),
						 PlayerGuildID = guild_pub:get_player_guild_id(PlayerID),
						 case PlayerGuildID =/= 0 of
							 ?TRUE ->
								 guildPID ! {playerMsgGuildMemberOnLine, GuildID, player:getPlayerID(), player:getPlayerProperty(#player.level)},
								 logdbProc:log_playerAction(?Player_Action_EnterGuild, PlayerGuildID),
								 player:setPlayerGuildID(PlayerGuildID);
							 ?FALSE -> ok
						 end;
					 _ ->
						 guildPID ! {playerMsgGuildMemberOnLine, GuildID, player:getPlayerID(), player:getPlayerProperty(#player.level)},
						 attainment:check_attainment(?Attainments_Type_JoinGuild, {1, 0, 0, 0, 0}),
						 player_task:refresh_task(?Task_Goal_JoinGuild)
				 end,
				 sync_depot_setting() end).

%% 玩家领取公会工资
on_get_guild_salary() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 case GuildID =:= 0 of
						 ?TRUE -> throw(?Guild_Salary_NoGuild);
						 ?FALSE -> ok
					 end,

					 case variable_player:get_value(?Variable_Player_GuildDailyItem) =:= 1 of
						 ?TRUE -> throw(?Guild_Salary_NoSalary);
						 ?FALSE -> ok
					 end,
					 RewardList = df:getGlobalSetupValueList(guild_dayPay, []),
					 ItemList = [{Id, Num} || {1, Id, Num} <- RewardList],
					 CurrencyList = [{Id1, Num1} || {2, Id1, Num1} <- RewardList],
					 variable_player:set_value(?Variable_Player_GuildDailyItem, 1),
					 bag_player:add(ItemList, ?Reason_Guild_DailyItem),
					 currency:add(CurrencyList, ?Reason_Guild_DailyItem),
					 player_item:show_get_item_dialog(ItemList, CurrencyList, [], 0),
					 player:send(#pk_GS2U_getGuildSalaryResult{result = 0})
				 catch
					 ErrorCode -> player:send(#pk_GS2U_getGuildSalaryResult{result = ErrorCode})
				 end end).

%% 玩家取消申请加入帮派
on_cancel_join_guild(GuildID) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_Join_NoGuild);
						 _ -> ok
					 end,
					 AppList = Guild#guild_base.applicantList,
					 PlayerID = player:getPlayerID(),
					 ApplicantData = lists:keyfind(PlayerID, #guildApplicant.playerID, AppList),
					 case ApplicantData of
						 false -> throw(?Guild_OperateApplicant_NoApplicant);
						 _ -> ok
					 end,
					 guildPID ! {playerMsgCancelJoinGuild, GuildID, PlayerID}
				 catch
					 Result ->
						 player:send(#pk_GS2U_CancelJoinGuildResult{guildID = GuildID, result = Result})
				 end end).

%% 设置自动通过条件
on_set_enter_condition(Type, Value) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_EnterCondition_NoGuild);
						 _ -> ok
					 end,
					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 Rank =
						 case lists:keyfind(player:getPlayerID(), 1, MemberList) of
							 false -> throw(?Guild_EnterCondition_NoMember);
							 {_, R, _} -> R
						 end,
					 case Rank >= ?GuildRank_ViceChairman of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?Guild_EnterCondition_NoPermission)
					 end,

					 guildPID ! {playerMsgEnterCondition, GuildID, player:getPlayerID(), Type, Value},
					 todo
				 catch
					 Result ->
						 player:send(#pk_GS2U_addGuildConditionResult{type = Type, value = Value, result = Result})
				 end end).

%% 设置是否自动加入
on_set_auto_join(AutoJoin) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_EnterCondition_NoGuild);
						 _ -> ok
					 end,

					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_EnterCondition_NoGuild)
								  end,
					 Rank =
						 case lists:keyfind(player:getPlayerID(), 1, MemberList) of
							 false -> throw(?Guild_EnterCondition_NoMember);
							 {_, R, _} -> R
						 end,
					 case Rank >= ?GuildRank_ViceChairman of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?Guild_EnterCondition_NoPermission)
					 end,

					 guildPID ! {playerMsgSetAutoJoin, GuildID, player:getPlayerID(), AutoJoin}
				 catch
					 Result ->
						 player:send(#pk_GS2U_setAutoJoinGuildResult{autoJoin = AutoJoin, result = Result})
				 end end).

%% 捐献仙盟基金
on_donate_guild_money(Times) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_Error_NoGuild);
						 _ -> ok
					 end,
					 case Times > 0 of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?Guild_Error_NoTimes)
					 end,
					 MemberList = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,
					 Rank =
						 case lists:keyfind(player:getPlayerID(), 1, MemberList) of
							 false -> throw(?Guild_Error_NoMember);
							 {_, R, _} -> R
						 end,
					 case Rank >= ?GuildRank_Elder of
						 ?TRUE -> ok;
						 ?FALSE -> throw(?Guild_EnterCondition_NoPermission)
					 end,

					 SpentGold = df:getGlobalSetupValue(guildMoneyNum1, 0),
					 GuildMoney = df:getGlobalSetupValue(guildMoneyNum2, 0),
					 CurrencyError = currency:delete(?CURRENCY_GoldBind, SpentGold * Times, ?Gold_Change_DonateGuildMoney),
					 ?ERROR_CHECK_THROW(CurrencyError),
					 guildPID ! {changeGuildMoney, GuildID, GuildMoney * Times},
					 guildPID ! {addGuildMoneyLog, GuildID, player:getPlayerID(), Times, GuildMoney * Times, time:time()},
					 player:send(#pk_GS2U_donateGuildMoneyResult{times = Times, result = 0})
				 catch
					 Result ->
						 player:send(#pk_GS2U_donateGuildMoneyResult{times = Times, result = Result})
				 end end).

%%add_count(Type) ->
%%	case Type of
%%		6 -> variable_player:set_value(?VARIABLE_PLAYER_jisi1, variable_player:get_value(?VARIABLE_PLAYER_jisi1) + 1);
%%		7 -> variable_player:set_value(?VARIABLE_PLAYER_jisi2, variable_player:get_value(?VARIABLE_PLAYER_jisi2) + 1);
%%		8 -> variable_player:set_value(?VARIABLE_PLAYER_jisi3, variable_player:get_value(?VARIABLE_PLAYER_jisi3) + 1);
%%		_ -> skip
%%	end.
%%get_type_count(T) ->
%%	case T of
%%		1 ->
%%			variable_player:get_value(?VARIABLE_PLAYER_jisi1) + variable_player:get_value(?VARIABLE_PLAYER_jisi2) + variable_player:get_value(?VARIABLE_PLAYER_jisi3);
%%		2 -> variable_player:get_value(?VARIABLE_PLAYER_jisi2) + variable_player:get_value(?VARIABLE_PLAYER_jisi3);
%%		3 -> variable_player:get_value(?VARIABLE_PLAYER_jisi3);
%%		_ -> 0
%%	end.

%%
on_get_money_log_list() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_Error_NoGuild);
						 _ -> ok
					 end,
					 Func = fun({PlayerID, Times, Money, Time}) ->
						 #pk_guildMoneyLog{
							 playerID = PlayerID,
							 playerName = mirror_player:get_player_element(PlayerID, #player.name),
							 donateTimes = Times,
							 addMoney = Money,
							 donateTime = Time
						 }
							end,
					 List = lists:map(Func, Guild#guild_base.moneyLog_list),
					 player:send(#pk_GS2U_sendGuildMoneyLogList{log_list = List})
				 catch
					 _Why -> player:send(#pk_GS2U_sendGuildMoneyLogList{log_list = []})
				 end end).

on_get_guild_money() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 case Guild of
						 {} -> throw(?Guild_Error_NoGuild);
						 _ -> ok
					 end,
					 player:send(#pk_GS2U_sendGuildMoney{guildMoney = Guild#guild_base.guildMoney}),
					 todo
				 catch
					 _Code -> player:send(#pk_GS2U_sendGuildMoney{guildMoney = 0})
				 end end).

show_demons_eq(UID) ->
	?metrics(begin
				 case etsBaseFunc:readRecord(?GuildDepotShowEqEts, UID) of
					 {} ->
						 Msg = #pk_GS2U_ShowEqInfoRet{err_code = ?ErrorCode_Eq_NotExist, eq_uid = UID};
					 Info ->
						 Msg = #pk_GS2U_ShowEqInfoRet{err_code = 0, eq_uid = UID, eq_info = eq:make_eq_msg(Info#depotShowEq.eq)}
				 end,
				 player:send(Msg) end).

%%下线，帮派相关处理
on_player_offline(PlayerID) ->
	?metrics(begin
%%给帮派发送成员下线
				 GuildID = player:getPlayerProperty(#player.guildID),
				 case GuildID of
					 0 -> ok;
					 _ -> guildPID ! {playerMsgGuildMemberOffLine, GuildID, PlayerID}
				 end end).

%% 更新玩家变量
change_player_property(ChangeList) ->
	?metrics(begin
				 ChangeFunc = fun({Index, Value}) ->
					 case Index of
						 #player.guildID ->
							 OldGuildID = player:getPlayerProperty(#player.guildID),
							 player:setPlayerGuildID(Value),
							 case Value =:= 0 of
								 ?TRUE ->
									 logdbProc:log_playerAction(?Player_Action_QuitGuild, OldGuildID);
								 ?FALSE ->
									 logdbProc:log_playerAction(?Player_Action_EnterGuild, Value)
							 end,

							 ok;
						 #player.quitGuildTime ->
							 case Value > 0 of
								 ?TRUE ->
									 variable_player:set_value(?Variant_Index_51_TodayIsQuitGuild, 1);
								 ?FALSE -> ok
							 end,
							 case variable_player:get_value(?FixedVariant_Index_65_ClearStartTime) =:= 0 andalso Value > 0 of
								 ?TRUE ->
									 variable_player:set_value(?FixedVariant_Index_65_ClearStartTime, Value);
								 ?FALSE -> ok
							 end,
							 %% 30级以下的退出仙盟可以马上申请新的仙盟
							 case player:getLevel() >= df:getGlobalSetupValue(joinGuildLimit, 30) of
								 ?FALSE -> ok;
								 ?TRUE ->
									 player:setPlayerProperty(Index, Value),
									 etsBaseFunc:changeFiled(?ETS_PlayerOnLine, player:getPlayerID(), #playerOnLine.quitGuildTime, Value)
							 end;
						 _ ->
							 player:setPlayerProperty(Index, Value)
					 end
							  end,
				 lists:foreach(ChangeFunc, ChangeList),
				 ok end).

%% 玩家加入公会回调
on_player_join_guild() ->
	SendContent = io_lib:format("<%@)!#!$>Guild_Join_Notice", []),
	chat:onPlayerSendUnlimited(?Chat_Channel_Guild, 0, SendContent),
	ok.

on_tick(TimesTamp) ->
	?metrics(begin
				 ClearStartTime = variable_player:get_value(?FixedVariant_Index_65_ClearStartTime),
				 case ClearStartTime =/= 0 of
					 ?FALSE -> ok;
					 ?TRUE ->
						 case time:time_add(TimesTamp, - ?WeekTick_Seconds) >= ClearStartTime of
							 ?TRUE ->
								 variable_player:set_value(?FixedVariant_Index_56_ClearQuitGuildTimes, 0),
								 variable_player:set_value(?FixedVariant_Index_65_ClearStartTime, 0);
							 ?FALSE -> ok
						 end
				 end,
				 ok end).

%% 获取玩家的帮派等级
get_player_guild_level() ->
	?metrics(begin
				 GuildID = player:getPlayerProperty(#player.guildID),
				 case guild_pub:find_guild(GuildID) of
					 #guild_base{building_list = Building} ->
						 proplists:get_value(?GuildBuilding_Lobby, Building, 1);
					 _ -> 0
				 end end).

sync_depot_setting() ->
	GuildId = player:getPlayerProperty(#player.guildID),
	case guild_pub:find_guild(GuildId) of
		[#guild_base{depot_clear_flag = Flag}] ->
			case lists:keyfind(player:getPlayerID(), 1, guild_pub:get_guild_member_list(GuildId)) of
				{_, Rank} when Rank >= ?GuildRank_ViceChairman ->
					<<Enable:8, Chara:8, Star:8, Order:8>> = <<Flag:32>>,
					Msg = #pk_GS2U_GuildDepotAutoClearStateSync{
						enable = common:int_to_bool(Enable),
						chara = Chara, star = Star, order = Order
					},
					player:send(Msg);
				_ -> skip
			end;
		_ -> skip
	end.

%% 弹劾
guild_impeach() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildId = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildId),
					 ?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
					 #guild_base{chairmanPlayerID = MasterId} = Guild,
					 MemberList = case guild_pub:get_guild_member_maps(GuildId) of
									  #guild_member_maps{member_list = M} -> M;
									  _ -> throw(?ErrorCode_Guild_NoGuild)
								  end,
					 PlayerId = player:getPlayerID(),
					 Rank = case lists:keyfind(PlayerId, 1, MemberList) of
								false -> throw(?Guild_OperateApplicant_NoMember);
								{_, Rk, _} -> Rk
							end,

					 case Rank of
						 ?GuildRank_Chairman -> throw(?ErrorCode_Guild_ImpeachFail);
						 ?GuildRank_SuperElder -> skip;
						 ?GuildRank_ViceChairman -> skip;
						 _ -> throw(?ErrorCode_Guild_ImpeachFail)
					 end,

					 case main:isOnline(MasterId) of
						 ?TRUE -> throw(?ErrorCode_Guild_ImpeachFail);
						 _ -> skip
					 end,

					 #guild_member{lastOffTime = LastOfflineTime} = guild_pub:find_guild_member(MasterId),
					 case time:time_offset(LastOfflineTime, time:time()) >= 86400 of
						 ?TRUE -> skip;
						 _ -> throw(?ErrorCode_Guild_ImpeachFail)
					 end,
					 CostErr = player:delete_cost(df:getGlobalSetupValueList(guild_TanheSpend, [{2, 0, 2000}]), ?Reason_Guild_Impeach),
					 ?ERROR_CHECK_THROW(CostErr),
					 guild:send_2_me({impeach, PlayerId, GuildId})
				 catch
					 ErrCode -> player:send(#pk_GS2U_GuildImpeachRet{err_code = ErrCode})
				 end end).

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Guild) =:= 1 andalso guide:is_open_action(?OpenAction_guild).

%% 分配宝箱
on_assign_treasure_chest(MPlayerIDList) ->
	?metrics(begin
				 try
					 ?ERROR_CHECK_THROW(player:check_func_open(?WorldVariant_Switch_TreasureChest, ?OpenAction_TreasureChest)),
					 GuildId = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildId),
					 ?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
					 PlayerID = player:getPlayerID(),
					 Rank = guild_pub:get_member_rank(GuildId, PlayerID),
					 ?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
					 PlayerIDList = lists:usort(MPlayerIDList),
					 ?CHECK_THROW(PlayerIDList =/= [], ?ErrorCode_Guild_ChestNum),
					 CanUseNum = guild_pub:get_guild_usable_chest(Guild),
					 ?CHECK_THROW(CanUseNum >= length(PlayerIDList), ?ErrorCode_Guild_ChestNum),
					 guild:send_2_me({assign_treasure_chest, GuildId, PlayerID, PlayerIDList})
				 catch
					 Err ->
						 player:send(#pk_GS2U_assign_treasure_chest_ret{err_code = Err})
				 end end).
on_assign_guild_award(?AssignAwardTypeGuildInsZones = Type, AssignPlayerID, ItemID) ->
	?metrics(begin
				 try
					 GuildId = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildId),
					 ?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
					 PlayerID = player:getPlayerID(),
					 Rank = guild_pub:get_member_rank(GuildId, PlayerID),
					 ?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
					 case guild_pub:find_guild_member(AssignPlayerID) of
						 #guild_member{guildID = GuildId} -> ok;
						 _ -> throw(?Guild_Error_NoMember)
					 end,
					 guild:send_2_me({assign_guild_award, Type, GuildId, PlayerID, AssignPlayerID, ItemID})
				 catch
					 Err ->
						 player:send(#pk_GS2U_guild_assign_award_to_ret{type = Type, item_id = ItemID, player_id = AssignPlayerID, err_code = Err})
				 end end).

%% 设置自动分配宝箱规则
on_assign_treasure_rule_set(Rule) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
					 ?CHECK_THROW(Guild#guild_base.treasure_assign_rule =/= Rule, ?ERROR_OK),
					 PlayerID = player:getPlayerID(),
					 Rank = guild_pub:get_member_rank(GuildID, PlayerID),
					 ?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
					 guild:send_2_me({assign_treasure_rule_set, {PlayerID, GuildID, Rule}})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_assign_treasure_rule_set_ret{rule = Rule, err_code = ErrorCode})
				 end end).

on_assign_award_rule_set(?AssignAwardTypeGuildInsZones = Type, Rule) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		GuildID = player:getPlayerProperty(#player.guildID),
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		?CHECK_THROW(Guild#guild_base.guild_ins_zones_assign_rule =/= Rule, ?ERROR_OK),
		PlayerID = player:getPlayerID(),
		Rank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
		guild:send_2_me({assign_award_rule_set, {PlayerID, GuildID, Type, Rule}})
	catch
		ErrorCode ->
			player:send(#pk_GS2U_guild_assign_award_rule_set_ret{type = Type, rule = Rule, err_code = ErrorCode})
	end;
on_assign_award_rule_set(Type, Rule) ->
	player:send(#pk_GS2U_guild_assign_award_rule_set_ret{type = Type, rule = Rule, err_code = ?ERROR_Param}).


%% 领取声望工资
on_get_prestige_salary() ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
					 PlayerID = player:getPlayerID(),
					 case guild_pub:find_guild_member(PlayerID) of
						 #guild_member{guildID = GuildID, state_mark = Mark} when GuildID > 0 ->
							 ?CHECK_THROW(not variant:isBitOn(Mark, ?StateContributeSalary), ?ErrorCode_Guild_PrestigeSalary);
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,
					 guild:send_2_me({get_prestige_salary, {PlayerID, GuildID}})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_get_prestige_salary_ret{err_code = ErrorCode})
				 end end).

%% 获取宝箱分配记录
on_get_assign_treasure_event() ->
	?metrics(begin
				 try
					 ?ERROR_CHECK_THROW(player:check_func_open(?WorldVariant_Switch_TreasureChest, ?OpenAction_TreasureChest)),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 ?CHECK_THROW(guild_pub:find_guild(GuildID) =/= {}, ?ErrorCode_Guild_NoGuild),
					 EventList0 = lists:keysort(#guildEvent.time, guild_event:get_guild_module_log_list(GuildID, ?EventModule_4)),
					 EventList = lists:sublist(lists:reverse(EventList0), 50),
					 Msg = #pk_GS2U_assign_treasure_event_ret{
						 event_list = [guild_pub:make_guild_dynamic(R) || R <- EventList]
					 },
					 player:send(Msg)
				 catch
					 _ErrorCode -> player:send(#pk_GS2U_assign_treasure_event_ret{})
				 end end).

%% 战争工坊信息
on_chariot_info_req() ->
	?metrics(begin
				 GuildID = player:getPlayerProperty(#player.guildID),
				 ChariotInfo = case table_global:lookup(?TableGuildChariot, GuildID) of
								   [] ->
									   #chariot_info{guild_id = GuildID};
								   [R] -> R
							   end,
				 player:send(#pk_GS2U_guild_workshop_info_ret{list = guild_workshop:make_chariot_msg(ChariotInfo)}) end).

%% 战争科技信息
on_guild_science_info_req() ->
	?metrics(begin
				 GuildID = player:getPlayerProperty(#player.guildID),
				 case guild_pub:find_guild(GuildID) of
					 {} -> player:send(#pk_GS2U_guild_science_info_ret{});
					 GuildInfo ->
						 player:send(#pk_GS2U_guild_science_info_ret{list = [#pk_key_value{key = K, value = V} ||
							 {K, V} <- GuildInfo#guild_base.chariot_science_list]})
				 end end).

%% 升级战争科技
on_guild_science_update(ID) ->
	?metrics(begin
				 try
					 GuildID = player:getPlayerProperty(#player.guildID),
					 GuildInfo = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(GuildInfo =/= {}, ?ErrorCode_Guild_NoGuild),
					 #guild_base{chariot_science_list = ScList, guildMoney = GuildMoney} = GuildInfo,


					 ?CHECK_THROW(lists:member(ID, guild_pub:get_attr_value_list_by_index(GuildInfo#guild_base.building_list, ?Guild_ChariotScience)), ?ErrorCode_Guild_Science_Lock),
					 Lv = case lists:keyfind(ID, 1, ScList) of
							  ?FALSE -> 0;
							  {_, V} -> V
						  end,
					 Cfg = cfg_chariotscience:getRow(ID, Lv),
					 ?CHECK_THROW(Cfg =/= {}, ?ERROR_Cfg),
					 #chariotscienceCfg{needs = Needs} = Cfg,
					 ScienceLv = proplists:get_value(?GuildBuilding_Tec, GuildInfo#guild_base.building_list, 1),
					 LvCfg = cfg_chariotLevel:getRow(ID, ScienceLv),
					 ?CHECK_THROW(LvCfg =/= {}, ?ERROR_Cfg),
					 #chariotLevelCfg{gradeInterval = {_, MaxLv}} = LvCfg,
					 ?CHECK_THROW(Lv + 1 =< MaxLv, ?ErrorCode_Guild_Science_Lock),
					 ?CHECK_THROW(Needs > 0, ?ErrorCode_Guild_ScienceMaxLevel),
					 ?CHECK_THROW(GuildMoney >= Needs, ?ErrorCode_Guild_MoneyEnough),
					 guild:send_2_me({guild_science_update, player:getPlayerID(), GuildID, ID})
				 catch
					 Err ->
						 player:send(#pk_GS2U_guild_science_up_ret{id = ID, error = Err})
				 end end).

%% 造战车
on_build_chariot(MaybeToBuildList) ->
	?metrics(begin
				 try
					 GuildID = player:getPlayerProperty(#player.guildID),
					 GuildInfo = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(GuildInfo =/= {}, ?ErrorCode_Guild_NoGuild),
					 ToBuildList = [R || {Type, N} = R <- MaybeToBuildList, N > 0 andalso guild_pub:is_chariot_unlock(Type, GuildInfo#guild_base.chariot_science_list)],
					 ?CHECK_THROW(ToBuildList =/= [], ?ErrorCode_Guild_No_Chariot_Build),
					 BuildNum = lists:sum([N || {_, N} <- ToBuildList]),
					 ?CHECK_THROW(BuildNum > 0, ?ErrorCode_Guild_No_Chariot_Build),
					 #chariot_info{own_list = OwnList, build_list = BuildList, queue_list = QueueList} = case table_global:lookup(?TableGuildChariot, GuildID) of
																											 [] ->
																												 #chariot_info{guild_id = GuildID};
																											 [R] ->
																												 R
																										 end,
					 ?CHECK_THROW(length(OwnList) + length(BuildList) + length(QueueList) + BuildNum < guild_pub:get_attr_value_by_index(GuildInfo#guild_base.building_list, ?Guild_ChariotNum), ?ErrorCode_Guild_No_Chariot_Full),
					 guild_workshop:send_2_me({build_chariot, player:getPlayerID(), GuildID, ToBuildList})
				 catch
					 Err ->
						 player:send(#pk_GS2U_guild_chariot_build_ret{error = Err})
				 end end).

%% 取消/回收战车
on_chariot_cancel(ID) ->
	?metrics(begin
				 try
					 GuildID = player:getPlayerProperty(#player.guildID),
					 GuildInfo = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(GuildInfo =/= {}, ?ErrorCode_Guild_NoGuild),
					 case table_global:lookup(?TableGuildChariot, GuildID) of
						 [] ->
							 throw(?ErrorCode_Guild_No_Chariot);
						 [#chariot_info{own_list = OwnList, build_list = BuildList, queue_list = QueueList}] ->
							 ?CHECK_THROW(lists:keymember(ID, 1, OwnList) orelse lists:keymember(ID, 1, BuildList) orelse lists:keymember(ID, 1, QueueList), ?ErrorCode_Guild_No_Chariot)
					 end,
					 guild_workshop:send_2_me({cancel_chariot, player:getPlayerID(), GuildID, ID})
				 catch
					 Err ->
						 player:send(#pk_GS2U_guild_chariot_build_cancel_ret{cancel_id = ID, error = Err})
				 end end).

on_chariot_use_rule_set(NewRule) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
					 GuildID = player:getPlayerProperty(#player.guildID),
					 Guild = guild_pub:find_guild(GuildID),
					 ?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
					 ?CHECK_THROW(NewRule =< 63, ?ERROR_Param),
					 ?CHECK_THROW(Guild#guild_base.chariot_use_rule =/= NewRule, ?ERROR_OK),
					 PlayerID = player:getPlayerID(),
					 Rank = guild_pub:get_member_rank(GuildID, PlayerID),
					 ?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
					 guild:send_2_me({chariot_use_rule_set, {PlayerID, GuildID, NewRule}})
				 catch
					 ErrorCode ->
						 player:send(#pk_GS2U_chariot_use_rule_ret{value = NewRule, err_code = ErrorCode})
				 end end).

on_active_value_access(ID, Times) ->
	PlayerID = player:getPlayerID(),
	case guild_pub:find_guild_member(PlayerID) of
		#guild_member{guildID = GuildID, active_value_access = AccessList} when GuildID > 0 ->
			#guildActivityCfg{access = List} = cfg_guildActivity:first_row(),
			HasTime = case lists:keyfind(ID, 1, AccessList) of
						  ?FALSE -> 0;
						  {_, T} -> T
					  end,
			case lists:keyfind(ID, 1, List) of
				{_, _, MaxTime} when HasTime < MaxTime ->
					AddTimes = min(Times, MaxTime - HasTime),
					guild:send_2_me({add_member_active_access, PlayerID, self(), ID, AddTimes});
				_ -> ok
			end;
		_ -> ok
	end.

on_active_value_access_ex(PlayerID, ID, Times) ->
	main:sendMsgToPlayerProcess(PlayerID, {active_value_access, ID, Times}).

on_assign_award_list_req(Type) ->
	GuildID = player:getPlayerProperty(#player.guildID),
	List = case table_global:lookup(?TableGuildAssignAward, {GuildID, Type}) of
			   [] -> [];
			   [Info] -> Info#guild_assign_award.list
		   end,
	player:send(#pk_GS2U_guild_assign_award_list_ret{type = Type, list = lists:map(fun make_assign_award_item_msg/1, List)}).

make_assign_award_item_msg(#guild_assign_award_item{item_id = P1, source_from = P2, is_assign = P3, belong_player_name = P4}) ->
	#pk_guild_assign_award_item{
		item_id = P1,
		source_from = P2,
		is_assign = P3,
		belong_name = P4
	}.

on_assign_award_log_req(Type) ->
	GuildID = player:getPlayerProperty(#player.guildID),
	List = case table_global:lookup(?TableGuildAssignAward, {GuildID, Type}) of
			   [] -> [];
			   [Info] -> Info#guild_assign_award.log_list
		   end,
	player:send(#pk_GS2U_guild_assign_award_log_ret{type = Type, list = lists:map(fun make_assign_award_log_msg/1, List)}).

make_assign_award_log_msg({Type, Name, ItemID, ToName, Time}) ->
	#pk_guild_assign_award_log{
		type = Type,
		name = Name,
		item_id = ItemID,
		to_name = ToName,
		time = Time
	}.

get_active_value() ->
	#guildActivityCfg{access = AccessCfg} = cfg_guildActivity:first_row(),
	PlayerId = player:getPlayerID(),
	case guild_pub:find_guild_member(PlayerId) of
		#guild_member{active_value_access = AccessList} ->
			guild_pub:calc_active_value(AccessList, AccessCfg, 0);
		_ -> ok
	end.