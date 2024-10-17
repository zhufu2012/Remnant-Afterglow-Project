-ifndef(cfg_bagLimit_hrl).
-define(cfg_bagLimit_hrl, true).

-record(bagLimitCfg, {
	%% 背包ID
	iD,
	%% 背包基础格子
	numBase,
	%% 是否可以进行扩展
	extend,
	%% 可扩展至
	numExtend,
	%% 背包扩展需求道具及数量，（已开启区间数，需要道具，需要数量）
	extendCost,
	%% 背包扩展道具单个价值
	extendPrice
}).

-endif.
