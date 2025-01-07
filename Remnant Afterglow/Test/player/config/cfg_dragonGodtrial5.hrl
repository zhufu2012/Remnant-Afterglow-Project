-ifndef(cfg_dragonGodtrial5_hrl).
-define(cfg_dragonGodtrial5_hrl, true).

-record(dragonGodtrial5Cfg, {
	%% 达成条件分组ID
	iD,
	%% 达成条件
	%% 取[DragonGodtrial2_1_龙神试炼积分达成]ID
	condition,
	%% 总次数上限
	number
}).

-endif.
