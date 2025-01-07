-ifndef(cfg_equipWashRule_hrl).
-define(cfg_equipWashRule_hrl, true).

-record(equipWashRuleCfg, {
	%% 锁定条目数量
	iD,
	%% 基础洗练时，锁定消耗基础道具数量
	%% (道具id，数量)
	washBase,
	%% 钻石洗练时，锁定消耗钻石数量
	%% (货币id，数量)
	washDiamond,
	%% 高级橙色洗练道具消耗(道具id，数量)
	washOrange,
	%% 高级红色洗练道具消耗(道具id，数量)
	washRed
}).

-endif.
