-ifndef(cfg_changeRoleTask_hrl).
-define(cfg_changeRoleTask_hrl, true).

-record(changeRoleTaskCfg, {
	%% 任务ID 
	iD,
	%% 单个任务奖励的属性
	attrAdd
}).

-endif.
