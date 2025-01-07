-ifndef(cfg_dungeon_active).
-define(cfg_dungeon_active, 1).

-record(dungeon_activeCfg, {
	%% 作者:
	%% 1000-1999金钱
	%% 2000-2999
	%% 3000-3999
	%% 4000-4999
	%% 5000-5999
	iD,
	%% 作者:
	%% 副本类型
	%% 1金钱
	%% 2经验
	%% 3突破石
	%% 4精炼石
	%% 5培养丹
	type,
	%% 作者:
	%% 文字唯一标签
	%% 在这个表内策划使用
	dungeonNameIndex,
	%% 作者:
	%% 关卡名称
	dungeon_Name,
	%% 作者:
	%% 通过关卡解锁下一个关卡的ID
	dungeon_Next,
	%% 作者:
	%% 对应的副本ID
	mapID_Det,
	%% 作者:
	%% 挑战推荐战力显示
	recommend_battlepoint,
	%% 作者:
	%% 进入扣除
	%% 扣除次数|扣除体力
	costfatigue,
	%% 作者:
	%% 优先扣除次数和体力
	%% 消耗道具
	%% 道具ID|道具数量
	costItem,
	%% 作者:
	%% 积分转换ID
	conversionID,
	%% 作者:
	%% 转换类型
	%% 0为转换物品
	%% 1为转换货币
	conversionType,
	%% 作者:
	%% 显示道具ID
	showItem,
	%% 作者:
	%% 基础奖励
	%% {货币类型，货币数量}
	%% 货币：
	%% 0为元宝Gold
	%% 1为铜币Money
	%% 2为魂玉SoulValue
	%% 3为声望Reputation
	%% 4为荣誉Honor
	%% 5为战魂WarSpirit
	%% 6为铸魂EquipSoul
	%% 7为帮会贡献值GangCont
	%% 8为神器ArtiSoul
	coinGift,
	%% 作者:
	%% 基础奖励
	%% {物品ID，物品数量}
	itemGift,
	%% 作者:
	%% 当前关卡是否可以攻打
	%% 条件满足之一，就可攻打
	%% <VIP等级开放，玩家等级开放>
	%% 开放等级为-1则为等级不未开放条件
	openCondition,
	%% 作者:
	%% 当前关卡通关后，
	%% 下关开启等级。
	nextLevel
}).

-endif.
