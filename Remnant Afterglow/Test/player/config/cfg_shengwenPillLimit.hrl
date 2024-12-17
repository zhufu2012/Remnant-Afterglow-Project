-ifndef(cfg_shengwenPillLimit_hrl).
-define(cfg_shengwenPillLimit_hrl, true).

-record(shengwenPillLimitCfg, {
	%% 角色等级
	iD,
	%% 道具ID和Item表对应
	itemID,
	%% 索引
	index,
	%% 当前角色等级条件下丹药使用上限，角色等级填20（前面填10），限制填25，表示:11-20级的上限是25个
	max
}).

-endif.
