-ifndef(cfg_wingStarNewAttr_hrl).
-define(cfg_wingStarNewAttr_hrl, true).

-record(wingStarNewAttrCfg, {
	%% 品质
	iD,
	%% 星数
	star,
	%% 客户端索引
	index,
	%% 最大星数
	starMax,
	%% 本级需要碎片的数量
	%% 不累加
	%% 具体需要的道具ID去WingBaseNew表新增字段ConsumeStar取
	%% 整体道具分解碎片数量读取0星配置，海外版本，统一为45
	needItem,
	%% 升星提供固定属性
	attrAdd,
	%% 基础属性提升万分比
	attrIncrease
}).

-endif.
