-ifndef(cfg_greenDiamondBlessBase_hrl).
-define(cfg_greenDiamondBlessBase_hrl, true).

-record(greenDiamondBlessBaseCfg, {
	%% 基础ID
	iD,
	%% 每日占卜
	%% （权重，占卜ID,奖励货币ID，奖励数量）
	dailyGift,
	%% 祈福保底次数
	%% 提前暴击，次数重置
	blessMustDouble,
	%% 不同VIP所获得的暴击率
	%% （VIP，暴击概率【万分比】）
	%% VIP数递增配置，不足取之前
	vipLikelihood,
	%% 基础获得
	%% 代码写死固定为蓝钻
	baseBlueDiamond,
	%% 触发暴击后的具体返利倍数（万分比）
	multiple
}).

-endif.
