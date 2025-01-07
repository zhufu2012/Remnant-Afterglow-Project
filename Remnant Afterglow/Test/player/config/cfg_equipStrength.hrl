-ifndef(cfg_equipStrength_hrl).
-define(cfg_equipStrength_hrl, true).

-record(equipStrengthCfg, {
	%% 装备部位枚举
	iD,
	%% 强化总等级
	strengthLv,
	%% 索引
	index,
	%% 强化等级段位
	grade,
	%% 段位里强化小等级
	lv,
	%% 强化成功率万分比
	strRate,
	%% 到下一级消耗道具
	%% {道具id，数量}
	consumeItem,
	%% 到下一级消耗货币
	%% {货币id，数量}
	consumeCoin,
	%% 当前等级附带属性
	%% (属性id，数量)
	attribute,
	%% 强化突破奖励
	%% （这里填的是单级奖励）
	topAttribute,
	%% 强化大师当前等级附带属性
	%% (属性id，数量)
	attribute2,
	%% 强化大师等级，客户端显示用
	lvShow
}).

-endif.
