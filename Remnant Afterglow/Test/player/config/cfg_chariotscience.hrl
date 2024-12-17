-ifndef(cfg_chariotscience_hrl).
-define(cfg_chariotscience_hrl, true).

-record(chariotscienceCfg, {
	%% 科技ID
	iD,
	%% 科技等级
	skillLv,
	%% 科技等级上限
	maxLv,
	%% 战车科技等级上限所需公会科技等级
	lvCondition,
	%% 升到下一级消耗
	%% 数量
	needs,
	%% 强化(1为解锁战车，ID为战车ID。2为提供给战车的buff，变身成战车时，获得的buff，在战车状态解除时消除。3为技能修正，为战车的技能添加修正
	strengthen
}).

-endif.
