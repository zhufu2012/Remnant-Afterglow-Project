-ifndef(cfg_syntTrea_hrl).
-define(cfg_syntTrea_hrl, true).

-record(syntTreaCfg, {
	%% 作者:
	%% 神石
	iD,
	%% 作者:
	%% 是否永久显示配方
	%% 0为不显示
	%% 1为显示
	show,
	%% 作者:
	%% 碎片数
	num,
	%% 作者:
	%% 需要物品ID
	needItem1,
	%% 作者:
	%% 需要物品ID
	needItem2,
	%% 作者:
	%% 需要物品ID
	needItem3,
	%% 作者:
	%% 需要物品ID
	needItem4,
	%% 作者:
	%% 需要物品ID
	needItem5,
	%% 作者:
	%% 需要物品ID
	needItem6,
	%% 作者:
	%% 抢夺机器人掉落碎片概率
	robotPro,
	%% 作者:
	%% 抢夺玩家成功概率
	playerPro
}).

-endif.
