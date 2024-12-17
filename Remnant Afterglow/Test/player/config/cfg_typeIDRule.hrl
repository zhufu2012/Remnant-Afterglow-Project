-ifndef(cfg_typeIDRule_hrl).
-define(cfg_typeIDRule_hrl, true).

-record(typeIDRuleCfg, {
	%% 阶数
	order,
	%% 类型
	%% 1、装备类
	%% 2、饰品类
	type,
	%% 索引
	index,
	%% 限制转换次数
	num
}).

-endif.
