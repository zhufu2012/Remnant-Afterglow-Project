-ifndef(cfg_mountEqpOpenNew_hrl).
-define(cfg_mountEqpOpenNew_hrl, true).

-record(mountEqpOpenNewCfg, {
	%% 装备格子ID
	iD,
	%% 翼灵角色等级要求
	needLv
}).

-endif.
