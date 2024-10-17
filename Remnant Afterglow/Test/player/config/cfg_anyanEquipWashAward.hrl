-ifndef(cfg_anyanEquipWashAward_hrl).
-define(cfg_anyanEquipWashAward_hrl, true).

-record(anyanEquipWashAwardCfg, {
	%% 暗炎类型
	%% 1普通，部位1-6
	%% 2高级，部位7-12
	typeID,
	%% 等级
	level,
	%% 索引
	index,
	%% 等级上限
	levelLimit,
	%% 洗炼次数
	waskNum,
	%% 奖励属性
	%% （属性id，值）
	%% 奖励不叠加
	waskAwarkAttri
}).

-endif.
