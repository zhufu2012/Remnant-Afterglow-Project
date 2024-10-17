-ifndef(cfg_mapObject_hrl).
-define(cfg_mapObject_hrl, true).

-record(mapObjectCfg, {
	%% ID
	iD,
	%% 作者:
	%% 刷的数量.
	nUM,
	%% 作者:
	%% 刷东西的位置随机组，不会重复选出
	position,
	%% 作者:
	%% buff球随机库。不会重复选出
	%% 随机库里的buff球|随机库里的buff球|随机库里的buff球
	buffObject
}).

-endif.
