-ifndef(cfg_finallyArenaItem_hrl).
-define(cfg_finallyArenaItem_hrl, true).

-record(finallyArenaItemCfg, {
	%% 竞技场结算ID
	arenaID,
	%% 排名下限
	limit,
	%% 排名上限
	max,
	%% 世界等级
	worldID,
	%% 索引
	index,
	%% 最终结算奖励
	%% （类型，id，数量）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	finallyDayAward
}).

-endif.
