%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 战盟公共进程
%%% @end
%%% Created : 01. 八月 2018 15:39
%%%-------------------------------------------------------------------
-module(guild_pub).
-author("zhangrj").
-include("guild.hrl").
-include("global.hrl").
-include("record.hrl").
-include("db_table.hrl").
-include("cfg_guildBuilding.hrl").
-include("cfg_equipBase.hrl").
-include("item.hrl").
-include("netmsgRecords.hrl").
-include("cfg_guildTreasuryuse.hrl").
-include("cfg_guildTreasuryAcquire.hrl").
-include("cfg_guildchariot.hrl").

%% API
-export([
	get_guild_total_battle_value/1,
	sort_guild/1,
	sort_guild/0,
	gen_call/1,
	get_guild_mem_off_flag/2,
	get_guild_member_list/1,
	get_guild_member_id_list/1,
	get_player_applicant_list/1,
	get_player_guild_id/1,
	get_guild_name/1,
	get_guild_member_class/2,
	get_guild_member_record/2,
	get_guild_chairman_id/1,
	get_player_and_guild_info/2,
	get_guild_applicatn_record/2,
	get_guild_member_list_by_rank/2,
	send_msg_to_all_member_process/2,
	send_msg_to_all_member/2,
	get_guild_property/2,
	get_building_list/1,
	get_attr_value_by_index/2,
	get_member_rank/1,
	get_member_rank/2,
	get_guild_level/1,
	make_guild_dynamic/1,
	send_guild_notice/3,
	get_rise_rank_index/3,
	get_down_rank_index/3,
	get_building_msg_index/3,
	active_can_exit_guild/0
]).

-export([get_guild_money/1, get_guild_member_num/1, get_guild_all_member_record/1, find_guild/1, get_guild_member_maps/1,
	find_guild_member/1, is_guild_member/2, has_guild/1, get_building_level/2, get_guild_maps_member/1, list_2_guild_base/1,
	guild_base_2_list/1, lists_2_guild_member/1, guild_member_2_list/1, get_donate_integral/1, get_exchange_integral/2,
	get_clean_guild_money/1, get_guild_usable_chest/1, check_add_treasure_chest/3, check_init_building/1, is_chariot_unlock/2,
	get_attr_value_list_by_index/2, send_msg_to_all_member_process/3, calc_active_value/3, get_all_guild_id/0, list_2_assign_award/1,
	assign_award_2_list/1, get_trading_market_discount/1, get_active_member_num/2, exist_guild/1]).
-export([get_guild_member_top/2]).

find_guild(GuildID) ->
	case table_global:lookup(?TableGuild, GuildID) of
		[] -> {};
		[R | _] -> R
	end.

find_guild_member(PlayerID) ->
	case table_global:lookup(?TableGuildMember, PlayerID) of
		[] -> {};
		[R | _] -> R
	end.

exist_guild(GuildId) ->
	table_global:member(?TableGuild, GuildId).

get_guild_member_maps(GuildID) ->
	etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID).

get_guild_total_battle_value(GuildID) ->
	MemberList = case etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID) of
					 #guild_member_maps{member_list = L} -> L;
					 _ -> []
				 end,
	lists:foldl(fun({_, _, Bv}, Sum) -> Bv + Sum end, 0, MemberList).

get_all_guild_id() ->
	table_global:key_list(?TableGuild).

sort_guild() ->
	sort_guild(table_global:record_list(?TableGuild)).
sort_guild(GuildList) ->
	SortFunc = fun(#guild_base{id = GuildID1, building_list = Build1, createTime = CrTime1}, #guild_base{id = GuildID2, building_list = Build2, createTime = CrTime2}) ->
		%% 先排仙盟总战斗力
		BV1 = get_guild_total_battle_value(GuildID1),
		BV2 = get_guild_total_battle_value(GuildID2),

		case BV1 > BV2 of
			?TRUE -> ?TRUE;
			?FALSE ->
				case BV1 =:= BV2 of
					?TRUE ->
						GuildLevel1 = proplists:get_value(?GuildBuilding_Lobby, Build1, 1),
						GuildLevel2 = proplists:get_value(?GuildBuilding_Lobby, Build2, 1),
						case GuildLevel1 > GuildLevel2 of
							?TRUE -> ?TRUE;
							?FALSE ->
								%% 战斗力也一样就按创建时间
								case GuildLevel1 =:= GuildLevel2 of
									?TRUE -> CrTime1 < CrTime2;
									?FALSE -> ?FALSE
								end
						end;
					?FALSE -> ?FALSE
				end
		end
			   end,
	lists:sort(SortFunc, GuildList).

get_guild_member_num(GuildID) ->
	case etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID) of
		#guild_member_maps{member_total = N} -> N;
		_ -> 0
	end.

