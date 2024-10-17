-ifndef(cfg_lMatch1v1Cup_hrl).
-define(cfg_lMatch1v1Cup_hrl, true).

-record(lMatch1v1CupCfg, {
	%% 奖杯ID
	%% 与1v1赛季对应
	iD,
	%% 段位
	lV,
	%% 索引
	index,
	%% 最大段位
	lVMax,
	%% 激活材料ID
	%% 默认消耗1个
	lVConsume,
	%% 基础属性
	%% 奖杯基础属性包括段位基础属性+品质基础属性
	attrBase,
	%% 材料返还
	%% (道具ID，数量）
	%% 奖杯基础属性包括段位基础属性+品质基础属性
	return
}).

-endif.
