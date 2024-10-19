-ifndef(cfg_shengdunExpItemNew_hrl).
-define(cfg_shengdunExpItemNew_hrl, true).

-record(shengdunExpItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 每个道具提供的经验值
	exp,
	%% 钻石补足的道具单价
	%% (货币枚举,数量)
	usePrice
}).

-endif.
