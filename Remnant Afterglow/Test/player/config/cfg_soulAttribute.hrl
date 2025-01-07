-ifndef(cfg_soulAttribute_hrl).
-define(cfg_soulAttribute_hrl, true).

-record(soulAttributeCfg, {
	%% 聚魂道具的ID，和item一一对应
	iD,
	%% 聚魂强化等级
	lv,
	index,
	%% 此聚魂能升级的最大等级
	maxLv,
	%% 聚魂强化属性,1级时为激活属性
	%% {附加属性ID，附加值}
	strengthAttribute,
	%% 强化附加的通用属性
	%% {附加属性ID，附加值}
	strengthNormalAttribute,
	%% 是否为核心聚魂
	%% 1是，0否
	isCore,
	%% 强化到下一级需要使用到的道具id和数量
	%% {类型,id,数量}
	%% 1类型为货币
	%% 2类型为一般道具
	nextItem,
	%% 分解获得的道具id和数量
	%% {类型,id,数量}
	%% 1类型为货币
	%% 2类型为一般道具
	resolveItem,
	%% 聚魂是晋升还是合成获得
	%% 1为晋升，2为合成
	isPromotion,
	%% 拆解获得道具
	%% {类型,id,数量}
	%% 类型1为货币
	%% 类型2为一般道具
	openItem,
	%% 当前等级分解后所反还的升级消耗道具id和数量{类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	resolveLvItem,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate,
	%% 神魂类型分类，同类型不可同时装配
	type
}).

-endif.
