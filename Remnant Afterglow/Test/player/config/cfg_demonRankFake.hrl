-ifndef(cfg_demonRankFake_hrl).
-define(cfg_demonRankFake_hrl, true).

-record(demonRankFakeCfg, {
	%% 当前玩家的真实名次/500（全局表配置）
	%% 超过500为500，未通关为0.不足500人分母仍为500
	%% 算出来的值换算成万分比
	iD,
	%% 换算后的最终奖励数据
	%% 程序需要做第一名处理
	rankNumber
}).

-endif.
