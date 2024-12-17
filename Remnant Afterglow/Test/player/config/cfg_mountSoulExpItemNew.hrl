-ifndef(cfg_mountSoulExpItemNew_hrl).
-define(cfg_mountSoulExpItemNew_hrl, true).

-record(mountSoulExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
