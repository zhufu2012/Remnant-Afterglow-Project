-ifndef(cfg_wildCoastBoss_hrl).
-define(cfg_wildCoastBoss_hrl, true).

-record(wildCoastBossCfg, {
	%% 等级
	%% 73级就找70 向下去取
	iD,
	%% 对应地图ID：2109000
	%% {权值,BOSSID}
	map1,
	%% 对应地图ID：2109001
	map2,
	%% 对应地图ID：2109002
	map3,
	%% 对应地图ID：2109003
	map4
}).

-endif.
