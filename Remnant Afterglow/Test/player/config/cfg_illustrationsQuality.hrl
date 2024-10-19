-ifndef(cfg_illustrationsQuality_hrl).
-define(cfg_illustrationsQuality_hrl, true).

-record(illustrationsQualityCfg, {
	%% 图鉴id
	iD,
	%% 品质等级
	qualityLv,
	%% 最大升品等级
	qualityMax,
	%% 升品消耗
	%% (道具ID,数量)
	%% 不累加
	needItem,
	%% 附加属性
	attribute
}).

-endif.
