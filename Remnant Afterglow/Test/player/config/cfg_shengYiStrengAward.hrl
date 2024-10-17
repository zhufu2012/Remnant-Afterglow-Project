-ifndef(cfg_shengYiStrengAward_hrl).
-define(cfg_shengYiStrengAward_hrl, true).

-record(shengYiStrengAwardCfg, {
	%% 圣翼等级分类
	syLevel,
	%% 强化等级
	strLevel,
	%% 索引
	index,
	%% 等级奖励属性
	%% (属性ID，属性值)
	%% 不叠加，前端计算
	attrAdd
}).

-endif.
