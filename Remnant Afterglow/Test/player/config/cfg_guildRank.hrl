-ifndef(cfg_guildRank_hrl).
-define(cfg_guildRank_hrl, true).

-record(guildRankCfg, {
	%% 序列
	iD,
	%% 1为每日帮会累计伤害排行奖励
	%% 2为每周全服单伤最高排行奖励
	type,
	%% 客户端索引
	index,
	%% 排名-高
	%% RankMax=0时
	%% RankMin=0时
	%% 代表其余参与该活动的人
	rankMax,
	%% 排名-低
	rankMin,
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
	%% 宝箱奖励
	%% {物品ID，数量}
	awardItem,
	%% 成员贡献值
	contribute
}).

-endif.
