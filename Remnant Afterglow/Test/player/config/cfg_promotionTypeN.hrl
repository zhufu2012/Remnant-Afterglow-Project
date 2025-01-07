-ifndef(cfg_promotionTypeN_hrl).
-define(cfg_promotionTypeN_hrl, true).

-record(promotionTypeNCfg, {
	iD,
	%% 参与活动门票消耗（只配置一个）
	%% (货币ID，货币数量)
	cost,
	%% 参与活动门票消耗（只配置一个）
	%% (道具ID，道具数量)
	costItem,
	%% 活动开始后，多少时间内可以购买门票(单位时间：秒）
	%% 例如：86400表示活动开始后一天之内可以购买
	timeBuy,
	%% 条件达成ID
	%% 填PromotionTypeA表格中具体的ID
	getId,
	%% 计数类型
	%% （1为活动开启后就开始计数，2为角色购买门票后开始计数，0为不需要计数）
	count,
	%% 门票名称
	nameText,
	%% 门票名称
	nameText_EN,
	%% 印尼
	nameText_IN,
	%% 泰语
	nameText_TH,
	%% 购买超时多少小时并且玩家没有购买隐藏已超时该分页
	overTime
}).

-endif.
