-ifndef(cfg_bloodLlineageLevel_hrl).
-define(cfg_bloodLlineageLevel_hrl, true).

-record(bloodLlineageLevelCfg, {
	%% 血脉ID
	bloodID,
	%% 等级
	bloodLevel,
	%% 索引
	index,
	%% 等级上限
	maxLv,
	%% 阶数
	step,
	%% 当前星数
	star,
	%% 升下一级经验
	exp,
	%% 等级奖励属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
