-ifndef(cfg_changeRoleMutiTask_hrl).
-define(cfg_changeRoleMutiTask_hrl, true).

-record(changeRoleMutiTaskCfg, {
	%% 关联Task_5_转职任务表中的target_num
	iD,
	%% 1角色目标数量|2角色目标数量|3角色目标数量
	target_num,
	%% 目标参数1
	target_num1,
	%% 目标参数2
	target_num2,
	%% 目标参数3
	target_num3,
	%% 目标参数4
	target_num4
}).

-endif.
