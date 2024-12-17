-ifndef(cfg_guildShopAuctionNew_hrl).
-define(cfg_guildShopAuctionNew_hrl, true).

-record(guildShopAuctionNewCfg, {
	%% 出售物品/装备ID
	%% 如果是装备则配置EquiPara字段
	%% 出售的数量根据产出的数量定
	itemID,
	%% 装备品质
	%% 道具填"0"
	quality,
	%% 装备星级
	%% 道具填"0"
	star,
	%% 编号
	%% 同一个道具ID，可能有多个编号；
	%% 当掉落出这个ID的道具，则全部编号的物品都进行拍卖.
	number,
	%% 序号
	index,
	%% 玩法调用：
	%% 填写对应玩法的功能开启ID.
	%% 0表示：所有功能都调用.
	%% 守卫战盟（186）
	%% 战盟争霸（189）
	%% 龙城争霸（283）
	%% 篝火BOSS（359）
	%% 炎魔（23）
	%% 王者1v1（659）
	%% 领地战（506）
	%% 联服公会战（762）
	functionId,
	%% 龙城争霸拍卖
	%% 0.表示所有领地都出.
	%% 1表示1级领地；
	%% 2表示2级领地；
	%% 3表示3级领地.
	dcitywarId,
	%% 限制次数
	%% 0：没限制，走之前的逻辑；
	%% 其他数字：强制拍卖次数，每次拍卖1个.
	%% （个人限购的次数）
	limit,
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
	%% 是否定为贵重物品：1、是； 0、否
	%% 贵重物品由会长指定哪些成员可进行拍卖，在一定时间内如果无人拍卖，则参与了活动的其他人员可参与拍卖。
	%% 备注：流拍时间见：GuildTrade_StreamBeatTime1、GuildTrade_StreamBeatTime2【globalSetup_10_战盟和好友】
	valuable
}).

-endif.
