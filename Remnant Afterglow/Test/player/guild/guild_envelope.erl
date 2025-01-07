%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 仙盟红包
%%% @end
%%% Created : 09. 八月 2018 11:58
%%%-------------------------------------------------------------------
-module(guild_envelope).
-author("zhangrj").
-include("logger.hrl").
-include("condition_compile.hrl").
-include("globalDict.hrl").
-include("guild_envelope.hrl").
-include("db_table.hrl").
-include("guild.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("cfg_expDistribution.hrl").
-include("netmsgRecords.hrl").
-include("currency.hrl").
-include("activity_new.hrl").
-include("attainment.hrl").

-export([init/1, start_link/0, handle_info/2, handle_cast/2, handle_call/3, code_change/3, terminate/2]).
-export([cast/1]).
-record(state, {}).

start_link() ->
	gen_server:start_link({local, guild_envelope}, ?MODULE, [], [{timeout, ?Start_Link_TimeOut_ms}]).

cast(Fun) when is_function(Fun, 0) ->
	gen_server:cast(guild_envelope, {do, Fun}).

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
	ets:new(?GuildEnvelopeEts, [{keypos, #guildEnvelope.en_id}, named_table, protected, set, ?ETSRC, ?ETSWC]),
	ets:new(?PlayerEnvelopeEts, [{keypos, #playerEnvelope.key}, named_table, protected, set, ?ETSRC, ?ETSWC]),
%%	erlang:send_after(?MainTick_INTERVAL, self(), {activeTicker}),
	load_envelope_data(),
%%	self() ! {do, fun guild_envelope:delete_player_envelope/0},
	#state{}.

%% 返回{Reply, NewState}
%%do_call({get_envelope, EnID, PlayerID}, _CallFrom, State) ->
%%	Reply = get_envelope(EnID, PlayerID),
%%	{Reply, State};
do_call(CallRequest, CallFrom, State) ->
	?LOG_ERROR("unknown call: request=~p, from=~p", [CallRequest, CallFrom]),
	Reply = ok,
	{Reply, State}.

%% 返回NewState
do_cast({activeTicker}, State) ->
	erlang:send_after(3000, self(), {activeTicker}),
	TimesTamp = time:time(),
	on_tick(TimesTamp),
	State;
do_cast({onReset5}, State) ->
	on_reset5(),
	State;
do_cast({create_envelope, Info, Params}, State) ->
	create_new_envelope(Info, Params),
	State;
do_cast({get_envelope, EnID, PlayerID}, State) ->
	get_envelope(EnID, PlayerID),
	State;
do_cast({get_envelope, GuildID, EnIdList, CurGold, MaxGold, PlayerID}, State) ->
	get_envelope(GuildID, EnIdList, CurGold, MaxGold, PlayerID),
	State;
do_cast({on_guild_dismiss, GuildID}, State) ->
	on_guild_dismiss(GuildID),
	State;
do_cast({do, Fun}, State) ->
	Fun(),
	State;
do_cast(CastRequest, State) ->
	?LOG_ERROR("unknown cast: request=~p", [CastRequest]),
	State.

do_terminate(_Reason, _State) ->
	ok.

guild_envelope_record2db(Info) ->
	#db_guild_envelope{
		en_id = Info#guildEnvelope.en_id,
		guild_id = Info#guildEnvelope.guild_id,
		type = Info#guildEnvelope.type,
		money = Info#guildEnvelope.money,
		number = Info#guildEnvelope.number,
		cur_num = Info#guildEnvelope.cur_num,
		send_id = Info#guildEnvelope.send_id,
		msg = Info#guildEnvelope.msg,
		time = Info#guildEnvelope.time,
		envelope_list = gamedbProc:term_to_dbstring(Info#guildEnvelope.envelope_list)
	}.
guild_envelope_db2record(Info) ->
	#guildEnvelope{
		en_id = Info#db_guild_envelope.en_id,
		guild_id = Info#db_guild_envelope.guild_id,
		type = Info#db_guild_envelope.type,
		money = Info#db_guild_envelope.money,
		number = Info#db_guild_envelope.number,
		cur_num = Info#db_guild_envelope.cur_num,
		send_id = Info#db_guild_envelope.send_id,
		msg = unicode:characters_to_list(Info#db_guild_envelope.msg),
		time = Info#db_guild_envelope.time,
		envelope_list = gamedbProc:dbstring_to_term(Info#db_guild_envelope.envelope_list)
	}.

load_guild_envelope() ->
	List = table_global:record_list(db_guild_envelope),
	L = [guild_envelope_db2record(R) || R <- List],
	etsBaseFunc:insertRecord(?GuildEnvelopeEts, L).
update_guild_envelope(Info) ->
	DBInfo = guild_envelope_record2db(Info),
	table_global:insert(db_guild_envelope, DBInfo).
delete_guild_envelope(KeyList) when is_list(KeyList) ->
	table_global:delete(db_guild_envelope, KeyList);
delete_guild_envelope(Key) ->
	table_global:delete(db_guild_envelope, [Key]).

load_player_envelope() ->
	List = table_global:record_list(db_player_envelope),
	L = [begin [_, PlayerId, EnId | T] = tuple_to_list(R), list_to_tuple([playerEnvelope, {PlayerId, EnId}, PlayerId, EnId | T]) end || R <- List],
	etsBaseFunc:insertRecord(?PlayerEnvelopeEts, L).
update_player_envelope(Info) ->
	DBInfo = setelement(1, Info, db_player_envelope),
	DBInfo1 = erlang:delete_element(2, DBInfo),
	table_global:insert(db_player_envelope, DBInfo1).
%%delete_player_envelope(Key) when is_tuple(Key) ->
%%	table_global:delete(db_player_envelope, [Key]);
%%delete_player_envelope(KeyList) ->
%%	table_global:delete(db_player_envelope, KeyList).
%%delete_player_envelope() ->
%%	%% 有效红包ID
%%	IdList = ets:select(?GuildEnvelopeEts, ets:fun2ms(fun(#guildEnvelope{en_id = EnId}) -> EnId end)),
%%	%% 有效玩家红包记录
%%	List = lists:append([ets:select(?PlayerEnvelopeEts,
%%		ets:fun2ms(fun(#playerEnvelope{en_id = EnId} = Record) when EnId =:= Id -> Record end)) || Id <- IdList]),
%%	%% 更新数据库
%%	ets:delete_all_objects(?PlayerEnvelopeEts),
%%	table_global:delete_all(db_player_envelope),
%%	ets:insert(?PlayerEnvelopeEts, List),
%%	List1 = [begin [N, _ | T] = tuple_to_list(R), list_to_tuple([N | T]) end || R <- List],
%%	table_global:insert(db_player_envelope, List1).

load_envelope_data() ->
	load_guild_envelope(),
	load_player_envelope(),
	ok.

%%on_reset() ->
%%	%% 删除每日红包
%%	Q = ets:fun2ms(fun(#guildEnvelope{type = Type} = R) when Type =:= 5 -> R end),
%%	List = ets:select(?GuildEnvelopeEts, Q),
%%	EnIDList = [R#guildEnvelope.en_id || R <- List],
%%	clean_guild_envelope(EnIDList),
%%	clean_player_envelope(EnIDList),
%%	delete_player_envelope(),
%%	%% 发送每日红包
%%	do_sys_envelope(),
%%	ok.

on_reset5() ->
	clean_all_envelope(),
	%% 发送每日红包
	do_sys_envelope().

%% 系统红包
do_sys_envelope() ->
	GuildList = table_global:record_list(?TableGuild),
	Money = cfg_globalSetup:everyRedGuild_SendLimit(),
	Num = cfg_globalSetup:everyRedGuild_PlayerLimit(),
	lists:foreach(fun(Guild) ->
		m_guild_envelope:create_envelope(Guild#guild_base.id, Guild#guild_base.chairmanPlayerID, 5, Money, Num, "GuildSYSRed01")
				  end, GuildList),
	ok.

on_tick(_TimesTamp) ->
%%	check_guild_envelope(TimesTamp),
	ok.

%%%% 检查红包时效
%%check_guild_envelope(TimesTamp) ->
%%	Q = ets:fun2ms(fun(#guildEnvelope{type = Type, time = Time} = R)
%%		when TimesTamp >= Time andalso Type =/= 5 -> R end),
%%	List = ets:select(?GuildEnvelopeEts, Q),
%%	EnIDList = [R#guildEnvelope.en_id || R <- List],
%%	clean_guild_envelope(EnIDList),
%%	clean_player_envelope(EnIDList),
%%	ok.

%% 清除所有记录
clean_all_envelope() ->
	etsBaseFunc:deleteAllRecord(?GuildEnvelopeEts),
	etsBaseFunc:deleteAllRecord(?PlayerEnvelopeEts),
	table_global:delete_all(db_guild_envelope),
	table_global:delete_all(db_player_envelope).

%% 删除红包数据
clean_guild_envelope(EnIDList) ->
	[etsBaseFunc:deleteRecord(?GuildEnvelopeEts, R) || R <- EnIDList],
	delete_guild_envelope(EnIDList),
	ok.
%%%% 删除玩家领取记录
%%clean_player_envelope(EnIDList) when is_list(EnIDList) ->
%%	lists:foreach(fun(EnID) ->
%%		clean_player_envelope(EnID)
%%				  end, EnIDList);
%%clean_player_envelope(EnID) ->
%%	Q = ets:fun2ms(fun(#playerEnvelope{en_id = EID, key = Key} = _R) when EID =:= EnID -> Key end),
%%	List = ets:select(?PlayerEnvelopeEts, Q),
%%	Q0 = ets:fun2ms(fun(#playerEnvelope{en_id = EID} = _R) when EID =:= EnID -> ?TRUE end),
%%	ets:select_delete(?PlayerEnvelopeEts, Q0),
%%	delete_player_envelope(List),
%%	ok.

%% 响应战盟解散
on_guild_dismiss(GuildID) ->
	Q = ets:fun2ms(fun(#guildEnvelope{guild_id = GID} = R) when GID =:= GuildID -> R end),
	List = ets:select(?GuildEnvelopeEts, Q),
	EnIDList = [R#guildEnvelope.en_id || R <- List],
	clean_guild_envelope(EnIDList),
	ok.

%% 创建红包
create_new_envelope(EnvelopeInfo, Params) ->
	etsBaseFunc:insertRecord(?GuildEnvelopeEts, EnvelopeInfo),
	update_guild_envelope(EnvelopeInfo),
	do_envelope_event(EnvelopeInfo, Params).

%% 红包事件
do_envelope_event(EnvelopeInfo, Params) ->
	#guildEnvelope{en_id = EnID, guild_id = GuildID, type = Type, send_id = PlayerID, money = Money} = EnvelopeInfo,
	guild_event:add_guild_event(GuildID, ?EventModule_2, Type, PlayerID, [Money] ++ Params),
	guild_pub:send_msg_to_all_member_process(EnvelopeInfo#guildEnvelope.guild_id, {get_envelope_info}),
	%% 公告
	NameText = richText:getPlayerTextByID(PlayerID),
	case EnvelopeInfo#guildEnvelope.type of
		1 ->
			guild_pub:send_guild_notice(EnvelopeInfo#guildEnvelope.guild_id, guildRed_Recharge01,
				fun(Language) ->
					language:format(language:get_server_string("GuildRed_Recharge01", Language), [NameText])
				end);
		2 ->
			guild_pub:send_guild_notice(EnvelopeInfo#guildEnvelope.guild_id, guildRed_Recharge02,
				fun(Language) ->
					language:format(language:get_server_string("GuildRed_Recharge02", Language), [NameText])
				end);
		5 ->
			guild_pub:send_guild_notice(EnvelopeInfo#guildEnvelope.guild_id, guildDayRed01,
				fun(Language) ->
					language:format(language:get_server_string("GuildDayRed01", Language), [NameText])
				end);
		_ ->
			guild_pub:send_guild_notice(EnvelopeInfo#guildEnvelope.guild_id, guildNewNotice18,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice18", Language), [NameText, Money])
				end)
	end,
	logdbProc:log_guild_envelope(GuildID, PlayerID, EnID, 1, Money),
	ok.

%% 玩家领取红包
get_envelope(EnID, PlayerID) ->
	try
		Envelope =
			case etsBaseFunc:readRecord(?GuildEnvelopeEts, EnID) of
				{} -> throw(?ErrorCode_Guild_EnvelopeNotExist);
				E -> E
			end,
		case Envelope#guildEnvelope.type =:= 5 of
			?TRUE ->
				case variable_player:get_player_value(PlayerID, ?Variant_Index_10_GuildSysEnvelope) =:= 1 of
					?TRUE -> throw(?ErrorCode_Guild_SysEnvelope);
					?FALSE ->
						main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variant_Index_10_GuildSysEnvelope, 1})
				end;
			?FALSE -> ok
		end,
		Gold = case Envelope#guildEnvelope.cur_num >= Envelope#guildEnvelope.number of
				   ?TRUE ->
					   get_envelope_money(EnID, PlayerID),
					   0;
				   ?FALSE ->
					   get_envelope_gold(EnID, PlayerID)
			   end,

		%% 领红包公告
		case Gold > 0 of
			?TRUE ->
				PlayerText = richText:getPlayerTextByID(PlayerID),
				Params = case Envelope#guildEnvelope.type of
							 5 -> [PlayerText, Gold];
							 _ -> [PlayerText, richText:getPlayerTextByID(Envelope#guildEnvelope.send_id), Gold]
						 end,
				case Envelope#guildEnvelope.type of
					1 ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildRed_Recharge03,
							fun(Language) ->
								language:format(language:get_server_string("GuildRed_Recharge03", Language), Params)
							end);
					2 ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildRed_Recharge04,
							fun(Language) ->
								language:format(language:get_server_string("GuildRed_Recharge04", Language), Params)
							end);
					4 ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice31,
							fun(Language) ->
								language:format(language:get_server_string("GuildNewNotice31", Language), Params)
							end);
					5 ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildDayRed02,
							fun(Language) ->
								language:format(language:get_server_string("GuildDayRed02", Language), Params)
							end);
					6 ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice35,
							fun(Language) ->
								language:format(language:get_server_string("GuildNewNotice35", Language), Params)
							end);
					7 ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice37,
							fun(Language) ->
								language:format(language:get_server_string("GuildNewNotice37", Language), Params)
							end);
					_ ->
						guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice16,
							fun(Language) ->
								language:format(language:get_server_string("GuildNewNotice16", Language), Params)
							end)
				end,
				check_luck_notice(Envelope),
				logdbProc:log_guild_envelope(Envelope#guildEnvelope.guild_id, PlayerID, EnID, 2, Gold);
			?FALSE -> ok
		end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_get_guild_envelope_result{en_id = EnID, result = 0}),
		ok
	catch
		Ret -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_get_guild_envelope_result{en_id = EnID, result = Ret})
	end.
get_envelope(GuildId, EnIdList, CurGold, MaxGold, PlayerID) ->
	try
		CurVipCardNum = variable_player:get_player_value(PlayerID, ?Variable_Player_EnvelopeVipCard),
		F = fun(EnId, {RIds, RGold, RVipCardNum}) ->
			case CurGold + RGold >= MaxGold of
				?TRUE -> {RIds, RGold, RVipCardNum};
				?FALSE ->
					case ets:lookup(?GuildEnvelopeEts, EnId) of
						[#guildEnvelope{cur_num = CurNum, number = MaxNum}] when CurNum >= MaxNum ->
							get_envelope_money(EnId, PlayerID),
							{[EnId | RIds], RGold, RVipCardNum};
						[#guildEnvelope{guild_id = GuildId, type = Type}] ->
							IsGet = case {Type =:= 5, variable_player:get_player_value(PlayerID, ?Variant_Index_10_GuildSysEnvelope) =/= 1} of
										{?TRUE, ?TRUE} ->
											main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variant_Index_10_GuildSysEnvelope, 1}),
											?TRUE;
										{?TRUE, ?FALSE} -> ?FALSE;
										_ -> ?TRUE
									end,
							Envelope = etsBaseFunc:readRecord(?GuildEnvelopeEts, EnId),
							Index = Envelope#guildEnvelope.cur_num + 1,
							case IsGet andalso lists:keyfind(Index, 1, Envelope#guildEnvelope.envelope_list) of
								{_, Gold} when CurGold + RGold < MaxGold ->
									{VipCardItem, VipCardNum} = rand_vip_card(CurVipCardNum + RVipCardNum),
									add_envelope_log(EnId, PlayerID, 0, Gold, Index, VipCardItem, VipCardNum),
									etsBaseFunc:changeFiled(?GuildEnvelopeEts, EnId, #guildEnvelope.cur_num, Index),
									update_guild_envelope(Envelope#guildEnvelope{cur_num = Index}),
									logdbProc:log_guild_envelope(GuildId, PlayerID, EnId, 2, Gold),
									{[EnId | RIds], RGold + Gold, RVipCardNum + VipCardNum};
								_ ->
									{RIds, RGold, RVipCardNum}
							end;
						_ ->
							{RIds, RGold, RVipCardNum}
					end
			end
			end,
		case lists:foldl(F, {[], 0, 0}, EnIdList) of
			{GetIds, GetGold, GetVipCardNum} when GetGold > 0 ->
				[{VipCardItem, _, _}] = df:getGlobalSetupValueList(wildBossRedBagItem, [{1100096, 1, 3}]),
				main:sendMsgToPlayerProcess(PlayerID, {addGold, GetGold, ?Reason_Guild_getEnvelope}),
				main:sendMsgToPlayerProcess(PlayerID, {addItem, VipCardItem, GetVipCardNum, ?Reason_Guild_getEnvelope}),

				main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variable_Player_EnvelopeGoldNum, CurGold + GetGold}),
				main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variable_Player_EnvelopeVipCard, CurVipCardNum + GetVipCardNum}),
				main:sendMsgToPlayerProcess(PlayerID, {attainment_addprogress, ?Attainments_Type_ChestDiamondsCount, {GetGold}}),

				activity_new_player:on_active_condition_change_ex(PlayerID, ?SalesActivity_GuildEnvelopGold, GetGold),
				player_item:show_get_item_dialog(PlayerID, [{VipCardItem, GetVipCardNum}], [{?CURRENCY_GoldBind, GetGold}], [], 0, 0),
				Params = [richText:getPlayerTextByID(PlayerID), length(GetIds), GetGold],
				guild_pub:send_guild_notice(GuildId, guildRedpacket1,
					fun(Language) ->
						language:format(language:get_server_string("GuildRedpacket1", Language), Params)
					end);
			_ -> ok
		end,
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_get_guild_envelope_result{en_id = 0, result = 0})
	catch
		Ret -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_get_guild_envelope_result{en_id = 0, result = Ret})
	end.

%% 手气最佳公告
check_luck_notice(Envelope) when Envelope#guildEnvelope.cur_num + 1 >= Envelope#guildEnvelope.number ->
	List = m_guild_envelope:get_envelope_get_gold_record(Envelope#guildEnvelope.en_id),
	LuckyID = m_guild_envelope:find_lucky_player(List),
	Gold = etsBaseFunc:getRecordField(?PlayerEnvelopeEts, {LuckyID, Envelope#guildEnvelope.en_id}, #playerEnvelope.get_money, 0),
	Params = [richText:getPlayerTextByID(LuckyID), richText:getPlayerTextByID(Envelope#guildEnvelope.send_id), Gold],
	case Envelope#guildEnvelope.type of
		1 ->
			guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildRed_Recharge05,
				fun(Language) ->
					language:format(language:get_server_string("GuildRed_Recharge05", Language), Params)
				end);
		2 ->
			guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildRed_Recharge06,
				fun(Language) ->
					language:format(language:get_server_string("GuildRed_Recharge06", Language), Params)
				end);
		4 ->
			guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice32,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice32", Language), Params)
				end);
		6 ->
			guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice36,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice36", Language), Params)
				end);
		7 ->
			guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice38,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice38", Language), Params)
				end);
		_ ->
			guild_pub:send_guild_notice(Envelope#guildEnvelope.guild_id, guildNewNotice17,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice17", Language), Params)
				end)
	end,
	ok;
check_luck_notice(_Envelope) ->
	ok.

%% 领取红包
get_envelope_gold(EnID, PlayerID) ->
	Envelope = etsBaseFunc:readRecord(?GuildEnvelopeEts, EnID),
	Index = Envelope#guildEnvelope.cur_num + 1,
	case lists:keyfind(Index, 1, Envelope#guildEnvelope.envelope_list) of
		?FALSE -> ?LOG_ERROR("envelope index not exist ~p", [PlayerID]), Gold = 0;
		{_, Gold} -> main:sendMsgToPlayerProcess(PlayerID, {addGold, Gold, ?Reason_Guild_getEnvelope})
	end,
	CurVipCardNum = variable_player:get_player_value(PlayerID, ?Variable_Player_EnvelopeVipCard),
	{VipCardItem, VipCardNum} = rand_vip_card(CurVipCardNum),
	main:sendMsgToPlayerProcess(PlayerID, {addItem, VipCardItem, VipCardNum, ?Reason_Guild_getEnvelope}),
	add_envelope_log(EnID, PlayerID, 0, Gold, Index, VipCardItem, VipCardNum),
	etsBaseFunc:changeFiled(?GuildEnvelopeEts, EnID, #guildEnvelope.cur_num, Index),
	update_guild_envelope(Envelope#guildEnvelope{cur_num = Index}),
	CurGoldNum = variable_player:get_player_value(PlayerID, ?Variable_Player_EnvelopeGoldNum),
	main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variable_Player_EnvelopeGoldNum, CurGoldNum + Gold}),
	main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variable_Player_EnvelopeVipCard, CurVipCardNum + VipCardNum}),
	activity_new_player:on_active_condition_change_ex(PlayerID, ?SalesActivity_GuildEnvelopGold, Gold),
	Gold.

%% 红包已领取完领取铜币
get_envelope_money(EnID, PlayerID) ->
	Level = mirror_player:get_player_element(PlayerID, #player.level),
	Money =
		case cfg_expDistribution:getRow(Level) of
			Cfg when Cfg =/= {} -> Cfg#expDistributionCfg.redPacketMoney;
			_ ->
				?LOG_ERROR("get envelope money expdistribution has no config ~p", [{PlayerID, Level}]),
				0
		end,
	case Money > 0 of
		?TRUE -> main:sendMsgToPlayerProcess(PlayerID, {addMoney, Money, ?Reason_Guild_getEnvelope});
		?FALSE -> ok
	end,
	add_envelope_log(EnID, PlayerID, 1, Money, 0, 0, 0),
	logdbProc:log_guild_envelope(mirror_player:get_player_element(PlayerID, #player.guildID), PlayerID, EnID, 3, Money),
	ok.

%% 领取记录
add_envelope_log(EnID, PlayerID, Type, Money, Index, VipCardItem, VipCardNum) ->
	Info =
		#playerEnvelope{
			key = {PlayerID, EnID},
			player_id = PlayerID,
			en_id = EnID,
			index = Index,
			get_type = Type,
			get_money = Money,
			get_item = VipCardItem,
			get_item_num = VipCardNum,
			time = time:time()
		},
	etsBaseFunc:insertRecord(?PlayerEnvelopeEts, Info),
	update_player_envelope(Info).

rand_vip_card(CurItemNum) ->
	[{_, MaxItemNum}] = df:getGlobalSetupValueList(wildBossRedBagItemLimit, [{1100096, 40}]),
	[{VipItemID, Min, Max}] = df:getGlobalSetupValueList(wildBossRedBagItem, [{1100096, 1, 3}]),
	case CurItemNum =< MaxItemNum of
		?TRUE ->
			{VipItemID, min(common:rand(Min, Max), MaxItemNum - CurItemNum)};
		_ -> {0, 0}
	end.