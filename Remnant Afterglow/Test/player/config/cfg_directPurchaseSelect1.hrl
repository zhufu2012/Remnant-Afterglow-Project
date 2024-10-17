-ifndef(cfg_directPurchaseSelect1_hrl).
-define(cfg_directPurchaseSelect1_hrl, true).

-record(directPurchaseSelect1Cfg, {
	%% 活动ID
	%% ActiveBase表类型：33
	iD,
	%% 直购物品库ID
	%% 【DirectPurchaseSelect2_1_自选直购】ID
	itemID,
	%% 直购活动界面顶部道具显示
	%% 配置0，则不显示
	item
}).

-endif.
