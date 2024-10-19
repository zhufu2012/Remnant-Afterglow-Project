-ifndef(cfg_soulStar_hrl).
-define(cfg_soulStar_hrl, true).

-record(soulStarCfg, {
	%% 聚魂道具ID
	%% 和item表一一对应
	iD,
	%% 聚魂星级
	starLv,
	%% 双索引
	index,
	%% 升星的最大等级
	maxStarLv,
	%% 星级提升基础属性万分比
	starAttribute,
	%% 升星到下一级需要使用到的道具id和数量
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	nextStarItem,
	%% 当前星级分解/拆解后所反还的升星消耗道具id和数量（同时获得升级材料，在RuneAttribute配置表）
	%% {类型，id，数量}
	%% {类型，id，数量}
	%% 1类型为货币
	%% 2类型为一般道具
	resolveStarItem
}).

-endif.
