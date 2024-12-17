-ifndef(cfg_growupReward_hrl).
-define(cfg_growupReward_hrl, true).

-record(growupRewardCfg, {
	%% ID
	iD,
	%% 类型
	%% 1 为成长基金 购买了才能领
	%% 2 为全民奖励 全服购买人数够了就可以领
	type,
	%% 所需全服购买人数
	num,
	%% 领取奖励所需等级
	level,
	%% 基础奖励
	%% {货币类型，货币数量}
	%% 货币：
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	coinGift,
	%% 基础奖励
	%% {物品ID，物品数量}
	itemGift
}).

-endif.
