-ifndef(cfg_offlineCountReward_hrl).
-define(cfg_offlineCountReward_hrl, true).

-record(offlineCountRewardCfg, {
	%% 顺序ID
	iD,
	%% 所需快速讨伐次数
	num,
	%% 下一循环取到的ID
	nextId,
	%% 玩家等级区间
	%% (起始等级、奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	countGrade,
	%% 奖励
	%% （等级奖励序号，职业，类型，ID，数量，是否绑定）
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，1005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1道具，2货币
	%% ID：货币ID或道具ID
	%% 数量：货币数量或道具数量
	%% 是否绑定：0非绑，1绑定
	countAward
}).

-endif.
