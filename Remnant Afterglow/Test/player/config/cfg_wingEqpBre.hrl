-ifndef(cfg_wingEqpBre_hrl).
-define(cfg_wingEqpBre_hrl, true).

-record(wingEqpBreCfg, {
	%% 装备类型1攻击，2防御
	iD,
	%% 突破等级
	breLv,
	%% 索引
	index,
	%% 最大强化等级
	lv,
	%% 消耗道具{道具id，数量}
	itemConsume,
	%% 突破属性
	attribute,
	%% 最大突破等级
	lvMax
}).

-endif.
