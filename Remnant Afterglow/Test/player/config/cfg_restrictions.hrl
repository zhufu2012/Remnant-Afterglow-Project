-ifndef(cfg_restrictions_hrl).
-define(cfg_restrictions_hrl, true).

-record(restrictionsCfg, {
	%% 奖励限制条件ID
	iD,
	%% {分组，条件类型，参数1，参数2，参数3}
	%% ·满足条件才“显示、掉落、实际给奖励”等情况，具体根据调用该条件ID的配置表字段来决定。
	%% ·分组：组号相同为“且”，组号不同为“或”。
	%% 条件类型：0，表示无限制；条件类型：0，表示无限制；
	%% 条件类型：1功能，参数=功能ID，该功能开启后满足；
	%% 条件类型：2等级，参数=等级，达到该等级才满足；
	restrictions
}).

-endif.
