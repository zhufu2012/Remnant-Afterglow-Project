-ifndef(cfg_dragonEquip_hrl).
-define(cfg_dragonEquip_hrl, true).

-record(dragonEquipCfg, {
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
	%% 索引
	index,
	%% 开启条件（条件类型，参数）
	%% 条件类型：1.等级  2.转职
	showLimit,
	%% 基础值（属性ID，数值）
	baseAttribute,
	%% 基础值评分ID
	basePoint,
	%% 额外属性
	%% （属性id，值，品质，评分ID）
	%% 品质0白1蓝2紫3橙4红5龙6神7神像
	onlyAttribute,
	%% 激活条件1
	%% 穿戴对应的神像武器装备
	%% 参数1：对应的神像ID 参数2:部位
	%% 没有填0 参数3：是否需要是祝福的神像武器   1是 0否
	needCondition1,
	%% 激活条件2
	%% 消耗对应的道具ID
	%% 参数1：道具ID，参数2：使用道具数量
	%% 没有填0
	needCondition2,
	%% 激活条件3
	%% 需要激活满上一个神像圣装
	%% 上一个神像的ID
	%% 没有填0
	needCondition3
}).

-endif.
