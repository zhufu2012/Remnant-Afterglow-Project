-ifndef(cfg_towerCount_hrl).
-define(cfg_towerCount_hrl, true).

-record(towerCountCfg, {
	%% 地图ID
	iD,
	%% 怪物类型，数量
	%% 怪物类型：1、小怪 2、精英 3、BOSS
	count,
	%% 空模型ID
	kongModel,
	%% 序号，x坐标，z坐标
	position
}).

-endif.
