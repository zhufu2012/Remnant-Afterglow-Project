-ifndef(cfg_lMatch1v1ExpItem_hrl).
-define(cfg_lMatch1v1ExpItem_hrl, true).

-record(lMatch1v1ExpItemCfg, {
	%% 奖杯id
	iD,
	%% 材料类型
	%% 1升级
	%% 2升品
	type,
	%% 材料序号
	order,
	%% 索引
	index,
	%% 最大材料数量
	maxNum,
	%% 道具ID和Item表一一对应
	itemID,
	%% 每个道具提供的经验值
	exp
}).

-endif.
