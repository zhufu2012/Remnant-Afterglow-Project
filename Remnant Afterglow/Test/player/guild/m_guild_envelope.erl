%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 战盟红包外部进程
%%% @end
%%% Created : 09. 八月 2018 15:36
%%%-------------------------------------------------------------------
-module(m_guild_envelope).
-author("zhangrj").
-include("record.hrl").
-include("guild_envelope.hrl").
-include("id_generator.hrl").
-include("guild.hrl").
-include("error.hrl").
-include("error.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("netmsgRecords.hrl").
-include("db_table.hrl").
-include("attainment.hrl").
-include("cfg_mapsetting.hrl").
-include("cfg_monsterBase.hrl").
-include("cfg_name_mapsetting.hrl").
-include("cfg_name_MonsterName.hrl").
-include("cfg_wildBossNew.hrl").
-include("logger.hrl").
-include("currency.hrl").
-include("cfg_globalSetupText.hrl").
-include("cfg_dungeonBaseNew.hrl").
-include("player_private_list.hrl").

%% API
-export([
	create_envelope/6,
	create_envelope/7,
	get_envelopes/2,
	gen_call/1,
	on_get_envelope_info/0,
	on_get_envelope_record/1,
	on_get_envelope/1,
	on_send_envelope/3,
	get_envelope_get_gold_record/1,
	find_lucky_player/1,
	on_world_boss_dead/4,
	on_SWDY_boss_dead/3,
	on_person_boss_dead/2
]).

%% -------------- 公共进程 -------------
%% 创建红包
create_envelope(GuildID, PlayerID, Type, Money, Number, Msg) ->?metrics(begin 
	create_envelope(GuildID, PlayerID, Type, Money, Number, Msg, []) end).
create_envelope(GuildID, PlayerID, Type, Money, Number, Msg, Params) ->
	?metrics(begin
				 create(GuildID, PlayerID, Type, Money, Number, Msg, Params)
			 end).
create(GuildID, PlayerID, Type, Money, Number, Msg, Params) ->
	EnID = id_generator:generate(?ID_TYPE_GuildEnvelope),
	NowTime = time:time(),
	TimeLimit = cfg_globalSetup:guildRedPacket_TimeLimit(),
	NewInfo =
		#guildEnvelope{
			en_id = EnID,
			guild_id = GuildID,
			type = Type,
			money = Money,
			number = Number,
			send_id = PlayerID,
			msg = Msg,
			time = NowTime + TimeLimit,
			envelope_list = m_guild_envelope:get_envelopes(Money, Number)
		},
	guild_envelope ! {create_envelope, NewInfo, Params}.

%% 返回一个红包数据
get_envelopes(TotalMoney, Num) ->?metrics(begin 
	Min = cfg_globalSetup:redPacketB1(),
	BaseParamPercent = cfg_globalSetup:redPacketA1(),
	BaseMoney = max(Min, ceil(TotalMoney * BaseParamPercent / 10000 / Num)),
	IndexList = lists:seq(1, Num),
	RandParamList = [{Ind, common:rand(1, 100)} || Ind <- IndexList],
	TotalRandParam = lists:sum([P || {_, P} <- RandParamList]),
	Func =
		fun({Ind, Param}) ->
			Money = erlang:round(Param / TotalRandParam * (TotalMoney - BaseMoney * Num)) + BaseMoney,
			{Ind, Money}
		end,
	MoneyList = lists:map(Func, RandParamList),
	CalTotalMoney = lists:sum([M || {_, M} <- MoneyList]),
	case CalTotalMoney < TotalMoney of
		?TRUE -> fix_envelopes_1(MoneyList, TotalMoney - CalTotalMoney);
		?FALSE -> fix_envelopes_2(MoneyList, CalTotalMoney - TotalMoney, BaseMoney)
	end end).

%% 红包数量分配修正
fix_envelopes_1(MoneyList, ExMoney) ->
	List1 = lists:keysort(2, MoneyList),
	{Ind, Money} = lists:last(List1),
	(List1 -- [{Ind, Money}]) ++ [{Ind, Money + ExMoney}].
fix_envelopes_2(MoneyList, ExMoney, BaseMoney) ->
	List1 = lists:keysort(2, MoneyList),
	fix_envelopes_2_1(List1, ExMoney, BaseMoney, []).

