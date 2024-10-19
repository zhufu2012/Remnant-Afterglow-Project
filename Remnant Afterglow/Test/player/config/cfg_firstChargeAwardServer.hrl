-ifndef(cfg_firstChargeAwardServer_hrl).
-define(cfg_firstChargeAwardServer_hrl, true).

-record(firstChargeAwardServerCfg, {
	%% 方案
	%% 此表功能已废弃（D3，2022/11/28，任小通）
	iD,
	%% 作者:
	%% 开服时间在这个日期区间内的服务器，才生效
	%% {起始GSID,结束GSID}|{起始GSID,结束GSID}
	serverID
}).

-endif.
