-ifndef(cfg_weekFinancing_hrl).
-define(cfg_weekFinancing_hrl, true).

-record(weekFinancingCfg, {
	%% 世界等级
	worldlLv,
	%% 奖励天数ID
	%% 购买后第几天可以领取该奖励
	%% 1代表购买的当天可以领取
	%% 2代表购买的第二天可以领取
	dayID,
	index,
	%% 奖励
	%% (职业,类型，物品ID，是否绑定，数量)
	%% 职业：0=所有职业的人均可获得该掉落，1004=战士，10005=法师，1006=弓手.（如果是职业一的人，不会掉落职业二的奖励，但是可以获得不分职业的奖励）
	%% 类型：1为道具，填写道具ID，2为货币，填写货币枚举
	%% 掉落是否绑定：0为非绑 1为绑定，货币不使用此参数
	weekGift
}).

-endif.
