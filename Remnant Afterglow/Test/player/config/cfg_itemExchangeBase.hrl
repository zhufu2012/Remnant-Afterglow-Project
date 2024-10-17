-ifndef(cfg_itemExchangeBase_hrl).
-define(cfg_itemExchangeBase_hrl, true).

-record(itemExchangeBaseCfg, {
	%% 入口表TypeID【ActiveBase】=23
	iD,
	%% 填写[ItemExchangeList_1_道具兑换列表]表的达成id
	activitys
}).

-endif.
