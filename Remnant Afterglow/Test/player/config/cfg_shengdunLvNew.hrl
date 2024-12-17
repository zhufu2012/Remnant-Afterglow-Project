-ifndef(cfg_shengdunLvNew_hrl).
-define(cfg_shengdunLvNew_hrl, true).

-record(shengdunLvNewCfg, {
	%% 圣盾等级
	iD,
	%% 圣盾最大等级
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% 这里的值是累计值
	%% (属性ID，属性值)
	attrAdd,
	%% 圣盾评分，为累计值
	rank
}).

-endif.
