-ifndef(cfg_anyanEquipWash_hrl).
-define(cfg_anyanEquipWash_hrl, true).

-record(anyanEquipWashCfg, {
	%% 部位ID
	iD,
	%% 阶
	step,
	%% 索引
	index,
	%% 洗炼属性段权重
	%% 段1权重|段2权重|……
	partPro,
	%% 洗炼属性段1属性
	%% （属性id，下限，上限）
	%% 随机一个比例，所有属性值均按范围的该比例取值
	waskAttribute1,
	%% 洗炼属性段2属性
	%% （属性id，下限，上限）
	%% 随机一个比例，所有属性值均按范围的该比例取值
	waskAttribute2,
	%% 洗炼属性段3属性
	%% （属性id，下限，上限）
	%% 随机一个比例，所有属性值均按范围的该比例取值
	waskAttribute3,
	%% 每次洗炼消耗
	%% （类型，ID，值）
	%% 类型：1道具，2货币
	needExp
}).

-endif.
