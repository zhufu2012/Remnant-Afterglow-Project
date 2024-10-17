-ifndef(cfg_coldForestDrop1_hrl).
-define(cfg_coldForestDrop1_hrl, true).

-record(coldForestDrop1Cfg, {
	%% 掉落编号
	%% 用于掉落表ActiveDrop，区分不同个人等级的掉落;
	%% 活动开始后不在变化，下场活动重新计算
	iD,
	%% 个人等级下限
	wLevel1,
	%% 个人等级上限
	wLevel2
}).

-endif.
