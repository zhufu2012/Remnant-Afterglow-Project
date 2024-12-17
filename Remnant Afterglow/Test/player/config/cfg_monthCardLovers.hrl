-ifndef(cfg_monthCardLovers_hrl).
-define(cfg_monthCardLovers_hrl, true).

-record(monthCardLoversCfg, {
	iD,
	%% 购买方式
	%% 1、货币
	%% 2、直购
	type,
	%% 购买消耗
	%% （货币类型，数量）
	price,
	%% 直购商品ID，要和运营核对好价格.
	%% 货币消耗或者直购商品ID只能配置其中一个
	directPurchase,
	%% 购买后立即获得
	%% （货币类型，数量）
	getOnce,
	%% 双方立即获得亲密度
	intimacy,
	%% 有情侣月卡的人每日领取的奖励
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	award,
	%% 月卡持续天数
	day
}).

-endif.
