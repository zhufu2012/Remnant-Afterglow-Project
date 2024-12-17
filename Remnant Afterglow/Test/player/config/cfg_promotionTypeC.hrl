-ifndef(cfg_promotionTypeC_hrl).
-define(cfg_promotionTypeC_hrl, true).

-record(promotionTypeCCfg, {
	iD,
	%% 作者:
	%% 类型：
	%% 1. 积分购物
	%% 2. 货币购物
	%% 3. 打折限购
	%% 4. VIP特权
	type,
	%% 作者:
	%% 限制VIP等级
	viplevel,
	%% VIP可见等级
	%% 不满足配置的VIP等级则对应的项不可见
	viplimit,
	%% 作者:
	%% 出售物品
	%% {sellID,ItemID,ItemNum,coinType,oldPrice,nowPrice,limitType,limitTimes}
	%% sellID : 本项中唯一
	%% coinType:货币类型
	%% oldprice ： 原价
	%% nowprice： 现价
	%% limitType： 限制类型
	%%             0：无限制
	%%             1：每日限制
	%%             2：活动期间限制
	%% limitTimes： 限制次数
	%% 慎用类型1，目前类型1只限制了每天的领取次数，但没有重置达成的进度。这个以后优化
	%% 类型1一般只在售卖物品的活动中使用
	items
}).

-endif.
