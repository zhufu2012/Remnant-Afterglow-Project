-ifndef(cfg_shopCirculation_hrl).
-define(cfg_shopCirculation_hrl, true).

-record(shopCirculationCfg, {
	%% 作者:
	%% 循环商店编号
	iD,
	%% 作者:
	%% 序列
	snum,
	%% 作者:
	%% 位置序列
	seat,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 出售物品ID
	item,
	%% 作者:
	%% 单次出售物品数量
	num,
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
	%% 9为爱心
	%% 10为血玉
	coin,
	%% 作者:
	%% 单次出售货币
	coinNum,
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
	%% 9为爱心
	%% 10为血玉
	currType1,
	%% 作者:
	%% 物品原价
	origCopy1,
	%% 作者:
	%% 物折扣力度
	%% 万分比
	%% 当值小于10000时，显示客户端显示折扣
	discount1,
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
	currType2,
	%% 作者:
	%% 物品原价
	origCopy2,
	%% 作者:
	%% 物折扣力度
	%% 万分比
	%% 当值小于10000时，显示客户端显示折扣
	discount2,
	%% 作者:
	%% 所需物品ID
	needItem1,
	%% 作者:
	%% 所需物品数量
	num1,
	%% 作者:
	%% 所需物品ID
	needItem2,
	%% 作者:
	%% 所需物品数量
	num2,
	%% 作者:
	%% 限购类型
	%% 0为不限购
	%% 1为角色限购
	%% 2为帮派限购
	%% 3为全服限购
	limitType,
	%% 作者:
	%% 限购参数
	%% 限购数量
	limitParam,
	%% 作者:
	%% 推销
	%% 客户端是否显示推销
	recommend,
	%% 作者:
	%% 拍卖货币类型
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
	%% 10为血玉
	auctCType,
	%% 作者:
	%% 拍卖一口价
	auctBuyNow,
	%% 作者:
	%% 拍卖初始竞价
	%% 万分比
	auctIPPro,
	%% 作者:
	%% 拍卖每次竞价
	%% 万分比
	%% (AuctIPPro+AuctBidPro*N)<=10000
	auctBidPro
}).

-endif.
