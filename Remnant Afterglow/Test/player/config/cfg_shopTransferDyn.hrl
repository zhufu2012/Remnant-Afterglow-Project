-ifndef(cfg_shopTransferDyn_hrl).
-define(cfg_shopTransferDyn_hrl, true).

-record(shopTransferDynCfg, {
	%% 转职限购编号
	iD,
	%% 0转限购次数
	transfer0,
	%% 1转限购次数
	transfer1,
	%% 2转限购次数
	transfer2,
	%% 3转限购次数
	transfer3,
	%% 4转限购次数
	transfer4,
	%% 5转限购次数
	transfer5,
	%% 6转限购次数
	transfer6,
	%% 7转限购次数
	transfer7,
	%% 8转限购次数
	transfer8,
	%% 9转限购次数
	transfer9,
	%% 10转限购次数
	transfer10
}).

-endif.
