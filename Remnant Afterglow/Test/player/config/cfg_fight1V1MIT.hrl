-ifndef(cfg_fight1V1MIT_hrl).
-define(cfg_fight1V1MIT_hrl, true).

-record(fight1V1MITCfg, {
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
