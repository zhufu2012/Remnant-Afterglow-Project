-ifndef(cfg_runeStep_hrl).
-define(cfg_runeStep_hrl, true).

-record(runeStepCfg, {
	%% 龙印道具ID
	%% 和item表一一对应
	iD,
	%% 龙印阶级
	stepLv,
	%% 双索引
	index,
	%% 升阶的最大等级
	maxStepLv,
	%% 阶级提升基础属性万分比
	stepAttribute,
	%% 升阶到下一级需要使用到的道具id和数量
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	nextStepItem,
	%% 当前阶级分解/拆解后所反还的升阶消耗道具id和数量（同时获得升级材料，在RuneAttribute配置表）
	%% {类型，id，数量}
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	resolveStepItem
}).

-endif.
