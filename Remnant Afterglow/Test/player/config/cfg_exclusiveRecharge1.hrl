-ifndef(cfg_exclusiveRecharge1_hrl).
-define(cfg_exclusiveRecharge1_hrl, true).

-record(exclusiveRecharge1Cfg, {
	iD,
	%% 每轮活动时间，天
	day,
	%% 开服天数分段
	%% (开服天数,开服天数序号）
	%% 开服天数分段：向前取等
	%% (1,1）|(11,2):
	%% 1≤开服天数≤10,为序号1
	%% 开服天数≥11,为序号2.
	rule1,
	%% 个人等级分段
	%% (等级,等级序号）
	%% 等级段：向前取等
	%% (0,1）|(501,2):
	%% 0≤等级≤500,为序号1
	%% 等级≥501,为序号2.
	rule2
}).

-endif.
