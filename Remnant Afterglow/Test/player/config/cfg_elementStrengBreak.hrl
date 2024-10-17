-ifndef(cfg_elementStrengBreak_hrl).
-define(cfg_elementStrengBreak_hrl, true).

-record(elementStrengBreakCfg, {
	%% 强化类型
	%% 1攻击
	%% 2防御
	%% 所有部位的元素强化都一样
	type,
	%% 突破等级
	breakLevel,
	%% 索引
	index,
	%% 强化等级上限
	strengLevelLimit,
	%% 最大突破等级
	maxBreakLevel,
	%% 升下一级消耗
	%% （道具id，数量）
	consume,
	%% 突破等级属性
	%% (属性ID，属性值)
	%% 等级属性不叠加，前端处理当前提升的值
	attrAdd
}).

-endif.
