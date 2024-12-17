-ifndef(cfg_equipSynthesis_hrl).
-define(cfg_equipSynthesis_hrl, true).

-record(equipSynthesisCfg, {
	%% 条件ID
	iD,
	%% 装备最低星星数量
	starLimit,
	%% 装备最低颜色品质
	qualityLimit,
	%% 装备最低阶数
	stairsLimit
}).

-endif.
