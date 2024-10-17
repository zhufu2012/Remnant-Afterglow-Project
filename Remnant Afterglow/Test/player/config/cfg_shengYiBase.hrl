-ifndef(cfg_shengYiBase_hrl).
-define(cfg_shengYiBase_hrl, true).

-record(shengYiBaseCfg, {
	%% 圣翼ID
	%% 同圣翼道具id
	iD,
	%% 精炼经验
	refineExp,
	%% 圣翼基础属性
	%% (属性ID，属性值)
	attrBase,
	%% 圣翼幸运属性条数
	%% (幸运属性条数，权重）
	attrLuckyNum,
	%% 圣翼幸运属性
	%% (属性ID，属性值)
	%% 确定幸运属性条数后，在本字段内随机取属性，不重复
	attrLucky
}).

-endif.
