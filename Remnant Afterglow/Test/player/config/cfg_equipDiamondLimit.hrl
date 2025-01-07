-ifndef(cfg_equipDiamondLimit_hrl).
-define(cfg_equipDiamondLimit_hrl, true).

-record(equipDiamondLimitCfg, {
	%% 亲密度等级
	iD,
	%% 下一级亲密度所需花费钻石
	needDiamond,
	%% 当前亲密度最多能花在装备购买的钻石数量
	%% *可以用ItemType=8来判断是否是装备
	diamondLimit,
	%% 转生带来的购买限额提高
	%% (转生数，钻石额增加）
	rebirthAddDiamond
}).

-endif.
