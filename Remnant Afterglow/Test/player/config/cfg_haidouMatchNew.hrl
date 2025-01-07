-ifndef(cfg_haidouMatchNew_hrl).
-define(cfg_haidouMatchNew_hrl, true).

-record(haidouMatchNewCfg, {
	%% ID
	iD,
	%% 初始匹配等级区间段
	%% 以队伍队长等级为基准，正负值设置匹配等级区间段
	level,
	%% 初始区间(上下限，均含)
	initialLevel,
	%% 扩大时间,单位秒
	time,
	%% 扩大区间(上下限，均含)，对应前面时间
	expansionlevel
}).

-endif.
