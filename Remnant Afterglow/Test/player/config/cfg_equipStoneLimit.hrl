-ifndef(cfg_equipStoneLimit_hrl).
-define(cfg_equipStoneLimit_hrl, true).

-record(equipStoneLimitCfg, {
	%% 套装类型
	%% 1普通2完美3龙神装
	iD,
	%% 最少需要的装备条件
	%% （品质，星级）品质：0白 1蓝 2紫 3橙 4红 5龙 6神 7龙神
	needEquip
}).

-endif.
