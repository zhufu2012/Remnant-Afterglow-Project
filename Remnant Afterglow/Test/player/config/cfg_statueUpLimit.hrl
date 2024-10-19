-ifndef(cfg_statueUpLimit_hrl).
-define(cfg_statueUpLimit_hrl, true).

-record(statueUpLimitCfg, {
	%% 神像ID
	iD,
	%% 解锁神像翅膀升级功能所需镶嵌翅膀最低条件
	%% （品质，星级）
	%% 满足该品质及星级即开启功能
	openStatueUp,
	%% 对应神像翅膀升级中可消耗的神像ID
	statueID
}).

-endif.
