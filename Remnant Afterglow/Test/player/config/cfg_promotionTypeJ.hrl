-ifndef(cfg_promotionTypeJ_hrl).
-define(cfg_promotionTypeJ_hrl, true).

-record(promotionTypeJCfg, {
	iD,
	%% REN:
	%% 可购买天使基金条件
	conditions,
	%% REN:
	%% 购买花费
	%% {档次序号，非绑花费,返利持续天数}
	spend,
	%% REN:
	%% 返利
	%% {档次序号，第几次，至第几次，绑元数量}
	reward
}).

-endif.
