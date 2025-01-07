-ifndef(cfg_skillActionnew_hrl).
-define(cfg_skillActionnew_hrl, true).

-record(skillActionnewCfg, {
	%% 技能操作方式
	%% 1.普通 2.长按和按下开关
	operationMode,
	%% 预警时间(毫秒)
	%% 当值为0时,为不需要预警
	waringTime
}).

-endif.
