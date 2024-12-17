-ifndef(cfg_shengYiSkillSlotExt_hrl).
-define(cfg_shengYiSkillSlotExt_hrl, true).

-record(shengYiSkillSlotExtCfg, {
	%% 技能类型
	%% 1主动技能
	%% 2被动技能
	type,
	%% 槽位扩展顺序
	order,
	%% 索引
	index,
	%% 扩展消耗
	%% （消耗类型，id，数量）
	%% 类型1：道具-道具id，数量
	%% 类型2：道具-货币枚举，数量
	consume
}).

-endif.
