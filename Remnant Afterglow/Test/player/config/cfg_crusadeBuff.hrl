-ifndef(cfg_crusadeBuff_hrl).
-define(cfg_crusadeBuff_hrl, true).

-record(crusadeBuffCfg, {
	%% 讨伐次数对应的buff加成
	%% 超出最后一个配置的次数时，都读取最后一个次数对应的buffID
	%% 例如这里最后一个配置的300次，那么>500次时取的buffID=1002030
	iD,
	%% 获得BUFF
	timeDif
}).

-endif.
