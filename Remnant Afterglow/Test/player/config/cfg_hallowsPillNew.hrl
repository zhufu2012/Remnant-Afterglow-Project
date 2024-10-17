-ifndef(cfg_hallowsPillNew_hrl).
-define(cfg_hallowsPillNew_hrl, true).

-record(hallowsPillNewCfg, {
	%% 角色等级
	iD,
	%% 道具ID和Item表对应
	itemID,
	%% 索引
	index,
	%% 丹类型1火灵2水灵3雷灵4土灵
	element,
	%% 当前角色等级条件下丹药使用上限，角色等级填20（前面填10），限制填25，表示:11-20级的上限是25个
	max
}).

-endif.
