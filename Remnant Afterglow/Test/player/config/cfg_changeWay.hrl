-ifndef(cfg_changeWay_hrl).
-define(cfg_changeWay_hrl, true).

-record(changeWayCfg, {
	%% 玩家等级下限
	lvmin,
	%% 玩家等级上限
	lvmax,
	%% 索引
	index,
	%% 转换职业的权重（权重，职业顺序）
	%% 高级装备
	oneOccupation1,
	%% 转换职业的权重（权重，职业顺序）
	%% 垃圾装备
	oneOccupation2
}).

-endif.
