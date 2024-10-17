-ifndef(cfg_mountStarAttrNew_hrl).
-define(cfg_mountStarAttrNew_hrl, true).

-record(mountStarAttrNewCfg, {
	%% 品质
	iD,
	%% 星数
	star,
	%% 客户端索引
	index,
	%% 最大星数
	starMax,
	%% 本级需要碎片数量
	%% 具体消耗ID去MountBaseNew表ConsumeStar取
	%% 整体道具分解碎片数量读取0级配置,海外版本，坐骑统一为45
	needItem,
	%% 升星提供固定属性
	attrAdd,
	%% 基础属性提升万分比
	attrIncrease,
	%% 坐骑速度
	speed
}).

-endif.
