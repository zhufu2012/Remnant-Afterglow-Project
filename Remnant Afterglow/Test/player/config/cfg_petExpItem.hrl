-ifndef(cfg_petExpItem_hrl).
-define(cfg_petExpItem_hrl, true).

-record(petExpItemCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
