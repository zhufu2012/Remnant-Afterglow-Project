-ifndef(cfg_blessingUnlock_hrl).
-define(cfg_blessingUnlock_hrl, true).

-record(blessingUnlockCfg, {
	%% 祝福格子序号
	iD,
	%% 格子上限
	maxLock,
	%% 开启条件(类型，参数1，参数2）
	%% 类型=1，参数1=VIP等级
	%% 类型=2，参数1=角色等级
	%% 类型=3，参数1=关卡ID
	openTheLock,
	%% 开启消耗（类型，ID，数量）
	%% 类型1：物品
	%% 类型2：货币
	consume
}).

-endif.
