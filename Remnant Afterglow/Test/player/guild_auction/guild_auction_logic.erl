%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%              战盟争霸管理进程逻辑处理
%%% @end
%%% Created : 19. 十二月 2018 15:55
%%%-------------------------------------------------------------------
-module(guild_auction_logic).
-author("cbfan").
-include("guild_auction.hrl").
-include("netmsgRecords.hrl").
-include("attainment.hrl").
-include("reason.hrl").
-include("item.hrl").
-include("cfg_guildBonus.hrl").
-include("guild.hrl").
-include("id_generator.hrl").
-include("currency.hrl").

-include("cfg_guildShopAuctionNew.hrl").

%% API
-export([on_init/0, on_tick/0, add_auction/1, open_ui/3, close_ui/2, bid/1, bid_immediate/1, on_settle_accounts/0, get_all_curr/2]).
-export([auction_2_list/1, list_2_auction/1, auction_item_2_list/1, list_2_auction_item/1, set_bid_authority/1, select_guild_authority/1,
	on_manager_online/1]).

on_init() ->
	ets:new(?Ets_GuildAuction, [set, protected, named_table, {keypos, #ga.guild_id}, ?ETSRC, ?ETSWC]),
	ets:new(?Ets_GuildAuctionItem, [set, protected, named_table, {keypos, #ga_item_info.id}, ?ETSRC, ?ETSWC]),
	ets:new(?Ets_GuildAuctionHistory, [duplicate_bag, protected, named_table, {keypos, #ga_item_history.guild_id}, ?ETSRC, ?ETSWC]),
	ets:new(?Ets_GuildAuctionProfitHistory, [bag, protected, named_table, {keypos, #ga_profit_history.guild_id}, ?ETSRC, ?ETSWC]),
	GaList = table_global:fold(fun({_, GuildId, AcId, PlayerList, Tax, IdList, EndTime, AuthPlayerID, AuthEndTime}, Ret) ->
		case lists:keytake(GuildId, #ga.guild_id, Ret) of
			?FALSE ->
				[#ga{guild_id = GuildId, ga_info = [#ga_info{ac_id = AcId, player_list = PlayerList, tax = Tax,
					id_list = IdList, end_time = EndTime, authority_player_id = AuthPlayerID, authority_end_time = AuthEndTime}]} | Ret];
			{_, OldGa, Left} ->
				[OldGa#ga{guild_id = GuildId, ga_info = [#ga_info{ac_id = AcId, player_list = PlayerList, tax = Tax,
					id_list = IdList, end_time = EndTime, authority_player_id = AuthPlayerID, authority_end_time = AuthEndTime} | OldGa#ga.ga_info]} | Left]
		end
							   end, [], db_guild_auction),
	GaItemList = table_global:record_list(db_guild_auction_item),
	?LOG_INFO("found not deal complete auction :~p", [{GaList, GaItemList}]),
	ets:insert(?Ets_GuildAuction, GaList),
	ets:insert(?Ets_GuildAuctionItem, GaItemList),
	ok.

on_tick() ->
	erlang:send_after(1000, self(), tick),
	Time = time:time(),
	UpdateList = ets:foldl(fun(#ga{guild_id = GuildID, ga_info = GaInfoList} = Ga, Ret) ->
		{IsChange, NewGaInfo} = lists:foldl(fun(#ga_info{ac_id = AcID, end_time = EndTime, authority_end_time = AuEndTime} = GaInfo, {Ret1, Ret2}) ->
			case Time >= EndTime of
				?TRUE ->
					on_settle_accounts_by_ac(GuildID, AcID),
					{Ret1, Ret2};
				?FALSE ->
					case AuEndTime > 0 andalso Time >= AuEndTime of
						?TRUE ->
							authority_time_end(GuildID, AcID),
							{?TRUE, lists:keystore(AcID, #ga_info.ac_id, Ret2, GaInfo#ga_info{authority_end_time = 0})};
						?FALSE -> {Ret1, Ret2}
					end
			end
											end, {?FALSE, GaInfoList}, GaInfoList),
		case IsChange of
			?FALSE -> Ret;
			?TRUE -> [Ga#ga{ga_info = NewGaInfo} | Ret]
		end
						   end, [], ?Ets_GuildAuction),
	case UpdateList =/= [] of
		?FALSE -> ok;
		?TRUE ->
			ets:insert(?Ets_GuildAuction, UpdateList),
			[update_db_guild_auction(NewGuildInfo) || NewGuildInfo <- UpdateList]
	end,
	ok.

authority_time_end(GuildID, AcID) ->
	Q1 = ets:fun2ms(fun(#ga_item_info{activity_id = ID, guild_id = Gid, bid_state = BindState, player_id = PlayerID} = R)
		when (ID =:= AcID andalso Gid =:= GuildID) andalso (BindState =:= 2 orelse (BindState =:= 1 andalso PlayerID =:= 0)) ->
		R end),
	AuctionList = ets:select(?Ets_GuildAuctionItem, Q1),
	case AuctionList =/= [] of
		?TRUE ->
			{UpdateInfo, SendMsgList} = lists:mapfoldl(fun(#ga_item_info{} = Info, Ret) ->
				NewInfo = Info#ga_item_info{bid_state = 0},
				NewRet = [#pk_ga_item_refresh{
					ga_id = NewInfo#ga_item_info.id,
					bought = NewInfo#ga_item_info.bought,
					player_name = NewInfo#ga_item_info.player_name,
					times = NewInfo#ga_item_info.times,
					bid_state = NewInfo#ga_item_info.bid_state
				} | Ret],
				{NewInfo, NewRet}
													   end, [], AuctionList),
			ets:insert(?Ets_GuildAuctionItem, UpdateInfo),
			table_global:insert(db_guild_auction_item, UpdateInfo),
			Msg = #pk_GS2U_GAItemRefresh{list = SendMsgList},
			sync_msg(GuildID, Msg);
		?FALSE -> ok
	end.

%% {PlayerId, PlayerName} PlayerList
%% {ItemList1, EqList1}：竞拍列表
%% {ItemList2, EqList2}：个人限购
add_auction({GuildId, ActivityId, SourceID, {ItemList1, EqList1}, {ItemList2, EqList2}, PlayerList}) ->
	NewPlayerList =
		case PlayerList of
			%% 守卫战盟拍卖特殊处理
			{1, ListP} ->
				ListP1 = lists:umerge(get_guild_auction(), ListP),
				set_guild_auction(ListP1),
				ListP1;
			L -> L
		end,
	?LOG_INFO("add_auction :~p", [{GuildId, ActivityId, ItemList1, EqList1, NewPlayerList}]),
	clear_history(GuildId, ActivityId),
	List1 = add_item(ItemList1 ++ EqList1, {ActivityId, SourceID, GuildId, ?ACType_Auction}, []),
	List2 = add_item(ItemList2 ++ EqList2, {ActivityId, SourceID, GuildId, ?ACType_Amount}, []),
	List = List1 ++ List2,
	F = fun(Info = #ga_item_info{id = Id}, {R1, R2}) -> {[Id | R1], [Info | R2]} end,
	{L1, L2} = lists:foldl(F, {[], []}, List),
	case L2 =:= [] of
		?TRUE -> skip;
		_ ->
			ets:insert(?Ets_GuildAuctionItem, L2),
			table_global:insert(db_guild_auction_item, L2),
			GuildInfo = case ets:lookup(?Ets_GuildAuction, GuildId) of
							[#ga{} = Value] -> Value;
							_ -> #ga{guild_id = GuildId}
						end,

			Section = length(NewPlayerList),
			TaxList = lists:keysort(1, [{P1, P2} || #guildBonusCfg{section = P1, tax = P2} <- cfg_guildBonus:rows()]),
			Tax = case common:getValueByInterval(Section, TaxList, 0) of
					  0 -> #guildBonusCfg{tax = T} = cfg_guildBonus:last_row(), T;
					  {_, T} -> T
				  end,

			#ga{ga_info = GaInfoList, viewer_list = ViewerList} = GuildInfo,
			NowTime = time:time(),
			GaStartTime = time:time_add(NowTime, cfg_globalSetup:preauctionwaitingtime()),
			GaEndTime = time:time_add(NowTime, get_auction_keep_time(ActivityId)),
			GaInfo = case lists:keyfind(ActivityId, #ga_info.ac_id, GaInfoList) of
						 #ga_info{id_list = OldIdList} = OldGaInfo ->
							 OldGaInfo#ga_info{ac_id = ActivityId, player_list = NewPlayerList, id_list = L1 ++ OldIdList, tax = Tax, start_time = GaStartTime, end_time = GaEndTime};
						 _ ->
							 AuthPlayerID = select_guild_authority(GuildId),
							 AuthEndTime = NowTime + get_authority_time(ActivityId),
							 AuthPlayerID > 0 andalso local:sendPlayerClientMsg(AuthPlayerID, #pk_GS2U_get_authority_red{ac_id = ActivityId, type = 1}),
							 #ga_info{ac_id = ActivityId, player_list = NewPlayerList, id_list = L1, tax = Tax, start_time = GaStartTime, end_time = GaEndTime, authority_player_id = AuthPlayerID, authority_end_time = AuthEndTime}
					 end,
%% TODO  上一场为结算的数据分红怎么算
%%			GaInfo = #ga_info{ac_id = ActivityId, player_list = PlayerList, id_list = L1, tax = Tax},

			NewGuildInfo = GuildInfo#ga{ga_info = lists:keystore(ActivityId, #ga_info.ac_id, GaInfoList, GaInfo)},
			ets:insert(?Ets_GuildAuction, NewGuildInfo),
			update_db_guild_auction(NewGuildInfo),
			case ViewerList =/= [] of
				?TRUE ->
					F1 = fun({PlayerId, Pid}) ->
						Records = [make_record_msg(ItemInfo, PlayerId) || ItemInfo <- L2],
						Msg1 = [#pk_ga_ac_info{
							player_num = length(PL), tax = Tax1, ac_id = ActivityId1,
							self_can_profit = lists:keymember(PlayerId, 1, PL),
							end_time = ETime, authority_end_time = AuthEndTime, authority_player_id = AuthPlayerID
						} || #ga_info{player_list = PL, tax = Tax1, ac_id = ActivityId1, end_time = ETime, authority_end_time = AuthEndTime,
							authority_player_id = AuthPlayerID} <- NewGuildInfo#ga.ga_info],
						m_send:send_pid_msg_2_client(Pid, #pk_GS2U_RequestGAInfoRet{info = Records, ac_info = Msg1})
						 end,
					[F1(V) || V <- ViewerList];
				_ -> skip
			end,
			guild_pub:send_msg_to_all_member_process(GuildId, {sendToClient, #pk_GS2U_GARedDotShow{ac_ids = [ActivityId]}})
	end.

make_record_msg(ItemInfo, PlayerId) ->
	#ga_item_info{id = Id, activity_id = AcId, ac_type = AcType, item_id = ItemId, amount = Amount, bind = Bind, eq = Eq, times = Times, source_id = SourceID,
		player_name = PlayerName, bought = Bought, cfg_key = CfgKey, bid_type = BidType, can_bid_list = CanBidList, bid_state = BidState} = ItemInfo,
	Cfg = cfg_guildShopAuctionNew:row(CfgKey),
	#pk_ga_item{
		bought = Bought, ac_type = AcType, max_buy = Amount,
		ga_id = Id, ac_id = AcId, item_id = ItemId, bind = Bind, times = Times, player_name = PlayerName,
		eq = [eq:make_eq_msg(E) || {_, E} <- Eq],
		curr_type = Cfg#guildShopAuctionNewCfg.auctCType,
		init_cost = Cfg#guildShopAuctionNewCfg.auctIPPro,
		add_cost = Cfg#guildShopAuctionNewCfg.auctBidPro,
		max_cost = Cfg#guildShopAuctionNewCfg.auctBuyNow,
		cost_price = Cfg#guildShopAuctionNewCfg.costPrice,
		can_bid = common:bool_to_int(BidType =:= 1 orelse BidState =:= 0 orelse lists:member(PlayerId, CanBidList)),
		source_id = SourceID
	}.

add_item([], _, Ret) -> Ret;
add_item([{ItemId, Count, IsBind, _} | T], Param, Ret) ->
	{AcId, SourceID, GuildId, AcType} = Param,
	F = fun(AuctionCfg) ->
		case add_item_check(AuctionCfg, {ItemId, 0, 0, AcId}) of
			?TRUE ->
				ItemAmount = case AuctionCfg#guildShopAuctionNewCfg.limit =/= 0 of
								 ?TRUE -> AuctionCfg#guildShopAuctionNewCfg.limit;
								 ?FALSE -> Count
							 end,
				Info = #ga_item_info{
					id = id_generate(), ac_type = AcType, item_id = ItemId, amount = ItemAmount, bind = IsBind,
					activity_id = AcId, guild_id = GuildId, source_id = SourceID,
					cfg_key = get_cfg_key(AuctionCfg), bid_type = common:getTernaryValue(AuctionCfg#guildShopAuctionNewCfg.valuable =:= 1, 0, 1),
					bid_state = common:getTernaryValue(AuctionCfg#guildShopAuctionNewCfg.valuable =:= 1, 2, 0)
				},
				{?TRUE, Info};
			?FALSE -> ?FALSE
		end
		end,
	AddList = lists:filtermap(F, cfg_guildShopAuctionNew:rows()),
	add_item(T, Param, AddList ++ Ret);
add_item([{#item{bind = IsBind}, #eq{character = Q, star = S, item_data_id = ItemId}} = Eq | T], Param, Ret) ->
	{AcId, SourceID, GuildId, AcType} = Param,
	F = fun(AuctionCfg) ->
		case add_item_check(AuctionCfg, {ItemId, Q, S, AcId}) of
			?TRUE ->
				{ItemIns, EqIns} = Eq,
				NewItemIns = item:new(ItemIns, 1),
				NewEqIns = EqIns#eq{uid = NewItemIns#item.id},
				NewEq = {NewItemIns, NewEqIns},
				Info = #ga_item_info{
					id = id_generate(), ac_type = AcType, item_id = ItemId, bind = IsBind, quality = Q, star = S, eq = [NewEq],
					activity_id = AcId, guild_id = GuildId, source_id = SourceID,
					cfg_key = get_cfg_key(AuctionCfg), bid_type = common:getTernaryValue(AuctionCfg#guildShopAuctionNewCfg.valuable =:= 1, 0, 1),
					bid_state = common:getTernaryValue(AuctionCfg#guildShopAuctionNewCfg.valuable =:= 1, 2, 0)
				},
				{?TRUE, Info};
			?FALSE -> ?FALSE
		end
		end,
	AddList = lists:filtermap(F, cfg_guildShopAuctionNew:rows()),
	add_item(T, Param, AddList ++ Ret).


add_item_check(AuctionCfg, Param) ->
	{ItemId, C, S, AcId} = Param,
	OpenAction = case AcId of
					 ?GuildAuctionGuildGuard -> ?OpenAction_GuildGuard;
					 ?GuildAuctionGuildCraft -> ?OpenAction_GuildCraft;
					 ?GuildAuctionGuildBonfire -> ?OpenAction_BonfireBoss;
					 ?GuildAuctionGuildYanmo -> ?OpenAction_YanMo;
					 ?GuildAuctionGuildDomainFight -> ?OpenAction_DomainFight;
					 ?GuildAuctionGuildWar -> ?OpenAction_GuildWar
				 end,
	#guildShopAuctionNewCfg{itemID = CfgId, quality = Character, star = Star, functionId = OpenActionList, dcitywarId = GroupList} = AuctionCfg,
	CfgId =:= ItemId andalso Character =:= C andalso Star =:= S
		andalso (OpenActionList =:= [] orelse lists:member(OpenAction, OpenActionList))
		andalso GroupList =:= [].

get_cfg_key(#guildShopAuctionNewCfg{itemID = K1, quality = K2, star = K3, number = K4}) ->
	{K1, K2, K3, K4}.


clear_history(GuildId, AcId) ->
	M1 = ets:fun2ms(fun(#ga_item_history{guild_id = Id1, activity_id = Id2}) when Id1 =:= GuildId andalso Id2 =:= AcId ->
		?TRUE end),
	ets:select_delete(?Ets_GuildAuctionHistory, M1),

	M2 = ets:fun2ms(fun(#ga_profit_history{guild_id = Id1, activity_id = Id2}) when Id1 =:= GuildId andalso Id2 =:= AcId ->
		?TRUE end),
	ets:select_delete(?Ets_GuildAuctionProfitHistory, M2),
	ok.


open_ui(GuildId, PlayerId, Pid) ->
	case ets:lookup(?Ets_GuildAuction, GuildId) of
		[#ga{viewer_list = ViewerList} = Value] ->
			NewViewerList = lists:keystore(PlayerId, 1, ViewerList, {PlayerId, Pid}),
			ets:insert(?Ets_GuildAuction, Value#ga{viewer_list = NewViewerList});
		_ -> skip
	end.

close_ui(GuildId, PlayerId) ->
	case ets:lookup(?Ets_GuildAuction, GuildId) of
		[#ga{viewer_list = ViewerList} = Value] ->
			NewViewerList = lists:keydelete(PlayerId, 1, ViewerList),
			ets:insert(?Ets_GuildAuction, Value#ga{viewer_list = NewViewerList});
		_ -> skip
	end.


bid({PlayerId, PlayerName, GuildId, Pid, GaId, Times, {CurrType, Curr}, CostList}) ->
	try
		Info = ets:lookup(?Ets_GuildAuctionItem, GaId),
		case Info of
			[] -> throw(?ErrorCode_GA_NoItem);
			_ -> skip
		end,
		[#ga_item_info{activity_id = AcId, bought = IsBought, player_id = OldPlayerId, times = T, cfg_key = CfgKey, cost_list = OldCostList,
			bid_type = BidType, can_bid_list = CanBidList, bid_state = BidState} = Item] = Info,
		case ets:lookup(?Ets_GuildAuction, GuildId) of
			[#ga{ga_info = GaInfo}] ->
				Now = time:time(),
				case lists:keyfind(AcId, #ga_info.ac_id, GaInfo) of
					#ga_info{start_time = StartTime} when Now < StartTime -> throw(?ErrorCode_GA_NotStart);
					#ga_info{end_time = EndTime} when Now >= EndTime -> throw(?ErrorCode_GA_Over);
					_ -> ok
				end;
			_ -> throw(?ErrorCode_GA_CannotBuy)
		end,
		case IsBought of
			?TRUE -> throw(?ErrorCode_GA_Bought);
			_ -> skip
		end,
		case PlayerId =:= OldPlayerId of
			?TRUE -> throw(?ErrorCode_GA_BidRepeat);
			_ -> skip
		end,
		case Times =:= T + 1 of
			?TRUE -> skip;
			_ -> throw(?ErrorCode_GA_Fresh)
		end,
		NewBidState = case BidType =:= 1 orelse BidState =:= 0 of
						  ?TRUE -> BidState;
						  _ ->
							  ?CHECK_THROW(lists:member(PlayerId, CanBidList), ?ErrorCode_GA_CantAuction),
							  common:getTernaryValue(BidState =:= 2, 1, BidState)
					  end,
		#guildShopAuctionNewCfg{auctCType = CurrType, auctIPPro = InitCurr, auctBidPro = Add, auctBuyNow = Max} = cfg_guildShopAuctionNew:row(CfgKey),
		return_cost_1(OldPlayerId, OldCostList, Item),
		NewInfo = case InitCurr + Add * Times >= Max of
					  ?TRUE ->
						  NewItem = Item#ga_item_info{
							  bought = ?TRUE,
							  player_id = PlayerId,
							  player_name = PlayerName,
							  times = Times,
							  curr_type = CurrType,
							  curr = Curr,
							  bid_state = NewBidState
						  },
						  send_item(NewItem, 1),
						  add_history(NewItem, {CurrType, Curr}),
						  NewItem;
					  _ ->
						  Item#ga_item_info{player_id = PlayerId, player_name = PlayerName, times = Times, curr_type = CurrType,
							  curr = Curr, cost_list = CostList, bid_state = NewBidState}
				  end,
		ets:insert(?Ets_GuildAuctionItem, NewInfo),
		table_global:insert(db_guild_auction_item, NewInfo),
		Msg = #pk_GS2U_GAItemRefresh{
			list = [#pk_ga_item_refresh{
				ga_id = NewInfo#ga_item_info.id,
				bought = NewInfo#ga_item_info.bought,
				player_name = NewInfo#ga_item_info.player_name,
				times = NewInfo#ga_item_info.times,
				bid_state = NewInfo#ga_item_info.bid_state
			}]
		},
		sync_msg(GuildId, Msg),
		m_send:send_pid_msg_2_client(Pid, #pk_GS2U_GABidRet{err_code = ?ERROR_OK})
	catch
		ErrCode ->
			return_cost(PlayerId, CostList),
			m_send:send_pid_msg_2_client(Pid, #pk_GS2U_GABidRet{err_code = ErrCode})
	end.
bid_immediate({PlayerId, PlayerName, GuildId, Pid, GaId, {CurrType, Curr}, CostList}) ->
	try
		Info = ets:lookup(?Ets_GuildAuctionItem, GaId),
		case Info of
			[] -> throw(?ErrorCode_GA_NoItem);
			_ -> skip
		end,
		[#ga_item_info{activity_id = AcId, bought = IsBought, player_id = OldPlayerId, cfg_key = CfgKey, cost_list = OldCostList} = Item] = Info,
		case ets:lookup(?Ets_GuildAuction, GuildId) of
			[#ga{ga_info = GaInfo}] ->
				Now = time:time(),
				case lists:keyfind(AcId, #ga_info.ac_id, GaInfo) of
					#ga_info{start_time = StartTime} when Now < StartTime -> throw(?ErrorCode_GA_NotStart);
					#ga_info{end_time = EndTime} when Now >= EndTime -> throw(?ErrorCode_GA_Over);
					_ -> ok
				end;
			_ -> throw(?ErrorCode_GA_CannotBuy)
		end,
		case IsBought of
			?TRUE -> throw(?ErrorCode_GA_Bought);
			_ -> skip
		end,
		#guildShopAuctionNewCfg{auctCType = CurrType} = cfg_guildShopAuctionNew:row(CfgKey),
		return_cost_1(OldPlayerId, OldCostList, Item),
		NewInfo = Item#ga_item_info{bought = ?TRUE, player_id = PlayerId, player_name = PlayerName, curr_type = CurrType, curr = Curr, cost_list = CostList},
		send_item(NewInfo, 1),
		ets:insert(?Ets_GuildAuctionItem, NewInfo),
		table_global:insert(db_guild_auction_item, NewInfo),
		UpdateMsg = #pk_ga_item_refresh{
			ga_id = NewInfo#ga_item_info.id,
			bought = NewInfo#ga_item_info.bought,
			player_name = NewInfo#ga_item_info.player_name,
			times = NewInfo#ga_item_info.times,
			bid_state = NewInfo#ga_item_info.bid_state
		},
		Msg = #pk_GS2U_GAItemRefresh{list = [UpdateMsg]},
		sync_msg(GuildId, Msg),

		m_send:sendMsgToClient(OldPlayerId, #pk_GS2U_GABidBeyondMe{info = UpdateMsg}),

		m_send:send_pid_msg_2_client(Pid, #pk_GS2U_GABuyImmediateRet{err_code = ?ERROR_OK}),

		add_history(NewInfo, {CurrType, Curr})
	catch
		ErrCode ->
			return_cost(PlayerId, CostList),
			m_send:send_pid_msg_2_client(Pid, #pk_GS2U_GABuyImmediateRet{err_code = ErrCode})
	end.

sync_msg(GuildId, Msg) ->
	[#ga{viewer_list = ViewerList}] = ets:lookup(?Ets_GuildAuction, GuildId),
	[m_send:send_pid_msg_2_client(Pid, Msg) || {_, Pid} <- ViewerList].

%%
return_cost(PlayerId, CostList) ->
	Language = language:get_player_language(PlayerId),
	mail:send_mail(#mailInfo{
		player_id = PlayerId,
		title = language:get_server_string("playerbag_full_title", Language),
		describe = language:get_server_string("playerbag_full_describ", Language),
		isDirect = 1,
		coinList = [#coinInfo{type = T, num = C, reason = ?Reason_GA_BidRet} || {T, C} <- CostList]
	}).

return_cost_1(0, _CostList, _Item) -> ok;
return_cost_1(PlayerId, CostList, Item) ->
	Language = language:get_player_language(PlayerId),
	Describe = case Item#ga_item_info.activity_id of
				   ?GuildAuctionGuildGuard ->
					   language:format(language:get_server_string("GuildTrade_jingbiao2", Language), [get_item_text(Item, Language)]);
				   ?GuildAuctionGuildCraft ->
					   language:format(language:get_server_string("GuildTrade_jingbiao3", Language), [get_item_text(Item, Language)]);
				   ?GuildAuctionGuildBonfire ->
					   language:format(language:get_server_string("GuildTrade_jingbiao6", Language), [get_item_text(Item, Language)]);
				   ?GuildAuctionGuildYanmo ->
					   language:format(language:get_server_string("GuildTrade_jingbiao8", Language), [get_item_text(Item, Language)]);
				   ?GuildAuctionGuildDomainFight ->
					   language:format(language:get_server_string("GuildTrade_jingbiao10", Language), [get_item_text(Item, Language)]);
				   ?GuildAuctionGuildWar ->
					   language:format(language:get_server_string("D3_GHZ_Mail_Desc2", Language), [get_item_text(Item, Language)])
			   end,
	mail:send_mail(#mailInfo{
		player_id = PlayerId,
		title = language:get_server_string("GuildTrade_jingbiao1", Language),
		describe = Describe,
		isDirect = 0,
		coinList = [#coinInfo{type = T, num = C, reason = ?Reason_GA_BidRet} || {T, C} <- CostList]
	}).

get_item_text(#ga_item_info{item_id = ItemId, eq = []}, Language) ->
	richText:getItemText(ItemId, Language);
get_item_text(#ga_item_info{eq = [Eq]}, Language) ->
	richText:getItemText(Eq, Language).

send_item(#ga_item_info{player_id = PlayerId, item_id = ItemId, eq = [], activity_id = AcId, curr_type = CurrType, curr = Curr}, IsDirect) ->
	Language = language:get_player_language(PlayerId),
	Describe = case AcId of
				   ?GuildAuctionGuildGuard ->
					   language:format(language:get_server_string("GuildTrade_jingbiao4", Language), [richText:getItemText(ItemId, Language)]);
				   ?GuildAuctionGuildCraft ->
					   language:format(language:get_server_string("GuildTrade_jingbiao5", Language), [richText:getItemText(ItemId, Language)]);
				   ?GuildAuctionGuildBonfire ->
					   language:format(language:get_server_string("GuildTrade_jingbiao7", Language), [richText:getItemText(ItemId, Language)]);
				   ?GuildAuctionGuildYanmo ->
					   language:format(language:get_server_string("GuildTrade_jingbiao9", Language), [richText:getItemText(ItemId, Language)]);
				   ?GuildAuctionGuildDomainFight ->
					   language:format(language:get_server_string("GuildTrade_jingbiao11", Language), [richText:getItemText(ItemId, Language)]);
				   ?GuildAuctionGuildWar ->
					   language:format(language:get_server_string("D3_GHZ_Mail_Desc3", Language), [richText:getItemText(ItemId, Language)])
			   end,
	case IsDirect =:= 1 of
		?TRUE -> player_item:show_get_item_dialog(PlayerId, [{ItemId, 1}], [], [], 0, 0);
		_ -> skip
	end,
	mail:send_mail(#mailInfo{
		player_id = PlayerId,            %% 接收者ID
		title = language:get_server_string("GuildTrade_jingbiao1", Language),               %% 标题
		describe = Describe,           %% 描述
		isDirect = IsDirect,
		itemList = [#itemInfo{itemID = ItemId, num = 1}],
		attachmentReason = ?Reason_GA_BidBuy
	}),
	currency:deleted_offline(PlayerId, CurrType, Curr, ?Reason_GA_BidBuy),
	player_offevent:save_offline_event(PlayerId, ?Offevent_Type_Attainments, {attainment_addprogress, ?Attainments_Type_AuctionCount, {1}}),
	ok;
send_item(#ga_item_info{player_id = PlayerId, eq = [Eq], activity_id = AcId, curr_type = CurrType, curr = Curr}, IsDirect) ->
	Language = language:get_player_language(PlayerId),
	Describe = case AcId of
				   ?GuildAuctionGuildGuard ->
					   language:format(language:get_server_string("GuildTrade_jingbiao4", Language), [richText:getItemText(Eq, Language)]);
				   ?GuildAuctionGuildCraft ->
					   language:format(language:get_server_string("GuildTrade_jingbiao5", Language), [richText:getItemText(Eq, Language)]);
				   ?GuildAuctionGuildBonfire ->
					   language:format(language:get_server_string("GuildTrade_jingbiao7", Language), [richText:getItemText(Eq, Language)]);
				   ?GuildAuctionGuildYanmo ->
					   language:format(language:get_server_string("GuildTrade_jingbiao9", Language), [richText:getItemText(Eq, Language)]);
				   ?GuildAuctionGuildDomainFight ->
					   language:format(language:get_server_string("GuildTrade_jingbiao11", Language), [richText:getItemText(Eq, Language)]);
				   ?GuildAuctionGuildWar ->
					   language:format(language:get_server_string("D3_GHZ_Mail_Desc3", Language), [richText:getItemText(Eq, Language)])
			   end,
	case IsDirect =:= 1 of
		?TRUE -> player_item:show_get_item_dialog(PlayerId, [], [], [Eq], 0, 0);
%%			Msg = player_item:make_show_get_item_dialog_msg([], [], [Eq], 0),
%%			local:sendPlayerClientMsg(PlayerId, Msg);
		_ -> skip
	end,
	mail:send_mail(#mailInfo{
		player_id = PlayerId,            %% 接收者ID
		title = language:get_server_string("GuildTrade_jingbiao1", Language),               %% 标题
		describe = Describe,           %% 描述
		isDirect = IsDirect,
		itemInstance = [Eq],
		attachmentReason = ?Reason_GA_BidBuy
	}),
	currency:deleted_offline(PlayerId, CurrType, Curr, ?Reason_GA_BidBuy),
	player_offevent:save_offline_event(PlayerId, ?Offevent_Type_Attainments, {attainment_addprogress, ?Attainments_Type_AuctionCount, {1}}),
	ok.

add_history(Item, {CurrType, Curr}) ->
	History = #ga_item_history{
		guild_id = Item#ga_item_info.guild_id,
		activity_id = Item#ga_item_info.activity_id,
		item_id = Item#ga_item_info.item_id,
		quality = Item#ga_item_info.quality,
		star = Item#ga_item_info.star,
		eq = Item#ga_item_info.eq,
		bind = Item#ga_item_info.bind,
		type = common:getTernaryValue(Item#ga_item_info.bought, 2, 1),  %% 1-竞猜获得 2-一口价获得
		time = time:time(),
		player_name = Item#ga_item_info.player_name,
		curr_type = CurrType,
		curr = Curr         %% 当前拍卖的次数  低价+次数*每次加价  = 花的钱
	},
	ets:insert(?Ets_GuildAuctionHistory, History).


id_generate() ->
	id_generator:generate(?ID_TYPE_GuildAuction).

on_settle_accounts() ->
	%% 1. 拍卖物品结算
	AuctionList = ets:tab2list(?Ets_GuildAuctionItem),
	lists:foreach(fun on_settle_accounts_1/1, AuctionList),
	%% 2. 分红结算
	GuildList = ets:tab2list(?Ets_GuildAuction),
	lists:foreach(fun on_settle_accounts_2/1, GuildList),
	ets:delete_all_objects(?Ets_GuildAuctionItem),
	table_global:delete_all(db_guild_auction_item),
	ets:delete_all_objects(?Ets_GuildAuction),
	table_global:delete_all(db_guild_auction),
	ok.
on_settle_accounts_by_ac(GuildID, AcID) ->
	%% 1. 拍卖物品结算
	Q1 = ets:fun2ms(fun(#ga_item_info{activity_id = ID, guild_id = Gid} = R) when ID =:= AcID andalso Gid =:= GuildID ->
		R end),
	AuctionList = ets:select(?Ets_GuildAuctionItem, Q1),
	lists:foreach(fun(AuctionItem) -> on_settle_accounts_1(AuctionItem) end, AuctionList),
	%% 2. 分红结算
	Q2 = ets:fun2ms(fun(#ga{guild_id = Gid} = R) when Gid =:= GuildID -> R end),
	GuildList = ets:select(?Ets_GuildAuction, Q2),
	ShareFunc = fun(#ga{ga_info = GaInfoList} = Ga) ->
		case lists:keytake(AcID, #ga_info.ac_id, GaInfoList) of
			?FALSE -> ok;
			{_, GaInfo, Left} ->
				on_settle_accounts_3(GuildID, GaInfo),
				case Left =/= [] of
					?TRUE ->
						NewGa = Ga#ga{ga_info = Left},
						ets:insert(?Ets_GuildAuction, NewGa);
					_ ->
						ets:delete(?Ets_GuildAuction, Ga#ga.guild_id)
				end
		end
				end,
	lists:foreach(ShareFunc, GuildList),
	DelAucItemList = lists:map(fun(AuctionItem) -> ets:delete(?Ets_GuildAuctionItem, AuctionItem#ga_item_info.id),
		AuctionItem#ga_item_info.id end, AuctionList),
	table_global:delete(db_guild_auction_item, DelAucItemList),
	table_global:delete(db_guild_auction, [{GuildID, AcID}]),
	guild_pub:send_msg_to_all_member_process(GuildID, {sendToClient, #pk_GS2U_get_authority_red{ac_id = AcID, type = 0}}),
	ok.

on_settle_accounts_1(#ga_item_info{bought = ?TRUE}) -> skip;
on_settle_accounts_1(#ga_item_info{activity_id = AcId, item_id = I, amount = N, bind = B, eq = EqList, player_id = 0}) ->
	%% 没人要的商品，发配到世界拍卖
	case AcId of
		?GuildAuctionGuildWar ->
			Daytime = time:daytime(),
			{Start, End} = guild_war_logic:get_cluster_auction_time(),
			StartTime = time:time_add(Daytime, Start),
			FinishTime = time:time_add(Daytime, End),
			ItemList = common:getTernaryValue(EqList == [], [{I, N, B, 0}], []),
			cluster_auction_logic:add_goods(?OpenAction_GuildWar, [], ItemList, EqList, StartTime, FinishTime);
		_ -> ok
	end;
on_settle_accounts_1(#ga_item_info{times = T, cfg_key = CfgKey} = Item) ->
	send_item(Item, 0),
	#guildShopAuctionNewCfg{auctCType = CurrType, auctIPPro = InitCurr, auctBidPro = Add} = cfg_guildShopAuctionNew:row(CfgKey),
	add_history(Item, {CurrType, InitCurr + Add * T}).

on_settle_accounts_2(#ga{ga_info = GaInfoList, guild_id = GuildId}) ->
	[on_settle_accounts_3(GuildId, GaInfo) || GaInfo <- GaInfoList].

on_settle_accounts_3(GuildId, #ga_info{id_list = IdList, player_list = PlayerList, ac_id = AcId, tax = Tax}) ->
	CurrList = get_all_curr(IdList, []),
	on_settle_accounts_4(CurrList, Tax, PlayerList, {GuildId, AcId}).


on_settle_accounts_4(CurrList, Tax, PlayerList, SomeInfo) ->
	PlayerNum = length(PlayerList),
	ProfitList = [{CurrType, Curr, trunc(Curr * (10000 - Tax) / 10000 / PlayerNum)} || {CurrType, Curr} <- CurrList, Curr > 0],
	?LOG_INFO("auction profit :~p", [{ProfitList, Tax}]),
	case ProfitList =/= [] of
		?TRUE ->
			{GuildId, AcId} = SomeInfo,
			lists:foreach(fun({PlayerId, _PlayerName}) -> send_profit(PlayerId, ProfitList, AcId) end, PlayerList),
			History = #ga_profit_history{
				guild_id = GuildId,
				activity_id = AcId,
				time = time:time(),
				curr_list = ProfitList,
				player_num = PlayerNum,
				tax = Tax,
				player_list = PlayerList %%
			},
			ets:insert(?Ets_GuildAuctionProfitHistory, History);
		?FALSE -> ok
	end.


%% 结算函数调用
get_all_curr([], Ret) -> common:listValueMerge(Ret);
get_all_curr([Id | T], Ret) ->
	[#ga_item_info{curr = Curr, curr_type = CurrType}] = ets:lookup(?Ets_GuildAuctionItem, Id),
	RetCurr = case CurrType of
				  ?CURRENCY_Gold -> {?CURRENCY_GoldCat, Curr};
				  _ -> {CurrType, Curr}
			  end,
	get_all_curr(T, [RetCurr | Ret]).

%% 分红
send_profit(PlayerId, ProfitList, AcId) ->
	Language = language:get_player_language(PlayerId),
	AwardCurrList = [{T, C} || {T, _, C} <- ProfitList],
	Describe = case AcId of
				   ?GuildAuctionGuildGuard ->
					   language:format(language:get_server_string("Guildtrade_end2", Language), [richText:getRewardText([], AwardCurrList, Language)]);
				   ?GuildAuctionGuildCraft ->
					   language:format(language:get_server_string("Guildtrade_end3", Language), [richText:getRewardText([], AwardCurrList, Language)]);
				   ?GuildAuctionGuildBonfire ->
					   language:format(language:get_server_string("Guildtrade_end4", Language), [richText:getRewardText([], AwardCurrList, Language)]);
				   ?GuildAuctionGuildYanmo ->
					   language:format(language:get_server_string("Guildtrade_end5", Language), [richText:getRewardText([], AwardCurrList, Language)]);
				   ?GuildAuctionGuildDomainFight ->
					   language:format(language:get_server_string("Guildtrade_end6", Language), [richText:getRewardText([], AwardCurrList, Language)]);
				   ?GuildAuctionGuildWar ->
					   language:format(language:get_server_string("D3_GHZ_Mail_Desc4", Language), [richText:getRewardText([], AwardCurrList, Language)]);
				   _ -> ""
			   end,
	mail:send_mail(#mailInfo{
		player_id = PlayerId,
		title = language:get_server_string("Guildtrade_end1", Language),
		describe = Describe,
		isDirect = 0,
		coinList = [#coinInfo{type = T, num = C, reason = ?Reason_GA_BidProfit} || {T, C} <- AwardCurrList]
	}).

%% 守卫战盟拍卖资格玩家
get_guild_auction() -> case get('guild_auction_list') of ?UNDEFINED -> [];L -> L end.
set_guild_auction(Info) -> put('guild_auction_list', Info).

auction_2_list({_, GuildId, AcId, PlayerList, Tax, IdList, EndTime, AuthPlayerID, AuthEndTime}) ->
	[GuildId, AcId, gamedbProc:term_to_dbstring(PlayerList), Tax, gamedbProc:term_to_dbstring(IdList), EndTime, AuthPlayerID, AuthEndTime].
list_2_auction([GuildId, AcId, PlayerList, Tax, IdList, EndTime, AuthPlayerID, AuthEndTime]) ->
	{null, GuildId, AcId, gamedbProc:dbstring_to_term(PlayerList), Tax, gamedbProc:dbstring_to_term(IdList), EndTime, AuthPlayerID, AuthEndTime}.
auction_item_2_list(Record) ->
	tl(tuple_to_list(Record#ga_item_info{
		eq = gamedbProc:term_to_dbstring(Record#ga_item_info.eq),
		bought = common:getTernaryValue(Record#ga_item_info.bought, 1, 0),
		cost_list = gamedbProc:term_to_dbstring(Record#ga_item_info.cost_list),
		cfg_key = gamedbProc:term_to_dbstring(Record#ga_item_info.cfg_key),
		can_bid_list = gamedbProc:term_to_dbstring(Record#ga_item_info.can_bid_list)
	})).
list_2_auction_item(List) ->
	Record = list_to_tuple([ga_item_info | List]),
	Record#ga_item_info{
		eq = gamedbProc:dbstring_to_term(Record#ga_item_info.eq),
		bought = Record#ga_item_info.bought =:= 1,  %% 是否被一口价买了
		player_name = unicode:characters_to_list(Record#ga_item_info.player_name),
		cost_list = gamedbProc:dbstring_to_term(Record#ga_item_info.cost_list),
		cfg_key = gamedbProc:dbstring_to_term(Record#ga_item_info.cfg_key),
		can_bid_list = gamedbProc:dbstring_to_term(Record#ga_item_info.can_bid_list)
	}.

get_auction_keep_time(?GuildAuctionGuildBonfire) -> cfg_globalSetup:guildTrade_KeepTime1();
get_auction_keep_time(?GuildAuctionGuildDomainFight) -> cfg_globalSetup:guildTrade_KeepTime2();
get_auction_keep_time(?GuildAuctionGuildWar) -> guild_war_logic:get_auction_keep_time();
get_auction_keep_time(_) -> 1800.

update_db_guild_auction(#ga{guild_id = GuildID, ga_info = InfoList}) ->
	List = [{null, GuildID, AcId, PlayerList, Tax, IdList, EndTime, AuthPlayerID, AuthEndTIme} ||
		#ga_info{ac_id = AcId, player_list = PlayerList, tax = Tax, id_list = IdList, end_time = EndTime,
			authority_player_id = AuthPlayerID, authority_end_time = AuthEndTIme} <- InfoList],
	table_global:insert(db_guild_auction, List).

set_bid_authority({PlayerId, GuildId, GaId, Type, PlayerIDList}) ->
	try
		GuildInfo = case ets:lookup(?Ets_GuildAuction, GuildId) of
						[#ga{} = Value] -> Value;
						_ -> throw(?ErrorCode_GA_NoItem)
					end,
		#ga{ga_info = GaInfoList} = GuildInfo,
		AucItemInfo = etsBaseFunc:readRecord(?Ets_GuildAuctionItem, GaId),
		?CHECK_THROW(AucItemInfo =/= {}, ?ErrorCode_GA_NoItem),
		#ga_item_info{activity_id = AcID, bought = IsBought, player_id = NowBidPlayerID, player_name = NowBidPlayerName, cost_list = CostList,
			can_bid_list = CanBidList, bid_state = BidState, curr = OldCurr} = AucItemInfo,
		?CHECK_THROW(not IsBought, ?ErrorCode_GA_Bought),
		?CHECK_THROW(BidState =/= 0, ?ErrorCode_GA_AuthorityNo),
		?CHECK_THROW(not (CanBidList =:= PlayerIDList), ?ERROR_OK),
		case lists:keyfind(AcID, #ga_info.ac_id, GaInfoList) of
			#ga_info{authority_player_id = PlayerId} -> ok;
			_ -> throw(?ErrorCode_GA_Authority)
		end,
		{NewBidPlayerID, NewBidPlayerName} = case NowBidPlayerID > 0 andalso lists:member(NowBidPlayerID, PlayerIDList) of
												 ?TRUE -> {NowBidPlayerID, NowBidPlayerName};
												 ?FALSE -> {0, ""}
											 end,
		NewCurr = case NowBidPlayerID > 0 andalso NewBidPlayerID =/= NowBidPlayerID of
					  ?TRUE ->%%取消稀有物品竞拍权限
						  authority_return_cost(NowBidPlayerID, CostList, AucItemInfo),%%退回稀有物品的竞价
						  0;
					  ?FALSE -> OldCurr
				  end,
		NewAucItemInfo = AucItemInfo#ga_item_info{bid_type = Type, can_bid_list = PlayerIDList, player_id = NewBidPlayerID,
			player_name = NewBidPlayerName, bid_state = 1, curr = NewCurr},
		ets:insert(?Ets_GuildAuctionItem, NewAucItemInfo),
		table_global:insert(db_guild_auction_item, NewAucItemInfo),
		UpdateMsg = #pk_ga_item_refresh{
			ga_id = NewAucItemInfo#ga_item_info.id,
			bought = NewAucItemInfo#ga_item_info.bought,
			player_name = NewAucItemInfo#ga_item_info.player_name,
			times = NewAucItemInfo#ga_item_info.times,
			bid_state = NewAucItemInfo#ga_item_info.bid_state
		},
		Msg = #pk_GS2U_GAItemRefresh{list = [UpdateMsg]},
		sync_msg(GuildId, Msg),
		[local:sendPlayerClientMsg(GetPlayerID, #pk_GS2U_get_authority_red{ac_id = AcID, ga_id = GaId,
			is_operator = common:bool_to_int(GetPlayerID =:= PlayerId), type = 2}) || GetPlayerID <- PlayerIDList--CanBidList],
		[local:sendPlayerClientMsg(GetPlayerID, #pk_GS2U_get_authority_red{ac_id = AcID, ga_id = GaId,
			is_operator = common:bool_to_int(GetPlayerID =:= PlayerId), type = 3}) || GetPlayerID <- CanBidList--PlayerIDList]
	catch
		_Err -> ok
	end.

authority_return_cost(PlayerId, CostList, _Item) ->
	Language = language:get_player_language(PlayerId),
	mail:send_mail(#mailInfo{
		player_id = PlayerId,
		title = language:get_server_string("GuildTrade_jingbiao1", Language),
		describe = language:get_server_string("AuctionRightsMail1", Language),
		isDirect = 0,
		coinList = [#coinInfo{type = T, num = C, reason = ?Reason_GA_BidRet} || {T, C} <- CostList]
	}).

select_guild_authority(GuildID) ->
	%% 归属按照顺序，依次筛选：会长-执法者-副会长
	%% 相同职位，如果有多个玩家，则再次判断等级高低，等级高的优先，如果等级相同，则判断战斗力
	List1 = [{PlayerID, Rk} || {PlayerID, Rk} <- guild_pub:get_guild_member_list(GuildID),
		lists:member(Rk, [?GuildRank_Chairman, ?GuildRank_SuperElder, ?GuildRank_ViceChairman]) andalso main:is_connected(PlayerID)],
	case [PlayerID || {PlayerID, ?GuildRank_Chairman} <- List1] of
		[PlayerID] -> PlayerID;
		_ ->
			case [PlayerID || {PlayerID, ?GuildRank_SuperElder} <- List1] of
				[] ->
					case [PlayerID || {PlayerID, ?GuildRank_ViceChairman} <- List1] of
						[] -> 0;
						[PlayerID] -> PlayerID;
						List3 ->
							[{_, _, PlayerID} | _] = lists:keysort(1, [{-mirror_player:get_player_level(PlayerID), -mirror_player:get_player_battle_value(PlayerID), PlayerID} || PlayerID <- List3]),
							PlayerID
					end;
				[PlayerID] -> PlayerID;
				List2 ->
					[{_, _, PlayerID} | _] = lists:keysort(1, [{-mirror_player:get_player_level(PlayerID), -mirror_player:get_player_battle_value(PlayerID), PlayerID} || PlayerID <- List2]),
					PlayerID
			end
	end.

on_manager_online(GuildId) ->
	case ets:lookup(?Ets_GuildAuction, GuildId) of
		[#ga{ga_info = GaInfoList} = GuildInfo] ->
			case [R || #ga_info{authority_player_id = 0} = R <- GaInfoList] of
				[] -> ok;
				List ->
					AuthPlayerID = select_guild_authority(GuildId),
					NewGaInfoList = lists:foldl(fun(#ga_info{ac_id = AcID} = Info, Ret) ->
						NewInfo = Info#ga_info{authority_player_id = AuthPlayerID},
						AuthPlayerID > 0 andalso local:sendPlayerClientMsg(AuthPlayerID, #pk_GS2U_get_authority_red{ac_id = AcID, type = 1}),
						lists:keystore(AcID, #ga_info.ac_id, Ret, NewInfo)
												end, GaInfoList, List),
					NewGuildInfo = GuildInfo#ga{ga_info = NewGaInfoList},
					ets:insert(?Ets_GuildAuction, NewGuildInfo),
					update_db_guild_auction(NewGuildInfo)
			end;
		_ -> ok
	end.

get_authority_time(?GuildAuctionGuildDomainFight) -> cfg_globalSetup:guildTrade_StreamBeatTime1();
get_authority_time(?GuildAuctionGuildBonfire) -> cfg_globalSetup:guildTrade_StreamBeatTime2();
get_authority_time(?GuildAuctionGuildWar) -> cfg_globalSetup:guildTrade_StreamBeatTime3();
get_authority_time(_) -> 0.

