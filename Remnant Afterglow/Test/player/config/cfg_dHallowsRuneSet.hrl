-ifndef(cfg_dHallowsRuneSet_hrl).
-define(cfg_dHallowsRuneSet_hrl, true).

-record(dHallowsRuneSetCfg, {
	%% 圣物转数
	syLevel,
	%% 符文槽位编号
	runeSet,
	%% 索引
	index,
	%% 槽位可镶嵌该转职圣印最高的品质
	qualityMax,
	%% 没有镶嵌时，点击获取的符文ID
	lead
}).

-endif.
