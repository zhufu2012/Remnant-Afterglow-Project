-ifndef(cfg_wingFlyNew_hrl).
-define(cfg_wingFlyNew_hrl, true).

-record(wingFlyNewCfg, {
	%% 品质
	%% 此处为翅膀本身品质
	%% 1R
	%% 2SR
	%% 3SSR
	%% 4SP
	%% 5UR
	iD,
	%% 飞翼等级
	level,
	%% 升下一级消耗道具{数量}
	%% 具体消耗取激活飞翼时的消耗
	needItem,
	%% 飞翼最大等级
	maxLv,
	%% 等级属性
	%% {属性ID，属性值}
	attrAdd,
	%% 当前等级飞行时速度
	speed
}).

-endif.
