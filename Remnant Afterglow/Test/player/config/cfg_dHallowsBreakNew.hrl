-ifndef(cfg_dHallowsBreakNew_hrl).
-define(cfg_dHallowsBreakNew_hrl, true).

-record(dHallowsBreakNewCfg, {
	%% 圣物ID
	iD,
	%% 突破等级
	lV,
	%% 客户端索引
	index,
	%% 圣物等级上限
	maxLv,
	%% 需要材料
	needItem,
	%% 附加属性
	attribute
}).

-endif.
