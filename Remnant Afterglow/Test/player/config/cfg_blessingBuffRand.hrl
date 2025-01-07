-ifndef(cfg_blessingBuffRand_hrl).
-define(cfg_blessingBuffRand_hrl, true).

-record(blessingBuffRandCfg, {
	%% 章节
	iD,
	%% 小章节
	oder,
	%% 索引
	index,
	%% 祝福宝箱随机概率
	%% （库ID，权重）
	weight
}).

-endif.
