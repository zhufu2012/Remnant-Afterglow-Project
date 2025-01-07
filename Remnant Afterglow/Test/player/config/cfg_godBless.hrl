-ifndef(cfg_godBless_hrl).
-define(cfg_godBless_hrl, true).

-record(godBlessCfg, {
	%% 玩家限制等级【0做特殊处理取无尽神佑】
	iD,
	%% 当前神佑等级
	godBlesssLv,
	%% 索引
	index,
	%% 最大等级上限
	blessLimit,
	%% 属性（属性ID，值）（填累计）
	attribute,
	%% 阶段属性（属性ID，值）这里填单次，主要是为了前端程序读取方便
	activation
}).

-endif.
