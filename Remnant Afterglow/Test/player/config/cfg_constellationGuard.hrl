-ifndef(cfg_constellationGuard_hrl).
-define(cfg_constellationGuard_hrl, true).

-record(constellationGuardCfg, {
	%% 星座ID
	iD,
	%% 守护孔位序号
	guardOrder,
	%% 索引
	index,
	%% 守护类型
	%% 填写类型枚举
	%% 1、坐骑
	%% 2、宠物
	%% 3、翅膀
	%% 4、圣物
	guardType,
	%% 守护稀有度
	%% 填写稀有度枚举
	%% 0、N
	%% 1、S级
	%% 2、SR级
	%% 3、SSR级 
	%% 4、
	%% 5、
	guardGrade
}).

-endif.
