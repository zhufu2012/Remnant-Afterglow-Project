-ifndef(cfg_faZhenStar_hrl).
-define(cfg_faZhenStar_hrl, true).

-record(faZhenStarCfg, {
	%% 法阵ID
	iD,
	%% 法阵星级
	starLv,
	%% 索引
	index,
	%% 升星的最大等级
	maxStarLv,
	%% 星级提升属性
	%% (这里填的是累加值，程序直接取）
	starAttribute,
	%% 当前法阵上的全符文提升万分比
	%% （和升星提升的万分比做加法）
	%% 也要算升级的加成值
	starAttributePercent,
	%% 升星到下一级需要使用到的道具id和数量
	%% {类型，id，数量}
	%% 1类型为一般道具
	%% 2类型为货币
	nextStarItem,
	%% 当前星级分解/拆解后所反还的升星消耗道具id和数量（同时获得升级材料，在RuneAttribute配置表）
	%% {类型，id，数量}
	%% {类型，id，数量}
	%% 1类型为一般道具
	%% 2类型为货币
	resolveStarItem,
	%% 升星法阵评分
	%% 这里直接取值
	rcneScore
}).

-endif.
