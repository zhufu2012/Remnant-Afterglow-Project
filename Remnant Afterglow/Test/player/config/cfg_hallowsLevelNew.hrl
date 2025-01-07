-ifndef(cfg_hallowsLevelNew_hrl).
-define(cfg_hallowsLevelNew_hrl, true).

-record(hallowsLevelNewCfg, {
	%% 等级
	iD,
	%% 圣物类型1火2水3雷4土
	element,
	%% 客户端索引
	index,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
