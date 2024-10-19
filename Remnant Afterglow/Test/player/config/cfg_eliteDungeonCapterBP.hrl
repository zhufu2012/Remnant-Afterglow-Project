-ifndef(cfg_eliteDungeonCapterBP_hrl).
-define(cfg_eliteDungeonCapterBP_hrl, true).

-record(eliteDungeonCapterBPCfg, {
	%% 战令组
	iD,
	%% (功能ID，后台ID)
	functionId,
	%% 消耗类型
	%% 1、货币进阶
	%% 2、直购
	consumeType,
	%% 进阶消耗
	%% （货币ID，数量）
	advancedConsume,
	%% 进阶消耗
	%% 直购商品ID
	%% 货币消耗或者直购商品ID只能配置其中一个
	directPurchase,
	%% 基础战令名字
	baseIconText,
	%% 章节ID
	%% [EliteDungeonCapter_1_章节星级奖励]表的ID.
	capterID
}).

-endif.
