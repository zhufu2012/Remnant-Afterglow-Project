-ifndef(cfg_petSymbiosis_hrl).
-define(cfg_petSymbiosis_hrl, true).

-record(petSymbiosisCfg, {
	%% 入驻位ID
	iD,
	%% 解锁条件
	%% （条件类型，参数）
	%% 类型1英雄塔层数
	%% 类型2：vip等级
	%% 注：条件和消耗均填0表示默认开启
	%% 注：入驻只能按顺序解锁
	condition,
	%% 解锁消耗
	%% （消耗类型，id，数量）
	%% 类型1：道具
	%% 类型2：货币
	need
}).

-endif.
