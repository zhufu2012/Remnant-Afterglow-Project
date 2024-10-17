-ifndef(cfg_expeditionTeamTask_hrl).
-define(cfg_expeditionTeamTask_hrl, true).

-record(expeditionTeamTaskCfg, {
	%% 活动类型
	%% 1普通城池争夺
	%% 2皇城争夺
	type1,
	%% 任务类型1
	%% 1、初始任务
	%% 2、动态任务
	type2,
	%% 索引
	index,
	%% 可发表任务类型
	%% 1、进攻城池
	%% 2、占领城池
	%% 4、防守城池
	%% 8、击杀敌人
	%% 16、皇城占领点
	%% 填写权限之和，例：普通战初始只有2种权限1+4=5
	%% 初始任务优先级：16、8、1、4、2
	%% 注1：皇城战防守阵营不能节皇城占领点任务
	%% 注2：阵营占领周报所有城池后不能接进攻任务
	taskType,
	%% 任务奖励（宝箱积分）
	%% （任务类型，接取消耗积分，完成奖励积分）
	taskAward
}).

-endif.
