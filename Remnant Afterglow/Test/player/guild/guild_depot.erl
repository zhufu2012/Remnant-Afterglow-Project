%%%-------------------------------------------------------------------
%%% @author zhangrj
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%% 战盟仓库（战盟进程)
%%% @end
%%% Created : 06. 八月 2018 14:22
%%%-------------------------------------------------------------------
-module(guild_depot).
-author("zhangrj").
-include("guild.hrl").
-include("record.hrl").
-include("db_table.hrl").
-include("error.hrl").
-include("item.hrl").
-include("netmsgRecords.hrl").
-include("logger.hrl").
-include("cfg_equipBase.hrl").

-define(TableItem, db_item_guild).
-define(TableEq, db_eq_guild).

%% API
-export([load/0, donate_item/3, exchange_depot_item/4, delete_guild_item/3]).
-export([depot_auto_clear_set/1]).
-export([auto_clear/1]).

load() ->
	PartGuildItem = table_global:fold(fun(#db_item_player{player_id = GuildID} = R, Ret) ->
		case lists:keytake(GuildID, 1, Ret) of
			?FALSE -> [{GuildID, item, [bag_player:from_db_item(R)]} | Ret];
			{_, {_, _, OldList}, Left} -> [{GuildID, item, [bag_player:from_db_item(R) | OldList]} | Left]
		end
									  end, [], ?TableItem),
	PartGuildEq = table_global:fold(fun(#db_eq{player_id = GuildID} = R, Ret) ->
		case table_global:lookup(?TableItem, R#db_eq.uid) of
			[_] ->
				case lists:keytake(GuildID, 1, Ret) of
					?FALSE -> [{GuildID, eq, [eq:from_db_eq(R)]} | Ret];
					{_, {_, _, OldList}, Left} -> [{GuildID, eq, [eq:from_db_eq(R) | OldList]} | Left]
				end;
			_ -> Ret
		end
									end, [], ?TableEq),
	InsertFunc = fun
					 ({GuildID, item, ItemList}, Ret) ->
						 case lists:keytake(GuildID, #guildDepot.id, Ret) of
							 ?FALSE -> [#guildDepot{id = GuildID, item_list = ItemList} | Ret];
							 {_, Info, Left} -> [Info#guildDepot{id = GuildID, item_list = ItemList} | Left]
						 end;
					 ({GuildID, eq, EqList}, Ret) ->
						 case lists:keytake(GuildID, #guildDepot.id, Ret) of
							 ?FALSE -> [#guildDepot{id = GuildID, equip_list = EqList} | Ret];
							 {_, Info, Left} -> [Info#guildDepot{id = GuildID, equip_list = EqList} | Left]
						 end
				 end,
	Ret1 = lists:foldl(InsertFunc, [], PartGuildItem),
	Ret2 = lists:foldl(InsertFunc, Ret1, PartGuildEq),
	etsBaseFunc:insertRecord(?GuildDepotEts, Ret2),
	ok.

update_eq(Eq, GuildID) ->
	Info = case is_list(Eq) of
			   ?TRUE -> [eq:eq_2_db_eq(Eq0, GuildID) || Eq0 <- Eq];
			   ?FALSE -> eq:eq_2_db_eq(Eq, GuildID)
		   end,
	table_global:insert(?TableEq, Info).

update_item(Item, GuildID) ->
	Info = case is_list(Item) of
			   ?TRUE -> [bag_player:to_db_item(Item0, GuildID, 0) || Item0 <- Item];
			   ?FALSE -> bag_player:to_db_item(Item, GuildID, 0)
		   end,
	table_global:insert(?TableItem, Info).

delete(IDList) when is_list(IDList) ->
	table_global:delete(?TableEq, IDList),
	table_global:delete(?TableItem, IDList);
delete(ID) ->
	table_global:delete(?TableEq, [ID]),
	table_global:delete(?TableItem, [ID]).

%% 捐赠道具
donate_item(GuildID, PlayerID, DonateItems) ->
	try
		case guild_pub:find_guild(GuildID) of
			{} -> throw(?ErrorCode_Guild_NoGuild);
			_ -> ok
		end,
		case etsBaseFunc:readRecord(?GuildDepotEts, GuildID) of
			{} ->
				Items = [Item || {Item, _Equip} <- DonateItems],
				Equips = [Equip || {_Item, Equip} <- DonateItems],
				RetCode = 0,
				RealItems = DonateItems,
				NewDepot = #guildDepot{id = GuildID, equip_list = Equips, item_list = Items};
			Depot ->
				MaxCount = guild_pub:get_attr_value_by_index(GuildID, ?Guild_Depot),
				case length(Depot#guildDepot.equip_list) + length(DonateItems) > MaxCount of
					?TRUE ->
						RealItems = lists:sublist(DonateItems, MaxCount - length(Depot#guildDepot.equip_list)),
						RetCode = ?ErrorCode_Guild_DepotFull;
					?FALSE ->
						RealItems = DonateItems,
						RetCode = 0
				end,

				case length(Depot#guildDepot.equip_list) + length(DonateItems) >= MaxCount of
					?TRUE ->
						guild:send_2_me({auto_clear, GuildID});
					?FALSE -> skip
				end,

				Items = [Item || {Item, _Equip} <- RealItems],
				Equips = [Equip || {_Item, Equip} <- RealItems],
				NewDepot = Depot#guildDepot{
					equip_list = Depot#guildDepot.equip_list ++ Equips,
					item_list = Depot#guildDepot.item_list ++ Items
				}
		end,
		etsBaseFunc:insertRecord(?GuildDepotEts, NewDepot),
		update_eq(Equips, GuildID),
		update_item(Items, GuildID),
		Integral = guild_pub:get_donate_integral(RealItems),
		guild:add_member_integral(GuildID, PlayerID, Integral),
		[guild_event:add_guild_event(GuildID, ?EventModule_3, 1, PlayerID, [E#eq.uid, E#eq.item_data_id, E#eq.character]) || E <- Equips],
		add_depot_show_eq(Equips),
		PlayerText = richText:getPlayerTextByID(PlayerID),
		lists:foreach(fun(DonateItem) ->
			guild_pub:send_guild_notice(GuildID, guildNewNotice21,
				fun(Language) ->
					language:format(language:get_server_string("GuildNewNotice21", Language),
						[PlayerText, richText:getItemText(DonateItem, Language)])
				end)
					  end, RealItems),

		%% 捐献失败返回
		case DonateItems -- RealItems of
			[] -> ok;
			FailedItems -> player_offevent:save_offline_event(PlayerID, ?Offevent_Type_GuildDonate, {FailedItems})
		end,
		logdbProc:log_guild_depot(GuildID, PlayerID, 1, [{E#eq.uid, E#eq.item_data_id, E#eq.character} || E <- Equips]),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_donateItemResult{itemID = 0, result = RetCode}),
		ok
	catch
		ErrorCode ->
			player_offevent:save_offline_event(PlayerID, ?Offevent_Type_GuildDonate, {DonateItems}),
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_donateItemResult{itemID = 0, result = ErrorCode})
	end.

%% 是否可以删除装备
can_delete_equip(Depot, Item, Equip) ->
	lists:keyfind(Item#item.id, #item.id, Depot#guildDepot.item_list) =/= ?FALSE andalso
		lists:keyfind(Equip#eq.uid, #eq.uid, Depot#guildDepot.equip_list) =/= {}.

%% 兑换道具
exchange_depot_item(GuildID, PlayerID, Equip, Item) ->
	case guild_pub:find_guild(GuildID) of
		{} -> ?ErrorCode_Guild_NoGuild;
		_ ->
			case etsBaseFunc:readRecord(?GuildDepotEts, GuildID) of
				{} -> ?ErrorCode_Guild_DepotEmpty;
				Depot ->
					case can_delete_equip(Depot, Item, Equip) of
						?TRUE ->
							NewEquipList = lists:delete(Equip, Depot#guildDepot.equip_list),
							NewItemList = lists:delete(Item, Depot#guildDepot.item_list),
							etsBaseFunc:changeFiled(?GuildDepotEts, GuildID, [{#guildDepot.equip_list, NewEquipList}, {#guildDepot.item_list, NewItemList}]),
							delete(Item#item.id),
							guild_event:add_guild_event(GuildID, ?EventModule_3, 2, PlayerID, [Equip#eq.uid, Equip#eq.item_data_id, Equip#eq.character, 1]),
							add_depot_show_eq(Equip),
							logdbProc:log_guild_depot(GuildID, PlayerID, 2, [{Equip#eq.uid, Equip#eq.item_data_id, Equip#eq.character}]),
							0;
						?FALSE -> ?ErrorCode_Guild_Exchanged
					end
			end
	end.

%% 删除道具
delete_guild_item(PlayerID, GuildID, IDList0) ->
	try
		IDList = lists:usort(IDList0),
		Depot =
			case etsBaseFunc:readRecord(?GuildDepotEts, GuildID) of
				{} -> throw(?ErrorCode_Guild_NoGuild);
				R -> R
			end,
		DelList =
			lists:map(
				fun(ID) ->
					Item = lists:keyfind(ID, #item.id, Depot#guildDepot.item_list),
					Equip = lists:keyfind(ID, #eq.uid, Depot#guildDepot.equip_list),
					case Item =/= ?FALSE andalso Equip =/= ?FALSE of
						?TRUE -> ok;
						?FALSE -> throw({ID, ?ErrorCode_Guild_NotExist})
					end,
					{Item, Equip}
				end, IDList),
		%% 增加战盟基金
		GuildMoney = guild_pub:get_clean_guild_money(DelList),
		guild:add_guild_money(GuildID, GuildMoney),
		%% 删除道具
		DelItems = [Item || {Item, _Equip} <- DelList],
		DelEquips = [Equip || {_Item, Equip} <- DelList],
		ItemList = Depot#guildDepot.item_list -- DelItems,
		EquipList = Depot#guildDepot.equip_list -- DelEquips,
		etsBaseFunc:changeFiled(?GuildDepotEts, GuildID, [{#guildDepot.item_list, ItemList}, {#guildDepot.equip_list, EquipList}]),
		delete(IDList),

		guild_event:add_guild_event(GuildID, ?EventModule_3, 3, PlayerID, [length(IDList), GuildMoney]),
		Params = [richText:getPlayerTextByID(PlayerID), length(IDList)],
		case guild_pub:get_member_rank(GuildID, PlayerID) of
			?GuildRank_Chairman ->
				guild_pub:send_guild_notice(GuildID, guildNewNotice22,
					fun(Language) ->
						language:format(language:get_server_string("GuildNewNotice22", Language), Params)
					end);
			?GuildRank_SuperElder ->
				guild_pub:send_guild_notice(GuildID, guildNewNotice22,
					fun(Language) ->
						language:format(language:get_server_string("GuildNewNotice33", Language), Params)
					end);
			?GuildRank_ViceChairman ->
				guild_pub:send_guild_notice(GuildID, guildNewNotice22,
					fun(Language) ->
						language:format(language:get_server_string("GuildNewNotice34", Language), Params)
					end);
			_ -> ok
		end,
		logdbProc:log_guild_depot(GuildID, PlayerID, 3,
			[{Equip#eq.uid, Equip#eq.item_data_id, Equip#eq.character} || Equip <- Depot#guildDepot.equip_list, lists:member(Equip#eq.uid, IDList)]),
		m_send:sendMsgToClient(PlayerID, #pk_GS2U_deleteFromGuildBagResult{saleID = 0, result = 0})
	catch
		{DBID, ErrorCode} ->
			m_send:sendMsgToClient(PlayerID, #pk_GS2U_deleteFromGuildBagResult{saleID = DBID, result = ErrorCode});
		ErrorCode -> m_send:sendMsgToClient(PlayerID, #pk_GS2U_deleteFromGuildBagResult{saleID = 0, result = ErrorCode})
	end.
depot_auto_clear_set({PlayerId, GuildId, Enable, Chara, Star, Order}) ->
	try
		Guild = case guild_pub:find_guild(GuildId) of
					{} -> throw(?ErrorCode_Guild_NoGuild);
					R -> R
				end,
		EnableInt = common:bool_to_int(Enable),
		<<Flag:32>> = <<EnableInt:8, Chara:8, Star:8, Order:8>>,

		NewGuild = Guild#guild_base{depot_clear_flag = Flag},
		guild:update_guild(NewGuild),
		[m_send:sendMsgToClient(MemberId, #pk_GS2U_GuildDepotAutoClearStateSync{enable = Enable, chara = Chara, star = Star, order = Order})
			|| {MemberId, Rank} <- guild_pub:get_guild_member_list(GuildId), Rank >= ?GuildRank_ViceChairman],

		MaxCount = guild_pub:get_attr_value_by_index(GuildId, ?Guild_Depot),
		case etsBaseFunc:readRecord(?GuildDepotEts, GuildId) of
			#guildDepot{equip_list = L} ->
				case length(L) >= MaxCount of
					?TRUE -> guild:send_2_me({auto_clear, GuildId});
					_ -> skip
				end;
			_ -> skip
		end,
		m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildDepotAutoClearSet{err_code = ?ERROR_OK})
	catch
		ErrorCode -> m_send:sendMsgToClient(PlayerId, #pk_GS2U_GuildDepotAutoClearSet{err_code = ErrorCode})
	end.

%% 自动清理
auto_clear(GuildId) ->
	try
		Guild = case guild_pub:find_guild(GuildId) of
					{} -> throw(skip);
					G -> G
				end,
		#guild_base{depot_clear_flag = Flag} = Guild,
		<<Enable:8, Chara:8, Star:8, Order:8>> = <<Flag:32>>,

		case Enable of
			1 -> skip;
			_ -> throw(skip)
		end,
		Depot = case etsBaseFunc:readRecord(?GuildDepotEts, GuildId) of
					{} -> throw(skip);
					R -> R
				end,
		#guildDepot{equip_list = EqList1, item_list = ItemList1} = Depot,
		DelList = auto_clear_1(EqList1, ItemList1, {Chara, Star, Order}, []),
		case DelList of
			[] -> skip;
			_ ->
				%% 增加战盟基金
				GuildMoney = guild_pub:get_clean_guild_money(DelList),
				guild:add_guild_money(GuildId, GuildMoney),
				%% 删除道具
				DelItems = [Item || {Item, _Equip} <- DelList],
				DelEquips = [Equip || {_Item, Equip} <- DelList],
				IDList = [Uid || {_Item, #eq{uid = Uid}} <- DelList],
				ItemList = Depot#guildDepot.item_list -- DelItems,
				EquipList = Depot#guildDepot.equip_list -- DelEquips,
				etsBaseFunc:changeFiled(?GuildDepotEts, GuildId, [{#guildDepot.item_list, ItemList}, {#guildDepot.equip_list, EquipList}]),
				delete(IDList),

				guild_event:add_guild_event(GuildId, ?EventModule_3, 4, 0, [length(IDList), GuildMoney]),
				[m_send:sendMsgToClient(Mid, #pk_GS2U_deleteFromGuildBagResult{saleID = 0, result = 0}) || Mid <- guild_pub:get_guild_member_id_list(GuildId)],

				logdbProc:log_guild_depot(GuildId, 0, 4,
					[{Equip#eq.uid, Equip#eq.item_data_id, Equip#eq.character} || Equip <- Depot#guildDepot.equip_list, lists:member(Equip#eq.uid, IDList)])
		end
	catch
		skip -> skip;
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace))
	end.

auto_clear_1([], _ItemList, _Condition, Ret) -> Ret;
auto_clear_1([Eq | T], ItemList, {Chara, Star, Order} = Condition, Ret) ->
	try
		#eq{character = C, star = S, item_data_id = ItemDataId, uid = Uid} = Eq,
		#equipBaseCfg{order = O} = cfg_equipBase:getRow(ItemDataId),
		case C =< Chara andalso S =< Star andalso O =< Order of
			?TRUE ->
				Item = lists:keyfind(Uid, #item.id, ItemList),
				auto_clear_1(T, ItemList, Condition, [{Item, Eq} | Ret]);
			_ -> auto_clear_1(T, ItemList, Condition, Ret)
		end
	catch
		Class:ExcReason:Stacktrace ->
			?LOG_ERROR(?LOG_STACKTRACE(Class, ExcReason, Stacktrace)),
			auto_clear_1(T, ItemList, Condition, Ret)
	end.

%% 增加装备显示信息
add_depot_show_eq(Equips) ->
	guild_event ! {add_depot_show_eq, Equips}.
