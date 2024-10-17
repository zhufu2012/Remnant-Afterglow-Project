-ifndef(cfg_hatcheEggs2Reward_hrl).
-define(cfg_hatcheEggs2Reward_hrl, true).

-record(hatcheEggs2RewardCfg, {
	%% 龙晶阶段
	iD,
	%% 对应活跃度
	liveness,
	%% （QTE判断，加速效果[秒]）
	%% QTE判断：1、QTE中了  0、QTE没中
	qTEFast,
	%% (QTE判断，类型，ID，数量)
	%% QTE判断：1、QTE中了  0、QTE没中
	%% 类型：1为道具，2为货币
	qTEGift
}).

-endif.
