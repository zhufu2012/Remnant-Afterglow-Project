-ifndef(cfg_robot3v3_hrl).
-define(cfg_robot3v3_hrl, true).

-record(robot3v3Cfg, {
	%% 玩家队伍人数
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
	%% 匹配到机器人的数量
	robotNum,
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
	robRankLv,
	%% 机器人BUFF
	robotBuff
}).

-endif.
