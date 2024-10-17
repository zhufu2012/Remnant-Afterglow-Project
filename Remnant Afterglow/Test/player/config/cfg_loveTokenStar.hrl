-ifndef(cfg_loveTokenStar_hrl).
-define(cfg_loveTokenStar_hrl, true).

-record(loveTokenStarCfg, {
	%% 作者:
	%% 信物ID
	iD,
	%% 作者:
	%% 星级
	star,
	%% 作者:
	%% 客户端索引
	index,
	%% 作者:
	%% 最大等级
	starMax,
	%% 作者:
	%% 升到下一星的消耗
	%% （道具ID，数量）
	upConsume,
	%% 作者:
	%% 提升信物基础属性百分比（填写万分点）
	attrIncrease,
	%% 星级基础属性
	%% （属性ID，属性值）0星时为激活属性
	%% 【LoveTokenBase_1_信物基础表（洗炼）】表的PoteValue字段加成以下配置的所有属性
	attrBase
}).

-endif.
