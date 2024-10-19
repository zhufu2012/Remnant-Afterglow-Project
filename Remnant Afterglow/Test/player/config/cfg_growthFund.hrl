-ifndef(cfg_growthFund_hrl).
-define(cfg_growthFund_hrl, true).

-record(growthFundCfg, {
	%% 基金类型
	%% 1.成长基金
	%% 2.巅峰基金
	%% 3.传说基金
	fundId,
	%% 方案
	type,
	%% 领取次数
	num,
	%% 索引
	index,
	%% 获得返利
	%% （货币类型，货币数量）
	fundGift,
	%% 免费奖励
	%% （货币类型，货币数量）
	freeGift,
	%% 领取等级限制
	lvLimit
}).

-endif.
