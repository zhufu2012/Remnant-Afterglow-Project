-ifndef(cfg_guildCopyRate_hrl).
-define(cfg_guildCopyRate_hrl, true).

-record(guildCopyRateCfg, {
	%% 章节ID
	iD,
	%% 进度序号
	rateRange,
	%% 索引
	index,
	%% 最大进度序号
	maxRateRange,
	%% 进度万分比
	%% 本章昨日进度
	progress,
	%% 每日进度奖励
	%% (职业，类型，ID，数量，品质，星级，是否绑定)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型1=道具，ID=道具ID；
	%% 类型2=货币，ID=货币ID
	%% 类型3=装备，ID=装备ID
	%% 品质、星级：对应装备的品质和星级，其他类型无效
	%% 是否绑定：0.非绑  1.绑定
	rewardItem
}).

-endif.
