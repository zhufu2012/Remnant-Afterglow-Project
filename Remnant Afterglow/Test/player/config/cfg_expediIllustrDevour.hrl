-ifndef(cfg_expediIllustrDevour_hrl).
-define(cfg_expediIllustrDevour_hrl, true).

-record(expediIllustrDevourCfg, {
	%% 图鉴类型
	%% 1.星座；
	%% 2.城池；
	%% 3.首领；
	%% 4.资源；
	%% 5.爵位
	type,
	%% 吞噬等级
	level,
	%% 索引
	index,
	%% 最大吞噬等级
	lvMax,
	%% 升至下一级需要经验
	%% 默认0级,最大等级填0
	needExp,
	%% 等级属性
	%% (属性ID，属性值)
	attrAdd
}).

-endif.
