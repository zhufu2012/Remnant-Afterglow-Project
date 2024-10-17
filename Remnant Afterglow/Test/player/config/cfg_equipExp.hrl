-ifndef(cfg_equipExp_hrl).
-define(cfg_equipExp_hrl, true).

-record(equipExpCfg, {
	%% 装备阶数1-16阶
	%% 没有配置就不能吃
	iD,
	%% 装备品质
	%% 0白，1蓝，2紫，3橙，4红，5粉，6神
	quality,
	%% 装备星级
	%% 1-3星
	star,
	%% 索引
	index,
	%% 提供炼金的经验值
	provideExp
}).

-endif.
