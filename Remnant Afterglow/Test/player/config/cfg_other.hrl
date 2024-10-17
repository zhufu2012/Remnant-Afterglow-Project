-ifndef(cfg_offstringCfg).
-define(cfg_offstringCfg, 1).

-record(offstringCfg, {
	%%admin:,id序号
	id,
	%%admin:,过滤字
	str
}).

-record(drop, {
	%% 作者:
	%% 掉落包ID
	id,
	%% 掉落类型
	%% 0:直接掉落
	%% 1:圆桌掉落
	%% 2：稀有掉落
	type,
	%%列表
	dropList
}).

-record(dropElement, {
	iD,
	dropType,
	param,
	pro,
	min,
	max,
	way,
	index
}).
-record(dropPackage, {
	id,
	maxWeight,
	itemList
}).
-record(dropPackageItem, {
	iD,
	itemID,
	weight,
	min,
	max,
	index
}).


-endif.
