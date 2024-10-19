-ifndef(cfg_godSteps_hrl).
-define(cfg_godSteps_hrl, true).

-record(godStepsCfg, {
	%% 神系编号
	iD,
	%% 神位编号
	steps,
	%% 索引
	index,
	%% 神位名字
	name,
	%% 神系限时称号
	%% 主神争夺结算，即时获得称号
	%% 没有填0
	lordGodTitle
}).

-endif.
