-ifndef(cfg_dragonTempleBase_hrl).
-define(cfg_dragonTempleBase_hrl, true).

-record(dragonTempleBaseCfg, {
	iD,
	%% 填写DragonTempleReach_1_天神殿达成条件表的达成id
	activitys,
	%% 天神神殿界面奖励模型的参数配置
	%% （职业，模型ID，缩放，位置X,位置Y，位置Z,旋转X，旋转Y，旋转Z）
	%% 缩放：100表示缩放是1
	model
}).

-endif.
