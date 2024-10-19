-ifndef(cfg_mapBuffInfo_hrl).
-define(cfg_mapBuffInfo_hrl, true).

-record(mapBuffInfoCfg, {
	%% 作者:
	%% MapID
	iD,
	%% 地图刷buff球参数：
	%% {类型，时间，mapobjectID}|{类型，时间，mapobjectID}
	%% 类型：1时间顺序刷，刷完不刷
	%% 2循环刷
	info
}).

-endif.
