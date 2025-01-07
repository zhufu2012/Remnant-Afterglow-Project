-ifndef(cfg_polluteAuctionSell_hrl).
-define(cfg_polluteAuctionSell_hrl, true).

-record(polluteAuctionSellCfg, {
	%% 这里查询不到的为无法污染出售的装备
	%% （只有装备）
	iD,
	%% 装备用
	%% 该装备含有的品质和星级情况
	%% ｛品质，星级｝
	%% 品质（颜色）
	%% 0白，1蓝，2紫，3橙，4红 ，5龙，6神，7龙神
	%% 星级
	%% 0为0星，1-3为1-3星
	chaStar,
	%% 污染后出售价格
	%% （货币ID，出售价格）
	polluteSellPrice,
	%% 污染出售开启条件限制
	openItemCondition
}).

-endif.
