-ifndef(cfg_tradeCorrelation_hrl).
-define(cfg_tradeCorrelation_hrl, true).

-record(tradeCorrelationCfg, {
	iD,
	%% 道具整体上架保护期
	%% (上架后N秒不可下架）
	protectTime,
	%% 交易行上架格子数
	%% 这里是VIPFUN的ID
	squareNum,
	%% 交易行税收数额
	%% 这里是VIPFUN的ID
	revenue,
	%% 系统清理下架时长（小时）
	discardTime,
	%% 公会-交易行税收数额
	%% 这里是VIPFUN的ID
	revenue2,
	%% 公会交易行上架后，在公会交易行的倒计时（小时）
	discardTime2
}).

-endif.
