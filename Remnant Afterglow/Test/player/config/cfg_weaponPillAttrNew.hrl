-ifndef(cfg_weaponPillAttrNew_hrl).
-define(cfg_weaponPillAttrNew_hrl, true).

-record(weaponPillAttrNewCfg, {
	%% 编号id
	iD,
	%% 道具ID
	itemID,
	%% 每次嗑丹增加属性
	%% (属性id,属性值)
	attrAdd,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
