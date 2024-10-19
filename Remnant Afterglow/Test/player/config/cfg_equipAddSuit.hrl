-ifndef(cfg_equipAddSuit_hrl).
-define(cfg_equipAddSuit_hrl, true).

-record(equipAddSuitCfg, {
	%% ID
	iD,
	%% 基础转换概率（万分比）
	baseChance,
	%% 至少需要的装备材料个数
	needEquipNum,
	%% 最多可以放置的装备个数
	needEquipNumMax,
	%% 可使用填充的装备类别
	%% 1.攻击类
	%% 2.防御类
	%% 3.饰品类
	%% (与Item表中ItemType=8时的EquipType字段匹配）
	limitEquipType,
	%% 可放入装备阶数
	rateCorrect,
	%% 套装成功的结果
	%% （权重，ID）
	finallyID
}).

-endif.
