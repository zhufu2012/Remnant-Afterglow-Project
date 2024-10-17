-ifndef(cfg_expediIllustrJiBan_hrl).
-define(cfg_expediIllustrJiBan_hrl, true).

-record(expediIllustrJiBanCfg, {
	%% 图鉴类型
	%% 1.星座；
	%% 2.城池；
	%% 3.首领；
	%% 4.资源；
	%% 5.爵位
	type,
	%% 羁绊等级
	level,
	%% 索引
	index,
	%% 最大羁绊等级
	lvMax,
	%% 羁绊名字
	%% (texts索引：IllustrationsJiBan1…)
	name,
	%% 升级羁绊，需要激活图鉴数量
	%% 默认0级羁绊,最大等级填0
	needNum,
	%% 等级属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
