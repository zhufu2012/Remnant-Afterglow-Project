-ifndef(cfg_petEqpOpen_hrl).
-define(cfg_petEqpOpen_hrl, true).

-record(petEqpOpenCfg, {
	%% 装备格子ID
	iD,
	%% 角色等级要求
	needLv
}).

-endif.
