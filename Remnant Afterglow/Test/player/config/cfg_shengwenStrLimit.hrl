-ifndef(cfg_shengwenStrLimit_hrl).
-define(cfg_shengwenStrLimit_hrl, true).

-record(shengwenStrLimitCfg, {
	%% 圣纹装备阶数
	iD,
	%% 不同阶数对应的最大强化和继承等级
	number
}).

-endif.
