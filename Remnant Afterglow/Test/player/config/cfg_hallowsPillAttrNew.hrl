-ifndef(cfg_hallowsPillAttrNew_hrl).
-define(cfg_hallowsPillAttrNew_hrl, true).

-record(hallowsPillAttrNewCfg, {
	%% 编号id
	iD,
	%% 圣灵类型1火灵2水灵3雷灵4土灵
	element,
	%% 索引
	index,
	%% 道具ID
	itemID,
	%% 每次嗑丹增加属性
	attrAdd,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
