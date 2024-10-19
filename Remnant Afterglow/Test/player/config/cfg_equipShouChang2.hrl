-ifndef(cfg_equipShouChang2_hrl).
-define(cfg_equipShouChang2_hrl, true).

-record(equipShouChang2Cfg, {
	%% 装备阶数
	iD,
	%% 装备品质
	%% 0白 1蓝 2紫 3橙 4红 5龙 6神 7龙神
	quality,
	%% 分类
	%% 1、攻防套装
	%% 2、饰品套装
	part1,
	%% 套装：几件套
	part2,
	index,
	%% 套装属性
	%% （属性id，值）
	%% 1、不同阶、不同件数的套装属性共存
	%% 2、同阶同件数的套装，高品质高星级替换低品质低星级（龙神3星>神装3>龙装3星>红3>红2>橙3）
	attribute
}).

-endif.
