-ifndef(cfg_geniusAttr_hrl).
-define(cfg_geniusAttr_hrl, true).

-record(geniusAttrCfg, {
	%% 属性天赋ID
	iD,
	%% 天赋名称
	name,
	%% 天赋描述
	des,
	%% 天赋ICON
	icon,
	%% 加的属性
	%% （属性ID，值）
	attribute
}).

-endif.
