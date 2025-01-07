-ifndef(cfg_dHallowsStar_hrl).
-define(cfg_dHallowsStar_hrl, true).

-record(dHallowsStarCfg, {
	%% 组ID
	iD,
	%% 星数
	star,
	%% 客户端索引
	index,
	%% 最大星数
	gradeMax,
	%% 升到下一级消耗的材料
	%% 数量
	needItem,
	%% 升星提供属性
	%% （属性ID,值）
	%% （填的是累计增加的数据）
	attrAdd
}).

-endif.
