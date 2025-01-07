-ifndef(cfg_multipleBoss_hrl).
-define(cfg_multipleBoss_hrl, true).

-record(multipleBossCfg, {
	%% 死亡地狱：1
	%% 死亡森林：3   
	%% 诅咒禁地：4
	%% （和打宝类型对应起来的）
	%% 世界BOSS：7
	%% 联服死亡地狱：2
	%% 神魔战场：6
	%% 神魔幻域：8
	%% 元素试炼：12
	iD,
	%% 倍数
	multiple,
	index,
	%% 多倍开启条件
	%% (组号，类型，参数）
	%% 组号：组号相同为“且”，组号不同为“或”.
	%% 类型1：等级，参数=等级；
	%% 类型2：VIP，参数=VIP等级
	open,
	%% 多倍可视条件
	%% (组号，类型，参数）
	%% 组号：组号相同为“且”，组号不同为“或”.
	%% 类型1：等级，参数=等级；
	%% 类型2：VIP，参数=VIP等级
	show
}).

-endif.
