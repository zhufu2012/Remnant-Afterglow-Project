-ifndef(cfg_elementStrengAdd_hrl).
-define(cfg_elementStrengAdd_hrl, true).

-record(elementStrengAddCfg, {
	%% 强化类型
	%% 1攻击
	%% 2防御
	%% 所有部位的元素强化都一样
	type,
	%% 追加等级
	addLevel,
	%% 索引
	index,
	%% 可追加条件：
	%% 对应部位、强化类型的突破等级
	%% 高等级兼容低等级
	breakLevelConditon,
	%% 最大追加等级
	maxAddLevel,
	%% 升下一级消耗
	%% （道具id，数量）
	consume,
	%% 追加等级属性
	%% (属性ID，属性值)
	%% 等级属性不叠加，前端处理当前提升的值
	attrAdd,
	%% 元素强化属性提升万分比
	%% 提升范围：对应部位和强化类型的强化和突破属性
	attrIncrease
}).

-endif.
