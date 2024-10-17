-ifndef(cfg_arenaRandom_hrl).
-define(cfg_arenaRandom_hrl, true).

-record(arenaRandomCfg, {
	%% 自己排名
	iD,
	%% 从左至右，位置1排名区间
	%% 备注1：判断在Set1排名区间对手的战力，选出战力低于“自己战力/ArenaFight[ExpDistribution_1_新加各种等级系数]”的对手中相对排名最高的，如果没有就在该排名区间正常选则1个对手；
	%% 备注2:未上榜的玩家以1500排名为准
	set1,
	set2,
	set3,
	set4,
	set5,
	%% Set1字段后端处理缩放倍数
	%% 这里填“5”表示：第一次在5-10名查找1次，第二次在11-15名查找1次，第三次在16-17名查找1次；
	%% 直到找到可秒杀的对手，终止查找；
	%% 如果没有的符合条件的对手就正常随机Set1范围内的名次。
	suoFang
}).

-endif.
