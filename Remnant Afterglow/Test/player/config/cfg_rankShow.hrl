-ifndef(cfg_rankShow_hrl).
-define(cfg_rankShow_hrl, true).

-record(rankShowCfg, {
	%% 排行榜ID
	iD,
	%% 功能
	openaction,
	%% 后台
	functionSwitch,
	%% 分类
	%% 1、养成类型
	%% 2、挑战类型
	%% 3、活动类型
	type,
	%% 开关
	%% 1、开
	%% 0、关
	openIF,
	%% 播报顺序
	%% 针对同种类型，序号小的在前
	%% 同类型的都从1开始连续
	rank,
	%% 播报类型
	%% 0-联服和非联服启用 
	%% 1-非联服启用 
	%% 2-联服启用 ,
	rankShowType
}).

-endif.
