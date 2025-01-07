%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%			 XO房间 玩家进程
%%% @end
%%% Created : 19. 十二月 2018 15:55
%%%-------------------------------------------------------------------
-module(guild_auction_player).
-author("cbfan").
-include("guild_auction.hrl").
-include("netmsgRecords.hrl").
-include("reason.hrl").
-include("variable.hrl").
-include("db_table.hrl").
-include("cfg_guildShopAuctionNew.hrl").
-include("currency.hrl").

%% API
-export([on_load/1, on_player_online/0, get_guild_auction_info/0, close_ui/0, bid/2, buy_immediate/2, get_auction_history/1,
	get_profit_history/1, get_total_curr/1, set_bid_authority/3, get_bid_authority/1]).

on_load(PlayerID) ->
	DbLimit = table_player:lookup(db_ga_limit_player, PlayerID),
	set_limit_list(DbLimit).

set_limit_list(L) ->
	put(ga_limit_player_list, L).
get_limit_list() ->
	get(ga_limit_player_list).
find_limit(GaId) ->
	PlayerId = player:getPlayerID(),
	find_the_limit(PlayerId, GaId, get_limit_list()).

find_the_limit(PlayerId, GaId, []) -> #db_ga_limit_player{id = GaId, player_id = PlayerId};
find_the_limit(PlayerId, GaId, [Info | List]) ->
	case Info#db_ga_limit_player.player_id =:= PlayerId andalso Info#db_ga_limit_player.id =:= GaId of
		?TRUE -> Info;
		?FALSE -> find_the_limit(PlayerId, GaId, List)
	end.


