-ifndef(cfg_wingJiBanNew_hrl).
-define(cfg_wingJiBanNew_hrl, true).

-record(wingJiBanNewCfg, {
	%% 羁绊ID
	iD,
	%% 羁绊等级
	level,
	%% 羁绊最大等级
	maxLv,
	%% 羁绊名字
	name,
	%% 翅膀ID组
	group,
	%% 翅膀ID组对应的等级
	needLv,
	%% 翅膀ID组对应的星级
	needStar,
	%% 增加属性
	attrAdd
}).

-endif.
