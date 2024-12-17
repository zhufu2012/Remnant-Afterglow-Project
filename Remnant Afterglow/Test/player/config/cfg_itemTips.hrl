-ifndef(cfg_itemTips_hrl).
-define(cfg_itemTips_hrl, true).

-record(itemTipsCfg, {
	%% 个人等级分段
	%% (等级,等级序号）
	%% 等级段：向前取等
	%% (0,1）|(501,2):
	%% 0≤等级≤500,为序号1
	%% 等级≥501,为序号2.
	levelRule
}).

-endif.
