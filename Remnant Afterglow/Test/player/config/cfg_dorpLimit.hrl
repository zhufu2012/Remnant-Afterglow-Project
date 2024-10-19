-ifndef(cfg_dorpLimit_hrl).
-define(cfg_dorpLimit_hrl, true).

-record(dorpLimitCfg, {
	%% 道具ID
	iD,
	%% 产出功能开关
	openactionID,
	%% 对应产出MapAi限制
	limitMapAi
}).

-endif.
