-ifndef(cfg_activeDropOrder_hrl).
-define(cfg_activeDropOrder_hrl, true).

-record(activeDropOrderCfg, {
	%% 掉落编号
	%% 用于掉落表ActiveDrop，区分不同世界等级的掉落;
	%% 活动开始后不在变化，下场活动重新计算
	iD,
	%% 世界等级下限
	wLevel1,
	%% 世界等级上限
	wLevel2
}).

-endif.
