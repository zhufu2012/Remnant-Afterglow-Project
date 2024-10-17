-ifndef(cfg_godBlessUse_hrl).
-define(cfg_godBlessUse_hrl, true).

-record(godBlessUseCfg, {
	%% 限制等级【0做特殊处理取无尽神佑】
	iD,
	%% 转职数
	upcareerLv,
	%% 祈祷1：道具
	%% (道具ID，数量，增加进度万分比）
	useItem,
	%% 祈祷2：经验（免费祈祷）
	%% （消耗经验万分比，进度万分比）
	useExp1,
	%% 祈祷3：经验（付费祈祷）
	%% 普通祈祷
	%% （序号，货币类型，货币值，消耗经验万分比，进度万分比）
	useExp2
}).

-endif.
