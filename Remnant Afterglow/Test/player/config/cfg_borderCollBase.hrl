-ifndef(cfg_borderCollBase_hrl).
-define(cfg_borderCollBase_hrl, true).

-record(borderCollBaseCfg, {
	%% 地图ID
	iD,
	%% 采集物刷新等待时间/秒
	initialTime,
	%% 晶石分布
	%% （采集物id，晶石数量，刷新间隔秒，积分）
	%% 填0表示没有晶石
	%% 采集物id：对应“Collection_1_采集物”的id
	sparNum,
	%% 晶石刷新点集合
	sparBorn1
}).

-endif.
