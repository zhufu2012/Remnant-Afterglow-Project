-ifndef(cfg_suitTypeChange_hrl).
-define(cfg_suitTypeChange_hrl, true).

-record(suitTypeChangeCfg, {
	%% 装备ID
	iD,
	%% （物品ID，数量）
	needItem,
	%% 转换后的装备ID
	changeType
}).

-endif.
