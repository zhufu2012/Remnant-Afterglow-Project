-ifndef(cfg_lMatch1v1BP_hrl).
-define(cfg_lMatch1v1BP_hrl, true).

-record(lMatch1v1BPCfg, {
	%% 类型
	%% 1、赛季次数BP
	%% 2、赛季段位BP
	iD,
	%% 高级BP
	%% 直购商品ID
	directPurchase
}).

-endif.
