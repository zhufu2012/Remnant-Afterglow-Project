-ifndef(cfg_reactiveType_hrl).
-define(cfg_reactiveType_hrl, true).

-record(reactiveTypeCfg, {
	%% 动态类型
	%% 与PushSalesBase表的ReactiveType字段所填参数对应
	%% 1.今日特惠
	iD,
	%% 对应礼包挡位
	reactiveGear,
	%% 索引
	index,
	%% 按天数降低礼包挡位
	%% 单位：天
	%% 天的结算时间都是24点。
	%% 比如此处配1，即当天激活此推送后，到当天24点，玩家未购买此挡位的礼包，则第2天推送的礼包挡位降低。
	%% 比如此处配3，即当天激活此推送后，到第3天24点，玩家未购买此挡位的礼包，则第4天推送的礼包挡位降低。
	reduceDay,
	%% 降低的挡位数
	%% 未购买礼包天数达到降低条件ReduceDay时，推送礼包降低的挡位数。
	%% 如“3天未购买第3档礼包，第4天推送的礼包降低1档”，则ReduceDay填3，ReduceGear填1。
	reduceGear
}).

-endif.
