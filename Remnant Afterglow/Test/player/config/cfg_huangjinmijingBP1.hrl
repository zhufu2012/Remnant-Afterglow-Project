-ifndef(cfg_huangjinmijingBP1_hrl).
-define(cfg_huangjinmijingBP1_hrl, true).

-record(huangjinmijingBP1Cfg, {
	%% 类型
	%% 1、进阶价格
	%% 2、至尊价格
	iD,
	%% 高级BP
	%% 直购商品ID
	directPurchase
}).

-endif.
