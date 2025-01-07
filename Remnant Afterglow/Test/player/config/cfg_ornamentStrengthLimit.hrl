-ifndef(cfg_ornamentStrengthLimit_hrl).
-define(cfg_ornamentStrengthLimit_hrl, true).

-record(ornamentStrengthLimitCfg, {
	%% 品质ID
	%% 0白
	%% 1蓝
	%% 2紫
	%% 3橙
	%% 4红
	%% 5龙装
	%% 6神
	%% 7龙神
	iD,
	%% 不同品质对应的强化最大等级限制
	number
}).

-endif.
