-ifndef(cfg_horcuxBaseExpItem_hrl).
-define(cfg_horcuxBaseExpItem_hrl, true).

-record(horcuxBaseExpItemCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
