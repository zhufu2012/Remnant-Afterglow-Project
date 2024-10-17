-ifndef(cfg_dragonEquipStar_hrl).
-define(cfg_dragonEquipStar_hrl, true).

-record(dragonEquipStarCfg, {
	%% 神像ID
	iD,
	%% 部位
	%% 1.主手
	%% 2.副手
	%% 3.头盔
	%% 4.胸甲
	%% 5.手套
	%% 6.腰带
	%% 7.裤子
	%% 8.鞋子
	type,
	%% 星级
	star,
	%% 索引
	index,
	%% 最大星级
	starMax,
	%% 升星消耗
	%% 升至下一星的消耗
	%% (道具ID，数量)
	needItem,
	%% 升星提供的属性（属性ID，数值）
	attribute,
	%% 天神圣装基础属性，提升万分比
	%% 基础属性为：BaseAttribute【DragonEquip_1_天神圣装基础】
	attrIncrease1,
	%% 天神圣装额外属性，提升万分比
	%% 额外属性为：OnlyAttribute【DragonEquip_1_天神圣装基础】
	attrIncrease2
}).

-endif.
