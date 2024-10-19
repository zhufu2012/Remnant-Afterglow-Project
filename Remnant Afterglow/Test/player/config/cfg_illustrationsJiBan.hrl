-ifndef(cfg_illustrationsJiBan_hrl).
-define(cfg_illustrationsJiBan_hrl, true).

-record(illustrationsJiBanCfg, {
	%% 羁绊ID
	iD,
	%% 羁绊等级
	level,
	%% 最大羁绊等级
	lvMax,
	%% 羁绊名字
	%% (texts索引：IllustrationsJiBan1…)
	name,
	%% 图鉴ID组
	group,
	%% 图鉴ID组对应的星级
	needStar,
	%% 图鉴ID组对应的升品等级
	needQualityLv,
	%% 增加属性
	attrAdd,
	%% 特殊属性
	specialAttribute
}).

-endif.
