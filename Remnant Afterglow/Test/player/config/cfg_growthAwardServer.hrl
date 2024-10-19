-ifndef(cfg_growthAwardServer_hrl).
-define(cfg_growthAwardServer_hrl, true).

-record(growthAwardServerCfg, {
	%% 方案
	iD,
	%% 作者:
	%% 开服时间在这个日期区间内的服务器，才生效
	%% {起始GSID,结束GSID}|{起始GSID,结束GSID}
	serverID
}).

-endif.
