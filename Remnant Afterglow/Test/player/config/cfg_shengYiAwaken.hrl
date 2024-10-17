-ifndef(cfg_shengYiAwaken_hrl).
-define(cfg_shengYiAwaken_hrl, true).

-record(shengYiAwakenCfg, {
	%% 圣翼等级分类
	syLevel,
	%% 觉醒等级
	awLevel,
	%% 索引
	index,
	%% 精炼等级上限
	maxLv,
	%% 升下一级消耗
	%% （道具id，数量）
	consume,
	%% 等级奖励属性
	%% (属性ID，属性值)
	attrAdd,
	%% 等级解锁属性
	%% (属性ID，属性值)
	attrUlock,
	%% 等级解锁技能
	%% （技能类型，技能id，技能槽位）
	%% 多选一
	skillUlock
}).

-endif.
