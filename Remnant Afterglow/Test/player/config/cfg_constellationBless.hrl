-ifndef(cfg_constellationBless_hrl).
-define(cfg_constellationBless_hrl, true).

-record(constellationBlessCfg, {
	%% 星座ID
	iD,
	%% 部位
	%% 1战剑2战戒3战镯4战坠5战链6战盔7战甲8战腕9战腿10战靴
	position,
	%% 祝福等级
	level,
	%% 索引
	index,
	%% 觉醒等级上限
	levelLimit,
	%% 祝福消耗
	%% （道具id，数量）
	%% 填0表示已到最大等级
	consume,
	%% 祝福等级属性
	%% (属性ID，属性值)
	%% 等级属性不叠加，前端处理当前提升的值
	attrAdd,
	%% 星魂装备基础属性提升万分比
	%% 包括强化属性
	baseIncrease,
	%% 评价
	evaluate
}).

-endif.
