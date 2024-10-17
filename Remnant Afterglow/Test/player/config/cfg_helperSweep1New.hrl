-ifndef(cfg_helperSweep1New_hrl).
-define(cfg_helperSweep1New_hrl, true).

-record(helperSweep1NewCfg, {
	%% 小助手功能：
	%% 1、坐骑材料本
	%% 2、魔宠材料本
	%% 3、翅膀材料本
	%% 4、圣物材料本
	%% 5、龙神材料本
	%% 6、地精宝库
	%% 7、埋骨之地
	%% 8、竞技场
	iD,
	%% 绑钻扫荡消耗/1次
	%% (货币枚举，数量)
	bindingNeed,
	%% 绑钻扫荡奖励加成
	%% 万分点
	%% 加成效果只对道具奖励有效，不影响经验加成
	bindingAward
}).

-endif.
