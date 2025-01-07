-ifndef(cfg_advancedOutStand_hrl).
-define(cfg_advancedOutStand_hrl, true).

-record(advancedOutStandCfg, {
	%% 阶数
	stage,
	%% 类型
	godAdornType,
	%% 进阶次数
	advancedTimes,
	%% Key
	index,
	%% 进阶获得有星属性后的品质
	%% 0白 1蓝 2紫 3橙 4红 5龙 6神  7、龙神
	%% 包装用
	advancedQuality,
	%% 进阶到下一阶的消耗
	%% （类型，ID，数量）
	%% 类型：1物品，ID为：道具ID
	%% 类型：2货币，ID为：货币ID
	advancedNeedItem,
	%% 当级的可进阶最大次数
	maxAdvanced,
	%% 基础属性
	%% （属性ID，值）
	advancedBaseAttr,
	%% 星级进化属性
	%% 必定是一条已获得的带星属性
	%% （星级标识，属性ID，值）
	outStand1,
	%% 非星级进化属性
	%% 三者任意随一种，最后把库随完
	%% （星级标识，属性ID，值）
	%% 如果库里的个数在之前被随机完，则不会获得新的，如果在最后一次随机还有剩余，则全部获得
	outStand2
}).

-endif.
