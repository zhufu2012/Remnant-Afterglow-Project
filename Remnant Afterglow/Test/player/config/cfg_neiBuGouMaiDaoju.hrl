-ifndef(cfg_neiBuGouMaiDaoju_hrl).
-define(cfg_neiBuGouMaiDaoju_hrl, true).

-record(neiBuGouMaiDaojuCfg, {
	%% 内部购买/直购道具调用ID
	iD,
	%% 功能类型
	%% 0、充值
	%% 1、首充
	%% 2、续充
	%% 3、终身卡
	%% 4、月理财
	%% 5、成长基金
	%% 6、觉醒之路战令
	%% 7、月卡特权
	%% 8、赏金特权
	%% 9、吞噬特权
	%% 10、直购礼包
	%% 11、限时特惠
	%% 12、荣耀献礼
	type,
	%% 渗透参数
	parameter,
	%% 商品码，付款时使用的参数，只和价格有关
	itemCode,
	%% 相应功能表内除去servergroup的Index
	functionIndex,
	%% 中文价格
	%% 只有裸包取这里的配置，SDK包走ums后台拉价格（价格配置*100，显示上需要除以100）
	price0
}).

-endif.
