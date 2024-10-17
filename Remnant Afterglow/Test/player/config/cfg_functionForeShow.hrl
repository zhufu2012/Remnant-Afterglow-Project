-ifndef(cfg_functionForeShow_hrl).
-define(cfg_functionForeShow_hrl, true).

-record(functionForeShowCfg, {
	iD,
	%% 功能预告时间
	time,
	%% 功能ID
	%% 11仙盟
	%% 14如来
	%% 52三界
	%% 53领地
	%% 54诛仙
	%% 58晚宴
	%% 61四海
	%% 65仙盟副本
	%% 66七夕副本
	%% 67麒麟洞
	%% 68运镖
	%% 69修罗战场
	%% 70跨服比武
	%% 71天宫试炼
	%% 72婚礼进行中
	%% 73仙侣跨服2V2
	actionID,
	%% 1为预告
	%% 2为进行中
	%% 3,4,5,为特殊预告类型，开始时间读取 当前ID+（3,4,5-1）的ID时间
	type
}).

-endif.
