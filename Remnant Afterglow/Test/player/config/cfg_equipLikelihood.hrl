-ifndef(cfg_equipLikelihood_hrl).
-define(cfg_equipLikelihood_hrl, true).

-record(equipLikelihoodCfg, {
	%% 装备阶数
	order,
	%% 品质
	quality,
	%% 星级
	star,
	%% 索引
	index,
	%% 提供辅助装备概率
	baseChance
}).

-endif.
