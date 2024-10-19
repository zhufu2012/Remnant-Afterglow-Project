-ifndef(cfg_longHuiPromotionBase_hrl).
-define(cfg_longHuiPromotionBase_hrl, true).

-record(longHuiPromotionBaseCfg, {
	iD,
	%% LongHuiPromotionTypeA_1_达成条件活动表,的ID
	%% {ID,ID,ID,…}
	activitys
}).

-endif.
