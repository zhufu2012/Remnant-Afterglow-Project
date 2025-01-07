-ifndef(cfg_vipPackagePurchase_hrl).
-define(cfg_vipPackagePurchase_hrl, true).

-record(vipPackagePurchaseCfg, {
	%% 1、VIP4打包购买（ID：1，写死V4打包购买
	iD,
	%% 快速提升到对应VIP，打包购买价格
	%% ·配置：打包购买直购ID
	%% ·如已购买其中一个，则打包价格隐藏.
	packagePurchase,
	%% 被打包购买的商品内容
	%% ·配置对应商品的商品ID加功能序号，用“&”隔开。配置时需要和程序确认.
	%% 4.99美元月卡特权： SUBSCRIBEMONTH_1|1
	%% 4.99美元月理财： MONTHFINANCING_1|1
	%% 9.99美元终身卡： FOREVERCARD_1|1
	packagePurchase1,
	%% 打包购买后额外给的VIP经验值
	%% ·和直购给的VIP经验值，加在一起飘字显示
	%% ·配置0，表示不额外给经验值
	vipExp,
	%% 对应功能ID
	%% 在2、3中用就是直购礼包中用，哪个功能ID大显示哪个，都未开启就都不显示
	fuctionID,
	%% 打包购买，折扣显示
	%% 10000
	%% 1000=1折
	%% 1500=1.5折
	%% …
	%% 10000，不显示折扣
	discount
}).

-endif.
