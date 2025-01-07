-ifndef(cfg_loveTokenLv_hrl).
-define(cfg_loveTokenLv_hrl, true).

-record(loveTokenLvCfg, {
	%% 作者:
	%% 信物ID
	iD,
	%% 作者:
	%% 等级
	level,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 最大等级
	levelMax,
	%% 作者:
	%% 消耗
	%% {道具ID，消耗数量}
	consume,
	%% 等级基础属性
	%% （属性ID，属性值）
	%% 【LoveTokenBase_1_信物基础表（洗炼）】表的PoteValue字段加成以下配置的所有属性
	attrBase,
	%% 等级高级属性
	%% （属性ID，属性值）
	attrBase2
}).

-endif.