on_player_online() ->
	case ets:lookup(?Ets_GuildAuction, player:getPlayerProperty(#player.guildID)) of
		[#ga{ga_info = Info}] when length(Info) > 0 ->
			player:send(#pk_GS2U_GARedDotShow{ac_ids = [AcId || #ga_info{ac_id = AcId} <- Info]});
		_ -> []
	end.

get_guild_auction_info() ->
	?metrics(begin
				 try
					 case variable_world:get_value(?WorldVariant_Switch_GuildAuction) of
						 1 -> skip;
						 _ -> throw(?ERROR_FunctionClose)
					 end,
					 GuildId = player:getPlayerProperty(#player.guildID),
					 PlayerId = player:getPlayerID(),
					 case GuildId > 0 of ?TRUE -> ok;?FALSE -> throw(?EnterMap_NoGuild) end,
					 GaInfo = case ets:lookup(?Ets_GuildAuction, GuildId) of
								  [#ga{ga_info = Info1}] -> Info1;
								  _ -> []
							  end,
					 F = fun(#ga_info{id_list = L, player_list = PlayerList}) ->
						 make_ga_msg(L, PlayerId, lists:keymember(PlayerId, 1, PlayerList), [])
						 end,
					 Msg = lists:append(lists:map(F, GaInfo)),

					 Msg1 = [
						 #pk_ga_ac_info{
							 player_num = length(L), tax = Tax, ac_id = ActivityId, self_can_profit = lists:keymember(PlayerId, 1, L),
							 start_time = StartTime, end_time = EndTime, authority_end_time = AuthEndTime, authority_player_id = AuthPlayerID
						 } || #ga_info{player_list = L, tax = Tax, ac_id = ActivityId, start_time = StartTime, end_time = EndTime, authority_end_time = AuthEndTime,
							 authority_player_id = AuthPlayerID} <- GaInfo],

					 guild_auction:send_2_me({open_ui, GuildId, PlayerId, self()}),
					 player:send(#pk_GS2U_RequestGAInfoRet{info = Msg, ac_info = Msg1})
				 catch
					 Err -> player:send(#pk_GS2U_RequestGAInfoRet{err_code = Err})
				 end
			 end).

make_ga_msg([], _, _, Ret) -> Ret;
make_ga_msg([Id | T], PlayerId, IsJoin, Ret) ->
	case ets:lookup(?Ets_GuildAuctionItem, Id) of
		[#ga_item_info{id = Id, activity_id = AcId, ac_type = AcType, item_id = ItemId, amount = Amount, bind = Bind, eq = Eq, times = Times, source_id = SourceID,
			player_name = PlayerName, bought = Bought, cfg_key = CfgKey, bid_type = BidType, can_bid_list = CanBidList, bid_state = BidState}] ->
			case AcType == ?ACType_Auction orelse IsJoin == ?TRUE of
				?TRUE ->
					#db_ga_limit_player{cur_buy = CurBuy} = find_limit(Id),
					Cfg = cfg_guildShopAuctionNew:row(CfgKey),
					M = #pk_ga_item{
						bought = Bought, ac_type = AcType, cur_buy = CurBuy, max_buy = Amount,
						ga_id = Id, ac_id = AcId, item_id = ItemId, bind = Bind, times = Times, player_name = PlayerName,
						eq = [eq:make_eq_msg(E) || {_, E} <- Eq],
						curr_type = Cfg#guildShopAuctionNewCfg.auctCType,
						init_cost = Cfg#guildShopAuctionNewCfg.auctIPPro,
						add_cost = Cfg#guildShopAuctionNewCfg.auctBidPro,
						max_cost = Cfg#guildShopAuctionNewCfg.auctBuyNow,
						cost_price = Cfg#guildShopAuctionNewCfg.costPrice,
						can_bid = common:bool_to_int(BidType =:= 1 orelse BidState =:= 0 orelse lists:member(PlayerId, CanBidList)),
						source_id = SourceID
					},
					make_ga_msg(T, PlayerId, IsJoin, [M | Ret]);
				?FALSE -> make_ga_msg(T, PlayerId, IsJoin, Ret)
			end;
		_Info -> make_ga_msg(T, PlayerId, IsJoin, Ret)
	end.

close_ui() ->
	GuildId = player:getPlayerProperty(#player.guildID),
	case GuildId > 0 of
		?TRUE -> guild_auction:send_2_me({close_ui, GuildId, player:getPlayerID()});
		?FALSE -> skip
	end.

%% 出价
bid(GaId, Times) ->
	?metrics(begin
				 try
					 Info = ets:lookup(?Ets_GuildAuctionItem, GaId),
					 case Info of
						 [] -> throw(?ErrorCode_GA_NoItem);
						 _ -> skip
					 end,
					 PlayerId = player:getPlayerID(),
					 GuildId = player:getPlayerProperty(#player.guildID),
					 case GuildId > 0 of ?TRUE -> ok; ?FALSE -> throw(?EnterMap_NoGuild) end,
					 [#ga_item_info{activity_id = AcId, ac_type = AcType, bought = IsBought, player_id = OldPlayerId, times = T, cfg_key = CfgKey,
						 bid_type = BidType, can_bid_list = CanBidList, bid_state = BidState}] = Info,
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
					 %% 不是竞拍物品不可竞拍
					 case AcType of
						 ?ACType_Auction -> ok;
						 _ -> throw(?ErrorCode_GA_CantAuction)
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
					 case BidType =:= 1 orelse BidState =:= 0 of
						 ?TRUE -> ok;
						 _ -> ?CHECK_THROW(lists:member(PlayerId, CanBidList), ?ErrorCode_GA_CantAuction)
					 end,
					 #guildShopAuctionNewCfg{auctCType = CurrType, auctIPPro = InitCurr, auctBidPro = Add, auctBuyNow = Max}
						 = cfg_guildShopAuctionNew:row(CfgKey),
					 Curr = {CurrType, min(InitCurr + Add * T, Max)},

					 CostList = fix_curr(Curr),

					 CostErr = player:delete_cost([], CostList, ?Reason_GA_BidCost),
					 ?ERROR_CHECK_THROW(CostErr),
					 guild_auction:send_2_me({bid,
						 {PlayerId, player:getPlayerProperty(#player.name), GuildId, self(), GaId, Times, Curr, CostList}})
				 catch
					 ErrCode -> player:send(#pk_GS2U_GABidRet{err_code = ErrCode})
				 end
			 end).

fix_curr({?CURRENCY_GuildWishPoint, NeedNum}) ->
	Exist = currency:get_value(?CURRENCY_GuildWishPoint),
	Extra = NeedNum - Exist,
	case Extra > 0 of
		?TRUE ->
			List = df:getGlobalSetupValueList(auction_Conversion, []),
			NewList = [{P2, P4} || {P1, P2, P3, P4} <- List, P1 =:= ?CURRENCY_GuildWishPoint, P3 =:= ?CURRENCY_Gold],
			case NewList of
				[] -> [{?CURRENCY_GuildWishPoint, NeedNum}];
				[{P2, P4}] ->
					NeedGold = ceil(Extra * P4 / P2),
					[{?CURRENCY_GuildWishPoint, NeedNum - ceil(NeedGold * P2 / P4)}, {?CURRENCY_Gold, NeedGold}]
			end;
		_ ->
			[{?CURRENCY_GuildWishPoint, NeedNum}]
	end;
fix_curr({Tp, NeedNum}) ->
	[{Tp, NeedNum}].

buy_immediate(GaId, BuyAmount) ->
	?metrics(begin
				 try
					 ?CHECK_THROW(BuyAmount > 0, ?ERROR_Param),
					 Info = ets:lookup(?Ets_GuildAuctionItem, GaId),
					 case Info of
						 [] -> throw(?ErrorCode_GA_NoItem);
						 _ -> skip
					 end,
					 PlayerId = player:getPlayerID(),
					 GuildId = player:getPlayerProperty(#player.guildID),
					 [#ga_item_info{activity_id = AcId, ac_type = AcType, amount = Amount, bought = IsBought, cfg_key = CfgKey,
						 bid_type = BidType, can_bid_list = CanBidList, bid_state = BidState} = GaItem] = Info,
					 case ets:lookup(?Ets_GuildAuction, GuildId) of
						 [#ga{ga_info = GaInfo1}] ->
							 Now = time:time(),
							 case lists:keyfind(AcId, #ga_info.ac_id, GaInfo1) of
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
					 case BidType =:= 1 orelse BidState =:= 0 of
						 ?TRUE -> ok;
						 _ -> ?CHECK_THROW(lists:member(PlayerId, CanBidList), ?ErrorCode_GA_CantAuction)
					 end,
					 Limit = find_limit(GaId),
					 case Limit of
						 #db_ga_limit_player{cur_buy = CurBuy} when AcType == ?ACType_Amount, CurBuy + BuyAmount > Amount ->
							 throw(?ErrorCode_GA_LimitBuy);
						 #db_ga_limit_player{} when AcType == ?ACType_Amount ->
							 GaInfo2 = case ets:lookup(?Ets_GuildAuction, GuildId) of
								           [#ga{ga_info = Info1}] -> Info1;
								           _ -> throw(?ErrorCode_GA_CannotBuy)
							           end,
							 CanBuy = case lists:keyfind(AcId, #ga_info.ac_id, GaInfo2) of
										  #ga_info{player_list = IdList} -> lists:keymember(PlayerId, 1, IdList);
										  _ -> ?FALSE
									  end,
							 [throw(?ErrorCode_GA_NoQualification) || not CanBuy];
						 _ -> ok
					 end,
					 #guildShopAuctionNewCfg{auctCType = CurrType, auctBuyNow = CurrAmount} = cfg_guildShopAuctionNew:row(CfgKey),
					 DecCurrency = case AcType of ?ACType_Amount -> {CurrType, CurrAmount * BuyAmount}; _ ->
						 {CurrType, CurrAmount} end,

					 CostList = fix_curr(DecCurrency),

					 CostErr = player:delete_cost([], CostList, ?Reason_GA_BidCost),
					 ?ERROR_CHECK_THROW(CostErr),
					 case AcType of
						 ?ACType_Auction ->
							 guild_auction:send_2_me({bid_immediate, {PlayerId, player:getPlayerProperty(#player.name), GuildId, self(), GaId, DecCurrency, CostList}});
						 ?ACType_Amount ->
							 limit_reward(GaItem, BuyAmount, Limit)
					 end
				 catch
					 ErrCode -> player:send(#pk_GS2U_GABuyImmediateRet{err_code = ErrCode})
				 end
			 end).

limit_reward(GaItem, BuyAmount, #db_ga_limit_player{player_id = PlayID, id = ID, cur_buy = CurBuy} = Limit) ->
	case GaItem of
		#ga_item_info{item_id = ItemID, eq = []} ->
			ItemList = ItemList = [{ItemID, BuyAmount}],
			EqList = [];
		#ga_item_info{eq = [Eq]} ->
			ItemList = [],
			EqList = [Eq]
	end,
	NewLimit = Limit#db_ga_limit_player{cur_buy = CurBuy + BuyAmount},
	NewLimitList = [NewLimit | delete_the_limit(PlayID, ID, get_limit_list(), [])],
	table_player:insert(db_ga_limit_player, NewLimit),
	set_limit_list(NewLimitList),
	player_item:reward(ItemList, EqList, [], ?Reason_GA_BidBuy),
	player_item:show_get_item_dialog(ItemList, [], EqList, 0),
	player:send(#pk_GS2U_GABuyImmediateRet{err_code = ?ERROR_OK}),
	player:send(#pk_GS2U_GAItemRefresh{list = [#pk_ga_item_refresh{ga_id = GaItem#ga_item_info.id, cur_buy = CurBuy + BuyAmount}]}),
	ok.

delete_the_limit(_PlayerId, _Id, [], Ret) -> Ret;
delete_the_limit(PlayerId, Id, [Info | List], Ret) ->
	case Info#db_ga_limit_player.player_id =:= PlayerId andalso Info#db_ga_limit_player.id =:= Id of
		?TRUE -> List ++ Ret;
		?FALSE -> delete_the_limit(PlayerId, Id, List, [Info | Ret])
	end.




get_auction_history(AcId) ->
	GuildId = player:getPlayerProperty(#player.guildID),
	History = ets:lookup(?Ets_GuildAuctionHistory, GuildId),
	Records = [
		#pk_ga_item_record{
			item_id = ItemId,
			bind = Bind,
			eq = [eq:make_eq_msg(E) || {_, E} <- Eq],
			type = Type,
			time = Time,
			player_name = PlayerName,
			curr_type = CurrType,
			curr = Curr
		} || #ga_item_history{
			item_id = ItemId, bind = Bind, eq = Eq, type = Type, time = Time, player_name = PlayerName,
			curr_type = CurrType, curr = Curr, activity_id = AId} <- History, AcId =:= AId],
	player:send(#pk_GS2U_GAHistoryRet{ac_id = AcId, records = Records}).

get_profit_history(AcId) ->
	GuildId = player:getPlayerProperty(#player.guildID),
	History = ets:lookup(?Ets_GuildAuctionProfitHistory, GuildId),

	case lists:keyfind(AcId, #ga_profit_history.activity_id, History) of
		#ga_profit_history{time = Time, curr_list = CurrList, player_num = N, tax = Tax, player_list = PlayerList} ->
			player:send(#pk_GS2U_GAProfitHistoryRet{
				ac_id = AcId,
				time = Time,
				curr_list = [#pk_key_2value{key = P1, value1 = P2, value2 = P3} || {P1, P2, P3} <- CurrList],
				player_num = N,
				self_can_profit = lists:keymember(player:getPlayerID(), 1, PlayerList),
				tax = Tax,
				names = [Name || {_, Name} <- PlayerList]
			});
		_ ->
			player:send(#pk_GS2U_GAProfitHistoryRet{ac_id = AcId})
	end.


get_total_curr(AcId) ->
	GuildId = player:getPlayerProperty(#player.guildID),
	TotalCurrList = case ets:lookup(?Ets_GuildAuction, GuildId) of
						[#ga{ga_info = GaList}] ->
							case lists:keyfind(AcId, #ga_info.ac_id, GaList) of
								#ga_info{id_list = IdList} ->
									[#pk_key_value{key = CurrType, value = CurrNum} || {CurrType, CurrNum} <- guild_auction_logic:get_all_curr(IdList, [])];
								_ ->
									[]
							end;
						_ -> []
					end,
	player:send(#pk_GS2U_GetGaTotalCurrRet{ac_id = AcId, total_curr = TotalCurrList}).

set_bid_authority(GaId, Type, MPlayerIDList) ->
	try
		PlayerIDList = lists:usort(MPlayerIDList),
		PlayerId = player:getPlayerID(),
		GuildId = player:getPlayerProperty(#player.guildID),
		case GuildId > 0 of ?TRUE -> ok; ?FALSE -> throw(?EnterMap_NoGuild) end,
		GuildInfo = case ets:lookup(?Ets_GuildAuction, GuildId) of
						[#ga{} = Value] -> Value;
						_ -> throw(?ErrorCode_GA_NoItem)
					end,
		#ga{ga_info = GaInfoList} = GuildInfo,
		AucItemInfo = etsBaseFunc:readRecord(?Ets_GuildAuctionItem, GaId),
		?CHECK_THROW(AucItemInfo =/= {}, ?ErrorCode_GA_NoItem),
		#ga_item_info{activity_id = AcID, bought = IsBought,
			can_bid_list = CanBidList, bid_state = BidState} = AucItemInfo,
		?CHECK_THROW(not IsBought, ?ErrorCode_GA_Bought),
		?CHECK_THROW(BidState =/= 0, ?ErrorCode_GA_AuthorityNo),
		?CHECK_THROW(not (CanBidList =:= PlayerIDList), ?ERROR_OK),
		case lists:keyfind(AcID, #ga_info.ac_id, GaInfoList) of
			#ga_info{authority_player_id = PlayerId} -> ok;
			_ -> throw(?ErrorCode_GA_Authority)
		end,
		guild_auction:send_2_me({set_bid_authority, {PlayerId, GuildId, GaId, Type, PlayerIDList}})
	catch
		_Err -> ok
	end.

get_bid_authority(GaId) ->
	try
		AucItemInfo = etsBaseFunc:readRecord(?Ets_GuildAuctionItem, GaId),
		?CHECK_THROW(AucItemInfo =/= {}, ?ErrorCode_GA_NoItem),
		#ga_item_info{bid_type = BidType, can_bid_list = CanBidList} = AucItemInfo,
		player:send(#pk_GS2U_get_bid_authority_ret{err_code = ?ERROR_OK, ga_id = GaId, type = BidType, player_id_list = CanBidList})
	catch
		Err ->
			player:send(#pk_GS2U_get_bid_authority_ret{err_code = Err, ga_id = GaId})
	end.