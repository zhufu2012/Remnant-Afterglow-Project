-ifndef(cfg_newLevelLimit_hrl).
-define(cfg_newLevelLimit_hrl, true).

-record(newLevelLimitCfg, {
	%% 等级封印期数ID
	iD,
	%% 对应封印等级
	levelLimit,
	%% 封印持续时间（天）现在字段应该没有作用，使用恶魔封印的时间
	time,
	%% （万分比经验,转换点）
	%% 每万分比经验，转换多少点数
	%% 货币ID：52
	changeNum,
	%% 首次达到封印等级的玩家奖励
	%% 称号ID
	firstLevelLimtReward,
	%% 之后达到封印等级的玩家奖励
	%% 称号ID
	nextLevelLimtReward,
	%% 封印结束后未达到封印等级的等级分段
	%% (起始等级、奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	otherRewardStage,
	%% 奖励序号对应的经验补偿列1
	expcompensate1,
	%% 奖励序号对应的经验补偿列2
	expcompensate2,
	%% 奖励序号对应的经验补偿列3
	expcompensate3,
	%% 奖励序号对应的经验补偿列4
	expcompensate4,
	%% 奖励序号对应的经验补偿列5
	expcompensate5,
	%% 奖励序号对应的经验补偿列6
	expcompensate6,
	%% 奖励序号对应的经验补偿列7
	expcompensate7,
	%% 经验的上限获取等级
	%% 比如是30级
	%% 最大可获取经验即为：30的0%到80的0%
	expLimit
}).

-endif.
