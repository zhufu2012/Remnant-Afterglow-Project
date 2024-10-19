-ifndef(cfg_borderMilitary_hrl).
-define(cfg_borderMilitary_hrl, true).

-record(borderMilitaryCfg, {
	%% 军衔ID
	iD,
	%% 军衔名
	name,
	%% 击杀战功
	killMerit,
	%% 是否拥有召集权限
	%% 0-没有
	%% 1-有
	clumpYN,
	%% 召集消耗
	%% （每天免费召集次数，消耗类型，类型id，数量）
	%% 类型1：道具，后续填写道具id和数量
	%% 类型2：货币，后续填写货币枚举和数量
	%% 填0表示无消耗
	clumpConsume,
	%% 召见间隔秒（个人）
	clumpCD,
	%% 是否拥有结盟权限
	%% 0-没有
	%% 1-有
	conveningAt
}).

-endif.
