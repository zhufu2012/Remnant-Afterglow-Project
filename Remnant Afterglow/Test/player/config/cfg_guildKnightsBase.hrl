-ifndef(cfg_guildKnightsBase_hrl).
-define(cfg_guildKnightsBase_hrl, true).

-record(guildKnightsBaseCfg, {
	%% ID
	iD,
	%% 持续时间，配置：天
	%% 时间从开服开始，或合服开始，每次合服重置持续时间
	%% 持续时间配置0时，表示：以后的所有时间
	%% ID=1,时间=5，表示：持续5天，第1-5天；
	%% ID=2,时间=10，表示：持续10天，第6-15天；
	%% ID=2,时间=0，表示：持续无限天，第16天及以上；
	duration,
	%% 战盟排名的结算时间间隔
	%% （结算时间间隔，间隔内具体时间点）
	%% 结算时间间隔：配置天；
	%% 间隔内具体时间点：配置秒，换算成几点几分
	guildRankTime,
	%% 战盟内排名结算时间间隔，小时
	%% 成员结算是在战盟拍卖间隔时间内
	memberRankTime,
	%% 每日登陆奖励
	%% （职业，类型，类型ID，掉落是否绑定,掉落数量）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	%% 掉落是否绑定：0为非绑 1为绑定（货币没有绑定或非绑的说法）
	%% 掉落数量：奖励道具的数量
	freeAward,
	%% 战盟内获奖成员排名数
	memberNum,
	%% 战盟内获奖成员排名分段
	memberSection,
	%% 战盟排名界面，奖励预览的+号后面的图片资源名称
	%% （分段，图片ID）
	%% 图片读取散图，默认前缀LSQS_
	rewardPic,
	%% 进入活动的广告图文字1
	advertDesc1,
	%% 进入活动的广告图文字2
	advertDesc2,
	%% 进入活动的广告图文字3
	advertDesc3,
	%% 进入活动的广告图文字4
	advertDesc4,
	%% 进入活动的广告图文字5
	advertDesc5,
	%% 进入活动的广告图文字6
	advertDesc6,
	%% 进入活动的广告图文字7
	advertDesc7,
	%% 进入活动的广告图文字8
	advertDesc8
}).

-endif.
