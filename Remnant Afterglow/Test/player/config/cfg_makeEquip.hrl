-ifndef(cfg_makeEquip_hrl).
-define(cfg_makeEquip_hrl, true).

-record(makeEquipCfg, {
	%% 主图纸ID
	iD,
	%% 打造材料需求（道具ID，数量）
	needConsume,
	%% 消耗货币
	%% （货币ID，数量）
	needCoin,
	%% 召唤时间
	%% （秒）
	needTime,
	%% 初始值
	%% 库1概率（万分比）
	initialProbability,
	%% 库1（物品ID，权重）
	result1,
	%% 库2（物品ID，权重）
	result2
}).

-endif.
