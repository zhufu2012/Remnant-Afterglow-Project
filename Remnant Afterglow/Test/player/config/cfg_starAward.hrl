-ifndef(cfg_starAward_hrl).
-define(cfg_starAward_hrl, true).

-record(starAwardCfg, {
	%% 封印次数id
	iD,
	%% 奖励档次
	rewardlevel,
	%% 客户端索引
	index,
	%% 总奖励档次
	grade,
	%% 星数区间
	totalStar,
	%% 奖励:
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	%% 这里前端显示和掉落非装备类型的道具都用这字段
	totalStarAward
}).

-endif.
