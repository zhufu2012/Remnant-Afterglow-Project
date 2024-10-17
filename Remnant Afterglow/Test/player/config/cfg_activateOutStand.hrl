-ifndef(cfg_activateOutStand_hrl).
-define(cfg_activateOutStand_hrl, true).

-record(activateOutStandCfg, {
	%% 阶数
	stage,
	%% 类型
	godAdornType,
	%% 激活次数
	activateTimes,
	%% Key
	index,
	%% 激活获得有星属性后的品质
	%% 0白 1蓝 2紫 3橙 4红 5龙 6神  7、龙神
	%% 包装用
	activateQuality,
	%% 激活到下一级消耗
	%% （类型，ID，数量）
	%% 类型：1物品，ID为：道具ID
	%% 类型：2货币，ID为：货币ID
	activateNeedItem,
	%% 当级的可激活最大次数
	maxActivate,
	%% 基础属性增加
	%% （属性ID，值）
	activateBaseAttr,
	%% 随机规则：0.使用pseudorandom字段的规则；1.在极品星级卓越库进行抽取，不去使用pseudorandom字段抽取。【程序需要筛选在库内已经被使用的卓越属性，被使用过的属性则不会在之后被继续使用，假如玩家在进化过程中将某一库中的属性都随机完毕，则玩家接下来的属性都只会在另外一个库中进行随机】（*绑定对应装备的随机规则）
	excellence1,
	%% 随机到星级库的概率
	%% 万分比
	pseudorandom,
	%% 无星级卓越属性库（权重值，星级标识，属性id，值）
	%% 星级标识：0.无 1.有
	outStand1,
	%% 低等星级卓越属性库（权重值，星级标识，属性id，值）
	%% 星级标识：0.无 1.有
	%% 当低等星级卓越属性库的数量不小于1，
	outStand2,
	%% 极品星级卓越属性库（权重值，星级标识，属性id，值）
	%% 星级标识：0.无 1.有
	outStand3
}).

-endif.
