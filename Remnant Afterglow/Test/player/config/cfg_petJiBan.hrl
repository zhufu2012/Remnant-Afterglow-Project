-ifndef(cfg_petJiBan_hrl).
-define(cfg_petJiBan_hrl, true).

-record(petJiBanCfg, {
	%% 羁绊ID
	iD,
	%% 羁绊等级
	level,
	%% 羁绊最大等级
	maxLv,
	%% 羁绊名字
	name,
	%% 宠物ID组
	group,
	%% 宠物ID组对应的等级
	needLv,
	%% 宠物ID组对应的星级
	needStar,
	%% 增加属性
	attrAdd
}).

-endif.
