-ifndef(cfg_equipStoneConsum_hrl).
-define(cfg_equipStoneConsum_hrl, true).

-record(equipStoneConsumCfg, {
	%% 部位
	type,
	%% 阶数
	order,
	%% 职业
	occupation,
	%% Key
	index,
	%% 普通、完美、龙神套装制作最低装备品质要求（）0白，1蓝，2紫，3橙，4红，5龙，6神，7龙神
	quality,
	%% 单件装备普通套装消耗道具数量
	%% {类型，道具id，数量}
	%% 1、道具 2、货币
	consume1,
	%% 单件装备完美套装消耗道具数量
	%% {类型,道具id，数量}
	%% 1、道具 2、货币
	consume2,
	%% 单件装备龙神套装消耗道具数量
	%% {类型,道具id，数量}
	%% 1、道具 2、货币
	consume3,
	%% 单件普通装备打造获得的属性
	%% （属性ID，值）
	baseAttrAdd1,
	%% 单件完美装备打造获得的属性
	%% （属性ID，值）
	baseAttrAdd2,
	%% 单件龙神装备打造获得的属性
	%% （属性ID，值）
	baseAttrAdd3
}).

-endif.
