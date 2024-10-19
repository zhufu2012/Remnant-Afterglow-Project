-ifndef(cfg_holiday_hrl).
-define(cfg_holiday_hrl, true).

-record(holidayCfg, {
	%% 年
	year,
	%% 月
	mouth,
	%% 日
	day,
	%% 索引
	index
}).

-endif.
