-ifndef(cfg_mountJiBanNew2_hrl).
-define(cfg_mountJiBanNew2_hrl, true).

-record(mountJiBanNew2Cfg, {
	%% 羁绊ID
	%% 1：A级羁绊
	%% 2：S级羁绊
	%% 3：SS级羁绊
	%% 4：SSS级羁绊
	iD,
	%% 羁绊等级
	level,
	%% 羁绊最大等级
	maxLv,
	%% 所需对应稀有度的外显数量
	num,
	%% 羁绊名字
	name,
	%% 增加属性
	%% 对已激活的对应稀有度的外显增加
	attrAdd
}).

-endif.
