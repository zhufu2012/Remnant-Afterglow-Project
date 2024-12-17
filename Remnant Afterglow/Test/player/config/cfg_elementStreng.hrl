-ifndef(cfg_elementStreng_hrl).
-define(cfg_elementStreng_hrl, true).

-record(elementStrengCfg, {
	%% 强化类型
	%% 1攻击
	%% 2防御
	%% 所有部位的元素强化都一样
	type,
	%% 强化等级
	%% 突破提升等级上限
	level,
	%% 索引
	index,
	%% 升下一级消耗
	%% （道具id，数量）
	consume,
	%% 等级属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
