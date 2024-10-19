-ifndef(cfg_rebateAward_hrl).
-define(cfg_rebateAward_hrl, true).

-record(rebateAwardCfg, {
	%% 作者:
	%% 奖励ID
	iD,
	%% 作者:
	%% 奖励名称
	name,
	%% 作者:
	%% {货币类型，数量}
	%% 货币类型 
	%% 0为元宝 Gold
	%% 1为铜币 Money
	%% 2为魂玉 SoulValue
	%% 3为声望 Reputation
	%% 4为荣誉 Honor
	%% 5为战魂 WarSpirit
	%% 6为铸魂 EquipSoul
	%% 7为帮会贡献值 GangCont
	%% 8为神器 ArtiSoul
	awardCoin,
	%% 作者:
	%% 宝箱奖励
	%% {物品ID，数量}
	awardItem
}).

-endif.
