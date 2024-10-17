-ifndef(cfg_demonKillRank_hrl).
-define(cfg_demonKillRank_hrl, true).

-record(demonKillRankCfg, {
	%% 赛季
	season,
	%% 结算分段
	worldLv,
	%% 索引
	index,
	%% 奖励分段
	rewardStage,
	%% 实际名次称号奖励
	%% （实际名次，奖励称号ID）
	%% 下一赛季/结算分段时清空对应称号
	giveTitleID,
	%% 排名奖励
	%% (分段，职业，类型，物品ID，品质，星级，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% .3为装备
	%% 品质，星级：装备填，其他填0
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	%% 显示和掉落道具都用这字段
	demonRankAward
}).

-endif.
