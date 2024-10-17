-ifndef(cfg_mountJiBanNew_hrl).
-define(cfg_mountJiBanNew_hrl, true).

-record(mountJiBanNewCfg, {
	%% 羁绊ID
	iD,
	%% 羁绊等级
	level,
	%% 羁绊最大等级
	maxLv,
	%% 羁绊名字
	name,
	%% 坐骑ID组
	group,
	%% 坐骑ID组对应的等级
	needLv,
	%% 坐骑ID组对应的星级
	needStar,
	%% 增加属性
	attrAdd
}).

-endif.
