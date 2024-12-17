-ifndef(cfg_lMatch1v1MatchType_hrl).
-define(cfg_lMatch1v1MatchType_hrl, true).

-record(lMatch1v1MatchTypeCfg, {
	%% 连败次数
	%% 超过配置最大值，取配置最大值
	iD,
	%% 连败类型
	%% 对应【LMatch1v1Match_1_常规赛匹配】Type
	type,
	%% 匹配类型
	%% 1采用积分排名匹配-【LMatch1v1Match_1_常规赛匹配】ExpansionScore
	%% 2采用战力排名匹配-【LMatch1v1Match_1_常规赛匹配】ExpansionFight
	%% 3、采用机器人战力排名匹配-【LMatch1v1Match_1_常规赛匹配】ExpansionFight2
	matchType
}).

-endif.
