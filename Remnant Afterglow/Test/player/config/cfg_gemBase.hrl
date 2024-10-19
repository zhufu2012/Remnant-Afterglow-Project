-ifndef(cfg_gemBase_hrl).
-define(cfg_gemBase_hrl, true).

-record(gemBaseCfg, {
	%% 宝石分类
	%% 1攻击
	%% 2防御
	%% 3生命元素宝石
	%% 4火元素宝石
	%% 5水元素宝石
	%% 6风元素宝石
	%% 7土元素宝石
	%% 8攻击核心
	%% 9防御核心
	%% 10.饰品宝石
	%% 11.饰品核心
	iD,
	%% 宝石等级分类
	%% 1.普通宝石
	%% 2.高级宝石
	level,
	%% 宝石品级
	number,
	%% 索引
	index,
	%% 宝石附带基础属性
	%% (属性id，数量)
	attribute,
	%% 高级宝石附带属性
	attributeAD,
	%% 宝石附带当前部位的宝石基础属性的万分比
	%% 针对当前部位已镶嵌的GemBase_1_宝石属性表中的Attribute字段
	%% *需要除开核心宝石
	partGemAttributeAdd,
	%% 宝石拆解消耗{道具id，数量}
	resolveConsume,
	%% 宝石拆解消耗{货币id，数量}
	resolveCost,
	%% 宝石拆解返还道具{道具id，数量}
	dismantling,
	%% 宝石拆解返还货币{货币id，数量}
	dismantling2,
	%% 单个宝石带来的评价值
	%% 圣甲相关宝石需要使用
	point,
	%% 额外属性
	%% ·用于增加固定战力，后端增加，前端在界面上不显示出来该属性。但属性的战力计算需要增加上。
	powerSupplement
}).

-endif.
