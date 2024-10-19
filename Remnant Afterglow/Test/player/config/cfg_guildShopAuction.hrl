-ifndef(cfg_guildShopAuction_hrl).
-define(cfg_guildShopAuction_hrl, true).

-record(guildShopAuctionCfg, {
	%% 出售物品/装备ID
	%% 如果是装备则配置EquiPara字段
	%% 出售的数量更具产出的数量定
	itemID,
	%% 装备品质
	%% 道具填"0"
	quality,
	%% 装备星级
	%% 道具填"0"
	star,
	%% 序号
	index,
	%% 拍卖货币类型
	%% 通用
	auctCType,
	%% 单个物品拍卖一口价
	%% 如果卖多个，则按个数翻倍
	auctBuyNow,
	%% 单个物品拍卖初始竞价
	%% 如果卖多个，则按个数翻倍
	auctIPPro,
	%% 单个物品拍卖每次竞价增加值
	%% 如果卖多个，则按个数翻倍
	%%  
	%% 如果拍卖价格≥一口价，则按照一口价直接买走
	auctBidPro,
	%% 单个物品商品原价
	%% 如果卖多个，则按个数翻倍
	costPrice,
	%% 龙城争霸
	%% 折扣：
	%% 龙城争霸拍卖中的价格折扣
	%% 对钻石和积分竞拍都有效
	%% 填写百分点
	%% 字段（程序功能）未使用
	discount,
	%% 龙城争霸
	%% 是否可用战盟积分竞拍：
	%% 1是0否
	canGuildCoin,
	%% 龙城争霸
	%% 积分一口价：
	gCoinBuyNow,
	%% 龙城争霸
	%% 积分初始竞价：
	gCoinIPPro,
	%% 龙城争霸
	%% 积分竞价增值：
	gCoinBidPro,
	%% 龙城争霸
	%% 积分/钻石比率：
	%% 战盟积分不足时，按对应比率用非绑补足，向上取整；
	%% 填0表示不可钻石补足战盟积分
	gCoinRate
}).

-endif.
