-ifndef(cfg_shengjiaLvUp_hrl).
-define(cfg_shengjiaLvUp_hrl, true).

-record(shengjiaLvUpCfg, {
	%% 圣甲阶数
	stairs,
	%% 圣甲等级
	lv,
	%% Key
	index,
	%% 上限等级
	iNT,
	%% 升下一级消耗
	%% (消耗道具id，数量）
	needItem,
	%% 等级奖励属性
	%% (属性ID，属性值)
	%% 这里配的是累计值
	attrAdd,
	%% 评价值
	%% 对应阶数的累计值
	point
}).

-endif.
