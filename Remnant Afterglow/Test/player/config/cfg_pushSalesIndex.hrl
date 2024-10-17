-ifndef(cfg_pushSalesIndex_hrl).
-define(cfg_pushSalesIndex_hrl, true).

-record(pushSalesIndexCfg, {
	%% 活动ID
	iD,
	%% PushSalesBase_1_限时特惠推送中的order
	order
}).

-endif.
