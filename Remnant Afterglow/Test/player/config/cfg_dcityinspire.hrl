-ifndef(cfg_dcityinspire_hrl).
-define(cfg_dcityinspire_hrl, true).

-record(dcityinspireCfg, {
	%% 鼓舞类型
	%% 1士气大振
	%% 2视死如归
	iD,
	%% 次数上限
	numLimit,
	%% 鼓舞消耗消耗
	%% (消耗类型，参数1，参数2)
	%% 类型1为道具，参数1为道具ID，参数2为道具数量
	%% 类型2为货币，参数1为货币类型，参数2为货币数量
	inspireCost,
	%% 鼓舞buff
	inspireBuff
}).

-endif.