gen_call(Request) ->
	gen_server:call(guildPID, Request).

%%通过下线时间得到离线1天，2天。。。
get_guild_mem_off_flag(Flag, LastOffTime) ->
	case Flag of
		1 -> 1;
		_ ->
			Now = time:time(),
			case is_number(LastOffTime) andalso LastOffTime > 0 of
				true ->
					Flag1 = erlang:trunc(time:time_offset(LastOffTime, Now) / 86400),
					case Flag1 > 0 of
						true ->
							case Flag1 of
								1 -> -1;
								2 -> -2;
								3 -> -3;
								4 -> -4;
								5 -> -5;
								6 -> -6;
								_ -> -7
							end;
						_ -> 0
					end;
				_ -> 0
			end
	end.

get_guild_all_member_record(GuildID) ->
	case etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID) of
		#guild_member_maps{member_list = List} ->
			KeyList = [PlayerID || {PlayerID, _, _} <- List],
			lists:foldl(fun(Key, Ret) ->
				case table_global:lookup(?TableGuildMember, Key) of
					[] -> Ret;
					[R | _] -> [R | Ret]
				end
						end, [], KeyList);
		_ -> []
	end.

get_guild_member_list(GuildID) ->
	GuildMapsInfo = get_guild_member_maps(GuildID),
	case GuildMapsInfo of
		{} -> [];
		_ ->
			[{PlayerID, Rank} || {PlayerID, Rank, _} <- GuildMapsInfo#guild_member_maps.member_list]
	end.

get_guild_member_id_list(GuildID) ->
	GuildMapsInfo = get_guild_member_maps(GuildID),
	case GuildMapsInfo of
		{} -> [];
		_ ->
			[PlayerID || {PlayerID, _, _} <- GuildMapsInfo#guild_member_maps.member_list]
	end.

get_guild_maps_member(GuildID) ->
	GuildMapsInfo = get_guild_member_maps(GuildID),
	case GuildMapsInfo of
		{} -> [];
		_ ->
			GuildMapsInfo#guild_member_maps.member_list
	end.

get_guild_member_top(GuildID, TopN) ->
	GuildMapsInfo = get_guild_member_maps(GuildID),
	case GuildMapsInfo of
		{} -> [];
		_ ->
			lists:sublist([PlayerID || {PlayerID, _, _} <- lists:reverse(lists:keysort(3, GuildMapsInfo#guild_member_maps.member_list))], TopN)
	end.

%% 遍历返回玩家申请帮派ID列表
get_player_applicant_list(PlayerID) ->
	Func = fun(Guild) ->
		ApplicantList = Guild#guild_base.applicantList,
		case lists:keyfind(PlayerID, #guildApplicant.playerID, ApplicantList) of
			false -> ok;
			_ -> Guild#guild_base.id
		end
		   end,
	common:listsFiterMap(Func, table_global:record_list(?TableGuild)).

get_player_guild_id(PlayerID) ->
	case table_global:lookup(?TableGuildMember, PlayerID) of
		[#guild_member{guildID = G} | _] -> G;
		_ -> 0
	end.

%%返回帮派名字
get_guild_name(0) -> "";
get_guild_name(GuildID) ->
	case table_global:lookup(?TableGuild, GuildID) of
		[#guild_base{guildName = Name}] -> Name;
		_ -> ""
	end.

%% 返回玩家的帮派职位　
get_guild_member_class(GuildID, PlayerID) ->
	Member = find_guild_member(PlayerID),
	case Member of
		#guild_member{guildID = GuildID, rank = Rank} -> Rank;
		_ -> 0
	end.

%%返回帮派成员信息记录
get_guild_member_record(GuildID, PlayerID) ->
	Member = find_guild_member(PlayerID),
	case Member of
		#guild_member{guildID = GuildID} = R -> R;
		_ -> {}
	end.

get_guild_chairman_id(GuildID) ->
	GuildInfo = find_guild(GuildID),
	case GuildInfo of
		{} -> 0;
		_ -> GuildInfo#guild_base.chairmanPlayerID
	end.

get_player_and_guild_info(GuildID, PlayerID) ->
	GuildInfo = find_guild(GuildID),
	MemberInfo = get_guild_member_record(GuildID, PlayerID),
	{GuildInfo, MemberInfo}.

%%获取申请表单记录
get_guild_applicatn_record(GuildBase, PlayerID) ->
	case lists:keyfind(PlayerID, #guildApplicant.playerID, GuildBase#guild_base.applicantList) of
		?FALSE -> {};
		R -> R
	end.

%% 获取帮派成员某官职成员列表
get_guild_member_list_by_rank(GuildID, Rank) when is_integer(Rank) ->
	[PlayerID || {PlayerID, Rk} <- get_guild_member_list(GuildID), Rk =:= Rank];
get_guild_member_list_by_rank(GuildID, RankList) ->
	[PlayerID || {PlayerID, Rk} <- get_guild_member_list(GuildID), lists:member(Rk, RankList)].

get_member_rank(PlayerID) ->
	GuildID = mirror_player:get_player_element(PlayerID, #player.guildID),
	get_member_rank(GuildID, PlayerID).
get_member_rank(GuildID, PlayerID) ->
	case etsBaseFunc:readRecord(?Ets_GuildMemberMaps, GuildID) of
		#guild_member_maps{member_list = List} ->
			case lists:keyfind(PlayerID, 1, List) of
				{_, R, _} -> R;
				_ -> 0
			end;

		_ -> 0
	end.

%% 战盟等级（取战盟大厅的等级）
get_guild_level(BuildingList) when is_list(BuildingList) ->
	proplists:get_value(?GuildBuilding_Lobby, BuildingList, 1);
get_guild_level(GuildID) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{building_list = L} ->
			proplists:get_value(?GuildBuilding_Lobby, L, 1);
		_ -> 0
	end.

get_building_level(GuildID, BuildID) ->
	case guild_pub:find_guild(GuildID) of
		#guild_base{building_list = L} ->
			proplists:get_value(BuildID, L, 1);
		_ -> 0
	end.

send_msg_to_all_member_process(GuildID, Msg) ->
	case guild_pub:get_guild_member_maps(GuildID) of
		#guild_member_maps{member_list = MemberList} ->
			Fun = fun({MemberID, _, _}) ->
				main:sendMsgToPlayerProcess(MemberID, Msg)
				  end,
			lists:foreach(Fun, MemberList);
		_ -> skip
	end.
send_msg_to_all_member_process(GuildID, Msg, ExceptList) ->
	case guild_pub:get_guild_member_maps(GuildID) of
		#guild_member_maps{member_list = MemberList} ->
			Fun = fun({MemberID, _, _}) ->
				lists:member(MemberID, ExceptList) orelse main:sendMsgToPlayerProcess(MemberID, Msg)
				  end,
			lists:foreach(Fun, MemberList);
		_ -> skip
	end.

%%发送消息给帮派所有成员
send_msg_to_all_member(GuildID, Msg) ->
	case get_guild_member_maps(GuildID) of
		{} -> ok;
		#guild_member_maps{member_list = List} ->
			lists:foreach(
				fun({MemberID, _, _}) ->
					case main:isOnline(MemberID) of
						?TRUE -> m_send:sendMsgToClient(MemberID, Msg);
						_ -> ok
					end
				end, List)
	end.

%% 获取帮派属性
get_guild_property(GuildID, Index) ->
	case find_guild(GuildID) of
		#guild_base{} = Base ->
			element(Index, Base);
		_ -> 0
	end.
get_guild_money(GuildID) ->
	get_guild_property(GuildID, #guild_base.guildMoney).

get_building_list(GuildID) ->
	case find_guild(GuildID) of
		#guild_base{building_list = L} -> L;
		_ -> []
	end.

%% 战盟属性加成值
get_attr_value_by_index(GuildID, Index) when is_integer(GuildID) ->
	List = get_building_list(GuildID),
	get_attr_value_by_index(List, Index);
get_attr_value_by_index(BuildingList, Index) ->
	BuildID = get_attr_building_id(Index),
	case lists:keyfind(BuildID, 1, BuildingList) of
		?FALSE -> 0;
		{_, BuildLv} ->
			case cfg_guildBuilding:getRow(BuildID, BuildLv) of
				#guildBuildingCfg{attrAdd = Attrs} ->
					case lists:keyfind(Index, 1, Attrs) of
						?FALSE -> 0;
						{_, V} -> V
					end;
				_ -> 0
			end
	end.

get_attr_value_list_by_index(GuildID, Index) when is_integer(GuildID) ->
	List = get_building_list(GuildID),
	get_attr_value_by_index(List, Index);
get_attr_value_list_by_index(BuildingList, Index) ->
	BuildID = get_attr_building_id(Index),
	case lists:keyfind(BuildID, 1, BuildingList) of
		?FALSE -> [];
		{_, BuildLv} ->
			case cfg_guildBuilding:getRow(BuildID, BuildLv) of
				#guildBuildingCfg{attrAdd = Attrs} ->
					[V || {I, V} <- Attrs, I =:= Index];
				_ -> []
			end
	end.

get_attr_building_id(Type) when Type =:= ?Guild_Member orelse Type =:= ?Guild_SuperElder orelse Type =:= ?Guild_ViceChairman
	orelse Type =:= ?Guild_Elder orelse Type =:= ?Guild_Elite orelse Type =:= ?Guild_Help ->
	?GuildBuilding_Lobby;
get_attr_building_id(Type) when Type =:= ?Guild_ShipTimesAdd orelse Type =:= ?Guild_ShipMultiple orelse Type =:= ?Guild_ShipTimeReduce ->
	?GuildBuilding_McShip;
get_attr_building_id(Type) when Type =:= ?Guild_TreasureChest orelse Type =:= ?Guild_RedEnvelop ->
	?GuildBuilding_Treasure;
get_attr_building_id(Type) when Type =:= ?Guild_DonateNum orelse Type =:= ?Guild_WishNum ->
	?GuildBuilding_WishPool;
get_attr_building_id(Type) when Type =:= ?Guild_ChariotTimeDec orelse Type =:= ?Guild_ChariotNum orelse Type =:= ?Guild_ChariotBack ->
	?GuildBuilding_Workshop;
get_attr_building_id(?Guild_FeteGodAdd) ->
	?GuildBuilding_FeteGod;
get_attr_building_id(?Guild_ShopItem) ->
	?GuildBuilding_Shop;
get_attr_building_id(?Guild_ChariotScience) ->
	?GuildBuilding_Tec;
get_attr_building_id(?Guild_TradingMarketDiscount) ->
	?GuildBuilding_TradingMarket.

get_donate_integral(Items) ->
	IntegralList = [get_donate_integral(Item, Equip) || {Item, Equip} <- Items],
	lists:sum(IntegralList).
get_donate_integral(Item, Equip) ->
	DonateParam = cfg_globalSetup:guildDonate1(),
	{OrderParam, CharacterParam, StarParam} = get_donate_integral_param(Item, Equip),
	trunc(DonateParam / 10000 * OrderParam / 10000 * CharacterParam / 10000 * StarParam / 10000).
get_exchange_integral(Item, Equip) ->
	DonateParam = cfg_globalSetup:guildDonate2(),
	{OrderParam, CharacterParam, StarParam} = get_donate_integral_param(Item, Equip),
	trunc(DonateParam / 10000 * OrderParam / 10000 * CharacterParam / 10000 * StarParam / 10000).
get_clean_guild_money(Items) ->
	IntegralList = [get_clean_guild_money(Item, Equip) || {Item, Equip} <- Items],
	lists:sum(IntegralList).
get_clean_guild_money(Item, Equip) ->
	DonateParam = cfg_globalSetup:guildDonate3(),
	{OrderParam, CharacterParam, StarParam} = get_donate_integral_param(Item, Equip),
	trunc(DonateParam / 10000 * OrderParam / 10000 * CharacterParam / 10000 * StarParam / 10000).

get_donate_integral_param(Item, Equip) ->
	#eq{character = Character, star = Star} = Equip,
	#equipBaseCfg{order = Order} = cfg_equipBase:getRow(Item#item.cfg_id),
	OrderParam = get_order_param(Order),
	CharacterParam = get_character_param(Character),
	StarParam = get_star_param(Star),
	{OrderParam, CharacterParam, StarParam}.

%% 阶数系数
get_order_param(1) -> cfg_globalSetup:guildDonateOrder1();
get_order_param(2) -> cfg_globalSetup:guildDonateOrder2();
get_order_param(3) -> cfg_globalSetup:guildDonateOrder3();
get_order_param(4) -> cfg_globalSetup:guildDonateOrder4();
get_order_param(5) -> cfg_globalSetup:guildDonateOrder5();
get_order_param(6) -> cfg_globalSetup:guildDonateOrder6();
get_order_param(7) -> cfg_globalSetup:guildDonateOrder7();
get_order_param(8) -> cfg_globalSetup:guildDonateOrder8();
get_order_param(9) -> cfg_globalSetup:guildDonateOrder9();
get_order_param(10) -> cfg_globalSetup:guildDonateOrder10();
get_order_param(11) -> cfg_globalSetup:guildDonateOrder11();
get_order_param(12) -> cfg_globalSetup:guildDonateOrder12();
get_order_param(13) -> cfg_globalSetup:guildDonateOrder13();
get_order_param(14) -> cfg_globalSetup:guildDonateOrder14();
get_order_param(15) -> cfg_globalSetup:guildDonateOrder15();
get_order_param(16) -> cfg_globalSetup:guildDonateOrder16();
get_order_param(17) -> cfg_globalSetup:guildDonateOrder17();
get_order_param(18) -> cfg_globalSetup:guildDonateOrder18();
get_order_param(19) -> cfg_globalSetup:guildDonateOrder19();
get_order_param(20) -> cfg_globalSetup:guildDonateOrder20();
get_order_param(_) -> 0.

get_character_param(0) -> cfg_globalSetup:guildDonateCharacter0();
get_character_param(1) -> cfg_globalSetup:guildDonateCharacter1();
get_character_param(2) -> cfg_globalSetup:guildDonateCharacter2();
get_character_param(3) -> cfg_globalSetup:guildDonateCharacter3();
get_character_param(4) -> cfg_globalSetup:guildDonateCharacter4();
get_character_param(5) -> cfg_globalSetup:guildDonateCharacter5();
get_character_param(6) -> cfg_globalSetup:guildDonateCharacter6();
get_character_param(_) -> 0.

get_star_param(0) -> cfg_globalSetup:guildDonateStar0();
get_star_param(1) -> cfg_globalSetup:guildDonateStar1();
get_star_param(2) -> cfg_globalSetup:guildDonateStar2();
get_star_param(3) -> cfg_globalSetup:guildDonateStar3();
get_star_param(_) -> 0.

make_guild_dynamic(Info) ->
	#pk_guild_event{
		name = richText:getPlayerTextByID(Info#guildEvent.player_id),
		rank = Info#guildEvent.rank,
		sex = mirror_player:get_player_sex(Info#guildEvent.player_id),
		type = Info#guildEvent.type,
		time = Info#guildEvent.time,
		params = Info#guildEvent.params
	}.

%% 任命公告信息
get_rise_rank_index(?GuildRank_ViceChairman, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice9, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice9", Language), Params) end);
get_rise_rank_index(?GuildRank_SuperElder, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice10, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice10", Language), Params) end);
get_rise_rank_index(?GuildRank_Elite, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice11, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice11", Language), Params) end);
get_rise_rank_index(?GuildRank_Elder, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice29, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice29", Language), Params) end);
get_rise_rank_index(_, _GuildID, _Params) ->
	{"", ""}.
%% 降职公告信息
get_down_rank_index(?GuildRank_ViceChairman, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice12, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice12", Language), Params) end);
get_down_rank_index(?GuildRank_SuperElder, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice13, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice13", Language), Params) end);
get_down_rank_index(?GuildRank_Elite, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice14, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice14", Language), Params) end);
get_down_rank_index(?GuildRank_Elder, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice30, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice30", Language), Params) end);
get_down_rank_index(?GuildRank_Normal, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice15, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice15", Language), Params) end);
get_down_rank_index(_, _GuildID, _Params) ->
	{"", ""}.
%% 建筑升级公告信息
get_building_msg_index(?GuildBuilding_Lobby, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice23, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice23", Language), Params) end);
get_building_msg_index(?GuildBuilding_FeteGod, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice24, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice24", Language), Params) end);
get_building_msg_index(?GuildBuilding_Shop, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice25, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice25", Language), Params) end);
get_building_msg_index(?GuildBuilding_Tec, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice26, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice26", Language), Params) end);
get_building_msg_index(?GuildBuilding_Depot, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice27, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice27", Language), Params) end);
get_building_msg_index(?GuildBuilding_Task, GuildID, Params) ->
	send_guild_notice(GuildID, guildNewNotice28, fun(Language) ->
		language:format(language:get_server_string("GuildNewNotice28", Language), Params) end);
get_building_msg_index(_BuildingID, _GuildID, _Params) ->
	{"", ""}.


%% 战盟公告
send_guild_notice(GuildID, NoticeIndex, LanguageFun) ->
	PlayerIDList = get_guild_member_id_list(GuildID),
	marquee:sendChannelNotice(PlayerIDList, GuildID, NoticeIndex, LanguageFun),
	ok.

active_can_exit_guild() ->
	not guild_guard_player:is_in_ac()
		andalso not bonfire_boss_logic:is_drink_active()
		andalso not yanmo:is_in_ac()
		andalso domain_fight_logic:can_exit_guild()
		andalso not manor_war_logic:is_in_ac().

is_guild_member(GuildID, PlayerID) ->
	case find_guild_member(PlayerID) of
		#guild_member{guildID = GuildID} -> ?TRUE;
		_ -> ?FALSE
	end.

has_guild(GuildID) ->
	table_global:member(?TableGuild, GuildID).

%% 检查初始化建筑等级
check_init_building(List) ->
	AllBuilding = lists:seq(?GuildBuilding_Start, ?GuildBuilding_End),
	case lists:filter(fun(ID) ->
		not lists:keymember(ID, 1, List) end, AllBuilding) of
		[] -> List;
		New -> List ++ [{ID, 1} || ID <- New]
	end.

list_2_guild_base(List) ->
	Record = list_to_tuple([guild_base | List]),
	Record#guild_base{
		chairmanPlayerName = unicode:characters_to_list(Record#guild_base.chairmanPlayerName),
		guildName = unicode:characters_to_list(Record#guild_base.guildName),
		announcement = unicode:characters_to_list(Record#guild_base.announcement),
		applicantList = gamedbProc:dbstring_to_term(Record#guild_base.applicantList),
		feteIDList = gamedbProc:dbstring_to_term(Record#guild_base.feteIDList),
		eventList = gamedbProc:dbstring_to_recordlist(Record#guild_base.eventList, guildEventList),
		wishList = binary_to_term(Record#guild_base.wishList),
		battlefield = gamedbProc:dbstring_to_term(Record#guild_base.battlefield),
		enterCondition = gamedbProc:dbstring_to_term(Record#guild_base.enterCondition),
		moneyLog_list = gamedbProc:dbstring_to_term(Record#guild_base.moneyLog_list),
		building_list = check_init_building(gamedbProc:dbstring_to_term(Record#guild_base.building_list)),
		chariot_science_list = gamedbProc:dbstring_to_term(Record#guild_base.chariot_science_list),
		link_url = unicode:characters_to_list(Record#guild_base.link_url)
	}.

guild_base_2_list(Record) ->
	tl(tuple_to_list(Record#guild_base{
		applicantList = gamedbProc:term_to_dbstring(Record#guild_base.applicantList),
		feteIDList = gamedbProc:term_to_dbstring(Record#guild_base.feteIDList),
		eventList = gamedbProc:recordlist_to_dbstring(Record#guild_base.eventList),
		wishList = term_to_binary(Record#guild_base.wishList),
		battlefield = gamedbProc:term_to_dbstring(Record#guild_base.battlefield),
		enterCondition = gamedbProc:term_to_dbstring(Record#guild_base.enterCondition),
		moneyLog_list = gamedbProc:term_to_dbstring(Record#guild_base.moneyLog_list),
		building_list = gamedbProc:term_to_dbstring(Record#guild_base.building_list),
		chariot_science_list = gamedbProc:term_to_dbstring(Record#guild_base.chariot_science_list)
	})).

lists_2_guild_member(List) ->
	Record = list_to_tuple([guild_member | List]),
	Record#guild_member{
		playerName = unicode:characters_to_list(Record#guild_member.playerName),
		feteList = gamedbProc:dbstring_to_term(Record#guild_member.feteList),
		giveList = gamedbProc:dbstring_to_recordlist(Record#guild_member.giveList, giveInfo),
		active_value_access = gamedbProc:dbstring_to_term(Record#guild_member.active_value_access)
	}.

guild_member_2_list(Record) ->
	tl(tuple_to_list(Record#guild_member{
		feteList = gamedbProc:term_to_dbstring(Record#guild_member.feteList),
		giveList = gamedbProc:recordlist_to_dbstring(Record#guild_member.giveList),
		active_value_access = gamedbProc:term_to_dbstring(Record#guild_member.active_value_access)
	})).

%% 获取可用宝箱数量
get_guild_usable_chest(Guild) ->
	#guild_base{treasure_chest = Score, treasure_chest_consume = Num, building_list = BuildingList} = Guild,
	MaxNum = guild_pub:get_attr_value_by_index(BuildingList, ?Guild_TreasureChest),
	ID = common:getValueByInterval1(Score, lists:usort(cfg_guildTreasuryuse:getKeyList()), 0),
	AddNum = case cfg_guildTreasuryuse:getRow(ID) of
				 #guildTreasuryuseCfg{acquireNum = N} -> min(N, MaxNum);
				 _ -> 0
			 end,
	max(AddNum - Num, 0).

%% 检查获得宝箱积分
check_add_treasure_chest(Type, Param, GuildID) ->
	case cfg_guildTreasuryAcquire:getRow(Type) of
		#guildTreasuryAcquireCfg{getRedBagWay = NeedParam, giveRedBag = AddNum} when NeedParam >= Param ->
			guild:send_2_me({changeGuildTreasureChest, GuildID, AddNum});
		_ -> ok
	end.

is_chariot_unlock(Type, ChariotScienceList) ->
	case cfg_guildchariot:getRow(Type) of
		{} -> ?FALSE;
		#guildchariotCfg{science = Science} ->
			lists:member(Science, ChariotScienceList)
	end.

calc_active_value([], _, Acc) -> Acc;
calc_active_value([{ID, Times} | T], AccessCfg, Acc) ->
	case lists:keyfind(ID, 1, AccessCfg) of
		{_, Score, _} -> calc_active_value(T, AccessCfg, Times * Score + Acc);
		_ -> calc_active_value(T, AccessCfg, Acc)
	end.

list_2_assign_award(List) ->
	Record = list_to_tuple([guild_assign_award | List]),
	Record#guild_assign_award{
		list = gamedbProc:my_binary_to_term(Record#guild_assign_award.list, []),
		log_list = gamedbProc:my_binary_to_term(Record#guild_assign_award.log_list, [])
	}.

assign_award_2_list(Record) ->
	tl(tuple_to_list(Record#guild_assign_award{
		list = term_to_binary(Record#guild_assign_award.list, [compressed]),
		log_list = term_to_binary(Record#guild_assign_award.log_list, [compressed])
	})).

get_trading_market_discount(GuildID) ->
	get_attr_value_by_index(GuildID, ?Guild_TradingMarketDiscount).

get_active_member_num(GuildID, ActiveDay) ->
	MemberIDList = get_guild_member_id_list(GuildID),
	NowTime = time:time(),
	ActiveTime = NowTime - ActiveDay * ?SECONDS_PER_DAY,
	lists:foldl(fun(MemberID, Acc) ->
		case find_guild_member(MemberID) of
			#guild_member{isOnline = IsOnline, lastOffTime = LastOffTime} when IsOnline =:= 1 orelse LastOffTime >= ActiveTime ->
				Acc + 1;
			_ -> Acc
		end
				end, 0, MemberIDList).