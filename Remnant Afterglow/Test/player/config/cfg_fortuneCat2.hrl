-ifndef(cfg_fortuneCat2_hrl).
-define(cfg_fortuneCat2_hrl, true).

-record(fortuneCat2Cfg, {
	%% 调用次数ID
	iD,
	%% 可招财条件
	%% （条件类型，参数）
	%% 条件：1 活动期间累计充值绿钻，参数 = 绿钻数量；
	%% 条件：2 活动期间消费钻石（不包含绿钻），参数 = 钻石数量；
	%% 条件：3 VIP等级，参数 = VIP等级.
	%% 新增：条件：4 活动期间消费绿钻（不包含钻石），参数 = 绿钻数量；
	condition,
	%% 消耗
	%% (方案,方式,参数1,参数2)
	%% 方案：
	%% 同方案必须同时消耗才可启用
	%% 不同方案满足1个方案即可启用
	%% 多方案都满足优先扣除方案ID小的
	%% 方式：
	%% 1为消耗道具；参数1：消耗道具ID；
	%% 参数2：消耗道具数量
	%% 2为消耗货币；参数1：消耗货币ID；
	%% 参数2：消耗货币数量
	consume,
	%% 本次抽出奖励的编号权重
	%% （编号，权重）
	weight,
	%% (编号,是否系统公告，是否抽奖记录）
	%% 是否系统公告：1是，0否；
	%% 是否抽奖记录：1是，0否.
	show
}).

-endif.