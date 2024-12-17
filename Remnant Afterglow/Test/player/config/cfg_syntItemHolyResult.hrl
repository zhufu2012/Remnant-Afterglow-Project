-ifndef(cfg_syntItemHolyResult_hrl).
-define(cfg_syntItemHolyResult_hrl, true).

-record(syntItemHolyResultCfg, {
	%% 主材料ID
	iD,
	%% 物品合成实际概率（万分比）
	%% 当这里填的值为99999，还用回原来的概率字段进行计算
	realRate,
	%% 主材料是否污染绑定
	binding,
	%% 合成结果
	%% (序号，权重，道具ID）
	syntItem,
	%% 偏向材料
	%% （道具1ID，序号1修正，序号2修正……）|（道具2ID，序号1修正，序号2修正……）
	runItem
}).

-endif.
