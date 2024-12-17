-ifndef(cfg_shengwenSuit_hrl).
-define(cfg_shengwenSuit_hrl, true).

-record(shengwenSuitCfg, {
	%% 阶数
	level,
	%% 圣纹类型
	%% 0所有
	%% 1灵纹
	%% 2魔纹
	%% 3神纹
	type,
	%% 数量
	number,
	%% 索引
	index,
	%% 套装名
	suitName,
	%% 属性（属性ID，属性值）
	attribute
}).

-endif.
