-ifndef(cfg_fight3V3MIT_hrl).
-define(cfg_fight3V3MIT_hrl, true).

-record(fight3V3MITCfg, {
	%% ID
	iD,
	%% 玩家当前积分区间
	%% 如果范围超过最大范围，以最大范围为准
	score,
	%% 初始区间(上下限，均含)
	initialScore,
	%% 扩大时间,单位秒
	time,
	%% 扩大区间(上下限，均含)，对应前面时间
	expansionScore
}).

-endif.
