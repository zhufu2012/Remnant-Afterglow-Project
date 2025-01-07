-ifndef(cfg_damLevel_hrl).
-define(cfg_damLevel_hrl, true).

-record(damLevelCfg, {
	%% 等级
	iD,
	%% 对怪物百分比伤害修正1
	%% 只对附加效果类型枚举104,且参数1是3的时候产生作用，修参数2=参数2*参数3列查询值/10000
	damLevel1,
	%% 对怪物百分比伤害修正2
	damLevel2,
	%% 对怪物百分比伤害修正3
	damLevel3
}).

-endif.
