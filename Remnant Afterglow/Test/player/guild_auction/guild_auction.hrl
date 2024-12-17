%%%-------------------------------------------------------------------
%%% @author cbfan
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. 十二月 2018 15:55
%%%-------------------------------------------------------------------
-author("cbfan").
-ifndef(guild_auction_hrl).
-define(guild_auction_hrl, true).

-include("logger.hrl").
-include("record.hrl").
-include("error.hrl").

%% 拍卖类型
-define(ACType_Auction, 0).   %% 竞拍
-define(ACType_Amount, 1).    %% 限购

-define(Ets_GuildAuction, ets_ga).
-record(ga, {
	guild_id = 0,
	viewer_list = [],  %% 更新需要同步的玩家
	ga_info = []       %% #ga_info{}
}).

-record(ga_info, {
	ac_id = 0,        %% 1-守卫战盟 2-战盟争霸 4-篝火Boss
	player_list = [],    %% 有资格竞拍的玩家
	tax = 0,
	id_list = [],
	start_time = 0,       %% 拍卖开始时间
	end_time = 0,         %% 拍卖结束时间
	authority_player_id = 0, %% 有权限分配的玩家id
	authority_end_time = 0 %% 权限结束时间
}).


-define(Ets_GuildAuctionItem, ets_ga_item).
-record(ga_item_info, {
	id = 0,
	activity_id = 0,
	source_id = 0,  %% 来源id 不同玩法意义不同
	guild_id = 0,
	ac_type = 0,    %% 0-竞拍，1-个人限购
	item_id = 0,
	quality = 0,
	star = 0,
	amount = 1,
	eq = [],
	bind = 1,
	bought = ?FALSE,  %% 是否被一口价买了
	player_id = 0,    %% 当前出价的人
	player_name = "",
	times = 0,         %% 当前拍卖的次数  低价+次数*每次加价  = 花的钱
	curr_type = 0,
	curr = 0,

	cost_list = [],
	cfg_key = 0,    %% 配置表的key
	bid_type = 0, %% 0-指定人员 1-所有人
	can_bid_list = [], %% 指定人员[玩家id]
	bid_state = 0  %% 0-可竞拍 1-有权限可竞拍 2-等待权限时间结束(结束后变为0)
}).

-define(Ets_GuildAuctionHistory, ets_ga_item_history).
-record(ga_item_history, {
	guild_id = 0,
	activity_id = 0,
	item_id = 0,
	quality = 0,
	star = 0,
	eq = [],
	bind = 1,
	type = 0,  %% 1-竞猜获得 2-一口价获得
	time = 0,
	player_name = "",
	curr_type = 0,
	curr = 0         %% 当前拍卖的次数  低价+次数*每次加价  = 花的钱
}).


-define(Ets_GuildAuctionProfitHistory, ets_ga_profit_history).
-record(ga_profit_history, {
	guild_id = 0,
	activity_id = 0,
	time = 0,
	curr_list = [], %% {type,total,per}
	player_num = 0,
	tax = 0,
	player_list = []  %%
}).

-endif.