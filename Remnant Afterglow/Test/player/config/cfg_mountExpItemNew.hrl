-ifndef(cfg_mountExpItemNew_hrl).
-define(cfg_mountExpItemNew_hrl, true).

-record(mountExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
