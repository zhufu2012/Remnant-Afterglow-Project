-ifndef(cfg_anyanEquipSuit_hrl).
-define(cfg_anyanEquipSuit_hrl, true).

-record(anyanEquipSuitCfg, {
	%% 阶数
	%% 前端显示最大阶数-分解筛选，遍历该字段的最大值
	step,
	%% 暗炎类型
	%% 1普通
	%% 2高阶
	%% 3珍稀
	typeID,
	%% 数量
	number,
	%% 索引
	index,
	%% 套装名
	suitName,
	%% 套装属性
	%% （属性ID，属性值）
	%% 取所有达到要求的最高阶奖励
	attribute
}).

-endif.
