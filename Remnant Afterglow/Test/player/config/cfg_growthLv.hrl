-ifndef(cfg_growthLv_hrl).
-define(cfg_growthLv_hrl, true).

-record(growthLvCfg, {
	%% 等级
	iD,
	%% 诛仙成长系数{生命、攻击、防御}
	%% 最终生命值=基础生命值*HP
	zhuxian_Growth
}).

-endif.
