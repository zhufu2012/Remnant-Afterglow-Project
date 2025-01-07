-ifndef(cfg_mountLevelNew_hrl).
-define(cfg_mountLevelNew_hrl, true).

-record(mountLevelNewCfg, {
	%% 等级
	iD,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
