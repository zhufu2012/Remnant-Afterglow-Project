%%gen_server代码模板

-module(guild).

-behaviour(gen_server).
% --------------------------------------------------------------------
% Include files
% --------------------------------------------------------------------
-include("cfg_guildSacrifice.hrl").
-include("netmsgRecords.hrl").
-include("condition_compile.hrl").
-include("record.hrl").
-include("globalDict.hrl").
-include("guild.hrl").
-include("logDefine.hrl").
-include("cfg_guildTitle.hrl").
-include("error.hrl").
-include("logRecord.hrl").
-include("chatDefine.hrl").
-include("top.hrl").
-include("playerDefine.hrl").
-include("logger.hrl").
-include("db_table.hrl").
-include("cfg_guildBuilding.hrl").
-include("error.hrl").
-include("attainment.hrl").
-include("player_task_define.hrl").
-include("id_generator.hrl").
-include("variable.hrl").
-include("activity_new.hrl").
-include("reason.hrl").
-include("cfg_guildTreasuryGift.hrl").
-include("cfg_chariotscience.hrl").
-include("cfg_chariotLevel.hrl").
-include("cfg_guildActivity.hrl").

% --------------------------------------------------------------------
% External exports
-export([]).
-export([start_link/0]).

% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-export([send_2_me/1, add_guild_event/8, get_guild_info/1, is_guild_master/1, is_guild_master_1/1,
	on_set_guild_ac_state/3, get_guild_ac_state/2, add_guild_money/2, update_guild/1, update_guild_member/1, update_guild_member/2,
	delete_guild_member/2, delete_guild/1, do_server_clear_guild/0, on_set_guild_ac_state/2, add_member_integral/3, call_me/1]).

-record(state, {}).

start_link() ->
	gen_server:start_link({local, guildPID}, ?MODULE, [], []).

send_2_me(Msg) -> gen_server:cast(guildPID, Msg).
call_me(Msg) -> gen_server:call(guildPID, Msg).

init(Args) ->
	try
		State = do_init(Args),
		{ok, State}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{stop, ExcReason}
	end.

handle_call(Request, From, State) ->
	try
		{Reply, NewState} = do_call(Request, From, State),
		{reply, Reply, NewState}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{reply, {error, ExcReason}, State}
	end.

handle_cast(Request, State) ->
	try
		NewState = do_cast(Request, State),
		{noreply, NewState}
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{noreply, State}
	end.

handle_info(Info, State) ->
	try
		put(?Noreply, true),
		NewState = do_cast(Info, State),
		case get(?Noreply) of
			true -> {noreply, NewState};
			false -> {stop, normal, NewState}
		end
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			{noreply, State}
	end.

terminate(Reason, State) ->
	try
		do_terminate(Reason, State)
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

