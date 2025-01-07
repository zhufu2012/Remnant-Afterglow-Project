-ifndef(cfg_manorWarRank_hrl).
-define(cfg_manorWarRank_hrl, true).

-record(manorWarRankCfg, {
	%% 作者:
	%% 奖励档次ID
	%% 所有奖励只能领取1档
	%% 优先级：
	%% 奖励档次ID（ID越小越好）>排名类型>积分类型
	iD,
	%% 作者:
	%% 需求类型
	%% 1为排名需求
	%% 2为积分需求
	type,
	%% 作者:
	%% 参数1
	param1,
	%% 作者:
	%% 参数2
	param2,
	%% 作者:
	%% 1级领地物品奖励
	%% {物品ID，物品数量}
	awardItem1,
	%% 作者:
	%% 1级领地货币奖励
	%% {货币ID，货币数量}
	%% 货币ID：
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
	awardCoin1,
	%% 作者:
	%% 特殊奖励次数
	speNum,
	%% 作者:
	%% 宝箱所需公会总积分
	boxNeedInte,
	%% 作者:
	%% 问号宝箱对应等级胜利者和鼓舞者宝箱
	%% 填宝箱的ITEM
	unknow,
	%% 作者:
	%% 只要最终拥有领地就算胜利者
	%% 胜利者道具ID|失败者道具ID
	speItem,
	boxName
}).

-endif.
