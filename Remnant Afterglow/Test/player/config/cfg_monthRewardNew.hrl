-ifndef(cfg_monthRewardNew_hrl).
-define(cfg_monthRewardNew_hrl, true).

-record(monthRewardNewCfg, {
	%% 月份
	month,
	%% 天数
	day,
	%% 索引
	index,
	%% 奖励
	%% 和RegisterReward表的Reward字段含义一致
	reward
}).

-endif.
