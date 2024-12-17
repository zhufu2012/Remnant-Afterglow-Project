-ifndef(cfg_mapCollectionBorn_hrl).
-define(cfg_mapCollectionBorn_hrl, true).

-record(mapCollectionBornCfg, {
	%% 波数ID
	iD,
	%% 采集物ID|位置库1数量
	collection1,
	%% 位置库1
	%% (位置x,位置z,朝向)|…… (位置x,位置z,朝向)
	pos1,
	%% 其他采集物ID数量
	%% (采集物id,位置库2数量,位置库3数量,位置库4数量)|…… (采集物id,位置库2数量,位置库3数量,位置库4数量)
	collection234,
	%% 位置库2
	%% (位置x,位置z,朝向)|…… (位置x,位置z,朝向)
	pos2,
	%% 位置库3
	%% (位置x,位置z,朝向)|…… (位置x,位置z,朝向)
	pos3,
	%% 位置库4
	%% (位置x,位置z,朝向)|…… (位置x,位置z,朝向)
	pos4
}).

-endif.
