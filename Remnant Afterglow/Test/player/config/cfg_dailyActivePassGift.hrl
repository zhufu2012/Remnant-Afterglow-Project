-ifndef(cfg_dailyActivePassGift_hrl).
-define(cfg_dailyActivePassGift_hrl, true).

-record(dailyActivePassGiftCfg, {
	%% 积分
	iD,
	%% 个人等级
	%% (起始等级、奖励序号）
	%% (1,1)|(100,2)表示：玩家等级为1-99级取序号为1的奖励，等级>=100级取序号为2的奖励.
	%% (1,1)表示：等级>=1级取序号为1的奖励.
	playerLv,
	%% 免费奖励
	%% (等级序号，职业,类型，物品ID，是否绑定，数量）
	%% 类型：1道具，2货币
	freeGift,
	%% 付费奖励
	%% (等级序号，职业,类型，物品ID，是否绑定，数量）
	%% 类型：1道具，2货币
	payGift
}).

-endif.