fix_envelopes_2_1([], _ExMoney, _BaseMoney, DecList) -> DecList;
fix_envelopes_2_1(List1, 0, _BaseMoney, DecList) -> DecList ++ List1;
fix_envelopes_2_1([{Ind, Money} | T], ExMoney, BaseMoney, DecList) ->
	DecMoney = min(Money - BaseMoney, ExMoney),
	fix_envelopes_2_1(T, ExMoney - DecMoney, BaseMoney, DecList ++ [{Ind, Money - DecMoney}]).






gen_call(Request) ->?metrics(begin 
	gen_server:call(guild_envelope, Request) end).

get_guild_envelope_list(GuildID) ->
	Q = ets:fun2ms(fun(#guildEnvelope{guild_id = GID} = R) when GID =:= GuildID -> R end),
	ets:select(?GuildEnvelopeEts, Q).

%% 领取记录（包括铜币）
%%get_envelope_get_record(EnID) ->
%%	Q = ets:fun2ms(fun(#playerEnvelope{en_id = EID}=R) when EID =:= EnID -> R end),
%%	ets:select(?PlayerEnvelopeEts, Q).

%% 领取记录（仅元宝)
get_envelope_get_gold_record(EnID) ->?metrics(begin 
	Q = ets:fun2ms(fun(#playerEnvelope{en_id = EID, get_type = Type} = R)
		when EID =:= EnID andalso Type =:= 0 -> R end),
	ets:select(?PlayerEnvelopeEts, Q) end).

find_lucky_player(List) ->?metrics(begin 
	Func =
		fun(R, {_ID, Money}) when R#playerEnvelope.get_money > Money ->
			{R#playerEnvelope.player_id, R#playerEnvelope.get_money};
			(_, Tuple) -> Tuple
		end,
	{LuckyID, _} = lists:foldl(Func, {0, 0}, lists:keysort(#playerEnvelope.index, List)),
	LuckyID end).

%% 世界Boss红包
on_world_boss_dead(MapDataID, BossID, BossLevel, PlayerID) ->?metrics(begin 
	GuildID = mirror_player:get_player_element(PlayerID, #player.guildID),
	do_world_boss_envelope(MapDataID, BossID, BossLevel, PlayerID, GuildID) end).
do_world_boss_envelope(_MapDataID, _BossID, _BossLevel, _PlayerID, 0) -> ok;
do_world_boss_envelope(MapDataID, BossID, BossLevel, PlayerID, GuildID) ->
	#wildBossNewCfg{guildRedBag = EnvelopeList} = cfg_wildBossNew:getRow(MapDataID),
	WorldLevel = variable_world:get_value(?WorldVariant_Index_16_WorldLevel),
	LevelCal = max(WorldLevel - BossLevel, 0),
	{Gold, Num} = case find_world_boss_gold(EnvelopeList, LevelCal, {}) of
					  {} ->
						  {_, _, Gold1, Num1} = lists:last(EnvelopeList),
						  {Gold1, Num1};
					  {G, N} ->
						  {G, N}
				  end,
	create_envelope(GuildID, PlayerID, 4, Gold, Num, "", [BossID]),
	%% 公告
	PlayerText = richText:getPlayerTextByID(PlayerID),
	guild_pub:send_guild_notice(GuildID, guildRedBag_WorldBOSS,
		fun(Language) -> language:format(language:get_server_string("GuildRedBag_WorldBOSS", Language),
			[PlayerText, language:get_map_name(MapDataID, Language), language:get_monster_name(BossID, Language), Gold])
		end),
	ok.
find_world_boss_gold([], _LevelCal, Envelope) -> Envelope;
find_world_boss_gold(_, _LevelCal, Envelope) when Envelope =/= {} -> Envelope;
find_world_boss_gold([{LevelC, _, Gold, Num} | List], LevelCal, Envelope) ->
	case LevelCal =< LevelC of
		?TRUE -> find_world_boss_gold(List, LevelCal, {Gold, Num});
		?FALSE -> find_world_boss_gold(List, LevelCal, Envelope)
	end.

%% 死亡地狱Boss红包(原恶魔入侵)
on_SWDY_boss_dead(BossID, PlayerID, Multi) ->?metrics(begin 
	[on_SWDY_boss_dead(BossID, PlayerID) || _ <- lists:seq(1, Multi)] end).
on_SWDY_boss_dead(BossID, PlayerID) ->
	GuildID = mirror_player:get_player_element(PlayerID, #player.guildID),
	do_SWDY_boss_envelope(BossID, PlayerID, GuildID).
do_SWDY_boss_envelope(_BossID, _PlayerID, 0) -> ok;
do_SWDY_boss_envelope(BossID, PlayerID, GuildID) ->
	[{_Type, Gold, Num, PersonMax} | _] = df:getGlobalSetupValueList(guildRedBag_DeadHellBOSS, [{0, 400, 20, 3}]),
	SendTimes = variable_player:get_player_value(PlayerID, ?Variable_Player_SWDYBoss_red_envelope),
	case SendTimes >= PersonMax of
		?TRUE -> skip;
		?FALSE ->
			create_envelope(GuildID, PlayerID, 6, Gold, Num, "", [BossID]),
			%% 公告
			PlayerText = richText:getPlayerTextByID(PlayerID),
			guild_pub:send_guild_notice(GuildID, guildRedBag_DeadHellBOSS,
				fun(Language) -> language:format(language:get_server_string("GuildRedBag_DeadHellBOSS", Language),
					[PlayerText, language:get_monster_name(BossID, Language), Gold])
				end),
			main:sendMsgToPlayerProcess(PlayerID, {setPlayerVariant, ?Variable_Player_SWDYBoss_red_envelope, SendTimes + 1})
	end,
	ok.

%% 个人Boss红包 玩家进程
on_person_boss_dead(MapDataID, BossID) ->?metrics(begin 
	PlayerID = player:getPlayerID(),
	GuildID = player:getPlayerProperty(#player.guildID),
	do_person_boss_envelope(MapDataID, BossID, PlayerID, GuildID) end).
do_person_boss_envelope(_MapDataID, _BossID, _PlayerID, 0) -> ok;
do_person_boss_envelope(MapDataID, BossID, PlayerID, GuildID) ->
	case cfg_dungeonBaseNew:getRow(MapDataID) of
		{} -> skip;
		#dungeonBaseNewCfg{entryCond = CondList} ->
			case lists:keyfind(2, 2, CondList) of
				{_, _, Vip} ->
					RedBagList = df:getGlobalSetupValueList(guildRedBag_SingleBOSS, [{5, 0, 400, 20, 1}, {7, 0, 400, 20, 1}, {9, 0, 500, 20, 1}]),
					case lists:keyfind(Vip, 1, RedBagList) of
						{_, _, Gold, Num, PersonMax} ->
							SendTimes = player_private_list:get_value(?Private_List_index_3, Vip, 1, 0),
							case SendTimes >= PersonMax of
								?TRUE -> skip;
								?FALSE ->
									create_envelope(GuildID, PlayerID, 7, Gold, Num, "", [BossID]),
									%% 公告
									PlayerText = richText:getPlayerTextByID(PlayerID),
									guild_pub:send_guild_notice(GuildID, guildRedBag_SingleBOSS,
										fun(Language) ->
											language:format(language:get_server_string("GuildRedBag_SingleBOSS", Language),
												[PlayerText, language:get_monster_name(BossID, Language), Gold])
										end),
									player_private_list:keystore(?Private_List_index_3, Vip, 1, {Vip, SendTimes + 1})
							end;
						_ -> skip
					end;
				_ -> skip
			end
	end,
	ok.

%% TODO ----------------------- 玩家进程 ------------------
on_get_envelope_info() ->?metrics(begin 
	case is_func_open() of
		?TRUE ->
			GuildID = player:getPlayerProperty(#player.guildID),
			List = get_guild_envelope_list(GuildID),
			PlayerID = player:getPlayerID(),
			EnvelopList = [make_envelope_msg(PlayerID, Info) || Info <- List],
%%			EventList0 = lists:keysort(#guildEvent.time, guild_event:get_guild_module_log_list(GuildID, ?EventModule_2)),
%%			EventList = lists:sublist(lists:reverse(EventList0), 50),
			player:send(#pk_GS2U_sendGuildEnvelopeInfo{
				envelope_list = EnvelopList,
				event_list = [] % [guild_pub:make_guild_dynamic(R) || R <- EventList]
			});
		?FALSE ->
			player:send(#pk_GS2U_sendGuildEnvelopeInfo{})
	end end).


make_envelope_msg(PlayerID, Info) ->
	Is_get = common:getTernaryValue(etsBaseFunc:hasRecordInTable(?PlayerEnvelopeEts, {PlayerID, Info#guildEnvelope.en_id}), 1, 0),
	Msg = case Info#guildEnvelope.type of
			  5 ->
				  Language = language:get_player_language(PlayerID),
				  language:get_server_string(Info#guildEnvelope.msg, Language);
			  _ ->
				  Info#guildEnvelope.msg
		  end,
	DbPlayer = mirror_player:get_player(Info#guildEnvelope.send_id),
	#pk_guildEnvelope{
		en_id = Info#guildEnvelope.en_id,
		type = Info#guildEnvelope.type,
		money = Info#guildEnvelope.money,
		number = Info#guildEnvelope.number,
		player_id = Info#guildEnvelope.send_id,
		name = DbPlayer#player.name,
		headIcon = mirror_player:get_player_equip_head(Info#guildEnvelope.send_id),
		msg = Msg,
		time = Info#guildEnvelope.time,
		frame = mirror_player:get_player_equip_frame(Info#guildEnvelope.send_id),
		career = mirror_player:get_role_career(Info#guildEnvelope.send_id, DbPlayer#player.leader_role_id),
		is_get = Is_get
	}.

on_get_envelope_record(EnID) ->?metrics(begin 
	case is_func_open() of
		?TRUE ->
			List = get_envelope_get_gold_record(EnID),
			LuckyID =
				case length(List) >= etsBaseFunc:getRecordField(?GuildEnvelopeEts, EnID, #guildEnvelope.en_id, 0) of
					?TRUE -> find_lucky_player(List);
					?FALSE -> 0
				end,
			case etsBaseFunc:readRecord(?PlayerEnvelopeEts, {player:getPlayerID(), EnID}) of
				{} ->
					Type = 0,
					Money = 0,
					ItemID = 0,
					ItemNum = 0;
				R ->
					Type = R#playerEnvelope.get_type,
					Money = R#playerEnvelope.get_money,
					ItemID = R#playerEnvelope.get_item,
					ItemNum = R#playerEnvelope.get_item_num
			end,
			Msg = [make_envelope_get_record_msg(Info, LuckyID) || Info <- lists:keysort(#playerEnvelope.index, List)],
			player:send(#pk_GS2U_sendGuildEnvelopeRecord{
				my_award = [#pk_rewardStc{type = 1, id = ItemID, num = ItemNum} || ItemID > 0, ItemNum > 0] ++ [#pk_rewardStc{type = 2, id = Type, num = Money}],
				record_list = Msg
			});
		?FALSE ->
			player:send(#pk_GS2U_sendGuildEnvelopeRecord{})
	end end).


make_envelope_get_record_msg(Info, LuckyID) ->
	#pk_guilEnvelopeRecord{
		name = mirror_player:get_player_element(Info#playerEnvelope.player_id, #player.name),
		award = [#pk_rewardStc{type = 1, id = Info#playerEnvelope.get_item, num = Info#playerEnvelope.get_item_num} ||
			Info#playerEnvelope.get_item > 0, Info#playerEnvelope.get_item_num > 0]
		++ [#pk_rewardStc{type = 2, id = Info#playerEnvelope.get_type, num = Info#playerEnvelope.get_money}],
		is_max = common:getTernaryValue(Info#playerEnvelope.player_id =:= LuckyID, 1, 0)
	}.

on_get_envelope(0) ->?metrics(begin 
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		case GuildID of
			0 -> throw(?ErrorCode_Guild_NoGuild);
			_ -> ok
		end,
		VipCfg = cfg_globalSetupText:getRow(guildRedPack),
		?CHECK_THROW(VipCfg =/= {}, ?ERROR_Cfg),
		CheckFun = fun({1, VipLv}) -> vip:get_vip_lv() >= VipLv;
			({2, PlayerLv}) -> player:getLevel() >= PlayerLv;
			(_) -> ?FALSE end,
		?CHECK_THROW(lists:any(CheckFun, VipCfg#globalSetupTextCfg.param2), ?ErrorCode_Guild_VipEnough),
		EnList = ets:match_object(?GuildEnvelopeEts, #guildEnvelope{guild_id = GuildID, _ = '_'}),
		EnIdList = lists:foldl(fun(#guildEnvelope{en_id = EnId, type = Type}, Ret) ->
			case ets:member(?PlayerEnvelopeEts, {PlayerID, EnId}) of
				?FALSE ->
					case {Type =:= 5, variable_player:get_value(?Variant_Index_10_GuildSysEnvelope) =/= 1} of
						{?TRUE, ?FALSE} -> Ret;
						_ -> [EnId | Ret]
					end;
				?TRUE ->
					Ret
			end
							   end, [], EnList),
		?CHECK_THROW(EnIdList =/= [], ?ErrorCode_Guild_NoEnvelopeGet),
		MaxGold = guild_pub:get_attr_value_by_index(GuildID, ?Guild_RedEnvelop) + recharge_subscribe:get_subscribe_value(?RechargeSubscribe6, 0),
		CurGold = variable_player:get_value(?Variable_Player_EnvelopeGoldNum),
		?CHECK_THROW(CurGold < MaxGold, ?ErrorCode_Guild_MaxDayGold),

		guild_envelope ! {get_envelope, GuildID, EnIdList, CurGold, MaxGold, PlayerID}
	catch
		Ret -> player:send(#pk_GS2U_get_guild_envelope_result{en_id = 0, result = Ret})
	end end);
on_get_envelope(EnID) ->
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		case GuildID of
			0 -> throw(?ErrorCode_Guild_NoGuild);
			_ -> ok
		end,
		case etsBaseFunc:readRecord(?GuildEnvelopeEts, EnID) of
			{} -> throw(?ErrorCode_Guild_EnvelopeNotExist);
			E -> E
		end,
		case etsBaseFunc:hasRecordInTable(?PlayerEnvelopeEts, {PlayerID, EnID}) of
			?TRUE -> throw(?ErrorCode_Guild_GetEnvelope);
			?FALSE -> ok
		end,
		case variable_player:get_value(?Variable_Player_EnvelopeGoldNum) >= guild_pub:get_attr_value_by_index(GuildID, ?Guild_RedEnvelop)
			+ recharge_subscribe:get_subscribe_value(?RechargeSubscribe6, 0) of
			?TRUE -> throw(?ErrorCode_Guild_MaxDayGold);
			?FALSE -> ok
		end,

		guild_envelope ! {get_envelope, EnID, PlayerID},
		ok
	catch
		Ret -> player:send(#pk_GS2U_get_guild_envelope_result{en_id = EnID, result = Ret})
	end.

%% 发红包
on_send_envelope(Money, Number, Msg) ->?metrics(begin 
	try
		?CHECK_THROW(is_func_open(), ?ERROR_FunctionClose),
		PlayerID = player:getPlayerID(),
		GuildID = player:getPlayerProperty(#player.guildID),
		case GuildID of
			0 -> throw(?ErrorCode_Guild_NoGuild);
			_ -> ok
		end,
		VipFunID = cfg_globalSetup:guild_SendRedVIP(),
		case vipFun:callVip(VipFunID, 0) =:= 1 of
			?TRUE -> ok;
			?FALSE -> throw(?ErrorCode_Guild_VipEnough)
		end,
		SendNum = variable_player:get_value(?Variable_Player_EnvelopeSendNum),
		case SendNum >= cfg_globalSetup:guildRedPacket_SendNumLimit() of
			?TRUE -> throw(?ErrorCode_Guild_MaxSendNum);
			?FALSE -> ok
		end,
		case Number > cfg_globalSetup:guildRedPacket_PlayerLimit() of
			?TRUE -> throw(?ErrorCode_Guild_MaxEnvelopeNum);
			?FALSE -> ok
		end,
		case Money > cfg_globalSetup:guildRedPacket_SendMax() orelse Money < cfg_globalSetup:guildRedPacket_SendMin() of
			?TRUE -> throw(?ErrorCode_Guild_WrongMoney);
			?FALSE -> ok
		end,
		case ceil(Money / Number) > cfg_globalSetup:guildRedPacket_VIPNum() of
			?TRUE -> throw(?ErrorCode_Guild_MaxPlayerGold);
			?FALSE -> ok
		end,
		CurrencyError = currency:delete(?CURRENCY_GoldBind, Money, ?Reason_Guild_sendEnvelope),
		?ERROR_CHECK_THROW(CurrencyError),
		create_envelope(GuildID, PlayerID, 3, Money, Number, Msg),
		variable_player:set_value(?Variable_Player_EnvelopeSendNum, SendNum + 1),
		attainment:add_attain_progress(?Attainments_Type_GuildRedPacketCount, {1}),
		player:send(#pk_GS2U_send_guild_envelope_result{result = 0}),
		ok
	catch
		Ret -> player:send(#pk_GS2U_send_guild_envelope_result{result = Ret})
	end end).

is_func_open() ->
	variable_world:get_value(?WorldVariant_Switch_Guild) =:= 1 andalso guide:is_open_action(?OpenAction_guild).