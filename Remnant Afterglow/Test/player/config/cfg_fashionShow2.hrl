-ifndef(cfg_fashionShow2_hrl).
-define(cfg_fashionShow2_hrl, true).

-record(fashionShow2Cfg, {
	%% 时装ID
	iD,
	%% 激活和星级
	%% 激活后是1星
	star,
	%% 索引
	index,
	%% 最大星级
	starMax,
	%% 激活和升星消耗
	%% (道具ID，数量)
	item,
	%% 激活和升星属性
	%% (附加属性ID，附加值)
	attribute
}).

-endif.
