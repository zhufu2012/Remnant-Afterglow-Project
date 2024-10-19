-ifndef(cfg_gemSet_hrl).
-define(cfg_gemSet_hrl, true).

-record(gemSetCfg, {
	%% 装备分类
	%% 1攻击
	%% 2防御
	%% 3饰品
	iD,
	%% 装备孔条目
	number,
	%% 索引
	index,
	%% 可镶嵌宝石类型
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
	gemType,
	%% 开启条件
	%% (条件类型|参数)
	%% 条件类型1：装备阶数
	%% 条件类型2：玩家VIP等级
	%% 该修改需要程序处理数据。必须通知程序
	open,
	%% 宝石附带属性
	%% (属性id，数量)
	attribute,
	%% 对应类型上弹出的获取途径宝石ID
	acquireGem
}).

-endif.
