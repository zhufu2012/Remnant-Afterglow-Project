-ifndef(cfg_runeAttribute_hrl).
-define(cfg_runeAttribute_hrl, true).

-record(runeAttributeCfg, {
	%% 符文道具ID
	%% 和item表一一对应
	iD,
	%% 符文强化等级
	lv,
	%% 双索引
	index,
	%% Type为符文类型，用于符文塔解锁新符文功能
	type,
	%% 此符文能升级的最大等级
	maxLv,
	%% 符文强化属性，1级时为符文初始属性
	%% {附加属性ID，附加值}升级后属性
	strengthAttribute,
	%% 强化附加的通用属性
	%% {附加属性ID，附加值}
	strengthNormalAttribute,
	%% 强化到下一级需要使用到的道具id和数量
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	nextItem,
	%% 分解获得的道具id和数量
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	resolveItem,
	%% 拆解获得道具
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	openItem,
	%% 当前等级分解后所反还的升级消耗道具id和数量{类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	resolveLvItem
}).

-endif.
