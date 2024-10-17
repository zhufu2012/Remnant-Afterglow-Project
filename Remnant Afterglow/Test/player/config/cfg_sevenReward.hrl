-ifndef(cfg_sevenReward_hrl).
-define(cfg_sevenReward_hrl, true).

-record(sevenRewardCfg, {
	%% 功能ID
	iD,
	%% 功能名称
	name,
	%% 描述使用，服务器不使用
	decs,
	%% 活动开始时间1/秒
	time1,
	%% 活动开始时间2/秒
	time2,
	%% 活动持续时间/秒
	keeptime
}).

-endif.
