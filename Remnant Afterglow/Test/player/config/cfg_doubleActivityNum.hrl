-ifndef(cfg_doubleActivityNum_hrl).
-define(cfg_doubleActivityNum_hrl, true).

-record(doubleActivityNumCfg, {
	%% 双倍分组ID
	%% 运营取该ID
	iD,
	%% 对应玩法道具编号
	no,
	%% 界面跳转ID
	jumpId
}).

-endif.
