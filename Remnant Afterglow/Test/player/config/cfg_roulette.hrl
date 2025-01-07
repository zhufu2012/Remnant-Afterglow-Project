-ifndef(cfg_roulette_hrl).
-define(cfg_roulette_hrl, true).

-record(rouletteCfg, {
	%% 作者:
	%% 转盘组
	%% 1普通抽卡（道具）
	%% 2英雄抽卡（元宝）
	%% 3装备抽卡(元宝)
	%% 4坐骑抽卡(元宝)
	%% 5翅膀抽卡（元宝）
	%% 6翅膀超级抽卡（元宝）
	iD,
	%% 作者:
	%% 等级限制
	%% 最高调用等级
	%% 双ID
	levelLimit,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 是否自动升级
	%% 1为自动升级
	%% 0为手动升级
	%% 需要满足后续条件
	autoUpd,
	%% 作者:
	%% 升级时，消耗的货币类型
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
	consCType,
	%% 作者:
	%% 升级消耗货币数量
	num,
	%% 作者:
	%% 抽卡时
	%% 消耗道具ID
	%% 消耗道具则不消耗货币
	%% 消耗货币则不消耗道具
	consItem,
	%% 作者:
	%% 抽卡时
	%% 消耗道具数量
	consNumb,
	%% 作者:
	%% 抽卡时
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
	%% 消耗道具则不消耗货币
	%% 消耗货币则不消耗道具
	currType,
	%% 作者:
	%% 抽卡时
	%% 物品原价
	%% 当消耗货币数量填“0”时，消耗货币无效，只能消耗道具抽卡
	origCopy,
	%% 作者:
	%% 固定产出物品
	item,
	%% 作者:
	%% 固定产出数量
	numb,
	%% 作者:
	%% 固定产出货币
	%% {货币类型，货币数量}
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
	%% 104为装备强化石（装备经验）
	coin,
	%% 作者:
	%% 搜索范围
	huntZone,
	%% 作者:
	%% 参数矩阵
	%% {权值，最高调用积分，增减积分，掉落包}
	paraArray,
	%% 作者:
	%% 本阶新增道具预览
	%% {道具ID}
	nextShow,
	%% 作者:
	%% 本阶段产出道具预览
	%% 道具|道具
	outputShow,
	%% 作者:
	%% 间隔时间(天)|次数奖励ID1|次数奖励ID1|…|次数奖励Idn
	%% 若概抽卡有多个等级段，以最后的等级段配置为准
	awardTime
}).

-endif.
