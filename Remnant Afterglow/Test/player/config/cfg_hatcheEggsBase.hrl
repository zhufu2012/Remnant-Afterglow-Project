-ifndef(cfg_hatcheEggsBase_hrl).
-define(cfg_hatcheEggsBase_hrl, true).

-record(hatcheEggsBaseCfg, {
	iD,
	%% 角色创建后的N秒
	%% 并满足功能开启条件时开启
	openTime,
	%% 孵蛋总持续时间（秒）
	persistTime,
	%% 抖动分段（秒）
	%% (已孵化时间，抖动每秒帧数）
	paragraphTime
}).

-endif.
