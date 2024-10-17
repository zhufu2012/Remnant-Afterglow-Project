-ifndef(cfg_lordRingLvUp_hrl).
-define(cfg_lordRingLvUp_hrl, true).

-record(lordRingLvUpCfg, {
	%% 魔戒ID
	iD,
	%% 升至下一级魔戒ID（填0表示没下一级）
	lordRingID,
	%% 对应换算的零星魔戒及其他道具数量（道具ID，数量）
	lordRingZero,
	%% 升至下一级的消耗（道具ID，数量）
	%% 这里配置的是总共数量
	nextLordRing
}).

-endif.
