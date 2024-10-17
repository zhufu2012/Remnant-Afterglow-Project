-ifndef(cfg_shengdunDisItemNew_hrl).
-define(cfg_shengdunDisItemNew_hrl, true).

-record(shengdunDisItemNewCfg, {
	%% 道具ID和Item表一一对应
	iD,
	%% 分解材料
	%% (分解所得道具ID，数量)
	%% 填0表示不可分解
	decompose
}).

-endif.
