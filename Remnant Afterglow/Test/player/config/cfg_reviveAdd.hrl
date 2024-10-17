-ifndef(cfg_reviveAdd_hrl).
-define(cfg_reviveAdd_hrl, true).

-record(reviveAddCfg, {
	%% 复活次数
	iD,
	%% 最大次数
	maxTime,
	%% 每次复活的消耗数（战盟争霸）
	reviveAdd1,
	%% 每次复活的消耗数
	reviveAdd2
}).

-endif.
