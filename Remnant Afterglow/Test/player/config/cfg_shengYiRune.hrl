-ifndef(cfg_shengYiRune_hrl).
-define(cfg_shengYiRune_hrl, true).

-record(shengYiRuneCfg, {
	%% 圣翼符文ID
	%% 同符文道具id
	iD,
	%% 符文属性
	%% (属性ID，属性值)
	attrBase,
	%% 符文升级消耗
	%% (道具ID，数量)
	%% 填0表示不可升级
	upConsume,
	%% 升级活动符文ID
	%% 同符文道具id
	upID
}).

-endif.
