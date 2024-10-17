-ifndef(cfg_demonRankOpenTimes_hrl).
-define(cfg_demonRankOpenTimes_hrl, true).

-record(demonRankOpenTimesCfg, {
	%% 赛季期数
	iD,
	%% 对应服务器开服天数
	openDays,
	%% 下一赛季开启的时间（秒）
	%% 从本期赛季结束后的当晚24.00后开始计时
	%% 填0表示无下赛季
	startNewKill,
	%% 当前赛季持续时间
	continueTime,
	%% 当前赛季的发奖时间（本赛季）
	%% 例：1|3|6，代表本赛季第1天、第3天、第6天会发奖
	awardDays
}).

-endif.
