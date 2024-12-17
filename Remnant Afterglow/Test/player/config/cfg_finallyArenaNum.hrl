-ifndef(cfg_finallyArenaNum_hrl).
-define(cfg_finallyArenaNum_hrl, true).

-record(finallyArenaNumCfg, {
	%% 竞技场结算ID
	iD,
	%% 竞技场结算周几
	%% （以22点为结算）
	finallyTimeShow
}).

-endif.
