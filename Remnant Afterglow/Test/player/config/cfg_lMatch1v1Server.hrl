-ifndef(cfg_lMatch1v1Server_hrl).
-define(cfg_lMatch1v1Server_hrl, true).

-record(lMatch1v1ServerCfg, {
	%% 1v1颠覆赛排名
	%% 与【LMatch1v1Ranking_1_赛季排名奖】ID对应
	iD,
	%% 战盟成员获得的时效BuffId
	%% 持续时间为下个常规赛（巅峰赛开启时清空）
	buffId1,
	%% 区服玩家获得的时效BuffId
	%% 持续时间为下个常规赛（巅峰赛开启时清空）
	buffId2
}).

-endif.
