-ifndef(cfg_lMatch1v1CupStar_hrl).
-define(cfg_lMatch1v1CupStar_hrl, true).

-record(lMatch1v1CupStarCfg, {
	%% 奖杯ID
	%% 与1v1赛季对应
	iD,
	%% 星级
	lV,
	%% 索引
	index,
	%% 最大星级
	lVMax,
	%% 升至本星级消耗的道具
	%% 默认消耗1个
	lVConsume,
	%% 升星提供的属性
	attrBase,
	%% 段位基础属性提升万分比
	%% 基础属性：段位基础属性
	%% 段位基础属性，读取：AttrBase[LMatch1v1Cup_1_奖杯段位]
	attrIncrease,
	%% 材料返还
	%% (道具ID，数量）
	%% 星级大于该星级时，点击使用返还的材料
	return
}).

-endif.
