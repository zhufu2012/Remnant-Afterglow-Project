-ifndef(cfg_robotNum_hrl).
-define(cfg_robotNum_hrl, true).

-record(robotNumCfg, {
	%% 功能id
	%% 填写Openaction的id
	%% 78永恒战场
	%% 95魔龙洞窟
	%% 101血色争霸
	%% 105巅峰3v3
	openactId,
	%% 地图id
	%% 对应活动的每个场景地图
	openactLv,
	%% 索引
	index,
	%% 机器人出生点
	%% (出生点x,出生点z，视野半径,巡逻半径,追击范围半径)
	%% 一个出生点，一个机器人
	robot,
	%% 复活时间
	%% (权重,复活时间,复活点1x,复活点1z，视野半径1,巡逻半径1,追击范围半径1,……)
	%% 机器人死亡时，根据权重随机获取一个复活时间（秒），再在对应的复活（五个参数一组）配置中随机一个复活点及AI参数
	revive,
	%% 复活次数
	%% 0为不限次数
	reviveNum
}).

-endif.
