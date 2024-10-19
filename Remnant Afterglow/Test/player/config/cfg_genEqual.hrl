-ifndef(cfg_genEqual_hrl).
-define(cfg_genEqual_hrl, true).

-record(genEqualCfg, {
	%% 宝石ID
	iD,
	%% 对应的下一级宝石ID
	%% 填0代表没下一级
	gemID,
	%% 对应换算的一级宝石及淬炼石数量（道具ID，数量）
	gemNumber,
	%% 同等级升至下一级数量
	needGemNumberShow
}).

-endif.
