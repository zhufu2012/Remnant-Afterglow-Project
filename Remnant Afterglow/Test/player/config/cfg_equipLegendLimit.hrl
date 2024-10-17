-ifndef(cfg_equipLegendLimit_hrl).
-define(cfg_equipLegendLimit_hrl, true).

-record(equipLegendLimitCfg, {
	%% 品质
	%% 品质：0白 1蓝 2紫 3橙 4红 5龙 6神 7龙神
	quality,
	%% 星数
	star,
	%% 索引
	index,
	%% 可打造的传奇套阶数上限
	needEquip
}).

-endif.
