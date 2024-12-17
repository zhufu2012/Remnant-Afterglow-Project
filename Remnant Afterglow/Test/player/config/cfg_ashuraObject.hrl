-ifndef(cfg_ashuraObject_hrl).
-define(cfg_ashuraObject_hrl, true).

-record(ashuraObjectCfg, {
	%% ID
	iD,
	%% 活动开启后时间，秒
	activeTime,
	%% 本波刷的类型
	%% 1刷buff球(这个类型只保留最后一波，刷新波的时候删掉上波）
	type,
	%% 刷的数量.
	%% {在组1随机的数量，在组2随机的数量，在组3随机的数量}
	nUM,
	%% 刷东西的位置随机组1，不会重复选出
	position1,
	%% 刷东西的位置随机组2，不会重复选出
	position2,
	%% 刷东西的位置随机组3，不会重复选出
	position3,
	%% buff随机库。不会重复选出
	%% 随机库里的buff球|随机库里的buff球|随机库里的buff球
	buffObject
}).

-endif.
