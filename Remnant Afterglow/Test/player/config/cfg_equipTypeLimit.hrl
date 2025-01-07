-ifndef(cfg_equipTypeLimit_hrl).
-define(cfg_equipTypeLimit_hrl, true).

-record(equipTypeLimitCfg, {
	%% ID
	iD,
	%% 可转换的最低阶数
	limitOrder,
	%% 可转换的最低品质
	limitQuality,
	%% 可转换的最低星级
	limitStar
}).

-endif.
