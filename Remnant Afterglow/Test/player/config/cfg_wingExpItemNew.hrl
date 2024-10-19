-ifndef(cfg_wingExpItemNew_hrl).
-define(cfg_wingExpItemNew_hrl, true).

-record(wingExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
