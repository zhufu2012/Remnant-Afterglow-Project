-ifndef(cfg_typeID_hrl).
-define(cfg_typeID_hrl, true).

-record(typeIDCfg, {
	%% 部位ID
	type,
	%% 阶数
	order,
	%% 索引
	index,
	%% 战士ID
	change1,
	%% 法师ID
	change2,
	%% 弓手ID
	change3,
	%% 圣职ID
	change4
}).

-endif.
