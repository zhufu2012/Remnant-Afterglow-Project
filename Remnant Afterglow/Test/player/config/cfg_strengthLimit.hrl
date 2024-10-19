-ifndef(cfg_strengthLimit_hrl).
-define(cfg_strengthLimit_hrl, true).

-record(strengthLimitCfg, {
	%% 装备阶数
	iD,
	%% 装备阶数对应的强化最大等级限制
	number
}).

-endif.
