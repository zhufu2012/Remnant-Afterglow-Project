-ifndef(cfg_grabRobot_hrl).
-define(cfg_grabRobot_hrl, true).

-record(grabRobotCfg, {
	%% 神石ID
	iD,
	%% 神石名字策划查找的时候用的，程序忽略
	god_StoneName,
	%% 机器人名字
	%% 抢夺玩家的时候使用玩家的名字
	robot_Name,
	%% 机器人等级
	robot_Level,
	%% {头像ID，命格等级}
	robot_head1,
	%% {机器人英雄ID,品质等级，星数}
	robot_head2,
	%% {机器人英雄ID,品质，星数}
	%% {机器人英雄ID,品质等级，星数}
	robot_head3,
	%% 抢夺机器人时掉落碎片的概率
	robot_Probability,
	%% 机器人的战斗力显示
	robot_Fight
}).

-endif.
