-ifndef(cfg_recurrence1_hrl).
-define(cfg_recurrence1_hrl, true).

-record(recurrence1Cfg, {
	iD,
	%% 回归触发条件
	%% （组号，类型，参数1，参数2）
	%% 组号：相同为“且”，需同时满足；不同为“或”，满足同一组号内容。
	%% 类型1：账号离线未登录老角色超过N天，参数1=天数，参数2=0；
	%% 类型2：开放有N天内的新服务器，且服务器的未满员，新服没有角色。参数1=开服天数.
	%% 类型3：老号充值绿钻数，参数1=额度，参数2=0.
	condition,
	%% 老服-回归活动的持续时间
	day1,
	%% 新服-回归福利活动持续时间（天）
	%% ·账号只能一个角色触发回归
	%% ·回归活动中，不在触发回归
	day
}).

-endif.