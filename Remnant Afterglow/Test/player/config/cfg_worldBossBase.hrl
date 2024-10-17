-ifndef(cfg_worldBossBase_hrl).
-define(cfg_worldBossBase_hrl, true).

-record(worldBossBaseCfg, {
	%% 作者:
	%% 世界BOSS
	%% 奖励序号（1为击杀将，2为幸运奖）
	%% BOSS等级
	iD,
	%% 作者:
	%% 最高排名
	%% RankMin=0时，代表特殊奖励
	rankMin,
	%% 最低排名
	%% 当RankMin>0时，
	%% 当RankMin=0时，
	%% 0代表击杀额外奖励
	%% 1代表幸运额外奖励
	%% 2代表参与奖励（获得排名奖的不获得此奖励）
	%% RankMax大于10000
	%% 默认显示以上
	%% RankMax=-1
	%% 不显示排名奖励
	rankMax,
	%% 作者:
	%% 每日物品奖励
	%% {BOSS类型，物品ID，数量}
	everyDayItem,
	%% 每日货币奖励
	%% {BOSS类型，货币类型，数量}
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
	everyDayCoin,
	bossShowLevel1,
	bossShowLevel2,
	bossShowLevel3,
	bossName1,
	bossName2,
	bossName3,
	%% 作者:
	%% BOSSID
	monster,
	%% 作者:
	%% 在地图上显示的模型配置
	%% {BOSS类型,模型ID，放缩万分比}
	model
}).

-endif.
