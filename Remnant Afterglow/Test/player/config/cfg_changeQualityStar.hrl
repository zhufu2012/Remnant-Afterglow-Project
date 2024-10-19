-ifndef(cfg_changeQualityStar_hrl).
-define(cfg_changeQualityStar_hrl, true).

-record(changeQualityStarCfg, {
	%% 品质
	quality,
	%% 星级
	star,
	%% 索引
	index,
	%% 转换方案
	changeWayType
}).

-endif.
