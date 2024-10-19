-ifndef(cfg_rebirthShow_hrl).
-define(cfg_rebirthShow_hrl, true).

-record(rebirthShowCfg, {
	%% 转生等级
	iD,
	%% 对应的封印副本ID
	levelSealID,
	%% 对应的转生BOSS id
	bossID,
	%% 转生完成等级
	finishLv
}).

-endif.
