-ifndef(cfg_wingJiBanNew2_hrl).
-define(cfg_wingJiBanNew2_hrl, true).

-record(wingJiBanNew2Cfg, {
	%% 羁绊ID
	%% 1：SR级羁绊
	%% 2：SSR级羁绊
	%% 3：SP级羁绊
	%% 4：UR级羁绊
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
