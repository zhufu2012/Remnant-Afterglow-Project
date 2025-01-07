-ifndef(cfg_petProduce_hrl).
-define(cfg_petProduce_hrl, true).

-record(petProduceCfg, {
	%% 英雄总星数
	iD,
	%% 额外产出个数/每分钟
	%% 针对每个星光祭坛建筑独立加速
	probabilityAdd
}).

-endif.
