-ifndef(cfg_rechargeAward_hrl).
-define(cfg_rechargeAward_hrl, true).

-record(rechargeAwardCfg, {
	%% 作者:
	%% 1开头是单日累计充值
	%% 2开头是累计充值
	iD,
	%% 作者:
	%% 充值元宝数量
	gold,
	%% 道具和数量
	%% {道具，数量}
	itemID,
	%% 作者:
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
	%% 104为装备强化石（装备经验）
	coin
}).

-endif.
