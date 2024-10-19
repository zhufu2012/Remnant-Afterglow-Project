-ifndef(cfg_pantheonEquipStrength_hrl).
-define(cfg_pantheonEquipStrength_hrl, true).

-record(pantheonEquipStrengthCfg, {
	%% 装备部位类型
	%% 来源为item表的DetailedType字段中
	iD,
	%% 强化等级
	lv,
	%% 索引
	index,
	%% 能强化的最大等级
	maxLv,
	%% 强化获得的属性
	%% 对应强化等级
	strengthAttribute,
	%% 升级到下1级需要的经验值
	needExp
}).

-endif.
