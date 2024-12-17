-ifndef(cfg_prayFast_hrl).
-define(cfg_prayFast_hrl, true).

-record(prayFastCfg, {
	%% 道具ID
	iD,
	%% 加速时间（秒）
	fastTime
}).

-endif.
