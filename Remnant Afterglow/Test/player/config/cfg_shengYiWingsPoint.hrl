-ifndef(cfg_shengYiWingsPoint_hrl).
-define(cfg_shengYiWingsPoint_hrl, true).

-record(shengYiWingsPointCfg, {
	%% 品质序号
	%% 与翅膀品质对应，序号=品质+1
	iD,
	%% 激活翅膀增加激励点数
	%% （对应品质翅膀的激活数量，奖励的点数）
	%% 品质A翅膀增加激励点数=INT(品质A翅膀实际激活数*品质A奖励点数/奖励需要激活数)
	%% 例：A级翅膀配置(5,4),12个A翅膀=9点
	actiPoint,
	%% 翅膀升星增加激励点数
	%% （对应品质翅膀的星级，奖励的点数）
	%% 品质A翅膀星级增加激励点数=INT(品质A翅膀实际总星数*品质A奖励点数/奖励需要星数)
	%% 例：S级翅膀配置(4,1),S翅膀总35星=8点
	starPoint
}).

-endif.
