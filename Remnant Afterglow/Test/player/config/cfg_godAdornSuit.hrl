-ifndef(cfg_godAdornSuit_hrl).
-define(cfg_godAdornSuit_hrl, true).

-record(godAdornSuitCfg, {
	%% 阶数
	stage,
	%% 品质
	quality,
	%% 星数
	star,
	%% Key
	index,
	%% 套装属性
	%% （属性ID，值）
	suitAttr
}).

-endif.
