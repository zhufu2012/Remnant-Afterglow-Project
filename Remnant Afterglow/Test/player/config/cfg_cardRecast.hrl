-ifndef(cfg_cardRecast_hrl).
-define(cfg_cardRecast_hrl, true).

-record(cardRecastCfg, {
	%% 对应品质
	quality,
	%% 品质位序
	num,
	%% Key
	index,
	%% 合成提供的概率（万分比）
	promoteChance
}).

-endif.
