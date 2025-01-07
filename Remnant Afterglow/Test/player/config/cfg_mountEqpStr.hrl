-ifndef(cfg_mountEqpStr_hrl).
-define(cfg_mountEqpStr_hrl, true).

-record(mountEqpStrCfg, {
	%% 装备类型1攻击，2防御
	iD,
	%% 强化等级
	lv,
	%% 索引
	index,
	%% 强化成功率万分比
	strRate,
	%% 到下一级消耗道具{道具id，数量}
	itemConsume,
	%% 强化属性
	attribute,
	%% 最大强化等级
	lvMax
}).

-endif.
