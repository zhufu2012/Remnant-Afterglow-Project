-ifndef(cfg_wingLevelNew_hrl).
-define(cfg_wingLevelNew_hrl, true).

-record(wingLevelNewCfg, {
	%% 等级
	iD,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
