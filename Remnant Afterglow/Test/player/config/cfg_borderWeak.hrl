-ifndef(cfg_borderWeak_hrl).
-define(cfg_borderWeak_hrl, true).

-record(borderWeakCfg, {
	%% 联服数
	%% 取小于等于玩家联服数的最大配置值
	num,
	%% 服务器积分排名
	%% 取小于等于玩家联服数的最大配置值
	rank,
	%% 索引
	index,
	%% buff加成
	%% (BuffID,生效范围)
	%% 生效范围：
	%% 1-所有地图
	%% 2-边境地图
	%% 填0表示没有加成
	bUFF,
	%% 是否可联盟
	%% 0-不可
	%% 1-可以
	alliance
}).

-endif.
