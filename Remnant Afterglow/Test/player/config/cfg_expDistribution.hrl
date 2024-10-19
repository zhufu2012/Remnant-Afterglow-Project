-ifndef(cfg_expDistribution_hrl).
-define(cfg_expDistribution_hrl, true).

-record(expDistributionCfg, {
	%% 玩家等级
	iD,
	%% 作者:
	%% 主角升级到下一等级所需经验
	exp,
	%% 玩家挂机获得的金币数量/每分钟
	coin,
	%% 玩家等级获得经验标准值（任务和副本中用到）
	standardEXP,
	%% 玩家等级获得金币标准值（任务和副本中用到）
	standardMoney,
	%% 战盟红包金币数
	redPacketMoney,
	%% 经验丹标准值（经验丹使用）
	eXPPowder,
	%% 人物基础属性
	attribute,
	%% 挂机等级经验产出(取玩家当前等级)
	offlineEXP,
	%% 战盟篝火经验：根据角色等级发放每次经验奖励
	guildDinnerExp,
	%% 神魔五层-人物基础属性
	sSRuinsAttribute
}).

-endif.
