-ifndef(cfg_advertisingMap_hrl).
-define(cfg_advertisingMap_hrl, true).

-record(advertisingMapCfg, {
	%% 预告开启时机
	%% （类型，参数）
	%% 类型：
	%% 1.等级
	%% 2.开服天数
	%% 3.功能开启，参数为功能ID
	%% 4.任务，完成任务ID
	%% 5.副本，完成副本ID
	%% 配置0表示上一个关闭后直接开启
	showTime,
	%% 预告关闭时机
	%% （类型，参数）
	%% 类型：
	%% 1.功能开启，参数为功能ID
	%% 2.任务，参数为完成任务ID
	%% 3.副本，参数为完成副本ID
	%% 4.领取等级礼包，参数为等级礼包ID，默认领取免费物品
	%% 5.激活天神，参数为天神ID
	closingTime
}).

-endif.
