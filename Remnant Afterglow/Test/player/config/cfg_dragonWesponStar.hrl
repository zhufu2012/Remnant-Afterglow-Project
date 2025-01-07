-ifndef(cfg_dragonWesponStar_hrl).
-define(cfg_dragonWesponStar_hrl, true).

-record(dragonWesponStarCfg, {
	%% 和item表中的神像装备id一一对应
	iD,
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
	%% 升星提供的属性（属性ID，数值）-角色
	attribute,
	%% 天神武器基础属性，提升万分比
	%% 基础属性为：BaseAttribute【DragonWeapon_1_天神武器基础】
	attrIncrease1,
	%% 天神武器极品属性，提升万分比
	%% 额外属性为：OnlyAttribute【DragonWeapon_1_天神武器基础】
	attrIncrease2,
	%% 分解消耗货币
	%% （货币ID，数量）
	consumeCoin,
	%% 分解所得道具
	%% （道具ID，数量）
	consumeEquip
}).

-endif.
