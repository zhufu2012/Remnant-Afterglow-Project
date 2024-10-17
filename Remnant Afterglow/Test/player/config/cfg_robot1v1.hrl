-ifndef(cfg_robot1v1_hrl).
-define(cfg_robot1v1_hrl, true).

-record(robot1v1Cfg, {
	%% 连续战败次数
	%% 累计上次活动的数据，
	%% 胜利就归0
	%% 取小于玩家值的最大配置值
	num,
	%% 匹配等待时间
	%% 秒
	%% 配置的每个时间点都计算一次
	waitTime,
	%% 索引
	index,
	%% 匹配到机器人的几率
	%% 万分点
	robotPro,
	%% 机器人镜像属性比下限
	%% 万分比
	robotAttrScaleMin,
	%% 机器人镜像属性比上限
	%% 万分比
	robotAttrScaleMax,
	%% 机器人等级波动范围
	%% （向下波动极限，向上波动极限）
	%% 以玩家等级为标准，上下波动；结果不小于1
	robLevel,
	%% 机器人段位ID波动范围
	%% （向下波动极限，向上波动极限）
	%% 以玩家段位为标准，上下波动；结果不小于1，不大于30
	robRankLv
}).

-endif.
