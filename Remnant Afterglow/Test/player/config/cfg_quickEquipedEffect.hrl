-ifndef(cfg_quickEquipedEffect_hrl).
-define(cfg_quickEquipedEffect_hrl, true).

-record(quickEquipedEffectCfg, {
	%% 职业
	%% 1004战士
	%% 1005法师
	%% 1006弓手
	role,
	%% 部位
	%% 1为武器，2为项链，3为护手，4为戒指，5衣服，6头盔，7肩甲，9裤子，10护符，14.副手
	part,
	%% 索引
	index
}).

-endif.
