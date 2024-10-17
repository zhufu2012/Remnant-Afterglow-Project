-ifndef(cfg_guildDinneDrink_hrl).
-define(cfg_guildDinneDrink_hrl, true).

-record(guildDinneDrinkCfg, {
	%% 晚宴喝酒类型
	%% 1：个人
	%% 2：全盟
	iD,
	%% 喝酒消耗
	%% (消耗类型，参数1，参数2)
	%% 类型1为道具，参数1为道具ID，参数2为道具数量
	%% 类型2为货币，参数1为货币类型，参数2为货币数量
	drinkCost,
	%% 次数上限
	drinkLimit,
	%% 个人经验加成/次
	%% 万分点
	%% 持续经验获得基础值：【ExpDistribution_1_新加各种等级系数】GuildDinnerExp
	personalExp,
	%% 全盟经验加成/次
	%% 万分点
	wholeExp,
	%% 全盟经验加成上限
	%% 万分点
	wholeExpLimit,
	%% 发红包需要的喝酒次数
	drinkToRedpacketNum,
	%% （派发绑钻总数量，红包数）
	%% 个人每天能领取的红包总金额：
	%% 没订阅特权的人，由GuildRedPacket_NotVIPNum[globalSetup]限制；
	%% 订阅了特权的人，由GuildRedPacket_NotVIPNum[globalSetup]和ID=9[Subscribe_1_订阅特权]一起限制
	redPacket,
	%% 红包名称
	%% 配置后端可到的文字表
	redName,
	%% 红包介绍文字
	%% 配置后端可到的文字表
	redIntroduce,
	%% 红包口令库
	%% 随机取一个
	drinkPasswords,
	%% 喝酒阶段奖励的(开服天数，祭祀进度)
	drinkAllawardsPoints,
	%% 篝火BOSS
	%% 个人鼓舞buff
	personalBuff,
	%% 篝火BOSS
	%% 全盟鼓舞buff
	wholeBuff,
	%% 喝酒奖励协助令牌
	%% ------------
	%% 2021/7/13修改，改为：非限制协助令牌，货币ID=41.
	helpPres
}).

-endif.
