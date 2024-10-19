-ifndef(cfg_borderBP_hrl).
-define(cfg_borderBP_hrl, true).

-record(borderBPCfg, {
	%% 类型
	%% 1、征服令牌
	%% 2、荣誉证书
	iD,
	%% 任务类型及奖励
	%% 这里填写：BorderBPTask_1_远征BP任务，ID
	%% 荣誉证书没有就填0
	task,
	%% 高级BP
	%% 直购商品ID
	directPurchase
}).

-endif.
