-ifndef(cfg_borderBuyPoint_hrl).
-define(cfg_borderBuyPoint_hrl, true).

-record(borderBuyPointCfg, {
	%% 购买类型
	%% 1-征服点
	%% 2-荣誉点
	iD,
	%% 购次参数
	%% 1-单次征服点
	%% 2-单次荣誉点
	%% ·如果配置0，表示无法购买，隐藏购买入口
	pointNum,
	%% 单次购买消耗
	%% （货币枚举，数量）
	type,
	%% 可购买条件，活动剩余时间。
	%% 对应BP达到该配置的剩余时间才可显示购买按钮并才能购买。
	%% 配置：时间（小时）
	conditionTime
}).

-endif.
