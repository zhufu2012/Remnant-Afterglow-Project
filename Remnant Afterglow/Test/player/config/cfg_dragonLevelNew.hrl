-ifndef(cfg_dragonLevelNew_hrl).
-define(cfg_dragonLevelNew_hrl, true).

-record(dragonLevelNewCfg, {
	%% 等级
	iD,
	%% 等级上限
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级段显示，主要是客户端显示用
	showLv,
	%% 等阶段显示，主要是客户端显示用
	showStairs,
	%% 突破消耗
	breakItem,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd,
	%% 单次点击需要材料及个数要求
	needItem,
	%% 单次点击增加属性
	addClickAttr
}).

-endif.
