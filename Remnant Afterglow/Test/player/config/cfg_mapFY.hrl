-ifndef(cfg_mapFY_hrl).
-define(cfg_mapFY_hrl, true).

-record(mapFYCfg, {
	%% 地图id
	mapID,
	%% 当前波数：
	%% 第1波，第2波，第3波，第4波
	grade,
	%% 同一编组的优先级
	%% 优先级越低，怪物数值难度配置越低，初始为1
	selectMonsterPriority,
	%% 索引
	index,
	%% 当前等级完成后进入的下一波
	next,
	%% 波数条件:
	%% 进入下一波的波数条件：(条件,条件参数)。注：每波击杀数单独算，不包括之前的
	%% 条件1：击杀，条件参数：击杀数
	%% 条件2：持续时间，条件参数：时间（ms毫秒）
	bornActice,
	%% 维持的小怪数量:
	%% （地图需要维持的场上怪物数量）
	num,
	%% 刷怪间隔:
	%% （检测场上存活怪物是否小于配置值，小于就刷怪。刷怪数量=配置值-场上当前怪物存活数量）
	time,
	%% 怪物ID:
	%% （每一波刷小怪的怪物id）
	monsterID,
	%% 小怪刷新点
	%% （怪物刷新的X坐标,怪物刷新的Z坐标，朝向）
	monsterPosition,
	%% 本波条件完成时(即进入下一波时候)触发的BOSS(怪物数量,怪物ID,怪物刷新的X坐标,怪物刷新的Z坐标，朝向)
	bossID,
	%% 本波条件完成时(即进入下一波时候)触发的BOSS(怪物数量,怪物ID,怪物刷新的X坐标,怪物刷新的Z坐标，朝向)
	bossPosition,
	%% 友方龙神的刷新（数量，ID，X坐标，Z坐标，朝向）
	dragonid,
	%% 友方龙神的刷新（数量，ID，X坐标，Z坐标，朝向）
	dragonPosition
}).

-endif.
