-ifndef(cfg_heavenRank_hrl).
-define(cfg_heavenRank_hrl, true).

-record(heavenRankCfg, {
	%% 奖励档次ID
	%% 所有奖励只能领取1档
	%% 优先级：
	%% 奖励档次ID（ID越小越好）>排名类型>积分类型
	%% 达到积分类型中最高积分，才调用排行榜奖励
	iD,
	%% 需求类型
	%% 1为排名需求
	%% 2为积分需求
	type,
	%% 参数1
	param1,
	%% 参数2
	param2,
	%% {奖励类型,参数1,参数2}
	%% 类型：
	%% 1为物品，参数1为道具ID，参数2为数量
	%% 2为货币，参数1为货币ID，参数2为数量
	award
}).

-endif.
