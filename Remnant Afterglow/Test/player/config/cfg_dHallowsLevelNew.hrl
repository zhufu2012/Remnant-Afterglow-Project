-ifndef(cfg_dHallowsLevelNew_hrl).
-define(cfg_dHallowsLevelNew_hrl, true).

-record(dHallowsLevelNewCfg, {
	%% 圣物ID
	iD,
	%% 等级
	lV,
	%% 客户端索引
	index,
	%% 等级上限
	maxLv,
	%% 升至下一级的道具消耗（物品ID，数量）
	%% 初始道具为0级，升1级相当于激活圣物
	exp,
	%% 升至当前等级奖励属性
	%% （属性ID，属性值）填累加的值
	attrAdd,
	%% 达成等级后的激活属性（属性ID，值）
	activation
}).

-endif.
