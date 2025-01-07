-ifndef(cfg_cardCondition_hrl).
-define(cfg_cardCondition_hrl, true).

-record(cardConditionCfg, {
	%% 装备阶数
	iD,
	%% 解锁的孔位数
	cardLock,
	%% UR孔位是否解锁
	%% 1、解锁
	%% 0、未解锁
	cardLock2
}).

-endif.
