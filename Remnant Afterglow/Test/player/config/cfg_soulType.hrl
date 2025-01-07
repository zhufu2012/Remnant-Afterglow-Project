-ifndef(cfg_soulType_hrl).
-define(cfg_soulType_hrl, true).

-record(soulTypeCfg, {
	%% 聚魂道具的ID，和item一一对应
	iD,
	%% 是否可用于合成1是0否
	canSynthesis,
	%% 是否可用于晋升1是0否
	canUpgrade,
	%% 是否可升星,1是0否
	canUpStar,
	%% 是否可升阶,1是0否
	canUpStep
}).

-endif.
