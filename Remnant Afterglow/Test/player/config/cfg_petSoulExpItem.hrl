-ifndef(cfg_petSoulExpItem_hrl).
-define(cfg_petSoulExpItem_hrl, true).

-record(petSoulExpItemCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
