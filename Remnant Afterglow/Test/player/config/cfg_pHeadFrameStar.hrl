-ifndef(cfg_pHeadFrameStar_hrl).
-define(cfg_pHeadFrameStar_hrl, true).

-record(pHeadFrameStarCfg, {
	%% 头像框ID
	iD,
	%% 星级
	star,
	%% 索引
	index,
	%% 最大星级
	starMax,
	%% 升星属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
