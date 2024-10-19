-ifndef(cfg_moreChargeServer_hrl).
-define(cfg_moreChargeServer_hrl, true).

-record(moreChargeServerCfg, {
	%% 方案
	iD,
	%% 作者:
	%% 开服时间在这个日期区间内的服务器，才生效
	%% {起始GSID,结束GSID}|{起始GSID,结束GSID}
	serverID
}).

-endif.
