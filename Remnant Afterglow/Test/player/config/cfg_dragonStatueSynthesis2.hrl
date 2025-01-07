-ifndef(cfg_dragonStatueSynthesis2_hrl).
-define(cfg_dragonStatueSynthesis2_hrl, true).

-record(dragonStatueSynthesis2Cfg, {
	%% 天神雕像合成结果随机库ID
	iD,
	%% 合成结果
	%% （权重，道具ID）
	weightResult
}).

-endif.
