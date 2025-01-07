-ifndef(cfg_directPurchaseSegmented1_hrl).
-define(cfg_directPurchaseSegmented1_hrl, true).

-record(directPurchaseSegmented1Cfg, {
	%% 活动ID
	%% ActiveBase表类型：18
	iD,
	%% 活动时间内容的天数序号
	%% 1、第1天
	%% 2、第2天
	%% ...
	%% n、第n天
	%% 前面天数不可购买后面天数的物品，后面天数可购买前面天数的物品
	num,
	%% 索引
	index,
	%% 最大天数
	maxNum,
	%% 直购物品库ID
	%% [DirectPurchaseSegmented2_1_直购2]ID
	itemID,
	%% 直购活动界面顶部道具显示
	%% 配置0，则不显示
	item,
	%% 第n天 包装名称
	text,
	%% 第n天 包装名称-英语
	text_EN,
	%% 第n天 包装名称-印尼
	text_IN,
	%% 第n天 包装名称-泰语
	text_TH,
	%% RU
	text_RU,
	%% FR
	text_FR,
	%% GE
	text_GE,
	%% TR
	text_TR,
	%% SP
	text_SP,
	%% PT
	text_PT,
	%% KR
	text_KR,
	%% TW
	text_TW,
	%% JP
	text_JP
}).

-endif.
