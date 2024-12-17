-ifndef(cfg_monthlyCardReward_hrl).
-define(cfg_monthlyCardReward_hrl, true).

-record(monthlyCardRewardCfg, {
	%% 作者:
	%% 月卡ID
	iD,
	%% 作者:
	%% 月卡类型
	%% 1、免费月卡
	%% 2、普通月卡
	%% 3、至尊月卡
	%% 4、永久月卡
	carType,
	%% 作者:
	%% 月卡名字
	name,
	%% 作者:
	%% 月卡有效时间
	day,
	%% 作者:
	%% 购买立即获得元宝数量
	getReward,
	%% 作者:
	%% 每天领取元宝
	mReceive,
	%% 作者:
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
	%% 作者:
	%% 下一等级月卡ID
	next_ID,
	%% 作者:
	%% 月卡图标名字
	icon,
	%% 作者:
	%% 大背景图片
	bagIcom,
	%% 作者:
	%% 边框图片
	framePic,
	%% 作者:
	%% 月卡名字图片
	cardNamePic
}).

-endif.
