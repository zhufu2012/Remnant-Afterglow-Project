-ifndef(cfg_vipWelfareNew_hrl).
-define(cfg_vipWelfareNew_hrl, true).

-record(vipWelfareNewCfg, {
	%% 作者:
	%% 每日领取奖励
	%% VIP等级
	iD,
	%% 作者:
	%% 预览VIP每日奖励ID
	%% 如果找不到，对应配置
	%% 同下处理
	%% -1为没有
	showID,
	%% 作者:
	%% VIP每日奖励
	%% {道具ID，道具数量}
	everyItem,
	%% 作者:
	%% 作者:
	%% 货币奖励
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
	everyCoin,
	%% 作者:
	%% 补偿当前VIP等级与上一级的差
	%% {道具ID，道具数量}
	compItem,
	%% 作者:
	%% 作者:
	%% 补偿当前VIP等级与上一级的差
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
	compCoin
}).

-endif.
