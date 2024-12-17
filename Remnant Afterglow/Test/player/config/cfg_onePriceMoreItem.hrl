-ifndef(cfg_onePriceMoreItem_hrl).
-define(cfg_onePriceMoreItem_hrl, true).

-record(onePriceMoreItemCfg, {
	%% 功能系统
	system,
	%% 商品序号
	iD,
	%% Index，也等于支付时的渗透参数
	index,
	%% 商品码，付款时使用的参数，只和价格有关
	itemCode,
	%% 中文价格
	%% 只有裸包取这里的配置，SDK包走ums后台拉价格（价格配置*100，显示上需要除以100）
	price0
}).

-endif.
