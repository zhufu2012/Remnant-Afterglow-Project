-ifndef(cfg_constellationStrLimit_hrl).
-define(cfg_constellationStrLimit_hrl, true).

-record(constellationStrLimitCfg, {
	%% 星魂装备阶数
	iD,
	%% 不同阶数对应的最大强化和继承等级
	number
}).

-endif.
