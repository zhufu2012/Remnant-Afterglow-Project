-ifndef(cfg_blessBuff_hrl).
-define(cfg_blessBuff_hrl, true).

-record(blessBuffCfg, {
	%% 累计祈福次数
	%% (当Gift字段奖励参数为2时)
	iD,
	%% 获得BUFF
	timeDif
}).

-endif.
