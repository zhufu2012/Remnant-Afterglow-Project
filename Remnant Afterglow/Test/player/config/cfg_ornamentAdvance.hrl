-ifndef(cfg_ornamentAdvance_hrl).
-define(cfg_ornamentAdvance_hrl, true).

-record(ornamentAdvanceCfg, {
	%% 将要被升阶佩饰的ID
	iD,
	%% 是否可以升阶，0不能升阶，1可以升阶
	isStrength,
	%% 升阶需要对应位置等级需求
	strengthLvNeed,
	%% 升阶到下阶配置需要的材料
	%% ｛类型，道具ID,道具数量｝
	%% 类型：1物品，ID为：道具ID
	%% 类型：2货币，ID为：货币ID
	needItem,
	%% 升阶到的佩饰ID
	ornamentAdvanceID
}).

-endif.
