-ifndef(cfg_wingSoulExpItemNew_hrl).
-define(cfg_wingSoulExpItemNew_hrl, true).

-record(wingSoulExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
