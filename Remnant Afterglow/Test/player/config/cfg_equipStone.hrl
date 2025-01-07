-ifndef(cfg_equipStone_hrl).
-define(cfg_equipStone_hrl, true).

-record(equipStoneCfg, {
	%% 装备阶数
	iD,
	%% 套装类型
	%% 1普通2完美3龙神装
	suitType,
	%% 套装攻防类型
	%% 1攻击2防御3预留
	type,
	%% 套装装备件数填多少就是几件套
	suit,
	%% 索引
	index,
	%% 增加属性{属性id，数值}
	attribute
}).

-endif.
