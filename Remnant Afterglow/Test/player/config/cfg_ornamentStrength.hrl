-ifndef(cfg_ornamentStrength_hrl).
-define(cfg_ornamentStrength_hrl, true).

-record(ornamentStrengthCfg, {
	%% 部位ID
	%% 1为海王战戟，2为海鲨背鳍，3海妖手套，4为海龙鳞甲，5为海蛇腰带，6为海鲛长靴.
	iD,
	%% 强化等级
	lv,
	%% 索引
	index,
	%% 能强化的最大等级
	maxLv,
	%% 强化获得的属性
	%% （对应强化等级）
	strengthAttribute,
	%% 升级到下1级所需
	%% （类型，ID，值）
	%% 类型：1道具，2货币
	needExp,
	%% 分解之后得到的材料
	%% ｛类型，道具ID,道具数量｝
	%% 类型：1物品，ID为：道具ID
	%% 类型：2货币，ID为：货币ID
	%% 类型：3配饰，ID为：配饰ID
	%% 填0表示不能分解.
	decomposeItem,
	%% 强化评分
	%% 这里填的是每次强化带来的评分，需要程序去算总和
	strengthPoint
}).

-endif.
