-ifndef(cfg_heroGemEqual_hrl).
-define(cfg_heroGemEqual_hrl, true).

-record(heroGemEqualCfg, {
	%% 魂石ID
	iD,
	%% 下一级ID
	nextID,
	%% 合成至下一级所需本级个数
	%% 填0表示无法升至下一级
	needGemNum,
	%% 换算（ID，数量）
	num
}).

-endif.
