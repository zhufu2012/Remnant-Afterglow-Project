-ifndef(cfg_ornamentSuit_hrl).
-define(cfg_ornamentSuit_hrl, true).

-record(ornamentSuitCfg, {
	%% 8件装备品质
	iD,
	%% 8件都达到了对应的品质后激活的套装属性，向下兼容
	%% 属性（属性ID，属性值）
	attribute
}).

-endif.
