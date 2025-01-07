-ifndef(cfg_dHallowsRune_hrl).
-define(cfg_dHallowsRune_hrl, true).

-record(dHallowsRuneCfg, {
	%% 圣物符文ID
	%% 同符文道具id
	iD,
	%% 圣物符文等级
	dHallowsRLV,
	%% 符文品质
	%% 0白1蓝
	%% 2紫3橙
	%% 4红5粉
	quality,
	%% 穿戴要求的最低转生数
	limitLv,
	%% 该圣印前一级圣印；填0表示无前一级
	priorRune,
	%% 该圣印后一级圣印；填0表示无前一级
	nextRune,
	%% 升至下一级等级消耗（符文ID，数量）；填0表示不可在向下升级
	useRune,
	%% 圣物符文当前属性（属性ID，值）
	attrAdd
}).

-endif.
