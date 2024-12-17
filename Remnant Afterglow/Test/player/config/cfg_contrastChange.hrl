-ifndef(cfg_contrastChange_hrl).
-define(cfg_contrastChange_hrl, true).

-record(contrastChangeCfg, {
	%% 变动日期内的：
	%% （购买玩家的+购买系统的）/ 玩家出售的  【玩家出售排开系统回收】
	%% 万分比
	%% 1、默认从大到小排列
	%% 2、如果超出最大值取最大值，小于最小值取最小值
	%% 3、购买或者出售为0，都默认给1的值
	%% 4、涨幅的值都是针对当前值
	iD,
	%% 价格方案1
	%% 万分比
	pricePlan1,
	%% 价格方案2
	%% 万分比
	pricePlan2,
	%% 价格方案3
	%% 万分比
	pricePlan3,
	%% 价格方案4
	%% 万分比
	pricePlan4,
	%% 价格方案5
	%% 万分比
	pricePlan5,
	%% 数量方案1
	%% 万分比
	numberPlan1,
	%% 数量方案2
	%% 万分比
	numberPlan2,
	%% 数量方案3
	%% 万分比
	numberPlan3,
	%% 数量方案4
	%% 万分比
	numberPlan4,
	%% 数量方案5
	%% 万分比
	numberPlan5
}).

-endif.
