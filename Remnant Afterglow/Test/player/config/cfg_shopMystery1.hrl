-ifndef(cfg_shopMystery1_hrl).
-define(cfg_shopMystery1_hrl, true).

-record(shopMystery1Cfg, {
	%% ID
	iD,
	%% 每轮免费刷新次数
	%% vipFun的ID
	refFree,
	%% 每轮恢复时间（小时）
	resetParam,
	%% 每轮免费刷新次数用完后：
	%% 消耗货币刷新次数
	%% vipFun的ID
	%% 每轮：可以是1次免费刷新次数，也可以是3次免费刷新次数。
	refPay,
	%% 每轮免费刷新次数用完后：
	%% 消耗货币刷新，单次消耗
	%% ConsumptionTime_1_次数消耗表，的ID
	refConsume,
	%% （等级段，累计充值段，商店ID）
	%% 等级段：只和等级比较，向前取；
	%% 累计充值段：只和累计充值比较，向前取，充值为绿钻；
	%% 商店ID：ShopMystery2_1_神秘商店位置，的ID.
	%% 每次刷新时判断等级和累计充值，选取对应的商店ID。
	numb
}).

-endif.
