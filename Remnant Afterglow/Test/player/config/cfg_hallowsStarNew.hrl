-ifndef(cfg_hallowsStarNew_hrl).
-define(cfg_hallowsStarNew_hrl, true).

-record(hallowsStarNewCfg, {
	%% 圣物id
	iD,
	%% 星数
	star,
	%% 客户端索引
	index,
	%% 最大星数
	starMax,
	%% 本级需要碎片,数量
	%% 不累加（基础表配置的激活材料也在这里，初始星数0星为激活材料）
	needItem,
	%% 升星提供属性
	attrAdd,
	%% 基础属性提升万分比
	attrIncrease,
	%% 提升系统中需要用到的评价该系统养成进度的依据值
	evaluate
}).

-endif.
