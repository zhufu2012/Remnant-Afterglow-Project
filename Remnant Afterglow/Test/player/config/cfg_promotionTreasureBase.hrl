-ifndef(cfg_promotionTreasureBase_hrl).
-define(cfg_promotionTreasureBase_hrl, true).

-record(promotionTreasureBaseCfg, {
	iD,
	%% 调用宝库奖励
	%% （序号，PromotionTreasureItem表奖励ID）
	treasureItem,
	%% 获取钥匙的任务
	%% （解锁天数，PromotionTreasureTask表任务ID)
	%% 解锁天数：如果配置1，则代表活动开启的第一天
	tasks
}).

-endif.
