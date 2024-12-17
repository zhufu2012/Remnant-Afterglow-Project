-ifndef(cfg_expeditionOpen_hrl).
-define(cfg_expeditionOpen_hrl, true).

-record(expeditionOpenCfg, {
	%% 功能ID（同Openaction表的ID保持一致）
	iD,
	oder,
	index,
	%% 开服天数
	%% （开始，结束）
	time,
	%% 功能开启周几
	%% 1.表示星期一
	%% 2.表示星期二
	%% …
	%% 7.表示星期天
	%% 0.表示星期一至星期天都开启
	%% 1|2|3表示 星期一二三开启
	week
}).

-endif.
