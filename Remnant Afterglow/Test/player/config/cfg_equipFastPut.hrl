-ifndef(cfg_equipFastPut_hrl).
-define(cfg_equipFastPut_hrl, true).

-record(equipFastPutCfg, {
	%% 阶数
	order,
	%% ID（优先级）
	%% ID越小优先级越大
	groupID,
	%% 索引
	index,
	%% 组合（品质，星级）
	combination
}).

-endif.
