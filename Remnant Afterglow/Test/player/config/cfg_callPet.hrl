-ifndef(cfg_callPet_hrl).
-define(cfg_callPet_hrl, true).

-record(callPetCfg, {
	%% 召唤的消耗道具ID
	iD,
	%% 消耗货币
	%% （货币ID，数量）
	needConsume,
	%% 召唤时间
	%% （秒）
	needTime,
	%% 建筑等级，库2实际概率(万分比）
	buildProbability,
	%% N次不出后必出
	%% （建筑等级，必出次数）
	mustSSR,
	%% 库1（物品ID，权重）
	%% 普通 SR
	result1,
	%% 库2（物品ID，权重）
	%% SSR
	result2
}).

-endif.
