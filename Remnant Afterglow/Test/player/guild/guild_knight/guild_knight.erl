%%%-------------------------------------------------------------------
%%% @author suw
%%% @copyright (C) 2022, DoubleGame
%%% @doc
%%%		公会骑士团
%%% @end
%%% Created : 31. 3月 2022 11:30
%%%-------------------------------------------------------------------
-module(guild_knight).
-author("suw").
-behaviour(gen_server).

%% API
-export([start_link/0, cast_run/1, send_2_me/1, get_topN/0, list_to_record/1, record_to_list/1, check_dissolve_guild/1, get_guild_rank/0]).
-export([get_data/0]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-include("global.hrl").
-include("guild.hrl").
-include("record.hrl").
-include("reason.hrl").
-include("cfg_guildKnightsBase.hrl").
-include("cfg_title.hrl").
-include("cfg_guildKnightsTitle.hrl").
-include("guild_knight.hrl").
-include("netmsgRecords.hrl").
-include("cfg_guildKnightsAttr.hrl").
-include("player_private_list.hrl").
-include("title_define.hrl").

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

list_to_record(List) ->
	Record = list_to_tuple([guild_knight | List]),
	Record#guild_knight{
		guild_rank = gamedbProc:dbstring_to_term(Record#guild_knight.guild_rank),
		guild_member_rank = gamedbProc:dbstring_to_term(Record#guild_knight.guild_member_rank),
		last_guild_member_rank = gamedbProc:dbstring_to_term(Record#guild_knight.last_guild_member_rank),
		title_info = gamedbProc:dbstring_to_term(Record#guild_knight.title_info)
	}.

record_to_list(Record) ->
	tl(tuple_to_list(Record#guild_knight{
		guild_rank = gamedbProc:term_to_dbstring(Record#guild_knight.guild_rank),
		guild_member_rank = gamedbProc:term_to_dbstring(Record#guild_knight.guild_member_rank),
		last_guild_member_rank = gamedbProc:term_to_dbstring(Record#guild_knight.last_guild_member_rank),
		title_info = gamedbProc:term_to_dbstring(Record#guild_knight.title_info)
	})).

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
	check_init(),
	#guild_knight{guild_next_time = GuildNextTime, member_next_time = MemberNextTime, guild_rank = RankList} = get_data(),
	next_guild_time(GuildNextTime),
	next_member_time(MemberNextTime),
	TopN = lists:sublist(RankList, ?TopMax),
	put_topN(TopN),
	time_update_schedule(),
	ok.

-spec do_call(term(), {pid(), term()}) -> Reply :: term().
do_call(Request, From) ->
	?LOG_ERROR("no_match_call: Request=~p, From=~p", [Request, From]),
	ok.

-spec do_cast(term()) -> any().
do_cast(time_update) ->
	time_update_schedule(),
	time_update();
do_cast({run, Fun}) ->
	Fun();
do_cast({gm_merge_server_settle}) ->
	merge_server_settle();
do_cast({gm_reset_server}) ->
	gm_reset_server();
do_cast(Request) ->
	?LOG_ERROR("no_match_cast: Request=~p", [Request]).

-spec do_terminate(term()) -> any().
do_terminate(_Reason) ->
	ok.

%% 时间更新
time_update_schedule() ->
	erlang:send_after(3000, self(), time_update).
time_update() ->
	Time = time:time(),
	time_update_activity(Time),
	ok.

get_data() ->
	case table_global:lookup(?TableGuildKnight, 1) of
		[R] -> R;
		_ -> {}
	end.

check_init() ->
	case get_data() of
		{} ->
			#guildKnightsBaseCfg{guildRankTime = GuildRankTime, memberRankTime = MemberTime} = cfg_guildKnightsBase:first_row(),
			NowTime = time:time(),
			DayTime = time:daytime(NowTime),
			NextGuildTime = get_guild_next_time(0, GuildRankTime),
			NextMemberTime = get_member_next_time(NowTime, NextGuildTime, GuildRankTime, MemberTime),
			NewData = #guild_knight{
				id = 1,
				index = 1,
				max_index = 1,
				start_time = DayTime,
				guild_next_time = NextGuildTime,
				member_next_time = NextMemberTime,
				open_time = NowTime
			},
			table_global:insert(?TableGuildKnight, NewData);
		#guild_knight{max_index = MaxIndex, start_time = 0} -> %% 合服后数据处理
			#guildKnightsBaseCfg{guildRankTime = GuildRankTime, memberRankTime = MemberTime} = cfg_guildKnightsBase:first_row(),
			NowTime = time:time(),
			DayTime = time:daytime(NowTime),
			NextGuildTime = get_guild_next_time(0, GuildRankTime),
			NextMemberTime = get_member_next_time(NowTime, NextGuildTime, GuildRankTime, MemberTime),
			NewData = #guild_knight{
				id = 1,
				index = 1,
				max_index = MaxIndex,
				start_time = DayTime,
				guild_next_time = NextGuildTime,
				member_next_time = NextMemberTime,
				open_time = NowTime
			},
			table_global:insert(?TableGuildKnight, NewData);
		_ -> ok
	end.


time_update_activity(Time) ->
	case Time >= next_guild_time() of
		?TRUE -> do_guild_rank_settle(Time);
		?FALSE -> ok
	end,
	case Time >= next_member_time() + 1 of
		?TRUE -> deal_member_rank(Time);
		?FALSE -> ok
	end.

get_guild_next_time(0, {_InternalDay, Sec}) -> time:daytime_add(time:time(), Sec);
get_guild_next_time(LastTime, {InternalDay, Sec}) ->
	time:daytime_add(LastTime, InternalDay * ?SECONDS_PER_DAY + Sec).

get_member_next_time(NowTime, GuildTime, {InterNalDay, Sec}, MemberTime) ->
	NextTime = time:daytime_add(GuildTime, -InterNalDay * ?SECONDS_PER_DAY + Sec + MemberTime * ?SECONDS_PER_HOUR),
	case NextTime > NowTime of
		?TRUE -> NextTime;
		?FALSE -> get_member_next_time(NowTime, GuildTime, {InterNalDay, Sec}, MemberTime, NextTime)
	end.
get_member_next_time(NowTime, GuildTime, {InterNalDay, Sec}, MemberTime, RetTime) ->
	case RetTime > NowTime of
		?TRUE -> RetTime;
		?FALSE ->
			get_member_next_time(NowTime, GuildTime, {InterNalDay, Sec}, MemberTime, time:time_add(RetTime, MemberTime * ?SECONDS_PER_HOUR))
	end.

next_guild_time(T) ->
	put({?MODULE, next_guild_time}, T).
next_guild_time() ->
	get({?MODULE, next_guild_time}).

next_member_time(T) ->
	put({?MODULE, next_member_time}, T).
next_member_time() ->
	get({?MODULE, next_member_time}).

do_guild_rank_settle(Time) ->
	#guild_knight{index = Index, guild_next_time = LastGuildNextTime, start_time = StartTime, max_index = MaxIndex} = Data = get_data(),
	#guildKnightsBaseCfg{guildRankTime = {InternalDay, Sec}, memberNum = MemberNum, memberRankTime = MemberRankTime, duration = Duration} = cfg_guildKnightsBase:getRow(Index),
	NewData = case Duration > 0 andalso time:daytime_offset_days(StartTime, Time) + 1 >= Duration of
				  ?TRUE ->
					  NewIndex = Index + 1,
					  case cfg_guildKnightsBase:getRow(NewIndex) of
						  #guildKnightsBaseCfg{guildRankTime = NextGuildRankTimeCfg} ->
							  NextGuildTime = get_guild_next_time(LastGuildNextTime, NextGuildRankTimeCfg),
							  next_guild_time(NextGuildTime),
							  NewMaxIndex = max(MaxIndex, NewIndex),
							  main:sendMsgToAllClient(#pk_GS2U_guild_knight_index_sync{index = NewIndex, max_index = NewMaxIndex, open_time = Time}),
							  Data#guild_knight{index = NewIndex, max_index = NewMaxIndex, start_time = time:daytime(Time), guild_next_time = NextGuildTime, open_time = Time};
						  _ ->
							  NextGuildTime = get_guild_next_time(LastGuildNextTime, {InternalDay, Sec}),
							  next_guild_time(NextGuildTime),
							  Data#guild_knight{guild_next_time = NextGuildTime}
					  end;
				  ?FALSE ->
					  NextGuildTime = get_guild_next_time(LastGuildNextTime, {InternalDay, Sec}),
					  next_guild_time(NextGuildTime),
					  Data#guild_knight{guild_next_time = NextGuildTime}
			  end,
	RankList = get_guild_rank(),
	table_global:insert(?TableGuildKnight, NewData#guild_knight{guild_rank = RankList}),
	TopN = lists:sublist(RankList, ?TopMax),
	put_topN(TopN),
	guild_rank_mail(RankList, TopN, Sec, MemberNum, MemberRankTime),
	main:sendMsgToAllPlayer({check_certain_state_sync, ?CertainStateDragonHonor}),
	marquee:sendChannelNotice(0, 0, actiKnights_gonggao5,
		fun(Language) ->
			[{_, Tp1GName}, {_, Tp2GName}, {_, Tp3GName}, {_, Tp4GName}, {_, Tp5GName} | _] = fix_topN_show(TopN, Language),
			language:format(language:get_server_string("ActiKnights_gonggao5", Language), [Tp1GName, Tp2GName, Tp3GName, Tp4GName, Tp5GName])
		end).

%% 获取战盟前二十排行
get_guild_rank() ->
	{RankList, _} = lists:mapfoldl(
		fun(Info, Num) ->
			{{Num, Info#guild_base.id}, Num + 1}
		end, 1, lists:sublist(guild_pub:sort_guild(), 20)),
	RankList.

put_topN(Data) ->
	d:storage_put({?MODULE, topN}, Data).
get_topN() ->
	d:storage_get({?MODULE, topN}, []).

fix_topN_show(GuildTopN, Language) ->
	Top1Name = language:get_server_string("ActiKnightsName1", Language),
	Top2Name = language:get_server_string("ActiKnightsName2", Language),
	Top3Name = language:get_server_string("ActiKnightsName3", Language),
	Top4Name = language:get_server_string("ActiKnightsName4", Language),
	Top5Name = language:get_server_string("ActiKnightsName5", Language),
	NoExist = language:get_server_string("ActiKnightsServer1", Language),
	Top3Show = common:listsFiterMap(fun({R, Gid}) ->
		case R of
			1 -> {Top1Name, guild_pub:get_guild_name(Gid)};
			2 -> {Top2Name, guild_pub:get_guild_name(Gid)};
			3 -> {Top3Name, guild_pub:get_guild_name(Gid)};
			4 -> {Top4Name, guild_pub:get_guild_name(Gid)};
			5 -> {Top5Name, guild_pub:get_guild_name(Gid)};
			_ ->
				?LOG_ERROR("no rank name ~p", [R]),
				ok
		end
									end, lists:keysort(1, GuildTopN)),
	case length(Top3Show) of
		5 -> Top3Show;
		4 -> Top3Show ++ [{Top5Name, NoExist}];
		3 -> Top3Show ++ [{Top4Name, NoExist}, {Top5Name, NoExist}];
		2 -> Top3Show ++ [{Top3Name, NoExist}, {Top4Name, NoExist}, {Top5Name, NoExist}];
		1 -> Top3Show ++ [{Top2Name, NoExist}, {Top3Name, NoExist}, {Top4Name, NoExist}, {Top5Name, NoExist}];
		0 ->
			[{Top1Name, NoExist}, {Top2Name, NoExist}, {Top3Name, NoExist}, {Top4Name, NoExist}, {Top5Name, NoExist}];
		_ -> Top3Show
	end.

%% 战盟结算邮件
guild_rank_mail([], _, _, _, _) -> ok;
guild_rank_mail([{Rank, GuildID} | T], TopN, GuildRankTime, MemberNum, MemberRankTime) when Rank =< ?TopMax ->
	GuidRankName = case Rank of
					   1 -> "ActiKnightsName1";
					   2 -> "ActiKnightsName2";
					   3 -> "ActiKnightsName3";
					   4 -> "ActiKnightsName4";
					   5 -> "ActiKnightsName5";
					   _ ->
						   ?LOG_ERROR("no rank name ~p", [Rank]),
						   "ActiKnightsName3"
				   end,
	[begin
		 Language = language:get_player_language(PlayerID),
		 [{Tp1Name, Tp1GName}, {Tp2Name, Tp2GName}, {Tp3Name, Tp3GName}, {Tp4Name, Tp4GName}, {Tp5Name, Tp5GName}] = fix_topN_show(TopN, Language),
		 mail:send_mail(#mailInfo{
			 player_id = PlayerID,
			 senderName = "dragon_honor",
			 title = language:get_server_string("ActiKnightsMail1", Language),
			 describe = language:format(language:get_server_string("ActiKnightsMail2", Language), [guild_pub:get_guild_name(GuildID), Rank, language:get_server_string(GuidRankName, Language),
				 GuildRankTime div ?SECONDS_PER_HOUR, MemberNum, MemberRankTime, Tp1Name, Tp1GName, Tp2Name, Tp2GName, Tp3Name, Tp3GName, Tp4Name, Tp4GName, Tp5Name, Tp5GName]),
			 attachmentReason = ?Reason_Dragon_Honor_Guild_Settle,  %% 奖励的原因
			 isDirect = 0
		 }) end || PlayerID <- guild_pub:get_guild_member_id_list(GuildID)],
	guild_rank_mail(T, TopN, GuildRankTime, MemberNum, MemberRankTime);
guild_rank_mail([{Rank, GuildID} | T], TopN, GuildRankTime, MemberNum, MemberRankTime) ->
	[begin
		 Language = language:get_player_language(PlayerID),
		 [{Tp1Name, Tp1GName}, {Tp2Name, Tp2GName}, {Tp3Name, Tp3GName}, {Tp4Name, Tp4GName}, {Tp5Name, Tp5GName}] = fix_topN_show(TopN, Language),
		 mail:send_mail(#mailInfo{
			 player_id = PlayerID,
			 senderName = "dragon_honor",
			 title = language:get_server_string("ActiKnightsMail3", Language),
			 describe = language:format(language:get_server_string("ActiKnightsMail4", Language), [guild_pub:get_guild_name(GuildID), Rank, GuildRankTime div ?SECONDS_PER_HOUR, Tp1Name, Tp1GName, Tp2Name, Tp2GName, Tp3Name, Tp3GName, Tp4Name, Tp4GName, Tp5Name, Tp5GName]),
			 attachmentReason = ?Reason_Dragon_Honor_Guild_Settle,  %% 奖励的原因
			 isDirect = 0
		 }) end || PlayerID <- guild_pub:get_guild_member_id_list(GuildID)],
	guild_rank_mail(T, TopN, GuildRankTime, MemberNum, MemberRankTime).

deal_member_rank(NowTime) ->
	?metrics(begin
				 #guild_knight{index = Index, max_index = MaxIndex, guild_rank = GuildRank, guild_member_rank = LastMemberRank, title_info = OldTitleInfo, guild_next_time = NextGuildTime} = Info = get_data(),
				 #guildKnightsBaseCfg{memberNum = MemberLimitNum, guildRankTime = GuildRankTime, memberRankTime = MemberTime} = cfg_guildKnightsBase:getRow(Index),
				 GuildTopN = lists:sublist(GuildRank, ?TopMax),
				 {NewMemberRank, NewTitleInfo} =
					 lists:foldl(fun
									 ({GRank, GuildID}, {Ret1, Ret2}) when GRank =< ?TopMax ->
										 PlayerBtList = get_guild_member_list(GuildID, OldTitleInfo),
										 MemberTopList = lists:reverse(lists:keysort(2, PlayerBtList)),
										 {RankList, TitleInfo, _} = lists:foldl(fun({PlayerID, _}, {R1, R2, Num}) ->
											 case Num of
												 N when N =< MemberLimitNum ->
													 case find_title_cfg_key(cfg_guildKnightsTitle:getKeyList(), Index, GRank, Num) of
														 {} ->
															 ?LOG_ERROR("no find key ~p", [{Index, GRank, Num}]),
															 {[{Num, PlayerID} | R1], R2, Num + 1};
														 CfgKey ->
															 #guildKnightsTitleCfg{} = Cfg = cfg_guildKnightsTitle:row(CfgKey),
															 TitleID = element(#guildKnightsTitleCfg.title1 + (MaxIndex - 1) * 2, Cfg),
															 settle_award_mail(GRank, TitleID, PlayerID, OldTitleInfo, MemberTime, MemberLimitNum),
															 {[{Num, PlayerID} | R1], [{PlayerID, TitleID} | R2], Num + 1}
													 end;
												 _ ->

													 {[{Num, PlayerID} | R1], R2, Num + 1}
											 end
																				end, {[], [], 1}, MemberTopList),
										 MemberText = lists:append([richText:getPlayerTextByID(PlayerID) || {PlayerID, _} <- lists:sublist(MemberTopList, 4)]),
										 {TextID, NoticeID} = case GRank of
																  1 -> {"ActiKnights_gonggao1", actiKnights_gonggao1};
																  2 -> {"ActiKnights_gonggao2", actiKnights_gonggao2};
																  3 -> {"ActiKnights_gonggao3", actiKnights_gonggao3};
																  4 -> {"ActiKnights_gonggao8", actiKnights_gonggao8};
																  _ -> {"ActiKnights_gonggao9", actiKnights_gonggao9}
															  end,
										 GuildName = guild_pub:get_guild_name(GuildID),
										 marquee:sendChannelNotice(0, 0, NoticeID,
											 fun(Language) ->
												 language:format(language:get_server_string(TextID, Language), [GuildName, MemberText])
											 end),
										 {[{GuildID, RankList} | Ret1], TitleInfo ++ Ret2};
									 (_, {Ret1, Ret2}) -> {Ret1, Ret2}
								 end, {[], []}, GuildRank),
				 NextMemberTime = get_member_next_time(NowTime, NextGuildTime, GuildRankTime, MemberTime),
				 next_member_time(NextMemberTime),
				 table_global:insert(?TableGuildKnight, Info#guild_knight{guild_member_rank = NewMemberRank, last_guild_member_rank = LastMemberRank, title_info = NewTitleInfo, member_next_time = NextMemberTime}),
				 settle_title(GuildTopN, NowTime, OldTitleInfo, NewTitleInfo, MemberTime, MemberLimitNum)
			 end).

find_title_cfg_key([], _Index, _GuildRank, _MyRank) -> {};
find_title_cfg_key([{Index, GuildRank, MemberRank1, MemberRank2} = Key | _], Index, GuildRank, MyRank) when MyRank >= MemberRank1 andalso MyRank =< MemberRank2 ->
	Key;
find_title_cfg_key([_ | T], Index, GuildRank, MyRank) ->
	find_title_cfg_key(T, Index, GuildRank, MyRank).

get_guild_member_list(GuildID, TitleInfo) ->
	?metrics(begin
				 case guild_pub:get_guild_member_maps(GuildID) of
					 {} -> [];
					 #guild_member_maps{member_list = List} ->
						 [{MemberID, fix_bt(MemberID, Bv, TitleInfo)} || {MemberID, _, Bv} <- List]
				 end
			 end).

fix_bt(PlayerID, BattleValue, OldTitleInfo) ->
	case lists:keyfind(PlayerID, 1, OldTitleInfo) of
		?FALSE -> BattleValue;
		{_, TitleID} ->
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
			end
	end.
settle_award_mail(GuildRank, TitleID, PlayerID, OldTitleInfo, MemberTime, MemberLimitNum) when GuildRank =< ?TopMax ->
	case lists:member({PlayerID, TitleID}, OldTitleInfo) of
		?TRUE -> skip;
		_ ->
			case cfg_title:getRow(TitleID) of
				#titleCfg{name = N} ->
					Language = language:get_player_language(PlayerID),
					GuidRankName = case GuildRank of
									   1 -> language:get_server_string("ActiKnightsName1", Language);
									   2 -> language:get_server_string("ActiKnightsName2", Language);
									   3 -> language:get_server_string("ActiKnightsName3", Language);
									   4 -> language:get_server_string("ActiKnightsName4", Language);
									   5 -> language:get_server_string("ActiKnightsName5", Language);
									   _ ->
										   ?LOG_ERROR("no rank name ~p", [GuildRank]),
										   ""
								   end,
					TitleName = language:get_tongyong_string(N, Language),
					mail:send_mail(#mailInfo{
						player_id = PlayerID,
						senderName = "dragon_honor",
						title = language:get_server_string("ActiKnightsMail9", Language),
						describe = language:format(language:get_server_string("ActiKnightsMail10", Language), [GuidRankName, TitleName, MemberTime, MemberLimitNum]),
						attachmentReason = ?Reason_Dragon_Honor_Rank_Award,  %% 奖励的原因
						isDirect = 0
					});
				_ ->
					?LOG_ERROR("no title cfg id: ~p", [TitleID]),
					ok
			end
	end;
settle_award_mail(_, _, _, _, _, _) ->
	ok.

%% 添加称号及推送红点
settle_title(GuildTop3, TimeStamp, OldTitleInfo, NewTitleInfo, MemberTime, MemberLimitNum) ->
	[player_title:on_add_title(PlayerID, TitleID, TimeStamp) || {PlayerID, TitleID} <- NewTitleInfo],
	DelTitleInfo = OldTitleInfo -- NewTitleInfo,
	lists:foreach(fun({MyPlayerID, MyTitleID}) ->
		case lists:any(fun({PlayerID, _}) -> PlayerID =:= MyPlayerID end, NewTitleInfo) of
			?TRUE -> skip;
			_ ->
				settle_del_mail(GuildTop3, MyTitleID, MyPlayerID, MemberTime, MemberLimitNum)
		end
				  end, DelTitleInfo).


%% 失去称号
settle_del_mail(GuildTop3, TitleID, PlayerID, MemberTime, MemberLimitNum) ->
	case cfg_title:getRow(TitleID) of
		#titleCfg{name = N} ->
			PlayerGuild = mirror_player:get_player_element(PlayerID, #player.guildID),
			Language = language:get_player_language(PlayerID),
			GuidRankName = case lists:keyfind(PlayerGuild, 2, GuildTop3) of
							   {1, _} -> language:get_server_string("ActiKnightsName1", Language);
							   {2, _} -> language:get_server_string("ActiKnightsName2", Language);
							   {3, _} -> language:get_server_string("ActiKnightsName3", Language);
							   {4, _} -> language:get_server_string("ActiKnightsName4", Language);
							   {5, _} -> language:get_server_string("ActiKnightsName5", Language);
							   _ ->
								   ?LOG_INFO("no rank name ~p", [{PlayerGuild, GuildTop3}]),
								   ""
						   end,
			case GuidRankName =/= "" of
				?TRUE ->
					TitleName = language:get_tongyong_string(N, Language),
					mail:send_mail(#mailInfo{
						player_id = PlayerID,
						senderName = "dragon_honor",
						title = language:get_server_string("ActiKnightsMail11", Language),
						describe = language:format(language:get_server_string("ActiKnightsMail12", Language), [GuidRankName, TitleName, MemberTime, MemberLimitNum]),
						attachmentReason = ?Reason_Dragon_Honor_Title_Change,  %% 奖励的原因
						isDirect = 0
					});
				_ -> skip
			end;
		_ ->
			ok
	end.

%% 战盟解散检查
check_dissolve_guild(GuildID) ->
	not lists:keymember(GuildID, 2, get_topN()).

merge_server_settle() ->
	#guild_knight{index = Index, max_index = MaxIndex, guild_rank = GuildRank, guild_member_rank = LastMemberRank, title_info = TitleInfo} = get_data(),
	lists:foreach(fun
					  ({GRank, GuildID}) when GRank =< ?TopMax ->
						  case lists:keyfind(GuildID, 1, LastMemberRank) of
							  {_, MemberRankList} ->
								  #guildKnightsBaseCfg{memberNum = MemberLimitNum} = cfg_guildKnightsBase:getRow(Index),
								  lists:foreach(fun({Num, PlayerID}) ->
									  case Num =< MemberLimitNum of
										  ?TRUE ->
											  case find_title_cfg_key(cfg_guildKnightsAttr:getKeyList(), Index, GRank, Num) of
												  {} ->
													  ?LOG_ERROR("no find key ~p", [{Index, GRank, Num}]);
												  CfgKey ->
													  #guildKnightsAttrCfg{} = Cfg = cfg_guildKnightsAttr:row(CfgKey),
													  Attr = element(#guildKnightsAttrCfg.attribute1 + (MaxIndex - 1), Cfg),
													  OldAttr = player_private_list:get_value_ex(PlayerID, ?Private_List_GuildKnightMerge),
													  NewAttr = common:listValueMerge(Attr ++ OldAttr),
													  player_private_list:set_value_ex(PlayerID, ?Private_List_GuildKnightMerge, NewAttr)
											  end;
										  _ ->
											  ok
									  end
												end, MemberRankList);
							  _ -> ok
						  end;
					  (_) -> ok
				  end, GuildRank),
	NowTime = time:time(),
	lists:foreach(fun({PlayerID, TitleID}) ->
		player_title:add_title_record_ex(PlayerID, #title_record{title_id = TitleID, op = ?TitleExpire, time = NowTime}),%%添加称号过期记录
		table_player:delete(?TablePlayerTitle, PlayerID, [TitleID]) end, TitleInfo).

gm_reset_server() ->
	?LOG_INFO("gm_reset_server"),
	table_global:delete_all(?TableGuildKnight),
	check_init(),
	#guild_knight{guild_next_time = GuildNextTime, member_next_time = MemberNextTime, guild_rank = RankList} = get_data(),
	next_guild_time(GuildNextTime),
	next_member_time(MemberNextTime),
	TopN = lists:sublist(RankList, ?TopMax),
	put_topN(TopN).