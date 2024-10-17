-ifndef(cfg_heroGemBase_hrl).
-define(cfg_heroGemBase_hrl, true).

-record(heroGemBaseCfg, {
	%% 魂石分类
	%% 备注：这里与道具类型ItmeType=102时，DetailedType的类型相同
	iD,
	%% 魂石等级
	%% 这里与道具类型ItmeType=102时，DetailedType2的等级相同
	number,
	%% 索引
	index,
	%% 魂石属性
	%% (属性id，数量)
	attribute
}).

-endif.
