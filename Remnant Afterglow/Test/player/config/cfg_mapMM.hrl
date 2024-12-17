-ifndef(cfg_mapMM_hrl).
-define(cfg_mapMM_hrl, true).

-record(mapMMCfg, {
	%% ID
	%% (地图id)
	iD,
	%% 波数条件:
	%% 进入每一波的波数条件：(波数,进入这一波击杀数)。注：每波击杀数单独算，不包括之前的。第一波不需要 填
	bornActice,
	%% 维持数量:
	%% （地图需要维持的场上怪物数量）
	num,
	%% 刷怪间隔:
	%% （检测场上存活怪物是否小于配置值，小于就刷怪。刷怪数量=配置值-场上当前怪物存活数量）
	time,
	%% 怪物ID:
	%% （每一波刷怪的怪物id）
	monster,
	%% 怪物刷新点
	%% （怪物刷新的X坐标,怪物刷新的Z坐标，朝向）
	position,
	%% 最后一波怪停止刷怪的击杀数
	%% (从这波开始算，不是总击杀数)
	sTOPNUM
}).

-endif.
