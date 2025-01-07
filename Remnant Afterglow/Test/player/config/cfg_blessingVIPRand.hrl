-ifndef(cfg_blessingVIPRand_hrl).
-define(cfg_blessingVIPRand_hrl, true).

-record(blessingVIPRandCfg, {
	%% VIP等级
	iD,
	%% 祝福宝箱随机概率权重加成万分比
	%% 当前VIP下，获得不同品质的加成
	%% （品质，加成）
	weight
}).

-endif.
