-ifndef(cfg_changeNum_hrl).
-define(cfg_changeNum_hrl, true).

-record(changeNumCfg, {
	%% 阶数
	type,
	%% 转换次数
	num,
	%% 索引
	index,
	%% 是否是本职业
	%% 1、是
	%% 0、否
	lvmax
}).

-endif.
