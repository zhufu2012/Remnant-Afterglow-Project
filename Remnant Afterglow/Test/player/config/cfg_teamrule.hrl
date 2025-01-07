-ifndef(cfg_teamrule_hrl).
-define(cfg_teamrule_hrl, true).

-record(teamruleCfg, {
	%% 地图id
	%% （1为 亲密助战）
	iD,
	%% 功能开启id
	openactionId,
	%% 副本AI
	mapAi,
	%% 组队人数上限
	teamLimit,
	%% X秒后匹配镜像
	robottime,
	%% 确认进入超时时间
	%% 单位秒
	waittime,
	%% 合并次数开启条件（或的关系）
	%% （类型，参数1）
	%% 类型1，玩家等级 参数1为玩家等级
	%% 类型2，VIP等级，参数1为VIP等级
	mergeLimit,
	%% 合并次数消耗
	%% （类型，参数1，参数2）
	%% 类型1为货币，参数1为货币id，参数2为数量
	%% 类型2为道具参数1为道具id，参数2为数量
	mergeNeed
}).

-endif.
