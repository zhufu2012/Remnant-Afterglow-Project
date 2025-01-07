-ifndef(cfg_dStrengthLimit_hrl).
-define(cfg_dStrengthLimit_hrl, true).

-record(dStrengthLimitCfg, {
	%% 当前转数
	iD,
	%% 装备分类：1攻击类
	%% 2防御类
	%% 3饰品类(复活)
	%% 4饰品类(护身)
	%% 5饰品类（麻痹）
	%% 6龙神类
	category,
	%% 索引
	index,
	%% 装备转数对应的强化最大等级限制
	lvLimit
}).

-endif.
