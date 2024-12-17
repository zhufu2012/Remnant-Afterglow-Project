-ifndef(cfg_marry7_hrl).
-define(cfg_marry7_hrl, true).

-record(marry7Cfg, {
	iD,
	%% 结婚理财周期，天
	day,
	%% 结婚理财
	%% 直购商品ID
	%% MARRYBUY_1/2…
	directPurchase,
	%% 单人购买后，单人立得奖励
	%% (货币类型，货币数量）
	reward1,
	%% 单人购买后，双人每日领取
	%% (货币类型，货币数量）
	reward2,
	%% 双人购买后，双人每日增加领取
	%% (货币类型，货币数量）
	reward3
}).

-endif.
