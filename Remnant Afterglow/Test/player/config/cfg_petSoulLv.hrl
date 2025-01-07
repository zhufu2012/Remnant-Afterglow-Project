-ifndef(cfg_petSoulLv_hrl).
-define(cfg_petSoulLv_hrl, true).

-record(petSoulLvCfg, {
	%% 魔灵等级
	iD,
	%% 魔灵最大等级
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
