-ifndef(cfg_lovePointGive_hrl).
-define(cfg_lovePointGive_hrl, true).

-record(lovePointGiveCfg, {
	%% 对应可以获得亲密度的MapAi
	iD,
	%% 参与击杀BOSS后获得的亲密度
	lovePoint
}).

-endif.
