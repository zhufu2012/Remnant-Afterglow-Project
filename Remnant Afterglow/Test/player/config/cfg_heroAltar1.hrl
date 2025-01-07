-ifndef(cfg_heroAltar1_hrl).
-define(cfg_heroAltar1_hrl, true).

-record(heroAltar1Cfg, {
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
