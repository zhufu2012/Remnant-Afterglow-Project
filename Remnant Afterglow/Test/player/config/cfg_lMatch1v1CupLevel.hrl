-ifndef(cfg_lMatch1v1CupLevel_hrl).
-define(cfg_lMatch1v1CupLevel_hrl, true).

-record(lMatch1v1CupLevelCfg, {
	%% 等级
	iD,
	%% 等级上限
	maxLv,
	%% 升下一级需要经验
	exp,
	%% 等级奖励属性
	%% {属性ID，属性值}
	attrAdd
}).

-endif.
