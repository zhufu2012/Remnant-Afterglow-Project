-ifndef(cfg_horcuxSoulLv_hrl).
-define(cfg_horcuxSoulLv_hrl, true).

-record(horcuxSoulLvCfg, {
	%% 器灵等级
	iD,
	%% 器灵最大等级
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
