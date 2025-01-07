-ifndef(cfg_pantheonExpItem_hrl).
-define(cfg_pantheonExpItem_hrl, true).

-record(pantheonExpItemCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp
}).

-endif.
