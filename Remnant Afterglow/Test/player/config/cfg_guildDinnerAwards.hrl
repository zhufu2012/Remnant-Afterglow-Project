-ifndef(cfg_guildDinnerAwards_hrl).
-define(cfg_guildDinnerAwards_hrl, true).

-record(guildDinnerAwardsCfg, {
	%% 序号
	iD,
	%% 世界等级下限
	worldLvDown,
	%% 世界等级上限
	worldLvUp,
	%% 领取奖励需要非绑喝酒的次数
	drinkNum,
	%% 共用战盟红包上限，该字段废弃
	%% 喝酒红包绑钻领取的上限
	redGuildLimit,
	%% 喝酒阶段奖励:
	%% （阶段,阶段所需的积分,阶段篝火资源及坐标序号,阶段奖励类型,奖励参数1,奖励参数2,奖励参数3)
	%% 篝火资源及坐标的配置需要拼接"FireEffect"及该配置的序号,再去全局表"globalSetupText"读取对应的参数（Param为篝火资源路径，Param2为篝火坐标）；不在晚宴时间或没有达成任一阶段，则默认FireEffect0
	%% 奖励类型1为道具，参数1为道具id，参数2为绑定类型（0非绑，1绑定），参数3为道具数量
	%% 奖励类型2为货币，参数1为货币枚举，参数2占位（默认0），参数3为货币数量
	dinnerAllsward,
	%% 晚宴活动奖励展示
	dinnerwardShow,
	%% 篝火寻路点
	%% 玩家寻路时，随机选择一个点
	firePath
}).

-endif.
