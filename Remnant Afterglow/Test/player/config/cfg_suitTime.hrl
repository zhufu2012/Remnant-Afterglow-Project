-ifndef(cfg_suitTime_hrl).
-define(cfg_suitTime_hrl, true).

-record(suitTimeCfg, {
	%% 作者:
	%% 公用次数ID
	%% 对应DungeonBaseNew表中Consume字段中的枚举3
	iD,
	%% 作者:
	%% 最大可拥有次数VIP_ID
	%% 累计次数
	%% 配置成和每日恢复次数相同的ID
	maxTimeID,
	%% 作者:
	%% 每日恢复次数VIP_ID
	%% 也是初始次数
	recTimeID,
	%% 作者:
	%% 每日最大可重置次数VIP_ID
	%% 每日刷新次数
	%% 填0：表示不能重置
	%% （D2的副本玩法都不能重置，都填“0”）
	resTimeID,
	%% 作者:
	%% 每日副本可购买最大次数VIP_ID
	%% 填0：表示不能购买
	maxBuyTimeID,
	%% 描述
	dEC
}).

-endif.
