-ifndef(cfg_prayItem_hrl).
-define(cfg_prayItem_hrl, true).

-record(prayItemCfg, {
	%% 道具ID
	iD,
	%% 祈愿时间
	needTime,
	%% 具体奖励（类型，ID，数量）
	%% 类型1：道具，类型ID为道具ID
	%% 类型2：货币，类型ID为货币ID
	gift
}).

-endif.
