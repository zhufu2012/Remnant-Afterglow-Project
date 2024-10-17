-ifndef(cfg_destinyGuard1_hrl).
-define(cfg_destinyGuard1_hrl, true).

-record(destinyGuard1Cfg, {
	%% 目标标签
	iD,
	%% 具体目标
	targetOder,
	index,
	%% 名称，文字ID
	name,
	%% 目标标签开启条件
	%% 前置目标ID
	%% 注意：
	%% 1.此处是显示上是否开启，实际后端已处理成默认开启（任务一开始就开始记数）
	%% 2.即使任务提前完成了，显示上看着也是未完成状态。点击会提示【解锁XX线索后开启】
	frontId2,
	%% 关联主线ID
	mainTaskId,
	%% 包含目标任务ID
	baseTaskId,
	%% 挑战BOSS任务ID
	%% 全局表字段，DestinyGuard_Map，用于前端判断BOSS副本与天命守护各分页对应关系，修改时注意不要遗漏
	bossTaskId,
	%% 主线引导查看任务ID
	%% 这里配了的任务，在该任务激活后，以任意方式进入对应分页，该任务完成
	leadTaskId
}).

-endif.
