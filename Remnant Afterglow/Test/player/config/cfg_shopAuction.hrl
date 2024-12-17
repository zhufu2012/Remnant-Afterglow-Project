-ifndef(cfg_shopAuction_hrl).
-define(cfg_shopAuction_hrl, true).

-record(shopAuctionCfg, {
	%% 作者:
	%% 拍卖行
	iD,
	%% 作者:
	%% 序列
	snum,
	%% 作者:
	%% 位置序列
	seat,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 出售物品ID
	item,
	%% 作者:
	%% 单次出售物品数量
	num,
	%% 作者:
	%% 货币类型
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 9为爱心
	%% 10为血玉
	coin,
	%% 作者:
	%% 单次出售货币
	coinNum,
	%% 作者:
	%% 拍卖货币类型
	%% 货币类型
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 10为血玉
	auctCType,
	%% 作者:
	%% 拍卖一口价
	auctBuyNow,
	%% 作者:
	%% 拍卖初始竞价
	%% 万分比
	auctIPPro,
	%% 作者:
	%% 拍卖每次竞价
	%% 万分比
	%% (AuctIPPro+AuctBidPro*N)<=10000
	auctBidPro,
	%% 作者:
	%% 商品原价
	costPrice
}).

-endif.
