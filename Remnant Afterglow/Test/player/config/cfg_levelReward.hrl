-ifndef(cfg_levelReward_hrl).
-define(cfg_levelReward_hrl, true).

-record(levelRewardCfg, {
	%% 作者:
	%% 等级礼包ID
	iD,
	%% 作者:
	%% 所需玩家等级
	level,
	%% 作者:
	%% 奖励道具
	%% {格子顺序，物品ID，物品数量}
	item,
	%% 作者:
	%% 奖励货币
	%% {格子顺序，货币类型，货币数量}
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 21为限时神将值 CareGodPoint
	coin,
	%% 作者:
	%% 建号时间算起（秒）
	need_Time,
	%% 作者:
	%% 额外奖励道具
	%% {格子顺序，物品ID，物品数量}
	item_other,
	%% 作者:
	%% 额外奖励货币
	%% {格子顺序，货币类型，货币数量}
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	%% 21为限时神将值 CareGodPoint
	coin_other
}).

-endif.
