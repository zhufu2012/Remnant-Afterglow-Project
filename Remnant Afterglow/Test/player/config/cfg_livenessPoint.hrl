-ifndef(cfg_livenessPoint_hrl).
-define(cfg_livenessPoint_hrl, true).

-record(livenessPointCfg, {
	%% 每日活跃度
	iD,
	%% 积分
	%% 这里填的值是获得积分，每次日活跃累计到对应的活跃度就获得一次对应的积分
	point
}).

-endif.
