-ifndef(cfg_constellationAwaken_hrl).
-define(cfg_constellationAwaken_hrl, true).

-record(constellationAwakenCfg, {
	%% 星座ID
	iD,
	%% 部位
	%% 1战剑2战戒3战镯4战坠5战链6战盔7战甲8战腕9战腿10战靴
	position,
	%% 觉醒等级
	level,
	%% 索引
	index,
	%% 觉醒等级上限
	levelLimit,
	%% 觉醒条件
	%% (部位，觉醒等级)
	%% 前端显示条件为全部位觉醒等级达到，后期若有部分等级需求，再做功能修改
	condition,
	%% 觉醒消耗
	%% （道具id，数量）
	%% 填0表示已到最大等级
	consume,
	%% 觉醒等级属性
	%% (属性ID，属性值)
	%% 等级属性不叠加，前端处理当前提升的值
	attrAdd,
	%% 评价
	evaluate
}).

-endif.
