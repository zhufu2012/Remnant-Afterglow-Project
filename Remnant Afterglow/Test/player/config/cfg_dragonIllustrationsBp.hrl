-ifndef(cfg_dragonIllustrationsBp_hrl).
-define(cfg_dragonIllustrationsBp_hrl, true).

-record(dragonIllustrationsBpCfg, {
	%% 战令组
	iD,
	%% 服务器组
	serverGroup,
	%% 索引
	index,
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
	%% 激活战令公告文字
	radio
}).

-endif.
