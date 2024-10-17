-ifndef(cfg_addLimit_hrl).
-define(cfg_addLimit_hrl, true).

-record(addLimitCfg, {
	%% 装备阶数
	iD,
	%% 当前阶数可追加的最大等级
	number
}).

-endif.
