-ifndef(cfg_taskSubstitute_hrl).
-define(cfg_taskSubstitute_hrl, true).

-record(taskSubstituteCfg, {
	%% 关卡ID
	%% 通关失败时，跳转到新任务
	iD,
	%% 原任务ID
	taskID,
	%% 新任务ID
	newTaskID
}).

-endif.
