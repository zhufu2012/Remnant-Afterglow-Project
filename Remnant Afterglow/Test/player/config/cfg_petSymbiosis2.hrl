-ifndef(cfg_petSymbiosis2_hrl).
-define(cfg_petSymbiosis2_hrl, true).

-record(petSymbiosis2Cfg, {
	%% 入驻位等级
	%% 所有入驻位等级一样
	iD,
	%% 入驻位等级最大等级
	lvMax,
	%% 入驻位共生等级限制
	%% 当前共生等级上限
	lvlimt,
	%% 升至下级消耗
	%% （消耗类型，id，数量）
	%% 类型1：道具
	%% 类型2：货币
	need,
	%% 回退消耗
	%% （货币id，数量）
	consume,
	%% 回退返还的材料
	%% （类型，id，数量）
	%% 类型1：道具
	%% 类型2：货币
	return
}).

-endif.
