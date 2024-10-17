-ifndef(cfg_worldMap_hrl).
-define(cfg_worldMap_hrl, true).

-record(worldMapCfg, {
	%% 地图ID
	iD,
	%% 作者:
	%% 领地名称
	name,
	%% Administrator:
	%% 对应领地ID
	manorID,
	%% Administrator:
	%% 1为循环地图
	%% 2为主城
	%% 3为新手村
	%% 4天魔入侵
	%% 5天魔远征
	mapType,
	%% 是否可进入
	enterLimit,
	%% Administrator:
	%% 对应图标资源ID
	imageName,
	%% Administrator:
	%% 图标在界面上的坐标
	imagePosition
}).

-endif.
