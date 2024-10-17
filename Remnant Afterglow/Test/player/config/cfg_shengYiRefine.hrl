-ifndef(cfg_shengYiRefine_hrl).
-define(cfg_shengYiRefine_hrl, true).

-record(shengYiRefineCfg, {
	%% 圣翼等级分类
	syLevel,
	%% 精炼等级
	refLevel,
	%% 索引
	index,
	%% 精炼等级上限
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
