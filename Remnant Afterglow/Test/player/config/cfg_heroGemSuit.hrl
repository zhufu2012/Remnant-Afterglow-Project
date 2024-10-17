-ifndef(cfg_heroGemSuit_hrl).
-define(cfg_heroGemSuit_hrl, true).

-record(heroGemSuitCfg, {
	%% 格子数
	num,
	%% 4个魂石等级数
	lv,
	%% 索引
	index,
	%% 属性
	%% （属性ID，值）
	attribute
}).

-endif.
