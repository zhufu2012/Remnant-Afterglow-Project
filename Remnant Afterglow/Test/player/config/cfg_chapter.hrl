-ifndef(cfg_chapter).
-define(cfg_chapter, 1).

-record(chapterCfg, {
	%% 作者:
	%% 章节ID
	iD,
	%% 作者:
	%% 章节宝箱
	%% 所需星数
	star,
	%% 作者:
	%% 章节星级宝箱
	%% 货币
	%% {星级段序列,货币类型，货币值}
	%% 0为元宝Gold
	%% 1为铜币Money
	%% 2为魂玉SoulValue
	%% 3为声望Reputation
	%% 4为荣誉Honor
	%% 5为战魂WarSpirit
	%% 6为铸魂EquipSoul
	%% 7为帮会贡献值GangCont
	%% 8为神器ArtiSoul
	starCoin,
	%% 作者:
	%% 章节星级宝箱
	%% {星级段序列，物品ID，物品数量}
	starItem,
	%% 作者:
	%% 宝箱关卡
	%% 所需通关副本ID
	box,
	%% 作者:
	%% 关卡宝箱
	%% 货币
	%% {宝箱序列，货币类型，货币值}
	%% 0为元宝Gold
	%% 1为铜币Money
	%% 2为魂玉SoulValue
	%% 3为声望Reputation
	%% 4为荣誉Honor
	%% 5为战魂WarSpirit
	%% 6为铸魂EquipSoul
	%% 7为帮会贡献值GangCont
	%% 8为神器ArtiSoul
	boxCoin,
	%% 作者:
	%% 关卡宝箱
	%% {宝箱序列,物品ID，物品数量}
	boxItem
}).

-endif.
