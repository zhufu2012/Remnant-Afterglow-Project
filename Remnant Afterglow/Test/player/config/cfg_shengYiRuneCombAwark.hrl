-ifndef(cfg_shengYiRuneCombAwark_hrl).
-define(cfg_shengYiRuneCombAwark_hrl, true).

-record(shengYiRuneCombAwarkCfg, {
	%% 圣翼等级
	%% 同【ShengYiBaseUnlock_1_圣翼解锁】SyLevel
	syLevel,
	%% 组合编号
	combOrder,
	%% 索引
	index,
	%% 组合条件
	%% (品质，数量）
	%% 多个条件需同时达成
	%% 只算当前圣翼等级的
	combQuality,
	%% 奖励属性
	%% (属性ID，属性值)
	attrAward
}).

-endif.