do_init([]) ->
	ets:new(?Ets_GuildMemberMaps, [{keypos, #guild_member_maps.guild_id}, named_table, protected, set, ?ETSRC]),
	ets:new(?GuildDepotEts, [{keypos, #guildDepot.id}, named_table, public, set, ?ETSRC]),
	ets:new(?GuildDepotShowEqEts, [{keypos, #depotShowEq.uid}, named_table, public, set, ?ETSRC]),
	ets:insert(?Ets_GuildMemberMaps, partition_guild_member()),
	guild_depot:load(),
	#state{}.

partition_guild_member() ->
	table_global:fold(
		fun
			(#guild_member{guildID = GuildID, playerID = PlayerID, rank = Rank, battleValue = Battle}, Ret) when GuildID > 0 ->
				case lists:keytake(GuildID, #guild_member_maps.guild_id, Ret) of
					?FALSE ->
						[#guild_member_maps{guild_id = GuildID, member_total = 1, member_list = [{PlayerID, Rank, Battle}]} | Ret];
					{_, #guild_member_maps{member_total = OldTotal, member_list = OldList} = OldR, Left} ->
						[OldR#guild_member_maps{member_total = OldTotal + 1, member_list = [{PlayerID, Rank, Battle} | OldList]} | Left]
				end;
			(_, Ret) -> Ret
		end, [], ?TableGuildMember).

%% 返回{Reply, NewState}
do_call({giveMemberPiece, PlayerID, GuildID, TargetID, PieceID, Number}, _CallFrom, State) ->
	Reply = guild_wish:give_piece(PlayerID, GuildID, TargetID, PieceID, Number),
	{Reply, State};
do_call({exchange_depot_item, GuildID, PlayerID, Equip, Item}, _CallFrom, State) ->
	Reply = guild_depot:exchange_depot_item(GuildID, PlayerID, Equip, Item),
	{Reply, State};
do_call({del_guild_money, GuildID, ChangeMoney}, _CallFrom, State) ->
	Reply = del_guild_money(GuildID, ChangeMoney),
	{Reply, State};
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState
do_cast({quit}, State) ->
	?LOG_INFO("quit", []),
	put(?Noreply, ?FALSE),
	State;
do_cast({broadcast, GuildID, Msg}, State) ->
	guild_pub:send_msg_to_all_member(GuildID, Msg),
	State;
do_cast({playerMsgCreateGuild, Param}, State) ->
	player_msg_create_guild(Param),
	State;
do_cast({playerMsgChangeGuildAnnouncement, PlayerID, GuildID, Msg}, State) ->
	player_msg_change_guild_announcement(PlayerID, GuildID, Msg),
	State;
do_cast({playerMsgChangeGuildLinkUrl, PlayerID, GuildID, Msg}, State) ->%%修改Link群网址
	player_msg_change_guild_link_url(PlayerID, GuildID, Msg),
	State;
do_cast({guild_science_update, PlayerID, GuildID, ID}, State) ->
	guild_science_update(PlayerID, GuildID, ID),
	State;
do_cast({gm_change_notice, GuildID, Str}, State) ->
	gm_change_guild_announcement(GuildID, Str),
	State;
do_cast({gm_change_join_time, GuildID, PlayerID}, State) ->
	gm_change_join_time(GuildID, PlayerID),
	State;
do_cast({playerMsgChangeGuildMemberRecord, PlayerID, Index, Value}, State) ->
	player_msg_change_guild_member_record(PlayerID, Index, Value),
	State;
do_cast({playerMsgGuildMemberOnLine, GuildID, PlayerID, PlayerLevel}, State) ->
	player_msg_guild_member_online(GuildID, PlayerID, PlayerLevel),
	State;
do_cast({playerMsgGuildMemberOffLine, GuildID, PlayerID}, State) ->
	player_msg_guild_member_offline(GuildID, PlayerID),
	State;
do_cast({player_offline_ex, PlayerID, OffLineTIme}, State) ->
	player_offline_ex(PlayerID, OffLineTIme),
	State;
do_cast({playerMsgRequestGuildMemberRankChange, GuildID, PlayerID, Msg}, State) ->
	player_msg_request_guild_member_rank_change(GuildID, PlayerID, Msg),
	State;
do_cast({gm_change_chairman, GuildID, TargetPlayerId}, State) ->
	gm_change_chairman(GuildID, TargetPlayerId),
	State;
do_cast({impeach, PlayerId, GuildId}, State) ->
	guild_impeach(PlayerId, GuildId),
	State;
do_cast({playerMsgKickOutGuildMember, FromPID, PlayerID, GuildID, Msg}, State) ->
	player_msg_kick_out_guild_member(FromPID, PlayerID, GuildID, Msg),
	State;
do_cast({playerMsgRequestGuildQuit, FromPID, PlayerID, GuildID}, State) ->
	player_msg_request_guild_quit(FromPID, PlayerID, GuildID),
	State;
do_cast({playerMsgRequestJoinGuild, FromPID, PlayerID, PlayerName, PlayerSex, PlayerLevel, GuildID, BattleValue}, State) ->
	player_msg_request_join_guild(FromPID, PlayerID, PlayerName, PlayerSex, PlayerLevel, GuildID, BattleValue),
	State;
do_cast({playerMsgOperateGuildApplicant, FromPID, PlayerID, GuildID, TargetPlayerID, IsAllow}, State) ->
	player_msg_operate_guild_applicant(FromPID, PlayerID, GuildID, TargetPlayerID, IsAllow),
	State;
do_cast({playerMsgFeteGod, PlayerID, GuildID, FeteID, Integral, ValidTimes, TaskAward}, State) ->
	player_msg_fete_god(PlayerID, GuildID, FeteID, Integral, ValidTimes, TaskAward),
	State;
do_cast({onekeyRefuseGuildApplicant, GuildID, PlayerID}, State) ->
	onekey_refuse_guild_applicant(GuildID, PlayerID),
	State;
do_cast({playerMsgChangeGuildName, FromPID, PlayerID, GuildID, NewGuildName}, State) ->
	player_msg_change_guild_name(FromPID, PlayerID, GuildID, NewGuildName),
	State;
do_cast({playerMsgDissolveGuild, _PlayerID, GuildID}, State) ->
	on_disband_guild(GuildID),
	State;
do_cast({playerMsgApplyInvite, PlayerID, Data, GuildID}, State) ->
	player_msg_apply_invite(PlayerID, Data, GuildID),
	State;
do_cast({playerMsgCancelJoinGuild, GuildID, PlayerID}, State) ->
	player_msg_cancel_join_guild(GuildID, PlayerID),
	State;
do_cast({playerMsgDeleteGuildItem, PlayerID, GuildID, IDList}, State) ->
	guild_depot:delete_guild_item(PlayerID, GuildID, IDList),
	State;
do_cast({depot_auto_clear_set, Msg}, State) ->
	guild_depot:depot_auto_clear_set(Msg),
	State;
do_cast({auto_clear, GuildId}, State) ->
	guild_depot:auto_clear(GuildId),
	State;
do_cast({donateGuildItem, GuildID, PlayerID, DonateItems}, State) ->
	guild_depot:donate_item(GuildID, PlayerID, DonateItems),
	State;
do_cast({playerMsgGetFeteGodAward, PlayerID, GuildID, FeteIDList}, State) ->
	player_msg_get_fete_god_award(PlayerID, GuildID, FeteIDList),
	State;
do_cast({set_guild_ac_state, GuildID, ActiveID, Status}, State) ->
	set_guild_ac_state(GuildID, ActiveID, Status),
	State;
do_cast({onReset}, State) ->
	check_auto_disband_guild(),
	check_auto_quit_player(),
	guild_envelope ! {onReset5},
	auto_assign_award_item(),
	on_reset_data(),
	guild_instance_zones:send_2_me({on_reset5}),
	State;
do_cast({releaseWish, PlayerID, GuildID, CardIdList, WishTime}, State) ->
	guild_wish:release_wish(PlayerID, GuildID, CardIdList, WishTime),
	State;
do_cast({sendWishMsg, PlayerID, GuildID}, State) ->
	guild_wish:send_wish_msg(PlayerID, GuildID),
	State;
%% battlefield_020_02 公会进程处理角色相关某些击杀事件
do_cast({battlefield_DeadEvent, Msg}, State) ->
	guildBattlefield:onDeadEvent(Msg),
	State;
%% battlefield_013_02 仙盟进程收到排行榜请求
do_cast({battlefield_RankListEvent, PlayerID, GuildID, RankType, DeadList}, State) ->
	guildBattlefield:onRankListEvent(PlayerID, GuildID, RankType, DeadList),
	State;
do_cast({playerMsgEnterCondition, GuildID, PlayerID, Type, Value}, State) ->
	player_msg_enter_condition(GuildID, PlayerID, Type, Value),
	State;
do_cast({playerMsgSetAutoJoin, GuildID, PlayerID, AutoJoin}, State) ->
	player_msg_set_auto_join(GuildID, PlayerID, AutoJoin),
	State;
do_cast({conditionEnterGuild, GuildID, TargetID}, State) ->
	condition_enter_guild(GuildID, TargetID),
	State;
do_cast({changeGuildMoney, GuildID, ChangeMoney}, State) ->
	add_guild_money(GuildID, ChangeMoney),
	State;
do_cast({changeGuildMaterials, GuildID, ChangeMate}, State) ->
	add_guild_materials(GuildID, ChangeMate),
	State;
do_cast({changeGuildTreasureChest, GuildID, AddNum}, State) ->
	add_guild_treasure_chest(GuildID, AddNum),
	State;
do_cast({changeGuildMemberPrestige, GuildID, PlayerID, AddNum}, State) ->
	add_guild_member_prestige(GuildID, PlayerID, AddNum),
	State;
do_cast({addGuildMoneyLog, GuildID, PlayerID, Times, GuildMoney, Dtime}, State) ->
	add_guild_money_log(GuildID, PlayerID, Times, GuildMoney, Dtime),
	State;
do_cast({uplevelBuilding, PlayerID, GuildID, BuildingID}, State) ->
	up_level_building(PlayerID, GuildID, BuildingID),
	State;
do_cast({add_member_integral, GuildID, PlayerID, Integral}, State) ->
	add_member_integral(GuildID, PlayerID, Integral),
	State;
do_cast({cluster_clear, ?BattlefieldPID}, State) ->
	%% 清理陈旧的活动数据
	IsClusterNew = cluster:is_opened(),
	FunClear =
		fun(#guild_base{id = ID, battlefield = Data}) ->
			case Data of
				#battlefieldData{isCluster = IsClusterNew} ->
					skip;
				_ ->
					table_global:update_with(fun(R) ->
						R#guild_base{battlefield = #battlefieldData{isCluster = IsClusterNew}}
											 end,
						[ID],
						?TableGuild
					)
			end
		end,
	lists:foreach(FunClear, table_global:record_list(?TableGuild)),
	State;
do_cast({update_recent_venue, List}, State) ->
	table_global:update_all_with(fun(#guild_base{id = ID} = R) ->
		case lists:keyfind(ID, 1, List) of
			?FALSE -> R#guild_base{recent_venue = 0};
			{_, Venue} -> R#guild_base{recent_venue = Venue}
		end
								 end, ?TableGuild),
	State;
do_cast({assign_treasure_chest, GuildId, PlayerID, PlayerIDList}, State) ->
	assign_treasure_chest(GuildId, PlayerID, PlayerIDList),
	State;
do_cast({assign_guild_award, Type, GuildId, PlayerID, AssignPlayerID, ItemID}, State) ->
	assign_guild_award(Type, GuildId, PlayerID, AssignPlayerID, ItemID),
	State;
do_cast({assign_treasure_rule_set, {PlayerID, GuildID, Rule}}, State) ->
	assign_treasure_rule_set(PlayerID, GuildID, Rule),
	State;
do_cast({assign_award_rule_set, Param}, State) ->
	assign_award_rule_set(Param),
	State;
do_cast({get_prestige_salary, {PlayerID, GuildID}}, State) ->
	get_prestige_salary(PlayerID, GuildID),
	State;
do_cast({chariot_use_rule_set, {PlayerID, GuildID, NewRule}}, State) ->
	chariot_use_rule_set(PlayerID, GuildID, NewRule),
	State;
do_cast({add_member_active_access, PlayerID, Pid, ID, AddTimes}, State) ->
	active_value_access(PlayerID, Pid, ID, AddTimes),
	State;
do_cast({reset21}, State) ->
	on_reset_21(),
	State;
do_cast({gm_clear_member_state_mark, PlayerID}, State) ->
	table_global:update_with(fun(R) -> R#guild_member{state_mark = 0} end, [PlayerID], ?TableGuildMember),
	State;
do_cast({add_assign_award_item, GuildID, ItemList, Type, SourceFrom}, State) ->
	add_assign_award_item(Type, SourceFrom, GuildID, ItemList),
	State;
do_cast({gm_quick_join, PlayerID}, State) ->
	gm_quick_join(PlayerID),
	State;
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

get_prestige_salary(PlayerID, GuildID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		MemberData = guild_pub:find_guild_member(PlayerID),
		case MemberData of
			#guild_member{guildID = GuildID, state_mark = Mark} when GuildID > 0 ->
				?CHECK_THROW(not variant:isBitOn(Mark, ?StateContributeSalary), ?ErrorCode_Guild_PrestigeSalary);
			_ -> throw(?ErrorCode_Guild_NoGuild)
		end,
		SalaryAwardList = [
			{
				Cfg#guildTitleCfg.consume,
				element(2, common:getValueByInterval(world_level:get_world_level(), Cfg#guildTitleCfg.wroldLv, {0, 0})),
				Cfg#guildTitleCfg.translateGift
			} || ID <- cfg_guildTitle:getKeyList(), (Cfg = cfg_guildTitle:getRow(ID)) =/= {}],
		update_guild_member(MemberData#guild_member{state_mark = variant:setBit(MemberData#guild_member.state_mark, ?StateContributeSalary, 1)}, ?FALSE),
		{_, Index, Award} = common:getValueByInterval(MemberData#guild_member.prestige, SalaryAwardList, {0, 0, []}),
		Salary = [{T, CfgID, N, B} || {I, _, T, CfgID, N, B} <- Award, Index =:= I],
		Item = [{I, N, B} || {1, I, N, B} <- Salary],
		Currency = [{I, N} || {2, I, N, _B} <- Salary],
		Msg = {player_reaward2, Item, [], Currency, 0, ?Reason_PrestigeSalary, 1, ?TRUE},
		main:sendMsgToPlayerProcess(PlayerID, Msg),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_get_prestige_salary_ret{err_code = ?ERROR_OK})
	catch
		ErrorCode -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_get_prestige_salary_ret{err_code = ErrorCode})
	end.

do_terminate(_Reason, _State) ->
	ok.

%%创建帮派
player_msg_create_guild({PlayerID, PlayerName, PlayerLevel, PlayerSex, National, BattleValue, Name, Icon}) ->
	try
		GuildID = id_generator:generate(?ID_TYPE_Guild),
		NowTime = time:time(),
		OldMember = case guild_pub:find_guild_member(PlayerID) of
						{} -> #guild_member{};
						Info -> Info
					end,
		NewMember = OldMember#guild_member{
			guildID = GuildID,
			playerID = PlayerID,
			rank = ?GuildRank_Chairman,
			playerName = PlayerName,
			playerSex = PlayerSex,
			playerLevel = PlayerLevel,
			playerVip = mirror_player:get_player_vip(PlayerID),
			playerHeadID = mirror_player:get_player_equip_head(PlayerID),
			playerFrame = mirror_player:get_player_equip_frame(PlayerID),
			playerNational = National,
			battleValue = BattleValue,
			isOnline = 1,
			joinTime = NowTime,
			lastOffTime = NowTime
		},
		InitBuilding = guild_pub:check_init_building([]),
		NewGuild = #guild_base{
			id = GuildID,
			headIcon = Icon,
			creatorID = PlayerID,
			chairmanPlayerID = PlayerID,
			chairmanPlayerName = PlayerName,
			guildName = Name,
			createTime = NowTime,
			changeNameTime = NowTime,
			building_list = InitBuilding,
			wish_limit_num = guild_pub:get_attr_value_by_index(InitBuilding, ?Guild_WishNum)
		},

		update_guild(NewGuild),
		update_guild_member(NewMember),

		main:sendMsgToPlayerProcess(PlayerID, {guildMsgCreateGuildResult, GuildID, ?ERROR_OK}),
		guildBattlefield:sendTaskInfo(NewGuild, PlayerID),
		guild_instance_zones:send_2_me({guild_create, GuildID}),
		logdbProc:log_guild_level(GuildID, 1),
		logdbProc:log_guildchange(GuildID, Name, language:get_server_string("guildChange_Create", ""), PlayerID, 1, 0, 0, 0, NowTime),
		ok
	catch
		Err ->
			main:sendMsgToPlayerProcess(PlayerID, {guildMsgCreateGuildResult, 0, Err})
	end.

update_guild(GuildBase) ->
	table_global:insert(?TableGuild, GuildBase).
delete_guild(GuildID) ->
	table_global:delete(?TableGuild, [GuildID]),
	etsBaseFunc:deleteRecord(?Ets_GuildMemberMaps, GuildID).

update_guild_member(#guild_member{} = NewMember) ->
	update_guild_member(NewMember, ?TRUE).
update_guild_member(NewMember, ?FALSE) ->
	table_global:insert(?TableGuildMember, NewMember);
update_guild_member(#guild_member{playerID = PlayerID, guildID = GuildID, rank = Rank, battleValue = Battle} = NewMember, _IsFresh) ->
	table_global:insert(?TableGuildMember, NewMember),
	NewMemberMap = case etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID) of
					   {} ->
						   #guild_member_maps{guild_id = GuildID, member_total = 1, member_list = [{PlayerID, Rank, Battle}]};
					   #guild_member_maps{member_total = Num, member_list = L} = R ->
						   case lists:keytake(PlayerID, 1, L) of
							   ?FALSE ->
								   R#guild_member_maps{member_total = Num + 1, member_list = [{PlayerID, Rank, Battle} | L]};
							   {_, _, Left} ->
								   R#guild_member_maps{member_list = [{PlayerID, Rank, Battle} | Left]}
						   end
				   end,
	etsBaseFunc:insertRecord(?Ets_GuildMemberMaps, NewMemberMap).
delete_guild_member(GuildID, PlayerID) ->
	case table_global:lookup(?TableGuildMember, PlayerID) of
		[#guild_member{guildID = GuildID} | _] when GuildID > 0 ->
			table_global:update_with(fun clear_member_fun/1, [PlayerID], ?TableGuildMember),
			case etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID) of
				{} ->
					ok;
				#guild_member_maps{member_total = Num, member_list = L} = R ->
					case lists:keytake(PlayerID, 1, L) of
						?FALSE ->
							ok;
						{_, _, Left} ->
							NewMemberMap = R#guild_member_maps{member_total = max(Num - 1, 0), member_list = Left},
							etsBaseFunc:insertRecord(?Ets_GuildMemberMaps, NewMemberMap)
					end
			end,
			?ERROR_OK;
		_ ->
			?Guild_KickOut_NoTarget
	end.

%%修改帮派公告
player_msg_change_guild_announcement(PlayerID, GuildID, #pk_U2GS_RequestChangeGuildAnnouncement{strAnnouncement = NewAnnouncement} = _Msg) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> ok;
			_ ->
				MemberList = case guild_pub:get_guild_member_maps(GuildID) of
								 #guild_member_maps{member_list = M} -> M;
								 _ -> throw(?ErrorCode_Guild_NoGuild)
							 end,
				Rank =
					case lists:keyfind(PlayerID, 1, MemberList) of
						false -> throw(?Guild_ModifyAnnouncement_NotMember);
						{_, Rk, _} -> Rk
					end,
				table_global:update_with(fun(R) ->
					R#guild_base{announcement = NewAnnouncement}
										 end, [GuildID], ?TableGuild),
				ToAll = #pk_GS2U_GuildAnnouncementChanged{strAnnouncement = NewAnnouncement},
				guild_pub:send_msg_to_all_member(GuildID, ToAll),
				m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestChangeGuildAnnouncementResult{result = ?ERROR_OK}),

				PlayerIDList = [MemberID || {MemberID, _, _} <- MemberList],
				PlayerText = richText:getPlayerTextByID(PlayerID),
				marquee:sendChannelNotice(PlayerIDList, GuildID, guild_Notice_Text2,
					fun(Language) ->
						language:format(language:get_server_string("Guild_Notice_Text2", Language),
							[richText:getGuildRankText(Rank, Language), PlayerText])
					end),

				marquee:sendChannelNotice(PlayerIDList, GuildID, guildNewNotice1,
					fun(Language) ->
						language:format(language:get_server_string("GuildNewNotice1", Language), [NewAnnouncement])
					end)
		end
	catch
		ErrorCode ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestChangeGuildAnnouncementResult{result = ErrorCode})
	end.

%% 修改帮派公告
gm_change_guild_announcement(GuildId, NewAnnouncement) ->
	Guild = guild_pub:find_guild(GuildId),
	case Guild of
		{} -> ?LOG_ERROR("cannot find guild when gm change notice :~p", [GuildId]);
		_ ->
			MemberList = case guild_pub:get_guild_member_maps(GuildId) of
							 #guild_member_maps{member_list = M} -> M;
							 _ -> throw(?ErrorCode_Guild_NoGuild)
						 end,
			table_global:update_with(fun(R) ->
				R#guild_base{announcement = NewAnnouncement}
									 end, [GuildId], ?TableGuild),
			ToAll = #pk_GS2U_GuildAnnouncementChanged{strAnnouncement = NewAnnouncement},
			guild_pub:send_msg_to_all_member(GuildId, ToAll),
			PlayerIDList = [MemberID || {MemberID, _, _} <- MemberList],
			marquee:sendChannelNotice(PlayerIDList, GuildId, guildNewNotice1,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice1", Language), [NewAnnouncement])
				end),
			?LOG_INFO("gm change guild notice ok =====================================")
	end.

%%修改公会Link群网址
player_msg_change_guild_link_url(PlayerID, GuildID, #pk_U2GS_RequestChangeGuildLinkUrl{strLink = NewStrLinkUrl} = _Msg) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> ok;
			_ ->
				#guild_base{link_reward = LinkReward} = Guild,
				MemberList = case guild_pub:get_guild_member_maps(GuildID) of
								 #guild_member_maps{member_list = M} -> M;
								 _ -> throw(?ErrorCode_Guild_NoGuild)
							 end,
				case lists:keyfind(PlayerID, 1, MemberList) of
					?FALSE -> throw(?Guild_ModifyAnnouncement_NotMember);
					{_, Rk, _} -> Rk
				end,
				table_global:update_with(fun(R) ->%%修改
					R#guild_base{link_url = NewStrLinkUrl, link_reward = 1} end, [GuildID], ?TableGuild),
				ToAll = #pk_GS2U_GuildLinkUrlChanged{strLink = NewStrLinkUrl},
				guild_pub:send_msg_to_all_member(GuildID, ToAll),
				m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestChangeGuildLinkUrlResult{result = ?ERROR_OK}),
				AwardList = df:getGlobalSetupValueList(lINE_lianjie, [{1, 1110025, 1, 1}, {1, 1290008, 1, 8}, {2, 0, 1, 50}]),
				case LinkReward =:= 0 of
					?TRUE ->
						Language = language:get_player_language(PlayerID),
						mail:send_mail(#mailInfo{
							player_id = PlayerID,
							title = language:get_server_string("EmaiLineQunText01", Language),                   %% 标题
							describe = language:get_server_string("EmaiLineQunText02", Language),               %% 描述
							multiple = 1,           %% 奖励倍数
							itemList = [#itemInfo{itemID = T, num = V, isBind = I} || {1, T, I, V} <- AwardList],
							coinList = [#coinInfo{type = T, num = V} || {2, T, _, V} <- AwardList],           %% 货币奖励列表
							attachmentReason = ?Reason_Guild_LinkUrl_Award
						});
					?FALSE ->
						ok
				end
		end
	catch
		ErrorCode ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestChangeGuildLinkUrlResult{result = ErrorCode})
	end.

check_guild_notice(GuildID, ReceiverID) ->
	Guild = guild_pub:find_guild(GuildID),
	case Guild =/= {} andalso Guild#guild_base.announcement =/= "" of
		?FALSE -> ok;
		?TRUE ->
			case ReceiverID of
				0 ->
					case guild_pub:get_guild_member_maps(GuildID) of
						#guild_member_maps{member_list = MemberList} ->
							PlayerIDList = [MemberID || {MemberID, _, _} <- MemberList],
							marquee:sendChannelNotice(PlayerIDList, GuildID, guild_Notice_Text3,
								fun(Language) ->
									language:format(language:get_server_string("Guild_Notice_Text3", Language), [Guild#guild_base.announcement])
								end);
						_ -> ok
					end;
				_ ->
					marquee:sendChannelNotice(ReceiverID, GuildID, guild_Notice_Text3,
						fun(Language) ->
							language:format(language:get_server_string("Guild_Notice_Text3", Language), [Guild#guild_base.announcement])
						end)
			end
	end.

%% 增加声望
add_guild_member_prestige(0, _PlayerID, _ContributeValue) -> ok;
add_guild_member_prestige(GuildID, PlayerID, ContributeValue) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} ->
				throw(?Guild_Contribute_NoGuild);
			_ -> ok
		end,

		Member = guild_pub:find_guild_member(PlayerID),
		case Member of
			#guild_member{guildID = GuildID} -> ok;
			_ -> throw(?Guild_Contribute_NotMember)
		end,
		ValueNew = ContributeValue + Member#guild_member.prestige,
		WeeklyValueNew = ContributeValue + Member#guild_member.weekly_prestige,
		NewMember = Member#guild_member{prestige = ValueNew, weekly_prestige = WeeklyValueNew},
		guild:update_guild_member(NewMember, ?FALSE),

		logdbProc:log_guildchange(GuildID, Guild#guild_base.guildName,
			language:get_server_string("guildChange_addContrib", ""), PlayerID, 0, 0, ContributeValue, 0, time:time()),
		todo
	catch
		ErrorCode -> ?LOG_INFO("player_msg_guild_contribute ~p", [{GuildID, PlayerID, ContributeValue, ErrorCode}])
	end.

%% 增加捐赠积分
add_member_integral(GuildID, PlayerID, Integral) ->
	case guild_pub:find_guild(GuildID) of
		{} -> ok;
		_Guild ->
			case guild_pub:find_guild_member(PlayerID) of
				#guild_member{guildID = GuildID} = Member ->
					NewMember = Member#guild_member{donate_integral = max(Member#guild_member.donate_integral + Integral, 0)},
					guild:update_guild_member(NewMember, ?FALSE);
				_ -> ok
			end
	end,
	ok.

add_guild_money(0, _Money) -> ok;
add_guild_money(GuildID, Money) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{guildMoney = OldMoney} = Info ->
			NewMoney = max(OldMoney + Money, 0),
			guild:update_guild(Info#guild_base{guildMoney = NewMoney}),
			Money > 0 andalso guild_workshop:send_2_me({guild_money_increase, GuildID});
		_ ->
			?LOG_ERROR("no exist guild ~p", [{GuildID, Money}]),
			ok
	end.
del_guild_money(0, _Money) -> ?FALSE;
del_guild_money(GuildID, Money) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{guildMoney = OldMoney} = Info when OldMoney >= Money ->
			guild:update_guild(Info#guild_base{guildMoney = OldMoney - Money}),
			?TRUE;
		_ ->
			?FALSE
	end.

add_guild_materials(0, _Num) -> ok;
add_guild_materials(GuildID, Num) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{building_materials = OldNum} = Info ->
			NewMoney = max(OldNum + Num, 0),
			guild:update_guild(Info#guild_base{building_materials = NewMoney});
		_ ->
			?LOG_ERROR("no exist guild ~p", [{GuildID, Num}]),
			ok
	end.

add_guild_treasure_chest(0, _Num) -> ok;
add_guild_treasure_chest(GuildID, Num) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{treasure_chest = OldNum} = Info ->
			NewMoney = max(OldNum + Num, 0),
			guild:update_guild(Info#guild_base{treasure_chest = NewMoney});
		_ ->
			?LOG_ERROR("no exist guild ~p", [{GuildID, Num}]),
			ok
	end.

add_guild_money_log(GuildID, PlayerID, Times, GuildMoney, Dtime) ->
	Guild = guild_pub:find_guild(GuildID),
	case Guild of
		{} -> throw(?Guild_Quit_NoGuild);
		_ -> ok
	end,
	%% 玩家ID 捐献次数  仙盟基金 时间
	NewEvent = {PlayerID, Times, GuildMoney, Dtime},
	NewList = [NewEvent | Guild#guild_base.moneyLog_list],
	table_global:update_with(fun(R) ->
		R#guild_base{moneyLog_list = NewList}
							 end, [GuildID], ?TableGuild).

%% 增加公会动态信息
add_guild_event(GuildID, PlayerID, PlayerName, EventID, DataID, Type, AddNum, EventTime) ->
	add_guild_event(GuildID, PlayerID, PlayerName, EventID, DataID, Type, AddNum, EventTime, 0).
add_guild_event(GuildID, PlayerID, PlayerName, EventID, DataID, Type, AddNum, EventTime, Param) ->
	try
		%%帮派记录
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_Quit_NoGuild);
			_ -> ok
		end,

		NewEvent = #guildEventList{playerName = PlayerName, eventID = EventID, dataID = DataID, type = Type, addNum = AddNum, eventTime = EventTime, param = Param},
		NewEventList = [NewEvent | Guild#guild_base.eventList],
		table_global:update_with(fun(R) ->
			R#guild_base{eventList = NewEventList}
								 end, [GuildID], ?TableGuild)
	catch
		ErrorCde ->
			?LOG_INFO("add guild event failure GuildID[~p], playerID[~p],ErrorCode[~p]", [GuildID, PlayerID, ErrorCde])
	end.

%% 让加入时间大于24小时
gm_change_join_time(GuildID, PlayerID) ->
	Guild = guild_pub:find_guild(GuildID),
	case Guild of
		{} -> ok;
		_ ->
			T = time:time_add(time:time(), - 86400 * 7),
			table_global:update_with(fun(R) -> R#guild_member{joinTime = T} end, [PlayerID], ?TableGuildMember)
	end.

%% 玩家属性变化
player_msg_change_guild_member_record(PlayerID, Index, Value) ->
	try
		%%成员信息记录
		Member = guild_pub:find_guild_member(PlayerID),
		case Member of
			#guild_member{guildID = Gid} when Gid > 0 -> ok;
			_ -> throw(?Guild_Contribute_NotMember)
		end,

		UpdateList = [{#player.name, #guild_member.playerName},
			{#player.sex, #guild_member.playerSex},
			{#player.level, #guild_member.playerLevel},
			{#player.vip, #guild_member.playerVip},
			{#player.head_id, #guild_member.playerHeadID},
			{#player.frame_id, #guild_member.playerFrame},
			{#player.nationality_id, #guild_member.playerNational},
			{#player.battleValue, #guild_member.battleValue},
			{#player.offlinetime, #guild_member.lastOffTime}],

		NewMember = case lists:keyfind(Index, 1, UpdateList) of
						{_, GIndex} ->
							setelement(GIndex, Member, Value);
						_ ->
							Member
					end,
		%% 成员属性变化
		update_guild_member(NewMember),
		case Index =:= #player.name andalso NewMember#guild_member.rank =:= ?GuildRank_Chairman of
			?TRUE ->
				table_global:update_with(fun(R) ->
					R#guild_base{chairmanPlayerName = Value}
										 end, [NewMember#guild_member.guildID], ?TableGuild);
			?FALSE -> ok
		end
	catch
		_ ->
			ok
	end.

%%成员上线通知
player_msg_guild_member_online(GuildID, PlayerID, PlayerLevel) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} ->
				%%帮派可能已经被删除了
				main:sendMsgToPlayerProcess(PlayerID, {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, time:time()}]}),
				throw(-1);
			_ ->
				player_msg_guild_member_online_ex(PlayerID, Guild, PlayerLevel)
		end,
		ok
	catch
		_ -> ok
	end.

player_msg_guild_member_online_ex(PlayerID, Guild, PlayerLevel) ->
	case guild_pub:is_guild_member(Guild#guild_base.id, PlayerID) of
		false -> %%容错处理，玩家GuildID 非零，而又没在帮会群里
			main:sendMsgToPlayerProcess(PlayerID, {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, time:time()}]}),
			?LOG_ERROR("playerMsgGuildMemberOnLine PlayerID, GuildID[~p ~p] can not find memberrecord", [PlayerID, Guild#guild_base.id]);
		_ ->
			Member = guild_pub:find_guild_member(PlayerID),
			Member =/= {} andalso update_guild_member(Member#guild_member{isOnline = 1, playerLevel = PlayerLevel}, ?FALSE),
			case lists:member(Member#guild_member.rank, [?GuildRank_Chairman, ?GuildRank_SuperElder, ?GuildRank_ViceChairman]) of
				?FALSE -> ok;
				?TRUE -> guild_auction:send_2_me({manager_online, Guild#guild_base.id})
			end,
			ToMsg = #pk_GS2U_GuildMemberOnlineChanged{nPlayerID = PlayerID, nOnline = 1},
			guild_pub:send_msg_to_all_member(Guild#guild_base.id, ToMsg),
			guildBattlefield:sendTaskInfo(Guild, PlayerID),
			check_guild_notice(Guild#guild_base.id, PlayerID)
	end.

%%成员下线通知
player_msg_guild_member_offline(GuildID, PlayerID) ->
	Guild = guild_pub:find_guild(GuildID),
	case Guild of
		{} -> ok;
		_ ->
			Member = guild_pub:find_guild_member(PlayerID),
			case Member of
				{} ->
					?LOG_ERROR("playerMsgGuildMemberOffLine, PlayerID, GuildID[~p ~p] can not find memberrecord", [PlayerID, GuildID]);
				_ ->
					NewMember = Member#guild_member{isOnline = 0, lastOffTime = time:time()},
					update_guild_member(NewMember, ?FALSE)
			end,
			ToMsg = #pk_GS2U_GuildMemberOnlineChanged{nPlayerID = PlayerID, nOnline = 0},
			guild_pub:send_msg_to_all_member(GuildID, ToMsg),
			ok
	end,
	ok.

player_offline_ex(PlayerID, OffLineTime) ->
	Member = guild_pub:find_guild_member(PlayerID),
	case Member of
		#guild_member{isOnline = 1} ->
			NewMember = Member#guild_member{isOnline = 0, lastOffTime = OffLineTime},
			update_guild_member(NewMember, ?FALSE);
		_ -> ok
	end.

%%调整帮派成员职位
player_msg_request_guild_member_rank_change(GuildID, PlayerID, #pk_U2GS_RequestGuildMemberRankChange{nPlayerID = TargetPlayerID, nRank = TargetRank}) ->
	try
		%%帮派记录
		Guild = guild_pub:find_guild(GuildID),
		%%任命者成员信息记录
		OpMember = guild_pub:find_guild_member(PlayerID),
		case OpMember =/= {} andalso OpMember#guild_member.guildID > 0 of
			?FALSE -> throw(?Guild_ChangeRank_NoSource);
			_ -> ok
		end,
		%%目标玩家的成员信息记录
		TargetMember = guild_pub:find_guild_member(TargetPlayerID),
		case TargetMember =/= {} andalso OpMember#guild_member.guildID =:= TargetMember#guild_member.guildID of
			?FALSE -> throw(?Guild_ChangeRank_NoTarget);
			_ -> ok
		end,
		%%官职个数检查
		ExistRankCount = length(guild_pub:get_guild_member_list_by_rank(GuildID, TargetRank)),
		case TargetRank of
			?GuildRank_Chairman -> %%帮主
				todo;
			?GuildRank_SuperElder -> %% 太上长老
				%% 太上长老人数 定义全局表
				case ExistRankCount >= guild_pub:get_attr_value_by_index(GuildID, ?Guild_SuperElder) of
					?TRUE -> throw(?Guild_ChangeRank_OutOfRankCount);
					?FALSE -> ok
				end,
				todo;
			?GuildRank_ViceChairman -> %%副帮主
				%%任命为副帮主
				%% 副盟主人数 定义全局表
				case ExistRankCount >= guild_pub:get_attr_value_by_index(GuildID, ?Guild_ViceChairman) of
					true -> throw(?Guild_ChangeRank_OutOfRankCount);
					false -> ok
				end;
			?GuildRank_Elder -> %%长老
				case ExistRankCount >= guild_pub:get_attr_value_by_index(GuildID, ?Guild_Elder) of
					true -> throw(?Guild_ChangeRank_OutOfRankCount);
					false -> ok
				end;
			?GuildRank_Elite -> %% 精英
				case ExistRankCount >= guild_pub:get_attr_value_by_index(GuildID, ?Guild_Elite) of
					true -> throw(?Guild_ChangeRank_OutOfRankCount);
					false -> ok
				end;
			?GuildRank_Normal -> %%成员
				todo;
			_ ->
				throw(?Guild_ChangeRank_OutOfRankCount)
		end,
		%%检查完毕，执行操作
		case TargetRank of
			?GuildRank_Chairman ->%%帮主移交要特别处理
				NewTargetMember = TargetMember#guild_member{rank = ?GuildRank_Chairman},
				NewOpMember = OpMember#guild_member{rank = ?GuildRank_Normal},
				NewGuildBase = Guild#guild_base{chairmanPlayerID = TargetPlayerID, chairmanPlayerName = NewTargetMember#guild_member.playerName},
				update_guild_member(NewTargetMember),
				update_guild_member(NewOpMember),
				update_guild(NewGuildBase),
				%% 帮主变为成员
				ToMsg0 = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = PlayerID, nNewRank = ?GuildRank_Normal},
				guild_pub:send_msg_to_all_member(GuildID, ToMsg0);
			_ ->
				NewTargetMember = TargetMember#guild_member{rank = TargetRank},
				update_guild_member(NewTargetMember)
		end,
		NewGuild = guild_pub:find_guild(GuildID),
		main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerRank}),

		case TargetRank of
			?GuildRank_SuperElder ->
				case length(guild_pub:get_guild_member_list_by_rank(GuildID, TargetRank)) >= 1 of
					?TRUE ->
						activity_new_player:on_active_condition_change_ex(NewGuild#guild_base.chairmanPlayerID, ?SalesActivity_Guild_SuperElder1, 1);
					?FALSE -> ok
				end;
			?GuildRank_ViceChairman ->
				case length(guild_pub:get_guild_member_list_by_rank(GuildID, TargetRank)) >= 2 of
					?TRUE ->
						activity_new_player:on_active_condition_change_ex(NewGuild#guild_base.chairmanPlayerID, ?SalesActivity_Guild_ViceChairman2, 1);
					?FALSE -> ok
				end;
			?GuildRank_Chairman ->
				main:sendMsgToPlayerProcess(PlayerID, {changePlayerRank}),
				activity_new_common:check_guild_active_condition(NewGuild#guild_base.chairmanPlayerID, GuildID);
			_ -> ok
		end,

		case TargetRank > TargetMember#guild_member.rank of
			?TRUE ->
				guild_pub:get_rise_rank_index(TargetRank, GuildID, [richText:getPlayerTextByID(TargetPlayerID)]),
				EventType = 5;
			?FALSE ->
				guild_pub:get_down_rank_index(TargetRank, GuildID, [richText:getPlayerTextByID(TargetPlayerID)]),
				EventType = 6
		end,
		guild_event:add_guild_event(GuildID, ?EventModule_1, EventType, TargetPlayerID, [TargetRank]),
		ToMsg = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = TargetPlayerID, nNewRank = TargetRank},
		guild_pub:send_msg_to_all_member(GuildID, ToMsg)
	catch
		ErrorCode ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_GuildMemberRankChangedResult{result = ErrorCode, nPlayerID = TargetPlayerID, nNewRank = TargetRank})
	end.

%%调整帮派成员职位
gm_change_chairman(GuildID, TargetPlayerID) ->
	try
		TargetRank = ?GuildRank_Chairman,
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_Error_NoGuild);
			_ -> skip
		end,
		#guild_base{chairmanPlayerID = PlayerID} = Guild,
		MemberRecord = guild_pub:find_guild_member(PlayerID),
		case MemberRecord of
			#guild_member{guildID = GuildID} -> ok;
			_ -> throw(?Guild_ChangeRank_NoSource)
		end,
		%%目标玩家的成员信息记录
		TargetMemberRecord = guild_pub:find_guild_member(TargetPlayerID),
		case TargetMemberRecord of
			#guild_member{guildID = GuildID} -> ok;
			_ -> throw(?Guild_ChangeRank_NoTarget)
		end,

		%% 检查完毕，执行操作
		NewMemberList1 = TargetMemberRecord#guild_member{rank = ?GuildRank_Chairman},
		NewMemberList2 = MemberRecord#guild_member{rank = ?GuildRank_Normal},
		NewGuild = Guild#guild_base{chairmanPlayerID = TargetPlayerID, chairmanPlayerName = TargetMemberRecord#guild_member.playerName},
		update_guild_member(NewMemberList1),
		update_guild_member(NewMemberList2),
		update_guild(NewGuild),

		%% 帮主变为成员
		ToMsg0 = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = PlayerID, nNewRank = ?GuildRank_Normal},
		guild_pub:send_msg_to_all_member(GuildID, ToMsg0),

		main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerRank}),
		main:sendMsgToPlayerProcess(PlayerID, {changePlayerRank}),
		activity_new_common:check_guild_active_condition(NewGuild#guild_base.chairmanPlayerID, GuildID),

		guild_pub:get_rise_rank_index(TargetRank, GuildID, [richText:getPlayerTextByID(TargetPlayerID)]),
		EventType = 5,
		guild_event:add_guild_event(GuildID, ?EventModule_1, EventType, TargetPlayerID, [TargetRank]),
		ToMsg = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = TargetPlayerID, nNewRank = TargetRank},
		guild_pub:send_msg_to_all_member(GuildID, ToMsg),
		?LOG_INFO("gm change chairmain ok =====================================")
	catch
		ErrorCode ->
			?LOG_ERROR("gm change chairmain error :~p", [ErrorCode]),
			ErrorCode
	end.
%% 弹劾
guild_impeach(OpPlayerId, GuildId) ->
	try
		Guild = guild_pub:find_guild(GuildId),
		case Guild of
			{} -> throw(?Guild_Error_NoGuild);
			_ -> skip
		end,
		#guild_base{chairmanPlayerID = MasterId} = Guild,
		case main:isOnline(MasterId) of
			?TRUE -> throw(?ErrorCode_Guild_ImpeachFail);
			_ -> skip
		end,
		Master = guild_pub:find_guild_member(MasterId),
		case Master of
			#guild_member{guildID = GuildId} -> ok;
			_ ->
				throw(?Guild_ChangeRank_NoSource)
		end,
		#guild_member{lastOffTime = LastOfflineTime} = Master,

		case time:time_sub(time:time(), LastOfflineTime) >= ?SECONDS_PER_DAY of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_Guild_ImpeachFail)
		end,

		%% 目标玩家的成员信息记录
		OpPlayer = guild_pub:find_guild_member(OpPlayerId),
		case OpPlayer =/= {} andalso OpPlayer#guild_member.guildID =:= GuildId of
			?TRUE -> ok;
			_ -> throw(?ErrorCode_Guild_ImpeachFail)
		end,
		#guild_member{rank = Rank} = OpPlayer,
		case Rank of
			?GuildRank_Chairman -> throw(?ErrorCode_Guild_ImpeachFail);
			?GuildRank_SuperElder -> skip;
			?GuildRank_ViceChairman -> skip;
			_ -> throw(?ErrorCode_Guild_ImpeachFail)
		end,

		%% 检查完毕，执行操作
		NewMember1 = OpPlayer#guild_member{rank = ?GuildRank_Chairman},
		NewMember2 = Master#guild_member{rank = ?GuildRank_Normal},
		NewGuild = Guild#guild_base{chairmanPlayerID = OpPlayerId, chairmanPlayerName = OpPlayer#guild_member.playerName},
		update_guild_member(NewMember1),
		update_guild_member(NewMember2),
		update_guild(NewGuild),

		%% 帮主变为成员
		ToMsg0 = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = MasterId, nNewRank = ?GuildRank_Normal},
		guild_pub:send_msg_to_all_member(GuildId, ToMsg0),

		main:sendMsgToPlayerProcess(OpPlayerId, {changePlayerRank}),
		activity_new_common:check_guild_active_condition(NewGuild#guild_base.chairmanPlayerID, GuildId),

		TargetRank = ?GuildRank_Chairman,
		guild_pub:get_rise_rank_index(TargetRank, GuildId, [richText:getPlayerTextByID(OpPlayerId)]),
		EventType = 5,
		guild_event:add_guild_event(GuildId, ?EventModule_1, EventType, OpPlayerId, [TargetRank]),
		ToMsg = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = OpPlayerId, nNewRank = TargetRank},
		guild_pub:send_msg_to_all_member(GuildId, ToMsg),
		m_send:sendMsgToClient(OpPlayerId, #pk_GS2U_GuildImpeachRet{}),
		on_impeach(OpPlayerId, MasterId, GuildId)
	catch
		ErrorCode ->
			Language = language:get_player_language(OpPlayerId),
			Consume = df:getGlobalSetupValueList(guild_TanheSpend, [{2, 0, 2000}]),
			mail:send_mail(#mailInfo{
				player_id = OpPlayerId,
				title = language:get_server_string("playerbag_full_title", Language),
				describe = language:get_server_string("playerbag_full_describ", Language),
				isDirect = 1,
				coinList = [#coinInfo{type = ID, num = Num, reason = ?Reason_Guild_ImpeachGet} || {2, ID, Num} <- Consume],
				itemList = [#itemInfo{itemID = ID, num = Num} || {1, ID, Num} <- Consume]
			}),
			m_send:sendMsgToClient(OpPlayerId, #pk_GS2U_GuildImpeachRet{err_code = ErrorCode})
	end.

%% P1 -> P2 P1弹劾P2
on_impeach(P1, P2, GuildId) ->
	PlayerText1 = richText:getPlayerTextByID(P1),
	PlayerText2 = richText:getPlayerTextByID(P2),
	guild_pub:send_guild_notice(GuildId, guild_TanheMZ,
		fun(Language) ->
			language:format(language:get_server_string("Guild_TanheMZ", Language), [PlayerText2, PlayerText1])
		end),
	Language = language:get_player_language(P2),
	mail:send_mail(#mailInfo{
		player_id = P2,
		title = language:get_server_string("Guild_Tanhe01", Language),
		describe = language:format(language:get_server_string("Guild_Tanhe02", Language), [PlayerText1])
	}),
	ok.


%%踢成员
player_msg_kick_out_guild_member(_FromPID, PlayerID, GuildID, #pk_U2GS_RequestGuildKickOutMember{nPlayerID = TargetPlayerID} = _Msg) ->
	try
		case PlayerID =:= TargetPlayerID of
			true -> throw(?Guild_KickOut_SamePlayer);
			false -> ok
		end,

		%%帮派记录
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_KickOut_NoGuild);
			_ -> ok
		end,

		MemberList = case guild_pub:get_guild_member_maps(GuildID) of
						 #guild_member_maps{member_list = M} -> M;
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,
		%%踢人者成员信息记录
		MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
		Rank = case MemberRecord of
				   false -> throw(?Guild_OperateApplicant_NoMember);
				   {_, Rk1, _} -> Rk1
			   end,

		%%目标玩家的成员信息记录
		TargetMemberRecord = lists:keyfind(TargetPlayerID, 1, MemberList),
		TargetRank = case TargetMemberRecord of
						 false -> throw(?Guild_KickOut_NoTarget);
						 {_, Rk2, _} -> Rk2
					 end,

		case Rank of
			?GuildRank_Chairman -> ok;
			?GuildRank_SuperElder -> ok;
			?GuildRank_ViceChairman ->
				case TargetRank of
					?GuildRank_Normal -> ok;
					_ -> throw(?Guild_KickOut_NoPermission)
				end;
			_ -> throw(?Guild_KickOut_NoPermission)
		end,

		DelErr = delete_guild_member(GuildID, TargetPlayerID),
		?ERROR_CHECK_THROW(DelErr),
		guild_wish:del_wish_info(GuildID, TargetPlayerID),

		ToMsg = #pk_GS2U_GuildMemberQuit{nPlayerID = TargetPlayerID, bKickOut = 1},
		guild_pub:send_msg_to_all_member(GuildID, ToMsg),
		NowTime = time:time(),
		guild_event:add_guild_event(GuildID, ?EventModule_1, 4, TargetPlayerID, []),
		PlayerText = richText:getPlayerTextByID(PlayerID),
		TargetPlayerText = richText:getPlayerTextByID(TargetPlayerID),
		guild_pub:send_guild_notice(GuildID, guildNewNotice8,
			fun(Language) ->
				language:format(language:get_server_string("GuildNewNotice8", Language), [PlayerText, TargetPlayerText])
			end),
		main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerPropertyList, [{#player.quitGuildTime, NowTime}, {#player.guildID, 0}]}),
		m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_KickOutGuild{}),
		send_kick_mail(TargetPlayerID, Guild#guild_base.guildName),
		gamedbProc:updatePlayerGuildQuitTime(0, NowTime, TargetPlayerID),
		main:sendMsgToPlayerProcess(TargetPlayerID, {guild_quit}),
		trading_market:send_2_me({guild_quit, TargetPlayerID}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestGuildKickOutMemberResult{result = 0})
	catch
		ErrorCode -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestGuildKickOutMemberResult{result = ErrorCode})
	end.

send_kick_mail(PlayerID, GuildName) ->
	Language = language:get_player_language(PlayerID),
	mail:send_mail(#mailInfo{
		player_id = PlayerID,
		title = language:get_server_string("GuildKickMail01", Language),
		describe = language:format(language:get_server_string("GuildKickMail02", Language), [GuildName])
	}).

%%主动退出帮派
player_msg_request_guild_quit(FromPID, PlayerID, GuildID) ->
	try
		%%帮派记录
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_Quit_NoGuild);
			_ -> ok
		end,

		MemberList = case guild_pub:get_guild_member_maps(GuildID) of
						 #guild_member_maps{member_list = M} -> M;
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,

		%%成员信息记录
		MemberRecord = lists:keyfind(PlayerID, 1, MemberList),
		Rank = case MemberRecord of
				   false -> throw(?Guild_OperateApplicant_NoMember);
				   {_, Rk, _} -> Rk
			   end,
		case guild_pub:active_can_exit_guild() of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Guild_InActivity)
		end,

		case Rank of
			%%帮主退出，要移交或解散
			?GuildRank_Chairman ->
				throw(?Guild_Quit_NoNewChairMan);
			_ ->
				DelErr = delete_guild_member(GuildID, PlayerID),
				?ERROR_CHECK_THROW(DelErr),
				NowTime = time:time(),
				gamedbProc:updatePlayerGuildQuitTime(0, NowTime, PlayerID),
				main:sendMsgToPlayerProcess(PlayerID, {guild_quit}),
				trading_market:send_2_me({guild_quit, PlayerID}),
				guild_event:add_guild_event(GuildID, ?EventModule_1, 2, PlayerID, []),
				PlayerText = richText:getPlayerTextByID(PlayerID),
				guild_pub:send_guild_notice(GuildID, guildNotice_Desc2,
					fun(Language) ->
						language:format(language:get_server_string("GuildNotice_Desc2", Language), [PlayerText])
					end),
				guild_wish:del_wish_info(GuildID, PlayerID),

				ToMsg = #pk_GS2U_GuildMemberQuit{nPlayerID = PlayerID, bKickOut = 0},
				guild_pub:send_msg_to_all_member(GuildID, ToMsg),
				case FromPID =:= 0 of
					true -> ok;
					false ->
						FromPID ! {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, NowTime}]}
				end
		end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestGuildQuitResult{result = 0})
	catch
		ErrorCode -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestGuildQuitResult{result = ErrorCode})
	end.

%%申请入帮
player_msg_request_join_guild(_FromPID, PlayerID, PlayerName, PlayerSex, Level, GuildID, BattleValue) ->
	try
		%%帮派记录
		Guild = guild_pub:find_guild(GuildID),
		ApplicantCount = length(Guild#guild_base.applicantList),
		case ApplicantCount >= ?Max_GuildApplicantCount of
			true -> throw(?Guild_Join_MaxApplicantCount);
			false -> ok
		end,

		GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
							  #guild_member_maps{} = R -> R;
							  _ -> throw(?Guild_ChangeRank_NoGuild)
						  end,

		%% 最大人数限制
		MemberCount = GuildMemberMaps#guild_member_maps.member_total,
		MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
		case MemberCount < MaxMemberCount of
			true -> ok;
			false -> throw(?Guild_Join_MaxMemberCount)
		end,

		NewApplicantRecord = #guildApplicant{
			playerID = PlayerID,
			playerName = PlayerName,
			player_sex = PlayerSex,
			level = Level,
			battleValue = BattleValue,
			applyTime = time:time()
		},
		NewApplicantList = lists:keystore(PlayerID, #guildApplicant.playerID, Guild#guild_base.applicantList, NewApplicantRecord),
		NewGuild = Guild#guild_base{applicantList = NewApplicantList},
		update_guild(NewGuild),

		m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestJoinGuildResult{result = 0}),

		%%有申请 发送给帮主、太上长老、副帮主
		case main:isOnline(Guild#guild_base.chairmanPlayerID) of
			?TRUE -> send_applicant_to_client(Guild#guild_base.chairmanPlayerID, GuildID);
			_ -> ok
		end,
		Func = fun({MemberID, MemberRank, _}) ->
			case MemberRank =:= ?GuildRank_ViceChairman orelse MemberRank =:= ?GuildRank_SuperElder of
				?TRUE ->
					case main:isOnline(MemberID) of
						?TRUE -> send_applicant_to_client(MemberID, GuildID);
						_ -> ok
					end;
				_ -> ok
			end,
			Language = language:get_player_language(MemberID),
			Content = language:format(language:get_server_string("Guild_Application_text1", Language), [richText:getPlayerTextByID(PlayerID)]),
			chat:systemSend(MemberID, Content)
			   end,
		lists:foreach(Func, GuildMemberMaps#guild_member_maps.member_list)
	catch
		ErrorCode -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestJoinGuildResult{result = ErrorCode})
	end.

%%发送申请信息到客户端
send_applicant_to_client(PlayerID, GuildID) ->
	Guild = guild_pub:find_guild(GuildID),
	case Guild of
		{} -> ok;
		_ ->
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
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_GuildApplicantInfoList{info_list = ApplicantList})
	end.

%%操作申请入帮者
player_msg_operate_guild_applicant(_FromPID, PlayerID, GuildID, TargetPlayerID, IsAllow) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_OperateApplicant_NoGuild);
			_ -> ok
		end,

		ApplyRecord = guild_pub:get_guild_applicatn_record(Guild, TargetPlayerID),
		case ApplyRecord of
			{} ->
				throw(?Guild_OperateApplicant_NoApplicant);
			_ -> ok
		end,

		case IsAllow of
			true ->
				%% 是否加入其它帮派
				OldMember = case guild_pub:find_guild_member(TargetPlayerID) of
								{} -> #guild_member{};
								MInfo -> MInfo
							end,

				case OldMember#guild_member.guildID of
					0 -> ok;
					_ ->
						delete_guild_applicant(ApplyRecord#guildApplicant.playerID, GuildID),
						throw(?Guild_OperateApplicant_IsOtherGuildMember)
				end,
				GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
									  #guild_member_maps{} = R -> R;
									  _ -> throw(?Guild_ChangeRank_NoGuild)
								  end,

				%% 是否超过帮会人数上限
				MemberCount = GuildMemberMaps#guild_member_maps.member_total,
				MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
				case MemberCount < MaxMemberCount of
					true -> ok;
					false -> throw(?Guild_OperateApplicant_MaxMemberCount)
				end,

				TargetPlayerIsOnline = case main:isOnline(TargetPlayerID) of
										   false -> 0;
										   true -> 1
									   end,
				NowTime = time:time(),
				TargetPlayer = mirror_player:get_player(TargetPlayerID),
				NewMember = OldMember#guild_member{
					guildID = GuildID,
					playerID = TargetPlayerID,
					rank = ?GuildRank_Normal,
					playerName = TargetPlayer#player.name,
					playerLevel = TargetPlayer#player.level,
					playerSex = TargetPlayer#player.sex,
					playerVip = TargetPlayer#player.vip,
					playerFrame = TargetPlayer#player.frame_id,
					playerNational = TargetPlayer#player.nationality_id,
					playerHeadID = TargetPlayer#player.head_id,
					battleValue = TargetPlayer#player.battleValue,
					isOnline = TargetPlayerIsOnline,
					joinTime = NowTime,
					lastOffTime = NowTime},

				NewMemberData = make_guild_member_data_msg(NewMember),
				ToMsg = #pk_GS2U_GuildMemberAdd{stData = NewMemberData},
				guild_pub:send_msg_to_all_member(GuildID, ToMsg),

				%% 加入新成员
				update_guild_member(NewMember),

				delete_player_app_guild(TargetPlayerID),
				guild_event:add_guild_event(GuildID, ?EventModule_1, 1, TargetPlayerID, []),
				gamedbProc:updatePlayerGuildQuitTime(GuildID, 0, TargetPlayerID),

%%				TargetPlayerText = richText:getPlayerTextByID(TargetPlayerID),
%%				guild_pub:send_guild_notice(GuildID, guildNotice_Desc1,
%%					fun(Language) ->
%%						language:format(language:get_server_string("GuildNotice_Desc1", Language), [TargetPlayerText])
%%					end),
				case main:isOnline(TargetPlayerID) of
					false ->
						ok;
					true ->
						main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerPropertyList, [{#player.guildID, GuildID}, {#player.quitGuildTime, 0}]}),
						m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_JoinGuildSuccess{guildID = GuildID, guildName = Guild#guild_base.guildName, isSuc = 1}),
						guildBattlefield:sendTaskInfo(Guild, TargetPlayerID),
						main:sendMsgToPlayerProcess(TargetPlayerID, {join_guild_after})
				end,
				case MemberCount + 1 =:= 30 of
					?TRUE ->
						[activity_new_player:on_active_condition_change_ex(MemberID, ?SalesActivity_Guild_MemberCount30, 1) || MemberID <-
							guild_pub:get_guild_member_id_list(GuildID), MemberID =/= TargetPlayerID];
					?FALSE -> ok
				end,
				activity_new_common:check_guild_active_condition(TargetPlayerID, GuildID),
				ok;
			_ ->
				m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_JoinGuildSuccess{guildID = GuildID, guildName = Guild#guild_base.guildName, isSuc = 0}),
				delete_guild_applicant(ApplyRecord#guildApplicant.playerID, GuildID)
		end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestGuildApplicantResult{result = 0})
	catch
		ErrorCode ->
			?LOG_INFO("GS2U_RequestGuildApplicantResult33333 ~p", [ErrorCode]),
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_RequestGuildApplicantResult{result = ErrorCode})
	end.

make_guild_member_data_msg(#guild_member{} = Member) ->
	#guildActivityCfg{access = AccessCfg} = cfg_guildActivity:first_row(),
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
	}.


%% 一键拒绝所有申请
onekey_refuse_guild_applicant(GuildID, PlayerID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_OperateApplicant_NoGuild);
			_ -> ok
		end,

		AppList = Guild#guild_base.applicantList,
		[m_send:sendMsgToClient(AppPlayer#guildApplicant.playerID, #pk_GS2U_JoinGuildSuccess{guildID = GuildID, guildName = Guild#guild_base.guildName, isSuc = 0}) ||
			AppPlayer <- AppList],
		update_guild(Guild#guild_base{applicantList = []}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_onkeyRefuseGuildAppResult{result = 0}),
		send_applicant_to_client(PlayerID, GuildID)
	catch
		ErrorCode -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_onkeyRefuseGuildAppResult{result = ErrorCode})
	end.

%% 删除玩家所有的申请记录
delete_player_app_guild(PlayerID) ->
	AllList = table_global:record_list(?TableGuild),
	Func = fun(#guild_base{applicantList = ApplyRecord} = Guild) ->
		case ApplyRecord of
			[] -> ok;
			_ ->
				case lists:keymember(PlayerID, #guildApplicant.playerID, Guild#guild_base.applicantList) of
					?TRUE ->
						NewApplicantList = lists:keydelete(PlayerID, #guildApplicant.playerID, Guild#guild_base.applicantList),
						update_guild(Guild#guild_base{applicantList = NewApplicantList});
					_ -> ok
				end
		end
		   end,
	[Func(GuildInfo) || GuildInfo <- AllList],
	ok.

%% 删除帮派中指定玩家的申请记录
delete_guild_applicant(AppID, GuildID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_OperateApplicant_NoGuild);
			_ -> ok
		end,
		case lists:keyfind(AppID, #guildApplicant.playerID, Guild#guild_base.applicantList) of
			{} -> throw(?Guild_ApplyInvite_NotGuildMember);
			_ -> ok
		end,
		NewApplicantList = lists:keydelete(AppID, #guildApplicant.playerID, Guild#guild_base.applicantList),
		update_guild(Guild#guild_base{applicantList = NewApplicantList})
	catch
		ErrorCode ->
			ErrorCode
	end.

%%修改帮派名称
player_msg_change_guild_name(_FromPID, _PlayerID, GuildID, NewGuildName) ->
	Guild = guild_pub:find_guild(GuildID),
	case Guild of
		{} -> ok;
		_ ->
			NewGuild = Guild#guild_base{guildName = NewGuildName, changeNameTime = time:time()},
			update_guild(NewGuild)
	end,
	case guild_pub:get_guild_member_maps(GuildID) of
		#guild_member_maps{member_list = MemberList} ->
			lists:foreach(fun({MemberID, _, _}) ->
				main:sendMsgToPlayerProcess(MemberID, {guild_name_changed})
						  end, MemberList);
		_ -> ok
	end.

%%邀请入帮的回复（同意）
player_msg_apply_invite(TargetPlayerID, {PlayerName, PlayerLevel, BattleValue, Sex, Vip, FrameId, NationAlityId}, GuildID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		TargetPlayerIsOnline =
			case main:isOnline(TargetPlayerID) of
				false -> 0;
				true -> 1
			end,

		GuildMember = guild_pub:find_guild_member(TargetPlayerID),
		case GuildMember =:= {} orelse GuildMember#guild_member.guildID =:= 0 of
			?TRUE -> ok;
			_ -> throw(ok)
		end,
		OldMember = case GuildMember of
						{} -> #guild_member{};
						MInfo -> MInfo
					end,
		NowTime = time:time(),
		NewMember = OldMember#guild_member{
			guildID = GuildID,
			playerID = TargetPlayerID,
			rank = ?GuildRank_Normal,
			playerName = PlayerName,
			playerLevel = PlayerLevel,
			playerHeadID = mirror_player:get_player_equip_head(TargetPlayerID),
			playerSex = Sex,
			playerVip = Vip,
			battleValue = BattleValue,
			playerFrame = FrameId,
			playerNational = NationAlityId,
			isOnline = TargetPlayerIsOnline,
			joinTime = NowTime,
			lastOffTime = NowTime},

		NewMemberData = make_guild_member_data_msg(NewMember),
		ToMsg = #pk_GS2U_GuildMemberAdd{stData = NewMemberData},
		guild_pub:send_msg_to_all_member(GuildID, ToMsg),

		delete_player_app_guild(TargetPlayerID),
		%% 加入新成员
		update_guild_member(NewMember),
		gamedbProc:updatePlayerGuildQuitTime(GuildID, 0, TargetPlayerID),
%%		add_guild_event(GuildID,TargetPlayerID,PlayerName,?GuildEvent_Join,0,0,0,NowTime),
		guild_event:add_guild_event(GuildID, ?EventModule_1, 1, TargetPlayerID, []),

%%		PlayerText = richText:getPlayerTextByID(TargetPlayerID),
%%		marquee:sendChannelNotice(guild_pub:get_guild_member_id_list(GuildID), GuildID, guildNotice_Desc1,
%%			fun(Language) ->
%%				language:format(language:get_server_string("GuildNotice_Desc1", Language), [PlayerText])
%%			end),

		case main:isOnline(TargetPlayerID) of
			false ->
				ok;
			true ->
				main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerPropertyList, [{#player.guildID, GuildID}, {#player.quitGuildTime, 0}]}),
				guildBattlefield:sendTaskInfo(Guild, TargetPlayerID),
				main:sendMsgToPlayerProcess(TargetPlayerID, {join_guild_after})
		end,
		case guild_pub:get_guild_member_num(GuildID) >= 30 of
			?TRUE ->
				[activity_new_player:on_active_condition_change_ex(MemberID, ?SalesActivity_Guild_MemberCount30, 1) || MemberID <-
					guild_pub:get_guild_member_id_list(GuildID), MemberID =/= TargetPlayerID];
			?FALSE -> ok
		end,
		activity_new_common:check_guild_active_condition(TargetPlayerID, GuildID),
		ok
	catch
		_ErrorCode ->
			ok
	end.

%% 玩家封天祭祀
player_msg_fete_god(PlayerID, GuildID, FeteID, Integral, ValidTimes, TaskAward) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		MemberList = case guild_pub:get_guild_member_maps(GuildID) of
						 #guild_member_maps{member_list = M} -> M;
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,
		case lists:keymember(PlayerID, 1, MemberList) of
			false -> throw(?Guild_FeteGod_noMember);
			_ -> ok
		end,

		FeteCount = length(Guild#guild_base.feteIDList),
		NewList =
			case lists:keytake(PlayerID, 1, Guild#guild_base.feteIDList) of
				?FALSE -> [{PlayerID, ValidTimes} | Guild#guild_base.feteIDList];
				{_, {_, Num}, DL} -> [{PlayerID, Num + ValidTimes} | DL]
			end,
		%% 战盟人数修改为X2
		NewGuild =
			case FeteCount < guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member) * 2 of
				?TRUE ->
					Guild#guild_base{feteValue = Guild#guild_base.feteValue + Integral, feteIDList = NewList};
				?FALSE ->
					Guild#guild_base{feteIDList = NewList}
			end,
		update_guild(NewGuild),

		guild_event:add_guild_event(GuildID, ?EventModule_1, 8, PlayerID, [FeteID, ValidTimes]),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_FeteGodResult{feteID = FeteID, sucTimes = ValidTimes, result = 0,
			reward_list = [#pk_key_value{key = I, value = N} || {I, N, _, _} <- TaskAward]})
	catch
		Result ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_FeteGodResult{feteID = FeteID, sucTimes = ValidTimes, result = Result})
	end.

%% 玩家领取奖励
player_msg_get_fete_god_award(PlayerID, GuildID, FeteIDList) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_FeteGod_noGuild);
			_ -> ok
		end,
		MemberInfo = guild_pub:find_guild_member(PlayerID),
		case MemberInfo#guild_member.guildID =:= GuildID of
			false -> throw(?Guild_FeteGod_noGuild);
			_ ->
				ok
		end,

		CfgList = [FeteGodCfg || FeteGodCfg <- [df:getGuildFeteCfg(FeteID) || FeteID <- FeteIDList], FeteGodCfg#guildSacrificeCfg.sacriType =:= ?FeteGod_Type_Award],
		case CfgList =/= [] of
			?TRUE -> ok;
			?FALSE ->
				throw(?Guild_FeteGod_wrongType)
		end,
		ValidFeteIDList = [FeteGodCfg#guildSacrificeCfg.iD || FeteGodCfg <- CfgList],
		FeteList = MemberInfo#guild_member.feteList ++ ValidFeteIDList,
		NewMember = MemberInfo#guild_member{feteList = FeteList},
		update_guild_member(NewMember, ?FALSE),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_getFeteGodAwardResult{feteIdList = ValidFeteIDList, result = 0})
	catch
		Code -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_getFeteGodAwardResult{feteIdList = FeteIDList, result = Code})
	end.

%% 重置数据
on_reset_data() ->
	NowTime = time:time(),
	IsWeek1 = time:day_of_week(NowTime) =:= 1,
	#guildActivityCfg{activity_personal = {_, QuitValue}, activity_Guild = {_, DisValue}, access = AccessCfg} = cfg_guildActivity:first_row(),
	%% 重置战盟
	Func = fun(GuildInfo) ->
		NewGuild = guildBattlefield:onResetDaily(GuildInfo),
		NewAcState = variant:setBit(NewGuild#guild_base.ac_state_mask, 1, 0),
		WishLimitNum = guild_pub:get_attr_value_by_index(GuildInfo#guild_base.building_list, ?Guild_WishNum),
		GuildLessDay = case GuildInfo#guild_base.active_value < DisValue of
						   ?TRUE -> GuildInfo#guild_base.active_less_day + 1;
						   ?FALSE -> 0
					   end,
		case IsWeek1 of
			?TRUE ->
				NewGuild#guild_base{feteValue = 0, feteIDList = [], wishList = [], ac_state_mask = NewAcState, eventList = [],
					moneyLog_list = [], treasure_chest = 0, treasure_chest_consume = 0, wish_limit_num = WishLimitNum, active_value = 0,
					active_less_day = GuildLessDay};
			?FALSE ->
				NewGuild#guild_base{feteValue = 0, feteIDList = [], wishList = [], ac_state_mask = NewAcState, eventList = [],
					moneyLog_list = [], wish_limit_num = WishLimitNum, active_value = 0, active_less_day = GuildLessDay}
		end
		   end,
	table_global:update_all_with(Func, ?TableGuild),

	%% 重置玩家祭祀数据
	SevenDaySec = min(df:getGlobalSetupValue(keepWishDays, 0) * ?DayTick_Seconds, ?WeekTick_Seconds),
	T2 = time:time_add(NowTime, -SevenDaySec),
	FeteFunc = fun(MemberInfo) ->
		NewGiveList = case MemberInfo#guild_member.giveList of
						  [#giveInfo{giveTime = GiveTime} | _] when GiveTime > T2 ->
							  MemberInfo#guild_member.giveList;
						  _ -> []
					  end,
		PersonLessDay = case MemberInfo#guild_member.guildID > 0 andalso guild_pub:calc_active_value(MemberInfo#guild_member.active_value_access, AccessCfg, 0) < QuitValue of
							?TRUE -> MemberInfo#guild_member.active_less_day + 1;
							?FALSE -> 0
						end,
		case IsWeek1 of
			?TRUE ->
				MemberInfo#guild_member{feteList = [], giveList = NewGiveList, weekly_prestige = 0, state_mark = 0, active_value_access = [],
					active_less_day = PersonLessDay};
			?FALSE ->
				MemberInfo#guild_member{feteList = [], giveList = NewGiveList, active_value_access = [], active_less_day = PersonLessDay}
		end
			   end,
	table_global:update_all_with(FeteFunc, ?TableGuildMember),
	do_check_trans_guild(),
%%	save_guild_rank_log(GuildList),
	ok.


%% 取消申请加入帮派
player_msg_cancel_join_guild(GuildID, PlayerID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_Join_NoGuild);
			_ -> ok
		end,
		AppList = Guild#guild_base.applicantList,

		case lists:keyfind(PlayerID, #guildApplicant.playerID, AppList) of
			false -> throw(?Guild_OperateApplicant_NoApplicant);
			_ -> ok
		end,
		MemberList = case guild_pub:get_guild_member_maps(GuildID) of
						 #guild_member_maps{member_list = M} -> M;
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,
		NewApplicantList = lists:keydelete(PlayerID, #guildApplicant.playerID, AppList),

		table_global:update_with(fun(R) ->
			R#guild_base{applicantList = NewApplicantList}
								 end, [GuildID], ?TableGuild),
		%%有申请 发送给帮主、太上长老、副帮主
		case main:isOnline(Guild#guild_base.chairmanPlayerID) of
			?TRUE -> send_applicant_to_client(Guild#guild_base.chairmanPlayerID, GuildID);
			_ -> ok
		end,

		Func = fun({MemberID, MemberRank, _}) ->
			case MemberRank =:= ?GuildRank_ViceChairman orelse MemberRank =:= ?GuildRank_SuperElder of
				?TRUE ->
					case main:isOnline(MemberID) of
						?TRUE -> send_applicant_to_client(MemberID, GuildID);
						_ -> ok
					end;
				_ -> ok
			end
			   end,
		lists:foreach(Func, MemberList),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_CancelJoinGuildResult{guildID = GuildID, result = 0})
	catch
		Result -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_CancelJoinGuildResult{guildID = GuildID, result = Result})
	end.

%% 条件进入
player_msg_enter_condition(GuildID, PlayerID, Type, Value) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_EnterCondition_NoGuild);
			_ -> ok
		end,
		MemberList = case guild_pub:get_guild_member_maps(GuildID) of
						 #guild_member_maps{member_list = M} -> M;
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,
		Rank =
			case lists:keyfind(PlayerID, 1, MemberList) of
				false -> throw(?Guild_EnterCondition_NoMember);
				{_, Rk, _} -> Rk
			end,

		case Rank >= ?GuildRank_ViceChairman of
			?TRUE -> ok;
			?FALSE -> throw(?Guild_EnterCondition_NoPermission)
		end,

		NewCondition =
			case lists:keyfind(Type, 1, Guild#guild_base.enterCondition) of
				false -> [{Type, Value}];
				_ -> lists:keyreplace(Type, 1, Guild#guild_base.enterCondition, {Type, Value})
			end,

		NewGuild = Guild#guild_base{enterCondition = NewCondition},
		update_guild(NewGuild),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_addGuildConditionResult{type = Type, value = Value, result = 0})
	catch
		Result ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_addGuildConditionResult{type = Type, value = Value, result = Result})
	end.

%% 设置自动加入
player_msg_set_auto_join(GuildID, PlayerID, AutoJoin) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_EnterCondition_NoGuild);
			_ -> ok
		end,

		MemberList = case guild_pub:get_guild_member_maps(GuildID) of
						 #guild_member_maps{member_list = M} -> M;
						 _ -> throw(?ErrorCode_Guild_NoGuild)
					 end,
		Rank =
			case lists:keyfind(PlayerID, 1, MemberList) of
				false -> throw(?Guild_EnterCondition_NoMember);
				{_, Rk, _} -> Rk
			end,

		case Rank >= ?GuildRank_ViceChairman of
			?TRUE -> ok;
			?FALSE -> throw(?Guild_EnterCondition_NoPermission)
		end,


		NewGuild = Guild#guild_base{autoJoin = AutoJoin},
		update_guild(NewGuild),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_setAutoJoinGuildResult{autoJoin = AutoJoin, result = 0})
	catch
		Result ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_setAutoJoinGuildResult{autoJoin = AutoJoin, result = Result})
	end.

%% 条件进入
condition_enter_guild(GuildID, TargetPlayerID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		case Guild of
			{} -> throw(?Guild_OperateApplicant_NoGuild);
			_ -> ok
		end,

		TargetMember = guild_pub:find_guild_member(TargetPlayerID),
		case TargetMember =:= {} orelse TargetMember#guild_member.guildID =:= 0 of
			?TRUE -> ok;
			_ ->
				delete_guild_applicant(TargetPlayerID, GuildID),
				throw(?Guild_OperateApplicant_IsOtherGuildMember)
		end,

		GuildMemberMaps = case guild_pub:get_guild_member_maps(GuildID) of
							  #guild_member_maps{} = R -> R;
							  _ -> throw(?Guild_ChangeRank_NoGuild)
						  end,
		case lists:keyfind(TargetPlayerID, 1, GuildMemberMaps#guild_member_maps.member_list) of
			false -> ok;
			_ -> throw(?Guild_OperateApplicant_IsOtherGuildMember)
		end,

		%% 是否超过帮会人数上限
		MemberCount = GuildMemberMaps#guild_member_maps.member_total,
		MaxMemberCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Member),
		case MemberCount < MaxMemberCount of
			true -> ok;
			false -> throw(?Guild_OperateApplicant_MaxMemberCount)
		end,

		TargetPlayerIsOnline = case main:isOnline(TargetPlayerID) of
								   false -> 0;
								   true -> 1
							   end,
		NowTime = time:time(),
		MirrorPlayer = mirror_player:get_player(TargetPlayerID),

		OldGuildMember = case TargetMember of
							 {} -> #guild_member{};
							 MInfo -> MInfo
						 end,
		NewMember = OldGuildMember#guild_member{
			guildID = GuildID,
			playerID = TargetPlayerID,
			rank = ?GuildRank_Normal,
			playerName = MirrorPlayer#player.name,
			playerLevel = MirrorPlayer#player.level,
			playerSex = MirrorPlayer#player.sex,
			playerVip = MirrorPlayer#player.vip,
			battleValue = MirrorPlayer#player.battleValue,
			playerFrame = MirrorPlayer#player.frame_id,
			playerNational = MirrorPlayer#player.nationality_id,
			playerHeadID = mirror_player:get_player_equip_head(TargetPlayerID),
			isOnline = TargetPlayerIsOnline,
			joinTime = NowTime,
			lastOffTime = NowTime},


		NewMemberData = make_guild_member_data_msg(NewMember),
		ToMsg = #pk_GS2U_GuildMemberAdd{stData = NewMemberData},
		guild_pub:send_msg_to_all_member(GuildID, ToMsg),

		%% 加入新成员
		update_guild_member(NewMember),

		delete_player_app_guild(TargetPlayerID),
		guild_event:add_guild_event(GuildID, ?EventModule_1, 1, TargetPlayerID, []),
%%		TargetPlayerText = richText:getPlayerTextByID(TargetPlayerID),
%%		guild_pub:send_guild_notice(GuildID, guildNotice_Desc1,
%%			fun(Language) ->
%%				language:format(language:get_server_string("GuildNotice_Desc1", Language), [TargetPlayerText])
%%			end),

		gamedbProc:updatePlayerGuildQuitTime(GuildID, 0, TargetPlayerID),
		case main:isOnline(TargetPlayerID) of
			false -> ok;
			true ->
				m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_RequestJoinGuildResult{result = 0}),
				main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerPropertyList, [{#player.guildID, GuildID}, {#player.quitGuildTime, 0}]}),
				m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_JoinGuildSuccess{guildID = GuildID, guildName = Guild#guild_base.guildName, isSuc = 1}),
				guildBattlefield:sendTaskInfo(Guild, TargetPlayerID),
				main:sendMsgToPlayerProcess(TargetPlayerID, {join_guild_after})
		end,
		case MemberCount + 1 =:= 30 of
			?TRUE ->
				[activity_new_player:on_active_condition_change_ex(MemberID, ?SalesActivity_Guild_MemberCount30, 1) || MemberID <-
					guild_pub:get_guild_member_id_list(GuildID), MemberID =/= TargetPlayerID];
			?FALSE -> ok
		end,
		activity_new_common:check_guild_active_condition(TargetPlayerID, GuildID),
		ok
	catch
		Code -> m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_RequestJoinGuildResult{result = Code})
	end.

%%  ----------LOCAL FUNCTION------------------------------------------------------ %%
get_guild_info(0) -> {};
get_guild_info(GuildID) ->
	case guild_pub:find_guild(GuildID) of
		{} -> {};
		Info -> Info
	end.

is_guild_master(PlayerID) ->
	case guild_pub:find_guild_member(PlayerID) of
		#guild_member{guildID = Gid, rank = Rank} when Gid > 0 -> Rank =:= ?GuildRank_Chairman;
		_ -> ?FALSE
	end.

is_guild_master_1(PlayerID) ->
	case guild_pub:find_guild_member(PlayerID) of
		#guild_member{rank = Rank, guildID = GuildID} when GuildID > 0 ->
			case Rank =:= ?GuildRank_Chairman of
				?TRUE ->
					case guild_pub:find_guild(GuildID) of
						#guild_base{creatorID = PlayerID} -> ?TRUE;
						_ -> ?FALSE
					end;
				_ -> ?FALSE
			end;
		_ -> ?FALSE
	end.


%%解散帮派
on_disband_guild(GuildID) ->
	%%帮派记录
	Guild = guild_pub:find_guild(GuildID),
	case Guild of
		{} -> ok;
		_ ->
			NowTime = time:time(),
			%%通知在线帮会成员，离帮时间
			MemberList = guild_pub:get_guild_member_id_list(GuildID),
			MemberFun = fun(MemberID) ->
				case main:isOnline(MemberID) of
					?FALSE ->
						gamedbProc:updatePlayerGuildQuitTime(0, NowTime, [MemberID]);
					_ ->
						main:sendMsgToPlayerProcess(MemberID, {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, NowTime}]}),
						main:sendMsgToPlayerProcess(MemberID, {guild_quit}),
						trading_market:send_2_me({guild_quit, MemberID}),
						m_send:sendMsgToClient(MemberID, #pk_GS2U_RequestGuildQuitResult{result = 1})
				end
						end,
			lists:foreach(MemberFun, MemberList),

			%%  因解散公会而清理数据
			cluster:cast_master(?BattlefieldPID, {deleteGuildRank, GuildID}),
			%% 猎魔 工会解散清理数据
			dh_otp:send_2_master({dh_guild_disband, GuildID}),
%%			guild_event:add_guild_event(GuildID, ?EventModule_1, 3, Guild#guild_base.chairmanPlayerID, []),
			PlayerText = richText:getPlayerTextByID(Guild#guild_base.chairmanPlayerID),
			guild_pub:send_guild_notice(GuildID, guildNewNotice7,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice7", Language), [PlayerText])
				end),

			delete_guild(GuildID),
			table_global:update_with(fun clear_member_fun/1, MemberList, ?TableGuildMember),
			red_envelope:clean_red_envelope_info_when_delete_guild(Guild#guild_base.id),
			guild_envelope ! {on_guild_dismiss, GuildID},
			guild_event ! {on_guild_dismiss, GuildID},
			domain_fight:send_2_me({on_guild_dismiss, GuildID}),
			guild_instance_zones:send_2_me({on_guild_dismiss, GuildID}),
%%			demon_guild_server:send_2_me({on_guild_dismiss, GuildID}),
			logdbProc:log_guildchange(GuildID, Guild#guild_base.guildName,
				language:get_server_string("guildChange_dismiss", ""), Guild#guild_base.chairmanPlayerID, 0, 0, 0, 0, NowTime),
			ok
	end.

check_auto_disband_guild() ->
	%%帮派记录
	AllGuild = table_global:record_list(?TableGuild),
	#guildActivityCfg{activity_Guild = {DisDay, DisValue}} = cfg_guildActivity:first_row(),
	lists:foreach(fun(#guild_base{id = GuildID, active_value = ActiveValue, active_less_day = LessDay} = Guild) ->
		case ActiveValue < DisValue andalso LessDay + 1 >= DisDay andalso guild_knight:check_dissolve_guild(GuildID) of
			?TRUE ->
				NowTime = time:time(),
				%%通知在线帮会成员，离帮时间
				MemberList = guild_pub:get_guild_member_id_list(GuildID),
				MemberFun = fun(MemberID) ->
					case main:isOnline(MemberID) of
						?FALSE ->
							gamedbProc:updatePlayerGuildQuitTime(0, 0, [MemberID]);
						_ ->
							main:sendMsgToPlayerProcess(MemberID, {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, 0}]}),
							main:sendMsgToPlayerProcess(MemberID, {guild_quit}),
							trading_market:send_2_me({guild_quit, MemberID}),
							m_send:sendMsgToClient(MemberID, #pk_GS2U_RequestGuildQuitResult{result = 1})
					end,
					Language = language:get_player_language(MemberID),
					mail:send_mail(#mailInfo{
						player_id = MemberID,
						title = language:get_server_string("D3_GHXG_Mail03", Language),
						describe = language:get_server_string("D3_GHXG_Mail04", Language, [DisDay, DisValue]),
						attachmentReason = ?Reason_Guild_Active_Less
					})
							end,
				lists:foreach(MemberFun, MemberList),

				%%  因解散公会而清理数据
				cluster:cast_master(?BattlefieldPID, {deleteGuildRank, GuildID}),
				%% 猎魔 工会解散清理数据
				dh_otp:send_2_master({dh_guild_disband, GuildID}),
				delete_guild(GuildID),
				table_global:update_with(fun clear_member_fun/1, MemberList, ?TableGuildMember),
				red_envelope:clean_red_envelope_info_when_delete_guild(GuildID),
				guild_envelope ! {on_guild_dismiss, GuildID},
				guild_event ! {on_guild_dismiss, GuildID},
				domain_fight:send_2_me({on_guild_dismiss, GuildID}),
%%				demon_guild_server:send_2_me({on_guild_dismiss, GuildID}),
				logdbProc:log_guildchange(GuildID, Guild#guild_base.guildName,
					"auto_dismiss", Guild#guild_base.chairmanPlayerID, 0, 0, 0, 0, NowTime),
				ok;
			?FALSE -> skip
		end
				  end, AllGuild).

check_auto_quit_player() ->
	#guildActivityCfg{access = AccessCfg, activity_personal = {QuitDay, QuitValue}} = cfg_guildActivity:first_row(),
	etsBaseFunc:etsFor(?Ets_GuildMemberMaps,
		fun
			(#guild_member_maps{member_list = [_]}) -> skip; %% 剩一个人不处理
			(#guild_member_maps{guild_id = GuildID, member_list = MemberList}) ->
				lists:foreach(fun({TargetPlayerID, _, _}) ->
					case guild_pub:find_guild_member(TargetPlayerID) of
						#guild_member{guildID = GuildID, rank = Rank, active_value_access = AccessList, active_less_day = LessDay} ->
							case guild_pub:calc_active_value(AccessList, AccessCfg, 0) < QuitValue andalso LessDay + 1 >= QuitDay andalso Rank =/= ?GuildRank_Chairman of
								?TRUE ->
									delete_guild_member(GuildID, TargetPlayerID),
									guild_wish:del_wish_info(GuildID, TargetPlayerID),
									guild_event:add_guild_event(GuildID, ?EventModule_1, 4, TargetPlayerID, []),
									case main:isOnline(TargetPlayerID) of
										?FALSE ->
											gamedbProc:updatePlayerGuildQuitTime(0, 0, [TargetPlayerID]);
										_ ->
											main:sendMsgToPlayerProcess(TargetPlayerID, {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, 0}]}),
											main:sendMsgToPlayerProcess(TargetPlayerID, {guild_quit}),
											trading_market:send_2_me({guild_quit, TargetPlayerID}),
											m_send:sendMsgToClient(TargetPlayerID, #pk_GS2U_KickOutGuild{})
									end,
									Language = language:get_player_language(TargetPlayerID),
									mail:send_mail(#mailInfo{
										player_id = TargetPlayerID,
										title = language:get_server_string("D3_GHXG_Mail01", Language),
										describe = language:get_server_string("D3_GHXG_Mail02", Language, [QuitDay, QuitValue]),
										attachmentReason = ?Reason_Guild_Active_Less
									});
								?FALSE -> skip
							end;
						_ -> ok
					end
							  end, MemberList)
		end).

%% 升级战盟建筑
up_level_building(PlayerID, GuildID, BuildingID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		{_, Level} = case lists:keyfind(BuildingID, 1, Guild#guild_base.building_list) of
						 ?FALSE -> throw(?ErrorCode_Guild_NoGuild);
						 R -> R
					 end,
		NewLevel = Level + 1,
		Cfg = cfg_guildBuilding:getRow(BuildingID, NewLevel),
		?CHECK_THROW(Cfg =/= {}, ?ERROR_Cfg),
		case Guild#guild_base.building_materials >= Cfg#guildBuildingCfg.needItem of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Guild_MoneyEnough)
		end,
		NewBuilding = lists:keyreplace(BuildingID, 1, Guild#guild_base.building_list, {BuildingID, NewLevel}),
		NewGuild = Guild#guild_base{building_materials = Guild#guild_base.building_materials - Cfg#guildBuildingCfg.needItem, building_list = NewBuilding},
		update_guild(NewGuild),

		guild_event:add_guild_event(GuildID, ?EventModule_1, 7, PlayerID, [BuildingID, NewLevel]),
		%% 公告
		Params = [richText:getPlayerTextByID(PlayerID), NewLevel],
		guild_pub:get_building_msg_index(BuildingID, GuildID, Params),
		logdbProc:log_guild_building(GuildID, PlayerID, BuildingID, NewLevel),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_uplevelGuildBuildingResult{buildingID = BuildingID, result = 0}),
		case BuildingID of
			?GuildBuilding_Lobby ->
				case NewLevel >= 2 of
					?TRUE ->
						[activity_new_player:on_active_condition_change_ex(MemberID, ?SalesActivity_Guild_GuildLv2, 1) || MemberID <-
							guild_pub:get_guild_member_id_list(GuildID)];
					?FALSE -> ok
				end,
				case NewLevel >= 3 of
					?TRUE ->
						[activity_new_player:on_active_condition_change_ex(MemberID, ?SalesActivity_Guild_GuildLv3, 1) || MemberID <-
							guild_pub:get_guild_member_id_list(GuildID)];
					?FALSE -> ok
				end;
			_ -> ok
		end
	catch
		Result ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_uplevelGuildBuildingResult{buildingID = BuildingID, result = Result})
	end.

do_check_trans_guild() ->
	Func = fun(Guild, Acc) ->
		check_check_trans_guild(Guild),
		Acc
		   end,
	table_global:fold(Func, ok, ?TableGuild).

%% 仙盟检查
check_check_trans_guild(Guild) ->
	try
		ChairmanID = Guild#guild_base.chairmanPlayerID,
		GuildID = Guild#guild_base.id,
		#guildActivityCfg{activity_personal = {QuitDay, QuitValue}} = cfg_guildActivity:first_row(),
		case guild_pub:find_guild_member(ChairmanID) of
			#guild_member{active_less_day = LessDay} when LessDay >= QuitDay ->
				F = fun(Rank) ->
					check_rank_member(Guild, Rank)
					end,
				case lists:any(F, [?GuildRank_SuperElder, ?GuildRank_ViceChairman, ?GuildRank_Elder, ?GuildRank_Elite, ?GuildRank_Normal]) of
					?TRUE ->
						delete_guild_member(GuildID, ChairmanID),
						guild_wish:del_wish_info(GuildID, ChairmanID),
						guild_event:add_guild_event(GuildID, ?EventModule_1, 4, ChairmanID, []),
						case main:isOnline(ChairmanID) of
							?FALSE ->
								gamedbProc:updatePlayerGuildQuitTime(0, 0, [ChairmanID]);
							_ ->
								main:sendMsgToPlayerProcess(ChairmanID, {changePlayerPropertyList, [{#player.guildID, 0}, {#player.quitGuildTime, 0}]}),
								main:sendMsgToPlayerProcess(ChairmanID, {guild_quit}),
								trading_market:send_2_me({guild_quit, ChairmanID}),
								m_send:sendMsgToClient(ChairmanID, #pk_GS2U_KickOutGuild{})
						end,
						Language = language:get_player_language(ChairmanID),
						mail:send_mail(#mailInfo{
							player_id = ChairmanID,
							title = language:get_server_string("D3_GHXG_Mail01", Language),
							describe = language:get_server_string("D3_GHXG_Mail02", Language, [QuitDay, QuitValue]),
							attachmentReason = ?Reason_Guild_Active_Less
						});
					?FALSE -> ok
				end;
			_ -> ok
		end,
		ok
	catch
		_Why ->
			?FALSE
	end.

%% 成员排名
sort_members(?AssignRuleWeeklyContribute, Members) ->
	Func =
		fun(M1, M2) ->
			case M1#guild_member.weekly_prestige > M2#guild_member.weekly_prestige of
				?TRUE -> ?TRUE;
				?FALSE ->
					case M1#guild_member.weekly_prestige =:= M2#guild_member.weekly_prestige of
						?TRUE ->
							M1#guild_member.battleValue >= M1#guild_member.battleValue;
						?FALSE -> ?FALSE
					end
			end
		end,
	lists:sort(Func, Members);
sort_members(?AssignRuleBattleValue, Members) ->
	Func =
		fun(M1, M2) ->
			case M1#guild_member.battleValue > M2#guild_member.battleValue of
				?TRUE -> ?TRUE;
				?FALSE ->
					case M1#guild_member.battleValue =:= M2#guild_member.battleValue of
						?TRUE ->
							M1#guild_member.prestige >= M1#guild_member.prestige;
						?FALSE -> ?FALSE
					end
			end
		end,
	lists:sort(Func, Members);
sort_members(?AssignRuleLevel, Members) ->
	Func =
		fun(M1, M2) ->
			case M1#guild_member.playerLevel > M2#guild_member.playerLevel of
				?TRUE -> ?TRUE;
				?FALSE ->
					case M1#guild_member.playerLevel =:= M2#guild_member.playerLevel of
						?TRUE ->
							M1#guild_member.battleValue >= M1#guild_member.battleValue;
						?FALSE -> ?FALSE
					end
			end
		end,
	lists:sort(Func, Members);
sort_members(_, Members) ->
	Func =
		fun(M1, M2) ->
			case M1#guild_member.prestige > M2#guild_member.prestige of
				?TRUE -> ?TRUE;
				?FALSE ->
					case M1#guild_member.prestige =:= M2#guild_member.prestige of
						?TRUE ->
							M1#guild_member.battleValue >= M1#guild_member.battleValue;
						?FALSE -> ?FALSE
					end
			end
		end,
	lists:sort(Func, Members).

%% 检查成员离线信息
check_rank_member(Guild, Rank) ->
	GuildCheckTime = df:getGlobalSetupValue(guildJobMakeTime, (?SECONDS_PER_DAY * 15)),
	NowTime = time:time(),
	Func =
		fun(MemberID) ->
			case main:isOnline(MemberID) of
				?TRUE -> MemberID;
				?FALSE ->
					%% 检查是否下线guildJobMakeTime
					OfflineTime = mirror_player:get_player_offline_time(MemberID),
					case NowTime > time:time_add(OfflineTime, GuildCheckTime) of
						?TRUE -> ok;
						?FALSE -> MemberID
					end
			end
		end,

	RankMembers = guild_pub:get_guild_member_list_by_rank(Guild#guild_base.id, Rank),
	MemberList = common:listsFiterMap(Func, RankMembers),
	case length(MemberList) > 0 of
		?TRUE ->
			Chairman = guild_pub:find_guild_member(Guild#guild_base.chairmanPlayerID),
			[NewChair | _] = sort_members(0, [MemberR || ID <- MemberList, (MemberR = guild_pub:find_guild_member(ID)) =/= {}]),
			change_chairman(Guild, Chairman, NewChair),
			?TRUE;
		?FALSE -> ?FALSE
	end.

%% 转让盟主(强制)
change_chairman(Guild, OldChair, NewChair) ->
	NewMemberList1 = NewChair#guild_member{rank = ?GuildRank_Chairman},
	NewMemberList2 = OldChair#guild_member{rank = ?GuildRank_Normal},
	NewGuild = Guild#guild_base{chairmanPlayerID = NewChair#guild_member.playerID, chairmanPlayerName = NewChair#guild_member.playerName},
	update_guild_member(NewMemberList1),
	update_guild_member(NewMemberList2),
	update_guild(NewGuild),
	%% 帮主变为成员
	ToMsg0 = #pk_GS2U_GuildMemberRankChangedResult{result = ?ERROR_OK, nPlayerID = OldChair#guild_member.playerID, nNewRank = ?GuildRank_Normal},
	guild_pub:send_msg_to_all_member(Guild#guild_base.id, ToMsg0).

%% 删除仙盟（ETS表，数据库（仙盟基础属性，成员表，申请表））
delete_guild_data(Guild) ->
	GuildID = Guild#guild_base.id,
	Func = fun(PlayerID) ->
		PID = main:getPlayerPID(PlayerID),
		case PID =:= 0 of
			?TRUE -> ok;
			?FALSE -> PID ! {changePlayerPropertyList, [{#player.guildID, 0}]}
		end
		   end,
	MemberList = guild_pub:get_guild_member_id_list(GuildID),
	lists:foreach(Func, MemberList),
	delete_guild(GuildID),
	table_global:update_with(fun clear_member_fun/1, MemberList, ?TableGuildMember),
	%% battlefield_031_00_02 因解散公会而清理数据
	cluster:cast_master(?BattlefieldPID, {deleteGuildRank, GuildID}),
	%% 猎魔 工会解散清理数据
	dh_otp:send_2_master({dh_guild_disband, GuildID}),
	guild_envelope ! {on_guild_dismiss, GuildID},
	guild_event ! {on_guild_dismiss, GuildID},
	logdbProc:log_guildchange(GuildID, Guild#guild_base.guildName,
		language:get_server_string("guildChange_SystemDelete", ""), 0, 0, 0, 0, 0, time:time()).

%% 合服处理超过1000个仙盟的情况，删掉1000以后的仙盟
do_server_clear_guild() ->
	try
		case table_global:size(?TableGuild) > ?Guild_Max_Count of
			?TRUE -> ok;
			?FALSE -> throw(1)
		end,
		SortList = guild_pub:sort_guild(),
		DelList = lists:nthtail(?Guild_Max_Count, SortList),
		Func = fun(GuildInfo) ->
			delete_guild_data(GuildInfo)
			   end,
		lists:foreach(Func, DelList)
	catch
		Why ->
			Why
	end.

%%%% 保存仙盟排名到数据库
%%save_guild_rank_log(GuildList) ->
%%	SortList = guild_pub:sort_guild(GuildList),
%%	NowTime = time:time(),
%%	Func = fun(Guild, Num) ->
%%		LogData = #guildRank_logdata{
%%			guildID = Guild#guild_base.id,
%%			guildName = Guild#guild_base.guildName,
%%			chairPlayerID = Guild#guild_base.chairmanPlayerID,
%%			chairName = Guild#guild_base.chairmanPlayerName,
%%			rank = Num,
%%			level = guild_pub:get_guild_level(Guild#guild_base.id),
%%			memberCount = guild_pub:get_guild_member_num(Guild#guild_base.id),
%%			guildBattleValue = guild_pub:get_guild_total_battle_value(Guild),
%%			createTime = Guild#guild_base.createTime,
%%			saveTime = NowTime
%%		},
%%		logdbProc:log_guildrank(LogData),
%%		Num + 1
%%		   end,
%%	lists:foldl(Func, 1, SortList).


%% 查询是否可以参加军团活动 一次活动只能打一把 AcId: 1-守卫战盟   2-领地战下一次是否可以宣战2级领地
get_guild_ac_state(GuildID, AcId) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{ac_state_mask = Mask} ->
			variant:isBitOn(Mask, AcId);
		_ -> ?FALSE
	end.

on_set_guild_ac_state(ActiveID, Status) ->
	lists:foreach(
		fun(#guild_base{id = GuildID}) ->
			guildPID ! {set_guild_ac_state, GuildID, ActiveID, Status}
		end,
		table_global:record_list(?TableGuild)).
on_set_guild_ac_state(GuildID, ActiveID, Status) -> guildPID ! {set_guild_ac_state, GuildID, ActiveID, Status}.
set_guild_ac_state(GuildID, AcId, State) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{ac_state_mask = Mask} = Info ->
			NewMask = variant:setBit(Mask, AcId, State),
			update_guild(Info#guild_base{ac_state_mask = NewMask}),
			case AcId =:= 1 of
				?TRUE ->
					guild_pub:send_msg_to_all_member(GuildID, #pk_GS2U_GuildGuardAcIsSettle{is_settle = ?TRUE});
				_ -> skip
			end;
		_Info ->
			skip
	end.

%% 分配宝箱
assign_treasure_chest(GuildId, PlayerID, MPlayerIDList) ->
	try
		Guild = guild_pub:find_guild(GuildId),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		Rank = guild_pub:get_member_rank(GuildId, PlayerID),
		?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
		ContributeLimit = cfg_globalSetup:needGuildFame(),
		FilterFun = fun(MemberID) ->
			case guild_pub:find_guild_member(MemberID) of
				#guild_member{guildID = GuildId, weekly_prestige = WeeklyContribute, state_mark = Mark}
					when WeeklyContribute >= ContributeLimit -> not variant:isBitOn(Mark, ?StateMaskChest);
				_ -> ?FALSE
			end
					end,
		PlayerIDList = lists:filter(FilterFun, MPlayerIDList),
		?CHECK_THROW(PlayerIDList =/= [], ?ErrorCode_Guild_ChestNum),
		CanUseNum = guild_pub:get_guild_usable_chest(Guild),
		ConsumeNum = length(PlayerIDList),
		?CHECK_THROW(CanUseNum >= ConsumeNum, ?ErrorCode_Guild_ChestNum),
		do_treasure_chest_award(1, PlayerIDList),
		update_guild(Guild#guild_base{treasure_chest_consume = Guild#guild_base.treasure_chest_consume + ConsumeNum}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_assign_treasure_chest_ret{id_list = PlayerIDList, err_code = ?ERROR_OK})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_assign_treasure_chest_ret{id_list = [], err_code = Err})
	end.

assign_guild_award(?AssignAwardTypeGuildInsZones = Type, GuildID, PlayerID, AssignPlayerID, ItemID) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		Rank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
		#guild_assign_award{list = List, log_list = LogList} = Data = case table_global:lookup(?TableGuildAssignAward, {GuildID, Type}) of
																		  [] -> throw(?ErrorCode_Guild_NoAssignAward);
																		  [Info] -> Info
																	  end,
		MemberData = case guild_pub:find_guild_member(AssignPlayerID) of
						 #guild_member{guildID = GuildID, state_mark = StateMark} = Member ->
							 ?CHECK_THROW(not variant:isBitOn(StateMark, ?StateGuildInsZoneAssign), ?ErrorCode_Guild_HasAssignAward),
							 Member;
						 _ -> throw(?Guild_Error_NoMember)
					 end,
		{IsSuccess, NewList} = assign_guild_award_item(List, ItemID, AssignPlayerID, []),
		?CHECK_THROW(IsSuccess, ?ErrorCode_Guild_NoAssignAward),
		ChairmanName = richText:getPlayerTextByID(PlayerID),
		NewLogList = lists:sublist([{1, ChairmanName, ItemID, richText:getPlayerTextByID(AssignPlayerID), time:time()} | LogList], 20),
		NewData = Data#guild_assign_award{list = NewList, log_list = NewLogList},
		table_global:insert(?TableGuildAssignAward, NewData),
		NewMemberData = MemberData#guild_member{state_mark = variant:setBit(MemberData#guild_member.state_mark, ?StateGuildInsZoneAssign, 1)},
		update_guild_member(NewMemberData, ?FALSE),
		mail:send_mail(#mailInfo{
			player_id = AssignPlayerID,
			title = "【没有文字】公会副本",
			describe = language:format("【没有文字】公会会长~1ts公会副本玩法中分配给你~2ts", [ChairmanName, richText:getItemListText([{ItemID, 1}], "ZH_CN")]),
			itemList = [#itemInfo{itemID = ItemID, num = 1, isBind = 1}],
			attachmentReason = ?Reason_Guild_Assign_Award
		}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_assign_award_to_ret{type = Type, item_id = ItemID, player_id = AssignPlayerID, err_code = ?ERROR_OK})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_assign_award_to_ret{type = Type, item_id = ItemID, player_id = AssignPlayerID, err_code = Err})
	end.

assign_guild_award_item([], _ItemID, _PlayerID, _Ret) ->
	{?FALSE, []};
assign_guild_award_item([#guild_assign_award_item{item_id = ItemID, is_assign = 0} = Data | T], ItemID, PlayerID, Ret) ->
	{?TRUE, [Data#guild_assign_award_item{item_id = ItemID, is_assign = 1, belong_player_name = richText:getPlayerTextByID(PlayerID)} | T] ++ Ret};
assign_guild_award_item([Item | T], ItemID, PlayerID, Ret) ->
	assign_guild_award_item(T, ItemID, PlayerID, [Item | Ret]).

%% 设置宝箱分配规则
assign_treasure_rule_set(PlayerID, GuildID, Rule) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		Rank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
		update_guild(Guild#guild_base{treasure_assign_rule = Rule}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_assign_treasure_rule_set_ret{rule = Rule, err_code = ?ERROR_OK})
	catch
		Err -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_assign_treasure_rule_set_ret{rule = Rule, err_code = Err})
	end.
%% 分配奖励自动分配规则
assign_award_rule_set({PlayerID, GuildID, ?AssignAwardTypeGuildInsZones = Type, Rule}) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		Rank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
		update_guild(Guild#guild_base{guild_ins_zones_assign_rule = Rule}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_assign_award_rule_set_ret{type = Type, rule = Rule, err_code = ?ERROR_OK})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_assign_award_rule_set_ret{type = Type, rule = Rule, err_code = Err})
	end.

%% 21点重置
on_reset_21() ->
	case time:day_of_week(time:time()) of
		7 ->
			table_global:update_all_with(fun(#guild_base{id = GuildID, treasure_assign_rule = AssRule, treasure_chest_consume = OldNum} = Guild) ->
				CanUseNum = guild_pub:get_guild_usable_chest(Guild),
				case CanUseNum > 0 of
					?TRUE ->
						case AssRule =/= ?AssignRuleNull of
							?TRUE ->
								ContributeLimit = cfg_globalSetup:needGuildFame(),
								MemberList = sort_members(AssRule, [MemberR || {ID, _, _} <- guild_pub:get_guild_maps_member(GuildID),
									(MemberR = guild_pub:find_guild_member(ID)) =/= {}]),
								AwardPlayerIDList = [R#guild_member.playerID || R <- lists:sublist(MemberList, CanUseNum),
									R#guild_member.weekly_prestige >= ContributeLimit andalso not variant:isBitOn(R#guild_member.state_mark, ?StateMaskChest)],
								do_treasure_chest_award(2, AwardPlayerIDList),
								?LOG_INFO("auto award, guild_id ~p, rule ~p, player_list ~p", [GuildID, AssRule, AwardPlayerIDList]);
							?FALSE ->
								?LOG_INFO("auto award, guild_id ~p, rule ~p", [GuildID, AssRule])
						end,
						Guild#guild_base{treasure_chest_consume = OldNum + CanUseNum};
					?FALSE ->
						Guild
				end
										 end, ?TableGuild);
		_ -> ok
	end.

do_treasure_chest_award(Way, PlayerIDList) ->
	#guildTreasuryGiftCfg{worldLv = WorldLv, acquireGift = Gift} = cfg_guildTreasuryGift:first_row(),
	{_, AwardID} = common:getValueByInterval(world_level:get_world_level(), WorldLv, {0, 0}),
	DropList = [{P2, P3, P4, P5, P6} || {P1, P2, P3, P4, P5, P6} <- Gift, P1 =:= AwardID],
	AssignFun = fun(#guild_member{playerID = MemberID, guildID = GuildID, playerLevel = PlayerLevel, state_mark = StateMark} = Info) ->
		{ItemList, EquipmentList, CurrencyList, _} = drop:drop(DropList, [], MemberID, 0, PlayerLevel),
		Language = language:get_player_language(MemberID),
		mail:send_mail(#mailInfo{
			player_id = MemberID,
			title = language:get_server_string("BaoKuMail1", Language),
			describe = language:get_server_string("BaoKuMail2", Language),
			coinList = [#coinInfo{type = CfgId, num = Amount, reason = ?Reason_Treasure_Chest} || {CfgId, Amount} <- CurrencyList],
			itemList = [#itemInfo{itemID = CfgId, num = Amount, isBind = Bind} || {CfgId, Amount, Bind, _} <- ItemList],
			itemInstance = EquipmentList,
			attachmentReason = ?Reason_Treasure_Chest
		}),
		guild_event:add_guild_event(GuildID, ?EventModule_4, Way, MemberID, []),
		Info#guild_member{state_mark = variant:setBit(StateMark, ?StateMaskChest, 1)}
				end,
	table_global:update_with(AssignFun, PlayerIDList, ?TableGuildMember).

clear_member_fun(Info) ->
	Info#guild_member{
		guildID = 0,
		rank = 0,
		prestige = 0,
		joinTime = 0,
		giveList = [],
		donate_integral = 0,
		weekly_prestige = 0,
		active_less_day = 0,
		active_value_access = []
	}.

guild_science_update(PlayerID, GuildID, ID) ->
	try
		GuildInfo = guild_pub:find_guild(GuildID),
		?CHECK_THROW(GuildInfo =/= {}, ?ErrorCode_Guild_NoGuild),
		#guild_base{chariot_science_list = ScList, guildMoney = GuildMoney} = GuildInfo,
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
		NewGuildInfo = GuildInfo#guild_base{guildMoney = GuildMoney - Needs, chariot_science_list = lists:keystore(ID, 1, ScList, {ID, Lv + 1})},
		update_guild(NewGuildInfo),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_science_up_ret{id = ID, new_lv = Lv + 1, error = ?ERROR_OK})
	catch
		Err ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_guild_science_up_ret{id = ID, error = Err})
	end.

%% 设置战车使用规则
chariot_use_rule_set(PlayerID, GuildID, Rule) ->
	try
		Guild = guild_pub:find_guild(GuildID),
		?CHECK_THROW(Guild =/= {}, ?ErrorCode_Guild_NoGuild),
		?CHECK_THROW(Rule =< 63, ?ERROR_Param),
		?CHECK_THROW(Guild#guild_base.chariot_use_rule =/= Rule, ?ERROR_OK),
		Rank = guild_pub:get_member_rank(GuildID, PlayerID),
		?CHECK_THROW(Rank =:= ?GuildRank_Chairman, ?ErrorCode_Guild_RankEnough),
		update_guild(Guild#guild_base{chariot_use_rule = Rule}),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_chariot_use_rule_ret{value = Rule, err_code = ?ERROR_OK})
	catch
		Err -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_chariot_use_rule_ret{value = Rule, err_code = Err})
	end.

active_value_access(PlayerID, Pid, ID, Times) ->
	case guild_pub:find_guild_member(PlayerID) of
		#guild_member{guildID = GuildID, active_value_access = AccessList} = Info when GuildID > 0 ->
			case guild_pub:find_guild(GuildID) of
				#guild_base{active_value = OldActiveV} = GuildInfo ->
					#guildActivityCfg{access = List} = cfg_guildActivity:first_row(),
					HasTime = case lists:keyfind(ID, 1, AccessList) of
								  ?FALSE -> 0;
								  {_, T} -> T
							  end,
					case lists:keyfind(ID, 1, List) of
						{_, Score, MaxTime} when HasTime < MaxTime ->
							AddTimes = min(Times, MaxTime - HasTime),
							update_guild_member(Info#guild_member{active_value_access = lists:keystore(ID, 1, AccessList, {ID, HasTime + AddTimes})}, ?FALSE),
							GuildAddScore = Score * AddTimes,
							update_guild(GuildInfo#guild_base{active_value = OldActiveV + GuildAddScore}),
							m_send:send_pid_msg_2_client(Pid, #pk_GS2U_MyActiveValueAccessUpdate{active_value_access = [#pk_key_value{key = ID, value = HasTime + AddTimes}]});
						_ -> ok
					end;
				_ -> ok
			end;
		_ -> ok
	end.

add_assign_award_item(Type, SourceFrom, GuildID, ItemList) ->
	NewInfo = case table_global:lookup(?TableGuildAssignAward, {GuildID, Type}) of
				  [] ->
					  #guild_assign_award{
						  guild_id = GuildID,
						  type = Type,
						  list = [#guild_assign_award_item{item_id = ItemID, source_from = SourceFrom} || ItemID <- ItemList]};
				  [Info] ->
					  Info#guild_assign_award{
						  list = [#guild_assign_award_item{item_id = ItemID, source_from = SourceFrom} || ItemID <- ItemList] ++ Info#guild_assign_award.list}
			  end,
	table_global:insert(?TableGuildAssignAward, NewInfo).

auto_assign_award_item() ->
	DataList = table_global:record_list(?TableGuildAssignAward),
	Now = time:time(),
	lists:foreach(fun(#guild_assign_award{guild_id = GuildID, type = Type, list = List, log_list = OldLogList} = Data) ->
		case Type =:= ?AssignAwardTypeGuildInsZones of
			?TRUE ->
				case [R || #guild_assign_award_item{is_assign = 0} = R <- List] of
					[] ->
						NewData = Data#guild_assign_award{list = []},
						table_global:insert(?TableGuildAssignAward, NewData);
					RemainList ->
						case guild_pub:find_guild(GuildID) of
							#guild_base{guild_ins_zones_assign_rule = AssRule} ->
								case AssRule =/= ?AssignRuleNull of
									?TRUE ->
										AssNum = length(RemainList),
										MemberList = sort_members(AssRule, [MemberR || {ID, _, _} <- guild_pub:get_guild_maps_member(GuildID),
											(MemberR = guild_pub:find_guild_member(ID)) =/= {}]),
										AwardPlayerList = lists:sublist([R || R <- MemberList,
											not variant:isBitOn(R#guild_member.state_mark, ?StateGuildInsZoneAssign)], AssNum),
										{LogList, _} = lists:foldl(fun(#guild_member{playerID = AssignPlayerID, playerName = PName, playerSex = PSex} = MemberData, {LogRet, RemainRet}) ->
											case RemainRet of
												[] -> {LogRet, RemainRet};
												[#guild_assign_award_item{item_id = ItemID} | Left] ->
													NewMemberData = MemberData#guild_member{state_mark = variant:setBit(MemberData#guild_member.state_mark, ?StateGuildInsZoneAssign, 1)},
													update_guild_member(NewMemberData, ?FALSE),
													mail:send_mail(#mailInfo{
														player_id = AssignPlayerID,
														title = "【没有文字】公会副本",
														describe = language:format("【没有文字】系统自动分配给你~2ts", [richText:getItemListText([{ItemID, 1}], "ZH_CN")]),
														itemList = [#itemInfo{itemID = ItemID, num = 1, isBind = 1}],
														attachmentReason = ?Reason_Guild_Assign_Award
													}),
													{[{2, "", ItemID, richText:getPlayerText(PName, PSex), Now} | LogRet], Left}
											end
																   end, {[], RemainList}, AwardPlayerList),
										NewLogList = lists:sublist(LogList ++ OldLogList, 20),
										NewData = Data#guild_assign_award{list = [], log_list = NewLogList},
										table_global:insert(?TableGuildAssignAward, NewData),
										?LOG_INFO("auto award, guild_id ~p, rule ~p, player_list ~p", [GuildID, AssRule, [Pl || #guild_member{playerID = Pl} <- AwardPlayerList]]);
									?FALSE ->
										NewData = Data#guild_assign_award{list = []},
										table_global:insert(?TableGuildAssignAward, NewData),
										?LOG_INFO("auto award, guild_id ~p, rule ~p", [GuildID, AssRule])
								end;
							_ ->
								table_global:delete(?TableGuildAssignAward, {GuildID, ?AssignAwardTypeGuildInsZones})
						end
				end;
			?FALSE -> ok
		end
				  end, DataList).

gm_quick_join(PlayerID) ->
	case guild_pub:find_guild_member(PlayerID) of
		#guild_member{guildID = GuildID} when GuildID =/= 0 -> ok;
		_ ->
			AllMemberList = etsBaseFunc:getAllRecord(?Ets_GuildMemberMaps),
			L = [GuildID || #guild_member_maps{guild_id = GuildID, member_list = MemberList} <- AllMemberList, length(MemberList) < 30],
			case L of
				[] ->
					#player{name = PlayerName, level = PlayerLevel, sex = PlayerSex, battleValue = BattleValue} = mirror_player:get_player(PlayerID),
					player_msg_create_guild({PlayerID, PlayerName, PlayerLevel, PlayerSex, 0, BattleValue, PlayerName, 1});
				[GuildID | _] ->
					condition_enter_guild(GuildID, PlayerID)
			end
	end.
