-ifndef(cfg_greenDiamondBlessUse_hrl).
-define(cfg_greenDiamondBlessUse_hrl, true).

-record(greenDiamondBlessUseCfg, {
	%% 购买次数ID
	iD,
	%% VIP需求
	vipNeed,
	%% 消耗绿钻数
	%% 代码写死固定为绿钻
	consume
}).

-endif.
