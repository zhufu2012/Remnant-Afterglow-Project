-ifndef(cfg_shopMallDyn_hrl).
-define(cfg_shopMallDyn_hrl, true).

-record(shopMallDynCfg, {
	%% 作者:
	%% 动态价格编号
	iD,
	%% 作者:
	%% 购买次数，超过配置最大数量已最大配置数为准
	num,
	%% 作者:
	%% 客户端索引
	index,
	%% 角色序号
	number,
	%% 作者:
	%% 折扣力度
	discountParam
}).

-endif.
