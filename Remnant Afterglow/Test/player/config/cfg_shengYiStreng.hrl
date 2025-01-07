-ifndef(cfg_shengYiStreng_hrl).
-define(cfg_shengYiStreng_hrl, true).

-record(shengYiStrengCfg, {
	%% 圣翼等级分类
	syLevel,
	%% 强化等级
	strLevel,
	%% 索引
	index,
	%% 强化等级上限
	maxLv,
	%% 升下一级消耗
	%% （道具id，数量）
	consume,
	%% 等级奖励属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
