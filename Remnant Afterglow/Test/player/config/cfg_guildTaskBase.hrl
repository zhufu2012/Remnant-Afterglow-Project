-ifndef(cfg_guildTaskBase_hrl).
-define(cfg_guildTaskBase_hrl, true).

-record(guildTaskBaseCfg, {
	iD,
	%% 每日次接取任务次数
	taskNumber,
	%% 每日免费刷新次数
	freeRefresh,
	%% 特殊
	%% （品质，出现个数，概率万分比，失败次数增长万分比）
	%% 品质：0、A；1、S；2、SS；3、SSS
	%% 随中之后，增加万分比重置.
	freeProbability,
	%% 普通
	%% 免费刷新,其他品质权重
	%% （品质,权重）
	%% 品质：0、A；1、S；2、SS；3、SSS
	freeWeight,
	%% 单日手动刷新刷新消耗
	%% （货币ID，数量）
	payRefresh,
	%% 特殊
	%% （品质，出现个数，概率万分比，失败次数增长万分比）
	%% 品质：0、A；1、S；2、SS；3、SSS
	%% 随中之后，增加万分比重置.
	payProbability,
	%% 普通
	%% 手动刷新,其他品质权重
	%% （品质,权重）
	%% 品质：0、A；1、S；2、SS；3、SSS
	payWeight
}).

-endif.
