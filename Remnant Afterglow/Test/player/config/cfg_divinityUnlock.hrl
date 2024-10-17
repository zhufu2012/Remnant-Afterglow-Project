-ifndef(cfg_divinityUnlock_hrl).
-define(cfg_divinityUnlock_hrl, true).

-record(divinityUnlockCfg, {
	%% 古神圣装部位
	iD,
	%% 对应普通装备部位
	equipPart,
	%% 解锁条件：
	%% 穿戴指定条件的普通装备
	%% （普通装备件数，阶数，品质，星级）
	unlockCondition,
	%% 强化界面，部位标签顺序
	strangeOrder,
	%% 觉醒界面，部位标签顺序
	forgeOrder
}).

-endif.
