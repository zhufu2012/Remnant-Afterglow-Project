-ifndef(cfg_pLoudStar_hrl).
-define(cfg_pLoudStar_hrl, true).

-record(pLoudStarCfg, {
	%% 头像ID
	iD,
	%% 星级
	star,
	%% 索引
	index,
	%% 最大星级
	starMax,
	%% 升星消耗
	%% (道具ID，数量)
	itemId,
	%% 升星属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
