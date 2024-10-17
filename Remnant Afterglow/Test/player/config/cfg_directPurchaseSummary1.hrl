-ifndef(cfg_directPurchaseSummary1_hrl).
-define(cfg_directPurchaseSummary1_hrl, true).

-record(directPurchaseSummary1Cfg, {
	%% 活动ID
	%% ActiveBase表类型：17
	iD,
	%% 直购物品库ID
	%% 【DirectPurchaseSummary2_1_直购1】ID
	itemID,
	%% 直购活动界面顶部道具显示
	%% 配置0，则不显示
	item
}).

-endif.
