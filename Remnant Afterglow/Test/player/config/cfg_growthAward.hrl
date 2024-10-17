-ifndef(cfg_growthAward_hrl).
-define(cfg_growthAward_hrl, true).

-record(growthAwardCfg, {
	%% 基金类型
	%% 1.成长基金
	%% 2.巅峰基金
	%% 3.传说基金
	fundId,
	%% 方案
	type,
	%% 服务器组
	serverGroup,
	%% 索引
	index,
	%% 购买需要充值金额
	limit,
	%% 购买方式
	%% 1、货币
	%% 2、直购
	buyType,
	%% 直购商品ID，要和运营核对好价格.
	%% 货币消耗或者直购商品ID只能配置其中一个
	directPurchase,
	%% 1档到2档
	directPurchase1,
	%% 1档到3档
	directPurchase2,
	%% 2档到3档
	directPurchase3,
	%% 购买花费
	%% （货币类型，货币数量）
	fundCost,
	%% 可以领取次数
	num
}).

-endif.
