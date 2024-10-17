-ifndef(cfg_borderMonster_hrl).
-define(cfg_borderMonster_hrl, true).

-record(borderMonsterCfg, {
	%% 怪物ID
	monster,
	%% 地图ID
	map,
	%% 索引
	index,
	%% 怪物积分
	%% （积分方式，参数1，参数2）
	%% 积分方式：
	%% 1-固定值，参数1默认0，参数2为积分值
	%% 2-当前服务器总积分的百分比，参数1为积分百分比（万分点），参数2为积分值；若按参数1计算的积分值小于参数2，则取参数2的值
	integral,
	%% 伤害排名奖励战功
	%% （排名，战功）
	%% 取小于等于玩家排名的最大配置值
	rankMertial,
	%% 击杀怪物获得的额外战功
	killMerit,
	%% 伤害排名增加诅咒值
	%% （排名，诅咒值）
	%% 取小于等于玩家排名的最大配置值
	cursedValue,
	%% BOSS类型
	%% 1为大BOSS
	%% 2为中BOSS
	%% 3为小BOSS
	monsterGrade
}).

-endif.
