-ifndef(cfg_rcneAttribute_hrl).
-define(cfg_rcneAttribute_hrl, true).

-record(rcneAttributeCfg, {
	%% 符文道具ID
	%% 和item表一一对应
	iD,
	%% 符文强化等级
	lv,
	%% 双索引
	index,
	%% 此符文能升级的最大等级
	maxLv,
	%% 符文强化属性，1级时为符文初始属性
	%% {附加属性ID，附加值}升级后属性
	strengthAttribute,
	%% 强化到下一级需要使用到的道具id和数量
	%% {类型，id，数量}
	%% 1道具
	%% 2货币
	nextItem,
	%% 当前等级分解后所反还的升级消耗道具id和数量{类型，id，数量}
	%% 1道具
	%% 2货币
	resolveLvItem,
	%% 符文升级提供符文评分
	%% 这里是每次升级提供的评分
	rcneScore
}).

-endif.
