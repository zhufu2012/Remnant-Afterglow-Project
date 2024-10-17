-ifndef(cfg_shopMall_hrl).
-define(cfg_shopMall_hrl, true).

-record(shopMallCfg, {
	%% 作者:
	%% 商城类型副本编号，最大99
	%% 1为基础商城
	%% 2为VIP周折扣商店
	iD,
	%% 作者:
	%% 位置序列，最大99
	%% 热更中，删除或添加的位置唯一
	seat,
	index,
	%% 作者:
	%% 出售物品ID
	item,
	%% 作者:
	%% 单次出售物品的数量
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
	%% 10为血玉
	currType,
	%% 作者:
	%% 原价
	origCopy,
	%% 作者:
	%% 折扣类型
	%% 0为固定折扣
	%% 1为动态折扣
	discountType,
	%% 作者:
	%% 折扣参数
	%% 固定折扣时，为折扣率
	%% 动态折扣时，为动态表的编号ShopMallDyn
	discountParam,
	%% 作者:
	%% 限购类型
	%% 0为不限购
	%% 1为普通限购
	%% 2为VIP限购
	limitType,
	%% 作者:
	%% 限购参数
	%% 普通限购：限购次数
	%% VIP限购：VIP功能编号
	%% VIPFunction
	limitParam,
	%% 作者:
	%% 推销
	%% 0为NO
	%% 1为推销
	recommend,
	%% 作者:
	%% 可购买条件类型
	%% 0代表无需条件
	%% 1代表玩家等级
	%% 2代表VIP等级
	%% 3代表历史最大竞技场排名
	%% 4代表大闹天宫最高星数
	%% 5帮会等级
	%% 6历史最大比武排名
	%% 7历史最大世界BOSS单次伤害
	conditionType,
	%% 作者:
	%% 可购买条件参数
	%% ConditionType=3时，代表竞技场类型
	%% ConditionType=6时，代表比武排名类型
	conditionParam,
	%% 作者:
	%% 可购买条件参数2
	%% ConditionType=3，6时，代表排名
	conditionParam2,
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
