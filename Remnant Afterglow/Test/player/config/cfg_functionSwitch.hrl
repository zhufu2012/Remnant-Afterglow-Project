-ifndef(cfg_functionSwitch_hrl).
-define(cfg_functionSwitch_hrl, true).

-record(functionSwitchCfg, {
	%% 功能ID（不能修改）
	iD,
	%% 功能名称
	name,
	%% 开关：
	%%   1：默认开启
	%%   0：默认关闭
	switch
}).

-endif.
